<?php
// Copyright (C) 2008 Rod Roark <rod@sunsetsystems.com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This may be run after an upgraded OpenEMR has been installed.
// Its purpose is to upgrade the MySQL OpenEMR database as needed
// for the new release.

// Disable PHP timeout.  This will not work in safe mode.
ini_set('max_execution_time', '0');

$ignoreAuth = true; // no login required

require_once('interface/globals.php');
require_once('library/sql.inc');

function tableExists($tblname) {
  $row = sqlQuery("SHOW TABLES LIKE '$tblname'");
  if (empty($row)) return false;
  return true;
}

function columnExists($tblname, $colname) {
  $row = sqlQuery("SHOW COLUMNS FROM $tblname LIKE '$colname'");
  if (empty($row)) return false;
  return true;
}

function columnHasType($tblname, $colname, $coltype) {
  $row = sqlQuery("SHOW COLUMNS FROM $tblname LIKE '$colname'");
  if (empty($row)) return true;
  return (strcasecmp($row['Type'], $coltype) == 0);
}

function tableHasRow($tblname, $colname, $value) {
  $row = sqlQuery("SELECT COUNT(*) AS count FROM $tblname WHERE " .
    "$colname LIKE '$value'");
  return $row['count'] ? true : false;
}

$versions = array();
$sqldir = "$webserver_root/sql";
$dh = opendir($sqldir);
if (! $dh) die("Cannot read $sqldir");
while (false !== ($sfname = readdir($dh))) {
  if (substr($sfname, 0, 1) == '.') continue;
  if (preg_match('/^(\d+)_(\d+)_(\d+)-to-\d+_\d+_\d+_upgrade.sql$/', $sfname, $matches)) {
    $version = $matches[1] . '.' . $matches[2] . '.' . $matches[3];
    $versions[$version] = $sfname;
  }
}
closedir($dh);
ksort($versions);
?>
<html>
<head>
<title>OpenEMR Database Upgrade</title>
<link rel='STYLESHEET' href='interface/themes/style_blue.css'>
</head>
<body>
<center>
<span class='title'>OpenEMR Database Upgrade</span>
<br>
</center>
<?php
if (!empty($_POST['form_submit'])) {
  $form_old_version = $_POST['form_old_version'];

  foreach ($versions as $version => $filename) {
    if (strcmp($version, $form_old_version) < 0) continue;

    echo "<font color='green'>Processing $filename ...</font><br />\n";

    flush();
    $fullname = "$webserver_root/sql/$filename";
    $fd = fopen($fullname, 'r');
    if ($fd == FALSE) {
      echo "ERROR.  Could not open '$fullname'.\n";
      flush();
      break;
    }

    $query = "";
    $line = "";
    $skipping = false;

    while (!feof ($fd)){
      $line = fgets($fd, 2048);
      $line = rtrim($line);

      if (preg_match('/^\s*--/', $line)) continue;
      if ($line == "") continue;

      if (preg_match('/^#IfNotTable\s+(\S+)/', $line, $matches)) {
        $skipping = tableExists($matches[1]);
        if ($skipping) echo "<font color='green'>Skipping section $line</font><br />\n";
      }
      else if (preg_match('/^#IfMissingColumn\s+(\S+)\s+(\S+)/', $line, $matches)) {
        if (tableExists($matches[1])) {
          $skipping = columnExists($matches[1], $matches[2]);
        }
        else {
          // If no such table then the column is deemed not "missing".
          $skipping = true;
        }
        if ($skipping) echo "<font color='green'>Skipping section $line</font><br />\n";
      }
      else if (preg_match('/^#IfNotColumnType\s+(\S+)\s+(\S+)\s+(\S+)/', $line, $matches)) {
        if (tableExists($matches[1])) {
          $skipping = columnHasType($matches[1], $matches[2], $matches[3]);
        }
        else {
          // If no such table then the column type is deemed not "missing".
          $skipping = true;
        }
        if ($skipping) echo "<font color='green'>Skipping section $line</font><br />\n";
      }
      else if (preg_match('/^#IfNotRow\s+(\S+)\s+(\S+)\s+(\S+)/', $line, $matches)) {
        if (tableExists($matches[1])) {
          $skipping = tableHasRow($matches[1], $matches[2], $matches[3]);
        }
        else {
          // If no such table then the row is deemed not "missing".
          $skipping = true;
        }
        if ($skipping) echo "<font color='green'>Skipping section $line</font><br />\n";
      }
      else if (preg_match('/^#EndIf/', $line)) {
        $skipping = false;
      }

      if (preg_match('/^\s*#/', $line)) continue;
      if ($skipping) continue;

      $query = $query . $line;
      if (substr($query, -1) == ';') {
        $query = rtrim($query, ';');
        echo "$query<br />\n";
        if (!sqlStatement($query)) {
          echo "<font color='red'>The above statement failed: " .
            mysql_error() . "<br />Upgrading will continue.<br /></font>\n";
        }
        $query = '';
      }
    }
    flush();
  }

  echo "<p><font color='green'>Database upgrade finished.</font></p>\n";
  echo "</body></html>\n";
  exit();
}

?>
<center>
<form method='post' action='sql_upgrade.php'>
<p>Please select the prior release you are converting from:
<select name='form_old_version'>
<?php
foreach ($versions as $version => $filename) {
  echo " <option value='$version'>$version</option>\n";
}
?>
</select>
</p>
<p>If you were using a development version between two releases,
then choose the older of those releases.</p>
<p><input type='submit' name='form_submit' value='Upgrade Database' /></p>
</form>
</center>
</body>
</html>