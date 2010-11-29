<?php
//------------This file inserts your field data into the MySQL database
include_once("../../globals.php");
include_once("../../../library/api.inc");
include_once("../../../library/forms.inc");
include_once("../../../library/sql.inc");
include_once("content_parser.php");
include_once("./functions.inc");

if ((can_edit_encounter() !== FALSE) and (same_user() !== FALSE)) {
	if ($encounter == "") {
	  $encounter = date("Ymd");
	}
	
	$field_names = array('category' => $_POST['category'], 'subcategory' => $_POST['subcategory'], 'item' => $_POST['item'], 'content' => $_POST['content']);
	if(get_magic_quotes_gpc()) {
	  foreach ($field_names as $k => $var) {
	    $field_names[$k] = stripslashes($var);
	  }
	}
	foreach ($field_names as $k => $var) {
	  $field_names[$k] = mysql_real_escape_string($var);
	}
	$camos_array = array();
	process_commands($field_names['content'],$camos_array); 
	
	$CAMOS_form_name = "CAMOS-".$field_names['category'].'-'.$field_names['subcategory'].'-'.$field_names['item'];
	
	if (preg_match("/^[\s\\r\\n\\\\r\\\\n]*$/",$field_names['content']) == 0) { //make sure blanks do not get submitted
	  $field_names['content'] = replace_placeholders($encounter,$pid,$field_names['content']);
	  reset($field_names);
	  $newid = formSubmit("form_CAMOS", $field_names, $_GET["id"], $userauthorized);
	  addForm($encounter, $CAMOS_form_name, $newid, "CAMOS", $pid, $userauthorized);
	}
	//deal with embedded camos submissions here
	//first, deal with inserting subjective,objective,assessment,plan snippets into SOAP note appropriately
	$soap = '';
	foreach($camos_array as $val) {
		if ($val['category'] == 'exam') {
			$soap = &$val;
		}
	}
	foreach($camos_array as $val) {
		if ($val['item'] == 'subjective') {
			$soap['content'] .= "\r\n".$val['content'];
		}
	}
	foreach($camos_array as $val) {
	  if (preg_match("/^[\s\\r\\n\\\\r\\\\n]*$/",$val['content']) == 0) { //make sure blanks not submitted
	    foreach($val as $k => $v) {
	      $val[$k] = replace_placeholders($encounter,$pid,trim($v));  
	    } 
	    $CAMOS_form_name = "CAMOS-".$val['category'].'-'.$val['subcategory'].'-'.$val['item'];
	    reset($val);
	    $newid = formSubmit("form_CAMOS", $val, $_GET["id"], $userauthorized);
	    addForm($encounter, $CAMOS_form_name, $newid, "CAMOS", $pid, $userauthorized);
	  }
	}
	echo "<font color=red><b>submitted: " . time() . "</b></font>";
} else {
	echo "<font color=red><b>Sorry, this encounter is closed or you are not the correct user.</b></font>";
}
?>
