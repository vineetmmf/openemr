<?php
// Copyright (C) 2010 OpenEMR Support LLC
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

include_once("../../globals.php");
require_once("$srcdir/options.inc.php");
include_once("$srcdir/formdata.inc.php");
?>
<html>
<head>
<?php html_header_show();?>
<link rel='stylesheet' href="<?php echo $css_header;?>" type="text/css">
</head>

<body class="body_top">
<?php

// Check and select patient reminder(s) for printing.
if (formData("reminder_id", "G")) {
$sql = "select reminder_content, sender_name, patient_id, scheduled_date from patient_reminders where reminder_id='".formData("reminder_id", "G")."'";
}
else {
$sql = "select reminder_content, sender_name, patient_id, scheduled_date from patient_reminders order by reminder_id";
}
$result = sqlStatement($sql);
while ($myrow = sqlFetchArray($result)) {
	$message = $myrow['reminder_content'];
	$sender_name = $myrow['sender_name'];
	$patient_id = $myrow['patient_id'];
	$form_scheduled_date = $myrow['scheduled_date'];

	$myrow = sqlQuery("select fname, lname, street, postal_code, city, state from patient_data where pid='$patient_id'");
	$fname = $myrow['fname'];
	$lname = $myrow['lname'];
	$street = $myrow['street'];
	$postal_code = $myrow['postal_code'];
	$city = $myrow['city'];
	$state = $myrow['state'];

	?>
	<?php // Display the patient reminder details ?>

	<p><?php echo $fname." ".$lname; ?><br>
	<?php echo $city.(($city and ($state or $postal_code))?",":"")." ".$state." ".$postal_code; ?></p>

	<p><?php echo $form_scheduled_date; ?></p>

	<p><?php xl('Dear','e'); ?>: <?php echo $fname; ?></p>

	<p><?php echo nl2br($message); ?></p>

	<p><?php xl('Sincerely','e'); ?>,<br>
	<?php echo $sender_name; ?></p><br><br><div style="page-break-after: always"><span style="display: none">&nbsp;</span></div><?php
}
?>

<script language='JavaScript'>
// Do auto printing for the page.
    window.print();
</script>

</body>
</html>
