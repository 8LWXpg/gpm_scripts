<#
.SYNOPSIS
	Download and extract a PowerToys Run Plugin from a GitHub release.
.PARAMETER repo
	GitHub repository name.
.NOTES
	7z cli must be in the PATH.
.EXAMPLE
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