# Contributing to the Chain Gang Book Project

Thanks for your interest in contributing!  
This project is maintained as a structured book/manual. To keep things 
organized, please follow the guidelines below.

---

## 🔄 **Typical Git Workflow for Book Development**

- **Do not edit `build/book.md` directly.**
  It is generated from source files listed in `build/manifests/manifest-<profile>.txt`.

- **Edit source files only:**  
  - `manuscript/frontmatter/` → Title page, preface, acknowledgements, TOC  
  - `manuscript/chapters/` → Chapters 1–12  
  - `manuscript/appendices/` → Appendices A–I  
  - `manuscript/conclusion.md` → Wrap-up  
  - `manuscript/overtime.md` → Overtime chapter

- Build inputs are in `build/`:
  - `build/manifests/` → chapter/file assembly order by profile
  - `build/metadatas/profiles/` → shared and profile metadata
  - `build/metadatas/publishers/` → publisher-specific metadata overlays

- Run `make fullbookmd` to stitch everything into `build/book.md`.

### **Build Modes (Profile + Publisher):**
```bash
# Show active profile/publisher plus manifest/metadata checks
make show PROFILE=fullbook PUBLISHER=common

# Build using profile-specific content and publisher metadata layering
make epub PROFILE=fullbook PUBLISHER=amazon
```


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

## Cursor Features for Book Writing

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

