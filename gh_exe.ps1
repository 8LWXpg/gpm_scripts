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
	gh.ps1 -name <NAME> -dest <DEST> -etag <ETAG> <URL> <PATTERN>
#>


param (
	[Parameter(Mandatory)]
	[string]$url,

	[Parameter(Mandatory)]
	[string]$pattern,

	# File name to extract
	[Parameter(Mandatory)]
	[string]$name,

	# Destination folder
	[Parameter(Mandatory)]
	[string]$dest,

	[string]$etag
)

# absolute path is required, because current directory is not the same as the script directory

try {
	$file_name, $etag = ~/.gpm/scripts/lib/gh_dl.ps1 -url $url -ScriptBlock { $_.name -match $pattern }
} catch {
	exit 1
}

7z e $file_name "-o$dest" -r $name -y -bso0 -bsp0 && Remove-Item $file_name

$etag