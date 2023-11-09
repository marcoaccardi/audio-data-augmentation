# PowerShell script to apply time stretching to audio files

# Check if rubberband is installed
function Check-Rubberband {
    $rubberband = Get-Command "rubberband" -ErrorAction SilentlyContinue
    if ($null -eq $rubberband) {
        Write-Host "rubberband could not be found. Please install rubberband to continue."
        exit
    } else {
        Write-Host "rubberband is installed."
    }
}

# Prompt the user for the source and destination directories and time stretch factor
$sourceDirectory = Read-Host "Enter the source directory path of your audio files"
$destinationDirectory = Read-Host "Enter the destination directory path for the time-stretched WAV files"
$timeFactor = Read-Host "Enter the time stretch factor (e.g., 0.8 for slower, 1.2 for faster playback)"

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

# Check for rubberband before proceeding
Check-Rubberband

# Loop over all audio files in the source directory
Get-ChildItem "$sourceDirectory" -File | ForEach-Object {
    $file = $_
    $filenameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($file)
    $outputFile = "$destinationDirectory\$filenameWithoutExt`_stretched.wav"

    # Apply time stretching with high-quality pitch shifting
    rubberband --pitch-hq -t $timeFactor $file.FullName $outputFile
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully processed $($file.FullName) into $outputFile"
    } else {
        Write-Host "Failed to process $($file.FullName)"
    }
}

Write-Host "Time stretching complete for all files in $sourceDirectory. All processed files are saved in $destinationDirectory."
