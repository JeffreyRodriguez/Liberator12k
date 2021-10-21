#!/bin/sh

exec gource -o - \
       -c 4 \
      --auto-skip-seconds 86400 \
      -s 0.1 \
      --camera-mode overview -1920x1080 \
      --font-scale 3 \
    | ffmpeg -y -i - -r 60 -threads 0 \
      -f image2pipe -vcodec ppm -vcodec libx264 \
      -preset ultrafast -pix_fmt yuv420p -crf 17 -bf 0 \
      gource.mp4
