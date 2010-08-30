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
include_once("$srcdir/sql.inc");
include_once("$srcdir/formdata.inc.php");

// Add an alert message when the condition is met.
$plan_id = formData("plan_id","P");
if ($plan_id != "") {
	$row = sqlQuery("SELECT * FROM health_plans WHERE plan_id = ?", array($plan_id));
	$plan_name = htmlspecialchars($row['plan_name'], ENT_QUOTES);
	if ($plan_name != "") {
		$message = "The patient is a candidate for \"$plan_name\" health plan. Please consider asking him/her to enroll in the plan.";
    	$past_due_message = "One or more actions from $plan_name Health Plan is past due. Please check the status with the patient.";
  		echo $message."::".$past_due_message;
	}
	else
	{
		echo "";
 	}
}
?>
