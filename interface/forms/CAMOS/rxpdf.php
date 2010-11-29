<?php
include_once ('../../globals.php'); 
function rxpdf(&$rxpdf,$pid,$enc) {
	//text sizes
	$big = 16;
	$medium = 10;
	$small = 10;
	$depth = '../../../';
	$data = getData($pid,$enc);
//	$doctor_name = $data[2]['name'].', '.$data[2]['title'];
	$doctor_name = $data[2]['name'];
	$doctor_address = $data[2]['address'];
	$doctor_address2 = $data[2]['city'].','.$data[2]['state'].' '.$data[2]['zip'];
	$doctor_phone = $data[2]['phone'];
	$doctor_dea = $data[2]['dea'];
	$patient_line = "Name: <c:uline>".$data[1]['name']."</c:uline> Address: <c:uline>".$data[1]['address']."</c:uline>, DOB: <c:uline>".$data[1]['dob']."</c:uline> Date: <c:uline>".$data[1]['date']."</c:uline>";
	include_once ($depth.'interface/globals.php'); include_once ($depth.'library/classes/class.ezpdf.php');
	include_once("../../../interface/forms/CAMOS/content_parser.php");
	?>
<?php
//	$rxpdf =& new Cezpdf(array(27.94,21.6)); //numbers for landscape 11 inches by 8.5 inches in centimeters
//	$rxpdf->selectFont($depth.'library/fonts/Helvetica');
//	$rxpdf->ezSetMargins(0,0,0,0); //I don't know if I need this
	for ($c = 0;$c<count($data[0])+4;$c += 4) {
		$rx = array();
		$rx[0] = explode("\n",pre_view_process($enc,$pid,$data[0][$c]));
		$rx[1] = explode("\n",pre_view_process($enc,$pid,$data[0][$c+1]));
		$rx[2] = explode("\n",pre_view_process($enc,$pid,$data[0][$c+2]));
		$rx[3] = explode("\n",pre_view_process($enc,$pid,$data[0][$c+3]));
		if (trim($data[0][$c]) == '') {break;} //stop printing if no more rx data!
		$rxpdf->ezNewPage();
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
		$header_font_size = 12;
		$patient_font_size = 10;
		$rx_font_size = 12;
		$fh = $rxpdf->getFontHeight($header_font_size);
		$fp = $rxpdf->getFontHeight($patient_font_size);
		$fr = $rxpdf->getFontHeight($rx_font_size);
		$y_offset_p = 90; //y offset for patient info, how far down to place it.
		$y_offset_r = 120; //y offset for rx info.
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
				$header_width,$header_font_size,$doctor_phone,'center');
			$hold = $rxpdf->addTextWrap(
				$qx[$x],$qy[$x]-$fh*4,
				$header_width,$header_font_size,$doctor_dea,'center');
			$hold = $rxpdf->addTextWrap(
				$qx[$x],$qy[$x]-$fh*5,
				$header_width,$header_font_size-6,"________________________________________________",'center');
			//signature lines
			$rxpdf->line($qx[$x]+10,$qy[$x]-320,$qx[$x]+240,$qy[$x]-320); //sig lines 
			$hold = $rxpdf->addTextWrap(
				$qx[$x]+10,$qy[$x]-320-$fh,
				$header_width,$header_font_size-4,"Signature",'left'); //shouldn't be in terms of header
		
			// START of entering individualized data for each rx
			$hold = $rxpdf->addTextWrap(
				$qx[$x],$qy[$x]-$y_offset_p,
				$header_width,$patient_font_size,$patient_line,'left');
			$i = 0;
			while (strlen($hold) > 0) {
				$i++;
				$hold = $rxpdf->addTextWrap(
				$qx[$x],$qy[$x]-$y_offset_p-$fp*$i,
				$header_width,$patient_font_size,$hold,'left');
			}
			$i = 0;
			if (trim(join($rx[$x-1])) != '') {
				foreach($rx[$x-1] as $anrx) {
					if (trim($anrx) != '') {
						$i++;
						$hold = $rxpdf->addTextWrap(
							$qx[$x]+5,$qy[$x]-$y_offset_r-$fr*$i,
							$header_width,$rx_font_size,trim($anrx),'left');
						while (strlen($hold) > 0) {
							$i++;
							$hold = $rxpdf->addTextWrap(
							$qx[$x]+5,$qy[$x]-$y_offset_r-$fr*$i,
							$header_width,$rx_font_size,trim($hold),'left');
						}
					}
				}
			} else {
				$hold = $rxpdf->addTextWrap(
					$qx[$x]+5,$qy[$x]-$y_offset_r-$fr,
					$header_width,12,'(NOT VALID FOR CONTROLLED DRUGS)','center');
			}
		}
	}
}
?>
<?php
function getData($pid,$enc) {
	$user = '';
	$query = sqlStatement("select user from forms where pid=$pid and encounter=$enc and form_name like 'New Patient Encounter'");
	if ($result = mysql_fetch_array($query, MYSQL_ASSOC)) {
		$user = $result['user'];
	}
	$query = sqlStatement("select id from users where username like '$user'");
	if ($result = mysql_fetch_array($query, MYSQL_ASSOC)) {
		$user = $result['id'];
	}
	$patient = array();
	$practice = array();
	//get patient information
	$query = sqlStatement("select fname,lname,street,city,state,postal_code,phone_home,DATE_FORMAT(DOB,'%m/%d/%y') as DOB from patient_data where pid =$pid");
	if ($result = mysql_fetch_array($query, MYSQL_ASSOC)) {
		$patient['name'] = $result['fname'] . ' ' . $result['lname'];
		$patient['address'] = $result['street'];
		$patient['city'] = $result['city'];
		$patient['state'] = $result['state'];
		$patient['zip'] = $result['postal_code'];
		$patient['phone'] = $result['phone_home'];
		$patient['dob'] = $result['DOB'];
	}
	$query = sqlStatement("select DATE_FORMAT(onset_date,'%M/%d/%y') as date from form_encounter where pid=$pid and encounter=$enc");
	if ($result = mysql_fetch_array($query, MYSQL_ASSOC)) {
		$patient['date'] = $result['date'];
	}
	//get physician information
	$query = sqlStatement("select * from users where id=$user");
	if ($result = mysql_fetch_array($query, MYSQL_ASSOC)) {
		$practice['name'] = $result['fname'] . ' ' . $result['lname'] . ', ' . $result['title']; 
		$practice['fname'] = $result['fname'];
		$practice['lname'] = $result['lname'];
		$practice['title'] = $result['title'];
		$practice['address'] = $result['street']; 
		$practice['city'] = $result['city']; 
		$practice['state'] = $result['state'];
		$practice['zip']  = $result['zip'];
		$practice['phone'] = $result['phone'];
		$practice['fax'] = $result['fax'];
		$practice['dea'] = $result['federaldrugid'];
	}
	$form_id_array = array();	
	$camos_content = array();
	$query = sqlStatement("select form_id from forms where pid=$pid and " .
		"encounter=$enc and form_name like 'CAMOS%'");
	while ($result = mysql_fetch_array($query, MYSQL_ASSOC)) {
		array_push($form_id_array, $result['form_id']);
	}
	foreach($form_id_array as $form_id) {
		$query = sqlStatement("select content from form_CAMOS " .
			"where id =$form_id and category not like 'exam'"); 
		if ($result = mysql_fetch_array($query, MYSQL_ASSOC)) {
			array_push($camos_content, $result['content']);
		}
	}
	return array($camos_content, $patient, $practice);
}
