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
include_once("../../../custom/code_types.inc.php");
include_once("$srcdir/sql.inc");
include_once("$srcdir/options.inc.php");
include_once("$srcdir/formdata.inc.php");
include_once("../summary/clinical_alerts_functions.php");
require_once("health_plans_functions.php");

$alertmsg = '';
$task = htmlspecialchars($_REQUEST['task'], ENT_QUOTES);
$sortby = htmlspecialchars($_REQUEST['sortby'], ENT_QUOTES);
$sortorder = htmlspecialchars($_REQUEST['sortorder'], ENT_QUOTES);
$begin = htmlspecialchars($_REQUEST['begin'], ENT_QUOTES);
$plan_id = 0;
$total_action = 0;
$plan_id = formData('plan_id','P',true);  // Get plan id.
// Get post value for add or update plan.
if ($task == "add" or $task == "update") {
    $plan_name = formData('plan_name','P',true);
    $description = formData('description','P',true);
    $category = formData('form_category','P',true);
    $gender = formData('form_gender','P',true);
    $fromage = formData('fromage','P',true);
    $toage = formData('toage','P',true);
    $from_month = formData('from_month','P',true);
    $to_month = formData('to_month','P',true);
    $rule = $_POST['rule'];
	if (formData('include_icd_show','P',true))
	{
		$icd_include = formDataCore($rule['include_icd']['codes'],true);
	}
	if (formData('include_cpt_show','P',true))
	{
		$cpt_include = formDataCore($rule['include_cpt']['codes'],true);
	}
	if (formData('include_ndc_show','P',true))
	{
		$ndc_include = formDataCore($rule['include_ndc']['codes'],true);
	}
	if (formData('include_allergy_show','P',true))
	{
		$allergy_include = formDataCore($rule['include_allergy']['codes'],true);
	}
	if (formData('include_pt_history_show','P',true))
	{
		if (formDataCore($rule['include_patient_history']['codes'],true)) {
			$include_patient_history_codes = explode("::", formDataCore($rule['include_patient_history']['codes'],true));
			$include_patient_history_descs = explode("::", formDataCore($rule['include_patient_history']['descs'],true));
		}
		$patient_history_include = "";
		for ($i = 0; $i < count($include_patient_history_codes); ++ $i) {
			$patient_history_include[] = trim(str_replace($include_patient_history_codes[$i], "", $include_patient_history_descs[$i]))."||".$include_patient_history_codes[$i];
		}
		if ($patient_history_include) {
			$patient_history_include = implode("::", $patient_history_include);
		}
	}
	if (formData('include_lab_show','P',true))
	{
		$include_lab_abnormal_result_history = explode("::", formDataCore($rule['include_lab_abnormal_result_history']['codes'],true));
		$lab_abnormal_result_include = "";
		for ($i = 0; $i < count($include_lab_abnormal_result_history); ++ $i) {
			$check_procedure = sqlQuery("SELECT procedure_type_id FROM procedure_type WHERE name LIKE ?", array($include_lab_abnormal_result_history[$i]));
			$lab_abnormal_result_include[] = $check_procedure['procedure_type_id'];
		}
		if ($lab_abnormal_result_include) {
			$lab_abnormal_result_include = implode("::", $lab_abnormal_result_include);
		}
	}
	if (formData('exclude_icd_show','P',true))
	{
		$icd_exclude = formDataCore($rule['exclude_icd']['codes'],true);
	}
	if (formData('exclude_cpt_show','P',true))
	{
		$cpt_exclude = formDataCore($rule['exclude_cpt']['codes'],true);
	}
	if (formData('exclude_ndc_show','P',true))
	{
		$ndc_exclude = formDataCore($rule['exclude_ndc']['codes'],true);
	}
	if (formData('exclude_allergy_show','P',true))
	{
		$allergy_exclude = formDataCore($rule['exclude_allergy']['codes'],true);
	}
	if (formData('exclude_pt_history_show','P',true))
	{
		if (formDataCore($rule['exclude_patient_history']['codes'],true)) {
			$exclude_patient_history_codes = explode("::", formDataCore($rule['exclude_patient_history']['codes'],true));
			$exclude_patient_history_descs = explode("::", formDataCore($rule['exclude_patient_history']['descs'],true));
		}
		$patient_history_exclude = "";
		for ($i = 0; $i < count($exclude_patient_history_codes); ++ $i) {
			$patient_history_exclude[] = trim(str_replace($exclude_patient_history_codes[$i], "", $exclude_patient_history_descs[$i]))."||".$exclude_patient_history_codes[$i];
		}
		if ($patient_history_exclude) {
			$patient_history_exclude = implode("::", $patient_history_exclude);
		}
	}
	if (formData('exclude_lab_show','P',true))
	{
		$exclude_lab_abnormal_result_history = explode("::", formDataCore($rule['exclude_lab_abnormal_result_history']['codes'],true));
		$lab_abnormal_result_exclude = "";
		for ($i = 0; $i < count($exclude_lab_abnormal_result_history); ++ $i) {
			$check_procedure = sqlQuery("SELECT procedure_type_id FROM procedure_type WHERE name LIKE ?", array($exclude_lab_abnormal_result_history[$i]));
			$lab_abnormal_result_exclude[] = $check_procedure['procedure_type_id'];
		}
		if ($lab_abnormal_result_exclude) {
			$lab_abnormal_result_exclude = implode("::", $lab_abnormal_result_exclude);
		}
	}
    $plan_goal = formData('plan_goal','P',true);
    $total_action = formData('total_action','P',true);
    for ($k=1;$k<=$total_action;$k++) {
        ${"plan_action_$k"} = formData('plan_action_'.$k,'P',true);
		${"frequency_$k"} = formData('frq_year_'.$k,'P',true)."::".formData('frq_month_'.$k,'P',true);
        ${"total_subaction_$k"} = formData('total_subaction_'.$k,'P',true);
		if (${"total_subaction_$k"} > 0)
		{
			for ($l=1;$l<=${"total_subaction_$k"};$l++) {
				${"plan_action_$k-$l"} = formData("plan_action_$k-$l",'P',true);
				${"form_action_targetdate_$k-$l"} = formData("form_action_targetdate_$k-$l",'P',true);
				${"reminder_timeframe_$k-$l"} = formData("reminder_timeframe_$k-$l",'P',true);
				${"followup_timeframe_$k-$l"} = formData("followup_timeframe_$k-$l",'P',true);
				${"completed_$k-$l"} = formData("completed_$k-$l",'P',true);
			}
		}
		else
		{
			${"form_action_targetdate_$k"} = formData('form_action_targetdate_'.$k,'P',true);
			${"reminder_timeframe_$k"} = formData('reminder_timeframe_'.$k,'P',true);
			${"followup_timeframe_$k"} = formData('followup_timeframe_'.$k,'P',true);
			${"completed_$k"} = formData('completed_'.$k,'P',true);
		}
    }
    $activation_status = formData('activation_status','P',true);
    
    // Get the filter age and month.
	$sqlBindArray = array();
    if ($from_month == "" and $fromage == "" and $to_month=="" and $toage=="") {
        $where_age = "";
    }
    else {
        // Get the from age and month values.
        if (($from_month == "0" or $from_month == "") and ($fromage == "0" or $fromage == "")){
            $formdate = date("Y-m-d");
        }
        else {
            $formdate = date("Y-m-d", mktime(0, 0, 0, date("m") - $from_month, date("d"), date("Y") - $fromage));
        }
        // Get the to age and month values.
        if (($to_month == "0" or $to_month == "") and ($toage == "0" or $toage == "")) {
            $todate = "0000-00-00";
        }
        else {
            $todate = date("Y-m-d", mktime(0, 0, 0, date("m") - $to_month, date("d"), date("Y") - $toage));
        }
        $where_age = "AND DOB BETWEEN ? AND ?";
		array_push($sqlBindArray, $todate, $formdate);
    }
    // Get the filter gender values.
    if ($gender=="") {
        $sex = "";
    } 
    else {
        $sex = "AND sex = ?";
		array_push($sqlBindArray, $gender);
    }
    
    if ($activation_status=="activate") {
        $status = "in_progress";
    } 
    else {
        $status = "cancelled";
    }
}
switch($task) {
    case "delete": {
        // Delete selected plan(s) from the Health Plans box (only).
        $delete_id = $_POST['delete_id'];
        for($i = 0; $i < count($delete_id); $i++) {
            $checkdel = sqlQuery("SELECT COUNT(*) AS count FROM health_plan_enrollment WHERE plan_id = ?", array(formDataCore($delete_id[$i]))); // check if any patients under this plan
            if ($checkdel['count']) {
              $alertmsg = xl("Cannot delete this entry because it\'s being used!");
            } 
            else {
                sqlStatement("DELETE FROM health_plans WHERE plan_id = ?", array(formDataCore($delete_id[$i])));
                sqlStatement("DELETE FROM health_plan_actions WHERE plan_id = ?", array(formDataCore($delete_id[$i])));
                sqlStatement("DELETE FROM health_plan_enrollment WHERE plan_id = ?", array(formDataCore($delete_id[$i])));
                sqlStatement("DELETE FROM patient_reminders WHERE plan_id = ?", array(formDataCore($delete_id[$i])));
                $getalerts = sqlQuery("SELECT alert_id FROM clinical_alerts WHERE plan_id = ?", array(formDataCore($delete_id[$i])));
                sqlStatement("DELETE FROM clinical_alerts where plan_id=?", array(formDataCore($delete_id[$i])));
                sqlStatement("DELETE FROM patient_alerts where alert_id=?", array(formDataCore($getalerts['alert_id'])));
            }
        }
        $task = "";
      } break;
    case "add":
    case "update": {
        // This covers both the adding and modification of health plans.
        $crow = sqlQuery("SELECT COUNT(*) AS count FROM health_plans WHERE plan_name = ? AND plan_id != ?", array($plan_name, $plan_id));
        if ($crow['count']) {
            $alertmsg = xl('Cannot add/update this entry because a duplicate already exists!');
            $task == "add"?$task = "addnew": $task = "edit";
        } 
        else {
            $sql =
            "plan_name = '" . $plan_name . "', " .
            "plan_description ='" . $description . "', " .
            "category ='" . $category . "', " .
            "gender ='" . $gender . "', " .
            "age_from ='" . $fromage . "', " .
            "age_to ='" . $toage . "', " .
            "month_from ='" . $from_month . "', " .
            "month_to ='" . $to_month . "', " .
            "icd_include ='" . $icd_include . "', " .
            "cpt_include ='" . $cpt_include . "', " .
            "ndc_include ='" . $ndc_include . "', " .
            "allergy_include ='" . $allergy_include . "', " .
            "patient_history_include ='" . $patient_history_include . "', " .
            "lab_abnormal_result_include ='" . $lab_abnormal_result_include . "', " .
            "icd_exclude ='" . $icd_exclude . "', " .
            "cpt_exclude ='" . $cpt_exclude . "', " .
            "ndc_exclude ='" . $ndc_exclude . "', " .
            "allergy_exclude ='" . $allergy_exclude . "', " .
            "patient_history_exclude ='" . $patient_history_exclude . "', " .
            "lab_abnormal_result_exclude ='" . $lab_abnormal_result_exclude . "', " .
            "goals ='" . $plan_goal . "', " .
            "activation_status ='" . $activation_status . "' ";
            //if (!empty($icd_include) or !empty($icd_exclude)) $icd_where = " AND code_type = 'ICD9'";
			$icd_sqlBindArray = array();
			
			if (!empty($icd_include) or !empty($icd_exclude)) {
				$icd_where = " AND type = 'medical_problem'";
			}
			
            if (!empty($cpt_include) or !empty($cpt_exclude)) {
				$cpt_where = " AND code_type = 'CPT4'";
			}
			
            //if (!empty($icd_include)) $icd_where .= " AND code IN ('".str_replace("::","','",$icd_include)."')";
			if (!empty($icd_include)) {
				$temp_arr_icd_include = explode("::", $icd_include);
				$temp_diagnosis_include="";
				for ($t=0;$t<count($temp_arr_icd_include);$t++){
					if($temp_arr_icd_include[$t]!=""){
						if ($temp_diagnosis_include!="") {
							$temp_diagnosis_include .= " OR ";
						}
						$temp_diagnosis_include .= "(diagnosis=? or diagnosis LIKE ? or diagnosis LIKE ? or diagnosis LIKE ?)";
						array_push($icd_sqlBindArray, "ICD9:".$temp_arr_icd_include[$t], "ICD9:$temp_arr_icd_include[$t];%", "%;ICD9:$temp_arr_icd_include[$t];%", "%;ICD9:$temp_arr_icd_include[$t]");
					}
				}
				$icd_where .= " AND ($temp_diagnosis_include)";
			}
            //if (!empty($icd_exclude)) $icd_where .= " AND code NOT IN ('".str_replace("::","','",$icd_exclude)."')";
			if (!empty($icd_exclude)) {
				$temp_arr_icd_exclude = explode("::", $icd_exclude);
				$temp_diagnosis_exclude="";
				for ($t=0;$t<count($temp_arr_icd_exclude);$t++){
					if($temp_arr_icd_exclude[$t]!=""){
						if ($temp_diagnosis_exclude!="") {
							$temp_diagnosis_exclude .= " AND "; 
						}
						$temp_diagnosis_exclude .= "(diagnosis!=? AND diagnosis NOT LIKE ? AND diagnosis NOT LIKE ? AND diagnosis NOT LIKE ?)";
						array_push($icd_sqlBindArray, "ICD9:$temp_arr_icd_include[$t]", "ICD9:$temp_arr_icd_include[$t];%", "%;ICD9:$temp_arr_icd_include[$t];%", "%;ICD9:$temp_arr_icd_include[$t]");
					}
				}
				$icd_where .= " AND ($temp_diagnosis_exclude)";
			}
            if (!empty($cpt_include)) $cpt_where .= " AND code IN ('".str_replace("::","','",$cpt_include)."')";
            if (!empty($cpt_exclude)) $cpt_where .= " AND code NOT IN ('".str_replace("::","','",$cpt_exclude)."')";
            if (!empty($ndc_include) or !empty($ndc_exclude)) $ndc_where = " AND type = 'medication'";
            if (!empty($ndc_include)) $ndc_where .= " AND title IN ('".str_replace("::","','",$ndc_include)."')";
            if (!empty($ndc_exclude)) $ndc_where .= " AND title NOT IN ('".str_replace("::","','",$ndc_exclude)."')";
            if (!empty($allergy_include) or !empty($allergy_exclude)) $allergy_where = " AND type = 'allergy'";
            if (!empty($allergy_include)) $allergy_where .= " AND title IN ('".str_replace("::","','",$allergy_include)."')";
            if (!empty($allergy_exclude)) $allergy_where .= " AND title NOT IN ('".str_replace("::","','",$allergy_exclude)."')";
            if (!empty($lab_abnormal_result_include) or !empty($lab_abnormal_result_exclude)) $lab_abnormal_result_where = " AND procedure_result.abnormal = 'yes'";
            if (!empty($lab_abnormal_result_include)) $lab_abnormal_result_where .= " AND procedure_result.procedure_type_id IN ('".str_replace("::","','",$lab_abnormal_result_include)."')";
            if (!empty($lab_abnormal_result_exclude)) $lab_abnormal_result_where .= " AND procedure_result.procedure_type_id NOT IN ('".str_replace("::","','",$lab_abnormal_result_exclude)."')";
            $patientid = array();
      
            if ($task == "update") {
                $query = "UPDATE health_plans SET $sql WHERE plan_id = ?";
                sqlStatement($query, array($plan_id));
                sqlStatement("DELETE FROM health_plan_actions WHERE plan_id = ?", array($plan_id));
                for ($k=1;$k<=$total_action;$k++) {
                    $sql_action = "";
                    $sql_action = 
                    "plan_id ='" . $plan_id . "', " .
                    "action_content ='" . ${"plan_action_$k"} . "', " .
                    "frequency ='" . ${"frequency_$k"} . "', " .
                    "subactions ='" . ${"total_subaction_$k"} . "', " .
                    "action_targetdate ='" . ${"form_action_targetdate_$k"} . "', " .
                    "reminder_timeframe ='" . ${"reminder_timeframe_$k"} . "', " .
                    "followup_timeframe ='" . ${"followup_timeframe_$k"} . "', " .
                    "completed ='" . ${"completed_$k"} . "'";
                    $action_id = sqlInsert("INSERT INTO health_plan_actions SET $sql_action");
					for ($l=1;$l<=${"total_subaction_$k"};$l++) {
						$sql_action = 
						"plan_id ='" . $plan_id . "', " .
						"action_content ='" . ${"plan_action_$k-$l"} . "', " .
						"action_targetdate ='" . ${"form_action_targetdate_$k-$l"} . "', " .
						"reminder_timeframe ='" . ${"reminder_timeframe_$k-$l"} . "', " .
						"followup_timeframe ='" . ${"followup_timeframe_$k-$l"} . "', " .
						"completed ='" . ${"completed_$k-$l"} . "'";
						$action_id = sqlInsert("INSERT INTO health_plan_actions SET $sql_action");
					}
                }
                $query = "SELECT pid FROM patient_data WHERE 1 = 1 $where_age $sex";
                $result = sqlStatement($query, $sqlBindArray);
                while ($rows = sqlFetchArray($result)) {
					  $get_patient_id = $rows['pid'];
					  if (!empty($icd_include) or !empty($icd_exclude)) {
                        $merge_icd_sqlBindArray = array_merge(array($rows['pid']),$icd_sqlBindArray);
						$cres = sqlQuery("SELECT COUNT(*) as count FROM lists WHERE pid=? AND (1 = 1".$icd_where.")", $merge_icd_sqlBindArray);
                        if ($cres['count'] == 0) {
							$get_patient_id = "";
                        }
                      }
                      if (!empty($cpt_include) or !empty($cpt_exclude)) {
                        $cres = sqlQuery("SELECT COUNT(*) as count FROM billing WHERE pid=? AND (1 = 1".$cpt_where.")", array($rows['pid']));
                        if ($cres['count'] == 0) {
							$get_patient_id = "";
                        }
                      } 
                      if (!empty($ndc_where) or !empty($allergy_where)) {
                        $cres = sqlQuery("SELECT COUNT(*) as count FROM lists WHERE pid=? AND (1 = 1".$ndc_where.") OR (1 = 1".$allergy_where.")", array($rows['pid']));
                        if ($cres['count'] == 0) {
							$get_patient_id = "";
                        }
                      } 
                      if (!empty($patient_history_include) or !empty($patient_history_exclude)) {
					  	$history_sqlBindArray = array($rows['pid']);
						
					  	if ($patient_history_include) {
							$tmp = explode("::", $patient_history_include);
							$historylike = "";
							for ($i = 0; $i < count($tmp); ++ $i) {
								$tmp2 = explode("||", $tmp[$i]);
								if ($historylike) {
									$historylike .= " OR ";
								}
								$historylike .= str_replace(" ", "_", substr(strtolower($tmp2[1]), strpos($tmp2[1], " ") + 1))." like ?";
								array_push($history_sqlBindArray, $tmp2[0]."||".str_replace(" ", "", strtolower($tmp2[1]))."%");
							}
							if ($historylike)
							{
								$historylike = " AND ($historylike)";
							}
						}
					  	if ($patient_history_exclude) {
							$tmp = explode("::", $patient_history_exclude);
							$historynotlike = "";
							for ($i = 0; $i < count($tmp); ++ $i) {
								$tmp2 = explode("||", $tmp[$i]);
								if ($historynotlike) {
									$historynotlike .= " OR ";
								}
								$historynotlike .= str_replace(" ", "_", substr(strtolower($tmp2[1]), strpos($tmp2[1], " ") + 1))." like ?";
								array_push($history_sqlBindArray, $tmp2[0]."||".str_replace(" ", "", strtolower($tmp2[1]))."%");
							}
							if ($historynotlike)
							{
								$historynotlike = " AND ($historynotlike)";
							}
						}
                        $cres = sqlQuery("SELECT COUNT(*) as count FROM history_data WHERE pid=? AND (1 = 1".$historylike.") OR (1 = 1".$historynotlike.")", $history_sqlBindArray);
                        if ($cres['count'] == 0) {
							$get_patient_id = "";
                        }
                      }
                      if (!empty($lab_abnormal_result_where)) {
                        $cres = sqlQuery("SELECT COUNT(*) as count FROM procedure_order, procedure_report, procedure_result WHERE procedure_result.procedure_report_id=procedure_report.procedure_report_id AND procedure_report.procedure_order_id=procedure_order.procedure_order_id AND procedure_order.patient_id=? AND (1 = 1".$lab_abnormal_result_where.")", array($rows['pid']));
                        if ($cres['count'] == 0) {
							$get_patient_id = "";
                        }
                      } 
                      if (!in_array($get_patient_id, $patientid) and $get_patient_id) {
                          array_push($patientid, $get_patient_id);
                      }
                }
                if ($activation_status=="activate") {
					// create new clinical alerts
					admin_create_alerts($plan_name, $plan_id);
					if (!empty($patientid)) {
						$delete_patient_where="";
						$total_patient_count=0;
						foreach($patientid as $val) {
							$prow = sqlQuery("SELECT * FROM health_plan_enrollment WHERE patient_id = ? AND plan_id = ?", array($val, $plan_id));
							if ($prow) {
								sqlStatement("UPDATE health_plan_enrollment SET  status = '$status' where patient_id = ? AND plan_id = ?", array($val, $plan_id));
								
								if ($status == "patient_refused") {
									$reminderstatus = "cancelled";
								}
								else {
									$reminderstatus = "pending";
								}
								
								// Delete the existing reminder of the enrollment.
								sqlQuery("delete from patient_reminders WHERE patient_id = ? AND plan_id = ? AND enroll_id=?", array($val, $plan_id, $prow['enroll_id']));
	
								// Enroll the health plan for the patient
								health_plans_enrollment($plan_id, $val, $prow['enroll_id'], $reminderstatus, "admin");
							} 
							else {
								// Add a new enrollment for a specific patient.
								$enroll_id = sqlInsert("INSERT INTO health_plan_enrollment SET  patient_id = '$val', plan_id = '$plan_id', status = '$status', signup_date = '".date("Y-m-d")."'");
								
								// Enroll the health plan for the patient
								health_plans_enrollment($plan_id, $val, $enroll_id, "pending", "admin");
	
								// Check and insert alert for patient.
								insert_alert($val);
							}
							// set id for remove patient thet not included in the plan after updated
							if ($val!="") {
								if ($total_patient_count==100){
									$delete_patient_where .= "') AND patient_id NOT IN ('";
									$total_patient_count=0;
								} elseif ($delete_patient_where!="") {
									$delete_patient_where .="','";
								}
								$delete_patient_where .= "$val";
								$total_patient_count++;
							}
						}
						// remove patient thet not included in the plan after updated
						unset($total_patient_count);
						if ($delete_patient_where!="") {
							$delete_patient_where = "patient_id NOT IN ('".$delete_patient_where."')";
							$delete_patient_where2 = str_replace("patient_id","pid",$delete_patient_where);
							$getalerts = sqlQuery("SELECT alert_id FROM clinical_alerts WHERE plan_id = '$plan_id'");
							//sqlStatement("delete from clinical_alerts where plan_id='$plan_id'");
							sqlStatement("DELETE FROM patient_alerts WHERE $delete_patient_where2 AND alert_id='".formDataCore($getalerts['alert_id'])."'");
							sqlStatement("DELETE FROM health_plan_enrollment WHERE $delete_patient_where AND plan_id = '$plan_id'");
							sqlStatement("DELETE FROM patient_reminders WHERE $delete_patient_where AND plan_id = '$plan_id'");
						}
					} else {
						$getalerts = sqlQuery("SELECT alert_id FROM clinical_alerts WHERE plan_id = ?", array($plan_id));
						sqlStatement("DELETE FROM patient_alerts WHERE  alert_id=?", array(formDataCore($getalerts['alert_id'])));
						sqlStatement("DELETE FROM health_plan_enrollment WHERE  plan_id = ?", array($plan_id));
						sqlStatement("DELETE FROM patient_reminders WHERE plan_id = ?", array($plan_id));
					}
                } else {
					$getalerts = sqlQuery("SELECT alert_id FROM clinical_alerts WHERE ?", array($plan_id));
					sqlStatement("delete from clinical_alerts where plan_id=?", array($plan_id));
					sqlStatement("delete from patient_alerts where alert_id=?", array(formDataCore($getalerts['alert_id'])));
					sqlStatement("DELETE FROM health_plan_enrollment WHERE plan_id = ?", array($plan_id));
					sqlStatement("DELETE FROM patient_reminders WHERE plan_id = ?", array($plan_id));
                }
			} else {
                $plan_id = sqlInsert("INSERT INTO health_plans SET $sql");
                for ($k=1;$k<=$total_action;$k++) {
                    $sql_action = "";
                    $sql_action = 
                    "plan_id ='" . $plan_id . "', " .
                    "action_content ='" . ${"plan_action_$k"} . "', " .
                    "frequency ='" . ${"frequency_$k"} . "', " .
                    "subactions ='" . ${"total_subaction_$k"} . "', " .
                    "action_targetdate ='" . ${"form_action_targetdate_$k"} . "', " .
                    "reminder_timeframe ='" . ${"reminder_timeframe_$k"} . "', " .
                    "followup_timeframe ='" . ${"followup_timeframe_$k"} . "', " .
                    "completed ='" . ${"completed_$k"} . "'";
                    $action_id = sqlInsert("INSERT INTO health_plan_actions SET $sql_action");
					for ($l=1;$l<=${"total_subaction_$k"};$l++) {
						$sql_action = 
						"plan_id ='" . $plan_id . "', " .
						"action_content ='" . ${"plan_action_$k-$l"} . "', " .
						"action_targetdate ='" . ${"form_action_targetdate_$k-$l"} . "', " .
						"reminder_timeframe ='" . ${"reminder_timeframe_$k-$l"} . "', " .
						"followup_timeframe ='" . ${"followup_timeframe_$k-$l"} . "', " .
						"completed ='" . ${"completed_$k-$l"} . "'";
						$action_id = sqlInsert("INSERT INTO health_plan_actions SET $sql_action");
					}
                }
        
                $query = "SELECT pid FROM patient_data WHERE 1 = 1 $where_age $sex";
                $result = sqlStatement($query, $sqlBindArray);
                while ($rows = sqlFetchArray($result)) {
				  $get_patient_id = $rows['pid'];
				  if (!empty($icd_include) or !empty($icd_exclude)) {
				  	$merge_icd_sqlBindArray = array_merge(array($rows['pid']),$icd_sqlBindArray);
					$cres = sqlQuery("SELECT COUNT(*) as count FROM lists WHERE pid=? AND (1 = 1".$icd_where.")", $merge_icd_sqlBindArray);
					if ($cres['count'] == 0) {
						$get_patient_id = "";
					}
				  }
				  if (!empty($cpt_include) or !empty($cpt_exclude)) {
					$cres = sqlQuery("SELECT COUNT(*) as count FROM billing WHERE pid=? AND (1 = 1".$cpt_where.")", array($rows['pid']));
					if ($cres['count'] == 0) {
						$get_patient_id = "";
					}
				  }
				  if (!empty($ndc_where) or !empty($allergy_where)) {
					$cres = sqlQuery("SELECT COUNT(*) as count FROM lists WHERE pid=? AND (1 = 1".$ndc_where.") OR (1 = 1".$allergy_where.")", array($rows['pid']));
					if ($cres['count'] == 0) {
						$get_patient_id = "";
					}
				  } 
				  if (!empty($patient_history_include) or !empty($patient_history_exclude)) {
				  	$history_sqlBindArray = array($rows['pid']);
					
					if ($patient_history_include) {
						$tmp = explode("::", $patient_history_include);
						$historylike = "";
						for ($i = 0; $i < count($tmp); ++ $i) {
							$tmp2 = explode("||", $tmp[$i]);
							if ($historylike) {
								$historylike .= " OR ";
							}
							$historylike .= str_replace(" ", "_", substr(strtolower($tmp2[1]), strpos($tmp2[1], " ") + 1))." like ?";
							array_push($history_sqlBindArray, $tmp2[0]."||".str_replace(" ", "", strtolower($tmp2[1]))."%");
						}
						if ($historylike)
						{
							$historylike = " AND ($historylike)";
						}
					}
					if ($patient_history_exclude)
					{
						$tmp = explode("::", $patient_history_exclude);
						$historynotlike = "";
						for ($i = 0; $i < count($tmp); ++ $i) {
							$tmp2 = explode("||", $tmp[$i]);
							if ($historynotlike) {
								$historynotlike .= " OR ";
							}
							$historynotlike .= str_replace(" ", "_", substr(strtolower($tmp2[1]), strpos($tmp2[1], " ") + 1))." like ?";
							array_push($history_sqlBindArray, $tmp2[0]."||".str_replace(" ", "", strtolower($tmp2[1]))."%");
						}
						if ($historynotlike)
						{
							$historynotlike = " AND ($historynotlike)";
						}
					}
					$cres = sqlQuery("SELECT COUNT(*) as count FROM history_data WHERE pid=? AND (1 = 1".$historylike.") OR (1 = 1".$historynotlike.")", $history_sqlBindArray);
					if ($cres['count'] == 0) {
						$get_patient_id = "";
					}
				  }
				  if (!empty($lab_abnormal_result_where)) {
                    $cres = sqlQuery("SELECT COUNT(*) as count FROM procedure_order, procedure_report, procedure_result WHERE procedure_result.procedure_report_id=procedure_report.procedure_report_id AND procedure_report.procedure_order_id=procedure_order.procedure_order_id AND procedure_order.patient_id=? AND (1 = 1".$lab_abnormal_result_where.")", array($rows['pid']));
					if ($cres['count'] == 0) {
						$get_patient_id = "";
					}
				  } 
				  if (!in_array($get_patient_id, $patientid) and $get_patient_id) {
					  array_push($patientid, $get_patient_id);
				  }
                }
                if ($activation_status=="activate") {
                 // Create new clinical alerts.
                 admin_create_alerts($plan_name, $plan_id);
                if (!empty($patientid)) {
                    foreach($patientid as $val) {
                        // Add a new enrollment for a specific patient.
                        $enroll_id = sqlInsert("INSERT INTO health_plan_enrollment SET  patient_id = '$val', plan_id = '$plan_id', status = '$status', signup_date = '".date("Y-m-d")."'");

						// Enroll the health plan for the patient
						health_plans_enrollment($plan_id, $val, $enroll_id, "pending", "admin");

                        // Check and insert alert for patient.
                        insert_alert($val); 
                    }
                }
                }
              }
            $plan_id = 0;
            $task = "";
        }
      } break;
}

if ($task == "edit") {
    // Get the health plans record based on plan ID.
    $sql = "SELECT * FROM health_plans WHERE plan_id = ?";
    $results = sqlQ($sql, array($plan_id));
    while ($row = sqlFetchArray($results)) {
        $plan_name = htmlspecialchars($row['plan_name'], ENT_QUOTES);
        $description = htmlspecialchars($row['plan_description'], ENT_QUOTES);
        $category = htmlspecialchars($row['category'], ENT_QUOTES);
        $gender = htmlspecialchars($row['gender'], ENT_QUOTES);
        $plan_goal = htmlspecialchars($row['goals'], ENT_QUOTES);
        $fromage = htmlspecialchars($row['age_from'], ENT_QUOTES);
        $toage = htmlspecialchars($row['age_to'], ENT_QUOTES);
        $from_month = htmlspecialchars($row['month_from'], ENT_QUOTES);
        $to_month = htmlspecialchars($row['month_to'], ENT_QUOTES);
        $icd_include = htmlspecialchars($row['icd_include'], ENT_QUOTES);
        $cpt_include = htmlspecialchars($row['cpt_include'], ENT_QUOTES);
        $ndc_include = htmlspecialchars($row['ndc_include'], ENT_QUOTES);
        $allergy_include = htmlspecialchars($row['allergy_include'], ENT_QUOTES);
        $patient_history_include = htmlspecialchars($row['patient_history_include'], ENT_QUOTES);
        $lab_abnormal_result_include = htmlspecialchars($row['lab_abnormal_result_include'], ENT_QUOTES);
        $icd_exclude = htmlspecialchars($row['icd_exclude'], ENT_QUOTES);
        $cpt_exclude = htmlspecialchars($row['cpt_exclude'], ENT_QUOTES);
        $ndc_exclude = htmlspecialchars($row['ndc_exclude'], ENT_QUOTES);
        $allergy_exclude = htmlspecialchars($row['allergy_exclude'], ENT_QUOTES);
        $patient_history_exclude = htmlspecialchars($row['patient_history_exclude'], ENT_QUOTES);
        $lab_abnormal_result_exclude = htmlspecialchars($row['lab_abnormal_result_exclude'], ENT_QUOTES);
        $activation_status = htmlspecialchars($row['activation_status'], ENT_QUOTES);
        $total_action = 0;
		$total_subaction = 0;
        $sql = "SELECT * FROM health_plan_actions WHERE plan_id = ? order by action_id";
        $results = sqlQ($sql, array($plan_id));
        while ($row = sqlFetchArray($results)) {
			if (htmlspecialchars($row['subactions'], ENT_QUOTES) != "" && htmlspecialchars($row['subactions'], ENT_QUOTES) != NULL) {
				$total_action++;
				$total_subaction = 0;
				${"action_id_".$total_action} = htmlspecialchars($row['action_id'], ENT_QUOTES);
				${"plan_action_".$total_action} = htmlspecialchars($row['action_content'], ENT_QUOTES);
				$frequency = explode("::", htmlspecialchars($row['frequency'], ENT_QUOTES));
				${"frq_year_".$total_action} = $frequency[0];
				${"frq_month_".$total_action} = $frequency[1];
				${"total_subaction_".$total_action} = htmlspecialchars($row['subactions'], ENT_QUOTES);
				${"form_action_targetdate_".$total_action} = htmlspecialchars($row['action_targetdate'], ENT_QUOTES);
				${"reminder_timeframe_".$total_action} = htmlspecialchars($row['reminder_timeframe'], ENT_QUOTES);
				${"followup_timeframe_".$total_action} = htmlspecialchars($row['followup_timeframe'], ENT_QUOTES);
				${"completed_".$total_action} = htmlspecialchars($row['completed'], ENT_QUOTES);
			}
			else {
				$total_subaction++;
				${"plan_action_$total_action-$total_subaction"} = htmlspecialchars($row['action_content'], ENT_QUOTES);
				${"form_action_targetdate_$total_action-$total_subaction"} = htmlspecialchars($row['action_targetdate'], ENT_QUOTES);
				${"reminder_timeframe_$total_action-$total_subaction"} = htmlspecialchars($row['reminder_timeframe'], ENT_QUOTES);
				${"followup_timeframe_$total_action-$total_subaction"} = htmlspecialchars($row['followup_timeframe'], ENT_QUOTES);
				${"completed_$total_action-$total_subaction"} = htmlspecialchars($row['completed'], ENT_QUOTES);
			}
        }
    }
}
//$filter = $_REQUEST['filter'];
//$search = $_REQUEST['search'];

$where = "1 = 1";
/*
if ($filter and $filter!="all") {
	$where .= " AND activation_status = '".formDataCore($filter)."'";
}
if (!empty($search)) {
	$where .= " AND plan_name LIKE '%" . formDataCore($search, true) . "%'";
}
*/
?>

<html>
<head>
<?php html_header_show(); ?>
<link rel="stylesheet" href="<?php echo $css_header;?>" type="text/css">
<style type="text/css">@import url(../../../library/dynarch_calendar.css);</style>
<script type="text/javascript" src="../../../library/dialog.js"></script>
<script type="text/javascript" src="../../../library/textformat.js"></script>
<script type="text/javascript" src="../../../library/dynarch_calendar.js"></script>
<script type="text/javascript" src="../../../library/dynarch_calendar_en.js"></script>
<script type="text/javascript" src="../../../library/dynarch_calendar_setup.js"></script>
<script type="text/javascript" src="<?php echo $GLOBALS['webroot']; ?>/library/js/jquery.js"></script>

<script language="JavaScript">
var mypcc = '<?php echo htmlspecialchars($GLOBALS['phone_country_code'], ENT_QUOTES); ?>';
var current_id = '';

// Some validation for saving a new code entry.
function validEntry(f) {
	if (!f.plan_name.value) {
  		alert('<?php echo htmlspecialchars(xl('No plan name was specified!'), ENT_QUOTES); ?>');
  		return false;
 }
 return true;
}
// Actions for add/edit/cancel health plans form.
function submitAdd() {
	var f = document.forms[0];
 	if (!validEntry(f)) return;
	f.task.value = 'add';
	f.plan_id.value = '';
	top.restoreSession();
	f.submit();
}

function submitUpdate() {
	var f = document.forms[0];
 	if (! parseInt(f.plan_id.value)) {
  		alert('<?php echo htmlspecialchars(xl('Cannot update because you are not editing an existing entry!'), ENT_QUOTES); ?>');
  		return;
 	}
 	if (!validEntry(f)) return;
 	f.task.value = 'update';
 	top.restoreSession();
 	f.submit();
}

function submitCancel() {
	var f = document.forms[0];
 	f.task.value = '';
	f.plan_id.value = '';
	top.restoreSession();
	f.submit();
}

function submitEdit(id) {
	var f = document.wikiList;
	f.task.value = 'edit';
	f.plan_id.value = id;
	top.restoreSession();
	f.submit();
}

function divclick(cb, divid) {
	var divstyle = document.getElementById(divid).style;
	if (cb.checked) {
		divstyle.display = 'block';
 	} else {
		divstyle.display = 'none';
	}
 	return true;
}

function divaction(num) {
	for (var i = 1; i <= 10; i++) {
   		if (i<=num) {
    		document.getElementById('action_'+i).style.display = 'block';
    		document.getElementById('action_details_'+i).style.display = 'block';
			divsubaction(i, document.getElementById('total_subaction_'+i).value)
   		} else {
    		document.getElementById('action_'+i).style.display = 'none';
    		document.getElementById('action_details_'+i).style.display = 'none';
			for (var j = 1; j <= 10; j++) {
				document.getElementById('subaction_'+i+'_'+j).style.display = 'none';
			}
  		}
 	}
	return true;
}

function divsubaction(j, num) {

	for (var k = 1; k <= 10; k++) {
   		if (k<=num) {
    		document.getElementById('action_details_'+j).style.display = 'none';
    		document.getElementById('subaction_'+j+'_'+k).style.display = 'block';
   		} else {
			if (num < 1)
			{
    			document.getElementById('action_details_'+j).style.display = 'block';
			}
    		document.getElementById('subaction_'+j+'_'+k).style.display = 'none';
  		}
 	}
	return true;
}

function refreshme() {
	top.restoreSession();
	location.reload();
}

// Helper function to set the contents of a div.
function setDivContent(id, content) {
	if (document.getElementById) {
  		var x = document.getElementById(id);
  		x.innerHTML = '';
  		x.innerHTML = content;
 	}
 	else if (document.all) {
  		var x = document.all[id];
  		x.innerHTML = content;
 	}
}

// Given a line number, redisplay its descriptive list of codes.
function displayCodes(id) {
	var f = document.forms[0];
 	var s = '';
 	var descs = f['rule[' + id + '][descs]'].value;
 	if (descs.length) {
  		var arrdescs = descs.split('::');
  		for (var i = 0; i < arrdescs.length; ++i) {
   			s += arrdescs[i] + '<br />';
  		}
 	}
	if (s.length == 0) s = '[<?php echo htmlspecialchars(xl('Add'), ENT_QUOTES); ?>]';
 	setDivContent(id, s);
}

// This invokes the find-code popup.
function select_code(id,type) {
	current_id = id;
 	if (type == "icd") codetype = "ICD9";
 	if (type == "cpt") codetype = "CPT4";
 	if (type == "ndc") codetype = "NDC";
 	if (type == "allergy") codetype = "Allergy";
 	if (type == "patient_history") codetype = "History";
 	if (type == "lab_abnormal_result_history") codetype = "Result";
 	dlgopen('../encounter/find_code_popup.php?codetype=' + codetype, '_blank', 700, 400);
 	return false;
}

// This is for callback by the find-code popup.
function set_related(codetype, code, selector, codedesc) {
	var f = document.forms[0];
 	var celem = f['rule[' + current_id + '][codes]'];
 	var delem = f['rule[' + current_id + '][descs]'];
 	var i = 0;
 	while ((i = codedesc.indexOf('::')) >= 0) {
  		codedesc = codedesc.substring(0, i) + ' ' + codedesc.substring(i+1);
 	}
 	if (code) {
  		if (celem.value) {
   			celem.value += '::';
   			delem.value += '::';
  		}
  		celem.value += code;
  		delem.value += code + ' ' + codedesc;
	} else {
  	  	celem.value = '';
  		delem.value = '';
 	}
 	displayCodes(current_id);
}

</script>

</head>
<body class="body_top">

<?php if ($GLOBALS['concurrent_layout']) { ?>
<table><tr><td><font class=title><?php echo htmlspecialchars(xl('Health Plans'), ENT_QUOTES); ?></font></td></tr></table>
<?php } else { ?>
<table><tr><td><a href="health_plans_admin.php" target="Main" onClick="top.restoreSession()">
<font class=title><?php echo htmlspecialchars(xl('Health Plans'), ENT_QUOTES); ?></font></a></td></tr></table>
<?php }
echo "<br/>";
// Display the Health Plans page layout.
if($task == "addnew" or $task == "edit") {?>

<form action='health_plans_admin.php' method='post' onsubmit=''>
<input type='hidden' name='task' value=''>
<center>
<table border=0 cellpadding=1 cellspacing=1>
    <tr>
        <td class='required'> <?php echo htmlspecialchars(xl('Plan Name'), ENT_QUOTES); ?>:</td>
        <td width=10></td>
        <td class='text'><input type="text" name="plan_name" value="<?php echo htmlspecialchars($plan_name, ENT_QUOTES);?>"></td>
    </tr>
    <tr>
        <td class='text'><?php echo htmlspecialchars(xl('Description'), ENT_QUOTES); ?>:</td>
        <td width=10></td>
        <td class='text'><textarea name="description" rows="8" style="width:450px;"><?php echo htmlspecialchars($description, ENT_QUOTES);?></textarea></td>
    </tr>
    <tr>
        <td class='text'><?php echo htmlspecialchars(xl('Category'), ENT_QUOTES); ?>:</td>
        <td width=10></td>
        <td class='text'>
          <?php
            generate_form_field(array('data_type'=>1,'field_id'=>'category','list_id'=>'health_plan_categories','empty_title'=>'SKIP'), $category);
          ?>
		</td>
    </tr>
    <tr>
        <td class='text'><?php echo htmlspecialchars(xl('Gender'), ENT_QUOTES); ?>:</td>
        <td width=10></td>
        <td class='text'>
        <?php
            generate_form_field(array('data_type'=>1,'field_id'=>'gender','list_id'=>'sex','empty_title'=>'All'), $gender);
           ?>
        </td>
    </tr>
    <tr>
        <td class='text'><?php echo htmlspecialchars(xl('From Age'), ENT_QUOTES); ?>:</td>
        <td width=10></td>
        <td class='text'>
          <select name="fromage">
              <option value=""><?php echo htmlspecialchars(xl('Unassigned'), ENT_QUOTES);?></option>
          <?php for($i=0; $i<=130; $i++) { ?>
            <option value="<?php echo "$i" ?>" <?php if ($fromage=="$i") echo "selected" ?>> <?php echo $i?> </option>
          <?php } ?>
          </select>
          <?php echo htmlspecialchars(xl('Year(s)'), ENT_QUOTES); ?>
          <select name="from_month">
            <option value=""><?php echo htmlspecialchars(xl('Unassigned'), ENT_QUOTES);?></option>
          <?php for($m=0; $m<=11; $m++) { ?>
            <option value="<?php echo "$m" ?>" <?php if ($from_month=="$m") echo "selected" ?>> <?php echo $m?> </option>
          <?php } ?>
          </select>
          <?php echo htmlspecialchars(xl('Month(s)'), ENT_QUOTES); ?>
        </td>
    </tr>
    <tr>
        <td class='text'><?php echo htmlspecialchars(xl('To Age'), ENT_QUOTES); ?>:</td>
        <td width=10></td>
        <td class='text'>
          <select name="toage">
            <option value=""><?php echo htmlspecialchars(xl('Unassigned'), ENT_QUOTES);?></option>
          <?php for($i=0; $i<=130; $i++) { ?>
            <option value="<?php echo "$i"; ?>" <?php if ($toage=="$i") echo "selected" ?>> <?php echo $i?> </option>
          <?php } ?>
          </select>
          <?php echo htmlspecialchars(xl('Year(s)'), ENT_QUOTES); ?>
          <select name="to_month">
            <option value=""><?php echo htmlspecialchars(xl('Unassigned'), ENT_QUOTES);?></option>
          <?php for($m=0; $m<=11; $m++) { ?>
            <option value="<?php echo "$m"; ?>" <?php if ($to_month=="$m") echo "selected" ?>> <?php echo $m?> </option>
          <?php } ?>
          </select>
          <?php echo htmlspecialchars(xl('Month(s)'), ENT_QUOTES); ?>
        </td>
    </tr>
    <tr>
        <td class='text' valign="top"><?php echo htmlspecialchars(xl('Include Rule'), ENT_QUOTES); ?>:</td>
        <td width=10></td>
        <td class='text'>
        <div>
        <input type='checkbox' name='include_icd_show' id='include_icd_show' onclick='return divclick(this,"div_include_icd");' <?php echo (!empty($icd_include))?"checked":"";?>/><?php echo htmlspecialchars(xl('ICD'), ENT_QUOTES); ?>
        <input type='checkbox' name='include_cpt_show' id='include_cpt_show' onclick='return divclick(this,"div_include_cpt");' <?php echo (!empty($cpt_include))?"checked":"";?>/><?php echo htmlspecialchars(xl('CPT'), ENT_QUOTES); ?>
        <input type='checkbox' name='include_ndc_show' id='include_ndc_show' onclick='return divclick(this,"div_include_ndc");' <?php echo (!empty($ndc_include))?"checked":"";?>/><?php echo htmlspecialchars(xl('Medication'), ENT_QUOTES); ?>
        <input type='checkbox' name='include_allergy_show' id='include_allergy_show' onclick='return divclick(this,"div_include_allergy");' <?php echo (!empty($allergy_include))?"checked":"";?>/><?php echo htmlspecialchars(xl('Allergy'), ENT_QUOTES); ?>
        <input type='checkbox' name='include_pt_history_show' id='include_pt_history_show' onclick='return divclick(this,"div_include_pt_history");' <?php if ($patient_history_include != '') echo " checked";?>/><?php echo htmlspecialchars(xl('Patient History'), ENT_QUOTES); ?>
        <input type='checkbox' name='include_lab_show' id='include_lab_show' onclick='return divclick(this,"div_include_lab");' <?php if ($lab_abnormal_result_include != '') echo " checked";?>/><?php echo htmlspecialchars(xl('Lab Abnormal Result'), ENT_QUOTES); ?>
        </div>
        <div id="div_include_icd" style="display:<?php echo (!empty($icd_include))?'block':'none'; ?>">
        <table>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('ICD Include'), ENT_QUOTES); ?>:</td>
                <td width=10></td>
                <td class='text'>
                <a href='javascript:void(0);' id='include_icd' onClick="return select_code('include_icd','icd')">
                <?php
                $descs = "";
                if (!empty($icd_include)) {
                    $icd_in_code = explode("::", $icd_include);
                    foreach ($icd_in_code as $icd_in_val) {
                        $codequery = "SELECT * FROM codes WHERE code_type=? AND code = ?";
                        $coderesult = sqlStatement($codequery, array('2', formDataCore($icd_in_val)));
                        while ($coderows = sqlFetchArray($coderesult)) {
                            if ($descs != "") $descs .= "::"; 
                            echo htmlspecialchars($coderows['code']. " " . $coderows['code_text'], ENT_QUOTES). "<br />";
                            $descs .= htmlspecialchars($coderows['code']. " " . $coderows['code_text'], ENT_QUOTES);
                        }
                    }
                }
                else {
                    echo "[".htmlspecialchars(xl('Add'), ENT_QUOTES)."]";
                }
                ?>
                </a>
                <input type='hidden' name='rule[include_icd][codes]' value='<?php echo htmlspecialchars($icd_include, ENT_QUOTES)?>' />
                <input type='hidden' name='rule[include_icd][descs]' value='<?php echo htmlspecialchars($descs, ENT_QUOTES)?>' />
                </td>
            </tr>
        </table>
        </div>
        <div id="div_include_cpt" style="display:<?php echo (!empty($cpt_include))?'block':'none'; ?>">
        <table>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('CPT Include'), ENT_QUOTES); ?>:</td>
                <td width=10></td>
                <td class='text'>
                <a href='javascript:void(0);' id='include_cpt' onClick="return select_code('include_cpt','cpt')">
                <?php
                $descs = "";
                if (!empty($cpt_include)) {
                    $cpt_in_code = explode("::", $cpt_include);
                    foreach ($cpt_in_code as $cpt_in_val) {
                        $codequery1 = "SELECT * FROM codes WHERE code_type=? AND code = ?";
                        $coderesult1 = sqlStatement($codequery1, array('1', formDataCore($cpt_in_val)));
                        while ($coderows1 = sqlFetchArray($coderesult1)) {
                            if ($descs != "") $descs .= "::";
                            echo htmlspecialchars($coderows1['code']. " " . $coderows1['code_text'], ENT_QUOTES). "<br />";
                            $descs .= htmlspecialchars($coderows1['code']. " " . $coderows1['code_text'], ENT_QUOTES);
                        }
                    }
                }
                else {
                    echo "[".htmlspecialchars(xl('Add'), ENT_QUOTES)."]";
                }
                ?>
                </a>
                <input type='hidden' name='rule[include_cpt][codes]' value='<?php echo htmlspecialchars($cpt_include, ENT_QUOTES)?>' />
                <input type='hidden' name='rule[include_cpt][descs]' value='<?php echo htmlspecialchars($descs, ENT_QUOTES)?>' />
                </td>
            </tr>
        </table>
        </div>
        <div id="div_include_ndc" style="display:<?php echo (!empty($ndc_include))?'block':'none'; ?>">
        <table>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('Medication Include'), ENT_QUOTES); ?>:</td>
                <td width=10></td>
                <td class='text'>
				<a href='javascript:void(0);' id='include_ndc' onClick="return select_code('include_ndc','ndc')">
				<?php
				if (!empty($ndc_include)) {
					echo str_replace("::", "<br />", $ndc_include);
				}
				else {
					echo "[".htmlspecialchars(xl('Add'), ENT_QUOTES)."]";
				}
				?>
                </a>
                <input type='hidden' name='rule[include_ndc][codes]' value='<?php echo htmlspecialchars($ndc_include, ENT_QUOTES)?>' />
                <input type='hidden' name='rule[include_ndc][descs]' value='<?php echo htmlspecialchars($ndc_include, ENT_QUOTES)?>' />
                </td>
            </tr>
        </table>
        </div>
        <div id="div_include_allergy" style="display:<?php echo (!empty($allergy_include))?'block':'none'; ?>">
        <table>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('Allergy Include'), ENT_QUOTES); ?>:</td>
                <td width=10></td>
                <td class='text'>
				<a href='javascript:void(0);' id='include_allergy' onClick="return select_code('include_allergy','allergy')">
				<?php
				if (!empty($allergy_include)) {
					echo str_replace("::", "<br />", $allergy_include);
				}
				else {
					echo "[".htmlspecialchars(xl('Add'), ENT_QUOTES)."]";
				}
				?>
                </a>
                <input type='hidden' name='rule[include_allergy][codes]' value='<?php echo htmlspecialchars($allergy_include, ENT_QUOTES)?>' />
                <input type='hidden' name='rule[include_allergy][descs]' value='<?php echo htmlspecialchars($allergy_include, ENT_QUOTES)?>' />
				</td>
            </tr>
        </table>
        </div>
        <div id="div_include_pt_history" style="display:<?php echo $patient_history_include!=''?'block':'none'; ?>">
        <table>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('Patient History Include'), ENT_QUOTES); ?>:</td>
                <td width=10></td>
                <td class='text'>
				<a href='javascript:void(0);' id='include_patient_history' onClick="return select_code('include_patient_history','patient_history')">
				<?php
                $codes = "";
                $descs = "";
				if (!empty($patient_history_include)) {
					$patient_history_include = explode("::", $patient_history_include);
					for ($i = 0; $i < count($patient_history_include); ++ $i) {
						$tmp_patient_history_include = explode("||", $patient_history_include[$i]);
						$codes[] = $tmp_patient_history_include[1];
						$descs[] = $tmp_patient_history_include[1]." ".$tmp_patient_history_include[0];
					}
					$codes = implode("::", $codes);
					$descs = implode("::", $descs);
					echo str_replace("::", "<br />", $descs);
				}
				else {
					echo "[".htmlspecialchars(xl('Add'), ENT_QUOTES)."]";
				}
				?>
                </a>
                <input type='hidden' name='rule[include_patient_history][codes]' value='<?php echo htmlspecialchars($codes, ENT_QUOTES)?>' />
                <input type='hidden' name='rule[include_patient_history][descs]' value='<?php echo htmlspecialchars($descs, ENT_QUOTES)?>' />
				</td>
            </tr>
        </table>
        </div>
        <div id="div_include_lab" style="display:<?php echo $lab_abnormal_result_include!=''?'block':'none'; ?>">
        <table>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('Lab Abnormal Result Include'), ENT_QUOTES); ?>:</td>
                <td width=10></td>
                <td class='text'>
				<a href='javascript:void(0);' id='include_lab_abnormal_result_history' onClick="return select_code('include_lab_abnormal_result_history','lab_abnormal_result_history')">
				<?php
                $codes = "";
                $descs = "";
				if (!empty($lab_abnormal_result_include)) {
                    $lab_abnormal_result_in_procedure = explode("::", $lab_abnormal_result_include);
                    foreach ($lab_abnormal_result_in_procedure as $lab_abnormal_result_in_val) {
                        $procedurequery = "SELECT * FROM procedure_type WHERE procedure_type_id = ?";
                        $procedureresult = sqlStatement($procedurequery, array($lab_abnormal_result_in_val));
                        while ($procedurerows = sqlFetchArray($procedureresult)) {
							$codes[] = htmlspecialchars($procedurerows['name'], ENT_QUOTES);
							$descs[] = htmlspecialchars($procedurerows['name']. " " . $procedurerows['description'], ENT_QUOTES);
                        }
                    }
					$codes = implode("::", $codes);
					$descs = implode("::", $descs);
					echo str_replace("::", "<br />", $descs);
				}
				else {
					echo "[".htmlspecialchars(xl('Add'), ENT_QUOTES)."]";
				}
				?>
                </a>
                <input type='hidden' name='rule[include_lab_abnormal_result_history][codes]' value='<?php echo htmlspecialchars($codes, ENT_QUOTES)?>' />
                <input type='hidden' name='rule[include_lab_abnormal_result_history][descs]' value='<?php echo htmlspecialchars($descs, ENT_QUOTES)?>' />
				</td>
            </tr>
        </table>
        </div>
        </td>
    </tr>
    <tr>
        <td class='text' valign="top"><?php echo htmlspecialchars(xl('Exclude Rule'), ENT_QUOTES); ?>:</td>
        <td width=10></td>
        <td class='text'>
        <div>
        <input type='checkbox' name='exclude_icd_show' id='exclude_icd_show' onclick='return divclick(this,"div_exclude_icd");' <?php echo (!empty($icd_exclude))?'checked':'';?>/><?php echo htmlspecialchars(xl('ICD'), ENT_QUOTES); ?>
        <input type='checkbox' name='exclude_cpt_show' id='exclude_cpt_show' onclick='return divclick(this,"div_exclude_cpt");' <?php echo (!empty($cpt_exclude))?'checked':'';?>/><?php echo htmlspecialchars(xl('CPT'), ENT_QUOTES); ?>
        <input type='checkbox' name='exclude_ndc_show' id='exclude_ndc_show' onclick='return divclick(this,"div_exclude_ndc");' <?php echo (!empty($ndc_exclude))?'checked':'';?>/><?php echo htmlspecialchars(xl('Medication'), ENT_QUOTES); ?>
        <input type='checkbox' name='exclude_allergy_show' id='exclude_allergy_show' onclick='return divclick(this,"div_exclude_allergy");' <?php echo (!empty($allergy_exclude))?'checked':'';?>/><?php echo htmlspecialchars(xl('Allergy'), ENT_QUOTES); ?>
        <input type='checkbox' name='exclude_pt_history_show' id='exclude_pt_history_show' onclick='return divclick(this,"div_exclude_pt_history");' <?php if ($patient_history_exclude != '') echo " checked";?>/><?php echo htmlspecialchars(xl('Patient History'), ENT_QUOTES); ?>
        <input type='checkbox' name='exclude_lab_show' id='exclude_lab_show' onclick='return divclick(this,"div_exclude_lab");' <?php if ($lab_abnormal_result_exclude != '') echo " checked";?>/><?php echo htmlspecialchars(xl('Lab Abnormal Result'), ENT_QUOTES); ?>
        </div>
        <div id="div_exclude_icd" style="display:<?php echo (!empty($icd_exclude))?'block':'none'; ?>">
        <table>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('ICD Exclude'), ENT_QUOTES); ?>:</td>
                <td width=10></td>
                <td class='text'>
                <a href='javascript:void(0);' id='exclude_icd' onClick="return select_code('exclude_icd','icd')">
                <?php
                $descs = "";
                if (!empty($icd_exclude)) {
                    $icd_ex_code = explode("::", $icd_exclude);
                    foreach ($icd_ex_code as $icd_ex_val) {
                        $codequery2 = "SELECT * FROM codes WHERE code_type=? AND code = ?";
                        $coderesult2 = sqlStatement($codequery2, array('2', formDataCore($icd_ex_val)));
                        while ($coderows2 = sqlFetchArray($coderesult2)) {
                            if ($descs != "") $descs .= "::";
                            echo htmlspecialchars($coderows2['code']. " " . $coderows2['code_text'], ENT_QUOTES). "<br />";
                            $descs .= htmlspecialchars($coderows2['code']. " " . $coderows2['code_text'], ENT_QUOTES);
                        }
                    }
                }
                else {
                    echo "[".htmlspecialchars(xl('Add'), ENT_QUOTES)."]";
                }
                ?>
                </a>
                <input type='hidden' name='rule[exclude_icd][codes]' value='<?php echo htmlspecialchars($icd_exclude, ENT_QUOTES)?>' />
                <input type='hidden' name='rule[exclude_icd][descs]' value='<?php echo htmlspecialchars($descs, ENT_QUOTES)?>' />
                </td>
            </tr>
        </table>
        </div>
        <div id="div_exclude_cpt" style="display:<?php echo (!empty($cpt_exclude))?'block':'none'; ?>">
        <table>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('CPT Exclude'), ENT_QUOTES); ?>:</td>
                <td width=10></td>
                <td class='text'>
                <a href='javascript:void(0);' id='exclude_cpt' onClick="return select_code('exclude_cpt','cpt')">
                <?php
                $descs = "";
                if (!empty($cpt_exclude)) {
                    $cpt_ex_code = explode("::", $cpt_exclude);
                    foreach ($cpt_ex_code as $cpt_ex_val) {
                        $codequery3 = "SELECT * FROM codes WHERE code_type=? AND code = ?";
                        $coderesult3 = sqlStatement($codequery3, array('1',formDataCore($cpt_ex_val)));
                        while ($coderows3 = sqlFetchArray($coderesult3)) {
                            if ($descs != "") $descs .= "::";
                            echo htmlspecialchars($coderows3['code']. " " . $coderows3['code_text'], ENT_QUOTES). "<br />";
                            $descs .= htmlspecialchars($coderows3['code']. " " . $coderows3['code_text'], ENT_QUOTES);
                        }
                    }
                }
                else {
                    echo "[".htmlspecialchars(xl('Add'), ENT_QUOTES)."]";
                }
                ?>
                </a>
                <input type='hidden' name='rule[exclude_cpt][codes]' value='<?php echo htmlspecialchars($cpt_exclude, ENT_QUOTES)?>' />
                <input type='hidden' name='rule[exclude_cpt][descs]' value='<?php echo htmlspecialchars($descs, ENT_QUOTES)?>' />
                </td>
            </tr>
        </table>
        </div>
        <div id="div_exclude_ndc" style="display:<?php echo (!empty($ndc_exclude))?'block':'none'; ?>">
        <table>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('Medication Exclude'), ENT_QUOTES); ?>:</td>
                <td width=10></td>
                <td class='text'>
				<a href='javascript:void(0);' id='exclude_ndc' onClick="return select_code('exclude_ndc','ndc')">
				<?php
				if (!empty($ndc_exclude)) {
					echo str_replace("::", "<br />", $ndc_exclude);
				}
				else {
					echo "[".htmlspecialchars(xl('Add'), ENT_QUOTES)."]";
				}
				?>
                </a>
                <input type='hidden' name='rule[exclude_ndc][codes]' value='<?php echo htmlspecialchars($ndc_exclude, ENT_QUOTES)?>' />
                <input type='hidden' name='rule[exclude_ndc][descs]' value='<?php echo htmlspecialchars($ndc_exclude, ENT_QUOTES)?>' />
                </td>
            </tr>
        </table>
        </div>
        <div id="div_exclude_allergy" style="display:<?php echo (!empty($allergy_exclude))?'block':'none'; ?>">
        <table>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('Allergy Exclude'), ENT_QUOTES); ?>:</td>
                <td width=10></td>
                <td class='text'>
				<a href='javascript:void(0);' id='exclude_allergy' onClick="return select_code('exclude_allergy','allergy')">
				<?php
				if (!empty($allergy_exclude)) {
					echo str_replace("::", "<br />", $allergy_exclude);
				}
				else {
					echo "[".htmlspecialchars(xl('Add'), ENT_QUOTES)."]";
				}
				?>
                </a>
                <input type='hidden' name='rule[exclude_allergy][codes]' value='<?php echo htmlspecialchars($allergy_exclude, ENT_QUOTES)?>' />
                <input type='hidden' name='rule[exclude_allergy][descs]' value='<?php echo htmlspecialchars($allergy_exclude, ENT_QUOTES)?>' />
				</td>
            </tr>
        </table>
        </div>
        <div id="div_exclude_pt_history" style="display:<?php echo $patient_history_exclude!=''?'block':'none'; ?>">
        <table>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('Patient History Exclude'), ENT_QUOTES); ?>:</td>
                <td width=10></td>
                <td class='text'>
				<a href='javascript:void(0);' id='exclude_patient_history' onClick="return select_code('exclude_patient_history','patient_history')">
				<?php
                $codes = "";
                $descs = "";
				if (!empty($patient_history_exclude)) {
					$patient_history_exclude = explode("::", $patient_history_exclude);
					for ($i = 0; $i < count($patient_history_exclude); ++ $i) {
						$tmp_patient_history_exclude = explode("||", $patient_history_exclude[$i]);
						$codes[] = $tmp_patient_history_exclude[1];
						$descs[] = $tmp_patient_history_exclude[1]." ".$tmp_patient_history_exclude[0];
					}
					$codes = implode("::", $codes);
					$descs = implode("::", $descs);
					echo str_replace("::", "<br />", $descs);
				}
				else {
					echo "[".htmlspecialchars(xl('Add'), ENT_QUOTES)."]";
				}
				?>
                </a>
                <input type='hidden' name='rule[exclude_patient_history][codes]' value='<?php echo htmlspecialchars($codes, ENT_QUOTES)?>' />
                <input type='hidden' name='rule[exclude_patient_history][descs]' value='<?php echo htmlspecialchars($descs, ENT_QUOTES)?>' />
				</td>
            </tr>
        </table>
        </div>
        <div id="div_exclude_lab" style="display:<?php echo $lab_abnormal_result_exclude!=''?'block':'none'; ?>">
        <table>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('Lab Abnormal Result Exclude'), ENT_QUOTES); ?>:</td>
                <td width=10></td>
                <td class='text'>
				<a href='javascript:void(0);' id='exclude_lab_abnormal_result_history' onClick="return select_code('exclude_lab_abnormal_result_history','lab_abnormal_result_history')">
				<?php
                $codes = "";
                $descs = "";
				if (!empty($lab_abnormal_result_exclude)) {
                    $lab_abnormal_result_in_procedure = explode("::", $lab_abnormal_result_exclude);
                    foreach ($lab_abnormal_result_in_procedure as $lab_abnormal_result_in_val) {
                        $procedurequery = "SELECT * FROM procedure_type WHERE procedure_type_id = ?";
                        $procedureresult = sqlStatement($procedurequery, array($lab_abnormal_result_in_val));
                        while ($procedurerows = sqlFetchArray($procedureresult)) {
							$codes[] = htmlspecialchars($procedurerows['name'], ENT_QUOTES);
							$descs[] = htmlspecialchars($procedurerows['name']. " " . $procedurerows['description'], ENT_QUOTES);
                        }
                    }
					$codes = implode("::", $codes);
					$descs = implode("::", $descs);
					echo str_replace("::", "<br />", $descs);
				}
				else {
					echo "[".htmlspecialchars(xl('Add'), ENT_QUOTES)."]";
				}
				?>
                </a>
                <input type='hidden' name='rule[exclude_lab_abnormal_result_history][codes]' value='<?php echo htmlspecialchars($codes, ENT_QUOTES)?>' />
                <input type='hidden' name='rule[exclude_lab_abnormal_result_history][descs]' value='<?php echo htmlspecialchars($descs, ENT_QUOTES)?>' />
				</td>
            </tr>
        </table>
        </div>
        </td>
    </tr>
    <tr>
        <td class='text'><?php echo htmlspecialchars(xl('Plan Goals'), ENT_QUOTES);?>:</td>
        <td width=10></td>
        <td class='text'><textarea name="plan_goal" rows="8" style="width:450px;"><?php echo htmlspecialchars($plan_goal, ENT_QUOTES);?></textarea></td>
    </tr>
    <tr>
        <td class='text' valign="top"><?php echo htmlspecialchars(xl('Plan Action'), ENT_QUOTES); ?>:</td>
        <td width=10></td>
        <td class='text'>
            <select name="total_action" onChange="divaction(this.value)">
              <option value='0'>0</option>
                <?php for ($i=1;$i<=10;$i++) {?>
                    <option value="<?php echo $i;?>" <?php if ($total_action == $i) echo "selected"; ?>><?php echo $i;?></option>
                <?php } ?>
            </select><br/>
<?php for ($j = 1; $j<=10; $j++) { ?>
        <div id="action_<?php echo $j;?>" style="display:<?php echo $j<=$total_action?"block":"none" ?>">
        <table>
            <tr>
                <td class='text' width="125"><?php echo htmlspecialchars(xl('Action #'). "" .$j, ENT_QUOTES);?>:</td>
                <td width=10></td>
                <td class='text'><input type="text" size="50" name="plan_action_<?php echo $j; ?>" value="<?php echo htmlspecialchars(${"plan_action_$j"}, ENT_QUOTES);?>"></td>
            </tr>
			<tr>
				<td class='text'><?php echo htmlspecialchars(xl('Frequency'), ENT_QUOTES);?>:</td>
				<td width=10></td>
				<td class='text'>
				  <select name="frq_year_<?php echo $j; ?>">
					<option value=""><?php echo htmlspecialchars(xl('Unassigned'), ENT_QUOTES);?></option>
				  <?php for($frq=0; $frq<=130; $frq++) { ?>
					<option value="<?php echo $frq ?>" <?php if (${"frq_year_$j"}=="$frq") echo "selected" ?>><?php echo $frq?></option>
				  <?php } ?>
				  </select> <?php echo htmlspecialchars(xl('Year(s)'), ENT_QUOTES);?>
				  <select name="frq_month_<?php echo $j; ?>">
					<option value=""><?php echo htmlspecialchars(xl('Unassigned'), ENT_QUOTES);?></option>
				  <?php for($frq=0; $frq<=11; $frq++) { ?>
					<option value="<?php echo $frq ?>" <?php if (${"frq_month_$j"}=="$frq") echo "selected" ?>><?php echo $frq?></option>
				  <?php } ?>
				  </select> <?php echo htmlspecialchars(xl('Month(s)'), ENT_QUOTES);?>
				</td>
			</tr>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('Subaction'), ENT_QUOTES);?>:</td>
                <td width=10></td>
                <td class='text'>
				<select id="total_subaction_<?php echo $j; ?>" name="total_subaction_<?php echo $j; ?>" onChange="divsubaction('<?php echo $j; ?>', this.value)">
					<?php for ($i=0;$i<=10;$i++) {?>
						<option value="<?php echo $i;?>" <?php if (${"total_subaction_$j"} == $i) echo "selected"; ?>><?php echo $i;?></option>
					<?php } ?>
				</select><br/>
				</td>
            </tr>
		</table>
		</div>
        <div id="action_details_<?php echo $j;?>" style="display:<?php echo (${"total_subaction_$j"}<1&&$j<=$total_action)?"block":"none" ?>">
		<table>
            <tr>
                <td class='text' width="125"><?php echo htmlspecialchars(xl('Target Date'), ENT_QUOTES);?>:</td>
                <td width=10></td>
                <td class='text'><?php generate_form_field(array('data_type'=>4,'field_id'=>"action_targetdate_$j"), ${"form_action_targetdate_$j"});
                echo "<script language='JavaScript'>Calendar.setup({inputField:'form_action_targetdate_$j', ifFormat:'%Y-%m-%d', button:'img_action_targetdate_$j'});</script>";?>
                </td>
            </tr>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('Reminder Timeframe'), ENT_QUOTES);?>:</td>
                <td width=10></td>
                <td class='text'><input type="text" size="4" name="reminder_timeframe_<?php echo $j; ?>" value="<?php echo htmlspecialchars(${"reminder_timeframe_$j"}, ENT_QUOTES);?>"> <?php echo htmlspecialchars(xl('Days'), ENT_QUOTES);?></td>
            </tr>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('Followup Timeframe'), ENT_QUOTES);?>:</td>
                <td width=10></td>
                <td class='text'><input type="text" size="4" name="followup_timeframe_<?php echo $j; ?>" value="<?php echo htmlspecialchars(${"followup_timeframe_$j"}, ENT_QUOTES);?>"> <?php echo htmlspecialchars(xl('Days'), ENT_QUOTES);?></td>
            </tr>
            <tr>
                <td class='text'><?php echo htmlspecialchars(xl('Completed'), ENT_QUOTES);?>:</td>
                <td width=10></td>
                <td class='text'><input type='checkbox' value="YES" name='completed_<?php echo $j; ?>' <?php echo ${"completed_$j"}=="YES"?"checked":"";?>/></td>
            </tr>
        </table>
        </div>
		<?php for ($k = 1; $k<=10; $k++) { ?>
				<div id="subaction_<?php echo $j;?>_<?php echo $k;?>" style="display:<?php echo $k<=${"total_subaction_$j"}?"block":"none" ?>">
				<table>
					<tr>
						<td width=140></td>
						<td class='text' width="125"><u><?php echo htmlspecialchars(xl('Subaction #'). "" .$k, ENT_QUOTES);?>:</u></td>
						<td width=10></td>
						<td class='text'><input type="text" size="26" name="plan_action_<?php echo $j;?>-<?php echo $k; ?>" value="<?php echo htmlspecialchars(${"plan_action_$j-$k"}, ENT_QUOTES);?>"></td>
					</tr>
					<tr>
						<td width=140></td>
						<td class='text'><?php echo htmlspecialchars(xl('Target Date'), ENT_QUOTES);?>:</td>
						<td width=10></td>
						<td class='text'><?php generate_form_field(array('data_type'=>4,'field_id'=>"action_targetdate_$j-$k"), ${"form_action_targetdate_$j-$k"});
						echo "<script language='JavaScript'>Calendar.setup({inputField:'form_action_targetdate_$j-$k', ifFormat:'%Y-%m-%d', button:'img_action_targetdate_$j-$k'});</script>";?>
						</td>
					</tr>
					<tr>
						<td width=140></td>
						<td class='text'><?php echo htmlspecialchars(xl('Reminder Timeframe'), ENT_QUOTES);?>:</td>
						<td width=10></td>
						<td class='text'><input type="text" size="4" name="reminder_timeframe_<?php echo $j;?>-<?php echo $k; ?>" value="<?php echo htmlspecialchars(${"reminder_timeframe_$j-$k"}, ENT_QUOTES);?>"> <?php echo htmlspecialchars(xl('Days'), ENT_QUOTES);?></td>
					</tr>
					<tr>
						<td width=140></td>
						<td class='text'><?php echo htmlspecialchars(xl('Followup Timeframe'), ENT_QUOTES);?>:</td>
						<td width=10></td>
						<td class='text'><input type="text" size="4" name="followup_timeframe_<?php echo $j;?>-<?php echo $k; ?>" value="<?php echo htmlspecialchars(${"followup_timeframe_$j-$k"}, ENT_QUOTES);?>"> <?php echo htmlspecialchars(xl('Days'), ENT_QUOTES);?></td>
					</tr>
					<tr>
						<td width=140></td>
						<td class='text'><?php echo htmlspecialchars(xl('Completed'), ENT_QUOTES);?>:</td>
						<td width=10></td>
						<td class='text'><input type='checkbox' value="YES" name='completed_<?php echo $j;?>-<?php echo $k; ?>' <?php echo ${"completed_$j-$k"}=="YES"?"checked":"";?>/></td>
					</tr>
				</table>
				</div>
		<?php } ?>
<?php } ?>
        </td>
    </tr>
    <tr>
        <td class='text'><?php echo htmlspecialchars(xl('Activation Status'), ENT_QUOTES);?>:</td>
        <td width=10></td>
        <td class='text'><input type="radio" name="activation_status" value="activate" checked><?php echo htmlspecialchars(xl('Activate Plan for All Patients'), ENT_QUOTES);?> <input type="radio" name="activation_status" value="deactivate" <?php echo $activation_status=="deactivate"?'checked':''; ?>><?php echo htmlspecialchars(xl('Deactivate Plan for All Patients'), ENT_QUOTES);?></td>
    </tr>
    <tr>
        <td colspan="3" align="center">
        <input type="hidden" name="plan_id" value="<?php echo $plan_id ?>"><br>
        <?php 
        if ($task == "edit") {
        ?>
        <input type="button" id="update" onClick="submitUpdate();" value="<?php echo htmlspecialchars(xl('Update'), ENT_QUOTES); ?>">
        &nbsp;&nbsp;
        <?php 
        }
        else {
        ?>
        <input type="button" id="add_as_new" onClick="submitAdd();" value="<?php echo htmlspecialchars(xl('Add as New'), ENT_QUOTES); ?>">
        <?php
        }
        ?>
        &nbsp;&nbsp;
        <input type="button" id="cancel" onClick="submitCancel();" value="<?php echo htmlspecialchars(xl('Cancel'), ENT_QUOTES); ?>">
        </td>
    </tr>
</table>
</center>
</form>
<?php
}
else
{
	// This is for sorting the records.
    $sort = array("plan_name", "category", "activation_status");
    if($sortby == "") {
        $sortby = $sort[0];
    }
    if($sortorder == "") { 
        $sortorder = "asc";
    }
    for($i = 0; $i < count($sort); $i++) {
        $sortlink[$i] = "<a href=\"health_plans_admin.php?sortby=$sort[$i]&sortorder=asc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortdown.gif\" border=0 alt=\"".htmlspecialchars(xl('Sort Up'), ENT_QUOTES)."\"></a>";
    }
    for($i = 0; $i < count($sort); $i++) {
        if($sortby == $sort[$i]) {
            switch($sortorder) {
                case "asc"      : $sortlink[$i] = "<a href=\"health_plans_admin.php?sortby=$sortby&sortorder=desc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortup.gif\" border=0 alt=\"".htmlspecialchars(xl('Sort Up'), ENT_QUOTES)."\"></a>"; break;
                case "desc"     : $sortlink[$i] = "<a href=\"health_plans_admin.php?sortby=$sortby&sortorder=asc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortdown.gif\" border=0 alt=\"".htmlspecialchars(xl('Sort Down'), ENT_QUOTES)."\"></a>"; break;
            } break;
        }
    }
    // This is for managing page numbering and display beneaths the Health Plans table.
    $listnumber = 25;
    $sql = "select COUNT(*) AS count FROM health_plans WHERE $where";
    $total_row = sqlQuery($sql);
    if($total_row['count']) {
        $total = $total_row['count'];
    }
    else {
        $total = 0;
    }
    if($begin == "" or $begin == 0) {
        $begin = 0;
    }
    $prev = $begin - $listnumber;
    $next = $begin + $listnumber;
    $start = $begin + 1;
    $end = $listnumber + $start - 1;
    if($end >= $total) {
        $end = $total;
    }
    if($end < $start) {
        $start = 0;
    }
    if($prev >= 0) {
        $prevlink = "<a href=\"health_plans_admin.php?sortby=$sortby&sortorder=$sortorder&begin=$prev\" onclick=\"top.restoreSession()\"><<</a>";
    }
    else { 
        $prevlink = "<<";
    }
    
    if($next < $total) {
        $nextlink = "<a href=\"health_plans_admin.php?sortby=$sortby&sortorder=$sortorder&begin=$next\" onclick=\"top.restoreSession()\">>></a>";
    }
    else {
        $nextlink = ">>";
    }
    // This is for displaying the Health Plans table header.
    echo "
    <table width=100%><tr><td><table border=0 cellpadding=1 cellspacing=0 width=90%  style=\"border-left: 1px #000000 solid; border-right: 1px #000000 solid; border-top: 1px #000000 solid;\">
    <form name=wikiList action=\"health_plans_admin.php?mode=$mode&sortby=$sortby&sortorder=$sortorder&begin=$begin\" method=post>
    <input type=hidden name=task value=delete>
    <input type=hidden name=plan_id value=$plan_id>
        <tr height=\"24\" style=\"background:lightgrey\">
            <td align=\"center\" width=\"25\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><input type=checkbox id=\"checkAll\" onclick=\"selectAll()\"></td>
            <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\" class=bold>&nbsp;<b>".htmlspecialchars(xl('Plan Name'), ENT_QUOTES)."</b> $sortlink[0]</td>
            <td width=\"30%\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\" class=bold>&nbsp;<b>".htmlspecialchars(xl('Category'), ENT_QUOTES)."</b> $sortlink[1]</td>
            <td width=\"15%\" style=\"border-bottom: 1px #000000 solid; \" class=bold>&nbsp;<b>".htmlspecialchars(xl('Status'), ENT_QUOTES)."</b> $sortlink[2]</td>
        </tr>";
        // This is for displaying the Health Plans table body.
        $count = 0; 
        $sql = "select plan_id, plan_name, category, plan_description, activation_status from health_plans WHERE $where order by $sortby $sortorder limit $begin, $listnumber";
        $result = sqlStatement($sql);
        while ($myrow = sqlFetchArray($result)) {
            $category_row = sqlQuery("SELECT title FROM list_options WHERE option_id = ? LIMIT 1", array($myrow["category"]));
            $category_name = htmlspecialchars(trim($category_row['title']), ENT_QUOTES);
            $status = (htmlspecialchars($myrow['activation_status'], ENT_QUOTES)=="activate"?"Activated":"Deactivated");
            $count++;
            echo "
            <tr id=\"row$count\" style=\"background:white\" height=\"24\">
                <td align=\"center\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><input type=checkbox id=\"check$count\" name=\"delete_id[]\" value=\"".htmlspecialchars($myrow['plan_id'], ENT_QUOTES)."\" onclick=\"if(this.checked==true){ selectRow('row$count'); }else{ deselectRow('row$count'); }\"></td>
                <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\"><a href='javascript:submitEdit(". htmlspecialchars($myrow['plan_id'], ENT_QUOTES) .")'>".htmlspecialchars($myrow['plan_name'], ENT_QUOTES)."</a></td><td width=5></td></tr></table></td>
                <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\">".$category_name."</td><td width=5></td></tr></table></td>
                <td style=\"border-bottom: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\">$status</td><td width=5></td></tr></table></td>
            </tr>";
        }
    // This is for displaying the Health Plans table footer.
    echo "
    </form></table>
    <table border=0 cellpadding=5 cellspacing=0 width=90%>
        <tr>
            <td class=\"text\"><a href=\"health_plans_admin.php?sortby=$sortby&sortorder=$sortorder&begin=$begin&task=addnew\" onclick=\"top.restoreSession()\">".htmlspecialchars(xl('Add New'), ENT_QUOTES)."</a> &nbsp; <a href=javascript:confirmDeleteSelected() onclick=\"top.restoreSession()\">".htmlspecialchars(xl('Delete'), ENT_QUOTES)."</a></td>
            <td align=right class=\"text\">$prevlink &nbsp; $end of $total &nbsp; $nextlink</td>
        </tr>
    </table></td></tr></table><br>"; ?>
<script language="javascript">
// This is to confirm delete action.
function confirmDeleteSelected() {
    var check_delete
	for(i = 1; i <= <?php echo $count ?>; i++) {
		if (document.getElementById("check"+i).checked==true){
			check_delete = "Yes";
		}
	}
	if (check_delete=="Yes"){
		if(confirm("<?php echo htmlspecialchars(xl('Do you really want to delete the selection?'), ENT_QUOTES); ?>")){
			top.restoreSession();
			document.wikiList.submit();
		}
	} else {
		alert("<?php echo htmlspecialchars(xl('No item in the list are selected'), ENT_QUOTES);?>");
	}
}
// This is to allow selection of all items in Health Plans table for deletion.
function selectAll() {
    if(document.getElementById("checkAll").checked==true) {
        document.getElementById("checkAll").checked=true;<?php
        for($i = 1; $i <= $count; $i++) {
            echo "document.getElementById(\"check$i\").checked=true; document.getElementById(\"row$i\").style.background='#E7E7E7';  ";
        } ?>
    }
    else {
        document.getElementById("checkAll").checked=false;<?php
        for($i = 1; $i <= $count; $i++) {
            echo "document.getElementById(\"check$i\").checked=false; document.getElementById(\"row$i\").style.background='#F7F7F7';  ";
        } ?>
    }
}
// The two functions below are for changing row styles in Health Plans table.
function selectRow(row) {
    document.getElementById(row).style.background = "#E7E7E7";
}
function deselectRow(row) {
    document.getElementById(row).style.background = "#F7F7F7";
}
<?php
 if ($alertmsg) {
  echo "alert('" . htmlspecialchars($alertmsg, ENT_QUOTES) . "');\n";
 }
?>
</script>
<?php 
} 
?>

</body>
</html>
