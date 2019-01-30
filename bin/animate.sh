#!/bin/bash

if [ -z "$1" ]
  then
    echo "Usage: animate.sh <path_to_frames> <output.mp4>"
  exit 1
fi

nice ffmpeg -y -i "$1" -framerate 10 -s:v 1920x1080 -c:v libx264 -crf 20 -pix_fmt yuv420p "$2"
