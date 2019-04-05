#!/bin/bash

cat ./result.txt |grep -v "#$"|grep -v "%$" >only-close.txt
#cat ./result.txt |grep -v "#$" >only-close.txt

rm -f only-close.html

echo "<style>.thumb { height: 200px; }</style>" >> only-close.html
while IFS=" " read one two distance cls; do
    echo "<a href=\"$one\"><img src=\"$one\" class=\"thumb\"/></a> <a href=\"$two\"><img src=\"$two\" class=\"thumb\"/></a> $distance $cls <br/>" >> only-close.html
done < only-close.txt

wc -l only-close.html