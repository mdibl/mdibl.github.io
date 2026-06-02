# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static documentation/education website for the MDIBL Comparative Genomics and Data Science Core, built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/). Deployed to GitHub Pages via GitHub Actions on push to `main`.

## Commands

```bash
# Install dependencies
pip install mkdocs-material

# Local development server (live reload at http://127.0.0.1:8000)
mkdocs serve

# Deploy to GitHub Pages (CI does this automatically on push to main)
mkdocs gh-deploy --force
```

## Architecture

- **`mkdocs.yml`** — All site configuration: nav structure, theme settings, markdown extensions. The `nav` section is the authoritative table of contents; every page must be listed here.
- **`docs/`** — All content as Markdown files, organized by section/course directory.
- **`docs/stylesheets/extra.css`** — Brand color overrides: primary blue `#007299`, accent green `#799c4b`.
- **`.github/workflows/ci.yml`** — Builds and deploys on push to `main` using `mkdocs gh-deploy --force`.

## Content Conventions

**Adding pages**: Register every new page in `mkdocs.yml` under `nav`. Section landing pages must be named `index.md` and have no label in the nav (just the path); all other pages need a label.

```yaml
- My Section:
  - mysection/index.md          # no label for index
  - Page One: mysection/page1.md
```

**Course directories**: Each course lives entirely within its own subdirectory under `docs/`. Use relative paths for all images, PDFs, and cross-page links within a course — this enables clean migration to `courseArchives/` when a course ends.

**Markdown features**: The site uses Material extensions — admonitions, tabbed content, superfences, emoji, code copy buttons, and `attr_list`/`md_in_html` for HTML grid cards. Copy patterns from existing pages or see the [Material reference docs](https://squidfunk.github.io/mkdocs-material/reference/).
