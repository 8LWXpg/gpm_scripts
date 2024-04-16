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

$response = Invoke-RestMethod $url
$result = $response.assets | Where-Object { $_.name.Contains('x64') }

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

7z x $file_name "-o$dest" -y -bso0 -bsp0 && Remove-Item $file_name

$etag