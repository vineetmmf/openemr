<?php
///this file pulls the images from the bgimages folder

	$imgdir = 'bgimages/'; // the directory, where images are stored
	$allowed_types = array('png','jpg','jpeg','gif'); // list of filetypes to show
	$dimg = opendir($imgdir);
	while($imgfile = readdir($dimg))
 	 {
 	  if(in_array(strtolower(substr($imgfile,-3)),$allowed_types))
 	  {
 	   $a_img[] = $imgfile;
 	   sort($a_img);
 	   reset ($a_img);
 	  } 
 	 }
 	 $totimg = count($a_img); // total image number

	

 	 for($x=0; $x < $totimg; $x++)
 	 {
 	  $size = getimagesize($imgdir.'/'.$a_img[$x]);

 	  print "$a_img[$x]<BR>";
	

 	 }


?>
      


