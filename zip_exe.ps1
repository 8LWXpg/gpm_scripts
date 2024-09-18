<#
.SYNOPSIS
	Download and extract a file from a GitHub release.
.PARAMETER repo
	GitHub repository name.
.PARAMETER pattern
	Target asset pattern.
.NOTES
	7z cli must be in the PATH.
.EXAMPLE
	gpm repo <repo> a <exe_name> gh_exe <user/repo> <target_assets>
#>

param (
	[Parameter(Mandatory)]
	[string]$repo,

	[Parameter(Mandatory)]
	[string]$pattern,

	[Parameter(Mandatory)]
	[string]$name,

	[string]$etag
)
$ErrorActionPreference = 'Stop'

try {
	# absolute path is required, because current directory is not the same as the script directory
	$file_name, $etag = ~/.gpm/scripts/lib/gh_dl.ps1 -repo $repo -ScriptBlock { $_.name -match $pattern } -etag $etag

	switch -regex ($file_name) {
		'\.tar.gz' { tar -xzf $file_name $name }
		'\.tar.xz' { tar -xJf $file_name $name }
		Default { 7z e $file_name '-o.' -r $name -y -bso0 -bsp0 }
	}

	if ($?) {
		Remove-Item $file_name
	} else {
		exit 1
	}
} catch {
	[Console]::Error.WriteLine($_.Exception.Message)
	exit 1
}

$etag