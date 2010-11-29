<?php
$default_limit = 25;
$max_limit = 500;
$limit = "limit $default_limit";
include_once("../../globals.php");
$clone_category = '';
$clone_subcategory = '';
$clone_item = '';
$clone_content = '';
$clone_data1 = '';
$clone_data2 = '';
$clone_data_array = array();
if (substr($_POST['hidden_mode'],0,5) == 'clone') {
  $clone_category = $_POST['category'] ? $_POST['category'] : '';
  $clone_category_term = '';
}
if ($clone_category != '') {
  $clone_category_term = " where category like '".$clone_category."'";
}
$clone_subcategory = $_POST['subcategory'] ? $_POST['subcategory'] : '';
$clone_subcategory_term = '';
if ($clone_subcategory != '') {
  $clone_subcategory_term = " and subcategory like '".$_POST['subcategory']."'";
}
$clone_item = $_POST['item'] ? $_POST['item'] : '';
$clone_item_term = ''; 
if ($clone_item != '') {
  $clone_item_term = " and item like '".$_POST['item']."'";
}
$clone_search = trim($_POST['clone_others_search']);

$name_data_flag = false; //flag to see if we are going to use patient names in search result of clone others.
$show_phone_flag = false; //if we do show patient names, flag to see if we show phone numbers too
$pid_clause = ''; //if name search, will return a limited list of names to search for.
if (strpos($clone_search, "::") !== false) {
  $name_data_flag = true;
  $show_phone_flag = true;
  $split = preg_split('/\s*::\s*/', $clone_search);
  if (preg_match('/^(\d+)(.*)/',$split[0],$matches)) {
	  $limit = "limit ".$matches[1];
	  if ($matches[1] == 0) {$limit = "limit $default_limit";}
	  if ($matches[1] > $max_limit) {$limit = "limit $max_limit";}
	  $split[0] = $matches[2];
  }
  $clone_search = $split[1];
  $pid_clause = searchName($split[0]);
}
elseif (strpos($clone_search, ":") !== false) {
  $name_data_flag = true;
  $split = preg_split('/\s*:\s*/', $clone_search);
  if (preg_match('/^(\d+).*/',$split[0],$matches)) {
	  $limit = "limit ".$matches[1];
	  if ($matches[1] == 0) {$limit = "limit $default_limit";}
	  if ($matches[1] > $max_limit) {$limit = "limit $max_limit";}
	  $split[0] = $matches[2];
  }
  $clone_search = $split[1];
  $pid_clause = searchName($split[0]);
}

$clone_search_term = '';
if ($clone_search != '') {
  $clone_search =  preg_replace('/\s+/', '%', $clone_search);
  if (substr($clone_search,0,1) == "`") {
    $clone_subcategory_term = '';      
    $clone_item_term = '';      
    $clone_search = substr($clone_search,1);
  }
  $clone_search_term = " and content like '%$clone_search%'"; 
}
if (substr($_POST['hidden_mode'],0,12) == 'clone others') { //clone from search box
	if (substr($clone_search,0,1) == '.') {
		$clone_data_array[rx_parser($clone_search)] = rx_parser($clone_search);
	} else {
		
		if (preg_match('/^(export)(.*)/',$clone_search,$matches)) { 
			$query1 = "select id, category from form_CAMOS_category";
			$statement1 = sqlStatement($query1);
		        while ($result1 = sqlFetchArray($statement1)) {
				$tmp = $result1['category'];
				$tmp = "/*import::category::$tmp*/"."\n";
				$clone_data_array[$tmp] = $tmp;
				$query2 = "select id,subcategory from form_CAMOS_subcategory where category_id=".$result1['id'];
				$statement2 = sqlStatement($query2);
				while ($result2 = sqlFetchArray($statement2)) {
					$tmp = $result2['subcategory'];
					$tmp = "/*import::subcategory::$tmp*/"."\n";
					$clone_data_array[$tmp] = $tmp;
					$query3 = "select item, content from form_CAMOS_item where subcategory_id=".$result2['id'];
					$statement3 = sqlStatement($query3);
					while ($result3 = sqlFetchArray($statement3)) {
						$tmp = $result3['item'];
						$tmp = "/*import::item::$tmp*/"."\n";
						$clone_data_array[$tmp] = $tmp;
						$tmp = $result3['content'];
						$tmp = "/*import::content::$tmp*/"."\n";
						$clone_data_array[$tmp] = $tmp;
					}
				}
			}
			$clone_data_array = array();
		}
		elseif ((preg_match('/^(billing)(.*)/',$clone_search,$matches)) || 
			(preg_match('/^(codes)(.*)/',$clone_search,$matches)) || 
			(preg_match('/^(short.billing)(.*)/',$clone_search,$matches)) || 
			(preg_match('/^(short.codes)(.*)/',$clone_search,$matches))) { 
			$short_mode = false;
			$table = $matches[1];
			if (substr($table,0,5) == 'short') {
				$short_mode = true;
				$table = substr($table,6);
			}
			$line = $matches[2];
			$line = '%'.trim($line).'%';
			$search_term = preg_replace('/\s+/','%',$line);
			$query = '';
			if ($table == 'codes') {
	        		$query = "SELECT * FROM codes WHERE ".
					"code_text like '$search_term' $limit";
//					"t1.code_text like '$search_term' $limit";
			} else {// table is billing
	        		$query = "SELECT * FROM billing WHERE ".
					"code_text like '$search_term' $limit";
			}
			$statement = sqlStatement($query);
		        while ($result = sqlFetchArray($statement)) {
				$code_type = $result['code_type'];
				if ($code_type == 1) {$code_type = 'CPT4';}
				if ($code_type == 2) {$code_type = 'ICD9';}
				if ($code_type == 3) {$code_type = 'OTHER';}
				$code = $result['code'];
				$code_text = $result['code_text'];
				$modifier = $result['modifier'];
				$units = $result['units'];
				$fee = $result['fee'];
				if (!$fee and $table == 'codes') {
					$statement2 = sqlStatement("Select pr_price from prices where pr_selector " .
						"like '' and pr_level like 'standard' and pr_id = ".$result['id']);
		        		if ($result2 = sqlFetchArray($statement2)) {
						$fee = $result2['pr_price'];
					}
				}
				$tmp = "/*billing::$code_type::$code::$code_text::$modifier::$units::$fee*/";
				if ($short_mode) {
					$tmp = "/*billing::$code_type::$code*/";
				}
    		        $clone_data_array[$tmp] = $tmp;  
			}
		} else {
		      //$clone_data_array['others'] = '/*'.$clone_category.'::'.$clone_subcategory.'::'.
		      //  $clone_item.'*/'; 
		      //See the two lines commented out just below:
		      //I am trying out searching all content regardless of category, subcategory, item...
		      //because of this, we have to limit results more.  There may be a few lines
		      //above that should be deleted if this becomes the normal way of doing these searches.
			//Consider making the two queries below by encounter instead of camos id.
			//This may be a little tricky.
		      if ($_POST['hidden_mode'] == 'clone others selected') { //clone from search box
			      $query = "select id, category, subcategory, item, content from form_CAMOS" .
			              $clone_category_term.$clone_subcategory_term.$clone_item_term.
				      $clone_search_term.$pid_clause." order by id desc $limit";
		      } else {
			      $query = "select id, category, subcategory, item, content from form_CAMOS" .
				  " where " . 
				  //"category like '%$clone_search%' or" .
			          //" subcategory like '%$clone_search%' or" .
			          //" item like '%$clone_search%' or" .
				  " content like '%$clone_search%'".$pid_clause." order by id desc $limit";
		      }
		      $statement = sqlStatement($query);
		      while ($result = sqlFetchArray($statement)) {
		        $tmp = '/*camos::'.$result['category'].'::'.$result['subcategory'].
		          '::'.$result['item'].'::'.$result['content'].'*/';  
		        if ($name_data_flag === true) {
                          $tmp = getMyPatientData($result['id'],$show_phone_flag)."\n$break\n".$tmp;
                        }
		        $key_tmp = preg_replace('/\W+/','',$tmp);
		        $key_tmp = preg_replace('/\W+/','',$tmp);
		        //$clone_data_array[$key_tmp] = $tmp;  
		        $clone_data_array['others_'.$result['id']] = $tmp;  
		      }
		}
	}
} else {//end of clone others
	    $query = "SELECT date(date) as date, subcategory, item, content FROM form_CAMOS WHERE category like '".
		    $clone_category."' and pid=".$_SESSION['pid']." order by id desc"; 

	    //
	    // CLONE LAST VISIT ->
	    //
	    // This is where we pull up the camos entries, vitals and billing codes from the previous visit(s)
	    //
	    //

  $user = $_SESSION['authUser']; //multiuser support. clone last visit only for the current user.
  if ($_POST['hidden_mode'] == 'clone last visit') {
    //go back $stepback # of encounters...
	//This has been changed to clone last visit based on actual last encounter rather than as it was
	//only looking at most recent BILLED encounters.  To go back to billed encounters, change the following
	//two queries to the 'billing' table rather than form_encounter and make sure to add in 'and activity=1'
	//OK, now I have tried tracking last encounter from billing, then form_encounter.  Now, we are going to
	//try from forms where form_name like 'CAMOS%' so we will not bother with encounters that have no CAMOS entries...
    $stepback = $_POST['stepback'] ? $_POST['stepback'] : 1;
    $tmp = sqlQuery("SELECT max(encounter) as max FROM forms where user like '$user' and encounter < " .
      $_SESSION['encounter'] . " and form_name like 'CAMOS%' and pid= " . $_SESSION['pid']);
    $last_encounter_id = $tmp['max'] ? $tmp['max'] : 0;
    for ($i=0;$i<$stepback-1;$i++) {
      $tmp = sqlQuery("SELECT max(encounter) as max FROM forms where user like '$user' and encounter < " .
        $last_encounter_id . " and form_name like 'CAMOS%' and pid= " . $_SESSION['pid']);
      $last_encounter_id = $tmp['max'] ? $tmp['max'] : 0;
    }
    $query = "SELECT form_CAMOS.id,category, subcategory, item, content FROM form_CAMOS " .
      "join forms on (form_CAMOS.id = forms.form_id) where " . 
      "forms.encounter = '$last_encounter_id' and form_CAMOS.pid=" .
      $_SESSION['pid']." order by form_CAMOS.id"; 
  }
  $statement = sqlStatement($query);
  while ($result = sqlFetchArray($statement)) {
    if (preg_match('/^[\s\r\n]*$/',$result['content']) == 0) {
      if ($_POST['hidden_mode'] == 'clone last visit') {
        $clone_category = $result['category'];
      }
      $clone_subcategory = $result['subcategory'];
      $clone_item = $result['item'];
      $clone_content = $result['content'];
      $clone_id = $result['id'];
      $clone_data1 = "/* camos :: $clone_category :: $clone_subcategory :: $clone_item :: ";
      $clone_data2 = "$clone_content */";
      $clone_data3 = $clone_data1 . $clone_data2;
      if ($_POST['hidden_mode'] == 'clone last visit') {
//        $clone_data1 = $clone_data3; //make key include whole entry so all 'last visit' data gets recorded and shown
        $clone_data1 = 'lv_'.$clone_id; //make key include whole entry so all 'last visit' data gets recorded and shown
      }
      if (!$clone_data_array[$clone_data1]) { //if does not exist, don't overwrite.
        $clone_data_array[$clone_data1] = "";
//        if ($_POST['hidden_mode'] == 'clone') {
        if (1) {
          $clone_data_array[$clone_data1] = "/* ------  ".$result['date']."  --------- */\n"; //break between clone items
        }
        $clone_data_array[$clone_data1] .= $clone_data3;
      }
    }
  }
  if ($_POST['hidden_mode'] == 'clone last visit') {
// clone vitals from last visit deprecated because not compatible with multiuser
//    $query = "SELECT t1.* FROM form_vitals as t1 join forms as t2 on (t1.id = t2.form_id) WHERE t2.encounter = '$last_encounter_id' and t1.pid=".$_SESSION['pid']." and t2.form_name like 'Vitals'"; 
//    $statement = sqlStatement($query);
//    if ($result = sqlFetchArray($statement)) {
//		$weight = $result['weight'];
//		$height = $result['height'];
//		$bps = $result['bps'];
//		$bpd = $result['bpd'];
//		$pulse = $result['pulse'];
//		$temperature = $result['temperature'];
//          	$clone_vitals = "/* vitals_key:: weight :: height :: systolic :: diastolic :: pulse :: temperature */\n"; 
//     	$clone_vitals = ""; 
//      	$clone_vitals .= "/* vitals\n :: $weight\n :: $height\n :: $bps\n :: $bpd\n :: $pulse\n :: $temperature\n */"; 
//      	$clone_data_array[$clone_vitals] = $clone_vitals; //commented out for now because I don't want vitals cloned
//	}
    $query = "SELECT code_type, code, code_text, modifier, units, fee FROM billing WHERE encounter = '$last_encounter_id' and pid=".$_SESSION['pid']." and activity=1 order by id"; 
    $statement = sqlStatement($query);
    while ($result = sqlFetchArray($statement)) {
      $clone_code_type = $result['code_type'];
      $clone_code = $result['code'];
      $clone_code_text = $result['code_text'];
      $clone_modifier = $result['modifier'];
      $clone_units = $result['units'];
      $clone_fee = $result['fee'];
      $clone_billing_data = "/* billing :: $clone_code_type :: $clone_code :: $clone_code_text :: $clone_modifier :: $clone_units :: $clone_fee */"; 
      $clone_data_array[$clone_billing_data] = $clone_billing_data;
    }
  }
} //end else (not clone others)
foreach($clone_data_array as $k => $v) {
  print $v."\n";
}
	    //
	    // END OF: CLONE LAST VISIT ->
	    //

function searchName($string) { //match one or more names and return clause for query of pids
  $string = trim($string);
  if ($string == 'this') {
    return " and (pid = ".$_SESSION['pid'].") ";    
  }
  global $limit;
  $ret = '';
  $data = array();
  $fname = '';
  $lname = '';
  if ($string == '') {return $ret;}
  $split = preg_split('/\s+/',$string);
  $name1 = $split[1];
  $name2 = $split[0];
  if ($name1 != '') {$name1 = "%".$name1."%";}
  if ($name2 != '') {$name1 = "%".$name2."%";}
  $query = sqlStatement("select pid from patient_data where fname like '$name1' or fname like '$name2' or " .
    "lname like '$name1' or lname like '$name2' $limit");
  while ($results = mysql_fetch_array($query, MYSQL_ASSOC)) {
    array_push($data,$results['pid']);
  }
  if (count($data) > 0) {
    $ret = join(" or pid = ",$data); 
    $ret = " and (pid = ".$ret.") ";
  }
  return $ret;
}
function getMyPatientData($form_id, $show_phone_flag) {//return a string of patient data and encounter data based on the form_CAMOS id
  $ret = '';
  $name = '';
  $dob = '';
  $enc_date = '';
  $phone_list = '';
  $pid = '';
  $query = sqlStatement("select t1.pid, t2.encounter, t1.fname, t1.mname, t1.lname, " .
    "t1.phone_home, t1.phone_biz, t1.phone_contact, t1.phone_cell, " .
    "date_format(t1.DOB,'%m-%d-%y') as DOB, date_format(t2.date,'%m-%d-%y') as date, " .
    "datediff(current_date(),t2.date) as days " .
    "from patient_data as t1 join forms as t2 on (t1.pid = t2.pid) where t2.form_id=$form_id " .
    "and form_name like 'CAMOS%'");
  if ($results = mysql_fetch_array($query, MYSQL_ASSOC)) {
    $pid = $results['pid'];
    $fname = $results['fname'];
    $mname = $results['mname'];
    $lname = $results['lname'];
    if ($mname) {$name = $fname.' '.$mname.' '.$lname;}
    else {$name = $fname.' '.$lname;}
    $dob = $results['DOB'];
    $enc_date = $results['date'];
    $enc = $results['encounter'];
    $days_ago = $results['days'];
    $phone_list = 
      "/* Home: ".$results['phone_home']." | ".	
      "Cell: ".$results['phone_cell']." | ".
      "Bus: ".$results['phone_biz']." | ".	
      "Contact: ".$results['phone_contact']." */";
  }
  $ret = "/*$pid, $enc, $name, DOB: $dob, Enc: $enc_date, $days_ago days ago. */";
  if ($show_phone_flag === true) {
    $ret .= "\n".$phone_list;
  }
  return $ret;
}
function rx_parser($str) {
	$ret  = "/* ######################################### */\n";
	$ret .= "/* ###### AUTO PRESCRIPTION GENERATOR ###### */\n";
	$ret .= "/* ######################################### */\n\n";
	$strings = explode('/',$str);
	foreach ($strings as $string) {
		$do_not_fill = '';
		if (preg_match("/f(\d+)/",$string, $matches)) {
			$days = $matches[1];
			$query = "select date_format(date_add(date, interval $days day),'%W, %m-%d-%Y') " .
				"as date from form_encounter where " . "pid = " . 
				$_SESSION['pid'] . " and encounter = " . $_SESSION['encounter']; 
			$statement = sqlStatement($query);
			if ($result = sqlFetchArray($statement)){ 
				$do_not_fill = "DO NOT FILL UNTIL ".$result['date'].".\n";
			}
		}
		elseif (preg_match("/f(\w+)/",$string, $matches)) {
			$date = DayToDate($matches[1]);
			$do_not_fill = "DO NOT FILL UNTIL ".$date.".\n";
		}
		$fields = explode('.',$string);
	//	$fields = preg_split('/[\.\s+]/',$string);
		array_shift($fields);
		if (preg_match("/^([rdpP])(\d*)/",$fields[0],$matches)) {
			$drugname1 = 'roxicodone';
			$drugname2 = 'Roxicodone ';
			if ($matches[1] == 'd') {$drugname1 = 'dilaudid';$drugname2 = 'Dilaudid ';}
			if ($matches[1] == 'p') {$drugname1 = 'percocet';$drugname2 = 'Percocet 10/325 ';}
			if ($matches[1] == 'P') {$drugname1 = 'percocet';$drugname2 = 'Percocet 10/650 ';}
			array_shift($fields);
			if ($fields[0] && !$fields[1] && !$fields[2]) {
				$fields[2] = $fields[0];
				$fields[0] = 30;
				if ($matches[1] == 'd') {$fields[0] = '4';}
				if (strtolower($matches[1]) == 'p') {$fields[0] = '';}
			} else {
				if (!$fields[0]) {$fields[0] = 30;}
				if (!$fields[1]) {$fields[1] = 180;}
				if (!$fields[2]) {$fields[2] = '1';}
				if ($matches[1] == 'd') {$fields[0] = '4';$fields[2] = '2-4';}
				if (strtolower($matches[1]) == 'p') {$fields[0] = '';$fields[1] = '120';$fields[2] = '1';}
			}
			if ($matches[2]) {
				$fields[1] = $matches[2];
			}
			$ret .= "/*camos::prescriptions::analgesics::$drugname1::\n\n$drugname2".$fields[0]."mg\n\n" .
				"#".$fields[1]."\n\n".
				"take ".$fields[2]." tablet by mouth q4-6 hrs prn pain.\n" .
				"$do_not_fill*/\n";
				
		}
		if (preg_match("/^([vx])(\d*)/",$fields[0],$matches)) {
			$drugname1 = 'xanax';
			$drugname2 = 'Xanax ';
			if ($matches[1] == 'v') {$drugname1 = 'valium';$drugname2 = 'valium ';}
			array_shift($fields);
			if ($matches[2]) {
				$fields[0] = '2'; 
				if ($matches[1] == 'v') {$fields[0] = '10';}
				$fields[1] = $matches[2];
				if ($fields[1] <= 21) {$fields[2] = '1/2 to 1 tablet by mouth once daily as needed for anxiety.';}
				elseif ($fields[1] <= 42) {$fields[2] = '1/2 to 1 tablet by mouth twice daily as needed for anxiety.';}
				elseif ($fields[1] <= 63) {$fields[2] = '1/2 to 1 tablet by mouth three times daily as needed for anxiety.';}
				elseif ($fields[1] > 63) {$fields[2] = '1/2 to 1 tablet by mouth four times daily as needed for anxiety.';}
			}
			$ret .= "/*camos::prescriptions::anxiolytic::$drugname1::\n\n$drugname2".$fields[0]."mg\n\n" .
				"#".$fields[1]."\n\n".
				"take ".$fields[2]."\n" .
				"$do_not_fill*/\n";
				
		}
		if (preg_match("/^([om])(\d*)/",$fields[0],$matches)) {
			$drugname1 = 'Oxycontin';
			$drugname2 = 'Oxycontin ';
			if ($matches[1] == 'm') {$drugname1 = 'MS Contin';$drugname2 = 'MS Contin ';}
			array_shift($fields);
			if ($matches[2]) {
				if ($matches[1] == 'm' && substr($matches[2],0,3) == 100) {
					$fields[0] = substr($matches[2],0,3); 
					$fields[1] = substr($matches[2],3); 
				} else {
					$fields[0] = substr($matches[2],0,2); 
					$fields[1] = substr($matches[2],2); 
				}
				//if ($fields[1] <= 21) {$fields[2] = '1 tablet by mouth at bedtime for pain.';}
				//elseif ($fields[1] <= 42) {$fields[2] = '1 tablet by mouth every 12 hours for pain.';}
				if ($fields[1] <= 42) {$fields[2] = '1 tablet by mouth every 12 hours for pain.';}
				elseif ($fields[1] <= 63) {$fields[2] = '1 tablet by mouth every 8 hours for pain.';}
				elseif ($fields[1] == 90) {$fields[2] = '1 tablet by mouth every 8 hours for pain.';}
			}
			$ret .= "/*camos::prescriptions::analgesics::$drugname1::\n\n$drugname2".$fields[0]."mg\n\n" .
				"#".$fields[1]."\n\n".
				"take ".$fields[2]."\n" .
				"DO NOT CRUSH OR CHEW.\n" .
				"$do_not_fill*/\n";
				
		}
	}
	return $ret;
}
function DayToDate($dayname) {
//	$dayname_array = ('sun' => 'sunday', 'mon' => 'monday', 'tues' = 'tuesday', 'wed' => 'wednesday',
//				'thu' => 'thursday', 'fri' => 'friday', 'sat' => 'saturday');
	$date_array = array();
	for ($i=1;$i<8;$i++) {
		$query = "select date_format(date_add(date, interval $i day),'%W, %m-%d-%Y') " .
			"as date from form_encounter where " . "pid = " . 
			$_SESSION['pid'] . " and encounter = " . $_SESSION['encounter']; 
		$statement = sqlStatement($query);
		if ($result = sqlFetchArray($statement)){ 
			array_push($date_array,$result['date']);
		}
	}
	foreach($date_array as $date) {
		if (strpos(strtolower($date),$dayname) !== false) {
			return $date;
		}
	}
}
?>
