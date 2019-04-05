#!/bin/bash

#cat ./result.txt |grep -v "x$" | grep -v "#$"|grep -v "%$" >only-close.txt
#cat ./result.txt |grep -v "#$" >only-close.txt
cat ./result.txt |grep -v "~$" | sort -n | head -n 1000 >only-close.txt

rm -f only-close.html

server="http://pcmlich.fit.vutbr.cz"
echo "<style>.thumb { height: 200px; }</style>" >> only-close.html
while IFS=" " read distance one two cls; do
    oner="$server/$(realpath --relative-to "/var/www/html/" "$one")"
    twor="$server/$(realpath --relative-to "/var/www/html/" "$two")"
    echo "<a href=\"$oner\"><img src=\"$oner\" class=\"thumb\"/></a> <a href=\"$twor\"><img src=\"$twor\" class=\"thumb\"/></a> $distance $cls <br/>" >> only-close.html
done < only-close.txt

wc -l only-close.html