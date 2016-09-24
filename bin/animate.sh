#!/bin/bash

nice convert -delay 5 -loop 0 frame*.png animation.gif

nice ffmpeg -i frame%05d.png -framerate 10 -s:v 1920x1080 -c:v libx264 -crf 20 -pix_fmt yuv420p animation.mp4
