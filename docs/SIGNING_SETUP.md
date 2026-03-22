# Android & iOS Signing Configuration for CI/CD

This guide explains how to set up secure signing for automated release builds.

## Android Signing

### 1. Generate Keystore (One-time setup)

```bash
keytool -genkey -v -keystore ~/copy_clip_release.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias copyclip_key
```

**Store this keystore securely** (Google Cloud Secret Manager, 1Password, or GitHub Secrets)

### 2. Encode Keystore for GitHub Secrets

```bash
# Base64 encode the keystore
base64 -i ~/copy_clip_release.keystore | pbcopy
```

### 3. Add GitHub Secrets

Go to **Settings > Secrets and variables > Actions** and add:

- `ANDROID_KEYSTORE_BASE64`: (base64-encoded keystore file)
- `ANDROID_KEYSTORE_PASSWORD`: (keystore password)
- `ANDROID_KEY_ALIAS`: `copyclip_key` (or your alias)
- `ANDROID_KEY_PASSWORD`: (key password)

### 4. Signing in CI

The release job in `.github/workflows/ci.yml` will use these secrets to sign APKs:

```yaml
- name: Decode keystore
  run: |
    echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 --decode > ~/copy_clip_release.keystore

- name: Build signed APK
  run: |
    flutter build apk --release \
      --dart-define=ANDROID_KEYSTORE_PATH=$HOME/copy_clip_release.keystore \
      --dart-define=ANDROID_KEYSTORE_PASSWORD=${{ secrets.ANDROID_KEYSTORE_PASSWORD }} \
      --dart-define=ANDROID_KEY_ALIAS=${{ secrets.ANDROID_KEY_ALIAS }} \
      --dart-define=ANDROID_KEY_PASSWORD=${{ secrets.ANDROID_KEY_PASSWORD }}
```

**Alternative (simpler):** Configure in `android/key.properties`:

```properties
storeFile=/path/to/copy_clip_release.keystore
storePassword=your_store_password
keyAlias=copyclip_key
keyPassword=your_key_password
```

Then add to `.gitignore`:
```
android/key.properties
```

And commit encrypted version or use GitHub Secrets with a setup script.

---

## iOS Signing

### 1. Generate Certificate & Provisioning Profile

- Use Xcode or Apple Developer portal
- Create App ID
- Create signing certificate
- Create provisioning profile
- Download and install

### 2. Export Certificates and create signing config

```bash
# Export certificate from Keychain
security export-ident-cert \
  -k ~/Library/Keychains/login.keychain-db \
  -t certs -f pemcms \
  -P EXPORT_PASSWORD \
  -o ~/ios_certificates.p12
```

### 3. Store in GitHub Secrets

Add to GitHub Secrets:
- `IOS_CERTIFICATE_P12`: (base64-encoded certificate)
- `IOS_CERTIFICATE_PASSWORD`: (certificate password)
- `IOS_PROVISIONING_PROFILE`: (base64-encoded .mobileprovision)
- `IOS_TEAM_ID`: (Apple Team ID)

### 4. Signing in CI (Fastlane)

Use [fastlane](https://fastlane.tools/) to automate iOS signing:

```bash
cd ios
fastlane init
# Follow prompts for match/provisioning setup
fastlane build_and_sign
```

---

## Fastlane Setup (Automated Store Deployment)

### 1. Install fastlane
```bash
sudo gem install fastlane -NV
fastlane init
```

### 2. Create `ios/fastlane/Fastfile`

```ruby
default_platform(:ios)

platform :ios do
  desc "Build and upload to TestFlight"
  lane :beta do
    setup_ci if is_ci
    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "Runner",
      configuration: "Release",
      derived_data_path: "build/ios/derived",
      export_method: "app-store",
      upload_bitcode: true,
      should_remove_build_dir: true
    )
    upload_to_testflight(
      skip_waiting_for_build_processing: true,
      apple_id: ENV["APPLE_ID"],
      team_id: ENV["IOS_TEAM_ID"]
    )
  end
end
```

### 3. Create `android/fastlane/Fastfile`

```ruby
default_platform(:android)

platform :android do
  desc "Build and upload to Play Store"
  lane :release do
    build_android_app(
      project_dir: ".",
      task: "bundleRelease",
      properties: {
        "android.injected.signing.store.file" => ENV["ANDROID_KEYSTORE_PATH"],
        "android.injected.signing.store.password" => ENV["ANDROID_KEYSTORE_PASSWORD"],
        "android.injected.signing.key.alias" => ENV["ANDROID_KEY_ALIAS"],
        "android.injected.signing.key.password" => ENV["ANDROID_KEY_PASSWORD"]
      }
    )
    upload_to_play_store(
      track: "internal",
      skip_upload_apk: true,
      skip_upload_metadata: true  # Requires manual metadata first
    )
  end
end
```

### 4. Add Fastlane to GitHub Workflow

```yaml
- name: Build and upload iOS
  run: |
    cd ios
    fastlane beta
  env:
    APPLE_ID: ${{ secrets.APPLE_ID }}
    IOS_TEAM_ID: ${{ secrets.IOS_TEAM_ID }}
    FASTLANE_USER: ${{ secrets.FASTLANE_USER }}
    FASTLANE_PASSWORD: ${{ secrets.FASTLANE_PASSWORD }}
```

---

## Checklist

- [ ] Generate Android keystore
- [ ] Add Android secrets to GitHub
- [ ] Test signed APK locally
- [ ] Generate iOS certificates
- [ ] Add iOS secrets to GitHub
- [ ] Install fastlane
- [ ] Create fastlane lanes
- [ ] Test fastlane locally
- [ ] Update CI workflow with signing steps
- [ ] Create release tag and test full CI run
