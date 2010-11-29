<?  include ('../../../interface/globals.php'); 
$preset_limit = 100;
$limit = 0;
?>
<html>
<head>
<title>
Search
</title>
</head>
<body>
<h1>Search</h1>
<form name=selector method=POST>
<input type=submit name=submit>
<table>
<tr>
<td>unique<input type=checkbox name=unique checked></td>
<td>limit<input length=7 type=text name=limit value='<? echo $_POST['limit'];?>'></td>
<td>pid<input length=4 type=text name=pid value='<? echo $_POST['pid'];?>'></td>
<td>category<input length=20 type=text name=category value='<? echo $_POST['category'];?>'></td>
<td>subcategory<input length=20 type=text name=subcategory value='<? echo $_POST['subcategory'];?>'></td>
<td>item<input length=20 type=text name=item value='<? echo $_POST['item'];?>'></td>
<td>content<input length=30 type=text name=content value='<? echo $_POST['content'];?>'></td>
</tr>
</table>
</form>
<hr>
<?
$unique = 0; // if flag set, only show each pid once.
$pid_array = array();
if ($_POST['unique'] == 'on') {
	$unique = 1;
}
if ($_POST['limit'] > 0) {
	$limit = $_POST['limit'];
} else {$limit = $preset_limit;
};
print("<h1> limit: $limit </h1>");
$pid = isset($_POST['pid']) ? $_POST['pid'] : 0;
$category = isset($_POST['category']) ? $_POST['category'] : '';
$subcategory = isset($_POST['subcategory']) ? $_POST['subcategory'] : '';
$item = isset($_POST['item']) ? $_POST['item'] : '';
$content = isset($_POST['content']) ? $_POST['content'] : '';
$content =  preg_replace('/\s+/', '%', $content);
if ($pid > 0) {
	$query = sqlStatement("select date_format(t2.date,'%m/%d/%Y') as date, t1.pid, t1.fname, t1.lname, t2.category, t2.subcategory, t2.item, t2.content from form_CAMOS as t2 join patient_data as t1 on (t1.pid=t2.pid) where t2.pid=$pid and category like '%$category%' and subcategory like '%$subcategory%' and item like '%$item%' and content like '%$content%' order by t2.date desc limit $limit");
} else { 
	$query = sqlStatement("select date_format(t2.date,'%m/%d/%Y') as date, t1.pid, t1.fname, t1.lname, t2.category, t2.subcategory, t2.item, t2.content from form_CAMOS as t2 join patient_data as t1 on (t1.pid=t2.pid) where category like '%$category%' and subcategory like '%$subcategory%' and item like '%$item%' and content like '%$content%' order by t2.date desc limit $limit");
}
	echo "<table border=1>";
$count=0;
while ($results = mysql_fetch_array($query, MYSQL_ASSOC)) {
	if ($unique == 1) {
		if (isset($pid_array[$results['pid']])) {
			continue;
		} else {
			$pid_array[$results['pid']]++;
		}
	}
	$count++;
	echo "<tr>";
	echo "<td>$count</td>";
	echo "<td>".$results['date']."</td>";
//	echo "<td>".$results['fname']." ".$results['lname']." (".$results['pid'].")</td>";
	echo "<td>".$results['category']."</td>";
	echo "<td>".$results['subcategory']."</td>";
	echo "<td>".$results['item']."</td>";
	echo "<td>".$results['content']."</td>";
	echo "</tr>";
}
	echo "</table>";
?>
</body>
</html>
