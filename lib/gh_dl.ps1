[OutputType([string])]
param (
	[Parameter(Mandatory)]
	[string]
	$repo,

	# Script block to match target assets, reutn bool.
	[Parameter(Mandatory)]
	[scriptblock]
	$ScriptBlock
)

$url = "https://api.github.com/repos/$repo/releases/latest"
$response = Invoke-RestMethod $url
$tag = $response.tag_name
$result = $response.assets | Where-Object -FilterScript $ScriptBlock

$dl_url = $result[0].browser_download_url
$file_name = $result[0].name
$r = if ($etag) {
	try {
		Invoke-WebRequest $dl_url -Headers @{ 'If-None-Match' = $etag }
	} catch [System.Net.Http.HttpRequestException] {
		if ($_.Exception.StatusCode.value__ -eq 304) {
			throw "$($PSStyle.Foreground.BrightCyan)$repo@$tag$($PSStyle.Reset) is up to date."
		}
		throw $_
	} catch {
		throw $_
	}
} else {
	Invoke-WebRequest $dl_url
}
[Console]::Error.WriteLine("Updated to $($PSStyle.Foreground.BrightCyan)$repo@$tag$($PSStyle.Reset).")
$etag = $r.Headers.ETag
Set-Content $file_name $r.Content -AsByteStream

$file_name, $etag