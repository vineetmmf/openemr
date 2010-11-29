<?php
include_once ('../../globals.php'); 
?>
<?php
if ($_POST['export']) {
	$temp = tmpfile();
	if ($temp === false) {echo "<h1>failed!</h1>";}
	else {
		$query1 = "select id, category from form_CAMOS_category";
		$statement1 = sqlStatement($query1);
		while ($result1 = sqlFetchArray($statement1)) {
		        $tmp = $result1['category'];
		        $tmp = "<category>$tmp</category>"."\n";
		        fwrite($temp, $tmp);
		        $query2 = "select id,subcategory from form_CAMOS_subcategory where category_id=".$result1['id'];
		        $statement2 = sqlStatement($query2);
		        while ($result2 = sqlFetchArray($statement2)) {
		                $tmp = $result2['subcategory'];
		                $tmp = "<subcategory>$tmp</subcategory>"."\n";
		                fwrite($temp, $tmp);
		                $query3 = "select item, content from form_CAMOS_item where subcategory_id=".$result2['id'];
		                $statement3 = sqlStatement($query3);
		                while ($result3 = sqlFetchArray($statement3)) {
		                        $tmp = $result3['item'];
		                        $tmp = "<item>$tmp</item>"."\n";
		                        fwrite($temp, $tmp);
		                        $tmp = preg_replace(array("/\n/","/\r/"),array("\\\\n","\\\\r"),$result3['content']);
		                        $tmp = "<content>$tmp</content>"."\n";
		                        fwrite($temp, $tmp);
		                }
		        }
		}
		rewind($temp);
	        header("Pragma: public");
	        header("Expires: 0");
	        header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
		header("Content-Type: text/plain");
	        header("Content-Disposition: attachment; filename=\"CAMOS_export.txt\"");
	
		fpassthru($temp);
		fclose($temp);
	}
}
if ( ($_POST['import1']) || ($_POST['import2']) ||  ($_POST['import3'])) {
	$import_mode = 1; //merge - the safest option
	if ($_POST['import2']) {$import_mode = 2;} //destructive merge - merge column data but overwrite content of identical items
	if ($_POST['import3']) {$import_mode = 3;} //full destructive import- clear all data before starting import
	$fname = '';
	foreach($_FILES as $file) {
		$fname = $file['tmp_name'];
	}
	$string = file_get_contents($fname);
	if ($string === false) {
		echo "<h1>Error opening uploaded file for reading.</h1>";
	} else {
		//Start import
		if ($import_mode == 3) { //full destructive import, remove all column data first
			$query = "delete from form_CAMOS_category";
			sqlInsert($query);
			$query = "delete from form_CAMOS_subcategory";
			sqlInsert($query);
			$query = "delete from form_CAMOS_item";
			sqlInsert($query);
		}
		$strings = array();
		if (preg_match_all('/<.*?>.*?<\/.*?>/s',$string,$matches,PREG_SET_ORDER)) {
			foreach($matches as $v) {
				array_push($strings,$v[0]);
			}	
		}
		$category = '';
		$category_id = 0;
		$subcategory = '';
		$subcategory_id = 0;
		$item = '';
		$item_id = 0;
		$content = '';
		foreach($strings as $buffer) {
//			$buffer = preg_replace("/[^\\\]\n/","\\\\n",$buffer);
//			$buffer = preg_replace("/[^\\\]\r/","\\\\n",$buffer);
			$buffer = preg_replace('/\n/',' ',$buffer);
			$buffer = preg_replace('/\r/',' ',$buffer);
			if (preg_match('/<category>(.*?)<\/category>/',$buffer,$matches)) {

				$category = addslashes(trim($matches[1])); //trim in case someone edited by hand and added spaces
				$statement = sqlStatement("select id from form_CAMOS_category where category like \"$category\"");
				if ($result = sqlFetchArray($statement)) {
					$category_id = $result['id'];
				} else {
					$query = "INSERT INTO form_CAMOS_category (user, category) ". 
						"values ('".$_SESSION['authUser']."', \"$category\")"; 
					sqlInsert($query);
					$statement = sqlStatement("select id from form_CAMOS_category where category like \"$category\"");
					if ($result = sqlFetchArray($statement)) {
						$category_id = $result['id'];
					}
				}
			}
			if (preg_match('/<subcategory>(.*?)<\/subcategory>/',$buffer,$matches)) {

				$subcategory = addslashes(trim($matches[1]));
				$statement = sqlStatement("select id from form_CAMOS_subcategory where subcategory " .
					"like \"$subcategory\" and category_id = $category_id");
				if ($result = sqlFetchArray($statement)) {
					$subcategory_id = $result['id'];
				} else {
					$query = "INSERT INTO form_CAMOS_subcategory (user, subcategory, category_id) ". 
						"values ('".$_SESSION['authUser']."', \"$subcategory\", $category_id)"; 
					sqlInsert($query);
					$statement = sqlStatement("select id from form_CAMOS_subcategory where subcategory " .
						"like \"$subcategory\" and category_id = $category_id");
					if ($result = sqlFetchArray($statement)) {
						$subcategory_id = $result['id'];
					}
				}
			}
			if ((preg_match('/<(item)>(.*?)<\/item>/',$buffer,$matches)) || 
			(preg_match('/<(content)>(.*?)<\/content>/s',$buffer,$matches))) {

				$mode = $matches[1];
				$value = addslashes(trim($matches[2]));
				$insert_value = '';
				if ($mode == 'item') {
					$postfix = 0;
					$statement = sqlStatement("select id from form_CAMOS_item where item like \"$value\" " .
						"and subcategory_id = $subcategory_id");
					if (($result = sqlFetchArray($statement)) && ($import_mode == 1)) {//let's count until we find a number available
						$postfix = 1;
						$inserted_duplicate = false;
						while ($inserted_duplicate === false) {
							$insert_value = $value."_".$postfix;
							$inner_statement = sqlStatement("select id from form_CAMOS_item " .
								"where item like \"$insert_value\" " .
								"and subcategory_id = $subcategory_id");
							if (!($inner_result = sqlFetchArray($inner_statement))) {//doesn't exist
								$inner_query = "INSERT INTO form_CAMOS_item (user, item, subcategory_id) ". 
									"values ('".$_SESSION['authUser']."', \"$insert_value\", ".
									"$subcategory_id)"; 
								sqlInsert($inner_query);
								$inserted_duplicate = true;
							} else {$postfix++;}
						}
					} else {
						$query = "INSERT INTO form_CAMOS_item (user, item, subcategory_id) ". 
							"values ('".$_SESSION['authUser']."', \"$value\", $subcategory_id)"; 
						sqlInsert($query);
					}
					if ($postfix == 0) {$insert_value = $value;}
					$statement = sqlStatement("select id from form_CAMOS_item where item like \"$insert_value\" " .
						"and subcategory_id = $subcategory_id");
					if ($result = sqlFetchArray($statement)) {
						$item_id = $result['id'];
					}
				}
				elseif ($mode == 'content') {
					$statement = sqlStatement("select content from form_CAMOS_item where id = ".$item_id);
					if ($result = sqlFetchArray($statement)) {
						//$content = "/*old*/\n\n".$result['content']."\n\n/*new*/\n\n$value";
						$content = $value;
					} else {
						$content = $value;
					}
					$query = "UPDATE form_CAMOS_item set content = \"$content\" where id = ".$item_id;
					sqlInsert($query);
				}
			}
		}
	}
}
?>
<html>
<head>
<title>
admin
</title>
</head>
<body>
<p>
Click 'export' to export your Category, Subcategory, Item, Content data to a text file.  Any resemblance of this file to an XML file is 
purely coincidental.  For now, opening and closing tags must be on the same line, they must be lowercase with no spaces.  To import, browse
for a file and click 'import'.  If the data is completely different, it will merge with your existing data.  If there are similar item names,
The old one will be kept and the new one saved with a number added to the end.  This feature is very experimental and not fully tested.  Use at your own risk!
</p>
<form enctype="multipart/form-data" method="POST">
<input type="hidden" name="MAX_FILE_SIZE" value="12000000" />
Send this file: <input type="file" name="userfile"/>
<input type="submit" value="merge import" name="import1"/>
<input type="submit" value="destructive merge import" name="import2"/>
<input type="submit" value="destructive import" name="import3"/>
<input type="submit" value="export" name="export"/>
</form>
</body>
</html>
