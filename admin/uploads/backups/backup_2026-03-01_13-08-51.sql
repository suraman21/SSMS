-- WBWS Backup - 2026-03-01 13:08:51

DROP TABLE IF EXISTS `academic_records`;
CREATE TABLE `academic_records` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(10) unsigned NOT NULL,
  `class_id` int(10) unsigned NOT NULL,
  `subject_id` int(10) unsigned NOT NULL,
  `academic_year_id` int(10) unsigned DEFAULT NULL,
  `term_id` int(10) unsigned DEFAULT NULL,
  `assessment_id` int(10) unsigned DEFAULT NULL,
  `submission_id` int(10) unsigned DEFAULT NULL,
  `assessment_type` enum('test','midterm','final','assignment','participation','project') NOT NULL DEFAULT 'test',
  `score` decimal(5,2) DEFAULT NULL COMMENT 'Score out of max_score',
  `max_score` decimal(5,2) NOT NULL DEFAULT 100.00,
  `grade_letter` varchar(5) DEFAULT NULL COMMENT 'A, B, C, D, F',
  `remarks` text DEFAULT NULL,
  `recorded_by` int(10) unsigned DEFAULT NULL,
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `member_id` (`member_id`),
  KEY `class_id` (`class_id`),
  KEY `subject_id` (`subject_id`),
  KEY `academic_year_id` (`academic_year_id`),
  KEY `term_id` (`term_id`),
  KEY `assessment_id` (`assessment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `academic_terms`;
CREATE TABLE `academic_terms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `academic_year_id` int(10) unsigned NOT NULL,
  `term_name` varchar(50) NOT NULL COMMENT 'e.g., 1ኛ ሴሚስተር, 2ኛ ሴሚስተር',
  `term_number` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `academic_year_id` (`academic_year_id`),
  KEY `is_current` (`is_current`),
  CONSTRAINT `fk_term_year` FOREIGN KEY (`academic_year_id`) REFERENCES `academic_years` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `academic_terms` VALUES ('1', '1', '1ኛ ሴሚስተር', '1', NULL, NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `academic_terms` VALUES ('2', '1', '2ኛ ሴሚስተር', '2', NULL, NULL, '0', '2026-02-12 05:06:26');

DROP TABLE IF EXISTS `academic_years`;
CREATE TABLE `academic_years` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `year_name` varchar(50) NOT NULL COMMENT 'e.g., 2017 ዓ.ም.',
  `year_gc` varchar(20) DEFAULT NULL COMMENT 'Gregorian equivalent, e.g., 2024/2025',
  `ec_year` smallint(5) unsigned DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL DEFAULT 0,
  `status` enum('active','completed','upcoming') NOT NULL DEFAULT 'upcoming',
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `year_name` (`year_name`),
  KEY `is_current` (`is_current`),
  KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `academic_years` VALUES ('1', '2017 ዓ.ም.', '2024/2025', '18', NULL, NULL, '0', 'active', '1', '2026-02-12 05:06:26', '2026-02-28 10:36:24');

DROP TABLE IF EXISTS `activity_logs`;
CREATE TABLE `activity_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_created` (`created_at`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `activity_logs` VALUES ('1', '1', 'superadmin', 'Dashboard Access', 'Super Admin dashboard viewed', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-20 08:58:54');
INSERT INTO `activity_logs` VALUES ('2', '1', 'superadmin', 'Dashboard Access', 'Super Admin dashboard viewed', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-20 08:59:55');
INSERT INTO `activity_logs` VALUES ('3', '1', 'superadmin', 'Dashboard Access', 'Super Admin dashboard viewed', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-20 09:01:11');
INSERT INTO `activity_logs` VALUES ('4', '1', 'superadmin', 'Dashboard Access', 'Super Admin dashboard viewed', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-20 09:02:04');
INSERT INTO `activity_logs` VALUES ('5', '1', 'superadmin', 'Database Backup', 'Backup file created: backup_2026-01-20_12-02-04.sql', '198.145.121.235', NULL, '2026-01-20 09:02:04');
INSERT INTO `activity_logs` VALUES ('6', '1', 'superadmin', 'Dashboard Access', 'Super Admin dashboard viewed', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-20 09:15:58');
INSERT INTO `activity_logs` VALUES ('7', '1', 'superadmin', 'Backup Created', 'backup_2026-01-20_12-17-26.sql', '198.145.121.235', NULL, '2026-01-20 09:17:26');
INSERT INTO `activity_logs` VALUES ('8', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-11 19:27:22');
INSERT INTO `activity_logs` VALUES ('9', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 05:01:36');
INSERT INTO `activity_logs` VALUES ('10', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 05:06:09');
INSERT INTO `activity_logs` VALUES ('11', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 05:06:50');
INSERT INTO `activity_logs` VALUES ('12', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 05:59:20');
INSERT INTO `activity_logs` VALUES ('13', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 06:00:32');
INSERT INTO `activity_logs` VALUES ('14', '7', 't1', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 06:03:53');
INSERT INTO `activity_logs` VALUES ('15', '7', 't1', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 10:30:51');
INSERT INTO `activity_logs` VALUES ('16', '7', 't1', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 10:44:23');
INSERT INTO `activity_logs` VALUES ('17', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 11:09:58');
INSERT INTO `activity_logs` VALUES ('18', '7', 't1', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 11:12:07');
INSERT INTO `activity_logs` VALUES ('19', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 11:14:07');
INSERT INTO `activity_logs` VALUES ('20', '7', 't1', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 11:56:48');
INSERT INTO `activity_logs` VALUES ('21', '7', 't1', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-14 07:00:26');
INSERT INTO `activity_logs` VALUES ('22', '2', 'info', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-16 07:43:41');
INSERT INTO `activity_logs` VALUES ('23', '2', 'info', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-19 05:42:39');
INSERT INTO `activity_logs` VALUES ('24', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-21 06:56:10');
INSERT INTO `activity_logs` VALUES ('25', '7', 't1', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-21 06:56:46');
INSERT INTO `activity_logs` VALUES ('26', '2', 'info', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-21 06:57:25');
INSERT INTO `activity_logs` VALUES ('27', '2', 'info', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-21 07:12:06');
INSERT INTO `activity_logs` VALUES ('28', '3', 'edu', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-21 07:26:12');
INSERT INTO `activity_logs` VALUES ('29', '2', 'info', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-21 07:28:20');
INSERT INTO `activity_logs` VALUES ('30', '2', 'info', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-22 20:08:59');
INSERT INTO `activity_logs` VALUES ('31', '2', 'info', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-22 20:40:51');
INSERT INTO `activity_logs` VALUES ('32', '2', 'info', 'Login', 'Successful login', '91.236.230.83', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-22 20:57:43');
INSERT INTO `activity_logs` VALUES ('33', '2', 'info', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-22 21:27:16');
INSERT INTO `activity_logs` VALUES ('34', '2', 'info', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-23 03:33:09');
INSERT INTO `activity_logs` VALUES ('35', '2', 'info', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-23 04:34:28');
INSERT INTO `activity_logs` VALUES ('36', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-23 04:55:56');
INSERT INTO `activity_logs` VALUES ('37', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 10:03:38');
INSERT INTO `activity_logs` VALUES ('38', '7', 't1', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 10:04:06');
INSERT INTO `activity_logs` VALUES ('39', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 10:04:31');
INSERT INTO `activity_logs` VALUES ('40', '4', 'finance', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 10:04:48');
INSERT INTO `activity_logs` VALUES ('41', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 10:05:19');
INSERT INTO `activity_logs` VALUES ('42', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 10:06:34');
INSERT INTO `activity_logs` VALUES ('43', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 10:16:16');
INSERT INTO `activity_logs` VALUES ('44', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 10:17:38');
INSERT INTO `activity_logs` VALUES ('45', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 11:04:45');
INSERT INTO `activity_logs` VALUES ('46', '3', 'edu', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 17:32:44');
INSERT INTO `activity_logs` VALUES ('47', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-27 06:42:10');
INSERT INTO `activity_logs` VALUES ('48', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-27 06:55:07');
INSERT INTO `activity_logs` VALUES ('49', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-27 08:37:09');
INSERT INTO `activity_logs` VALUES ('50', '7', 't1', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-27 08:40:28');
INSERT INTO `activity_logs` VALUES ('51', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-27 08:54:19');
INSERT INTO `activity_logs` VALUES ('52', '8', 'a1', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-27 10:33:42');
INSERT INTO `activity_logs` VALUES ('53', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-27 10:35:38');
INSERT INTO `activity_logs` VALUES ('54', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-27 10:35:54');
INSERT INTO `activity_logs` VALUES ('55', '8', 'a1', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-27 10:36:51');
INSERT INTO `activity_logs` VALUES ('56', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-27 10:37:14');
INSERT INTO `activity_logs` VALUES ('57', '2', 'info', 'Login', 'Successful login', '196.189.145.48', 'Mozilla/5.0 (Linux; Android 11; TECNO KG7h Build/RP1A.200720.011; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/145.0.7632.79 Mobile Safari/537.36', '2026-02-27 11:25:25');
INSERT INTO `activity_logs` VALUES ('58', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-27 11:29:33');
INSERT INTO `activity_logs` VALUES ('59', '2', 'info', 'Mobile Login', 'WBWS Mobile App', '198.145.121.235', NULL, '2026-02-27 12:22:43');
INSERT INTO `activity_logs` VALUES ('60', '2', 'info', 'Mobile Login', 'WBWS Mobile App', '196.190.154.85', NULL, '2026-02-27 12:24:55');
INSERT INTO `activity_logs` VALUES ('61', '2', 'info', 'Mobile Login', 'WBWS Mobile App', '196.190.154.85', NULL, '2026-02-27 12:25:35');
INSERT INTO `activity_logs` VALUES ('62', '1', 'superadmin', 'Mobile Login', 'WBWS Mobile App', '196.190.154.85', NULL, '2026-02-27 12:28:00');
INSERT INTO `activity_logs` VALUES ('63', '2', 'info', 'Mobile Login', 'WBWS Mobile App', '196.189.144.99', NULL, '2026-02-27 12:32:41');
INSERT INTO `activity_logs` VALUES ('64', '4', 'finance', 'Mobile Login', 'WBWS Mobile App', '196.189.144.99', NULL, '2026-02-27 13:02:00');
INSERT INTO `activity_logs` VALUES ('65', '2', 'info', 'Mobile Login', 'WBWS Mobile App', '196.189.144.99', NULL, '2026-02-27 13:34:47');
INSERT INTO `activity_logs` VALUES ('66', '2', 'info', 'Mobile Login', 'WBWS Mobile App', '196.191.61.163', NULL, '2026-02-27 16:46:20');
INSERT INTO `activity_logs` VALUES ('67', '2', 'info', 'Login', 'Successful login', '196.191.61.163', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-02-27 17:05:06');
INSERT INTO `activity_logs` VALUES ('68', '2', 'info', 'Login', 'Successful login', '196.191.61.163', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-02-27 17:05:11');
INSERT INTO `activity_logs` VALUES ('69', '2', 'info', 'Login', 'Successful login', '196.190.62.111', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-02-28 02:21:30');
INSERT INTO `activity_logs` VALUES ('70', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 07:07:21');
INSERT INTO `activity_logs` VALUES ('71', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 07:12:56');
INSERT INTO `activity_logs` VALUES ('72', '4', 'finance', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 07:13:24');
INSERT INTO `activity_logs` VALUES ('73', '5', 'material', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 07:14:57');
INSERT INTO `activity_logs` VALUES ('74', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 07:16:38');
INSERT INTO `activity_logs` VALUES ('75', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 07:47:48');
INSERT INTO `activity_logs` VALUES ('76', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 07:48:58');
INSERT INTO `activity_logs` VALUES ('77', '6', 'schooladmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 07:54:13');
INSERT INTO `activity_logs` VALUES ('78', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 08:17:52');
INSERT INTO `activity_logs` VALUES ('79', '6', 'schooladmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 08:18:16');
INSERT INTO `activity_logs` VALUES ('80', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 08:25:35');
INSERT INTO `activity_logs` VALUES ('81', '6', 'schooladmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 08:26:22');
INSERT INTO `activity_logs` VALUES ('82', '6', 'schooladmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 09:00:19');
INSERT INTO `activity_logs` VALUES ('83', '6', 'schooladmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 09:01:23');
INSERT INTO `activity_logs` VALUES ('84', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 09:37:34');
INSERT INTO `activity_logs` VALUES ('85', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 09:37:51');
INSERT INTO `activity_logs` VALUES ('86', '6', 'schooladmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 09:38:14');
INSERT INTO `activity_logs` VALUES ('87', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 09:41:37');
INSERT INTO `activity_logs` VALUES ('88', '3', 'edu', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 10:25:20');
INSERT INTO `activity_logs` VALUES ('89', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 10:56:52');
INSERT INTO `activity_logs` VALUES ('90', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 11:34:05');
INSERT INTO `activity_logs` VALUES ('91', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 11:35:33');
INSERT INTO `activity_logs` VALUES ('92', '7', 't1', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 12:42:07');
INSERT INTO `activity_logs` VALUES ('93', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-28 12:42:50');
INSERT INTO `activity_logs` VALUES ('94', '1', 'superadmin', 'Login', 'Successful login', '34.201.93.237', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36; Manus-User/1.0', '2026-02-28 12:48:42');
INSERT INTO `activity_logs` VALUES ('95', '3', 'edu', 'Login', 'Successful login', '34.201.93.237', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36; Manus-User/1.0', '2026-02-28 12:50:53');
INSERT INTO `activity_logs` VALUES ('96', '2', 'info', 'Login', 'Successful login', '34.201.93.237', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36; Manus-User/1.0', '2026-02-28 12:51:43');
INSERT INTO `activity_logs` VALUES ('97', '4', 'finance', 'Login', 'Successful login', '34.201.93.237', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36; Manus-User/1.0', '2026-02-28 12:52:31');
INSERT INTO `activity_logs` VALUES ('98', '5', 'material', 'Login', 'Successful login', '34.201.93.237', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36; Manus-User/1.0', '2026-02-28 12:53:27');
INSERT INTO `activity_logs` VALUES ('99', '6', 'schooladmin', 'Login', 'Successful login', '34.201.93.237', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36; Manus-User/1.0', '2026-02-28 12:54:15');
INSERT INTO `activity_logs` VALUES ('100', '1', 'superadmin', 'Login', 'Successful login', '34.201.93.237', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36; Manus-User/1.0', '2026-02-28 13:21:01');
INSERT INTO `activity_logs` VALUES ('101', '3', 'edu', 'Login', 'Successful login', '34.201.93.237', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36; Manus-User/1.0', '2026-02-28 13:21:56');
INSERT INTO `activity_logs` VALUES ('102', '2', 'info', 'Login', 'Successful login', '34.201.93.237', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36; Manus-User/1.0', '2026-02-28 13:22:45');
INSERT INTO `activity_logs` VALUES ('103', '4', 'finance', 'Login', 'Successful login', '34.201.93.237', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36; Manus-User/1.0', '2026-02-28 13:23:36');
INSERT INTO `activity_logs` VALUES ('104', '5', 'material', 'Login', 'Successful login', '34.201.93.237', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36; Manus-User/1.0', '2026-02-28 13:24:23');
INSERT INTO `activity_logs` VALUES ('105', '6', 'schooladmin', 'Login', 'Successful login', '34.201.93.237', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36; Manus-User/1.0', '2026-02-28 13:25:15');
INSERT INTO `activity_logs` VALUES ('106', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-01 07:52:29');
INSERT INTO `activity_logs` VALUES ('107', '2', 'info', 'Login', 'Successful login', '198.145.121.151', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-01 08:04:18');
INSERT INTO `activity_logs` VALUES ('108', '3', 'edu', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-01 08:19:11');
INSERT INTO `activity_logs` VALUES ('109', '1', 'superadmin', 'Login', 'Successful login', '91.236.230.83', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-01 08:48:51');
INSERT INTO `activity_logs` VALUES ('110', '2', 'info', 'Login', 'Successful login', '196.190.62.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-01 09:35:35');
INSERT INTO `activity_logs` VALUES ('111', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-01 09:35:49');
INSERT INTO `activity_logs` VALUES ('112', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-01 09:37:48');
INSERT INTO `activity_logs` VALUES ('113', '2', 'info', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-01 09:39:57');
INSERT INTO `activity_logs` VALUES ('114', '1', 'superadmin', 'Login', 'Successful login', '91.236.230.83', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-01 10:02:59');
INSERT INTO `activity_logs` VALUES ('115', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-01 10:03:56');
INSERT INTO `activity_logs` VALUES ('116', '1', 'superadmin', 'Login', 'Successful login', '198.145.121.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-01 10:07:06');

DROP TABLE IF EXISTS `assessments`;
CREATE TABLE `assessments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_id` int(10) unsigned NOT NULL,
  `subject_id` int(10) unsigned NOT NULL,
  `academic_year_id` int(10) unsigned NOT NULL,
  `term_id` int(10) unsigned DEFAULT NULL,
  `assessment_name` varchar(100) NOT NULL COMMENT 'e.g., Quiz 1, Midterm, Final Exam',
  `assessment_type` enum('test','quiz','midterm','final','assignment','project','participation','other') NOT NULL DEFAULT 'test',
  `weight_percentage` decimal(5,2) NOT NULL COMMENT 'Weight in total grade, e.g., 10.00 for 10%',
  `max_score` decimal(6,2) NOT NULL DEFAULT 100.00 COMMENT 'Maximum possible score',
  `description` text DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `assessment_order` tinyint(3) unsigned DEFAULT 1 COMMENT 'Display order',
  `is_published` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Whether grades are published to students',
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  KEY `subject_id` (`subject_id`),
  KEY `academic_year_id` (`academic_year_id`),
  KEY `term_id` (`term_id`),
  CONSTRAINT `fk_assess_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_assess_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_assess_term` FOREIGN KEY (`term_id`) REFERENCES `academic_terms` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_assess_year` FOREIGN KEY (`academic_year_id`) REFERENCES `academic_years` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `attendance`;
CREATE TABLE `attendance` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(10) unsigned NOT NULL,
  `class_id` int(10) unsigned DEFAULT NULL,
  `academic_year_id` int(10) unsigned DEFAULT NULL,
  `attendance_date` date NOT NULL,
  `status` enum('present','absent','late','excused','holiday') NOT NULL DEFAULT 'present',
  `check_in_time` time DEFAULT NULL,
  `check_out_time` time DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `recorded_by` int(10) unsigned DEFAULT NULL,
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_attendance` (`member_id`,`attendance_date`),
  KEY `attendance_date` (`attendance_date`),
  KEY `status` (`status`),
  KEY `class_id` (`class_id`),
  KEY `academic_year_id` (`academic_year_id`),
  CONSTRAINT `fk_att_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_att_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_att_year` FOREIGN KEY (`academic_year_id`) REFERENCES `academic_years` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `attendance_summary`;
CREATE TABLE `attendance_summary` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(10) unsigned NOT NULL,
  `academic_year_id` int(10) unsigned DEFAULT NULL,
  `month` tinyint(3) unsigned DEFAULT NULL COMMENT 'Ethiopian month 1-13',
  `year` smallint(5) unsigned DEFAULT NULL COMMENT 'Ethiopian year',
  `total_days` smallint(5) unsigned NOT NULL DEFAULT 0,
  `present_days` smallint(5) unsigned NOT NULL DEFAULT 0,
  `absent_days` smallint(5) unsigned NOT NULL DEFAULT 0,
  `late_days` smallint(5) unsigned NOT NULL DEFAULT 0,
  `excused_days` smallint(5) unsigned NOT NULL DEFAULT 0,
  `attendance_rate` decimal(5,2) DEFAULT NULL COMMENT 'Percentage',
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_summary` (`member_id`,`academic_year_id`,`month`,`year`),
  KEY `member_id` (`member_id`),
  KEY `academic_year_id` (`academic_year_id`),
  CONSTRAINT `fk_as_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_as_year` FOREIGN KEY (`academic_year_id`) REFERENCES `academic_years` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `cache_storage`;
CREATE TABLE `cache_storage` (
  `cache_key` varchar(100) NOT NULL,
  `cache_value` longtext DEFAULT NULL,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`cache_key`),
  KEY `expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `class_enrollments`;
CREATE TABLE `class_enrollments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(10) unsigned NOT NULL,
  `class_id` int(10) unsigned NOT NULL,
  `academic_year_id` int(10) unsigned NOT NULL,
  `enrolled_at` date NOT NULL,
  `status` enum('active','completed','dropped','transferred') NOT NULL DEFAULT 'active',
  `promoted_from` int(10) unsigned DEFAULT NULL COMMENT 'Previous class ID if promoted',
  `notes` text DEFAULT NULL,
  `enrolled_by` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_enrollment` (`member_id`,`class_id`,`academic_year_id`),
  KEY `member_id` (`member_id`),
  KEY `class_id` (`class_id`),
  KEY `academic_year_id` (`academic_year_id`),
  KEY `status` (`status`),
  CONSTRAINT `fk_enroll_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_enroll_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_enroll_year` FOREIGN KEY (`academic_year_id`) REFERENCES `academic_years` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `class_subjects`;
CREATE TABLE `class_subjects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_id` int(10) unsigned NOT NULL,
  `subject_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_class_subject` (`class_id`,`subject_id`),
  KEY `class_id` (`class_id`),
  KEY `subject_id` (`subject_id`),
  CONSTRAINT `fk_cs_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cs_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=393 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `class_subjects` VALUES ('1', '1', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('2', '1', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('3', '1', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('4', '1', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('5', '1', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('6', '1', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('7', '1', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('8', '2', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('9', '2', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('10', '2', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('11', '2', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('12', '2', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('13', '2', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('14', '2', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('15', '3', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('16', '3', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('17', '3', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('18', '3', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('19', '3', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('20', '3', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('21', '3', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('22', '4', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('23', '4', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('24', '4', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('25', '4', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('26', '4', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('27', '4', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('28', '4', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('29', '5', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('30', '5', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('31', '5', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('32', '5', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('33', '5', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('34', '5', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('35', '5', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('36', '6', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('37', '6', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('38', '6', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('39', '6', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('40', '6', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('41', '6', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('42', '6', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('43', '7', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('44', '7', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('45', '7', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('46', '7', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('47', '7', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('48', '7', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('49', '7', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('50', '8', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('51', '8', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('52', '8', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('53', '8', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('54', '8', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('55', '8', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('56', '8', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('57', '9', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('58', '9', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('59', '9', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('60', '9', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('61', '9', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('62', '9', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('63', '9', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('64', '10', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('65', '10', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('66', '10', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('67', '10', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('68', '10', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('69', '10', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('70', '10', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('71', '11', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('72', '11', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('73', '11', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('74', '11', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('75', '11', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('76', '11', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('77', '11', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('78', '12', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('79', '12', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('80', '12', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('81', '12', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('82', '12', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('83', '12', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('84', '12', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('85', '13', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('86', '13', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('87', '13', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('88', '13', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('89', '13', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('90', '13', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('91', '13', '7', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('92', '14', '1', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('93', '14', '2', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('94', '14', '3', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('95', '14', '4', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('96', '14', '5', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('97', '14', '6', '2026-02-12 05:59:33');
INSERT INTO `class_subjects` VALUES ('98', '14', '7', '2026-02-12 05:59:33');

DROP TABLE IF EXISTS `classes`;
CREATE TABLE `classes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(100) NOT NULL COMMENT 'e.g., 1ኛ ክፍል, 2ኛ ክፍል',
  `class_name_en` varchar(100) DEFAULT NULL COMMENT 'e.g., Grade 1, Grade 2',
  `class_code` varchar(20) NOT NULL COMMENT 'e.g., grade_1, grade_2',
  `level_order` tinyint(3) unsigned NOT NULL COMMENT 'Ordering: 1, 2, 3...',
  `section` varchar(50) DEFAULT NULL COMMENT 'Which section this belongs to',
  `age_group` enum('under6','7_13','14_17','18_plus') DEFAULT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `class_code` (`class_code`),
  KEY `level_order` (`level_order`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `classes` VALUES ('1', '1ኛ ክፍል', 'Grade 1', 'grade_1', '1', 'ህጻናት', '7_13', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('2', '2ኛ ክፍል', 'Grade 2', 'grade_2', '2', 'ህጻናት', '7_13', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('3', '3ኛ ክፍል', 'Grade 3', 'grade_3', '3', 'ህጻናት', '7_13', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('4', '4ኛ ክፍል', 'Grade 4', 'grade_4', '4', 'ህጻናት', '7_13', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('5', '5ኛ ክፍል', 'Grade 5', 'grade_5', '5', 'ማዕከላዊያን', '14_17', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('6', '6ኛ ክፍል', 'Grade 6', 'grade_6', '6', 'ማዕከላዊያን', '14_17', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('7', '7ኛ ክፍል', 'Grade 7', 'grade_7', '7', 'ማዕከላዊያን', '14_17', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('8', '8ኛ ክፍል', 'Grade 8', 'grade_8', '8', 'ወጣቶች', '18_plus', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('9', '9ኛ ክፍል', 'Grade 9', 'grade_9', '9', 'ወጣቶች', '18_plus', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('10', '10ኛ ክፍል', 'Grade 10', 'grade_10', '10', 'ወጣቶች', '18_plus', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('11', '11ኛ ክፍል', 'Grade 11', 'grade_11', '11', 'ወጣቶች', '18_plus', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('12', '12ኛ ክፍል', 'Grade 12', 'grade_12', '12', 'ወጣቶች', '18_plus', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('13', 'ዲፕሎማ', 'Diploma', 'diploma', '13', 'ወጣቶች', '18_plus', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `classes` VALUES ('14', 'ዲግሪ', 'Degree', 'degree', '14', 'ወጣቶች', '18_plus', NULL, '1', '2026-02-12 05:06:26');

DROP TABLE IF EXISTS `department_tasks`;
CREATE TABLE `department_tasks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `task_type` varchar(50) DEFAULT NULL COMMENT 'approval, review, action, info',
  `priority` enum('low','normal','high','urgent') NOT NULL DEFAULT 'normal',
  `status` enum('pending','in_progress','completed','cancelled') NOT NULL DEFAULT 'pending',
  `from_dept` varchar(50) NOT NULL COMMENT 'Originating department',
  `from_user_id` int(10) unsigned DEFAULT NULL,
  `to_dept` varchar(50) DEFAULT NULL COMMENT 'Target department',
  `to_user_id` int(10) unsigned DEFAULT NULL COMMENT 'Specific assignee',
  `related_member_id` int(10) unsigned DEFAULT NULL COMMENT 'If task is about a member',
  `related_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Additional context' CHECK (json_valid(`related_data`)),
  `due_date` date DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `completed_by` int(10) unsigned DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `from_dept` (`from_dept`),
  KEY `to_dept` (`to_dept`),
  KEY `to_user_id` (`to_user_id`),
  KEY `related_member_id` (`related_member_id`),
  KEY `due_date` (`due_date`),
  CONSTRAINT `fk_task_member` FOREIGN KEY (`related_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `dept_settings`;
CREATE TABLE `dept_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `dept_settings` VALUES ('1', 'dept_name_en', 'Information Department', '2', '2026-02-27 10:10:47');
INSERT INTO `dept_settings` VALUES ('2', 'dept_name_am', 'መረጃ ክፍል', '2', '2026-02-27 10:10:47');
INSERT INTO `dept_settings` VALUES ('3', 'church_name_en', 'Wulde Birhan Sunday School', '2', '2026-02-27 10:10:47');
INSERT INTO `dept_settings` VALUES ('4', 'church_name_am', 'ውሉደ ብርሃን የሰንበት ት/ቤት', '2', '2026-02-27 10:10:47');
INSERT INTO `dept_settings` VALUES ('5', 'dept_description', 'Manages member registration, ID cards, and member information.', '2', '2026-02-27 10:10:47');
INSERT INTO `dept_settings` VALUES ('6', 'calendar_mode', 'ethiopian', NULL, '2026-02-28 10:56:31');

DROP TABLE IF EXISTS `finance_budgets`;
CREATE TABLE `finance_budgets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
  `ec_year` smallint(5) unsigned NOT NULL,
  `budgeted_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `description` varchar(255) DEFAULT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_cat_year` (`category_id`,`ec_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `finance_categories`;
CREATE TABLE `finance_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` enum('income','expense') NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `finance_categories` VALUES ('1', 'Monthly Contribution', 'income', 'Regular monthly member fees', '1', '2026-02-28 07:12:30');
INSERT INTO `finance_categories` VALUES ('2', 'Special Offering', 'income', 'Special event contributions', '1', '2026-02-28 07:12:30');
INSERT INTO `finance_categories` VALUES ('3', 'Donation', 'income', 'General donations', '1', '2026-02-28 07:12:30');
INSERT INTO `finance_categories` VALUES ('4', 'Event Income', 'income', 'Income from events/activities', '1', '2026-02-28 07:12:30');
INSERT INTO `finance_categories` VALUES ('5', 'Teaching Materials', 'expense', 'Books, supplies for teaching', '1', '2026-02-28 07:12:30');
INSERT INTO `finance_categories` VALUES ('6', 'Office Supplies', 'expense', 'Administrative supplies', '1', '2026-02-28 07:12:30');
INSERT INTO `finance_categories` VALUES ('7', 'Maintenance', 'expense', 'Building/facility maintenance', '1', '2026-02-28 07:12:30');
INSERT INTO `finance_categories` VALUES ('8', 'Events & Programs', 'expense', 'Event organization costs', '1', '2026-02-28 07:12:30');
INSERT INTO `finance_categories` VALUES ('9', 'Transport', 'expense', 'Transportation costs', '1', '2026-02-28 07:12:30');
INSERT INTO `finance_categories` VALUES ('10', 'Utility', 'expense', 'Electric, water, etc.', '1', '2026-02-28 07:12:30');
INSERT INTO `finance_categories` VALUES ('11', 'Other Income', 'income', 'Miscellaneous income', '1', '2026-02-28 07:12:30');
INSERT INTO `finance_categories` VALUES ('12', 'Other Expense', 'expense', 'Miscellaneous expenses', '1', '2026-02-28 07:12:30');

DROP TABLE IF EXISTS `finance_member_fees`;
CREATE TABLE `finance_member_fees` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(10) unsigned NOT NULL,
  `fee_type` varchar(100) NOT NULL DEFAULT 'monthly',
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `ec_month` tinyint(3) unsigned DEFAULT NULL,
  `ec_year` smallint(5) unsigned DEFAULT NULL,
  `paid_date` date DEFAULT NULL,
  `status` enum('paid','unpaid','partial') DEFAULT 'unpaid',
  `recorded_by` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_member` (`member_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `finance_transactions`;
CREATE TABLE `finance_transactions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('income','expense') NOT NULL,
  `category_id` int(10) unsigned DEFAULT NULL,
  `member_id` int(10) unsigned DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `description` varchar(500) DEFAULT NULL,
  `receipt_number` varchar(50) DEFAULT NULL,
  `payment_method` enum('cash','bank_transfer','mobile_money','check','other') DEFAULT 'cash',
  `transaction_date` date NOT NULL,
  `ec_month` tinyint(3) unsigned DEFAULT NULL,
  `ec_year` smallint(5) unsigned DEFAULT NULL,
  `recorded_by` int(10) unsigned DEFAULT NULL,
  `status` enum('confirmed','pending','cancelled') DEFAULT 'confirmed',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_type` (`type`),
  KEY `idx_date` (`transaction_date`),
  KEY `idx_member` (`member_id`),
  KEY `idx_category` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `grade_submissions`;
CREATE TABLE `grade_submissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `teacher_id` int(10) unsigned NOT NULL,
  `class_id` int(10) unsigned NOT NULL,
  `subject_id` int(10) unsigned NOT NULL,
  `academic_year_id` int(10) unsigned DEFAULT NULL,
  `term_id` int(10) unsigned DEFAULT NULL,
  `assessment_id` int(10) unsigned DEFAULT NULL,
  `submission_type` enum('marklist','attendance','report') NOT NULL DEFAULT 'marklist',
  `status` enum('draft','submitted','approved','rejected','revision_needed') NOT NULL DEFAULT 'draft',
  `student_count` int(10) unsigned DEFAULT 0,
  `average_score` decimal(5,2) DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `reviewed_by` int(10) unsigned DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `review_notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `teacher_id` (`teacher_id`),
  KEY `class_id` (`class_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `material_categories`;
CREATE TABLE `material_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `material_categories` VALUES ('1', 'Church Items', 'Holy items, crosses, books', '1', '2026-02-28 07:12:30');
INSERT INTO `material_categories` VALUES ('2', 'Educational Materials', 'Textbooks, notebooks, teaching aids', '1', '2026-02-28 07:12:30');
INSERT INTO `material_categories` VALUES ('3', 'Office Supplies', 'Pens, paper, printer supplies', '1', '2026-02-28 07:12:30');
INSERT INTO `material_categories` VALUES ('4', 'Furniture', 'Tables, chairs, desks', '1', '2026-02-28 07:12:30');
INSERT INTO `material_categories` VALUES ('5', 'Equipment', 'Projectors, speakers, computers', '1', '2026-02-28 07:12:30');
INSERT INTO `material_categories` VALUES ('6', 'Cleaning Supplies', 'Cleaning materials and tools', '1', '2026-02-28 07:12:30');
INSERT INTO `material_categories` VALUES ('7', 'Kitchen Items', 'Cups, plates, cooking supplies', '1', '2026-02-28 07:12:30');

DROP TABLE IF EXISTS `material_items`;
CREATE TABLE `material_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `category_id` int(10) unsigned DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `quantity` int(11) DEFAULT 0,
  `min_quantity` int(11) DEFAULT 0,
  `unit` varchar(30) DEFAULT 'piece',
  `location` varchar(100) DEFAULT NULL,
  `condition_status` enum('good','fair','poor','damaged','disposed') DEFAULT 'good',
  `purchase_date` date DEFAULT NULL,
  `purchase_price` decimal(12,2) DEFAULT NULL,
  `status` enum('in_stock','low_stock','out_of_stock','maintenance') DEFAULT 'in_stock',
  `added_by` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `material_requests`;
CREATE TABLE `material_requests` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned DEFAULT NULL,
  `item_name` varchar(150) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `requested_by` varchar(100) NOT NULL,
  `department` varchar(100) DEFAULT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `status` enum('pending','approved','denied','fulfilled') DEFAULT 'pending',
  `approved_by` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `material_transactions`;
CREATE TABLE `material_transactions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned NOT NULL,
  `type` enum('incoming','outgoing','adjustment','disposal') NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `reason` varchar(255) DEFAULT NULL,
  `handled_by` varchar(100) DEFAULT NULL,
  `recorded_by` int(10) unsigned DEFAULT NULL,
  `transaction_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_item` (`item_id`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `member_changes`;
CREATE TABLE `member_changes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(10) unsigned NOT NULL,
  `change_type` varchar(50) NOT NULL COMMENT 'registered, updated, archived, role_changed, class_enrolled, promoted',
  `field_changed` varchar(100) DEFAULT NULL COMMENT 'Specific field that changed',
  `old_value` text DEFAULT NULL,
  `new_value` text DEFAULT NULL,
  `change_summary` varchar(255) DEFAULT NULL COMMENT 'Human readable summary',
  `changed_by_dept` varchar(50) DEFAULT NULL,
  `changed_by_user` int(10) unsigned DEFAULT NULL,
  `requires_sync` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Does this need other depts to be notified',
  `synced_to` varchar(255) DEFAULT NULL COMMENT 'Which depts have acknowledged',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `member_id` (`member_id`),
  KEY `change_type` (`change_type`),
  KEY `changed_by_dept` (`changed_by_dept`),
  KEY `requires_sync` (`requires_sync`),
  KEY `created_at` (`created_at`),
  CONSTRAINT `fk_mc_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `members`;
CREATE TABLE `members` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_code` varchar(30) DEFAULT NULL,
  `registration_type` enum('waiting','transfer','direct') NOT NULL DEFAULT 'waiting',
  `waiting_since` date DEFAULT NULL,
  `full_name_am` varchar(150) NOT NULL,
  `student_name` varchar(150) NOT NULL,
  `baptismal_name` varchar(150) DEFAULT NULL,
  `father_name` varchar(150) NOT NULL,
  `grandfather_name` varchar(150) DEFAULT NULL,
  `full_name_en` varchar(150) DEFAULT NULL,
  `gender` enum('male','female') NOT NULL DEFAULT 'male',
  `date_of_birth` date DEFAULT NULL,
  `dob_ec_day` tinyint(3) unsigned DEFAULT NULL,
  `dob_ec_month` tinyint(3) unsigned DEFAULT NULL,
  `dob_ec_year` smallint(5) unsigned DEFAULT NULL,
  `age` tinyint(3) unsigned DEFAULT NULL,
  `current_section` varchar(60) DEFAULT NULL,
  `education_level` varchar(60) DEFAULT NULL,
  `spiritual_education` varchar(100) DEFAULT NULL,
  `age_group` varchar(20) DEFAULT NULL,
  `member_type` enum('regular','special_regular','honorary') NOT NULL DEFAULT 'regular',
  `is_teacher` tinyint(1) NOT NULL DEFAULT 0,
  `is_staff` tinyint(1) NOT NULL DEFAULT 0,
  `is_committee` tinyint(1) NOT NULL DEFAULT 0,
  `is_volunteer` tinyint(1) NOT NULL DEFAULT 0,
  `is_dept_head_1` tinyint(1) NOT NULL DEFAULT 0,
  `is_dept_head_2` tinyint(1) NOT NULL DEFAULT 0,
  `is_dept_head_3` tinyint(1) NOT NULL DEFAULT 0,
  `is_dept_head_4` tinyint(1) NOT NULL DEFAULT 0,
  `is_dept_head_5` tinyint(1) NOT NULL DEFAULT 0,
  `is_dept_head_6` tinyint(1) NOT NULL DEFAULT 0,
  `is_dept_head_7` tinyint(1) NOT NULL DEFAULT 0,
  `is_dept_head_8` tinyint(1) NOT NULL DEFAULT 0,
  `status` enum('active','warning','inactive','archived') NOT NULL DEFAULT 'active',
  `archived_at` datetime DEFAULT NULL,
  `archived_by` varchar(100) DEFAULT NULL,
  `archive_reason` varchar(50) DEFAULT NULL,
  `archive_notes` text DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `restored_by` varchar(100) DEFAULT NULL,
  `phone_primary` varchar(30) DEFAULT NULL,
  `phone_number` varchar(30) DEFAULT NULL,
  `alt_phone_number` varchar(30) DEFAULT NULL,
  `phone_guardian` varchar(30) DEFAULT NULL,
  `guardian_name` varchar(150) DEFAULT NULL,
  `guardian_phone1` varchar(30) DEFAULT NULL,
  `guardian_phone2` varchar(30) DEFAULT NULL,
  `guardian_city` varchar(60) DEFAULT NULL,
  `guardian_sub_city` varchar(60) DEFAULT NULL,
  `guardian_woreda` varchar(10) DEFAULT NULL,
  `guardian_mender` varchar(10) DEFAULT NULL,
  `guardian_block_number` varchar(10) DEFAULT NULL,
  `guardian_house` varchar(10) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(60) DEFAULT NULL,
  `sub_city` varchar(60) DEFAULT NULL,
  `woreda` varchar(10) DEFAULT NULL,
  `mender` varchar(10) DEFAULT NULL,
  `block_number` varchar(10) DEFAULT NULL,
  `house_number` varchar(10) DEFAULT NULL,
  `work_profession` varchar(150) DEFAULT NULL,
  `registered_at` date NOT NULL DEFAULT curdate(),
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `student_photo_path` varchar(255) DEFAULT NULL,
  `guardian_photo_path` varchar(255) DEFAULT NULL,
  `doc_school_records_path` varchar(255) DEFAULT NULL,
  `doc_spiritual_path` varchar(255) DEFAULT NULL,
  `doc_signed_form_path` varchar(255) DEFAULT NULL,
  `signed_form_path` varchar(255) DEFAULT NULL,
  `id_card_status` enum('none','pending','generated') DEFAULT 'none',
  `id_card_generated_at` datetime DEFAULT NULL,
  `qr_code_path` varchar(255) DEFAULT NULL,
  `emergency_name` varchar(100) DEFAULT NULL,
  `emergency_phone` varchar(20) DEFAULT NULL,
  `christian_name` varchar(100) DEFAULT NULL,
  `current_class_id` int(10) unsigned DEFAULT NULL COMMENT 'Current enrolled class',
  `promoted_at` date DEFAULT NULL COMMENT 'Last promotion date',
  `spiritual_level_id` int(10) unsigned DEFAULT NULL COMMENT 'Current spiritual education level',
  `total_attendance_rate` decimal(5,2) DEFAULT NULL COMMENT 'Overall attendance percentage',
  `last_attendance_date` date DEFAULT NULL,
  `academic_status` enum('active','on_hold','graduated','dropped') DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_code` (`member_code`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `members` VALUES ('11', '0001', 'transfer', NULL, 'kidus buzayehu test', 'kidus', 'ሃይለ ገብርኤል', 'buzayehu', 'test', NULL, 'male', NULL, '4', '5', '2014', '4', 'አጸደ ህጻናት', 'elementary', 'grade_1', 'under6', 'regular', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'active', NULL, NULL, NULL, NULL, NULL, NULL, '0976559607', '0976559607', '', '0976559607', 'admin', '0976559607', '', 'addis_ababa', 'akaki_kality', '10', '3', NULL, NULL, NULL, 'addis_ababa', 'akaki_kality', '10', '3', '', '', 'developer, camera man', '2025-12-06', NULL, '2025-12-06 10:22:27', NULL, NULL, 'uploads/members/docs/doc_school_records_1765016547_7996.jpg', NULL, 'uploads/members/docs/doc_signed_form_1765016547_1613.jpg', NULL, 'generated', '2025-12-15 08:12:38', '/admin/id_cards/assets/qr/qr_0001.png', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active');
INSERT INTO `members` VALUES ('13', '0003', 'direct', NULL, 'ቅዱስ ብዙአየሁ', 'ቅዱስ', 'ሃይለ ገብርኤል', 'ብዙአየሁ', NULL, NULL, 'male', NULL, '5', '8', '1998', '20', 'ወጣቶች', 'high', NULL, '18_plus', 'honorary', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'active', NULL, NULL, NULL, NULL, NULL, NULL, '0976559607', '0976559607', NULL, '0913744965', 'እመበት ደምሴ', '0913744965', NULL, 'addis_ababa', 'akaki_kality', '10', NULL, NULL, NULL, NULL, 'addis_ababa', 'akaki_kality', '10', NULL, NULL, NULL, NULL, '2025-12-09', NULL, '2025-12-09 15:20:52', NULL, NULL, NULL, NULL, 'uploads/members/docs/doc_signed_form_1765293652_8160.png', NULL, 'generated', '2025-12-09 15:22:28', '/admin/id_cards/assets/qr/qr_0003.png', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active');
INSERT INTO `members` VALUES ('14', '0004', 'direct', NULL, 'kidus buzayehu bbbb', 'kidus', 'ሃይለ ገብርኤል', 'buzayehu', 'bbbb', NULL, 'male', NULL, '2', '3', '2000', '18', 'ወጣቶች', '', '', '18_plus', 'special_regular', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'active', NULL, NULL, NULL, NULL, '2025-12-27 21:09:49', 'info', '0909090909', '0909090909', '', '0913744965', 'Kidus Buzayhu', '0913744965', '', 'addis_ababa', 'kirkos', '2', '3', NULL, NULL, NULL, 'addis_ababa', 'kirkos', '2', '3', '', '', '', '2025-12-14', NULL, '2025-12-14 13:01:33', 'uploads/members/photos/student_photo_1772015553_2364.jpg', NULL, NULL, 'uploads/members/docs/doc_spiritual_1772015592_2247.jpg', 'uploads/members/docs/doc_signed_form_1771822479_1137.jpg', NULL, 'generated', '2026-01-20 11:51:29', '/admin/id_cards/assets/qr/qr_0004.png', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active');

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL COMMENT 'member_registered, teacher_assigned, grade_updated, etc.',
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Additional data like member_id, changes made' CHECK (json_valid(`data`)),
  `priority` enum('low','normal','high','urgent') NOT NULL DEFAULT 'normal',
  `source_dept` varchar(50) DEFAULT NULL COMMENT 'Department that triggered this',
  `source_user_id` int(10) unsigned DEFAULT NULL,
  `target_roles` varchar(255) DEFAULT NULL COMMENT 'Comma-separated roles: super_admin,school_admin,info_dept',
  `target_user_id` int(10) unsigned DEFAULT NULL COMMENT 'Specific user if not for roles',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `type` (`type`),
  KEY `target_roles` (`target_roles`),
  KEY `target_user_id` (`target_user_id`),
  KEY `is_read` (`is_read`),
  KEY `created_at` (`created_at`),
  KEY `source_user_id` (`source_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `shared_documents`;
CREATE TABLE `shared_documents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_type` varchar(50) DEFAULT NULL,
  `file_size` int(10) unsigned DEFAULT NULL COMMENT 'Size in bytes',
  `category` varchar(50) DEFAULT NULL COMMENT 'report, form, announcement, policy',
  `uploaded_by` int(10) unsigned DEFAULT NULL,
  `uploaded_dept` varchar(50) DEFAULT NULL,
  `visibility` enum('all','departments_only','specific') NOT NULL DEFAULT 'all',
  `visible_to` varchar(255) DEFAULT NULL COMMENT 'Comma-separated dept codes if specific',
  `download_count` int(10) unsigned NOT NULL DEFAULT 0,
  `is_pinned` tinyint(1) NOT NULL DEFAULT 0,
  `expires_at` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `category` (`category`),
  KEY `uploaded_dept` (`uploaded_dept`),
  KEY `visibility` (`visibility`),
  KEY `is_pinned` (`is_pinned`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `subjects`;
CREATE TABLE `subjects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subject_name` varchar(100) NOT NULL COMMENT 'e.g., መጽሐፍ ቅዱስ, ቅዳሴ',
  `subject_name_en` varchar(100) DEFAULT NULL,
  `subject_code` varchar(20) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `subject_code` (`subject_code`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `subjects` VALUES ('1', 'መጽሐፍ ቅዱስ', 'Holy Bible', 'bible', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `subjects` VALUES ('2', 'ቅዳሴ', 'Liturgy', 'liturgy', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `subjects` VALUES ('3', 'ታሪክ', 'Church History', 'history', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `subjects` VALUES ('4', 'ስነ ምግባር', 'Ethics', 'ethics', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `subjects` VALUES ('5', 'ዜማ', 'Church Music', 'music', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `subjects` VALUES ('6', 'ቋንቋ ግዕዝ', 'Geez Language', 'geez', NULL, '1', '2026-02-12 05:06:26');
INSERT INTO `subjects` VALUES ('7', 'ትርጓሜ', 'Interpretation', 'interpretation', NULL, '1', '2026-02-12 05:06:26');

DROP TABLE IF EXISTS `teacher_assignments`;
CREATE TABLE `teacher_assignments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `teacher_id` int(10) unsigned NOT NULL COMMENT 'Member ID who is teaching',
  `class_id` int(10) unsigned NOT NULL,
  `subject_id` int(10) unsigned DEFAULT NULL,
  `academic_year_id` int(10) unsigned DEFAULT NULL,
  `is_class_teacher` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Main teacher for this class',
  `is_primary` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `assigned_by` int(10) unsigned DEFAULT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `teacher_id` (`teacher_id`),
  KEY `class_id` (`class_id`),
  KEY `subject_id` (`subject_id`),
  KEY `academic_year_id` (`academic_year_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `teacher_assignments` VALUES ('3', '7', '1', '1', NULL, '0', '0', '1', 'active', '3', '2026-02-28 12:24:58');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `full_name` varchar(100) NOT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'info_dept',
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `member_id` int(10) unsigned DEFAULT NULL COMMENT 'Link to member if user is a teacher',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `member_id` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` VALUES ('1', 'superadmin', 'youremail@example.com', 'Main Super Admin', 'super_admin', '$2y$10$cPQVppQKGIpTLsGDxFF37OsslUw4LS05aIaF7NdyS5KtG2g2AFPr6', '1', '2026-02-27 12:28:00', '2025-12-04 09:52:01', NULL);
INSERT INTO `users` VALUES ('2', 'info', NULL, 'FikreSlase', 'info_dept', '$2y$10$uQrb9EQ3oIzNYGb6CDqgFuW1rFjfdniZly2GHTMYUVUK2ExTS/mW6', '1', '2026-02-27 16:46:20', '2025-12-05 07:19:30', NULL);
INSERT INTO `users` VALUES ('3', 'edu', NULL, 'Wesenu', 'edu_dept', '$2y$10$DTnU6g7pI7zxah.mCV71veVHab.Yb10.XZh1fh1dtr93ihKw2MYKy', '1', NULL, '2025-12-06 13:38:26', NULL);
INSERT INTO `users` VALUES ('4', 'finance', NULL, 'marta', 'finance_dept', '$2y$10$FjIaSezlsHbFQmqKfLciYewzN/3O96FR0dwKUUEZ4kp5QvQZaV0d6', '1', '2026-02-27 13:02:00', '2025-12-27 22:47:39', NULL);
INSERT INTO `users` VALUES ('5', 'material', NULL, 'mekdes', 'material_dept', '$2y$10$S4qxsOsSb1nxVLAM7FHRUe5O.0uAmR9CiOD9oYX4PYVzuynxKaujC', '1', NULL, '2025-12-27 22:50:40', NULL);
INSERT INTO `users` VALUES ('6', 'schooladmin', 'suraemu21@gmail.com', 'Barkachew Fikadu', 'school_admin', '$2y$10$oyDgCAeVECHDK0b.IA7xVOmvd.aRlvByqG4ffkRbYFnIuMghufAe2', '1', NULL, '2026-01-20 08:59:48', NULL);
INSERT INTO `users` VALUES ('7', 't1', NULL, 'kidus', 'teacher', '$2y$10$.mYZJuKWwJT1SxmpVLZuK.bbHgS50fkySam5Xf5//WMRs1ajC3Ywi', '1', NULL, '2026-02-12 06:02:42', '11');
INSERT INTO `users` VALUES ('8', 'a1', NULL, 'kidus buzayehu', 'attendance_taker', '$2y$10$.wmuWpAgjA5Cta9ksrAkTOI6GYD8pq9U3i5adohpIWZwQTm.8hiiC', '1', NULL, '2026-02-27 10:33:22', '11');

DROP TABLE IF EXISTS `wbws_audit_log`;
CREATE TABLE `wbws_audit_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `action` varchar(50) NOT NULL,
  `entity_type` varchar(50) NOT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_entity` (`entity_type`,`entity_id`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `wbws_audit_log` VALUES ('1', '2', 'info', 'update', '0', '2', '0', '198.145.121.151', '2026-02-23 03:33:30');
INSERT INTO `wbws_audit_log` VALUES ('2', '2', 'info', 'update', '0', '2', '0', '198.145.121.151', '2026-02-23 03:59:59');
INSERT INTO `wbws_audit_log` VALUES ('3', '2', 'info', 'update', '0', '1', '0', '198.145.121.151', '2026-02-23 04:03:29');
INSERT INTO `wbws_audit_log` VALUES ('4', '2', 'info', 'export_pdf', '0', '2', '0', '198.145.121.151', '2026-02-23 04:36:46');
INSERT INTO `wbws_audit_log` VALUES ('5', '2', 'info', 'update', '0', '2', '0', '198.145.121.151', '2026-02-23 04:47:39');
INSERT INTO `wbws_audit_log` VALUES ('6', '2', 'info', 'create', '0', '1', '0', '198.145.121.151', '2026-02-23 04:52:42');
INSERT INTO `wbws_audit_log` VALUES ('7', '2', 'info', 'export_pdf', '0', '2', '0', '198.145.121.151', '2026-02-23 04:53:01');
INSERT INTO `wbws_audit_log` VALUES ('8', '2', 'info', 'create', '0', '2', '0', '198.145.121.235', '2026-02-27 07:00:49');
INSERT INTO `wbws_audit_log` VALUES ('9', '2', 'info', 'export_pdf', '0', '2', '0', '198.145.121.235', '2026-02-27 07:01:05');

DROP TABLE IF EXISTS `wbws_group_leaders`;
CREATE TABLE `wbws_group_leaders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `leader_full_name` varchar(190) NOT NULL,
  `leader_full_name_en` varchar(200) DEFAULT NULL,
  `sex` enum('M','F') NOT NULL DEFAULT 'M',
  `phone` varchar(30) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `education_level` varchar(80) DEFAULT NULL,
  `responsibility` varchar(120) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `remark` varchar(200) DEFAULT NULL,
  `created_by` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `updated_by` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `fk_wbws_group_leaders_group` FOREIGN KEY (`group_id`) REFERENCES `wbws_groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `wbws_group_members`;
CREATE TABLE `wbws_group_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `full_name` varchar(200) NOT NULL,
  `full_name_en` varchar(200) DEFAULT NULL,
  `baptismal_name` varchar(100) DEFAULT NULL,
  `gender` enum('M','F') NOT NULL DEFAULT 'M',
  `phone` varchar(30) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `city` varchar(60) DEFAULT NULL,
  `sub_city` varchar(60) DEFAULT NULL,
  `woreda` varchar(20) DEFAULT NULL,
  `house_number` varchar(20) DEFAULT NULL,
  `education_level` varchar(80) DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `joined_date` date DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `photo_path` varchar(300) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_by` varchar(100) DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `membership_status` enum('active','inactive','suspended') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `wbws_group_members` VALUES ('1', '2', 'Limuel Fisseha', 'Limuel Fisseha', '', 'M', '0923490281', 'limuelfisseha@gmail.com', NULL, 'Addis Ababa', 'Addis Ababa', '', '', '', '', NULL, '', NULL, '1', 'info', NULL, '2026-02-23 04:52:42', 'active');
INSERT INTO `wbws_group_members` VALUES ('2', '2', 'Kidus Buzayhu', 'Kidus Buzayhu', 'ሃይለ ገብርኤል', 'M', '0976559607', 'suraemu21@gmail.com', NULL, 'Addis Ababa', 'Addis Abeba', '', '', '', '', NULL, '', NULL, '1', 'info', NULL, '2026-02-27 07:00:49', 'active');

DROP TABLE IF EXISTS `wbws_groups`;
CREATE TABLE `wbws_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(190) NOT NULL,
  `group_name_en` varchar(200) DEFAULT NULL,
  `established_year` varchar(20) DEFAULT NULL,
  `established_year_gc` varchar(20) DEFAULT NULL,
  `is_under_sunday_school` tinyint(1) NOT NULL DEFAULT 1,
  `founding_male` int(11) NOT NULL DEFAULT 0,
  `founding_female` int(11) NOT NULL DEFAULT 0,
  `current_male` int(11) NOT NULL DEFAULT 0,
  `current_female` int(11) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `notes` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_by` varchar(100) DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_name` (`group_name`),
  KEY `is_under_sunday_school` (`is_under_sunday_school`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `wbws_groups` VALUES ('1', 'mukera 3', '', '2014', '', '1', '9', '2', '22', '14', '', '', 'active', 'info', 'info', '2025-12-26 09:34:40', NULL);
INSERT INTO `wbws_groups` VALUES ('2', 'test group', 'jnnmnn', '2017', '', '0', '55', '21', '55', '33', '', '', 'active', 'info', 'info', '2025-12-26 09:54:58', NULL);

