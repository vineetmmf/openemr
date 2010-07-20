<?php
/* -------------- RelayHealth global variables -------------- */

// set practice settings from C_PracticeSettings or globals
// practice id, facility id etc

/* -------------- set booleans to turn on/off services -------------- */
// SOAP API - set TRUE if using soap calls on Left Nav menu with RelayHealth
$GLOBALS['rh_api'] = TRUE;

/* -------------- set environment for params and credentials -------------- */
$GLOBALS['rh_api_env'] = "T";  // env codes T->Test P->Prod

/* -------------- set variables for required params and credentials -------------- */

// set the relay health Partner ID - provided by Relay Health
$GLOBALS['rh_partner_id'] = "1086";

// set the relay health Practice ID - provided by Relay Health
$GLOBALS['rh_practice_id'] = "3852";

// the PartnerUserId should be set for each user login that is to utilize the rh api
// the PartnerUserId is stored in OpenEMR->users->ssi_relayhealth
/* !!! rh_api requires $_SESSION['rh_api_id'] set in library/auth.inc !!! */


switch( trim( $GLOBALS['rh_api_env'] ) )
{
  case "P":
    // set the assigning authority id for the practice
    // this is the aaid for health link
    $GLOBALS['rh_api_aaid'] = "C4E487EB-31EE-4DD3-9AFC-C4F76E4B1733";
    $GLOBALS['RHApplicationName']     = 'PhyauraSSI';
    $GLOBALS['RHApplicationPassword'] = 'relayme_123';
    $GLOBALS['RHPartnerName']         = 'PhyauraSSI';

    // production
    // globals for relay health SingleSignIn
    $GLOBALS['RHssilocation']            = 'https://api.relayhealth.com/SSI/SingleSignIn.svc';
    $GLOBALS['RHssiwsdl']                = 'https://api.relayhealth.com/SSI/SingleSignIn.svc?wsdl';

    // globals for relay health message service - temporary location
    // production
    $GLOBALS['RHmsglocation'] = "https://api.relayhealth.com/Message/RelayHealthMessageService.svc";
    $GLOBALS['RHmsgwsdl'] = "https://api.relayhealth.com/Message/RelayHealthMessageService.svc?wsdl";
    break;

  case "D":
  case "T":
  default:

    // use this for test account Phyaura_
    $GLOBALS['rh_api_aaid'] = "52BD95B4-927B-49B2-9905-6A2900575F69";
    $GLOBALS['RHApplicationName']     = 'Phyaura_PFP3852_SSI';
    $GLOBALS['RHApplicationPassword'] = 'relayme_123';
    $GLOBALS['RHPartnerName']         = 'Phyaura_PFP3852';

    // globals for relay health SingleSignIn
    // dev-testing
    $GLOBALS['RHssilocation']            = 'https://api.integration.relayhealth.com/SSI/SingleSignIn.svc';
    $GLOBALS['RHssiwsdl']                = 'https://api.integration.relayhealth.com/SSI/SingleSignIn.svc?wsdl';

    // globals for relay health message service - temporary location
    $GLOBALS['RHmsglocation'] = "https://api.integration.relayhealth.com/Message/RelayHealthMessageService.svc";
    $GLOBALS['RHmsgwsdl'] = "https://api.relayhealth.com/Message/RelayHealthMessageService.svc?wsdl";


    break;
}
