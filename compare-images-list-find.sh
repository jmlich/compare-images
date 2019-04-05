#!/bin/bash

inDirA=/var/www/html/fire/FiSmo/FiSmo-Images/Flickr-Fire/Flickr-Fire_flame
inDirB=/home/jmlich/workspace/fire/labelme/LabelMeAnnotationTool/Images/flickr-fire

#find "$inDirA" -type f |head -n 10 > list1.txt
find "$inDirA" -type f  > list1.txt
#find "$inDirB" -type f |head -n 10 > list2.txt
find "$inDirB" -type f > list2.txt

./compare-images.py ./list1.txt ./list2.txt >result.txt
