# STYLE_GUIDE.md  

# Chain Gang Book — Markdown Style Guide

This guide defines the **Markdown patterns** to use when drafting.  
Consistent patterns = easier formatting later (PDF, EPUB, DOCX, LaTeX).

This document defines the style rules for drafting, editing, and polishing the *Chain Crew Handbook*. All chapters, sidebars, and appendices must comply with these guidelines for consistency, clarity, and professionalism.  

## Professional Standards Language  
- Reinforce neutrality, professionalism, and safety throughout the text.  
- Use recurring phrases like:  
  - *"We work for the officials, not for the home team."*  
  - *"Professionalism is as much about appearance as accuracy."*

---

## Tone and Tense
- **Instructional text**: Present tense, direct, professional.  
  *Example: "Place the box at the linesman's right foot."*  
- **Anecdotes / sidebars**: Past tense, third person, story-like.  
  *Example: "One volunteer dropped the stick as the player crashed into the sideline."*  
- **Transitions and landings**: Short, declarative sentences tying the lesson back to professionalism, safety, or teamwork.  
- Keep voice professional but personable, with light humor allowed in sidebars.

---

## Chapter Structure
Each chapter must follow this structure:  
1. **Introductory paragraph**: Why this chapter matters, linked to game operations.  
2. **Primary content**: Clear subsections with headers.  
3. **Pro tips and/or sidebars**: At least one in each chapter, where applicable.  
4. **Landing sentence**: Concludes the chapter or sidebar, reinforces why the topic is critical to the crew's professionalism.  
5. **Transition sentence**: When appropriate, leads smoothly into the next chapter. Every chapter should include at least one.  

- Each chapter should include:  
  - Opening overview paragraph.  
  - Subsections with `##` headings for clarity.  
  - At least one sidebar with anecdote (if applicable).  
  - **Landing sentence** at the end of the main text.  
  - **Transition sentence** pointing forward to the next chapter (where appropriate).

---

## Anecdote Integration  
- Anecdotes may repeat a theme (e.g., safety, footwear) but must not duplicate full stories across chapters.  
- If duplication risk occurs, defer to the **earliest chapter** that establishes the theme and keep later mentions as brief references (e.g., "See Chapter 1 — closed-toe shoes are mandatory.").  

---

## Structure  
- Use `#` for chapter titles, e.g., `# Chapter 2 — Roles & Responsibilities`.  
- Use `##` for major subheadings (e.g., Box, Sticks, Clip, Officials).  
- Use `###` for sidebars or special notes.  
- Do not skip heading levels.  

---

## Headings  
- Use `#` for chapter titles, e.g., `# Chapter 2 — Roles & Responsibilities`.  
- Use `##` for major subheadings (e.g., Box, Sticks, Clip, Officials).  
- Use `###` for sidebars or special notes.  
- Do not skip heading levels.  

---

## Landing Sentences  
- Every chapter ends with a short **landing sentence** reinforcing why the content matters for professionalism, safety, or credibility.  
- Example: *"Clear roles and steady teamwork transform a handful of volunteers into a crew that officials can trust."*  
- Landing sentences must explicitly reinforce relevance to professionalism, safety, teamwork, or accuracy.

---

## Transitions  
- Where appropriate, end each chapter with a **transition sentence** to the next chapter.  
- Example: *"With responsibilities defined, the next step is to examine the equipment that makes the chain gang's work possible."*  

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
- Use the format:  
  - `### SIDEBAR: From the Sideline — [Title]`  
  - Anecdote in past tense.  
  - Close with a humorous or reflective punch line.  
- Always follow a sidebar with a **landing sentence** outside the box to reinforce why the anecdote matters.  

```markdown
### SIDEBAR: From the Sideline — [Title of Anecdote]

[Write your anecdote here. One or more paragraphs.]

<!-- end-sidebar -->
```

- Use `### SIDEBAR:` so we can style it consistently.  
- Always close with `<!-- end-sidebar -->`.

---

## 3. Pro Tips
- Special crew wisdom should be highlighted with a `**Pro Tip:**` prefix in bold.  
- Keep these short and practical.  
- Placement: Flexible, but should appear where the advice logically supports the main text.  
- Frequency: At least every other chapter, ideally one per chapter.  
- Content: Practical, actionable tips not covered in the main flow.  

```markdown
**Pro Tip:** [Write your tip here.]

<!-- end-protip -->
```

- Always bold "Pro Tip:" exactly this way.  
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
- All images (photos, diagrams, charts) are referred to as "Figures." If desired later, categories such as "Photo" or "Diagram" can be added.  
- Figures should always be referenced in the main text for context.  
- Resolution: Minimum **300 dpi** for print, or scalable vector graphics (SVG) for diagrams.  
- Placement: Near the paragraph where first referenced, not grouped at chapter ends.

---

## 5. Appendices
- Label appendices alphabetically (Appendix A, Appendix B, etc.).  
- Use consistent heading format: `# Appendix A — Title`.  
- Appendices may include reference material, checklists, or templates, but should avoid repeating full chapter content.  
- Appendices serve as **reference material**, not narrative.  
- No anecdotes or sidebars in appendices.  
- Cross-reference from chapters where needed ("See Appendix C for detailed signals").  
- Appendices should not duplicate main chapter content.

Streamline appendices to be purely reference (checklists, templates, diagrams) — remove narrative overlap.

```markdown
## Appendix A — Title Here

[Appendix content here.]
```

- Use `## Appendix A — …` format.  
- One appendix per section.  

---

## 6. Lists and Checklists
### 6.1 Lists  
- Use bullet lists (`-`) for duties, responsibilities, and checklists.  
- Use numbered lists only for step-by-step sequences.  
- Use ordered lists for sequential tasks or procedures.  
- Use unordered (bulleted) lists for qualities, tips, or non-ordered elements.  
- Keep list items parallel in structure (same tense and grammar style).

### 6.2 Checklists
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

## 8. Metadata & Production Prep
- Each file should include a header with:  
  ```
  Title:  
  Author: Richard Kallay  
  Draft Version:  
  Last Edited:  
  ```
- For publishing:  
  - Export formats: **PDF, EPUB, DOCX** (via Pandoc or similar).  
  - Ensure consistent heading hierarchy (`#`, `##`, `###`).  
  - Ensure figure references and captions are consistent.  
- Images: Save in `/figures/` directory. File naming convention: `fig_chX_shortdesc.png`.  
- TOC will be auto-generated later, don't manually edit.  
- Keep consistent use of chapter numbers, figure labels, and sidebar markers.  
- Don't manually renumber figures or chapters until final production.

---

## 9. Technical Terms  
- Use **bold** sparingly for key terms:  
  - **line of scrimmage**, **first down**, **chain**, **clip**, **measurement**, etc.  
- Avoid italics except for emphasis inside sidebars.

---

## 9.5. Acronyms and Abbreviations
- **First use**: Always spell out the full term followed by the acronym in parentheses.
  *Example: "The Athletic Director (AD) coordinates with the chain gang."*
- **Subsequent uses**: Use the acronym alone.
  *Example: "The AD will provide the equipment."*
- **Common football terms**: Some terms may be used as acronyms throughout:
  - **HL** (Head Linesman)
  - **AD** (Athletic Director) 
  - **NFHS** (National Federation of State High School Associations)
  - **VFW** (Veterans of Foreign Wars)
- **Acronym list**: Maintain a comprehensive list in an appendix for reference.
- **Consistency**: Once established, always use the same acronym for the same term.

### Auto-Generation Options:
- **Pandoc**: Can auto-generate acronym lists using the `--list-of-abbreviations` flag
- **LaTeX**: Automatic abbreviation lists with `\printacronyms`
- **Manual**: For now, maintain manually until production setup

```markdown
## Appendix X — Acronyms and Abbreviations

- **AD**: Athletic Director
- **HL**: Head Linesman  
- **NFHS**: National Federation of State High School Associations
- **VFW**: Veterans of Foreign Wars
```

**Note**: During production, this list can be auto-generated from the manuscript text using Pandoc or LaTeX tools, similar to the auto-generated TOC.

---

## 10. Consistency Rules
- No duplication of anecdotes. Reference earlier anecdotes when similar lessons apply.  
- Chapter introductions must explain *why the content matters*.  
- Landing sentences must explicitly reinforce relevance to professionalism, safety, teamwork, or accuracy.  
- All crew roles and responsibilities should use the same naming: **Box (Down Marker Operator), Sticks (First Down Markers), Clip Operator**.  

---

✅ Keep this `STYLE_GUIDE.md` file in your project root.  
✅ Copy-paste snippets into `book.md` while drafting.  
✅ Later, we'll convert systematically into LaTeX, DOCX, or EPUB.