#!/bin/bash

inDirA=/var/www/html/fire/dataset-fire-labelme-cropped-Images
inDirB=/var/www/html/fire/bowfire-dataset/dataset-BowFire/dataset/img_jpg

threshold=100000
near_log=./near.log
rm -f "$near_log"

for aFile in $(find "$inDirA" -type f); do
    for bFile in $(find "$inDirB" -type f); do
        if [ "$aFile" = "$bFile" ]; then
            continue;
        fi
        distance=$(./compare-images.py "$aFile" "$bFile")
#        echo $(basename $aFile) $(basename $bFile) $distance
        echo $aFile $bFile $distance
        if [ "$distance" -lt "$threshold" ]; then
            echo "$aFile $bFile $distance" >> "$near_log"
        fi
    done
done
