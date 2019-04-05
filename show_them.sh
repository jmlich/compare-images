#!/bin/bash

OUTPUT="/var/www/html/only-close.html"

#cat ./result.txt |grep -v "x$" | grep -v "#$"|grep -v "%$" >only-close.txt
#cat ./result.txt |grep -v "#$" >only-close.txt
cat ./result.txt |grep -v "~$" | sort -n | head -n 5000 >only-close.txt

rm -f "$OUTPUT"

declare -A a_use
declare -A b_use

USE_THRESHOLD=3

server="http://pcmlich.fit.vutbr.cz"
echo "<style>.thumb { height: 200px; }</style> <form action=\"add_to_list.php\" method=\"post\"> " >> "$OUTPUT"
echo "<input type=\"submit\"/> <br/> <br/> " >> "$OUTPUT"
while IFS=" " read distance one two cls; do
    oner="$server/$(realpath --relative-to "/var/www/html/" "$one")"
    twor="$server/$(realpath --relative-to "/var/www/html/" "$two")"

    if [ -n ${a_use[$one]} ]; then
        c_one=${a_use[$one]}
        c_one=$(( c_one + 1 ))
    else
        c_one=1
    fi
    a_use[$one]=$c_one

    if [ "$c_one" -gt "$USE_THRESHOLD" ]; then
        continue;
    fi


    if [ -n ${b_use[$two]} ]; then
        c_two=${b_use[$two]}
        c_two=$(( c_two + 1 ))
    else
        c_two=1
    fi

    b_use[$two]=$c_two

    if [ "$c_two" -gt "$USE_THRESHOLD" ]; then
        continue;
    fi

    echo "<input type=\"checkbox\" name=\"data[]\" value=\"$one $two\"/>" >>"$OUTPUT"
    echo "<a href=\"$oner\"><img src=\"$oner\" class=\"thumb\"/></a> $c_one " >> "$OUTPUT"
    echo "<a href=\"$twor\"><img src=\"$twor\" class=\"thumb\"/></a> $c_two " >> "$OUTPUT"
    echo "&lt;-&gt; $distance $cls " >> "$OUTPUT"
    echo "<br/>" >> "$OUTPUT"
done < only-close.txt

wc -l only-close.txt