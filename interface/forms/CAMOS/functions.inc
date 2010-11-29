<?php
$depth = '../../../';
include_once ($depth.'interface/globals.php');
function can_edit_encounter() { //return FALSE if no, TRUE if yes
	//check to see if this encounter is being added to on a previous date
	$enc = $_SESSION['encounter'];
	$pid = $_SESSION['pid'];
	$query = sqlStatement("select datediff(current_date() , date(t1.onset_date)) as date_diff " .
		"from form_encounter as t1 join forms as t2 on (t1.id = t2.form_id) where t2.form_name ".
		"like 'form_encounter' and t1.pid = $pid and t2.encounter = $enc"); 
	if ($results = mysql_fetch_array($query, MYSQL_ASSOC)) {
		if ($results['date_diff'] == 0) {
			return TRUE;
		}
		if ($results['date_diff'] != 0) {
			return FALSE;
		}
	}
}
function same_user() { //return FALSE if no, TRUE if yes
	//make sure that it is the same user that started this encounter that is currently trying to edit it
	$enc = $_SESSION['encounter'];
	$pid = $_SESSION['pid'];
	$user = $_SESSION['authUser'];
	$query = sqlStatement("select user from forms where pid=$pid and encounter=$enc");
	if ($results = mysql_fetch_array($query, MYSQL_ASSOC)) {
		if ($results['user'] == $user) {
			return TRUE;
		}
		if ($results['user'] != $user) {
			return FALSE;
		}
	}
}
?>

				

