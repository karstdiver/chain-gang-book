# Makefile for Chain Gang Book
#
# This Makefile is used to build the Chain Gang Book in various formats.
# It uses Pandoc to convert the Markdown files into PDF, EPUB, and DOCX formats.
# It also uses LaTeX to style the PDF output.
#

## Book type variables (what and how to build)  override these on the command line
# form of book to build: fullbook, proof, promo, etc.
PROFILE   ?= fullbook

# which publisher to build for: common/generic, print, amazon, apple, etc.
PUBLISHER ?= common

## Build directory and files (where book parts are in the directory tree)
# where build configs exist in the directory tree
BUILD_DIR      := build

# where raw book text exists in the directory tree
MANUSCRIPT_DIR := manuscript

# book file list for the current profile
MANIFEST_DIR   := $(BUILD_DIR)/manifests
MANIFEST       := $(MANIFEST_DIR)/manifest-$(PROFILE).txt

# where metadata exists
METADATA_DIR   := $(BUILD_DIR)/metadatas
PROFILE_DIR    := profiles
PUBLISHER_DIR  := publishers

# gather data files about the book
METADATA_COMMON := $(METADATA_DIR)/$(PROFILE_DIR)/common.yml
METADATA_FILES := \
  $(METADATA_COMMON) \
  $(METADATA_DIR)/$(PROFILE_DIR)/$(PROFILE).yml \
  $(METADATA_DIR)/$(PUBLISHER_DIR)/$(PUBLISHER).yml

METADATA_FLAGS := $(foreach f,$(METADATA_FILES),--metadata-file=$(f))

# where the publishing files exist
EXPORT_DIR     := exports

# Build files used to stitch and populate book parts
# - STITCHED_FILE: output file for the stitched manuscript
STITCHED_FILE  := $(BUILD_DIR)/book.md


# Export filename slug (not the book display title). Read from common.yml; no yq required.
TITLE           ?= chain-gang-book

# Is yq on PATH? (empty if not found)
YQ := $(shell command -v yq 2>/dev/null)

ifneq ($(wildcard $(METADATA_COMMON)),)
  ifneq ($(YQ),)
    # yq available — read slug from YAML
    TITLE := $(shell yq -r '.slug' '$(METADATA_COMMON)' 2>/dev/null)
  else
    # no yq — fallback: grep/sed
    TITLE := $(shell grep -E '^slug:[[:space:]]*' '$(METADATA_COMMON)' 2>/dev/null | head -1 | sed 's/^slug:[[:space:]]*//' | tr -d '"' | tr -d "'")
  endif
endif

# If yq returned empty or file missing slug, keep default
ifeq ($(TITLE),)
  TITLE := chain-gang-book
endif

## output file
MD=$(STITCHED_FILE)

## asset files
ASSET_DIR := assets
STYLE_DIR := styles
TEMPLATE  = $(ASSET_DIR)/$(STYLE_DIR)/book.tex.tpl
LUAFILTER = $(ASSET_DIR)/$(STYLE_DIR)/boxes.lua
REFDOCX   = $(ASSET_DIR)/$(STYLE_DIR)/reference.docx

PDF_ENGINE=xelatex

# Default target
help:
	@echo "Chain Gang Book Makefile"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Example:"
	@echo "make show"
	@echo "make fullbookmd PROFILE=fullbook"
	@echo "make pdf PROFILE=fullbook PUBLISHER=common"
	@echo " build with: common.yml → profiles/fullbook.yml → publishers/amazon.yml"
	@echo "$ make epub PROFILE=fullbook PUBLISHER=amazon"
	@echo ""
	@echo "Targets:"
	@echo "  help       - Show this help message"
	@echo "  show       - Display and check on book build files"
	@echo "  fullbookmd - Stitch together into book.md"
	@echo "  validate   - Run validation checks (placeholder - TODO)"
	@echo "  draft   - Quick PDF build (no template/filters, for proofing)"
	@echo "  pdf     - Build print-ready PDF (styled)"
	@echo "  showpdf - Build PDF and open in default viewer"
	@echo "  epub    - Build EPUB for Apple Books / Kindle"
	@echo "  docx    - Build Word/Pages version"
	@echo "  clean   - Remove LaTeX build artifacts"
	@echo ""
	@echo "Hints:"
	@echo "  raw book files are in           $(MANUSCRIPT_DIR)"
	@echo "  common manifest list are in     $(MANIFEST_DIR)"
	@echo "  profile manifest lists are in   $(METADATA_DIR)/$(PROFILE_DIR)"
	@echo "  publisher manifest lists are in $(METADATA_DIR)/$(PUBLISHER_DIR)"
	@echo "  stitched book file is $(STITCHED_FILE)"
	@echo "  output books are in $(EXPORT_DIR)"

draft: fullbookmd
	@echo "📝 Building draft PDF → $(EXPORT_DIR)/pdf/$(TITLE)_draft.pdf"
	pandoc $(MD) -o $(EXPORT_DIR)/pdf/$(TITLE)_draft.pdf \
	  $(METADATA_FLAGS) \
	  --from markdown \
	  --pdf-engine=$(PDF_ENGINE)
	@echo "✅ Wrote $(EXPORT_DIR)/pdf/$(TITLE)_draft.pdf"
	@ls -lh "$(EXPORT_DIR)/pdf/$(TITLE)_draft.pdf" || true

pdf: fullbookmd
	@echo "🖨  Building styled PDF → $(EXPORT_DIR)/pdf/$(TITLE).pdf"
	pandoc $(MD) -o $(EXPORT_DIR)/pdf/$(TITLE).pdf \
	  $(METADATA_FLAGS) \
	  --from markdown+implicit_figures \
	  --pdf-engine=$(PDF_ENGINE) \
	  --template=$(TEMPLATE) \
	  --lua-filter=$(LUAFILTER)
	@echo "✅ Wrote $(EXPORT_DIR)/pdf/$(TITLE).pdf"
	@ls -lh "$(EXPORT_DIR)/pdf/$(TITLE).pdf" || true

epub: fullbookmd
	@echo "📚 Building EPUB → $(EXPORT_DIR)/epub/$(TITLE).epub"
	pandoc $(MD) -o $(EXPORT_DIR)/epub/$(TITLE).epub \
	  $(METADATA_FLAGS) \
	  --from markdown+implicit_figures \
	  --lua-filter=$(LUAFILTER)
	@echo "✅ Wrote $(EXPORT_DIR)/epub/$(TITLE).epub"
	@ls -lh "$(EXPORT_DIR)/epub/$(TITLE).epub" || true

docx: fullbookmd
	@# Ensure reference.docx exists and is non-empty before calling Pandoc
	@test -s "$(REFDOCX)" || { \
	  echo "❌ DOCX build requires a non-empty reference DOCX at $(REFDOCX)."; \
	  echo "   TODO: Create a clean reference.docx with styles only."; \
	  echo "   Suggested workflow:"; \
	  echo "     1) Run: pandoc $(MD) -o /tmp/default-ref.docx --from markdown+implicit_figures --toc --number-sections"; \
	  echo "     2) Open /tmp/default-ref.docx in Word/LibreOffice."; \
	  echo "     3) Delete all book body text, but keep styles (Normal, Heading 1/2/3, etc.)."; \
	  echo "     4) Save it as $(REFDOCX)."; \
	  echo "   Alternatively, remove --reference-doc from the docx target to use Pandoc's default styles."; \
	  exit 1; \
	}
	pandoc $(MD) -o $(EXPORT_DIR)/docx/$(TITLE).docx \
	  $(METADATA_FLAGS) \
	  --from markdown+implicit_figures \
	  --reference-doc=$(REFDOCX) \
	  --lua-filter=$(LUAFILTER)
	@echo "✅ Wrote $(EXPORT_DIR)/docx/$(TITLE).docx"
	@ls -lh "$(EXPORT_DIR)/docx/$(TITLE).docx" || true

showpdf: pdf
	open $(EXPORT_DIR)/pdf/$(TITLE).pdf

clean:
	rm -f *.aux *.log *.out *.toc *.nav *.snm *.synctex.gz

# ---------- Stitch Markdown Parts into manuscript/book.md ----------
# Usage:
#   make fullbookmd                  # uses PROFILE=main by default
#   make fullbookmd PROFILE=proof    # uses manuscript/manifest-proof.txt
#   make show-manifest               # prints which manifest will be used


.PHONY: help clean showpdf fullbookmd show show-title show-profile show-manifest show-metadata check check-manifest check-metadata validate


show: show-title show-profile show-manifest check-manifest show-metadata check-metadata

show-title:
	@echo "YQ      = $(if $(YQ),$(YQ),(not installed))"
	@echo "TITLE   = $(TITLE)"
	@echo "SOURCE  = $(METADATA_COMMON)"

show-profile:
	@echo "Building book using:"
	@echo "PROFILE = $(PROFILE)"

show-manifest: show-profile check-manifest
	@echo "MANIFEST = $(MANIFEST)"
	@test -f "$(MANIFEST)" || (echo "⚠️  Manifest not found: $(MANIFEST)"; exit 1)

check-manifest:
	@# Ensure manifest exists and has at least one non-comment, non-empty line
	@test -f "$(MANIFEST)" || (echo "❌ Missing manifest: $(MANIFEST)"; exit 1)
	@grep -v '^\s*#' "$(MANIFEST)" | grep -vq '^\s*$$' || \
	  (echo "❌ Manifest has no content: $(MANIFEST)"; exit 1)

show-metadata: show-profile check-metadata
	@# loop testing existence of all used METADATA_FILES
	@echo "METADATA_FILES:"
	@for f in $(METADATA_FILES); do \
	  echo "  - $$f"; \
	  if [ ! -f "$$f" ]; then \
	    echo "⚠️  Metadata not found: $$f"; \
	    exit 1; \
	  fi; \
	done

check-metadata:
	@# Ensure each metadata file exists and has at least one non-comment, non-empty line
	@for f in $(METADATA_FILES); do \
	  test -f "$$f" || { echo "❌ Missing metadata: $$f"; exit 1; }; \
	  grep -v '^[[:space:]]*#' "$$f" | grep -qv '^[[:space:]]*$$' || { \
	    echo "❌ Metadata has no content: $$f"; exit 1; \
	  }; \
	done

# Validation (placeholder - to be implemented)
# See BUILD_VALIDATION_ANALYSIS.md for implementation plan
validate:
	@echo "⚠️  Validation is planned but not yet implemented."
	@echo "   This will check manifest structure, image references, and chapter formatting."
	@echo "   See BUILD_VALIDATION_ANALYSIS.md for details."
	@exit 0

fullbookmd: show
	@echo "📚 Stitching Markdown from $(MANIFEST) → $(STITCHED_FILE)"
	@mkdir -p $(dir $(STITCHED_FILE))
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
	  }' "$(MANIFEST)" > "$(STITCHED_FILE)"
	@echo "✅ Wrote $(STITCHED_FILE)"
	@ls -lh "$(STITCHED_FILE)" || true
