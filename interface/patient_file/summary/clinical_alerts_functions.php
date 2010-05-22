<?php
// Copyright (C) 2010 OpenEMR Support LLC   
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// Check and insert clinical alerts.
function insert_alert($pid) {
    $code = array();
    // Get the diagnosis (ICD) code for a patient.
    $sql = "SELECT diagnosis FROM lists WHERE pid = $pid AND type = 'medical_problem'";
    $dresult = sqlStatement($sql);

    while ($drows = sqlFetchArray($dresult)) {
        if (!empty($drows['diagnosis'])) {
            $tmp_diagnosis = explode(";", $drows['diagnosis']);
            foreach ($tmp_diagnosis as $val) {
                $diagnosis = explode(":", $val);
                if (!in_array($diagnosis[1],$code) and count($diagnosis) == 2 and $diagnosis[0] == 'ICD9') {
                     array_push($code,$diagnosis[1]);
                }
               }
          }
    }

    if (!empty($code)) {
        foreach ($code as $val) {
            if ($icd_include!="") $icd_include .= " OR ";
            if ($icd_exclude!="") $icd_exclude .= " AND ";
            $icd_include .= "icd_include ='".formDataCore($val)."' OR icd_include LIKE '".formDataCore($val)."::%' OR icd_include LIKE '%::".formDataCore($val)."::%' OR icd_include LIKE '%::".formDataCore($val)."'";
            $icd_exclude .= "icd_exclude !='".formDataCore($val)."' AND icd_exclude NOT LIKE '".formDataCore($val)."::%' AND icd_exclude NOT LIKE '%::".formDataCore($val)."::%' AND icd_exclude NOT LIKE '%::".formDataCore($val)."'";
          }
    }
    
    if ($icd_include != "") $sql_code_include .= " AND ((" . $icd_include . ") OR (icd_include = '' OR icd_include is NULL))";
    if ($icd_exclude != "") $sql_code_include .= " AND ((" . $icd_exclude . ") OR (icd_exclude = '' OR icd_exclude is NULL))";  

    // Get the CPT code for a patient.
    $sql = "SELECT DISTINCT(code) FROM billing WHERE pid = $pid AND code_type  = 'CPT4'";
    $cpt_result = sqlStatement($sql);
    while ($cpt_rows = sqlFetchArray($cpt_result)) {
        $cpt_code = $cpt_rows['code'];
        if ($cpt_include != "") $cpt_include .= " OR ";
        if ($cpt_exclude != "") $cpt_exclude .= " AND ";
        $cpt_include .= "cpt_include ='".formDataCore($cpt_code)."' OR cpt_include LIKE '".formDataCore($cpt_code)."::%' OR cpt_include LIKE '%::".formDataCore($cpt_code)."::%' OR cpt_include LIKE '%::".formDataCore($cpt_code)."'";
        $cpt_exclude .= "cpt_exclude !='".formDataCore($cpt_code)."' AND cpt_exclude NOT LIKE '".formDataCore($cpt_code)."::%' AND cpt_exclude NOT LIKE '%::".formDataCore($cpt_code)."::%' AND cpt_exclude NOT LIKE '%::".formDataCore($cpt_code)."'";
    }
    
    if ($cpt_include != "") $sql_code_include .= " AND ((" . $cpt_include . ") OR (cpt_include = '' OR cpt_include is NULL))";
    if ($cpt_exclude != "") $sql_code_include .= " AND ((" . $cpt_exclude . ") OR (cpt_exclude = '' OR cpt_exclude is NULL))"; 

    // Get medication for a patient.
    $sql = "SELECT DISTINCT(title) FROM lists WHERE pid = $pid AND type  = 'medication'";
    $medication_result = sqlStatement($sql);
    while ($medication_rows = sqlFetchArray($medication_result)) {
        $ndc_code = $medication_rows['title'];
          if ($ndc_include != "") $ndc_include .= " OR ";
        if ($ndc_exclude != "") $ndc_exclude .= " AND ";
        $ndc_include .= "ndc_include ='".formDataCore($ndc_code)."' OR ndc_include LIKE '".formDataCore($ndc_code)."::%' OR ndc_include LIKE '%::".formDataCore($ndc_code)."::%' OR ndc_include LIKE '%::".formDataCore($ndc_code)."'";
        $ndc_exclude .= "ndc_exclude !='".formDataCore($ndc_code)."' AND ndc_exclude NOT LIKE '".formDataCore($ndc_code)."::%' AND ndc_exclude NOT LIKE '%::".formDataCore($ndc_code)."::%' AND ndc_exclude NOT LIKE '%::".formDataCore($ndc_code)."'";
    }
    
    if ($ndc_include != "") $sql_code_include .= " AND ((" . $ndc_include . ") OR (ndc_include = '' OR ndc_include IS NULL))";
    if ($ndc_exclude != "") $sql_code_include .= " AND ((" . $ndc_exclude . ") OR (ndc_exclude = '' OR ndc_exclude is NULL))"; 

    // Get allergies for a patient.
    $sql = "SELECT DISTINCT(title) FROM lists WHERE pid = $pid AND type  = 'allergy'";
    $allergy_result = sqlStatement($sql);
    while ($allergy_rows = sqlFetchArray($allergy_result)) {
        $allergy_title = $allergy_rows['title'];
          if ($allergy_include != "") $allergy_include .= " OR ";
        if ($allergy_exclude != "") $allergy_exclude .= " AND ";
        $allergy_include .= "allergy_include ='".formDataCore($allergy_title)."' OR allergy_include LIKE '".formDataCore($allergy_title)."::%' OR allergy_include LIKE '%::".formDataCore($allergy_title)."::%' OR allergy_include LIKE '%::".formDataCore($allergy_title)."'";
        $allergy_exclude .= "allergy_exclude !='".formDataCore($allergy_title)."' AND allergy_exclude NOT LIKE '".formDataCore($allergy_title)."::%' AND allergy_exclude NOT LIKE '%::".formDataCore($allergy_title)."::%' AND allergy_exclude NOT LIKE '%::".formDataCore($allergy_title)."'";
    }
    
    if ($allergy_include != "") $sql_code_include .= " AND ((" . $allergy_include . ") OR (allergy_include = '' OR allergy_include is NULL))";
    if ($allergy_exclude != "") $sql_code_include .= " AND ((" . $allergy_exclude . ") OR (allergy_exclude = '' OR allergy_exclude is NULL))"; 

    // Get the history/lifestyle or a patient.
    // get fields name from layout_options where the data type = 28 (lifestyle)
    $sql = "SELECT field_id, title FROM layout_options WHERE form_id = 'HIS' AND data_type  = '28'";
    $his_result = sqlStatement($sql);
    while ($his_rows = sqlFetchArray($his_result)) {
	  	// check if field exist
	  	$check_field = sqlQuery("SHOW COLUMNS FROM history_data LIKE '".$his_rows['field_id']."'");
	  	if (!empty($check_field)) {
	   		// get the lifestyle code from history_data
	   		$lifestyle_row = sqlQuery("SELECT ".$his_rows['field_id']." AS lifestyle FROM history_data where ".$his_rows['field_id']." NOT LIKE '%|not_applicable%'");
			$tmp = explode("|", $lifestyle_row['lifestyle']);
			if ($tmp[0] or $tmp[1])
			{
				$tmp[1] = ucfirst(str_replace($his_rows['field_id'], "", $tmp[1]));
                if ($patient_history_include != "") $patient_history_include .= " OR ";
                if ($patient_history_exclude != "") $patient_history_exclude .= " AND ";
                $patient_history_include .= "patient_history_include LIKE '%||$tmp[1] ".$his_rows['title']."%' OR patient_history_include LIKE '%||$tmp[1] ".$his_rows['title']."'";
                $patient_history_exclude .= "patient_history_exclude NOT LIKE '%||$tmp[1] ".$his_rows['title']."%' AND patient_history_exclude NOT LIKE '%||$tmp[1] ".$his_rows['title']."'";
			}
	  	}
    }
    
    if ($patient_history_include != "") $sql_code_include .= " AND ((" . $patient_history_include . ") OR (patient_history_include = '' OR patient_history_include is NULL))";
    if ($patient_history_exclude != "") $sql_code_include .= " AND ((" . $patient_history_exclude . ") OR (patient_history_exclude = '' OR patient_history_exclude is NULL))";
	
    // Get lab results for a patient.
    $sql = "SELECT procedure_type_id FROM procedure_result WHERE abnormal = 'yes'";
    $lab_abnormal_result = sqlStatement($sql);
    while ($lab_abnormal_rows = sqlFetchArray($lab_abnormal_result)) {
        $lab_type = $lab_abnormal_rows['procedure_type_id'];
          if ($lab_abnormal_result_include != "") $lab_abnormal_result_include .= " OR ";
        if ($lab_abnormal_result_exclude != "") $lab_abnormal_result_exclude .= " AND ";
        $lab_abnormal_result_include .= "lab_abnormal_result_include ='".formDataCore($lab_type)."' OR lab_abnormal_result_include LIKE '".formDataCore($lab_type)."::%' OR lab_abnormal_result_include LIKE '%::".formDataCore($lab_type)."::%' OR lab_abnormal_result_include LIKE '%::".formDataCore($lab_type)."'";
        $lab_abnormal_result_exclude .= "lab_abnormal_result_exclude !='".formDataCore($lab_type)."' AND lab_abnormal_result_exclude NOT LIKE '".formDataCore($lab_type)."::%' AND lab_abnormal_result_exclude NOT LIKE '%::".formDataCore($lab_type)."::%' AND lab_abnormal_result_exclude NOT LIKE '%::".formDataCore($lab_type)."'";
    }
    
    if ($lab_abnormal_result_include != "") $sql_code_include .= " AND ((" . $lab_abnormal_result_include . ") OR (lab_abnormal_result_include = '' OR lab_abnormal_result_include is NULL))";
    if ($lab_abnormal_result_exclude != "") $sql_code_include .= " AND ((" . $lab_abnormal_result_exclude . ") OR (lab_abnormal_result_exclude = '' OR lab_abnormal_result_exclude is NULL))"; 

    $i = 0;
    $sql_where = "activation_status = 'activate'";
    
    // Get demographic information for a patient.
    $prow = sqlQuery("SELECT lname, fname, sex,(YEAR(CURDATE())-YEAR(DOB))-(RIGHT(CURDATE(),5)<RIGHT(DOB,5)) AS age, (MONTH(CURDATE())-MONTH(DOB))-(RIGHT(CURDATE(),2)<RIGHT(DOB,2)) AS month FROM patient_data WHERE pid = '$pid'");
    $patient_name = $prow['lname'] . ", " . $prow['fname'];
    $patient_age = $prow['age'];
    $patient_month = $prow['month'];
    if ($patient_month < 0) $patient_month += 12;
    $patient_gender = $prow['sex'];
    $sql_where .= " AND ((age_from <= ".$patient_age." AND month_from <= ".$patient_month.") " .
    "OR (age_from = '' AND month_from <= ".$patient_month.") " . 
    "OR (age_from IS NULL AND month_from <= ".$patient_month.") " .
    "OR (age_from <= ".$patient_age." AND month_from = '') " . 
    "OR (age_from <= ".$patient_age." AND month_from IS NULL) " .
    "OR (age_from IS NULL AND month_from IS NULL) " .
    "OR (age_from = '' AND month_from = '') " .
    "OR (age_from < $patient_age)) " .
    "AND ((age_to >= ".$patient_age." AND month_to >= ".$patient_month.") " .
    "OR (age_to = '' AND month_to >= ".$patient_month.") " . 
    "OR (age_to IS NULL AND month_to >= ".$patient_month.") " .
    "OR (age_to >= ".$patient_age." AND month_to = '') " . 
    "OR (age_to >= ".$patient_age." AND month_to IS NULL)" .
    "OR (age_to > $patient_age) " .
    "OR (age_to = '' AND month_to = '')" .
    "OR (age_to IS NULL AND month_to IS NULL))";

    if ($patient_gender != "") {
        $sql_where .= " AND (gender = '".$patient_gender."' OR gender = '' OR gender IS NULL)";
    }
    
    // Search for available health plans.
    $sql = "SELECT plan_id FROM health_plans WHERE $sql_where $sql_code_include";
    // echo $sql;
    $presult = sqlStatement($sql);
    while ($prows = sqlFetchArray($presult)) {
        // Show the plan if the patient has not enrolled in it.
        // Unset to make sure it's empty.
        unset($check2);
        unset($check_alert);
        unset($check);
        // Check to see if a patient is enrolled in the plan.
        // $check = sqlQuery("SELECT COUNT(*) AS count FROM health_plan_enrollment WHERE patient_id = '$pid' and plan_id = '".$prows['plan_id']."'");
        // Check to see if any alert exists.
        $check_alert = sqlQuery("SELECT alert_id, activated FROM clinical_alerts WHERE plan_id = '".$prows['plan_id']."'");
        if ($check_alert['alert_id']) {
            $check2 = sqlQuery("SELECT COUNT(*) AS count FROM patient_alerts WHERE pid = '$pid' and alert_id = '".$check_alert['alert_id']."'");
        }
        // Store clinical alert information.
        if ($check2['count'] <= 0 and !empty($check_alert['alert_id'])) {
            sqlStatement("INSERT INTO patient_alerts SET alert_id = '".$check_alert['alert_id']."', pid= '$pid', status = 'New', date_modified = '".date("Y-m-d")."'");
        }
    }
}

// Check clinical alerts.
function check_alerts($pid) {

    if (!empty($pid)) {
        $check = 0;
        // Get alert plan_id.
        $sql = "SELECT clinical_alerts.plan_id AS plan_id FROM patient_alerts JOIN clinical_alerts ON patient_alerts.alert_id= clinical_alerts.alert_id WHERE patient_alerts.pid = '$pid' AND patient_alerts.status != 'Done'";
        $result = sqlStatement($sql);
        while ($rows = sqlFetchArray($result)) {
             if ($rows['plan_id'] == '') {
                  $check += 1;
             } else {
               // Check health plan enrollment for a patient.
                   $enrollresult = sqlStatement("SELECT action_completed FROM health_plan_enrollment WHERE patient_id = '".formDataCore($pid)."' AND plan_id = '".formDataCore($rows['plan_id'])."'");
				   if ($enrollrow = sqlFetchArray($enrollresult)) { // if patient enrolled
                    $reminder_sql = "SELECT scheduled_date FROM patient_reminders WHERE patient_id = '".formDataCore($pid)."' AND plan_id = '".formDataCore($rows['plan_id'])."'";
                    $reminderresult = sqlStatement($reminder_sql);
                    while ($reminderrow = sqlFetchArray($reminderresult))
                    {
                          // Select the action completion status based on health plan enrollment ID.
                          $action_completed = explode(",", $enrollrow['action_completed']);
                          $now = date("Ymd");
                          $date = explode("-", $reminderrow['scheduled_date']);
                          $scheduled_date = $date[2].$date[1].$date[0];
                          // Check past due actions.
                          if (!in_array($reminderrow['action_id']."-YES", $action_completed) and $now >= $scheduled_date) {
                               $check += 1;
                          }
                     }
                   } else {
                    $check += 1;
                   }
             }
        }

        if ($check > 0) { // Show popup with alert messages.
        ?>
            <script LANGUAGE="JavaScript">
              dlgopen('../summary/clinical_alerts_popup.php?pid=' + <?php echo $pid; ?>, '_blank', 700, 400);
             </script>
            <?php
        }
    }else{
        return false;
    }
}

// Add alert messages.
function admin_create_alerts($alert_name, $plan_id, $color = 'Black') {

    $crow = sqlQuery("SELECT COUNT(*) AS count FROM clinical_alerts WHERE plan_id = '" . formDataCore($plan_id) . "'");
     if ($crow['count'] > 0) {
          return false;
     } else {
          $row = sqlQuery("SELECT * FROM health_plans WHERE plan_id = '$plan_id'");
          $plan_name = $row['plan_name'];
          if ($plan_name != "") {
               $message = "The patient is a candidate for \"$plan_name\" health plan. Please consider asking him/her to enroll in the plan.";
               $past_due_message = "One or more actions from $plan_name Health Plan is past due. Please check the status with the patient.";
          }
          $sql =
           "alert_name = '" . $alert_name . "', " .
           "color ='" . formDataCore($color) . "', " .
           "plan_id ='" . formDataCore($plan_id) . "', " .
           "message ='" . formDataCore($message) . "'," .
           "past_due_message ='" . formDataCore($past_due_message) . "'";
           sqlStatement("INSERT INTO clinical_alerts SET $sql");
     }
}

?>
