<?php
// Copyright (C) 2010 OpenEMR Support LLC  
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

require_once("../../globals.php");
require_once("$srcdir/pnotes.inc");
require_once("$srcdir/patient.inc");
require_once("$srcdir/acl.inc");
require_once("$srcdir/log.inc");
require_once("$srcdir/sql.inc");
require_once("$srcdir/options.inc.php");
include_once("$srcdir/formdata.inc.php");
require_once("$srcdir/classes/Document.class.php");
require_once("$srcdir/gprelations.inc.php");
require_once("../summary/clinical_alerts_functions.php");
require_once("health_plans_functions.php");

?>
<html>
<head>
<?php html_header_show();?>
<link rel="stylesheet" href="<?php echo $css_header;?>" type="text/css">
<style type="text/css">@import url(../../../library/dynarch_calendar.css);</style>
<script type="text/javascript" src="../../../library/dialog.js"></script>
<script type="text/javascript" src="../../../library/textformat.js"></script>
<script type="text/javascript" src="../../../library/dynarch_calendar.js"></script>
<script type="text/javascript" src="../../../library/dynarch_calendar_en.js"></script>
<script type="text/javascript" src="../../../library/dynarch_calendar_setup.js"></script>
<script type="text/javascript" src="<?php echo $GLOBALS['webroot']; ?>/library/js/jquery.js"></script>

<script LANGUAGE="JavaScript">
var mypcc = '<?php echo $GLOBALS['phone_country_code'] ?>';
 // Check the mandatory fields and show the warning.
function validate() {
  var f = document.forms[0];
  if (f.form_signup_date.value.length == 0) {
   alert('<?php xl('Please choose a value for Signup Date!', 'e') ?>');
   f.form_signup_date.focus();
   return false;
  }
  top.restoreSession();
  return true;
}
</script>
</head>

<body class="body_top">
<table><tr><td><span class="title"><?php xl('Health Plans','e'); ?></td></tr></table><br>
<?php
switch($task) {
    case "add" : {
		// Do the checking for the existing enrollment.
        $sql = "select reminder_id from patient_reminders where plan_id='".formData("plan_id")."' and patient_id='$pid'";
        $result = sqlStatement($sql);
        if ($myrow = sqlFetchArray($result)) {
            $sysinfo = "The patient is already enrolled in this plan!";
            $task = "addnew";
        }
        else {
			switch(formData("form_enrollment_status"))
			{
				case "patient_refused" : $reminderstatus = "cancelled"; break;
				case "in_progress" : $reminderstatus = "pending"; break;
				case "completed" : $reminderstatus = "send"; break;
				default : $reminderstatus = formData("form_enrollment_status"); break;
			}
	        // Add a new enrollment for a specific patient.
			$enroll_id = sqlInsert("INSERT INTO health_plan_enrollment SET  patient_id = '$pid', plan_id = '".formData("plan_id")."', status = '".formData("form_enrollment_status")."', signup_date = '".formData("form_signup_date")."'");
			
			// Enroll the health plan for the patient
			health_plans_enrollment(formData("plan_id"), $pid, $enroll_id, $reminderstatus, "patient");
			
			// check and insert alert for patient
			insert_alert($pid);
        }
    } break;
    case "edit" : {
        // Get the enrollment details to display.
        $sql = "select patient_id, plan_id, signup_date, status, action_date, action_completed from health_plan_enrollment where enroll_id='".formData("enroll_id", "G")."'";
        $result = sqlStatement($sql);
        if ($myrow = sqlFetchArray($result)) {
            $patient_id = $myrow['patient_id'];
            $plan_id = $myrow['plan_id'];
            $form_signup_date = $myrow['signup_date'];
            $form_enrollment_status = $myrow['status'];
			$form_action_targetdate = explode(",", $myrow['action_date']);
			$form_action_completed = explode(",", $myrow['action_completed']);
        }
    } break;
    case "update" : {
		// Change the reminder status based on enrollment status.
		switch(formData("form_enrollment_status"))
		{
			case "patient_refused" : $reminderstatus = "cancelled"; break;
			case "in_progress" : $reminderstatus = "pending"; break;
			case "completed" : $reminderstatus = "send"; break;
			default : $reminderstatus = formData("form_enrollment_status"); break;
		}
		
		// Select the plan ID from based on the enrollment ID.
        $enrollrow = sqlQuery("select plan_id from health_plan_enrollment where enroll_id='".formData("enroll_id")."'");

        // Delete the existing reminder of the enrollment.
        sqlQuery("delete from patient_reminders where plan_id='".$enrollrow['plan_id']."' and patient_id='$pid'");

		// Enroll the health plan for the patient
		health_plans_enrollment($enrollrow['plan_id'], $pid, formData("enroll_id"), $reminderstatus, "patient");
    } break;
    case "delete" : {
        // Delete selected enrollment(s) from the Health Plans box (only).
		$delete_id = $_POST['delete_id'];
        for($i = 0; $i < count($delete_id); $i++) {
            sqlQuery("delete from health_plan_enrollment where enroll_id='$delete_id[$i]'");
            sqlQuery("delete from patient_reminders where enroll_id='$delete_id[$i]'");
        }
    } break;
}

if($task == "addnew" or $task == "edit") {
 // Display the Health Plans page layout.
echo "<form name=reminder action=\"health_plans_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$begin\" method=post>";

if ($task == "addnew") {
    echo "<input type=hidden name=task value=add>";
}
else {
    echo "<input type=hidden name=enroll_id value=$enroll_id><input type=hidden name=task value=update>";
}
?><div id="pnotes"><center><?php

if ($sysinfo) {
    echo "<table border='0' cellspacing='8'><tr><td class=text><span style='color:red;'><b>$sysinfo</b></span></td></tr></table>";
} ?>

<table border='0' cellspacing='8'>
<tr><td class='text'><?php xl('Plan','e'); ?>:</td><td class='text'><select name='plan_id' style="width:200px " onChange="document.reminder.task.value='<?php echo $task ?>';document.reminder.submit()" <?php echo ($task=="addnew"?"":"disabled") ?>><?php
$pres = sqlStatement("SELECT plan_id, plan_name FROM  health_plans WHERE activation_status='activate' ORDER BY plan_name");

while ($prow = sqlFetchArray($pres)) {
	if ($plan_id==""){
 		$plan_id = $prow['plan_id'];
 	}
  	echo "    <option value='" . $prow['plan_id'] . "'";
  	if ($prow['plan_id'] == $plan_id) echo " selected";
  	echo ">" . $prow['plan_name'];
  	echo "</option>\n";
}
?></select></td></tr><?php
// Get and display health plan records based on plan ID.
$sql = "SELECT * FROM health_plans WHERE plan_id = '$plan_id'";
$results = sqlQ($sql);
while ($row = sqlFetchArray($results)) {
	$plan_name = $row['plan_name'];
	$description = $row['plan_description'];
	$category = $row['category'];
    $frequency = explode("::", $row['frequency']);
	$frq_year = $frequency[0];
	$frq_month = $frequency[1];
	$gender = $row['gender'];
	$plan_goal = $row['goals'];
	$fromage = $row['age_from'];
	$toage = $row['age_to'];
	$from_month = $row['month_from'];
	$to_month = $row['month_to'];
	$icd_include = $row['icd_include'];
	$cpt_include = $row['cpt_include'];
	$ndc_include = $row['ndc_include'];
	$allergy_include = $row['allergy_include'];
	$patient_history_include = $row['patient_history_include'];
	$lab_abnormal_result_include = $row['lab_abnormal_result_include'];
	$icd_exclude = $row['icd_exclude'];
	$cpt_exclude = $row['cpt_exclude'];
	$ndc_exclude = $row['ndc_exclude'];
	$allergy_exclude = $row['allergy_exclude'];
	$patient_history_exclude = $row['patient_history_exclude'];
	$lab_abnormal_result_exclude = $row['lab_abnormal_result_exclude'];
	$activation_status = $row['activation_status'];
	$total_action = 0;
	$action_count = 0;
	$sql = "SELECT * FROM health_plan_actions WHERE plan_id = '$plan_id' order by action_id";
	$results = sqlQ($sql);
	while ($row = sqlFetchArray($results)) {
		if ($row['subactions'] != "" && $row['subactions'] != NULL) {
			$total_action++;
			$total_subaction = 0;
			${"action_id_".$total_action} = $row['action_id'];
			${"plan_action_".$total_action} = $row['action_content'];
			$frequency = explode("::", $row['frequency']);
			${"frq_year_".$total_action} = $frequency[0];
			${"frq_month_".$total_action} = $frequency[1];
			${"total_subaction_".$total_action} = $row['subactions'];
			if ($task == "addnew") {
				${"form_action_targetdate_".$total_action} = $row['action_targetdate'];
			}
			else {
				${"form_action_targetdate_".$total_action} = $form_action_targetdate[$action_count];
			}
			${"reminder_timeframe_".$total_action} = $row['reminder_timeframe'];
			${"followup_timeframe_".$total_action} = $row['followup_timeframe'];
			if ($task == "addnew") {
				${"completed_".$total_action} = $row['completed'];
			}
			else {
				${"completed_".$total_action} = substr($form_action_completed[$action_count], - 3);
			}
		}
		else {
			$total_subaction++;
			${"plan_action_$total_action-$total_subaction"} = $row['action_content'];
			if ($task == "addnew") {
				${"form_action_targetdate_$total_action-$total_subaction"} = $row['action_targetdate'];
			}
			else {
				${"form_action_targetdate_$total_action-$total_subaction"} = $form_action_targetdate[$action_count];
			}
			${"reminder_timeframe_$total_action-$total_subaction"} = $row['reminder_timeframe'];
			${"followup_timeframe_$total_action-$total_subaction"} = $row['followup_timeframe'];
			if ($task == "addnew") {
				${"completed_$total_action-$total_subaction"} = $row['completed'];
			}
			else {
				${"completed_$total_action-$total_subaction"} = substr($form_action_completed[$action_count], - 3);
			}
		}
		if ($row['subactions'] == 0)
		{
			++$action_count;
		}
	}
}
?>

<tr><td class='text'><?php xl('Patient','e'); ?>:</td><td class='text'><?php
 if ($pid) {
  $prow = sqlQuery("SELECT lname, fname " .
   "FROM patient_data WHERE pid = '" . $pid . "'");
  $patientname = $prow['lname'].", " . $prow['fname'];
 } ?>
   <input type='text' size='10' name='form_patient' style='width:150px;' value='<?php echo htmlspecialchars($patientname, ENT_QUOTES); ?>' disabled /></td></tr>
<tr>
	<td class='text'><?php xl('Description','e'); ?>:</td>
	<td class='text'><textarea name="description" rows="8" style="width:450px;" disabled><?php echo $description;?></textarea></td>
</tr>
<tr>
	<td class='text'><?php xl('Category','e'); ?>:</td>
	<td class='text'>
	  <select disabled><option>
	  <?php
      $category_row = sqlQuery("SELECT title FROM list_options WHERE option_id = '$category' LIMIT 1");
      echo trim($category_row['title']);
	  ?>
	  </option></select></td>
</tr>
<tr>
	<td class='text'><?php xl('Frequency','e');?>:</td>
	<td class='text'>
	  <select disabled>
		<option><?php echo $frq_year?></option>
	  </select> <?php xl('year(s)','e');?>
	  <select disabled>
		<option><?php echo $frq_month?></option>
	  </select> <?php xl('month(s)','e');?>
	</td>
</tr>
<tr>
	<td class='text'><?php xl('Gender','e'); ?>:</td>
	<td class='text'><select disabled><option><?php echo ($gender?$gender:xl('All','e'))?></option></select></td>
</tr>
<tr>
	<td class='text'><?php xl('From Age','e'); ?>:</td>
	<td class='text'>
	  <select name="fromage" disabled>
		<option value=""><?php xl('Unassigned','e')?></option>
	  <?php for($i=0; $i<=130; $i++) { ?>
		<option value="<?php echo "$i" ?>" <?php if ($fromage=="$i") echo "selected" ?>> <?php echo $i?> </option>
	  <?php } ?>
	  </select>
	  <?php xl('Year(s)','e'); ?>
	  <select name="from_month" disabled>
		<option value=""><?php xl('Unassigned','e')?></option>
	  <?php for($m=0; $m<=11; $m++) { ?>
		<option value="<?php echo "$m" ?>" <?php if ($from_month=="$m") echo "selected" ?>> <?php echo $m?> </option>
	  <?php } ?>
	  </select>
	  <?php xl('Month(s)','e'); ?>
	</td>
</tr>
<tr>
	<td class='text'><?php xl('To Age','e'); ?>:</td>
	<td class='text'>
	  <select name="toage" disabled>
		<option value=""><?php xl('Unassigned','e')?></option>
	  <?php for($i=0; $i<=130; $i++) { ?>
		<option value="<?php echo "$i"; ?>" <?php if ($toage=="$i") echo "selected" ?>> <?php echo $i?> </option>
	  <?php } ?>
	  </select>
	  <?php xl('Year(s)','e'); ?>
	  <select name="to_month" disabled>
		<option value=""><?php xl('Unassigned','e')?></option>
	  <?php for($m=0; $m<=11; $m++) { ?>
		<option value="<?php echo "$m"; ?>" <?php if ($to_month=="$m") echo "selected" ?>> <?php echo $m?> </option>
	  <?php } ?>
	  </select>
	  <?php xl('Month(s)','e'); ?>
	</td>
</tr>
<tr>
	<td class='text' valign="top"><?php xl('Include Rule','e'); ?>:</td>
	<td class='text'>
	<div>
	<input type='checkbox' name='include_icd_show' id='include_icd_show' onclick='return divclick(this,"div_include_icd");' <?php echo (!empty($icd_include))?"checked":"";?> disabled/><?php xl('ICD','e'); ?>
	<input type='checkbox' name='include_cpt_show' id='include_cpt_show' onclick='return divclick(this,"div_include_cpt");' <?php echo (!empty($cpt_include))?"checked":"";?> disabled/><?php xl('CPT','e'); ?>
	<input type='checkbox' name='include_ndc_show' id='include_ndc_show' onclick='return divclick(this,"div_include_ndc");' <?php echo (!empty($ndc_include))?"checked":"";?> disabled/><?php xl('Medication','e'); ?>
    <input type='checkbox' name='include_allergy_show' id='include_allergy_show' onclick='return divclick(this,"div_include_allergy");' <?php echo (!empty($allergy_include))?"checked":"";?> disabled/><?php xl('Allergy','e'); ?>
	<input type='checkbox' name='include_pt_history_show' id='include_pt_history_show' onclick='return divclick(this,"div_include_pt_history");' <?php if ($patient_history_include != '') echo " checked";?> disabled/><?php xl('Patient History','e'); ?>
	<input type='checkbox' name='include_lab_show' id='include_lab_show' onclick='return divclick(this,"div_include_lab");' <?php if ($lab_abnormal_result_include != '') echo " checked";?> disabled/><?php xl('Lab Abnormal Result','e'); ?>
	</div>
	<div id="div_include_icd" style="display:<?php echo (!empty($icd_include))?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php xl('ICD Include','e'); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($icd_include)) {
				$icd_in_code = explode("::", $icd_include);
				foreach ($icd_in_code as $icd_in_val) {
					$codequery = "SELECT * FROM codes WHERE code_type='2' AND code = '".formDataCore($icd_in_val)."'";
					$coderesult = sqlStatement($codequery);
					while ($coderows = sqlFetchArray($coderesult)) {
						echo $coderows['code']. " " .ucfirst(strtolower($coderows['code_text'])). "<br />";
					}
				}
			}
			?>
			</td>
		</tr>
	</table>
	</div>
	<div id="div_include_cpt" style="display:<?php echo (!empty($cpt_include))?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php xl('CPT Include','e'); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($cpt_include)) {
				$cpt_in_code = explode("::", $cpt_include);
				foreach ($cpt_in_code as $cpt_in_val) {
					$codequery1 = "SELECT * FROM codes WHERE code_type='1' AND code = '".formDataCore($cpt_in_val)."'";
					$coderesult1 = sqlStatement($codequery1);
					while ($coderows1 = sqlFetchArray($coderesult1)) {
						echo $coderows1['code']. " " .ucfirst(strtolower($coderows1['code_text'])). "<br />";
					}
				}
			}
			?>
			</td>
		</tr>
	</table>
	</div>
	<div id="div_include_ndc" style="display:<?php echo (!empty($ndc_include))?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php xl('Medication Include','e'); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($ndc_include)) {
				echo str_replace("::", "<br />", $ndc_include);
			}
			?>
			</td>
		</tr>
	</table>
	</div>
	<div id="div_include_allergy" style="display:<?php echo (!empty($allergy_include))?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php xl('Allergy Include','e'); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($allergy_include)) {
				echo str_replace("::", "<br />", $allergy_include);
			}
			?>
			</td>
		</tr>
	</table>
	</div>
	<div id="div_include_pt_history" style="display:<?php echo $patient_history_include!=''?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php xl('Patient History Include','e'); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($patient_history_include)) {
				$patient_history_include = explode("::", $patient_history_include);
				for ($i = 0; $i < count($patient_history_include); ++ $i) {
					$tmp_patient_history_include = explode("||", $patient_history_include[$i]);
					echo $tmp_patient_history_include[1]." ".$tmp_patient_history_include[0]."<br>";
				}
			}
			?>
			</td>
		</tr>
	</table>
	</div>
	<div id="div_include_lab" style="display:<?php echo $lab_abnormal_result_include!=''?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php xl('Lab Abnormal Result Include','e'); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($lab_abnormal_result_include)) {
				$lab_abnormal_result_in_procedure = explode("::", $lab_abnormal_result_include);
				foreach ($lab_abnormal_result_in_procedure as $lab_abnormal_result_in_val) {
					$procedurequery = "SELECT * FROM procedure_type WHERE procedure_type_id = '".$lab_abnormal_result_in_val."'";
					$procedureresult = sqlStatement($procedurequery);
					while ($procedurerows = sqlFetchArray($procedureresult)) {
						echo $procedurerows['name']. " " . $procedurerows['description']."<br>";
					}
				}
			}
			?>
			</td>
		</tr>
	</table>
	</div>
	</td>
</tr>
<tr>
	<td class='text' valign="top"><?php xl('Exclude Rule','e'); ?>:</td>
	<td class='text'>
	<div>
	<input type='checkbox' name='exclude_icd_show' id='exclude_icd_show' onclick='return divclick(this,"div_exclude_icd");' <?php echo (!empty($icd_exclude))?'checked':'';?> disabled/><?php xl('ICD','e'); ?>
	<input type='checkbox' name='exclude_cpt_show' id='exclude_cpt_show' onclick='return divclick(this,"div_exclude_cpt");' <?php echo (!empty($cpt_exclude))?'checked':'';?> disabled/><?php xl('CPT','e'); ?>
	<input type='checkbox' name='exclude_ndc_show' id='exclude_ndc_show' onclick='return divclick(this,"div_exclude_ndc");' <?php echo (!empty($ndc_exclude))?'checked':'';?> disabled/><?php xl('Medication','e'); ?>
    <input type='checkbox' name='exclude_allergy_show' id='exclude_allergy_show' onclick='return divclick(this,"div_exclude_allergy");' <?php echo (!empty($allergy_exclude))?'checked':'';?> disabled/><?php xl('Allergy','e'); ?>
	<input type='checkbox' name='exclude_pt_history_show' id='exclude_pt_history_show' onclick='return divclick(this,"div_exclude_pt_history");' <?php if ($patient_history_exclude != '') echo " checked";?> disabled/><?php xl('Patient History','e'); ?>
	<input type='checkbox' name='exclude_lab_show' id='exclude_lab_show' onclick='return divclick(this,"div_exclude_lab");' <?php if ($lab_abnormal_result_exclude != '') echo " checked";?> disabled/><?php xl('Lab Abnormal Result','e'); ?>
	</div>
	<div id="div_exclude_icd" style="display:<?php echo (!empty($icd_exclude))?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php xl('ICD Exclude','e'); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($icd_exclude)) {
				$icd_ex_code = explode("::", $icd_exclude);
				foreach ($icd_ex_code as $icd_ex_val) {
					$codequery2 = "SELECT * FROM codes WHERE code_type='2' AND code = '".formDataCore($icd_ex_val)."'";
					$coderesult2 = sqlStatement($codequery2);
					while ($coderows2 = sqlFetchArray($coderesult2)) {
						echo $coderows2['code']. " " .ucfirst(strtolower($coderows2['code_text'])). "<br />";
					}
				}
			}
			?>
			</td>
		</tr>
	</table>
	</div>
	<div id="div_exclude_cpt" style="display:<?php echo (!empty($cpt_exclude))?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php xl('CPT Exclude','e'); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($cpt_exclude)) {
				$cpt_in_code = explode("::", $cpt_exclude);
				foreach ($cpt_in_code as $cpt_in_val) {
					$codequery3 = "SELECT * FROM codes WHERE code_type='1' AND code = '".formDataCore($cpt_in_val)."'";
					$coderesult3 = sqlStatement($codequery3);
					while ($coderows3 = sqlFetchArray($coderesult3)) {
						echo $coderows3['code']. " " .ucfirst(strtolower($coderows3['code_text'])). "<br />";
					}
				}
			}
			?>
			</td>
		</tr>
	</table>
	</div>
	<div id="div_exclude_ndc" style="display:<?php echo (!empty($ndc_exclude))?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php xl('Medication Exclude','e'); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($ndc_exclude)) {
				echo str_replace("::", "<br />", $ndc_exclude);
			}
			?>
			</td>
		</tr>
	</table>
	</div>
	<div id="div_exclude_allergy" style="display:<?php echo (!empty($allergy_exclude))?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php xl('Allergy Exclude','e'); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($allergy_exclude)) {
				echo str_replace("::", "<br />", $allergy_exclude);
			}
			?>
			</td>
		</tr>
	</table>
	</div>
	
	<div id="div_exclude_pt_history" style="display:<?php echo $patient_history_exclude!=''?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php xl('Patient History Exclude','e'); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($patient_history_exclude)) {
				$patient_history_exclude = explode("::", $patient_history_exclude);
				for ($i = 0; $i < count($patient_history_exclude); ++ $i) {
					$tmp_patient_history_exclude = explode("||", $patient_history_exclude[$i]);
					echo $tmp_patient_history_exclude[1]." ".$tmp_patient_history_exclude[0]."<br>";
				}
			}
			?>
			</td>
		</tr>
	</table>
	</div>
	<div id="div_exclude_lab" style="display:<?php echo $lab_abnormal_result_exclude!=''?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php xl('Lab Abnormal Result Exclude','e'); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($lab_abnormal_result_exclude)) {
				$lab_abnormal_result_in_procedure = explode("::", $lab_abnormal_result_exclude);
				foreach ($lab_abnormal_result_in_procedure as $lab_abnormal_result_in_val) {
					$procedurequery = "SELECT * FROM procedure_type WHERE procedure_type_id = '".$lab_abnormal_result_in_val."'";
					$procedureresult = sqlStatement($procedurequery);
					while ($procedurerows = sqlFetchArray($procedureresult)) {
						echo $procedurerows['name']. " " . $procedurerows['description']."<br>";
					}
				}
			}
			?>
			</td>
		</tr>
	</table>
	</div>
	</td>
</tr>
<tr>
	<td class='text'><?php xl('Plan Goals','e');?>:</td>
	<td class='text'><textarea name="plan_goal" rows="8" style="width:450px;" disabled><?php echo $plan_goal;?></textarea></td>
</tr>
<tr>
	<td class='text' valign="top"><?php xl('Plan Action','e'); ?>:</td>
	<td class='text'>
		<select name="total_action" onChange="divaction(this.value)" disabled>
		  <option value='0'>0</option>
			<?php for ($i=1;$i<=10;$i++) {?>
				<option value="<?php echo $i;?>" <?php if ($total_action == $i) echo "selected"; ?>><?php echo $i;?></option>
			<?php } ?>
		</select><br/>
<?php for ($j = 1; $j<=$total_action; $j++) { ?>
	<div id="action_<?php echo $j;?>" style="display:<?php echo $j<=$total_action?"block":"none" ?>">
	<table>
		<tr>
			<td class='text' width="125"><?php echo xl('Action #'). "" .$j;?>:</td>
			<td class='text'><input type="text" size="50" name="plan_action_<?php echo $j; ?>" value="<?php echo ${"plan_action_$j"};?>" disabled></td>
		</tr>
		<tr>
			<td class='text'><?php xl('Frequency','e');?>:</td>
			<td class='text'>
			  <select name="frq_year_<?php echo $j; ?>" disabled>
				<option value=""><?php xl('Unassigned','e')?></option>
			  <?php for($frq=0; $frq<=130; $frq++) { ?>
				<option value="<?php echo $frq ?>" <?php if (${"frq_year_$j"}=="$frq") echo "selected" ?>><?php echo $frq?></option>
			  <?php } ?>
			  </select> <?php xl('Year(s)','e');?>
			  <select name="frq_month_<?php echo $j; ?>" disabled>
				<option value=""><?php xl('Unassigned','e')?></option>
			  <?php for($frq=0; $frq<=11; $frq++) { ?>
				<option value="<?php echo $frq ?>" <?php if (${"frq_month_$j"}=="$frq") echo "selected" ?>><?php echo $frq?></option>
			  <?php } ?>
			  </select> <?php xl('Month(s)','e');?>
			</td>
		</tr>
		<tr>
			<td class='text'><?php echo xl('Subaction');?>:</td>
			<td class='text'>
			  <select disabled>
				<option><?php echo ${"total_subaction_$j"}?></option>
			  </select><br/>
			</td>
		</tr>
	</table>
	</div>
	<div id="action_details_<?php echo $j;?>" style="display:<?php echo (${"total_subaction_$j"}<1&&$j<=$total_action)?"block":"none" ?>">
	<table>
		<tr>
			<td class='text'><?php xl('Target Date','e');?>:</td>
			<td class='text'><?php generate_form_field(array('data_type'=>4,'field_id'=>"action_targetdate_$j"), ${"form_action_targetdate_$j"});
			echo "<script language='JavaScript'>Calendar.setup({inputField:'form_action_targetdate_$j', ifFormat:'%Y-%m-%d', button:'img_action_targetdate_$j'});</script>"; ?>
			</td>
		</tr>
		<tr>
			<td class='text'><?php xl('Reminder Timeframe','e');?>:</td>
			<td class='text'><input type="text" size="4" name="reminder_timeframe_<?php echo $j; ?>" value="<?php echo ${"reminder_timeframe_$j"};?>" disabled> <?php xl('Days','e');?></td>
		</tr>
		<tr>
			<td class='text'><?php xl('Followup Timeframe','e');?>:</td>
			<td class='text'><input type="text" size="4" name="followup_timeframe_<?php echo $j; ?>" value="<?php echo ${"followup_timeframe_$j"};?>" disabled> <?php xl('Days','e');?></td>
		</tr>
		<tr>
			<td class='text'><?php xl('Completed','e');?>:</td>
			<td class='text'><input type='checkbox' value="YES" name='completed_<?php echo $j; ?>' <?php echo ${"completed_$j"}=="YES"?"checked":"";?>/></td>
		</tr>
	</table>
	</div>
	<?php for ($k = 1; $k<=${"total_subaction_$j"}; $k++) { ?>
		<div id="subaction_<?php echo $j;?>_<?php echo $k;?>" style="display:<?php echo $k<=${"total_subaction_$j"}?"block":"none" ?>">
		<table>
			<tr>
				<td width=125></td>
				<td class='text' width="125"><u><?php echo xl('Subaction #'). "" .$k;?>:</u></td>
				<td width=10></td>
				<td class='text'><input type="text" size="27" name="plan_action_<?php echo $j;?>-<?php echo $k; ?>" value="<?php echo htmlspecialchars(${"plan_action_$j-$k"}, ENT_QUOTES);?>" disabled></td>
			</tr>
			<tr>
				<td width=125></td>
				<td class='text'><?php xl('Target Date','e');?>:</td>
				<td width=10></td>
				<td class='text'><?php generate_form_field(array('data_type'=>4,'field_id'=>"action_targetdate_$j-$k"), ${"form_action_targetdate_$j-$k"});
				echo "<script language='JavaScript'>Calendar.setup({inputField:'form_action_targetdate_$j-$k', ifFormat:'%Y-%m-%d', button:'img_action_targetdate_$j-$k'});</script>";?>
				</td>
			</tr>
			<tr>
				<td width=125></td>
				<td class='text'><?php xl('Reminder Timeframe','e');?>:</td>
				<td width=10></td>
				<td class='text'><input type="text" size="4" name="reminder_timeframe_<?php echo $j;?>-<?php echo $k; ?>" value="<?php echo htmlspecialchars(${"reminder_timeframe_$j-$k"}, ENT_QUOTES);?>" disabled> <?php xl('Days','e');?></td>
			</tr>
			<tr>
				<td width=125></td>
				<td class='text'><?php xl('Followup Timeframe','e');?>:</td>
				<td width=10></td>
				<td class='text'><input type="text" size="4" name="followup_timeframe_<?php echo $j;?>-<?php echo $k; ?>" value="<?php echo htmlspecialchars(${"followup_timeframe_$j-$k"}, ENT_QUOTES);?>" disabled> <?php xl('Days','e');?></td>
			</tr>
			<tr>
				<td width=125></td>
				<td class='text'><?php xl('Completed','e');?>:</td>
				<td width=10></td>
				<td class='text'><input type='checkbox' value="YES" name='completed_<?php echo $j;?>-<?php echo $k; ?>' <?php echo ${"completed_$j-$k"}=="YES"?"checked":"";?>/></td>
			</tr>
		</table>
		</div>
	<?php } ?>
<?php } ?>
	</td>
</tr>
<tr><td class='required' width="100"><b><?php xl('Signup Date','e'); ?>:</b></td><td><?php
generate_form_field(array('data_type'=>4,'field_id'=>'signup_date'), $form_signup_date);
echo "<script language='JavaScript'>Calendar.setup({inputField:'form_signup_date', ifFormat:'%Y-%m-%d', button:'img_signup_date'});</script>";

if ($form_enrollment_status == "") {
	$form_enrollment_status = "in_progress";
}
?></td></tr>
<tr><td class='text'><?php xl('Status','e'); ?>:</td><td><?php generate_form_field(array('data_type'=>1,'field_id'=>'enrollment_status','list_id'=>'enrollment_status','empty_title'=>'SKIP'), $form_enrollment_status); ?></td></tr>
</table><br><input type="submit" value="<?php xl('Save enrollment','e'); ?>"  onClick="return validate()"> <input type="submit" value="<?php xl('Cancel','e'); ?>" onClick="document.reminder.task.value=''"><br></form></center></div><?php
}
else
{
    // This is for sorting the records.
    $sort = array("plan_name", "signup_date", "status");
    if($sortby == "") {
        $sortby = $sort[0];
    }
    if($sortorder == "") { 
        $sortorder = "asc";
    }
    for($i = 0; $i < count($sort); $i++) {
        $sortlink[$i] = "<a href=\"health_plans_patient.php?sortby=$sort[$i]&sortorder=asc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortdown.gif\" border=0 alt=\"".xl('Sort Up')."\"></a>";
    }
    for($i = 0; $i < count($sort); $i++) {
        if($sortby == $sort[$i]) {
            switch($sortorder) {
                case "asc"      : $sortlink[$i] = "<a href=\"health_plans_patient.php?sortby=$sortby&sortorder=desc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortup.gif\" border=0 alt=\"".xl('Sort Up')."\"></a>"; break;
                case "desc"     : $sortlink[$i] = "<a href=\"health_plans_patient.php?sortby=$sortby&sortorder=asc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortdown.gif\" border=0 alt=\"".xl('Sort Down')."\"></a>"; break;
            } break;
        }
    }
    // This is for managing page numbering and display beneaths the Health Plans table.
    $listnumber = 25;
    $sql = "select enroll_id, plan_name, signup_date, status from health_plan_enrollment, health_plans where health_plans.plan_id=health_plan_enrollment.plan_id and health_plan_enrollment.patient_id='$pid'";
    $result = sqlStatement($sql);
    if(sqlNumRows($result) != 0) {
        $total = sqlNumRows($result);
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
        $prevlink = "<a href=\"health_plans_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$prev\" onclick=\"top.restoreSession()\"><<</a>";
    }
    else { 
        $prevlink = "<<";
    }
    
    if($next < $total) {
        $nextlink = "<a href=\"health_plans_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$next\" onclick=\"top.restoreSession()\">>></a>";
    }
    else {
        $nextlink = ">>";
    }
    // This is for displaying the Health Plans table header.
    echo "
    <table width=100%><tr><td><table border=0 cellpadding=1 cellspacing=0 width=90%  style=\"border-left: 1px #000000 solid; border-right: 1px #000000 solid; border-top: 1px #000000 solid;\">
    <form name=wikiList action=\"health_plans_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$begin\" method=post>
    <input type=hidden name=task value=delete>
        <tr height=\"24\" style=\"background:lightgrey\">
            <td align=\"center\" width=\"25\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><input type=checkbox id=\"checkAll\" onclick=\"selectAll()\"></td>
            <td width=\"\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\" class=bold>&nbsp;<b>".xl('Plan')."</b> $sortlink[1]</td>
	    <td width=\"25%\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\" class=bold>&nbsp;<b>".xl('Signup Date')."</b> $sortlink[0]</td>
            <td width=\"25%\" style=\"border-bottom: 1px #000000 solid; \" class=bold>&nbsp;<b>".xl('Status')."</b> $sortlink[2]</td>
        </tr>";
        // This is for displaying the Health Plans table body.
        $count = 0;
        $sql = "select enroll_id, plan_name, signup_date, status from health_plan_enrollment, health_plans where health_plans.plan_id=health_plan_enrollment.plan_id and health_plan_enrollment.patient_id='$pid' order by $sortby $sortorder limit $begin, $listnumber";
        $result = sqlStatement($sql);
        while ($myrow = sqlFetchArray($result)) {
            $count++;
            echo "
            <tr id=\"row$count\" style=\"background:white\" height=\"24\">
                <td align=\"center\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><input type=checkbox id=\"check$count\" name=\"delete_id[]\" value=\"".$myrow['enroll_id']."\" onclick=\"if(this.checked==true){ selectRow('row$count'); }else{ deselectRow('row$count'); }\"></td>
                <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\"><a href=\"health_plans_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$begin&task=edit&enroll_id=".$myrow['enroll_id']."\" onclick=\"top.restoreSession()\">".$myrow['plan_name']."</a></td><td width=5></td></tr></table></td>
                <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\">".$myrow['signup_date']."</td><td width=5></td></tr></table></td>
                <td style=\"border-bottom: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\">".ucwords(str_replace("_", " ", $myrow['status']))."</td><td width=5></td></tr></table></td>
            </tr>";
        }
    // This is for displaying the Health Plans table footer.
    echo "
    </form></table>
    <table border=0 cellpadding=5 cellspacing=0 width=90%>
        <tr>
            <td class=\"text\"><a href=\"health_plans_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$begin&task=addnew\" onclick=\"top.restoreSession()\">".xl('Add New')."</a> &nbsp; <a href=\"javascript:confirmDeleteSelected()\" onclick=\"top.restoreSession()\">".xl('Delete')."</a></td>
            <td align=right class=\"text\">$prevlink &nbsp; $end of $total &nbsp; $nextlink</td>
        </tr>
    </table></td></tr></table><br>"; ?>

<script language="javascript">
// This is to confirm the delete action.
function confirmDeleteSelected() {
    if(confirm("<?php xl('Do you really want to delete the selection?', 'e') ?>")) {
        document.wikiList.submit();
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
</script><?php
}
?>

</body>
</html>
