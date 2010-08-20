<?php
  include_once("../../globals.php");
  include_once("$srcdir/api.inc");
  include_once("$srcdir/forms.inc");


  $array['id'] = null;
  $array['code'] = $_POST['diagnostic'];
  $array['x'] = $_POST['x'];
  $array['y'] = $_POST['y'];
  $array['notes'] = $_POST['notes'];

  formSubmit('form_body', $array, 16);
?>