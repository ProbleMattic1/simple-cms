# Ananke Theme Setup Guide

## ✅ Theme Installation Complete

The Ananke theme has been successfully installed and configured for your Simple CMS project.

## What's Been Configured

### 1. Theme Installation
- ✅ Downloaded and installed Ananke theme
- ✅ Updated `config.toml` to use the theme
- ✅ Removed custom layouts (using theme's layouts)

### 2. Theme Configuration
- ✅ Enabled recent posts on homepage
- ✅ Configured social media follow links (GitHub, LinkedIn, Twitter)
- ✅ Configured social sharing (Email, Facebook, LinkedIn, Twitter)
- ✅ Updated content structure to match theme requirements

### 3. Content Updates
- ✅ Updated archetype template
- ✅ Updated existing posts with theme-compatible front matter
- ✅ Added descriptions and featured image fields

## Theme Features

### Built-in Features
- **Responsive Design**: Works on all devices
- **Search Functionality**: Built-in search capability
- **Social Media Integration**: Follow and share buttons
- **Recent Posts**: Shows recent posts on homepage
- **Tag Support**: Organize content with tags
- **Featured Images**: Support for post featured images
- **SEO Optimized**: Built-in SEO features

### Customization Options

#### Colors and Styling
The theme uses CSS custom properties for easy customization. You can override styles by creating:
```
static/css/custom.css
```

#### Social Media Links
Update your social media profiles in `config.toml`:
```toml
[params]
  github = "your-github-username"
  linkedin = "your-linkedin-username"
  twitter = "your-twitter-username"
```

#### Menu Configuration
The theme automatically creates menus from your content structure. You can customize the main menu in `config.toml`:
```toml
[menu]
  [[menu.main]]
    name = "Home"
    url = "/"
    weight = 10
```

## Testing Your Theme

Once Hugo is installed, test the theme by running:

```bash
# Start development server
hugo server

# Create a new post
hugo new posts/my-new-post.md

# Build the site
hugo
```

## Theme Documentation

- **Official Documentation**: https://github.com/theNewDynamic/gohugo-theme-ananke
- **Demo Site**: https://themes.gohugo.io/themes/gohugo-theme-ananke/
- **Configuration Reference**: See `themes/ananke/config/_default/params.toml`

## Next Steps

1. **Install Hugo** (if not already done)
2. **Test the theme** with `hugo server`
3. **Customize colors and styling** (optional)
4. **Add your social media profiles**
5. **Continue to Section 4**: Content Structure and Templates

## Troubleshooting

### Common Issues

1. **Theme not loading**: Make sure `theme = "ananke"` is set in `config.toml`
2. **Missing styles**: Ensure the theme is properly installed in `themes/ananke/`
3. **Content not showing**: Check that your content has the correct front matter format

### Getting Help

- Check the theme's GitHub repository for issues
- Review the theme documentation
- Test with a minimal configuration first
