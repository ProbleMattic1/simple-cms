# Simple CMS Server Deployment Script
# This script helps deploy your CMS to a server with proper configuration

param(
    [Parameter(Mandatory=$true)]
    [string]$Domain,
    
    [Parameter(Mandatory=$false)]
    [string]$BuildDir = "public"
)

Write-Host "🚀 Starting Simple CMS Server Deployment..." -ForegroundColor Green

# Step 1: Update production config with your domain
Write-Host "📝 Updating production configuration..." -ForegroundColor Yellow
$configFile = "config.production.toml"
$configContent = Get-Content $configFile -Raw
$configContent = $configContent -replace "baseURL = 'https://your-actual-domain.com/'", "baseURL = 'https://$Domain/'"
$configContent = $configContent -replace "https://yourdomain.com", "https://$Domain"
Set-Content $configFile $configContent

# Step 2: Build the site for production
Write-Host "🔨 Building site for production..." -ForegroundColor Yellow
& hugo --config config.production.toml --minify --cleanDestinationDir

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}

# Step 3: Copy server-compatible admin page
Write-Host "📋 Setting up server-compatible admin page..." -ForegroundColor Yellow
Copy-Item "static/admin/index-server.html" "$BuildDir/admin/index.html" -Force

# Step 4: Ensure CSS file is in the right place
Write-Host "🎨 Ensuring CSS files are properly placed..." -ForegroundColor Yellow
if (Test-Path "static/admin/admin-styles.css") {
    Copy-Item "static/admin/admin-styles.css" "$BuildDir/admin/admin-styles.css" -Force
}

# Step 5: Create .htaccess for Apache servers (if needed)
Write-Host "⚙️ Creating server configuration files..." -ForegroundColor Yellow
$htaccessContent = @"
# Simple CMS .htaccess
RewriteEngine On

# Force HTTPS
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Remove trailing slashes
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{THE_REQUEST} \s/+([^?\s]*?)/+(\?[^\s]*)?\s
RewriteRule ^ /%1%2 [R=301,L]

# Cache static assets
<FilesMatch "\.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$">
    ExpiresActive On
    ExpiresDefault "access plus 1 year"
    Header set Cache-Control "public, immutable"
</FilesMatch>

# Security headers
Header always set X-Frame-Options "DENY"
Header always set X-Content-Type-Options "nosniff"
Header always set X-XSS-Protection "1; mode=block"
Header always set Referrer-Policy "strict-origin-when-cross-origin"

# Admin page security
<LocationMatch "^/admin/">
    Header always set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://unpkg.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data:; connect-src 'self'; frame-src 'none'; object-src 'none'; base-uri 'self'; form-action 'self';"
</LocationMatch>
"@

Set-Content "$BuildDir/.htaccess" $htaccessContent

# Step 6: Create deployment info file
Write-Host "📊 Creating deployment information..." -ForegroundColor Yellow
$deployInfo = @"
# Simple CMS Deployment Information
Deployment Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Domain: https://$Domain
Build Directory: $BuildDir
Hugo Version: $(hugo version)
"@

Set-Content "$BuildDir/DEPLOYMENT_INFO.txt" $deployInfo

# Step 7: Verify critical files
Write-Host "✅ Verifying deployment files..." -ForegroundColor Yellow
$criticalFiles = @(
    "$BuildDir/index.html",
    "$BuildDir/admin/index.html",
    "$BuildDir/admin/admin-styles.css",
    "$BuildDir/admin/config.yml"
)

foreach ($file in $criticalFiles) {
    if (Test-Path $file) {
        Write-Host "✓ $file" -ForegroundColor Green
    } else {
        Write-Host "✗ $file - MISSING!" -ForegroundColor Red
    }
}

Write-Host "🎉 Deployment preparation complete!" -ForegroundColor Green
Write-Host "📁 Your site is ready in the '$BuildDir' directory" -ForegroundColor Cyan
Write-Host "🌐 Upload the contents of '$BuildDir' to your server" -ForegroundColor Cyan
Write-Host "🔗 Your admin panel will be available at: https://$Domain/admin/" -ForegroundColor Cyan

# Step 8: Display next steps
Write-Host "`n📋 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Upload all files from '$BuildDir' to your web server" -ForegroundColor White
Write-Host "2. Ensure your server supports .htaccess (Apache) or configure equivalent rules" -ForegroundColor White
Write-Host "3. Set up SSL certificate for HTTPS" -ForegroundColor White
Write-Host "4. Configure your domain's DNS to point to your server" -ForegroundColor White
Write-Host "5. Test the admin panel at https://$Domain/admin/" -ForegroundColor White

Write-Host "`n🔧 Troubleshooting Tips:" -ForegroundColor Yellow
Write-Host "- If styles don't load, check that CSS files are accessible" -ForegroundColor White
Write-Host "- If admin doesn't work, verify the baseURL in config.production.toml" -ForegroundColor White
Write-Host "- Check server error logs for any issues" -ForegroundColor White
Write-Host "- Ensure your server supports the required file types (.html, .css, .js)" -ForegroundColor White
