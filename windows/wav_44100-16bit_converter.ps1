# PowerShell script to convert audio files to WAV format using ffmpeg

# Function to check if FFmpeg is installed
function Check-FFmpeg {
    $ffmpeg = Get-Command "ffmpeg" -ErrorAction SilentlyContinue
    if ($null -eq $ffmpeg) {
        Write-Host "ffmpeg could not be found. Please install ffmpeg to continue."
        exit
    } else {
        Write-Host "ffmpeg is installed."
    }
}

# Prompt user for the source and destination directories
$sourceDirectory = Read-Host "Enter the source directory path of your audio files"
$destinationDirectory = Read-Host "Enter the destination directory path for the converted WAV files"

# Check if the source directory exists
if (!(Test-Path $sourceDirectory)) {
    Write-Host "The source directory $sourceDirectory does not exist. Please enter a valid directory."
    exit
}

# Check if the destination directory exists, create it if not
if (!(Test-Path $destinationDirectory)) {
    Write-Host "The destination directory $destinationDirectory does not exist. Creating directory."
    New-Item -ItemType Directory -Path $destinationDirectory
}

# Check for FFmpeg before proceeding
Check-FFmpeg

# Loop over all audio files in the source directory
Get-ChildItem "$sourceDirectory" -File | ForEach-Object {
    $file = $_
    $filename = [System.IO.Path]::GetFileNameWithoutExtension($file)
    $outputFile = "$destinationDirectory\$filename.wav"

    # Convert to wav format with the specified options, overwrite if exists
    ffmpeg -y -i $file.FullName -acodec pcm_s16le -ar 44100 -ac 2 $outputFile
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully converted $($file.FullName) to $outputFile."
    } else {
        Write-Host "Failed to convert $($file.FullName)."
    }
}

Write-Host "Conversion to WAV complete for all files in $sourceDirectory. All converted files are saved in $destinationDirectory."
