---
description: Procedures for automated N2 audio synthesis and tag-aware text processing.
---
# JLPT N2 Audio Automation Skill

Use this skill to manage the generation and integration of high-quality TTS audio for JLPT N2 study materials.

## 1. TTS Synthesis Requirements
- **Engine**: Microsoft Haruka (Native Windows) or Edge TTS (Cloud).
- **Voice**: Professional, high-naturalness female or male voices suitable for JLPT listening practice.
- **Format**: `.wav` files at **44.1kHz** or **48kHz** for maximum browser compatibility.

## 2. Text Pre-processing (Ruby Stripping)
Before synthesis, all HTML tags (especially Ruby tags) must be removed to avoid the engine "spelling out" the tags or getting confused.

- **Regex Pattern**: 
  - Remove `<rt>...</rt>` content: `<rt>[^<]+</rt>`
  - Remove remaining tags: `<[^>]+>`
- **Punctuation**: Ensure sentence endings have full-width periods (`。`) or commas (`、`) to maintain natural prosody.

## 3. Automation Workflow
- **Script**: `gen_audio_v3.ps1` (PowerShell).
- **Input**: `03_对话练习.md` (Markdown).
- **Output**: `03_对话音频.wav` (WAV).
- **Batch Processing**: Recursively scan `Day_XX` folders to ensure all daily materials have matching audio.

## 4. File Organization
Audio files must be colocated with their source Markdown files for easy relative path matching in the web portal logic.

- **Standard Path**: `c:\projects\japanese_N2\Day_XX\03_对话音频.wav`
