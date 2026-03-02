---
description: Standards for precise Japanese N2 furigana (Ruby) formatting and Kanji usage.
---
# JLPT N2 Furigana & Kanji Standard

Use this skill to ensure all Japanese N2 study materials meet the "Premium" visual and technical standards for vertical alignment and orthography.

## 1. Granular Ruby Tagging (核心要求)
Furigana (reading) must be placed directly above each individual Kanji character. Do NOT tag entire words as a single block.

- **INCORRECT**: `<ruby>舞台<rt>ぶたい</rt></ruby>`
- **CORRECT**: `<ruby>舞<rt>ぶ</rt>台<rt>たい</rt></ruby>`

### Why?
Granular tagging ensures that the reading is strictly and precisely aligned above the correct character, preventing "drifting" or misalignment in various browser widths.

## 2. Visual Styling
- **Color**: Reading texts (`<rt>`) must be **RED**.
- **Weight**: Reading texts must be **NOT BOLD** (`font-weight: normal`).
- **Formatting**: For bold text with furigana, wrap the entire ruby tag in a `<b>` or `<strong>` tag.
  - **Example**: `<b><ruby>我<rt>が</rt>慢<rt>まん</rt></ruby></b>`

## 3. Kanji Orthography (汉字标准)
Always use **Standard Japanese Kanji** (Kyōiku/Jōyō) as per the JLPT N2 curriculum. Avoid Simplified Chinese characters even if they look similar.

- **Check**: Use 「活躍」, not 「活跃」; 「飽きる」, not 「饱きる」.

## 4. Pitch Accent (音调标注)
Include pitch accent notation in vocabulary tables using the `[数字]` format.

- **Example**: `[1]` for Atamadaka, `[0]` for Heiban.
- **Placement**: Place it in a dedicated "Pitch" or "音调" column.
