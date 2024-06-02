<#
.SYNOPSIS
	Download and extract a PowerToys Run Plugin from a GitHub release.
.DESCRIPTION
	Find the latest release in GitHub API URL $url, extract the content to $dest
.LINK
	https://github.com/8LWXpg/gpm_scripts
.EXAMPLE
	Download the latest release if ETAG is not matched.
	gpm repo <repo> a <plugin_name> ptr <user/repo>
#>


param (
	[Parameter(Mandatory)]
	[string]$repo,

	[Parameter(Mandatory)]
	[string]$name,

	[string]$etag
)
$ErrorActionPreference = 'Stop'

try {
	# absolute path is required, because current directory is not the same as the script directory
	$file_name, $etag = ~/.gpm/scripts/lib/gh_dl.ps1 -repo $repo -ScriptBlock { $_.name.Contains('x64') }
} catch {
	[Console]::Error.WriteLine($_.Exception.Message)
	exit 1
}

7z x $file_name '-o.' -y -bso0 -bsp0
if ($?) {
	Remove-Item $file_name
} else {
	exit 1
}

$etag