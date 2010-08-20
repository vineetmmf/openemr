<?php
include_once("../../globals.php");
include_once("$srcdir/api.inc");
include_once("$srcdir/forms.inc");

if (isset($_GET["search"]))
{
  $search =$_GET["search"];
  $m = $_GET["m"];

  $result = mysql_query("SELECT * FROM `codes` WHERE $m LIKE '$search%' LIMIT 50", $GLOBALS['dbh']);

  while($row = mysql_fetch_array($result)) {
    $return[] = $row['code'] . ' ' . $row['code_text'];
  }

  echo implode("\n", $return);
}
?>