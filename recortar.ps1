Add-Type -AssemblyName System.Drawing

$inputDir  = "c:\Users\adame\Downloads\1-16\imagenes"
$tmpDir    = "c:\Users\adame\Downloads\1-16\tmp_crop"
$threshold = 240
$padding   = 15

if (-not (Test-Path $tmpDir)) { New-Item -ItemType Directory -Path $tmpDir | Out-Null }

1..16 | ForEach-Object {
    $n     = $_
    $path  = "$inputDir\$n.png"
    $tmp   = "$tmpDir\$n.png"
    Write-Host "Processing $n.png..."

    $bmp = [System.Drawing.Bitmap]::new($path)
    $w   = $bmp.Width
    $h   = $bmp.Height

    $top = $h; $bottom = 0; $left = $w; $right = 0

    for ($y = 0; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            $px = $bmp.GetPixel($x, $y)
            if ($px.R -lt $threshold -or $px.G -lt $threshold -or $px.B -lt $threshold) {
                if ($x -lt $left)   { $left   = $x }
                if ($x -gt $right)  { $right  = $x }
                if ($y -lt $top)    { $top    = $y }
                if ($y -gt $bottom) { $bottom = $y }
            }
        }
    }

    if ($left -gt $right -or $top -gt $bottom) {
        Write-Host "  No content found, skipping."
        $bmp.Dispose(); return
    }

    $left   = [Math]::Max(0, $left   - $padding)
    $top    = [Math]::Max(0, $top    - $padding)
    $right  = [Math]::Min($w - 1, $right  + $padding)
    $bottom = [Math]::Min($h - 1, $bottom + $padding)
    $cropW  = $right - $left + 1
    $cropH  = $bottom - $top + 1

    $rect    = [System.Drawing.Rectangle]::new($left, $top, $cropW, $cropH)
    $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
    $bmp.Dispose()   # release original file NOW

    # Make square with white background
    $side = [Math]::Max($cropW, $cropH)
    $sq   = [System.Drawing.Bitmap]::new($side, $side)
    $g    = [System.Drawing.Graphics]::FromImage($sq)
    $g.Clear([System.Drawing.Color]::White)
    $offX = [int](($side - $cropW) / 2)
    $offY = [int](($side - $cropH) / 2)
    $g.DrawImage($cropped, $offX, $offY, $cropW, $cropH)
    $g.Dispose(); $cropped.Dispose()

    # Save to temp first
    $sq.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $sq.Dispose()

    # Replace original
    Move-Item -Path $tmp -Destination $path -Force
    Write-Host "  OK: cropped ${cropW}x${cropH} -> square ${side}x${side}"
}

# Clean up temp dir
Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "`nAll done!"
