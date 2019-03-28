#!/bin/bash

inDirA=/var/www/html/fire/dataset-fire-labelme-cropped-Images
inDirB=/var/www/html/fire/bowfire-dataset/dataset-BowFire/dataset/img_jpg

thresholds=( 100000 200000 500000 1000000 )


near_log="./near-%d.log"

for threshold in ${thresholds[*]}; do
    log=$(printf "$near_log" "$threshold")
    rm -f $log
done

for aFile in $(find "$inDirA" -type f); do
    for bFile in $(find "$inDirB" -type f); do
        if [ "$aFile" = "$bFile" ]; then
            continue;
        fi
        distance=$(./compare-images.py "$aFile" "$bFile")
#        echo $(basename $aFile) $(basename $bFile) $distance
        echo $aFile $bFile $distance
        for threshold in ${thresholds[*]}; do
            log=$(printf "$near_log" "$threshold")
            if [ "$distance" -lt "$threshold" ]; then
                echo "$aFile $bFile $distance" >> "$log"
            fi
        done

    done
done
