# Environment Variables Guide

## 1. GitHub Secrets (Required for CI/CD)

### Android Signing Secrets

These secrets are required to build signed Android APKs and App Bundles.

**Where to add:** GitHub Repository > Settings > Secrets and variables > Actions > New repository secret

| Secret Name | Value | How to Generate |
|------------|-------|-----------------|
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded `.keystore` file | See section 2 below |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password | Set during keystore creation |
| `ANDROID_KEY_ALIAS` | Key alias | Usually `copyclip_key` |
| `ANDROID_KEY_PASSWORD` | Key password | Set during keystore creation |

**Example:**
```bash
# Generate keystore (one-time)
keytool -genkey -v -keystore ~/copy_clip_release.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias copyclip_key

# Encode to base64
base64 -i ~/copy_clip_release.keystore | pbcopy  # macOS
# or: cat ~/copy_clip_release.keystore | base64  # Linux

# Paste into GitHub Secret: ANDROID_KEYSTORE_BASE64
```

---

### Android Play Store Deployment (Optional)

Required only if using `deploy-stores.yml` workflow for automatic Play Store uploads.

| Secret Name | Value | How to Get |
|------------|-------|-----------|
| `PLAY_STORE_JSON_KEY` | Google Play Service Account JSON | [Google Play Console](https://play.google.com/console) |

**Steps:**
1. Go to Google Play Console > Settings > API access
2. Create Service Account
3. Download JSON key file
4. Base64 encode the JSON:
   ```bash
   base64 -i ~/Downloads/google-play-key.json | pbcopy
   ```
5. Add to GitHub Secrets

---

### iOS/TestFlight Deployment (Optional)

Required only if using `deploy-stores.yml` workflow for automatic TestFlight/App Store uploads.

| Secret Name | Value | How to Get |
|------------|-------|-----------|
| `APPLE_ID` | Apple Developer account email | Your Apple account |
| `APPLE_ID_PASSWORD` | App-specific password | [Apple ID Security](https://appleid.apple.com) |
| `APPLE_TEAM_ID` | Apple Team ID | Apple Developer Program |
| `FASTLANE_USER` | Apple Developer email | Same as APPLE_ID |
| `FASTLANE_PASSWORD` | App-specific password | Same as APPLE_ID_PASSWORD |
| `MATCH_GITHUB_TOKEN` | GitHub Personal Access Token | [GitHub Settings > Tokens](https://github.com/settings/tokens) |

**Steps (Apple ID Password):**
1. Go to https://appleid.apple.com/account/security
2. Generate App-specific password
3. Use that for `APPLE_ID_PASSWORD`

**Steps (MATCH_GITHUB_TOKEN):**
1. Go to https://github.com/settings/tokens
2. Create token with `repo` scope
3. Paste into GitHub Secrets

---

### Notifications (Optional)

For Slack notifications on deployment status:

| Secret Name | Value | How to Get |
|------------|-------|-----------|
| `SLACK_WEBHOOK_URL` | Slack Incoming Webhook URL | [Slack API](https://api.slack.com/apps) |

**Steps:**
1. Create Slack App or use existing
2. Enable Incoming Webhooks
3. Create webhook for channel
4. Copy webhook URL to GitHub Secrets

---

## 2. Local Environment File (`.env`)

### Create `.env.example` (Commit to repo)

```bash
# Local Development Environment Variables
# Copy this file to .env and fill in actual values

# Flutter Build Configuration
FLAVOR=dev
BUILD_MODE=debug

# Feature Flags
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
ENABLE_PERFORMANCE_MONITORING=true

# Android Configuration
ANDROID_PACKAGE_NAME=com.technopradyumn.copyclip
ANDROID_VERSION_CODE=1
ANDROID_VERSION_NAME=0.1.0

# iOS Configuration
IOS_BUNDLE_ID=com.technopradyumn.copyclip
IOS_VERSION=0.1.0
IOS_BUILD_NUMBER=1

# Signing (Local Development)
# Keystore path for local signed builds
# KEYSTORE_PATH=/path/to/copy_clip_release.keystore
# KEYSTORE_PASSWORD=your_keystore_password
# KEY_ALIAS=copyclip_key
# KEY_PASSWORD=your_key_password
```

### Create `.env.local` (Gitignored - local only)

Add to `.gitignore` first:
```bash
echo ".env.local" >> .gitignore
```

Then create `.env.local`:
```bash
# Local Development Environment Variables (NEVER commit)
# Copy from .env.example and fill in actual values

FLAVOR=dev
BUILD_MODE=debug

ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false
ENABLE_PERFORMANCE_MONITORING=false

ANDROID_PACKAGE_NAME=com.technopradyumn.copyclip
ANDROID_VERSION_CODE=1
ANDROID_VERSION_NAME=0.1.0-dev

IOS_BUNDLE_ID=com.technopradyumn.copyclip
IOS_VERSION=0.1.0
IOS_BUILD_NUMBER=1

# For local signed builds (development)
KEYSTORE_PATH=~/copy_clip_release.keystore
KEYSTORE_PASSWORD=your_keystore_password
KEY_ALIAS=copyclip_key
KEY_PASSWORD=your_key_password
```

### Create `.env.production` (For Fastlane deployment)

```bash
# Production Environment Variables (Fastlane)
# Use only for production releases

FLAVOR=production
BUILD_MODE=release

ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
ENABLE_PERFORMANCE_MONITORING=true

ANDROID_PACKAGE_NAME=com.technopradyumn.copyclip
ANDROID_VERSION_CODE=100
ANDROID_VERSION_NAME=1.0.0

IOS_BUNDLE_ID=com.technopradyumn.copyclip
IOS_VERSION=1.0.0
IOS_BUILD_NUMBER=100

# Signing (Production)
KEYSTORE_PATH=$HOME/copy_clip_release.keystore
KEYSTORE_PASSWORD=$ANDROID_KEYSTORE_PASSWORD
KEY_ALIAS=$ANDROID_KEY_ALIAS
KEY_PASSWORD=$ANDROID_KEY_PASSWORD
```

---

## 3. Loading `.env` in Flutter

### Using `flutter_dotenv` package

**Step 1:** Add to `pubspec.yaml`
```yaml
dependencies:
  flutter_dotenv: ^5.0.0
```

**Step 2:** Add asset in `pubspec.yaml`
```yaml
flutter:
  assets:
    - .env
    - .env.local
    - .env.production
```

**Step 3:** Load in `main.dart`
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Load .env file
  String env = const String.fromEnvironment('ENV', defaultValue: 'dev');
  String envFile = env == 'production' ? '.env.production' : '.env.local';
  
  await dotenv.load(fileName: envFile);
  
  runApp(const MyApp());
}

// Access variables anywhere
String apiUrl = dotenv.env['API_BASE_URL']!;
bool analyticsEnabled = dotenv.env['ENABLE_ANALYTICS'] == 'true';
```

**Step 4:** Run with environment
```bash
# dev (default)
flutter run

# local
flutter run --dart-define=ENV=dev

# production
flutter run --dart-define=ENV=production
```

---

## 4. GitHub Secrets Quick Checklist

Copy and paste this checklist to verify all secrets are added:

```markdown
## ✅ GitHub Secrets Checklist

### Android Signing (Required for CI/CD)
- [ ] ANDROID_KEYSTORE_BASE64
- [ ] ANDROID_KEYSTORE_PASSWORD
- [ ] ANDROID_KEY_ALIAS
- [ ] ANDROID_KEY_PASSWORD

### Play Store Deployment (Optional)
- [ ] PLAY_STORE_JSON_KEY

### iOS/TestFlight Deployment (Optional)
- [ ] APPLE_ID
- [ ] APPLE_ID_PASSWORD
- [ ] APPLE_TEAM_ID
- [ ] FASTLANE_USER
- [ ] FASTLANE_PASSWORD
- [ ] MATCH_GITHUB_TOKEN

### Notifications (Optional)
- [ ] SLACK_WEBHOOK_URL
```

**Add secrets:**
```bash
# Example: Add ANDROID_KEYSTORE_BASE64 via GitHub CLI
gh secret set ANDROID_KEYSTORE_BASE64 < android_keystore_base64.txt

# Or via GitHub UI:
# Settings > Secrets and variables > Actions > New repository secret
```

---

## 5. Loading Secrets in Workflows

### In `.github/workflows/ci.yml`

```yaml
env:
  ANDROID_KEYSTORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
  ANDROID_KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}
  ANDROID_KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
```

### In `.github/workflows/deploy-stores.yml`

```yaml
- name: Deploy Android
  env:
    PLAY_STORE_JSON_KEY: ${{ secrets.PLAY_STORE_JSON_KEY }}
    ANDROID_KEYSTORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
```

---

## 6. Environment Variables in Dart Code

### Define a config class

```dart
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._internal();

  late String flavor;
  late bool enableAnalytics;
  late bool enableCrashReporting;

  static Future<void> init() async {
    await dotenv.load(fileName: _getEnvFile());
    
    final config = AppConfig._instance;
    config.flavor = dotenv.env['FLAVOR'] ?? 'dev';
    config.enableAnalytics = dotenv.env['ENABLE_ANALYTICS'] == 'true';
    config.enableCrashReporting = dotenv.env['ENABLE_CRASH_REPORTING'] == 'true';
  }

  static String _getEnvFile() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    if (env == 'production') {
      return '.env.production';
    }
    return '.env.local';
  }
}

// Usage in main.dart
void main() async {
  await AppConfig.init();
  runApp(const MyApp());
}

// Access anywhere
print(AppConfig().flavor);
```

---

## 7. Local Build with Signing

### Build signed APK locally

**Interactive version:**
```bash
chmod +x scripts/local_build_signed.sh
./scripts/local_build_signed.sh
```

**Manual version:**
```bash
flutter build apk --release \
  --dart-define=KEYSTORE_PATH=$HOME/copy_clip_release.keystore \
  --dart-define=KEYSTORE_PASSWORD=your_password \
  --dart-define=KEY_ALIAS=copyclip_key \
  --dart-define=KEY_PASSWORD=your_key_password
```

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| `Secret not found` | Verify secret name exactly matches in workflow |
| `.env` file not loading | Check `pubspec.yaml` assets section includes `.env*` files |
| `KEYSTORE_PATH` not recognized | Ensure it's passed with `--dart-define` flag |
| Secrets visible in logs | Never print `${{ secrets.* }}` directly; use masked vars |
| Local build works but CI fails | Check GitHub Secret encoding (base64) |

---

## Summary

| Environment | Files | Purpose |
|-----------|-------|---------|
| **Local Dev** | `.env.local` | Personal dev setup (gitignored) |
| **Production** | `.env.production` | Fastlane deployment config |
| **Example** | `.env.example` | Template (committed to repo) |
| **GitHub** | Secrets (UI/CLI) | CI/CD secure values |

**Next:** Commit `.env.example`, create `.env.local`, add GitHub Secrets, run `flutter gen-l10n`, then test!
