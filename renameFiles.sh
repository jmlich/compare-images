#!/bin/bash

echo "already done" ; exit

xmldir="/home/jmlich/workspace/fire/labelme/LabelMeAnnotationTool/Annotations/flickr-fire"
orig_dir="/home/jmlich/workspace/fire/labelme/LabelMeAnnotationTool/Images/flickr-fire"

while IFS=' ' read -d $'\n' -r fna fnb; do
    bna=$(basename "$fna" ".jpg")
    bnb=$(basename "$fnb" ".jpg")
    dnb=$(dirname "$fnb")

    anotfile_old="$xmldir/${bnb}.xml"
    anotfile_new="$xmldir/${bna}.xml"

    if [ "$bna" = "$bnb" ]; then
        continue;
    fi

    mv "$orig_dir/${bnb}.jpg" "$orig_dir/${bna}.jpg"

    if [ -f "$anotfile_old" ]; then
        sed -i "s|<filename>$bnb.jpg</filename>|<filename>$bna.jpg</filename>|g" $anotfile_old
        mv "$anotfile_old" "$anotfile_new"
    fi

done < "./pairlist.txt"