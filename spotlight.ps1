[CmdletBinding()]
param(
    [switch]$KeepImage,
    [string]$BackgroundsPath = "$env:USERPROFILE\.local\share\backgrounds",
    [switch]$SetLockScreen,
    [switch]$SetDesktop
)

# Functions
function SetLockScreenImage {
    param(
        [string]$Path
    )
    Add-Type -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;
        
        public class Wallpaper {
            [DllImport("user32.dll", CharSet = CharSet.Auto)]
            public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
        }
"@
    $SPI_SETLOCKSCREEN = 0x0017
    $NULL = 0
    [Wallpaper]::SystemParametersInfo($SPI_SETLOCKSCREEN, $NULL, $Path, $NULL)
}

function SetDesktopWallpaper {
    param(
        [string]$Path
    )
    Add-Type -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;
        
        public class Wallpaper {
            [DllImport("user32.dll", CharSet = CharSet.Auto)]
            public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
        }
"@
    $SPI_SETDESKWALLPAPER = 0x0014
    $NULL = 0
    [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, $NULL, $Path, $NULL)
}

# Main Script
$uri = "https://arc.msn.com/v3/Delivery/Placement?pid=209567&fmt=json&cdm=1&lc=en,en-US&ctry=US"
$response = Invoke-RestMethod -Uri $uri -Headers @{ "User-Agent" = "WindowsShellClient/0" }
$item = $response.batchrsp.items[0].item | ConvertFrom-Json
$landscapeUrl = $item.ad.image_fullscreen_001_landscape.u
$title = $item.ad.title_text.tx

if(-Not (Test-Path $BackgroundsPath)) {
    New-Item -ItemType Directory -Path $BackgroundsPath
}

$imagePath = Join-Path $BackgroundsPath "$((Get-Date).ToString('yy-MM-dd-HH-mm-ss'))-$title.jpg"
Invoke-WebRequest -Uri $landscapeUrl -OutFile $imagePath

# If KeepImage is not passed, delete previous image
if (!$KeepImage) {
    Remove-Item "$BackgroundsPath\*.jpg" -Exclude $(Split-Path $imagePath -Leaf)
}

# Set lockscreen and/or desktop wallpaper
if ($SetLockScreen) {
    SetLockScreenImage -Path $imagePath
}

if ($SetDesktop) {
    SetDesktopWallpaper -Path $imagePath
}
