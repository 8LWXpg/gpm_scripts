<#
.SYNOPSIS
	Download and extract a file from a GitHub release.
.DESCRIPTION
	Find the latest release in GitHub API URL $url, download the first file that matches $pattern, extract the file $name to $dest.
.NOTES
	Prerequisite: 7z cli must be in the PATH.
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

$response = Invoke-RestMethod $url
$result = $response.assets | Where-Object { $_.name -match $pattern }

$dl_url = $result[0].browser_download_url
$file_name = $result[0].name
$r = if ($etag) {
	try {
		Invoke-WebRequest $dl_url -Headers @{ 'If-None-Match' = $etag }
	} catch [System.Net.Http.HttpRequestException] {
		if ($_.Exception.StatusCode.value__ -ne 304) {
			throw $_
		} else {
			exit 0
		}
	} catch {
		throw $_
	}
} else {
	Invoke-WebRequest $dl_url
}
$etag = $r.Headers.ETag
Set-Content $file_name $r.Content -AsByteStream

7z e $file_name "-o$dest" -r $name -y -bso0 -bsp0
if ($?) {
	Remove-Item $file_name
}

$etag