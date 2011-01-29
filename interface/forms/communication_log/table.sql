CREATE TABLE IF NOT EXISTS `form_communication` (
    /* both extended and encounter forms need a last modified date */
    date datetime default NULL comment 'last modified date',
    /* these fields are common to all encounter forms. */
    id bigint(20) NOT NULL auto_increment,
    pid bigint(20) NOT NULL default 0,
    user varchar(255) default NULL,
    groupname varchar(255) default NULL,
    authorized tinyint(4) default NULL,
    activity tinyint(4) default NULL,
    effective_date datetime default NULL,
    contact_date datetime default NULL,
    contact_name varchar(255),
    phone varchar(15),
    direction varchar(255),
    contact_success varchar(255),
    reason TEXT,
    result TEXT,
    screener int(11) default NULL,
    signature_box varchar(60),
    PRIMARY KEY (id)
) TYPE=InnoDB;
CREATE TABLE IF NOT EXISTS `signatures` (
    /* a unique ID for each entry */
    id bigint(20) NOT NULL auto_increment,
    /* the name of the directory containing the form being signed */
    formname varchar(255) NOT NULL,
    /* the field to be checked */
    fieldname varchar(64) NOT NULL,
    /* how to check the field */
    relationship varchar(20) NOT NULL,
    /* what to check it against */
    constant varchar(255) NOT NULL,
    /* evaluation level */
    level tinyint(4) default NULL,
    /* how to compare this item to others of its level */
    peerrelationship varchar(20) default NULL,
    /* how to compare this item to items of the previous level */
    subordinaterelationship varchar(20) default NULL,
    PRIMARY KEY (id)
) TYPE=InnoDB;
INSERT INTO `signatures` set formname='communication_log',
    fieldname='signature_box',
    relationship='not-equal',
    constant='',
    level='0',
    peerrelationship='AND',
    subordinaterelationship='AND';
