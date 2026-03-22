# CopyClip CI/CD Pipeline Documentation

## Overview

This project includes a **complete CI/CD pipeline** with automated testing, building, code coverage, and optional deployment to app stores.

### Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `ci.yml` | Push to main/master, PRs | Build, test, analyze, lint, L10n check |
| `coverage.yml` | Pull requests to main/master | Generate code coverage reports, upload to Codecov |
| `deploy-stores.yml` | Manual workflow dispatch | Deploy to Play Store / App Store (requires setup) |

---

## 1. CI Workflow (`ci.yml`)

### What it does

**On every push to `main` or `master`, or PR:**
- ✅ Checkout code
- ✅ Set up Flutter
- ✅ Restore cached dependencies
- ✅ Run `flutter pub get`
- ✅ Generate localizations with `flutter gen-l10n`
- ✅ **Enforce L10n consistency** (fails if source files changed)
- ✅ Run `flutter analyze` (static analysis)
- ✅ Run `flutter test --coverage`
- ✅ Build debug APK

**On version tags (`v*`, e.g., `v1.0.0`):**
- ✅ Build signed Android APK
- ✅ Build Android App Bundle (AAB)
- ✅ Build iOS release
- ✅ Upload artifacts (30-day retention)
- ✅ Create GitHub Release (draft)

### Running locally to replicate

```bash
# Test build step
flutter pub get
flutter gen-l10n
flutter analyze
flutter test --coverage
flutter build apk --debug

# Test release build (requires signing setup)
./scripts/local_build_signed.sh
```

---

## 2. Coverage Workflow (`coverage.yml`)

### What it does

**On every PR:**
- Runs `flutter test --coverage`
- Uploads LCOV coverage report to [Codecov](https://codecov.io)
- Provides PR comment with coverage changes

### Setup

1. Go to https://codecov.io and sign in with GitHub
2. Enable this repository
3. *No additional secrets needed* (Codecov picks up LCOV file automatically)

### Usage

- After PR, check Codecov comment for coverage ↔ 📊

---

## 3. Coverage Badge

Add this to your `README.md` for a live coverage badge:

```markdown
[![codecov](https://codecov.io/gh/YOUR_GITHUB_USERNAME/CopyClip/branch/main/graph/badge.svg)](https://codecov.io/gh/YOUR_GITHUB_USERNAME/CopyClip)
```

---

## 4. Android Signing Setup

### Prerequisites

1. Generate a keystore (one-time):
   ```bash
   keytool -genkey -v -keystore ~/copy_clip_release.keystore \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias copyclip_key
   ```

2. Encode and add to GitHub Secrets:
   ```bash
   base64 -i ~/copy_clip_release.keystore | pbcopy  # macOS
   # or on Windows/Linux: cat copy_clip_release.keystore | base64
   ```

3. **Go to Settings > Secrets and variables > Actions** and add:
   - `ANDROID_KEYSTORE_BASE64`: (paste base64 output)
   - `ANDROID_KEYSTORE_PASSWORD`: (your keystore password)
   - `ANDROID_KEY_ALIAS`: `copyclip_key`
   - `ANDROID_KEY_PASSWORD`: (your key password)

### Local Testing

```bash
chmod +x scripts/local_build_signed.sh
./scripts/local_build_signed.sh
```

---

## 5. Release Process

### Automated Release Build & GitHub Release

```bash
# On your local machine or after merging to main:
git tag v1.0.0
git push origin v1.0.0
```

**Then:**
1. GitHub Actions `release` job runs
2. Builds signed APK, AAB, iOS
3. Creates **draft** GitHub Release with artifacts
4. You review and publish from GitHub UI

### Files generated

```
build/app/outputs/
├── apk/release/app-release.apk
└── bundle/release/app-release.aab
build/ios/
└── iphoneos/Runner.app
```

---

## 6. Optional: Fastlane Deployment

### Setup (one-time)

```bash
# Install fastlane
sudo gem install fastlane -NV

# Configure for Android
cd android
fastlane init

# Configure for iOS
cd ../ios
fastlane init
```

### Deploy Stores Workflow

The `deploy-stores.yml` workflow is **disabled by default**.

To enable:
1. Set up Fastlane locally ✓
2. Create `Fastfile` with deployment lanes
3. Add secrets:
   - `PLAY_STORE_JSON_KEY` (Google Play Service account JSON)
   - `APPLE_ID`, `APPLE_ID_PASSWORD`
   - `FASTLANE_USER`, `FASTLANE_PASSWORD`
   - `MATCH_GITHUB_TOKEN` (for iOS cert/provisioning)
   - `SLACK_WEBHOOK_URL` (optional, for notifications)

4. Run manually:
   - Go to **Actions > Deploy to App Stores (Fastlane)**
   - Click **Run workflow**
   - Select track: `internal`, `alpha`, `beta`, or `production`

---

## 7. L10n Validation

The CI enforces **localization consistency**:

```bash
# Runs automatically in CI:
flutter gen-l10n

# If files changed, check them in:
git add lib/src/l10n/app_localizations*.dart lib/src/l10n/untranslated.json
git commit -m "chore: update l10n"
```

**Untranslated messages report:**
- Generated at: `lib/src/l10n/untranslated.json`
- Run locally: `flutter gen-l10n --untranslated-messages-file=lib/src/l10n/untranslated.json`

---

## 8. Monitoring & Debugging

### Viewing Logs

1. **GitHub Actions UI**: https://github.com/YOUR_USERNAME/CopyClip/actions
2. Click workflow run
3. Expand any failed step to see full output

### Troubleshooting

| Issue | Solution |
|-------|----------|
| `flutter gen-l10n` fails | Run locally: `flutter gen-l10n`, commit generated files |
| Build fails with keystore error | Add Android secrets (see Android Signing Setup) |
| Codecov not reporting | Make sure tests run with `--coverage` flag |
| L10n check fails but files look OK | Delete `lib/src/l10n/untranslated.json` and re-run |

---

## 9. PR Status Checks

The main CI workflow runs automatically on **every PR**:

- ✅ Must pass `build-test` (flutter build/test)
- ✅ Must pass `lint` (flutter format)

**Require these checks to merge** (GitHub repo settings):
1. Go to **Settings > Branches > Add rule**
2. Pattern: `main` (or `master`)
3. Under **Require status checks**: select `build-test` and `lint`

---

## 10. CI Status Badge

Add to your README:

```markdown
![CI Status](https://github.com/YOUR_USERNAME/CopyClip/workflows/Flutter%20CI/badge.svg)
```

---

## Summary

| Goal | How |
|------|-----|
| Auto-test on PR | ✅ Done (ci.yml) |
| Auto-build on merge | ✅ Done (ci.yml) |
| Code coverage tracking | ✅ Done (coverage.yml) |
| Release APK/AAB/iOS | ✅ Done (ci.yml + tag) |
| Store deployment | ✅ Optional (deploy-stores.yml) |
| L10n consistency | ✅ Enforced (ci.yml) |

---

**Questions?** See [SIGNING_SETUP.md](./SIGNING_SETUP.md) for detailed signing instructions.
