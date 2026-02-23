import os
import re
import time
import argparse
import urllib.parse
import requests
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm

# ── optional Selenium ──────────────────────────────────────────────────────────
try:
    from selenium import webdriver
    from selenium.webdriver.chrome.options import Options
    from selenium.webdriver.common.by import By
    from selenium.common.exceptions import (ElementClickInterceptedException,
                                             StaleElementReferenceException)
    SELENIUM_AVAILABLE = True
except ImportError:
    SELENIUM_AVAILABLE = False


# ══════════════════════════════════════════════════════════════════════════════
# URL helpers
# ══════════════════════════════════════════════════════════════════════════════

IMAGE_EXT_RE = re.compile(r'\.(jpe?g|png|webp|gif|bmp|tiff|svg)(\?.*)?$', re.I)
JUNK_RE      = re.compile(r'(icon|placeholder|avatar|pixel|1x1|blank|spacer|logo|sprite)', re.I)

HIGH_RES_ATTRS = [
    'data-original', 'data-highres', 'data-full-url', 'data-zoom-image',
    'data-hi-res',   'data-full-src', 'data-large-file', 'data-src-large',
    'data-big',      'data-image',    'data-zoom',  'data-original-src',
    'data-src',      'data-lazy-src', 'data-full',  'data-actual-src',
]


def strip_resize(url: str) -> str:
    """
    Remove CDN/CMS resize parameters to get the closest-to-original URL.
    Works for WordPress, Shopify, Cloudinary, imgix, Wix, Squarespace,
    DigitalOcean Spaces, Pinterest, Twitter/X, Reddit, etc.
    """
    if not url:
        return url
    u = url.strip()

    # Unsplash
    if "images.unsplash.com" in u:
        return u.split('?')[0]

    # Twitter/X → :orig
    if "twimg.com" in u:
        return re.sub(r'name=[^&]+', 'name=orig', u) if '?' in u else re.sub(r':\w+$', ':orig', u)

    # Pinterest → /originals/
    if "pinimg.com" in u:
        u = re.sub(r'/\d+x/', '/originals/', u)
        return u

    # Reddit preview → i.redd.it
    if "preview.redd.it" in u:
        return u.replace("preview.redd.it", "i.redd.it").split('?')[0]

    # Wikipedia thumb
    if "upload.wikimedia.org" in u and "/thumb/" in u:
        parts = u.split('/')
        if re.match(r'\d+px-', parts[-1]):
            u = u.replace('/thumb/', '/').rsplit('/', 1)[0]
        return u

    # Shopify
    if "cdn.shopify.com" in u:
        u = re.sub(
            r'_(small|medium|large|grande|master|compact|pico|icon|thumb|(\d+x\d+))'
            r'(?=\.(?:jpe?g|png|webp|gif))', '', u, flags=re.I)
        return u.split('?v=')[0]

    # Wix
    if "static.wixstatic.com" in u:
        return re.sub(r'/v1/fill/[^/]+/', '/', u)

    # Squarespace / imgix / Fastly → strip query
    if any(x in u for x in ["squarespace.com", "imgix.net", ".fastly."]):
        return u.split('?')[0]

    # Google user content (Photos, etc.)
    if "googleusercontent.com" in u:
        return re.sub(r'=[swh]\d+(-[swh]\d+)*$', '=s0', u)

    # Cloudinary – strip transform segment
    if "cloudinary.com" in u:
        u = re.sub(r'(/upload/)(?:[^/]+/)+', r'\1', u)
        return u

    # DigitalOcean Spaces / WordPress: remove -WIDTHxHEIGHT before extension
    # e.g.  image-12-150x150.jpeg → image-12.jpeg
    u = re.sub(r'-\d+x\d+(?=\.(jpe?g|png|webp|gif|bmp))', '', u, flags=re.I)

    # Generic thumbnail name suffixes
    u = re.sub(
        r'[-_](thumb|thumbnail|small|medium|large|sm|md|lg|xs|'
        r'preview|square|tile|crop|resized|scaled|compact|mini|tiny)'
        r'(?=\.(jpe?g|png|webp|gif|bmp))',
        '', u, flags=re.I)

    # Generic resize query params → strip entire query
    resize_params = ['w=', 'width=', 'h=', 'height=', 'fit=', 'crop=',
                     'size=', 'resize=', 'maxwidth=', 'maxheight=']
    if any(p in u.lower() for p in resize_params):
        u = u.split('?')[0]

    return u


def pick_srcset_best(srcset: str) -> str | None:
    """Return the URL for the highest width/density from a srcset string."""
    if not srcset:
        return None
    best_url, best_score = '', 0
    for part in srcset.split(','):
        tokens = part.strip().split()
        if not tokens:
            continue
        img_url = tokens[0]
        score   = 0
        if len(tokens) > 1:
            m = re.match(r'(\d+)([wx])', tokens[1])
            if m:
                score = int(m.group(1)) * (1000 if m.group(2) == 'x' else 1)
        if score > best_score:
            best_score, best_url = score, img_url
    return best_url or None


def candidates_for_img(img_tag, page_url: str) -> list[str]:
    """
    Return a prioritised list of candidate full-size URLs for one <img> element.

    Priority:
      1. parent <a href>  (direct image file link — the gold standard)
      2. data-* high-res attributes
      3. best from srcset
      4. strip -WxH from src
      5. src as-is
    """
    result: list[str] = []

    def add(u: str):
        if u:
            if u.startswith('//'):
                u = 'https:' + u
            u = urllib.parse.urljoin(page_url, u)
            if u.startswith('http') and not JUNK_RE.search(u):
                if u not in result:
                    result.append(u)

    # ── 1. Parent <a href> — HIGHEST PRIORITY ─────────────────────────────
    parent_a = img_tag.find_parent('a')
    if parent_a:
        href = parent_a.get('href', '').strip()
        if href and IMAGE_EXT_RE.search(href):
            add(href)   # no strip_resize — it's already the original!

    # ── 2. data-* high-res attributes ─────────────────────────────────────
    for attr in HIGH_RES_ATTRS:
        val = img_tag.get(attr, '').strip()
        if val and not val.startswith('data:'):
            add(strip_resize(val))

    # ── 3. Best from srcset ───────────────────────────────────────────────
    srcset = img_tag.get('srcset') or img_tag.get('data-srcset') or ''
    if srcset:
        best = pick_srcset_best(srcset)
        if best:
            add(strip_resize(best))

    # ── 4. Strip resize from src ──────────────────────────────────────────
    src = img_tag.get('src', '').strip()
    if src and not src.startswith('data:'):
        add(strip_resize(src))

    # ── 5. Original src as-is ─────────────────────────────────────────────
    if src and not src.startswith('data:'):
        add(src if '://' in src else urllib.parse.urljoin(page_url, src))

    return result


# ══════════════════════════════════════════════════════════════════════════════
# HTTP helpers
# ══════════════════════════════════════════════════════════════════════════════

def make_session(referer: str = '') -> requests.Session:
    s = requests.Session()
    s.headers.update({
        'User-Agent':      ('Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
                            'AppleWebKit/537.36 (KHTML, like Gecko) '
                            'Chrome/122.0.0.0 Safari/537.36'),
        'Accept':          'image/avif,image/webp,image/apng,image/*,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9',
        'Accept-Encoding': 'gzip, deflate, br',
    })
    if referer:
        s.headers['Referer'] = referer
    return s


def fetch_image(url: str, session: requests.Session, timeout: int = 20
                ) -> tuple[bytes, str] | None:
    """Download url, return (bytes, content_type) or None."""
    try:
        r = session.get(url, timeout=timeout, allow_redirects=True)
        if r.status_code != 200:
            return None
        ct = r.headers.get('Content-Type', '')
        if 'text/html' in ct or 'text/xml' in ct:
            return None
        return r.content, ct
    except Exception:
        return None


def unique_filename(folder: str, url: str, ct: str) -> str:
    path = urllib.parse.urlparse(url).path
    name = os.path.basename(path) or ''
    name = re.sub(r'[\\/:*?"<>|]', '_', name).strip('_')

    if not name or '.' not in name:
        ext  = ('.png' if 'png' in ct else '.webp' if 'webp' in ct
                else '.gif' if 'gif' in ct else '.jpg')
        name = f"img_{abs(hash(url)) % 9_999_999}{ext}"

    if len(name) > 120:
        base, ext = os.path.splitext(name)
        name = base[:110] + ext

    fp = os.path.join(folder, name)
    if os.path.exists(fp):
        base, ext = os.path.splitext(name)
        fp = os.path.join(folder, f"{base}_{abs(hash(url)) % 9999}{ext}")
    return fp


def download_best(candidates: list[str], session: requests.Session,
                  min_kb: int, folder: str) -> bool:
    """
    Try every candidate; save the one with the most bytes (= best quality).
    Returns True if an image was saved.
    """
    best_data: bytes | None = None
    best_url  = ''
    best_ct   = ''

    for url in candidates:
        if not url or not url.startswith('http'):
            continue
        result = fetch_image(url, session)
        if not result:
            continue
        data, ct = result
        if len(data) < min_kb * 1024:
            continue
        if best_data is None or len(data) > len(best_data):
            best_data, best_url, best_ct = data, url, ct

    if best_data:
        fp = unique_filename(folder, best_url, best_ct)
        with open(fp, 'wb') as f:
            f.write(best_data)
        return True
    return False


# ══════════════════════════════════════════════════════════════════════════════
# Static scrape  (fast, no browser needed)
# ══════════════════════════════════════════════════════════════════════════════

def scrape_static(page_url: str, session: requests.Session) -> list[list[str]]:
    """Return a list of candidate-groups from the page HTML."""
    try:
        r = session.get(page_url, timeout=20)
        r.raise_for_status()
    except Exception as e:
        print(f"  [!] Failed to fetch {page_url}: {e}")
        return []

    soup = BeautifulSoup(r.text, 'html.parser')
    groups: list[list[str]] = []
    seen_first: set[str]    = set()

    def add_group(cands: list[str]):
        clean = [u for u in cands if u and u.startswith('http') and not JUNK_RE.search(u)]
        if clean and clean[0] not in seen_first:
            seen_first.add(clean[0])
            groups.append(clean)

    # <picture> elements
    for pic in soup.find_all('picture'):
        cands: list[str] = []
        for src_el in pic.find_all('source'):
            ss = src_el.get('srcset') or src_el.get('data-srcset', '')
            if ss:
                best = pick_srcset_best(ss)
                if best:
                    cands.append(strip_resize(urllib.parse.urljoin(page_url, best)))
        img = pic.find('img')
        if img:
            cands += candidates_for_img(img, page_url)
        if cands:
            add_group(cands)

    # Standalone <img> tags
    for img in soup.find_all('img'):
        if img.find_parent('picture'):
            continue
        add_group(candidates_for_img(img, page_url))

    # Bare <a href="...image..."> links
    for a in soup.find_all('a', href=True):
        if a.find('img'):
            continue  # already handled via parent-a logic above
        href = a['href']
        if href.startswith('//'):
            href = 'https:' + href
        abs_href = urllib.parse.urljoin(page_url, href)
        if IMAGE_EXT_RE.search(abs_href) and not JUNK_RE.search(abs_href):
            add_group([abs_href])

    # Inline style background-image
    for tag in soup.find_all(style=re.compile(r'background-image', re.I)):
        m = re.search(r"url\(['\"]?(.*?)['\"]?\)", tag.get('style', ''))
        if m:
            bg = m.group(1)
            if bg.startswith('//'):
                bg = 'https:' + bg
            bg = urllib.parse.urljoin(page_url, bg)
            if not JUNK_RE.search(bg):
                add_group([strip_resize(bg)])

    # JSON/script embedded URLs
    for script in soup.find_all('script'):
        content = script.string or ''
        for m in re.findall(
                r'https?://[^\s\'"\\]+\.(?:jpe?g|png|webp|gif|bmp)(?:\?[^\s\'"\\]*)?',
                content, re.I):
            m = m.replace('\\/', '/').rstrip('\\')
            if not JUNK_RE.search(m):
                add_group([strip_resize(m)])

    return groups


# ══════════════════════════════════════════════════════════════════════════════
# Selenium browser scrape  (handles JS-rendered galleries)
# ══════════════════════════════════════════════════════════════════════════════

def _build_driver(headless: bool) -> 'webdriver.Chrome':
    opts = Options()
    if headless:
        opts.add_argument('--headless=new')
    opts.add_argument('--disable-gpu')
    opts.add_argument('--no-sandbox')
    opts.add_argument('--disable-dev-shm-usage')
    opts.add_argument('--window-size=1920,1080')
    opts.add_argument('--log-level=3')
    opts.add_experimental_option('excludeSwitches', ['enable-logging'])
    opts.add_argument(
        'user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
        'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36')
    return webdriver.Chrome(options=opts)


# JS to gather ALL image data from a rendered page in one shot
_COLLECT_JS = """
(function(){
  var HIGH = %s;
  var imgs = document.querySelectorAll('img');
  var out  = [];
  imgs.forEach(function(img){
    if (img.offsetWidth < 30 || img.offsetHeight < 30) return;
    var info = {
      src:        img.src        || '',
      currentSrc: img.currentSrc || '',
      srcset:     img.srcset || img.dataset.srcset || '',
      parentHref: '',
      attrs: {}
    };
    HIGH.forEach(function(a){ var v=img.getAttribute(a); if(v) info.attrs[a]=v; });
    var pa = img.closest('a');
    if (pa) info.parentHref = pa.href || '';
    out.push(info);
  });
  return out;
})();
""" % repr(HIGH_RES_ATTRS)


def scrape_selenium(page_url: str, headless: bool = True) -> list[list[str]]:
    """Return candidate-groups using a real Chrome browser."""
    if not SELENIUM_AVAILABLE:
        raise RuntimeError("Selenium not installed. Run: python -m pip install selenium")

    driver = _build_driver(headless)
    groups: list[list[str]] = []

    try:
        print(f"  [Browser] Loading {page_url} …")
        driver.get(page_url)

        # Scroll to bottom to trigger lazy loading, then back to top
        last_h = 0
        for _ in range(10):
            driver.execute_script("window.scrollBy(0, window.innerHeight * 1.5);")
            time.sleep(0.5)
            new_h = driver.execute_script("return document.body.scrollHeight")
            if new_h == last_h:
                break
            last_h = new_h
        driver.execute_script("window.scrollTo(0, 0);")
        time.sleep(0.8)

        img_infos = driver.execute_script(_COLLECT_JS)
        print(f"  [Browser] {len(img_infos)} visible images found.")

        seen_first: set[str] = set()

        for info in img_infos:
            cands: list[str] = []

            # 1. Parent <a href> = original image file (HIGHEST PRIORITY)
            href = info.get('parentHref', '').strip()
            if href and IMAGE_EXT_RE.search(href) and not JUNK_RE.search(href):
                cands.append(href)   # already absolute, already original — no strip needed

            # 2. data-* attrs
            for attr, val in info.get('attrs', {}).items():
                if val and val.startswith('http'):
                    cands.append(strip_resize(val))

            # 3. currentSrc (browser picks best from srcset)
            cs = info.get('currentSrc', '').strip()
            if cs and cs.startswith('http'):
                cands.append(strip_resize(cs))

            # 4. srcset best
            ss = info.get('srcset', '')
            if ss:
                best = pick_srcset_best(ss)
                if best and best.startswith('http'):
                    cands.append(strip_resize(best))

            # 5. src stripped
            src = info.get('src', '').strip()
            if src and src.startswith('http'):
                cands.append(strip_resize(src))

            # Deduplicate preserving order
            seen_u: set[str] = set()
            deduped = []
            for u in cands:
                if u and u.startswith('http') and not JUNK_RE.search(u) and u not in seen_u:
                    seen_u.add(u)
                    deduped.append(u)

            if deduped and deduped[0] not in seen_first:
                seen_first.add(deduped[0])
                groups.append(deduped)

    finally:
        driver.quit()

    return groups


# ══════════════════════════════════════════════════════════════════════════════
# Main orchestration
# ══════════════════════════════════════════════════════════════════════════════

def scrape_images(page_url: str, output_dir: str,
                  min_size_kb: int = 50,
                  use_browser: bool = True,
                  headless: bool    = True):

    os.makedirs(output_dir, exist_ok=True)
    session = make_session(referer=page_url)

    # ── Collect candidate groups ───────────────────────────────────────────
    if use_browser and SELENIUM_AVAILABLE:
        print("[1/2] Browser mode — using Chrome to get full-size image URLs …")
        try:
            groups = scrape_selenium(page_url, headless=headless)
        except Exception as e:
            print(f"  [!] Browser failed ({e}), falling back to static scrape.")
            groups = scrape_static(page_url, session)
        if not groups:
            print("  [!] Browser returned nothing, falling back to static scrape.")
            groups = scrape_static(page_url, session)
    else:
        if use_browser and not SELENIUM_AVAILABLE:
            print("[!] Selenium not installed — using static mode.")
            print("    Install: python -m pip install selenium")
        print("[1/2] Static mode — extracting image URLs from HTML …")
        groups = scrape_static(page_url, session)

    print(f"\n[2/2] Downloading {len(groups)} images "
          f"(largest-quality wins, min {min_size_kb} KB) …")

    success = 0
    for g in tqdm(groups, desc="Downloading"):
        if download_best(g, session, min_size_kb, output_dir):
            success += 1

    print(f"\n✅  Done. {success}/{len(groups)} full-size images saved → '{output_dir}'")


# ══════════════════════════════════════════════════════════════════════════════
# CLI
# ══════════════════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Full-Size Image Downloader — no blur, no cropping",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # satsaheb.org or any WordPress gallery — works WITHOUT a browser:
  python image_downloader.py --url "https://www.satsaheb.org/dowry-free-marriages-english-2/" --no-browser

  # General gallery (uses Chrome to handle JS-rendered pages):
  python image_downloader.py --url "https://example.com/gallery"

  # Show Chrome window (useful if headless is blocked):
  python image_downloader.py --url "https://example.com" --show-browser

  # Custom output folder + skip anything smaller than 200 KB:
  python image_downloader.py --url "https://example.com" --output myfolder --min-size 200
        """)
    parser.add_argument("--url",          required=True,
                        help="URL of the gallery / image page to download from")
    parser.add_argument("--output",       default="downloads",
                        help="Folder to save images (default: downloads)")
    parser.add_argument("--min-size",     type=int, default=50,
                        help="Minimum file size in KB to keep (default: 50)")
    parser.add_argument("--no-browser",   action="store_true",
                        help="Skip Chrome; use fast static HTML scrape only. "
                             "Sufficient for satsaheb.org and similar WordPress sites.")
    parser.add_argument("--show-browser", action="store_true",
                        help="Show Chrome window instead of running headless")
    args = parser.parse_args()

    scrape_images(
        page_url    = args.url,
        output_dir  = args.output,
        min_size_kb = args.min_size,
        use_browser = not args.no_browser,
        headless    = not args.show_browser,
    )
