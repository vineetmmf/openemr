<?php
include_once("../../globals.php");
include_once("$srcdir/api.inc");
include_once("$srcdir/eapi.php");
include_once("$srcdir/forms.inc");
?>
<html>
<head>
	<script type="text/javascript" src="<?php echo $web_root ?>/library/js/jquery-1.3.2.min.js"></script>
	<script type="text/javascript" src="<?php echo $web_root ?>/library/js/query.elementlocation.js"></script>
	<script type="text/javascript" src="<?php echo $web_root ?>/library/js/ajax_search.js"></script>
	<link rel="stylesheet" type="text/css" href="<?php echo $web_root ?>/library/js/thickbox.css" />
	<script>
	$(document).ready(function(){
      $("#clickable-image").click( function( eventObj ) {
				var location = $("#clickable-image").elementlocation();
				var x = eventObj.pageX - location.x;
				var y = eventObj.pageY - location.y;

				var m = document.getElementById('marker');

        m.style.left = x +'px';
        m.style.top = y +'px';
        m.style.visibility = 'visible';

        var l = document.getElementById('form');
        l.style.visibility = 'visible';
      });
      $("#cmdSubmit").click( function( eventObj ) {

				var location = $("#marker").elementlocation();

        var x = location.x;
        var y = location.y;

        if ($('#diagnostic').val() != '' && x != -5 && y != -5)
				{
				      $.post('<?php echo $rootdir ?>/forms/body/save.php', { x: x, y: y, diagnostic: $('#diagnostic').val(), notes: $('#notes').val() },function(data){
				        window.location = "<?php echo $rootdir ?>/patient_file/encounter/load_form.php?formname=body";
            });
        }else{
          alert('Debe escribir un codigo y tener senalada una area.');
        }
      })
    });
  </script>
<style type="text/css" media="screen">
  	body {
  		font: 11px arial;
  	}
  	.suggest_link {
  		background-color: #FFFFFF;
  		padding: 2px 6px 2px 6px;
  	}
  	.suggest_link_over {
  		background-color: #3366CC;
  		padding: 2px 6px 2px 6px;
  	}
  </style>
</head>
<body>
  <div align="left" style="position:relative; float:left;">
  	<div id="marker" style="position: absolute; visibility:hidden; z-index: 20; width: 10px; height: 10px; margin-left: -5px; margin-top: -5px; background: black"></div>
  	<?php renderMarkers($pid, $rootdir) ?>
    <MAP NAME="map">
    <area style="cursor:help" onclick="invalidArea()" shape="poly" coords="310,202,305,234,306,270,320,305,326,367,324,416,320,441,325,506,313,542,304,587,315,616,319,638,322,656,472,664,472,358,446,352,421,327,396,297,369,272,340,246,325,224," href="#" alt="" title=""   />
    <area style="cursor:help" onclick="invalidArea()" shape="poly" coords="269,23,277,37,281,59,281,76,279,96,293,113,324,121,346,152,366,192,391,221,419,251,439,282,460,315,473,316,473,0,248,2,248,17," href="#" alt="" title=""   />
    <area style="cursor:help" onclick="invalidArea()" shape="poly" coords="11,339,34,336,67,311,100,282,155,239,170,217,179,196,189,237,189,277,179,325,171,370,172,418,177,454,177,487,179,536,186,573,187,604,181,633,182,660,4,661,3,526,5,426," href="#" alt="" title=""   />
    <area style="cursor:help" onclick="invalidArea()" shape="poly" coords="247,401,237,437,233,462,232,482,232,515,227,553,227,581,234,613,234,639,234,650,270,651,270,636,271,616,270,591,275,566,268,537,266,515,269,488,265,455,256,418," href="#" alt="" title=""   />
    <area style="cursor:help" onclick="invalidArea()" shape="poly" coords="2,3,243,5,242,19,225,25,216,48,216,78,221,96,205,109,175,117,156,134,145,157,128,178,109,206,88,227,71,253,55,271,32,298,18,322,9,323,3,174,2,56," href="#" alt="" title=""   />
    <?php //renderAreas($pid) ?>
    </MAP>
    <IMG style="cursor:crosshair" SRC="<?php echo $rootdir ?>/forms/body/images/body.jpg" ALT="body" id="clickable-image" BORDER=0 USEMAP="#map">
	</div>
	<div style="float: left; padding-top:15px;">
	  <h3>Body Form</h3>
  	<div id="form" style="visibility: hidden">
	      <form name="frmSearch" action="#">
	      <?php dxSuggest() ?>
      	<br />
      	<br />
      	  <b>Notes:</b><textarea name="notes" id="notes" rows="10" cols="40"></textarea>
        <br />
        <br />
      </form>
      <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" alt="cmdSubmit" />
    </div>
    </ br>
    <div id="table">
    <table>
    <tr><th>Code</th></tr>
  	    <?php foreach (getLastDiag($pid) as $item){ ?>
  	      <td><?php echo $item ?></td></tr>
  	    <?php } ?>
    </table>
    </div>
  </div>
</body>
</html><?php

/**
 * getLastDiag()
 *
 * @param mixed $pid
 * @return
 */
function getLastDiag($pid)
{
  $result = mysql_query("SELECT * FROM `form_body` WHERE `pid` = '$pid'", $GLOBALS['dbh']);

  while($row=mysql_fetch_array($result)) {
    $return[] = $row['code'];
  }
  return $return;
}
/**
 * renderAreas()
 *
 * @return
 */
function renderAreas($pid)
{
  $result = mysql_query("SELECT * FROM `form_body` WHERE `patient_id` = '$pid'", $GLOBALS['dbh']);
  while($row=mysql_fetch_array($result)) {
    $x = $row['x'] + 5;
    $y = $row['y'] + 5;
    echo '<AREA HREF="#" ALT="Contacts" TITLE="Contacts" SHAPE="CIRCLE" COORDS="'. $x . ',' . $y . ',10">';
  }
}
function renderMarkers($pid, $rootdir)
{
  $result = mysql_query("SELECT * FROM `form_body` WHERE `pid` = '$pid'", $GLOBALS['dbh']);
  while($row=mysql_fetch_array($result)) {
    ?>
    <img style="position: absolute; visibility:visible; z-index: 20; width: 15px; height: 15px; left: <?php echo $row['x'] ?>px; top:  <?php echo  $row['y'] ?>px;" border=0 SRC="<?php echo $rootdir ?>/forms/body/images/marker.gif">
  <?php }
}
?>