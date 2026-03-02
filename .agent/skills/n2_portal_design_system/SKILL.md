---
description: Technical architecture and visual design system for the JLPT N2 Study Portal.
---
# JLPT N2 Portal Design System Skill

Use this skill to maintain, update, and build the premium JLPT N2 Study Portal web application.

## 1. Visual Design Theme: "Porcelain & Indigo"
Maintain a professional, high-readability light theme with the following specs:

- **Backgrounds**: Slate-100 base (`#f1f5f9`), Pure White cards (`#ffffff`).
- **Accent Color**: Deep Indigo (`#4f46e5`) for headers and active states.
- **Sidebars**: Narrow design (**220px**) for maximum content width.
- **Glassmorphism**: Use subtle `backdrop-filter: blur(10px)` on floating navigation and overlays.
- **Cards**: Large radius (**2rem**) with soft, multi-layered `box-shadow`.

## 2. Table & Content Specs
- **Width**: Content cards must be **100% width** to accommodate 8-column vocabulary tables.
- **Furigana Style**: Ensure `rt` elements are **RED** and **NORMAL weight** via CSS globally.
- **Alignment**: Character-level vertical alignment must be consistent across all tabs.

## 3. Build System (PowerShell v18+)
The portal is built using a custom static-site generation logic.

- **Data Handling**: All study Markdown files are converted to JSON and inlined into `data.js` to avoid CORS issues and allow offline/local-file usage.
- **Markdown Parsing**: Use the `Convert-MdInline` function to handle bolding and inline Ruby tags correctly within table cells.
- **Automation**: Run `build_site_final_v18.ps1` (or latest) whenever files in `Day_XX` folders are modified.

## 4. Navigation & State
- **Routing**: Client-side routing to switch between `Day_01` to `Day_14`.
- **Tabs**: Smooth transitions between **Vocabulary**, **Dialogue**, and **Test** sections.
- **Audio Sync**: Ensure the audio player correctly points to the relative path of the day's `.wav` file.
