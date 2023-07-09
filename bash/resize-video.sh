#!/usr/bin/env bash

set -ex

if [ $# -ne 1 ]; then
    echo "Usage: $0 input-file"
    exit 1
fi

dir_name=$(dirname $1)
base_name=$(basename $1)
file_name=${base_name%.*}
extension=${base_name##*.}

output_path=/mnt/ramdisk/debug
mkdir -p $output_path

#$HOME/code/ffmpeg/ffmpeg \
ffmpeg \
    -hwaccel cuvid \
    -hwaccel_output_format cuda \
    -c:v h264_cuvid \
    -resize 1280x720 \
    -i $1 \
    -fps_mode passthrough \
    -c:v h264_nvenc \
    -c:a copy \
    -b:v 1M \
    "${output_path}/${file_name}.720p.${extension}"
