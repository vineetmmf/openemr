<?php
include_once("../../globals.php");
$table_array = array();
$query = sqlStatement("select item, content from form_camos_item where item like '.%' order by item");
while ($results = mysql_fetch_array($query, MYSQL_ASSOC)) {
		array_push($table_array, array('item' => $results['item'], 'content' => $results['content']));
}
include_once ('../../../library/classes/class.ezpdf.php');
$pdf =& new Cezpdf();
$pdf->selectFont('../../../library/fonts/Helvetica');
$pdf->ezSetCmMargins(1,1,1,1);
$pdf->ezTable($table_array,'','',array('width'=>540));
$pdf->ezStream();
?>
