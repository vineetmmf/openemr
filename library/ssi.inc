<?php
// Copyright (C) 2008 Phyaura, LLC <info@phyaura.com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

function getRelayHealthLink( $dest ) {
      switch( trim($dest) )
      {
        case "inbox":
            return '<div id="rhmsgcount"><a href="../jump_to_RelayHealth.php?dest=inbox" target="_new" class="rhesuites" id="rh_link">'.
                htmlspecialchars( xl('e-messages').'(0)', ENT_NOQUOTES) . '</a></div>';
          break;
      case "renewals":
            return '<a href="../jump_to_RelayHealth.php?dest='.$dest.'" target="_new" class="rhesuites" id="rh_link">'.
                htmlspecialchars( xl('e-renewals'), ENT_NOQUOTES) .'</a>';
        break;
      case "escripts":
            return '<a href="../jump_to_RelayHealth.php?dest='.$dest.'" target="_new" class="rhesuites" id="rh_link">'.
                htmlspecialchars( xl('e-scripts'), ENT_NOQUOTES) .'</a>';
        break;
      case "home":
        return '<a href="../jump_to_RelayHealth.php?dest='.$dest.'" target="_new" class="navitem" id="rh_link">'.
            htmlspecialchars( xl('E-suites'), ENT_NOQUOTES) .'</a>';
        break;
      default:
        return '<a href="https://app.relayhealth.com" target="_new" class="navitem" id="rh_link">'.
            htmlspecialchars( xl('Relay Health'), ENT_NOQUOTES) .'</a>';
      }
}
?>
