
CREATE TABLE IF NOT EXISTS `image_draw` (

id bigint(20) NOT NULL auto_increment,
    
date datetime default NULL,
    
pid bigint(20) default NULL,
    
user varchar(255) default NULL,

encounter bigint(20) DEFAULT NULL,    
groupname varchar(255) default NULL,
    
authorized tinyint(4) default NULL,
    
activity tinyint(4) default NULL,




deleted tinyint(4) NOT NULL DEFAULT '0' COMMENT 'flag indicates form has been deleted',
ImgName varchar(255) NOT NULL,
ImgType varchar(255) NOT NULL,
PRIMARY KEY (id)
) TYPE=MyISAM;


