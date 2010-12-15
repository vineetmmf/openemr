<?php
/*
 * This will delete the image, actually sets deleted to 1 in the database for forms and image_draw
 */
include_once("../../globals.php");
include_once("$srcdir/api.inc");
include_once("$srcdir/forms.inc");

$returnurl = $GLOBALS['concurrent_layout'] ? 'encounter_top.php' : 'patient_encounter.php';

$ImgName = $_GET[name];
$ImgID = $_GET[id];
$act = $_GET[act];
          
if(($name) AND ($act =='del')) {		
        $q1 = "UPDATE image_draw SET deleted = '1' where `ImgName` = '$ImgName'  ";
        mysql_query($q1) or die(mysql_error());

	$q2 = "UPDATE forms SET deleted = '1' WHERE `formdir` = 'image_draw' AND pid = '$pid' AND user = '$_SESSION[authUser]'  AND encounter = '$encounter'  AND form_id = '$ImgID' ";
        mysql_query($q2) or die(mysql_error());

//unlink("images/$image_id");
header("location:$rootdir/patient_file/encounter/$returnurl");
}

?>
