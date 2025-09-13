# Complete Deployment Guide

## Overview

This guide covers everything you need to deploy your Simple CMS to production with security, performance, and monitoring configurations.

## 🚀 Quick Start

### Prerequisites
- Hugo installed and working
- Git repository set up
- Domain name (optional)
- Hosting account (Netlify, Vercel, etc.)

### 1. Prepare for Deployment
```bash
# Update configuration for production
cp config.toml config.production.toml

# Edit config.production.toml with your domain
# Update baseURL, analytics IDs, contact information

# Test the build
hugo --config config.production.toml --minify
```

### 2. Deploy to Netlify (Recommended)
```bash
# Install Netlify CLI
npm install -g netlify-cli

# Login to Netlify
netlify login

# Deploy
netlify deploy --prod --dir public
```

## 🔧 Platform-Specific Deployment

### Netlify Deployment

#### Automatic Deployment
1. **Connect Repository**:
   - Go to [Netlify](https://netlify.com)
   - Click "New site from Git"
   - Connect your GitHub/GitLab repository

2. **Configure Build Settings**:
   - Build command: `hugo --config config.production.toml --minify --cleanDestinationDir`
   - Publish directory: `public`
   - Hugo version: `0.150.0`

3. **Environment Variables**:
   ```
   HUGO_VERSION=0.150.0
   HUGO_ENV=production
   ```

4. **Deploy**: Netlify will automatically deploy on every push to main branch

#### Manual Deployment
```bash
# Build the site
hugo --config config.production.toml --minify

# Deploy to Netlify
netlify deploy --prod --dir public
```

### Vercel Deployment

#### Automatic Deployment
1. **Connect Repository**:
   - Go to [Vercel](https://vercel.com)
   - Import your GitHub repository
   - Configure build settings

2. **Build Configuration**:
   - Framework: Hugo
   - Build Command: `hugo --config config.production.toml --minify`
   - Output Directory: `public`

#### Manual Deployment
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
vercel --prod
```

### GitHub Pages Deployment

#### Using GitHub Actions
1. **Enable GitHub Pages**:
   - Go to repository Settings > Pages
   - Source: GitHub Actions

2. **Workflow Configuration**:
   - The `.github/workflows/deploy.yml` file is already configured
   - Push to main branch to trigger deployment

#### Manual Deployment
```bash
# Build the site
hugo --config config.production.toml --minify

# Create .nojekyll file
touch public/.nojekyll

# Push to gh-pages branch
cd public
git init
git add .
git commit -m "Deploy to GitHub Pages"
git push -f origin main:gh-pages
```

### AWS S3 + CloudFront Deployment

#### Setup
1. **Create S3 Bucket**:
   ```bash
   aws s3 mb s3://your-bucket-name
   aws s3 website s3://your-bucket-name --index-document index.html
   ```

2. **Deploy**:
   ```bash
   # Build the site
   hugo --config config.production.toml --minify
   
   # Sync to S3
   aws s3 sync public/ s3://your-bucket-name --delete
   ```

3. **Configure CloudFront**:
   - Create CloudFront distribution
   - Set S3 bucket as origin
   - Configure caching behaviors

## 🔒 Security Configuration

### Security Headers
The `static/_headers` file includes comprehensive security headers:

- **X-Frame-Options**: Prevents clickjacking
- **X-Content-Type-Options**: Prevents MIME sniffing
- **X-XSS-Protection**: XSS protection
- **Content-Security-Policy**: Prevents code injection
- **Strict-Transport-Security**: Enforces HTTPS
- **Referrer-Policy**: Controls referrer information

### HTTPS Configuration
- **Netlify**: Automatic HTTPS with Let's Encrypt
- **Vercel**: Automatic HTTPS
- **GitHub Pages**: Automatic HTTPS
- **AWS**: Use AWS Certificate Manager

### CMS Security
- **Authentication**: Configure Git Gateway (Netlify) or OAuth
- **Access Control**: Set up user roles and permissions
- **Content Validation**: Validate all CMS inputs
- **Backup Strategy**: Regular content backups

## 📊 Performance Optimization

### Build Optimization
```bash
# Production build with optimizations
hugo --config config.production.toml --minify --cleanDestinationDir --gc
```

### Image Optimization
- Use WebP format when possible
- Implement lazy loading
- Optimize image sizes
- Use responsive images

### Caching Strategy
- **Static Assets**: Cache for 1 year
- **HTML Pages**: Cache for 1 hour
- **API Endpoints**: No cache
- **Service Worker**: Offline caching

### CDN Configuration
- Enable CDN for all static assets
- Configure proper cache headers
- Use HTTP/2 and compression

## 📈 Monitoring and Analytics

### Google Analytics Setup
1. **Create GA4 Property**:
   - Go to [Google Analytics](https://analytics.google.com)
   - Create new property
   - Get Measurement ID

2. **Configure Tracking**:
   - Update `GA_MEASUREMENT_ID` in config
   - Add tracking code to templates
   - Set up conversion goals

### Performance Monitoring
- **Core Web Vitals**: Track LCP, FID, CLS
- **Page Speed**: Monitor loading times
- **Uptime**: Set up uptime monitoring
- **Error Tracking**: Monitor JavaScript errors

### Uptime Monitoring
- **UptimeRobot**: Free uptime monitoring
- **Pingdom**: Advanced monitoring
- **StatusCake**: Comprehensive monitoring

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow
The `.github/workflows/deploy.yml` file provides:

- **Automated Testing**: Link checking, HTML validation
- **Multi-Environment**: Staging and production deployments
- **Security Scanning**: Automated security checks
- **Performance Testing**: Lighthouse CI integration
- **Backup**: Automated backups

### Deployment Triggers
- **Main Branch**: Deploy to production
- **Develop Branch**: Deploy to staging
- **Pull Requests**: Run tests and preview
- **Manual**: Workflow dispatch

## 🛠️ Maintenance

### Regular Updates
```bash
# Update Hugo
hugo version
# Download latest version from GitHub releases

# Update dependencies
hugo mod get -u
hugo mod tidy

# Update theme
cd themes/ananke
git pull origin master
```

### Backup Strategy
1. **Code Backup**: Git repository (automatic)
2. **Content Backup**: Regular CMS exports
3. **Media Backup**: Cloud storage backup
4. **Configuration Backup**: Environment variables

### Monitoring Checklist
- [ ] Site uptime and performance
- [ ] Security headers and HTTPS
- [ ] Analytics and user behavior
- [ ] Error logs and exceptions
- [ ] Content freshness and SEO

## 🚨 Troubleshooting

### Common Issues

#### Build Failures
```bash
# Check Hugo version
hugo version

# Clean build
rm -rf public/
hugo --config config.production.toml --minify

# Check for errors
hugo --config config.production.toml --verbose
```

#### Deployment Issues
- **Netlify**: Check build logs in dashboard
- **Vercel**: Check function logs
- **GitHub Pages**: Check Actions logs
- **AWS**: Check CloudWatch logs

#### Performance Issues
- **Slow Loading**: Check image optimization
- **High Bounce Rate**: Check Core Web Vitals
- **SEO Issues**: Check meta tags and sitemap

### Debug Mode
```bash
# Enable debug mode
hugo --config config.production.toml --verbose --debug

# Check build statistics
hugo --config config.production.toml --templateMetrics
```

## 📋 Pre-Deployment Checklist

### Configuration
- [ ] Update `baseURL` in production config
- [ ] Set up analytics tracking IDs
- [ ] Configure contact form endpoints
- [ ] Update social media links
- [ ] Set up custom domain (if applicable)

### Security
- [ ] Enable HTTPS
- [ ] Configure security headers
- [ ] Set up authentication for CMS
- [ ] Test form submissions
- [ ] Verify privacy policy compliance

### Performance
- [ ] Optimize images
- [ ] Enable compression
- [ ] Configure caching
- [ ] Test Core Web Vitals
- [ ] Set up CDN

### Monitoring
- [ ] Configure analytics
- [ ] Set up error tracking
- [ ] Enable uptime monitoring
- [ ] Test performance monitoring
- [ ] Set up alerts

### Content
- [ ] Review all content
- [ ] Check for broken links
- [ ] Verify SEO meta tags
- [ ] Test CMS functionality
- [ ] Update sample content

## 🎉 Post-Deployment

### Verification
1. **Test All Features**:
   - Navigation and links
   - Contact forms
   - Search functionality
   - CMS interface
   - Social sharing

2. **Performance Check**:
   - Page speed test
   - Mobile responsiveness
   - Core Web Vitals
   - Accessibility

3. **SEO Verification**:
   - Meta tags
   - Sitemap
   - Robots.txt
   - Structured data

### Launch Activities
- [ ] Submit sitemap to search engines
- [ ] Set up Google Search Console
- [ ] Configure social media previews
- [ ] Send launch announcement
- [ ] Monitor initial traffic

## 📞 Support

### Resources
- **Hugo Documentation**: https://gohugo.io/documentation/
- **Decap CMS Docs**: https://decapcms.org/docs/
- **Netlify Docs**: https://docs.netlify.com/
- **Vercel Docs**: https://vercel.com/docs

### Community
- **Hugo Forum**: https://discourse.gohugo.io/
- **GitHub Issues**: Report bugs and feature requests
- **Stack Overflow**: Technical questions

---

Your Simple CMS is now ready for production deployment! Follow this guide to ensure a secure, fast, and reliable deployment.
