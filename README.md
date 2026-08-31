# Chain Crew Handbook

A practical guide to high school football chain crews — roles, responsibilities, 
equipment, safety, and professionalism — written by **Richard Kallay**.  

This project manages the book as a set of modular Markdown files stitched 
together with a Makefile. The goal is to produce clean, reproducible builds of 
the book in multiple formats (Markdown, PDF, EPUB, DOCX).  

---

## Repository Structure

```
chain-gang-book/
├── manuscript/              # Human-written source content
│   ├── frontmatter/         # Preface, acknowledgements, TOC
│   ├── chapters/            # Chapter source files
│   ├── appendices/          # Appendix source files
│   ├── conclusion.md
│   └── overtime.md
├── build/                   # Build inputs and generated stitched manuscript
│   ├── manifests/           # Assembly order by profile (manifest-<profile>.txt)
│   ├── metadatas/           # Layered metadata (profiles + publishers)
│   │   ├── profiles/
│   │   └── publishers/
│   └── book.md              # Generated stitched book (do not edit; gitignored)
├── exports/                 # Built outputs (PDF, EPUB, DOCX, etc.)
├── Makefile                 # Build automation
├── .gitignore               # Git ignore rules
├── LICENSE                  # Copyright (all rights reserved)
└── CONTRIBUTING.md          # Contribution guidelines
```

---

## Build Instructions

This repo uses a **manifest + metadata + Makefile** system to build the book.

### Stitch into `book.md`

Default profile (`fullbook`):

```bash
make fullbookmd
```

Alternative profile (`proof`, `promo`, etc.):

```bash
make fullbookmd PROFILE=proof
```

The manifest file defines which `.md` parts are included and in what order.  
For example: `build/manifests/manifest-fullbook.txt`.

The stitched output is written to `build/book.md` (generated locally; not committed).

### Metadata Layering

Build metadata is layered from:
- `build/metadatas/profiles/common.yml`
- `build/metadatas/profiles/<PROFILE>.yml`
- `build/metadatas/publishers/<PUBLISHER>.yml`

Use the CLI to choose profile and publisher:

```bash
make show PROFILE=fullbook PUBLISHER=common
make epub PROFILE=fullbook PUBLISHER=amazon
```

### Export Formats

- `make draft` → quick PDF in `exports/pdf/chain-gang-book_draft.pdf`
- `make pdf`   → styled PDF in `exports/pdf/chain-gang-book.pdf`
- `make epub`  → EPUB in `exports/epub/chain-gang-book.epub`
- `make docx`  → DOCX in `exports/docx/chain-gang-book.docx`

---

## Style Guide

- Follow `STYLE_GUIDE.md` for formatting conventions.
- Use consistent Markdown headers (`# Chapter X — Title`).
- Anecdotes are written in **third person** for consistency.
- Sidebars and pro tips use blockquotes and headings for visibility.

---

## Copyright

© 2026 Richard Kallay

All rights reserved.

See [LICENSE](LICENSE) for details.

---

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for workflow, 
style rules, and copyright.  

---

## Author

**Richard Kallay**  
*High school football chain crew veteran (~10 years), software engineer, and author.*  
