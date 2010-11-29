<?php
//------------report.php
include_once("../../globals.php");
include_once("../../../library/api.inc");
include_once("../../../interface/forms/CAMOS/content_parser.php");
function CAMOS_report( $pid, $encounter, $cols, $id) {
  $data = formFetch("form_CAMOS", $id);
  if ($data) {
    //echo "(category) ".stripslashes($data['category'])." | ";
    //echo "(subcategory) ".stripslashes($data['subcategory'])." | ";
    //echo "(item) ".stripslashes($data['item']);
    echo "<a href='" . $GLOBALS['webroot'] .
      "/interface/forms/CAMOS/rx_print.php?sigline=embossed' target=_new onclick='top.restoreSession()'>rx</a>\n";
    echo " | ";
    echo "<a href='" . $GLOBALS['webroot'] .
      "/interface/forms/CAMOS/rx_print.php?sigline=signed' target=_new onclick='top.restoreSession()'>sig_rx</a>\n";
    echo " | ";
    echo "<a href='" . $GLOBALS['webroot'] .
      "/interface/forms/CAMOS/rx_print.php?rxlabel=true' target=_new onclick='top.restoreSession()'>rxlabel</a>\n";
    echo " | ";
    echo "<a href='" . $GLOBALS['webroot'] .
      "/interface/forms/CAMOS/rx_print.php?letterhead=true&signer=patient' target=_new onclick='top.restoreSession()'>letterhead; patient signs</a>\n";
    echo " | ";
    echo "<a href='" . $GLOBALS['webroot'] .
      "/interface/forms/CAMOS/rx_print.php?letterhead=true&signer=doctor' target=_new onclick='top.restoreSession()'>letterhead; doctor signs</a>\n";
    echo " | ";
    echo "<a href='" . $GLOBALS['webroot'] .
      "/interface/forms/CAMOS/notegen.php?pid=".$GLOBALS['pid']."&encounter=".$GLOBALS['encounter']."' target=_new onclick='top.restoreSession()'>Print This Encounter</a>\n";
    echo " | ";
    echo "<a href='" . $GLOBALS['webroot'] .
      "/interface/forms/CAMOS/notegen.php' target=_new onclick='top.restoreSession()'>Print Any Encounter</a>\n";
    echo "<pre>".wordwrap(stripslashes(pre_view_process($GLOBALS['encounter'],$GLOBALS['pid'],$data['content'])))."</pre><hr>\n";
  }
}
?> 
