<?
include_once("../../globals.php");
include_once("$srcdir/api.inc");
?>
<html>
<body>
<span class=title>Patient Images</span>
<br>

<span class=text>Images from todays visit</span><br>

<?php
$data = formFetch('image_draw', $id);
   
    if ($data) {
 
        print "<table><tr>";
	echo "<img src=\"$GLOBALS[rootdir]/forms/image_draw/images/$data[ImgName]\" width=280  >";
    	print "</tr></table>";
}


?>

<br>


<br><Br>
<hr>
<a href="<?php echo $GLOBALS['form_exit_url']; ?>" onclick="top.restoreSession()">Done</a>

<?php
formFooter();
?>