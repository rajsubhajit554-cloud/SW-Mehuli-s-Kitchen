Add-Type -AssemblyName System.Drawing

$baseDir = "d:\Dripza Water Business\all Clint\Mehuli's Kitchen\websites\SW Mehuli's Kitchen"
$assetsDir = Join-Path $baseDir "assets"
$outputDir = Join-Path $assetsDir "food_items"

if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

function Crop-Dish {
    param(
        [System.Drawing.Bitmap]$sourceBmp,
        [int]$cellX, [int]$cellY, [int]$cellW, [int]$cellH,
        [double]$dishMaxHFrac,
        [string]$filename,
        [int]$targetSize = 500,
        [int]$pad = 18
    )
    
    $outputPath = Join-Path $outputDir $filename
    
    # 1. Scan boundary for dish bounding box inside [cellX, cellY, cellW, cellH * dishMaxHFrac]
    $scanMaxY = [int]($cellY + $cellH * $dishMaxHFrac)
    $minX = $cellX + $cellW
    $maxX = $cellX
    $minY = $scanMaxY
    $maxY = $cellY
    
    # Non-black threshold: step by 2 for speed
    for ($y = $cellY; $y -lt $scanMaxY; $y += 2) {
        for ($x = $cellX; $x -lt ($cellX + $cellW); $x += 2) {
            $px = $sourceBmp.GetPixel($x, $y)
            if (($px.R + $px.G + $px.B) -gt 45 -and ($px.R -gt 18 -or $px.G -gt 18 -or $px.B -gt 18)) {
                if ($x -lt $minX) { $minX = $x }
                if ($x -gt $maxX) { $maxX = $x }
                if ($y -lt $minY) { $minY = $y }
                if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }
    
    # Fallback if detection found nothing
    if ($minX -ge $maxX -or $minY -ge $maxY) {
        $minX = $cellX
        $maxX = $cellX + $cellW - 1
        $minY = $cellY
        $maxY = $scanMaxY - 1
    }
    
    # Add margin around dish while staying strictly above scanMaxY and inside cell bounds
    $margin = 6
    $cropX = [Math]::Max($cellX, $minX - $margin)
    $cropY = [Math]::Max($cellY, $minY - $margin)
    $cropR = [Math]::Min($cellX + $cellW - 1, $maxX + $margin)
    $cropB = [Math]::Min($scanMaxY - 1, $maxY + $margin)
    
    $cropW = [Math]::Max(1, $cropR - $cropX + 1)
    $cropH = [Math]::Max(1, $cropB - $cropY + 1)
    
    # Create square target canvas
    $targetBmp = New-Object System.Drawing.Bitmap $targetSize, $targetSize
    $g = [System.Drawing.Graphics]::FromImage($targetBmp)
    $g.Clear([System.Drawing.Color]::Black)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    
    $availW = $targetSize - 2 * $pad
    $availH = $targetSize - 2 * $pad
    $scale = [Math]::Min($availW / $cropW, $availH / $cropH)
    
    $drawW = [int]($cropW * $scale)
    $drawH = [int]($cropH * $scale)
    $drawX = [int](($targetSize - $drawW) / 2)
    $drawY = [int](($targetSize - $drawH) / 2)
    
    $srcRect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropW, $cropH
    $dstRect = New-Object System.Drawing.Rectangle $drawX, $drawY, $drawW, $drawH
    
    $g.DrawImage($sourceBmp, $dstRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()
    
    $targetBmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $targetBmp.Dispose()
}

$sheets = @(
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_24_30 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 512; H = 512; Frac = 0.80; File = "egg_laccha_roll.png" },
            @{ X = 512; Y = 0; W = 512; H = 512; Frac = 0.80; File = "egg_chicken_roll.png" },
            @{ X = 1024; Y = 0; W = 512; H = 512; Frac = 0.80; File = "chicken_kathi_roll.png" },
            @{ X = 0; Y = 512; W = 512; H = 512; Frac = 0.80; File = "chicken_bhuna_roll.png" },
            @{ X = 512; Y = 512; W = 512; H = 512; Frac = 0.80; File = "paneer_roll.png" },
            @{ X = 1024; Y = 512; W = 512; H = 512; Frac = 0.80; File = "chicken_cheese_special_roll.png" }
        )
    },
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_24_33 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 512; H = 512; Frac = 0.80; File = "veg_manchurian.png" },
            @{ X = 512; Y = 0; W = 512; H = 512; Frac = 0.80; File = "paneer_chili.png" },
            @{ X = 1024; Y = 0; W = 512; H = 512; Frac = 0.80; File = "paneer_65.png" },
            @{ X = 0; Y = 512; W = 512; H = 512; Frac = 0.80; File = "paneer_tikka_kabab.png" },
            @{ X = 512; Y = 512; W = 512; H = 512; Frac = 0.80; File = "paneer_banjara_kabab.png" },
            @{ X = 1024; Y = 512; W = 512; H = 512; Frac = 0.80; File = "paneer_reshmi_kabab.png" }
        )
    },
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_24_35 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 512; H = 341; Frac = 0.79; File = "tandoori_chicken.png" },
            @{ X = 512; Y = 0; W = 512; H = 341; Frac = 0.79; File = "chicken_tikka_kabab.png" },
            @{ X = 1024; Y = 0; W = 512; H = 341; Frac = 0.79; File = "chicken_reshmi_kabab.png" },
            @{ X = 0; Y = 341; W = 512; H = 341; Frac = 0.79; File = "chicken_malai_kabab.png" },
            @{ X = 512; Y = 341; W = 512; H = 341; Frac = 0.79; File = "chicken_hariyali_kabab.png" },
            @{ X = 1024; Y = 341; W = 512; H = 341; Frac = 0.79; File = "nazrana_seekh_kabab.png" },
            @{ X = 0; Y = 682; W = 512; H = 342; Frac = 0.79; File = "dahi_lahsuni_chicken_kabab.png" },
            @{ X = 512; Y = 682; W = 512; H = 342; Frac = 0.79; File = "chef_special_chicken_kabab.png" },
            @{ X = 1024; Y = 682; W = 512; H = 342; Frac = 0.79; File = "fish_tikka.png" }
        )
    },
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_24_47 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 512; H = 341; Frac = 0.79; File = "chicken_steamed_momo.png" },
            @{ X = 512; Y = 0; W = 512; H = 341; Frac = 0.79; File = "chicken_fried_momo.png" },
            @{ X = 1024; Y = 0; W = 512; H = 341; Frac = 0.79; File = "chicken_pan_fried_momo.png" },
            @{ X = 0; Y = 341; W = 512; H = 341; Frac = 0.79; File = "chicken_manchow_soup.png" },
            @{ X = 512; Y = 341; W = 512; H = 341; Frac = 0.79; File = "chicken_hot_and_sour_soup.png" },
            @{ X = 1024; Y = 341; W = 512; H = 341; Frac = 0.79; File = "french_onion_soup.png" },
            @{ X = 0; Y = 682; W = 512; H = 342; Frac = 0.79; File = "chicken_lung_fung_soup.png" },
            @{ X = 512; Y = 682; W = 512; H = 342; Frac = 0.79; File = "chicken_tom_yum_soup.png" },
            @{ X = 1024; Y = 682; W = 512; H = 342; Frac = 0.79; File = "chicken_coriander_soup.png" }
        )
    },
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_24_50 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 512; H = 341; Frac = 0.79; File = "paneer_pakora.png" },
            @{ X = 512; Y = 0; W = 512; H = 341; Frac = 0.79; File = "panko_fish_fry.png" },
            @{ X = 1024; Y = 0; W = 512; H = 341; Frac = 0.79; File = "fish_finger.png" },
            @{ X = 0; Y = 341; W = 512; H = 341; Frac = 0.79; File = "chicken_pakora.png" },
            @{ X = 512; Y = 341; W = 512; H = 341; Frac = 0.79; File = "crunchy_chicken_finger.png" },
            @{ X = 1024; Y = 341; W = 512; H = 341; Frac = 0.79; File = "chicken_nuggets.png" },
            @{ X = 220; Y = 682; W = 1096; H = 342; Frac = 0.79; File = "omelet.png" }
        )
    },
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_24_52 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 384; H = 341; Frac = 0.79; File = "chicken_chili.png" },
            @{ X = 384; Y = 0; W = 384; H = 341; Frac = 0.79; File = "chicken_manchurian.png" },
            @{ X = 768; Y = 0; W = 384; H = 341; Frac = 0.79; File = "chili_wings.png" },
            @{ X = 1152; Y = 0; W = 384; H = 341; Frac = 0.79; File = "chili_fish.png" },
            @{ X = 0; Y = 341; W = 384; H = 341; Frac = 0.79; File = "crispy_chicken.png" },
            @{ X = 384; Y = 341; W = 384; H = 341; Frac = 0.79; File = "chicken_65.png" },
            @{ X = 768; Y = 341; W = 384; H = 341; Frac = 0.79; File = "garlic_chicken.png" },
            @{ X = 1152; Y = 341; W = 384; H = 341; Frac = 0.79; File = "hongkong_chicken.png" },
            @{ X = 0; Y = 682; W = 307; H = 342; Frac = 0.79; File = "hunan_chicken.png" },
            @{ X = 307; Y = 682; W = 307; H = 342; Frac = 0.79; File = "dragon_chicken.png" },
            @{ X = 614; Y = 682; W = 307; H = 342; Frac = 0.79; File = "western_chicken.png" },
            @{ X = 921; Y = 682; W = 307; H = 342; Frac = 0.79; File = "steam_fish.png" },
            @{ X = 1228; Y = 682; W = 308; H = 342; Frac = 0.79; File = "special_fish.png" }
        )
    },
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_24_54 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 512; H = 341; Frac = 0.79; File = "veg_hakka_noodles.png" },
            @{ X = 512; Y = 0; W = 512; H = 341; Frac = 0.79; File = "veg_schezwan_noodles.png" },
            @{ X = 1024; Y = 0; W = 512; H = 341; Frac = 0.79; File = "veg_hongkong_noodles.png" },
            @{ X = 0; Y = 341; W = 512; H = 341; Frac = 0.79; File = "egg_hakka_noodles.png" },
            @{ X = 512; Y = 341; W = 512; H = 341; Frac = 0.79; File = "chicken_hakka_noodles.png" },
            @{ X = 1024; Y = 341; W = 512; H = 341; Frac = 0.79; File = "chicken_hongkong_noodles.png" },
            @{ X = 0; Y = 682; W = 512; H = 342; Frac = 0.79; File = "chicken_schezwan_hakka_noodles.png" },
            @{ X = 512; Y = 682; W = 512; H = 342; Frac = 0.79; File = "chicken_singapore_noodles.png" },
            @{ X = 1024; Y = 682; W = 512; H = 342; Frac = 0.79; File = "chef_special_noodles.png" }
        )
    },
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_24_56 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 384; H = 341; Frac = 0.79; File = "veg_fried_rice.png" },
            @{ X = 384; Y = 0; W = 384; H = 341; Frac = 0.79; File = "veg_hongkong_rice.png" },
            @{ X = 768; Y = 0; W = 384; H = 341; Frac = 0.79; File = "chicken_fried_rice.png" },
            @{ X = 1152; Y = 0; W = 384; H = 341; Frac = 0.79; File = "chicken_schezwan_rice.png" },
            @{ X = 0; Y = 341; W = 384; H = 341; Frac = 0.79; File = "chicken_singapore_rice.png" },
            @{ X = 384; Y = 341; W = 384; H = 341; Frac = 0.79; File = "chef_special_rice.png" },
            @{ X = 768; Y = 341; W = 384; H = 341; Frac = 0.79; File = "egg_rice.png" },
            @{ X = 1152; Y = 341; W = 384; H = 341; Frac = 0.79; File = "steamed_rice.png" },
            @{ X = 0; Y = 682; W = 512; H = 342; Frac = 0.79; File = "jeera_rice.png" },
            @{ X = 512; Y = 682; W = 512; H = 342; Frac = 0.79; File = "veg_pulao.png" },
            @{ X = 1024; Y = 682; W = 512; H = 342; Frac = 0.79; File = "extra_rice.png" }
        )
    },
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_25_24 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 384; H = 256; Frac = 0.79; File = "chicken_biryani.png" },
            @{ X = 384; Y = 0; W = 384; H = 256; Frac = 0.79; File = "egg_biryani.png" },
            @{ X = 768; Y = 0; W = 384; H = 256; Frac = 0.79; File = "dal_fry.png" },
            @{ X = 1152; Y = 0; W = 384; H = 256; Frac = 0.79; File = "dal_tadka.png" },
            @{ X = 0; Y = 256; W = 384; H = 256; Frac = 0.79; File = "veg_tadka.png" },
            @{ X = 384; Y = 256; W = 384; H = 256; Frac = 0.79; File = "chana_masala.png" },
            @{ X = 768; Y = 256; W = 384; H = 256; Frac = 0.79; File = "paneer_tikka_masala.png" },
            @{ X = 1152; Y = 256; W = 384; H = 256; Frac = 0.79; File = "paneer_butter_masala.png" },
            @{ X = 0; Y = 512; W = 384; H = 256; Frac = 0.79; File = "paneer_do_pyaza.png" },
            @{ X = 384; Y = 512; W = 384; H = 256; Frac = 0.79; File = "kadai_paneer.png" },
            @{ X = 768; Y = 512; W = 384; H = 256; Frac = 0.79; File = "paneer_lahori.png" },
            @{ X = 1152; Y = 512; W = 384; H = 256; Frac = 0.79; File = "paneer_makhani.png" },
            @{ X = 0; Y = 768; W = 384; H = 256; Frac = 0.79; File = "veg_lajawab.png" },
            @{ X = 384; Y = 768; W = 384; H = 256; Frac = 0.79; File = "mix_veg.png" },
            @{ X = 768; Y = 768; W = 384; H = 256; Frac = 0.79; File = "veg_kolhapuri.png" },
            @{ X = 1152; Y = 768; W = 384; H = 256; Frac = 0.79; File = "veg_thali.png" }
        )
    },
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_25_26 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 307; H = 205; Frac = 0.77; File = "chicken_kasha.png" },
            @{ X = 307; Y = 0; W = 307; H = 205; Frac = 0.77; File = "chicken_do_pyaza.png" },
            @{ X = 614; Y = 0; W = 307; H = 205; Frac = 0.77; File = "chicken_kadai.png" },
            @{ X = 921; Y = 0; W = 307; H = 205; Frac = 0.77; File = "chicken_bharta.png" },
            @{ X = 1228; Y = 0; W = 308; H = 205; Frac = 0.77; File = "chicken_lahori.png" },

            @{ X = 0; Y = 205; W = 307; H = 205; Frac = 0.77; File = "chicken_kolhapuri.png" },
            @{ X = 307; Y = 205; W = 307; H = 205; Frac = 0.77; File = "butter_chicken.png" },
            @{ X = 614; Y = 205; W = 307; H = 205; Frac = 0.77; File = "chicken_tikka_masala.png" },
            @{ X = 921; Y = 205; W = 307; H = 205; Frac = 0.77; File = "murgh_musallam.png" },
            @{ X = 1228; Y = 205; W = 308; H = 205; Frac = 0.77; File = "chicken_angara.png" },

            @{ X = 0; Y = 410; W = 307; H = 205; Frac = 0.77; File = "chicken_patiala.png" },
            @{ X = 307; Y = 410; W = 307; H = 205; Frac = 0.77; File = "egg_curry.png" },
            @{ X = 614; Y = 410; W = 307; H = 205; Frac = 0.77; File = "egg_masala.png" },
            @{ X = 921; Y = 410; W = 307; H = 205; Frac = 0.77; File = "mutton_kasha.png" },
            @{ X = 1228; Y = 410; W = 308; H = 205; Frac = 0.77; File = "mutton_masala.png" },

            @{ X = 0; Y = 615; W = 307; H = 205; Frac = 0.77; File = "mutton_rogan_josh.png" },
            @{ X = 307; Y = 615; W = 307; H = 205; Frac = 0.77; File = "tawa_fish.png" },
            @{ X = 614; Y = 615; W = 307; H = 205; Frac = 0.77; File = "katla_fish_curry.png" },
            @{ X = 921; Y = 615; W = 307; H = 205; Frac = 0.77; File = "special_fish_curry.png" },
            @{ X = 1228; Y = 615; W = 308; H = 205; Frac = 0.77; File = "fish_curry_basa.png" },

            @{ X = 250; Y = 820; W = 500; H = 204; Frac = 0.77; File = "egg_tadka.png" },
            @{ X = 786; Y = 820; W = 500; H = 204; Frac = 0.77; File = "chicken_tadka.png" }
        )
    },
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_25_28 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 384; H = 341; Frac = 0.79; File = "tawa_roti.png" },
            @{ X = 384; Y = 0; W = 384; H = 341; Frac = 0.79; File = "tandoori_roti.png" },
            @{ X = 768; Y = 0; W = 384; H = 341; Frac = 0.79; File = "butter_naan.png" },
            @{ X = 1152; Y = 0; W = 384; H = 341; Frac = 0.79; File = "plain_naan.png" },
            @{ X = 0; Y = 341; W = 384; H = 341; Frac = 0.79; File = "laccha_paratha.png" },
            @{ X = 384; Y = 341; W = 384; H = 341; Frac = 0.79; File = "garlic_naan.png" },
            @{ X = 768; Y = 341; W = 384; H = 341; Frac = 0.79; File = "cheese_garlic_naan.png" },
            @{ X = 1152; Y = 341; W = 384; H = 341; Frac = 0.79; File = "masala_kulcha.png" },
            @{ X = 0; Y = 682; W = 512; H = 342; Frac = 0.79; File = "alu_paratha.png" },
            @{ X = 512; Y = 682; W = 512; H = 342; Frac = 0.79; File = "paneer_paratha.png" },
            @{ X = 1024; Y = 682; W = 512; H = 342; Frac = 0.79; File = "kashmiri_naan.png" }
        )
    },
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_25_30 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 307; H = 341; Frac = 0.79; File = "blue_lagoon_mocktail.png" },
            @{ X = 307; Y = 0; W = 307; H = 341; Frac = 0.79; File = "mojito_mocktail.png" },
            @{ X = 614; Y = 0; W = 307; H = 341; Frac = 0.79; File = "triple_virgin_mocktail.png" },
            @{ X = 921; Y = 0; W = 307; H = 341; Frac = 0.79; File = "lassi.png" },
            @{ X = 1228; Y = 0; W = 308; H = 341; Frac = 0.79; File = "sex_on_the_beach.png" },
            @{ X = 0; Y = 341; W = 307; H = 341; Frac = 0.79; File = "summer_cool.png" },
            @{ X = 307; Y = 341; W = 307; H = 341; Frac = 0.79; File = "pina_colada.png" },
            @{ X = 614; Y = 341; W = 307; H = 341; Frac = 0.79; File = "masala_cold_drinks.png" },
            @{ X = 921; Y = 341; W = 307; H = 341; Frac = 0.79; File = "fresh_lime_soda.png" },
            @{ X = 1228; Y = 341; W = 308; H = 341; Frac = 0.79; File = "mehulis_special_mocktail.png" },
            @{ X = 0; Y = 682; W = 512; H = 342; Frac = 0.79; File = "soda.png" },
            @{ X = 512; Y = 682; W = 512; H = 342; Frac = 0.79; File = "cold_drinks.png" },
            @{ X = 1024; Y = 682; W = 512; H = 342; Frac = 0.79; File = "mineral_water.png" }
        )
    },
    @{
        Name = "ChatGPT Image Sep 29, 2026, 10_25_32 AM.png"
        Items = @(
            @{ X = 0; Y = 0; W = 512; H = 512; Frac = 0.80; File = "tea.png" },
            @{ X = 512; Y = 0; W = 512; H = 512; Frac = 0.80; File = "lemon_tea.png" },
            @{ X = 1024; Y = 0; W = 512; H = 512; Frac = 0.80; File = "milk_tea.png" },
            @{ X = 0; Y = 512; W = 512; H = 512; Frac = 0.80; File = "coffee.png" },
            @{ X = 512; Y = 512; W = 512; H = 512; Frac = 0.80; File = "black_coffee.png" },
            @{ X = 1024; Y = 512; W = 512; H = 512; Frac = 0.80; File = "kesar_milk_tea.png" }
        )
    }
)

$totalProcessed = 0
foreach ($sheet in $sheets) {
    $sheetPath = Join-Path $assetsDir $sheet.Name
    if (-not (Test-Path $sheetPath)) {
        Write-Error "Sheet not found: $sheetPath"
        continue
    }
    
    $bmp = [System.Drawing.Bitmap]::FromFile($sheetPath)
    
    foreach ($item in $sheet.Items) {
        Crop-Dish -sourceBmp $bmp `
                  -cellX $item.X -cellY $item.Y -cellW $item.W -cellH $item.H `
                  -dishMaxHFrac $item.Frac `
                  -filename $item.File `
                  -targetSize 500 -pad 18
        $totalProcessed++
    }
    
    $bmp.Dispose()
}

Write-Output "DONE! Total processed images: $totalProcessed"
