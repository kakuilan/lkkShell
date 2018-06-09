#!/bin/sh

start_time=0.5
duration=0.6

palette="/tmp/palette.png"

#filters="fps=10,scale=480:-1:flags=lanczos"
#filters="fps=10,scale=-1:390:flags=lanczos,crop=223:390:120:0"
filters="transpose=1,fps=10,scale=-1:312:flags=lanczos"

ffmpeg -v warning -ss $start_time -t $duration -i $1 -vf "$filters,palettegen" -y $palette
ffmpeg -v warning -ss $start_time -t $duration -i $1 -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $2
