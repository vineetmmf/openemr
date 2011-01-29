<?php
/*
 * The page shown when the user requests to see this form in a "report view". does not allow editing contents, or saving. has 'print' and 'delete' buttons.
 */

/* for $GLOBALS[], ?? */
require_once('../../globals.php');
/* for acl_check(), ?? */
require_once($GLOBALS['srcdir'].'/api.inc');
/* for display_layout_rows(), ?? */
require_once($GLOBALS['srcdir'].'/options.inc.php');

/** CHANGE THIS - name of the database table associated with this form **/
$table_name = 'form_communication';

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
/* Use the formFetch function from api.inc to load the saved record */
$xyzzy = formFetch($table_name, $_GET['id']);

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

/* since we have no-where to return, abuse returnurl to link to the 'edit' page */
/* FIXME: pass the ID, create blank rows if necissary. */
$returnurl = "../../forms/$form_folder/view.php?mode=noencounter";

/* remove the time-of-day from all date fields */
if ($xyzzy['contact_date'] != '') {
    $dateparts = split(' ', $xyzzy['contact_date']);
    $xyzzy['contact_date'] = $dateparts[0];
}

/* define check field functions. used for translating from fields to html viewable strings */

function chkdata_Date(&$record, $var) {
        return htmlspecialchars($record{"$var"},ENT_QUOTES);
}

function chkdata_Txt(&$record, $var) {
        return htmlspecialchars($record{"$var"},ENT_QUOTES);
}

?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>

<!-- declare this document as being encoded in UTF-8 -->
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" ></meta>

<!-- supporting javascript code -->
<!-- for dialog -->
<script type="text/javascript" src="<?php echo $GLOBALS['webroot']; ?>/library/dialog.js"></script>
<!-- For jquery, required by edit, print, and delete buttons. -->
<script type="text/javascript" src="<?php echo $GLOBALS['webroot']; ?>/library/js/jquery.js"></script>
<script type="text/javascript" src="<?php echo $GLOBALS['webroot']; ?>/library/textformat.js"></script>

<!-- Global Stylesheet -->
<link rel="stylesheet" href="<?php echo $css_header; ?>" type="text/css"/>
<!-- Form Specific Stylesheet. -->
<link rel="stylesheet" href="../../forms/<?php echo $form_folder; ?>/style.css" type="text/css"/>

<script type="text/javascript">

<!-- FIXME: this needs to detect access method, and construct a URL appropriately! -->
function PrintForm() {
    newwin = window.open("<?php echo $rootdir.'/forms/'.$form_folder.'/print.php?id='.$_GET['id']; ?>","print_<?php echo $form_name; ?>");
}

</script>
<title><?php echo htmlspecialchars('Show '.$form_name); ?></title>

</head>
<body class="body_top">

<div id="title">
<span class="title"><?php xl($form_name,'e'); ?></span>
<?php
 if ($thisauth == 'write' || $thisauth == 'addonly')
  { ?>
<a href="<?php echo $returnurl; ?>" onclick="top.restoreSession()">
<span class="back"><?php xl($tmore,'e'); ?></span>
</a>
<?php }; ?>
</div>

<form method="post" id="<?php echo $form_folder; ?>" action="">

<!-- container for the main body of the form -->
<div id="form_container">

<div id="show">

<!-- display the form's manual based fields -->
<table border='0' cellpadding='0' width='100%'>
<tr><td class='sectionlabel'>Who</td><!-- called consumeRows 014--> <td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Date','e').':'; ?></td><td class='text data' colspan='3'><?php echo generate_display_field($manual_layouts['contact_date'], $xyzzy['contact_date']); ?></td></tr>
<tr><td valign='top'>&nbsp;</td><!-- called consumeRows 014--> <td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Name','e').':'; ?></td><td class='text data' colspan='3'><?php echo generate_display_field($manual_layouts['contact_name'], $xyzzy['contact_name']); ?></td></tr>
<tr><td valign='top'>&nbsp;</td><!-- called consumeRows 014--> <td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Phone #','e').':'; ?></td><td class='text data' colspan='3'><?php echo generate_display_field($manual_layouts['phone'], $xyzzy['phone']); ?></td></tr>
<tr><td valign='top'>&nbsp;</td><!-- called consumeRows 014--> <!-- called consumeRows 224--> <td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Outgoing Call?','e').':'; ?></td><td class='text data' colspan='1'><?php echo generate_display_field($manual_layouts['direction'], $xyzzy['direction']); ?></td><td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Contact Successful?','e').':'; ?></td><td class='text data' colspan='1'><?php echo generate_display_field($manual_layouts['contact_success'], $xyzzy['contact_success']); ?></td></tr>
<tr><td valign='top'>&nbsp;</td><!-- called consumeRows 014--> <!-- called consumeRows 224--> <td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Reasons for contact','e').':'; ?></td><td class='text data' colspan='1'><?php echo generate_display_field($manual_layouts['reason'], $xyzzy['reason']); ?></td><td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Results of conversation','e').':'; ?></td><td class='text data' colspan='1'><?php echo generate_display_field($manual_layouts['result'], $xyzzy['result']); ?></td><!-- called consumeRows 424--> <!-- Exiting not($fields)0--></tr>
<tr><td class='sectionlabel'>Agency Representitive</td><!-- called consumeRows 014--> <!-- called consumeRows 224--> <td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Access Screener','e').':'; ?></td><td class='text data' colspan='1'><?php echo generate_display_field($manual_layouts['screener'], $xyzzy['screener']); ?></td><td class='fieldlabel' colspan='1'><?php echo xl_layout_label('Signature','e').':'; ?></td><td class='text data' colspan='1'><?php echo generate_display_field($manual_layouts['signature_box'], $xyzzy['signature_box']); ?></td><!-- called consumeRows 424--> <!-- Exiting not($fields)0--></tr>
</table>


</div><!-- end show -->

</div><!-- end form_container -->

<!-- Print button -->
<div id="button_bar" class="button_bar">
<fieldset class="button_bar">
<input type="button" class="print" value="<?php xl('Print','e'); ?>" />
</fieldset>
</div><!-- end button_bar -->

</form>
<script type="text/javascript">
// jQuery stuff to make the page a little easier to use

$(document).ready(function(){
    $(".print").click(function() { PrintForm(); });
});
</script>
</body>
</html>

