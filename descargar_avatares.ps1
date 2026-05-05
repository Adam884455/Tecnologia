$outputDir = "c:\Users\adame\Downloads\1-16\imagenes"

if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir }

Write-Host "Iniciando descarga rapida de 240 avatares de relleno (del 17 al 256)..."

$baseUrl = "https://api.dicebear.com/7.x/adventurer/png?seed="

17..256 | ForEach-Object {
    $n = $_
    $url = $baseUrl + "Avatar$n" + "&backgroundColor=b6e3f4,c0aede,d1d4f9"
    $file = "$outputDir\$n.png"
    
    if (-not (Test-Path $file)) {
        try {
            Invoke-WebRequest -Uri $url -OutFile $file -UseBasicParsing | Out-Null
            if ($n % 20 -eq 0) { Write-Host "Progreso: Avatar #$n descargado." }
        } catch { }
    }
}

Write-Host "`n¡Descarga terminada! Ahora tu Modo Hardcore está lleno de avatares."
