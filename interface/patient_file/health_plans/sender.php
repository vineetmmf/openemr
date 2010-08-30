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

<?php
// Insert/update the reminder sender details into patient_reminder table.
if (formData("task") == "save")
{
	$sql = "select reminder_id from patient_reminders where reminder_name=?";
	$result = sqlStatement($sql, array('Sender Details'));
	if ($myrow = sqlFetchArray($result)) {
		sqlQuery("update patient_reminders set reminder_name='Sender Details', sender_name='".formData("sender_name")."', email_address='".formData("email_address")."', phone_number='".formData("phone_number")."' where reminder_id=?", array($myrow['reminder_id']));
	}
	else {
		sqlQuery("insert into patient_reminders set reminder_name='Sender Details', sender_name='".formData("sender_name")."', email_address='".formData("email_address")."', phone_number='".formData("phone_number")."'");
	}
	echo "<script language=javascript>window.close()</script>";
}

// Get the reminder sender details.
$sql = "select sender_name, email_address, phone_number from patient_reminders where reminder_name='Sender Details'";
$result = sqlStatement($sql);
if ($myrow = sqlFetchArray($result)) {
	$sender_name = $myrow['sender_name'];
	$email_address = $myrow['email_address'];
	$phone_number = $myrow['phone_number'];
}

// Display sender details form. ?>
<body class="body_top">
<form name=sender action="sender.php" method=post>
<input type="hidden" name="task" value="save">
<center><br>
<table border='0' cellspacing='8'>
<tr><td class='text'><b><?php echo htmlspecialchars(xl('Sender Name'), ENT_QUOTES); ?>:</b></td><td><input type='text' name='sender_name' size='30' value='<?php echo htmlspecialchars($sender_name, ENT_QUOTES); ?>' /></td></tr>
<tr><td class='text'><b><?php echo htmlspecialchars(xl('Email Address'), ENT_QUOTES); ?>:</b></td><td><input type='text' name='email_address' size='30' value='<?php echo htmlspecialchars($email_address, ENT_QUOTES); ?>' /></td></tr>
<tr><td class='text'><b><?php echo htmlspecialchars(xl('Phone Number'), ENT_QUOTES); ?>:</b></td><td><input type='text' name='phone_number' size='30' value='<?php echo htmlspecialchars($phone_number, ENT_QUOTES); ?>' /></td></tr>
</table><input type="submit" value="<?php echo htmlspecialchars(xl('Save'), ENT_QUOTES); ?>"> <input type="button" value="<?php xl('Close','e'); ?>" onClick="window.close()">

</body>
</html>
