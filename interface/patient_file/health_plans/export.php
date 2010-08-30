<?php
// Copyright (C) 2010 OpenEMR Support LLC
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

//SANITIZE ALL ESCAPES
$sanitize_all_escapes=true;

//STOP FAKE REGISTER GLOBALS
$fake_register_globals=false;

require_once("../../globals.php");
require_once("$srcdir/options.inc.php");
include_once("$srcdir/formdata.inc.php");

// Get the patient_reminders table columns from the database.
$dump_buffer = "";
$query = "show columns from patient_reminders";
$result = sqlStatement($query);
while ($myrow = sqlFetchArray($result)) {
	while ($myrowvalue = each($myrow)) {
		$field[] = htmlspecialchars($myrowvalue['value'], ENT_QUOTES);
		break;
	}
}

// Put the separator between the records and end of the record.
for($i = 0; $i < count($field); $i++)
{
	if($i == count($field) - 1)
	{
		$dump_buffer .= $field[$i]."\r\n";
	}
	else
	{
		$dump_buffer .= $field[$i]."|";
	}
}

// Get the patient_reminders table data from the database.
$query = "select * from patient_reminders";
$result = sqlStatement($query);
while ($myrow = sqlFetchArray($result)) {
	$i = 1;
	while ($myrowvalue = each($myrow)) {
		$myrowvalue["value"] = ereg_replace("\"", "\"\"", htmlspecialchars($myrowvalue["value"], ENT_QUOTES));
		$myrowvalue["value"] = preg_replace("/\r\n|\n\r|\n|\r/", " ", $myrowvalue["value"]);
		$record = $myrowvalue["value"];
		if ($i == count($myrow)) {
			$dump_buffer .= $record."\r\n";
		}
		else {
			$dump_buffer .= $record."|";
		}
		++$i;
	}
}

// Write the data into the temporary file.
$fp = fopen("patient_reminders.csv", "w");
fwrite($fp, $dump_buffer);
fclose($fp);

// Export the data into the patient_reminders.csv.
$filesize = filesize("patient_reminders.csv");
if($filesize) {
	Header("Content-Type: application/text");
	Header("Content-Length: ".$filesize);
	Header("Content-Disposition: attachment; filename=patient_reminders.csv");
	@readfile("patient_reminders.csv");
}

// Delete the data into the temporary file.
unlink("patient_reminders.csv");
unset($dump_buffer);
exit;

?>
