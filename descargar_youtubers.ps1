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
"Jaime Altozano", "ShaunTrack", "Nate Gentile", "Topes de Gama", "Topes de Gama 2", "Victor Abarca", "Eduardo Arcos", "Dot CSV",
"Lord Draugr", "Tamayo", "VisualPolitik", "Memorias de Pez", "Joan Pradells", "Sergio Peinado", "Powerexplosive", "Esttik",
"Joe Burgerchallenge", "Sezar Blue", "Cenando con Pablo", "Gorka Barredo", "Anna Terés", "Jordi Cruz", "The Fit Fiance", "Iron Masters",
"Jordi Wild", "Angel Martin", "Ignatius Farray", "David Broncano", "Pantomima Full", "Rober Bodegas", "Facu Diaz", "Miguel Maldonado",
"Dalas Review", "Javi Oliveira", "Sasel", "Roma Gallardo", "Un Tio Blanco Hetero", "Tiparraco", "Soy una Pringada", "Malbert"
)

$outputDir = "c:\Users\adame\Downloads\1-16\imagenes"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir }

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$index = 17

foreach ($name in $names) {
    $file = "$outputDir\$index.png"

    $downloaded = $false
    $encodedName = $name.Replace(' ', '_')
    $wikiUrl = "https://es.wikipedia.org/api/rest_v1/page/summary/$encodedName"
    
    try {
        $response = Invoke-RestMethod -Uri $wikiUrl -Headers @{"User-Agent"="MiJuego/1.0"} -ErrorAction Stop
        if ($response.thumbnail -and $response.thumbnail.source) {
            $imgUrl = $response.thumbnail.source
            $imgUrl = $imgUrl -replace '/\d+px-', '/300px-'
            Invoke-WebRequest -Uri $imgUrl -OutFile $file -UseBasicParsing | Out-Null
            $downloaded = $true
        }
    } catch { }

    if (-not $downloaded) {
        try {
            $wikiUrlEn = "https://en.wikipedia.org/api/rest_v1/page/summary/$encodedName"
            $response = Invoke-RestMethod -Uri $wikiUrlEn -Headers @{"User-Agent"="MiJuego/1.0"} -ErrorAction Stop
            if ($response.thumbnail -and $response.thumbnail.source) {
                $imgUrl = $response.thumbnail.source
                $imgUrl = $imgUrl -replace '/\d+px-', '/300px-'
                Invoke-WebRequest -Uri $imgUrl -OutFile $file -UseBasicParsing | Out-Null
                $downloaded = $true
            }
        } catch { }
    }

    if (-not $downloaded) {
        # Fallback UI avatar
        $avatarName = $name.Replace(' ', '+')
        $avatarUrl = "https://ui-avatars.com/api/?name=$avatarName&background=random&color=fff&size=200&bold=true"
        try { Invoke-WebRequest -Uri $avatarUrl -OutFile $file -UseBasicParsing | Out-Null } catch {}
    }

    $index++
}
