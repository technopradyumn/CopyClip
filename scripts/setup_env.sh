#!/bin/bash
# setup_env.sh - Interactive environment variable setup script
# Usage: ./scripts/setup_env.sh

set -e

echo "🔧 CopyClip Environment Setup"
echo "=============================="
echo ""

# Check if .env.local already exists
if [ -f .env.local ]; then
    echo "⚠️  .env.local already exists"
    read -p "Overwrite? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting..."
        exit 1
    fi
fi

# Copy template
cp .env.example .env.local
echo "✓ Created .env.local from .env.example"
echo ""

# Prompt for values
echo "📝 Enter environment values (or press Enter for defaults):"
echo ""

read -p "API Base URL (https://api-dev.example.com): " api_url
api_url=${api_url:-https://api-dev.example.com}
sed -i.bak "s|API_BASE_URL=.*|API_BASE_URL=$api_url|" .env.local && rm .env.local.bak

read -p "Flavor (dev/staging/production): " flavor
flavor=${flavor:-dev}
sed -i.bak "s/FLAVOR=.*/FLAVOR=$flavor/" .env.local && rm .env.local.bak

read -p "Enable Analytics (true/false): " analytics
analytics=${analytics:-false}
sed -i.bak "s/ENABLE_ANALYTICS=.*/ENABLE_ANALYTICS=$analytics/" .env.local && rm .env.local.bak

read -p "Android Package Name (com.example.copyclip.dev): " pkg_name
pkg_name=${pkg_name:-com.example.copyclip.dev}
sed -i.bak "s/ANDROID_PACKAGE_NAME=.*/ANDROID_PACKAGE_NAME=$pkg_name/" .env.local && rm .env.local.bak

read -p "iOS Bundle ID (com.example.copyclip.dev): " bundle_id
bundle_id=${bundle_id:-com.example.copyclip.dev}
sed -i.bak "s/IOS_BUNDLE_ID=.*/IOS_BUNDLE_ID=$bundle_id/" .env.local && rm .env.local.bak

echo ""
echo "✅ Environment setup complete!"
echo ""
echo "Your .env.local is ready. Configuration:"
echo "  API Base URL: $api_url"
echo "  Flavor: $flavor"
echo "  Analytics: $analytics"
echo "  Android Package: $pkg_name"
echo "  iOS Bundle ID: $bundle_id"
echo ""
echo "📌 Next steps:"
echo "  1. Add flutter_dotenv to pubspec.yaml (if not already added)"
echo "  2. Load .env file in main.dart using flutter_dotenv"
echo "  3. Run: flutter pub get && flutter run"
echo ""
echo "⚠️  For signing configuration, see docs/SIGNING_SETUP.md"
