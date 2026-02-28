$baseDir = "c:\projects\日语N2"
$outputDir = "c:\projects\japanese_N2"

if (-not (Test-Path $outputDir)) { New-Item -Path $outputDir -ItemType Directory }

$phases = @(
    @{ id = "p1"; name = "筑基期 (3-4月)"; folder = "01_筑基期_3月-4月" },
    @{ id = "p2"; name = "强化期 (5月)"; folder = "02_强化期_5月" },
    @{ id = "p3"; name = "冲刺期 (6月)"; folder = "03_冲刺期_6月" },
    @{ id = "p4"; name = "考前周 (7月)"; folder = "04_考前周_7月初" }
)

$result = @{ phases = @() }

foreach ($p in $phases) {
    $phasePath = Join-Path $baseDir $p.folder
    if (-not (Test-Path $phasePath)) { continue }

    $pData = @{ id = $p.id; name = $p.name; days = @() }
    
    $subfolders = Get-ChildItem -Path $phasePath -Directory
    foreach ($sf in $subfolders) {
        $days = Get-ChildItem -Path $sf.FullName -Directory -Filter "Day_*"
        foreach ($d in $days) {
            $dialogueFile = Join-Path $d.FullName "03_对话练习.md"
            $audioFile = Join-Path $d.FullName "03_对话音频.wav"

            if (Test-Path $dialogueFile) {
                $content = Get-Content $dialogueFile -Raw -Encoding UTF8
                
                # Basic Parsing
                $content = $content -replace '# (.*)', '<h3>$1</h3>'
                $content = $content -replace '## (.*)', '<h4>$1</h4>'
                $content = $content -replace '### (.*)', '<h5>$1</h5>'
                $content = $content -replace '(?m)^\*\*([^*]+)\*\*：', '<div class="dialogue-turn"><strong>$1</strong>：'
                $content = $content -replace '---', '<hr>'
                $content = $content -replace "\n\n", "</div>`n`n"
                $content = $content -replace "\n", "<br>"

                $dayTitle = $d.Name.Replace("_", " ")
                
                $webAudioPath = $null
                if (Test-Path $audioFile) {
                    $audioName = "$($p.id)_$($sf.Name)_$($d.Name)_audio.wav" -replace "[^a-zA-Z0-9_.]", "_"
                    Copy-Item $audioFile (Join-Path $outputDir $audioName)
                    $webAudioPath = $audioName
                }

                $pData.days += @{
                    id      = "$($p.id)_$($d.Name)"
                    title   = $dayTitle
                    content = $content
                    audio   = $webAudioPath
                }
            }
        }
    }
    $result.phases += $pData
}

$result | ConvertTo-Json -Depth 10 | Out-File (Join-Path $outputDir "data.json") -Encoding UTF8
Write-Host "Site data generated successfully via PowerShell."
