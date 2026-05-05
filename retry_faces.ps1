$targets = @{
    26 = "elrubiusOMG"
    30 = "Auron"
    64 = "Cristiano Ronaldo"
}

$outputDir = "c:\Users\adame\Downloads\1-16\imagenes"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

foreach ($index in $targets.Keys) {
    $name = $targets[$index]
    $file = "$outputDir\$index.png"
    Write-Host "Updating character #$index with $name..."
    
    $encodedWiki = $name.Replace(' ', '_')
    $wikiUrl = "https://es.wikipedia.org/api/rest_v1/page/summary/$encodedWiki"
    
    $downloaded = $false
    try {
        $response = Invoke-RestMethod -Uri $wikiUrl -Headers @{"User-Agent"="GameUpdater/1.0"} -ErrorAction Stop
        if ($response.thumbnail -and $response.thumbnail.source) {
            $imgUrl = $response.thumbnail.source
            $imgUrl = $imgUrl -replace '/\d+px-', '/600px-'
            Invoke-WebRequest -Uri $imgUrl -OutFile $file -UseBasicParsing | Out-Null
            $downloaded = $true
            Write-Host "  Successfully downloaded face from Wikipedia." -ForegroundColor Green
        }
    } catch { }

    if (-not $downloaded) {
        # Try YouTube with the new name
        try {
            $encodedName = [uri]::EscapeDataString($name)
            $searchUrl = "https://www.youtube.com/results?search_query=$encodedName"
            $html = (Invoke-WebRequest -Uri $searchUrl -UseBasicParsing -Headers @{"User-Agent"="Mozilla/5.0"} -ErrorAction Stop).Content
            if ($html -match '(https://yt3\.ggpht\.com/[a-zA-Z0-9_-]+(?:=s[0-9]+-c-k-c0x00ffffff-no-rj)?)') {
                $imgUrl = $($matches[1])
                $imgUrl = $imgUrl -replace '=s\d+-', '=s600-'
                Invoke-WebRequest -Uri $imgUrl -OutFile $file -UseBasicParsing | Out-Null
                $downloaded = $true
                Write-Host "  Successfully downloaded face from YouTube." -ForegroundColor Green
            }
        } catch { }
    }
}
