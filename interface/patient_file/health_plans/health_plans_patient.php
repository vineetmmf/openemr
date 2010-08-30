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
   alert('<?php echo htmlspecialchars(xl('Please choose a value for Signup Date!'), ENT_QUOTES) ?>');
   f.form_signup_date.focus();
   return false;
  }
  top.restoreSession();
  return true;
}
</script>
</head>

<body class="body_top">
<table><tr><td><span class="title"><?php echo htmlspecialchars(xl('Health Plans'), ENT_QUOTES); ?></td></tr></table><br>
<?php
$task = htmlspecialchars($_REQUEST['task'], ENT_QUOTES);
$sortby = htmlspecialchars($_REQUEST['sortby'], ENT_QUOTES);
$sortorder = htmlspecialchars($_REQUEST['sortorder'], ENT_QUOTES);
$begin = htmlspecialchars($_REQUEST['begin'], ENT_QUOTES);

switch($task) {
    case "add" : {
		// Do the checking for the existing enrollment.
        //$sql = "select reminder_id from patient_reminders where plan_id=? and patient_id=?";
		$sql = "select enroll_id from health_plan_enrollment where plan_id=? and patient_id=?";
        $result = sqlStatement($sql, array(formData("plan_id"), $pid));
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
        $sql = "select patient_id, plan_id, signup_date, status, action_date, action_completed from health_plan_enrollment where enroll_id=?";
        $result = sqlStatement($sql, array(formData("enroll_id", "G")));
        if ($myrow = sqlFetchArray($result)) {
            $patient_id = htmlspecialchars($myrow['patient_id'], ENT_QUOTES);
            $plan_id = htmlspecialchars($myrow['plan_id'], ENT_QUOTES);
            $form_signup_date = htmlspecialchars($myrow['signup_date'], ENT_QUOTES);
            $form_enrollment_status = htmlspecialchars($myrow['status'], ENT_QUOTES);
			$form_action_targetdate = explode(",", htmlspecialchars($myrow['action_date'], ENT_QUOTES));
			$form_action_completed = explode(",", htmlspecialchars($myrow['action_completed'], ENT_QUOTES));
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
        $enrollrow = sqlQuery("select plan_id from health_plan_enrollment where enroll_id=?", array(formData("enroll_id")));

        // Delete the existing reminder of the enrollment.
        sqlQuery("delete from patient_reminders where plan_id=? and patient_id=?", array(formData("plan_id"), $pid));

		// Enroll the health plan for the patient
		health_plans_enrollment(formData("plan_id"), $pid, formData("enroll_id"), $reminderstatus, "patient");
    } break;
    case "delete" : {
        // Delete selected enrollment(s) from the Health Plans box (only).
		$delete_id = $_POST['delete_id'];
        for($i = 0; $i < count($delete_id); $i++) {
            sqlQuery("delete from health_plan_enrollment where enroll_id=?", array($delete_id[$i]));
            sqlQuery("delete from patient_reminders where enroll_id=?", array($delete_id[$i]));
        }
    } break;
}

if($task == "addnew" or $task == "edit") {
 // Display the Health Plans page layout.
echo "<form name=reminder action=\"health_plans_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$begin\" method=post>";

if ($task == "addnew") {
    echo "<input type=hidden name=task value=add>";
	$plan_id = formData("plan_id");
}
else {
    echo "<input type=hidden name=enroll_id value=".formData("enroll_id", "G").">".
	"<input type=hidden name=plan_id value=".$plan_id.">".
	"<input type=hidden name=task value=update>";
}
?><div id="pnotes"><center><?php

if ($sysinfo) {
    echo "<table border='0' cellspacing='8'><tr><td class=text><span style='color:red;'><b>$sysinfo</b></span></td></tr></table>";
} ?>

<table border='0' cellspacing='8'>
<tr><td class='text'><?php echo htmlspecialchars(xl('Plan'), ENT_QUOTES); ?>:</td><td class='text'><select name='plan_id' style="width:200px " onChange="document.reminder.task.value='<?php echo $task ?>';document.reminder.submit()" <?php echo ($task=="addnew"?"":"disabled") ?>><?php
$pres = sqlStatement("SELECT plan_id, plan_name FROM health_plans WHERE activation_status=? ORDER BY plan_name", array('activate'));

while ($prow = sqlFetchArray($pres)) {
	if ($plan_id==""){
 		$plan_id = htmlspecialchars($prow['plan_id'], ENT_QUOTES);
 	}
  	echo "    <option value='" . htmlspecialchars($prow['plan_id'], ENT_QUOTES) . "'";
  	if (htmlspecialchars($prow['plan_id'], ENT_QUOTES) == $plan_id) echo " selected";
  	echo ">" . htmlspecialchars($prow['plan_name'], ENT_QUOTES);
  	echo "</option>\n";
}
?></select></td></tr><?php
// Get and display health plan records based on plan ID.
$sql = "SELECT * FROM health_plans WHERE plan_id = ?";
$results = sqlQ($sql, array($plan_id));
while ($row = sqlFetchArray($results)) {
	$plan_name = htmlspecialchars($row['plan_name'], ENT_QUOTES);
	$description = htmlspecialchars($row['plan_description'], ENT_QUOTES);
	$category = htmlspecialchars($row['category'], ENT_QUOTES);
    $frequency = explode("::", htmlspecialchars($row['frequency'], ENT_QUOTES));
	$frq_year = $frequency[0];
	$frq_month = $frequency[1];
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
	$action_count = 0;
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
			if ($task == "addnew") {
				${"form_action_targetdate_".$total_action} = htmlspecialchars($row['action_targetdate'], ENT_QUOTES);
			}
			else {
				${"form_action_targetdate_".$total_action} = $form_action_targetdate[$action_count];
			}
			${"reminder_timeframe_".$total_action} = htmlspecialchars($row['reminder_timeframe'], ENT_QUOTES);
			${"followup_timeframe_".$total_action} = htmlspecialchars($row['followup_timeframe'], ENT_QUOTES);
			if ($task == "addnew") {
				${"completed_".$total_action} = htmlspecialchars($row['completed'], ENT_QUOTES);
			}
			else {
				${"completed_".$total_action} = substr($form_action_completed[$action_count], - 3);
			}
		}
		else {
			$total_subaction++;
			${"plan_action_$total_action-$total_subaction"} = htmlspecialchars($row['action_content'], ENT_QUOTES);
			if ($task == "addnew") {
				${"form_action_targetdate_$total_action-$total_subaction"} = htmlspecialchars($row['action_targetdate'], ENT_QUOTES);
			}
			else {
				${"form_action_targetdate_$total_action-$total_subaction"} = $form_action_targetdate[$action_count];
			}
			${"reminder_timeframe_$total_action-$total_subaction"} = htmlspecialchars($row['reminder_timeframe'], ENT_QUOTES);
			${"followup_timeframe_$total_action-$total_subaction"} = htmlspecialchars($row['followup_timeframe'], ENT_QUOTES);
			if ($task == "addnew") {
				${"completed_$total_action-$total_subaction"} = htmlspecialchars($row['completed'], ENT_QUOTES);
			}
			else {
				${"completed_$total_action-$total_subaction"} = substr($form_action_completed[$action_count], - 3);
			}
		}
		if (htmlspecialchars($row['subactions'], ENT_QUOTES) == 0)
		{
			++$action_count;
		}
	}
}
?>

<tr><td class='text'><?php echo htmlspecialchars(xl('Patient'), ENT_QUOTES); ?>:</td><td class='text'><?php
 if ($pid) {
  $prow = sqlQuery("SELECT lname, fname " .
   "FROM patient_data WHERE pid = ?", array($pid));
  $patientname = htmlspecialchars($prow['lname'].", " . $prow['fname'], ENT_QUOTES);
 } ?>
   <input type='text' size='10' name='form_patient' style='width:150px;' value='<?php echo htmlspecialchars($patientname, ENT_QUOTES); ?>' disabled /></td></tr>
<tr>
	<td class='text'><?php echo htmlspecialchars(xl('Description'), ENT_QUOTES); ?>:</td>
	<td class='text'><textarea name="description" rows="8" style="width:450px;" disabled><?php echo htmlspecialchars($description, ENT_QUOTES)?></textarea></td>
</tr>
<tr>
	<td class='text'><?php echo htmlspecialchars(xl('Category'), ENT_QUOTES); ?>:</td>
	<td class='text'>
	  <select disabled><option>
	  <?php
      $category_row = sqlQuery("SELECT title FROM list_options WHERE option_id = ? LIMIT 1", array($category));
      echo htmlspecialchars(trim($category_row['title']), ENT_QUOTES);
	  ?>
	  </option></select></td>
</tr>
<tr>
	<td class='text'><?php echo htmlspecialchars(xl('Frequency'), ENT_QUOTES);?>:</td>
	<td class='text'>
	  <select disabled>
		<option><?php echo $frq_year?></option>
	  </select> <?php echo htmlspecialchars(xl('year(s)'), ENT_QUOTES);?>
	  <select disabled>
		<option><?php echo $frq_month?></option>
	  </select> <?php echo htmlspecialchars(xl('month(s)'), ENT_QUOTES);?>
	</td>
</tr>
<tr>
	<td class='text'><?php echo htmlspecialchars(xl('Gender'), ENT_QUOTES); ?>:</td>
	<td class='text'><select disabled><option><?php echo ($gender?$gender:htmlspecialchars(xl('All'), ENT_QUOTES))?></option></select></td>
</tr>
<tr>
	<td class='text'><?php echo htmlspecialchars(xl('From Age'), ENT_QUOTES); ?>:</td>
	<td class='text'>
	  <select name="fromage" disabled>
		<option value=""><?php echo htmlspecialchars(xl('Unassigned'), ENT_QUOTES)?></option>
	  <?php for($i=0; $i<=130; $i++) { ?>
		<option value="<?php echo "$i" ?>" <?php if ($fromage=="$i") echo "selected" ?>> <?php echo $i?> </option>
	  <?php } ?>
	  </select>
	  <?php echo htmlspecialchars(xl('Year(s)'), ENT_QUOTES); ?>
	  <select name="from_month" disabled>
		<option value=""><?php echo htmlspecialchars(xl('Unassigned'), ENT_QUOTES)?></option>
	  <?php for($m=0; $m<=11; $m++) { ?>
		<option value="<?php echo "$m" ?>" <?php if ($from_month=="$m") echo "selected" ?>> <?php echo $m?> </option>
	  <?php } ?>
	  </select>
	  <?php echo htmlspecialchars(xl('Month(s)'), ENT_QUOTES); ?>
	</td>
</tr>
<tr>
	<td class='text'><?php echo htmlspecialchars(xl('To Age'), ENT_QUOTES); ?>:</td>
	<td class='text'>
	  <select name="toage" disabled>
		<option value=""><?php echo htmlspecialchars(xl('Unassigned'), ENT_QUOTES)?></option>
	  <?php for($i=0; $i<=130; $i++) { ?>
		<option value="<?php echo "$i"; ?>" <?php if ($toage=="$i") echo "selected" ?>> <?php echo $i?> </option>
	  <?php } ?>
	  </select>
	  <?php echo htmlspecialchars(xl('Year(s)'), ENT_QUOTES); ?>
	  <select name="to_month" disabled>
		<option value=""><?php echo htmlspecialchars(xl('Unassigned'), ENT_QUOTES)?></option>
	  <?php for($m=0; $m<=11; $m++) { ?>
		<option value="<?php echo "$m"; ?>" <?php if ($to_month=="$m") echo "selected" ?>> <?php echo $m?> </option>
	  <?php } ?>
	  </select>
	  <?php echo htmlspecialchars(xl('Month(s)'), ENT_QUOTES); ?>
	</td>
</tr>
<tr>
	<td class='text' valign="top"><?php echo htmlspecialchars(xl('Include Rule'), ENT_QUOTES); ?>:</td>
	<td class='text'>
	<div>
	<input type='checkbox' name='include_icd_show' id='include_icd_show' onclick='return divclick(this,"div_include_icd");' <?php echo (!empty($icd_include))?"checked":"";?> disabled/><?php echo htmlspecialchars(xl('ICD'), ENT_QUOTES); ?>
	<input type='checkbox' name='include_cpt_show' id='include_cpt_show' onclick='return divclick(this,"div_include_cpt");' <?php echo (!empty($cpt_include))?"checked":"";?> disabled/><?php echo htmlspecialchars(xl('CPT'), ENT_QUOTES); ?>
	<input type='checkbox' name='include_ndc_show' id='include_ndc_show' onclick='return divclick(this,"div_include_ndc");' <?php echo (!empty($ndc_include))?"checked":"";?> disabled/><?php echo htmlspecialchars(xl('Medication'), ENT_QUOTES); ?>
    <input type='checkbox' name='include_allergy_show' id='include_allergy_show' onclick='return divclick(this,"div_include_allergy");' <?php echo (!empty($allergy_include))?"checked":"";?> disabled/><?php echo htmlspecialchars(xl('Allergy'), ENT_QUOTES); ?>
	<input type='checkbox' name='include_pt_history_show' id='include_pt_history_show' onclick='return divclick(this,"div_include_pt_history");' <?php if ($patient_history_include != '') echo " checked";?> disabled/><?php echo htmlspecialchars(xl('Patient History'), ENT_QUOTES); ?>
	<input type='checkbox' name='include_lab_show' id='include_lab_show' onclick='return divclick(this,"div_include_lab");' <?php if ($lab_abnormal_result_include != '') echo " checked";?> disabled/><?php echo htmlspecialchars(xl('Lab Abnormal Result'), ENT_QUOTES); ?>
	</div>
	<div id="div_include_icd" style="display:<?php echo (!empty($icd_include))?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php echo htmlspecialchars(xl('ICD Include'), ENT_QUOTES); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($icd_include)) {
				$icd_in_code = explode("::", $icd_include);
				foreach ($icd_in_code as $icd_in_val) {
					$codequery = "SELECT * FROM codes WHERE code_type=? AND code = ?";
					$coderesult = sqlStatement($codequery, array('2', formDataCore($icd_in_val)));
					while ($coderows = sqlFetchArray($coderesult)) {
						echo htmlspecialchars($coderows['code']. " " .ucfirst(strtolower($coderows['code_text'])), ENT_QUOTES). "<br />";
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
			<td class='text'><?php echo htmlspecialchars(xl('CPT Include'), ENT_QUOTES); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($cpt_include)) {
				$cpt_in_code = explode("::", $cpt_include);
				foreach ($cpt_in_code as $cpt_in_val) {
					$codequery1 = "SELECT * FROM codes WHERE code_type=? AND code = ?";
					$coderesult1 = sqlStatement($codequery1, array('1', formDataCore($cpt_in_val)));
					while ($coderows1 = sqlFetchArray($coderesult1)) {
						echo htmlspecialchars($coderows1['code']. " " .ucfirst(strtolower($coderows1['code_text'])), ENT_QUOTES). "<br />";
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
			<td class='text'><?php echo htmlspecialchars(xl('Medication Include'), ENT_QUOTES); ?>:</td>
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
			<td class='text'><?php echo htmlspecialchars(xl('Allergy Include'), ENT_QUOTES); ?>:</td>
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
			<td class='text'><?php echo htmlspecialchars(xl('Patient History Include'), ENT_QUOTES); ?>:</td>
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
			<td class='text'><?php echo htmlspecialchars(xl('Lab Abnormal Result Include'), ENT_QUOTES); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($lab_abnormal_result_include)) {
				$lab_abnormal_result_in_procedure = explode("::", $lab_abnormal_result_include);
				foreach ($lab_abnormal_result_in_procedure as $lab_abnormal_result_in_val) {
					$procedurequery = "SELECT * FROM procedure_type WHERE procedure_type_id = ?";
					$procedureresult = sqlStatement($procedurequery, array($lab_abnormal_result_in_val));
					while ($procedurerows = sqlFetchArray($procedureresult)) {
						echo htmlspecialchars($procedurerows['name']. " " . $procedurerows['description'], ENT_QUOTES)."<br>";
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
	<td class='text' valign="top"><?php echo htmlspecialchars(xl('Exclude Rule'), ENT_QUOTES); ?>:</td>
	<td class='text'>
	<div>
	<input type='checkbox' name='exclude_icd_show' id='exclude_icd_show' onclick='return divclick(this,"div_exclude_icd");' <?php echo (!empty($icd_exclude))?'checked':'';?> disabled/><?php echo htmlspecialchars(xl('ICD'), ENT_QUOTES); ?>
	<input type='checkbox' name='exclude_cpt_show' id='exclude_cpt_show' onclick='return divclick(this,"div_exclude_cpt");' <?php echo (!empty($cpt_exclude))?'checked':'';?> disabled/><?php echo htmlspecialchars(xl('CPT'), ENT_QUOTES); ?>
	<input type='checkbox' name='exclude_ndc_show' id='exclude_ndc_show' onclick='return divclick(this,"div_exclude_ndc");' <?php echo (!empty($ndc_exclude))?'checked':'';?> disabled/><?php echo htmlspecialchars(xl('Medication'), ENT_QUOTES); ?>
    <input type='checkbox' name='exclude_allergy_show' id='exclude_allergy_show' onclick='return divclick(this,"div_exclude_allergy");' <?php echo (!empty($allergy_exclude))?'checked':'';?> disabled/><?php echo htmlspecialchars(xl('Allergy'), ENT_QUOTES); ?>
	<input type='checkbox' name='exclude_pt_history_show' id='exclude_pt_history_show' onclick='return divclick(this,"div_exclude_pt_history");' <?php if ($patient_history_exclude != '') echo " checked";?> disabled/><?php echo htmlspecialchars(xl('Patient History'), ENT_QUOTES); ?>
	<input type='checkbox' name='exclude_lab_show' id='exclude_lab_show' onclick='return divclick(this,"div_exclude_lab");' <?php if ($lab_abnormal_result_exclude != '') echo " checked";?> disabled/><?php echo htmlspecialchars(xl('Lab Abnormal Result'), ENT_QUOTES); ?>
	</div>
	<div id="div_exclude_icd" style="display:<?php echo (!empty($icd_exclude))?'block':'none'; ?>">
	<table>
		<tr>
			<td class='text'><?php echo htmlspecialchars(xl('ICD Exclude'), ENT_QUOTES); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($icd_exclude)) {
				$icd_ex_code = explode("::", $icd_exclude);
				foreach ($icd_ex_code as $icd_ex_val) {
					$codequery2 = "SELECT * FROM codes WHERE code_type=? AND code = ?";
					$coderesult2 = sqlStatement($codequery2, array('2', formDataCore($icd_ex_val)));
					while ($coderows2 = sqlFetchArray($coderesult2)) {
						echo htmlspecialchars($coderows2['code']. " " .ucfirst(strtolower($coderows2['code_text'])), ENT_QUOTES). "<br />";
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
			<td class='text'><?php echo htmlspecialchars(xl('CPT Exclude'), ENT_QUOTES); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($cpt_exclude)) {
				$cpt_in_code = explode("::", $cpt_exclude);
				foreach ($cpt_in_code as $cpt_in_val) {
					$codequery3 = "SELECT * FROM codes WHERE code_type=? AND code = ?";
					$coderesult3 = sqlStatement($codequery3, array('1', formDataCore($cpt_in_val)));
					while ($coderows3 = sqlFetchArray($coderesult3)) {
						echo htmlspecialchars($coderows3['code']. " " .ucfirst(strtolower($coderows3['code_text'])), ENT_QUOTES). "<br />";
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
			<td class='text'><?php echo htmlspecialchars(xl('Medication Exclude'), ENT_QUOTES); ?>:</td>
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
			<td class='text'><?php echo htmlspecialchars(xl('Allergy Exclude'), ENT_QUOTES); ?>:</td>
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
			<td class='text'><?php echo htmlspecialchars(xl('Patient History Exclude'), ENT_QUOTES); ?>:</td>
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
			<td class='text'><?php echo htmlspecialchars(xl('Lab Abnormal Result Exclude'), ENT_QUOTES); ?>:</td>
			<td width=10></td>
			<td class='text'>
			<?php
			if (!empty($lab_abnormal_result_exclude)) {
				$lab_abnormal_result_in_procedure = explode("::", $lab_abnormal_result_exclude);
				foreach ($lab_abnormal_result_in_procedure as $lab_abnormal_result_in_val) {
					$procedurequery = "SELECT * FROM procedure_type WHERE procedure_type_id = ?";
					$procedureresult = sqlStatement($procedurequery, array($lab_abnormal_result_in_val));
					while ($procedurerows = sqlFetchArray($procedureresult)) {
						echo htmlspecialchars($procedurerows['name']. " " . $procedurerows['description'], ENT_QUOTES)."<br>";
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
	<td class='text'><?php echo htmlspecialchars(xl('Plan Goals'), ENT_QUOTES);?>:</td>
	<td class='text'><textarea name="plan_goal" rows="8" style="width:450px;" disabled><?php echo $plan_goal;?></textarea></td>
</tr>
<tr>
	<td class='text' valign="top"><?php echo htmlspecialchars(xl('Plan Action'), ENT_QUOTES); ?>:</td>
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
			<td class='text' width="125"><?php echo htmlspecialchars(xl('Action #'), ENT_QUOTES). "" .$j;?>:</td>
			<td class='text'><input type="text" size="50" name="plan_action_<?php echo $j; ?>" value="<?php echo ${"plan_action_$j"};?>" disabled></td>
		</tr>
		<tr>
			<td class='text'><?php echo htmlspecialchars(xl('Frequency'), ENT_QUOTES);?>:</td>
			<td class='text'>
			  <select name="frq_year_<?php echo $j; ?>" disabled>
				<option value=""><?php echo htmlspecialchars(xl('Unassigned'), ENT_QUOTES)?></option>
			  <?php for($frq=0; $frq<=130; $frq++) { ?>
				<option value="<?php echo $frq ?>" <?php if (${"frq_year_$j"}=="$frq") echo "selected" ?>><?php echo $frq?></option>
			  <?php } ?>
			  </select> <?php echo htmlspecialchars(xl('Year(s)'), ENT_QUOTES);?>
			  <select name="frq_month_<?php echo $j; ?>" disabled>
				<option value=""><?php echo htmlspecialchars(xl('Unassigned'), ENT_QUOTES)?></option>
			  <?php for($frq=0; $frq<=11; $frq++) { ?>
				<option value="<?php echo $frq ?>" <?php if (${"frq_month_$j"}=="$frq") echo "selected" ?>><?php echo $frq?></option>
			  <?php } ?>
			  </select> <?php echo htmlspecialchars(xl('Month(s)'), ENT_QUOTES);?>
			</td>
		</tr>
		<tr>
			<td class='text'><?php echo htmlspecialchars(xl('Subaction'), ENT_QUOTES);?>:</td>
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
			<td class='text'><?php echo htmlspecialchars(xl('Target Date'), ENT_QUOTES);?>:</td>
			<td class='text'><?php generate_form_field(array('data_type'=>4,'field_id'=>"action_targetdate_$j"), ${"form_action_targetdate_$j"});
			echo "<script language='JavaScript'>Calendar.setup({inputField:'form_action_targetdate_$j', ifFormat:'%Y-%m-%d', button:'img_action_targetdate_$j'});</script>"; ?>
			</td>
		</tr>
		<tr>
			<td class='text'><?php echo htmlspecialchars(xl('Reminder Timeframe'), ENT_QUOTES);?>:</td>
			<td class='text'><input type="text" size="4" name="reminder_timeframe_<?php echo $j; ?>" value="<?php echo ${"reminder_timeframe_$j"};?>" disabled> <?php echo htmlspecialchars(xl('Days'), ENT_QUOTES);?></td>
		</tr>
		<tr>
			<td class='text'><?php echo htmlspecialchars(xl('Followup Timeframe'), ENT_QUOTES);?>:</td>
			<td class='text'><input type="text" size="4" name="followup_timeframe_<?php echo $j; ?>" value="<?php echo ${"followup_timeframe_$j"};?>" disabled> <?php echo htmlspecialchars(xl('Days'), ENT_QUOTES);?></td>
		</tr>
		<tr>
			<td class='text'><?php echo htmlspecialchars(xl('Completed'), ENT_QUOTES);?>:</td>
			<td class='text'><input type='checkbox' value="YES" name='completed_<?php echo $j; ?>' <?php echo ${"completed_$j"}=="YES"?"checked":"";?>/></td>
		</tr>
	</table>
	</div>
	<?php for ($k = 1; $k<=${"total_subaction_$j"}; $k++) { ?>
		<div id="subaction_<?php echo $j;?>_<?php echo $k;?>" style="display:<?php echo $k<=${"total_subaction_$j"}?"block":"none" ?>">
		<table>
			<tr>
				<td width=125></td>
				<td class='text' width="125"><u><?php echo htmlspecialchars(xl('Subaction #'), ENT_QUOTES). "" .$k;?>:</u></td>
				<td width=10></td>
				<td class='text'><input type="text" size="27" name="plan_action_<?php echo $j;?>-<?php echo $k; ?>" value="<?php echo htmlspecialchars(${"plan_action_$j-$k"}, ENT_QUOTES);?>" disabled></td>
			</tr>
			<tr>
				<td width=125></td>
				<td class='text'><?php echo htmlspecialchars(xl('Target Date'), ENT_QUOTES);?>:</td>
				<td width=10></td>
				<td class='text'><?php generate_form_field(array('data_type'=>4,'field_id'=>"action_targetdate_$j-$k"), ${"form_action_targetdate_$j-$k"});
				echo "<script language='JavaScript'>Calendar.setup({inputField:'form_action_targetdate_$j-$k', ifFormat:'%Y-%m-%d', button:'img_action_targetdate_$j-$k'});</script>";?>
				</td>
			</tr>
			<tr>
				<td width=125></td>
				<td class='text'><?php echo htmlspecialchars(xl('Reminder Timeframe'), ENT_QUOTES);?>:</td>
				<td width=10></td>
				<td class='text'><input type="text" size="4" name="reminder_timeframe_<?php echo $j;?>-<?php echo $k; ?>" value="<?php echo htmlspecialchars(${"reminder_timeframe_$j-$k"}, ENT_QUOTES);?>" disabled> <?php echo htmlspecialchars(xl('Days'), ENT_QUOTES);?></td>
			</tr>
			<tr>
				<td width=125></td>
				<td class='text'><?php echo htmlspecialchars(xl('Followup Timeframe'), ENT_QUOTES);?>:</td>
				<td width=10></td>
				<td class='text'><input type="text" size="4" name="followup_timeframe_<?php echo $j;?>-<?php echo $k; ?>" value="<?php echo htmlspecialchars(${"followup_timeframe_$j-$k"}, ENT_QUOTES);?>" disabled> <?php echo htmlspecialchars(xl('Days'), ENT_QUOTES);?></td>
			</tr>
			<tr>
				<td width=125></td>
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
<tr><td class='required' width="100"><b><?php echo htmlspecialchars(xl('Signup Date'), ENT_QUOTES); ?>:</b></td><td><?php
generate_form_field(array('data_type'=>4,'field_id'=>'signup_date'), $form_signup_date);
echo "<script language='JavaScript'>Calendar.setup({inputField:'form_signup_date', ifFormat:'%Y-%m-%d', button:'img_signup_date'});</script>";

if ($form_enrollment_status == "") {
	$form_enrollment_status = "in_progress";
}
?></td></tr>
<tr><td class='text'><?php xl('Status','e'); ?>:</td><td><?php generate_form_field(array('data_type'=>1,'field_id'=>'enrollment_status','list_id'=>'enrollment_status','empty_title'=>'SKIP'), $form_enrollment_status); ?></td></tr>
</table><br><input type="submit" value="<?php echo htmlspecialchars(xl('Save enrollment'), ENT_QUOTES); ?>"  onClick="return validate()"> <input type="submit" value="<?php echo htmlspecialchars(xl('Cancel'), ENT_QUOTES); ?>" onClick="document.reminder.task.value=''"><br></form></center></div><?php
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
        $sortlink[$i] = "<a href=\"health_plans_patient.php?sortby=$sort[$i]&sortorder=asc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortdown.gif\" border=0 alt=\"".htmlspecialchars(xl('Sort Up'), ENT_QUOTES)."\"></a>";
    }
    for($i = 0; $i < count($sort); $i++) {
        if($sortby == $sort[$i]) {
            switch($sortorder) {
                case "asc"      : $sortlink[$i] = "<a href=\"health_plans_patient.php?sortby=$sortby&sortorder=desc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortup.gif\" border=0 alt=\"".htmlspecialchars(xl('Sort Up'), ENT_QUOTES)."\"></a>"; break;
                case "desc"     : $sortlink[$i] = "<a href=\"health_plans_patient.php?sortby=$sortby&sortorder=asc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortdown.gif\" border=0 alt=\"".htmlspecialchars(xl('Sort Down'), ENT_QUOTES)."\"></a>"; break;
            } break;
        }
    }
    // This is for managing page numbering and display beneaths the Health Plans table.
    $listnumber = 25;
    $sql = "select enroll_id, plan_name, signup_date, status from health_plan_enrollment, health_plans where health_plans.plan_id=health_plan_enrollment.plan_id and health_plan_enrollment.patient_id=?";
    $result = sqlStatement($sql, array($pid));
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
            <td width=\"\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\" class=bold>&nbsp;<b>".htmlspecialchars(xl('Plan'), ENT_QUOTES)."</b> $sortlink[0]</td>
	    <td width=\"25%\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\" class=bold>&nbsp;<b>".htmlspecialchars(xl('Signup Date'), ENT_QUOTES)."</b> $sortlink[1]</td>
            <td width=\"25%\" style=\"border-bottom: 1px #000000 solid; \" class=bold>&nbsp;<b>".htmlspecialchars(xl('Status'), ENT_QUOTES)."</b> $sortlink[2]</td>
        </tr>";
        // This is for displaying the Health Plans table body.
        $count = 0;
        $sql = "select enroll_id, plan_name, signup_date, status from health_plan_enrollment, health_plans where health_plans.plan_id=health_plan_enrollment.plan_id and health_plan_enrollment.patient_id=? order by $sortby $sortorder limit $begin, $listnumber";
        $result = sqlStatement($sql, array($pid));
        while ($myrow = sqlFetchArray($result)) {
            $count++;
            echo "
            <tr id=\"row$count\" style=\"background:white\" height=\"24\">
                <td align=\"center\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><input type=checkbox id=\"check$count\" name=\"delete_id[]\" value=\"".htmlspecialchars($myrow['enroll_id'], ENT_QUOTES)."\" onclick=\"if(this.checked==true){ selectRow('row$count'); }else{ deselectRow('row$count'); }\"></td>
                <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\"><a href=\"health_plans_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$begin&task=edit&enroll_id=".htmlspecialchars($myrow['enroll_id'], ENT_QUOTES)."\" onclick=\"top.restoreSession()\">".htmlspecialchars($myrow['plan_name'], ENT_QUOTES)."</a></td><td width=5></td></tr></table></td>
                <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\">".htmlspecialchars($myrow['signup_date'], ENT_QUOTES)."</td><td width=5></td></tr></table></td>
                <td style=\"border-bottom: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\">".htmlspecialchars(ucwords(str_replace("_", " ", $myrow['status'])), ENT_QUOTES)."</td><td width=5></td></tr></table></td>
            </tr>";
        }
    // This is for displaying the Health Plans table footer.
    echo "
    </form></table>
    <table border=0 cellpadding=5 cellspacing=0 width=90%>
        <tr>
            <td class=\"text\"><a href=\"health_plans_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$begin&task=addnew\" onclick=\"top.restoreSession()\">".htmlspecialchars(xl('Add New'), ENT_QUOTES)."</a> &nbsp; <a href=\"javascript:confirmDeleteSelected()\" onclick=\"top.restoreSession()\">".htmlspecialchars(xl('Delete'), ENT_QUOTES)."</a></td>
            <td align=right class=\"text\">$prevlink &nbsp; $end of $total &nbsp; $nextlink</td>
        </tr>
    </table></td></tr></table><br>"; ?>

<script language="javascript">
// This is to confirm the delete action.
function confirmDeleteSelected() {
    var check_delete
	for(i = 1; i <= <?php echo $count ?>; i++) {
		if (document.getElementById("check"+i).checked==true){
			check_delete = "Yes";
		}
	}
	if (check_delete=="Yes"){
		if(confirm("<?php echo htmlspecialchars(xl('Do you really want to delete the selection?'), ENT_QUOTES) ?>")){
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
</script><?php
}
?>

</body>
</html>
