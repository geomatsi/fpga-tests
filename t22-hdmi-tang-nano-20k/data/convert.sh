#!/bin/bash

IMAGE=$1

if [ -z $1 ]
then
	IMAGE=test1.jpg
fi

magick $IMAGE -resize 180x120! -depth 8 rgb:tile.rgb
xxd -p -c 3 tile.rgb > rom.hex
rm tile.rgb
