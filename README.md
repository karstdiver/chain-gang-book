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
├── manuscript/              # Main source content
│   ├── frontmatter/         # Preface, acknowledgements, TOC
│   ├── chapters/            # Chapters 1–12
│   ├── appendices/          # Appendices A–I
│   └── conclusion.md        # Wrap-up
├── exports/                 # Built outputs (PDF, EPUB, DOCX, etc.)
├── Makefile                 # Build automation
├── .gitignore               # Git ignore rules
├── LICENSE                  # License (CC-BY 4.0)
└── CONTRIBUTING.md          # Contribution guidelines
```

---

## Build Instructions

This repo uses a **manifest + Makefile** system to stitch together the book.  

### Stitch into `book.md`

Default profile (`main`):

```bash
make fullbookmd
```

Alternative profile (`proof`, `promo`, etc.):

```bash
make fullbookmd PROFILE=proof
```

The manifest file defines which `.md` parts are included and in what order.  
For example: `manuscript/manifest-main.txt`.

### Export Formats (coming soon)

Planned targets for `make`:
- `make draft` → Quick combined Markdown into `manuscript/book.md`
- `make pdf`   → Polished PDF into `exports/book.pdf` (via Pandoc/LaTeX)
- `make epub`  → EPUB format for e-readers
- `make docx`  → Word format for editors

---

## Style Guide

- Follow `STYLE_GUIDE.md` for formatting conventions.
- Use consistent Markdown headers (`# Chapter X — Title`).
- Anecdotes are written in **third person** for consistency.
- Sidebars and pro tips use blockquotes and headings for visibility.

---

## License

This work is licensed under the **Creative Commons Attribution 4.0 International License (CC-BY 4.0)**.  
See [LICENSE](LICENSE) for details.

---

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for workflow, 
style rules, and licensing details.  

---

## Author

**Richard Kallay**  
*High school football chain crew veteran (~10 years), software engineer, and author.*  
