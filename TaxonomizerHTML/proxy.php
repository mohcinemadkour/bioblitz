<?php
header('Content-Type: text/xml');
error_log("CALL!");
$url = $_GET['url'];
if(strpos($url, 'http') === 0) // exclude local files
{
  $data = file_get_contents($url);
  echo $data;

}
?>