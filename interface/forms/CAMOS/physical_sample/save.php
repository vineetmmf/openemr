<?php
//------------This file inserts your field data into the MySQL database
include_once("../../globals.php");
include_once("$srcdir/api.inc");
include_once("$srcdir/forms.inc");

//process form variables here
//create an array of all of the existing field names
$field_names = array('chief_complaints' => 'textarea','surgical_history' => 'checkbox_group','surgical_history_other' => 'textfield','medical_history' => 'scrolling_list_multiples','medical_history_other' => 'textfield','allergies' => 'checkbox_group','allergies_other' => 'textfield','smoke_history' => 'radio_group','etoh_history' => 'scrolling_list','last_mammogram' => 'date');
$negatives = array('surgical_history' => array('cholecystectomy' => 'cholecystectomy','tonsillectomy' => 'tonsillectomy','apendectomy' => 'apendectomy','hernia' => 'hernia'),'medical_history' => array('asthma' => 'asthma','diabetes' => 'diabetes','hypertension' => 'hypertension','GERD' => 'GERD'),'allergies' => array('penicillin' => 'penicillin','sulfa' => 'sulfa','iodine' => 'iodine'));
//process each field according to it's type
foreach($field_names as $key=>$val)
{
  $pos = '';
  $neg = '';
	if ($val == "checkbox")
	{
		if ($_POST[$key]) {$field_names[$key] = "yes";}
		else {$field_names[$key] = "negative";}
	}
	elseif (($val == "checkbox_group")||($val == "scrolling_list_multiples"))
	{
		if (array_key_exists($key,$negatives)) #a field requests reporting of negatives
		{
                  if ($_POST[$key]) 
                  {
			foreach($_POST[$key] as $var) #check positives against list
			{
				if (array_key_exists($var, $negatives[$key]))
				{	#remove positives from list, leaving negatives
					unset($negatives[$key][$var]);
				}
			}
                  }
			if (is_array($negatives[$key]) && count($negatives[$key])>0) 
			{
				$neg = "Negative for ".implode(', ',$negatives[$key]).'.';
			}
		}
		if (is_array($_POST[$key]) && count($_POST[$key])>0) 
		{
			$pos = implode(', ',$_POST[$key]);
		}
		if($pos) {$pos = 'Positive for '.$pos.'.  ';}
		$field_names[$key] = $pos.$neg;	
	}
	else
	{
		$field_names[$key] = $_POST[$key];
	}
        if ($field_names[$key] != '')
        {
//          $field_names[$key] .= '.';
          $field_names[$key] = preg_replace('/\s*,\s*([^,]+)\./',' and $1.',$field_names[$key]); // replace last comma with 'and' and ending period
        } 
}

//end special processing
if(get_magic_quotes_gpc()) {
  foreach ($field_names as $k => $var) {
    $field_names[$k] = stripslashes($var);
  }
}
foreach ($field_names as $k => $var) {
  #if (strtolower($k) == strtolower($var)) {unset($field_names[$k]);}
  $field_names[$k] = mysql_real_escape_string($var);
echo "$var\n";
}
if ($encounter == "")
$encounter = date("Ymd");
if ($_GET["mode"] == "new"){
reset($field_names);
$newid = formSubmit("form_physical_sample", $field_names, $_GET["id"], $userauthorized);
addForm($encounter, "physical_sample", $newid, "physical_sample", $pid, $userauthorized);
}elseif ($_GET["mode"] == "update") {
sqlInsert("update form_physical_sample set pid = {$_SESSION["pid"]},groupname='".$_SESSION["authProvider"]."',user='".$_SESSION["authUser"]."',authorized=$userauthorized,activity=1, date = NOW(), chief_complaints='".$field_names["chief_complaints"]."',surgical_history='".$field_names["surgical_history"]."',surgical_history_other='".$field_names["surgical_history_other"]."',medical_history='".$field_names["medical_history"]."',medical_history_other='".$field_names["medical_history_other"]."',allergies='".$field_names["allergies"]."',allergies_other='".$field_names["allergies_other"]."',smoke_history='".$field_names["smoke_history"]."',etoh_history='".$field_names["etoh_history"]."',last_mammogram='".$field_names["last_mammogram"]."' where id=$id");
}

$_SESSION["encounter"] = $encounter;
formHeader("Redirecting....");
formJump();
formFooter();
?>
