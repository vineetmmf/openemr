<?php
include_once ('../../globals.php'); 
?>
<html>
<head>
<title>
$_SESSION variable review
</title>
</head>
<body>
<table border=1>
<?php
$count = 0;
foreach ($_SESSION as $k => $v) {
	$count++;
	echo "<tr><td>$count</td><td>$k</td><td>$v</td></tr>\n";
}
?>
</table>
</body>
</html>
