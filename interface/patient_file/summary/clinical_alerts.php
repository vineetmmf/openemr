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
require_once("$srcdir/classes/Document.class.php");
require_once("$srcdir/gprelations.inc.php");
require_once("$srcdir/sql.inc");

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
  		alert('<?php xl('Please choose a value for Name!', 'e') ?>');
  		f.alert_name.focus();
  		return false;
 	}
	if (f.plan_id.selectedIndex <= 0) {
  		alert('<?php xl('Please choose a value for Plan','e')?>');
  		if (f.plan_id.focus) f.plan_id.focus();
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

// Confirm the deletion of a selected item.
function confirmDeletefile() {
	if(confirm("<?php xl('Do you really want to delete this file?', 'e') ?>")) {
    	top.restoreSession();
    	return true;
  	}
  	return false;
}

// Generate alert messages based on pre-set conditions.
function set_message(task) {

	var f = document.forms['alert'];
	var plan_id = f.plan_id;
	var message = f.message;
	var past_due_message = f.past_due_message;

	if (task == "addnew" || past_due_message.value.length == 0 || message.value.length == 0) {
		$.ajax({
			type: "POST",
   			url: "clinical_alerts_add_message.php",
   			data: "plan_id="+ plan_id.value,
   			success: function(data){
    			if (data.length) {
     				var arrmsg = data.split('::');
     				if (task == "addnew" || message.value.length == 0)
      					message.value = arrmsg[0];
     				if (task == "addnew" || past_due_message.value.length == 0)
      					past_due_message.value = arrmsg[1];
    			}
   			}
  		});
 	}
 	return false;
}

</script>
</head>

<body class="body_top">
<table><tr><td><span class="title"><?php xl('Clinical Alerts','e'); ?></span></td></tr></table><br>
<?php

switch($task) {
	case "edit" : {
    	$alert_id = formData('alert_id', 'R');
    	// Edit alert.
    	$sql = "select * from clinical_alerts where alert_id = '".$alert_id."'";
    	$result = sqlStatement($sql);
    	if ($myrow = sqlFetchArray($result)) {
      		$alert_name = $myrow['alert_name'];
      		$plan_id = $myrow['plan_id'];
      		$plan = sqlQuery("SELECT plan_name FROM health_plans WHERE plan_id = '" . formDataCore($plan_id) . "'");
      		$plan_name = $plan['plan_name'];
      		$alert_color = $myrow['color'];
      		$activated = $myrow['activated'];
      		$responded = $myrow['responded'];
      		$message = $myrow['message'];
      		$past_due_message = $myrow['past_due_message'];
    	}
  	} break;

  	case "add" :

    case "update" : {
    	// Strip slashes.
    	$alert_id = formData('alert_id', 'R');
    	if ($task == "add") {
      		$crow = sqlQuery("SELECT COUNT(*) AS count FROM clinical_alerts WHERE plan_id = '" . formData("plan_id") . "' AND alert_name = '". formData("alert_name") ."'");
    	} else {
      		$crow = sqlQuery("SELECT COUNT(*) AS count FROM clinical_alerts WHERE plan_id = '" . formData("plan_id") . "' AND alert_name = '" . formData("alert_name") . "' AND alert_id != '".$alert_id."'");
    	}
	    if ($crow['count']) {
	      	$alertmsg = xl('Cannot add/update this entry because a duplicate already exists!');
	      	$task == "add" ? $task = "addnew": $task = "edit";
	    } else {
	      	$sql =
	        "alert_name = '" . formData("alert_name") . "', " .
	        "color ='" . formData("form_alert_color") . "', " .
	        "plan_id ='" . formData("plan_id") . "', " .
	        "message ='" . formData("message") . "'," .
	        "past_due_message ='" . formData("past_due_message") . "'";
	      	// Update existing alert or add a new one.
	      	if ($task == "add") {
	        	sqlStatement("INSERT INTO clinical_alerts SET $sql");
	      	} else {
	        	sqlStatement("UPDATE clinical_alerts SET $sql WHERE alert_id = '$alert_id'");
	      	}
	    }
  	} break;

  	case "delete" : {
    	// Delete selected alert(s).
	    for($i = 0; $i < count($delete_id); $i++) {
	      $checkdel = sqlQuery("SELECT COUNT(*) AS count FROM patient_alerts WHERE alert_id = '". formDataCore($delete_id[$i]) ."'");      // check if any patients under this alerts
	      if ($checkdel['count']) {
	        $alertmsg = xl("Cannot delete this entry because it\'s being used!");
	      } else {
	        sqlStatement("delete from clinical_alerts where alert_id='$delete_id[$i]'");
	      }
	    }
  	} break;
}

if($task == "addnew" or $task == "edit") { // Start the alerts form.
	// Add/edit alert layout.
	echo "<form name=alert action=\"clinical_alerts.php?sortby=$sortby&sortorder=$sortorder&begin=$begin\" method=post onsubmit='return validate()'>";
  	if ($task == "addnew") {
    	echo "<input type=hidden name=task value=add>";
    	$button_name = xl('Save alert');
  	} else {
    	echo "<input type=hidden name=alert_id value=$alert_id><input type=hidden name=task value=update>";
    	$button_name = xl('Update alert');
  	}
	?><div id="pnotes"><center>
	<table border='0' cellpadding=1 cellspacing=1>
	 <tr>
	  <td class='required' align='left'><b><?php xl('Name','e'); ?>:</b>
	  <td width=10></td>
	  <td class='text'><input type=entry name='alert_name' id='alert_name' style="width:315px " value="<?php echo htmlspecialchars($alert_name, ENT_QUOTES); ?>"></td>
	 </tr>
	 <tr>
	  <td class='required' valign="top" align='left'><b><?php xl('Plan','e'); ?>:</b></td>
	  <td width=10></td>
	  <td class='text'>
	  <select name="plan_id" onChange="set_message('<?php echo $task;?>')">
	   <option value=""></option>
	  <?php
	  $sql = "SELECT plan_name, plan_id FROM health_plans WHERE activation_status = 'activate'";
	  $presult = sqlStatement($sql);
	  while ($prows = sqlFetchArray($presult)) {
	  	?>
	  	<option value="<?php echo $prows['plan_id']?>" <?php if ($prows['plan_id'] == $plan_id) echo "selected"; ?>><?php echo htmlspecialchars($prows['plan_name'], ENT_QUOTES)?></option>
	    <?php
	  }
	  ?>
	  </select>
	  </td>
	 </tr>
	 <tr>
	  <td class='text' align='left'><b><?php xl('Color','e'); ?>:</b></td>
	  <td width=10></td>
	  <td class='text'> <?php generate_form_field(array('data_type'=>1,'field_id'=>'alert_color','list_id'=>'alert_color','empty_title'=>'SKIP'), $alert_color); ?></td>
	 </tr>
	 <tr>
	  <td class='text' valign="top"><b><?php xl('Advice Message','e'); ?>:</b></td>
	  <td width=10></td>
	  <td class='text'>
	  <textarea name='message' rows='8' cols='80'><?php echo $message; ?></textarea></td>
	 </tr>
	 <tr>
	  <td class='text' valign="top"><b><?php xl('Past Due Message','e'); ?>:</b></td>
	  <td width=10></td>
	  <td class='text'>
	  <textarea name='past_due_message' rows='8' cols='80'><?php echo $past_due_message; ?></textarea>
	  </td>
	 </tr>
	 <tr>
	  <td class='text' valign="top" align='left'><b><?php xl('Activated','e'); ?>:</b></td>
	  <td width=10></td>
	  <td class='text'>
	  <input type="text" size="4" name="activated" value="<?php echo $activated ?>" disabled="disabled">
	  </td>
	 </tr>
	 <tr>
	  <td class='text' valign="top" align='left'><b><?php xl('Responded','e'); ?>:</b></td>
	  <td width=10></td>
	  <td class='text'>
	  <input type="text" size="4" name="responded" value="<?php echo $responded ?>" disabled="disabled">
	  </td>
	 </tr>
	</table>
	<input type="submit" value="<?php echo $button_name; ?>">&nbsp;&nbsp;<input type="button" value="<?php xl('Cancel','e'); ?>" onClick="submitCancel()">
	<br>
	</form>
	</center>
	</div><?php
	} else { // End alerts form and start add/edit table.
	  // Record sorting.
	  $sort = array("alert_name", "activated", "responded", "color");
	  if($sortby == "") {
	      $sortby = $sort[0];
	  }
	      if($sortorder == "") {
	      $sortorder = "asc";
	  }
	  for($i = 0; $i < count($sort); $i++) {
	      $sortlink[$i] = "<a href=\"clinical_alerts.php?sortby=$sort[$i]&sortorder=asc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortdown.gif\" border=0 alt=\"".xl('Sort Up')."\"></a>";
	  }
	  for($i = 0; $i < count($sort); $i++) {
	      if($sortby == $sort[$i]) {
	         switch($sortorder) {
	            case "asc"    : $sortlink[$i] = "<a href=\"clinical_alerts.php?sortby=$sortby&sortorder=desc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortup.gif\" border=0 alt=\"".xl('Sort Up')."\"></a>"; break;
	            case "desc"   : $sortlink[$i] = "<a href=\"clinical_alerts.php?sortby=$sortby&sortorder=asc\" onclick=\"top.restoreSession()\"><img src=\"../../../images/sortdown.gif\" border=0 alt=\"".xl('Sort Down')."\"></a>"; break;
	         } break;
	      }
	  }
	  // Record paging.
	  $listnumber = 25;
	  $sql = "select COUNT(*) AS count from clinical_alerts";
	  $total_row = sqlQuery($sql);
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
	      $prevlink = "<a href=\"clinical_alerts.php?sortby=$sortby&sortorder=$sortorder&begin=$prev\" onclick=\"top.restoreSession()\"><<</a>";
	  } else {
	      $prevlink = "<<";
	  }

	  if($next < $total) {
	      $nextlink = "<a href=\"clinical_alerts.php?sortby=$sortby&sortorder=$sortorder&begin=$next\" onclick=\"top.restoreSession()\">>></a>";
	  } else {
	      $nextlink = ">>";
	  }
	  // Display the editing table header.
	  echo "
	  <table width=100%><tr><td><table border=0 cellpadding=1 cellspacing=0 width=90%  style=\"border-left: 1px #000000 solid; border-right: 1px #000000 solid; border-top: 1px #000000 solid;\">
	  <form name=wikiList action=\"clinical_alerts.php?sortby=$sortby&sortorder=$sortorder&begin=$begin\" method=post>
	  <input type=hidden name=task value=delete>
	    <tr height=\"24\" style=\"background:lightgrey\">
	      <td align=\"center\" width=\"25\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><input type=checkbox id=\"checkAll\" onclick=\"selectAll()\"></td>
	      <td width=\"\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\" class=bold>&nbsp;<b>".xl('Name')."</b> $sortlink[0]</td>
	      <td width=\"120px\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\" class=bold>&nbsp;<b>".xl('Activated')."</b> $sortlink[1]</td>
	      <td width=\"140px\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\" class=bold>&nbsp;<b>".xl('Responded')."</b> $sortlink[2]</td>
	      <td width=\"80px\" style=\"border-bottom: 1px #000000 solid;\" class=bold>&nbsp;<b>".xl('Color')."</b> $sortlink[3]</td>
	    </tr>";
	    // Display the editing table body.
	    $count = 0;
	    $sql = "select alert_id, alert_name, activated, responded, color from clinical_alerts order by $sortby $sortorder limit $begin, $listnumber";
	    $result = sqlStatement($sql);
	    while ($myrow = sqlFetchArray($result)) {
	       $count++;
	       echo "
	       <tr id=\"row$count\" style=\"background:white\" height=\"24\">
	         <td align=\"center\" style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><input type=checkbox id=\"check$count\" name=\"delete_id[]\" value=\"".$myrow['alert_id']."\" onclick=\"if(this.checked==true){ selectRow('row$count'); }else{ deselectRow('row$count'); }\"></td>
	         <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\"><a href=\"clinical_alerts.php?showall=$showall&sortby=$sortby&sortorder=$sortorder&begin=$begin&task=edit&alert_id=".$myrow['alert_id']."\" onclick=\"top.restoreSession()\">".$myrow['alert_name']."</a></td><td width=5></td></tr></table></td>
	         <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\">".$myrow['activated']."</td><td width=5></td></tr></table></td>
	         <td style=\"border-bottom: 1px #000000 solid; border-right: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\">".$myrow['responded']."</td><td width=5></td></tr></table></td>
	         <td style=\"border-bottom: 1px #000000 solid;\"><table cellspacing=0 cellpadding=0 width=100%><tr><td width=5></td><td class=\"text\">".$myrow['color']."</td><td width=5></td></tr></table></td>
	       </tr>";
	    }
	  // Display the editing table footer.
	  echo "
	  </form></table>
	  <table border=0 cellpadding=5 cellspacing=0 width=90%>
	    <tr>
	      <td class=\"text\"><a href=\"clinical_alerts.php?sortby=$sortby&sortorder=$sortorder&begin=$begin&task=addnew\" onclick=\"top.restoreSession()\">".xl('Add New')."</a> &nbsp; <a href=\"javascript:confirmDeleteSelected()\" onclick=\"top.restoreSession()\">".xl('Delete')."</a></td>
	      <td align=right class=\"text\">$prevlink &nbsp; $end of $total &nbsp; $nextlink</td>
	    </tr>
	  </table></td></tr></table><br>"; ?>
	<script language="javascript">

	// Confirm the delete action.
	function confirmDeleteSelected() {
		if(confirm("<?php xl('Do you really want to delete the selection?', 'e') ?>")) {
	    document.wikiList.submit();
	}
}

// Select all items as clicked.
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

// Change the row style.
function selectRow(row) {
	document.getElementById(row).style.background = "#E7E7E7";
}

function deselectRow(row) {
	document.getElementById(row).style.background = "#F7F7F7";
}

</script><?php
} // end add/edit table
?>

<script language="javascript">
<?php
	if ($alertmsg) {
  	echo "alert('" . htmlentities($alertmsg) . "');\n";
	}
?>
</script>

</body>
</html>
