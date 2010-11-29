<?php
include_once("../../globals.php");
include_once("$srcdir/api.inc");
formHeader("Form: physical_sample");
?>
<html><head>
<link rel=stylesheet href="<?echo $css_header;?>" type="text/css">
</head>
<body <?echo $top_bg_line;?> topmargin=0 rightmargin=0 leftmargin=2 bottommargin=0 marginwidth=2 marginheight=0>
<form method=post action="<?echo $rootdir;?>/forms/physical_sample/save.php?mode=new" name="my_form" onsubmit="return top.restoreSession()">
<h1> physical_sample </h1>
<hr>
<input type="submit" name="submit form" value="submit form" /><br>

<table>

<tr><td> <? xl("Chief complaints",'e') ?> </td> <td><textarea name="chief_complaints"  rows="4" cols="40"></textarea></td></tr>

</table>
<br>
<h3> <? xl("past surgical history",'e') ?> </h3>

<table>

<tr><td> <? xl("Surgical history",'e') ?> </td> <td><label><input type="checkbox" name="surgical_history[]" value="cholecystectomy" /> <? xl("cholecystectomy",'e') ?> </label> <label><input type="checkbox" name="surgical_history[]" value="tonsillectomy" /> <? xl("tonsillectomy",'e') ?> </label> <label><input type="checkbox" name="surgical_history[]" value="apendectomy" /> <? xl("apendectomy",'e') ?> </label> <label><input type="checkbox" name="surgical_history[]" value="hernia" /> <? xl("hernia",'e') ?> </label></td></tr>

</table>
<br>
<h4> <? xl("other",'e') ?> </h4>

<table>

<tr><td> <? xl("Surgical history other",'e') ?> </td> <td><input type="text" name="surgical_history_other"  /></td></tr>

</table>
<br>
<h3> <? xl("past medical history",'e') ?> </h3>

<table>

<tr><td> <? xl("Medical history",'e') ?> </td> <td><select name="medical_history[]"  size="4" multiple="multiple">
<option value="asthma"> <? xl("asthma",'e') ?> </option>
<option value="diabetes"> <? xl("diabetes",'e') ?> </option>
<option value="hypertension"> <? xl("hypertension",'e') ?> </option>
<option value="GERD"> <? xl("GERD",'e') ?> </option>
</select></td></tr>

</table>
<br>
<h4> <? xl("other",'e') ?> </h4>

<table>

<tr><td> <? xl("Medical history other",'e') ?> </td> <td><input type="text" name="medical_history_other"  /></td></tr>

</table>
<br>
<h2> <? xl("Allergies",'e') ?> </h2>

<table>

<tr><td> <? xl("Allergies",'e') ?> </td> <td><label><input type="checkbox" name="allergies[]" value="penicillin" /> <? xl("penicillin",'e') ?> </label> <label><input type="checkbox" name="allergies[]" value="sulfa" /> <? xl("sulfa",'e') ?> </label> <label><input type="checkbox" name="allergies[]" value="iodine" /> <? xl("iodine",'e') ?> </label></td></tr>

</table>
<br>
<h4> <? xl("other",'e') ?> </h4>

<table>

<tr><td> <? xl("Allergies other",'e') ?> </td> <td><input type="text" name="allergies_other"  /></td></tr>

</table>
<br>
<h2> <? xl("Social History",'e') ?> </h2>
<br>
<h3> <? xl("smoking",'e') ?> </h3>

<table>

<tr><td> <? xl("Smoke history",'e') ?> </td> <td><label><input type="radio" name="smoke_history" value="non-smoker" /> <? xl("non-smoker",'e') ?> </label> <label><input type="radio" name="smoke_history" value="smoker" /> <? xl("smoker",'e') ?> </label></td></tr>

</table>
<br>
<h3> <? xl("alcohol",'e') ?> </h3>

<table>

<tr><td> <? xl("Etoh history",'e') ?> </td> <td><select name="etoh_history"  size="4">
<option value="none"> <? xl("none",'e') ?> </option>
<option value="occasional"> <? xl("occasional",'e') ?> </option>
<option value="daily"> <? xl("daily",'e') ?> </option>
<option value="heavy use"> <? xl("heavy use",'e') ?> </option>
</select></td></tr>

</table>
<br>
<h3> <? xl("last mammogram",'e') ?> </h3>

<table>

<tr><td>
<span class='text'><?php xl('Last mammogram (yyyy-mm-dd): ','e') ?></span>
</td><td>
<input type='text' size='10' name='last_mammogram' id='last_mammogram' onkeyup='datekeyup(this,mypcc)' onblur='dateblur(this,mypcc)' title='yyyy-mm-dd last date of this event' />
<img src='../../../interface/pic/show_calendar.gif' align='absbottom' width='24' height='22'
id='img_last_mammogram' border='0' alt='[?]' style='cursor:pointer'
title='Click here to choose a date'>
<script>
Calendar.setup({inputField:'last_mammogram', ifFormat:'%Y-%m-%d', button:'img_last_mammogram'});
</script>
</td></tr>

</table>
<table></table><input type="submit" name="submit form" value="submit form" />
</form>
<?php
formFooter();
?>
