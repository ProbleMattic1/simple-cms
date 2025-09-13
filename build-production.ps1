# Production Build Script for GitLab Pages
# This script creates a clean production build without development files

Write-Host "🚀 Building Simple CMS for GitLab Pages..." -ForegroundColor Green

# Step 1: Clean previous build
Write-Host "🧹 Cleaning previous build..." -ForegroundColor Yellow
if (Test-Path "public") {
    Remove-Item -Recurse -Force "public"
}

# Step 2: Build for production
Write-Host "🔨 Building site for production..." -ForegroundColor Yellow
if (Test-Path "hugo.exe") {
    & .\hugo.exe --config config.production.toml --minify --cleanDestinationDir --environment production
} else {
    & hugo --config config.production.toml --minify --cleanDestinationDir --environment production
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}

# Step 3: Remove development files
Write-Host "🗑️ Removing development files..." -ForegroundColor Yellow
$devFiles = @(
    "public/livereload.js*",
    "public/*.map",
    "public/.DS_Store"
)

foreach ($pattern in $devFiles) {
    Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue | Remove-Item -Force
}

# Step 4: Ensure admin files are in place
Write-Host "📋 Setting up admin files..." -ForegroundColor Yellow
if (Test-Path "static/admin/index-server.html") {
    Copy-Item "static/admin/index-server.html" "public/admin/index.html" -Force
}

if (Test-Path "static/admin/admin-styles.css") {
    Copy-Item "static/admin/admin-styles.css" "public/admin/admin-styles.css" -Force
}

# Step 5: Verify critical files exist
Write-Host "✅ Verifying build..." -ForegroundColor Yellow
$criticalFiles = @(
    "public/index.html",
    "public/admin/index.html",
    "public/admin/config.yml"
)

# Check for CSS file with hash
$cssFiles = Get-ChildItem -Path "public/ananke/css/" -Name "main.min.*.css"
if ($cssFiles) {
    Write-Host "✓ public/ananke/css/$($cssFiles[0])" -ForegroundColor Green
} else {
    Write-Host "✗ public/ananke/css/main.min.*.css - MISSING!" -ForegroundColor Red
    $allFilesExist = $false
}

$allFilesExist = $true
foreach ($file in $criticalFiles) {
    if (Test-Path $file) {
        Write-Host "✓ $file" -ForegroundColor Green
    } else {
        Write-Host "✗ $file - MISSING!" -ForegroundColor Red
        $allFilesExist = $false
    }
}

# Step 6: Check for development artifacts
Write-Host "🔍 Checking for development artifacts..." -ForegroundColor Yellow
$devArtifacts = Get-ChildItem -Path "public" -Recurse -Include "livereload.js*", "*.map" -ErrorAction SilentlyContinue
if ($devArtifacts) {
    Write-Host "⚠️ Found development artifacts:" -ForegroundColor Yellow
    $devArtifacts | ForEach-Object { Write-Host "  - $($_.FullName)" -ForegroundColor Yellow }
} else {
    Write-Host "✓ No development artifacts found" -ForegroundColor Green
}

# Step 7: Create deployment info
Write-Host "📊 Creating deployment information..." -ForegroundColor Yellow
$deployInfo = @"
# Simple CMS GitLab Pages Deployment
Build Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Base URL: https://getlocal-project-810af4.gitlab.io/simple/
Environment: Production
Hugo Version: $(if (Test-Path "hugo.exe") { & .\hugo.exe version } else { hugo version })
Build Command: hugo --config config.production.toml --minify --cleanDestinationDir --environment production

## Files Structure:
$(Get-ChildItem -Path "public" -Recurse | Select-Object FullName | ForEach-Object { $_.FullName.Replace((Get-Location).Path + "\public\", "") })
"@

Set-Content "public/DEPLOYMENT_INFO.txt" $deployInfo

if ($allFilesExist) {
    Write-Host "🎉 Production build completed successfully!" -ForegroundColor Green
    Write-Host "📁 Build directory: public/" -ForegroundColor Cyan
    Write-Host "🌐 GitLab Pages URL: https://getlocal-project-810af4.gitlab.io/simple/" -ForegroundColor Cyan
    Write-Host "🔗 Admin Panel: https://getlocal-project-810af4.gitlab.io/simple/admin/" -ForegroundColor Cyan
    
    Write-Host "`n📋 Next Steps:" -ForegroundColor Yellow
    Write-Host "1. Commit and push your changes to GitLab" -ForegroundColor White
    Write-Host "2. GitLab CI/CD will automatically deploy to Pages" -ForegroundColor White
    Write-Host "3. Wait for the pipeline to complete" -ForegroundColor White
    Write-Host "4. Visit your site at the GitLab Pages URL" -ForegroundColor White
} else {
    Write-Host "❌ Build verification failed!" -ForegroundColor Red
    Write-Host "Please check the missing files and try again." -ForegroundColor Red
    exit 1
}
