# Content Structure Guide

## Overview

Your Simple CMS now has a comprehensive content structure with multiple content types, custom templates, and reusable components.

## Content Organization

### 📁 Directory Structure

```
content/
├── _index.md              # Homepage content
├── about.md               # About page
├── posts/                 # Blog posts
│   ├── _index.md         # Posts section page
│   ├── welcome.md        # Sample post
│   └── theme-features.md # Theme showcase post
├── pages/                 # Static pages
│   ├── _index.md         # Pages section page
│   ├── services.md       # Services page
│   └── contact.md        # Contact page
├── projects/              # Project portfolio
│   ├── _index.md         # Projects section page
│   ├── ecommerce-cms.md  # Sample project
│   └── blog-platform.md  # Sample project
└── testimonials/          # Client testimonials
    ├── _index.md         # Testimonials section page
    ├── client-review-1.md # Sample testimonial
    └── client-review-2.md # Sample testimonial
```

## Content Types

### 1. **Posts** (`content/posts/`)
Blog posts and articles with the following front matter:

```yaml
---
title: "Post Title"
date: 2024-01-01T12:00:00Z
draft: false
tags: ["tag1", "tag2"]
featured_image: "/images/post-image.jpg"
description: "Post description for SEO"
---
```

**Features:**
- Automatic listing on homepage
- Tag support for categorization
- Featured images
- SEO descriptions
- Date-based organization

### 2. **Pages** (`content/pages/`)
Static pages with important information:

```yaml
---
title: "Page Title"
date: 2024-01-01T00:00:00Z
draft: false
featured_image: ""
description: "Page description for SEO"
---
```

**Features:**
- Static content pages
- Contact forms integration
- Service descriptions
- Company information

### 3. **Projects** (`content/projects/`)
Portfolio items and case studies:

```yaml
---
title: "Project Title"
date: 2024-01-15T10:00:00Z
draft: false
tags: ["project-type", "technology"]
featured_image: "/images/project-image.jpg"
description: "Project description and results"
---
```

**Features:**
- Custom project layouts
- Featured project showcase
- Tag-based filtering
- Detailed case studies
- Results and metrics

### 4. **Testimonials** (`content/testimonials/`)
Client reviews and feedback:

```yaml
---
title: "Client Review Title"
date: 2024-01-20T09:00:00Z
draft: false
tags: ["testimonial", "client-review"]
featured_image: ""
description: "Brief testimonial summary"
---
```

**Features:**
- Quote-style layouts
- Client information
- Review categorization
- Featured testimonials

## Custom Templates

### 🎨 **Project Templates**

**List Template** (`layouts/projects/list.html`):
- Grid layout for project showcase
- Project cards with images
- Tag display
- Hover effects

**Single Template** (`layouts/projects/single.html`):
- Detailed project view
- Featured image display
- Full content rendering
- Tag navigation

### 💬 **Testimonial Templates**

**List Template** (`layouts/testimonials/list.html`):
- Card-based layout
- Quote highlights
- Client information
- Read more links

**Single Template** (`layouts/testimonials/single.html`):
- Full testimonial view
- Enhanced typography
- Quote styling
- Related content

## Reusable Components

### 📝 **Partials** (`layouts/partials/`)

1. **Contact Form** (`contact-form.html`):
   - Responsive contact form
   - Form validation
   - Formspree integration
   - Custom styling

2. **Featured Projects** (`featured-projects.html`):
   - Homepage project showcase
   - Automatic project selection
   - Grid layout
   - Call-to-action buttons

3. **Recent Testimonials** (`recent-testimonials.html`):
   - Homepage testimonial display
   - Quote highlighting
   - Dark theme styling
   - Responsive design

## Content Creation Workflow

### 1. **Creating New Content**

```bash
# Create a new blog post
hugo new posts/my-new-post.md

# Create a new project
hugo new projects/my-new-project.md

# Create a new testimonial
hugo new testimonials/new-testimonial.md

# Create a new page
hugo new pages/new-page.md
```

### 2. **Content Guidelines**

**Posts:**
- Use descriptive titles
- Add relevant tags
- Include featured images
- Write compelling descriptions

**Projects:**
- Include project overview
- Highlight key features
- Show results and metrics
- Add relevant tags

**Testimonials:**
- Use client quotes in summary
- Include client details
- Add project context
- Use testimonial tags

### 3. **SEO Best Practices**

- **Descriptive Titles**: Clear, keyword-rich titles
- **Meta Descriptions**: Compelling descriptions for search results
- **Featured Images**: High-quality, relevant images
- **Tags**: Relevant tags for content organization
- **Internal Linking**: Link between related content

## Navigation Structure

### 🧭 **Menu Configuration**

The site automatically generates navigation based on content structure:

- **Home**: Main homepage
- **Posts**: Blog posts listing
- **Projects**: Portfolio showcase
- **About**: Company information
- **Contact**: Contact information and form

### 📱 **Responsive Design**

All templates are fully responsive:
- Mobile-first approach
- Flexible grid layouts
- Touch-friendly interfaces
- Optimized typography

## Performance Features

### ⚡ **Optimization**

- **Static Generation**: Fast loading times
- **Image Optimization**: Responsive images
- **CSS Minification**: Optimized stylesheets
- **Lazy Loading**: Images load as needed

### 🔍 **Search Functionality**

- **Built-in Search**: Client-side search
- **Content Indexing**: Automatic content indexing
- **Fast Results**: Instant search results
- **Tag Filtering**: Filter by content tags

## Next Steps

1. **Customize Content**: Update sample content with your information
2. **Add Images**: Upload and configure featured images
3. **Configure Forms**: Set up contact form integration
4. **Test Templates**: Verify all templates work correctly
5. **Continue to Section 5**: CMS Integration (Decap CMS)

## Troubleshooting

### Common Issues

1. **Content not showing**: Check front matter format
2. **Images not loading**: Verify image paths
3. **Templates not working**: Check template file locations
4. **Partials not rendering**: Verify partial syntax

### Getting Help

- Check Hugo documentation
- Review template examples
- Test with minimal content first
- Validate front matter syntax
