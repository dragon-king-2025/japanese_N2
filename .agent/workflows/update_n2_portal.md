---
description: Comprehensive workflow to add new daily materials, generate audio, and update the N2 portal.
---
# N2 Project Daily Update Workflow

Follow these steps to add new study content (e.g., Day 15) and synchronize it to the web portal and GitHub.

## 1. Prepare New Content
1. Create a new directory: `c:\projects\japanese_N2\Day_XX`.
2. Add the following Markdown files using the **n2_furigana_master** skill:
    - `01_核心词汇.md`
    - `03_对话练习.md`
    - `04_自我测试.md`

## 2. Generate Audio
Use the automation script to synthesize speech for the new dialogue.
// turbo
3. Run the audio generation script:
```powershell
powershell -File c:\projects\japanese_N2\gen_audio_v3.ps1
```

## 3. Build the Portal
Convert the new Markdown data into the interactive web format.
// turbo
4. Run the latest build script:
```powershell
powershell -File c:\projects\japanese_N2\build_site_final_v18.ps1
```

## 4. Verify Locally
5. Open `c:\projects\japanese_N2\index.html` in a browser.
6. Verify that:
    - The new Day appears in the sidebar.
    - Furigana is red, non-bold, and character-aligned.
    - Audio plays correctly in the Dialogue tab.

## 5. Sync to GitHub
Commit and push the changes to the remote repository.
// turbo
7. Execute the sync commands:
```powershell
git add .
git commit -m "Add Day XX materials and update portal"
git push origin main
```
