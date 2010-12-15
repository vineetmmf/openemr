<?php
include_once("../../globals.php");
include_once("$srcdir/api.inc");

$table_name = "image_draw";

$form_name = "Patient Images";

$form_folder = "image_draw";

formHeader("Form: ".$form_name);
$returnurl = $GLOBALS['concurrent_layout'] ? 'encounter_top.php' : 'patient_encounter.php';

$record = formFetch($table_name, $_GET["id"]);

?>

<html><head>
<?php html_header_show();?>


</head>

<body class="body_top">

<?php echo date("F d, Y", time()); ?>



<!-- container for the main body of the form -->
<div id="form_container">

<div id="general">

<?
    
   
    if ($record) {
 
        print "<table><tr>";
	echo "<img src=\"$GLOBALS[rootdir]/forms/image_draw/images/$record[ImgName]\" width=475  >";
    	print "</tr></table>";
}
?>
<BR>
<a href="<?=$rootdir;?>/forms/image_draw/deleteimage.php?act=del&name=<?=$record[ImgName];?>&id=<?=$record[id];?>" class="link" onClick="return window.confirm('Are you SURE you want to delete this image?')" >[<?php xl('Delete Image','e'); ?>]</a>  
<a href="<?php echo "$rootdir/patient_file/encounter/$returnurl";?>" class="link"
 onclick="top.restoreSession()">[<?php xl('Cancel','e'); ?>]</a>
</div>

</div>

</div> <!-- end form_container -->


</form>

</body>


</html>
