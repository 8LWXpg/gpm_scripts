<#
.SYNOPSIS
	Download and extract a PowerToys Run Plugin from a GitHub release.
.DESCRIPTION
	Find the latest release in GitHub API URL $url, extract the content to $dest
.LINK
	https://github.com/8LWXpg/gpm_scripts
.EXAMPLE
	Download the latest release if ETAG is not matched.
	ptr.ps1 -url <URL> -name <NAME> -dest <DEST> -etag <ETAG>
#>


param (
	[Parameter(Mandatory)]
	[string]
	$url,

	[Parameter(Mandatory)]
	[string]
	$name,

	[Parameter(Mandatory)]
	[string]
	$dest,

	[string]
	$etag
)
$ErrorActionPreference = 'Stop'

$file_name, $etag = ~/.gpm/scripts/lib/gh_dl.ps1 -url $url -ScriptBlock { $_.name.Contains('x64') }
if ($LASTEXITCODE -ne 0) {
	exit $LASTEXITCODE
}

7z x $file_name "-o$dest" -y -bso0 -bsp0 && Remove-Item $file_name

$etag