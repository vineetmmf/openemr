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

//get sender detail 
$sql = "select sender_name, email_address, phone_number from patient_reminders where reminder_name='Sender Details'";
$result = sqlStatement($sql);
if ($myrow = sqlFetchArray($result)) {
	$sender_name = htmlspecialchars($myrow['sender_name'], ENT_QUOTES);
	$email_address = htmlspecialchars($myrow['email_address'], ENT_QUOTES);
	$phone_number = htmlspecialchars($myrow['phone_number'], ENT_QUOTES);
}

// Check and select patient reminder(s) for printing.
if (formData("reminder_id", "G")) {
$sql = "select reminder_content, sender_name, patient_id, scheduled_date from patient_reminders where reminder_id=?";
$result = sqlStatement($sql, array(formData("reminder_id", "G")));
}
else {
$sql = "select reminder_content, sender_name, patient_id, scheduled_date from patient_reminders where patient_id!='' and reminder_name!='Sender Details' order by reminder_id";
$result = sqlStatement($sql);
}
//$result = sqlStatement($sql);
while ($myrow = sqlFetchArray($result)) {
	$message = htmlspecialchars($myrow['reminder_content'], ENT_QUOTES);
	//$sender_name = $myrow['sender_name'];
	$patient_id = htmlspecialchars($myrow['patient_id'], ENT_QUOTES);
	$form_scheduled_date = htmlspecialchars($myrow['scheduled_date'], ENT_QUOTES);

	$myrow = sqlQuery("select fname, lname, street, postal_code, city, state from patient_data where pid=?", array($patient_id));
	$fname = htmlspecialchars($myrow['fname'], ENT_QUOTES);
	$lname = htmlspecialchars($myrow['lname'], ENT_QUOTES);
	$street = htmlspecialchars($myrow['street'], ENT_QUOTES);
	$postal_code = htmlspecialchars($myrow['postal_code'], ENT_QUOTES);
	$city = htmlspecialchars($myrow['city'], ENT_QUOTES);
	$state = htmlspecialchars($myrow['state'], ENT_QUOTES);

	?>
	<?php // Display the patient reminder details ?>

	<p><?php echo "Address :<br>".$fname." ".$lname; ?><br>
	<?php echo $street.($street?",<br>":"");?>
	<?php echo $city.(($city and ($state or $postal_code))?",":"")." ".$state." ".$postal_code; ?></p>

	<p><?php echo $form_scheduled_date; ?></p>

	<?php echo str_replace("[[sender]]", $sender_name, str_replace("[[patient_name]]", $fname, nl2br($message))); ?>
	<br><br><div style="page-break-after: always"><span style="display: none">&nbsp;</span></div><?php
}
?>

<script language='JavaScript'>
// Do auto printing for the page.
    window.print();
</script>

</body>
</html>
