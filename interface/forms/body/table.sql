-- phpMyAdmin SQL Dump
-- version 2.10.3
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 11, 2010 at 06:33 PM
-- Server version: 5.0.45
-- PHP Version: 5.2.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `openemr`
--

-- --------------------------------------------------------

--
-- Table structure for table `form_body`
--

CREATE TABLE `form_body` (
  `id` int(11) NOT NULL auto_increment,
  `code` varchar(128) NOT NULL,
  `x` int(20) NOT NULL,
  `y` int(20) NOT NULL,
  `notes` longtext,
  `patient_id` int(11) NOT NULL,
  `created_at` date NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;