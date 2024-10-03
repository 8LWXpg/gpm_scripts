<#
.SYNOPSIS
    Copy a directory to repo root.
.PARAMETER path
    Path to the directory.
.EXAMPLE
    gpm repo <repo> a <name> dir <path> [-c]
#>

param (
    # path to the directory
    [Parameter(Mandatory)]
    [string]
    $path,

    [string]
    $dir,

    # dir name
    [Parameter(Mandatory)]
    [string]$name
)

try {
    if ($dir) {
        Push-Location
        Set-Location $dir
    }
    $path = (Resolve-Path $path).Path
    Pop-Location
    Remove-Item -r $name -ErrorAction Ignore
    Copy-Item $path $name -Recurse -Force
} catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 1
}
