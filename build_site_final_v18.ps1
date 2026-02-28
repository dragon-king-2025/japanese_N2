$fileListPath = "c:\projects\japanese_N2\file_list.txt"
$outputDir = "c:\projects\japanese_N2"

if (-not (Test-Path $fileListPath)) { Write-Error "File list not found"; exit }

$files = [System.IO.File]::ReadAllLines($fileListPath, [System.Text.Encoding]::UTF8)
$daysDict = @{}

# Helper function for inline Markdown formatting
function Convert-MdInline($text) {
    if (-not $text) { return "" }
    $out = $text -replace "\*\*(.*?)\*\*", '<strong>$1</strong>'
    return $out
}

function Convert-TableToHtml($md) {
    if (-not $md) { return "" }
    $lines = $md -split "\r?\n"
    $html = '<div class="table-wrapper"><table>'
    $inHeader = $false
    $inBody = $false
    
    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ($trimmed -match "^\s*\|") {
            if ($trimmed -match "\| :---") { continue }
            $cells = $trimmed.Trim("|").Split("|") | ForEach-Object { $_.Trim() }
            if ($cells.Count -lt 2) { continue }
            
            if (-not $inHeader) {
                $html += "<thead><tr>"
                foreach ($c in $cells) { 
                    $fc = Convert-MdInline $c
                    $html += "<th>$fc</th>" 
                }
                $html += "</tr></thead><tbody>"
                $inHeader = $true
                $inBody = $true
            }
            else {
                $html += "<tr>"
                foreach ($c in $cells) { 
                    $fc = Convert-MdInline $c
                    $html += "<td>$fc</td>" 
                }
                $html += "</tr>"
            }
        }
    }
    if ($inBody) { $html += "</tbody>" }
    $html += "</table></div>"
    return $html
}

foreach ($f in $files) {
    if ($f.Trim() -eq "") { continue }
    $parent = Split-Path $f -Parent
    $folderName = Split-Path $parent -Leaf
    $fileName = Split-Path $f -Leaf
    
    if ($folderName -like "Day_*") {
        if (-not $daysDict.ContainsKey($folderName)) {
            $daysDict[$folderName] = @{ 
                id       = $folderName; 
                title    = $folderName.Replace("_", " "); 
                vocab    = ""; 
                dialogue = ""; 
                test     = ""; 
                audio    = $null 
            }
        }
        
        $raw = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
        
        # Block level replacements
        $h = $raw -replace '# (.*)', '<h3>$1</h3>' `
            -replace '## (.*)', '<h4>$1</h4>' `
            -replace '### (.*)', '<h5>$1</h5>' `
            -replace '---', '<hr>'
        
        # Inline level replacements and line breaks
        $h = Convert-MdInline $h
        $h = $h -replace "\n", "<br>"

        if ($fileName -match "^02_") { 
            $daysDict[$folderName].vocab = Convert-TableToHtml $raw 
        }
        elseif ($fileName -match "^03_") {
            if ($f.ToLower().EndsWith(".md")) { 
                $daysDict[$folderName].dialogue = $h 
            }
            else {
                $audioName = $folderName + "_audio.wav"
                Copy-Item $f (Join-Path $outputDir $audioName) -Force
                $daysDict[$folderName].audio = $audioName
            }
        }
        elseif ($fileName -match "^04_") { 
            $daysDict[$folderName].test = $h 
        }
    }
}

$daysList = @()
foreach ($key in ($daysDict.Keys | Sort-Object)) {
    $daysList += $daysDict[$key]
}

$finalObj = @{ phases = @( @{ id = "p1_1"; name = "N2 Study Portal (Phase 1.1)"; days = $daysList } ) }
$json = $finalObj | ConvertTo-Json -Depth 10

$jsContent = "const STUDY_DATA = $json;"
[System.IO.File]::WriteAllText((Join-Path $outputDir "data.js"), $jsContent, [System.Text.Encoding]::UTF8)

Write-Host "Success: data.js rebuilt with $($daysList.Count) days."
