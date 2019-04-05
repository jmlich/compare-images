#!/bin/bash

OUTPUT="/var/www/html/only-close.html"

#cat ./result.txt |grep -v "x$" | grep -v "#$"|grep -v "%$" >only-close.txt
#cat ./result.txt |grep -v "#$" >only-close.txt
cat ./result.txt |grep -v "~$" | sort -n | head -n 1000 >only-close.txt

rm -f "$OUTPUT"

server="http://pcmlich.fit.vutbr.cz"
echo "<style>.thumb { height: 200px; }</style> <form action=\"add_to_list.php\" method=\"post\"> " >> "$OUTPUT"
echo "<input type=\"submit\"/> <br/> <br/> " >> "$OUTPUT"
while IFS=" " read distance one two cls; do
    oner="$server/$(realpath --relative-to "/var/www/html/" "$one")"
    twor="$server/$(realpath --relative-to "/var/www/html/" "$two")"
    echo "<input type=\"checkbox\" name=\"data[]\" value=\"$one $two\"/>" >>"$OUTPUT"
    echo "<a href=\"$oner\"><img src=\"$oner\" class=\"thumb\"/></a> <a href=\"$twor\"><img src=\"$twor\" class=\"thumb\"/></a> $distance $cls " >> "$OUTPUT"
    echo "<br/>" >> "$OUTPUT"
done < only-close.txt

wc -l only-close.txt