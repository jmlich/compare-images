#!/bin/bash

OUTPUT="/var/www/html/only-close.html"

#cat ./result.txt |grep -v "x$" | grep -v "#$"|grep -v "%$" >only-close.txt
#cat ./result.txt |grep -v "#$" >only-close.txt
cat ./result.txt |grep -v "~$" | sort -n | head -n 1000 > only-close.txt

rm -f "$OUTPUT"

declare -A a_use
declare -A b_use

USE_THRESHOLD=10

server="http://pcmlich.fit.vutbr.cz"

cat <<EOF >> "$OUTPUT"
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <style>.thumb { height: 200px; }</style> <form action="add_to_list.php" method="post">
  </head>
<script  src="https://code.jquery.com/jquery-3.4.0.min.js"  integrity="sha256-BJeo0qm959uMBGb65z40ejJYGSgR7REI4+CW1fNKwOg="  crossorigin="anonymous"></script>
<script>
\$(document).ready(function() {
  \$('tr').click(function(event) {
    if (event.target.type !== 'checkbox') {
      \$(':checkbox', this).trigger('click');
    }
  });
});
</script>

<input type="submit" value="confirm matches"/> <br/> <br/>
<table class="table table-striped">
EOF

while IFS=" " read -r distance one two cls; do
    oner="$server/$(realpath --relative-to "/var/www/html/" "$one")"
#    twor="$server/$(realpath --relative-to "/var/www/html/" "$two")"
    twor="$server//fire/dataset-fire-labelme-orig-Images/$(realpath --relative-to "/home/jmlich/workspace/fire/labelme/LabelMeAnnotationTool/Images" "$two")"

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

    {
        echo "<tr>"
        echo "<td>"
        echo "<input type=\"checkbox\" name=\"data[]\" value=\"$one $two\"/>"
        echo "</td><td>"
        echo "<a href=\"$oner\"><img src=\"$oner\" class=\"thumb\"/></a>"
        echo "</td><td>"
        echo " $c_one "
        echo "</td><td>"
        echo "<a href=\"$twor\"><img src=\"$twor\" class=\"thumb\"/></a>"
        echo "</td><td>"
        echo " $c_two "
        echo "</td><td>"
        echo "$distance"
        echo "</td><td>"
        echo " $cls "
        echo "</td>"
        echo "</tr>"
    } >>"$OUTPUT"
done < only-close.txt

wc -l only-close.txt