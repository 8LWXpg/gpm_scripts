<#
.SYNOPSIS
	Download and extract a file from a GitHub release.
.DESCRIPTION
	Find the latest release in GitHub API URL $url, download the first file that matches $pattern, extract the file $name to $dest.
.NOTES
	7z cli must be in the PATH.
.LINK
	https://github.com/8LWXpg/gpm_scripts
.EXAMPLE
	Download the latest release if ETAG is not matched.
	gpm repo <repo> a <exe_name> gh_exe <user/repo> <target_assets>
#>


param (
	[Parameter(Mandatory)]
	[string]$repo,

	# Pattern to match target assets, like 'x86_64-pc-windows'
	[Parameter(Mandatory)]
	[string]$pattern,

	# File name to extract
	[Parameter(Mandatory)]
	[string]$name,

	[string]$etag
)
$ErrorActionPreference = 'Stop'

$url = "https://api.github.com/repos/$repo/releases/latest"
try {
	# absolute path is required, because current directory is not the same as the script directory
	$file_name, $etag = ~/.gpm/scripts/lib/gh_dl.ps1 -url $url -ScriptBlock { $_.name -match $pattern }
} catch {
	[Console]::Error.WriteLine($_.Exception.Message)
	exit 1
}

Rename-Item $file_name $name

$etag