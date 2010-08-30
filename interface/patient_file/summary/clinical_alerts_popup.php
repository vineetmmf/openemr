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
require_once("../../../custom/code_types.inc.php");
require_once("$srcdir/sql.inc");
require_once("$srcdir/options.inc.php");
require_once("$srcdir/formdata.inc.php");

?>
<html>
<head>

<?php html_header_show(); ?>
<title><?php echo htmlspecialchars(xl('Alerts'), ENT_QUOTES); ?></title>
<link rel="stylesheet" href='<?php echo $css_header ?>' type='text/css'>
<script type="text/javascript" src="../../../library/textformat.js"></script>
<script type="text/javascript" src="../../../library/js/jquery.js"></script>
<script language="javascript">
function submitclose() {
    var f = document.theform;
    f.task.value = 'close';
    // top.restoreSession();
    f.submit();
}
</script>

</head>
<body class="body_top">
<?php
$task = htmlspecialchars($_REQUEST['task'], ENT_QUOTES);
// if ($task == "close" or $task == "go") {
if ($task == "close") {
    $plan = $_POST['track'];
    $id = explode("::",$_POST['id']);
    $respond = 0;
    $track_education = $_POST['track_education'];

      // Track user's response to an alert.
      if (!empty($id)) {
        foreach ($id as $alert_id) {
              if (!empty($plan[$alert_id])) {
                   $respond++;
              }
              if ($track_education[$alert_id] !="") $respond++;
             $total_respond = sqlQuery("SELECT responded FROM clinical_alerts WHERE alert_id = ?", array($alert_id));
              sqlStatement("UPDATE clinical_alerts SET responded = '".($total_respond['responded'] + $respond)."' WHERE alert_id = ?", array($alert_id));
              $respond = 0;
        }
      }
      // Close the alert popup.
      echo "<script language='JavaScript'>\n";
      echo " window.close();\n";
      echo " if (opener.refreshme) opener.refreshme();\n";
      echo "</script></body></html>\n";
      exit();
}
?>


<form method='post' name='theform' action='clinical_alerts_popup.php'>
<input type="hidden" name="task" value="">
<center>
<table border='0' cellpadding='5' cellspacing='0'>
<?php

// Check to see if an alert exists.
if (!empty($pid) and $task == "") {
    $arr_alert_id = array();
    $sql = "SELECT clinical_alerts.plan_id AS plan_id, patient_alerts.alert_id AS alert_id FROM patient_alerts JOIN clinical_alerts ON patient_alerts.alert_id = clinical_alerts.alert_id WHERE patient_alerts.pid = ? AND patient_alerts.status != 'Done'";
     $result = sqlStatement($sql, array($pid));
     while ($rows = sqlFetchArray($result)) {
         if ($rows['plan_id'] == '') {
               if (@!in_array($rows['alert_id'],$arr_alert_id))
            $arr_alert_id[] = $rows['alert_id'];
          } else {
               // Check health plan enrollment.
               $enrollresult = sqlStatement("SELECT action_completed FROM health_plan_enrollment WHERE patient_id = ? AND plan_id = ?", array(formDataCore($pid), formDataCore($rows['plan_id'])));
            if ($enrollrow = sqlFetchArray($enrollresult)) { // If patient is enrolled in the plan.
                $reminder_sql = "SELECT scheduled_date FROM patient_reminders WHERE patient_id = ? AND plan_id = ?";
                $reminderresult = sqlStatement($reminder_sql, array(formDataCore($pid), formDataCore($rows['plan_id'])));
                while ($reminderrow = sqlFetchArray($reminderresult)) {
                    // Select action completion status based on enrollment ID.
                     $action_completed = explode(",", $enrollrow['action_completed']);
                     $now = date("Ymd");
                     $date = explode("-", $reminderrow['scheduled_date']);
                     $scheduled_date = $date[2].$date[1].$date[0];
                     // Check past due actions.
                     if (@!in_array($reminderrow['action_id']."-YES", $action_completed) and $now >= $scheduled_date) {
                          if (!in_array($rows['alert_id'],$arr_alert_id)){
                             $arr_alert_id[] = $rows['alert_id'];
                        }
                    }
                }
                  } else {
                if (@!in_array($rows['alert_id'],$arr_alert_id)){
                    $arr_alert_id[] = $rows['alert_id'];
                }
               }
          }
     }
}

if (!empty($pid) and !empty($arr_alert_id)) { // Check to see if clinical alerts exist.
    $all_id = "";
     $total_alerts = 1;
    foreach ($arr_alert_id as $alert_id) { // Show each patient alert.
    
        $cres = sqlQuery("SELECT COUNT(*) as count FROM clinical_alerts, health_plans WHERE clinical_alerts.alert_id=? and health_plans.plan_id=clinical_alerts.plan_id and health_plans.activation_status='activate'", array($alert_id));
        if ($cres['count']) {
        //$row = sqlQuery("SELECT * FROM patient_alerts WHERE pid = '$pid' AND alert_id = '$alert_id'");
          // set id. post after submit form
          if (!empty($all_id))
               $all_id .= "::" . $alert_id;
          else
               $all_id = $alert_id;
          $alertresult = sqlStatement("SELECT * FROM clinical_alerts WHERE alert_id = ?", array($alert_id));
          while ($alertrow = sqlFetchArray($alertresult)) { // get detail from clinical_alerts
               $alert_color = htmlspecialchars($alertrow['color'], ENT_QUOTES);
               $plan_id = htmlspecialchars($alertrow['plan_id'], ENT_QUOTES);
               if ($alertrow['past_due_message'] == "") {
                   $past_due_message = "No message has been set up for this alert. Please talk to your Administrator.";
               } else {
                $past_due_message = htmlspecialchars($alertrow['past_due_message'], ENT_QUOTES);
               }
               if ($alertrow['message'] == "") {
                $message = "No message has been set up for this alert. Please talk to your Administrator.";
               } else {
                $message = htmlspecialchars($alertrow['message'], ENT_QUOTES);
               }
               $total = 0;
               // Update the activated count for each alert.
               sqlStatement("UPDATE clinical_alerts SET activated = '".($alertrow['activated'] + 1)."' WHERE alert_id = ?", array($alert_id));
     ?>
     <tr>
      <td height="5">
       <br/>
      </td>
     </tr>
     <tr>
      <td class='text' align='left'><b><?php echo htmlspecialchars(xl('Alert'). " #".$total_alerts, ENT_QUOTES); ?>:</b>
      <td width=10></td>
      <td class='text'><?php echo "<font color=\"".$alert_color."\">".htmlspecialchars($alertrow['alert_name'], ENT_QUOTES)."</font>"; ?></td>
     </tr>
     <tr>
      <td class='text' valign="top"><b><?php echo htmlspecialchars(xl('Advice Message'), ENT_QUOTES); ?>:</b></td>
      <td width=10></td>
      <td class='text'>
      <?php
            // Check to see if a patient is enrolled in the health plan.
               $check = sqlQuery("SELECT COUNT(*) AS count FROM health_plan_enrollment WHERE patient_id = ? and plan_id = ?", array($pid, $plan_id));
               if ($check['count'] > 0 and $plan_id != "") {
                echo "<font color=\"".$alert_color."\">".$past_due_message."</font>";
              } else {
              echo "<font color=\"".$alert_color."\">".$message."</font>";
            }
      ?>
      </td>
     </tr>
     <tr>
      <td class='text' valign="top" align='left'><b><?php echo htmlspecialchars(xl('Plan'), ENT_QUOTES); ?>:</b></td>
      <td width=10></td>
      <td class='text'>
      <?php
              if (!empty($plan_id)) { // Check to see if the health plan exists.
                $sql = "SELECT plan_name FROM health_plans WHERE plan_id = ?";
                $presult = sqlQuery($sql, array($alertrow['plan_id']));
                $plan_name = $presult['plan_name'];
                if (empty($check['count']) and $check['count'] <= 0) { //  check enroll part. if not enrolled
      ?>
                     <input type='checkbox' name="track[<?php echo $alert_id?>]" value="<?php echo $plan_id; ?>" id="track_<?php echo $alert_id ?>"/><font color="<?php echo $alert_color; ?>"> <?php echo htmlspecialchars(xl('Discussed')." ".$plan_name." ".xl('Health Plan'), ENT_QUOTES);?></font><br />
        <?php
                } else { //if enrolled
        ?>
                     <input type='checkbox' name="track[<?php echo $alert_id?>]" value="<?php echo $plan_id; ?>" id="track_<?php echo $alert_id ?>"/><font color="<?php echo $alert_color; ?>"> <?php echo htmlspecialchars(xl('Reviewed the status of')." ".$plan_name." ".xl('Health Plan'), ENT_QUOTES);?></font><br />
        <?php
                }
               } else { // end if plan exist
                echo htmlspecialchars(xl('No Plan'), ENT_QUOTES)."<br/>";
               } // end if plan no exist
        ?>
      </td>
     </tr>
     <tr>
      <td class='text' valign="top" align='left'><b><?php echo htmlspecialchars(xl('Other'), ENT_QUOTES); ?>:</b></td>
      <td width=10></td>
      <td class='text'>
       <input type='checkbox' name="track_education[<?php echo $alert_id;?>]" id='track_education_<?php echo $alert_id;?>' value="<?php echo $alert_id;?>"/><font color="<?php echo $alert_color; ?>"> <?php echo htmlspecialchars(xl('Provided Patient Education'), ENT_QUOTES); ?></font>
      </td>
     </tr>
     <?php
       $total_alerts++;
          } // end get detail from clinical_alerts
          }
      // post the id when submit form
      echo "<input type=\"hidden\" name=\"id\" value=\"".htmlspecialchars($all_id, ENT_QUOTES)."\">";
    } // end each patient alerts
     ?>
     <tr>
      <td class='text' align='center' colspan="3"><br>
        <input type="button" value="<?php echo htmlspecialchars(xl('Save'), ENT_QUOTES); ?>" onClick="submitclose()">&nbsp;&nbsp;
        <input type="button" value="<?php echo htmlspecialchars(xl('Cancel'), ENT_QUOTES); ?>" onClick="window.close()">
      </td>
     </tr>
      <?php
} else { // end if patient alerts exist. if patient alerts not exist, close this popup
  echo "<script language='JavaScript'>\n";
  echo " window.close();\n";
  echo "</script></body></html>\n";
  exit();
} // end if alerts do not exist
?>
</table>
</center>
</form>

</body>
</html>
