# PowerShell Script for Pitch Shifting Audio Files using Rubberband

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

# Prompt user for the audio file directory
$directory = Read-Host "Enter the directory path of your audio files"

# Check if the directory exists
if (!(Test-Path $directory)) {
    Write-Host "The directory $directory does not exist. Please enter a valid directory."
    exit
}

# Check for rubberband installation
Check-Rubberband

# Loop over all files in the directory
Get-ChildItem "$directory" -File | ForEach-Object {
    $file = $_
    $filename = [System.IO.Path]::GetFileNameWithoutExtension($file)
    $extension = [System.IO.Path]::GetExtension($file)

    # Perform pitch shifting from -5 to +5
    -5..5 | ForEach-Object {
        $i = $_
        # Skip the pitch shift for 0
        if ($i -eq 0) { return }

        $outputFilename = "$directory\$filename`_pitch_$i$extension"
        # Apply pitch shifting
        & rubberband -p $i $file $outputFilename

        if ($?) {
            Write-Host "Created pitch shifted version: $outputFilename"
        }
    }
}

Write-Host "Pitch shifting complete for all files in $directory."