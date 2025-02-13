# mdibl.github.io

[![Website Build Status](https://github.com/mdibl/mdibl.github.io/actions/workflows/ci.yml/badge.svg)](https://github.com/mdibl/mdibl.github.io/actions/workflows/ci.yml)

[![Built with Material for MkDocs](https://img.shields.io/badge/Material_for_MkDocs-526CFE?style=for-the-badge&logo=MaterialForMkDocs&logoColor=white)](https://squidfunk.github.io/mkdocs-material/) 

[MDIBL Education Website](https://mdibl.github.io/)


### For Course Pages/Sections

- each course should contain all of it's contents within it's own directory. This will allow for seamless migration to archive upon completion. 
- paths (for images/presentations/links to other pages) for courses should be relative. 

### Adding Pages

- To add a new page or section, please adhere to the existing structure within `mkdocs.yml` `nav` section.
- Each section/subsection's home page needs to be called `index.md` and does not need a page name in the `mkdocs.yml`. All other pages need to have a name.

```
 i.e. 
  - Bioinformatics Bits: 
    - bits/index.md
    - Bit 1: bits/bit1.md
    - Bit 2: bits/bit2.md
```

### More info

All non-raw-text features can be copied from other sections in the website or check [mkdocs material -- reference](https://squidfunk.github.io/mkdocs-material/reference/) for more info. 