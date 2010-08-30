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

// Enroll the health plan for the patient
function health_plans_enrollment($plan_id, $pid, $enroll_id, $reminderstatus, $type) {

	// Select the plan name based on plan ID.
	$planrow = sqlQuery("select plan_name from health_plans where plan_id = ?", array($plan_id));

	// Get the sender name for the reminder and followup message.
	$patient = sqlQuery("select fname from patient_data where pid=?", array($pid));

	// Get the sender name for the reminder and followup message.
	$sender = sqlQuery("select sender_name from patient_reminders where reminder_name=?", array('Sender Details'));

	// Select the plan action based on plan ID.
	$actionsql = "select * from health_plan_actions where plan_id = ? order by action_id";
	$actionresult = sqlStatement($actionsql, array($plan_id));
	$count = 0;
	$subcount = 0;
	$form_action_targetdate = array();
	$form_action_completed = array();
	while ($myactionrow = sqlFetchArray($actionresult)) {
		switch($type)
		{
			case "admin" : {
				if ($myactionrow['subactions'] != "" && $myactionrow['subactions'] != NULL) {
					$subcount = 0;
					if ($myactionrow['subactions'] == 0)
					{
						++$count;
						if ($myactionrow['action_targetdate']) {
							$form_action_targetdate[] = ${"form_action_targetdate_$count"} = $myactionrow['action_targetdate'];
						}
					}
				}
				else {
					++$subcount;
					if ($myactionrow['action_targetdate']) {
						$form_action_targetdate[] = ${"form_action_targetdate_$count-$subcount"} = $myactionrow['action_targetdate'];
					}
				}
			} break;
			case "batch" : {
				if ($myactionrow['subactions'] <= 0)
				{
					++$count;
					global ${"form_action_targetdate_$count"}, ${"form_action_completed_$count"};
					$form_action_targetdate[] = ${"form_action_targetdate_$count"};
					$form_action_completed[] = ${"form_action_completed_$count"};
				}
			} break;
			case "patient" : {
				if ($myactionrow['subactions'] != "" && $myactionrow['subactions'] != NULL) {
					$subcount = 0;
					++$count;
					if ($myactionrow['subactions'] == 0)
					{
						if (formData('form_action_targetdate_'.$count,'P',true)) {
							$form_action_targetdate[] = ${"form_action_targetdate_$count"} = formData('form_action_targetdate_'.$count,'P',true);
						}
						else {
							$form_action_targetdate[] = "0000-00-00";
						}
						if (formData('completed_'.$count,'P',true)) {
							$form_action_completed[] = $myactionrow['action_id']."-"."YES";
						}
						else {
							$form_action_completed[] = $myactionrow['action_id']."-"."NO";
						}
						$total_action = 1;
					}
				}
				else {
					++$subcount;
					if (formData("form_action_targetdate_$count-$subcount",'P',true)) {
						$form_action_targetdate[] = ${"form_action_targetdate_$count-$subcount"} = formData("form_action_targetdate_$count-$subcount",'P',true);
					}
					else {
						$form_action_targetdate[] = "0000-00-00";
					}
					if (formData("completed_$count-$subcount",'P',true)) {
						$form_action_completed[] = $myactionrow['action_id']."-"."YES";
					}
					else {
						$form_action_completed[] = $myactionrow['action_id']."-"."NO";
					}
					$total_action = $subcount;
				}
			} break;
		}
		
		if (${"form_action_targetdate_$count-$subcount"}) {
			${"form_action_targetdate_$count"} = ${"form_action_targetdate_$count-$subcount"};
		}

		if (${"form_action_targetdate_$count"} and ${"form_action_targetdate_$count"} != "0000-00-00") {
			$form_scheduled_date = explode("-", ${"form_action_targetdate_$count"});
			if ($myactionrow['reminder_timeframe'] > 0)
			{
				$reminder_scheduled_date = date("Y-m-d", mktime(0, 0, 0, $form_scheduled_date[1], $form_scheduled_date[2] - $myactionrow['reminder_timeframe'], $form_scheduled_date[0]));

				// Add a new reminder for a specific patient.
				//sqlQuery("insert into patient_reminders value (0, '".$planrow['plan_name']." Action # $count - Reminder', '$pid', '$reminder_scheduled_date', 'Dear ".$patient['fname'].":\n\nYou have a health maintenance activity targeted for ".${"form_action_targetdate_$count"}.". Please call our office for more information and to schedule an appointment if needed.\n\nRegards,\n".$sender['sender_name']."', '', '', '', '$enroll_id', '$plan_id', '".$myactionrow['action_id']."', '', '$reminderstatus', '$reminderstatus', '$reminderstatus')");
				sqlQuery("insert into patient_reminders value (0, '".$planrow['plan_name']." Action # $count - Reminder', '$pid', '$reminder_scheduled_date', 'Dear [[patient_name]]:\n\nYou have a health maintenance activity targeted for ".${"form_action_targetdate_$count"}.". Please call our office for more information and to schedule an appointment if needed.\n\nRegards,\n[[sender]]', '', '', '', '$enroll_id', '$plan_id', '".$myactionrow['action_id']."', '', '$reminderstatus', '$reminderstatus', '$reminderstatus')");
			}
			if ($myactionrow['followup_timeframe'] > 0)
			{
				$followup_scheduled_date = date("Y-m-d", mktime(0, 0, 0, $form_scheduled_date[1], $form_scheduled_date[2] + $myactionrow['followup_timeframe'], $form_scheduled_date[0]));

				// Add a new followup for a specific patient.
				//sqlQuery("insert into patient_reminders value (0, '".$planrow['plan_name']." Action # $count - Followup', '$pid', '$followup_scheduled_date', 'Dear ".$patient['fname'].":\n\nYou have a health maintenance activity targeted for ".${"form_action_targetdate_$count"}.". Please call our office for more information and to schedule an appointment if needed.\n\nRegards,\n".$sender['sender_name']."', '', '', '', '$enroll_id', '$plan_id', '".$myactionrow['action_id']."', '', '$reminderstatus', '$reminderstatus', '$reminderstatus')");
				sqlQuery("insert into patient_reminders value (0, '".$planrow['plan_name']." Action # $count - Followup', '$pid', '$followup_scheduled_date', 'Dear [[patient_name]]:\n\nYou have a health maintenance activity targeted for ".${"form_action_targetdate_$count"}.". Please call our office for more information and to schedule an appointment if needed.\n\nRegards,\n[[sender]]', '', '', '', '$enroll_id', '$plan_id', '".$myactionrow['action_id']."', '', '$reminderstatus', '$reminderstatus', '$reminderstatus')");
			}
		}
	}
	switch($type)
	{
		case "admin" : {
			// Update the signup date and action date from the reminder of the enrollment.
			if ($form_action_targetdate) {
				sqlQuery("update health_plan_enrollment set action_date='".implode(",", $form_action_targetdate)."' where enroll_id=?", array($enroll_id));
			}
		} break;
		case "batch" :
		case "patient" : {
			// Update the action date from the reminder of the enrollment.
			sqlQuery("update health_plan_enrollment set action_date='".implode(",", $form_action_targetdate)."', action_completed ='".implode(",", $form_action_completed)."' where enroll_id=?", array($enroll_id));
	
			if (formData("form_signup_date") && formData("form_enrollment_status")) {
				// Update the signup date and action date from the reminder of the enrollment.
				sqlQuery("update health_plan_enrollment set signup_date='".formData("form_signup_date")."', status='".formData("form_enrollment_status")."' where enroll_id=?", array($enroll_id));
			}
		} break;
	}
}

?>
