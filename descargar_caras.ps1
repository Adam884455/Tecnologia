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

$targetIndices = @(21, 22, 23, 24, 25, 27, 29, 30, 31, 32, 33, 34, 35, 39, 40, 41, 43, 45, 47, 51, 54, 55, 61, 62, 63, 64)
$outputDir = "c:\Users\adame\Downloads\1-16\imagenes"
$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

foreach ($i in $targetIndices) {
    if ($i -ge 17 -and $i -le ($names.Length + 16)) {
        $name = $names[$i - 17]
        Write-Host "Fetching image for index $i ($name)..."
        $encodedName = [uri]::EscapeDataString($name + " youtuber cara profile")
        
        try {
            $html = (Invoke-WebRequest -Uri "https://www.bing.com/images/search?q=$encodedName" -UseBasicParsing -Headers @{"User-Agent"=$ua}).Content
            
            # Fetch the first valid URL
            if ($html -match 'murl&quot;:&quot;(https[^\&]+)') {
                $imgUrl = $matches[1]
                $file = "$outputDir\$i.png"
                Write-Host "Downloading $imgUrl -> $file"
                Invoke-WebRequest -Uri $imgUrl -OutFile $file -UseBasicParsing | Out-Null
            } else {
                Write-Host "No match found for $name" -ForegroundColor Red
            }
        } catch {
            Write-Host "Error fetching $name" -ForegroundColor Red
        }
    }
}
