#!/bin/bash

# Function to check if ffmpeg is installed
check_ffmpeg() {
  if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg could not be found. Please install ffmpeg to continue."
    exit 1
  else
    echo "ffmpeg is installed."
  fi
}

# Prompt the user for the source directory
read -p "Enter the source directory path of your audio files: " SOURCE_DIRECTORY

# Check if the provided source directory exists
if [ ! -d "$SOURCE_DIRECTORY" ]; then
  echo "The source directory $SOURCE_DIRECTORY does not exist. Please enter a valid directory."
  exit 1
fi

# Prompt the user for the destination directory
read -p "Enter the destination directory path for the converted WAV files: " DESTINATION_DIRECTORY

# Check if the provided destination directory exists, if not create it
if [ ! -d "$DESTINATION_DIRECTORY" ]; then
  echo "The destination directory $DESTINATION_DIRECTORY does not exist. Creating directory."
  mkdir -p "$DESTINATION_DIRECTORY"
fi

# Check for ffmpeg before proceeding
check_ffmpeg

# Loop over all audio files in the source directory
for file in "$SOURCE_DIRECTORY"/*; do
  # Skip if it's not a file
  if [ ! -f "$file" ]; then
    continue
  fi

  # Extract the filename with extension
  filename_with_ext=$(basename -- "$file")

  # Extract the filename without the extension
  filename="${filename_with_ext%.*}"

  # Define the output filename with .wav extension and output path
  output_file="${DESTINATION_DIRECTORY}/${filename}.wav"

  # Convert to wav format with the specified options, overwrite if exists
  ffmpeg -y -i "$file" -acodec pcm_s16le -ar 44100 -ac 2 "$output_file"
  
  # Check if conversion was successful
  if [ $? -eq 0 ]; then
    echo "Successfully converted $file to $output_file."
  else
    echo "Failed to convert $file."
  fi
done

echo "Conversion to WAV complete for all files in $SOURCE_DIRECTORY. All converted files are saved in $DESTINATION_DIRECTORY."
