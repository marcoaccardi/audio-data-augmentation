# Audio Processing Toolkit

## Overview
This repository houses a collection of Bash scripts for audio processing tasks including data augmentation through pitch shifting, time stretching, and format conversion to WAV using `rubberband` and `ffmpeg`.

### Scripts and Their Functions
1. `pitch_shift.sh` - Modifies the pitch of audio files within a given range.
2. `time_stretch.sh` - Changes the playback speed of audio files without altering the pitch.
3. `convert_to_wav.sh` - Converts audio files to WAV format, ensuring compatibility across different systems and software.

## Prerequisites
- `rubberband-cli` on Linux or `rubberband` on macOS.
- `ffmpeg` for audio conversion.

### Links to resources
- **Rubberband**: https://breakfastquay.com/rubberband/ - This is the official website for the Rubberband audio stretching library, where you can find information about the tool, including documentation and download instructions.

- **FFmpeg**: https://ffmpeg.org/ - This is the official website for FFmpeg, an open-source project consisting of a vast software suite of libraries and programs for handling video, audio, and other multimedia files and streams.

## Installation
The scripts will guide you through the installation process if these tools are not found.

## Usage Instructions
1. Clone the repository to your system.
2. Run the desired script with `bash <script_name>.sh`.
3. Follow the on-screen prompts to input the required paths.

### Example Paths
- Source directory path: `/home/user/audio_files/originals`
- Destination directory path: `/home/user/audio_files/processed`

Note: Always replace placeholders with your specific paths and details.

## Contributing
Feel free to fork, modify, and send pull requests. Bug reports and suggestions for improvements are also welcome.

