# Watchdirs (For MacOS)

Watch the given directory for new image files. New images trigger a relocation to a desired directory

This is good for working on a web project where you could have downloads and screenshots as well as edits

Everything will go where it is intended


# TODO

- Make it a swift an app with a tray icon

## Features

- Monitors specified directories for new image files.
- Automatically moves new image files to a designated destination directory.
- Handles file name conflicts by appending a sequence number to the file name.
- Skips files that are still being written to.
- Ignores temporary files ending in `.part`.

## Requirements

- **macOS**: This script is designed to run on macOS.
- **fswatch**: A file change monitor that receives notifications when the contents of the specified files or directories are modified.

## Installation

1. **Install fswatch**:
   ```bash
   brew install fswatch
   ```


2. **Clone this repository**:
   ```bash
   git clone https://github.com/yourusername/image-auto-mover.git
   cd image-auto-mover
   ```


3. **Make the script executable**:
   ```bash
   chmod +x image_auto_mover.sh
   ```


## Usage

1. **Edit the script**:
   - Open `image_auto_mover.sh` in your favorite text editor.
   - Modify the `WATCH_DIRS` array to include the directories you want to monitor. By default, it monitors the `Desktop` and `Downloads` directories.
   - Set the `DEST_DIR` variable to the directory where you want to move the images.

2. **Run the script**:
   ```bash
   ./image_auto_mover.sh
   ```

## Example Use Case

As a web developer, you might frequently take screenshots or download images for your projects. Instead of manually moving these files to your project directory, you can use this script to automate the process. For example:

- **Screenshots**: When you take a screenshot, it is saved to your `Desktop`. The script will automatically move it to your project directory.
- **Downloads**: When you download an image, it is saved to your `Downloads` folder. The script will automatically move it to your project directory.

This way, you no longer have to chase around files and can focus on your development work.

## Notes

- The script only runs on macOS.
- Ensure that the destination directory exists or the script will create it for you.
- The script uses `shasum` to compute file hashes and `stat` to get file information, which are available by default on macOS.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.
