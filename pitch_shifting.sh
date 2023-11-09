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

# Ask for the directory containing the audio files
read -p "Enter the directory path of your audio files: " DIRECTORY

# Check if the provided directory exists
if [ ! -d "$DIRECTORY" ]; then
  echo "The directory $DIRECTORY does not exist. Please enter a valid directory."
  exit 1
fi

# Check and install rubberband
check_rubberband

# Loop over all files in the directory
for file in "$DIRECTORY"/*; do
  # Skip if it's not a file
  if [ ! -f "$file" ]; then
    continue
  fi

  # Extract the filename without the extension
  filename=$(basename -- "$file")
  extension="${filename##*.}"
  filename="${filename%.*}"

  # Perform pitch shifting from -5 to +5
  for i in {-5..5}; do
    # Skip the pitch shifting for 0 as it is the original file
    if [ "$i" -eq 0 ]; then
      continue
    fi
    
    # Construct the output filename
    output_filename="${DIRECTORY}/${filename}_pitch_${i}.${extension}"

    # Apply pitch shifting
    rubberband -p $i "$file" "$output_filename"
    
    echo "Created pitch shifted version: $output_filename"
  done
done

echo "Pitch shifting complete for all files in $DIRECTORY."
