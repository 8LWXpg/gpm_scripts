[OutputType([string])]
param (
	[Parameter(Mandatory)]
	[string]
	$url,

	# Script block to match target assets, reutn bool.
	[Parameter(Mandatory)]
	[scriptblock]
	$ScriptBlock
)

$response = Invoke-RestMethod $url
$result = $response.assets | Where-Object -FilterScript $ScriptBlock

$dl_url = $result[0].browser_download_url
$file_name = $result[0].name
$r = if ($etag) {
	try {
		Invoke-WebRequest $dl_url -Headers @{ 'If-None-Match' = $etag }
	} catch [System.Net.Http.HttpRequestException] {
		if ($_.Exception.StatusCode.value__ -eq 304) {
			throw "$($PSStyle.Foreground.BrightCyan)$file_name$($PSStyle.Reset) is up to date."
		}
		throw $_
	} catch {
		throw $_
	}
} else {
	Invoke-WebRequest $dl_url
}
$etag = $r.Headers.ETag
Set-Content $file_name $r.Content -AsByteStream

$file_name, $etag