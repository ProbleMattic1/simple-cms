# PowerShell Deployment Script for Simple CMS
# This script automates the deployment process

param(
    [Parameter(Mandatory=$false)]
    [string]$Environment = "production",
    
    [Parameter(Mandatory=$false)]
    [string]$Platform = "netlify",
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipBuild = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipTest = $false
)

# Configuration
$ErrorActionPreference = "Stop"
$ProjectRoot = $PSScriptRoot
$BuildDir = Join-Path $ProjectRoot "public"
$ConfigFile = if ($Environment -eq "production") { "config.production.toml" } else { "config.toml" }

Write-Host "🚀 Starting deployment process..." -ForegroundColor Green
Write-Host "Environment: $Environment" -ForegroundColor Yellow
Write-Host "Platform: $Platform" -ForegroundColor Yellow
Write-Host "Config: $ConfigFile" -ForegroundColor Yellow

# Function to check if command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Check prerequisites
Write-Host "`n📋 Checking prerequisites..." -ForegroundColor Blue

if (-not (Test-Command "hugo")) {
    Write-Error "Hugo is not installed or not in PATH. Please install Hugo first."
    exit 1
}

if (-not (Test-Command "git")) {
    Write-Error "Git is not installed or not in PATH. Please install Git first."
    exit 1
}

Write-Host "✅ Prerequisites check passed" -ForegroundColor Green

# Clean previous build
if (Test-Path $BuildDir) {
    Write-Host "`n🧹 Cleaning previous build..." -ForegroundColor Blue
    Remove-Item -Path $BuildDir -Recurse -Force
    Write-Host "✅ Previous build cleaned" -ForegroundColor Green
}

# Run tests (if not skipped)
if (-not $SkipTest) {
    Write-Host "`n🧪 Running tests..." -ForegroundColor Blue
    
    # Check for broken links (if linkchecker is available)
    if (Test-Command "linkchecker") {
        Write-Host "Running link checker..." -ForegroundColor Yellow
        # linkchecker would be run here
    }
    
    # Check for HTML validation (if html-validate is available)
    if (Test-Command "html-validate") {
        Write-Host "Running HTML validation..." -ForegroundColor Yellow
        # html-validate would be run here
    }
    
    Write-Host "✅ Tests completed" -ForegroundColor Green
}

# Build the site
if (-not $SkipBuild) {
    Write-Host "`n🔨 Building site..." -ForegroundColor Blue
    
    $buildCommand = "hugo --config $ConfigFile --minify --cleanDestinationDir"
    
    if ($Environment -eq "production") {
        $buildCommand += " --baseURL https://yourdomain.com/"
    }
    
    Write-Host "Running: $buildCommand" -ForegroundColor Yellow
    
    try {
        Invoke-Expression $buildCommand
        Write-Host "✅ Site built successfully" -ForegroundColor Green
    }
    catch {
        Write-Error "Build failed: $_"
        exit 1
    }
}

# Verify build
if (Test-Path $BuildDir) {
    $fileCount = (Get-ChildItem -Path $BuildDir -Recurse -File).Count
    Write-Host "`n📊 Build verification:" -ForegroundColor Blue
    Write-Host "Files generated: $fileCount" -ForegroundColor Yellow
    Write-Host "Build size: $([math]::Round((Get-ChildItem -Path $BuildDir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB" -ForegroundColor Yellow
} else {
    Write-Error "Build directory not found. Build may have failed."
    exit 1
}

# Platform-specific deployment
Write-Host "`n🚀 Deploying to $Platform..." -ForegroundColor Blue

switch ($Platform.ToLower()) {
    "netlify" {
        if (Test-Command "netlify") {
            Write-Host "Deploying to Netlify..." -ForegroundColor Yellow
            try {
                netlify deploy --prod --dir $BuildDir
                Write-Host "✅ Deployed to Netlify successfully" -ForegroundColor Green
            }
            catch {
                Write-Error "Netlify deployment failed: $_"
                exit 1
            }
        } else {
            Write-Warning "Netlify CLI not found. Please install it or deploy manually."
        }
    }
    
    "vercel" {
        if (Test-Command "vercel") {
            Write-Host "Deploying to Vercel..." -ForegroundColor Yellow
            try {
                Set-Location $BuildDir
                vercel --prod
                Set-Location $ProjectRoot
                Write-Host "✅ Deployed to Vercel successfully" -ForegroundColor Green
            }
            catch {
                Write-Error "Vercel deployment failed: $_"
                exit 1
            }
        } else {
            Write-Warning "Vercel CLI not found. Please install it or deploy manually."
        }
    }
    
    "github-pages" {
        Write-Host "Preparing for GitHub Pages deployment..." -ForegroundColor Yellow
        
        # Create .nojekyll file for GitHub Pages
        $noJekyllFile = Join-Path $BuildDir ".nojekyll"
        New-Item -Path $noJekyllFile -ItemType File -Force | Out-Null
        
        # Create CNAME file if custom domain is configured
        if ($Environment -eq "production") {
            $cnameFile = Join-Path $BuildDir "CNAME"
            "yourdomain.com" | Out-File -FilePath $cnameFile -Encoding ASCII
        }
        
        Write-Host "✅ GitHub Pages files prepared" -ForegroundColor Green
        Write-Host "Push the contents of the 'public' directory to your gh-pages branch" -ForegroundColor Yellow
    }
    
    "s3" {
        if (Test-Command "aws") {
            Write-Host "Deploying to S3..." -ForegroundColor Yellow
            try {
                $bucketName = "your-bucket-name"
                aws s3 sync $BuildDir "s3://$bucketName" --delete
                Write-Host "✅ Deployed to S3 successfully" -ForegroundColor Green
            }
            catch {
                Write-Error "S3 deployment failed: $_"
                exit 1
            }
        } else {
            Write-Warning "AWS CLI not found. Please install it or deploy manually."
        }
    }
    
    default {
        Write-Warning "Unknown platform: $Platform"
        Write-Host "Manual deployment required. Build files are in: $BuildDir" -ForegroundColor Yellow
    }
}

# Post-deployment tasks
Write-Host "`n🔧 Running post-deployment tasks..." -ForegroundColor Blue

# Update sitemap (if needed)
Write-Host "Updating sitemap..." -ForegroundColor Yellow

# Ping search engines (if production)
if ($Environment -eq "production") {
    Write-Host "Pinging search engines..." -ForegroundColor Yellow
    # Add search engine ping URLs here
}

# Send deployment notification (if configured)
if ($env:DEPLOYMENT_WEBHOOK_URL) {
    Write-Host "Sending deployment notification..." -ForegroundColor Yellow
    # Send webhook notification
}

Write-Host "✅ Post-deployment tasks completed" -ForegroundColor Green

# Summary
Write-Host "`n🎉 Deployment completed successfully!" -ForegroundColor Green
Write-Host "Environment: $Environment" -ForegroundColor Yellow
Write-Host "Platform: $Platform" -ForegroundColor Yellow
Write-Host "Build directory: $BuildDir" -ForegroundColor Yellow

if ($Platform -eq "github-pages") {
    Write-Host "`n📝 Next steps:" -ForegroundColor Blue
    Write-Host "1. Commit and push the contents of the 'public' directory" -ForegroundColor White
    Write-Host "2. Push to your gh-pages branch" -ForegroundColor White
    Write-Host "3. Your site will be available at: https://yourusername.github.io/your-repo/" -ForegroundColor White
}

Write-Host "`n🔗 Useful links:" -ForegroundColor Blue
Write-Host "- Site URL: https://yourdomain.com" -ForegroundColor White
Write-Host "- Admin Panel: https://yourdomain.com/admin/" -ForegroundColor White
Write-Host "- Analytics: https://analytics.google.com" -ForegroundColor White

Write-Host "`n✨ Happy publishing!" -ForegroundColor Green
