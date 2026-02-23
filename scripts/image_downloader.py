import os
import requests
from bs4 import BeautifulSoup
import urllib.parse
from concurrent.futures import ThreadPoolExecutor
from tqdm import tqdm
import argparse
import re

def get_original_url(img_url, srcset=None):
    """
    Attempts to find the original high-resolution URL from an image URL or srcset.
    """
    # 1. Handle srcset (find the largest resolution)
    if srcset:
        parts = srcset.split(',')
        candidates = []
        for part in parts:
            part = part.strip()
            if not part: continue
            # Match URL and optional descriptor (e.g., 1080w or 2x)
            match = re.search(r'(\S+)\s+(\d+)([wx])', part)
            if match:
                url, val, unit = match.groups()
                candidates.append((url, int(val)))
            else:
                # Handle cases without descriptor
                candidates.append((part.split()[0], 0))
        
        if candidates:
            # Sort by value (width or density) descending
            candidates.sort(key=lambda x: x[1], reverse=True)
            img_url = candidates[0][0]

    # 2. Specific fixes for common CDNs/Platforms
    # Unsplash: Remove query params for original quality
    if "images.unsplash.com" in img_url:
        img_url = img_url.split('?')[0]

    # WordPress: Remove scaling/resizing suffixes
    img_url = re.sub(r'-\d+x\d+(?=\.\w+$)', '', img_url)
    img_url = re.sub(r'(-scaled|_thumb|_small)$', '', img_url)

    # 3. Strip common query param resizing (generic)
    img_url = re.sub(r'\?.*$', '', img_url)
    
    return img_url

def download_image(url, folder, session):
    try:
        response = session.get(url, stream=True, timeout=10)
        if response.status_code == 200:
            # Extract filename from URL
            filename = os.path.basename(urllib.parse.urlparse(url).path)
            if not filename:
                filename = f"image_{hash(url)}.jpg"
            
            filepath = os.path.join(folder, filename)
            
            # Ensure path is unique
            if os.path.exists(filepath):
                base, ext = os.path.splitext(filename)
                filepath = os.path.join(folder, f"{base}_{hash(url)}{ext}")

            with open(filepath, 'wb') as f:
                for chunk in response.iter_content(1024):
                    f.write(chunk)
            return True
    except Exception as e:
        # print(f"Error downloading {url}: {e}")
        pass
    return False

def scrape_images(url, output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    session = requests.Session()
    session.headers.update({
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    })

    print(f"Scraping {url}...")
    try:
        response = session.get(url, timeout=15)
        response.raise_for_status()
    except Exception as e:
        print(f"Failed to fetch {url}: {e}")
        return

    soup = BeautifulSoup(response.text, 'html.parser')
    img_tags = soup.find_all('img')
    
    image_urls = set()
    for img in img_tags:
        # Check various attributes for high-res sources
        src = img.get('src')
        srcset = img.get('srcset')
        data_src = img.get('data-src') or img.get('data-original') or img.get('data-highres') or img.get('data-lazy-src')
        
        target_url = data_src or src
        if target_url:
            # Clean target_url (sometimes it has leading //)
            if target_url.startswith('//'):
                target_url = 'https:' + target_url
            
            absolute_url = urllib.parse.urljoin(url, target_url)
            original_url = get_original_url(absolute_url, srcset)
            
            # Additional validation
            if original_url.startswith('http'):
                image_urls.add(original_url)

    print(f"Found {len(image_urls)} unique image candidates.")
    if image_urls:
        print("Sample URLs found:")
        for u in list(image_urls)[:3]:
            print(f" - {u}")
    
    with ThreadPoolExecutor(max_workers=10) as executor:
        list(tqdm(executor.map(lambda u: download_image(u, output_dir, session), image_urls), total=len(image_urls), desc="Downloading"))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Bulk Image Downloader (Original Quality)")
    parser.add_argument("--url", required=True, help="URL to scrape images from")
    parser.add_argument("--output", default="downloads", help="Output directory (default: downloads)")
    
    args = parser.parse_args()
    scrape_images(args.url, args.output)
