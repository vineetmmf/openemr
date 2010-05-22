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
require_once("$srcdir/options.inc.php");
include_once("$srcdir/formdata.inc.php");
require_once("$srcdir/classes/Document.class.php");
require_once("$srcdir/gprelations.inc.php");

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
   	if (f.reminder_name.value.length == 0) {
   		alert('<?php xl('Please choose a value for Name!', 'e') ?>');
   		f.reminder_name.focus();
   		return false;
   	}
   	if (f.patient_id.value.length == 0) {
   		alert('<?php xl('Please choose a value for Patient!', 'e') ?>');
   		return false;
   	}
   	if (f.form_scheduled_date.value.length == 0) {
   		alert('<?php xl('Please choose a value for Scheduled Date!', 'e') ?>');
	    f.form_scheduled_date.focus();
   		return false;
  	}
  	top.restoreSession();
  	return true;
}
</script>

</head>

<body class="body_top">
<table><tr><td><span class="title"><?php xl('Patient Reminders','e'); ?></td></tr></table><br>

<?php

switch($task)
{
    case "add" : {
        // Add a new patient reminder for a specific patient.
        sqlQuery("insert into patient_reminders value (0, '".formData("reminder_name")."', '".formData("patient_id")."', '".formData("form_scheduled_date")."', '".formData("message")."', '', '', '', '', '".formData("plan_id")."', '', '', '".formData("form_voice_status")."', '".formData("form_email_status")."', '".formData("form_mail_status")."')");
    } break;
    case "edit" : {
        // Get the patient reminder details to display.
        $sql = "select reminder_name, reminder_content, action_id, patient_id, scheduled_date, voice_status, email_status, mail_status from patient_reminders where reminder_id='".formData("reminder_id", "G")."'";
        $result = sqlStatement($sql);
        if ($myrow = sqlFetchArray($result)) {
            $reminder_name = $myrow['reminder_name'];
            $message = $myrow['reminder_content'];
            $plan_id = $myrow['action_id'];
            $patient_id = $myrow['patient_id'];
            $form_scheduled_date = $myrow['scheduled_date'];
            $form_voice_status = $myrow['voice_status'];
            $form_email_status = $myrow['email_status'];
            $form_mail_status = $myrow['mail_status'];
        }
    } break;
    case "update" : {
        // Update the patient reminder record.
        sqlQuery("update patient_reminders set reminder_name='".formData("reminder_name")."',reminder_content='".formData("message")."', action_id='".formData("plan_id")."',patient_id='".formData("patient_id")."', scheduled_date='".formData("form_scheduled_date")."', voice_status='".formData("form_voice_status")."', email_status='".formData("form_email_status")."', mail_status='".formData("form_mail_status")."' where reminder_id='".formData("reminder_id")."'");
    } break;
    case "delete" : {
        // Delete selected patient reminder(s) from the editing table.
        $delete_id = $_POST['delete_id'];
        for($i = 0; $i < count($delete_id); $i++) {
            sqlQuery("delete from patient_reminders where reminder_id='$delete_id[$i]'");
        }
    } break;
}

if($task == "addnew" or $task == "edit") {
// Display the Patient Reminders page layout.
echo "<form name=reminder action=\"patient_reminders.php?sortby=$sortby&sortorder=$sortorder&begin=$begin\" method=post>";

if ($task == "addnew") {
    echo "<input type=hidden name=task value=add>";
}
else
{
    echo "<input type=hidden name=reminder_id value=$reminder_id><input type=hidden name=task value=update>";
}
?><div id="pnotes"><center>
<table border='0' cellspacing='8'>
<tr><td class='required' width="100"><b><?php xl('Name','e'); ?>:</b></td><td><input type=entry name='reminder_name' id='reminder_name' style="width:315px " value="<?php echo htmlspecialchars($reminder_name, ENT_QUOTES); ?>"></td></tr>
<tr><td class='required'><b><?php xl('Patient','e'); ?>:</b></td><td><?php
if ($patient_id) {
     $prow = sqlQuery("SELECT lname, fname " .
     "FROM patient_data WHERE pid = '" . $patient_id . "'");
     $patientname = $prow['lname'].", " . $prow['fname'];
}

if ($patientname == "") {
     $patientname = xl('Click to select');
} ?>
   <input type='text' size='10' name='form_patient' style='width:150px;cursor:pointer;cursor:hand' value='<?php echo htmlspecialchars($patientname, ENT_QUOTES); ?>' onclick='sel_patient()' title='<?php xl('Click to select patient','e'); ?>' readonly />
   <input type='hidden' name='patient_id' value='<?php echo $patient_id ?>' />
</td></tr>
<tr><td class='required'><b><?php xl('Scheduled Date','e'); ?>:</b></td><td><?php
generate_form_field(array('data_type'=>4,'field_id'=>'scheduled_date'), $form_scheduled_date);
echo "<script language='JavaScript'>Calendar.setup({inputField:'form_scheduled_date', ifFormat:'%Y-%m-%d', button:'img_scheduled_date'});</script>";
?>
</td></tr>
<tr><td class='text'><b><?php xl('Plan','e'); ?>:</b></td><td><select name='plan_id' style="width:200px ">
<?php
$pres = sqlStatement("SELECT plan_id, plan_name FROM  health_plans WHERE activation_status='activate' ORDER BY plan_name");

while ($prow = sqlFetchArray($pres)) {
  	echo "    <option value='" . $prow['plan_id'] . "'";
  	if ($prow['plan_id'] == $plan_id) echo " selected";
  	echo ">" . $prow['plan_name'];
  	echo "</option>\n";
}
?></select>
</td></tr>
<tr><td class='text'><b><?php xl('Voice Status','e'); ?>:</b></td><td><?php generate_form_field(array('data_type'=>1,'field_id'=>'voice_status','list_id'=>'reminder_status','empty_title'=>'SKIP'), $form_voice_status); ?></td></tr>
<tr><td class='text'><b><?php xl('Email Status','e'); ?>:</b></td><td><?php generate_form_field(array('data_type'=>1,'field_id'=>'email_status','list_id'=>'reminder_status','empty_title'=>'SKIP'), $form_email_status); ?></td></tr>
<tr><td class='text'><b><?php xl('Mail Status','e'); ?>:</b></td><td><?php generate_form_field(array('data_type'=>1,'field_id'=>'mail_status','list_id'=>'reminder_status','empty_title'=>'SKIP'), $form_mail_status); ?></td></tr>
<tr><td class='text'><b><?php xl('Message','e'); ?>:</b></td><td><textarea name='message' rows='8' cols='60'><?php echo $message; ?></textarea></td></tr>
</table><input type="submit" value="<?php xl('Save reminder','e'); ?>"  onClick="return validate()"> <?php

if ($task == "edit") { ?>
<input type="button" id="printreminder" value="<?php xl('Print reminder','e'); ?>"> <?php
} ?>
<input type="submit" value="<?php xl('Cancel','e'); ?>" onClick="document.reminder.task.value=''"><br></form><form name="export_reminders_form" action="export.php" target="_blank"></form></center></div>

<script language="javascript">
// This is for callback by the find-patient popup.
function setpatient(pid, lname, fname, dob) {
  	var f = document.forms[0];
  	f.form_patient.value = lname + ', ' + fname;
  	f.patient_id.value = pid;
 }

// This invokes the find-patient popup.
function sel_patient() {
  	dlgopen('../../main/calendar/find_patient_popup.php', '_blank', 500, 400);
 }

// jQuery stuff to make the page a little easier to use
$(document).ready(function(){
    $("#printreminder").click(function() { PrintReminder(); });
    var PrintReminder = function () {
        top.restoreSession();
        window.open('reminders_print.php?reminder_id=<?php echo $reminder_id; ?>', '_blank', 'resizable=1,scrollbars=1,width=600,height=500');
    }
});
</script><?php
}
else
{
    // This is for sorting the records.
    $sort = array("reminder_name", "fname, lname", "scheduled_date");
    if($sortby == "") {
        $sortby = $sort[0];
    }
    if($sortorder == "") { 
        $sortorder = "asc";
    }
    for($i = 0; $i < count($sort); $i++) {
        $sortlink[$i] = "<a href=\"patient_reminders.php?sortby=$sort[$i]&sortorder=asc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortdown.gif\" border=0 alt=\"".xl('Sort Up')."\"></a>";
    }
    for($i = 0; $i < count($sort); $i++) {
        if($sortby == $sort[$i]) {
            switch($sortorder) {
                case "asc"      : $sortlink[$i] = "<a href=\"patient_reminders.php?sortby=$sortby&sortorder=desc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortup.gif\" border=0 alt=\"".xl('Sort Up')."\"></a>"; break;
                case "desc"     : $sortlink[$i] = "<a href=\"patient_reminders.php?sortby=$sortby&sortorder=asc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortdown.gif\" border=0 alt=\"".xl('Sort Down')."\"></a>"; break;
            } break;
        }
    }
    // This is for managing page numbering and display beneath the Patient Reminders table.
    $listnumber = 25;
    $sql = "select reminder_id, fname, lname, reminder_name, scheduled_date from patient_reminders, patient_data where patient_data.pid=patient_reminders.patient_id and scheduled_date != '0000-00-00'";
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
        $prevlink = "<a href=\"patient_reminders.php?sortby=$sortby&sortorder=$sortorder&begin=$prev\" onclick=\"top.restoreSession()\"><<</a>";
    }
    else { 
        $prevlink = "<<";
    }
    
    if($next < $total) {
        $nextlink = "<a href=\"patient_reminders.php?sortby=$sortby&sortorder=$sortorder&begin=$next\" onclick=\"top.restoreSession()\">>></a>";
    }
    else {
        $nextlink = ">>";
    }
    // This is for displaying the Patient Reminders table header.
    echo "
    <table width=100%><tr><td><table border=0 cellpadding=1 cellspacing=0 width=90% style=\"border-left: 1px #000000 solid; border-right: 1px #000000 solid; border-top: 1px #000000 solid;\">
    <form name=wikiList action=\"patient_reminders.php?sortby=$sortby&sortorder=$sortorder&begin=$begin\" method=post>
    <input type=hidden name=task value=delete>
        <tr height=\"24\" style=\"background:lightgrey\">
            <td align=\"center\" width=\"25\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><input type=checkbox id=\"checkAll\" onclick=\"selectAll()\"></td>
            <td width=\"\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\" class=bold>&nbsp;<b>".xl('Name')."</b> $sortlink[0]</td>
            <td width=\"25%\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\" class=bold>&nbsp;<b>".xl('Patient')."</b> $sortlink[1]</td>
            <td width=\"20%\" style=\"border-bottom: 1px #000000 solid;\" class=bold>&nbsp;<b>".xl('Scheduled Date')."</b> $sortlink[2]</td>
        </tr>";
        // This is for displaying the Patient Reminders table body.
        $count = 0;
        $sql = "select reminder_id, fname, lname, reminder_name, scheduled_date from patient_reminders, patient_data where patient_data.pid=patient_reminders.patient_id and scheduled_date != '0000-00-00' order by $sortby $sortorder limit $begin, $listnumber";
        $result = sqlStatement($sql);
        while ($myrow = sqlFetchArray($result)) {
            $count++;
            echo "
            <tr id=\"row$count\" style=\"background:white\" height=\"24\">
                <td align=\"center\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><input type=checkbox id=\"check$count\" name=\"delete_id[]\" value=\"".$myrow['reminder_id']."\" onclick=\"if(this.checked==true){ selectRow('row$count'); }else{ deselectRow('row$count'); }\"></td>
                <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\"><a href=\"patient_reminders.php?sortby=$sortby&sortorder=$sortorder&begin=$begin&task=edit&reminder_id=".$myrow['reminder_id']."\" onclick=\"top.restoreSession()\">".$myrow['reminder_name']."</a></td><td width=5></td></tr></table></td>
                <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\">".$myrow['lname'].", ".$myrow['fname']."</td><td width=5></td></tr></table></td>
                <td style=\"border-bottom: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\">".$myrow['scheduled_date']."</td><td width=5></td></tr></table></td>
            </tr>";
        }
    // This is for displaying the Patient Reminders table footer.
    echo "
    </form></table>
    <table border=0 cellpadding=5 cellspacing=0 width=90%>
        <tr>
            <td class=\"text\"><a href=\"patient_reminders.php?sortby=$sortby&sortorder=$sortorder&begin=$begin&task=addnew\" onclick=\"top.restoreSession()\">".xl('Add New')."</a> &nbsp; <a href=\"javascript:confirmDeleteSelected()\" onclick=\"top.restoreSession()\">".xl('Delete')."</a> &nbsp; <a href=\"\" onclick=\"return EditSender()\">".xl('Edit Sender')."</a> &nbsp; <a href=\"\" onclick=\"return ReminderBatch()\">".xl('Run Batch')."</a> &nbsp; <a href=\"\" onclick=\"return PrintAll()\">".xl('Print All')."</a> &nbsp; <a href=\"\" onclick=\"return ExportData()\">".xl('Export Data')."</a></td>
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
// This is to allow selection of all items in Patient Reminders table for deletion.
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
// The two functions below are for changing row styles in Patient Reminders table.
function selectRow(row) {
    document.getElementById(row).style.background = "#E7E7E7";
}
function deselectRow(row) {
    document.getElementById(row).style.background = "#F7F7F7";
}
// Show a template popup of patient reminders batch sending tool.
function ReminderBatch() {
    top.restoreSession();
    dlgopen('../../batchcom/batch_reminders.php', '_blank', 600, 200);
    return false;
}
// Show a template popup of patient reminders sender details.
function EditSender() {
    top.restoreSession();
    dlgopen('sender.php', '_blank', 600, 200);
    return false;
}
// Show a template popup of patient reminders for printing.
function PrintAll() {
    top.restoreSession();
    dlgopen('print.php', '_blank', 600, 500);
    return false;
}
// Export patient reminders in Excel CSV format for mail merging use in Word or another program.
function ExportData() {
    top.restoreSession();
    window.location = 'export.php';
    return false;
}
</script>

<?php
}
?>

</body>
</html>
