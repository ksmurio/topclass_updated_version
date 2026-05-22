CREATE DATABASE  IF NOT EXISTS `topclass_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `topclass_db`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: topclass_db
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `battle_grades`
--

DROP TABLE IF EXISTS `battle_grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `battle_grades` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `battle_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_battle_user` (`battle_id`,`user_id`),
  KEY `fk_bg_user` (`user_id`),
  CONSTRAINT `fk_bg_battle` FOREIGN KEY (`battle_id`) REFERENCES `battles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bg_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battle_grades`
--

LOCK TABLES `battle_grades` WRITE;
/*!40000 ALTER TABLE `battle_grades` DISABLE KEYS */;
INSERT INTO `battle_grades` VALUES ('2623c24c-518c-4e71-9390-d0f5ca3822d2','aab8f550-0421-4166-b3f9-7aa51ad1e4c3','1fd00609-512c-4f7a-8586-b0e5c6dceea5','2026-05-21 12:06:23'),('58368116-8741-416b-a29d-73690652832a','531007df-2a62-49e9-9a59-bb1f11e0a4eb','1fd00609-512c-4f7a-8586-b0e5c6dceea5','2026-05-21 11:45:07');
/*!40000 ALTER TABLE `battle_grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battles`
--

DROP TABLE IF EXISTS `battles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `battles` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `club_id` char(36) NOT NULL,
  `creator_id` char(36) NOT NULL,
  `date` datetime NOT NULL,
  `status` enum('scheduled','ongoing','finished') DEFAULT 'scheduled',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_battles_club` (`club_id`),
  KEY `fk_battles_creator` (`creator_id`),
  CONSTRAINT `fk_battles_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_battles_creator` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battles`
--

LOCK TABLES `battles` WRITE;
/*!40000 ALTER TABLE `battles` DISABLE KEYS */;
INSERT INTO `battles` VALUES ('531007df-2a62-49e9-9a59-bb1f11e0a4eb','9ada2f64-9977-4f32-b223-70624423d137','1fd00609-512c-4f7a-8586-b0e5c6dceea5','2026-04-22 00:00:00','scheduled','2026-04-23 09:58:02','12:00:00'),('71293a43-19cd-4df5-b1aa-a8df8de926ac','7dba6b98-2bd8-469a-a888-eb6fab421fd3','1827537d-428a-4fbe-8298-5fede97479dd','2026-03-31 00:00:00','scheduled','2026-03-30 10:37:42','00:00:00'),('a8ce527f-331f-49cb-92b2-cb088c8eca66','aa5e0719-fad1-4bb8-b4c1-84557d566ce3','004730cd-6139-4019-821a-bbfba921fa68','2026-04-01 00:00:00','scheduled','2026-03-30 16:09:09','09:09:00'),('aab8f550-0421-4166-b3f9-7aa51ad1e4c3','9ada2f64-9977-4f32-b223-70624423d137','1fd00609-512c-4f7a-8586-b0e5c6dceea5','2026-05-20 00:00:00','scheduled','2026-05-21 12:06:19','15:08:00');
/*!40000 ALTER TABLE `battles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `club_comments`
--

DROP TABLE IF EXISTS `club_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `club_comments` (
  `id` char(36) NOT NULL,
  `post_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `club_comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `club_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `club_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `club_comments`
--

LOCK TABLES `club_comments` WRITE;
/*!40000 ALTER TABLE `club_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `club_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `club_posts`
--

DROP TABLE IF EXISTS `club_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `club_posts` (
  `id` char(36) NOT NULL,
  `club_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `club_posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `club_posts`
--

LOCK TABLES `club_posts` WRITE;
/*!40000 ALTER TABLE `club_posts` DISABLE KEYS */;
INSERT INTO `club_posts` VALUES ('798d91c7-73e0-4efd-ba42-5494d3fe6521','9ada2f64-9977-4f32-b223-70624423d137','1fd00609-512c-4f7a-8586-b0e5c6dceea5','ola\n','2026-05-21 10:05:29');
/*!40000 ALTER TABLE `club_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clubs`
--

DROP TABLE IF EXISTS `clubs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clubs` (
  `id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `club_type` enum('1','2','3','4','5','6','7','8','9','10','11','12','13') NOT NULL,
  `creator_id` char(36) NOT NULL,
  `club_uuid` char(36) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `is_private` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `club_image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `club_uuid` (`club_uuid`),
  KEY `creator_id` (`creator_id`),
  CONSTRAINT `clubs_ibfk_1` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clubs`
--

LOCK TABLES `clubs` WRITE;
/*!40000 ALTER TABLE `clubs` DISABLE KEYS */;
INSERT INTO `clubs` VALUES ('7dba6b98-2bd8-469a-a888-eb6fab421fd3','ingles','inglles is good','3','1827537d-428a-4fbe-8298-5fede97479dd','c6702896-4a88-492e-8335-bfdb250b7a24',NULL,0,'2026-03-30 09:57:57','1774864677313-841383500-2ad2ed77096ad9bca592cad7a80345b3.jpg'),('9ada2f64-9977-4f32-b223-70624423d137','firstMathClub','hello','2','1fd00609-512c-4f7a-8586-b0e5c6dceea5','cb653ccf-97e8-4148-9206-d2d1710e0b92','123123',1,'2026-04-23 09:57:40','1776938260919-644543262.png'),('aa5e0719-fad1-4bb8-b4c1-84557d566ce3','adasd','adasd','7','004730cd-6139-4019-821a-bbfba921fa68','14637cf5-b21d-4055-a79d-a9344a55e65e',NULL,0,'2026-02-27 16:52:43',NULL),('d029173b-cbfa-44a8-8e9f-721646cf87bc','a','a','1','28795797-4394-4911-88a8-913e7af145ee','f937a421-8f6b-4ece-bb05-31f2a7421020',NULL,0,'2026-01-27 20:48:07',NULL),('e78197a6-7665-452e-977e-89b07fa83af3','asdasdsa','adas','6','004730cd-6139-4019-821a-bbfba921fa68','c74b22e5-c199-491c-a75c-54f323bfdc92',NULL,0,'2026-03-26 10:26:58','1774520818025-640168532-02177054958926669d9f56ebaf8adc0cbe3483f4c0cffb8e52570_0.jpg');
/*!40000 ALTER TABLE `clubs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `missions`
--

DROP TABLE IF EXISTS `missions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `missions` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `creator_id` char(36) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `due_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_missions_creator` (`creator_id`),
  CONSTRAINT `fk_missions_creator` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `missions`
--

LOCK TABLES `missions` WRITE;
/*!40000 ALTER TABLE `missions` DISABLE KEYS */;
/*!40000 ALTER TABLE `missions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notes` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `user_id` char(36) DEFAULT NULL,
  `club_id` char(36) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `content` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_notes_user` (`user_id`),
  KEY `fk_notes_club` (`club_id`),
  CONSTRAINT `fk_notes_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_notes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subject_grades`
--

DROP TABLE IF EXISTS `subject_grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject_grades` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `user_id` char(36) DEFAULT NULL,
  `club_id` char(36) DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `grade` decimal(4,2) DEFAULT NULL,
  `graded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_subject_grades_user` (`user_id`),
  KEY `fk_subject_grades_club` (`club_id`),
  KEY `fk_subject_grades_subject` (`subject_id`),
  CONSTRAINT `fk_subject_grades_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_subject_grades_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_subject_grades_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject_grades`
--

LOCK TABLES `subject_grades` WRITE;
/*!40000 ALTER TABLE `subject_grades` DISABLE KEYS */;
INSERT INTO `subject_grades` VALUES ('15b7b163-f388-41d0-b318-7533a6f813ee','e47d2a4b-10ef-4a51-915b-debea572331e',NULL,11,3.00,'2026-03-30 08:26:44'),('174d0681-c271-401f-937a-a2468cbef389','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,37,3.00,'2026-04-23 09:54:14'),('1c5df9e9-0aec-4d0f-b361-5a673702eaba','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,33,2.00,'2026-04-23 09:58:57'),('294edb7b-ba6c-456c-a9c5-4bb753e834bf','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,38,3.00,'2026-05-21 12:04:31'),('2a68e9b4-52e9-445f-82ba-444f54fce037','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,30,5.00,'2026-04-23 09:53:52'),('3ae0d898-b203-4858-9624-8871293826af','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,32,3.00,'2026-05-21 11:59:37'),('491c25f3-98b2-41ab-b225-d95ab50443fa','1827537d-428a-4fbe-8298-5fede97479dd',NULL,3,5.00,'2026-03-30 10:04:51'),('4c787f7d-1a40-4629-b7c4-07b4a7c5cfd7','e47d2a4b-10ef-4a51-915b-debea572331e',NULL,2,4.00,'2026-03-30 08:26:21'),('5a04b797-b487-4fb0-ab16-9d3123dc3a2c','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,32,3.00,'2026-05-21 11:59:19'),('5da73d92-655c-412a-9e73-14662d32e169','004730cd-6139-4019-821a-bbfba921fa68',NULL,3,5.00,'2026-03-30 07:22:24'),('5f185dae-80fc-4682-9f02-2dd9e141a31a','1827537d-428a-4fbe-8298-5fede97479dd',NULL,2,5.00,'2026-03-30 10:34:05'),('77c2ea0b-fdb4-470f-a801-9fbf3cf847d5','8b98514d-92e9-4a88-b50b-1d1e27fbced0',NULL,2,3.00,'2026-04-23 11:01:39'),('799325ef-058b-45b5-8f86-8e7b127ffa4f','1827537d-428a-4fbe-8298-5fede97479dd',NULL,1,0.00,'2026-03-07 20:36:17'),('79dc342a-1c56-4a3c-9d4a-69f86112cc84','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,34,3.00,'2026-05-21 12:06:26'),('833d5474-63c2-4f48-b804-56a7b1d43ab6','004730cd-6139-4019-821a-bbfba921fa68',NULL,1,4.00,'2026-03-30 07:22:11'),('85ca4bfc-6d42-4094-a925-d755719de63a','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,34,3.00,'2026-04-23 09:54:06'),('97bf0f23-98f3-44d0-88ba-2d472551a344','1827537d-428a-4fbe-8298-5fede97479dd',NULL,2,5.00,'2026-03-07 20:36:05'),('999c46de-19b2-4c2a-943a-2f7a34449ad2','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,36,2.00,'2026-05-21 11:45:14'),('a8dcb979-a892-490c-b24b-559b9d01a64f','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,38,3.00,'2026-05-21 12:02:07'),('aca0cc28-e635-4d29-986f-d742be750808','e47d2a4b-10ef-4a51-915b-debea572331e',NULL,1,5.00,'2026-03-30 08:07:33'),('ae06114c-9dc1-4dcf-a276-cdec11efaeee','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,33,5.00,'2026-04-23 09:58:37'),('affa0aa1-05a4-4936-8e5a-950368335255','004730cd-6139-4019-821a-bbfba921fa68',NULL,2,5.00,'2026-04-01 16:36:15'),('b3c71f83-d030-4346-a315-d80447a6beef','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,31,5.00,'2026-04-23 09:53:43'),('b57c5bb4-1bb7-4661-bdf1-90f96749aca2','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,36,4.00,'2026-05-21 11:10:40'),('beea824a-ba4c-4ce4-b979-3446c4b56169','1827537d-428a-4fbe-8298-5fede97479dd',NULL,2,5.00,'2026-03-07 20:35:47'),('c4abcc2e-8ea3-4b62-bda1-caf539cb1fb7','004730cd-6139-4019-821a-bbfba921fa68',NULL,2,0.00,'2026-03-30 07:27:53'),('caa344c5-0d19-458c-b9d2-4cb0807c8e9a','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,36,2.00,'2026-05-21 11:57:32'),('d8d3abd6-5282-4a66-9016-2325933749b4','e47d2a4b-10ef-4a51-915b-debea572331e',NULL,6,5.00,'2026-03-30 08:26:14'),('e2fdca1a-22ac-4b21-8686-d44f694ac7d6','004730cd-6139-4019-821a-bbfba921fa68',NULL,1,3.00,'2026-03-30 07:21:50'),('ed61bf8f-74d9-487c-bc7d-4ad5dcb12c2a','004730cd-6139-4019-821a-bbfba921fa68',NULL,2,5.00,'2026-03-30 07:22:03'),('f6600333-69f8-4fbb-8998-7e86e16e8ae3','e47d2a4b-10ef-4a51-915b-debea572331e',NULL,9,2.00,'2026-03-30 08:26:32'),('f894a26e-e93e-46af-b5a6-686c6d8d6d4e','e47d2a4b-10ef-4a51-915b-debea572331e',NULL,2,3.00,'2026-03-30 08:26:06'),('fc47a5a0-5ba7-4f60-9d2d-41304a2d3e1c','8b98514d-92e9-4a88-b50b-1d1e27fbced0',NULL,2,2.00,'2026-04-23 10:55:10');
/*!40000 ALTER TABLE `subject_grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `year` tinyint unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES (1,'Português','9º ano',9),(2,'Matemática','9º ano',9),(3,'Inglês','9º ano',9),(4,'Francês','9º ano',9),(5,'História','9º ano',9),(6,'Geografia','9º ano',9),(7,'Ciências Naturais','9º ano',9),(8,'Físico-Química','9º ano',9),(9,'Educação Visual','9º ano',9),(10,'Educação Física','9º ano',9),(11,'TIC','9º ano',9),(12,'Português','10º ano',10),(13,'Inglês','10º ano',10),(14,'Educação Física','10º ano',10),(15,'Matemática A','10º ano',10),(16,'Física e Química A','10º ano',10),(17,'Biologia e Geologia','10º ano',10),(18,'História A','10º ano',10),(19,'Geografia A','10º ano',10),(20,'Economia A','10º ano',10),(21,'Português','11º ano',11),(22,'Inglês','11º ano',11),(23,'Educação Física','11º ano',11),(24,'Matemática A','11º ano',11),(25,'Física e Química A','11º ano',11),(26,'Biologia e Geologia','11º ano',11),(27,'História A','11º ano',11),(28,'Geografia A','11º ano',11),(29,'Filosofia','11º ano',11),(30,'Português','12º ano',12),(31,'Inglês','12º ano',12),(32,'Educação Física','12º ano',12),(33,'Matemática A','12º ano',12),(34,'Física','12º ano',12),(35,'Química','12º ano',12),(36,'Biologia','12º ano',12),(37,'História A','12º ano',12),(38,'Filosofia','12º ano',12);
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_clubs`
--

DROP TABLE IF EXISTS `user_clubs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_clubs` (
  `user_id` char(36) NOT NULL,
  `club_id` char(36) NOT NULL,
  PRIMARY KEY (`user_id`,`club_id`),
  KEY `club_id` (`club_id`),
  CONSTRAINT `user_clubs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_clubs_ibfk_2` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_clubs`
--

LOCK TABLES `user_clubs` WRITE;
/*!40000 ALTER TABLE `user_clubs` DISABLE KEYS */;
INSERT INTO `user_clubs` VALUES ('1827537d-428a-4fbe-8298-5fede97479dd','7dba6b98-2bd8-469a-a888-eb6fab421fd3'),('1fd00609-512c-4f7a-8586-b0e5c6dceea5','9ada2f64-9977-4f32-b223-70624423d137'),('8b98514d-92e9-4a88-b50b-1d1e27fbced0','9ada2f64-9977-4f32-b223-70624423d137'),('004730cd-6139-4019-821a-bbfba921fa68','aa5e0719-fad1-4bb8-b4c1-84557d566ce3'),('179c0e87-9442-4325-a4fe-5fc4362051be','d029173b-cbfa-44a8-8e9f-721646cf87bc'),('28795797-4394-4911-88a8-913e7af145ee','d029173b-cbfa-44a8-8e9f-721646cf87bc'),('004730cd-6139-4019-821a-bbfba921fa68','e78197a6-7665-452e-977e-89b07fa83af3');
/*!40000 ALTER TABLE `user_clubs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_missions`
--

DROP TABLE IF EXISTS `user_missions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_missions` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `user_id` char(36) DEFAULT NULL,
  `mission_id` char(36) DEFAULT NULL,
  `points` int DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_user_missions_user` (`user_id`),
  KEY `fk_user_missions_mission` (`mission_id`),
  CONSTRAINT `fk_user_missions_mission` FOREIGN KEY (`mission_id`) REFERENCES `missions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_missions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_missions`
--

LOCK TABLES `user_missions` WRITE;
/*!40000 ALTER TABLE `user_missions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_missions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` char(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `global_average` decimal(4,2) DEFAULT '0.00',
  `can_create_battle` tinyint(1) DEFAULT '0',
  `profile_picture` varchar(255) DEFAULT NULL,
  `school_year` tinyint unsigned DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT '0',
  `verification_code` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `users_chk_1` CHECK ((`school_year` between 1 and 12))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('004730cd-6139-4019-821a-bbfba921fa68','m','m','m@gmail.com','$2b$10$ukkLCHM8lBc.FGaW/PsAWusCY6R7U1lUMgyUCIrx8.WsfR7Ne7gEa',3.67,0,NULL,NULL,0,NULL),('00878e58-5823-4779-985e-4f330e53ae98','g','g','g@gmail.com','$2b$10$CUVhLLAapID0dtPqHj64KOAlQTx6mZbLlkznbeQsimDujaGuggeam',0.00,0,NULL,NULL,0,NULL),('0129ff17-207b-431e-995d-6a90ea16630c','kk','kk','kk@gmail.com','$2b$10$fzE8XPc/VWewkbCruB2X8ut08KcCZdZ1BN4oPAIzOQaUvOFXXGC6W',0.00,0,NULL,NULL,0,NULL),('04972045-b6e1-46c1-a3ac-ba29a2b2fde9','murilo','murilo','limamurilo864@gmail.com','$2b$10$52EGu8xEdwYVkQyCIGTgpOtA0zcGNrvXPsY.LqQd76P2l6f27bjIu',0.00,0,'1776434664329-734364091.jpg',12,0,'413710'),('179c0e87-9442-4325-a4fe-5fc4362051be','t','t','t@gmail.com','$2b$10$pPTcutYedKOl9HV/T3b1YuG2Dvql/nQEy9CUfOBwHhZaky/JDyY7C',0.00,0,NULL,NULL,0,NULL),('1827537d-428a-4fbe-8298-5fede97479dd','aaaaaaaaaa','aaaaaaaaaa','aaaaaaaaaa@gmail.com','$2b$10$GcYOZNTqcRSzA0zrfn74m.85Kfc5p0KuhmlP2M9Obv547Mi5EYaNu',4.00,0,'1772893678632-760230060-IMG_6683.jpeg',9,0,NULL),('19ef6b67-9be9-4878-bfcf-c5029cf232fd','teeste','teeste','pya6zykjuqgz@zikzak.site','$2b$10$skZ.xvTBH8Hs47iT8wx4p.5UeyzaXL9yCcOza/lztVxTaLejh9EeK',0.00,0,'1776939393616-564734465.png',6,0,'984497'),('1bbc8c09-5d4f-4d45-87a0-533267999506','lololo','lololo','lololo@gmail.com','$2b$10$5cWHnzRjK.LFkIDpBblExOanyI.3CPs/LgZg/gYU0Omuew68OCHQy',0.00,0,NULL,12,0,'802908'),('1fd00609-512c-4f7a-8586-b0e5c6dceea5','murilomurilo','murilomurilo','murilomurilo@gmail.com','$2b$10$86yqr18eWn0ECEK4K9kNSeO9RgFOPRO4Shy3shOw7tk/v7P9hYpDm',3.29,0,'1776436146851-85205695.png',12,1,NULL),('28795797-4394-4911-88a8-913e7af145ee','A','A','A@GMAIL.COM','$2b$10$9n5zc05zVxsQBvdghrOcB.OaAOdrBzf7GY8DqI3vZy1cNN4hyRHRm',0.00,0,NULL,NULL,0,NULL),('31fe2f29-d953-4448-b753-769348fd7b1e','murilo','saldanha','muriloklk7@gmail.com','$2b$10$/zdZF17kwdAWLXetiJuQAOyM5Zppi.oOWsoeySUXj4FajUtMs5gJe',0.00,0,'1776282069862-682475734-02177114642405479d39dabdd16daed9e301f9238148b07c39876_0.jpg',12,0,'764581'),('3a4edb0e-2f74-4d2f-abfe-b6c0b638b4ec','asdasd','asdasd','jk3oypl8rv2@bseee.okcx.edu.rs','$2b$10$0XdcN0DTIEn250p37RZrOuV4LM4SbDolGuT067v/Zl9FlVejpq3NG',0.00,0,'1776282433649-231631139-IMG_8416.jpeg',12,0,'471175'),('484ee4a9-f73f-470c-878d-1be51530b758','aaaaaaaaaaaaa','aaaaaaaaaaaaa','aaaaaaaaaaaaa@gmail.com','$2b$10$jS7HAnOt5xmbfAeqloFkZ.VUe75hA9h.heLTKo9z7cr.JgyTGXFCy',0.00,0,NULL,12,0,'337656'),('4af08b25-a6b5-4531-8e91-dd6294012c9c','kaka','kaka','ivx0ck0h0usro@zikzak.site','$2b$10$xPuZT.A6ApNwAKP9WCnyueB.z8Acn7ijqk1XBMlxSf1567UUcZ64m',0.00,0,'1776940938623-963060514.png',6,0,'560492'),('5f79ac15-d30d-439c-a5eb-7f8a63984b49','testeteste123','testeteste13','h8k0uyrspcw@usa.priyo.edu.pl','$2b$10$6rT/mcf91jQm2qP3FFfla.mfaKq8.XZ/E68tvaZiap3db3Y3OmRNG',0.00,0,'1776938658115-359850550.png',5,0,'376108'),('8344b064-6685-4bae-bd51-dfe6ecfd30e7','aaaaaaaaa','aaaaaaaaa','aaaaaaaaa@gmail.com','$2b$10$eWkcLrNXqIm2C.gbdw7JH.voFszO55xQlWZetZaTEcE.GZc4xoDbO',0.00,0,NULL,12,0,'508907'),('8b98514d-92e9-4a88-b50b-1d1e27fbced0','tata234','tata234','d5qropta4r3psd@zikzak.site','$2b$10$Qi.4AI05yoOYbhRVG7nhM.SW5wlThijOYAdHehxsya/UN1N5CIjli',2.50,0,'1776941580071-105842479.png',6,1,NULL),('952e3128-efaf-4b5e-a632-4b8fa887860c','testeteste12312c32c1','testeteste1313c123','oezwa3y4qbbbo@zikzak.site','$2b$10$v3MZWCkOG9TPyv6.snk0Ju881Hdt4RZhkYU.ORjsECp.LvIuEzaZO',0.00,0,'1776938682552-928711530.png',5,0,'698689'),('9eb8d73d-c9cf-4f80-82f3-2f8f6db82811','tttt','tttt','tttt@gmail.com','$2b$10$Vbi4QZO.qIZmIk4Q8Sky3.CLmZMilghWjGYyqzx01hKZkTGrxo1cm',0.00,0,'1776940000328-199807149.png',6,0,'410397'),('a03b1ce9-a29e-4987-9226-8d7d77ab86da','olagost','olagost','o4cgwos6w@zikzak.site','$2b$10$8KoCV8hcmTVa0Y3bpHJcze/pRX8q63k7vqw7Q94A.sMHWORw/fIfy',0.00,0,'1776938745705-345688594.png',6,0,'676578'),('aa34c761-32a7-4863-8029-d378b9698560','tata','tata','a7ghtudbmlcqhx@zikzak.site','$2b$10$xU6XzxnAoA3X2O3HqIdcs.4QXBI/r75lYUPbj/r9pMMlgGNK.Nvjq',0.00,0,'1776941120370-910764824.png',6,0,'425004'),('b0d48816-f7b9-4a35-b85c-58704438e472','adadada','adadada','adadada@gmail.com','$2b$10$z40zIy2uDmxuIhU.bmm71Oys1m8aOmL2aCP3ryUpDVXTRdZC3CK/W',0.00,0,NULL,1,1,NULL),('b90cb553-251f-4011-b679-663a2f15f700','naoexiste','naoexiste','xnqdrwsf@zikzak.site','$2b$10$EKgnzmRxtweQFRk76V54x.IM23B1tJgX91u3FgrEIRH4OqtG/IzaG',0.00,0,'1776939009322-912792308.png',6,0,'135255'),('bc239595-ee39-4a44-b6de-688d0008f555','gg','gg','gg@gmail.com','$2b$10$zYM/fhwPFGTT6XEQb08TqejcIvvyXjXB/uELrqSddiOkewfe/w1iW',0.00,0,'1771512811439-991525553-115496_0-removebg-preview (1).png',NULL,0,NULL),('d31882cd-ca4b-42e7-ad6c-511096636749','teste','teste@gmail.com','piisiru9ptczz@bseee.okcx.edu.rs','$2b$10$yVR6REs36WRqXfZgRH51PeFvBQ79cu5B3uq4i9n0Whqkz5MAenUim',0.00,0,'1776938610575-52640458.png',5,0,'236182'),('e47d2a4b-10ef-4a51-915b-debea572331e','newUser','newUser','newUser@gmail.com','$2b$10$waYSz0yZXNK6UnxIG564m.si0yGgVeV5PbDCEhIeqpj/h6GLSGc1S',3.67,0,'1774858028535-572087450-IMG_6662(1).jpeg',5,0,NULL),('e6f33c1d-6023-4152-96a9-ea9d2055c54d','lolo','alolo','aloalo@gmail.com','$2b$10$T1sbDfxNagoSSmF.oKn6h.8NIxfA1Qx.Mz0JTuyk2d3CSBTNENGAG',0.00,0,'1776435928658-966161635.png',12,0,'377873'),('fa539f70-7074-4cfe-bfaa-fe2325e015bf','tata123','tata123','io7ekco1lnyn5un@zikzak.site','$2b$10$L649SXCK7PgBTitIgjnbeeMbGsDVMDIojc2HsbGV2OlAR75OKXrii',0.00,0,'1776941158278-886024783.png',6,0,'549241');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'topclass_db'
--

--
-- Dumping routines for database 'topclass_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-21 13:07:14
