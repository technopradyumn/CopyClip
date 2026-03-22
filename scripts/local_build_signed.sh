#!/bin/bash
# local_build_signed.sh - Build signed APK/AAB locally for testing
# Run: ./scripts/local_build_signed.sh

set -e

echo "🔐 CopyClip Local Signing Build Script"
echo "======================================="

# Check if keystore exists
if [ ! -f ~/copy_clip_release.keystore ]; then
    echo "❌ Keystore not found at ~/copy_clip_release.keystore"
    echo ""
    echo "To generate, run:"
    echo "keytool -genkey -v -keystore ~/copy_clip_release.keystore \\"
    echo "  -keyalg RSA -keysize 2048 -validity 10000 \\"
    echo "  -alias copyclip_key"
    echo ""
    exit 1
fi

# Prompt for passwords
read -sp "Enter keystore password: " KEYSTORE_PASSWORD
echo
read -sp "Enter key password: " KEY_PASSWORD
echo

KEYSTORE_PATH="$HOME/copy_clip_release.keystore"
KEY_ALIAS="copyclip_key"

echo ""
echo "📱 Building signed APK..."
flutter build apk --release \
  --dart-define=KEYSTORE_PATH="$KEYSTORE_PATH" \
  --dart-define=KEYSTORE_PASSWORD="$KEYSTORE_PASSWORD" \
  --dart-define=KEY_ALIAS="$KEY_ALIAS" \
  --dart-define=KEY_PASSWORD="$KEY_PASSWORD"

echo ""
echo "📦 Building signed AAB (App Bundle)..."
flutter build appbundle --release \
  --dart-define=KEYSTORE_PATH="$KEYSTORE_PATH" \
  --dart-define=KEYSTORE_PASSWORD="$KEYSTORE_PASSWORD" \
  --dart-define=KEY_ALIAS="$KEY_ALIAS" \
  --dart-define=KEY_PASSWORD="$KEY_PASSWORD"

echo ""
echo "✅ Builds complete!"
echo "📍 APK: ./build/app/outputs/apk/release/app-release.apk"
echo "📍 AAB: ./build/app/outputs/bundle/release/app-release.aab"
echo ""
echo "Next steps:"
echo "  - Test APK on device: flutter install -d <device_id>"
echo "  - Upload AAB to Play Store internal testing"
