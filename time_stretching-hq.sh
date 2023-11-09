#!/bin/bash

# Function to check if rubberband is installed
check_rubberband() {
  if ! command -v rubberband &> /dev/null; then
    echo "rubberband could not be found. Please install rubberband to continue."
    exit 1
  else
    echo "rubberband is installed."
  fi
}

# Prompt the user for the source directory
read -p "Enter the source directory path of your audio files: " SOURCE_DIRECTORY

# Check if the provided source directory exists
if [ ! -d "$SOURCE_DIRECTORY" ]; then
  echo "The source directory $SOURCE_DIRECTORY does not exist. Please enter a valid directory."
  exit 1
fi

# Prompt the user for the time stretch factor with a suggested range
read -p "Enter the time stretch factor (e.g., 0.8 for slower, 1.2 for faster playback): " TIME_FACTOR

# Prompt the user for the destination directory
read -p "Enter the destination directory path for the time-stretched WAV files: " DESTINATION_DIRECTORY

# Check if the provided destination directory exists, if not create it
if [ ! -d "$DESTINATION_DIRECTORY" ]; then
  echo "The destination directory $DESTINATION_DIRECTORY does not exist. Creating it..."
  mkdir -p "$DESTINATION_DIRECTORY"
fi

# Check for rubberband before proceeding
check_rubberband

# Loop over all audio files in the source directory
for file in "$SOURCE_DIRECTORY"/*; do
  # Skip if it's not a file
  if [ ! -f "$file" ]; then
    continue
  fi

  # Extract the filename without the extension
  filename=$(basename -- "$file")
  filename_without_ext="${filename%.*}"

  # Construct the output file path
  output_file="${DESTINATION_DIRECTORY}/${filename_without_ext}_stretched.wav"

  # Apply time stretching with high-quality pitch shifting
  rubberband --pitch-hq -t "$TIME_FACTOR" "$file" "$output_file"
  
  if [ $? -eq 0 ]; then
    echo "Successfully processed $file into $output_file"
  else
    echo "Failed to process $file"
  fi
done

echo "Time stretching complete for all files in $SOURCE_DIRECTORY. All processed files are saved in $DESTINATION_DIRECTORY."
