<?php
/*
 * This saves the submitted image to images folder as png and records in db
 */
include_once("../../globals.php");
include_once("$srcdir/api.inc");
include_once("$srcdir/forms.inc");

$table_name = "image_draw";
$form_name = "Patient Images";
$form_folder = "image_draw";

//////get image data and save image to folder
$filepath="images/";
$rand = time();
$name = "$rand.png";
$filename = $pid . "" . $name;

   $fp = fopen($filepath.$filename, 'wb');
   fwrite($fp, $GLOBALS['HTTP_RAW_POST_DATA']);
   fclose($fp);

//$fh = fopen($filepath.$filename, 'r');
//$data = addslashes(fread($fh, filesize($filepath.$filename)));
//fclose($fh);
//unlink("images/$filename");

    $newrecord['encounter'] = $encounter;
    $newrecord['ImgName'] = $filename;
    //$newrecord['ImgData'] = $data;
    $newrecord['ImgType'] = 'png';
    /* save the data into the form's own table */
    $newid = formSubmit($table_name, $newrecord, $_GET["id"], $userauthorized);
    
    /* link the form to the encounter in the 'forms' table */
    addForm($encounter, $form_name, $newid, $form_folder, $pid, $userauthorized);



$_SESSION["encounter"] = $encounter;

?>
