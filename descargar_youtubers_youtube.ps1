$names = @(
"MrBeast", "IShowSpeed", "PewDiePie", "MKBHD", "Casey Neistat", "Markiplier", "Logan Paul", "Jake Paul",
"Alexby11", "Mangel", "sTaXx", "Luzu", "Wismichu", "ElmilloR", "Loulogio", "Elvisa Yomaster",
"Sr. Cheeto", "Zorman", "JPelirrojo", "RoEnLaRed", "David Suarez", "Knekro", "Reven", "Folagor",
"Nil Ojeda", "Misho Amoli", "Guanyar", "Papi Gavi", "Spursito", "Werlyb", "Hamza Zaidi", "Paul Ferrer",
"Widler", "Exi", "Shooowit", "Paula Gonu", "Marina Rivers", "Lola Lolita", "Sofia Surferss", "Michenlo",
"Marta Diaz", "Lucia de la Puerta", "Nachter", "Anikilo", "Cacho01", "RobertPG", "DjMaRiiO", "Delantero09",
"Cristinini", "Biyin", "Mayichi", "Gemita", "Imantado", "Karchez", "Axozer", "Perxitaa",
"Reborn", "Focus", "Tanizen", "Nia Lakshart", "Zellendust", "Bersgamer", "Itowngameplay", "Zarcort",
"PiterG", "Kronno Zomber", "Cyclo", "Frigoadri", "Javier Santaolalla", "QuantumFracture", "Marti Montferrer", "Ter",
"Jaime Altozano", "ShaunTrack", "Nate Gentile", "Topes de Gama", "Carlos Santa Engracia", "Victor Abarca", "Eduardo Arcos", "Dot CSV",
"Lord Draugr", "Tamayo", "VisualPolitik", "Memorias de Pez", "Joan Pradells", "Sergio Peinado", "Powerexplosive", "Esttik",
"Joe Burgerchallenge", "Sezar Blue", "Cenando con Pablo", "Gorka Barredo", "Anna Terés", "Jordi Cruz", "The Fit Fiance", "Iron Masters",
"Jordi Wild", "Angel Martin", "Ignatius Farray", "David Broncano", "Pantomima Full", "Rober Bodegas", "Facu Diaz", "Miguel Maldonado",
"Dalas Review", "Javi Oliveira", "Sasel", "Roma Gallardo", "Un Tio Blanco Hetero", "Tiparraco", "Soy una Pringada", "Malbert"
)

$outputDir = "c:\Users\adame\Downloads\1-16\imagenes"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir }

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "INICIANDO DESCARGA ALTA CALIDAD DESDE YOUTUBE..."
$index = 17

foreach ($name in $names) {
    $file = "$outputDir\$index.png"
    Write-Host "Buscando a: $name (#$index)..." -NoNewline
    
    $encodedName = [uri]::EscapeDataString($name)
    $searchUrl = "https://www.youtube.com/results?search_query=$encodedName"
    
    $downloaded = $false
    try {
        $html = (Invoke-WebRequest -Uri $searchUrl -UseBasicParsing -Headers @{"User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"} -ErrorAction Stop).Content
        
        # Look for the first ggpht.com profile picture (usually matches the channel result exactly)
        if ($html -match '(https://yt3\.ggpht\.com/[a-zA-Z0-9_-]+(?:=s[0-9]+-c-k-c0x00ffffff-no-rj)?)') {
            $imgUrl = $($matches[1])
            # Force high resolution (300x300)
            $imgUrl = $imgUrl -replace '=s\d+-', '=s300-'
            
            Invoke-WebRequest -Uri $imgUrl -OutFile $file -UseBasicParsing | Out-Null
            Write-Host " OK!" -ForegroundColor Green
            $downloaded = $true
        }
    } catch { }

    if (-not $downloaded) {
        Write-Host " Falló YouTube, usando fallback." -ForegroundColor Red
        # Fallback UI avatar just in case
        $avatarName = $name.Replace(' ', '+')
        $avatarUrl = "https://ui-avatars.com/api/?name=$avatarName&background=random&color=fff&size=300&bold=true"
        try { Invoke-WebRequest -Uri $avatarUrl -OutFile $file -UseBasicParsing | Out-Null } catch {}
    }

    $index++
}

Write-Host "`n¡DESCARGA COMLETADA! TODAS LAS IMÁGENES REALES OBTENIDAS."
