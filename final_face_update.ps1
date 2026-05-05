$targets = @{
    26 = "El Rubius"
    30 = "AuronPlay"
    51 = "Ibai"
    52 = "TheGrefg"
    53 = "DjMaRiiO"
    54 = "Vegetta777"
    55 = "Willyrex"
    61 = "Guanyar"
    62 = "Anas El Andalousi"
    64 = "Cristiano Ronaldo"
}

$outputDir = "c:\Users\adame\Downloads\1-16\imagenes"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir }

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

foreach ($index in $targets.Keys) {
    $name = $targets[$index]
    $file = "$outputDir\$index.png"
    Write-Host "Updating character #$index with $name..."
    
    $encodedName = [uri]::EscapeDataString($name)
    $searchUrl = "https://www.youtube.com/results?search_query=$encodedName"
    
    $downloaded = $false
    try {
        $html = (Invoke-WebRequest -Uri $searchUrl -UseBasicParsing -Headers @{"User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"} -ErrorAction Stop).Content
        
        if ($html -match '(https://yt3\.ggpht\.com/[a-zA-Z0-9_-]+(?:=s[0-9]+-c-k-c0x00ffffff-no-rj)?)') {
            $imgUrl = $($matches[1])
            $imgUrl = $imgUrl -replace '=s\d+-', '=s600-'
            Invoke-WebRequest -Uri $imgUrl -OutFile $file -UseBasicParsing | Out-Null
            $downloaded = $true
            Write-Host "  Successfully downloaded face from YouTube." -ForegroundColor Green
        }
    } catch { }

    if (-not $downloaded) {
        # Fallback to Wikipedia summary image
        try {
            $encodedWiki = $name.Replace(' ', '_')
            $wikiUrl = "https://es.wikipedia.org/api/rest_v1/page/summary/$encodedWiki"
            $response = Invoke-RestMethod -Uri $wikiUrl -Headers @{"User-Agent"="GameUpdater/1.0"} -ErrorAction Stop
            if ($response.thumbnail -and $response.thumbnail.source) {
                $imgUrl = $response.thumbnail.source
                $imgUrl = $imgUrl -replace '/\d+px-', '/600px-'
                Invoke-WebRequest -Uri $imgUrl -OutFile $file -UseBasicParsing | Out-Null
                $downloaded = $true
                Write-Host "  Successfully downloaded face from Wikipedia." -ForegroundColor Green
            }
        } catch { }
    }

    if (-not $downloaded) {
        Write-Host "  FAILED to download $name. Keeping existing or using fallback." -ForegroundColor Red
    }
}

Write-Host "Finished updating characters."
