[CmdletBinding()]
param (
    # Git remote url
    [Parameter(Mandatory)]
    [string]$git,

    # Path in git repo
    [Parameter(Mandatory)]
    [string]$path,

    [Parameter(Mandatory)]
    [string]$name
)
$ErrorActionPreference = 'Stop'

function Get-OrUpdateGitRepo {
    param (
        [Parameter(Mandatory = $true)]
        [string]$GitUrl
    )

    # Extract repo name from URL if target directory not specified
    $repoName = $GitUrl -replace '.*/', '' -replace '\.git$', ''

    # Check if the repository already exists
    $commitHash = if (Test-Path -Path "$repoName/.git") {
        Push-Location $repoName
        git pull > $null
        git rev-parse --short HEAD
        Pop-Location
    } else {
        git clone $GitUrl > $null
        Push-Location $repoName
        git rev-parse --short HEAD
        Pop-Location
    }

    [Console]::Error.WriteLine("$($PSStyle.Foreground.Cyan)Updated to$($PSStyle.Reset) $commitHash")

    $repoName
}

# main
try {
    mkdir git -ea ig > $null
    Push-Location git
    $repoName = Get-OrUpdateGitRepo $git
    Pop-Location
    New-Item -ItemType SymbolicLink -Value "./git/$repoName/$path" $name -Force

    # generate css import
    Get-ChildItem *.css | Select-Object -ExpandProperty FullName | ForEach-Object {
        "@import url(`"$([uri]::new($_).ToString())`");"
    } | Join-String -Separator "`n" | Out-File ../userChrome.css -NoNewline
} catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 1
}