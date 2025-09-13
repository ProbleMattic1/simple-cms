# 🚀 Simple CMS Server Deployment Guide

This guide will help you deploy your Simple CMS to a web server and fix any styling issues.

## 🔧 Quick Fix for Styles Not Loading

### **Option 1: Use the Server-Compatible Admin Page**

1. **Replace your admin page** with the server-compatible version:
   ```bash
   # Copy the server-compatible admin page
   cp static/admin/index-server.html public/admin/index.html
   ```

2. **Ensure CSS file is in place**:
   ```bash
   # Copy the external CSS file
   cp static/admin/admin-styles.css public/admin/admin-styles.css
   ```

### **Option 2: Use the Deployment Script**

Run the deployment script with your domain:
```powershell
.\deploy-server.ps1 -Domain "yourdomain.com"
```

## 📋 Step-by-Step Deployment

### **1. Update Configuration**

Update your `config.production.toml` with your actual domain:
```toml
baseURL = 'https://yourdomain.com/'
```

### **2. Build for Production**

```bash
hugo --config config.production.toml --minify --cleanDestinationDir
```

### **3. Upload to Server**

Upload the entire contents of the `public` folder to your web server.

### **4. Server Configuration**

#### **For Apache Servers**

Create a `.htaccess` file in your root directory:
```apache
RewriteEngine On

# Force HTTPS
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

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
```

#### **For Nginx Servers**

Add to your nginx configuration:
```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name yourdomain.com www.yourdomain.com;
    
    root /path/to/your/public;
    index index.html;
    
    # Security headers
    add_header X-Frame-Options "DENY" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Cache static assets
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Admin panel
    location /admin/ {
        add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://unpkg.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data:; connect-src 'self'; frame-src 'none'; object-src 'none'; base-uri 'self'; form-action 'self';";
    }
}
```

## 🐛 Troubleshooting Common Issues

### **Styles Not Loading**

1. **Check file paths**: Ensure CSS files are accessible at `/admin/admin-styles.css`
2. **Check server configuration**: Verify your server serves CSS files with correct MIME type
3. **Check browser console**: Look for 404 errors or CORS issues
4. **Use absolute paths**: Make sure all paths are absolute (start with `/`)

### **Admin Panel Not Working**

1. **Check baseURL**: Ensure it matches your actual domain
2. **Check HTTPS**: Admin panel requires HTTPS for security
3. **Check file permissions**: Ensure all files are readable by the web server
4. **Check server logs**: Look for any error messages

### **Images Not Loading**

1. **Check image paths**: Ensure images are in the correct directory
2. **Check file permissions**: Images must be readable by the web server
3. **Check MIME types**: Server must serve images with correct content-type

## 🔍 Testing Your Deployment

### **1. Test Main Site**
- Visit `https://yourdomain.com`
- Check that all pages load correctly
- Verify navigation works

### **2. Test Admin Panel**
- Visit `https://yourdomain.com/admin/`
- Check that styles load correctly
- Test creating/editing content

### **3. Test Responsive Design**
- Test on mobile devices
- Check that admin panel works on different screen sizes

## 📱 Mobile Compatibility

The admin panel is fully responsive and works on:
- Desktop computers
- Tablets
- Mobile phones
- Different screen orientations

## 🔒 Security Considerations

1. **HTTPS Required**: Always use HTTPS for the admin panel
2. **Strong Passwords**: Use strong passwords for CMS authentication
3. **Regular Updates**: Keep your server and CMS updated
4. **Backup**: Regularly backup your content and configuration

## 🆘 Getting Help

If you're still having issues:

1. **Check server logs** for error messages
2. **Test locally** with `hugo server` to ensure everything works
3. **Verify file permissions** on your server
4. **Check browser console** for JavaScript errors
5. **Test with different browsers** to isolate issues

## 📞 Support

For additional help:
- Check the Hugo documentation
- Review Decap CMS documentation
- Check your hosting provider's documentation
- Test with a simple HTML file first to verify server configuration
