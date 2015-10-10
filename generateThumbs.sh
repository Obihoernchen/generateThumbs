#!/bin/bash

DIR=$1

if [ -z "$DIR" ]; then
	printf "%s\n" "This script will generate thumbnails for all video files inside the given directory"
	printf "%s\n" "moviexy.avi --> moviexy.jpg"
	printf "%s\n" "ffmpegthumbnailer is required"
	printf "%s\n" "Usage: generateThumbs <directory>"
	exit 1
fi

TYPES=( mov qt mp4 avi mkv m4v xvid divx wmv mpg mpeg webm flv vob ogg 3gp 3gp2 )

# Create a regex of the extensions for the find command
TYPES_RE="\\("${TYPES[1]}
for t in "${TYPES[@]:1:${#TYPES[*]}}"; do
    TYPES_RE="${TYPES_RE}\\|${t}"
done
TYPES_RE="${TYPES_RE}\\)"

find -L "$DIR" -regex ".*\.${TYPES_RE}" -type f | while read -r FILEPATH
do
	printf "%s\n" "--- Start Thumbnailcreation for ---"
	printf "%s\n" "$FILEPATH"
	THUMBFILE="${FILEPATH%.*}.jpg" # remove video ext. and add .jpg
	if [ -f "$THUMBFILE" ]; then
		printf "\e[1;33m%s\e[0m\n" "Thumbnail exists"
	else
		printf "\e[1;32m%s\e[0m\n" "Generating thumbnail..."
		ffmpegthumbnailer -i "$FILEPATH" -o "$THUMBFILE" -s 160 -q 10
	fi
	printf "%s\n" "--- End Thumbnailcreation ---"
done
exit 0
