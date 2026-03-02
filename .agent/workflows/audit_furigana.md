---
description: Workflow to audit and fix furigana alignment and styling across all files.
---
# N2 Furigana Quality Audit Workflow

Use this workflow if you notice misaligned readings or inconsistent styling in the study portal.

## 1. Scan for Block-Level Ruby
Identify files using the incorrect block-level ruby tagging (e.g., `<ruby>舞台<rt>ぶたい</rt></ruby>`).

1. Use `grep_search` to find `<ruby>` tags that contain more than one Kanji character before the first `<rt>`.

## 2. Apply Granular Fixes
Apply the **n2_furigana_master** skill standards.

2. Replace block tags with character-level tags:
   - **From**: `<ruby>汉字汉字<rt>发音发音</rt></ruby>`
   - **To**: `<ruby>汉<rt>发</rt>字<rt>音</rt></ruby>`

## 3. Verify CSS Compliance
3. Check `c:\projects\japanese_N2\style.css` to ensure the following rules are present:
```css
rt {
    color: #ef4444; /* Red */
    font-weight: normal !important;
    font-size: 0.6em;
}
```

## 4. Rebuild & Validate
// turbo
4. Rebuild the site data:
```powershell
powershell -File c:\projects\japanese_N2\build_site_final_v18.ps1
```
5. Refresh the browser and verify the visual alignment on the affected Day's page.
