# GitHub Secrets Setup - Step by Step Guide

## Your Repository
**URL:** https://github.com/technopradyumn/CopyClip

---

## Option A: Manual GitHub UI (Easiest - 5 minutes)

### Step 1: Go to GitHub Secrets Page
1. Visit: **https://github.com/technopradyumn/CopyClip/settings/secrets/actions**
2. You should see the "Secrets and variables" page

### Step 2: Add Secret 1 - ANDROID_KEYSTORE_BASE64

1. Click: **"New repository secret"** button
2. **Name:** `ANDROID_KEYSTORE_BASE64`
3. **Value:** Copy the long Base64 string below:

```
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
```

4. Click: **"Add secret"**

### Step 3: Add Secret 2 - ANDROID_KEYSTORE_PASSWORD

1. Click: **"New repository secret"** button
2. **Name:** `ANDROID_KEYSTORE_PASSWORD`
3. **Value:** `876503`
4. Click: **"Add secret"**

### Step 4: Add Secret 3 - ANDROID_KEY_ALIAS

1. Click: **"New repository secret"** button
2. **Name:** `ANDROID_KEY_ALIAS`
3. **Value:** `copyclip_upload`
4. Click: **"Add secret"**

### Step 5: Add Secret 4 - ANDROID_KEY_PASSWORD

1. Click: **"New repository secret"** button
2. **Name:** `ANDROID_KEY_PASSWORD`
3. **Value:** `876503`
4. Click: **"Add secret"**

---

## Option B: Automated with GitHub CLI (2 minutes)

### Prerequisites
1. Install GitHub CLI: https://cli.github.com/
2. Authenticate: `gh auth login`

### Run These Commands

```bash
gh secret set ANDROID_KEYSTORE_BASE64 -b "MIIK5gIBAzCCCpAGCSqGSIb3DQEHAaCCCoEEggp9..."
gh secret set ANDROID_KEYSTORE_PASSWORD -b "876503"
gh secret set ANDROID_KEY_ALIAS -b "copyclip_upload"
gh secret set ANDROID_KEY_PASSWORD -b "876503"
```

Or use the PowerShell script (if you have GitHub CLI installed):
```bash
.\scripts\add_github_secrets.ps1
```

---

## What Happens After Secrets Are Added

### 1. Workflow Starts Automatically (1 minute)
- Go to: https://github.com/technopradyumn/CopyClip/actions
- Should see `release` workflow running

### 2. Build Completes (5-10 minutes)
- Compiles app
- Runs tests
- Signs APK/AAB with your keystore
- Creates GitHub release

### 3. Download Artifacts
- Go to: https://github.com/technopradyumn/CopyClip/releases
- Find **v1.4.2** release
- Download `app-release.aab` (App Bundle for Play Store)

### 4. Upload to Google Play
1. Open Google Play Console
2. Select CopyClip app
3. Go to Production release
4. Upload `app-release.aab`
5. Review and submit

---

## Completing Setup Checklist

- [ ] Add Secret 1: ANDROID_KEYSTORE_BASE64 
- [ ] Add Secret 2: ANDROID_KEYSTORE_PASSWORD
- [ ] Add Secret 3: ANDROID_KEY_ALIAS
- [ ] Add Secret 4: ANDROID_KEY_PASSWORD
- [ ] Verify workflow runs at: https://github.com/technopradyumn/CopyClip/actions
- [ ] Download signed AAB from release
- [ ] Upload to Google Play Store

---

## Need Help?

### GitHub Secrets Page
https://github.com/technopradyumn/CopyClip/settings/secrets/actions

### GitHub Actions Status
https://github.com/technopradyumn/CopyClip/actions

### Releases Page
https://github.com/technopradyumn/CopyClip/releases

---

**Total Time to Complete:** ~20 minutes (5 min secrets + 10 min build + 5 min download)
