--
--  Comment Meta Language for sql upgrades:
--
--  Each section within an upgrade sql file is enveloped with an #If*/#EndIf block.  At first glance, these appear to be standard mysql 
--  comments meant to be cryptic hints to -other developers about the sql goodness contained therein.  However, were you to rely on such basic premises,
--  you would find yourself grossly decieved.  Indeed, without the knowledge that these comments are, in fact a sneakily embedded meta langauge derived 
--  for a purpose none-other than to aid in the protection of the database during upgrades,  you would no doubt be subject to much ridicule and public 
--  beratement at the hands of the very developers who envisioned such a crafty use of comments. -jwallace
--
--  While these lines are as enigmatic as they are functional, there is a method to the madness.  Let's take a moment to briefly go over proper comment meta language use.
--  
--  The #If* sections have the behavior of functions and come complete with arguments supplied command-line style 
--
--  Your Comment meta language lines cannot contain any other comment styles such as the nefarious double dashes "--" lest your lines be skipped and 
--  the blocks automatcially executed with out regard to the existing database state.   
--
--  Comment Meta Language Constructs:
-- 
--  #IfNotTable
--    argument: table_name
--    behavior: if the table_name does not exist,  the block will be executed

--  #IfTable
--    argument: table_name
--    behavior: if the table_name does exist, the block will be executed

--  #IfMissingColumn
--    arguments: table_name colname
--    behavior:  if the colname in the table_name table does not exist,  the block will be executed

--  #IfNotColumnType
--    arguments: table_name colname value
--    behavior:  If the table table_name does not have a column colname with a data type equal to value, then the block will be executed

--  #IfNotRow
--    arguments: table_name colname value
--    behavior:  If the table table_name does not have a row where colname = value, the block will be executed.

--  #IfNotRow2D
--    arguments: table_name colname value colname2 value2
--    behavior:  If the table table_name does not have a row where colname = value AND colname2 = value2, the block will be executed.

--  #IfNotRow2Dx2
--    desc:      This is a very specialized function to allow adding items to the list_options table to avoid both redundant option_id and title in each element.
--    arguments: table_name colname value colname2 value2 colname3 value3
--    behavior:  The block will be executed if both statements below are true:
--               1) The table table_name does not have a row where colname = value AND colname2 = value2.
--               2) The table table_name does not have a row where colname = value AND colname3 = value3.

--  #EndIf
--    all blocks are terminated with and #EndIf statement. 

#IfMissingColumn log patient_id
ALTER TABLE log ADD patient_id bigint(20) DEFAULT NULL;
#EndIf

#IfMissingColumn log success
ALTER TABLE log ADD success tinyint(1) DEFAULT 1;
#EndIf

#IfMissingColumn log checksum
ALTER TABLE log ADD checksum longtext DEFAULT NULL;
#EndIf

#IfMissingColumn log crt_user
ALTER TABLE log ADD crt_user varchar(255) DEFAULT NULL;
#EndIf

#IfNotRow2Dx2 list_options list_id language option_id armenian title Armenian
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'armenian', 'Armenian', 10, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id chinese title Chinese
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'chinese', 'Chinese', 20, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id danish title Danish
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'danish', 'Danish', 30, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id deaf title Deaf
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'deaf', 'Deaf', 40, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id farsi title Farsi
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'farsi', 'Farsi', 60, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id french title French
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'french', 'French', 70, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id german title German
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'german', 'German', 80, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id greek title Greek
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'greek', 'Greek', 90, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id hmong title Hmong
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'hmong', 'Hmong', 100, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id italian title Italian
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'italian', 'Italian', 110, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id japanese title Japanese
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'japanese', 'Japanese', 120, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id korean title Korean
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'korean', 'Korean', 130, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id laotian title Laotian
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'laotian', 'Laotian', 140, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id mien title Mien
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'mien', 'Mien', 150, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id norwegian title Norwegian
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'norwegian', 'Norwegian', 160, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id othrs title Others
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'othrs', 'Others', 170, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id portuguese title Portuguese
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'portuguese', 'Portuguese', 180, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id punjabi title Punjabi
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'punjabi', 'Punjabi', 190, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id russian title Russian
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'russian', 'Russian', 200, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id tagalog title Tagalog
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'tagalog', 'Tagalog', 220, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id turkish title Turkish
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'turkish', 'Turkish', 230, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id vietnamese title Vietnamese
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'vietnamese', 'Vietnamese', 240, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id yiddish title Yiddish
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'yiddish', 'Yiddish', 250, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id language option_id zulu title Zulu
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'zulu', 'Zulu', 260, 0);
#EndIf

update list_options set seq = 50 where list_id = 'language' and option_id = 'English';
update list_options set seq = 210 where list_id = 'language' and option_id = 'Spanish';

#IfNotRow2Dx2 list_options list_id ethrace option_id aleut title ALEUT
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'aleut', 'ALEUT', 10,  0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id amer_indian title American Indian
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'amer_indian', 'American Indian', 20, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id cambodian title Cambodian
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'cambodian', 'Cambodian', 50, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id cs_american title Central/South American
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'cs_american', 'Central/South American', 70, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id chinese title Chinese
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'chinese', 'Chinese', 80, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id cuban title Cuban
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'cuban', 'Cuban', 90, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id eskimo title Eskimo
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'eskimo', 'Eskimo', 100, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id filipino title Filipino
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'filipino', 'Filipino', 110, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id guamanian title Guamanian
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'guamanian', 'Guamanian', 120, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id hawaiian title Hawaiian
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'hawaiian', 'Hawaiian', 130, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id othr_us title Hispanic - Other (Born in US)
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'othr_us', 'Hispanic - Other (Born in US)', 150, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id othr_non_us title Hispanic - Other (Born outside US)
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'othr_non_us', 'Hispanic - Other (Born outside US)', 160, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id hmong title Hmong
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'hmong', 'Hmong', 170, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id indian title Indian
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'indian', 'Indian', 180, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id japanese title Japanese
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'japanese', 'Japanese', 190, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id korean title Korean
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'korean', 'Korean', 200, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id laotian title Laotian
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'laotian', 'Laotian', 210, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id mexican title Mexican/MexAmer/Chicano
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'mexican', 'Mexican/MexAmer/Chicano', 220, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id mlt-race title Multiracial
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'mlt-race', 'Multiracial', 230, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id othr title Other
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'othr', 'Other', 240, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id othr_spec title Other - Specified
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'othr_spec', 'Other - Specified', 250, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id pac_island title Pacific Islander
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'pac_island', 'Pacific Islander', 260, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id puerto_rican title Puerto Rican
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'puerto_rican', 'Puerto Rican', 270, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id refused title Refused To State
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'refused', 'Refused To State', 280, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id samoan title Samoan
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'samoan', 'Samoan', 290, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id spec title Specified
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'spec', 'Specified', 300, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id thai title Thai
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'thai', 'Thai', 310, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id unknown title Unknown
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'unknown', 'Unknown', 320, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id unspec title Unspecified
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'unspec', 'Unspecified', 330, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id vietnamese title Vietnamese
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'vietnamese', 'Vietnamese', 340, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id white title White
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'white', 'White', 350, 0);
#EndIf
#IfNotRow2Dx2 list_options list_id ethrace option_id withheld title Withheld
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'withheld', 'Withheld', 360, 0);
#EndIf

update list_options set seq = 60 where list_id = 'ethrace' and option_id = 'Caucasian';
update list_options set seq = 30 where list_id = 'ethrace' and option_id = 'Asian';
update list_options set seq = 40 where list_id = 'ethrace' and option_id = 'Black';
update list_options set seq = 140 where list_id = 'ethrace' and option_id = 'Hispanic';

#IfNotRow2D list_options list_id lists option_id eligibility
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists', 'eligibility', 'Eligibility', 47, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('eligibility', 'eligible', 'Eligible', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('eligibility', 'ineligible', 'Ineligible', 20, 0);
#EndIf

#IfNotRow2D layout_options form_id DEM field_id vfc
INSERT INTO `layout_options` VALUES ('DEM', 'vfc', '5Stats', 'VFC', 12, 1, 1, 20, 0, 'eligibility', 1, 1, '', '', 'Eligibility status for Vaccine for Children supplied vaccine');
#EndIf

#IfNotRow2D layout_options form_id DEM field_id mothersname
INSERT INTO `layout_options` VALUES ('DEM', 'mothersname', '2Contact', 'Mother''s Name', 6, 2, 1, 20, 63, '', 1, 1, '', '', '');
#EndIf

#IfNotRow2D layout_options form_id DEM field_id guardiansname
INSERT INTO `layout_options` VALUES ('DEM', 'guardiansname', '2Contact', 'Guardian''s Name', 7, 2, 1, 20, 63, '', 1, 1, '', '', '');
#EndIf

#IfNotRow2D layout_options form_id DEM field_id allow_imm_reg_use
INSERT INTO `layout_options` VALUES ('DEM', 'allow_imm_reg_use', '3Choices', 'Allow Immunization Registry Use', 9, 1, 1, 0, 0, 'yesno', 1, 1, '', '', '');
#EndIf

#IfNotRow2D layout_options form_id DEM field_id allow_imm_info_share
INSERT INTO `layout_options` VALUES ('DEM', 'allow_imm_info_share', '3Choices', 'Allow Immunization Info Sharing', 10, 1, 1, 0, 0, 'yesno', 1, 1, '', '', '');
#EndIf

#IfNotRow2D layout_options form_id DEM field_id allow_health_info_ex
INSERT INTO `layout_options` VALUES ('DEM', 'allow_health_info_ex', '3Choices', 'Allow Health Information Exchange', 11, 1, 1, 0, 0, 'yesno', 1, 1, '', '', '');
#EndIf

#IfMissingColumn patient_data vfc
ALTER TABlE patient_data
  ADD vfc varchar(255) NOT NULL DEFAULT '',
  ADD mothersname varchar(255) NOT NULL DEFAULT '',
  ADD guardiansname varchar(255) NOT NULL DEFAULT '',
  ADD allow_imm_reg_use varchar(255) NOT NULL DEFAULT '',
  ADD allow_imm_info_share varchar(255) NOT NULL DEFAULT '',
  ADD allow_health_info_ex varchar(255) NOT NULL DEFAULT '';
#EndIf

#IfNotRow categories name Advance Directive
  INSERT INTO categories select (select MAX(id) from categories) + 1, 'Advance Directive', '', 1, rght, rght + 7 from categories where name = 'Categories';
  INSERT INTO categories select (select MAX(id) from categories) + 1, 'Do Not Resuscitate Order', '', (select id from categories where name = 'Advance Directive'), rght + 1, rght + 2 from categories where name = 'Categories';
  INSERT INTO categories select (select MAX(id) from categories) + 1, 'Durable Power of Attorney', '', (select id from categories where name = 'Advance Directive'), rght + 3, rght + 4 from categories where name = 'Categories';
  INSERT INTO categories select (select MAX(id) from categories) + 1, 'Living Will', '', (select id from categories where name = 'Advance Directive'), rght + 5, rght + 6 from categories where name = 'Categories';
  UPDATE categories SET rght = rght + 8 WHERE name = 'Categories';
  UPDATE categories_seq SET id = (select MAX(id) from categories);
#EndIf

#IfMissingColumn patient_data completed_ad
ALTER TABLE patient_data
  ADD completed_ad VARCHAR(3) NOT NULL DEFAULT 'NO',
  ADD ad_reviewed date DEFAULT NULL;
#EndIf

#IfNotRow2D list_options list_id lists option_id apptstat
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'apptstat','Appointment Statuses', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','-'       ,'- None'              , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','*'       ,'* Reminder done'     ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','+'       ,'+ Chart pulled'      ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','x'       ,'x Canceled'          ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','?'       ,'? No show'           ,25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','@'       ,'@ Arrived'           ,30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','~'       ,'~ Arrived late'      ,35,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','!'       ,'! Left w/o visit'    ,40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','#'       ,'# Ins/fin issue'     ,45,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','<'       ,'< In exam room'      ,50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','>'       ,'> Checked out'       ,55,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','$'       ,'$ Coding done'       ,60,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('apptstat','%'       ,'% Canceled < 24h'    ,65,0);
ALTER TABLE openemr_postcalendar_events CHANGE pc_apptstatus pc_apptstatus varchar(15) NOT NULL DEFAULT '-';
#EndIf

#IfNotRow2D list_options list_id lists option_id transactions
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists', 'transactions', 'Transactions', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'Referral', 'Referral', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'Patient Request', 'Patient Request', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'Physician Request', 'Physician Request', 30, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'Legal', 'Legal', 40, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'Billing', 'Billing', 50, 0);
#EndIf

#IfNotRow2D layout_options form_id DEM field_id referral_source
INSERT INTO `layout_options` VALUES ('DEM', 'referral_source', '5Stats', 'Referral Source',10, 26, 1, 0, 0, 'refsource', 1, 1, '', '', 'How did they hear about us');
#EndIf

#IfMissingColumn list_options notes
ALTER TABLE list_options
  CHANGE mapping mapping varchar(31) NOT NULL DEFAULT '',
  ADD notes varchar(255) NOT NULL DEFAULT '';
#EndIf

#IfNotRow2D list_options list_id lists option_id warehouse
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','warehouse','Warehouses',21,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('warehouse','onsite','On Site', 5,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id abook_type
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','abook_type'  ,'Address Book Types'  , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('abook_type','ord_img','Imaging Service'     , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('abook_type','ord_imm','Immunization Service',10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('abook_type','ord_lab','Lab Service'         ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('abook_type','spe'    ,'Specialist'          ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('abook_type','vendor' ,'Vendor'              ,25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('abook_type','oth'    ,'Other'               ,95,0);
#EndIf

#IfMissingColumn users abook_type
ALTER TABLE users
  ADD abook_type varchar(31) NOT NULL DEFAULT '';
#EndIf

#IfNotRow2D list_options list_id lists option_id proc_type
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_type','Procedure Types', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_type','grp','Group'          ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_type','ord','Procedure Order',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_type','res','Discrete Result',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_type','rec','Recommendation' ,40,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id proc_body_site
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_body_site','Procedure Body Sites', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_body_site','arm'    ,'Arm'    ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_body_site','buttock','Buttock',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_body_site','oth'    ,'Other'  ,90,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id proc_specimen
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_specimen','Procedure Specimen Types', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_specimen','blood' ,'Blood' ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_specimen','saliva','Saliva',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_specimen','urine' ,'Urine' ,30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_specimen','oth'   ,'Other' ,90,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id proc_route
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_route','Procedure Routes', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_route','inj' ,'Injection',10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_route','oral','Oral'     ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_route','oth' ,'Other'    ,90,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id proc_lat
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_lat','Procedure Lateralities', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_lat','left' ,'Left'     ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_lat','right','Right'    ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_lat','bilat','Bilateral',30,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id proc_unit
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('lists','proc_unit','Procedure Units', 1);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','bool'       ,'Boolean'    ,  5);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','cu_mm'      ,'CU.MM'      , 10);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','fl'         ,'FL'         , 20);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','g_dl'       ,'G/DL'       , 30);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','gm_dl'      ,'GM/DL'      , 40);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','hmol_l'     ,'HMOL/L'     , 50);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','iu_l'       ,'IU/L'       , 60);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','mg_dl'      ,'MG/DL'      , 70);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','mil_cu_mm'  ,'Mil/CU.MM'  , 80);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','percent'    ,'Percent'    , 90);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','percentile' ,'Percentile' ,100);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','pg'         ,'PG'         ,110);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','ratio'      ,'Ratio'      ,120);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','thous_cu_mm','Thous/CU.MM',130);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','units'      ,'Units'      ,140);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','units_l'    ,'Units/L'    ,150);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','days'       ,'Days'       ,600);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','weeks'      ,'Weeks'      ,610);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','months'     ,'Months'     ,620);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','oth'        ,'Other'      ,990);
#EndIf

#IfNotRow2D list_options list_id lists option_id ord_priority
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','ord_priority','Order Priorities', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_priority','high'  ,'High'  ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_priority','normal','Normal',20,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id ord_status
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','ord_status','Order Statuses', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_status','pending' ,'Pending' ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_status','routed'  ,'Routed'  ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_status','complete','Complete',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_status','canceled','Canceled',40,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id proc_rep_status
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_rep_status','Procedure Report Statuses', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','final'  ,'Final'      ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','review' ,'Reviewed'   ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','prelim' ,'Preliminary',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','cancel' ,'Canceled'   ,40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','error'  ,'Error'      ,50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','correct','Corrected'  ,60,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id proc_res_abnormal
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_res_abnormal','Procedure Result Abnormal', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_abnormal','no'  ,'No'  ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_abnormal','yes' ,'Yes' ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_abnormal','high','High',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_abnormal','low' ,'Low' ,40,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id proc_res_status
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_res_status','Procedure Result Statuses', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','final'     ,'Final'      ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','prelim'    ,'Preliminary',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','cancel'    ,'Canceled'   ,30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','error'     ,'Error'      ,40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','correct'   ,'Corrected'  ,50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','incomplete','Incomplete' ,60,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id proc_res_bool
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_res_bool','Procedure Boolean Results', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_bool','neg' ,'Negative',10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_bool','pos' ,'Positive',20,0);
#EndIf

#IfNotTable procedure_type
CREATE TABLE `procedure_type` (
  `procedure_type_id`   bigint(20)   NOT NULL AUTO_INCREMENT,
  `parent`              bigint(20)   NOT NULL DEFAULT 0  COMMENT 'references procedure_type.procedure_type_id',
  `name`                varchar(63)  NOT NULL DEFAULT '' COMMENT 'name for this category, procedure or result type',
  `lab_id`              bigint(20)   NOT NULL DEFAULT 0  COMMENT 'references users.id, 0 means default to parent',
  `procedure_code`      varchar(31)  NOT NULL DEFAULT '' COMMENT 'code identifying this procedure',
  `procedure_type`      varchar(31)  NOT NULL DEFAULT '' COMMENT 'see list proc_type',
  `body_site`           varchar(31)  NOT NULL DEFAULT '' COMMENT 'where to do injection, e.g. arm, buttok',
  `specimen`            varchar(31)  NOT NULL DEFAULT '' COMMENT 'blood, urine, saliva, etc.',
  `route_admin`         varchar(31)  NOT NULL DEFAULT '' COMMENT 'oral, injection',
  `laterality`          varchar(31)  NOT NULL DEFAULT '' COMMENT 'left, right, ...',
  `description`         varchar(255) NOT NULL DEFAULT '' COMMENT 'descriptive text for procedure_code',
  `standard_code`       varchar(255) NOT NULL DEFAULT '' COMMENT 'industry standard code type and code (e.g. CPT4:12345)',
  `related_code`        varchar(255) NOT NULL DEFAULT '' COMMENT 'suggested code(s) for followup services if result is abnormal',
  `units`               varchar(31)  NOT NULL DEFAULT '' COMMENT 'default for procedure_result.units',
  `range`               varchar(255) NOT NULL DEFAULT '' COMMENT 'default for procedure_result.range',
  `seq`                 int(11)      NOT NULL default 0  COMMENT 'sequence number for ordering',
  PRIMARY KEY (`procedure_type_id`),
  KEY parent (parent)
) ENGINE=MyISAM;
#EndIf

#IfNotTable procedure_order
CREATE TABLE `procedure_order` (
  `procedure_order_id`     bigint(20)   NOT NULL AUTO_INCREMENT,
  `procedure_type_id`      bigint(20)   NOT NULL            COMMENT 'references procedure_type.procedure_type_id',
  `provider_id`            bigint(20)   NOT NULL DEFAULT 0  COMMENT 'references users.id',
  `patient_id`             bigint(20)   NOT NULL            COMMENT 'references patient_data.pid',
  `encounter_id`           bigint(20)   NOT NULL DEFAULT 0  COMMENT 'references form_encounter.encounter',
  `date_collected`         datetime     DEFAULT NULL        COMMENT 'time specimen collected',
  `date_ordered`           date         DEFAULT NULL,
  `order_priority`         varchar(31)  NOT NULL DEFAULT '',
  `order_status`           varchar(31)  NOT NULL DEFAULT '' COMMENT 'pending,routed,complete,canceled',
  `patient_instructions`   text         NOT NULL DEFAULT '',
  `activity`               tinyint(1)   NOT NULL DEFAULT 1  COMMENT '0 if deleted',
  `control_id`             bigint(20)   NOT NULL            COMMENT 'This is the CONTROL ID that is sent back from lab',
  PRIMARY KEY (`procedure_order_id`),
  KEY datepid (date_ordered, patient_id)
) ENGINE=MyISAM;
#EndIf

#IfNotTable procedure_report
CREATE TABLE `procedure_report` (
  `procedure_report_id` bigint(20)     NOT NULL AUTO_INCREMENT,
  `procedure_order_id`  bigint(20)     DEFAULT NULL   COMMENT 'references procedure_order.procedure_order_id',
  `date_collected`      datetime       DEFAULT NULL,
  `date_report`         date           DEFAULT NULL,
  `source`              bigint(20)     NOT NULL DEFAULT 0  COMMENT 'references users.id, who entered this data',
  `specimen_num`        varchar(63)    NOT NULL DEFAULT '',
  `report_status`       varchar(31)    NOT NULL DEFAULT '' COMMENT 'received,complete,error',
  `review_status`       varchar(31)    NOT NULL DEFAULT 'received' COMMENT 'panding reivew status: received,reviewed',
  PRIMARY KEY (`procedure_report_id`),
  KEY procedure_order_id (procedure_order_id)
) ENGINE=MyISAM; 
#EndIf

#IfNotTable procedure_result
CREATE TABLE `procedure_result` (
  `procedure_result_id` bigint(20)   NOT NULL AUTO_INCREMENT,
  `procedure_report_id` bigint(20)   NOT NULL            COMMENT 'references procedure_report.procedure_report_id',
  `procedure_type_id`   bigint(20)   NOT NULL            COMMENT 'references procedure_type.procedure_type_id',
  `date`                datetime     DEFAULT NULL        COMMENT 'lab-provided date specific to this result',
  `facility`            varchar(255) NOT NULL DEFAULT '' COMMENT 'lab-provided testing facility ID',
  `units`               varchar(31)  NOT NULL DEFAULT '',
  `result`              varchar(255) NOT NULL DEFAULT '',
  `range`               varchar(255) NOT NULL DEFAULT '',
  `abnormal`            varchar(31)  NOT NULL DEFAULT '' COMMENT 'no,yes,high,low',
  `comments`            text         NOT NULL DEFAULT '' COMMENT 'comments from the lab',
  `document_id`         bigint(20)   NOT NULL DEFAULT 0  COMMENT 'references documents.id if this result is a document',
  `result_status`       varchar(31)  NOT NULL DEFAULT '' COMMENT 'preliminary, cannot be done, final, corrected, incompete...etc.',
  PRIMARY KEY (`procedure_result_id`),
  KEY procedure_report_id (procedure_report_id)
) ENGINE=MyISAM; 
#EndIf

#IfMissingColumn history_data recreational_drugs
ALTER TABLE history_data ADD recreational_drugs longtext;
#EndIf

update layout_options set seq = 1, data_type = 28, titlecols = 1, datacols = 3 where form_id = 'HIS' and field_id = 'coffee';
update layout_options set seq = 6, data_type = 28, titlecols = 1, datacols = 3 where form_id = 'HIS' and field_id = 'exercise_patterns';
update layout_options set seq = 2, data_type = 28, titlecols = 1, datacols = 3 where form_id = 'HIS' and field_id = 'tobacco';
update layout_options set seq = 3, data_type = 28, titlecols = 1, datacols = 3 where form_id = 'HIS' and field_id = 'alcohol';
update layout_options set seq = 5, data_type = 28, titlecols = 1, datacols = 3 where form_id = 'HIS' and field_id = 'counseling';
update layout_options set seq = 7, data_type = 28, titlecols = 1, datacols = 3 where form_id = 'HIS' and field_id = 'hazardous_activities';
update layout_options set seq = 8, titlecols = 1, datacols = 3 where form_id = 'HIS' and field_id = 'sleep_patterns';
update layout_options set seq = 9, titlecols = 1, datacols = 3 where form_id = 'HIS' and field_id = 'seatbelt_use';

#IfNotRow2D layout_options form_id HIS field_id recreational_drugs
INSERT INTO layout_options (form_id, field_id, group_name, title, seq, data_type, uor, fld_length, max_length, list_id, titlecols, datacols, default_value, edit_options, description) VALUES ('HIS','recreational_drugs','4Lifestyle','Recreational Drugs',4,28,1,20,255,'',1,3,'','' ,'Recreational drugs use');
#EndIf

#IfMissingColumn users pwd_expiration_date
ALTER TABLE users ADD pwd_expiration_date date DEFAULT NULL;
#EndIf

#IfMissingColumn users pwd_history1
ALTER TABLE users ADD pwd_history1 longtext DEFAULT NULL;
#EndIf

#IfMissingColumn users pwd_history2
ALTER TABLE users ADD pwd_history2 longtext DEFAULT NULL;
#EndIf

#IfMissingColumn drug_inventory warehouse_id
ALTER TABLE drug_inventory
  ADD warehouse_id varchar(31) NOT NULL DEFAULT '';
#EndIf

#IfMissingColumn drug_inventory vendor_id
ALTER TABLE drug_inventory
  ADD vendor_id bigint(20) NOT NULL DEFAULT 0;
#EndIf

#IfMissingColumn drug_sales xfer_inventory_id
ALTER TABLE drug_sales
  ADD xfer_inventory_id int(11) NOT NULL DEFAULT 0;
#EndIf

#IfMissingColumn drugs allow_combining
ALTER TABLE drugs
  ADD allow_combining tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = allow filling an order from multiple lots',
  ADD allow_multiple  tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 = allow multiple lots at one warehouse';
#EndIf

#IfNotRow registry directory procedure_order
INSERT INTO `registry` VALUES ('Procedure Order', 1, 'procedure_order', NULL, 1, 1, '2010-02-25 00:00:00', 0, 'Administrative', '');
#EndIf

UPDATE registry SET category = 'Administrative' WHERE category = 'category' AND directory = 'fee_sheet';
UPDATE registry SET category = 'Administrative' WHERE category = 'category' AND directory = 'procedure_order';
UPDATE registry SET category = 'Administrative' WHERE category = 'category' AND directory = 'newpatient';
UPDATE registry SET category = 'Administrative' WHERE category = 'category' AND directory = 'misc_billing_options';
UPDATE registry SET category = 'Clinical' WHERE category = 'category';

#IfMissingColumn users default_warehouse
ALTER TABLE users ADD default_warehouse varchar(31) NOT NULL DEFAULT '';
#EndIf

UPDATE layout_options SET edit_options = 'N'  WHERE form_id = 'DEM' AND field_id = 'title'  AND edit_options = '';
UPDATE layout_options SET edit_options = 'CD' WHERE form_id = 'DEM' AND field_id = 'fname'  AND edit_options = 'C';
UPDATE layout_options SET edit_options = 'CD' WHERE form_id = 'DEM' AND field_id = 'lname'  AND edit_options = 'C';
UPDATE layout_options SET edit_options = 'ND' WHERE form_id = 'DEM' AND field_id = 'pubpid' AND edit_options = '';
UPDATE layout_options SET edit_options = 'N'  WHERE form_id = 'DEM' AND field_id = 'sex'    AND edit_options = '';

#IfNotRow2D list_options list_id lists option_id message_status
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'         ,'message_status','Message Status',45,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('message_status','Done'           ,'Done'         , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('message_status','Forwarded'      ,'Forwarded'    ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('message_status','New'            ,'New'          ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('message_status','Read'           ,'Read'         ,20,0);
#EndIf

#IfNotRow2D list_options list_id note_type option_id Lab Results
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Lab Results' ,'Lab Results', 15,0);
#EndIf
#IfNotRow2D list_options list_id note_type option_id New Orders
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','New Orders' ,'New Orders', 20,0);
#EndIf
#IfNotRow2D list_options list_id note_type option_id Patient Reminders
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Patient Reminders' ,'Patient Reminders', 25,0);
#EndIf

#IfMissingColumn pnotes message_status
ALTER TABLE pnotes
  ADD message_status VARCHAR(20) NOT NULL DEFAULT 'New';
#EndIf

#IfNotTable globals
CREATE TABLE `globals` (
  `gl_name`             varchar(63)    NOT NULL,
  `gl_index`            int(11)        NOT NULL DEFAULT 0,
  `gl_value`            varchar(255)   NOT NULL DEFAULT '',
  PRIMARY KEY (`gl_name`, `gl_index`)
) ENGINE=MyISAM; 
#EndIf

#IfNotTable lang_custom
CREATE TABLE lang_custom (
  `lang_description`   varchar(100)   NOT NULL default '',
  `lang_code`          char(2)        NOT NULL default '',
  `constant_name`      varchar(255)   NOT NULL default '',
  `definition`         mediumtext     NOT NULL default ''
) ENGINE=MyISAM;
#EndIf

#IfNotRow2D list_options list_id lists option_id irnpool
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'irnpool','Invoice Reference Number Pools', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes ) VALUES ('irnpool','main','Main',1,1,'000001');
#EndIf

#IfMissingColumn users irnpool
ALTER TABLE users ADD irnpool varchar(31) NOT NULL DEFAULT '';
#EndIf

#IfMissingColumn form_encounter invoice_refno
ALTER TABLE form_encounter ADD invoice_refno varchar(31) NOT NULL DEFAULT '';
#EndIf

#IfMissingColumn drug_sales notes
ALTER TABLE drug_sales
  ADD notes varchar(255) NOT NULL DEFAULT '';
#EndIf

#IfNotTable code_types
CREATE TABLE code_types (
  ct_key  varchar(15) NOT NULL           COMMENT 'short alphanumeric name',
  ct_id   int(11)     UNIQUE NOT NULL    COMMENT 'numeric identifier',
  ct_seq  int(11)     NOT NULL DEFAULT 0 COMMENT 'sort order',
  ct_mod  int(11)     NOT NULL DEFAULT 0 COMMENT 'length of modifier field',
  ct_just varchar(15) NOT NULL DEFAULT ''COMMENT 'ct_key of justify type, if any',
  ct_mask varchar(9)  NOT NULL DEFAULT ''COMMENT 'formatting mask for code values',
  ct_fee  tinyint(1)  NOT NULL default 0 COMMENT '1 if fees are used',
  ct_rel  tinyint(1)  NOT NULL default 0 COMMENT '1 if can relate to other code types',
  ct_nofs tinyint(1)  NOT NULL default 0 COMMENT '1 if to be hidden in the fee sheet',
  ct_diag tinyint(1)  NOT NULL default 0 COMMENT '1 if this is a diagnosis type',
  PRIMARY KEY (ct_key)
) ENGINE=MyISAM;
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag ) VALUES ('ICD9' , 2, 1, 2, ''    , 0, 0, 0, 1);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag ) VALUES ('CPT4' , 1, 2, 2, 'ICD9', 1, 0, 0, 0);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag ) VALUES ('HCPCS', 3, 3, 2, 'ICD9', 1, 0, 0, 0);
#EndIf

#IfNotRow2D list_options list_id lists option_id code_types
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('lists', 'code_types', 'Code Types', 1);
#EndIf

#IfMissingColumn codes reportable
ALTER TABLE `codes` 
  ADD `reportable` TINYINT(1) DEFAULT 0 COMMENT '0 = non-reportable, 1 = reportable';
#EndIf

#IfNotTable syndromic_surveillance
CREATE TABLE `syndromic_surveillance` (
  `id` bigint(20) NOT NULL auto_increment,
  `lists_id` bigint(20) NOT NULL,
  `submission_date` datetime NOT NULL,
  `filename` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY (`lists_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;
#EndIf

#IfMissingColumn lists reinjury_id
ALTER TABLE lists
  ADD reinjury_id bigint(20)  NOT NULL DEFAULT 0,
  ADD injury_part varchar(31) NOT NULL DEFAULT '',
  ADD injury_type varchar(31) NOT NULL DEFAULT '';
#EndIf

ALTER TABLE layout_options CHANGE description description text;

#IfMissingColumn transactions refer_reply_date
ALTER TABLE transactions ADD refer_reply_date date DEFAULT NULL;
#EndIf

#IfMissingColumn transactions reply_related_code
ALTER TABLE transactions ADD reply_related_code varchar(255) NOT NULL DEFAULT '';
#EndIf

#IfNotTable extended_log
CREATE TABLE `extended_log` (
  `id`          bigint(20)   NOT NULL AUTO_INCREMENT,
  `date`        datetime     DEFAULT NULL,
  `event`       varchar(255) DEFAULT NULL,
  `user`        varchar(255) DEFAULT NULL,
  `recipient`   varchar(255) DEFAULT NULL,
  `description` longtext,
  `patient_id`  bigint(20)   DEFAULT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1;
#EndIf

#IfNotRow2D list_options list_id lists option_id disclosure_type
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'disclosure_type','Disclosure Type', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('disclosure_type', 'disclosure-treatment', 'Treatment', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('disclosure_type', 'disclosure-payment', 'Payment', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('disclosure_type', 'disclosure-healthcareoperations', 'Health Care Operations', 30, 0);
#EndIf

#IfNotTable user_settings
CREATE TABLE `user_settings` (
  `setting_user`  bigint(20)   NOT NULL DEFAULT 0,
  `setting_label` varchar(63)  NOT NULL,
  `setting_value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`setting_user`, `setting_label`)
) ENGINE=MyISAM;
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'allergy_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'appointments_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'demographics_ps_expand', '0');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'dental_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'directives_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'disclosures_ps_expand', '0');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'immunizations_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'insurance_ps_expand', '0');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'medical_problem_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'medication_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'pnotes_ps_expand', '0');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'prescriptions_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'surgery_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'vitals_ps_expand', '1');
#EndIf

#IfNotRow2D list_options list_id lists option_id alert_status
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'       ,'alert_status','Alert Status',51,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_status','New'         ,'New'         , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_status','Read'        ,'Read'        , 10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_status','Done'        ,'Done'        , 15,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id alert_color
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'      ,'alert_color','Alert Color',50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_color','Black'      ,'Black'      ,5 ,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_color','Blue'       ,'Blue'       ,10 ,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_color','Brown'      ,'Brown'      ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_color','Green'      ,'Green'      ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_color','Purple'     ,'Purple'     ,25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_color','Red'        ,'Red'        ,30,0);
#EndIf

#IfNotTable clinical_alerts
CREATE TABLE `clinical_alerts` (
  `alert_id` bigint(20) NOT NULL auto_increment,
  `alert_name` varchar(255) default NULL,
  `plan_id` int(11) default NULL,
  `color` varchar(50) default NULL,
  `message` longtext,
  `past_due_message` longtext,
  `activated` bigint(20) DEFAULT '0',
  `responded` bigint(20) DEFAULT '0',
  PRIMARY KEY  (`alert_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;
#EndIf

#IfNotTable patient_alerts
CREATE TABLE `patient_alerts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `alert_id` bigint(20) NOT NULL COMMENT 'alert_id from clinical_alerts table',
  `pid` bigint(20) NOT NULL,
  `status` varchar(255) NOT NULL COMMENT 'Read, Done, New',
  `date_modified` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;
#EndIf

#IfNotRow2D list_options list_id lists option_id enrollment_status
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'            ,'enrollment_status','Enrollment Status',55,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('enrollment_status','patient_refused'  ,'Patient Refused'  , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('enrollment_status','in_progress'      ,'In Progress'      ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('enrollment_status','completed'        ,'Completed'        ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('enrollment_status','on_hold'          ,'On Hold'          ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('enrollment_status','cancelled'        ,'Cancelled'        ,25,0);
#EndIf

#IfNotRow2D list_options list_id lists option_id reminder_status
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'          ,'reminder_status','Reminder Status',60,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('reminder_status','sent'           ,'Sent'           , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('reminder_status','failed'         ,'Failed'         ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('reminder_status','pending'        ,'Pending'        ,15,1);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('reminder_status','on_hold'        ,'On Hold'        ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('reminder_status','cancelled'      ,'Cancelled'      ,25,0);
#EndIf

#IfNotTable health_plans
CREATE TABLE `health_plans` (
  `plan_id` bigint(20) NOT NULL auto_increment,
  `plan_name` varchar(255) DEFAULT NULL,
  `plan_description` longtext,
  `category` varchar(255) DEFAULT NULL COMMENT 'disease management,diabetes',
  `gender` varchar(255) DEFAULT NULL,
  `goals` longtext,
  `age_from` varchar(255) DEFAULT NULL,
  `age_to` varchar(255) DEFAULT NULL,
  `month_from` varchar(255) DEFAULT NULL,
  `month_to` varchar(255) DEFAULT NULL,
  `icd_include` longtext COMMENT '753.5::535::355',
  `cpt_include` longtext,
  `ndc_include` longtext COMMENT 'from Lexicomp or a free drug database',
  `allergy_include` longtext,
  `patient_history_include` longtext COMMENT 'e.g. smoking status',
  `lab_abnormal_result_include` longtext COMMENT 'from lab results table',
  `icd_exclude` longtext,
  `cpt_exclude` longtext,
  `ndc_exclude` longtext,
  `allergy_exclude` longtext,
  `patient_history_exclude` longtext,
  `lab_abnormal_result_exclude` longtext,
  `activation_status` varchar(255) DEFAULT NULL,
  PRIMARY KEY  (`plan_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, age_to, icd_include, activation_status) values (1, 'Heart Disease', 'A health plan for someone who has been diagnosed with any kind of heart disease related problem, including atherosclerosis and complications.', 'Start a proper care program to help the patient manage this disease.', 'disease_management', '', '50', '100', '429::429.0::429.1::429.2::429.3::429.4::429.5::429.6::429.7::429.8::429.9::429.71::429.79::429.81::429.82::429.83::429.89::440::440.0::440.1::440.2::440.3::440.4::440.8::440.9::440.20::440.21::440.22::440.23::440.24::440.29::440.30::440.31::440.32', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, icd_include, activation_status) values (2, 'Trauma Disorders', 'A health plan for someone who has been injured physically in accident or any kind of violence.', 'Reduce the risk of further injury to the patient and expediete recovery.', 'wellness', '', '800::800.0::800.1::800.2::800.3::800.4::800.5::800.6::800.7::800.8::800.9::800.00::800.01::800.02::800.03::800.04::800.05::800.06::800.09::800.10::800.11::800.12::800.13::800.14::800.15::800.16::800.19::800.20::800.21::800.22::800.23::800.24::800.25::800.26::800.29::800.30::800.31::800.32::800.33::800.34::800.35::800.36::800.39::800.40::800.41::800.42::800.43::800.44::800.45::800.46::800.49::800.50::800.51::800.52::800.53::800.54::800.55::800.56::800.59::800.60::800.61::800.62::800.63::800.64::800.65::800.66::800.69::800.70::800.71::800.72::800.73::800.74::800.75::800.76::800.79::800.80::800.81::800.82::800.83::800.84::800.85::800.86::800.89::800.90::800.91::800.92::800.93::800.94::800.95::800.96::800.99::801::801.0::801.1::801.2::801.3::801.4::801.5::801.6::801.7::801.8::801.9::801.00::801.01::801.02::801.03::801.04::801.05::801.06::801.09::801.10::801.11::801.12::801.13::801.14::801.15::801.16::801.19::801.20::801.21::801.22::801.23::801.24::801.25::801.26::801.29::801.30::801.31::801.32::801.33::801.34::801.35::801.36::801.39::801.40::801.41::801.42::801.43::801.44::801.45::801.46::801.49::801.50::801.51::801.52::801.53::801.54::801.55::801.56::801.59::801.60::801.61::801.62::801.63::801.64::801.65::801.66::801.69::801.70::801.71::801.72::801.73::801.74::801.75::801.76::801.79::801.80::801.81::801.82::801.83::801.84::801.85::801.86::801.89::801.90::801.91::801.92::801.93::801.94::801.95::801.96::801.99::802::802.0::802.1::802.2::802.3::802.4::802.5::802.6::802.7::802.8::802.9::802.20::802.21::802.22::802.23::802.24::802.25::802.26::802.27::802.28::802.29::802.30::802.31::802.32::802.33::802.34::802.35::802.36::802.37::802.38::802.39::803::803.0::803.1::803.2::803.3::803.4::803.5::803.6::803.7::803.8::803.9::803.00::803.01::803.02::803.03::803.04::803.05::803.06::803.09::803.10::803.11::803.12::803.13::803.14::803.15::803.16::803.19::803.20::803.21::803.22::803.23::803.24::803.25::803.26::803.29::803.30::803.31::803.32::803.33::803.34::803.35::803.36::803.39::803.40::803.41::803.42::803.43::803.44::803.45::803.46::803.49::803.50::803.51::803.52::803.53::803.54::803.55::803.56::803.59::803.60::803.61::803.62::803.63::803.64::803.65::803.66::803.69::803.70::803.71::803.72::803.73::803.74::803.75::803.76::803.79::803.80::803.81::803.82::803.83::803.84::803.85::803.86::803.89::803.90::803.91::803.92::803.93::803.94::803.95::803.96::803.99::804::804.0::804.1::804.2::804.3::804.4::804.5::804.6::804.7::804.8::804.9::804.00::804.01::804.02::804.03::804.04::804.05::804.06::804.09::804.10::804.11::804.12::804.13::804.14::804.15::804.16::804.19::804.20::804.21::804.22::804.23::804.24::804.25::804.26::804.29::804.30::804.31::804.32::804.33::804.34::804.35::804.36::804.39::804.40::804.41::804.42::804.43::804.44::804.45::804.46::804.49::804.50::804.51::804.52::804.53::804.54::804.55::804.56::804.59::804.60::804.61::804.62::804.63::804.64::804.65::804.66::804.69::804.70::804.71::804.72::804.73::804.74::804.75::804.76::804.79::804.80::804.81::804.82::804.83::804.84::804.85::804.86::804.89::804.90::804.91::804.92::804.93::804.94::804.95::804.96::804.99::805::805.0::805.1::805.2::805.3::805.4::805.5::805.6::805.7::805.8::805.9::805.00::805.01::805.02::805.03::805.04::805.05::805.06::805.07::805.08::805.10::805.11::805.12::805.13::805.14::805.15::805.16::805.17::805.18::806::806.0::806.1::806.2::806.3::806.4::806.5::806.6::806.7::806.8::806.9::806.00::806.01::806.02::806.03::806.04::806.05::806.06::806.07::806.08::806.09::806.10::806.11::806.12::806.13::806.14::806.15::806.16::806.17::806.18::806.19::806.20::806.21::806.22::806.23::806.24::806.25::806.26::806.27::806.28::806.29::806.30::806.31::806.32::806.33::806.34::806.35::806.36::806.37::806.38::806.39::806.60::806.61::806.62::806.69::806.70::806.71::806.72::806.79::807::807.0::807.1::807.2::807.3::807.4::807.5::807.6::807.00::807.01::807.02::807.03::807.04::807.05::807.06::807.07::807.08::807.09::807.10::807.11::807.12::807.13::807.14::807.15::807.16::807.17::807.18::807.19::808::808.0::808.1::808.2::808.3::808.4::808.5::808.8::808.9::808.41::808.42::808.43::808.49::808.51::808.52::808.53::808.59::809::809.0::809.1::810::810.0::810.1::810.00::810.01::810.02::810.03::810.10::810.11::810.12::810.13::811::811.0::811.1::811.00::811.01::811.02::811.03::811.09::811.10::811.11::811.12::811.13::811.19::812::812.0::812.1::812.2::812.3::812.4::812.5::812.00::812.01::812.02::812.03::812.09::812.10::812.11::812.12::812.13::812.19::812.20::812.21::812.30::812.31::812.40::812.41::812.42::812.43::812.44::812.49::812.50::812.51::812.52::812.53::812.54::812.59::813::813.0::813.1::813.2::813.3::813.4::813.5::813.8::813.9::813.00::813.01::813.02::813.03::813.04::813.05::813.06::813.07::813.08::813.10::813.11::813.12::813.13::813.14::813.15::813.16::813.17::813.18::813.20::813.21::813.22::813.23::813.30::813.31::813.32::813.33::813.40::813.41::813.42::813.43::813.44::813.45::813.50::813.51::813.52::813.53::813.54::813.80::813.81::813.82::813.83::813.90::813.91::813.92::813.93::814::814.0::814.1::814.00::814.01::814.02::814.03::814.04::814.05::814.06::814.07::814.08::814.09::814.10::814.11::814.12::814.13::814.14::814.15::814.16::814.17::814.18::814.19::815::815.0::815.1::815.00::815.01::815.02::815.03::815.04::815.09::815.10::815.11::815.12::815.13::815.14::815.19::816::816.0::816.1::816.00::816.01::816.02::816.03::816.10::816.11::816.12::816.13::817::817.0::817.1::818::818.0::818.1::819::819.0::819.1::820::820.0::820.1::820.2::820.3::820.8::820.9::820.00::820.01::820.02::820.03::820.09::820.10::820.11::820.12::820.13::820.19::820.20::820.21::820.22::820.30::820.31::820.32::821::821.0::821.1::821.2::821.3::821.00::821.01::821.10::821.11::821.20::821.21::821.22::821.23::821.29::821.30::821.31::821.32::821.33::821.39::822::822.0::822.1::823::823.0::823.1::823.2::823.3::823.4::823.8::823.9::823.00::823.01::823.02::823.10::823.11::823.12::823.20::823.21::823.22::823.30::823.31::823.32::823.40::823.41::823.42::823.80::823.81::823.82::823.90::823.91::823.92::824::824.0::824.1::824.2::824.3::824.4::824.5::824.6::824.7::824.8::824.9::825::825.0::825.1::825.2::825.3::825.20::825.21::825.22::825.23::825.24::825.25::825.29::825.30::825.31::825.32::825.33::825.34::825.35::825.39::826::826.0::826.1::827::827.0::827.1::828::828.0::828.1::829::829.0::829.1::830::830.0::830.1::831::831.0::831.1::831.00::831.01::831.02::831.03::831.04::831.09::831.10::831.11::831.12::831.13::831.14::831.19::832::832.0::832.1::832.00::832.01::832.02::832.03::832.04::832.09::832.10::832.11::832.12::832.13::832.14::832.19::833::833.0::833.1::833.00::833.01::833.02::833.03::833.04::833.05::833.09::833.10::833.11::833.12::833.13::833.14::833.15::833.19::834::834.0::834.1::834.00::834.01::834.02::834.10::834.11::834.12::835::835.0::835.1::835.00::835.01::835.02::835.03::835.10::835.11::835.12::835.13::836::836.0::836.1::836.2::836.3::836.4::836.5::836.6::836.50::836.51::836.52::836.53::836.54::836.59::836.60::836.61::836.62::836.63::836.64::836.69::837::837.0::837.1::838::838.0::838.1::838.00::838.01::838.02::838.03::838.04::838.05::838.06::838.09::838.10::838.11::838.12::838.13::838.14::838.15::838.16::838.19::839::839.0::839.1::839.2::839.3::839.4::839.5::839.6::839.7::839.8::839.9::839.00::839.01::839.02::839.03::839.04::839.05::839.06::839.07::839.08::839.10::839.11::839.12::839.13::839.14::839.15::839.16::839.17::839.18::839.20::839.21::839.30::839.31::839.40::839.41::839.42::839.49::839.50::839.51::839.52::839.59::839.61::839.69::839.71::839.79::840::840.0::840.1::840.2::840.3::840.4::840.5::840.6::840.7::840.8::840.9::841::841.0::841.1::841.2::841.3::841.8::841.9::842::842.0::842.1::842.00::842.01::842.02::842.09::842.10::842.11::842.12::842.13::842.19::843::843.0::843.1::843.8::843.9::844::844.0::844.1::844.2::844.3::844.8::844.9::845::845.0::845.1::845.00::845.01::845.02::845.03::845.09::845.10::845.11::845.12::845.13::845.19::846::846.0::846.1::846.2::846.3::846.8::846.9::847::847.0::847.1::847.2::847.3::847.4::847.9::848::848.0::848.1::848.2::848.3::848.4::848.5::848.8::848.9::848.40::848.41::848.42::848.49::849::850::850.0::850.1::850.2::850.3::850.4::850.5::850.9::850.11::850.12::851::851.0::851.1::851.2::851.3::851.4::851.5::851.6::851.7::851.8::851.9::851.00::851.01::851.02::851.03::851.04::851.05::851.06::851.09::851.10::851.11::851.12::851.13::851.14::851.15::851.16::851.19::851.20::851.21::851.22::851.23::851.24::851.25::851.26::851.29::851.30::851.31::851.32::851.33::851.34::851.35::851.36::851.39::851.40::851.41::851.42::851.43::851.44::851.45::851.46::851.49::851.50::851.51::851.52::851.53::851.54::851.55::851.56::851.59::851.60::851.61::851.62::851.63::851.64::851.65::851.66::851.69::851.70::851.71::851.72::851.73::851.74::851.75::851.76::851.79::851.80::851.81::851.82::851.83::851.84::851.85::851.86::851.89::851.90::851.91::851.92::851.93::851.94::851.95::851.96::851.99::852::852.0::852.1::852.2::852.3::852.4::852.5::852.00::852.01::852.02::852.03::852.04::852.05::852.06::852.09::852.10::852.11::852.12::852.13::852.14::852.15::852.16::852.19::852.20::852.21::852.22::852.23::852.24::852.25::852.26::852.29::852.30::852.31::852.32::852.33::852.34::852.35::852.36::852.39::852.40::852.41::852.42::852.43::852.44::852.45::852.46::852.49::852.50::852.51::852.52::852.53::852.54::852.55::852.56::852.59::853::853.0::853.1::853.00::853.01::853.02::853.03::853.04::853.05::853.06::853.09::853.10::853.11::853.12::853.13::853.14::853.15::853.16::853.19::854::854.0::854.1::854.00::854.01::854.02::854.03::854.04::854.05::854.06::854.09::854.10::854.11::854.12::854.13::854.14::854.15::854.16::854.19::855::856::857::858::859::860::860.0::860.1::860.2::860.3::860.4::860.5::861::861.0::861.1::861.2::861.3::861.00::861.01::861.02::861.03::861.10::861.11::861.12::861.13::861.20::861.21::861.22::861.30::861.31::861.32::862::862.0::862.1::862.2::862.3::862.8::862.9::862.21::862.22::862.29::862.31::862.32::862.39::863::863.0::863.1::863.2::863.3::863.4::863.5::863.8::863.9::863.20::863.21::863.29::863.30::863.31::863.39::863.40::863.41::863.42::863.43::863.44::863.45::863.46::863.49::863.50::863.51::863.52::863.53::863.54::863.55::863.56::863.59::863.80::863.81::863.82::863.83::863.84::863.85::863.89::863.90::863.91::863.92::863.93::863.94::863.95::863.99::864::864.0::864.1::864.00::864.01::864.02::864.03::864.04::864.05::864.09::864.10::864.11::864.12::864.13::864.14::864.15::864.19::865::865.0::865.1::865.00::865.01::865.02::865.03::865.04::865.09::865.10::865.11::865.12::865.13::865.14::865.19::866::866.0::866.1::866.00::866.01::866.02::866.03::866.10::866.11::866.12::866.13::867::867.0::867.1::867.2::867.3::867.4::867.5::867.6::867.7::867.8::867.9::868::868.0::868.1::868.00::868.01::868.02::868.03::868.04::868.09::868.10::868.11::868.12::868.13::868.14::868.19::869::869.0::869.1::870::870.0::870.1::870.2::870.3::870.4::870.8::870.9::871::871.0::871.1::871.2::871.3::871.4::871.5::871.6::871.7::871.9::872::872.0::872.1::872.6::872.7::872.8::872.9::872.00::872.01::872.02::872.10::872.11::872.12::872.61::872.62::872.63::872.64::872.69::872.71::872.72::872.73::872.74::872.79::873::873.0::873.1::873.2::873.3::873.4::873.5::873.6::873.7::873.8::873.9::873.20::873.21::873.22::873.23::873.29::873.30::873.31::873.32::873.33::873.39::873.40::873.41::873.42::873.43::873.44::873.49::873.50::873.51::873.52::873.53::873.54::873.59::873.60::873.61::873.62::873.63::873.64::873.65::873.69::873.70::873.71::873.72::873.73::873.74::873.75::873.79::874::874.0::874.1::874.2::874.3::874.4::874.5::874.8::874.9::874.00::874.01::874.02::874.10::874.11::874.12::875::875.0::875.1::876::876.0::876.1::877::877.0::877.1::878::878.0::878.1::878.2::878.3::878.4::878.5::878.6::878.7::878.8::878.9::879::879.0::879.1::879.2::879.3::879.4::879.5::879.6::879.7::879.8::879.9::880::880.0::880.1::880.2::880.00::880.01::880.02::880.03::880.09::880.10::880.11::880.12::880.13::880.19::880.20::880.21::880.22::880.23::880.29::881::881.0::881.1::881.2::881.00::881.01::881.02::881.10::881.11::881.12::881.20::881.21::881.22::882::882.0::882.1::882.2::883::883.0::883.1::883.2::884::884.0::884.1::884.2::885::885.0::885.1::886::886.0::886.1::887::887.0::887.1::887.2::887.3::887.4::887.5::887.6::887.7::888::889::890::890.0::890.1::890.2::891::891.0::891.1::891.2::892::892.0::892.1::892.2::893::893.0::893.1::893.2::894::894.0::894.1::894.2::895::895.0::895.1::896::896.0::896.1::896.2::896.3::897::897.0::897.1::897.2::897.3::897.4::897.5::897.6::897.7::898::899::900::900.0::900.1::900.8::900.9::900.00::900.01::900.02::900.03::900.81::900.82::900.89::901::901.0::901.1::901.2::901.3::901.4::901.8::901.9::901.40::901.41::901.42::901.81::901.82::901.83::901.89::902::902.0::902.1::902.2::902.3::902.4::902.5::902.8::902.9::902.10::902.11::902.19::902.20::902.21::902.22::902.23::902.24::902.25::902.26::902.27::902.29::902.31::902.32::902.33::902.34::902.39::902.40::902.41::902.42::902.49::902.50::902.51::902.52::902.53::902.54::902.55::902.56::902.59::902.81::902.82::902.87::902.89::903::903.0::903.1::903.2::903.3::903.4::903.5::903.8::903.9::903.00::903.01::903.02::904::904.0::904.1::904.2::904.3::904.4::904.5::904.6::904.7::904.8::904.9::904.40::904.41::904.42::904.50::904.51::904.52::904.53::904.54::905::905.0::905.1::905.2::905.3::905.4::905.5::905.6::905.7::905.8::905.9::906::906.0::906.1::906.2::906.3::906.4::906.5::906.6::906.7::906.8::906.9::907::907.0::907.1::907.2::907.3::907.4::907.5::907.9::908::908.0::908.1::908.2::908.3::908.4::908.5::908.6::908.9::909::909.0::909.1::909.2::909.3::909.4::909.5::909.9::910::910.0::910.1::910.2::910.3::910.4::910.5::910.6::910.7::910.8::910.9::911::911.0::911.1::911.2::911.3::911.4::911.5::911.6::911.7::911.8::911.9::912::912.0::912.1::912.2::912.3::912.4::912.5::912.6::912.7::912.8::912.9::913::913.0::913.1::913.2::913.3::913.4::913.5::913.6::913.7::913.8::913.9::914::914.0::914.1::914.2::914.3::914.4::914.5::914.6::914.7::914.8::914.9::915::915.0::915.1::915.2::915.3::915.4::915.5::915.6::915.7::915.8::915.9::916::916.0::916.1::916.2::916.3::916.4::916.5::916.6::916.7::916.8::916.9::917::917.0::917.1::917.2::917.3::917.4::917.5::917.6::917.7::917.8::917.9::918::918.0::918.1::918.2::918.9::919::919.0::919.1::919.2::919.3::919.4::919.5::919.6::919.7::919.8::919.9::920::921::921.0::921.1::921.2::921.3::921.9::922::922.0::922.1::922.2::922.3::922.4::922.8::922.9::922.31::922.32::922.33::923::923.0::923.1::923.2::923.3::923.8::923.9::923.00::923.01::923.02::923.03::923.09::923.10::923.11::923.20::923.21::924::924.0::924.1::924.2::924.3::924.4::924.5::924.8::924.9::924.00::924.01::924.10::924.11::924.20::924.21::925::925.1::925.2::926::926.0::926.1::926.8::926.9::926.11::926.12::926.19::927::927.0::927.1::927.2::927.3::927.8::927.9::927.00::927.01::927.02::927.03::927.09::927.10::927.11::927.20::927.21::928::928.0::928.1::928.2::928.3::928.8::928.9::928.00::928.01::928.10::928.11::928.20::928.21::929::929.0::929.9::930::930.0::930.1::930.2::930.8::930.9::931::932::933::933.0::933.1::934::934.0::934.1::934.8::934.9::935::935.0::935.1::935.2::936::937::938::939::939.0::939.1::939.2::939.3::939.9::940::940.0::940.1::940.2::940.3::940.4::940.5::940.9::941::941.0::941.1::941.2::941.3::941.4::941.5::941.00::941.01::941.02::941.03::941.04::941.05::941.06::941.07::941.08::941.09::941.10::941.11::941.12::941.13::941.14::941.15::941.16::941.17::941.18::941.19::941.20::941.21::941.22::941.23::941.24::941.25::941.26::941.27::941.28::941.29::941.30::941.31::941.32::941.33::941.34::941.35::941.36::941.37::941.38::941.39::941.40::941.41::941.42::941.43::941.44::941.45::941.46::941.47::941.48::941.49::941.50::941.51::941.52::941.53::941.54::941.55::941.56::941.57::941.58::941.59::942::942.0::942.1::942.2::942.3::942.4::942.5::942.00::942.01::942.02::942.03::942.04::942.05::942.09::942.10::942.11::942.12::942.13::942.14::942.15::942.19::942.20::942.21::942.22::942.23::942.24::942.25::942.29::942.30::942.31::942.32::942.33::942.34::942.35::942.39::942.40::942.41::942.42::942.43::942.44::942.45::942.49::942.50::942.51::942.52::942.53::942.54::942.55::942.59::943::943.0::943.1::943.2::943.3::943.4::943.5::943.00::943.01::943.02::943.03::943.04::943.05::943.06::943.09::943.10::943.11::943.12::943.13::943.14::943.15::943.16::943.19::943.20::943.21::943.22::943.23::943.24::943.25::943.26::943.29::943.30::943.31::943.32::943.33::943.34::943.35::943.36::943.39::943.40::943.41::943.42::943.43::943.44::943.45::943.46::943.49::943.50::943.51::943.52::943.53::943.54::943.55::943.56::943.59::944::944.0::944.1::944.2::944.3::944.4::944.5::944.00::944.01::944.02::944.03::944.04::944.05::944.06::944.07::944.08::944.10::944.11::944.12::944.13::944.14::944.15::944.16::944.17::944.18::944.20::944.21::944.22::944.23::944.24::944.25::944.26::944.27::944.28::944.30::944.31::944.32::944.33::944.34::944.35::944.36::944.37::944.38::944.40::944.41::944.42::944.43::944.44::944.45::944.46::944.47::944.48::944.50::944.51::944.52::944.53::944.54::944.55::944.56::944.57::944.58::945::945.0::945.1::945.2::945.3::945.4::945.5::945.00::945.01::945.02::945.03::945.04::945.05::945.06::945.09::945.10::945.11::945.12::945.13::945.14::945.15::945.16::945.19::945.20::945.21::945.22::945.23::945.24::945.25::945.26::945.29::945.30::945.31::945.32::945.33::945.34::945.35::945.36::945.39::945.40::945.41::945.42::945.43::945.44::945.45::945.46::945.49::945.50::945.51::945.52::945.53::945.54::945.55::945.56::945.59::946::946.0::946.1::946.2::946.3::946.4::946.5::947::947.0::947.1::947.2::947.3::947.4::947.8::947.9::948::948.0::948.1::948.2::948.3::948.4::948.5::948.6::948.7::948.8::948.9::948.00::948.10::948.11::948.20::948.21::948.22::948.30::948.31::948.32::948.33::948.40::948.41::948.42::948.43::948.44::948.50::948.51::948.52::948.53::948.54::948.55::948.60::948.61::948.62::948.63::948.64::948.65::948.66::948.70::948.71::948.72::948.73::948.74::948.75::948.76::948.77::948.80::948.81::948.82::948.83::948.84::948.85::948.86::948.87::948.88::948.90::948.91::948.92::948.93::948.94::948.95::948.96::948.97::948.98::948.99::949::949.0::949.1::949.2::949.3::949.4::949.5::950::950.0::950.1::950.2::950.3::950.9::951::951.0::951.1::951.2::951.3::951.4::951.5::951.6::951.7::951.8::951.9::952::952.0::952.1::952.2::952.3::952.4::952.8::952.9::952.00::952.01::952.02::952.03::952.04::952.05::952.06::952.07::952.08::952.09::952.10::952.11::952.12::952.13::952.14::952.15::952.16::952.17::952.18::952.19::953::953.0::953.1::953.2::953.3::953.4::953.5::953.8::953.9::954::954.0::954.1::954.8::954.9::955::955.0::955.1::955.2::955.3::955.4::955.5::955.6::955.7::955.8::955.9::956::956.0::956.1::956.2::956.3::956.4::956.5::956.8::956.9::957::957.0::957.1::957.8::957.9::958::958.0::958.1::958.2::958.3::958.4::958.5::958.6::958.7::958.8::958.9::958.90::958.91::958.92::958.93::958.99::959::959.0::959.1::959.2::959.3::959.4::959.5::959.6::959.7::959.8::959.9::959.01::959.09::959.11::959.12::959.13::959.14::959.19', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, age_to, icd_include, patient_history_include, activation_status) values (3, 'Cancer Screening', 'A health plan for those who have a cancel risk due to family history or tobacco use.', 'Screen the patient for potential cancer issue and start the treatment early if cancer is diagnosed.', 'disease_management', '', '40', '100', '140::140.0::140.1::140.3::140.4::140.5::140.6::140.8::140.9::141::141.0::141.1::141.2::141.3::141.4::141.5::141.6::141.8::141.9::142::142.0::142.1::142.2::142.8::142.9::143::143.0::143.1::143.8::143.9::144::144.0::144.1::144.8::144.9::145::145.0::145.1::145.2::145.3::145.4::145.5::145.6::145.8::145.9::146::146.0::146.1::146.2::146.3::146.4::146.5::146.6::146.7::146.8::146.9::147::147.0::147.1::147.2::147.3::147.8::147.9::148::148.0::148.1::148.2::148.3::148.8::148.9::149::149.0::149.1::149.8::149.9::150::150.0::150.1::150.2::150.3::150.4::150.5::150.8::150.9::151::151.0::151.1::151.2::151.3::151.4::151.5::151.6::151.8::151.9::152::152.0::152.1::152.2::152.3::152.8::152.9::153::153.0::153.1::153.2::153.3::153.4::153.5::153.6::153.7::153.8::153.9::154::154.0::154.1::154.2::154.3::154.8::155::155.0::155.1::155.2::156::156.0::156.1::156.2::156.8::156.9::157::157.0::157.1::157.2::157.3::157.4::157.8::157.9::158::158.0::158.8::158.9::159::159.0::159.1::159.8::159.9::160::160.0::160.1::160.2::160.3::160.4::160.5::160.8::160.9::161::161.0::161.1::161.2::161.3::161.8::161.9::162::162.0::162.2::162.3::162.4::162.5::162.8::162.9::163::163.0::163.1::163.8::163.9::164::164.0::164.1::164.2::164.3::164.8::164.9::165::165.0::165.8::165.9::166::167::168::169::170::170.0::170.1::170.2::170.3::170.4::170.5::170.6::170.7::170.8::170.9::171::171.0::171.2::171.3::171.4::171.5::171.6::171.7::171.8::171.9::172::172.0::172.1::172.2::172.3::172.4::172.5::172.6::172.7::172.8::172.9::173::173.0::173.1::173.2::173.3::173.4::173.5::173.6::173.7::173.8::173.9::174::174.0::174.1::174.2::174.3::174.4::174.5::174.6::174.8::174.9::175::175.0::175.9::176::176.0::176.1::176.2::176.3::176.4::176.5::176.8::176.9::177::178::179::180::180.0::180.1::180.8::180.9::181::182::182.0::182.1::182.8::183::183.0::183.2::183.3::183.4::183.5::183.8::183.9::184::184.0::184.1::184.2::184.3::184.4::184.8::184.9::185::186::186.0::186.9::187::187.1::187.2::187.3::187.4::187.5::187.6::187.7::187.8::187.9::188::188.0::188.1::188.2::188.3::188.4::188.5::188.6::188.7::188.8::188.9::189::189.0::189.1::189.2::189.3::189.4::189.8::189.9::190::190.0::190.1::190.2::190.3::190.4::190.5::190.6::190.7::190.8::190.9::191::191.0::191.1::191.2::191.3::191.4::191.5::191.6::191.7::191.8::191.9::192::192.0::192.1::192.2::192.3::192.8::192.9::193::194::194.0::194.1::194.3::194.4::194.5::194.6::194.8::194.9::195::195.0::195.1::195.2::195.3::195.4::195.5::195.8::196::196.0::196.1::196.2::196.3::196.5::196.6::196.8::196.9::197::197.0::197.1::197.2::197.3::197.4::197.5::197.6::197.7::197.8::198::198.0::198.1::198.2::198.3::198.4::198.5::198.6::198.7::198.8::198.81::198.82::198.89::199::199.0::199.1::199.2::200::200.0::200.1::200.2::200.3::200.4::200.5::200.6::200.7::200.8::200.00::200.01::200.02::200.03::200.04::200.05::200.06::200.07::200.08::200.10::200.11::200.12::200.13::200.14::200.15::200.16::200.17::200.18::200.20::200.21::200.22::200.23::200.24::200.25::200.26::200.27::200.28::200.30::200.31::200.32::200.33::200.34::200.35::200.36::200.37::200.38::200.40::200.41::200.42::200.43::200.44::200.45::200.46::200.47::200.48::200.50::200.51::200.52::200.53::200.54::200.55::200.56::200.57::200.58::200.60::200.61::200.62::200.63::200.64::200.65::200.66::200.67::200.68::200.70::200.71::200.72::200.73::200.74::200.75::200.76::200.77::200.78::200.80::200.81::200.82::200.83::200.84::200.85::200.86::200.87::200.88::201::201.0::201.1::201.2::201.4::201.5::201.6::201.7::201.9::201.00::201.01::201.02::201.03::201.04::201.05::201.06::201.07::201.08::201.10::201.11::201.12::201.13::201.14::201.15::201.16::201.17::201.18::201.20::201.21::201.22::201.23::201.24::201.25::201.26::201.27::201.28::201.40::201.41::201.42::201.43::201.44::201.45::201.46::201.47::201.48::201.50::201.51::201.52::201.53::201.54::201.55::201.56::201.57::201.58::201.60::201.61::201.62::201.63::201.64::201.65::201.66::201.67::201.68::201.70::201.71::201.72::201.73::201.74::201.75::201.76::201.77::201.78::201.90::201.91::201.92::201.93::201.94::201.95::201.96::201.97::201.98::202::202.0::202.1::202.2::202.3::202.4::202.5::202.6::202.7::202.8::202.9::202.00::202.01::202.02::202.03::202.04::202.05::202.06::202.07::202.08::202.10::202.11::202.12::202.13::202.14::202.15::202.16::202.17::202.18::202.20::202.21::202.22::202.23::202.24::202.25::202.26::202.27::202.28::202.30::202.31::202.32::202.33::202.34::202.35::202.36::202.37::202.38::202.40::202.41::202.42::202.43::202.44::202.45::202.46::202.47::202.48::202.50::202.51::202.52::202.53::202.54::202.55::202.56::202.57::202.58::202.60::202.61::202.62::202.63::202.64::202.65::202.66::202.67::202.68::202.70::202.71::202.72::202.73::202.74::202.75::202.76::202.77::202.78::202.80::202.81::202.82::202.83::202.84::202.85::202.86::202.87::202.88::202.90::202.91::202.92::202.93::202.94::202.95::202.96::202.97::202.98::203::203.0::203.1::203.8::203.00::203.01::203.02::203.10::203.11::203.12::203.80::203.81::203.82::204::204.0::204.1::204.2::204.8::204.9::204.00::204.01::204.02::204.10::204.11::204.12::204.20::204.21::204.22::204.80::204.81::204.82::204.90::204.91::204.92::205::205.0::205.1::205.2::205.3::205.8::205.9::205.00::205.01::205.02::205.10::205.11::205.12::205.20::205.21::205.22::205.30::205.31::205.32::205.80::205.81::205.82::205.90::205.91::205.92::206::206.0::206.1::206.2::206.8::206.9::206.00::206.01::206.02::206.10::206.11::206.12::206.20::206.21::206.22::206.80::206.81::206.82::206.90::206.91::206.92::207::207.0::207.1::207.2::207.8::207.00::207.01::207.02::207.10::207.11::207.12::207.20::207.21::207.22::207.80::207.81::207.82::208::208.0::208.1::208.2::208.8::208.9::208.00::208.01::208.02::208.10::208.11::208.12::208.20::208.21::208.22::208.80::208.81::208.82::208.90::208.91::208.92::209::209.0::209.1::209.2::209.3::209.4::209.5::209.6::209.00::209.01::209.02::209.03::209.10::209.11::209.12::209.13::209.14::209.15::209.16::209.17::209.20::209.21::209.22::209.23::209.24::209.25::209.26::209.27::209.29::209.30::209.40::209.41::209.42::209.43::209.50::209.51::209.52::209.53::209.54::209.55::209.56::209.57::209.60::209.61::209.62::209.63::209.64::209.65::209.66::209.67::209.69::210::210.0::210.1::210.2::210.3::210.4::210.5::210.6::210.7::210.8::210.9::211::211.0::211.1::211.2::211.3::211.4::211.5::211.6::211.7::211.8::211.9::212::212.0::212.1::212.2::212.3::212.4::212.5::212.6::212.7::212.8::212.9::213::213.0::213.1::213.2::213.3::213.4::213.5::213.6::213.7::213.8::213.9::214::214.0::214.1::214.2::214.3::214.4::214.8::214.9::215::215.0::215.2::215.3::215.4::215.5::215.6::215.7::215.8::215.9::216::216.0::216.1::216.2::216.3::216.4::216.5::216.6::216.7::216.8::216.9::217::218::218.0::218.1::218.2::218.9::219::219.0::219.1::219.8::219.9::220::221::221.0::221.1::221.2::221.8::221.9::222::222.0::222.1::222.2::222.3::222.4::222.8::222.9::223::223.0::223.1::223.2::223.3::223.8::223.9::223.81::223.89::224::224.0::224.1::224.2::224.3::224.4::224.5::224.6::224.7::224.8::224.9::225::225.0::225.1::225.2::225.3::225.4::225.8::225.9::226::227::227.0::227.1::227.3::227.4::227.5::227.6::227.8::227.9::228::228.0::228.1::228.00::228.01::228.02::228.03::228.04::228.09::229::229.0::229.8::229.9::230::230.0::230.1::230.2::230.3::230.4::230.5::230.6::230.7::230.8::230.9::231::231.0::231.1::231.2::231.8::231.9::232::232.0::232.1::232.2::232.3::232.4::232.5::232.6::232.7::232.8::232.9::233::233.0::233.1::233.2::233.3::233.4::233.5::233.6::233.7::233.9::233.30::233.31::233.32::233.39::234::234.0::234.8::234.9::235::235.0::235.1::235.2::235.3::235.4::235.5::235.6::235.7::235.8::235.9::236::236.0::236.1::236.2::236.3::236.4::236.5::236.6::236.7::236.9::236.90::236.91::236.99::237::237.0::237.1::237.2::237.3::237.4::237.5::237.6::237.7::237.9::237.70::237.71::237.72::238::238.0::238.1::238.2::238.3::238.4::238.5::238.6::238.7::238.8::238.9::238.71::238.72::238.73::238.74::238.75::238.76::238.77::238.79::239::239.0::239.1::239.2::239.3::239.4::239.5::239.6::239.7::239.8::239.9', '||Current Tobacco', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, age_to, icd_include, activation_status) values (4, 'Mental Disorders', 'A health assessment for someone who is experiencing mental issue related to any of the followings: drug use, alcohol use, stress, sexual disorders, delusional, schizophrenic, etc.', 'Perform an assessment to decide if further treatment or referral is required.', 'wellness', '', '12', '100', '291::291.0::291.1::291.2::291.3::291.4::291.5::291.8::291.9::291.81::291.82::291.89::292::292.0::292.1::292.2::292.8::292.9::292.11::292.12::292.81::292.82::292.83::292.84::292.85::292.89::293::293.0::293.1::293.8::293.9::293.81::293.82::293.83::293.84::293.89::294::294.0::294.1::294.8::294.9::294.10::294.11::295::295.0::295.1::295.2::295.3::295.4::295.5::295.6::295.7::295.8::295.9::295.00::295.01::295.02::295.03::295.04::295.05::295.10::295.11::295.12::295.13::295.14::295.15::295.20::295.21::295.22::295.23::295.24::295.25::295.30::295.31::295.32::295.33::295.34::295.35::295.40::295.41::295.42::295.43::295.44::295.45::295.50::295.51::295.52::295.53::295.54::295.55::295.60::295.61::295.62::295.63::295.64::295.65::295.70::295.71::295.72::295.73::295.74::295.75::295.80::295.81::295.82::295.83::295.84::295.85::295.90::295.91::295.92::295.93::295.94::295.95::296::296.0::296.1::296.2::296.3::296.4::296.5::296.6::296.7::296.8::296.9::296.00::296.01::296.02::296.03::296.04::296.05::296.06::296.10::296.11::296.12::296.13::296.14::296.15::296.16::296.20::296.21::296.22::296.23::296.24::296.25::296.26::296.30::296.31::296.32::296.33::296.34::296.35::296.36::296.40::296.41::296.42::296.43::296.44::296.45::296.46::296.50::296.51::296.52::296.53::296.54::296.55::296.56::296.60::296.61::296.62::296.63::296.64::296.65::296.66::296.80::296.81::296.82::296.89::296.90::296.99::297::297.0::297.1::297.2::297.3::297.8::297.9::298::298.0::298.1::298.2::298.3::298.4::298.8::298.9::299::299.0::299.1::299.8::299.9::299.00::299.01::299.10::299.11::299.80::299.81::299.90::299.91::300::300.0::300.1::300.2::300.3::300.4::300.5::300.6::300.7::300.8::300.9::300.00::300.01::300.02::300.09::300.10::300.11::300.12::300.13::300.14::300.15::300.16::300.19::300.20::300.21::300.22::300.23::300.29::300.81::300.82::300.89::301::301.0::301.1::301.2::301.3::301.4::301.5::301.6::301.7::301.8::301.9::301.10::301.11::301.12::301.13::301.20::301.21::301.22::301.50::301.51::301.59::301.81::301.82::301.83::301.84::301.89::302::302.0::302.1::302.2::302.3::302.4::302.5::302.6::302.7::302.8::302.9::302.50::302.51::302.52::302.53::302.70::302.71::302.72::302.73::302.74::302.75::302.76::302.79::302.81::302.82::302.83::302.84::302.85::302.89::303::303.0::303.9::303.00::303.01::303.02::303.03::303.90::303.91::303.92::303.93::304::304.0::304.1::304.2::304.3::304.4::304.5::304.6::304.7::304.8::304.9::304.00::304.01::304.02::304.03::304.10::304.11::304.12::304.13::304.20::304.21::304.22::304.23::304.30::304.31::304.32::304.33::304.40::304.41::304.42::304.43::304.50::304.51::304.52::304.53::304.60::304.61::304.62::304.63::304.70::304.71::304.72::304.73::304.80::304.81::304.82::304.83::304.90::304.91::304.92::304.93::305::305.0::305.1::305.2::305.3::305.4::305.5::305.6::305.7::305.8::305.9::305.00::305.01::305.02::305.03::305.20::305.21::305.22::305.23::305.30::305.31::305.32::305.33::305.40::305.41::305.42::305.43::305.50::305.51::305.52::305.53::305.60::305.61::305.62::305.63::305.70::305.71::305.72::305.73::305.80::305.81::305.82::305.83::305.90::305.91::305.92::305.93::306::306.0::306.1::306.2::306.3::306.4::306.5::306.6::306.7::306.8::306.9::306.50::306.51::306.52::306.53::306.59::307::307.0::307.1::307.2::307.3::307.4::307.5::307.6::307.7::307.8::307.9::307.20::307.21::307.22::307.23::307.40::307.41::307.42::307.43::307.44::307.45::307.46::307.47::307.48::307.49::307.50::307.51::307.52::307.53::307.54::307.59::307.80::307.81::307.89::308::308.0::308.1::308.2::308.3::308.4::308.9::309::309.0::309.1::309.2::309.3::309.4::309.8::309.9::309.21::309.22::309.23::309.24::309.28::309.29::309.81::309.82::309.83::309.89::310::310.0::310.1::310.2::310.8::310.9::311::312::312.0::312.1::312.2::312.3::312.4::312.8::312.9::312.00::312.01::312.02::312.03::312.10::312.11::312.12::312.13::312.20::312.21::312.22::312.23::312.30::312.31::312.32::312.33::312.34::312.35::312.39::312.81::312.82::312.89::313::313.0::313.1::313.2::313.3::313.8::313.9::313.21::313.22::313.23::313.81::313.82::313.83::313.89::314::314.0::314.1::314.2::314.8::314.9::314.00::314.01::315::315.0::315.1::315.2::315.3::315.4::315.5::315.8::315.9::315.00::315.01::315.02::315.09::315.31::315.32::315.34::315.39::316', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, icd_include, activation_status) values (5, 'Asthma', 'A health plan for someone who is experiencing Asthma-like symptoms and/or has already been diagnosed as having Asthma.', 'Perform an assessment to enable the patient receive proper Asthma care.', 'disease_management', '', '10', '493::493.0::493.1::493.2::493.8::493.9::493.00::493.01::493.02::493.10::493.11::493.12::493.20::493.21::493.22::493.81::493.82::493.90::493.91::493.92', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, icd_include, activation_status) values (6, 'Hypertension', 'A health plan for someone who has high blood pressure or been diagnosed with any kind of hypertensive heart and kidney diseases.', 'Enable the patient to develop a healthy lifestyle and reduce the risk of heart diseases.', 'disease_management', '', '401::401.0::401.1::401.9::402::402.0::402.1::402.9::402.00::402.01::402.10::402.11::402.90::402.91::403::403.0::403.1::403.9::403.00::403.01::403.10::403.11::403.90::403.91::404::404.0::404.1::404.9::404.00::404.01::404.02::404.03::404.10::404.11::404.12::404.13::404.90::404.91::404.92::404.93::405::405.0::405.1::405.9::405.01::405.09::405.11::405.19::405.91::405.99', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, icd_include, activation_status) values (7, 'Diabetes Type 2', 'A health plan for someone who is diagnosed with diabetes type 2.', 'Enroll patients aged 18 through 75 years with diabetes mellitus and help them lower their hemoglobin A1c to less than 9.0%.', 'disease_management', '', '10', '249::249.0::249.1::249.2::249.3::249.4::249.5::249.6::249.7::249.8::249.9::249.00::249.01::249.10::249.11::249.20::249.21::249.30::249.31::249.40::249.41::249.50::249.51::249.60::249.61::249.70::249.71::249.80::249.81::249.90::249.91::250::250.0::250.1::250.2::250.3::250.4::250.5::250.6::250.7::250.8::250.9::250.00::250.01::250.02::250.03::250.10::250.11::250.12::250.13::250.20::250.21::250.22::250.23::250.30::250.31::250.32::250.33::250.40::250.41::250.42::250.43::250.50::250.51::250.52::250.53::250.60::250.61::250.62::250.63::250.70::250.71::250.72::250.73::250.80::250.81::250.82::250.83::250.90::250.91::250.92::250.93', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, age_to, icd_include, activation_status) values (8, 'Osteoarthritis and Joint Diseases', 'A health plan for someone who has any kind of osteoarthritis or joint diseases.', 'Provide care to minimize injury and to recover from the osteoarthritis or joint diseases.', 'disease_management', '', '50', '100', '714::714.0::714.1::714.2::714.3::714.4::714.8::714.9::714.30::714.31::714.32::714.33::714.81::714.89::715::715.0::715.1::715.2::715.3::715.8::715.9::715.00::715.04::715.09::715.10::715.11::715.12::715.13::715.14::715.15::715.16::715.17::715.18::715.20::715.21::715.22::715.23::715.24::715.25::715.26::715.27::715.28::715.30::715.31::715.32::715.33::715.34::715.35::715.36::715.37::715.38::715.80::715.89::715.90::715.91::715.92::715.93::715.94::715.95::715.96::715.97::715.98::716::716.0::716.1::716.2::716.3::716.4::716.5::716.6::716.8::716.9::716.00::716.01::716.02::716.03::716.04::716.05::716.06::716.07::716.08::716.09::716.10::716.11::716.12::716.13::716.14::716.15::716.16::716.17::716.18::716.19::716.20::716.21::716.22::716.23::716.24::716.25::716.26::716.27::716.28::716.29::716.30::716.31::716.32::716.33::716.34::716.35::716.36::716.37::716.38::716.39::716.40::716.41::716.42::716.43::716.44::716.45::716.46::716.47::716.48::716.49::716.50::716.51::716.52::716.53::716.54::716.55::716.56::716.57::716.58::716.59::716.60::716.61::716.62::716.63::716.64::716.65::716.66::716.67::716.68::716.80::716.81::716.82::716.83::716.84::716.85::716.86::716.87::716.88::716.89::716.90::716.91::716.92::716.93::716.94::716.95::716.96::716.97::716.98::716.99::717::717.0::717.1::717.2::717.3::717.4::717.5::717.6::717.7::717.8::717.9::717.40::717.41::717.42::717.43::717.49::717.81::717.82::717.83::717.84::717.85::717.89::718::718.0::718.1::718.2::718.3::718.4::718.5::718.6::718.7::718.8::718.9::718.00::718.01::718.02::718.03::718.04::718.05::718.07::718.08::718.09::718.10::718.11::718.12::718.13::718.14::718.15::718.17::718.18::718.19::718.20::718.21::718.22::718.23::718.24::718.25::718.26::718.27::718.28::718.29::718.30::718.31::718.32::718.33::718.34::718.35::718.36::718.37::718.38::718.39::718.40::718.41::718.42::718.43::718.44::718.45::718.46::718.47::718.48::718.49::718.50::718.51::718.52::718.53::718.54::718.55::718.56::718.57::718.58::718.59::718.60::718.65::718.70::718.71::718.72::718.73::718.74::718.75::718.76::718.77::718.78::718.79::718.80::718.81::718.82::718.83::718.84::718.85::718.86::718.87::718.88::718.89::718.90::718.91::718.92::718.93::718.94::718.95::718.97::718.98::718.99::719::719.0::719.1::719.2::719.3::719.4::719.5::719.6::719.7::719.8::719.9::719.00::719.01::719.02::719.03::719.04::719.05::719.06::719.07::719.08::719.09::719.10::719.11::719.12::719.13::719.14::719.15::719.16::719.17::719.18::719.19::719.20::719.21::719.22::719.23::719.24::719.25::719.26::719.27::719.28::719.29::719.30::719.31::719.32::719.33::719.34::719.35::719.36::719.37::719.38::719.39::719.40::719.41::719.42::719.43::719.44::719.45::719.46::719.47::719.48::719.49::719.50::719.51::719.52::719.53::719.54::719.55::719.56::719.57::719.58::719.59::719.60::719.61::719.62::719.63::719.64::719.65::719.66::719.67::719.68::719.69::719.80::719.81::719.82::719.83::719.84::719.85::719.86::719.87::719.88::719.89::719.90::719.91::719.92::719.93::719.94::719.95::719.96::719.97::719.98::719.99::720::720.0::720.1::720.2::720.8::720.9::720.81::720.89::721::721.0::721.1::721.2::721.3::721.4::721.5::721.6::721.7::721.8::721.9::721.41::721.42::721.90::721.91', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, icd_include, activation_status) values (9, 'Back Problems', 'A health plan for someone who is experiencing back pain or has suffered injury of any kind, including disc disorders.', 'Enable the patient to minimize back pain, avoid complication, and recover from the back problems.', 'wellness', '', '20', '722::722.0::722.1::722.2::722.3::722.4::722.5::722.6::722.7::722.8::722.9::722.10::722.11::722.30::722.31::722.32::722.39::722.51::722.52::722.70::722.71::722.72::722.73::722.80::722.81::722.82::722.83::722.90::722.91::722.92::722.93::724::724.0::724.1::724.2::724.3::724.4::724.5::724.6::724.7::724.8::724.9::724.00::724.01::724.02::724.09::724.70::724.71::724.79::847::847.0::847.1::847.2::847.3::847.4::847.9::876::876.0::876.1', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, age_to, icd_include, activation_status) values (10, 'Normal Childbirth', 'A health plan designed for an expecting mother to help her prepare for a normal childbirth.', 'Enable the expecting mother to undergo a successful childbirth.', 'wellness', 'Female', '15', '45', '640::640.0::640.8::640.9::640.00::640.01::640.03::640.80::640.81::640.83::640.90::640.91::640.93::641::641.0::641.1::641.2::641.3::641.8::641.9::641.00::641.01::641.03::641.10::641.11::641.13::641.20::641.21::641.23::641.30::641.31::641.33::641.80::641.81::641.83::641.90::641.91::641.93::642::642.0::642.1::642.2::642.3::642.4::642.5::642.6::642.7::642.9::642.00::642.01::642.02::642.03::642.04::642.10::642.11::642.12::642.13::642.14::642.20::642.21::642.22::642.23::642.24::642.30::642.31::642.32::642.33::642.34::642.40::642.41::642.42::642.43::642.44::642.50::642.51::642.52::642.53::642.54::642.60::642.61::642.62::642.63::642.64::642.70::642.71::642.72::642.73::642.74::642.90::642.91::642.92::642.93::642.94::643::643.0::643.1::643.2::643.8::643.9::643.00::643.01::643.03::643.10::643.11::643.13::643.20::643.21::643.23::643.80::643.81::643.83::643.90::643.91::643.93::644::644.0::644.1::644.2::644.00::644.03::644.10::644.13::644.20::644.21::645::645.1::645.2::645.10::645.11::645.13::645.20::645.21::645.23::646::646.0::646.1::646.2::646.3::646.4::646.5::646.6::646.7::646.8::646.9::646.00::646.01::646.03::646.10::646.11::646.12::646.13::646.14::646.20::646.21::646.22::646.23::646.24::646.30::646.31::646.33::646.40::646.41::646.42::646.43::646.44::646.50::646.51::646.52::646.53::646.54::646.60::646.61::646.62::646.63::646.64::646.70::646.71::646.73::646.80::646.81::646.82::646.83::646.84::646.90::646.91::646.93::647::647.0::647.1::647.2::647.3::647.4::647.5::647.6::647.8::647.9::647.00::647.01::647.02::647.03::647.04::647.10::647.11::647.12::647.13::647.14::647.20::647.21::647.22::647.23::647.24::647.30::647.31::647.32::647.33::647.34::647.40::647.41::647.42::647.43::647.44::647.50::647.51::647.52::647.53::647.54::647.60::647.61::647.62::647.63::647.64::647.80::647.81::647.82::647.83::647.84::647.90::647.91::647.92::647.93::647.94::648::648.0::648.1::648.2::648.3::648.4::648.5::648.6::648.7::648.8::648.9::648.00::648.01::648.02::648.03::648.04::648.10::648.11::648.12::648.13::648.14::648.20::648.21::648.22::648.23::648.24::648.30::648.31::648.32::648.33::648.34::648.40::648.41::648.42::648.43::648.44::648.50::648.51::648.52::648.53::648.54::648.60::648.61::648.62::648.63::648.64::648.70::648.71::648.72::648.73::648.74::648.80::648.81::648.82::648.83::648.84::648.90::648.91::648.92::648.93::648.94::649::649.0::649.1::649.2::649.3::649.4::649.5::649.6::649.7::649.00::649.01::649.02::649.03::649.04::649.10::649.11::649.12::649.13::649.14::649.20::649.21::649.22::649.23::649.24::649.30::649.31::649.32::649.33::649.34::649.40::649.41::649.42::649.43::649.44::649.50::649.51::649.53::649.60::649.61::649.62::649.63::649.64::649.70::649.71::649.73::650::651::651.0::651.1::651.2::651.3::651.4::651.5::651.6::651.7::651.8::651.9::651.00::651.01::651.03::651.10::651.11::651.13::651.20::651.21::651.23::651.30::651.31::651.33::651.40::651.41::651.43::651.50::651.51::651.53::651.60::651.61::651.63::651.70::651.71::651.73::651.80::651.81::651.83::651.90::651.91::651.93::652::652.0::652.1::652.2::652.3::652.4::652.5::652.6::652.7::652.8::652.9::652.00::652.01::652.03::652.10::652.11::652.13::652.20::652.21::652.23::652.30::652.31::652.33::652.40::652.41::652.43::652.50::652.51::652.53::652.60::652.61::652.63::652.70::652.71::652.73::652.80::652.81::652.83::652.90::652.91::652.93::653::653.0::653.1::653.2::653.3::653.4::653.5::653.6::653.7::653.8::653.9::653.00::653.01::653.03::653.10::653.11::653.13::653.20::653.21::653.23::653.30::653.31::653.33::653.40::653.41::653.43::653.50::653.51::653.53::653.60::653.61::653.63::653.70::653.71::653.73::653.80::653.81::653.83::653.90::653.91::653.93::654::654.0::654.1::654.2::654.3::654.4::654.5::654.6::654.7::654.8::654.9::654.00::654.01::654.02::654.03::654.04::654.10::654.11::654.12::654.13::654.14::654.20::654.21::654.23::654.30::654.31::654.32::654.33::654.34::654.40::654.41::654.42::654.43::654.44::654.50::654.51::654.52::654.53::654.54::654.60::654.61::654.62::654.63::654.64::654.70::654.71::654.72::654.73::654.74::654.80::654.81::654.82::654.83::654.84::654.90::654.91::654.92::654.93::654.94::655::655.0::655.1::655.2::655.3::655.4::655.5::655.6::655.7::655.8::655.9::655.00::655.01::655.03::655.10::655.11::655.13::655.20::655.21::655.23::655.30::655.31::655.33::655.40::655.41::655.43::655.50::655.51::655.53::655.60::655.61::655.63::655.70::655.71::655.73::655.80::655.81::655.83::655.90::655.91::655.93::656::656.0::656.1::656.2::656.3::656.4::656.5::656.6::656.7::656.8::656.9::656.00::656.01::656.03::656.10::656.11::656.13::656.20::656.21::656.23::656.30::656.31::656.33::656.40::656.41::656.43::656.50::656.51::656.53::656.60::656.61::656.63::656.70::656.71::656.73::656.80::656.81::656.83::656.90::656.91::656.93::657::657.00::657.01::657.03::658::658.0::658.1::658.2::658.3::658.4::658.8::658.9::658.00::658.01::658.03::658.10::658.11::658.13::658.20::658.21::658.23::658.30::658.31::658.33::658.40::658.41::658.43::658.80::658.81::658.83::658.90::658.91::658.93::659::659.0::659.1::659.2::659.3::659.4::659.5::659.6::659.7::659.8::659.9::659.00::659.01::659.03::659.10::659.11::659.13::659.20::659.21::659.23::659.30::659.31::659.33::659.40::659.41::659.43::659.50::659.51::659.53::659.60::659.61::659.63::659.70::659.71::659.73::659.80::659.81::659.83::659.90::659.91::659.93::660::660.0::660.1::660.2::660.3::660.4::660.5::660.6::660.7::660.8::660.9::660.00::660.01::660.03::660.10::660.11::660.13::660.20::660.21::660.23::660.30::660.31::660.33::660.40::660.41::660.43::660.50::660.51::660.53::660.60::660.61::660.63::660.70::660.71::660.73::660.80::660.81::660.83::660.90::660.91::660.93::661::661.0::661.1::661.2::661.3::661.4::661.9::661.00::661.01::661.03::661.10::661.11::661.13::661.20::661.21::661.23::661.30::661.31::661.33::661.40::661.41::661.43::661.90::661.91::661.93::662::662.0::662.1::662.2::662.3::662.00::662.01::662.03::662.10::662.11::662.13::662.20::662.21::662.23::662.30::662.31::662.33::663::663.0::663.1::663.2::663.3::663.4::663.5::663.6::663.8::663.9::663.00::663.01::663.03::663.10::663.11::663.13::663.20::663.21::663.23::663.30::663.31::663.33::663.40::663.41::663.43::663.50::663.51::663.53::663.60::663.61::663.63::663.80::663.81::663.83::663.90::663.91::663.93::664::664.0::664.1::664.2::664.3::664.4::664.5::664.6::664.8::664.9::664.00::664.01::664.04::664.10::664.11::664.14::664.20::664.21::664.24::664.30::664.31::664.34::664.40::664.41::664.44::664.50::664.51::664.54::664.60::664.61::664.64::664.80::664.81::664.84::664.90::664.91::664.94::665::665.0::665.1::665.2::665.3::665.4::665.5::665.6::665.7::665.8::665.9::665.00::665.01::665.03::665.10::665.11::665.20::665.22::665.24::665.30::665.31::665.34::665.40::665.41::665.44::665.50::665.51::665.54::665.60::665.61::665.64::665.70::665.71::665.72::665.74::665.80::665.81::665.82::665.83::665.84::665.90::665.91::665.92::665.93::665.94::666::666.0::666.1::666.2::666.3::666.00::666.02::666.04::666.10::666.12::666.14::666.20::666.22::666.24::666.30::666.32::666.34::667::667.0::667.1::667.00::667.02::667.04::667.10::667.12::667.14::668::668.0::668.1::668.2::668.8::668.9::668.00::668.01::668.02::668.03::668.04::668.10::668.11::668.12::668.13::668.14::668.20::668.21::668.22::668.23::668.24::668.80::668.81::668.82::668.83::668.84::668.90::668.91::668.92::668.93::668.94::669::669.0::669.1::669.2::669.3::669.4::669.5::669.6::669.7::669.8::669.9::669.00::669.01::669.02::669.03::669.04::669.10::669.11::669.12::669.13::669.14::669.20::669.21::669.22::669.23::669.24::669.30::669.32::669.34::669.40::669.41::669.42::669.43::669.44::669.50::669.51::669.60::669.61::669.70::669.71::669.80::669.81::669.82::669.83::669.84::669.90::669.91::669.92::669.93::669.94::670::670.00::670.02::670.04::671::671.0::671.1::671.2::671.3::671.4::671.5::671.8::671.9::671.00::671.01::671.02::671.03::671.04::671.10::671.11::671.12::671.13::671.14::671.20::671.21::671.22::671.23::671.24::671.30::671.31::671.33::671.40::671.42::671.44::671.50::671.51::671.52::671.53::671.54::671.80::671.81::671.82::671.83::671.84::671.90::671.91::671.92::671.93::671.94::672::672.00::672.02::672.04::673::673.0::673.1::673.2::673.3::673.8::673.00::673.01::673.02::673.03::673.04::673.10::673.11::673.12::673.13::673.14::673.20::673.21::673.22::673.23::673.24::673.30::673.31::673.32::673.33::673.34::673.80::673.81::673.82::673.83::673.84::674::674.0::674.1::674.2::674.3::674.4::674.5::674.8::674.9::674.00::674.01::674.02::674.03::674.04::674.10::674.12::674.14::674.20::674.22::674.24::674.30::674.32::674.34::674.40::674.42::674.44::674.50::674.51::674.52::674.53::674.54::674.80::674.82::674.84::674.90::674.92::674.94::675::675.0::675.1::675.2::675.8::675.9::675.00::675.01::675.02::675.03::675.04::675.10::675.11::675.12::675.13::675.14::675.20::675.21::675.22::675.23::675.24::675.80::675.81::675.82::675.83::675.84::675.90::675.91::675.92::675.93::675.94::676::676.0::676.1::676.2::676.3::676.4::676.5::676.6::676.8::676.9::676.00::676.01::676.02::676.03::676.04::676.10::676.11::676.12::676.13::676.14::676.20::676.21::676.22::676.23::676.24::676.30::676.31::676.32::676.33::676.34::676.40::676.41::676.42::676.43::676.44::676.50::676.51::676.52::676.53::676.54::676.60::676.61::676.62::676.63::676.64::676.80::676.81::676.82::676.83::676.84::676.90::676.91::676.92::676.93::676.94::677::678::678.0::678.1::678.00::678.01::678.03::678.10::678.11::678.13::679::679.0::679.1::679.00::679.01::679.02::679.03::679.04::679.10::679.11::679.12::679.13::679.14', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, month_from, allergy_exclude, activation_status) values (11, 'Flu Shot', 'A annual health maintenance program for anyone who wants to reduce the chance of getting a seasonal flu. It\'s recommended for someone who is at a high risk of having serious seasonal flu-related complications or someone who lives with or provides care to high-risk population groups.', 'Administer flu shot to high-risk groups.', 'wellness', '', '6', 'Egg::Flu Shot', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, age_to, patient_history_include, activation_status) values (12, 'Smoking Cessation', 'A health plan for someone who is actively using any kind of tobacco products, except for smokeless tobacco.', 'Assist the patient quit smoking or switch to a smokeless tobacco within a certain period of time.', 'wellness', '', '10', '800', '||Current Tobacco', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, age_to, activation_status) values (13, 'Female Adults Less Than 50 Years Old', 'A general preventive health plan for female adults who are less than 50 years old.', 'Provides basic screening and health maintenance services to female adults who are generally healthy.', 'health_maintenance', 'Female', '19', '49', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, activation_status) values (14, 'Female Adults 50 Years and Above', 'A general preventive health plan for female adults who are 50 years and above.', 'Provides basic screening and health maintenance services to female adults who are generally healthy.', 'health_maintenance', 'Female', '50', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, age_to, activation_status) values (15, 'Male Adults Less Than 50 Years Old', 'A general preventive health plan for male adults who are less than 50 years old.', 'Provides basic screening and health maintenance services to male adults who are generally healthy.', 'health_maintenance', 'Male', '19', '49', 'deactivate');
insert into health_plans (plan_id, plan_name, plan_description, goals, category, gender, age_from, activation_status) values (16, 'Male Adults 50 Years and Above', 'A general preventive health plan for male adults who are 50 years and above.', 'Provides basic screening and health maintenance services to male adults who are generally healthy.', 'health_maintenance', 'Male', '50', 'deactivate');
#EndIf

#IfNotTable health_plan_actions
CREATE TABLE `health_plan_actions` (
  `action_id` bigint(20) NOT NULL auto_increment,
  `plan_id` bigint(20) DEFAULT NULL,
  `action_content` longtext,
  `frequency` varchar(10) DEFAULT NULL,
  `subactions` varchar(5) DEFAULT NULL,
  `action_targetdate` date DEFAULT NULL,
  `reminder_timeframe` smallint(4) DEFAULT NULL,
  `followup_timeframe` smallint(4) DEFAULT NULL,
  `completed` varchar(3) default NULL,
  PRIMARY KEY  (`action_id`),
  KEY `plan_id` (`plan_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (1, 'Lipid Panel', 4, '', '');
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (1, 'Go for Lipid Panel #1', '', '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (1, 'Go for Lipid Panel #2', '', '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (1, 'Go for Lipid Panel #3', '', '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (1, 'Go for Lipid Panel #4', '', '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (1, 'Manage nutrition', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (1, 'Start exercise regularly', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (1, 'Check blood pressure', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (1, 'Check with doctor regarding any needed medication', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (2, 'Ask for routine physican exams', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (2, 'Ask for helmet and car seat/seatbelt use education', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (3, 'Go for a mammograph or a prostate exam.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (3, 'Go for a chest x-ray (every 5 years)', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (3, 'Go for DRE/PSA testing (every year)', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (3, 'Ask for smoking cessation education', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (4, 'Complete mental questionnaire', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (4, 'Go for mental health education', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (5, 'Complete Asthma assessment questionnaire (every 1 year)', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (5, 'Ask for asthma inhaler', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (6, 'Monitor blood pressure every 3 months', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (6, 'Start an exercise program', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (6, 'Start a nutrition and weight loss program', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (7, 'A1C', 4, '', '');
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (7, 'Go for A1C #1', '', '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (7, 'Go for A1C #2', '', '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (7, 'Go for A1C #3', '', '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (7, 'Go for A1C #4', '', '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (7, 'Foot Exam', 2, '', '');
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (7, 'Go for foot exam #1', '', '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (7, 'Go for foot exam #2', '', '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (7, 'Go for a dilated eye exam', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (7, 'Go for a urinanalysis', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (8, 'Ask for routine physican exams', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (8, 'Start a nutrition and weight loss program', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (9, 'Ask for routine physican exams as needed', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (9, 'Ask for diagnostic tests: X-ray, MRI', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (9, 'Start an exercise program', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (9, 'Ask for ergonomic education', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (10, 'Ask for OB PANEL', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (10, 'Get prenatal education', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (10, 'Receive STD screening', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (10, 'Start a nutrition program', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (10, 'Check for immunizations and get them as needed', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (10, 'Receive education on use of alcohol, tobacco, and recreational drugs', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (10, 'Receive education on exercise and hazardous activities', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (11, 'Receive Influenza Vaccine', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (12, 'Go for smoking cessation education', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (13, 'Get a physical exam.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (13, 'Go for a skin exam.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (13, 'Get a mammogram.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (13, 'Go for a pap test.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (14, 'Get a physical exam.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (14, 'Go for a skin exam.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (14, 'Go for a mammogram.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (14, 'Get a pap test.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (14, 'Receive an osteoporosis check.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (14, 'Go for a flu shot every year.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (14, 'Receive an eye exam (Glucoma check).', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (14, 'Get a GI screening.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (15, 'Go for a physical exam.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (15, 'Get a cholesterol test.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (15, 'Get a skin exam.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (15, 'Go for a testicular screening.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (16, 'Go for a physical exam.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (16, 'Get a cholesterol test.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (16, 'Do a skin exam.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (16, 'Get a colorectal cancer screening.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (16, 'Go for a testicular screening.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (16, 'Get a prostate screening.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (16, 'Receive an eye exam (Glucoma check).', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (16, 'Get a GI screening.', 0, '', 7);
insert into health_plan_actions (plan_id, action_content, subactions, action_targetdate, reminder_timeframe) values (16, 'Go for a flu shot every year.', 0, '', 7);
#EndIf

#IfNotTable patient_reminders
CREATE TABLE `patient_reminders` (
 `reminder_id` bigint(20) NOT NULL auto_increment,
 `reminder_name` varchar(255) DEFAULT NULL COMMENT 'flu shot, smoking cessation',
 `patient_id` bigint(20) DEFAULT NULL COMMENT 'id from patient_data table',
 `scheduled_date` date DEFAULT NULL COMMENT 'cron job will be used to generate the reminders daily',
 `reminder_content` longtext,
 `sender_name` varchar(255) NOT NULL default '',
 `email_address` varchar(255) NOT NULL default '',
 `phone_number` varchar(255) NOT NULL default '',
 `enroll_id` bigint(20) DEFAULT NULL,
 `plan_id` bigint(20) DEFAULT NULL,
 `action_id` bigint(20) DEFAULT NULL,
 `date_modified` date DEFAULT NULL,
 `voice_status` varchar(255) DEFAULT NULL,
 `email_status` varchar(255) DEFAULT NULL,
 `mail_status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`reminder_id`),
  KEY `patient_id` (`patient_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1;
#EndIf

#IfNotTable health_plan_enrollment
CREATE TABLE `health_plan_enrollment` (
  `enroll_id` bigint(20) NOT NULL auto_increment,
  `patient_id` bigint(20) DEFAULT NULL,
  `plan_id` bigint(20) DEFAULT NULL,
  `signup_date` date DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `action_date` varchar(255) default NULL,
  `action_completed` varchar(255) default NULL,
  PRIMARY KEY (`enroll_id`),
  KEY `patient_id` (`patient_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1;
#EndIf

#IfNotRow2D list_options list_id lists option_id health_plan_categories
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'                 ,'health_plan_categories','Health Plan Categories',60,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('health_plan_categories','disease_management'    ,'Disease Management'    , 5,1);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('health_plan_categories','health_maintenance'    ,'Health Maintenance'    ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('health_plan_categories','wellness'              ,'Wellness'              ,15,0);
#EndIf
