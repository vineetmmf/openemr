<?php
/*
 * New image form
 */

include_once("../../globals.php");
include_once("$srcdir/api.inc");
$form_name = "Patient Images";
$form_folder = "image_draw";
//formHeader("Form: ".$form_name);
//$returnurl = $GLOBALS['concurrent_layout'] ? 'encounter_top.php' : 'patient_encounter.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head><title>Patient Images</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel=stylesheet href="<?=$GLOBALS['css_header']?>" type="text/css">
		<style type="text/css" media="screen">
		html, body { height:100%; background-color: #999999;}
		body { margin:0; padding:0; overflow:hidden; }
		#flashContent { width:100%; height:100%; }
		</style>


</head>


<body class="body_top" >

<?//php echo date("F d, Y", time()); ?>
<BR><BR>
<div id="flashContent" style="text-align:center;">  
			<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="475" height="375" id="draw1" align="middle">
				<param name="movie" value="<?=$GLOBALS['rootdir'];?>/forms/image_draw/draw1.swf" />
				<param name="quality" value="high" />
				<param name="bgcolor" value="#999999" />
				<param name="play" value="true" />
				<param name="loop" value="true" />
				<param name="wmode" value="window" />
				<param name="scale" value="showall" />
				<param name="menu" value="true" />
				<param name="devicefont" value="false" />
				<param name="salign" value="" />
				<param name="allowScriptAccess" value="sameDomain" />
				<!--[if !IE]>-->
				<object type="application/x-shockwave-flash" data="<?=$GLOBALS['rootdir'];?>/forms/image_draw/draw1.swf" width="475" height="375">
					<param name="movie" value="<?=$GLOBALS['rootdir'];?>/forms/image_draw/draw1.swf" />
					<param name="quality" value="high" />
					<param name="bgcolor" value="#999999" />
					<param name="play" value="true" />
					<param name="loop" value="true" />
					<param name="wmode" value="window" />
					<param name="scale" value="showall" />
					<param name="menu" value="true" />
					<param name="devicefont" value="false" />
					<param name="salign" value="" />
					<param name="allowScriptAccess" value="sameDomain" />
				<!--<![endif]-->
					<a href="http://www.adobe.com/go/getflash">
						<img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" />
					</a>
				<!--[if !IE]>-->
				</object>
				<!--<![endif]-->
			</object>
		</div>

<BR><BR>
<?include('showimages.php');?>
</body>

</html>

