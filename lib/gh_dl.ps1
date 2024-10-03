[OutputType([string])]
param (
	[Parameter(Mandatory)]
	[string]
	$repo,

	# Script block to match target assets, reutn bool.
	[Parameter(Mandatory)]
	[scriptblock]
	$ScriptBlock,

	# Current tag
	[string]$tag
)

$url = "https://api.github.com/repos/$repo/releases/latest"
$response = Invoke-RestMethod $url
$new_tag = $response.tag_name
if ($tag -eq $new_tag) {
	throw "$($PSStyle.Foreground.BrightCyan)$repo@$tag$($PSStyle.Reset) is up to date."
}
$result = $response.assets | Where-Object -FilterScript $ScriptBlock

$dl_url = $result[0].browser_download_url
$file_name = $result[0].name
$r = try {
	Invoke-WebRequest $dl_url
} catch {
	throw $_
}
[Console]::Error.WriteLine("Updated to $($PSStyle.Foreground.BrightCyan)$repo@$new_tag$($PSStyle.Reset).")
Set-Content $file_name $r.Content -AsByteStream

$file_name, $new_tag