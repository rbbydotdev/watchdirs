#!/bin/bash

# Directories to watch
WATCH_DIRS=("$HOME/Desktop" "$HOME/Downloads")
# Directory to move images to
DEST_DIR=${HOME}/etc/projects/tv/public

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Get the current timestamp
START_TIME=$(date +%s)

# Function to compute the hash of a file
compute_hash() {
	local file=$1
	shasum "$file" | awk '{ print $1 }'
}

# Function to move the file with a new sequence name if needed
move_file_with_sequence() {

	local src_file=$1
	local dest_file=$2

	local base_name=$(basename "$dest_file")
	local dir_name=$(dirname "$dest_file")
	local extension="${base_name##*.}"
	local file_name="${base_name%.*}"
	local counter=1

	while [[ -e "$dest_file" ]]; do
		dest_file="${dir_name}/${file_name}_${counter}.${extension}"
		((counter++))
	done

	mv "$src_file" "$dest_file"
	echo "Moved new image with sequence name: $dest_file"
}

# Function to check if a file is an image and move it
move_image_if_new() {
	local file
	local file_time
	file=$1

	# Skip files ending in .part
	if [[ "$file" == *.part ]]; then
		echo "Skipping file with .part extension: $file"
		return
	fi

	# Check if the file exists
	if [[ ! -e "$file" ]]; then
		# echo "File does not exist: $file"
		return
	fi

	# Get the directory name of the file
	file_dir=$(dirname "$file")

	# Check if the file is directly in one of the watch directories
	for dir in "${WATCH_DIRS[@]}"; do
		if [[ "$file_dir" == "$dir" ]]; then
			file_time=$(stat -f %B "$file")

			if [[ $file_time -gt $START_TIME ]]; then
				if file "$file" | grep -qE 'image|bitmap'; then
					dest_file="$DEST_DIR/$(basename "$file")"

					# Wait until the file is not being written to
					while true; do
						sleep 1
						size1=$(stat -f %z "$file")
						sleep 1
						size2=$(stat -f %z "$file")
						if [[ "$size1" -eq "$size2" ]]; then
							break
						fi
					done

					if [[ -e "$dest_file" ]]; then
						src_hash=$(compute_hash "$file")
						dest_hash=$(compute_hash "$dest_file")
						if [[ "$src_hash" == "$dest_hash" ]]; then
							echo "File already exists with the same hash: $file"
						else
							move_file_with_sequence "$file" "$dest_file"
						fi
					else
						mv "$file" "$dest_file"
						echo "Moved new image: $file to $dest_file"
					fi
				fi
			fi
			break
		fi
	done
}

# Export the functions so they can be used by fswatch
export -f move_image_if_new
export -f compute_hash
export -f move_file_with_sequence

# Start fswatch to monitor the directories without descending into subdirectories
fswatch -0 -d "${WATCH_DIRS[@]}" | while read -d "" event; do
	move_image_if_new "$event"
done
