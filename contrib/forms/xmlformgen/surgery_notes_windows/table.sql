CREATE TABLE IF NOT EXISTS `surgery_post` (
    /* both extended and encounter forms need a last modified date */
    date datetime default NULL comment 'last modified date',
    /* these fields are common to all encounter forms. */
    id bigint(20) NOT NULL auto_increment,
    pid bigint(20) NOT NULL default 0,
    user varchar(255) default NULL,
    groupname varchar(255) default NULL,
    authorized tinyint(4) default NULL,
    activity tinyint(4) default NULL,
    operation_date datetime default NULL,
    present_date datetime default NULL,
    patient_name varchar(255),
    reg_number varchar(20),
    provider_name int(11) default NULL,
    surg_incision TEXT,
    PRIMARY KEY (id)
) TYPE=InnoDB;

