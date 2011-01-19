<?php
 // Copyright (C) 2010-2011 Aron Racho <aron@mi-squred.com>
 //
 // This program is free software; you can redistribute it and/or
 // modify it under the terms of the GNU General Public License
 // as published by the Free Software Foundation; either version 2
 // of the License, or (at your option) any later version.
?>

<?php
/**
 * Description of RuleAction
 *
 * @author aron
 */
class RuleAction {
    var $guid;
    var $id;
    var $category;
    var $categoryLbl;
    var $item;
    var $itemLbl;
    var $reminderLink;
    var $reminderMessage;
    var $customRulesInput;
    var $groupId;
    var $targetCriteria;

    function __construct() {
    }

    function getTitle() {
        return getLabel( $this->category ) . " - " . getLabel( $this->item );
    }

    function getCategoryLabel() {
        if ( !$this->categoryLbl ) {
            $this->categoryLbl = getLabel( $this->category);
        }
        return $this->categoryLbl;
    }

    function getItemLabel() {
        if ( !$this->itemLbl ) {
            $this->itemLbl = getLabel( $this->item);
        }
        return $this->itemLbl;
    }
}
?>
