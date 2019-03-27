#!/bin/bash

inDirA=/var/www/html/fire/dataset-fire-labelme-cropped-Images
inDirB=/var/www/html/fire/dataset-fire-labelme-cropped-Images

for aFile in $(find "$inDirA" -type f); do
    for bFile in $(find "$inDirB" -type f); do
        if [ "$aFile" = "$bFile" ]; then
            continue;
        fi
        distance=$(./compare-images.py "$aFile" "$bFile")
        echo $(basename $aFile) $(basename $bFile) $distance
        exit
    done
done