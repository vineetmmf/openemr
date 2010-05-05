<?php
$fake_register_globals = FALSE;
require_once("../../globals.php");
require_once($GLOBALS['srcdir'] . '/formdata.inc.php');

$pa_patient = (string) ((integer) $pid); /* SQL Injection Free */

$action =& $_POST['action'];
if (!isset($action)) {
	/* No action requested. */
} else if ($action == 'add') {
	unset($pa_number, $pa_begin, $pa_end, $pa_service, $pa_units);
	if (isset($_POST['pa_number'], $_POST['pa_begin'], $_POST['pa_end'], $_POST['pa_service'], $_POST['pa_units'])) {
		$pa_number = strip_escape_custom($_POST['pa_number']);

		$pa_begin = formData_DATE('pa_begin');
		if ($pa_begin === NULL) unset($pa_begin);

		$pa_end = formData_DATE('pa_end');
		if ($pa_end === NULL) unset($pa_end);

		$pa_service = strip_escape_custom($_POST['pa_service']);
		$pa_units = (string) ((integer) strip_escape_custom($_POST['pa_units']));
	} else {
		$user_msg = xl('Incomplete request received. No action was taken.');
		$user_msg_type = 'error';
	}

	unset($resource);
	if (isset($pa_number, $pa_begin, $pa_end, $pa_service, $pa_units)) {
		$stmt  = 'INSERT INTO prior_auth (';
		$stmt .=   'pa_patient';
		$stmt .= ', pa_number';
		$stmt .= ', pa_begin';
		$stmt .= ', pa_end';
		$stmt .= ', pa_service';
		$stmt .= ', pa_count';
		$stmt .= ')';
		$stmt .= ' VALUES (';
		$stmt .=   "$pa_patient";
		$stmt .= ", '" . add_escape_custom($pa_number) . "'";
		$stmt .= ", $pa_begin";
		$stmt .= ", $pa_end";
		$stmt .= ", '" . add_escape_custom($pa_service) . "'";
		$stmt .= ", $pa_units";
		$stmt .= ');';

		$resource = sqlStatement($stmt);
	} else {
		$user_msg = xl('Some of the values provided were invalid. No action was taken.');
		$user_msg_type = 'error';
	}

	if (isset($resource)) {
		if ($resource !== FALSE) {
			$user_msg = xl('New prior authorization created. It should appear below.');
			$user_msg_type = 'info';
		} else {
			$user_msg = xl('Failed to record new prior authorization in the system.');
			$user_msg_type = 'error';
		}
	}
} else if ($action == 'update') {
	$user_msg = xl('The "update" action is not implemented.');
	$user_msg_type = 'error';
} else if ($action == 'delete') {
	if (isset($_POST['pa_id'])) {
		$pa_id = (string) ((integer) $_POST['pa_id']);

		$stmt  = 'DELETE FROM prior_auth';
		$stmt .= " WHERE pa_patient = $pa_patient";
		$stmt .= "   AND pa_id = $pa_id";
		$stmt .= ';';

		$resource = sqlStatement($stmt);
		if ($resource === FALSE) {
			$user_msg = xl('Could not delete the chosen prior authorization.');
			$user_msg_type = 'error';
		} else {
			$user_msg = xl('The prior authorization no longer exists in the system.');
			$user_msg_type = 'info';
		}
	} else {
		$user_msg = xl('A deletion was requested but the sytem could not determine which prior authorization to delete. No deletion occured.');
		$user_msg_type = 'error';
	}
} else {
	$user_msg = xl('You requested an action that was not understood. No action has been taken.');
	$user_msg_type = 'error';
	/* XXX: Need to log this error. */
}
?>
<html>
	<head>
		<link rel='stylesheet' href='<?php echo htmlspecialchars($css_header, ENT_QUOTES); ?>' type='text/css' />
	</head>
	<body class='body_top'>
<?php
if (isset($user_msg)) {
?>
	<p class='user-message <?php echo htmlspecialchars($user_msg_type, ENT_QUOTES); ?>'>
		<?php echo htmlspecialchars($user_msg, ENT_NOQUOTES); ?>
	</p>
<?php
}
?>
		<h2><?php echo htmlspecialchars(xl('Add Prior Authorization'), ENT_NOQUOTES); ?></h2>
		<form method='post' action='prior_auths.php' name='add_or_edit_pa'>
			<p>
			<label for='pa_number'><?php echo htmlspecialchars(xl('Number (Identifier)'), ENT_NOQUOTES); ?>:</label>
			<input type='text' id='pa_number' name='pa_number' />
			<br />
			<label for='pa_begin'><?php echo htmlspecialchars(xl('Start Date'), ENT_NOQUOTES); ?>:</label>
			<input type='text' id='pa_begin' name='pa_begin' />
			<label for='pa_end'><?php echo htmlspecialchars(xl('End Date'), ENT_NOQUOTES); ?>:</label>
			<input type='text' id='pa_end' name='pa_end' />
			<br />
			<label for='pa_service'><?php echo htmlspecialchars(xl('Service or Procedure'), ENT_NOQUOTES); ?>:</label>
			<input type='text' id='pa_sevice' name='pa_service' />
			<label for='pa_units'><?php echo htmlspecialchars(xl('Number of Units'), ENT_NOQUOTES); ?>:</label>
			<input type='text' id='pa_units' name='pa_units' />
			<br />
			<button type='submit' name='action' value='add'><?php echo htmlspecialchars(xl('Create New'), ENT_NOQUOTES); ?></button>
			<button type='reset'><?php echo htmlspecialchars(xl('Clear'), ENT_NOQUOTES); ?></button>
			</p>
		</form>
		<h2><?php echo htmlspecialchars(xl('Existing Prior Authorizations'), ENT_NOQUOTES); ?></h2>
		<table>
			<thead>
				<tr>
					<th><?php echo htmlspecialchars(xl('Number (Identifier)'), ENT_NOQUOTES); ?></th>
					<th><?php echo htmlspecialchars(xl('Start Date'), ENT_NOQUOTES); ?></th>
					<th><?php echo htmlspecialchars(xl('End Date'), ENT_NOQUOTES); ?></th>
					<th><?php echo htmlspecialchars(xl('Service or Procedure'), ENT_NOQUOTES); ?></th>
					<th><?php echo htmlspecialchars(xl('Number of Units'), ENT_NOQUOTES); ?></th>
					<th colspan='2'><?php echo htmlspecialchars(xl('Actions'), ENT_NOQUOTES); ?></th>
				</tr>
			</thead>
<?php
$query  = 'SELECT pa_id AS id';
$query .=      ', pa_number AS number';
$query .=      ', pa_begin AS begin';
$query .=      ', pa_end AS end';
$query .=      ', pa_service AS service';
$query .=      ', pa_count AS units';
$query .= ' FROM prior_auth';
$query .= " WHERE pa_patient = $pa_patient";
$query .= ';';

$resource = sqlStatement($query);
if ($resource !== FALSE) {
	$row = sqlFetchArray($resource);
}

if (isset($row) && $row !== FALSE) {
?>
			<tbody>
<?php
	do {
		$pa_id =& $row['id'];
		$pa_number =& $row['number'];
		$pa_begin_str =& $row['begin'];
		$pa_end_str =& $row['end'];
		$pa_service =& $row['service'];
		$pa_units =& $row['units'];
?>
				<tr>
					<td><?php echo htmlspecialchars($pa_number, ENT_NOQUOTES); ?></td>
					<td><?php echo htmlspecialchars($pa_begin_str, ENT_NOQUOTES); ?></td>
					<td><?php echo htmlspecialchars($pa_end_str, ENT_NOQUOTES); ?></td>
					<td><?php echo htmlspecialchars($pa_service, ENT_NOQUOTES); ?></td>
					<td><?php echo htmlspecialchars($pa_units, ENT_NOQUOTES); ?></td>
					<td>
						<form method='post' action='prior_auths.php' name='delete_pa_<?php echo htmlspecialchars($pa_id, ENT_QUOTES) ?>'>
							<input type='hidden' name='pa_id' value='<?php echo htmlspecialchars($pa_id, ENT_QUOTES); ?>' />
							<button type='submit' name='action' value='delete'><?php echo htmlspecialchars(xl('Delete'), ENT_NOQUOTES); ?></button>
						</form>
					</td>
				</tr>
<?php
	} while (($row = sqlFetchArray($resource)) !== FALSE);
?>
			</tbody>
<?php
}
?>
		</table>
	</body>
</html>
