# Cover images

The Makefile picks a cover **by target**. Slot names stay stable; point them at new art by replacing the file or overriding the variable.

| Target | Makefile variable | Default slot |
| --- | --- | --- |
| `make draft` | `DEFAULT_COVER_IMAGE` | `default-cover-image.jpg` |
| `make pdf` | `PDF_COVER_IMAGE` | `pdf-cover-image.jpg` → print master |
| `make epub` | `EPUB_COVER_IMAGE` | `epub-cover-image.jpg` → ebook master |
| `make docx` | (none) | Word has no EPUB/PDF-style cover page |

Masters (keep these names):

- `Friday_Night_Chains_1600x2560.jpg` — ebook / store thumbnail
- `Friday_Night_Chains_4800x7680_300dpi.jpg` — print

`pdf-cover-image.jpg` and `epub-cover-image.jpg` are symlinks to those masters.

`chain-gang-cover.jpg` is leftover placeholder art; it is not used by `make`.

Override example:

```bash
make pdf PDF_COVER_IMAGE=assets/covers/Friday_Night_Chains_4800x7680_300dpi.jpg
```
