<?php

$filename = "blacklist.txt";
$file = "";

if (file_exists($filename)) {
  $file = file_get_contents($filename);
  $data = explode("\n", $file);
} else {
  $data = array();
}


$data2 = array_merge($data, $_REQUEST['data']);
$data3 = array_unique($data2);
sort($data3);
$file = implode("\n", $data3);

echo "<pre>".print_r($file, true)."</pre>";

file_put_contents('blacklist.txt', $file);

?>