<?php
/* -------------- RelayHealth global variables -------------- */
$GLOBALS['rh'] = array();

// set practice settings from C_PracticeSettings or globals
// practice id, facility id etc

/* -------------- set booleans to turn on/off services -------------- */
// SOAP API - set TRUE if using soap calls on Left Nav menu with RelayHealth
$GLOBALS['rh']['rh_api'] = TRUE;

// eScripts - set TRUE if using e-prescribing with RelayHealth
$GLOBALS['rh']['rh_escripts'] = TRUE;

// Patient ADT (New and Update) - set TRUE if sendinging
// outbound ADT messages to RelayHealth for patient creation and updates
$GLOBALS['rh']['rh_patient'] = TRUE;

// Patient/medication CCD (New and Update) - set TRUE if sendinging
// outbound CCD messages to RelayHealth for patient medication adding and updates
$GLOBALS['rh']['rh_medication'] = TRUE;

/* -------------- set environment for params and credentials -------------- */
$GLOBALS['rh']['rh_api_env'] = "P";  // env codes T->Test P->Prod


/* -------------- set variables for required params and credentials -------------- */

// set the relay health Partner ID - provided by Relay Health
$GLOBALS['rh']['rh_partner_id'] = "";

// set the relay health Practice ID - provided by Relay Health
$GLOBALS['rh']['rh_practice_id'] = "";

// the PartnerUserId should be set for each user login that is to utilize the rh api
// the PartnerUserId is stored in OpenEMR->users->ssi_relayhealth
/* !!! rh_api requires $_SESSION['rh']['rh_api_id'] set in library/auth.inc !!! */


switch( trim( $GLOBALS['rh']['rh_api_env'] ) )
{
  case "P":
    // set the assigning authority id for the practice
    // this is the aaid for health link
    $GLOBALS['rh']['rh_api_aaid'] = "";

    // production
    // globals for relay health SingleSignIn
    $GLOBALS['rh']['ssi']['ApplicationName']     = '';
    $GLOBALS['rh']['ssi']['ApplicationPassword'] = '';
    $GLOBALS['rh']['ssi']['PartnerName']         = '';
    $GLOBALS['rh']['ssi'] = array();
    $GLOBALS['rh']['ssi']['location']            = 'https://api.relayhealth.com/SSI/SingleSignIn.svc';
    $GLOBALS['rh']['ssi']['wsdl']                = 'https://api.relayhealth.com/SSI/SingleSignIn.svc?wsdl';

    // globals for relay health message service - temporary location
    // production
    $GLOBALS['rh']['message']['ApplicationName']     = '';
    $GLOBALS['rh']['message']['ApplicationPassword'] = '';
    $GLOBALS['rh']['message']['PartnerName']         = '';
    $GLOBALS['rh']['message']['location'] = "https://api.relayhealth.com/Message/RelayHealthMessageService.svc";
    $GLOBALS['rh']['message']['wsdl'] = "https://api.relayhealth.com/Message/RelayHealthMessageService.svc?wsdl";
    break;

  case "D":
  case "T":
  default:

    // use this for test account Phyaura_
    $GLOBALS['rh']['rh_api_aaid'] = "";
    // globals for relay health SingleSignIn
    // dev-testing
    $GLOBALS['rh']['ssi']['ApplicationName']     = '';
    $GLOBALS['rh']['ssi']['ApplicationPassword'] = '';
    $GLOBALS['rh']['ssi']['PartnerName']         = '';
    $GLOBALS['rh']['ssi']['location']            = 'https://api.integration.relayhealth.com/SSI/SingleSignIn.svc';
    $GLOBALS['rh']['ssi']['wsdl']                = 'https://api.integration.relayhealth.com/SSI/SingleSignIn.svc?wsdl';

    // globals for relay health message service - temporary location
    $GLOBALS['rh']['message']['ApplicationName']     = '';
    $GLOBALS['rh']['message']['ApplicationPassword'] = '';
    $GLOBALS['rh']['message']['PartnerName']         = '';
    $GLOBALS['rh']['message']['location'] = "https://api.integration.relayhealth.com/Message/RelayHealthMessageService.svc";
    $GLOBALS['rh']['message']['wsdl'] = "https://api.relayhealth.com/Message/RelayHealthMessageService.svc?wsdl";


    break;
}
?>


