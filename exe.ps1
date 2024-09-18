<#
.SYNOPSIS
	Download and extract a file from a GitHub release.
.PARAMETER repo
	GitHub repository name.
.PARAMETER pattern
	Target asset pattern
.NOTES
	7z cli must be in the PATH.
.EXAMPLE
	gpm repo <repo> a <exe> exe <user/repo> <target_assets>
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

try {
	# absolute path is required, because current directory is not the same as the script directory
	$file_name, $etag = ~/.gpm/scripts/lib/gh_dl.ps1 -repo $repo -ScriptBlock { $_.name -match $pattern } -etag $etag

	if ($name -ne $file_name) {
		Remove-Item $name -ErrorAction SilentlyContinue
		Rename-Item -LiteralPath $file_name $name -Force
	}
} catch {
	[Console]::Error.WriteLine($_.Exception.Message)
	exit 1
}

$etag