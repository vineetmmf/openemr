<!-- view.php --> 
 <?php 
 include_once("../../globals.php"); 
 include_once("$srcdir/api.inc"); 
 formHeader("Form: physical_sample"); 
 $obj = formFetch("form_physical_sample", $_GET["id"]);  //#Use the formFetch function from api.inc to get values for existing form. 
  
 function chkdata_Txt(&$obj, $var) { 
         return htmlentities($obj{"$var"}); 
 } 
 function chkdata_Date(&$obj, $var) { 
         return htmlentities($obj{"$var"}); 
 } 
 function chkdata_CB(&$obj, $nam, $var) { 
 	if (preg_match("/Negative.*$var/",$obj{$nam})) {return;} else {return "checked";} 
 } 
 function chkdata_Radio(&$obj, $nam, $var) { 
 	if (strpos($obj{$nam},$var) !== false) {return "checked";} 
 } 
  function chkdata_PopOrScroll(&$obj, $nam, $var) { 
 	if (preg_match("/Negative.*$var/",$obj{$nam})) {return;} else {return "selected";} 
 } 
  
 ?> 
 <html><head> 
 <link rel=stylesheet href="<?echo $css_header;?>" type="text/css"> 
 </head> 
 <body <?echo $top_bg_line;?> topmargin=0 rightmargin=0 leftmargin=2 bottommargin=0 marginwidth=2 marginheight=0> 
 <style type="text/css">@import url(../../../library/dynarch_calendar.css);</style>
<script type="text/javascript" src="../../../library/dialog.js"></script>
<script type="text/javascript" src="../../../library/textformat.js"></script>
<script type="text/javascript" src="../../../library/dynarch_calendar.js"></script>
<script type="text/javascript" src="../../../library/dynarch_calendar_en.js"></script>
<script type="text/javascript" src="../../../library/dynarch_calendar_setup.js"></script>
<script language='JavaScript'> var mypcc = '1'; </script>
 
 <form method=post action="<?echo $rootdir?>/forms/physical_sample/save.php?mode=update&id=<?echo $_GET["id"];?>" name="my_form" onsubmit="return top.restoreSession()"> 
 <h1> physical_sample </h1> 
 <hr> 
 <input type="submit" name="submit form" value="submit form" /><br> 
  
 <table> 
  
 <tr><td> <? xl("Chief complaints",'e') ?> </td> <td><textarea name="chief_complaints"  rows="4" cols="40"><?php $result = chkdata_Txt($obj,"chief_complaints"); echo $result;?></textarea></td></tr> 
  
 </table> 
 <br> 
 <h3> <? xl("past surgical history",'e') ?> </h3> 
  
 <table> 
  
 <tr><td> <? xl("Surgical history",'e') ?> </td> <td><label><input type="checkbox" name="surgical_history[]" value="cholecystectomy" <?php $result = chkdata_CB($obj,"surgical_history","cholecystectomy"); echo $result;?> <? xl(">cholecystectomy",'e') ?> </label> 
 <label><input type="checkbox" name="surgical_history[]" value="tonsillectomy" <?php $result = chkdata_CB($obj,"surgical_history","tonsillectomy"); echo $result;?> <? xl(">tonsillectomy",'e') ?> </label> 
 <label><input type="checkbox" name="surgical_history[]" value="apendectomy" <?php $result = chkdata_CB($obj,"surgical_history","apendectomy"); echo $result;?> <? xl(">apendectomy",'e') ?> </label> 
 <label><input type="checkbox" name="surgical_history[]" value="hernia" <?php $result = chkdata_CB($obj,"surgical_history","hernia"); echo $result;?> <? xl(">hernia",'e') ?> </label></td></tr> 
  
 </table> 
 <br> 
 <h4> <? xl("other",'e') ?> </h4> 
  
 <table> 
  
 <tr><td> <? xl("Surgical history other",'e') ?> </td> <td><input type="text" name="surgical_history_other" value="<?php $result = chkdata_Txt($obj,"surgical_history_other"); echo $result;?>"></td></tr> 
  
 </table> 
 <br> 
 <h3> <? xl("past medical history",'e') ?> </h3> 
  
 <table> 
  
 <tr><td> <? xl("Medical history",'e') ?> </td> <td><select name="medical_history[]"  size="4" multiple="multiple"> 
 <option value="asthma" <?php $result = chkdata_PopOrScroll($obj,"medical_history","asthma"); echo $result;?> <? xl(">asthma",'e') ?> </option> 
 <option value="diabetes" <?php $result = chkdata_PopOrScroll($obj,"medical_history","diabetes"); echo $result;?> <? xl(">diabetes",'e') ?> </option> 
 <option value="hypertension" <?php $result = chkdata_PopOrScroll($obj,"medical_history","hypertension"); echo $result;?> <? xl(">hypertension",'e') ?> </option> 
 <option value="GERD" <?php $result = chkdata_PopOrScroll($obj,"medical_history","GERD"); echo $result;?> <? xl(">GERD",'e') ?> </option> 
 </select></td></tr> 
  
 </table> 
 <br> 
 <h4> <? xl("other",'e') ?> </h4> 
  
 <table> 
  
 <tr><td> <? xl("Medical history other",'e') ?> </td> <td><input type="text" name="medical_history_other" value="<?php $result = chkdata_Txt($obj,"medical_history_other"); echo $result;?>"></td></tr> 
  
 </table> 
 <br> 
 <h2> <? xl("Allergies",'e') ?> </h2> 
  
 <table> 
  
 <tr><td> <? xl("Allergies",'e') ?> </td> <td><label><input type="checkbox" name="allergies[]" value="penicillin" <?php $result = chkdata_CB($obj,"allergies","penicillin"); echo $result;?> <? xl(">penicillin",'e') ?> </label> 
 <label><input type="checkbox" name="allergies[]" value="sulfa" <?php $result = chkdata_CB($obj,"allergies","sulfa"); echo $result;?> <? xl(">sulfa",'e') ?> </label> 
 <label><input type="checkbox" name="allergies[]" value="iodine" <?php $result = chkdata_CB($obj,"allergies","iodine"); echo $result;?> <? xl(">iodine",'e') ?> </label></td></tr> 
  
 </table> 
 <br> 
 <h4> <? xl("other",'e') ?> </h4> 
  
 <table> 
  
 <tr><td> <? xl("Allergies other",'e') ?> </td> <td><input type="text" name="allergies_other" value="<?php $result = chkdata_Txt($obj,"allergies_other"); echo $result;?>"></td></tr> 
  
 </table> 
 <br> 
 <h2> <? xl("Social History",'e') ?> </h2> 
 <br> 
 <h3> <? xl("smoking",'e') ?> </h3> 
  
 <table> 
  
 <tr><td> <? xl("Smoke history",'e') ?> </td> <td><label><input type="radio" name="smoke_history" value="non-smoker" /> <? xl("non-smoker",'e') ?> </label> 
 <label><input type="radio" name="smoke_history" value="smoker" <?php $result = chkdata_Radio($obj,"smoke_history","smoker"); echo $result;?> <? xl(">smoker",'e') ?> </label></td></tr> 
  
 </table> 
 <br> 
 <h3> <? xl("alcohol",'e') ?> </h3> 
  
 <table> 
  
 <tr><td> <? xl("Etoh history",'e') ?> </td> <td><select name="etoh_history"  size="4"> 
 <option value="none" <?php $result = chkdata_PopOrScroll($obj,"etoh_history","none"); echo $result;?> <? xl(">none",'e') ?> </option> 
 <option value="occasional" <?php $result = chkdata_PopOrScroll($obj,"etoh_history","occasional"); echo $result;?> <? xl(">occasional",'e') ?> </option> 
 <option value="daily" <?php $result = chkdata_PopOrScroll($obj,"etoh_history","daily"); echo $result;?> <? xl(">daily",'e') ?> </option> 
 <option value="heavy use" <?php $result = chkdata_PopOrScroll($obj,"etoh_history","heavy use"); echo $result;?> <? xl(">heavy use",'e') ?> </option> 
 </select></td></tr> 
  
 </table> 
 <br> 
 <h3> <? xl("last mammogram",'e') ?> </h3> 
  
 <table> 
  
 <tr><td> 
 <span class='text'><?php xl('Last mammogram (yyyy-mm-dd): ','e') ?></span> 
 </td><td> 
 <input type='text' size='10' name='last_mammogram' id='last_mammogram' onkeyup='datekeyup(this,mypcc)' onblur='dateblur(this,mypcc)' title='yyyy-mm-dd last date of this event'  value="<?php $result = chkdata_Date($obj,"last_mammogram"); echo $result;?>"> 
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
