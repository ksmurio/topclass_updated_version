CREATE DATABASE  IF NOT EXISTS `topclass_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `topclass_db`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: topclass_db
-- ------------------------------------------------------
-- Server version	8.0.44

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
  `id` char(36) NOT NULL,
  `battle_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battle_grades`
--

LOCK TABLES `battle_grades` WRITE;
/*!40000 ALTER TABLE `battle_grades` DISABLE KEYS */;
INSERT INTO `battle_grades` VALUES ('18794dcc-1f43-46c2-94f4-2231bc7fa6a8','05a3df33-55b7-484a-b649-98ecf739c6cb','1fd00609-512c-4f7a-8586-b0e5c6dceea5','2026-06-04 13:43:15'),('6881baf5-d7bc-43b8-8d7d-835819453c4e','caa6c0a7-a277-441c-ba5e-6e579b69b978','1fd00609-512c-4f7a-8586-b0e5c6dceea5','2026-06-04 13:07:38'),('70baf073-7897-49c1-be73-4f3bfca414a7','db9aaf18-103a-43a8-810a-48ac8a50bb94','1fd00609-512c-4f7a-8586-b0e5c6dceea5','2026-06-04 13:36:14');
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
INSERT INTO `battles` VALUES ('05a3df33-55b7-484a-b649-98ecf739c6cb','383c672b-7b46-4d85-aa20-a79aa35a52b8','1fd00609-512c-4f7a-8586-b0e5c6dceea5','2026-06-04 00:00:00','scheduled','2026-06-04 13:43:00','14:44:00'),('71293a43-19cd-4df5-b1aa-a8df8de926ac','7dba6b98-2bd8-469a-a888-eb6fab421fd3','1827537d-428a-4fbe-8298-5fede97479dd','2026-03-31 00:00:00','scheduled','2026-03-30 10:37:42','00:00:00'),('92e6cfcc-f7c7-469e-a253-9bb723296ccc','383c672b-7b46-4d85-aa20-a79aa35a52b8','1fd00609-512c-4f7a-8586-b0e5c6dceea5','2026-12-25 00:00:00','scheduled','2026-05-17 16:15:31','12:00:00'),('a8ce527f-331f-49cb-92b2-cb088c8eca66','aa5e0719-fad1-4bb8-b4c1-84557d566ce3','004730cd-6139-4019-821a-bbfba921fa68','2026-04-01 00:00:00','scheduled','2026-03-30 16:09:09','09:09:00'),('caa6c0a7-a277-441c-ba5e-6e579b69b978','383c672b-7b46-4d85-aa20-a79aa35a52b8','1fd00609-512c-4f7a-8586-b0e5c6dceea5','2026-06-03 00:00:00','scheduled','2026-06-04 11:45:40','12:45:00'),('db9aaf18-103a-43a8-810a-48ac8a50bb94','383c672b-7b46-4d85-aa20-a79aa35a52b8','1fd00609-512c-4f7a-8586-b0e5c6dceea5','2026-05-29 00:00:00','scheduled','2026-05-16 17:39:15','12:00:00'),('e0cb3bc5-d27c-4fdb-ab10-260f46e5fce9','383c672b-7b46-4d85-aa20-a79aa35a52b8','1fd00609-512c-4f7a-8586-b0e5c6dceea5','2026-06-18 00:00:00','scheduled','2026-06-04 11:45:21','14:47:00');
/*!40000 ALTER TABLE `battles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `club_comments`
--

DROP TABLE IF EXISTS `club_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `club_comments` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `post_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_comments_post` (`post_id`),
  KEY `fk_comments_user` (`user_id`),
  CONSTRAINT `fk_comments_post` FOREIGN KEY (`post_id`) REFERENCES `club_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `club_comments`
--

LOCK TABLES `club_comments` WRITE;
/*!40000 ALTER TABLE `club_comments` DISABLE KEYS */;
INSERT INTO `club_comments` VALUES ('174ad64b-2737-4f3d-8d83-431ba863cd13','b0a66574-10aa-4e84-b727-f6fed776151d','1fd00609-512c-4f7a-8586-b0e5c6dceea5','ola','2026-05-17 09:09:54'),('568bb699-2977-4424-bb5e-06e6f0921aa7','b89ffe33-1b2e-48b6-9383-5a8e1a9c7044','1827537d-428a-4fbe-8298-5fede97479dd','sim','2026-05-17 15:35:33'),('5ea925cf-a317-4c46-bc8b-78ea0d8dc064','b0a66574-10aa-4e84-b727-f6fed776151d','1fd00609-512c-4f7a-8586-b0e5c6dceea5','ola','2026-05-17 08:55:20'),('c3a5a46f-2256-4f30-8038-56f11ed12aec','b0a66574-10aa-4e84-b727-f6fed776151d','1827537d-428a-4fbe-8298-5fede97479dd','não','2026-05-17 15:35:40'),('e94067ba-5287-4a91-a4f4-8e6694353e22','7fd465f1-46f4-4d73-9158-c058581f6b00','1fd00609-512c-4f7a-8586-b0e5c6dceea5','sim','2026-05-17 16:16:09');
/*!40000 ALTER TABLE `club_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `club_posts`
--

DROP TABLE IF EXISTS `club_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `club_posts` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `club_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_posts_club` (`club_id`),
  KEY `fk_posts_user` (`user_id`),
  CONSTRAINT `fk_posts_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_posts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `club_posts`
--

LOCK TABLES `club_posts` WRITE;
/*!40000 ALTER TABLE `club_posts` DISABLE KEYS */;
INSERT INTO `club_posts` VALUES ('7fd465f1-46f4-4d73-9158-c058581f6b00','28dc54aa-88d8-4644-bd9c-9b3203715599','1827537d-428a-4fbe-8298-5fede97479dd','ola tudo bem?','2026-05-17 15:35:30',NULL),('8ff9ea1c-e1c0-4fc0-b7f7-bba6ac1ff7cc','383c672b-7b46-4d85-aa20-a79aa35a52b8','a7ee4110-77b2-4cc1-8024-81071a4b4f47','hello','2026-06-04 14:30:36',NULL),('974bd6a3-213c-4af0-af51-610d34672711','28dc54aa-88d8-4644-bd9c-9b3203715599','1fd00609-512c-4f7a-8586-b0e5c6dceea5','ola','2026-05-17 16:15:55',NULL),('b0a66574-10aa-4e84-b727-f6fed776151d','28dc54aa-88d8-4644-bd9c-9b3203715599','1fd00609-512c-4f7a-8586-b0e5c6dceea5','dasdsad','2026-05-17 08:55:11',NULL),('b89ffe33-1b2e-48b6-9383-5a8e1a9c7044','28dc54aa-88d8-4644-bd9c-9b3203715599','1fd00609-512c-4f7a-8586-b0e5c6dceea5','pao','2026-05-17 09:10:07',NULL),('d1f8d8d7-5e40-440b-ab65-650a261c28d2','383c672b-7b46-4d85-aa20-a79aa35a52b8','1fd00609-512c-4f7a-8586-b0e5c6dceea5','i like it\r\n','2026-06-04 09:52:31','1780566751172-868304811.png'),('e982640e-e318-4b6c-bf25-d0e4d74fdc2e','28dc54aa-88d8-4644-bd9c-9b3203715599','1fd00609-512c-4f7a-8586-b0e5c6dceea5','ola','2026-05-17 15:54:48',NULL);
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
  `club_type` int NOT NULL,
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
INSERT INTO `clubs` VALUES ('28dc54aa-88d8-4644-bd9c-9b3203715599','Matematica ','eu gosto de matematica murilo 1',33,'8cdc0b76-2798-4955-a328-a6f273ba5082','598038d7-70f6-438c-9c31-bf59a4a5c917',NULL,0,'2026-05-16 17:07:31','1778951251876-924474424.jpg'),('383c672b-7b46-4d85-aa20-a79aa35a52b8','AAAA','AAAA',37,'1fd00609-512c-4f7a-8586-b0e5c6dceea5','d6ff019f-d5d9-4e5b-9ad9-eab9f000eee9',NULL,0,'2026-05-16 16:03:32','1778947412230-780537612.png'),('75d707c2-8fe6-4272-8f0e-6c9b73c02d9c','asdasd','asdas',5,'1fd00609-512c-4f7a-8586-b0e5c6dceea5','2b3102f7-d53e-4027-bf3d-8ec069b8dd2b',NULL,0,'2026-05-08 21:00:56','1778274056348-814023505.jpeg'),('7dba6b98-2bd8-469a-a888-eb6fab421fd3','ingles','inglles is good',3,'1827537d-428a-4fbe-8298-5fede97479dd','c6702896-4a88-492e-8335-bfdb250b7a24',NULL,0,'2026-03-30 09:57:57','1774864677313-841383500-2ad2ed77096ad9bca592cad7a80345b3.jpg'),('823a76cc-92ad-4f0f-a6dc-951ae21824b8','hsitoria','asd',5,'1fd00609-512c-4f7a-8586-b0e5c6dceea5','1e6cebfe-bc22-4042-aee1-e3d3f9b3265c',NULL,0,'2026-05-16 15:45:48','1778946348866-702602926.jpeg'),('aa5e0719-fad1-4bb8-b4c1-84557d566ce3','adasd','adasd',7,'004730cd-6139-4019-821a-bbfba921fa68','14637cf5-b21d-4055-a79d-a9344a55e65e',NULL,0,'2026-02-27 16:52:43',NULL),('d029173b-cbfa-44a8-8e9f-721646cf87bc','a','a',1,'28795797-4394-4911-88a8-913e7af145ee','f937a421-8f6b-4ece-bb05-31f2a7421020',NULL,0,'2026-01-27 20:48:07',NULL),('e78197a6-7665-452e-977e-89b07fa83af3','asdasdsa','adas',6,'004730cd-6139-4019-821a-bbfba921fa68','c74b22e5-c199-491c-a75c-54f323bfdc92',NULL,0,'2026-03-26 10:26:58','1774520818025-640168532-02177054958926669d9f56ebaf8adc0cbe3483f4c0cffb8e52570_0.jpg'),('eb9e8e4d-2535-4395-bff7-84703db09949','asdas','asda',18,'1fd00609-512c-4f7a-8586-b0e5c6dceea5','aac57e8a-dbd9-4961-b459-3de0bf1361df',NULL,0,'2026-05-16 15:59:05','1778947145010-848702125.png'),('f7c57955-2cdc-4db3-8e40-750f5aa6eb29','histo A','HISTOA',27,'1fd00609-512c-4f7a-8586-b0e5c6dceea5','da55af6a-198f-4f3a-bd96-19d0259849e1',NULL,0,'2026-05-16 15:59:47','1778947186952-993996342.png');
/*!40000 ALTER TABLE `clubs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupons`
--

DROP TABLE IF EXISTS `coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupons` (
  `id` char(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `points_cost` int NOT NULL,
  `discount` varchar(50) NOT NULL,
  `code_prefix` varchar(20) DEFAULT 'TOP',
  `stock` int DEFAULT '-1',
  `active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupons`
--

LOCK TABLES `coupons` WRITE;
/*!40000 ALTER TABLE `coupons` DISABLE KEYS */;
INSERT INTO `coupons` VALUES ('f22d62c8-64dc-11f1-9b44-d1a5c7f67c8a','Desconto Fnac 10%','Coupon de 10% de desconto na Fnac',500,'10%','FNAC',50,1,'2026-06-10 15:59:14'),('f22dfc8f-64dc-11f1-9b44-d1a5c7f67c8a','Voucher WOOK 5€','Voucher de 5€ na loja WOOK',300,'5€','WOOK',99,1,'2026-06-10 15:59:14'),('f22e01c1-64dc-11f1-9b44-d1a5c7f67c8a','Spotify 1 mês grátis','1 mês de Spotify Premium sem custo',800,'100%','SPOT',20,1,'2026-06-10 15:59:14'),('f22e02c2-64dc-11f1-9b44-d1a5c7f67c8a','Desconto Storytel 15%','15% de desconto na subscrição Storytel',400,'15%','STEL',-1,1,'2026-06-10 15:59:14');
/*!40000 ALTER TABLE `coupons` ENABLE KEYS */;
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
INSERT INTO `missions` VALUES ('a1b2c3d4-0001-4000-8000-000000000001','1fd00609-512c-4f7a-8586-b0e5c6dceea5','Estudar para o teste de Matemática','Rever todos os conteúdos do capítulo de funções e derivadas para o próximo teste.','2026-06-04 14:13:07','2026-06-20'),('a1b2c3d4-0002-4000-8000-000000000002','1fd00609-512c-4f7a-8586-b0e5c6dceea5','Fazer resumo de História A','Criar um resumo completo sobre a 1ª Guerra Mundial e as suas consequências.','2026-06-04 14:13:07','2026-06-15'),('a1b2c3d4-0003-4000-8000-000000000003','1827537d-428a-4fbe-8298-5fede97479dd','Praticar vocabulário de Inglês','Memorizar 50 novas palavras em inglês e usá-las em frases.','2026-06-04 14:13:07','2026-06-10'),('a1b2c3d4-0004-4000-8000-000000000004','1827537d-428a-4fbe-8298-5fede97479dd','Ler obra de Português','Ler os primeiros 3 capítulos do livro indicado e fazer anotações.','2026-06-04 14:13:07','2026-06-25'),('a1b2c3d4-0005-4000-8000-000000000005','8cdc0b76-2798-4955-a328-a6f273ba5082','Resolver 20 exercícios de Matemática','Completar os exercícios das páginas 120 a 140 do manual.','2026-06-04 14:13:07','2026-06-12'),('a1b2c3d4-0006-4000-8000-000000000006','8cdc0b76-2798-4955-a328-a6f273ba5082','Participar no debate do clube de Matemática','Preparar argumentos e participar no debate semanal do clube.','2026-06-04 14:13:07','2026-06-18'),('a1b2c3d4-0007-4000-8000-000000000007','1fd00609-512c-4f7a-8586-b0e5c6dceea5','Publicar post de revisão no clube de História','Escrever um post com dicas de estudo para os membros do clube.','2026-06-04 14:13:07','2026-06-14'),('a1b2c3d4-0008-4000-8000-000000000008','1827537d-428a-4fbe-8298-5fede97479dd','Desafiar um colega no clube de Inglês','Criar e participar num battle de vocabulário com um membro do clube.','2026-06-04 14:13:07','2026-06-22'),('a1b2c3d4-0009-4000-8000-000000000009','004730cd-6139-4019-821a-bbfba921fa68','Preparação para exame nacional de Inglês','Resolver 3 exames nacionais dos anos anteriores e corrigir os erros.','2026-06-04 14:13:07','2026-06-30'),('a1b2c3d4-0010-4000-8000-000000000010','004730cd-6139-4019-821a-bbfba921fa68','Simulacro de exame de Físico-Química','Completar um exame simulado em tempo real e avaliar o resultado.','2026-06-04 14:13:07','2026-06-28'),('a1b2c3d4-0011-4000-8000-000000000011','1fd00609-512c-4f7a-8586-b0e5c6dceea5','Subir nota de Filosofia para 16','Estudar os temas de ética e epistemologia para melhorar a nota no próximo teste.','2026-06-04 14:13:07','2026-07-01'),('a1b2c3d4-0012-4000-8000-000000000012','8cdc0b76-2798-4955-a328-a6f273ba5082','Manter média acima de 17 em Matemática','Garantir que as próximas avaliações de Matemática A não baixem da nota de 17 valores.','2026-06-04 14:13:07','2026-07-15'),('a1b2c3d4-0013-4000-8000-000000000013','1827537d-428a-4fbe-8298-5fede97479dd','Estudar 1 hora por dia durante 7 dias','Manter uma rotina de estudo diária de pelo menos 60 minutos durante uma semana.','2026-06-04 14:13:07','2026-06-11'),('a1b2c3d4-0014-4000-8000-000000000014','1fd00609-512c-4f7a-8586-b0e5c6dceea5','Tirar apontamentos em todas as aulas desta semana','Organizar os apontamentos de cada disciplina e partilhar com o grupo de estudo.','2026-06-04 14:13:07','2026-06-08'),('a1b2c3d4-0015-4000-8000-000000000015',NULL,'Completar 5 battles na plataforma','Participar e concluir 5 battles diferentes na TopClass para ganhar pontos extra.','2026-06-04 14:13:07','2026-07-31'),('m0000001-0000-4000-8000-000000000001','1fd00609-512c-4f7a-8586-b0e5c6dceea5','Rever matéria de Inglês','Rever vocabulário e gramática do último capítulo para preparação do teste.','2026-06-04 14:16:25','2026-06-01'),('m0000001-0000-4000-8000-000000000002','8cdc0b76-2798-4955-a328-a6f273ba5082','Exercícios de Matemática A','Resolver 10 exercícios de derivadas e verificar os resultados.','2026-06-04 14:16:25','2026-06-02'),('m0000001-0000-4000-8000-000000000003','1fd00609-512c-4f7a-8586-b0e5c6dceea5','Fazer resumo de História A','Criar um resumo dos eventos da 2ª Guerra Mundial para o teste da semana.','2026-06-04 14:16:25','2026-06-04'),('m0000001-0000-4000-8000-000000000004','1827537d-428a-4fbe-8298-5fede97479dd','Ler capítulo de Português','Ler e anotar os pontos principais do capítulo indicado pelo professor.','2026-06-04 14:16:25','2026-06-04'),('m0000001-0000-4000-8000-000000000005','8cdc0b76-2798-4955-a328-a6f273ba5082','Publicar post no clube de Matemática','Partilhar dicas de estudo sobre funções com os membros do clube.','2026-06-04 14:16:25','2026-06-04'),('m0000001-0000-4000-8000-000000000006','004730cd-6139-4019-821a-bbfba921fa68','Simulacro de exame de Inglês','Completar um exame simulado de inglês de anos anteriores em tempo real.','2026-06-04 14:16:25','2026-06-05'),('m0000001-0000-4000-8000-000000000007','1fd00609-512c-4f7a-8586-b0e5c6dceea5','Participar num battle no clube','Desafiar um colega para um battle na disciplina à escolha.','2026-06-04 14:16:25','2026-06-06'),('m0000001-0000-4000-8000-000000000008',NULL,'Revisão geral da semana','Rever todos os apontamentos da semana e organizar os temas para a semana seguinte.','2026-06-04 14:16:25','2026-06-07');
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
INSERT INTO `subject_grades` VALUES ('0516381c-7290-427a-9eb7-dd2f4f384bfb','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,36,2.00,'2026-06-04 13:07:44'),('15b7b163-f388-41d0-b318-7533a6f813ee','e47d2a4b-10ef-4a51-915b-debea572331e',NULL,11,3.00,'2026-03-30 08:26:44'),('388f3794-9eda-4865-a076-5a26ec3d3c45','8cdc0b76-2798-4955-a328-a6f273ba5082',NULL,33,19.00,'2026-05-16 17:08:38'),('39d82bee-07b8-4773-b27e-f163f93adb2a','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,37,18.00,'2026-05-17 15:41:07'),('3e5adcde-201a-4e3a-91dc-b52f274afd2d','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,37,15.00,'2026-05-17 15:40:49'),('491c25f3-98b2-41ab-b225-d95ab50443fa','1827537d-428a-4fbe-8298-5fede97479dd',NULL,3,5.00,'2026-03-30 10:04:51'),('4bc0b767-66e9-4668-8b8d-33436d3954f5','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,94,5.00,'2026-06-04 13:36:20'),('4c787f7d-1a40-4629-b7c4-07b4a7c5cfd7','e47d2a4b-10ef-4a51-915b-debea572331e',NULL,2,4.00,'2026-03-30 08:26:21'),('4de232d1-c663-40c0-b3f5-a668eab54fc2','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,37,5.00,'2026-05-16 15:36:02'),('503f7181-9004-4377-b078-b7831341af0d','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,37,20.00,'2026-05-16 15:36:16'),('544791c6-0109-4879-8947-a3d608de9908','8cdc0b76-2798-4955-a328-a6f273ba5082',NULL,33,5.00,'2026-05-16 17:08:23'),('58763dd0-c475-4dd9-9b4d-c9f9d8cb9488','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,36,20.00,'2026-06-04 13:43:36'),('5da73d92-655c-412a-9e73-14662d32e169','004730cd-6139-4019-821a-bbfba921fa68',NULL,3,5.00,'2026-03-30 07:22:24'),('5f185dae-80fc-4682-9f02-2dd9e141a31a','1827537d-428a-4fbe-8298-5fede97479dd',NULL,2,5.00,'2026-03-30 10:34:05'),('60284521-0196-4eec-a5e0-c75b88c02048','a7ee4110-77b2-4cc1-8024-81071a4b4f47',NULL,37,20.00,'2026-06-04 14:31:33'),('62efef46-cf5e-46d1-8607-6d136b19c05b','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,38,5.00,'2026-05-16 15:46:13'),('73e6c759-3362-4a9f-82e4-890b7e25ed1c','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,33,16.00,'2026-05-16 17:09:16'),('799325ef-058b-45b5-8f86-8e7b127ffa4f','1827537d-428a-4fbe-8298-5fede97479dd',NULL,1,0.00,'2026-03-07 20:36:17'),('7d17306b-85dd-4f5c-9091-fdc789076cbf','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,37,5.00,'2026-05-08 21:01:15'),('833d5474-63c2-4f48-b804-56a7b1d43ab6','004730cd-6139-4019-821a-bbfba921fa68',NULL,1,4.00,'2026-03-30 07:22:11'),('8f43fd45-2fa1-43c9-8a96-9c0f7d9e893a','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,88,18.00,'2026-05-17 15:51:09'),('97bf0f23-98f3-44d0-88ba-2d472551a344','1827537d-428a-4fbe-8298-5fede97479dd',NULL,2,5.00,'2026-03-07 20:36:05'),('ac514f58-5777-488d-a171-ab2b6f0ebc97','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,98,14.00,'2026-05-17 16:14:46'),('aca0cc28-e635-4d29-986f-d742be750808','e47d2a4b-10ef-4a51-915b-debea572331e',NULL,1,5.00,'2026-03-30 08:07:33'),('affa0aa1-05a4-4936-8e5a-950368335255','004730cd-6139-4019-821a-bbfba921fa68',NULL,2,5.00,'2026-04-01 16:36:15'),('bc069ce6-31f4-410c-b250-a8c32d3adbdf','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,31,1.00,'2026-05-16 15:32:42'),('beea824a-ba4c-4ce4-b979-3446c4b56169','1827537d-428a-4fbe-8298-5fede97479dd',NULL,2,5.00,'2026-03-07 20:35:47'),('c44e4366-f417-4078-b4f7-bbb799bcec47','8cdc0b76-2798-4955-a328-a6f273ba5082',NULL,33,18.00,'2026-05-16 17:08:44'),('c4abcc2e-8ea3-4b62-bda1-caf539cb1fb7','004730cd-6139-4019-821a-bbfba921fa68',NULL,2,0.00,'2026-03-30 07:27:53'),('d8d3abd6-5282-4a66-9016-2325933749b4','e47d2a4b-10ef-4a51-915b-debea572331e',NULL,6,5.00,'2026-03-30 08:26:14'),('e2d50971-df61-4e91-ad88-1460906af250','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,55,19.00,'2026-05-17 15:48:51'),('e2fdca1a-22ac-4b21-8686-d44f694ac7d6','004730cd-6139-4019-821a-bbfba921fa68',NULL,1,3.00,'2026-03-30 07:21:50'),('ea5c4796-55a5-4c9f-a4e7-7fbac0dcda6b','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,33,13.00,'2026-05-16 17:09:24'),('ed61bf8f-74d9-487c-bc7d-4ad5dcb12c2a','004730cd-6139-4019-821a-bbfba921fa68',NULL,2,5.00,'2026-03-30 07:22:03'),('f24287f5-4a2d-449f-866f-cf5ab4179fdb','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,95,10.00,'2026-05-17 15:53:50'),('f25de789-dad4-4e32-8d49-8918aab9e1f0','a7ee4110-77b2-4cc1-8024-81071a4b4f47',NULL,37,10.00,'2026-06-04 14:32:32'),('f6600333-69f8-4fbb-8998-7e86e16e8ae3','e47d2a4b-10ef-4a51-915b-debea572331e',NULL,9,2.00,'2026-03-30 08:26:32'),('f894a26e-e93e-46af-b5a6-686c6d8d6d4e','e47d2a4b-10ef-4a51-915b-debea572331e',NULL,2,3.00,'2026-03-30 08:26:06'),('fe829c47-f29b-49d7-82c0-5502f85ec202','1fd00609-512c-4f7a-8586-b0e5c6dceea5',NULL,37,6.00,'2026-05-17 15:41:23');
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
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES (1,'Português','9º ano',9),(2,'Matemática','9º ano',9),(3,'Inglês','9º ano',9),(4,'Francês','9º ano',9),(5,'História','9º ano',9),(6,'Geografia','9º ano',9),(7,'Ciências Naturais','9º ano',9),(8,'Físico-Química','9º ano',9),(9,'Educação Visual','9º ano',9),(10,'Educação Física','9º ano',9),(11,'TIC','9º ano',9),(12,'Português','10º ano',10),(13,'Inglês','10º ano',10),(14,'Educação Física','10º ano',10),(15,'Matemática A','10º ano',10),(16,'Física e Química A','10º ano',10),(17,'Biologia e Geologia','10º ano',10),(18,'História A','10º ano',10),(19,'Geografia A','10º ano',10),(20,'Economia A','10º ano',10),(21,'Português','11º ano',11),(22,'Inglês','11º ano',11),(23,'Educação Física','11º ano',11),(24,'Matemática A','11º ano',11),(25,'Física e Química A','11º ano',11),(26,'Biologia e Geologia','11º ano',11),(27,'História A','11º ano',11),(28,'Geografia A','11º ano',11),(29,'Filosofia','11º ano',11),(30,'Português','12º ano',12),(31,'Inglês','12º ano',12),(32,'Educação Física','12º ano',12),(33,'Matemática A','12º ano',12),(34,'Física','12º ano',12),(35,'Química','12º ano',12),(36,'Biologia','12º ano',12),(37,'História A','12º ano',12),(38,'Filosofia','12º ano',12),(39,'Matemática B','10º ano',10),(40,'Física e Química B','10º ano',10),(41,'História B','10º ano',10),(42,'Geografia B','10º ano',10),(43,'Economia B','10º ano',10),(44,'Matemática B','11º ano',11),(45,'Física e Química B','11º ano',11),(46,'História B','11º ano',11),(47,'Geografia B','11º ano',11),(48,'Economia A','11º ano',11),(49,'Economia B','11º ano',11),(50,'Matemática B','12º ano',12),(51,'História B','12º ano',12),(52,'Física A','12º ano',12),(53,'Química A','12º ano',12),(54,'Biologia A','12º ano',12),(55,'Geologia A','12º ano',12),(56,'Espanhol','9º ano',9),(57,'Educação Tecnológica','9º ano',9),(58,'EMRC','9º ano',9),(59,'Oferta Complementar','9º ano',9),(60,'Educação Musical','9º ano',9),(61,'Espanhol','10º ano',10),(62,'Francês','10º ano',10),(63,'EMRC','10º ano',10),(64,'Psicologia e Sociologia','10º ano',10),(65,'Aplicações Informáticas B','10º ano',10),(66,'MACS','10º ano',10),(67,'Geometria Descritiva A','10º ano',10),(68,'Geometria Descritiva B','10º ano',10),(69,'Desenho A','10º ano',10),(70,'Educação Visual','10º ano',10),(71,'Espanhol','11º ano',11),(72,'Francês','11º ano',11),(73,'EMRC','11º ano',11),(74,'Psicologia e Sociologia','11º ano',11),(75,'Aplicações Informáticas B','11º ano',11),(76,'MACS','11º ano',11),(77,'Geometria Descritiva A','11º ano',11),(78,'Geometria Descritiva B','11º ano',11),(79,'Desenho A','11º ano',11),(80,'Educação Visual','11º ano',11),(81,'Literatura Portuguesa','11º ano',11),(82,'Biologia','11º ano',11),(83,'Geologia','11º ano',11),(84,'Espanhol','12º ano',12),(85,'Francês','12º ano',12),(86,'EMRC','12º ano',12),(87,'MACS','12º ano',12),(88,'Geometria Descritiva A','12º ano',12),(89,'Geometria Descritiva B','12º ano',12),(90,'Desenho A','12º ano',12),(91,'Literatura Portuguesa','12º ano',12),(92,'Aplicações Informáticas B','12º ano',12),(93,'Sociologia','12º ano',12),(94,'Direito','12º ano',12),(95,'Economia A','12º ano',12),(96,'Economia B','12º ano',12),(97,'Matemática B','12º ano',12),(98,'Clássicos da Literatura','12º ano',12);
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
INSERT INTO `user_clubs` VALUES ('1827537d-428a-4fbe-8298-5fede97479dd','28dc54aa-88d8-4644-bd9c-9b3203715599'),('1fd00609-512c-4f7a-8586-b0e5c6dceea5','28dc54aa-88d8-4644-bd9c-9b3203715599'),('8cdc0b76-2798-4955-a328-a6f273ba5082','28dc54aa-88d8-4644-bd9c-9b3203715599'),('1fd00609-512c-4f7a-8586-b0e5c6dceea5','383c672b-7b46-4d85-aa20-a79aa35a52b8'),('a7ee4110-77b2-4cc1-8024-81071a4b4f47','383c672b-7b46-4d85-aa20-a79aa35a52b8'),('1fd00609-512c-4f7a-8586-b0e5c6dceea5','75d707c2-8fe6-4272-8f0e-6c9b73c02d9c'),('1827537d-428a-4fbe-8298-5fede97479dd','7dba6b98-2bd8-469a-a888-eb6fab421fd3'),('1fd00609-512c-4f7a-8586-b0e5c6dceea5','823a76cc-92ad-4f0f-a6dc-951ae21824b8'),('004730cd-6139-4019-821a-bbfba921fa68','aa5e0719-fad1-4bb8-b4c1-84557d566ce3'),('179c0e87-9442-4325-a4fe-5fc4362051be','d029173b-cbfa-44a8-8e9f-721646cf87bc'),('28795797-4394-4911-88a8-913e7af145ee','d029173b-cbfa-44a8-8e9f-721646cf87bc'),('004730cd-6139-4019-821a-bbfba921fa68','e78197a6-7665-452e-977e-89b07fa83af3'),('1fd00609-512c-4f7a-8586-b0e5c6dceea5','eb9e8e4d-2535-4395-bff7-84703db09949'),('1fd00609-512c-4f7a-8586-b0e5c6dceea5','f7c57955-2cdc-4db3-8e40-750f5aa6eb29');
/*!40000 ALTER TABLE `user_clubs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_coupons`
--

DROP TABLE IF EXISTS `user_coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_coupons` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `coupon_id` char(36) NOT NULL,
  `code` varchar(50) NOT NULL,
  `purchased_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `user_id` (`user_id`),
  KEY `coupon_id` (`coupon_id`),
  CONSTRAINT `user_coupons_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_coupons_ibfk_2` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_coupons`
--

LOCK TABLES `user_coupons` WRITE;
/*!40000 ALTER TABLE `user_coupons` DISABLE KEYS */;
INSERT INTO `user_coupons` VALUES ('1f2b60c1-78c4-4844-8f05-7d6ebc33e281','1fd00609-512c-4f7a-8586-b0e5c6dceea5','f22dfc8f-64dc-11f1-9b44-d1a5c7f67c8a','WOOK-MQ87MYX0-MFHGH','2026-06-10 15:15:09');
/*!40000 ALTER TABLE `user_coupons` ENABLE KEYS */;
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
INSERT INTO `user_missions` VALUES ('5f1ee279-4d06-4fc3-9b7d-a3c3a9faa2f8','1fd00609-512c-4f7a-8586-b0e5c6dceea5','m0000001-0000-4000-8000-000000000004',10,'2026-06-04 14:21:39'),('7bcf8fd7-6fd7-4f6f-b7b1-c0dd9285e445','1fd00609-512c-4f7a-8586-b0e5c6dceea5','m0000001-0000-4000-8000-000000000007',10,'2026-06-04 14:21:42'),('7eb98621-f0c1-43ae-a0ef-0e5e695b81f2','1fd00609-512c-4f7a-8586-b0e5c6dceea5','m0000001-0000-4000-8000-000000000005',10,'2026-06-04 14:21:40'),('bba18d8c-1cef-4c79-b71d-dc48cd5f524b','1fd00609-512c-4f7a-8586-b0e5c6dceea5','m0000001-0000-4000-8000-000000000002',10,'2026-06-04 14:16:49'),('cae9497b-f2b6-4af7-ab25-ff0d8be48389','1fd00609-512c-4f7a-8586-b0e5c6dceea5','m0000001-0000-4000-8000-000000000006',10,'2026-06-04 14:16:54');
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
  `photos` json DEFAULT NULL,
  `points` int DEFAULT '0',
  `reports` int DEFAULT '0',
  `reported_by` json DEFAULT NULL,
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
INSERT INTO `users` VALUES ('004730cd-6139-4019-821a-bbfba921fa68','m','m','m@gmail.com','$2b$10$ukkLCHM8lBc.FGaW/PsAWusCY6R7U1lUMgyUCIrx8.WsfR7Ne7gEa',3.67,0,NULL,NULL,0,NULL,NULL,0,0,NULL),('00878e58-5823-4779-985e-4f330e53ae98','g','g','g@gmail.com','$2b$10$CUVhLLAapID0dtPqHj64KOAlQTx6mZbLlkznbeQsimDujaGuggeam',0.00,0,NULL,NULL,0,NULL,NULL,0,0,NULL),('0129ff17-207b-431e-995d-6a90ea16630c','kk','kk','kk@gmail.com','$2b$10$fzE8XPc/VWewkbCruB2X8ut08KcCZdZ1BN4oPAIzOQaUvOFXXGC6W',0.00,0,NULL,NULL,0,NULL,NULL,0,0,NULL),('04972045-b6e1-46c1-a3ac-ba29a2b2fde9','murilo','murilo','limamurilo864@gmail.com','$2b$10$52EGu8xEdwYVkQyCIGTgpOtA0zcGNrvXPsY.LqQd76P2l6f27bjIu',0.00,0,'1776434664329-734364091.jpg',12,0,'413710',NULL,0,0,NULL),('179c0e87-9442-4325-a4fe-5fc4362051be','t','t','t@gmail.com','$2b$10$pPTcutYedKOl9HV/T3b1YuG2Dvql/nQEy9CUfOBwHhZaky/JDyY7C',0.00,0,NULL,NULL,0,NULL,NULL,0,0,NULL),('1827537d-428a-4fbe-8298-5fede97479dd','aaaaaaaaaa','aaaaaaaaaa','aaaaaaaaaa@gmail.com','$2b$10$GcYOZNTqcRSzA0zrfn74m.85Kfc5p0KuhmlP2M9Obv547Mi5EYaNu',4.00,0,'1772893678632-760230060-IMG_6683.jpeg',9,1,NULL,NULL,0,0,NULL),('1bbc8c09-5d4f-4d45-87a0-533267999506','lololo','lololo','lololo@gmail.com','$2b$10$5cWHnzRjK.LFkIDpBblExOanyI.3CPs/LgZg/gYU0Omuew68OCHQy',0.00,0,NULL,12,0,'802908',NULL,0,0,NULL),('1fd00609-512c-4f7a-8586-b0e5c6dceea5','murilomurilo','murilomurilo','murilomurilo@gmail.com','$2b$10$86yqr18eWn0ECEK4K9kNSeO9RgFOPRO4Shy3shOw7tk/v7P9hYpDm',11.29,0,'1776436146851-85205695.png',12,1,NULL,'[\"1780567733546-880073212.jpg\"]',1751,2,'[\"1fd00609-512c-4f7a-8586-b0e5c6dceea5\", \"a7ee4110-77b2-4cc1-8024-81071a4b4f47\"]'),('28795797-4394-4911-88a8-913e7af145ee','A','A','A@GMAIL.COM','$2b$10$9n5zc05zVxsQBvdghrOcB.OaAOdrBzf7GY8DqI3vZy1cNN4hyRHRm',0.00,0,NULL,NULL,1,NULL,NULL,0,0,NULL),('31fe2f29-d953-4448-b753-769348fd7b1e','murilo','saldanha','muriloklk7@gmail.com','$2b$10$/zdZF17kwdAWLXetiJuQAOyM5Zppi.oOWsoeySUXj4FajUtMs5gJe',0.00,0,'1776282069862-682475734-02177114642405479d39dabdd16daed9e301f9238148b07c39876_0.jpg',12,0,'764581',NULL,0,0,NULL),('3a4edb0e-2f74-4d2f-abfe-b6c0b638b4ec','asdasd','asdasd','jk3oypl8rv2@bseee.okcx.edu.rs','$2b$10$0XdcN0DTIEn250p37RZrOuV4LM4SbDolGuT067v/Zl9FlVejpq3NG',0.00,0,'1776282433649-231631139-IMG_8416.jpeg',12,0,'471175',NULL,0,0,NULL),('484ee4a9-f73f-470c-878d-1be51530b758','aaaaaaaaaaaaa','aaaaaaaaaaaaa','aaaaaaaaaaaaa@gmail.com','$2b$10$jS7HAnOt5xmbfAeqloFkZ.VUe75hA9h.heLTKo9z7cr.JgyTGXFCy',0.00,0,NULL,12,0,'337656',NULL,0,0,NULL),('8344b064-6685-4bae-bd51-dfe6ecfd30e7','aaaaaaaaa','aaaaaaaaa','aaaaaaaaa@gmail.com','$2b$10$eWkcLrNXqIm2C.gbdw7JH.voFszO55xQlWZetZaTEcE.GZc4xoDbO',0.00,0,NULL,12,0,'508907',NULL,0,0,NULL),('8cdc0b76-2798-4955-a328-a6f273ba5082','murilo1','murilo1','murilo1@gmail.com','$2b$10$oL/TcJcVuJJeGTSWs3C9O.U/eURHh8zvaOzn7ap4KWPfkddEkBBD6',14.00,0,'1778951168581-383719566.png',12,1,NULL,NULL,0,0,NULL),('a7ee4110-77b2-4cc1-8024-81071a4b4f47','murilo12','murilo12','murilo12@gmail.com','$2b$10$T8MxW6Bf9Rhy1OPmnXkk2u2UpnkuBtkfkZDDvb3W/3kFPrgAw8SyO',15.00,0,'1780583384970-404097131.png',12,1,NULL,'[]',2,0,'[]'),('b0d48816-f7b9-4a35-b85c-58704438e472','adadada','adadada','adadada@gmail.com','$2b$10$z40zIy2uDmxuIhU.bmm71Oys1m8aOmL2aCP3ryUpDVXTRdZC3CK/W',0.00,0,NULL,1,1,NULL,NULL,0,0,NULL),('bc239595-ee39-4a44-b6de-688d0008f555','gg','gg','gg@gmail.com','$2b$10$zYM/fhwPFGTT6XEQb08TqejcIvvyXjXB/uELrqSddiOkewfe/w1iW',0.00,0,'1771512811439-991525553-115496_0-removebg-preview (1).png',NULL,0,NULL,NULL,0,0,NULL),('e47d2a4b-10ef-4a51-915b-debea572331e','newUser','newUser','newUser@gmail.com','$2b$10$waYSz0yZXNK6UnxIG564m.si0yGgVeV5PbDCEhIeqpj/h6GLSGc1S',3.67,0,'1774858028535-572087450-IMG_6662(1).jpeg',5,0,NULL,NULL,0,0,NULL),('e6f33c1d-6023-4152-96a9-ea9d2055c54d','lolo','alolo','aloalo@gmail.com','$2b$10$T1sbDfxNagoSSmF.oKn6h.8NIxfA1Qx.Mz0JTuyk2d3CSBTNENGAG',0.00,0,'1776435928658-966161635.png',12,0,'377873',NULL,0,0,NULL),('fa4b1676-95a8-4ebc-9e65-c7afe328307c','asdas','asdas','asdas@gmail.com','$2b$10$quNN9VoOcjTyMh5zOdDkw.nbn0Cu3CKHuiSTcQHArEtEkAgvtJ8uC',0.00,0,NULL,12,0,'954871',NULL,0,0,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-10 17:42:42
