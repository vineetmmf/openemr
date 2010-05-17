<?php
include_once("../../globals.php");
include_once($GLOBALS["srcdir"]."/api.inc");
function misc_billing_options_report( $pid, $encounter, $cols, $id) {
$count = 0;
$data = formFetch("form_misc_billing_options", $id);
if ($data) {
print "<table>";
foreach($data as $key => $value) {
if ($key == "id" || $key == "pid" || $key == "user" || $key == "groupname" || $key == "authorized" || $key == "activity" || $key == "date" || $value == "" || $value == "0" || $value == "0000-00-00 00:00:00" || $value =="0000-00-00") {
	continue;
} else if ($key == 'pa_id') {
	if ($value !== NULL && !empty($value)) {
		$value = (integer) $value;

		$sql  = 'SELECT pa_number';
		$sql .=  ' FROM prior_auth';
		$sql .= " WHERE pa_id = $value";
		$sql .= ';';

		$resource = sqlStatement($sql);
		$row = sqlFetchRow($resource);

		if ($row === FALSE) {
			$pa_number = xl('Missing or Invalid');
		}
?>
<tr><td>
	<span class='bold'><?php htmlspecialchars(xl('Prior Authorization Number'), ENT_NOQUOTES); ?>: </span>
	<span class='text'><?php htmlspecialchars($pa_number, ENT_NOQUOTES); ?></span>
</td></tr>
<?php
	}
	continue;
}
print "<tr>";
if ($value == "1") {
$value = "yes"; 
}

$key=ucwords(str_replace("_"," ",$key));
print "<td><span class=bold>$key: </span><span class=text>$value</span></td>";
$count++;
if ($count == $cols) {
$count = 0;
print "</tr>\n";
}
}
print "</table>";
}
}
?> 
