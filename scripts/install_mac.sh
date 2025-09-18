#!/usr/bin/env bash

# macOS bootstrap for building the book
# - Installs Homebrew (if needed)
# - Installs Pandoc
# - Installs a minimal LaTeX distribution (BasicTeX) and required packages for xelatex
# - Installs utilities for handling SVG → PDF when building
#
# Usage:
#   chmod +x scripts/install_mac.sh
#   ./scripts/install_mac.sh

set -euo pipefail

echo "➡️  Bootstrapping macOS build environment..."

# 1) Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "🔧 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "✅ Homebrew installed"
fi

echo "🔎 Using brew at: $(command -v brew)"

# 2) Core tools
echo "📦 Installing core packages (pandoc, imagemagick, librsvg, inkscape)..."
brew install pandoc imagemagick librsvg || true
# Inkscape is optional but helpful for latex/svg flows
brew install --cask inkscape || true

# 3) Minimal TeX (BasicTeX) for xelatex
if ! command -v tlmgr >/dev/null 2>&1; then
  echo "📦 Installing BasicTeX (minimal LaTeX distribution)..."
  brew install --cask basictex
  echo "ℹ️  Adding TeX binaries to your PATH (\"~/.zprofile\")"
  {
    echo ''
    echo '# Added by chain-gang-book/scripts/install_mac.sh'
    echo 'export PATH="/Library/TeX/texbin:$PATH"'
  } >> "$HOME/.zprofile"
  # Make PATH available in current shell session as well
  export PATH="/Library/TeX/texbin:$PATH"
fi

echo "🔁 Updating tlmgr..."
sudo tlmgr update --self || true

echo "📦 Installing required LaTeX packages (this can take a few minutes)..."
sudo tlmgr install \
  xetex latexmk \
  collection-fontsrecommended collection-latexrecommended \
  geometry fancyhdr titlesec setspace hyperref \
  upquote microtype csquotes etoolbox enumitem booktabs \
  tcolorbox xcolor parskip pdfpages wrapfig mdframed fvextra needspace \
  fontspec unicode-math polyglossia luaotfload luahbtex iftex unicode-data

echo "🗂  Ensuring export directories exist..."
mkdir -p exports/pdf exports/epub exports/docx

cat <<'EONOTE'
✅ Setup complete.

Build commands:
  make fullbookmd              # stitch manifest → manuscript/book.md
  make pdf                     # exports/pdf/chain-gang-book.pdf
  make epub                    # exports/epub/chain-gang-book.epub
  make docx                    # exports/docx/chain-gang-book.docx

Notes:
  - If SVGs fail during PDF build, Pandoc+XeLaTeX may require external conversion.
    You can convert an SVG to PDF or PNG:
      rsvg-convert -f pdf -o out.pdf input.svg
      magick convert input.svg out.pdf
    Then update the image path in the Markdown to the converted file for PDF builds.
EONOTE


