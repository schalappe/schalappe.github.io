# CLAUDE.md

## Project Overview

Personal portfolio and blog website for Abdallah Hakim Kone, an AI engineer. Built with Hugo static site generator using the PaperMod theme. The site combines a custom portfolio homepage with a PaperMod-powered blog section.

## Commands

```bash
# Development server with drafts (http://localhost:1313)
hugo server -D

# Production build (outputs to public/)
hugo

# Create new blog post
hugo new blog/post-name.md
```

**Requires:** Hugo v0.146.0+

## Deployment

The site deploys automatically via GitHub Actions on push to `main` branch. See `.github/workflows/hugo.yml`.

## Architecture

### Two-Layout System

The site uses a dual-layout architecture:

1. **Custom Portfolio Layout** (`layouts/_default/home.html`)
   - Standalone HTML document (does NOT use baseof.html)
   - Renders homepage sections via partials in `layouts/partials/home/`
   - Data-driven from `data/schalappe.json`

2. **PaperMod Blog Layout** (`layouts/_default/baseof.html`)
   - Used by all non-home pages (blog posts, archives, tags)
   - Extends PaperMod theme with custom partials in `layouts/partials/blog/`

### Data Flow

Profile content is centralized in `data/schalappe.json`:

- Profile info, social links
- Skills (languages, tools) with Iconify icon IDs
- Work experience and education
- Featured projects

Templates access this data via `site.Data.schalappe`.

### Key Directories

```text
├── hugo.toml              # Site config, menu structure
├── data/schalappe.json    # All portfolio content
├── layouts/
│   ├── _default/
│   │   ├── home.html      # Portfolio homepage (standalone)
│   │   ├── baseof.html    # Blog base template
│   │   ├── single.html    # Blog post template
│   │   └── list.html      # Blog listing template
│   └── partials/
│       ├── home/          # Homepage sections (about, journey, skill, projects)
│       └── blog/          # PaperMod overrides
├── assets/
│   ├── css/main.css       # Portfolio styles
│   ├── css/blog_custom.css # Blog customizations
│   ├── js/main.js         # Interactive features (menu, tabs, carousel)
│   └── vendor/            # Swiper, FontAwesome, Iconify
├── content/blog/          # Blog posts (markdown)
├── static/                # Static files (favicon, CNAME)
└── themes/PaperMod/       # Theme (git submodule)
```

### Interactive Features (main.js)

- Mobile menu toggle
- Dark/light theme toggle (persisted to localStorage)
- Experience/Education tab switching
- Skills accordion expansion
- Swiper.js project carousel
- Scroll-based navigation highlighting
