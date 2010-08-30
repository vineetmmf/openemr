--
-- Database: `openemr`
-- 

-- --------------------------------------------------------

-- 
-- Table structure for table `addresses`
-- 

DROP TABLE IF EXISTS `addresses`;
CREATE TABLE `addresses` (
  `id` int(11) NOT NULL default '0',
  `line1` varchar(255) default NULL,
  `line2` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(35) default NULL,
  `zip` varchar(10) default NULL,
  `plus_four` varchar(4) default NULL,
  `country` varchar(255) default NULL,
  `foreign_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `foreign_id` (`foreign_id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `array`
-- 

DROP TABLE IF EXISTS `array`;
CREATE TABLE `array` (
  `array_key` varchar(255) default NULL,
  `array_value` longtext
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `batchcom`
-- 

DROP TABLE IF EXISTS `batchcom`;
CREATE TABLE `batchcom` (
  `id` bigint(20) NOT NULL auto_increment,
  `patient_id` int(11) NOT NULL default '0',
  `sent_by` bigint(20) NOT NULL default '0',
  `msg_type` varchar(60) default NULL,
  `msg_subject` varchar(255) default NULL,
  `msg_text` mediumtext,
  `msg_date_sent` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `billing`
-- 

DROP TABLE IF EXISTS `billing`;
CREATE TABLE `billing` (
  `id` int(11) NOT NULL auto_increment,
  `date` datetime default NULL,
  `code_type` varchar(7) default NULL,
  `code` varchar(9) default NULL,
  `pid` int(11) default NULL,
  `provider_id` int(11) default NULL,
  `user` int(11) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(1) default NULL,
  `encounter` int(11) default NULL,
  `code_text` longtext,
  `billed` tinyint(1) default NULL,
  `activity` tinyint(1) default NULL,
  `payer_id` int(11) default NULL,
  `bill_process` tinyint(2) NOT NULL default '0',
  `bill_date` datetime default NULL,
  `process_date` datetime default NULL,
  `process_file` varchar(255) default NULL,
  `modifier` varchar(5) default NULL,
  `units` tinyint(3) default NULL,
  `fee` decimal(12,2) default NULL,
  `justify` varchar(255) default NULL,
  `target` varchar(30) default NULL,
  `x12_partner_id` int(11) default NULL,
  `ndc_info` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `categories`
-- 

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `value` varchar(255) default NULL,
  `parent` int(11) NOT NULL default '0',
  `lft` int(11) NOT NULL default '0',
  `rght` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `parent` (`parent`),
  KEY `lft` (`lft`,`rght`)
) ENGINE=MyISAM;

-- 
-- Dumping data for table `categories`
-- 

INSERT INTO `categories` VALUES (1, 'Categories', '', 0, 0, 17);
INSERT INTO `categories` VALUES (2, 'Lab Report', '', 1, 1, 2);
INSERT INTO `categories` VALUES (3, 'Medical Record', '', 1, 3, 4);
INSERT INTO `categories` VALUES (4, 'Patient Information', '', 1, 5, 8);
INSERT INTO `categories` VALUES (5, 'Patient ID card', '', 4, 6, 7);
INSERT INTO `categories` VALUES (6, 'Advance Directive', '', 1, 9, 16);
INSERT INTO `categories` VALUES (7, 'Do Not Resuscitate Order', '', 6, 10, 11);
INSERT INTO `categories` VALUES (8, 'Durable Power of Attorney', '', 6, 12, 13);
INSERT INTO `categories` VALUES (9, 'Living Will', '', 6, 14, 15);

-- --------------------------------------------------------

-- 
-- Table structure for table `categories_seq`
-- 

DROP TABLE IF EXISTS `categories_seq`;
CREATE TABLE `categories_seq` (
  `id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- 
-- Dumping data for table `categories_seq`
-- 

INSERT INTO `categories_seq` VALUES (9);

-- --------------------------------------------------------

-- 
-- Table structure for table `categories_to_documents`
-- 

DROP TABLE IF EXISTS `categories_to_documents`;
CREATE TABLE `categories_to_documents` (
  `category_id` int(11) NOT NULL default '0',
  `document_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`category_id`,`document_id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `claims`
-- 

DROP TABLE IF EXISTS `claims`;
CREATE TABLE `claims` (
  `patient_id` int(11) NOT NULL,
  `encounter_id` int(11) NOT NULL,
  `version` int(10) unsigned NOT NULL auto_increment,
  `payer_id` int(11) NOT NULL default '0',
  `status` tinyint(2) NOT NULL default '0',
  `payer_type` tinyint(4) NOT NULL default '0',
  `bill_process` tinyint(2) NOT NULL default '0',
  `bill_time` datetime default NULL,
  `process_time` datetime default NULL,
  `process_file` varchar(255) default NULL,
  `target` varchar(30) default NULL,
  `x12_partner_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`patient_id`,`encounter_id`,`version`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `codes`
-- 

DROP TABLE IF EXISTS `codes`;
CREATE TABLE `codes` (
  `id` int(11) NOT NULL auto_increment,
  `code_text` varchar(255) NOT NULL default '',
  `code_text_short` varchar(24) NOT NULL default '',
  `code` varchar(10) NOT NULL default '',
  `code_type` tinyint(2) default NULL,
  `modifier` varchar(5) NOT NULL default '',
  `units` tinyint(3) default NULL,
  `fee` decimal(12,2) default NULL,
  `superbill` varchar(31) NOT NULL default '',
  `related_code` varchar(255) NOT NULL default '',
  `taxrates` varchar(255) NOT NULL default '',
  `cyp_factor` float NOT NULL DEFAULT 0 COMMENT 'quantity representing a years supply',
  `active` TINYINT(1) DEFAULT 1 COMMENT '0 = inactive, 1 = active',
  `reportable` TINYINT(1) DEFAULT 0 COMMENT '0 = non-reportable, 1 = reportable',
  PRIMARY KEY  (`id`),
  KEY `code` (`code`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;
-- --------------------------------------------------------

-- 
-- Table structure for table `syndromic_surveillance`
-- 

DROP TABLE IF EXISTS `syndromic_surveillance`;
CREATE TABLE `syndromic_surveillance` (
  `id` bigint(20) NOT NULL auto_increment,
  `lists_id` bigint(20) NOT NULL,
  `submission_date` datetime NOT NULL,
  `filename` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY (`lists_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `config`
-- 

DROP TABLE IF EXISTS `config`;
CREATE TABLE `config` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `value` varchar(255) default NULL,
  `parent` int(11) NOT NULL default '0',
  `lft` int(11) NOT NULL default '0',
  `rght` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `parent` (`parent`),
  KEY `lft` (`lft`,`rght`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `config_seq`
-- 

DROP TABLE IF EXISTS `config_seq`;
CREATE TABLE `config_seq` (
  `id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- 
-- Dumping data for table `config_seq`
-- 

INSERT INTO `config_seq` VALUES (0);

-- --------------------------------------------------------

-- 
-- Table structure for table `documents`
-- 

DROP TABLE IF EXISTS `documents`;
CREATE TABLE `documents` (
  `id` int(11) NOT NULL default '0',
  `type` enum('file_url','blob','web_url') default NULL,
  `size` int(11) default NULL,
  `date` datetime default NULL,
  `url` varchar(255) default NULL,
  `mimetype` varchar(255) default NULL,
  `pages` int(11) default NULL,
  `owner` int(11) default NULL,
  `revision` timestamp NOT NULL,
  `foreign_id` int(11) default NULL,
  `docdate` date default NULL,
  `list_id` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `revision` (`revision`),
  KEY `foreign_id` (`foreign_id`),
  KEY `owner` (`owner`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `drug_inventory`
-- 

DROP TABLE IF EXISTS `drug_inventory`;
CREATE TABLE `drug_inventory` (
  `inventory_id` int(11) NOT NULL auto_increment,
  `drug_id` int(11) NOT NULL,
  `lot_number` varchar(20) default NULL,
  `expiration` date default NULL,
  `manufacturer` varchar(255) default NULL,
  `on_hand` int(11) NOT NULL default '0',
  `warehouse_id` varchar(31) NOT NULL DEFAULT '',
  `vendor_id` bigint(20) NOT NULL DEFAULT 0,
  `last_notify` date NOT NULL default '0000-00-00',
  `destroy_date` date default NULL,
  `destroy_method` varchar(255) default NULL,
  `destroy_witness` varchar(255) default NULL,
  `destroy_notes` varchar(255) default NULL,
  PRIMARY KEY  (`inventory_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `drug_sales`
-- 

DROP TABLE IF EXISTS `drug_sales`;
CREATE TABLE `drug_sales` (
  `sale_id` int(11) NOT NULL auto_increment,
  `drug_id` int(11) NOT NULL,
  `inventory_id` int(11) NOT NULL,
  `prescription_id` int(11) NOT NULL default '0',
  `pid` int(11) NOT NULL default '0',
  `encounter` int(11) NOT NULL default '0',
  `user` varchar(255) default NULL,
  `sale_date` date NOT NULL,
  `quantity` int(11) NOT NULL default '0',
  `fee` decimal(12,2) NOT NULL default '0.00',
  `billed` tinyint(1) NOT NULL default '0' COMMENT 'indicates if the sale is posted to accounting',
  `xfer_inventory_id` int(11) NOT NULL DEFAULT 0,
  `notes` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY  (`sale_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `drug_templates`
-- 

DROP TABLE IF EXISTS `drug_templates`;
CREATE TABLE `drug_templates` (
  `drug_id` int(11) NOT NULL,
  `selector` varchar(255) NOT NULL default '',
  `dosage` varchar(10) default NULL,
  `period` int(11) NOT NULL default '0',
  `quantity` int(11) NOT NULL default '0',
  `refills` int(11) NOT NULL default '0',
  `taxrates` varchar(255) default NULL,
  PRIMARY KEY  (`drug_id`,`selector`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `drugs`
-- 

DROP TABLE IF EXISTS `drugs`;
CREATE TABLE `drugs` (
  `drug_id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL DEFAULT '',
  `ndc_number` varchar(20) NOT NULL DEFAULT '',
  `on_order` int(11) NOT NULL default '0',
  `reorder_point` int(11) NOT NULL default '0',
  `last_notify` date NOT NULL default '0000-00-00',
  `reactions` text,
  `form` int(3) NOT NULL default '0',
  `size` float unsigned NOT NULL default '0',
  `unit` int(11) NOT NULL default '0',
  `route` int(11) NOT NULL default '0',
  `substitute` int(11) NOT NULL default '0',
  `related_code` varchar(255) NOT NULL DEFAULT '' COMMENT 'may reference a related codes.code',
  `cyp_factor` float NOT NULL DEFAULT 0 COMMENT 'quantity representing a years supply',
  `active` TINYINT(1) DEFAULT 1 COMMENT '0 = inactive, 1 = active',
  `allow_combining` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = allow filling an order from multiple lots',
  `allow_multiple`  tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 = allow multiple lots at one warehouse',
  PRIMARY KEY  (`drug_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `employer_data`
-- 

DROP TABLE IF EXISTS `employer_data`;
CREATE TABLE `employer_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `street` varchar(255) default NULL,
  `postal_code` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `country` varchar(255) default NULL,
  `date` datetime default NULL,
  `pid` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `facility`
-- 

DROP TABLE IF EXISTS `facility`;
CREATE TABLE `facility` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `phone` varchar(30) default NULL,
  `fax` varchar(30) default NULL,
  `street` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(50) default NULL,
  `postal_code` varchar(11) default NULL,
  `country_code` varchar(10) default NULL,
  `federal_ein` varchar(15) default NULL,
  `service_location` tinyint(1) NOT NULL default '1',
  `billing_location` tinyint(1) NOT NULL default '0',
  `accepts_assignment` tinyint(1) NOT NULL default '0',
  `pos_code` tinyint(4) default NULL,
  `x12_sender_id` varchar(25) default NULL,
  `attn` varchar(65) default NULL,
  `domain_identifier` varchar(60) default NULL,
  `facility_npi` varchar(15) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 ;

-- 
-- Dumping data for table `facility`
-- 

INSERT INTO `facility` VALUES (3, 'Your Clinic Name Here', '000-000-0000', '000-000-0000', '', '', '', '', '', '', 1, 0, 0, NULL, '', '', '', '');

-- --------------------------------------------------------

-- 
-- Table structure for table `fee_sheet_options`
-- 

DROP TABLE IF EXISTS `fee_sheet_options`;
CREATE TABLE `fee_sheet_options` (
  `fs_category` varchar(63) default NULL,
  `fs_option` varchar(63) default NULL,
  `fs_codes` varchar(255) default NULL
) ENGINE=MyISAM;

-- 
-- Dumping data for table `fee_sheet_options`
-- 

INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '1Brief', 'CPT4|99201|');
INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '2Limited', 'CPT4|99202|');
INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '3Detailed', 'CPT4|99203|');
INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '4Extended', 'CPT4|99204|');
INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '5Comprehensive', 'CPT4|99205|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '1Brief', 'CPT4|99211|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '2Limited', 'CPT4|99212|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '3Detailed', 'CPT4|99213|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '4Extended', 'CPT4|99214|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '5Comprehensive', 'CPT4|99215|');

-- --------------------------------------------------------

-- 
-- Table structure for table `form_dictation`
-- 

DROP TABLE IF EXISTS `form_dictation`;
CREATE TABLE `form_dictation` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(4) default NULL,
  `activity` tinyint(4) default NULL,
  `dictation` longtext,
  `additional_notes` longtext,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_encounter`
-- 

DROP TABLE IF EXISTS `form_encounter`;
CREATE TABLE `form_encounter` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `reason` longtext,
  `facility` longtext,
  `facility_id` int(11) NOT NULL default '0',
  `pid` bigint(20) default NULL,
  `encounter` bigint(20) default NULL,
  `onset_date` datetime default NULL,
  `sensitivity` varchar(30) default NULL,
  `billing_note` text,
  `pc_catid` int(11) NOT NULL default '5' COMMENT 'event category from openemr_postcalendar_categories',
  `last_level_billed` int  NOT NULL DEFAULT 0 COMMENT '0=none, 1=ins1, 2=ins2, etc',
  `last_level_closed` int  NOT NULL DEFAULT 0 COMMENT '0=none, 1=ins1, 2=ins2, etc',
  `last_stmt_date`    date DEFAULT NULL,
  `stmt_count`        int  NOT NULL DEFAULT 0,
  `provider_id` INT(11) DEFAULT '0' COMMENT 'default and main provider for this visit',
  `supervisor_id` INT(11) DEFAULT '0' COMMENT 'supervising provider, if any, for this visit',
  `invoice_refno` varchar(31) NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_misc_billing_options`
-- 

DROP TABLE IF EXISTS `form_misc_billing_options`;
CREATE TABLE `form_misc_billing_options` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(4) default NULL,
  `activity` tinyint(4) default NULL,
  `employment_related` tinyint(1) default NULL,
  `auto_accident` tinyint(1) default NULL,
  `accident_state` varchar(2) default NULL,
  `other_accident` tinyint(1) default NULL,
  `outside_lab` tinyint(1) default NULL,
  `lab_amount` decimal(5,2) default NULL,
  `is_unable_to_work` tinyint(1) default NULL,
  `off_work_from` date default NULL,
  `off_work_to` date default NULL,
  `is_hospitalized` tinyint(1) default NULL,
  `hospitalization_date_from` date default NULL,
  `hospitalization_date_to` date default NULL,
  `medicaid_resubmission_code` varchar(10) default NULL,
  `medicaid_original_reference` varchar(15) default NULL,
  `prior_auth_number` varchar(20) default NULL,
  `comments` varchar(255) default NULL,
  `replacement_claim` tinyint(1) default 0,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_reviewofs`
-- 

DROP TABLE IF EXISTS `form_reviewofs`;
CREATE TABLE `form_reviewofs` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(4) default NULL,
  `activity` tinyint(4) default NULL,
  `fever` varchar(5) default NULL,
  `chills` varchar(5) default NULL,
  `night_sweats` varchar(5) default NULL,
  `weight_loss` varchar(5) default NULL,
  `poor_appetite` varchar(5) default NULL,
  `insomnia` varchar(5) default NULL,
  `fatigued` varchar(5) default NULL,
  `depressed` varchar(5) default NULL,
  `hyperactive` varchar(5) default NULL,
  `exposure_to_foreign_countries` varchar(5) default NULL,
  `cataracts` varchar(5) default NULL,
  `cataract_surgery` varchar(5) default NULL,
  `glaucoma` varchar(5) default NULL,
  `double_vision` varchar(5) default NULL,
  `blurred_vision` varchar(5) default NULL,
  `poor_hearing` varchar(5) default NULL,
  `headaches` varchar(5) default NULL,
  `ringing_in_ears` varchar(5) default NULL,
  `bloody_nose` varchar(5) default NULL,
  `sinusitis` varchar(5) default NULL,
  `sinus_surgery` varchar(5) default NULL,
  `dry_mouth` varchar(5) default NULL,
  `strep_throat` varchar(5) default NULL,
  `tonsillectomy` varchar(5) default NULL,
  `swollen_lymph_nodes` varchar(5) default NULL,
  `throat_cancer` varchar(5) default NULL,
  `throat_cancer_surgery` varchar(5) default NULL,
  `heart_attack` varchar(5) default NULL,
  `irregular_heart_beat` varchar(5) default NULL,
  `chest_pains` varchar(5) default NULL,
  `shortness_of_breath` varchar(5) default NULL,
  `high_blood_pressure` varchar(5) default NULL,
  `heart_failure` varchar(5) default NULL,
  `poor_circulation` varchar(5) default NULL,
  `vascular_surgery` varchar(5) default NULL,
  `cardiac_catheterization` varchar(5) default NULL,
  `coronary_artery_bypass` varchar(5) default NULL,
  `heart_transplant` varchar(5) default NULL,
  `stress_test` varchar(5) default NULL,
  `emphysema` varchar(5) default NULL,
  `chronic_bronchitis` varchar(5) default NULL,
  `interstitial_lung_disease` varchar(5) default NULL,
  `shortness_of_breath_2` varchar(5) default NULL,
  `lung_cancer` varchar(5) default NULL,
  `lung_cancer_surgery` varchar(5) default NULL,
  `pheumothorax` varchar(5) default NULL,
  `stomach_pains` varchar(5) default NULL,
  `peptic_ulcer_disease` varchar(5) default NULL,
  `gastritis` varchar(5) default NULL,
  `endoscopy` varchar(5) default NULL,
  `polyps` varchar(5) default NULL,
  `colonoscopy` varchar(5) default NULL,
  `colon_cancer` varchar(5) default NULL,
  `colon_cancer_surgery` varchar(5) default NULL,
  `ulcerative_colitis` varchar(5) default NULL,
  `crohns_disease` varchar(5) default NULL,
  `appendectomy` varchar(5) default NULL,
  `divirticulitis` varchar(5) default NULL,
  `divirticulitis_surgery` varchar(5) default NULL,
  `gall_stones` varchar(5) default NULL,
  `cholecystectomy` varchar(5) default NULL,
  `hepatitis` varchar(5) default NULL,
  `cirrhosis_of_the_liver` varchar(5) default NULL,
  `splenectomy` varchar(5) default NULL,
  `kidney_failure` varchar(5) default NULL,
  `kidney_stones` varchar(5) default NULL,
  `kidney_cancer` varchar(5) default NULL,
  `kidney_infections` varchar(5) default NULL,
  `bladder_infections` varchar(5) default NULL,
  `bladder_cancer` varchar(5) default NULL,
  `prostate_problems` varchar(5) default NULL,
  `prostate_cancer` varchar(5) default NULL,
  `kidney_transplant` varchar(5) default NULL,
  `sexually_transmitted_disease` varchar(5) default NULL,
  `burning_with_urination` varchar(5) default NULL,
  `discharge_from_urethra` varchar(5) default NULL,
  `rashes` varchar(5) default NULL,
  `infections` varchar(5) default NULL,
  `ulcerations` varchar(5) default NULL,
  `pemphigus` varchar(5) default NULL,
  `herpes` varchar(5) default NULL,
  `osetoarthritis` varchar(5) default NULL,
  `rheumotoid_arthritis` varchar(5) default NULL,
  `lupus` varchar(5) default NULL,
  `ankylosing_sondlilitis` varchar(5) default NULL,
  `swollen_joints` varchar(5) default NULL,
  `stiff_joints` varchar(5) default NULL,
  `broken_bones` varchar(5) default NULL,
  `neck_problems` varchar(5) default NULL,
  `back_problems` varchar(5) default NULL,
  `back_surgery` varchar(5) default NULL,
  `scoliosis` varchar(5) default NULL,
  `herniated_disc` varchar(5) default NULL,
  `shoulder_problems` varchar(5) default NULL,
  `elbow_problems` varchar(5) default NULL,
  `wrist_problems` varchar(5) default NULL,
  `hand_problems` varchar(5) default NULL,
  `hip_problems` varchar(5) default NULL,
  `knee_problems` varchar(5) default NULL,
  `ankle_problems` varchar(5) default NULL,
  `foot_problems` varchar(5) default NULL,
  `insulin_dependent_diabetes` varchar(5) default NULL,
  `noninsulin_dependent_diabetes` varchar(5) default NULL,
  `hypothyroidism` varchar(5) default NULL,
  `hyperthyroidism` varchar(5) default NULL,
  `cushing_syndrom` varchar(5) default NULL,
  `addison_syndrom` varchar(5) default NULL,
  `additional_notes` longtext,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_ros`
-- 

DROP TABLE IF EXISTS `form_ros`;
CREATE TABLE `form_ros` (
  `id` int(11) NOT NULL auto_increment,
  `pid` int(11) NOT NULL,
  `activity` int(11) NOT NULL default '1',
  `date` datetime default NULL,
  `weight_change` varchar(3) default NULL,
  `weakness` varchar(3) default NULL,
  `fatigue` varchar(3) default NULL,
  `anorexia` varchar(3) default NULL,
  `fever` varchar(3) default NULL,
  `chills` varchar(3) default NULL,
  `night_sweats` varchar(3) default NULL,
  `insomnia` varchar(3) default NULL,
  `irritability` varchar(3) default NULL,
  `heat_or_cold` varchar(3) default NULL,
  `intolerance` varchar(3) default NULL,
  `change_in_vision` varchar(3) default NULL,
  `glaucoma_history` varchar(3) default NULL,
  `eye_pain` varchar(3) default NULL,
  `irritation` varchar(3) default NULL,
  `redness` varchar(3) default NULL,
  `excessive_tearing` varchar(3) default NULL,
  `double_vision` varchar(3) default NULL,
  `blind_spots` varchar(3) default NULL,
  `photophobia` varchar(3) default NULL,
  `hearing_loss` varchar(3) default NULL,
  `discharge` varchar(3) default NULL,
  `pain` varchar(3) default NULL,
  `vertigo` varchar(3) default NULL,
  `tinnitus` varchar(3) default NULL,
  `frequent_colds` varchar(3) default NULL,
  `sore_throat` varchar(3) default NULL,
  `sinus_problems` varchar(3) default NULL,
  `post_nasal_drip` varchar(3) default NULL,
  `nosebleed` varchar(3) default NULL,
  `snoring` varchar(3) default NULL,
  `apnea` varchar(3) default NULL,
  `breast_mass` varchar(3) default NULL,
  `breast_discharge` varchar(3) default NULL,
  `biopsy` varchar(3) default NULL,
  `abnormal_mammogram` varchar(3) default NULL,
  `cough` varchar(3) default NULL,
  `sputum` varchar(3) default NULL,
  `shortness_of_breath` varchar(3) default NULL,
  `wheezing` varchar(3) default NULL,
  `hemoptsyis` varchar(3) default NULL,
  `asthma` varchar(3) default NULL,
  `copd` varchar(3) default NULL,
  `chest_pain` varchar(3) default NULL,
  `palpitation` varchar(3) default NULL,
  `syncope` varchar(3) default NULL,
  `pnd` varchar(3) default NULL,
  `doe` varchar(3) default NULL,
  `orthopnea` varchar(3) default NULL,
  `peripheal` varchar(3) default NULL,
  `edema` varchar(3) default NULL,
  `legpain_cramping` varchar(3) default NULL,
  `history_murmur` varchar(3) default NULL,
  `arrythmia` varchar(3) default NULL,
  `heart_problem` varchar(3) default NULL,
  `dysphagia` varchar(3) default NULL,
  `heartburn` varchar(3) default NULL,
  `bloating` varchar(3) default NULL,
  `belching` varchar(3) default NULL,
  `flatulence` varchar(3) default NULL,
  `nausea` varchar(3) default NULL,
  `vomiting` varchar(3) default NULL,
  `hematemesis` varchar(3) default NULL,
  `gastro_pain` varchar(3) default NULL,
  `food_intolerance` varchar(3) default NULL,
  `hepatitis` varchar(3) default NULL,
  `jaundice` varchar(3) default NULL,
  `hematochezia` varchar(3) default NULL,
  `changed_bowel` varchar(3) default NULL,
  `diarrhea` varchar(3) default NULL,
  `constipation` varchar(3) default NULL,
  `polyuria` varchar(3) default NULL,
  `polydypsia` varchar(3) default NULL,
  `dysuria` varchar(3) default NULL,
  `hematuria` varchar(3) default NULL,
  `frequency` varchar(3) default NULL,
  `urgency` varchar(3) default NULL,
  `incontinence` varchar(3) default NULL,
  `renal_stones` varchar(3) default NULL,
  `utis` varchar(3) default NULL,
  `hesitancy` varchar(3) default NULL,
  `dribbling` varchar(3) default NULL,
  `stream` varchar(3) default NULL,
  `nocturia` varchar(3) default NULL,
  `erections` varchar(3) default NULL,
  `ejaculations` varchar(3) default NULL,
  `g` varchar(3) default NULL,
  `p` varchar(3) default NULL,
  `ap` varchar(3) default NULL,
  `lc` varchar(3) default NULL,
  `mearche` varchar(3) default NULL,
  `menopause` varchar(3) default NULL,
  `lmp` varchar(3) default NULL,
  `f_frequency` varchar(3) default NULL,
  `f_flow` varchar(3) default NULL,
  `f_symptoms` varchar(3) default NULL,
  `abnormal_hair_growth` varchar(3) default NULL,
  `f_hirsutism` varchar(3) default NULL,
  `joint_pain` varchar(3) default NULL,
  `swelling` varchar(3) default NULL,
  `m_redness` varchar(3) default NULL,
  `m_warm` varchar(3) default NULL,
  `m_stiffness` varchar(3) default NULL,
  `muscle` varchar(3) default NULL,
  `m_aches` varchar(3) default NULL,
  `fms` varchar(3) default NULL,
  `arthritis` varchar(3) default NULL,
  `loc` varchar(3) default NULL,
  `seizures` varchar(3) default NULL,
  `stroke` varchar(3) default NULL,
  `tia` varchar(3) default NULL,
  `n_numbness` varchar(3) default NULL,
  `n_weakness` varchar(3) default NULL,
  `paralysis` varchar(3) default NULL,
  `intellectual_decline` varchar(3) default NULL,
  `memory_problems` varchar(3) default NULL,
  `dementia` varchar(3) default NULL,
  `n_headache` varchar(3) default NULL,
  `s_cancer` varchar(3) default NULL,
  `psoriasis` varchar(3) default NULL,
  `s_acne` varchar(3) default NULL,
  `s_other` varchar(3) default NULL,
  `s_disease` varchar(3) default NULL,
  `p_diagnosis` varchar(3) default NULL,
  `p_medication` varchar(3) default NULL,
  `depression` varchar(3) default NULL,
  `anxiety` varchar(3) default NULL,
  `social_difficulties` varchar(3) default NULL,
  `thyroid_problems` varchar(3) default NULL,
  `diabetes` varchar(3) default NULL,
  `abnormal_blood` varchar(3) default NULL,
  `anemia` varchar(3) default NULL,
  `fh_blood_problems` varchar(3) default NULL,
  `bleeding_problems` varchar(3) default NULL,
  `allergies` varchar(3) default NULL,
  `frequent_illness` varchar(3) default NULL,
  `hiv` varchar(3) default NULL,
  `hai_status` varchar(3) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_soap`
-- 

DROP TABLE IF EXISTS `form_soap`;
CREATE TABLE `form_soap` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default '0',
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(4) default '0',
  `activity` tinyint(4) default '0',
  `subjective` text,
  `objective` text,
  `assessment` text,
  `plan` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_vitals`
-- 

DROP TABLE IF EXISTS `form_vitals`;
CREATE TABLE `form_vitals` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default '0',
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(4) default '0',
  `activity` tinyint(4) default '0',
  `bps` varchar(40) default NULL,
  `bpd` varchar(40) default NULL,
  `weight` float(5,2) default '0.00',
  `height` float(5,2) default '0.00',
  `temperature` float(5,2) default '0.00',
  `temp_method` varchar(255) default NULL,
  `pulse` float(5,2) default '0.00',
  `respiration` float(5,2) default '0.00',
  `note` varchar(255) default NULL,
  `BMI` float(4,1) default '0.0',
  `BMI_status` varchar(255) default NULL,
  `waist_circ` float(5,2) default '0.00',
  `head_circ` float(4,2) default '0.00',
  `oxygen_saturation` float(5,2) default '0.00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `forms`
-- 

DROP TABLE IF EXISTS `forms`;
CREATE TABLE `forms` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `encounter` bigint(20) default NULL,
  `form_name` longtext,
  `form_id` bigint(20) default NULL,
  `pid` bigint(20) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(4) default NULL,
  `deleted` tinyint(4) DEFAULT '0' NOT NULL COMMENT 'flag indicates form has been deleted',
  `formdir` longtext,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `geo_country_reference`
-- 

DROP TABLE IF EXISTS `geo_country_reference`;
CREATE TABLE `geo_country_reference` (
  `countries_id` int(5) NOT NULL auto_increment,
  `countries_name` varchar(64) default NULL,
  `countries_iso_code_2` char(2) NOT NULL default '',
  `countries_iso_code_3` char(3) NOT NULL default '',
  PRIMARY KEY  (`countries_id`),
  KEY `IDX_COUNTRIES_NAME` (`countries_name`)
) ENGINE=MyISAM AUTO_INCREMENT=240 ;

-- 
-- Dumping data for table `geo_country_reference`
-- 

INSERT INTO `geo_country_reference` VALUES (1, 'Afghanistan', 'AF', 'AFG');
INSERT INTO `geo_country_reference` VALUES (2, 'Albania', 'AL', 'ALB');
INSERT INTO `geo_country_reference` VALUES (3, 'Algeria', 'DZ', 'DZA');
INSERT INTO `geo_country_reference` VALUES (4, 'American Samoa', 'AS', 'ASM');
INSERT INTO `geo_country_reference` VALUES (5, 'Andorra', 'AD', 'AND');
INSERT INTO `geo_country_reference` VALUES (6, 'Angola', 'AO', 'AGO');
INSERT INTO `geo_country_reference` VALUES (7, 'Anguilla', 'AI', 'AIA');
INSERT INTO `geo_country_reference` VALUES (8, 'Antarctica', 'AQ', 'ATA');
INSERT INTO `geo_country_reference` VALUES (9, 'Antigua and Barbuda', 'AG', 'ATG');
INSERT INTO `geo_country_reference` VALUES (10, 'Argentina', 'AR', 'ARG');
INSERT INTO `geo_country_reference` VALUES (11, 'Armenia', 'AM', 'ARM');
INSERT INTO `geo_country_reference` VALUES (12, 'Aruba', 'AW', 'ABW');
INSERT INTO `geo_country_reference` VALUES (13, 'Australia', 'AU', 'AUS');
INSERT INTO `geo_country_reference` VALUES (14, 'Austria', 'AT', 'AUT');
INSERT INTO `geo_country_reference` VALUES (15, 'Azerbaijan', 'AZ', 'AZE');
INSERT INTO `geo_country_reference` VALUES (16, 'Bahamas', 'BS', 'BHS');
INSERT INTO `geo_country_reference` VALUES (17, 'Bahrain', 'BH', 'BHR');
INSERT INTO `geo_country_reference` VALUES (18, 'Bangladesh', 'BD', 'BGD');
INSERT INTO `geo_country_reference` VALUES (19, 'Barbados', 'BB', 'BRB');
INSERT INTO `geo_country_reference` VALUES (20, 'Belarus', 'BY', 'BLR');
INSERT INTO `geo_country_reference` VALUES (21, 'Belgium', 'BE', 'BEL');
INSERT INTO `geo_country_reference` VALUES (22, 'Belize', 'BZ', 'BLZ');
INSERT INTO `geo_country_reference` VALUES (23, 'Benin', 'BJ', 'BEN');
INSERT INTO `geo_country_reference` VALUES (24, 'Bermuda', 'BM', 'BMU');
INSERT INTO `geo_country_reference` VALUES (25, 'Bhutan', 'BT', 'BTN');
INSERT INTO `geo_country_reference` VALUES (26, 'Bolivia', 'BO', 'BOL');
INSERT INTO `geo_country_reference` VALUES (27, 'Bosnia and Herzegowina', 'BA', 'BIH');
INSERT INTO `geo_country_reference` VALUES (28, 'Botswana', 'BW', 'BWA');
INSERT INTO `geo_country_reference` VALUES (29, 'Bouvet Island', 'BV', 'BVT');
INSERT INTO `geo_country_reference` VALUES (30, 'Brazil', 'BR', 'BRA');
INSERT INTO `geo_country_reference` VALUES (31, 'British Indian Ocean Territory', 'IO', 'IOT');
INSERT INTO `geo_country_reference` VALUES (32, 'Brunei Darussalam', 'BN', 'BRN');
INSERT INTO `geo_country_reference` VALUES (33, 'Bulgaria', 'BG', 'BGR');
INSERT INTO `geo_country_reference` VALUES (34, 'Burkina Faso', 'BF', 'BFA');
INSERT INTO `geo_country_reference` VALUES (35, 'Burundi', 'BI', 'BDI');
INSERT INTO `geo_country_reference` VALUES (36, 'Cambodia', 'KH', 'KHM');
INSERT INTO `geo_country_reference` VALUES (37, 'Cameroon', 'CM', 'CMR');
INSERT INTO `geo_country_reference` VALUES (38, 'Canada', 'CA', 'CAN');
INSERT INTO `geo_country_reference` VALUES (39, 'Cape Verde', 'CV', 'CPV');
INSERT INTO `geo_country_reference` VALUES (40, 'Cayman Islands', 'KY', 'CYM');
INSERT INTO `geo_country_reference` VALUES (41, 'Central African Republic', 'CF', 'CAF');
INSERT INTO `geo_country_reference` VALUES (42, 'Chad', 'TD', 'TCD');
INSERT INTO `geo_country_reference` VALUES (43, 'Chile', 'CL', 'CHL');
INSERT INTO `geo_country_reference` VALUES (44, 'China', 'CN', 'CHN');
INSERT INTO `geo_country_reference` VALUES (45, 'Christmas Island', 'CX', 'CXR');
INSERT INTO `geo_country_reference` VALUES (46, 'Cocos (Keeling) Islands', 'CC', 'CCK');
INSERT INTO `geo_country_reference` VALUES (47, 'Colombia', 'CO', 'COL');
INSERT INTO `geo_country_reference` VALUES (48, 'Comoros', 'KM', 'COM');
INSERT INTO `geo_country_reference` VALUES (49, 'Congo', 'CG', 'COG');
INSERT INTO `geo_country_reference` VALUES (50, 'Cook Islands', 'CK', 'COK');
INSERT INTO `geo_country_reference` VALUES (51, 'Costa Rica', 'CR', 'CRI');
INSERT INTO `geo_country_reference` VALUES (52, 'Cote D Ivoire', 'CI', 'CIV');
INSERT INTO `geo_country_reference` VALUES (53, 'Croatia', 'HR', 'HRV');
INSERT INTO `geo_country_reference` VALUES (54, 'Cuba', 'CU', 'CUB');
INSERT INTO `geo_country_reference` VALUES (55, 'Cyprus', 'CY', 'CYP');
INSERT INTO `geo_country_reference` VALUES (56, 'Czech Republic', 'CZ', 'CZE');
INSERT INTO `geo_country_reference` VALUES (57, 'Denmark', 'DK', 'DNK');
INSERT INTO `geo_country_reference` VALUES (58, 'Djibouti', 'DJ', 'DJI');
INSERT INTO `geo_country_reference` VALUES (59, 'Dominica', 'DM', 'DMA');
INSERT INTO `geo_country_reference` VALUES (60, 'Dominican Republic', 'DO', 'DOM');
INSERT INTO `geo_country_reference` VALUES (61, 'East Timor', 'TP', 'TMP');
INSERT INTO `geo_country_reference` VALUES (62, 'Ecuador', 'EC', 'ECU');
INSERT INTO `geo_country_reference` VALUES (63, 'Egypt', 'EG', 'EGY');
INSERT INTO `geo_country_reference` VALUES (64, 'El Salvador', 'SV', 'SLV');
INSERT INTO `geo_country_reference` VALUES (65, 'Equatorial Guinea', 'GQ', 'GNQ');
INSERT INTO `geo_country_reference` VALUES (66, 'Eritrea', 'ER', 'ERI');
INSERT INTO `geo_country_reference` VALUES (67, 'Estonia', 'EE', 'EST');
INSERT INTO `geo_country_reference` VALUES (68, 'Ethiopia', 'ET', 'ETH');
INSERT INTO `geo_country_reference` VALUES (69, 'Falkland Islands (Malvinas)', 'FK', 'FLK');
INSERT INTO `geo_country_reference` VALUES (70, 'Faroe Islands', 'FO', 'FRO');
INSERT INTO `geo_country_reference` VALUES (71, 'Fiji', 'FJ', 'FJI');
INSERT INTO `geo_country_reference` VALUES (72, 'Finland', 'FI', 'FIN');
INSERT INTO `geo_country_reference` VALUES (73, 'France', 'FR', 'FRA');
INSERT INTO `geo_country_reference` VALUES (74, 'France, MEtropolitan', 'FX', 'FXX');
INSERT INTO `geo_country_reference` VALUES (75, 'French Guiana', 'GF', 'GUF');
INSERT INTO `geo_country_reference` VALUES (76, 'French Polynesia', 'PF', 'PYF');
INSERT INTO `geo_country_reference` VALUES (77, 'French Southern Territories', 'TF', 'ATF');
INSERT INTO `geo_country_reference` VALUES (78, 'Gabon', 'GA', 'GAB');
INSERT INTO `geo_country_reference` VALUES (79, 'Gambia', 'GM', 'GMB');
INSERT INTO `geo_country_reference` VALUES (80, 'Georgia', 'GE', 'GEO');
INSERT INTO `geo_country_reference` VALUES (81, 'Germany', 'DE', 'DEU');
INSERT INTO `geo_country_reference` VALUES (82, 'Ghana', 'GH', 'GHA');
INSERT INTO `geo_country_reference` VALUES (83, 'Gibraltar', 'GI', 'GIB');
INSERT INTO `geo_country_reference` VALUES (84, 'Greece', 'GR', 'GRC');
INSERT INTO `geo_country_reference` VALUES (85, 'Greenland', 'GL', 'GRL');
INSERT INTO `geo_country_reference` VALUES (86, 'Grenada', 'GD', 'GRD');
INSERT INTO `geo_country_reference` VALUES (87, 'Guadeloupe', 'GP', 'GLP');
INSERT INTO `geo_country_reference` VALUES (88, 'Guam', 'GU', 'GUM');
INSERT INTO `geo_country_reference` VALUES (89, 'Guatemala', 'GT', 'GTM');
INSERT INTO `geo_country_reference` VALUES (90, 'Guinea', 'GN', 'GIN');
INSERT INTO `geo_country_reference` VALUES (91, 'Guinea-bissau', 'GW', 'GNB');
INSERT INTO `geo_country_reference` VALUES (92, 'Guyana', 'GY', 'GUY');
INSERT INTO `geo_country_reference` VALUES (93, 'Haiti', 'HT', 'HTI');
INSERT INTO `geo_country_reference` VALUES (94, 'Heard and Mc Donald Islands', 'HM', 'HMD');
INSERT INTO `geo_country_reference` VALUES (95, 'Honduras', 'HN', 'HND');
INSERT INTO `geo_country_reference` VALUES (96, 'Hong Kong', 'HK', 'HKG');
INSERT INTO `geo_country_reference` VALUES (97, 'Hungary', 'HU', 'HUN');
INSERT INTO `geo_country_reference` VALUES (98, 'Iceland', 'IS', 'ISL');
INSERT INTO `geo_country_reference` VALUES (99, 'India', 'IN', 'IND');
INSERT INTO `geo_country_reference` VALUES (100, 'Indonesia', 'ID', 'IDN');
INSERT INTO `geo_country_reference` VALUES (101, 'Iran (Islamic Republic of)', 'IR', 'IRN');
INSERT INTO `geo_country_reference` VALUES (102, 'Iraq', 'IQ', 'IRQ');
INSERT INTO `geo_country_reference` VALUES (103, 'Ireland', 'IE', 'IRL');
INSERT INTO `geo_country_reference` VALUES (104, 'Israel', 'IL', 'ISR');
INSERT INTO `geo_country_reference` VALUES (105, 'Italy', 'IT', 'ITA');
INSERT INTO `geo_country_reference` VALUES (106, 'Jamaica', 'JM', 'JAM');
INSERT INTO `geo_country_reference` VALUES (107, 'Japan', 'JP', 'JPN');
INSERT INTO `geo_country_reference` VALUES (108, 'Jordan', 'JO', 'JOR');
INSERT INTO `geo_country_reference` VALUES (109, 'Kazakhstan', 'KZ', 'KAZ');
INSERT INTO `geo_country_reference` VALUES (110, 'Kenya', 'KE', 'KEN');
INSERT INTO `geo_country_reference` VALUES (111, 'Kiribati', 'KI', 'KIR');
INSERT INTO `geo_country_reference` VALUES (112, 'Korea, Democratic Peoples Republic of', 'KP', 'PRK');
INSERT INTO `geo_country_reference` VALUES (113, 'Korea, Republic of', 'KR', 'KOR');
INSERT INTO `geo_country_reference` VALUES (114, 'Kuwait', 'KW', 'KWT');
INSERT INTO `geo_country_reference` VALUES (115, 'Kyrgyzstan', 'KG', 'KGZ');
INSERT INTO `geo_country_reference` VALUES (116, 'Lao Peoples Democratic Republic', 'LA', 'LAO');
INSERT INTO `geo_country_reference` VALUES (117, 'Latvia', 'LV', 'LVA');
INSERT INTO `geo_country_reference` VALUES (118, 'Lebanon', 'LB', 'LBN');
INSERT INTO `geo_country_reference` VALUES (119, 'Lesotho', 'LS', 'LSO');
INSERT INTO `geo_country_reference` VALUES (120, 'Liberia', 'LR', 'LBR');
INSERT INTO `geo_country_reference` VALUES (121, 'Libyan Arab Jamahiriya', 'LY', 'LBY');
INSERT INTO `geo_country_reference` VALUES (122, 'Liechtenstein', 'LI', 'LIE');
INSERT INTO `geo_country_reference` VALUES (123, 'Lithuania', 'LT', 'LTU');
INSERT INTO `geo_country_reference` VALUES (124, 'Luxembourg', 'LU', 'LUX');
INSERT INTO `geo_country_reference` VALUES (125, 'Macau', 'MO', 'MAC');
INSERT INTO `geo_country_reference` VALUES (126, 'Macedonia, The Former Yugoslav Republic of', 'MK', 'MKD');
INSERT INTO `geo_country_reference` VALUES (127, 'Madagascar', 'MG', 'MDG');
INSERT INTO `geo_country_reference` VALUES (128, 'Malawi', 'MW', 'MWI');
INSERT INTO `geo_country_reference` VALUES (129, 'Malaysia', 'MY', 'MYS');
INSERT INTO `geo_country_reference` VALUES (130, 'Maldives', 'MV', 'MDV');
INSERT INTO `geo_country_reference` VALUES (131, 'Mali', 'ML', 'MLI');
INSERT INTO `geo_country_reference` VALUES (132, 'Malta', 'MT', 'MLT');
INSERT INTO `geo_country_reference` VALUES (133, 'Marshall Islands', 'MH', 'MHL');
INSERT INTO `geo_country_reference` VALUES (134, 'Martinique', 'MQ', 'MTQ');
INSERT INTO `geo_country_reference` VALUES (135, 'Mauritania', 'MR', 'MRT');
INSERT INTO `geo_country_reference` VALUES (136, 'Mauritius', 'MU', 'MUS');
INSERT INTO `geo_country_reference` VALUES (137, 'Mayotte', 'YT', 'MYT');
INSERT INTO `geo_country_reference` VALUES (138, 'Mexico', 'MX', 'MEX');
INSERT INTO `geo_country_reference` VALUES (139, 'Micronesia, Federated States of', 'FM', 'FSM');
INSERT INTO `geo_country_reference` VALUES (140, 'Moldova, Republic of', 'MD', 'MDA');
INSERT INTO `geo_country_reference` VALUES (141, 'Monaco', 'MC', 'MCO');
INSERT INTO `geo_country_reference` VALUES (142, 'Mongolia', 'MN', 'MNG');
INSERT INTO `geo_country_reference` VALUES (143, 'Montserrat', 'MS', 'MSR');
INSERT INTO `geo_country_reference` VALUES (144, 'Morocco', 'MA', 'MAR');
INSERT INTO `geo_country_reference` VALUES (145, 'Mozambique', 'MZ', 'MOZ');
INSERT INTO `geo_country_reference` VALUES (146, 'Myanmar', 'MM', 'MMR');
INSERT INTO `geo_country_reference` VALUES (147, 'Namibia', 'NA', 'NAM');
INSERT INTO `geo_country_reference` VALUES (148, 'Nauru', 'NR', 'NRU');
INSERT INTO `geo_country_reference` VALUES (149, 'Nepal', 'NP', 'NPL');
INSERT INTO `geo_country_reference` VALUES (150, 'Netherlands', 'NL', 'NLD');
INSERT INTO `geo_country_reference` VALUES (151, 'Netherlands Antilles', 'AN', 'ANT');
INSERT INTO `geo_country_reference` VALUES (152, 'New Caledonia', 'NC', 'NCL');
INSERT INTO `geo_country_reference` VALUES (153, 'New Zealand', 'NZ', 'NZL');
INSERT INTO `geo_country_reference` VALUES (154, 'Nicaragua', 'NI', 'NIC');
INSERT INTO `geo_country_reference` VALUES (155, 'Niger', 'NE', 'NER');
INSERT INTO `geo_country_reference` VALUES (156, 'Nigeria', 'NG', 'NGA');
INSERT INTO `geo_country_reference` VALUES (157, 'Niue', 'NU', 'NIU');
INSERT INTO `geo_country_reference` VALUES (158, 'Norfolk Island', 'NF', 'NFK');
INSERT INTO `geo_country_reference` VALUES (159, 'Northern Mariana Islands', 'MP', 'MNP');
INSERT INTO `geo_country_reference` VALUES (160, 'Norway', 'NO', 'NOR');
INSERT INTO `geo_country_reference` VALUES (161, 'Oman', 'OM', 'OMN');
INSERT INTO `geo_country_reference` VALUES (162, 'Pakistan', 'PK', 'PAK');
INSERT INTO `geo_country_reference` VALUES (163, 'Palau', 'PW', 'PLW');
INSERT INTO `geo_country_reference` VALUES (164, 'Panama', 'PA', 'PAN');
INSERT INTO `geo_country_reference` VALUES (165, 'Papua New Guinea', 'PG', 'PNG');
INSERT INTO `geo_country_reference` VALUES (166, 'Paraguay', 'PY', 'PRY');
INSERT INTO `geo_country_reference` VALUES (167, 'Peru', 'PE', 'PER');
INSERT INTO `geo_country_reference` VALUES (168, 'Philippines', 'PH', 'PHL');
INSERT INTO `geo_country_reference` VALUES (169, 'Pitcairn', 'PN', 'PCN');
INSERT INTO `geo_country_reference` VALUES (170, 'Poland', 'PL', 'POL');
INSERT INTO `geo_country_reference` VALUES (171, 'Portugal', 'PT', 'PRT');
INSERT INTO `geo_country_reference` VALUES (172, 'Puerto Rico', 'PR', 'PRI');
INSERT INTO `geo_country_reference` VALUES (173, 'Qatar', 'QA', 'QAT');
INSERT INTO `geo_country_reference` VALUES (174, 'Reunion', 'RE', 'REU');
INSERT INTO `geo_country_reference` VALUES (175, 'Romania', 'RO', 'ROM');
INSERT INTO `geo_country_reference` VALUES (176, 'Russian Federation', 'RU', 'RUS');
INSERT INTO `geo_country_reference` VALUES (177, 'Rwanda', 'RW', 'RWA');
INSERT INTO `geo_country_reference` VALUES (178, 'Saint Kitts and Nevis', 'KN', 'KNA');
INSERT INTO `geo_country_reference` VALUES (179, 'Saint Lucia', 'LC', 'LCA');
INSERT INTO `geo_country_reference` VALUES (180, 'Saint Vincent and the Grenadines', 'VC', 'VCT');
INSERT INTO `geo_country_reference` VALUES (181, 'Samoa', 'WS', 'WSM');
INSERT INTO `geo_country_reference` VALUES (182, 'San Marino', 'SM', 'SMR');
INSERT INTO `geo_country_reference` VALUES (183, 'Sao Tome and Principe', 'ST', 'STP');
INSERT INTO `geo_country_reference` VALUES (184, 'Saudi Arabia', 'SA', 'SAU');
INSERT INTO `geo_country_reference` VALUES (185, 'Senegal', 'SN', 'SEN');
INSERT INTO `geo_country_reference` VALUES (186, 'Seychelles', 'SC', 'SYC');
INSERT INTO `geo_country_reference` VALUES (187, 'Sierra Leone', 'SL', 'SLE');
INSERT INTO `geo_country_reference` VALUES (188, 'Singapore', 'SG', 'SGP');
INSERT INTO `geo_country_reference` VALUES (189, 'Slovakia (Slovak Republic)', 'SK', 'SVK');
INSERT INTO `geo_country_reference` VALUES (190, 'Slovenia', 'SI', 'SVN');
INSERT INTO `geo_country_reference` VALUES (191, 'Solomon Islands', 'SB', 'SLB');
INSERT INTO `geo_country_reference` VALUES (192, 'Somalia', 'SO', 'SOM');
INSERT INTO `geo_country_reference` VALUES (193, 'south Africa', 'ZA', 'ZAF');
INSERT INTO `geo_country_reference` VALUES (194, 'South Georgia and the South Sandwich Islands', 'GS', 'SGS');
INSERT INTO `geo_country_reference` VALUES (195, 'Spain', 'ES', 'ESP');
INSERT INTO `geo_country_reference` VALUES (196, 'Sri Lanka', 'LK', 'LKA');
INSERT INTO `geo_country_reference` VALUES (197, 'St. Helena', 'SH', 'SHN');
INSERT INTO `geo_country_reference` VALUES (198, 'St. Pierre and Miquelon', 'PM', 'SPM');
INSERT INTO `geo_country_reference` VALUES (199, 'Sudan', 'SD', 'SDN');
INSERT INTO `geo_country_reference` VALUES (200, 'Suriname', 'SR', 'SUR');
INSERT INTO `geo_country_reference` VALUES (201, 'Svalbard and Jan Mayen Islands', 'SJ', 'SJM');
INSERT INTO `geo_country_reference` VALUES (202, 'Swaziland', 'SZ', 'SWZ');
INSERT INTO `geo_country_reference` VALUES (203, 'Sweden', 'SE', 'SWE');
INSERT INTO `geo_country_reference` VALUES (204, 'Switzerland', 'CH', 'CHE');
INSERT INTO `geo_country_reference` VALUES (205, 'Syrian Arab Republic', 'SY', 'SYR');
INSERT INTO `geo_country_reference` VALUES (206, 'Taiwan, Province of China', 'TW', 'TWN');
INSERT INTO `geo_country_reference` VALUES (207, 'Tajikistan', 'TJ', 'TJK');
INSERT INTO `geo_country_reference` VALUES (208, 'Tanzania, United Republic of', 'TZ', 'TZA');
INSERT INTO `geo_country_reference` VALUES (209, 'Thailand', 'TH', 'THA');
INSERT INTO `geo_country_reference` VALUES (210, 'Togo', 'TG', 'TGO');
INSERT INTO `geo_country_reference` VALUES (211, 'Tokelau', 'TK', 'TKL');
INSERT INTO `geo_country_reference` VALUES (212, 'Tonga', 'TO', 'TON');
INSERT INTO `geo_country_reference` VALUES (213, 'Trinidad and Tobago', 'TT', 'TTO');
INSERT INTO `geo_country_reference` VALUES (214, 'Tunisia', 'TN', 'TUN');
INSERT INTO `geo_country_reference` VALUES (215, 'Turkey', 'TR', 'TUR');
INSERT INTO `geo_country_reference` VALUES (216, 'Turkmenistan', 'TM', 'TKM');
INSERT INTO `geo_country_reference` VALUES (217, 'Turks and Caicos Islands', 'TC', 'TCA');
INSERT INTO `geo_country_reference` VALUES (218, 'Tuvalu', 'TV', 'TUV');
INSERT INTO `geo_country_reference` VALUES (219, 'Uganda', 'UG', 'UGA');
INSERT INTO `geo_country_reference` VALUES (220, 'Ukraine', 'UA', 'UKR');
INSERT INTO `geo_country_reference` VALUES (221, 'United Arab Emirates', 'AE', 'ARE');
INSERT INTO `geo_country_reference` VALUES (222, 'United Kingdom', 'GB', 'GBR');
INSERT INTO `geo_country_reference` VALUES (223, 'United States', 'US', 'USA');
INSERT INTO `geo_country_reference` VALUES (224, 'United States Minor Outlying Islands', 'UM', 'UMI');
INSERT INTO `geo_country_reference` VALUES (225, 'Uruguay', 'UY', 'URY');
INSERT INTO `geo_country_reference` VALUES (226, 'Uzbekistan', 'UZ', 'UZB');
INSERT INTO `geo_country_reference` VALUES (227, 'Vanuatu', 'VU', 'VUT');
INSERT INTO `geo_country_reference` VALUES (228, 'Vatican City State (Holy See)', 'VA', 'VAT');
INSERT INTO `geo_country_reference` VALUES (229, 'Venezuela', 'VE', 'VEN');
INSERT INTO `geo_country_reference` VALUES (230, 'Viet Nam', 'VN', 'VNM');
INSERT INTO `geo_country_reference` VALUES (231, 'Virgin Islands (British)', 'VG', 'VGB');
INSERT INTO `geo_country_reference` VALUES (232, 'Virgin Islands (U.S.)', 'VI', 'VIR');
INSERT INTO `geo_country_reference` VALUES (233, 'Wallis and Futuna Islands', 'WF', 'WLF');
INSERT INTO `geo_country_reference` VALUES (234, 'Western Sahara', 'EH', 'ESH');
INSERT INTO `geo_country_reference` VALUES (235, 'Yemen', 'YE', 'YEM');
INSERT INTO `geo_country_reference` VALUES (236, 'Yugoslavia', 'YU', 'YUG');
INSERT INTO `geo_country_reference` VALUES (237, 'Zaire', 'ZR', 'ZAR');
INSERT INTO `geo_country_reference` VALUES (238, 'Zambia', 'ZM', 'ZMB');
INSERT INTO `geo_country_reference` VALUES (239, 'Zimbabwe', 'ZW', 'ZWE');

-- --------------------------------------------------------

-- 
-- Table structure for table `geo_zone_reference`
-- 

DROP TABLE IF EXISTS `geo_zone_reference`;
CREATE TABLE `geo_zone_reference` (
  `zone_id` int(5) NOT NULL auto_increment,
  `zone_country_id` int(5) NOT NULL default '0',
  `zone_code` varchar(5) default NULL,
  `zone_name` varchar(32) default NULL,
  PRIMARY KEY  (`zone_id`)
) ENGINE=MyISAM AUTO_INCREMENT=83 ;

-- 
-- Dumping data for table `geo_zone_reference`
-- 

INSERT INTO `geo_zone_reference` VALUES (1, 223, 'AL', 'Alabama');
INSERT INTO `geo_zone_reference` VALUES (2, 223, 'AK', 'Alaska');
INSERT INTO `geo_zone_reference` VALUES (3, 223, 'AS', 'American Samoa');
INSERT INTO `geo_zone_reference` VALUES (4, 223, 'AZ', 'Arizona');
INSERT INTO `geo_zone_reference` VALUES (5, 223, 'AR', 'Arkansas');
INSERT INTO `geo_zone_reference` VALUES (6, 223, 'AF', 'Armed Forces Africa');
INSERT INTO `geo_zone_reference` VALUES (7, 223, 'AA', 'Armed Forces Americas');
INSERT INTO `geo_zone_reference` VALUES (8, 223, 'AC', 'Armed Forces Canada');
INSERT INTO `geo_zone_reference` VALUES (9, 223, 'AE', 'Armed Forces Europe');
INSERT INTO `geo_zone_reference` VALUES (10, 223, 'AM', 'Armed Forces Middle East');
INSERT INTO `geo_zone_reference` VALUES (11, 223, 'AP', 'Armed Forces Pacific');
INSERT INTO `geo_zone_reference` VALUES (12, 223, 'CA', 'California');
INSERT INTO `geo_zone_reference` VALUES (13, 223, 'CO', 'Colorado');
INSERT INTO `geo_zone_reference` VALUES (14, 223, 'CT', 'Connecticut');
INSERT INTO `geo_zone_reference` VALUES (15, 223, 'DE', 'Delaware');
INSERT INTO `geo_zone_reference` VALUES (16, 223, 'DC', 'District of Columbia');
INSERT INTO `geo_zone_reference` VALUES (17, 223, 'FM', 'Federated States Of Micronesia');
INSERT INTO `geo_zone_reference` VALUES (18, 223, 'FL', 'Florida');
INSERT INTO `geo_zone_reference` VALUES (19, 223, 'GA', 'Georgia');
INSERT INTO `geo_zone_reference` VALUES (20, 223, 'GU', 'Guam');
INSERT INTO `geo_zone_reference` VALUES (21, 223, 'HI', 'Hawaii');
INSERT INTO `geo_zone_reference` VALUES (22, 223, 'ID', 'Idaho');
INSERT INTO `geo_zone_reference` VALUES (23, 223, 'IL', 'Illinois');
INSERT INTO `geo_zone_reference` VALUES (24, 223, 'IN', 'Indiana');
INSERT INTO `geo_zone_reference` VALUES (25, 223, 'IA', 'Iowa');
INSERT INTO `geo_zone_reference` VALUES (26, 223, 'KS', 'Kansas');
INSERT INTO `geo_zone_reference` VALUES (27, 223, 'KY', 'Kentucky');
INSERT INTO `geo_zone_reference` VALUES (28, 223, 'LA', 'Louisiana');
INSERT INTO `geo_zone_reference` VALUES (29, 223, 'ME', 'Maine');
INSERT INTO `geo_zone_reference` VALUES (30, 223, 'MH', 'Marshall Islands');
INSERT INTO `geo_zone_reference` VALUES (31, 223, 'MD', 'Maryland');
INSERT INTO `geo_zone_reference` VALUES (32, 223, 'MA', 'Massachusetts');
INSERT INTO `geo_zone_reference` VALUES (33, 223, 'MI', 'Michigan');
INSERT INTO `geo_zone_reference` VALUES (34, 223, 'MN', 'Minnesota');
INSERT INTO `geo_zone_reference` VALUES (35, 223, 'MS', 'Mississippi');
INSERT INTO `geo_zone_reference` VALUES (36, 223, 'MO', 'Missouri');
INSERT INTO `geo_zone_reference` VALUES (37, 223, 'MT', 'Montana');
INSERT INTO `geo_zone_reference` VALUES (38, 223, 'NE', 'Nebraska');
INSERT INTO `geo_zone_reference` VALUES (39, 223, 'NV', 'Nevada');
INSERT INTO `geo_zone_reference` VALUES (40, 223, 'NH', 'New Hampshire');
INSERT INTO `geo_zone_reference` VALUES (41, 223, 'NJ', 'New Jersey');
INSERT INTO `geo_zone_reference` VALUES (42, 223, 'NM', 'New Mexico');
INSERT INTO `geo_zone_reference` VALUES (43, 223, 'NY', 'New York');
INSERT INTO `geo_zone_reference` VALUES (44, 223, 'NC', 'North Carolina');
INSERT INTO `geo_zone_reference` VALUES (45, 223, 'ND', 'North Dakota');
INSERT INTO `geo_zone_reference` VALUES (46, 223, 'MP', 'Northern Mariana Islands');
INSERT INTO `geo_zone_reference` VALUES (47, 223, 'OH', 'Ohio');
INSERT INTO `geo_zone_reference` VALUES (48, 223, 'OK', 'Oklahoma');
INSERT INTO `geo_zone_reference` VALUES (49, 223, 'OR', 'Oregon');
INSERT INTO `geo_zone_reference` VALUES (50, 223, 'PW', 'Palau');
INSERT INTO `geo_zone_reference` VALUES (51, 223, 'PA', 'Pennsylvania');
INSERT INTO `geo_zone_reference` VALUES (52, 223, 'PR', 'Puerto Rico');
INSERT INTO `geo_zone_reference` VALUES (53, 223, 'RI', 'Rhode Island');
INSERT INTO `geo_zone_reference` VALUES (54, 223, 'SC', 'South Carolina');
INSERT INTO `geo_zone_reference` VALUES (55, 223, 'SD', 'South Dakota');
INSERT INTO `geo_zone_reference` VALUES (56, 223, 'TN', 'Tenessee');
INSERT INTO `geo_zone_reference` VALUES (57, 223, 'TX', 'Texas');
INSERT INTO `geo_zone_reference` VALUES (58, 223, 'UT', 'Utah');
INSERT INTO `geo_zone_reference` VALUES (59, 223, 'VT', 'Vermont');
INSERT INTO `geo_zone_reference` VALUES (60, 223, 'VI', 'Virgin Islands');
INSERT INTO `geo_zone_reference` VALUES (61, 223, 'VA', 'Virginia');
INSERT INTO `geo_zone_reference` VALUES (62, 223, 'WA', 'Washington');
INSERT INTO `geo_zone_reference` VALUES (63, 223, 'WV', 'West Virginia');
INSERT INTO `geo_zone_reference` VALUES (64, 223, 'WI', 'Wisconsin');
INSERT INTO `geo_zone_reference` VALUES (65, 223, 'WY', 'Wyoming');
INSERT INTO `geo_zone_reference` VALUES (66, 38, 'AB', 'Alberta');
INSERT INTO `geo_zone_reference` VALUES (67, 38, 'BC', 'British Columbia');
INSERT INTO `geo_zone_reference` VALUES (68, 38, 'MB', 'Manitoba');
INSERT INTO `geo_zone_reference` VALUES (69, 38, 'NF', 'Newfoundland');
INSERT INTO `geo_zone_reference` VALUES (70, 38, 'NB', 'New Brunswick');
INSERT INTO `geo_zone_reference` VALUES (71, 38, 'NS', 'Nova Scotia');
INSERT INTO `geo_zone_reference` VALUES (72, 38, 'NT', 'Northwest Territories');
INSERT INTO `geo_zone_reference` VALUES (73, 38, 'NU', 'Nunavut');
INSERT INTO `geo_zone_reference` VALUES (74, 38, 'ON', 'Ontario');
INSERT INTO `geo_zone_reference` VALUES (75, 38, 'PE', 'Prince Edward Island');
INSERT INTO `geo_zone_reference` VALUES (76, 38, 'QC', 'Quebec');
INSERT INTO `geo_zone_reference` VALUES (77, 38, 'SK', 'Saskatchewan');
INSERT INTO `geo_zone_reference` VALUES (78, 38, 'YT', 'Yukon Territory');
INSERT INTO `geo_zone_reference` VALUES (79, 61, 'QLD', 'Queensland');
INSERT INTO `geo_zone_reference` VALUES (80, 61, 'SA', 'South Australia');
INSERT INTO `geo_zone_reference` VALUES (81, 61, 'ACT', 'Australian Capital Territory');
INSERT INTO `geo_zone_reference` VALUES (82, 61, 'VIC', 'Victoria');

-- --------------------------------------------------------

-- 
-- Table structure for table `groups`
-- 

DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `id` bigint(20) NOT NULL auto_increment,
  `name` longtext,
  `user` longtext,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `history_data`
-- 

DROP TABLE IF EXISTS `history_data`;
CREATE TABLE `history_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `coffee` longtext,
  `tobacco` longtext,
  `alcohol` longtext,
  `sleep_patterns` longtext,
  `exercise_patterns` longtext,
  `seatbelt_use` longtext,
  `counseling` longtext,
  `hazardous_activities` longtext,
  `recreational_drugs` longtext,
  `last_breast_exam` varchar(255) default NULL,
  `last_mammogram` varchar(255) default NULL,
  `last_gynocological_exam` varchar(255) default NULL,
  `last_rectal_exam` varchar(255) default NULL,
  `last_prostate_exam` varchar(255) default NULL,
  `last_physical_exam` varchar(255) default NULL,
  `last_sigmoidoscopy_colonoscopy` varchar(255) default NULL,
  `last_ecg` varchar(255) default NULL,
  `last_cardiac_echo` varchar(255) default NULL,
  `last_retinal` varchar(255) default NULL,
  `last_fluvax` varchar(255) default NULL,
  `last_pneuvax` varchar(255) default NULL,
  `last_ldl` varchar(255) default NULL,
  `last_hemoglobin` varchar(255) default NULL,
  `last_psa` varchar(255) default NULL,
  `last_exam_results` varchar(255) default NULL,
  `history_mother` longtext,
  `history_father` longtext,
  `history_siblings` longtext,
  `history_offspring` longtext,
  `history_spouse` longtext,
  `relatives_cancer` longtext,
  `relatives_tuberculosis` longtext,
  `relatives_diabetes` longtext,
  `relatives_high_blood_pressure` longtext,
  `relatives_heart_problems` longtext,
  `relatives_stroke` longtext,
  `relatives_epilepsy` longtext,
  `relatives_mental_illness` longtext,
  `relatives_suicide` longtext,
  `cataract_surgery` datetime default NULL,
  `tonsillectomy` datetime default NULL,
  `cholecystestomy` datetime default NULL,
  `heart_surgery` datetime default NULL,
  `hysterectomy` datetime default NULL,
  `hernia_repair` datetime default NULL,
  `hip_replacement` datetime default NULL,
  `knee_replacement` datetime default NULL,
  `appendectomy` datetime default NULL,
  `date` datetime default NULL,
  `pid` bigint(20) NOT NULL default '0',
  `name_1` varchar(255) default NULL,
  `value_1` varchar(255) default NULL,
  `name_2` varchar(255) default NULL,
  `value_2` varchar(255) default NULL,
  `additional_history` text,
  `exams`      text         NOT NULL DEFAULT '',
  `usertext11` varchar(255) NOT NULL DEFAULT '',
  `usertext12` varchar(255) NOT NULL DEFAULT '',
  `usertext13` varchar(255) NOT NULL DEFAULT '',
  `usertext14` varchar(255) NOT NULL DEFAULT '',
  `usertext15` varchar(255) NOT NULL DEFAULT '',
  `usertext16` varchar(255) NOT NULL DEFAULT '',
  `usertext17` varchar(255) NOT NULL DEFAULT '',
  `usertext18` varchar(255) NOT NULL DEFAULT '',
  `usertext19` varchar(255) NOT NULL DEFAULT '',
  `usertext20` varchar(255) NOT NULL DEFAULT '',
  `usertext21` varchar(255) NOT NULL DEFAULT '',
  `usertext22` varchar(255) NOT NULL DEFAULT '',
  `usertext23` varchar(255) NOT NULL DEFAULT '',
  `usertext24` varchar(255) NOT NULL DEFAULT '',
  `usertext25` varchar(255) NOT NULL DEFAULT '',
  `usertext26` varchar(255) NOT NULL DEFAULT '',
  `usertext27` varchar(255) NOT NULL DEFAULT '',
  `usertext28` varchar(255) NOT NULL DEFAULT '',
  `usertext29` varchar(255) NOT NULL DEFAULT '',
  `usertext30` varchar(255) NOT NULL DEFAULT '',
  `userdate11` date DEFAULT NULL,
  `userdate12` date DEFAULT NULL,
  `userdate13` date DEFAULT NULL,
  `userdate14` date DEFAULT NULL,
  `userdate15` date DEFAULT NULL,
  `userarea11` text NOT NULL DEFAULT '',
  `userarea12` text NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `immunizations`
-- 

DROP TABLE IF EXISTS `immunizations`;
CREATE TABLE `immunizations` (
  `id` bigint(20) NOT NULL auto_increment,
  `patient_id` int(11) default NULL,
  `administered_date` date default NULL,
  `immunization_id` int(11) default NULL,
  `manufacturer` varchar(100) default NULL,
  `lot_number` varchar(50) default NULL,
  `administered_by_id` bigint(20) default NULL,
  `administered_by` VARCHAR( 255 ) default NULL COMMENT 'Alternative to administered_by_id',
  `education_date` date default NULL,
  `vis_date` date default NULL COMMENT 'Date of VIS Statement', 
  `note` text,
  `create_date` datetime default NULL,
  `update_date` timestamp NOT NULL,
  `created_by` bigint(20) default NULL,
  `updated_by` bigint(20) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `insurance_companies`
-- 

DROP TABLE IF EXISTS `insurance_companies`;
CREATE TABLE `insurance_companies` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `attn` varchar(255) default NULL,
  `cms_id` varchar(15) default NULL,
  `freeb_type` tinyint(2) default NULL,
  `x12_receiver_id` varchar(25) default NULL,
  `x12_default_partner_id` int(11) default NULL,
  `alt_cms_id` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `insurance_data`
-- 

DROP TABLE IF EXISTS `insurance_data`;
CREATE TABLE `insurance_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `type` enum('primary','secondary','tertiary') default NULL,
  `provider` varchar(255) default NULL,
  `plan_name` varchar(255) default NULL,
  `policy_number` varchar(255) default NULL,
  `group_number` varchar(255) default NULL,
  `subscriber_lname` varchar(255) default NULL,
  `subscriber_mname` varchar(255) default NULL,
  `subscriber_fname` varchar(255) default NULL,
  `subscriber_relationship` varchar(255) default NULL,
  `subscriber_ss` varchar(255) default NULL,
  `subscriber_DOB` date default NULL,
  `subscriber_street` varchar(255) default NULL,
  `subscriber_postal_code` varchar(255) default NULL,
  `subscriber_city` varchar(255) default NULL,
  `subscriber_state` varchar(255) default NULL,
  `subscriber_country` varchar(255) default NULL,
  `subscriber_phone` varchar(255) default NULL,
  `subscriber_employer` varchar(255) default NULL,
  `subscriber_employer_street` varchar(255) default NULL,
  `subscriber_employer_postal_code` varchar(255) default NULL,
  `subscriber_employer_state` varchar(255) default NULL,
  `subscriber_employer_country` varchar(255) default NULL,
  `subscriber_employer_city` varchar(255) default NULL,
  `copay` varchar(255) default NULL,
  `date` date NOT NULL default '0000-00-00',
  `pid` bigint(20) NOT NULL default '0',
  `subscriber_sex` varchar(25) default NULL,
  `accept_assignment` varchar(5) NOT NULL DEFAULT 'TRUE',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `pid_type_date` (`pid`,`type`,`date`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `insurance_numbers`
-- 

DROP TABLE IF EXISTS `insurance_numbers`;
CREATE TABLE `insurance_numbers` (
  `id` int(11) NOT NULL default '0',
  `provider_id` int(11) NOT NULL default '0',
  `insurance_company_id` int(11) default NULL,
  `provider_number` varchar(20) default NULL,
  `rendering_provider_number` varchar(20) default NULL,
  `group_number` varchar(20) default NULL,
  `provider_number_type` varchar(4) default NULL,
  `rendering_provider_number_type` varchar(4) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `integration_mapping`
-- 

DROP TABLE IF EXISTS `integration_mapping`;
CREATE TABLE `integration_mapping` (
  `id` int(11) NOT NULL default '0',
  `foreign_id` int(11) NOT NULL default '0',
  `foreign_table` varchar(125) default NULL,
  `local_id` int(11) NOT NULL default '0',
  `local_table` varchar(125) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `foreign_id` (`foreign_id`,`foreign_table`,`local_id`,`local_table`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `issue_encounter`
-- 

DROP TABLE IF EXISTS `issue_encounter`;
CREATE TABLE `issue_encounter` (
  `pid` int(11) NOT NULL,
  `list_id` int(11) NOT NULL,
  `encounter` int(11) NOT NULL,
  `resolved` tinyint(1) NOT NULL,
  PRIMARY KEY  (`pid`,`list_id`,`encounter`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `lang_constants`
-- 

DROP TABLE IF EXISTS `lang_constants`;
CREATE TABLE `lang_constants` (
  `cons_id` int(11) NOT NULL auto_increment,
  `constant_name` varchar(255) BINARY default NULL,
  UNIQUE KEY `cons_id` (`cons_id`),
  KEY `constant_name` (`constant_name`)
) ENGINE=MyISAM ;

-- 
-- Table structure for table `lang_definitions`
-- 

DROP TABLE IF EXISTS `lang_definitions`;
CREATE TABLE `lang_definitions` (
  `def_id` int(11) NOT NULL auto_increment,
  `cons_id` int(11) NOT NULL default '0',
  `lang_id` int(11) NOT NULL default '0',
  `definition` mediumtext,
  UNIQUE KEY `def_id` (`def_id`),
  KEY `cons_id` (`cons_id`)
) ENGINE=MyISAM ;

-- 
-- Table structure for table `lang_languages`
-- 

DROP TABLE IF EXISTS `lang_languages`;
CREATE TABLE `lang_languages` (
  `lang_id` int(11) NOT NULL auto_increment,
  `lang_code` char(2) NOT NULL default '',
  `lang_description` varchar(100) default NULL,
  UNIQUE KEY `lang_id` (`lang_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 ;

-- 
-- Dumping data for table `lang_languages`
-- 

INSERT INTO `lang_languages` VALUES (1, 'en', 'English');

-- --------------------------------------------------------

--
-- Table structure for table `lang_custom`
--

DROP TABLE IF EXISTS `lang_custom`;
CREATE TABLE `lang_custom` (
  `lang_description` varchar(100) NOT NULL default '',
  `lang_code` char(2) NOT NULL default '',
  `constant_name` varchar(255) NOT NULL default '',
  `definition` mediumtext NOT NULL default ''
) ENGINE=MyISAM ;

-- --------------------------------------------------------

-- 
-- Table structure for table `layout_options`
-- 

DROP TABLE IF EXISTS `layout_options`;
CREATE TABLE `layout_options` (
  `form_id` varchar(31) NOT NULL default '',
  `field_id` varchar(31) NOT NULL default '',
  `group_name` varchar(31) NOT NULL default '',
  `title` varchar(63) NOT NULL default '',
  `seq` int(11) NOT NULL default '0',
  `data_type` tinyint(3) NOT NULL default '0',
  `uor` tinyint(1) NOT NULL default '1',
  `fld_length` int(11) NOT NULL default '15',
  `max_length` int(11) NOT NULL default '0',
  `list_id` varchar(31) NOT NULL default '',
  `titlecols` tinyint(3) NOT NULL default '1',
  `datacols` tinyint(3) NOT NULL default '1',
  `default_value` varchar(255) NOT NULL default '',
  `edit_options` varchar(36) NOT NULL default '',
  `description` text,
  PRIMARY KEY  (`form_id`,`field_id`,`seq`)
) ENGINE=MyISAM;

-- 
-- Dumping data for table `layout_options`
-- 
INSERT INTO `layout_options` VALUES ('DEM', 'title', '1Who', 'Name', 1, 1, 1, 0, 0, 'titles', 1, 1, '', 'N', 'Title');
INSERT INTO `layout_options` VALUES ('DEM', 'fname', '1Who', '', 2, 2, 2, 10, 63, '', 0, 0, '', 'CD', 'First Name');
INSERT INTO `layout_options` VALUES ('DEM', 'mname', '1Who', '', 3, 2, 1, 2, 63, '', 0, 0, '', 'C', 'Middle Name');
INSERT INTO `layout_options` VALUES ('DEM', 'lname', '1Who', '', 4, 2, 2, 10, 63, '', 0, 0, '', 'CD', 'Last Name');
INSERT INTO `layout_options` VALUES ('DEM', 'pubpid', '1Who', 'External ID', 5, 2, 1, 10, 15, '', 1, 1, '', 'ND', 'External identifier');
INSERT INTO `layout_options` VALUES ('DEM', 'DOB', '1Who', 'DOB', 6, 4, 2, 10, 10, '', 1, 1, '', 'D', 'Date of Birth');
INSERT INTO `layout_options` VALUES ('DEM', 'sex', '1Who', 'Sex', 7, 1, 2, 0, 0, 'sex', 1, 1, '', 'N', 'Sex');
INSERT INTO `layout_options` VALUES ('DEM', 'ss', '1Who', 'S.S.', 8, 2, 1, 11, 11, '', 1, 1, '', '', 'Social Security Number');
INSERT INTO `layout_options` VALUES ('DEM', 'drivers_license', '1Who', 'License/ID', 9, 2, 1, 15, 63, '', 1, 1, '', '', 'Drivers License or State ID');
INSERT INTO `layout_options` VALUES ('DEM', 'status', '1Who', 'Marital Status', 10, 1, 1, 0, 0, 'marital', 1, 3, '', '', 'Marital Status');
INSERT INTO `layout_options` VALUES ('DEM', 'genericname1', '1Who', 'User Defined', 11, 2, 1, 15, 63, '', 1, 3, '', '', 'User Defined Field');
INSERT INTO `layout_options` VALUES ('DEM', 'genericval1', '1Who', '', 12, 2, 1, 15, 63, '', 0, 0, '', '', 'User Defined Field');
INSERT INTO `layout_options` VALUES ('DEM', 'genericname2', '1Who', '', 13, 2, 1, 15, 63, '', 0, 0, '', '', 'User Defined Field');
INSERT INTO `layout_options` VALUES ('DEM', 'genericval2', '1Who', '', 14, 2, 1, 15, 63, '', 0, 0, '', '', 'User Defined Field');
INSERT INTO `layout_options` VALUES ('DEM', 'squad', '1Who', 'Squad', 15, 13, 0, 0, 0, '', 1, 3, '', '', 'Squad Membership');
INSERT INTO `layout_options` VALUES ('DEM', 'pricelevel', '1Who', 'Price Level', 16, 1, 0, 0, 0, 'pricelevel', 1, 1, '', '', 'Discount Level');
INSERT INTO `layout_options` VALUES ('DEM', 'street', '2Contact', 'Address', 1, 2, 1, 25, 63, '', 1, 1, '', 'C', 'Street and Number');
INSERT INTO `layout_options` VALUES ('DEM', 'city', '2Contact', 'City', 2, 2, 1, 15, 63, '', 1, 1, '', 'C', 'City Name');
INSERT INTO `layout_options` VALUES ('DEM', 'state', '2Contact', 'State', 3, 26, 1, 0, 0, 'state', 1, 1, '', '', 'State/Locality');
INSERT INTO `layout_options` VALUES ('DEM', 'postal_code', '2Contact', 'Postal Code', 4, 2, 1, 6, 63, '', 1, 1, '', '', 'Postal Code');
INSERT INTO `layout_options` VALUES ('DEM', 'country_code', '2Contact', 'Country', 5, 26, 1, 0, 0, 'country', 1, 1, '', '', 'Country');
INSERT INTO `layout_options` VALUES ('DEM', 'mothersname', '2Contact', 'Mother''s Name', 6, 2, 1, 20, 63, '', 1, 1, '', '', '');
INSERT INTO `layout_options` VALUES ('DEM', 'guardiansname', '2Contact', 'Guardian''s Name', 7, 2, 1, 20, 63, '', 1, 1, '', '', '');
INSERT INTO `layout_options` VALUES ('DEM', 'contact_relationship', '2Contact', 'Emergency Contact', 8, 2, 1, 10, 63, '', 1, 1, '', 'C', 'Emergency Contact Person');
INSERT INTO `layout_options` VALUES ('DEM', 'phone_contact', '2Contact', 'Emergency Phone', 9, 2, 1, 20, 63, '', 1, 1, '', 'P', 'Emergency Contact Phone Number');
INSERT INTO `layout_options` VALUES ('DEM', 'phone_home', '2Contact', 'Home Phone', 10, 2, 1, 20, 63, '', 1, 1, '', 'P', 'Home Phone Number');
INSERT INTO `layout_options` VALUES ('DEM', 'phone_biz', '2Contact', 'Work Phone', 11, 2, 1, 20, 63, '', 1, 1, '', 'P', 'Work Phone Number');
INSERT INTO `layout_options` VALUES ('DEM', 'phone_cell', '2Contact', 'Mobile Phone', 12, 2, 1, 20, 63, '', 1, 1, '', 'P', 'Cell Phone Number');
INSERT INTO `layout_options` VALUES ('DEM', 'email', '2Contact', 'Contact Email', 13, 2, 1, 30, 95, '', 1, 1, '', '', 'Contact Email Address');
INSERT INTO `layout_options` VALUES ('DEM', 'providerID', '3Choices', 'Provider', 1, 11, 1, 0, 0, '', 1, 3, '', '', 'Referring Provider');
INSERT INTO `layout_options` VALUES ('DEM', 'pharmacy_id', '3Choices', 'Pharmacy', 2, 12, 1, 0, 0, '', 1, 3, '', '', 'Preferred Pharmacy');
INSERT INTO `layout_options` VALUES ('DEM', 'hipaa_notice', '3Choices', 'HIPAA Notice Received', 3, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Did you receive a copy of the HIPAA Notice?');
INSERT INTO `layout_options` VALUES ('DEM', 'hipaa_voice', '3Choices', 'Allow Voice Message', 4, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Allow telephone messages?');
INSERT INTO `layout_options` VALUES ('DEM', 'hipaa_message', '3Choices', 'Leave Message With', 5, 2, 1, 20, 63, '', 1, 1, '', '', 'With whom may we leave a message?');
INSERT INTO `layout_options` VALUES ('DEM', 'hipaa_mail', '3Choices', 'Allow Mail Message', 6, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Allow email messages?');
INSERT INTO `layout_options` VALUES ('DEM', 'hipaa_allowsms'  , '3Choices', 'Allow SMS'  , 7, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Allow SMS (text messages)?');
INSERT INTO `layout_options` VALUES ('DEM', 'hipaa_allowemail', '3Choices', 'Allow Email', 8, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Allow Email?');

INSERT INTO `layout_options` VALUES ('DEM', 'allow_imm_reg_use', '3Choices', 'Allow Immunization Registry Use', 9, 1, 1, 0, 0, 'yesno', 1, 1, '', '', '');
INSERT INTO `layout_options` VALUES ('DEM', 'allow_imm_info_share', '3Choices', 'Allow Immunization Info Sharing', 10, 1, 1, 0, 0, 'yesno', 1, 1, '', '', '');
INSERT INTO `layout_options` VALUES ('DEM', 'allow_health_info_ex', '3Choices', 'Allow Health Information Exchange', 11, 1, 1, 0, 0, 'yesno', 1, 1, '', '', '');
INSERT INTO `layout_options` VALUES ('DEM', 'occupation', '4Employer', 'Occupation', 1, 2, 1, 20, 63, '', 1, 1, '', 'C', 'Occupation');
INSERT INTO `layout_options` VALUES ('DEM', 'em_name', '4Employer', 'Employer Name', 2, 2, 1, 20, 63, '', 1, 1, '', 'C', 'Employer Name');
INSERT INTO `layout_options` VALUES ('DEM', 'em_street', '4Employer', 'Employer Address', 3, 2, 1, 25, 63, '', 1, 1, '', 'C', 'Street and Number');
INSERT INTO `layout_options` VALUES ('DEM', 'em_city', '4Employer', 'City', 4, 2, 1, 15, 63, '', 1, 1, '', 'C', 'City Name');
INSERT INTO `layout_options` VALUES ('DEM', 'em_state', '4Employer', 'State', 5, 26, 1, 0, 0, 'state', 1, 1, '', '', 'State/Locality');
INSERT INTO `layout_options` VALUES ('DEM', 'em_postal_code', '4Employer', 'Postal Code', 6, 2, 1, 6, 63, '', 1, 1, '', '', 'Postal Code');
INSERT INTO `layout_options` VALUES ('DEM', 'em_country', '4Employer', 'Country', 7, 26, 1, 0, 0, 'country', 1, 1, '', '', 'Country');
INSERT INTO `layout_options` VALUES ('DEM', 'language', '5Stats', 'Language', 1, 26, 1, 0, 0, 'language', 1, 1, '', '', 'Preferred Language');
INSERT INTO `layout_options` VALUES ('DEM', 'ethnoracial', '5Stats', 'Race/Ethnicity', 2, 26, 1, 0, 0, 'ethrace', 1, 1, '', '', 'Ethnicity or Race');
INSERT INTO `layout_options` VALUES ('DEM', 'financial_review', '5Stats', 'Financial Review Date', 3, 2, 1, 10, 10, '', 1, 1, '', 'D', 'Financial Review Date');
INSERT INTO `layout_options` VALUES ('DEM', 'family_size', '5Stats', 'Family Size', 4, 2, 1, 20, 63, '', 1, 1, '', '', 'Family Size');
INSERT INTO `layout_options` VALUES ('DEM', 'monthly_income', '5Stats', 'Monthly Income', 5, 2, 1, 20, 63, '', 1, 1, '', '', 'Monthly Income');
INSERT INTO `layout_options` VALUES ('DEM', 'homeless', '5Stats', 'Homeless, etc.', 6, 2, 1, 20, 63, '', 1, 1, '', '', 'Homeless or similar?');
INSERT INTO `layout_options` VALUES ('DEM', 'interpretter', '5Stats', 'Interpreter', 7, 2, 1, 20, 63, '', 1, 1, '', '', 'Interpreter needed?');
INSERT INTO `layout_options` VALUES ('DEM', 'migrantseasonal', '5Stats', 'Migrant/Seasonal', 8, 2, 1, 20, 63, '', 1, 1, '', '', 'Migrant or seasonal worker?');
INSERT INTO `layout_options` VALUES ('DEM', 'contrastart', '5Stats', 'Contraceptives Start',9,4,0,10,10,'',1,1,'','','Date contraceptive services initially provided');
INSERT INTO `layout_options` VALUES ('DEM', 'referral_source', '5Stats', 'Referral Source',10, 26, 1, 0, 0, 'refsource', 1, 1, '', '', 'How did they hear about us');
INSERT INTO `layout_options` VALUES ('DEM', 'vfc', '5Stats', 'VFC', 12, 1, 1, 20, 0, 'eligibility', 1, 1, '', '', 'Eligibility status for Vaccine for Children supplied vaccine');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext1', '6Misc', 'User Defined Text 1', 1, 2, 0, 10, 63, '', 1, 1, '', '', 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext2', '6Misc', 'User Defined Text 2', 2, 2, 0, 10, 63, '', 1, 1, '', '', 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext3', '6Misc', 'User Defined Text 3', 3,2,0,10,63,'',1,1,'','','User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext4', '6Misc', 'User Defined Text 4', 4,2,0,10,63,'',1,1,'','','User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext5', '6Misc', 'User Defined Text 5', 5,2,0,10,63,'',1,1,'','','User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext6', '6Misc', 'User Defined Text 6', 6,2,0,10,63,'',1,1,'','','User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext7', '6Misc', 'User Defined Text 7', 7,2,0,10,63,'',1,1,'','','User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext8', '6Misc', 'User Defined Text 8', 8,2,0,10,63,'',1,1,'','','User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist1', '6Misc', 'User Defined List 1', 9, 1, 0, 0, 0, 'userlist1', 1, 1, '', '', 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist2', '6Misc', 'User Defined List 2',10, 1, 0, 0, 0, 'userlist2', 1, 1, '', '', 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist3', '6Misc', 'User Defined List 3',11, 1, 0, 0, 0, 'userlist3', 1, 1, '', '' , 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist4', '6Misc', 'User Defined List 4',12, 1, 0, 0, 0, 'userlist4', 1, 1, '', '' , 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist5', '6Misc', 'User Defined List 5',13, 1, 0, 0, 0, 'userlist5', 1, 1, '', '' , 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist6', '6Misc', 'User Defined List 6',14, 1, 0, 0, 0, 'userlist6', 1, 1, '', '' , 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist7', '6Misc', 'User Defined List 7',15, 1, 0, 0, 0, 'userlist7', 1, 1, '', '' , 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'regdate'  , '6Misc', 'Registration Date'  ,16, 4, 0,10,10, ''         , 1, 1, '', 'D', 'Start Date at This Clinic');


INSERT INTO layout_options VALUES ('REF','refer_date'      ,'1Referral','Referral Date'                  , 1, 4,2, 0,  0,''         ,1,1,'C','D','Date of referral');
INSERT INTO layout_options VALUES ('REF','refer_from'      ,'1Referral','Refer By'                       , 2,10,2, 0,  0,''         ,1,1,'' ,'' ,'Referral By');
INSERT INTO layout_options VALUES ('REF','refer_external'  ,'1Referral','External Referral'              , 3, 1,1, 0,  0,'boolean'  ,1,1,'' ,'' ,'External referral?');
INSERT INTO layout_options VALUES ('REF','refer_to'        ,'1Referral','Refer To'                       , 4,14,2, 0,  0,''         ,1,1,'' ,'' ,'Referral To');
INSERT INTO layout_options VALUES ('REF','body'            ,'1Referral','Reason'                         , 5, 3,2,30,  3,''         ,1,1,'' ,'' ,'Reason for referral');
INSERT INTO layout_options VALUES ('REF','refer_diag'      ,'1Referral','Referrer Diagnosis'             , 6, 2,1,30,255,''         ,1,1,'' ,'X','Referrer diagnosis');
INSERT INTO layout_options VALUES ('REF','refer_risk_level','1Referral','Risk Level'                     , 7, 1,1, 0,  0,'risklevel',1,1,'' ,'' ,'Level of urgency');
INSERT INTO layout_options VALUES ('REF','refer_vitals'    ,'1Referral','Include Vitals'                 , 8, 1,1, 0,  0,'boolean'  ,1,1,'' ,'' ,'Include vitals data?');
INSERT INTO layout_options VALUES ('REF','refer_related_code','1Referral','Requested Service'            , 9,15,1,30,255,''         ,1,1,'' ,'' ,'Billing Code for Requested Service');
INSERT INTO layout_options VALUES ('REF','reply_date'      ,'2Counter-Referral','Reply Date'             ,10, 4,1, 0,  0,''         ,1,1,'' ,'D','Date of reply');
INSERT INTO layout_options VALUES ('REF','reply_from'      ,'2Counter-Referral','Reply From'             ,11, 2,1,30,255,''         ,1,1,'' ,'' ,'Who replied?');
INSERT INTO layout_options VALUES ('REF','reply_init_diag' ,'2Counter-Referral','Presumed Diagnosis'     ,12, 2,1,30,255,''         ,1,1,'' ,'' ,'Presumed diagnosis by specialist');
INSERT INTO layout_options VALUES ('REF','reply_final_diag','2Counter-Referral','Final Diagnosis'        ,13, 2,1,30,255,''         ,1,1,'' ,'' ,'Final diagnosis by specialist');
INSERT INTO layout_options VALUES ('REF','reply_documents' ,'2Counter-Referral','Documents'              ,14, 2,1,30,255,''         ,1,1,'' ,'' ,'Where may related scanned or paper documents be found?');
INSERT INTO layout_options VALUES ('REF','reply_findings'  ,'2Counter-Referral','Findings'               ,15, 3,1,30,  3,''         ,1,1,'' ,'' ,'Findings by specialist');
INSERT INTO layout_options VALUES ('REF','reply_services'  ,'2Counter-Referral','Services Provided'      ,16, 3,1,30,  3,''         ,1,1,'' ,'' ,'Service provided by specialist');
INSERT INTO layout_options VALUES ('REF','reply_recommend' ,'2Counter-Referral','Recommendations'        ,17, 3,1,30,  3,''         ,1,1,'' ,'' ,'Recommendations by specialist');
INSERT INTO layout_options VALUES ('REF','reply_rx_refer'  ,'2Counter-Referral','Prescriptions/Referrals',18, 3,1,30,  3,''         ,1,1,'' ,'' ,'Prescriptions and/or referrals by specialist');

INSERT INTO layout_options VALUES ('HIS','usertext11','1General','Risk Factors',1,21,1,0,0,'riskfactors',1,1,'','' ,'Risk Factors');
INSERT INTO layout_options VALUES ('HIS','exams'     ,'1General','Exams/Tests' ,2,23,1,0,0,'exams'      ,1,1,'','' ,'Exam and test results');
INSERT INTO layout_options VALUES ('HIS','history_father'   ,'2Family History','Father'   ,1, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','history_mother'   ,'2Family History','Mother'   ,2, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','history_siblings' ,'2Family History','Siblings' ,3, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','history_spouse'   ,'2Family History','Spouse'   ,4, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','history_offspring','2Family History','Offspring',5, 2,1,20,255,'',1,3,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_cancer'             ,'3Relatives','Cancer'             ,1, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_tuberculosis'       ,'3Relatives','Tuberculosis'       ,2, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_diabetes'           ,'3Relatives','Diabetes'           ,3, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_high_blood_pressure','3Relatives','High Blood Pressure',4, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_heart_problems'     ,'3Relatives','Heart Problems'     ,5, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_stroke'             ,'3Relatives','Stroke'             ,6, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_epilepsy'           ,'3Relatives','Epilepsy'           ,7, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_mental_illness'     ,'3Relatives','Mental Illness'     ,8, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_suicide'            ,'3Relatives','Suicide'            ,9, 2,1,20,255,'',1,3,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','coffee'              ,'4Lifestyle','Coffee'              ,1,28,1,20,255,'',1,3,'','' ,'Caffeine consumption');
INSERT INTO layout_options VALUES ('HIS','tobacco'             ,'4Lifestyle','Tobacco'             ,2,28,1,20,255,'',1,3,'','' ,'Tobacco use');
INSERT INTO layout_options VALUES ('HIS','alcohol'             ,'4Lifestyle','Alcohol'             ,3,28,1,20,255,'',1,3,'','' ,'Alcohol consumption');
INSERT INTO layout_options VALUES ('HIS','recreational_drugs'  ,'4Lifestyle','Recreational Drugs'  ,4,28,1,20,255,'',1,3,'','' ,'Recreational drug use');
INSERT INTO layout_options VALUES ('HIS','counseling'          ,'4Lifestyle','Counseling'          ,5,28,1,20,255,'',1,3,'','' ,'Counseling activities');
INSERT INTO layout_options VALUES ('HIS','exercise_patterns'   ,'4Lifestyle','Exercise Patterns'   ,6,28,1,20,255,'',1,3,'','' ,'Exercise patterns');
INSERT INTO layout_options VALUES ('HIS','hazardous_activities','4Lifestyle','Hazardous Activities',7,28,1,20,255,'',1,3,'','' ,'Hazardous activities');
INSERT INTO layout_options VALUES ('HIS','sleep_patterns'      ,'4Lifestyle','Sleep Patterns'      ,8, 2,1,20,255,'',1,3,'','' ,'Sleep patterns');
INSERT INTO layout_options VALUES ('HIS','seatbelt_use'        ,'4Lifestyle','Seatbelt Use'        ,9, 2,1,20,255,'',1,3,'','' ,'Seatbelt use');
INSERT INTO layout_options VALUES ('HIS','name_1'            ,'5Other','Name/Value'        ,1, 2,1,10,255,'',1,1,'','' ,'Name 1' );
INSERT INTO layout_options VALUES ('HIS','value_1'           ,'5Other',''                  ,2, 2,1,10,255,'',0,0,'','' ,'Value 1');
INSERT INTO layout_options VALUES ('HIS','name_2'            ,'5Other','Name/Value'        ,3, 2,1,10,255,'',1,1,'','' ,'Name 2' );
INSERT INTO layout_options VALUES ('HIS','value_2'           ,'5Other',''                  ,4, 2,1,10,255,'',0,0,'','' ,'Value 2');
INSERT INTO layout_options VALUES ('HIS','additional_history','5Other','Additional History',5, 3,1,30,  3,'',1,3,'' ,'' ,'Additional history notes');
INSERT INTO layout_options VALUES ('HIS','userarea11'        ,'5Other','User Defined Area 11',6,3,0,30,3,'',1,3,'','','User Defined');
INSERT INTO layout_options VALUES ('HIS','userarea12'        ,'5Other','User Defined Area 12',7,3,0,30,3,'',1,3,'','','User Defined');

-- --------------------------------------------------------

-- 
-- Table structure for table `list_options`
-- 

DROP TABLE IF EXISTS `list_options`;
CREATE TABLE `list_options` (
  `list_id` varchar(31) NOT NULL default '',
  `option_id` varchar(31) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `seq` int(11) NOT NULL default '0',
  `is_default` tinyint(1) NOT NULL default '0',
  `option_value` float NOT NULL default '0',
  `mapping` varchar(31) NOT NULL DEFAULT '',
  `notes` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY  (`list_id`,`option_id`)
) ENGINE=MyISAM;

-- 
-- Dumping data for table `list_options`
-- 

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('yesno', 'NO', 'NO', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('yesno', 'YES', 'YES', 2, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('titles', 'Mr.', 'Mr.', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('titles', 'Mrs.', 'Mrs.', 2, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('titles', 'Ms.', 'Ms.', 3, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('titles', 'Dr.', 'Dr.', 4, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('sex', 'Female', 'Female', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('sex', 'Male', 'Male', 2, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('marital', 'married', 'Married', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('marital', 'single', 'Single', 2, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('marital', 'divorced', 'Divorced', 3, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('marital', 'widowed', 'Widowed', 4, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('marital', 'separated', 'Separated', 5, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('marital', 'domestic partner', 'Domestic Partner', 6, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'armenian', 'Armenian', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'chinese', 'Chinese', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'danish', 'Danish', 30, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'deaf', 'Deaf', 40, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'English', 'English', 50, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'farsi', 'Farsi', 60, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'french', 'French', 70, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'german', 'German', 80, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'greek', 'Greek', 90, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'hmong', 'Hmong', 100, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'italian', 'Italian', 110, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'japanese', 'Japanese', 120, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'korean', 'Korean', 130, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'laotian', 'Laotian', 140, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'mien', 'Mien', 150, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'norwegian', 'Norwegian', 160, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'othrs', 'Others', 170, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'portuguese', 'Portuguese', 180, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'punjabi', 'Punjabi', 190, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'russian', 'Russian', 200, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'Spanish', 'Spanish', 210, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'tagalog', 'Tagalog', 220, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'turkish', 'Turkish', 230, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'vietnamese', 'Vietnamese', 240, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'yiddish', 'Yiddish', 250, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'zulu', 'Zulu', 260, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'aleut', 'ALEUT', 10,  0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'amer_indian', 'American Indian', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'Asian', 'Asian', 30, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'Black', 'Black', 40, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'cambodian', 'Cambodian', 50, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'Caucasian', 'Caucasian', 60, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'cs_american', 'Central/South American', 70, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'chinese', 'Chinese', 80, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'cuban', 'Cuban', 90, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'eskimo', 'Eskimo', 100, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'filipino', 'Filipino', 110, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'guamanian', 'Guamanian', 120, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'hawaiian', 'Hawaiian', 130, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'Hispanic', 'Hispanic', 140, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'othr_us', 'Hispanic - Other (Born in US)', 150, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'othr_non_us', 'Hispanic - Other (Born outside US)', 160, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'hmong', 'Hmong', 170, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'indian', 'Indian', 180, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'japanese', 'Japanese', 190, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'korean', 'Korean', 200, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'laotian', 'Laotian', 210, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'mexican', 'Mexican/MexAmer/Chicano', 220, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'mlt-race', 'Multiracial', 230, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'othr', 'Other', 240, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'othr_spec', 'Other - Specified', 250, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'pac_island', 'Pacific Islander', 260, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'puerto_rican', 'Puerto Rican', 270, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'refused', 'Refused To State', 280, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'samoan', 'Samoan', 290, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'spec', 'Specified', 300, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'thai', 'Thai', 310, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'unknown', 'Unknown', 320, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'unspec', 'Unspecified', 330, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'vietnamese', 'Vietnamese', 340, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'white', 'White', 350, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'withheld', 'Withheld', 360, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist1', 'sample', 'Sample', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist2', 'sample', 'Sample', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist3','sample','Sample',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist4','sample','Sample',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist5','sample','Sample',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist6','sample','Sample',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist7','sample','Sample',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('pricelevel', 'standard', 'Standard', 1, 1);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('risklevel', 'low', 'Low', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('risklevel', 'medium', 'Medium', 2, 1);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('risklevel', 'high', 'High', 3, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('boolean', '0', 'No', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('boolean', '1', 'Yes', 2, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('country', 'USA', 'USA', 1, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','AL','Alabama'             , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','AK','Alaska'              , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','AZ','Arizona'             , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','AR','Arkansas'            , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','CA','California'          , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','CO','Colorado'            , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','CT','Connecticut'         , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','DE','Delaware'            , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','DC','District of Columbia', 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','FL','Florida'             ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','GA','Georgia'             ,11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','HI','Hawaii'              ,12,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','ID','Idaho'               ,13,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','IL','Illinois'            ,14,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','IN','Indiana'             ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','IA','Iowa'                ,16,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','KS','Kansas'              ,17,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','KY','Kentucky'            ,18,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','LA','Louisiana'           ,19,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','ME','Maine'               ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MD','Maryland'            ,21,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MA','Massachusetts'       ,22,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MI','Michigan'            ,23,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MN','Minnesota'           ,24,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MS','Mississippi'         ,25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MO','Missouri'            ,26,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MT','Montana'             ,27,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NE','Nebraska'            ,28,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NV','Nevada'              ,29,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NH','New Hampshire'       ,30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NJ','New Jersey'          ,31,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NM','New Mexico'          ,32,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NY','New York'            ,33,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NC','North Carolina'      ,34,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','ND','North Dakota'        ,35,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','OH','Ohio'                ,36,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','OK','Oklahoma'            ,37,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','OR','Oregon'              ,38,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','PA','Pennsylvania'        ,39,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','RI','Rhode Island'        ,40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','SC','South Carolina'      ,41,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','SD','South Dakota'        ,42,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','TN','Tennessee'           ,43,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','TX','Texas'               ,44,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','UT','Utah'                ,45,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','VT','Vermont'             ,46,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','VA','Virginia'            ,47,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','WA','Washington'          ,48,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','WV','West Virginia'       ,49,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','WI','Wisconsin'           ,50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','WY','Wyoming'             ,51,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Patient'      ,'Patient'      , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Employee'     ,'Employee'     , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Walk-In'      ,'Walk-In'      , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Newspaper'    ,'Newspaper'    , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Radio'        ,'Radio'        , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','T.V.'         ,'T.V.'         , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Direct Mail'  ,'Direct Mail'  , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Coupon'       ,'Coupon'       , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Referral Card','Referral Card', 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Other'        ,'Other'        ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','vv' ,'Varicose Veins'                      , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','ht' ,'Hypertension'                        , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','db' ,'Diabetes'                            , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','sc' ,'Sickle Cell'                         , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','fib','Fibroids'                            , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','pid','PID (Pelvic Inflammatory Disease)'   , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','mig','Severe Migraine'                     , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','hd' ,'Heart Disease'                       , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','str','Thrombosis/Stroke'                   , 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','hep','Hepatitis'                           ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','gb' ,'Gall Bladder Condition'              ,11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','br' ,'Breast Disease'                      ,12,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','dpr','Depression'                          ,13,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','all','Allergies'                           ,14,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','inf','Infertility'                         ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','ast','Asthma'                              ,16,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','ep' ,'Epilepsy'                            ,17,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','cl' ,'Contact Lenses'                      ,18,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','coc','Contraceptive Complication (specify)',19,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','oth','Other (specify)'                     ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'brs','Breast Exam'          , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'cec','Cardiac Echo'         , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'ecg','ECG'                  , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'gyn','Gynecological Exam'   , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'mam','Mammogram'            , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'phy','Physical Exam'        , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'pro','Prostate Exam'        , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'rec','Rectal Exam'          , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'sic','Sigmoid/Colonoscopy'  , 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'ret','Retinal Exam'         ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'flu','Flu Vaccination'      ,11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'pne','Pneumonia Vaccination',12,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'ldl','LDL'                  ,13,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'hem','Hemoglobin'           ,14,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'psa','PSA'                  ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','0',''           ,0,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','1','suspension' ,1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','2','tablet'     ,2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','3','capsule'    ,3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','4','solution'   ,4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','5','tsp'        ,5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','6','ml'         ,6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','7','units'      ,7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','8','inhalations',8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','9','gtts(drops)',9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','10','cream'   ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','11','ointment',11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','0',''          ,0,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','1','mg'    ,1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','2','mg/1cc',2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','3','mg/2cc',3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','4','mg/3cc',4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','5','mg/4cc',5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','6','mg/5cc',6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','7','mcg'   ,7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','8','grams' ,8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '0',''                 , 0,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '1','Per Oris'         , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '2','Per Rectum'       , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '3','To Skin'          , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '4','To Affected Area' , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '5','Sublingual'       , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '6','OS'               , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '7','OD'               , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '8','OU'               , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '9','SQ'               , 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route','10','IM'               ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route','11','IV'               ,11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route','12','Per Nostril'      ,12,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route','13','Both Ears',13,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route','14','Left Ear' ,14,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route','15','Right Ear',15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','0',''      ,0,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','1','b.i.d.',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','2','t.i.d.',2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','3','q.i.d.',3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','4','q.3h'  ,4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','5','q.4h'  ,5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','6','q.5h'  ,6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','7','q.6h'  ,7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','8','q.8h'  ,8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','9','q.d.'  ,9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','10','a.c.'  ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','11','p.c.'  ,11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','12','a.m.'  ,12,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','13','p.m.'  ,13,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','14','ante'  ,14,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','15','h'     ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','16','h.s.'  ,16,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','17','p.r.n.',17,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','18','stat'  ,18,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('chartloc','fileroom','File Room'              ,1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'boolean'      ,'Boolean'            , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'chartloc'     ,'Chart Storage Locations',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'country'      ,'Country'            , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'drug_form'    ,'Drug Forms'         , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'drug_units'   ,'Drug Units'         , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'drug_route'   ,'Drug Routes'        , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'drug_interval','Drug Intervals'     , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'exams'        ,'Exams/Tests'        , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'feesheet'     ,'Fee Sheet'          , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'language'     ,'Language'           , 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'lbfnames'     ,'Layout-Based Visit Forms',9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'marital'      ,'Marital Status'     ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'pricelevel'   ,'Price Level'        ,11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'ethrace'      ,'Race/Ethnicity'     ,12,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'refsource'    ,'Referral Source'    ,13,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'riskfactors'  ,'Risk Factors'       ,14,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'risklevel'    ,'Risk Level'         ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'superbill'    ,'Service Category'   ,16,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'sex'          ,'Sex'                ,17,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'state'        ,'State'              ,18,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'taxrate'      ,'Tax Rate'           ,19,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'titles'       ,'Titles'             ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'yesno'        ,'Yes/No'             ,21,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist1'    ,'User Defined List 1',22,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist2'    ,'User Defined List 2',23,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist3'    ,'User Defined List 3',24,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist4'    ,'User Defined List 4',25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist5'    ,'User Defined List 5',26,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist6'    ,'User Defined List 6',27,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist7'    ,'User Defined List 7',28,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'    ,'adjreason'      ,'Adjustment Reasons',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Adm adjust'     ,'Adm adjust'     , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','After hrs calls','After hrs calls',10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Bad check'      ,'Bad check'      ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Bad debt'       ,'Bad debt'       ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Coll w/o'       ,'Coll w/o'       ,25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Discount'       ,'Discount'       ,30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Hardship w/o'   ,'Hardship w/o'   ,35,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Ins adjust'     ,'Ins adjust'     ,40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Ins bundling'   ,'Ins bundling'   ,45,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Ins overpaid'   ,'Ins overpaid'   ,50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Ins refund'     ,'Ins refund'     ,55,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Pt overpaid'    ,'Pt overpaid'    ,60,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Pt refund'      ,'Pt refund'      ,65,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Pt released'    ,'Pt released'    ,70,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Sm debt w/o'    ,'Sm debt w/o'    ,75,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','To copay'       ,'To copay'       ,80,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','To ded\'ble'    ,'To ded\'ble'    ,85,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('adjreason','Untimely filing','Untimely filing',90,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'       ,'sub_relation','Subscriber Relationship',18,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('sub_relation','self'        ,'Self'                   , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('sub_relation','spouse'      ,'Spouse'                 , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('sub_relation','child'       ,'Child'                  , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('sub_relation','other'       ,'Other'                  , 4,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'     ,'occurrence','Occurrence'                  ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','0'         ,'Unknown or N/A'              , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','1'         ,'First'                       ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','6'         ,'Early Recurrence (<2 Mo)'    ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','7'         ,'Late Recurrence (2-12 Mo)'   ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','8'         ,'Delayed Recurrence (> 12 Mo)',25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','4'         ,'Chronic/Recurrent'           ,30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','5'         ,'Acute on Chronic'            ,35,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'  ,'outcome','Outcome'         ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('outcome','0'      ,'Unassigned'      , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('outcome','1'      ,'Resolved'        , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('outcome','2'      ,'Improved'        ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('outcome','3'      ,'Status quo'      ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('outcome','4'      ,'Worse'           ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('outcome','5'      ,'Pending followup',25,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'    ,'note_type'      ,'Patient Note Types',10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Unassigned'     ,'Unassigned'        , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Chart Note'     ,'Chart Note'        , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Insurance'      ,'Insurance'         , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','New Document'   ,'New Document'      , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Pharmacy'       ,'Pharmacy'          , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Prior Auth'     ,'Prior Auth'        , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Referral'       ,'Referral'          , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Test Scheduling','Test Scheduling'   , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Bill/Collect'   ,'Bill/Collect'      , 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Other'          ,'Other'             ,10,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'        ,'immunizations','Immunizations'           ,  8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','1'            ,'DTaP 1'                  , 30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','2'            ,'DTaP 2'                  , 35,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','3'            ,'DTaP 3'                  , 40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','4'            ,'DTaP 4'                  , 45,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','5'            ,'DTaP 5'                  , 50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','6'            ,'DT 1'                    ,  5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','7'            ,'DT 2'                    , 10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','8'            ,'DT 3'                    , 15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','9'            ,'DT 4'                    , 20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','10'           ,'DT 5'                    , 25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','11'           ,'IPV 1'                   ,110,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','12'           ,'IPV 2'                   ,115,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','13'           ,'IPV 3'                   ,120,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','14'           ,'IPV 4'                   ,125,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','15'           ,'Hib 1'                   , 80,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','16'           ,'Hib 2'                   , 85,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','17'           ,'Hib 3'                   , 90,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','18'           ,'Hib 4'                   , 95,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','19'           ,'Pneumococcal Conjugate 1',140,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','20'           ,'Pneumococcal Conjugate 2',145,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','21'           ,'Pneumococcal Conjugate 3',150,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','22'           ,'Pneumococcal Conjugate 4',155,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','23'           ,'MMR 1'                   ,130,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','24'           ,'MMR 2'                   ,135,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','25'           ,'Varicella 1'             ,165,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','26'           ,'Varicella 2'             ,170,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','27'           ,'Hepatitis B 1'           , 65,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','28'           ,'Hepatitis B 2'           , 70,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','29'           ,'Hepatitis B 3'           , 75,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','30'           ,'Influenza 1'             ,100,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','31'           ,'Influenza 2'             ,105,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','32'           ,'Td'                      ,160,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','33'           ,'Hepatitis A 1'           , 55,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','34'           ,'Hepatitis A 2'           , 60,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','35'           ,'Other'                   ,175,0);

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

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'    ,'warehouse','Warehouses',21,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('warehouse','onsite'   ,'On Site'   , 5,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','abook_type'  ,'Address Book Types'  , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('abook_type','ord_img','Imaging Service'     , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('abook_type','ord_imm','Immunization Service',10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('abook_type','ord_lab','Lab Service'         ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('abook_type','spe'    ,'Specialist'          ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('abook_type','vendor' ,'Vendor'              ,25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('abook_type','oth'    ,'Other'               ,95,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_type','Procedure Types', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_type','grp','Group'          ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_type','ord','Procedure Order',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_type','res','Discrete Result',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_type','rec','Recommendation' ,40,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_body_site','Procedure Body Sites', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_body_site','arm'    ,'Arm'    ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_body_site','buttock','Buttock',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_body_site','oth'    ,'Other'  ,90,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_specimen','Procedure Specimen Types', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_specimen','blood' ,'Blood' ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_specimen','saliva','Saliva',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_specimen','urine' ,'Urine' ,30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_specimen','oth'   ,'Other' ,90,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_route','Procedure Routes', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_route','inj' ,'Injection',10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_route','oral','Oral'     ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_route','oth' ,'Other'    ,90,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_lat','Procedure Lateralities', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_lat','left' ,'Left'     ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_lat','right','Right'    ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_lat','bilat','Bilateral',30,0);

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

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','ord_priority','Order Priorities', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_priority','high'  ,'High'  ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_priority','normal','Normal',20,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','ord_status','Order Statuses', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_status','pending' ,'Pending' ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_status','routed'  ,'Routed'  ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_status','complete','Complete',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_status','canceled','Canceled',40,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_rep_status','Procedure Report Statuses', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','final'  ,'Final'      ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','review' ,'Reviewed'   ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','prelim' ,'Preliminary',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','cancel' ,'Canceled'   ,40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','error'  ,'Error'      ,50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','correct','Corrected'  ,60,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_res_abnormal','Procedure Result Abnormal', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_abnormal','no'  ,'No'  ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_abnormal','yes' ,'Yes' ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_abnormal','high','High',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_abnormal','low' ,'Low' ,40,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_res_status','Procedure Result Statuses', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','final'     ,'Final'      ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','prelim'    ,'Preliminary',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','cancel'    ,'Canceled'   ,30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','error'     ,'Error'      ,40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','correct'   ,'Corrected'  ,50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','incomplete','Incomplete' ,60,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_res_bool','Procedure Boolean Results', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_bool','neg' ,'Negative',10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_bool','pos' ,'Positive',20,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'         ,'message_status','Message Status',45,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('message_status','Done'           ,'Done'         , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('message_status','Forwarded'      ,'Forwarded'    ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('message_status','New'            ,'New'          ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('message_status','Read'           ,'Read'         ,20,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Lab Results' ,'Lab Results', 15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','New Orders' ,'New Orders', 20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Patient Reminders' ,'Patient Reminders', 25,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'irnpool','Invoice Reference Number Pools', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes ) VALUES ('irnpool','main','Main',1,1,'000001');

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists', 'eligibility', 'Eligibility', 60, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('eligibility', 'eligible', 'Eligible', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('eligibility', 'ineligible', 'Ineligible', 20, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists', 'transactions', 'Transactions', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'Referral', 'Referral', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'Patient Request', 'Patient Request', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'Physician Request', 'Physician Request', 30, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'Legal', 'Legal', 40, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'Billing', 'Billing', 50, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'       ,'alert_status','Alert Status',51,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_status','New'         ,'New'         ,5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_status','Read'        ,'Read'        ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_status','Done'        ,'Done'        ,15,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'      ,'alert_color','Alert Color',50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_color','Black'      ,'Black'      ,5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_color','Blue'       ,'Blue'       ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_color','Brown'      ,'Brown'      ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_color','Green'      ,'Green'      ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_color','Purple'     ,'Purple'     ,25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('alert_color','Red'        ,'Red'        ,30,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'            ,'enrollment_status','Enrollment Status',55,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('enrollment_status','patient_refused'  ,'Patient Refused'  , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('enrollment_status','in_progress'      ,'In Progress'      ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('enrollment_status','completed'        ,'Completed'        ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('enrollment_status','on_hold'          ,'On Hold'          ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('enrollment_status','cancelled'        ,'Cancelled'        ,25,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'          ,'reminder_status','Reminder Status',60,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('reminder_status','sent'           ,'Sent'           , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('reminder_status','failed'         ,'Failed'         ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('reminder_status','pending'        ,'Pending'        ,15,1);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('reminder_status','on_hold'        ,'On Hold'        ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('reminder_status','cancelled'      ,'Cancelled'      ,25,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'          ,'health_plan_categories','Health Plan Categories',60,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('health_plan_categories','disease_management' ,'Disease Management' , 5,1);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('health_plan_categories','health_maintenance' ,'Health Maintenance' ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('health_plan_categories','wellness'           ,'Wellness'           ,15,0);

-- --------------------------------------------------------

-- 
-- Table structure for table `lists`
-- 

DROP TABLE IF EXISTS `lists`;
CREATE TABLE `lists` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `type` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `begdate` date default NULL,
  `enddate` date default NULL,
  `returndate` date default NULL,
  `occurrence` int(11) default '0',
  `classification` int(11) default '0',
  `referredby` varchar(255) default NULL,
  `extrainfo` varchar(255) default NULL,
  `diagnosis` varchar(255) default NULL,
  `activity` tinyint(4) default NULL,
  `comments` longtext,
  `pid` bigint(20) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `outcome` int(11) NOT NULL default '0',
  `destination` varchar(255) default NULL,
  `reinjury_id` bigint(20)  NOT NULL DEFAULT 0,
  `injury_part` varchar(31) NOT NULL DEFAULT '',
  `injury_type` varchar(31) NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `log`
-- 

DROP TABLE IF EXISTS `log`;
CREATE TABLE `log` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `event` varchar(255) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `comments` longtext,
  `user_notes` longtext,
  `patient_id` bigint(20) default NULL,
  `success` tinyint(1) default 1,
  `checksum` longtext default NULL,
  `crt_user` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `notes`
-- 

DROP TABLE IF EXISTS `notes`;
CREATE TABLE `notes` (
  `id` int(11) NOT NULL default '0',
  `foreign_id` int(11) NOT NULL default '0',
  `note` varchar(255) default NULL,
  `owner` int(11) default NULL,
  `date` datetime default NULL,
  `revision` timestamp NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `foreign_id` (`owner`),
  KEY `foreign_id_2` (`foreign_id`),
  KEY `date` (`date`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `onotes`
-- 

DROP TABLE IF EXISTS `onotes`;
CREATE TABLE `onotes` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `body` longtext,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `activity` tinyint(4) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_module_vars`
-- 

DROP TABLE IF EXISTS `openemr_module_vars`;
CREATE TABLE `openemr_module_vars` (
  `pn_id` int(11) unsigned NOT NULL auto_increment,
  `pn_modname` varchar(64) default NULL,
  `pn_name` varchar(64) default NULL,
  `pn_value` longtext,
  PRIMARY KEY  (`pn_id`),
  KEY `pn_modname` (`pn_modname`),
  KEY `pn_name` (`pn_name`)
) ENGINE=MyISAM AUTO_INCREMENT=235 ;

-- 
-- Dumping data for table `openemr_module_vars`
-- 

INSERT INTO `openemr_module_vars` VALUES (234, 'PostCalendar', 'pcNotifyEmail', '');
INSERT INTO `openemr_module_vars` VALUES (233, 'PostCalendar', 'pcNotifyAdmin', '0');
INSERT INTO `openemr_module_vars` VALUES (232, 'PostCalendar', 'pcCacheLifetime', '3600');
INSERT INTO `openemr_module_vars` VALUES (231, 'PostCalendar', 'pcUseCache', '0');
INSERT INTO `openemr_module_vars` VALUES (230, 'PostCalendar', 'pcDefaultView', 'day');
INSERT INTO `openemr_module_vars` VALUES (229, 'PostCalendar', 'pcTimeIncrement', '5');
INSERT INTO `openemr_module_vars` VALUES (228, 'PostCalendar', 'pcAllowUserCalendar', '1');
INSERT INTO `openemr_module_vars` VALUES (227, 'PostCalendar', 'pcAllowSiteWide', '1');
INSERT INTO `openemr_module_vars` VALUES (226, 'PostCalendar', 'pcTemplate', 'default');
INSERT INTO `openemr_module_vars` VALUES (225, 'PostCalendar', 'pcEventDateFormat', '%Y-%m-%d');
INSERT INTO `openemr_module_vars` VALUES (224, 'PostCalendar', 'pcDisplayTopics', '0');
INSERT INTO `openemr_module_vars` VALUES (223, 'PostCalendar', 'pcListHowManyEvents', '15');
INSERT INTO `openemr_module_vars` VALUES (222, 'PostCalendar', 'pcAllowDirectSubmit', '1');
INSERT INTO `openemr_module_vars` VALUES (221, 'PostCalendar', 'pcUsePopups', '0');
INSERT INTO `openemr_module_vars` VALUES (220, 'PostCalendar', 'pcDayHighlightColor', '#EEEEEE');
INSERT INTO `openemr_module_vars` VALUES (219, 'PostCalendar', 'pcFirstDayOfWeek', '1');
INSERT INTO `openemr_module_vars` VALUES (218, 'PostCalendar', 'pcUseInternationalDates', '0');
INSERT INTO `openemr_module_vars` VALUES (217, 'PostCalendar', 'pcEventsOpenInNewWindow', '0');
INSERT INTO `openemr_module_vars` VALUES (216, 'PostCalendar', 'pcTime24Hours', '0');

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_modules`
-- 

DROP TABLE IF EXISTS `openemr_modules`;
CREATE TABLE `openemr_modules` (
  `pn_id` int(11) unsigned NOT NULL auto_increment,
  `pn_name` varchar(64) default NULL,
  `pn_type` int(6) NOT NULL default '0',
  `pn_displayname` varchar(64) default NULL,
  `pn_description` varchar(255) default NULL,
  `pn_regid` int(11) unsigned NOT NULL default '0',
  `pn_directory` varchar(64) default NULL,
  `pn_version` varchar(10) default NULL,
  `pn_admin_capable` tinyint(1) NOT NULL default '0',
  `pn_user_capable` tinyint(1) NOT NULL default '0',
  `pn_state` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`pn_id`)
) ENGINE=MyISAM AUTO_INCREMENT=47 ;

-- 
-- Dumping data for table `openemr_modules`
-- 

INSERT INTO `openemr_modules` VALUES (46, 'PostCalendar', 2, 'PostCalendar', 'PostNuke Calendar Module', 0, 'PostCalendar', '4.0.0', 1, 1, 3);

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_postcalendar_categories`
-- 

DROP TABLE IF EXISTS `openemr_postcalendar_categories`;
CREATE TABLE `openemr_postcalendar_categories` (
  `pc_catid` int(11) unsigned NOT NULL auto_increment,
  `pc_catname` varchar(100) default NULL,
  `pc_catcolor` varchar(50) default NULL,
  `pc_catdesc` text,
  `pc_recurrtype` int(1) NOT NULL default '0',
  `pc_enddate` date default NULL,
  `pc_recurrspec` text,
  `pc_recurrfreq` int(3) NOT NULL default '0',
  `pc_duration` bigint(20) NOT NULL default '0',
  `pc_end_date_flag` tinyint(1) NOT NULL default '0',
  `pc_end_date_type` int(2) default NULL,
  `pc_end_date_freq` int(11) NOT NULL default '0',
  `pc_end_all_day` tinyint(1) NOT NULL default '0',
  `pc_dailylimit` int(2) NOT NULL default '0',
  PRIMARY KEY  (`pc_catid`),
  KEY `basic_cat` (`pc_catname`,`pc_catcolor`)
) ENGINE=MyISAM AUTO_INCREMENT=11 ;

-- 
-- Dumping data for table `openemr_postcalendar_categories`
-- 

INSERT INTO `openemr_postcalendar_categories` VALUES (5, 'Office Visit', '#FFFFCC', 'Normal Office Visit', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 900, 0, 0, 0, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (4, 'Vacation', '#EFEFEF', 'Reserved for use to define Scheduled Vacation Time', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 0, 0, 0, 0, 1, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (1, 'No Show', '#DDDDDD', 'Reserved to define when an event did not occur as specified.', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (2, 'In Office', '#99CCFF', 'Reserved todefine when a provider may haveavailable appointments after.', 1, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 0, 1, 3, 2, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (3, 'Out Of Office', '#99FFFF', 'Reserved to define when a provider may not have available appointments after.', 1, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 0, 1, 3, 2, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (8, 'Lunch', '#FFFF33', 'Lunch', 1, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 3600, 0, 3, 2, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (9, 'Established Patient', '#CCFF33', '', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 900, 0, 0, 0, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (10,'New Patient', '#CCFFFF', '', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 1800, 0, 0, 0, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (11,'Reserved','#FF7777','Reserved',1,NULL,'a:5:{s:17:\"event_repeat_freq\";s:1:\"1\";s:22:\"event_repeat_freq_type\";s:1:\"4\";s:19:\"event_repeat_on_num\";s:1:\"1\";s:19:\"event_repeat_on_day\";s:1:\"0\";s:20:\"event_repeat_on_freq\";s:1:\"0\";}',0,900,0,3,2,0,0);

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_postcalendar_events`
-- 

DROP TABLE IF EXISTS `openemr_postcalendar_events`;
CREATE TABLE `openemr_postcalendar_events` (
  `pc_eid` int(11) unsigned NOT NULL auto_increment,
  `pc_catid` int(11) NOT NULL default '0',
  `pc_multiple` int(10) unsigned NOT NULL,
  `pc_aid` varchar(30) default NULL,
  `pc_pid` varchar(11) default NULL,
  `pc_title` varchar(150) default NULL,
  `pc_time` datetime default NULL,
  `pc_hometext` text,
  `pc_comments` int(11) default '0',
  `pc_counter` mediumint(8) unsigned default '0',
  `pc_topic` int(3) NOT NULL default '1',
  `pc_informant` varchar(20) default NULL,
  `pc_eventDate` date NOT NULL default '0000-00-00',
  `pc_endDate` date NOT NULL default '0000-00-00',
  `pc_duration` bigint(20) NOT NULL default '0',
  `pc_recurrtype` int(1) NOT NULL default '0',
  `pc_recurrspec` text,
  `pc_recurrfreq` int(3) NOT NULL default '0',
  `pc_startTime` time default NULL,
  `pc_endTime` time default NULL,
  `pc_alldayevent` int(1) NOT NULL default '0',
  `pc_location` text,
  `pc_conttel` varchar(50) default NULL,
  `pc_contname` varchar(50) default NULL,
  `pc_contemail` varchar(255) default NULL,
  `pc_website` varchar(255) default NULL,
  `pc_fee` varchar(50) default NULL,
  `pc_eventstatus` int(11) NOT NULL default '0',
  `pc_sharing` int(11) NOT NULL default '0',
  `pc_language` varchar(30) default NULL,
  `pc_apptstatus` varchar(15) NOT NULL default '-',
  `pc_prefcatid` int(11) NOT NULL default '0',
  `pc_facility` smallint(6) NOT NULL default '0' COMMENT 'facility id for this event',
  `pc_sendalertsms` VARCHAR(3) NOT NULL DEFAULT 'NO',
  `pc_sendalertemail` VARCHAR( 3 ) NOT NULL DEFAULT 'NO',
  PRIMARY KEY  (`pc_eid`),
  KEY `basic_event` (`pc_catid`,`pc_aid`,`pc_eventDate`,`pc_endDate`,`pc_eventstatus`,`pc_sharing`,`pc_topic`)
) ENGINE=MyISAM AUTO_INCREMENT=7 ;

-- 
-- Dumping data for table `openemr_postcalendar_events`
-- 

INSERT INTO `openemr_postcalendar_events` VALUES (3, 2, 0, '1', '', 'In Office', '2005-03-03 12:22:31', ':text:', 0, 0, 0, '1', '2005-03-03', '2007-03-03', 0, 1, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, '09:00:00', '09:00:00', 0, 'a:6:{s:14:"event_location";N;s:13:"event_street1";N;s:13:"event_street2";N;s:10:"event_city";N;s:11:"event_state";N;s:12:"event_postal";N;}', '', '', '', '', '', 1, 1, '', '-', 0, 0, 'NO', 'NO');
INSERT INTO `openemr_postcalendar_events` VALUES (5, 3, 0, '1', '', 'Out Of Office', '2005-03-03 12:22:52', ':text:', 0, 0, 0, '1', '2005-03-03', '2007-03-03', 0, 1, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, '17:00:00', '17:00:00', 0, 'a:6:{s:14:"event_location";N;s:13:"event_street1";N;s:13:"event_street2";N;s:10:"event_city";N;s:11:"event_state";N;s:12:"event_postal";N;}', '', '', '', '', '', 1, 1, '', '-', 0, 0, 'NO', 'NO');
INSERT INTO `openemr_postcalendar_events` VALUES (6, 8, 0, '1', '', 'Lunch', '2005-03-03 12:23:31', ':text:', 0, 0, 0, '1', '2005-03-03', '2007-03-03', 3600, 1, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, '12:00:00', '13:00:00', 0, 'a:6:{s:14:"event_location";N;s:13:"event_street1";N;s:13:"event_street2";N;s:10:"event_city";N;s:11:"event_state";N;s:12:"event_postal";N;}', '', '', '', '', '', 1, 1, '', '-', 0, 0, 'NO', 'NO');

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_postcalendar_limits`
-- 

DROP TABLE IF EXISTS `openemr_postcalendar_limits`;
CREATE TABLE `openemr_postcalendar_limits` (
  `pc_limitid` int(11) NOT NULL auto_increment,
  `pc_catid` int(11) NOT NULL default '0',
  `pc_starttime` time NOT NULL default '00:00:00',
  `pc_endtime` time NOT NULL default '00:00:00',
  `pc_limit` int(11) NOT NULL default '1',
  PRIMARY KEY  (`pc_limitid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_postcalendar_topics`
-- 

DROP TABLE IF EXISTS `openemr_postcalendar_topics`;
CREATE TABLE `openemr_postcalendar_topics` (
  `pc_catid` int(11) unsigned NOT NULL auto_increment,
  `pc_catname` varchar(100) default NULL,
  `pc_catcolor` varchar(50) default NULL,
  `pc_catdesc` text,
  PRIMARY KEY  (`pc_catid`),
  KEY `basic_cat` (`pc_catname`,`pc_catcolor`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_session_info`
-- 

DROP TABLE IF EXISTS `openemr_session_info`;
CREATE TABLE `openemr_session_info` (
  `pn_sessid` varchar(32) NOT NULL default '',
  `pn_ipaddr` varchar(20) default NULL,
  `pn_firstused` int(11) NOT NULL default '0',
  `pn_lastused` int(11) NOT NULL default '0',
  `pn_uid` int(11) NOT NULL default '0',
  `pn_vars` blob,
  PRIMARY KEY  (`pn_sessid`)
) ENGINE=MyISAM;

-- 
-- Dumping data for table `openemr_session_info`
-- 

INSERT INTO `openemr_session_info` VALUES ('978d31441dccd350d406bfab98978f20', '127.0.0.1', 1109233952, 1109234177, 0, NULL);

-- --------------------------------------------------------

-- 
-- Table structure for table `patient_data`
-- 

DROP TABLE IF EXISTS `patient_data`;
CREATE TABLE `patient_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `language` varchar(255) NOT NULL default '',
  `financial` varchar(255) NOT NULL default '',
  `fname` varchar(255) NOT NULL default '',
  `lname` varchar(255) NOT NULL default '',
  `mname` varchar(255) NOT NULL default '',
  `DOB` date default NULL,
  `street` varchar(255) NOT NULL default '',
  `postal_code` varchar(255) NOT NULL default '',
  `city` varchar(255) NOT NULL default '',
  `state` varchar(255) NOT NULL default '',
  `country_code` varchar(255) NOT NULL default '',
  `drivers_license` varchar(255) NOT NULL default '',
  `ss` varchar(255) NOT NULL default '',
  `occupation` longtext,
  `phone_home` varchar(255) NOT NULL default '',
  `phone_biz` varchar(255) NOT NULL default '',
  `phone_contact` varchar(255) NOT NULL default '',
  `phone_cell` varchar(255) NOT NULL default '',
  `pharmacy_id` int(11) NOT NULL default '0',
  `status` varchar(255) NOT NULL default '',
  `contact_relationship` varchar(255) NOT NULL default '',
  `date` datetime default NULL,
  `sex` varchar(255) NOT NULL default '',
  `referrer` varchar(255) NOT NULL default '',
  `referrerID` varchar(255) NOT NULL default '',
  `providerID` int(11) default NULL,
  `email` varchar(255) NOT NULL default '',
  `ethnoracial` varchar(255) NOT NULL default '',
  `interpretter` varchar(255) NOT NULL default '',
  `migrantseasonal` varchar(255) NOT NULL default '',
  `family_size` varchar(255) NOT NULL default '',
  `monthly_income` varchar(255) NOT NULL default '',
  `homeless` varchar(255) NOT NULL default '',
  `financial_review` datetime default NULL,
  `pubpid` varchar(255) NOT NULL default '',
  `pid` bigint(20) NOT NULL default '0',
  `genericname1` varchar(255) NOT NULL default '',
  `genericval1` varchar(255) NOT NULL default '',
  `genericname2` varchar(255) NOT NULL default '',
  `genericval2` varchar(255) NOT NULL default '',
  `hipaa_mail` varchar(3) NOT NULL default '',
  `hipaa_voice` varchar(3) NOT NULL default '',
  `hipaa_notice` varchar(3) NOT NULL default '',
  `hipaa_message` varchar(20) NOT NULL default '',
  `hipaa_allowsms` VARCHAR(3) NOT NULL DEFAULT 'NO',
  `hipaa_allowemail` VARCHAR(3) NOT NULL DEFAULT 'NO',
  `squad` varchar(32) NOT NULL default '',
  `fitness` int(11) NOT NULL default '0',
  `referral_source` varchar(30) NOT NULL default '',
  `usertext1` varchar(255) NOT NULL DEFAULT '',
  `usertext2` varchar(255) NOT NULL DEFAULT '',
  `usertext3` varchar(255) NOT NULL DEFAULT '',
  `usertext4` varchar(255) NOT NULL DEFAULT '',
  `usertext5` varchar(255) NOT NULL DEFAULT '',
  `usertext6` varchar(255) NOT NULL DEFAULT '',
  `usertext7` varchar(255) NOT NULL DEFAULT '',
  `usertext8` varchar(255) NOT NULL DEFAULT '',
  `userlist1` varchar(255) NOT NULL DEFAULT '',
  `userlist2` varchar(255) NOT NULL DEFAULT '',
  `userlist3` varchar(255) NOT NULL DEFAULT '',
  `userlist4` varchar(255) NOT NULL DEFAULT '',
  `userlist5` varchar(255) NOT NULL DEFAULT '',
  `userlist6` varchar(255) NOT NULL DEFAULT '',
  `userlist7` varchar(255) NOT NULL DEFAULT '',
  `pricelevel` varchar(255) NOT NULL default 'standard',
  `regdate`     date DEFAULT NULL COMMENT 'Registration Date',
  `contrastart` date DEFAULT NULL COMMENT 'Date contraceptives initially used',
  `completed_ad` VARCHAR(3) NOT NULL DEFAULT 'NO',
  `ad_reviewed` date DEFAULT NULL,
  `vfc` varchar(255) NOT NULL DEFAULT '',
  `mothersname` varchar(255) NOT NULL DEFAULT '',
  `guardiansname` varchar(255) NOT NULL DEFAULT '',
  `allow_imm_reg_use` varchar(255) NOT NULL DEFAULT '',
  `allow_imm_info_share` varchar(255) NOT NULL DEFAULT '',
  `allow_health_info_ex` varchar(255) NOT NULL DEFAULT '',
  UNIQUE KEY `pid` (`pid`),
  KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `payments`
-- 

DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `id` bigint(20) NOT NULL auto_increment,
  `pid` bigint(20) NOT NULL default '0',
  `dtime` datetime NOT NULL,
  `encounter` bigint(20) NOT NULL default '0',
  `user` varchar(255) default NULL,
  `method` varchar(255) default NULL,
  `source` varchar(255) default NULL,
  `amount1` decimal(12,2) NOT NULL default '0.00',
  `amount2` decimal(12,2) NOT NULL default '0.00',
  `posted1` decimal(12,2) NOT NULL default '0.00',
  `posted2` decimal(12,2) NOT NULL default '0.00',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `pharmacies`
-- 

DROP TABLE IF EXISTS `pharmacies`;
CREATE TABLE `pharmacies` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `transmit_method` int(11) NOT NULL default '1',
  `email` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `phone_numbers`
-- 

DROP TABLE IF EXISTS `phone_numbers`;
CREATE TABLE `phone_numbers` (
  `id` int(11) NOT NULL default '0',
  `country_code` varchar(5) default NULL,
  `area_code` char(3) default NULL,
  `prefix` char(3) default NULL,
  `number` varchar(4) default NULL,
  `type` int(11) default NULL,
  `foreign_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `foreign_id` (`foreign_id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_bookmark`
-- 

DROP TABLE IF EXISTS `pma_bookmark`;
CREATE TABLE `pma_bookmark` (
  `id` int(11) NOT NULL auto_increment,
  `dbase` varchar(255) default NULL,
  `user` varchar(255) default NULL,
  `label` varchar(255) default NULL,
  `query` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM COMMENT='Bookmarks' AUTO_INCREMENT=10 ;

-- 
-- Dumping data for table `pma_bookmark`
-- 

INSERT INTO `pma_bookmark` VALUES (2, 'openemr', 'openemr', 'Aggregate Race Statistics', 'SELECT ethnoracial as "Race/Ethnicity", count(*) as Count FROM  `patient_data` WHERE 1 group by ethnoracial');
INSERT INTO `pma_bookmark` VALUES (9, 'openemr', 'openemr', 'Search by Code', 'SELECT  b.code, concat(pd.fname," ", pd.lname) as "Patient Name", concat(u.fname," ", u.lname) as "Provider Name", en.reason as "Encounter Desc.", en.date\r\nFROM billing as b\r\nLEFT JOIN users AS u ON b.user = u.id\r\nLEFT JOIN patient_data as pd on b.pid = pd.pid\r\nLEFT JOIN form_encounter as en on b.encounter = en.encounter and b.pid = en.pid\r\nWHERE 1 /* and b.code like ''%[VARIABLE]%'' */ ORDER BY b.code');
INSERT INTO `pma_bookmark` VALUES (8, 'openemr', 'openemr', 'Count No Shows By Provider since Interval ago', 'SELECT concat( u.fname,  " ", u.lname )  AS  "Provider Name", u.id AS  "Provider ID", count(  DISTINCT ev.pc_eid )  AS  "Number of No Shows"/* , concat(DATE_FORMAT(NOW(),''%Y-%m-%d''), '' and '',DATE_FORMAT(DATE_ADD(now(), INTERVAL [VARIABLE]),''%Y-%m-%d'') ) as "Between Dates" */ FROM  `openemr_postcalendar_events`  AS ev LEFT  JOIN users AS u ON ev.pc_aid = u.id WHERE ev.pc_catid =1/* and ( ev.pc_eventDate >= DATE_SUB(now(), INTERVAL [VARIABLE]) )  */\r\nGROUP  BY u.id;');
INSERT INTO `pma_bookmark` VALUES (6, 'openemr', 'openemr', 'Appointments By Race/Ethnicity from today plus interval', 'SELECT  count(pd.ethnoracial) as "Number of Appointments", pd.ethnoracial AS  "Race/Ethnicity" /* , concat(DATE_FORMAT(NOW(),''%Y-%m-%d''), '' and '',DATE_FORMAT(DATE_ADD(now(), INTERVAL [VARIABLE]),''%Y-%m-%d'') ) as "Between Dates" */ FROM openemr_postcalendar_events AS ev LEFT  JOIN   `patient_data`  AS pd ON  pd.pid = ev.pc_pid where ev.pc_eventstatus=1 and ev.pc_catid = 5 and ev.pc_eventDate >= now()  /* and ( ev.pc_eventDate <= DATE_ADD(now(), INTERVAL [VARIABLE]) )  */ group by pd.ethnoracial');

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_column_info`
-- 

DROP TABLE IF EXISTS `pma_column_info`;
CREATE TABLE `pma_column_info` (
  `id` int(5) unsigned NOT NULL auto_increment,
  `db_name` varchar(64) default NULL,
  `table_name` varchar(64) default NULL,
  `column_name` varchar(64) default NULL,
  `comment` varchar(255) default NULL,
  `mimetype` varchar(255) default NULL,
  `transformation` varchar(255) default NULL,
  `transformation_options` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`)
) ENGINE=MyISAM COMMENT='Column Information for phpMyAdmin' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_history`
-- 

DROP TABLE IF EXISTS `pma_history`;
CREATE TABLE `pma_history` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `username` varchar(64) default NULL,
  `db` varchar(64) default NULL,
  `table` varchar(64) default NULL,
  `timevalue` timestamp NOT NULL,
  `sqlquery` text,
  PRIMARY KEY  (`id`),
  KEY `username` (`username`,`db`,`table`,`timevalue`)
) ENGINE=MyISAM COMMENT='SQL history' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_pdf_pages`
-- 

DROP TABLE IF EXISTS `pma_pdf_pages`;
CREATE TABLE `pma_pdf_pages` (
  `db_name` varchar(64) default NULL,
  `page_nr` int(10) unsigned NOT NULL auto_increment,
  `page_descr` varchar(50) default NULL,
  PRIMARY KEY  (`page_nr`),
  KEY `db_name` (`db_name`)
) ENGINE=MyISAM COMMENT='PDF Relationpages for PMA' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_relation`
-- 

DROP TABLE IF EXISTS `pma_relation`;
CREATE TABLE `pma_relation` (
  `master_db` varchar(64) NOT NULL default '',
  `master_table` varchar(64) NOT NULL default '',
  `master_field` varchar(64) NOT NULL default '',
  `foreign_db` varchar(64) default NULL,
  `foreign_table` varchar(64) default NULL,
  `foreign_field` varchar(64) default NULL,
  PRIMARY KEY  (`master_db`,`master_table`,`master_field`),
  KEY `foreign_field` (`foreign_db`,`foreign_table`)
) ENGINE=MyISAM COMMENT='Relation table';

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_table_coords`
-- 

DROP TABLE IF EXISTS `pma_table_coords`;
CREATE TABLE `pma_table_coords` (
  `db_name` varchar(64) NOT NULL default '',
  `table_name` varchar(64) NOT NULL default '',
  `pdf_page_number` int(11) NOT NULL default '0',
  `x` float unsigned NOT NULL default '0',
  `y` float unsigned NOT NULL default '0',
  PRIMARY KEY  (`db_name`,`table_name`,`pdf_page_number`)
) ENGINE=MyISAM COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_table_info`
-- 

DROP TABLE IF EXISTS `pma_table_info`;
CREATE TABLE `pma_table_info` (
  `db_name` varchar(64) NOT NULL default '',
  `table_name` varchar(64) NOT NULL default '',
  `display_field` varchar(64) default NULL,
  PRIMARY KEY  (`db_name`,`table_name`)
) ENGINE=MyISAM COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

-- 
-- Table structure for table `pnotes`
-- 

DROP TABLE IF EXISTS `pnotes`;
CREATE TABLE `pnotes` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `body` longtext,
  `pid` bigint(20) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `activity` tinyint(4) default NULL,
  `authorized` tinyint(4) default NULL,
  `title` varchar(255) default NULL,
  `assigned_to` varchar(255) default NULL,
  `deleted` tinyint(4) default 0 COMMENT 'flag indicates note is deleted',
  `message_status` VARCHAR(20) NOT NULL DEFAULT 'New',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `prescriptions`
-- 

DROP TABLE IF EXISTS `prescriptions`;
CREATE TABLE `prescriptions` (
  `id` int(11) NOT NULL auto_increment,
  `patient_id` int(11) default NULL,
  `filled_by_id` int(11) default NULL,
  `pharmacy_id` int(11) default NULL,
  `date_added` date default NULL,
  `date_modified` date default NULL,
  `provider_id` int(11) default NULL,
  `start_date` date default NULL,
  `drug` varchar(150) default NULL,
  `drug_id` int(11) NOT NULL default '0',
  `form` int(3) default NULL,
  `dosage` varchar(100) default NULL,
  `quantity` varchar(31) default NULL,
  `size` float unsigned default NULL,
  `unit` int(11) default NULL,
  `route` int(11) default NULL,
  `interval` int(11) default NULL,
  `substitute` int(11) default NULL,
  `refills` int(11) default NULL,
  `per_refill` int(11) default NULL,
  `filled_date` date default NULL,
  `medication` int(11) default NULL,
  `note` text,
  `active` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `prices`
-- 

DROP TABLE IF EXISTS `prices`;
CREATE TABLE `prices` (
  `pr_id` varchar(11) NOT NULL default '',
  `pr_selector` varchar(255) NOT NULL default '' COMMENT 'template selector for drugs, empty for codes',
  `pr_level` varchar(31) NOT NULL default '',
  `pr_price` decimal(12,2) NOT NULL default '0.00' COMMENT 'price in local currency',
  PRIMARY KEY  (`pr_id`,`pr_selector`,`pr_level`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `registry`
-- 

DROP TABLE IF EXISTS `registry`;
CREATE TABLE `registry` (
  `name` varchar(255) default NULL,
  `state` tinyint(4) default NULL,
  `directory` varchar(255) default NULL,
  `id` bigint(20) NOT NULL auto_increment,
  `sql_run` tinyint(4) default NULL,
  `unpackaged` tinyint(4) default NULL,
  `date` datetime default NULL,
  `priority` int(11) default '0',
  `category` varchar(255) default NULL,
  `nickname` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 ;

-- 
-- Dumping data for table `registry`
-- 

INSERT INTO `registry` VALUES ('New Encounter Form', 1, 'newpatient', 1, 1, 1, '2003-09-14 15:16:45', 0, 'Administrative', '');
INSERT INTO `registry` VALUES ('Review of Systems Checks', 1, 'reviewofs', 9, 1, 1, '2003-09-14 15:16:45', 0, 'Clinical', '');
INSERT INTO `registry` VALUES ('Speech Dictation', 1, 'dictation', 10, 1, 1, '2003-09-14 15:16:45', 0, 'Clinical', '');
INSERT INTO `registry` VALUES ('SOAP', 1, 'soap', 11, 1, 1, '2005-03-03 00:16:35', 0, 'Clinical', '');
INSERT INTO `registry` VALUES ('Vitals', 1, 'vitals', 12, 1, 1, '2005-03-03 00:16:34', 0, 'Clinical', '');
INSERT INTO `registry` VALUES ('Review Of Systems', 1, 'ros', 13, 1, 1, '2005-03-03 00:16:30', 0, 'Clinical', '');
INSERT INTO `registry` VALUES ('Fee Sheet', 1, 'fee_sheet', 14, 1, 1, '2007-07-28 00:00:00', 0, 'Administrative', '');
INSERT INTO `registry` VALUES ('Misc Billing Options HCFA', 1, 'misc_billing_options', 15, 1, 1, '2007-07-28 00:00:00', 0, 'Administrative', '');
INSERT INTO `registry` VALUES ('Procedure Order', 1, 'procedure_order', 16, 1, 1, '2010-02-25 00:00:00', 0, 'Administrative', '');

-- --------------------------------------------------------

-- 
-- Table structure for table `sequences`
-- 

DROP TABLE IF EXISTS `sequences`;
CREATE TABLE `sequences` (
  `id` int(11) unsigned NOT NULL default '0'
) ENGINE=MyISAM;

-- 
-- Dumping data for table `sequences`
-- 

INSERT INTO `sequences` VALUES (1);

-- --------------------------------------------------------

-- 
-- Table structure for table `transactions`
-- 

DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id`                      bigint(20)   NOT NULL auto_increment,
  `date`                    datetime     default NULL,
  `title`                   varchar(255) NOT NULL DEFAULT '',
  `body`                    longtext     NOT NULL DEFAULT '',
  `pid`                     bigint(20)   default NULL,
  `user`                    varchar(255) NOT NULL DEFAULT '',
  `groupname`               varchar(255) NOT NULL DEFAULT '',
  `authorized`              tinyint(4)   default NULL,
  `refer_date`              date         DEFAULT NULL,
  `refer_from`              int(11)      NOT NULL DEFAULT 0,
  `refer_to`                int(11)      NOT NULL DEFAULT 0,
  `refer_diag`              varchar(255) NOT NULL DEFAULT '',
  `refer_risk_level`        varchar(255) NOT NULL DEFAULT '',
  `refer_vitals`            tinyint(1)   NOT NULL DEFAULT 0,
  `refer_external`          tinyint(1)   NOT NULL DEFAULT 0,
  `refer_related_code`      varchar(255) NOT NULL DEFAULT '',
  `refer_reply_date`        date         DEFAULT NULL,
  `reply_date`              date         DEFAULT NULL,
  `reply_from`              varchar(255) NOT NULL DEFAULT '',
  `reply_init_diag`         varchar(255) NOT NULL DEFAULT '',
  `reply_final_diag`        varchar(255) NOT NULL DEFAULT '',
  `reply_documents`         varchar(255) NOT NULL DEFAULT '',
  `reply_findings`          text         NOT NULL DEFAULT '',
  `reply_services`          text         NOT NULL DEFAULT '',
  `reply_recommend`         text         NOT NULL DEFAULT '',
  `reply_rx_refer`          text         NOT NULL DEFAULT '',
  `reply_related_code`      varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `users`
-- 

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL auto_increment,
  `username` varchar(255) default NULL,
  `password` longtext,
  `authorized` tinyint(4) default NULL,
  `info` longtext,
  `source` tinyint(4) default NULL,
  `fname` varchar(255) default NULL,
  `mname` varchar(255) default NULL,
  `lname` varchar(255) default NULL,
  `federaltaxid` varchar(255) default NULL,
  `federaldrugid` varchar(255) default NULL,
  `upin` varchar(255) default NULL,
  `facility` varchar(255) default NULL,
  `facility_id` int(11) NOT NULL default '0',
  `see_auth` int(11) NOT NULL default '1',
  `active` tinyint(1) NOT NULL default '1',
  `npi` varchar(15) default NULL,
  `title` varchar(30) default NULL,
  `specialty` varchar(255) default NULL,
  `billname` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `assistant` varchar(255) default NULL,
  `organization` varchar(255) default NULL,
  `valedictory` varchar(255) default NULL,
  `street` varchar(60) default NULL,
  `streetb` varchar(60) default NULL,
  `city` varchar(30) default NULL,
  `state` varchar(30) default NULL,
  `zip` varchar(20) default NULL,
  `street2` varchar(60) default NULL,
  `streetb2` varchar(60) default NULL,
  `city2` varchar(30) default NULL,
  `state2` varchar(30) default NULL,
  `zip2` varchar(20) default NULL,
  `phone` varchar(30) default NULL,
  `fax` varchar(30) default NULL,
  `phonew1` varchar(30) default NULL,
  `phonew2` varchar(30) default NULL,
  `phonecell` varchar(30) default NULL,
  `notes` text,
  `cal_ui` tinyint(4) NOT NULL default '1',
  `taxonomy` varchar(30) NOT NULL DEFAULT '207Q00000X',
  `ssi_relayhealth` varchar(64) NULL,
  `calendar` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 = appears in calendar',
  `abook_type` varchar(31) NOT NULL DEFAULT '',
  `pwd_expiration_date` date default NULL,
  `pwd_history1` longtext default NULL,
  `pwd_history2` longtext default NULL,
  `default_warehouse` varchar(31) NOT NULL DEFAULT '',
  `irnpool` varchar(31) NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `user_settings`
--

CREATE TABLE `user_settings` (
  `setting_user`  bigint(20)   NOT NULL DEFAULT 0,
  `setting_label` varchar(63)  NOT NULL,
  `setting_value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`setting_user`, `setting_label`)
) ENGINE=MyISAM;

--
-- Dumping data for table `user_settings`
--

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

-- --------------------------------------------------------

-- 
-- Table structure for table `x12_partners`
-- 

DROP TABLE IF EXISTS `x12_partners`;
CREATE TABLE `x12_partners` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `id_number` varchar(255) default NULL,
  `x12_sender_id` varchar(255) default NULL,
  `x12_receiver_id` varchar(255) default NULL,
  `x12_version` varchar(255) default NULL,
  `processing_format` enum('standard','medi-cal','cms','proxymed') default NULL,
  `x12_isa05` char(2)     NOT NULL DEFAULT 'ZZ',
  `x12_isa07` char(2)     NOT NULL DEFAULT 'ZZ',
  `x12_isa14` char(1)     NOT NULL DEFAULT '0',
  `x12_isa15` char(1)     NOT NULL DEFAULT 'P',
  `x12_gs02`  varchar(15) NOT NULL DEFAULT '',
  `x12_per06` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

------------------------------------------------------------------------------------- 
-- Table structure for table `automatic_notification`
-- 

DROP TABLE IF EXISTS `automatic_notification`;
CREATE TABLE `automatic_notification` (
  `notification_id` int(5) NOT NULL auto_increment,
  `sms_gateway_type` varchar(255) NOT NULL,
  `next_app_date` date NOT NULL,
  `next_app_time` varchar(10) NOT NULL,
  `provider_name` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `email_sender` varchar(100) NOT NULL,
  `email_subject` varchar(100) NOT NULL,
  `type` enum('SMS','Email') NOT NULL default 'SMS',
  `notification_sent_date` datetime NOT NULL,
  PRIMARY KEY  (`notification_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

-- 
-- Dumping data for table `automatic_notification`
-- 

INSERT INTO `automatic_notification` (`notification_id`, `sms_gateway_type`, `next_app_date`, `next_app_time`, `provider_name`, `message`, `email_sender`, `email_subject`, `type`, `notification_sent_date`) VALUES (1, 'CLICKATELL', '0000-00-00', ':', 'EMR GROUP 1 .. SMS', 'Welcome to EMR GROUP 1.. SMS', '', '', 'SMS', '0000-00-00 00:00:00'),
(2, '', '2007-10-02', '05:50', 'EMR GROUP', 'Welcome to EMR GROUP . Email', 'EMR Group', 'Welcome to EMR GROUP', 'Email', '2007-09-30 00:00:00');

-- --------------------------------------------------------

-- 
-- Table structure for table `notification_log`
-- 

DROP TABLE IF EXISTS `notification_log`;
CREATE TABLE `notification_log` (
  `iLogId` int(11) NOT NULL auto_increment,
  `pid` int(7) NOT NULL,
  `pc_eid` int(11) unsigned NULL,
  `sms_gateway_type` varchar(50) NOT NULL,
  `smsgateway_info` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `email_sender` varchar(255) NOT NULL,
  `email_subject` varchar(255) NOT NULL,
  `type` enum('SMS','Email') NOT NULL,
  `patient_info` text NOT NULL,
  `pc_eventDate` date NOT NULL,
  `pc_endDate` date NOT NULL,
  `pc_startTime` time NOT NULL,
  `pc_endTime` time NOT NULL,
  `dSentDateTime` datetime NOT NULL,
  PRIMARY KEY  (`iLogId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `notification_settings`
-- 

DROP TABLE IF EXISTS `notification_settings`;
CREATE TABLE `notification_settings` (
  `SettingsId` int(3) NOT NULL auto_increment,
  `Send_SMS_Before_Hours` int(3) NOT NULL,
  `Send_Email_Before_Hours` int(3) NOT NULL,
  `SMS_gateway_username` varchar(100) NOT NULL,
  `SMS_gateway_password` varchar(100) NOT NULL,
  `SMS_gateway_apikey` varchar(100) NOT NULL,
  `type` varchar(50) NOT NULL,
  PRIMARY KEY  (`SettingsId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

-- 
-- Dumping data for table `notification_settings`
-- 

INSERT INTO `notification_settings` (`SettingsId`, `Send_SMS_Before_Hours`, `Send_Email_Before_Hours`, `SMS_gateway_username`, `SMS_gateway_password`, `SMS_gateway_apikey`, `type`) VALUES (1, 150, 150, 'sms username', 'sms password', 'sms api key', 'SMS/Email Settings');

-- -------------------------------------------------------------------

CREATE TABLE chart_tracker (
  ct_pid            int(11)       NOT NULL,
  ct_when           datetime      NOT NULL,
  ct_userid         bigint(20)    NOT NULL DEFAULT 0,
  ct_location       varchar(31)   NOT NULL DEFAULT '',
  PRIMARY KEY (ct_pid, ct_when)
) ENGINE=MyISAM;

CREATE TABLE ar_session (
  session_id     int unsigned  NOT NULL AUTO_INCREMENT,
  payer_id       int(11)       NOT NULL            COMMENT '0=pt else references insurance_companies.id',
  user_id        int(11)       NOT NULL            COMMENT 'references users.id for session owner',
  closed         tinyint(1)    NOT NULL DEFAULT 0  COMMENT '0=no, 1=yes',
  reference      varchar(255)  NOT NULL DEFAULT '' COMMENT 'check or EOB number',
  check_date     date          DEFAULT NULL,
  deposit_date   date          DEFAULT NULL,
  pay_total      decimal(12,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (session_id),
  KEY user_closed (user_id, closed),
  KEY deposit_date (deposit_date)
) ENGINE=MyISAM;

CREATE TABLE ar_activity (
  pid            int(11)       NOT NULL,
  encounter      int(11)       NOT NULL,
  sequence_no    int unsigned  NOT NULL AUTO_INCREMENT,
  code           varchar(9)    NOT NULL            COMMENT 'empty means claim level',
  modifier       varchar(5)    NOT NULL DEFAULT '',
  payer_type     int           NOT NULL            COMMENT '0=pt, 1=ins1, 2=ins2, etc',
  post_time      datetime      NOT NULL,
  post_user      int(11)       NOT NULL            COMMENT 'references users.id',
  session_id     int unsigned  NOT NULL            COMMENT 'references ar_session.session_id',
  memo           varchar(255)  NOT NULL DEFAULT '' COMMENT 'adjustment reasons go here',
  pay_amount     decimal(12,2) NOT NULL DEFAULT 0  COMMENT 'either pay or adj will always be 0',
  adj_amount     decimal(12,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (pid, encounter, sequence_no),
  KEY session_id (session_id)
) ENGINE=MyISAM;

CREATE TABLE `users_facility` (
  `tablename` varchar(64) NOT NULL,
  `table_id` int(11) NOT NULL,
  `facility_id` int(11) NOT NULL,
  PRIMARY KEY (`tablename`,`table_id`,`facility_id`)
) ENGINE=InnoDB COMMENT='joins users or patient_data to facility table';

CREATE TABLE `lbf_data` (
  `form_id`     int(11)      NOT NULL AUTO_INCREMENT COMMENT 'references forms.form_id',
  `field_id`    varchar(31)  NOT NULL COMMENT 'references layout_options.field_id',
  `field_value` varchar(255) NOT NULL,
  PRIMARY KEY (`form_id`,`field_id`)
) ENGINE=MyISAM COMMENT='contains all data from layout-based forms';

CREATE TABLE gprelations (
  type1 int(2)     NOT NULL,
  id1   bigint(20) NOT NULL,
  type2 int(2)     NOT NULL,
  id2   bigint(20) NOT NULL,
  PRIMARY KEY (type1,id1,type2,id2),
  KEY key2  (type2,id2)
) ENGINE=MyISAM COMMENT='general purpose relations';

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

CREATE TABLE `globals` (
  `gl_name`             varchar(63)    NOT NULL,
  `gl_index`            int(11)        NOT NULL DEFAULT 0,
  `gl_value`            varchar(255)   NOT NULL DEFAULT '',
  PRIMARY KEY (`gl_name`, `gl_index`)
) ENGINE=MyISAM; 

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

INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('lists', 'code_types', 'Code Types', 1);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'disclosure_type','Disclosure Type', 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('disclosure_type', 'disclosure-treatment', 'Treatment', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('disclosure_type', 'disclosure-payment', 'Payment', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('disclosure_type', 'disclosure-healthcareoperations', 'Health Care Operations', 30, 0);

-- --------------------------------------------------------

-- 
-- Table structure for table `extended_log`
--

DROP TABLE IF EXISTS `extended_log`;
CREATE TABLE `extended_log` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `event` varchar(255) default NULL,
  `user` varchar(255) default NULL,
  `recipient` varchar(255) default NULL,
  `description` longtext,
  `patient_id` bigint(20) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `clinical_alerts`
--

DROP TABLE IF EXISTS `clinical_alerts`;
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
) ENGINE=MyISAM AUTO_INCREMENT=1;

-- --------------------------------------------------------

--
-- Table structure for table `patient_alerts`
--

DROP TABLE IF EXISTS `patient_alerts`;
CREATE TABLE `patient_alerts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `alert_id` bigint(20) NOT NULL COMMENT 'alert_id from clinical_alerts table',
  `pid` bigint(20) NOT NULL,
  `status` varchar(255) NOT NULL COMMENT 'Read, Done, New',
  `date_modified` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

-- --------------------------------------------------------

--
-- Table structure for table `health_plans`
--

DROP TABLE IF EXISTS `health_plans`;
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

-- --------------------------------------------------------

--
-- Table structure for table `health_plan_actions`
--

DROP TABLE IF EXISTS `health_plan_actions`;
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

-- --------------------------------------------------------

--
-- Table structure for table `patient_reminders`
--

DROP TABLE IF EXISTS `patient_reminders`;
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

-- --------------------------------------------------------

--
-- Table structure for table `health_plan_enrollment`
--

DROP TABLE IF EXISTS `health_plan_enrollment`;
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

-- --------------------------------------------------------
