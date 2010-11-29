<?php
//text sizes
$big = 16;
$medium = 10;
$small = 10;
$depth = '../../../';
$patient_line = "Name: <c:uline>".$patient_name."</c:uline> Address: <c:uline>".$patient_address."</c:uline> Date: <c:uline>".$encounter_date."</c:uline>";
$testrx_array = explode("\n",$testrx);
include_once ($depth.'interface/globals.php');
include_once ($depth.'library/classes/class.ezpdf.php');
include_once("../../../interface/forms/CAMOS/content_parser.php");
?>
<?php
$rxpdf =& new Cezpdf(array(27.94,21.6)); //numbers for landscape 11 inches by 8.5 inches in centimeters
$rxpdf->selectFont($depth.'library/fonts/Helvetica');
$rxpdf->ezSetMargins(0,0,0,0); //I don't know if I need this
$w = $rxpdf->ez['pageWidth'];
$h = $rxpdf->ez['pageHeight'];
$hw = $w/2; // half the page width
$hh = $h/2; // half the page height
$tm = 50; //top margin of rx
$lm = 5; //left margin of rx
//upper left starting/reference point of each of four quadrants of prescriptions
$qx = array(); //quadrant x offset
$qy = array(); //quadrant y offset
$qx[1] = 5;
$qy[1] = $h-50;
$qx[2] = $hw+5;
$qy[2] = $h-50;
$qx[3] = 5;
$qy[3] = $hh-50;
$qx[4] = $hw+5;
$qy[4] = $hh-50;
//draw the two lines to use the paper cutter on.
$rxpdf->line(0,$hh,$w,$hh); //line across
$rxpdf->line($hw,0,$hw,$h); //line up and down 
//settings for header which is the doctor's info
$header_width = $hw-20; //width of fields for doctor's name
$header_font_size = 16;
$patient_font_size = 10;
$rx_font_size = 12;
$fh = $rxpdf->getFontHeight($header_font_size);
$fp = $rxpdf->getFontHeight($patient_font_size);
$fr = $rxpdf->getFontHeight($rx_font_size);
$y_offset_p = 80; //y offset for patient info, how far down to place it.
$y_offset_r = 100; //y offset for rx info.
for ($x=1;$x<5;$x++) {
	//headers
	$hold = $rxpdf->addTextWrap(
		$qx[$x],$qy[$x],
		$header_width,$header_font_size,$doctor_name,'center');
	$hold = $rxpdf->addTextWrap(
		$qx[$x],$qy[$x]-$fh,
		$header_width,$header_font_size,$doctor_address,'center');
	$hold = $rxpdf->addTextWrap(
		$qx[$x],$qy[$x]-$fh*2,
		$header_width,$header_font_size,$doctor_address2,'center');
	$hold = $rxpdf->addTextWrap(
		$qx[$x],$qy[$x]-$fh*3,
		$header_width,$header_font_size-6,"________________________________________________",'center');
	//signature lines
	$rxpdf->line($qx[$x]+10,$qy[$x]-220,$qx[$x]+300,$qy[$x]-220); //sig lines 
	$hold = $rxpdf->addTextWrap(
		$qx[$x]+10,$qy[$x]-220-$fh,
		$header_width,$header_font_size-4,"Signature",'left'); //shouldn't be in terms of header

	// START of entering individualized data for each rx
	$hold = $rxpdf->addTextWrap(
		$qx[$x],$qy[$x]-$y_offset_p,
		$header_width,$patient_font_size,$patient_line,'left');
	$i = 0;
	foreach($testrx_array as $rx) {
		$i++;
		$hold = $rxpdf->addTextWrap(
			$qx[$x]+5,$qy[$x]-$y_offset_r-$fr*$i,
			$header_width,$rx_font_size,trim($rx),'left');
		while (strlen($hold) > 0) {
			$i++;
			$hold = $rxpdf->addTextWrap(
			$qx[$x]+5,$qy[$x]-$y_offset_r-$fr*$i,
			$header_width,$rx_font_size,trim($hold),'left');
	
		}
	}

}
$rxpdf->ezStream();

?>
