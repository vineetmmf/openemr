<?php
include_once("../../globals.php");
include_once($GLOBALS["srcdir"]."/api.inc");

function image_draw_report( $pid, $encounter, $cols, $id) {
    
    /** CHANGE THIS - name of the database table associated with this form **/
    $table_name = "image_draw";

    $count = 0;
    $data = formFetch($table_name, $id);
   
    if ($data) {
 
        print "<table><tr>";
	echo "<img src=\"$GLOBALS[rootdir]/forms/image_draw/images/$data[ImgName]\" width=280  >";
    	print "</tr></table>";
}

}
?> 
