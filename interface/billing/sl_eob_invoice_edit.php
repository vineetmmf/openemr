<?php ob_start();
  include_once("../globals.php");
  include_once("../../library/patient.inc");
  include_once("../../library/forms.inc");
  include_once("../../library/sl_eob.inc.php");
  include_once("../../library/invoice_summary.inc.php");
  include_once("../../custom/code_types.inc.php");
  
  $debug = 0; // set to 1 for debugging mode

  $INTEGRATED_AR = $GLOBALS['oer_config']['ws_accounting']['enabled'] === 2;

 ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<!--<title>Untitled Document</title>-->
</head>

<body bgcolor="#CCCCCC">
<?php 
$trans_id = 0 + $_GET['id'];
  if (! $trans_id) die(xl("You cannot access this page directly."));
  
  if($_GET['act'] == 'delete'){
  if($_GET['condition']=='charge' || $_GET['condition']=='copay'){
		
		$delete  = "delete FROM billing WHERE id='".$_REQUEST['mainid']."'"; 
	}
	else{
 		$delete = "delete from ar_activity where encounter= '".$_GET['ecid']."' AND sequence_no= '".$_GET['seqn']."' AND pid= '".$_GET['pid']."'";
	
	}
	 $qry1 = mysql_query($delete) or die(mysql_error());

	$msg =($qry1)? "Record Deleted Successfully":"not deleted";
header('location:sl_eob_invoice.php?id='.$_REQUEST['id'].'&msg='.$msg);
	}  
         
  
  
	//echo $INTEGRATED_AR;exit;
  if ($INTEGRATED_AR) {
    // In the Integrated A/R case, $trans_id matches form_encounter.id.
     $ferow = sqlQuery("SELECT e.*, p.fname, p.mname, p.id, p.lname " .
      "FROM form_encounter AS e, patient_data AS p WHERE " .
      "e.id = '$trans_id' AND p.pid = e.pid");
	  //$row=mysql_fetch_array($ferow);
	  //print_r($ferow); exit;
	  
	 
    if (empty($ferow)) die("There is no encounter with form_encounter.id = '$trans_id'.");
    $patient_id        = 0 + $ferow['pid'];
    $encounter_id      = 0 + $ferow['encounter'];
    $svcdate           = substr($ferow['date'], 0, 10);
    $form_payer_id     = 0 + $_POST['form_payer_id'];
    $form_reference    = $_POST['form_reference'];
    $form_check_date   = fixDate($_POST['form_check_date'], date('Y-m-d'));
    $form_deposit_date = fixDate($_POST['form_deposit_date'], $form_check_date);
    $form_pay_total    = 0 + $_POST['form_pay_total'];
	//print_r($ferow);
  }
  else {
    slInitialize();
  }
  if($_GET['act'] == 'edit'){
  
  	if($_GET['condition']=='charge'|| $_GET['condition']=='copay'){
		
		$tmp = sqlQuery("SELECT * FROM billing WHERE id='".$_REQUEST['billid']."' LIMIT 1");
		
		$date1 = substr($tmp['date'], 0, 10);
		
    	if (preg_match('/^(\d\d\d\d)(\d\d)(\d\d)\s*$/', $date1, $matches)) {
     		$date1 = $matches[1] . '-' . $matches[2] . '-' . $matches[3];
    	}  
	}
	else{
	
	  	$tmp = sqlQuery("SELECT * FROM ar_activity WHERE pid='".$_REQUEST['id']."' AND encounter='".$_REQUEST['ecid']."' AND sequence_no='".$_REQUEST['seqn']."' LIMIT 1");
		
		$sessiontemp=sqlQuery("select * from ar_session where session_id='".$tmp['session_id']."'");
		
		if($sessiontemp['deposit_date']!='')
		{
			$date1 = $sessiontemp['deposit_date'];
		}
		else {
		$date1 = substr($tmp['post_time'], 0, 10);
		
    	if (preg_match('/^(\d\d\d\d)(\d\d)(\d\d)\s*$/', $date1, $matches)) {
     		$date1 = $matches[1] . '-' . $matches[2] . '-' . $matches[3];
    		} 
		} 
	}	

	
	/*$ddate = substr($tmp['post_time'], 0, 10);
		
    	if (preg_match('/^(\d\d\d\d)(\d\d)(\d\d)\s*$/', $ddate, $matches)) {
     		$ddate = $matches[1] . '-' . $matches[2] . '-' . $matches[3];
    	} */
		
	}
	
	if($_REQUEST['act']=='update')	
	{
	if($_REQUEST['condition']=='charge' || $_REQUEST['condition']=='copay'){
	
		$charge=($_REQUEST['condition']=='copay')?(0-$_REQUEST['charge']):$_REQUEST['charge'];
		$timenew=(strftime('%X'));
		$datenew=$_REQUEST['date1'];
		$datetimenew=$datenew." ".$timenew;	
	  	$update="UPDATE  billing SET fee = ".$charge;
		if($_REQUEST['condition']=='copay')
			{$update.=" , date='".$datetimenew."'";}
		
		$update.= " WHERE id='".$_REQUEST['billid']."'";
	
	//echo $update;exit;
	}
	else{
		$timenew=(strftime('%X'));
		$datenew=$_REQUEST['date1'];
		$datetimenew=$datenew." ".$timenew;
		$memo=$_REQUEST['memo'];
		if($memo=="Ins adjust")
		{
			$nmemo=$memo.$_REQUEST['tmpinsurance'];
		}
		else
		{
			$nmemo=$memo;
		}
	 	$update="UPDATE  ar_activity SET post_time = '".$datetimenew."', pay_amount = '".$_REQUEST['pay']."', adj_amount = '".$_REQUEST['adjust']."', memo = '".$nmemo."' WHERE pid='".$_REQUEST['id']."' AND encounter='".$_REQUEST['ecid']."' AND sequence_no='".$_REQUEST['seqn']."'";
		
		$sessiontemp=sqlQuery("select * from ar_activity where pid='".$_REQUEST['id']."' AND encounter='".$_REQUEST['ecid']."' AND sequence_no='".$_REQUEST['seqn']."'");
		
		$updatesession="update ar_session set deposit_date = '".$datenew."' where session_id = '".$sessiontemp['session_id']."'";
	 	$tmpsessionupdate=mysql_query($updatesession) or die(mysql_error()."problem in updation");
	 
	 }
	
	 $tmp1=mysql_query($update) or die(mysql_error()."problem in updation");
	
	
	//$msg =($tmp1)? "Record updated Successfully":"not updated";
	if($tmp1)
	{
	echo $info_msg = "Record successfully updated";
	
	}
	else
	{
	echo $info_msg = "not updated";
	?>
	<?
	}
	echo "<html>\n<body>\n<script language='JavaScript'>\n";
  if ($info_msg) echo " alert('$info_msg');\n";
  echo " if (!opener.closed && opener.refreshme) opener.refreshme();\n";
  echo " window.close();\n";
  echo "</script>\n</body>\n</html>\n";
  exit();
	}
	
	
?>

<form action="sl_eob_invoice_edit.php?id=<?php echo $trans_id ?>" method="post" name="myform" >

<table width="50%" border="0" align="center">

 <tr>
    <td height="30" colspan="2"><strong>Update Invoice Data</strong></td>
    
  </tr>
  <!--<tr>
    <td height="34">Code</td>
    <td><input name="code" type="text" value="<?php echo $tmp['code']?>" /></td>
  </tr>-->
  <!--
  <tr>
    <td height="32">Charge</td>
    <td><input name="charge" type="text" value="<?php echo $tmp['fee']?>" /></td>
  </tr>
  <tr>
    <td height="33">Balance</td>
    <td><input name="balance" type="text" value="<?php echo $tmp['fee']?>" /></td>
  </tr>
  <tr>
    <td height="39">Source</td>
    <td>-->
<!--	<input name="source" type="text" value="<?php echo $tmp['fee']?>" />
 <?php
			if (isset($ddata['plv'])) {
			  if (!$ddata['plv']) echo 'Pt/';
			  else echo 'Ins' . $ddata['plv'] . '/';
			}
			echo $ddata['src'];
		   ?>  </td>
  </tr>-->
  <?php 
	if($_GET['condition']!='charge'){
	?>	
  <tr>
    <td height="39">Date</td>
    <td><input type="text" value="<?php echo $date1 ?>" name="date1" /><?php //echo date('d-m-Y')?></td>
  </tr>
  <?php } ?>
  <tr>
  
<?php 
	if($_GET['condition']=='charge'){
	?>
	 <tr>
    <td height="32">Charge</td>
    <td><input name="charge" type="text" value="<?php echo $tmp['fee']?>" /></td>
  </tr>
	<?
	}
else if($_GET['condition']=='copay'){?>
	<td height="30">Pay</td>
    		<td><input name="charge" type="text" value="<?php echo 0 -$tmp['fee']?>" /></td>
			<?php
}
else{
 		if(($tmp['pay_amount'])>0){?>
    		<td height="30">Pay</td>
    		<td><input name="pay" type="text" value="<?php echo $tmp['pay_amount']?>" /></td>
<?php  	}
	  	if(($tmp['adj_amount'])>0){
?>	
			<td height="30">Adjust</td>
    		<td><input name="adjust" type="text" value="<?php echo $tmp['adj_amount']?>" /></td>
<?
		}
		
?>
  </tr>
  <tr>
  </tr>
  <?php  	
	  	if(($tmp['adj_amount'])>0){
?>	
  <tr>
    <td height="33">Reason</td>
    <td>
	<select name="memo" style="background-color:<?php echo $bgcolor ?> ">
	
		<?php
		if(substr($tmp['memo'],0,10)=="Ins adjust")
		{
			$tmpmemo = substr($tmp['memo'],0,10);
			$tmpinsurance = substr($tmp['memo'],10);
		}
		else
		{
			$tmpmemo = $tmp['memo'];
		}
		// Adjustment reasons are now taken from the list_options table.
		echo "    <option value=''></option>\n";
		 $ores = sqlStatement("SELECT option_id, title FROM list_options " .
		  "WHERE list_id = 'adjreason' ORDER BY seq, title"); 
		while ($orow = sqlFetchArray($ores)) {
			$checked=($tmpmemo==$orow['title'])?'selected="selected""':'';
		  echo "    <option $checked value='" . addslashes($orow['option_id']) . "' " ;
		  echo ">" . $orow['title'] . "</option>\n";
		}
		?>
   </select>
	</td>
  </tr>
  <?
  }
  }
  ?>
  <tr>
    <td>&nbsp;</td><!--  onclick="window.close(); opener.location.reload(true);"-->
    <td><input type="submit" value="Update" name="update" /></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
<input type="hidden" name="id" value="<?php echo $_REQUEST['id']?>" />
<input type="hidden" name="billid" value="<?php echo $tmp['id']?>" />
<input type="hidden" name="condition" value="<?php echo $_REQUEST['condition']?>" />

<input type="hidden" name="ecid" value="<?php echo $_REQUEST['ecid']?>" />
<input type="hidden" name="seqn" value="<?php echo $_REQUEST['seqn']?>" />
<input type="hidden" name="tmpinsurance" value="<?php echo $tmpinsurance ?>" />
<input type="hidden" name="act" value="update" />
</form>

</body>
</html>
