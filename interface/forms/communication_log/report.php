<?php
/*
 * this file's contents are included in both the encounter page as a 'quick summary' of a form, and in the medical records' reports page.
 */

/* for $GLOBALS[], ?? */
require_once('../../globals.php');
/* for acl_check(), ?? */
require_once($GLOBALS['srcdir'].'/api.inc');

/* The name of the function is significant and must match the folder name */
function communication_log_report( $pid, $encounter, $cols, $id) {
    $count = 0;
/** CHANGE THIS - name of the database table associated with this form **/
$table_name = 'form_communication';


/* an array of all of the fields' names and their types. */
$field_names = array('contact_date' => 'date','contact_name' => 'textfield','phone' => 'textfield','direction' => 'checkbox_list','contact_success' => 'checkbox_list','reason' => 'textarea','result' => 'textarea','screener' => 'provider','signature_box' => 'textfield');
/* an array of the lists the fields may draw on. */
$lists = array();
    $data = formFetch($table_name, $id);
    if ($data) {

        echo '<table><tr>';

        foreach($data as $key => $value) {
            if ($key == 'id' || $key == 'pid' || $key == 'user' ||
                $key == 'groupname' || $key == 'authorized' ||
                $key == 'activity' || $key == 'date' || 
                $value == '' || $value == '0000-00-00 00:00:00' ||
                $value == 'n')
            {
                /* skip built-in fields and "blank data". */
	        continue;
            }

            /* display 'yes' instead of 'on'. */
            if ($value == 'on') {
                $value = 'yes';
            }

            /* remove the time-of-day from the 'date' fields. */
            if ($field_names[$key] == 'date')
            if ($value != '') {
              $dateparts = split(' ', $value);
              $value = $dateparts[0];
            }

            /* replace underscores with spaces, and uppercase all words. */
            /* this is a primitive form of converting the column names into something displayable. */
            $key=ucwords(str_replace('_',' ',$key));
            $mykey = $key;
            $myval = $value;
            echo '<td><span class=bold>'.xl("$mykey").': </span><span class=text>'.xl("$myval").'</span></td>';


            $count++;
            if ($count == $cols) {
                $count = 0;
                echo '</tr><tr>' . PHP_EOL;
            }
        }
    }
    echo '</tr></table><hr>';
}
?>

