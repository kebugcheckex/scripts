param(
    [Parameter(Mandatory)]
    [String]$inputFile
)

# ffprobe $inputFile
$file = Get-Item $inputFile
if (-not $file.Exists)
{
    Write-Output "The input file $inputFile does not exist"
    Exit
}
$container = Split-Path -Path $inputFile
$outputFile = "$container$($file.BaseName).720p$($file.Extension)"
# $outputFile = "R:\$($file.BaseName).720p$($file.Extension)"

ffmpeg `
    -hwaccel cuvid `
    -hwaccel_output_format cuda `
    -c:v h264_cuvid `
    -resize 1280x720 `
    -i $inputFile `
    -fps_mode passthrough `
    -c:a copy `
    -c:v h264_nvenc `
    -b:v 1M `
    $outputFile
