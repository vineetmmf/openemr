<?php
// Copyright (C) 2009 Rod Roark <rod@sunsetsystems.com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// These functions will be used to globally validate and prepare
// data for sql database insertion.
//

// Main function that will manage POST, GET, and 
// REQUEST variables 
function formData($name, $type='P', $isTrim=false) {
  return formDataCore(requestValue($name, $type),$isTrim);
}

/* Fetches from _POST, _GET, or _REQUEST and send to formDataCore_DATE */
function formData_DATE($name, $type='P') {
	return formDataCore_DATE(requestValue($name, $type));
}

// Core function that will be called by formData.
// Note it can also be called directly if preparing
// normal variables (not GET,POST, or REQUEST)
function formDataCore($s, $isTrim=false) {
      //trim if selected
      if ($isTrim) {$s = trim($s);}
      //strip escapes
      $s = strip_escape_custom($s);
      //add escapes for safe database insertion
      $s = add_escape_custom($s);
      return $s;
}

/* Takes a string and tries to interpret it as a date
 * using strtotime().  If strtotime() is successful, then
 * we format the date as a SQL DATE literal and return
 * the resulting string.
 *
 * Failure is indicated by a NULL return.
 */
function formDataCore_DATE($s) {
	/* strtotime handles whitespace; no need to trim. */
	$parse_date = strtotime(strip_escape_custom($s));

	/* Failure return depends on PHP version. See PHP documentation. */
	if ($parse_date !== FALSE && $parse_date !== -1) {
		/* %F is always of the form YYYY-MM-DD, all SQL-string safe.
		 * No need for further escaping. */
		return strftime("DATE '%F'", $parse_date);
	}
}

// Will remove escapes if needed (ie magic quotes turned on) from string
// Called by above formDataCore() function to prepare for database insertion.
// Can also be called directly if simply need to remove escaped characters
//  from a string before processing.
function strip_escape_custom($s) {
      //strip slashes if magic quotes turned on
      if (get_magic_quotes_gpc()) {$s = stripslashes($s);}
      return $s;
}

// Will add escapes as needed onto a string
// Called by above formDataCore() function to prepare for database insertion.
// Can also be called directly if need to escape an already process string (ie.
//  escapes were already removed, then processed, and now want to insert into
//  database)
function add_escape_custom($s) {
      //prepare for safe mysql insertion
      $s = mysql_real_escape_string($s);
      return $s;
}

// This function is only being kept to support
// previous functionality. If you want to trim
// variables, this should be done using above
// functions.
function formTrim($s) {
  return formDataCore($s,true);
}

/* Used by formData* functions to get a value from the HTTP request. */
function requestValue($name, $type = 'P') {
  if ($type == 'P')
    return isset($_POST[$name]) ? $_POST[$name] : '';
  else if ($type == 'G')
    return isset($_GET[$name]) ? $_GET[$name] : '';
  else
    return isset($_REQUEST[$name]) ? $_REQUEST[$name] : '';
}

?>
