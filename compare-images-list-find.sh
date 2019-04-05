#!/bin/bash

inDirA=/var/www/html/fire/FiSmo/FiSmo-Images/Flickr-Fire/Flickr-Fire_flame
#inDirB=/home/jmlich/workspace/fire/labelme/LabelMeAnnotationTool/Images/flickr-fire
inDirB=/var/www/html/fire/dataset-fire-labelme-cropped-Images/flickr-fire
blacklist_file=/var/www/html/blacklist.txt

#find "$inDirA" -type f |head -n 10 > list1.txt
find "$inDirA" -type f  > list1.txt
#find "$inDirB" -type f |head -n 10 > list2.txt
find "$inDirB" -type f > list2.txt


if [ -f "$blacklist_file" ]; then
    while IFS=" " read fa fb; do
        if [ -z $fa ]; then
            continue;
        fi
        sed '\#'"$fa"'#d' -i list1.txt
        sed '\#'"$fb"'#d' -i list2.txt
    done < "$blacklist_file"
else
    touch "$blacklist_file"
    chmod 666 "$blacklist_file"
fi

wc -l "$blacklist_file" list1.txt list2.txt

./compare-images.py ./list1.txt ./list2.txt >result.txt
