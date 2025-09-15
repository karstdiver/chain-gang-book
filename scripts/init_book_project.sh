#!/bin/bash
# init_book_project.sh
# Script to create a Chain Gang Book project structure

set -e

# Root project folder
PROJECT="chain-gang-book"

# Create base directory
mkdir -p $PROJECT
cd $PROJECT

# Top-level files
touch README.md LICENSE CHANGELOG.md .gitignore

# Manuscript
mkdir -p manuscript/{frontmatter,chapters,appendices}
touch manuscript/book.md
touch manuscript/STYLE_GUIDE.md
touch manuscript/STYLE_GUIDE_QUICK.md
touch manuscript/frontmatter/{preface.md,acknowledgements.md,toc.md}
touch manuscript/chapters/ch01_intro.md
touch manuscript/appendices/appA.md

# Assets
mkdir -p assets/{images/{cover,figures,diagrams},styles}
touch assets/styles/{book.tex.tpl,boxes.lua,reference.docx}

# Scripts
mkdir -p scripts
touch scripts/{make_pdf.sh,make_epub.sh,make_docx.sh,install_mac.sh}

# Pages (optional)
mkdir -p pages
touch pages/book.pages

# Exports
mkdir -p exports/{pdf,epub,docx}

# Makefile
touch Makefile

echo "✅ Project structure for '$PROJECT' created successfully."

