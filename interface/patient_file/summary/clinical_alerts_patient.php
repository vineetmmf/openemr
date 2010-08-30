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
require_once("$srcdir/patient.inc");
require_once("$srcdir/acl.inc");
require_once("$srcdir/log.inc");
require_once("$srcdir/options.inc.php");
require_once("$srcdir/classes/Document.class.php");
require_once("$srcdir/gprelations.inc.php");
require_once("$srcdir/sql.inc");
require_once("clinical_alerts_functions.php");

$task = htmlspecialchars($_REQUEST['task'], ENT_QUOTES);
$sortby = htmlspecialchars($_REQUEST['sortby'], ENT_QUOTES);
$sortorder = htmlspecialchars($_REQUEST['sortorder'], ENT_QUOTES);
$begin = htmlspecialchars($_REQUEST['begin'], ENT_QUOTES);

// Check and insert clinical alerts for a patient.
if ($pid && $GLOBALS['clinical_decision_rules_and_patient_reminders']) {
	insert_alert($pid);
}
?>

<html>
<head>
<?php html_header_show();?>
<link rel="stylesheet" href="<?php echo $css_header;?>" type="text/css">
<script type="text/javascript" src="../../../library/dialog.js"></script>
<script type="text/javascript" src="../../../library/textformat.js"></script>
<script type="text/javascript" src="<?php echo $GLOBALS['webroot']; ?>/library/js/jquery.js"></script>

<script LANGUAGE="JavaScript">
// Check to see that mandatory fields are filled in.
function validate() {
    var f = document.forms[0];
    if (f.alert_name.value.length == 0) {
        alert('<?php echo htmlspecialchars(xl('Please choose a value for Name!'), ENT_QUOTES) ?>');
   	    f.alert_name.focus();
   	    return false;
    }
  	    top.restoreSession();
    return true;
}

// Cancel form.
function submitCancel() {
	var f = document.forms['alert'];
 	f.task.value = '';
 	top.restoreSession();
	f.submit();
}

</script>
</head>

<body class="body_top">
<table><tr><td><span class="title"><?php echo htmlspecialchars(xl('Clinical Alerts'), ENT_QUOTES); ?></span></td></tr></table><br>
<?php

switch($task) {
	case "edit" : {
	    $id = formData('id', 'R');
	    // Edit an alert.
	    $row = sqlQuery("SELECT * FROM patient_alerts WHERE id = ? and pid = ?", array($id, $pid));
	    $alert_status = htmlspecialchars($row['status'], ENT_QUOTES);
	    $date_modified = htmlspecialchars($row['date_modified'], ENT_QUOTES);
	    $prow = sqlQuery("SELECT lname, fname, sex, DATE_FORMAT(DOB,'%Y-%m-%d') as DOB_YMD FROM patient_data WHERE pid = ?", array($pid));
	    $patient_name = htmlspecialchars($prow['lname'] . ", " . $prow['fname'], ENT_QUOTES);
	    $patient_DOB = htmlspecialchars($prow['DOB_YMD'], ENT_QUOTES);
	    $gender = htmlspecialchars($prow['sex'], ENT_QUOTES);
	    $alertrow = sqlQuery("SELECT * FROM clinical_alerts WHERE alert_id = ?", array($row['alert_id']));
	    $alert_name = htmlspecialchars($alertrow['alert_name'], ENT_QUOTES);
	    $plan_id = htmlspecialchars($alertrow['plan_id'], ENT_QUOTES);
	    $plan = sqlQuery("SELECT plan_name FROM health_plans WHERE plan_id = ?", array(formDataCore($plan_id)));
	    $plan_name = htmlspecialchars($plan['plan_name'], ENT_QUOTES);
	    $alert_color = htmlspecialchars($alertrow['color'], ENT_QUOTES);
	    $activated = htmlspecialchars($alertrow['activated'], ENT_QUOTES);
	    $responded = htmlspecialchars($alertrow['responded'], ENT_QUOTES);
	    $checkmsg = sqlQuery("SELECT COUNT(*) AS count FROM health_plan_enrollment WHERE patient_id = ? and plan_id = ?", array($pid, $plan_id));
	    if (empty($checkmsg['count']) and $checkmsg['count'] <= 0) {
	    	$message = htmlspecialchars($alertrow['message'], ENT_QUOTES);
	    } else {
	    	$message = htmlspecialchars($alertrow['past_due_message'], ENT_QUOTES);
	    }
	} break;

	case "update" : {
	    // Strip slashes.
	    $id = formData('id', 'R');
	    $plan = formData("track_plan");
	    $track_education = formData('track_education');
	    // update patiend alert status
	    sqlStatement("UPDATE patient_alerts SET status = '" . formData("form_alert_status") . "', date_modified = '".date("Y-m-d")."' WHERE id = ?", array($id));
	    $respond = 0;

	    // Track user's response to an alert.
	    if (!empty($id)) {
	    	if ($track_plan !="") $respond++;
	      	if ($track_education !="") $respond++;
	      	$row = sqlQuery("SELECT alert_id FROM patient_alerts WHERE id = ? and pid = ?", array($id, $pid));
	      	$alert_id = $row['alert_id'];
	      	$total_respond = sqlQuery("SELECT responded FROM clinical_alerts WHERE alert_id = ?", array($alert_id));
	      	sqlStatement("UPDATE clinical_alerts SET responded = '".($total_respond['responded'] + $respond)."' WHERE alert_id = ?", array($alert_id));
	      	$respond = 0;
	    }
	} break;

	case "delete" : {
	    // Delete selected clinical alerts.
	    $delete_id = $_POST['delete_id'];
	    for($i = 0; $i < count($delete_id); $i++) {
	    	sqlStatement("delete from patient_alerts where id=?", array(formDataCore($delete_id[$i])));
	    }
	} break;
}

if($task == "edit") { // Edit the alert form fields.
// Add/edit the alert layout.
	echo "<form name=alert action=\"clinical_alerts_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$begin\" method=post onsubmit='return validate()'>";
	if ($task == "edit") {
    	echo "<input type=hidden name=id value=$id><input type=hidden name=task value=update>";
    	$button_name = xl('Update alert');
 	}
	?><div><center>
	<table border='0' cellpadding=1 cellspacing=1>
	 <tr>
	  <td class='text' align='left'><b><?php echo htmlspecialchars(xl('Alert Name'), ENT_QUOTES); ?>:</b>
	  <td width=10></td>
	  <td class='text'><input type="text" style="width:315px;" value="<?php echo htmlspecialchars($alert_name, ENT_QUOTES); ?>" disabled ></td>
	 </tr>
	 <tr>
	  <td class='text' align='left'><b><?php echo htmlspecialchars(xl('Patient'), ENT_QUOTES); ?>:</b>
	  <td width=10></td>
	  <td class='text'><input type="text" value="<?php echo htmlspecialchars($patient_name, ENT_QUOTES); ?>" disabled ></td>
	 </tr>
	 <tr>
	  <td class='text' align='left'><b><?php echo htmlspecialchars(xl('Gender'), ENT_QUOTES); ?>:</b></td>
	  <td width=10></td>
	  <td class='text'><input type="text" value="<?php echo htmlspecialchars($gender, ENT_QUOTES); ?>" disabled ></td>
	 </tr>
	 <tr>
	   <td class='text' align='left'><b><?php echo htmlspecialchars(xl('Patient DOB'), ENT_QUOTES); ?>:</b></td>
	   <td width=10></td>
	   <td class='text'><input type="text" value="<?php echo htmlspecialchars($patient_DOB, ENT_QUOTES); ?>" disabled ></td>
	 </tr>
	 </tr>
	 <tr>
	  <td class='text' valign="top"><b><?php echo htmlspecialchars(xl('Advice Message'), ENT_QUOTES); ?>:</b></td>
	  <td width=10></td>
	  <td class='text'>
	  <?php
	  if (!empty($message)) {
	      $message = nl2br($message);
	      echo "<div class='text' style='background-color:white; color: gray; border:1px solid #999; padding: 5px; width: 640px;'><font color=\"$alert_color\">".$message."</font></div>";
	  } else {
	      echo "<div class='text' style='background-color:white; color: $alert_color; border:1px solid #999; padding: 5px; width: 640px;'>No message has been set up for this alert. Please talk to your Administrator.</div>";
	  }
	  ?>
	  </td>
	 </tr>
	 <tr>
	  <td class='text' valign="top" align='left'><b><?php echo htmlspecialchars(xl('Plan'), ENT_QUOTES); ?>:</b></td>
	  <td width=10></td>
	  <td class='text'>
	  <?php
	  if (!empty($plan_id)) {
	  	 $sql = "SELECT plan_name FROM health_plans WHERE plan_id = ?";
	  	 $presult = sqlQuery($sql, array($plan_id));
	     $plan_name = $presult['plan_name'];
	     // show the plan if patient no enrolled
	     $check = sqlQuery("SELECT COUNT(*) AS count FROM health_plan_enrollment WHERE patient_id = ? and plan_id = ?", array($pid, $plan_id));
	     if (empty($check['count']) and $check['count'] <= 0) {
	     ?>
	        <input type='checkbox' name="track_plan" value="<?php echo $plan_id; ?>" id="track_plan"/><font color="<?php echo $alert_color; ?>"><?php echo htmlspecialchars(xl('Offered')." ".$plan_name." ".xl('Health Plan', ENT_QUOTES));?>
	        </font><br />
	      <?php
	     } else {
	      ?>
	        <input type='checkbox' name="track_plan" value="<?php echo $plan_id; ?>" id="track_plan"/><font color="<?php echo $alert_color; ?>"><?php echo htmlspecialchars(xl('Check the status of the')." ".$plan_name." ".xl('Health Plan'), ENT_QUOTES);?>
	        </font><br />
	      <?php
	     }
	  } else {
	      echo htmlspecialchars(xl('No Plan'), ENT_QUOTES)."<br/>";
	  }
	  ?>
	    <input type='checkbox' name='track_education' id='track_education' value="Offered Patient Education"/><font color="<?php echo $alert_color; ?>"><?php echo htmlspecialchars(xl('Offered Patient Education'), ENT_QUOTES)?></font>
	  </td>
	 </tr>
	 <tr>
	  <td class='text' valign="top" align='left'><b><?php echo htmlspecialchars(xl('Status'), ENT_QUOTES); ?>:</b></td>
	  <td width=10></td>
	  <td class='text'>
	  <?php
	  if ($alert_status == ""){
	       $alert_status = "New";
	  }
	  generate_form_field(array('data_type'=>1,'field_id'=>'alert_status','list_id'=>'alert_status','empty_title'=>'SKIP','order_by'=>'title'), $alert_status); ?>
	  </td>
	 </tr>
	 <tr>
	  <td class='text' valign="top" align='left'><b><?php echo htmlspecialchars(xl('Date Modified'), ENT_QUOTES); ?>:</b></td>
	  <td width=10></td>
	  <td class='text'><input type="text" size="10" name="date_modified" value="<?php echo $date_modified ?>" disabled="disabled"></td>
	 </tr>
	</table>
	<input type="submit" value="<?php echo htmlspecialchars($button_name, ENT_QUOTES); ?>">&nbsp;&nbsp;<input type="button" value="<?php echo htmlspecialchars(xl('Cancel'), ENT_QUOTES); ?>" onClick="submitCancel()">
	<br>
	</form>
	</center>
	</div><?php
	} else { // End alerts form and start add/edit table.
	  // Managing column sorting in the editing table.
		$sort = array("clinical_alerts.alert_name", "patient_alerts.status");
	  	if($sortby == "") {
	    	$sortby = $sort[0];
	  	}
	  	if($sortorder == "") {
	    	$sortorder = "asc";
	  	}
	  	for($i = 0; $i < count($sort); $i++) {
	    	$sortlink[$i] = "<a href=\"clinical_alerts_patient.php?sortby=$sort[$i]&sortorder=asc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortdown.gif\" border=0 alt=\"".htmlspecialchars(xl('Sort Up'), ENT_QUOTES)."\"></a>";
	  	}
	  	for($i = 0; $i < count($sort); $i++) {
	    	if($sortby == $sort[$i]) {
	      	switch($sortorder) {
	        	case "asc"    : $sortlink[$i] = "<a href=\"clinical_alerts_patient.php?sortby=$sortby&sortorder=desc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortup.gif\" border=0 alt=\"".htmlspecialchars(xl('Sort Up'), ENT_QUOTES)."\"></a>"; break;
	        	case "desc"   : $sortlink[$i] = "<a href=\"clinical_alerts_patient.php?sortby=$sortby&sortorder=asc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortdown.gif\" border=0 alt=\"".htmlspecialchars(xl('Sort Down'), ENT_QUOTES)."\"></a>"; break;
	      	} break;
	    }
	}
	// Manage page numbering in the editing table.
	$listnumber = 25;
	$sql = "select COUNT(*) AS count from patient_alerts WHERE pid = ?";
	$total_row = sqlQuery($sql, array($pid));
	if($total_row['count']) {
	  $total = $total_row['count'];
	} else {
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
	  $prevlink = "<a href=\"clinical_alerts_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$prev\" onclick=\"top.restoreSession()\"><<</a>";
	} else {
	  $prevlink = "<<";
	}

	if($next < $total) {
	  $nextlink = "<a href=\"clinical_alerts_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$next\" onclick=\"top.restoreSession()\">>></a>";
	} else {
	  $nextlink = ">>";
	}
	// Edit the table header.
	echo "
	<table width=100%><tr><td><table border=0 cellpadding=1 cellspacing=0 width=90%  style=\"border-left: 1px #000000 solid; border-right: 1px #000000 solid; border-top: 1px #000000 solid;\">
	<form name=wikiList action=\"clinical_alerts_patient.php?sortby=$sortby&sortorder=$sortorder&begin=$begin\" method=post>
	<input type=hidden name=task value=delete>
	  <tr height=\"24\" style=\"background:lightgrey\">
	    <td align=\"center\" width=\"25\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><input type=checkbox id=\"checkAll\" onclick=\"selectAll()\"></td>
	    <td width=\"\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\" class=bold>&nbsp;<b>".htmlspecialchars(xl('Alerts Name'), ENT_QUOTES)."</b> $sortlink[0]</td>
	    <td width=\"20%\" style=\"border-bottom: 1px #000000 solid;\" class=bold>&nbsp;<b>".htmlspecialchars(xl('Status'), ENT_QUOTES)."</b> $sortlink[1]</td>
	  </tr>";
	  // Edit the table body.
	  $count = 0;
	  $sql = "select patient_alerts.id, patient_alerts.alert_id, clinical_alerts.alert_name, patient_alerts.status, clinical_alerts.color from patient_alerts,clinical_alerts WHERE patient_alerts.alert_id = clinical_alerts.alert_id AND patient_alerts.pid = ? order by $sortby $sortorder limit $begin, $listnumber";
	  $result = sqlStatement($sql, array($pid));
	  while ($myrow = sqlFetchArray($result)) {
	      $count++;
	      echo "
	      <tr id=\"row$count\" style=\"background:white\" height=\"24\">
	         <td align=\"center\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><input type=checkbox id=\"check$count\" name=\"delete_id[]\" value=\"".htmlspecialchars($myrow['id'], ENT_QUOTES)."\" onclick=\"if(this.checked==true){ selectRow('row$count'); }else{ deselectRow('row$count'); }\"></td>
	         <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\"><a href=\"clinical_alerts_patient.php?showall=$showall&sortby=$sortby&sortorder=$sortorder&begin=$begin&task=edit&id=".htmlspecialchars($myrow['id'], ENT_QUOTES)."\" onclick=\"top.restoreSession()\">".htmlspecialchars($myrow['alert_name'], ENT_QUOTES)."</a></td><td width=5></td></tr></table></td>
	         <td style=\"border-bottom: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\">".htmlspecialchars($myrow['status'], ENT_QUOTES)."</td><td width=5></td></tr></table></td>
	      </tr>";
	  }
	// Edit the table footer.
	echo "
	</form></table>
	<table border=0 cellpadding=5 cellspacing=0 width=90%>
	  <tr>
	    <td class=\"text\"><a href=\"javascript:confirmDeleteSelected()\" onclick=\"top.restoreSession()\">".htmlspecialchars(xl('Delete'), ENT_QUOTES)."</a></td>
	    <td align=right class=\"text\">$prevlink &nbsp; $end of $total &nbsp; $nextlink</td>
	  </tr>
	</table></td></tr></table><br>"; ?>

	<script language="javascript">
	// Confirm the deletion of a selected item.
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

	// Select all items.
	function selectAll() {
		if(document.getElementById("checkAll").checked==true) {
	    	document.getElementById("checkAll").checked=true;<?php
	    	for($i = 1; $i <= $count; $i++) {
	      		echo "document.getElementById(\"check$i\").checked=true; document.getElementById(\"row$i\").style.background='#E7E7E7';  ";
	    	} ?>
	  	} else {
	    	document.getElementById("checkAll").checked=false;<?php
	    	for($i = 1; $i <= $count; $i++) {
	      	echo "document.getElementById(\"check$i\").checked=false; document.getElementById(\"row$i\").style.background='#F7F7F7';  ";
	    } ?>
	}

}

// Change the row style in the table.
function selectRow(row) {
	document.getElementById(row).style.background = "#E7E7E7";
}
function deselectRow(row) {
	document.getElementById(row).style.background = "#F7F7F7";
}

</script><?php
} //End add/edit table.
?>

<script language="javascript">
<?php
if ($alertmsg) {
	echo "alert('" . htmlspecialchars($alertmsg, ENT_QUOTES) . "');\n";
}
?>
</script>

</body>
</html>
