const fs = require('fs');
const path = require('path');

const baseDir = 'c:\\projects\\日语N2';
const outputDir = 'c:\\projects\\japanese_N2';

function scanStudyMaterials() {
    const phases = [
        { id: 'p1', name: '筑基期 (3-4月)', folder: '01_筑基期_3月-4月' },
        { id: 'p2', name: '强化期 (5月)', folder: '02_强化期_5月' },
        { id: 'p3', name: '冲刺期 (6月)', folder: '03_冲刺期_6月' },
        { id: 'p4', name: '考前周 (7月)', folder: '04_考前周_7月初' }
    ];

    const result = { phases: [] };

    phases.forEach(p => {
        const phasePath = path.join(baseDir, p.folder);
        if (!fs.existsSync(phasePath)) return;

        const pData = { id: p.id, name: p.name, days: [] };

        // Scan subfolders (1.1, 1.2 etc)
        const subfolders = fs.readdirSync(phasePath).filter(f => fs.statSync(path.join(phasePath, f)).isDirectory());

        subfolders.forEach(sf => {
            const sfPath = path.join(phasePath, sf);
            const days = fs.readdirSync(sfPath).filter(f => f.startsWith('Day_'));

            days.forEach(d => {
                const dayPath = path.join(sfPath, d);
                const dialogueFile = path.join(dayPath, '03_对话练习.md');
                const audioFile = path.join(dayPath, '03_对话音频.wav');

                if (fs.existsSync(dialogueFile)) {
                    let content = fs.readFileSync(dialogueFile, 'utf8');

                    // Basic Markdown Parsing (convert to HTML)
                    content = content
                        .replace(/^# (.*$)/gim, '<h3>$1</h3>')
                        .replace(/^## (.*$)/gim, '<h4>$1</h4>')
                        .replace(/^### (.*$)/gim, '<h5>$1</h5>')
                        .replace(/^\*\*([^*]+)\*\*：/gim, '<div class="dialogue-turn"><strong>$1</strong>：')
                        .replace(/---/g, '<hr>')
                        .replace(/\n\n/g, '</div>\n\n') // Close dialogue turns on double newline
                        .replace(/\n/g, '<br>');

                    const dayTitle = d.replace(/_/g, ' ');

                    // Handle Audio: Copy to output dir for web access
                    let webAudioPath = null;
                    if (fs.existsSync(audioFile)) {
                        const audioName = `${p.id}_${sf}_${d}_audio.wav`.replace(/[^a-z0-9_.]/gi, '_');
                        fs.copyFileSync(audioFile, path.join(outputDir, audioName));
                        webAudioPath = audioName;
                    }

                    pData.days.push({
                        id: `${p.id}_${d}`,
                        title: dayTitle,
                        content: content,
                        audio: webAudioPath
                    });
                }
            });
        });
        result.phases.push(pData);
    });

    fs.writeFileSync(path.join(outputDir, 'data.json'), JSON.stringify(result, null, 2));
    console.log('Site data generated successfully.');
}

scanStudyMaterials();
