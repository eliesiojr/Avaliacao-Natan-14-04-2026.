-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: escola
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alunos_campus_anapolis`
--

DROP TABLE IF EXISTS `alunos_campus_anapolis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alunos_campus_anapolis` (
  `id_aluno` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  `sexo` char(1) NOT NULL,
  `data_nascimento` date NOT NULL,
  `campus` varchar(50) DEFAULT 'Anápolis',
  PRIMARY KEY (`id_aluno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alunos_campus_anapolis`
--

LOCK TABLES `alunos_campus_anapolis` WRITE;
/*!40000 ALTER TABLE `alunos_campus_anapolis` DISABLE KEYS */;
INSERT INTO `alunos_campus_anapolis` VALUES (6,'Fernanda Alves','F','2003-01-05','Anápolis'),(7,'Gustavo Rocha','M','1998-12-12','Anápolis'),(8,'Helena Ribeiro','F','2000-04-18','Anápolis'),(9,'Igor Mendes','M','2001-09-09','Anápolis'),(10,'Juliana Martins','F','2002-06-20','Anápolis');
/*!40000 ALTER TABLE `alunos_campus_anapolis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alunos_campus_goianesia`
--

DROP TABLE IF EXISTS `alunos_campus_goianesia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alunos_campus_goianesia` (
  `id_aluno` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  `sexo` char(1) NOT NULL,
  `data_nascimento` date NOT NULL,
  `campus` varchar(50) DEFAULT 'Goianésia',
  PRIMARY KEY (`id_aluno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alunos_campus_goianesia`
--

LOCK TABLES `alunos_campus_goianesia` WRITE;
/*!40000 ALTER TABLE `alunos_campus_goianesia` DISABLE KEYS */;
INSERT INTO `alunos_campus_goianesia` VALUES (1,'Ana Silva','F','2001-05-14','Goianésia'),(2,'Bruno Souza','M','2000-08-22','Goianésia'),(3,'Carlos Eduardo','M','1999-11-30','Goianésia'),(4,'Daniela Costa','F','2002-02-10','Goianésia'),(5,'Eduardo Lima','M','2001-07-25','Goianésia');
/*!40000 ALTER TABLE `alunos_campus_goianesia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curso_disciplina`
--

DROP TABLE IF EXISTS `curso_disciplina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curso_disciplina` (
  `Id_curso_disciplina` int NOT NULL AUTO_INCREMENT,
  `id_disciplina` int NOT NULL,
  `id_cursos` int NOT NULL,
  PRIMARY KEY (`Id_curso_disciplina`),
  UNIQUE KEY `id_disciplina` (`id_disciplina`,`id_cursos`),
  KEY `id_cursos` (`id_cursos`),
  CONSTRAINT `curso_disciplina_ibfk_1` FOREIGN KEY (`id_disciplina`) REFERENCES `disciplina` (`id_disciplina`),
  CONSTRAINT `curso_disciplina_ibfk_2` FOREIGN KEY (`id_cursos`) REFERENCES `cursos` (`id_cursos`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curso_disciplina`
--

LOCK TABLES `curso_disciplina` WRITE;
/*!40000 ALTER TABLE `curso_disciplina` DISABLE KEYS */;
INSERT INTO `curso_disciplina` VALUES (1,1,1),(2,2,1),(3,3,1),(6,4,5),(7,5,6),(8,6,7),(4,7,1),(5,8,2),(9,9,9),(10,10,4);
/*!40000 ALTER TABLE `curso_disciplina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cursos`
--

DROP TABLE IF EXISTS `cursos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cursos` (
  `id_cursos` int NOT NULL AUTO_INCREMENT,
  `nome_curso` varchar(100) NOT NULL,
  PRIMARY KEY (`id_cursos`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursos`
--

LOCK TABLES `cursos` WRITE;
/*!40000 ALTER TABLE `cursos` DISABLE KEYS */;
INSERT INTO `cursos` VALUES (1,'CC'),(2,'Engenharia de Software'),(3,'Sistemas de Informação'),(4,'Administração'),(5,'Direito'),(6,'Medicina'),(7,'Engenharia Civil'),(8,'Arquitetura'),(9,'Psicologia'),(10,'Matemática');
/*!40000 ALTER TABLE `cursos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disciplina`
--

DROP TABLE IF EXISTS `disciplina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disciplina` (
  `id_disciplina` int NOT NULL AUTO_INCREMENT,
  `nome_disciplina` varchar(30) NOT NULL,
  `vagas` int DEFAULT '10',
  PRIMARY KEY (`id_disciplina`),
  CONSTRAINT `chk_vagas_positivo` CHECK ((`vagas` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disciplina`
--

LOCK TABLES `disciplina` WRITE;
/*!40000 ALTER TABLE `disciplina` DISABLE KEYS */;
INSERT INTO `disciplina` VALUES (1,'Banco de Dados',8),(2,'Algoritmos e Lógica',10),(3,'Cálculo I',10),(4,'Direito Penal',10),(5,'Anatomia Humana',10),(6,'Física I',10),(7,'Estruturas de Dados',10),(8,'Engenharia de Requisitos',10),(9,'Psicologia Cognitiva',10),(10,'Gestão de Projetos',10);
/*!40000 ALTER TABLE `disciplina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matricula`
--

DROP TABLE IF EXISTS `matricula`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matricula` (
  `id_matricula` int NOT NULL AUTO_INCREMENT,
  `data_matricula` date NOT NULL,
  `semestre` varchar(6) NOT NULL,
  `id_aluno` int NOT NULL,
  `id_cursos` int NOT NULL,
  PRIMARY KEY (`id_matricula`),
  UNIQUE KEY `semestre` (`semestre`,`id_aluno`,`id_cursos`),
  KEY `id_cursos` (`id_cursos`),
  CONSTRAINT `matricula_ibfk_1` FOREIGN KEY (`id_cursos`) REFERENCES `cursos` (`id_cursos`)
) ENGINE=InnoDB AUTO_INCREMENT=256777 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matricula`
--

LOCK TABLES `matricula` WRITE;
/*!40000 ALTER TABLE `matricula` DISABLE KEYS */;
INSERT INTO `matricula` VALUES (1,'2026-02-01','2026.1',1,1),(2,'2026-02-02','2026.1',2,1),(3,'2026-02-03','2026.1',3,2),(4,'2026-02-04','2026.1',4,5),(5,'2026-02-05','2026.1',5,6),(6,'2026-02-06','2026.1',6,1),(7,'2026-02-07','2026.1',7,7),(8,'2026-02-08','2026.1',8,9),(9,'2026-02-09','2026.1',9,4),(10,'2026-02-10','2026.1',10,1),(5353,'2026-04-14','2027.1',1,1),(256776,'2026-04-14','2026.2',1,1);
/*!40000 ALTER TABLE `matricula` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_alunos_global`
--

DROP TABLE IF EXISTS `vw_alunos_global`;
/*!50001 DROP VIEW IF EXISTS `vw_alunos_global`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alunos_global` AS SELECT 
 1 AS `id_aluno`,
 1 AS `nome`,
 1 AS `sexo`,
 1 AS `data_nascimento`,
 1 AS `campus`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_alunos_global`
--

/*!50001 DROP VIEW IF EXISTS `vw_alunos_global`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alunos_global` AS select `alunos_campus_goianesia`.`id_aluno` AS `id_aluno`,`alunos_campus_goianesia`.`nome` AS `nome`,`alunos_campus_goianesia`.`sexo` AS `sexo`,`alunos_campus_goianesia`.`data_nascimento` AS `data_nascimento`,`alunos_campus_goianesia`.`campus` AS `campus` from `alunos_campus_goianesia` union all select `alunos_campus_anapolis`.`id_aluno` AS `id_aluno`,`alunos_campus_anapolis`.`nome` AS `nome`,`alunos_campus_anapolis`.`sexo` AS `sexo`,`alunos_campus_anapolis`.`data_nascimento` AS `data_nascimento`,`alunos_campus_anapolis`.`campus` AS `campus` from `alunos_campus_anapolis` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-14 19:51:42
