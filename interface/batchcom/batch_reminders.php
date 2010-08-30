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

require_once(dirname(__FILE__)."/../../interface/globals.php");
include_once("$srcdir/sql.inc");
include_once("$srcdir/formdata.inc.php");
?>
<html>
<head>
<?php html_header_show();?>
<link rel="stylesheet" href="<?php echo $css_header;?>" type="text/css">
<link rel="stylesheet" href="batchcom.css" type="text/css">
</head>
<body class="body_top">
<span class="title"><?php echo htmlspecialchars(xl('Patient Reminder Batch Job'), ENT_QUOTES)?></span>
<table>
 <tr>
  <td class='text' align='left' colspan="3"><br>
    <span class="text"><?php echo htmlspecialchars(xl('The patient reminders have been processed according their scheduled dates.'), ENT_QUOTES)?></span><br><br>
    <span class="text"><?php echo htmlspecialchars(xl('Email delivery is immediate, while automated VOIP is sent to the service provider for further processing.'), ENT_QUOTES)?></span><br><br>
    <input type="button" value="<?php echo htmlspecialchars(xl('Close'), ENT_QUOTES); ?>" onClick="window.close()"><br><br><br>
  </td>
 </tr>
</table>
<br><br>

<?php

require_once ($GLOBALS['srcdir'] . "/classes/postmaster.php");
require_once ($GLOBALS['srcdir'] . "/maviq_phone_api.php");
require_once("$include_root/patient_file/health_plans/health_plans_functions.php");

// Recreate the reminder follow the actions frequency
$enrollsql = "select * from health_plan_enrollment order by enroll_id";
$enrollresult = sqlStatement($enrollsql);
while ($myenrollrow = sqlFetchArray($enrollresult)) {
	$action_date = explode(",", htmlspecialchars($myenrollrow['action_date'], ENT_QUOTES));
	$action_completed = explode(",", htmlspecialchars($myenrollrow['action_completed'], ENT_QUOTES));
	$actionsql = "select * from health_plan_actions where plan_id = ? order by action_id";
	$actionresult = sqlStatement($actionsql, array($myenrollrow['plan_id']));
	$count = 0;
	$reminder_recreate = "";
	while ($myactionrow = sqlFetchArray($actionresult)) {
		if ($myactionrow['subactions'] != "" && $myactionrow['subactions'] != NULL) {
			if ($myactionrow['subactions'] == 0)
			{
				$action_frequency = htmlspecialchars($myactionrow['frequency'], ENT_QUOTES);
				if ($action_date[$count] != "0000-00-00" && substr($action_completed[$count], -3) == "YES") {
					if ($action_frequency != "::") {
						$tmp_frequency = explode("::", $action_frequency);
						$tmp_actiondate = explode("-", $action_date[$count]);
						$action_date[$count] = date("Y-m-d", mktime(0, 0, 0, $tmp_actiondate[1] + $tmp_frequency[1], $tmp_actiondate[2], $tmp_actiondate[0] + $tmp_frequency[0]));
						$action_completed[$count] = str_replace("YES", "NO", $action_completed[$count]);
						$reminder_recreate = "YES";
					}
				}
				${"form_action_targetdate_".($count + 1)} = $action_date[$count];
				${"form_action_completed_".($count + 1)} = $action_completed[$count];
				++$count;
			}
			else
			{
				$action_frequency = htmlspecialchars($myactionrow['frequency'], ENT_QUOTES);
			}
		}
		else {
			if ($action_date[$count] != "0000-00-00" && substr($action_completed[$count], -3) == "YES") {
				if ($action_frequency != "::") {
					$tmp_frequency = explode("::", $action_frequency);
					$tmp_actiondate = explode("-", $action_date[$count]);
					$action_date[$count] = date("Y-m-d", mktime(0, 0, 0, $tmp_actiondate[1] + $tmp_frequency[1], $tmp_actiondate[2], $tmp_actiondate[0] + $tmp_frequency[0]));
					$action_completed[$count] = str_replace("YES", "NO", $action_completed[$count]);
					$reminder_recreate = "YES";
				}
			}
			${"form_action_targetdate_".($count + 1)} = $action_date[$count];
			${"form_action_completed_".($count + 1)} = $action_completed[$count];
			++$count;
		}
	}
	if ($reminder_recreate == "YES")
	{
		// Delete the existing reminder of the enrollment.
		sqlQuery("delete from patient_reminders WHERE patient_id = ? AND plan_id = ? AND enroll_id= ?", array($myenrollrow['patient_id'], $myenrollrow['plan_id'], $myenrollrow['enroll_id']));

		// Enroll the health plan for the patient
		health_plans_enrollment($myenrollrow['plan_id'], $myenrollrow['patient_id'], $myenrollrow['enroll_id'], "pending", "batch");
	}
}


// Get the reminder sender details.
$sql = "select sender_name, email_address, phone_number from patient_reminders where reminder_name=?";
$result = sqlStatement($sql, array('Sender Details'));
if ($myrow = sqlFetchArray($result)) {
	$sender_name = htmlspecialchars($myrow['sender_name'], ENT_QUOTES);
	$email_address = htmlspecialchars($myrow['email_address'], ENT_QUOTES);
	$phone_number = htmlspecialchars($myrow['phone_number'], ENT_QUOTES);
}
if ($GLOBALS['clinical_decision_rules_and_patient_reminders']) {
	// Get the reminder where scheduled date is less than or equal to today's date and has a Pending status.
	$sql = "select reminder_id, reminder_name, patient_id, enroll_id, action_id, reminder_content, scheduled_date, voice_status, email_status from patient_reminders where scheduled_date = ? and scheduled_date != ? and scheduled_date IS NOT NULL";
	$result = sqlStatement($sql, array(date("Y-m-d"), '0000-00-00'));
	while ($myrow = sqlFetchArray($result))
	{
		// Select the action completions status based on enrollment ID.
		$enrollrow = sqlQuery("select action_completed from health_plan_enrollment where enroll_id= ?", array($myrow['enroll_id']));
		$action_completed = explode(",", $enrollrow['action_completed']);
		if (!in_array($myrow['action_id']."-YES", $action_completed)) {
			$scheduled_date = explode("-", $myrow['scheduled_date']);
			// Get the patient details based on patient ID.
			$sql = "select fname, lname, email, phone_cell, hipaa_voice, hipaa_allowemail from patient_data where pid=?";
			$patientresult = sqlStatement($sql, array($myrow['patient_id']));
			if ($mypatientrow = sqlFetchArray($patientresult))
			{
				$patientfname = htmlspecialchars($mypatientrow['fname'], ENT_QUOTES);
				$patientlname = htmlspecialchars($mypatientrow['lname'], ENT_QUOTES);
				$patientemail = htmlspecialchars($mypatientrow['email'], ENT_QUOTES);
				$patientphone = htmlspecialchars($mypatientrow['phone_cell'], ENT_QUOTES);
				$hipaa_voice = htmlspecialchars($mypatientrow['hipaa_voice'], ENT_QUOTES);
				$hipaa_allowemail = htmlspecialchars($mypatientrow['hipaa_allowemail'], ENT_QUOTES);
			}
			// Email to patient if Allow Email field in Demographics is set to Yes.
			if ($hipaa_allowemail == "YES" and ($myrow['email_status'] == "pending" or $myrow['email_status'] == "failed"))
			{
				$mail = new MyMailer();
				$mail->FromName = $sender_name;  // required
				$mail->Sender = $sender_name;    // required
				$mail->From = $email_address;    // required
				$mail->AddAddress($patientemail, $patientfname.", ".$patientlname);   // required
				$mail->AddReplyTo($email_address,$sender_name);  // required  
				$mail->Body = str_replace("[[sender]]", $sender_name, str_replace("[[patient_name]]", $patientfname, $myrow['reminder_content']));
				if(stristr($myrow['reminder_name'], "Followup") == TRUE)
				{
					$mail->Subject = "Health Maintenance Action Followup";
				}
				else
				{
					$mail->Subject = "Health Maintenance Action Reminder";
				}
				if(!$mail->Send()) {
					//echo "Email sent fail...<br><br>";
					sqlQuery("update patient_reminders set email_status='failed' where reminder_id=?", array($myrow['reminder_id']));
				}
				else
				{
					//echo "Email sent successfully...<br><br>";
					sqlQuery("update patient_reminders set email_status='sent' where reminder_id=?", array($myrow['reminder_id']));
				}
			}
			// Do a calling to patient if Allow Voice Message in Demographics is set to Yes.
			if ($hipaa_voice == "YES" and $myrow['voice_status'] == "pending")
			{
				// Automated VOIP service provided by Maviq. Please visit http://signup.maviq.com for more information.
				$siteId = $GLOBALS['phone_gateway_username'];
				$token = $GLOBALS['phone_gateway_password'];
				$endpoint = $GLOBALS['phone_gateway_url'];
				$client = new MaviqClient($siteId, $token, $endpoint);
				//Set up params.
				$data = array(
					"firstName" => $patientfname,
					"lastName" => $patientlname,	 
					"phone" => $patientphone,
					"apptDate" => "$scheduled_date[1]/$scheduled_date[2]/$scheduled_date[0]",
					"timeRange" => "10-18",
					"type" => "reminder",
					"timeZone" => date('P'),
					"greeting" => str_replace("[[sender]]", $sender_name, str_replace("[[patient_name]]", $patientfname, $myrow['reminder_content']))
				);
			
				// Make the call.
				$response = $client->sendRequest("appointment", "POST", $data);
	
				// Check response for calling success or error.
				if($response->IsError)
				{
					// echo "Phone call failed...<br><br>";
					sqlQuery("update patient_reminders set voice_status='failed' where reminder_id=?", array($myrow['reminder_id']));
				}
				else
				{
					// echo "Phone call done successfully...<br><br>";
					sqlQuery("update patient_reminders set voice_status='sent' where reminder_id=?", array($myrow['reminder_id']));
				}
			}
		}
	}
}
?> 
</body>
</html>