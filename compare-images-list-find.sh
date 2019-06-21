#!/bin/bash


## match flickr-fire in my dataset (to rename it)
#inDirA=/var/www/html/fire/FiSmo/FiSmo-Images/Flickr-Fire/Flickr-Fire_flame
#inDirB=/var/www/html/fire/dataset-fire-labelme-cropped-Images/flickr-fire
#inDirB=/var/www/html/fire/dataset-flickr-fire-tune

## match bowfire in my dataset (to exclude it from training set)
inDirA=/var/www/html/fire/bowfire-dataset/dataset-BowFire/dataset/img_jpg
inDirB=/var/www/html/fire/dataset-fire-labelme-orig-Images
#inDirB=/var/www/html/fire/dataset-fire-labelme-cropped-Images/flickr-fire
#inDirB=/var/www/html/fire/dataset-fire-labelme-cropped-Images

## match flick-fire with bowfire data set
#inDirA=/var/www/html/fire/FiSmo/FiSmo-Images/Flickr-Fire/Flickr-Fire_flame
#inDirB=/var/www/html/fire/bowfire-dataset/dataset-BowFire/dataset/img_jpg


blacklist_file=/var/www/html/blacklist.txt

#find "$inDirA" -type f |head -n 10 > list1.txt
find -L "$inDirA" -type f  > list1.txt
#find "$inDirB" -type f |head -n 10 > list2.txt
find -L "$inDirB" -type f > list2.txt

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

./show_them.sh