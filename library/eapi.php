<?php
  include_once("../../globals.php");
  include_once("api.inc");
  include_once("$srcdir/forms.inc");
  include_once("sqlconf.php");
  require_once("sql.inc");


  if (isset($_GET["search"]))
  {
    $search =$_GET["search"];

    $result = mysql_query("SELECT * FROM `codes` WHERE `code` LIKE '$search%' LIMIT 20", $GLOBALS['dbh']);
    $result1 = mysql_query("SELECT * FROM `codes` WHERE `code_text` LIKE '$search%' LIMIT 20", $GLOBALS['dbh']);

    while($row = mysql_fetch_array($result1)) {
      $return[] = $row['code_text'];
    }

    while($row = mysql_fetch_array($result)) {
      $return[] = $row['code'];
    }
    echo implode("\n", $return);
  }

  function dxSuggest()
  {;
    ?>
    <b>Dx: </b><input type="text" id="diagnostic" name="diagnostic" alt="Search Criteria" onkeyup="searchSuggest('<?php  echo $GLOBALS['webroot'] ?>');" autocomplete="off" />
    <div id="search_suggest" style="position: absolute; margin-left:20px; background-color: #FFFFFF; text-align: left; border: 1px solid #000000;">
    </div>
    <?php
  }
?>