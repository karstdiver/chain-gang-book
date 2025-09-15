# Contributing to the Chain Gang Book Project

Thanks for your interest in contributing!  
This project is maintained as a structured book/manual. To keep things 
organized, please follow the guidelines below.

---

## 🔄 **Typical Git Workflow for Book Development**

- **Do not edit `manuscript/book.md` directly.**  
  It is generated from individual chapter and appendix files using the Makefile.  

- **Edit source files only:**  
  - `manuscript/frontmatter/` → Preface, acknowledgements, TOC  
  - `manuscript/chapters/` → Chapters 1–12  
  - `manuscript/appendices/` → Appendices A–I  
  - `manuscript/conclusion.md` → Wrap-up  

- Run `make fullbookmd` to stitch everything into `book.md`.


### **Daily Writing Workflow:**
```bash
# Check status
git status

# Add changes
git add .

# Commit with descriptive message
git commit -m "Add chapter 3: Advanced concepts"

# Push to remote (if you have one)
git push origin main
```

### **Branching Strategy for Books:**
```bash
# Create feature branch for new chapter
git checkout -b chapter-4

# Work on chapter
# ... write content ...

# Commit changes
git add .
git commit -m "Complete chapter 4 draft"

# Merge back to main
git checkout main
git merge chapter-4
```

## �� **Cursor Features for Book Writing**

- **Markdown support** - Great for structured writing
- **Git integration** - Built-in source control
- **Extensions** - Spell check, grammar tools, etc.
- **Split view** - Edit multiple files simultaneously
- **Search** - Find and replace across entire book

---

## Style Guidelines

- Follow `STYLE_GUIDE.md` for headings, sidebars, anecdotes, and pro tips.  
- Use third-person tone for anecdotes (“One volunteer…”) for consistency.  
- Insert new sections or sidebars as separate Markdown blocks with clear headings.

---

## Commit Messages

- Keep commits focused (“Rewrite Chapter 3 intro”, “Polish sidebar in Appendix H”).  
- Use present tense (“Add”, “Fix”, “Update”) for clarity.

---

## Licensing

By contributing, you agree that your contributions will be licensed under the
Creative Commons Attribution 4.0 International License (CC BY 4.0).

---

