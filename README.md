# Simple CMS

A simple content management system built with Hugo and Decap CMS.

## Project Structure

```
simple-cms/
├── archetypes/          # Content templates
├── content/            # Site content (Markdown files)
│   ├── posts/         # Blog posts
│   ├── _index.md      # Homepage content
│   └── about.md       # About page
├── layouts/           # HTML templates
│   └── _default/      # Default templates
├── static/            # Static assets (CSS, JS, images)
├── themes/            # Hugo themes
├── config.toml        # Site configuration
└── README.md          # This file
```

## Getting Started

### 1. Install Hugo

Follow the instructions in `HUGO_INSTALLATION.md` to install Hugo on your system.

### 2. Run the Development Server

Once Hugo is installed, run:

```bash
hugo server
```

Your site will be available at `http://localhost:1313`

### 3. Create Content

Create new posts with:

```bash
hugo new posts/my-new-post.md
```

### 4. Build the Site

Generate the static site:

```bash
hugo
```

The built site will be in the `public/` directory.

## Features

- ✅ Basic Hugo site structure
- ✅ Responsive design
- ✅ Markdown content support
- ✅ Blog post functionality
- ⏳ CMS interface (Decap CMS) - Coming in Section 5
- ⏳ Theme customization - Coming in Section 3
- ⏳ Advanced features - Coming in Section 6

## Next Steps

1. Install Hugo following the instructions in `HUGO_INSTALLATION.md`
2. Test the site with `hugo server`
3. Continue with Section 2: Theme Selection and Configuration