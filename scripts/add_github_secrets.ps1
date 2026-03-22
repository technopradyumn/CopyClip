# Add GitHub Secrets using GitHub CLI
# Prerequisites: GitHub CLI must be installed and authenticated
# Run: ./scripts/add_github_secrets.ps1

Write-Host "Adding GitHub Secrets for CopyClip CI/CD..." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# Check if gh CLI is installed
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "`nERROR: GitHub CLI not found!" -ForegroundColor Red
    Write-Host "Install from: https://cli.github.com/" -ForegroundColor Yellow
    exit 1
}

# Read keystore Base64 from file
$secretsFile = "GITHUB_SECRETS_TO_ADD.txt"
if (-not (Test-Path $secretsFile)) {
    Write-Host "`nERROR: $secretsFile not found!" -ForegroundColor Red
    exit 1
}

$content = Get-Content $secretsFile -Raw
$keystore_base64 = ($content -match 'SECRET_1_VALUE: (.+)$') ? ($matches[1]) : ""

if (-not $keystore_base64) {
    Write-Host "ERROR: Could not extract ANDROID_KEYSTORE_BASE64 from file" -ForegroundColor Red
    exit 1
}

Write-Host "`nSecret 1: Adding ANDROID_KEYSTORE_BASE64..." -ForegroundColor Green
gh secret set ANDROID_KEYSTORE_BASE64 -b $keystore_base64
Write-Host "✓ Added ANDROID_KEYSTORE_BASE64" -ForegroundColor Green

Write-Host "`nSecret 2: Adding ANDROID_KEYSTORE_PASSWORD..." -ForegroundColor Green
gh secret set ANDROID_KEYSTORE_PASSWORD -b "876503"
Write-Host "✓ Added ANDROID_KEYSTORE_PASSWORD" -ForegroundColor Green

Write-Host "`nSecret 3: Adding ANDROID_KEY_ALIAS..." -ForegroundColor Green
gh secret set ANDROID_KEY_ALIAS -b "copyclip_upload"
Write-Host "✓ Added ANDROID_KEY_ALIAS" -ForegroundColor Green

Write-Host "`nSecret 4: Adding ANDROID_KEY_PASSWORD..." -ForegroundColor Green
gh secret set ANDROID_KEY_PASSWORD -b "876503"
Write-Host "✓ Added ANDROID_KEY_PASSWORD" -ForegroundColor Green

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "All 4 Secrets Added Successfully!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "1. Check GitHub Actions: https://github.com/YOUR_USERNAME/copyclip/actions" -ForegroundColor Gray
Write-Host "2. Release workflow should start automatically" -ForegroundColor Gray
Write-Host "3. Download artifacts after 5-10 minutes" -ForegroundColor Gray
Write-Host "4. Upload AAB to Google Play Store" -ForegroundColor Gray

Write-Host "`nVerify Secrets:" -ForegroundColor Yellow
Write-Host "gh secret list" -ForegroundColor Gray
