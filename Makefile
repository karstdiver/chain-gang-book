TITLE=chain-gang-book
MD=manuscript/book.md
TEMPLATE=assets/styles/book.tex.tpl
LUAFILTER=assets/styles/boxes.lua
REFDOCX=assets/styles/reference.docx

PDF_ENGINE=xelatex

# Default target
help:
	@echo "Chain Gang Book Makefile"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  help    - Show this help message"
	@echo "  fullbookmd - Stitch together into book.md"
	@echo "  draft   - Quick PDF build (no template/filters, for proofing)"
	@echo "  pdf     - Build print-ready PDF (styled)"
	@echo "  showpdf - Build PDF and open in default viewer"
	@echo "  epub    - Build EPUB for Apple Books / Kindle"
	@echo "  docx    - Build Word/Pages version"
	@echo "  clean   - Remove LaTeX build artifacts"

draft:
	pandoc $(MD) -o exports/pdf/$(TITLE)_draft.pdf \
	  --from markdown \
	  --toc --number-sections \
	  --pdf-engine=$(PDF_ENGINE)

pdf:
	pandoc $(MD) -o exports/pdf/$(TITLE).pdf \
	  --from markdown+implicit_figures \
	  --toc --number-sections \
	  --pdf-engine=$(PDF_ENGINE) \
	  --template=$(TEMPLATE) \
	  --lua-filter=$(LUAFILTER) \
	  -M title="Friday Night Chains" \
	  -M author="Richard Kallay"

epub:
	pandoc $(MD) -o exports/epub/$(TITLE).epub \
	  --from markdown+implicit_figures \
	  --toc --number-sections \
	  --lua-filter=$(LUAFILTER) \
	  -M title="Friday Night Chains" \
	  -M author="Richard Kallay"

docx:
	pandoc $(MD) -o exports/docx/$(TITLE).docx \
	  --from markdown+implicit_figures \
	  --toc --number-sections \
	  --reference-doc=$(REFDOCX) \
	  --lua-filter=$(LUAFILTER)

showpdf: pdf
	open exports/pdf/$(TITLE).pdf

clean:
	rm -f *.aux *.log *.out *.toc *.nav *.snm *.synctex.gz

# ---------- Stitch Markdown Parts into manuscript/book.md ----------
# Usage:
#   make fullbookmd                  # uses PROFILE=main by default
#   make fullbookmd PROFILE=proof    # uses manuscript/manifest-proof.txt
#   make show-manifest               # prints which manifest will be used

# Default profile and derived manifest path
PROFILE ?= main
MANIFEST := manuscript/manifest-$(PROFILE).txt
OUTFILE  := manuscript/book.md

.PHONY: fullbookmd show-manifest check-manifest

show-manifest:
	@echo "PROFILE = $(PROFILE)"
	@echo "MANIFEST = $(MANIFEST)"
	@test -f "$(MANIFEST)" || (echo "⚠️  Manifest not found: $(MANIFEST)"; exit 1)

check-manifest:
	@# Ensure manifest exists and has at least one non-comment, non-empty line
	@test -f "$(MANIFEST)" || (echo "❌ Missing manifest: $(MANIFEST)"; exit 1)
	@grep -v '^\s*#' "$(MANIFEST)" | grep -vq '^\s*$$' || \
	  (echo "❌ Manifest has no content: $(MANIFEST)"; exit 1)

fullbookmd: check-manifest
	@echo "📚 Stitching Markdown from $(MANIFEST) → $(OUTFILE)"
	@mkdir -p $(dir $(OUTFILE))
	@awk '\
	  BEGIN { first=1 } \
	  /^\s*$$/ { next } \
	  /^\s*#/ { next } \
	  { \
	    file=$$0; \
	    if (system("[ -f \"" file "\" ]") != 0) { \
	      printf("❌ Missing file listed in manifest: %s\n", file) > "/dev/stderr"; \
	      exit 2; \
	    } \
	    if (!first) { print "" } \
	    first=0; \
	    while ((getline line < file) > 0) print line; \
	    close(file); \
	  }' "$(MANIFEST)" > "$(OUTFILE)"
	@echo "✅ Wrote $(OUTFILE)"
