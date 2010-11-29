CREATE TABLE IF NOT EXISTS `form_physical_sample` (
id bigint(20) NOT NULL auto_increment,
date datetime default NULL,
pid bigint(20) default NULL,
user varchar(255) default NULL,
groupname varchar(255) default NULL,
authorized tinyint(4) default NULL,
activity tinyint(4) default NULL,
chief_complaints TEXT,
surgical_history TEXT,
surgical_history_other TEXT,
medical_history TEXT,
medical_history_other TEXT,
allergies TEXT,
allergies_other TEXT,
smoke_history TEXT,
etoh_history TEXT,
last_mammogram DATE,

PRIMARY KEY (id)
) TYPE=MyISAM;
