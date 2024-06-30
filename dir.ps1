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

    [Parameter(Mandatory)]
    [string]
    $cwd,

    # dir name
    [Parameter(Mandatory)]
    [string]$name
)

try {
    Push-Location
    Set-Location $cwd
    $path = (Resolve-Path $path).Path
    Pop-Location
    Copy-Item $path $name -Recurse -Force
} catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 1
}
