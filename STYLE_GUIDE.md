# Chain Gang Book — Markdown Style Guide

This guide defines the **Markdown patterns** to use when drafting.  
Consistent patterns = easier formatting later (PDF, EPUB, DOCX, LaTeX).

---

## 1. Chapters
```markdown
# Chapter X — Title Here

[Opening text in standard paragraph format.]
```

- Use `#` for chapter titles.  
- Always start with `# Chapter X — …` for easy search/replacement.  

---

## 2. Sidebars (Anecdotes)
```markdown
### SIDEBAR: From the Sideline — [Title of Anecdote]

[Write your anecdote here. One or more paragraphs.]

<!-- end-sidebar -->
```

- Use `### SIDEBAR:` so we can style it consistently.  
- Always close with `<!-- end-sidebar -->`.

---

## 3. Pro Tips
```markdown
**Pro Tip:** [Write your tip here.]

<!-- end-protip -->
```

- Always bold “Pro Tip:” exactly this way.  
- End with `<!-- end-protip -->`.

---

## 4. Figures & Illustrations
```markdown
![Alt text for screen readers](images/filename.jpg)

*Figure X: Descriptive caption goes here.*
```

- Store images in `/images` folder.  
- Caption must start with `*Figure X: …*` for later auto-numbering.  
- Use descriptive alt text.

---

## 5. Appendices
```markdown
## Appendix A — Title Here

[Appendix content here.]
```

- Use `## Appendix A — …` format.  
- One appendix per section.  

---

## 6. Checklists
```markdown
- [ ] Item one
- [ ] Item two
- [ ] Item three
```

- Use GitHub-flavored Markdown checkboxes for tasks, procedures, or uniform checks.

---

## 7. Conclusion / Preface / Acknowledgements
```markdown
# Preface
# Acknowledgements
# Conclusion
```

- Use `#` for top-level book sections.  
- These should not be numbered chapters.

---

## 8. Metadata Notes
- TOC will be auto-generated later, don’t manually edit.  
- Keep consistent use of chapter numbers, figure labels, and sidebar markers.  
- Don’t manually renumber figures or chapters until final production.

---

✅ Keep this `STYLE_GUIDE.md` file in your project root.  
✅ Copy-paste snippets into `book.md` while drafting.  
✅ Later, we’ll convert systematically into LaTeX, DOCX, or EPUB.
