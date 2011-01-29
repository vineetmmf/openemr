<?php
/*
 * The page shown when the user requests a new form. allows the user to enter form contents, and save.
 */

/* for $GLOBALS[], ?? */
require_once('../../globals.php');
/* for acl_check(), ?? */
require_once($GLOBALS['srcdir'].'/api.inc');
/* for generate_form_field, ?? */
require_once($GLOBALS['srcdir'].'/options.inc.php');
/* note that we cannot include options_listadd.inc here, as it generates code before the <html> tag */

/** CHANGE THIS name to the name of your form. **/
$form_name = 'Communication Log';

/** CHANGE THIS to match the folder you created for this form. **/
$form_folder = 'communication_log';

/* Check the access control lists to ensure permissions to this page */
$thisauth = acl_check('patients', 'med');
if (!$thisauth) {
 die($form_name.': Access Denied.');
}
/* perform a squad check for pages touching patients, if we're in 'athletic team' mode */
if ($GLOBALS['athletic_team']!='false') {
  $tmp = getPatientData($pid, 'squad');
  if ($tmp['squad'] && ! acl_check('squads', $tmp['squad']))
   $thisauth = 0;
}

if ($thisauth != 'write' && $thisauth != 'addonly')
  die($form_name.': Adding is not authorized.');
/* in order to use the layout engine's draw functions, we need a fake table of layout data. */
$manual_layouts = array( 
 'contact_date' => 
   array( 'field_id' => 'contact_date',
          'data_type' => '4',
          'fld_length' => '0',
          'description' => 'Date contact occured/was attempted',
          'list_id' => '' ),
 'contact_name' => 
   array( 'field_id' => 'contact_name',
          'data_type' => '2',
          'fld_length' => '10',
          'max_length' => '255',
          'description' => 'Person we are attempting to contact/were contacted by',
          'list_id' => '' ),
 'phone' => 
   array( 'field_id' => 'phone',
          'data_type' => '2',
          'fld_length' => '10',
          'max_length' => '15',
          'description' => 'Phone number dialed or number of caller(if known)',
          'list_id' => '' ),
 'direction' => 
   array( 'field_id' => 'direction',
          'data_type' => '21',
          'fld_length' => '0',
          'description' => 'Was the call outbound?',
          'list_id' => 'yesno' ),
 'contact_success' => 
   array( 'field_id' => 'contact_success',
          'data_type' => '21',
          'fld_length' => '0',
          'description' => 'If the call was outbound, did you get ahold of someone who could help?',
          'list_id' => 'yesno' ),
 'reason' => 
   array( 'field_id' => 'reason',
          'data_type' => '3',
          'fld_length' => '10',
          'max_length' => '3',
          'description' => 'the principal reason or reasons contact was attempted',
          'list_id' => '' ),
 'result' => 
   array( 'field_id' => 'result',
          'data_type' => '3',
          'fld_length' => '10',
          'max_length' => '3',
          'description' => '',
          'list_id' => '' ),
 'screener' => 
   array( 'field_id' => 'screener',
          'data_type' => '10',
          'fld_length' => '0',
          'description' => 'Staff Member',
          'list_id' => '' ),
 'signature_box' => 
   array( 'field_id' => 'signature_box',
          'data_type' => '2',
          'fld_length' => '10',
          'max_length' => '60',
          'description' => 'Sign here to signify all information in this form is correct',
          'list_id' => '' )
 );
$submiturl = $GLOBALS['rootdir'].'/forms/'.$form_folder.'/save.php?mode=new&amp;return=encounter';
/* no get logic here */
$returnurl = $GLOBALS['concurrent_layout'] ? 'encounter_top.php' : 'patient_encounter.php';

?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>

<!-- declare this document as being encoded in UTF-8 -->
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" ></meta>

<!-- supporting javascript code -->
<!-- for dialog -->
<script type="text/javascript" src="<?php echo $GLOBALS['webroot']; ?>/library/dialog.js"></script>
<!-- For jquery, required by the save and discard buttons. -->
<script type="text/javascript" src="<?php echo $GLOBALS['webroot']; ?>/library/js/jquery.js"></script>
<script type="text/javascript" src="<?php echo $GLOBALS['webroot']; ?>/library/textformat.js"></script>

<!-- Global Stylesheet -->
<link rel="stylesheet" href="<?php echo $css_header; ?>" type="text/css"/>
<!-- Form Specific Stylesheet. -->
<link rel="stylesheet" href="../../forms/<?php echo $form_folder; ?>/style.css" type="text/css"/>

<!-- pop up calendar -->
<style type="text/css">@import url(<?php echo $GLOBALS['webroot']; ?>/library/dynarch_calendar.css);</style>
<script type="text/javascript" src="<?php echo $GLOBALS['webroot']; ?>/library/dynarch_calendar.js"></script>
<?php include_once("{$GLOBALS['srcdir']}/dynarch_calendar_en.inc.php"); ?>
<script type="text/javascript" src="<?php echo $GLOBALS['webroot']; ?>/library/dynarch_calendar_setup.js"></script>

<script type="text/javascript">
// this line is to assist the calendar text boxes
var mypcc = '<?php echo $GLOBALS['phone_country_code']; ?>';

<!-- support code for collapsing sections -->
function divclick(cb, divid) {
 var divstyle = document.getElementById(divid).style;
 if (cb.checked) {
  divstyle.display = 'block';
 } else {
  divstyle.display = 'none';
 }
 return true;
}

<!-- a validator for all the fields expected in this form -->
function validate() {
  return true;
}

<!-- a callback for validating field contents. executed at submission time. -->
function submitme() {
 var f = document.forms[0];
 if (validate(f)) {
  top.restoreSession();
  f.submit();
 }
}

</script>



<title><?php echo htmlspecialchars('New '.$form_name); ?></title>

</head>
<body class="body_top">

<div id="title">
<a href="<?php echo $returnurl; ?>" onclick="top.restoreSession()">
<span class="title"><?php xl($form_name,'e'); ?></span>
<span class="back">(<?php xl('Back','e'); ?>)</span>
</a>
</div>

<form method="post" action="<?php echo $submiturl; ?>" id="<?php echo $form_folder; ?>"> 

<!-- Save/Cancel buttons -->
<div id="top_buttons" class="top_buttons">
<fieldset class="top_buttons">
<input type="button" class="save" value="<?php xl('Save','e'); ?>" />
<input type="button" class="dontsave" value="<?php xl('Don\'t Save','e'); ?>" />
</fieldset>
</div><!-- end top_buttons -->

<!-- container for the main body of the form -->
<div id="form_container">
<fieldset>

<!-- display the form's manual based fields -->
<table border='0' cellpadding='0' width='100%'>
<tr><td class='sectionlabel'><input type='checkbox' id='form_cb_m_1' value='1' onclick='return divclick(this,"contact")' checked="checked" />Who</td></tr><tr><td><div id="contact" class='section'><table>
<!-- called consumeRows 014--> <!--  generating 4 cells and calling --><td>
<span class="fieldlabel"><?php xl('Date','e'); ?> (yyyy-mm-dd): </span>
</td><td>
   <input type='text' size='10' name='contact_date' id='contact_date' title='Date contact occured/was attempted'
    value="<?php echo date('Y-m-d', time()); ?>"
    title="<?php xl('yyyy-mm-dd','e'); ?>"
    onkeyup='datekeyup(this,mypcc)' onblur='dateblur(this,mypcc)' />
   <img src='../../pic/show_calendar.gif' width='24' height='22'
    id='img_contact_date' alt='[?]' style='cursor:pointer'
    title="<?php xl('Click here to choose a date','e'); ?>" />
<script type="text/javascript">
Calendar.setup({inputField:'contact_date', ifFormat:'%Y-%m-%d', button:'img_contact_date'});
</script>
</td>
<!--  generating empties --><td class='emptycell' colspan='1'></td></tr>
<!-- called consumeRows 014--> <!--  generating 4 cells and calling --><td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Name','e').':'; ?></td><td class='text data' colspan='3'><?php echo generate_form_field($manual_layouts['contact_name'], ''); ?></td><!--  generating empties --><td class='emptycell' colspan='1'></td></tr>
<!-- called consumeRows 014--> <!--  generating 4 cells and calling --><td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Phone #','e').':'; ?></td><td class='text data' colspan='3'><?php echo generate_form_field($manual_layouts['phone'], ''); ?></td><!--  generating empties --><td class='emptycell' colspan='1'></td></tr>
<!-- called consumeRows 014--> <!-- just calling --><!-- called consumeRows 224--> <!--  generating 4 cells and calling --><td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Outgoing Call?','e').':'; ?></td><td class='text data' colspan='1'><?php echo generate_form_field($manual_layouts['direction'], ''); ?></td><td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Contact Successful?','e').':'; ?></td><td class='text data' colspan='1'><?php echo generate_form_field($manual_layouts['contact_success'], ''); ?></td><!--  generating empties --><td class='emptycell' colspan='1'></td></tr>
<!-- called consumeRows 014--> <!-- just calling --><!-- called consumeRows 224--> <!-- generating not($fields[$checked+1]) and calling last --><td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Reasons for contact','e').':'; ?></td><td class='text data' colspan='1'><?php echo generate_form_field($manual_layouts['reason'], ''); ?></td><td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Results of conversation','e').':'; ?></td><td class='text data' colspan='1'><?php echo generate_form_field($manual_layouts['result'], ''); ?></td><!-- called consumeRows 424--> <!-- Exiting not($fields) and generating 0 empty fields --></tr>
</table></div>
</td></tr> <!-- end section contact -->
<tr><td class='sectionlabel'><input type='checkbox' id='form_cb_m_2' value='1' onclick='return divclick(this,"staff")' checked="checked" />Agency Representitive</td></tr><tr><td><div id="staff" class='section'><table>
<!-- called consumeRows 014--> <!-- just calling --><!-- called consumeRows 224--> <!-- generating not($fields[$checked+1]) and calling last --><td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Access Screener','e').':'; ?></td><td class='text data' colspan='1'><?php echo generate_form_field($manual_layouts['screener'], ''); ?></td><td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Signature','e').':'; ?></td><td class='text data' colspan='1'><?php echo generate_form_field($manual_layouts['signature_box'], ''); ?></td><!-- called consumeRows 424--> <!-- Exiting not($fields) and generating 0 empty fields --></tr>
</table></div>
</td></tr> <!-- end section staff -->
</table>

</fieldset>
</div> <!-- end form_container -->

<!-- Save/Cancel buttons -->
<div id="bottom_buttons" class="button_bar">
<fieldset>
<input type="button" class="save" value="<?php xl('Save','e'); ?>" />
<input type="button" class="dontsave" value="<?php xl('Don\'t Save','e'); ?>" />
</fieldset>
</div><!-- end bottom_buttons -->
</form>
<script type="text/javascript">
// jQuery stuff to make the page a little easier to use

$(document).ready(function(){
    $(".save").click(function() { top.restoreSession(); document.forms["<?php echo $form_folder; ?>"].submit(); });
    $(".dontsave").click(function() { location.href='<?php echo "$rootdir/patient_file/encounter/$returnurl"; ?>'; });
});
</script>
</body>
</html>

