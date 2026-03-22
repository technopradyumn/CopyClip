# CopyClip CI/CD - Quick Start

## Your Repository
**https://github.com/technopradyumn/CopyClip**

---

## FINAL STEP: Add 4 GitHub Secrets

**Go to:** https://github.com/technopradyumn/CopyClip/settings/secrets/actions

**Copy & Paste These Secrets:**

| Step | Secret Name | Secret Value |
|------|---|---|
| 1 | `ANDROID_KEYSTORE_BASE64` | [Paste Base64 from GITHUB_SECRETS_TO_ADD.txt] |
| 2 | `ANDROID_KEYSTORE_PASSWORD` | `876503` |
| 3 | `ANDROID_KEY_ALIAS` | `copyclip_upload` |
| 4 | `ANDROID_KEY_PASSWORD` | `876503` |

---

## After Adding Secrets (Auto-Happens)

### What Happens
1. GitHub Actions **automatically starts**
2. Builds signed APK & AAB
3. Creates release with artifacts
4. Takes **5-10 minutes**

### Monitor Progress
**https://github.com/technopradyumn/CopyClip/actions**

### Download Artifacts
**https://github.com/technopradyumn/CopyClip/releases**
- Download: `app-release.aab`

### Upload to Play Store
1. Open Google Play Console
2. Select CopyClip app
3. Upload `app-release.aab`
4. Review & submit

---

## Current Build Info

| Component | Value |
|-----------|-------|
| Version Name | 1.4.3 |
| Version Code | 26 |
| Package | com.technopradyumn.copyclip |
| Tag | v1.4.2 |

---

## Files Created

```
.github/workflows/
  ├─ ci.yml              (Main CI/CD pipeline)
  ├─ coverage.yml        (Code coverage)
  └─ deploy-stores.yml  (Optional: App Store deployment)

docs/
  ├─ CI_CD_SETUP.md              (CI/CD overview)
  ├─ ENVIRONMENT_VARIABLES.md    (Env config guide)
  └─ SIGNING_SETUP.md           (Android signing guide)

scripts/
  ├─ setup_env.sh                (Environment setup)
  ├─ setup_github_secrets.sh     (GitHub secrets setup)
  ├─ local_build_signed.sh       (Local signed build)
  └─ add_github_secrets.ps1      (Windows: Add secrets)

Configuration Files:
  ├─ .env.example               (Dev template)
  ├─ .env.local                 (Your local config)
  └─ .env.production            (Production template)

Reference Files:
  ├─ SETUP_COMPLETE.md          (Setup summary)
  ├─ SECRETS_SETUP_GUIDE.md     (This guide)
  ├─ GITHUB_SECRETS_TO_ADD.txt  (All secret values)
  └─ ENV_QUICK_REFERENCE.txt    (Quick lookups)
```

---

## All Links

| Link | Purpose |
|------|---------|
| [Settings > Secrets](https://github.com/technopradyumn/CopyClip/settings/secrets/actions) | Add 4 secrets here |
| [GitHub Actions](https://github.com/technopradyumn/CopyClip/actions) | Monitor builds |
| [Releases](https://github.com/technopradyumn/CopyClip/releases) | Download APK/AAB |
| [Code](https://github.com/technopradyumn/CopyClip) | View source |

---

## Timeline

| Step | Time | Status |
|------|------|--------|
| Add 4 secrets | 5 min | **YOU ARE HERE** |
| Workflow runs | 5-10 min | Auto |
| Download AAB | 1 min | Manual |
| Upload to Play Store | 5 min | Manual |
| **TOTAL** | **~20 min** | **DONE!** |

---

## Next: Add Secrets Here

👉 **https://github.com/technopradyumn/CopyClip/settings/secrets/actions**

Click "New repository secret" 4 times and add:
1. ANDROID_KEYSTORE_BASE64
2. ANDROID_KEYSTORE_PASSWORD = 876503
3. ANDROID_KEY_ALIAS = copyclip_upload
4. ANDROID_KEY_PASSWORD = 876503

**Then watch the workflow build your signed APK/AAB!**

🚀 Ready to ship to Play Store!
