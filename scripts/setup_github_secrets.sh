#!/bin/bash
# setup_github_secrets.sh - Helper script to add GitHub Secrets
# Usage: ./scripts/setup_github_secrets.sh
# Requires: GitHub CLI (gh) to be installed and authenticated

set -e

echo "🔐 GitHub Secrets Setup Helper"
echo "==============================="
echo ""
echo "This script helps you add secrets to GitHub for CI/CD automation."
echo "Requires: GitHub CLI installed (https://cli.github.com/)"
echo ""

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI not found. Install from: https://cli.github.com/"
    exit 1
fi

# Verify gh is authenticated
if ! gh auth status > /dev/null 2>&1; then
    echo "❌ Not authenticated with GitHub. Run: gh auth login"
    exit 1
fi

echo "✓ GitHub CLI authenticated"
echo ""

# Function to add secret
add_secret() {
    local secret_name=$1
    local prompt=$2
    
    echo "📝 $secret_name"
    echo "   $prompt"
    
    read -p "   Enter value (or 'skip' to skip): " secret_value
    
    if [ "$secret_value" != "skip" ] && [ -n "$secret_value" ]; then
        echo -n "$secret_value" | gh secret set "$secret_name"
        echo "   ✓ Secret added"
    else
        echo "   ⊘ Skipped"
    fi
    echo ""
}

# Android Signing Secrets
echo "=== ANDROID SIGNING (Required for Release Builds) ==="
echo ""

# ANDROID_KEYSTORE_BASE64
echo "🔑 ANDROID_KEYSTORE_BASE64"
echo "   Base64-encoded Android keystore file"
read -p "   Enter keystore file path (or 'skip'): " keystore_path

if [ "$keystore_path" != "skip" ] && [ -n "$keystore_path" ]; then
    if [ -f "$keystore_path" ]; then
        # Encode and set secret
        encoded=$(base64 < "$keystore_path")
        echo -n "$encoded" | gh secret set "ANDROID_KEYSTORE_BASE64"
        echo "   ✓ Secret added from $keystore_path"
    else
        echo "   ❌ File not found: $keystore_path"
    fi
else
    echo "   ⊘ Skipped - will need to add manually:"
    echo "   base64 -i ~/copy_clip_release.keystore | gh secret set ANDROID_KEYSTORE_BASE64"
fi
echo ""

add_secret "ANDROID_KEYSTORE_PASSWORD" "Your keystore password"
add_secret "ANDROID_KEY_ALIAS" "Key alias (default: copyclip_key)"
add_secret "ANDROID_KEY_PASSWORD" "Your key password"

echo ""
echo "=== PLAY STORE DEPLOYMENT (Optional) ==="
echo ""

read -p "Setup Play Store deployment? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    add_secret "PLAY_STORE_JSON_KEY" "Google Play Service Account JSON key (base64-encoded or raw)"
else
    echo "⊘ Skipped Play Store setup"
fi

echo ""
echo "=== iOS/TESTFLIGHT DEPLOYMENT (Optional) ==="
echo ""

read -p "Setup iOS/TestFlight deployment? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    add_secret "APPLE_ID" "Your Apple Developer account email"
    add_secret "APPLE_ID_PASSWORD" "Apple app-specific password (not your main password)"
    add_secret "APPLE_TEAM_ID" "Your Apple Team ID"
    add_secret "FASTLANE_USER" "Fastlane user (same as APPLE_ID)"
    add_secret "FASTLANE_PASSWORD" "Fastlane password (same as APPLE_ID_PASSWORD)"
    add_secret "MATCH_GITHUB_TOKEN" "GitHub Personal Access Token (with 'repo' scope)"
else
    echo "⊘ Skipped iOS setup"
fi

echo ""
echo "=== NOTIFICATIONS (Optional) ==="
echo ""

read -p "Setup Slack notifications? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    add_secret "SLACK_WEBHOOK_URL" "Slack Incoming Webhook URL"
else
    echo "⊘ Skipped Slack setup"
fi

echo ""
echo "✅ GitHub Secrets setup complete!"
echo ""
echo "📊 View secrets: gh secret list"
echo "🔒 Delete secret: gh secret delete SECRET_NAME"
echo ""
echo "📌 Next steps:"
echo "  1. Commit .env.example: git add .env.example && git commit"
echo "  2. Create local .env: cp .env.example .env.local"
echo "  3. Fill in .env.local with your local values"
echo "  4. Test CI: Push to main or create a PR"
