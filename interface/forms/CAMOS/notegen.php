<?
//text sizes
$big = 16;
$medium = 10;
$small = 10;

$depth = '../../../';
include_once ($depth.'interface/globals.php');
include_once ($depth.'library/classes/class.ezpdf.php');
include_once("../../../interface/forms/CAMOS/content_parser.php");
?>
<?
if (!$_POST['submit'] && !($_GET['pid'] && $_GET['encounter']) && !(isset($_GET['pid_only']))) {
?>
<html>
<head>
<title>
Print Notes
</title>
<style type="text/css">@import url('<?php echo $depth ?>library/dynarch_calendar.css');</style>
<script type="text/javascript" src="<?php echo $depth ?>library/dialog.js"></script>
<script type="text/javascript" src="<?php echo $depth ?>library/textformat.js"></script>
<script type="text/javascript" src="<?php echo $depth ?>library/dynarch_calendar.js"></script>
<script type="text/javascript" src="<?php echo $depth ?>library/dynarch_calendar_en.js"></script>
<script type="text/javascript" src="<?php echo $depth ?>library/dynarch_calendar_setup.js"></script>
</head>

<body>
<script language='JavaScript'> var mypcc = '1'; </script>

<form method=post name=choose_patients> 

<table>
<tr><td>
<span class='text'><?php xl('Start (yyyy-mm-dd): ','e') ?></span>
</td><td>
<input type='text' size='10' name='start' id='start' value='<? echo $_POST['end'] ? $_POST['end'] : date('Y-m-d') ?>' 
onkeyup='datekeyup(this,mypcc)' onblur='dateblur(this,mypcc)'
title='yyyy-mm-dd last date of this event' />
<img src='<?php echo $depth ?>interface/pic/show_calendar.gif' align='absbottom' width='24' height='22'
id='img_start' border='0' alt='[?]' style='cursor:pointer'
title='Click here to choose a date'>
<script>
Calendar.setup({inputField:'start', ifFormat:'%Y-%m-%d', button:'img_start'});
</script>
</td></tr>

<tr><td>
<span class='text'><?php xl('End (yyyy-mm-dd): ','e') ?></span>
</td><td>
<input type='text' size='10' name='end' id='end' value ='<? echo $_POST['end'] ? $_POST['end'] : date('Y-m-d') ?>' 
onkeyup='datekeyup(this,mypcc)' onblur='dateblur(this,mypcc)'
title='yyyy-mm-dd last date of this event' />
<img src='<?php echo $depth ?>interface/pic/show_calendar.gif' align='absbottom' width='24' height='22'
id='img_end' border='0' alt='[?]' style='cursor:pointer'
title='Click here to choose a date'>
<script>
Calendar.setup({inputField:'end', ifFormat:'%Y-%m-%d', button:'img_end'});
</script>
</td></tr>
<tr><td></td><td></td></tr>
<tr><td>Last Name: </td><td>
<input type='text' name='lname'/> 
</td></tr>
<tr><td>First Name: </td><td>
<input type='text' name='fname'/> 
</td></tr>
<tr><td>PID: </td><td>
<input type='text' name='patient_pid'/> 
</td></tr>
<tr><td>Digitally Signed: </td><td>
<input type=checkbox name='digisign'/> 
</td></tr>
<tr><td>Reciept View: </td><td>
<input type=checkbox name='reciept'/> 
</td></tr>
<tr><td>
<input type='submit' name='submit' value='submit'>
</td><td>
</td></tr>
</table>
</form>
</body>
</html>
<?
}
//if ($_POST['submit'] || ($_GET['pid'] && $_GET['encounter'])) {
else {
	$digisign = false;
	$reciept = false;
	if ($_POST['digisign'] == 'on') {
		$digisign = true;
	}
	if ($_POST['reciept'] == 'on') {
		$reciept = true;
	}
  	$pdf =& new Cezpdf();
	$pdf->selectFont($depth.'library/fonts/Helvetica');
	$pdf->ezSetCmMargins(1,1,1,1);
	if (isset($_GET['pid_only'])) {
		$output = getFormData($_POST['start'],$_POST['end'],$_POST['lname'],$_POST['fname'],$_GET['pid_only']);
	} else {
		$output = getFormData($_POST['start'],$_POST['end'],$_POST['lname'],$_POST['fname'],$_POST['patient_pid']);
	}
	ksort($output);
	$first = 1;
	$single_note_flag = FALSE;
	if (count($output) == 1) {
		$single_note_flag = TRUE;
	}
	foreach ($output as $datekey => $dailynote) {
		foreach ($dailynote as $note_id => $notecontents) {
			preg_match('/(\d+)_(\d+)/', $note_id, $matches); //the unique note id contains the pid and encounter
			$pid = $matches[1];
			$enc = $matches[2];
			if (!$first) { //generate a new page each time except first iteration when nothing has been printed yet
				$pdf->ezNewPage();
			}
			else {
				$first = 0;
			}
			if ($reciept) {
				$pdf->ezText('',$small);
			}
			$pdf->ezText("Date: ".$notecontents['date'],$small);
			$pdf->ezText("Name: ".$notecontents['name'],$small);
			$pdf->ezText("DOB: ".$notecontents['dob'],$small);
			$pdf->ezText("address: ".$notecontents['address'],$small);
			$pdf->ezText("phone: ".$notecontents['phone'],$small);
//			$pdf->ezText("ID: ".$note_id,$small);
			$pdf->ezText("",$small);
			if (!$reciept) {
				$pdf->ezText("Chief Complaint: ".$notecontents['reason'],$medium);
				if ($notecontents['vitals']) {
//					$pdf->ezText("",$medium);
					$pdf->ezText($notecontents['vitals'],$medium);
				}
				if (count($notecontents['exam']) > 0) {
					$pdf->ezText("",$medium);
					$pdf->ezText("Progress Notes",$big);
					$pdf->ezText("",$medium);
					foreach($notecontents['exam'] as $examnote) {
						$pdf->ezText($examnote);
//						$pdf->ezText(pre_view_process($enc,$pid,$examnote));
					}
				}
				if (count($notecontents['prescriptions']) > 0) {
					$pdf->ezText("",$medium);
					$pdf->ezText("Prescriptions",$big);
					$pdf->ezText("",$medium);
					foreach($notecontents['prescriptions'] as $rx) {
	//					$pdf->ezText($rx);
						$pdf->ezText(pre_view_process($enc,$pid,$rx));
					}
				}
				if (count($notecontents['other']) > 0) {
					$pdf->ezText("",$medium);
					$pdf->ezText("Other",$big);
					$pdf->ezText("",$medium);
					foreach($notecontents['other'] as $other => $othercat) {
						$pdf->ezText($other,$medium);
						foreach($othercat as $items) {
	//						$pdf->ezText($items,$medium);
							$pdf->ezText(pre_view_process($enc,$pid,$items),$medium);
						}
					}
				}
				if (count($notecontents['billing']) > 0) {
					$tmp = array();
					foreach($notecontents['billing'] as $code) {//too lazy to fix placement of query below.  this is terrible :(
						$tmp[$code]++;
					}
					if (count($tmp) > 0) {
						$pdf->ezText("",$medium);
						$pdf->ezText("Coding",$big);
						$pdf->ezText("",$medium);
						foreach($tmp as $code => $val) {
							$tmp_array = explode('_|_|_',$code);
							if (strtolower(trim($tmp_array[0])) == 'icd9') {
								$pdf->ezText($tmp_array[1],$medium);
							}
						}
					}
				}
				$pdf->ezText("",$big);
				$pdf->ezText("",$big);
				$query = sqlStatement("select t2.id, t2.fname, t2.lname, t2.title from forms as t1 join users as t2 on " .
					"(t1.user like t2.username) where t1.pid=$pid and t1.encounter=$enc and t1.form_name like 'New Patient Encounter'");
				$name = '';
				if ($results = mysql_fetch_array($query, MYSQL_ASSOC)) {
					$name = $results['fname']." ".$results['lname'].", ".$results['title'];
					$user_id = $results['id'];
				}
				//name thing isn't working right at the moment due to bad data in database with provider
				//so hardcode it for now.  fix data later.
				$name = "John Smith, M.D.";
				if ($digisign === false) {
					$pdf->ezText("_________________________________________",$big);
					$pdf->ezText($name,$big);
				} else {
	//				$pdf->ezText("Digitally Signed",$big);
					$pdf->ezText($name,$big);
				}
			} else { // print a reciept
				if (count($notecontents['billing']) > 0) {
					$dxlist = array();
					$charges = array();
					$payments = array();
					$charges_total = 0;
					$payments_total = 0;
					$tmp = array();
					foreach($notecontents['billing'] as $code) {
						$tmp[$code]++;
					}
					if (count($tmp) > 0) {
						foreach($tmp as $code => $val) {
							$tmp_array = explode('_|_|_',$code);
							if (strtolower(trim($tmp_array[0])) == 'icd9') {
								array_push($dxlist,$tmp_array[1]);
//								$pdf->ezText($tmp_array[1],$medium);
							}
							elseif (strtolower(trim($tmp_array[0])) == 'copay') {
								array_push($payments,$tmp_array[1]);
								preg_match('/\$(.+?) /',$tmp_array[1],$matches);
								$payments_total += $matches[1];
							}
							else {
								array_push($charges,$tmp_array[1]);
								preg_match('/\$(.+?) /',$tmp_array[1],$matches);
								$charges_total += $matches[1];
							}
						}
						$pdf->ezText('diagnosis list',$big);
						$pdf->ezText('',$medium);
						foreach ($dxlist as $v) {
							$pdf->ezText($v,$medium);
						}
						$pdf->ezText('',$big);
						$pdf->ezText('charges',$big);
						$pdf->ezText('',$medium);
						foreach ($charges as $v) {
							$pdf->ezText($v,$medium);
						}
						$pdf->ezText('',$big);
						$pdf->ezText('payments',$big);
						$pdf->ezText('',$medium);
						foreach ($payments as $v) {
							$pdf->ezText($v,$medium);
						}
						$pdf->ezText('',$big);
						$pdf->ezText('Charges Total',$big);
						$pdf->ezText('',$medium);
						$pdf->ezText('$'.sprintf("%01.2f",$charges_total),$medium);
						$pdf->ezText('',$big);
						$pdf->ezText('Payments Total',$big);
						$pdf->ezText('',$medium);
						$pdf->ezText('$'.sprintf("%01.2f",$payments_total),$medium);
					}
				}

			}
		}
	}
	if ($single_note_flag === TRUE) {
		include ('./rxpdf.php');
		rxpdf($pdf, $pid, $enc);
	}
	$pdf->ezStream();
}
function getFormData($start_date,$end_date,$lname,$fname,$patient_pid) { //dates in sql format
	$lname = trim($lname);
	$fname = trim($fname);
	$name_clause = '';
	$date_clause = "date(t2.date) >= '".$start_date."' and date(t2.date) <= '".$end_date."' ";
	$limit_clause = '';
	if ($lname || $fname) {
		$name_clause = "and t3.lname like '%".$lname."%' and t3.fname like '%".$fname."%' ";
	}
	$dates = array();
	if ($_GET['pid'] && $_GET['encounter']) {
		$date_clause = '';
		$name_clause = "t2.pid=".$_GET['pid']." and t2.encounter=".$_GET['encounter']." ";
	}
	if ($patient_pid) {
		$date_clause = '';
		$name_clause = "t2.pid=$patient_pid ";
	}
	if ($_GET['pid_only']) {
		$date_clause = "date(t2.date) >= DATE_SUB(DATE(CURRENT_DATE()), INTERVAL 90 DAY) and date(t2.date) <= DATE(CURRENT_DATE()) AND ";
		if (isset($_GET['limit'])) {
			$end_date = getDateOldEncounter($patient_pid, $_GET['limit']); 
			$date_clause = "date(t2.date) <= DATE(CURRENT_DATE()) and date(t2.date) >= date('".
				$end_date."') and ";
		}
	}
	$query1 = sqlStatement(
		"select t1.form_id, t1.form_name, t1.pid, date_format(t2.date,'%m-%d-%Y') as date, " .
		"date_format(t2.date,'%Y%m%d') as datekey, " .
		"t3.phone_home, t3.street, t3.city, t3.state, t3.postal_code, " .
		"t3.lname, t3.fname, date_format(t3.DOB,'%m-%d-%Y') as dob, " .
		"t2.encounter as enc, " .
	      	"t2.reason from " .
		"forms as t1 join " .
		"form_encounter as t2 on " .
		"(t1.pid = t2.pid and t1.encounter = t2.encounter) " . 
		"join patient_data as t3 on " .
		"(t1.pid = t3.pid) where " .
		$date_clause .
		$name_clause .
		"order by date,pid" .
		"");
	while ($results1 = mysql_fetch_array($query1, MYSQL_ASSOC)) {
		if (!$dates[$results1['datekey']]) {
			$dates[$results1['datekey']] = array();
		}
		if (!$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]) {
			$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']] = array();
			$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['name'] = $results1['fname'].' '.$results1['lname'];
			$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['date'] = $results1['date'];
			$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['phone'] = $results1['phone_home'];
			$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['address'] = $results1['street'].
				', '.$results1['city'].', '.$results1['state'].' '.$results1['postal_code'];
			$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['dob'] = $results1['dob'];
			$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['vitals'] = '';
			$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['reason'] = $results1['reason'];
			$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['exam'] = array();
			$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['prescriptions'] = array();
			$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['other'] = array();
			$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['billing'] = array();
		}
		// get icd9 codes for this encounter
		$query2 = sqlStatement("select * from billing where encounter = ".
			$results1['enc']." and pid = ".$results1['pid']." and activity=1");
                while ($results2 = mysql_fetch_array($query2, MYSQL_ASSOC)) {
			$fee = '';
			$code = $results2['code'];
			if ($results2['fee'] > 0) {$fee = '$'.$results2['fee'].' '; }
			if (strtolower(trim($results2['code_type'])) == 'copay') {$code = '$'.$code; }
			array_push($dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['billing'],
				$results2['code_type'].'_|_|_'.$fee.$code.' '.$results2['code_text']);
		}
		if (strtolower($results1['form_name']) == 'vitals') { // deal with Vitals
			$query2 = sqlStatement("select * from form_vitals where id = " .
			    	$results1['form_id']);	
	                if ($results2 = mysql_fetch_array($query2, MYSQL_ASSOC)) {
				$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['vitals'] = formatVitals($results2);
			}
		}
		if (substr(strtolower($results1['form_name']),0,5) == 'camos') { // deal with camos
			$query2 = sqlStatement("select category,content from form_CAMOS where id = " .
			    	$results1['form_id']);	
	                if ($results2 = mysql_fetch_array($query2, MYSQL_ASSOC)) {
				$content = $results2['content'];
				if ($results2['category'] == 'exam') {
					array_push($dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['exam'],$content);
				}
				elseif ($results2['category'] == 'prescriptions') {
					$tmphold = preg_replace("/\n+/",' ',$content); 
//					$tmphold = $content;
					array_push($dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['prescriptions'], $tmphold);
				}
				elseif ($results2['category'] == 'communications') {
					//do nothing
				}
				else {
					if (!$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['other'][$results2['category']]) {
						$dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['other'][$results2['category']] = array();
					}
					array_push($dates[$results1['datekey']][$results1['pid'].'_'.$results1['enc']]['other'][$results2['category']],
						preg_replace(array("/\n+/"),array(' '),$content));
				}
			}
		}
	}
	return $dates;
}
function formatVitals($raw) { //pass raw vitals array, format and return as string
	$height = '';
	$weight = '';
	$bmi = '';
	$temp= '';
	$bp = '';
	$pulse = '';
	$respiration = '';
	$oxygen_saturation = '';
	if ($raw['height'] && $raw['height'] > 0) {
		$height = "HT: ".$raw['height']." ";
	}
	if ($raw['weight'] && $raw['weight'] > 0) {
		$weight = "WT: ".$raw['weight']." ";
	}
	if ($raw['BMI'] && $raw['BMI'] > 0) {
		$bmi = "BMI: ".$raw['BMI']." ";
	}
	if ($raw['temperature'] && $raw['temperature'] > 0) {
		$temp = "Temp: ".$raw['temperature']." ";
	}
	if ($raw['bps'] && $raw['bpd'] && $raw['bps'] > 0 && $raw['bpd'] > 0) {
		$bp = "BP: ".$raw['bps']."/".$raw['bpd']." ";
	}
	if ($raw['pulse'] && $raw['pulse'] > 0) {
		$pulse = "Pulse: ".$raw['pulse']." ";
	}
	if ($raw['respiration'] && $raw['respiration'] > 0) {
		$respiration = "Respiration: ".$raw['respiration']." ";
	}
	if ($raw['oxygen_saturation'] && $raw['oxygen_saturation'] > 0) {
		$oxygen_saturation = "O2 Sat: ".$raw['oxygen_saturation']."% ";
	}
	$ret = $height.$weight.$bmi.$temp.$bp.
		$pulse.$respiration.$oxygen_saturation;
	if ($ret != '') {
		$ret = "Vital Signs: ".$ret;
	}
	return $ret;
}

function getDateOldEncounter($pid, $num) { 
	//Given $num, return the date of the encounter $num encounters back or the oldest if it is less
	if ($num<1) {
		$num = 1;
	}
        $stepback = $num;
        $tmp = sqlQuery("SELECT max(encounter) as max FROM forms " .
          "where form_name like 'CAMOS%' and pid=$pid");
        $last_encounter_id = $tmp['max'] ? $tmp['max'] : 0;
        for ($i=0;$i<$stepback-1;$i++) {
          $tmp = sqlQuery("SELECT max(encounter) as max FROM forms where encounter < " .
            $last_encounter_id . " and form_name like 'CAMOS%' and pid=$pid");
	  if (!isset($tmp['max'])) {
	    break;
	  }
          $last_encounter_id = $tmp['max'] ? $tmp['max'] : 0;
        }
        $tmp = sqlQuery("SELECT onset_date as date from form_encounter where encounter=$last_encounter_id " .
		"and pid=$pid");
	return $tmp['date'] ? $tmp['date'] : '';
}
