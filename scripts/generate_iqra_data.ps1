$baseLetters = @("ا", "ب", "ت", "ث", "ج", "ح", "خ", "د", "ذ", "ر", "ز", "س", "ش", "ص", "ض", "ط", "ظ", "ع", "غ", "ف", "ق", "ك", "ل", "م", "ن", "و", "ه", "ي")
$baseLatin = @("a", "ba", "ta", "tsa", "ja", "ha", "kha", "da", "dza", "ra", "za", "sa", "sya", "sha", "dha", "tha", "zha", "a'", "gha", "fa", "qa", "ka", "la", "ma", "na", "wa", "ha", "ya")

$outDir = "assets/data/iqra"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

function Get-RandomBaseLetter {
    $idx = Get-Random -Maximum $baseLetters.Length
    return @{ "ar" = $baseLetters[$idx]; "lat" = $baseLatin[$idx] }
}

function Generate-Iqra-Json {
    param (
        [int]$level,
        [int]$totalPages,
        [string]$title
    )
    
    $pages = @()
    for ($i = 1; $i -le $totalPages; $i++) {
        $arText = ""
        $latText = ""
        
        $wordCount = 2 + [int][math]::Floor($i / 10) # progressive length
        
        for ($w = 0; $w -lt $wordCount; $w++) {
            $l1 = Get-RandomBaseLetter
            $l2 = Get-RandomBaseLetter
            
            if ($level -eq 1) {
                $arText += $l1.ar + "َ " + $l2.ar + "َ   "
                $latText += $l1.lat + "-" + $l2.lat + "   "
            } elseif ($level -eq 2) {
                $arText += $l1.ar + "َا " + $l2.ar + "َ   "
                $latText += $l1.lat + "a-" + $l2.lat + "   "
            } elseif ($level -eq 3) {
                $harakatAr = @("َ", "ِ", "ُ")
                $harakatLat = @("a", "i", "u")
                $h1 = Get-Random -Maximum 3
                $h2 = Get-Random -Maximum 3
                $arText += $l1.ar + $harakatAr[$h1] + " " + $l2.ar + $harakatAr[$h2] + "   "
                $latText += $l1.lat.Substring(0, $l1.lat.Length-1) + $harakatLat[$h1] + "-" + $l2.lat.Substring(0, $l2.lat.Length-1) + $harakatLat[$h2] + "   "
            } elseif ($level -eq 4) {
                $arText += $l1.ar + "َنْ " + $l2.ar + "ٌ   "
                $latText += $l1.lat.Substring(0, $l1.lat.Length-1) + "an-" + $l2.lat.Substring(0, $l2.lat.Length-1) + "un   "
            } elseif ($level -eq 5) {
                $arText += "اَلْ" + $l1.ar + "َ" + $l2.ar + "ُ   "
                $latText += "al-" + $l1.lat + $l2.lat.Substring(0, $l2.lat.Length-1) + "u   "
            } else {
                $arText += "بِسْمِ " + $l1.ar + "َ" + $l2.ar + "ِ   "
                $latText += "bismi " + $l1.lat + $l2.lat.Substring(0, $l2.lat.Length-1) + "i   "
            }
        }
        
        $pages += @{
            page = $i
            title = $title
            arabic = $arText.Trim()
            latin = $latText.Trim()
            audio = "iqra${level}_page${i}.mp3"
        }
    }
    
    $jsonObj = @{
        level = $level
        title = $title
        pages = $pages
    }
    
    $jsonString = $jsonObj | ConvertTo-Json -Depth 5 -Compress
    # Unescape unicode (PowerShell ConvertTo-Json escapes non-ascii by default in Windows PowerShell 5.1 depending on version, let's write with UTF8)
    $jsonString | Out-File -FilePath "$outDir/iqra$level.json" -Encoding UTF8
    Write-Host "Generated iqra$level.json"
}

Generate-Iqra-Json -level 1 -totalPages 10 -title "Iqra 1"
Generate-Iqra-Json -level 2 -totalPages 20 -title "Iqra 2"
Generate-Iqra-Json -level 3 -totalPages 25 -title "Iqra 3"
Generate-Iqra-Json -level 4 -totalPages 30 -title "Iqra 4"
Generate-Iqra-Json -level 5 -totalPages 35 -title "Iqra 5"
Generate-Iqra-Json -level 6 -totalPages 40 -title "Iqra 6"
