#!/bin/bash

# Function to check if rubberband is installed
check_rubberband() {
  if ! command -v rubberband &> /dev/null; then
    echo "rubberband could not be found, attempting to install..."
    install_rubberband
  else
    echo "rubberband is already installed."
  fi
}

# Function to install rubberband
install_rubberband() {
  # Detect OS and install rubberband using the appropriate package manager
  OS="`uname`"
  case $OS in
    'Linux')
      # Install for Linux
      sudo apt-get update && sudo apt-get install -y rubberband-cli
      ;;
    'Darwin') 
      # Install for macOS
      if ! command -v brew &> /dev/null; then
        echo "Homebrew not found, please install it to proceed."
        exit 1
      fi
      brew install rubberband
      ;;
    *) 
      # Unknown OS
      echo "Unsupported operating system: $OS"
      exit 1
      ;;
  esac
}

# Prompt for input and output directories
read -p "Enter the source directory path of your audio files: " SOURCE_DIRECTORY
read -p "Enter the destination directory path for the pitch-shifted audio files: " DESTINATION_DIRECTORY

# Check if the source directory exists
if [ ! -d "$SOURCE_DIRECTORY" ]; then
  echo "The source directory $SOURCE_DIRECTORY does not exist. Please enter a valid directory."
  exit 1
fi

# Check if the destination directory exists, if not, create it
if [ ! -d "$DESTINATION_DIRECTORY" ]; then
  echo "The destination directory $DESTINATION_DIRECTORY does not exist. Creating it now..."
  mkdir -p "$DESTINATION_DIRECTORY"
fi

# Ask for min and max pitch values
read -p "Enter the minimum pitch shift value: " MIN_PITCH
read -p "Enter the maximum pitch shift value: " MAX_PITCH

# Ensure rubberband is installed before proceeding
check_rubberband

# Loop over all files in the source directory and apply pitch shifting
for file in "$SOURCE_DIRECTORY"/*; do
  # Skip if it's not a file
  if [ ! -f "$file" ]; then
    continue
  fi

  # Extract the filename without the extension
  filename=$(basename -- "$file")
  extension="${filename##*.}"
  filename="${filename%.*}"

  # Perform pitch shifting within the user-specified range
  for (( i=$MIN_PITCH; i<=$MAX_PITCH; i++ )); do
    # Skip the pitch shifting for 0 as it is the original file
    if [ "$i" -eq 0 ]; then
      continue
    fi
    
    # Construct the output filename in the destination directory
    output_filename="${DESTINATION_DIRECTORY}/${filename}_pitch_${i}.${extension}"

    # Apply pitch shifting
    rubberband -p $i "$file" "$output_filename"
    
    echo "Created pitch-shifted version: $output_filename"
  done
done

echo "Pitch shifting complete for files in $SOURCE_DIRECTORY. Check $DESTINATION_DIRECTORY for output."