-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: acueducto_santander
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Table structure for table `administradores`
--

DROP TABLE IF EXISTS `administradores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administradores` (
  `id_administrador` varchar(10) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `nombre_usuario` varchar(50) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  `id_estado_empleado` varchar(10) DEFAULT NULL,
  `id_rol` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_administrador`),
  KEY `id_rol` (`id_rol`),
  KEY `id_estado_empleado` (`id_estado_empleado`),
  CONSTRAINT `administradores_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles_permisos` (`id_rol`),
  CONSTRAINT `administradores_ibfk_2` FOREIGN KEY (`id_estado_empleado`) REFERENCES `estado_empleados` (`id_estado_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administradores`
--

LOCK TABLES `administradores` WRITE;
/*!40000 ALTER TABLE `administradores` DISABLE KEYS */;
INSERT INTO `administradores` VALUES ('ADMI0001','Juan Lopez','Juan','5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5','EMPL0001','ROL0001'),('ADMI0002','Luis','Luis','c5ff177a86e82441f93e3772da700d5f6838157fa1bfdc0bb689d7f7e55e7aba','EMPL0001','ROL0002'),('ADMI0003','Laura','Laura Sanchez','f0b8649dbd8cc269a6a9f57166490602cb5e17344007e29c1591f6cdad29aa37','EMPL0001','ROL0002'),('ADMI0004','Antonio Suarez','Antonio','1f0ca711df81520887afe0dca099652a249e7eda60348be7327d432b02298652','EMPL0001','ROL0003'),('ADMI0005','Camila Ruiz','Camila','80d161545383dd77c8703ec50d566ae19f9f6bb5b68b42b26482f1cdf21bf8f2','EMPL0001','ROL0002'),('ADMI0006','Luisa Zamora','Luisa','06b4f9360e803edbc0baa644a8597068305ec74436267ddafde5dc587a4bffaa','EMPL0001','ROL0003'),('ADMI0007','Daniel Morales','Daniel','27b499d70e54747b8dbdf1e8149c9a80885b67bc328b39e70b038d8729039218','EMPL0001','ROL0001'),('ADMI0008','Maria Salazar','Maria','9ff18ebe7449349f358e3af0b57cf7a032c1c6b2272cb2656ff85eb112232f16','EMPL0001','ROL0003'),('ADMI0009','Pedro Gomez','Pedro','a432d817e884eb8bd3953177b68c747b64d8d6a705b79787445750bf80fe55b6','EMPL0001','ROL0002'),('ADMI0010','Alvaro Sanchez','Alvaro','a1187e822212db0b0f00fda11fa3a4c32fdcff528108f605b91736b48da27ae2','EMPL0001','ROL0001'),('ADMI0011','Lorena Merino','Lorena','a86c261f64d780d7b75bf50e497110843f97f2e379eee18a13b9e26b4ec23872','EMPL0002','ROL0002'),('ADMI0012','Susan Paz','Susan','f6dce2c608ef3fd522dcd3a4ab897f855945309f2d04e64f86e507730137596a','EMPL0001','ROL0003');
/*!40000 ALTER TABLE `administradores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria`
--

DROP TABLE IF EXISTS `auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria` (
  `id_auditoria` varchar(10) NOT NULL,
  `tabla` varchar(50) DEFAULT NULL,
  `id_registro_afectado` varchar(50) DEFAULT NULL,
  `accion` varchar(10) DEFAULT NULL COMMENT 'INSERT, UPDATE, DELETE',
  `id_administrador` varchar(50) DEFAULT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  `detalles` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_auditoria`),
  KEY `id_administrador` (`id_administrador`),
  CONSTRAINT `auditoria_ibfk_1` FOREIGN KEY (`id_administrador`) REFERENCES `administradores` (`id_administrador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria`
--

LOCK TABLES `auditoria` WRITE;
/*!40000 ALTER TABLE `auditoria` DISABLE KEYS */;
INSERT INTO `auditoria` VALUES ('AUDI0001','administradores','ADMI0006','INSERT','ADMI0003','2024-12-26 23:22:25','Se crea usuario por primera vez'),('AUDI0002','administradores','ADMI0007','INSERT','ADMI0003','2024-12-27 20:52:07','Se crea usuario por primera vez'),('AUDI0003','administradores','ADMI0008','INSERT','ADMI0003','2024-12-30 22:14:51','Se crea usuario por primera vez'),('AUDI0004','administradores','ADMI0009','INSERT','ADMI0003','2024-12-30 22:18:42','Se crea usuario por primera vez'),('AUDI0005','administradores','ADMI0010','INSERT','ADMI0003','2024-12-30 22:20:15','Se crea usuario por primera vez'),('AUDI0006','administradores','ADMI0011','INSERT','ADMI0003','2024-12-30 22:40:38','Se crea usuario por primera vez'),('AUDI0007','administradores','ADMI0007','UPDATE','ADMI0003','2025-01-08 22:49:14','Se actualiza la contraseña del usuario'),('AUDI0008','administradores','ADMI0007','UPDATE','ADMI0007','2025-01-08 22:51:45','Se actualiza la contraseña del usuario'),('AUDI0009','administradores','ADMI0007','UPDATE','ADMI0007','2025-01-10 21:22:28','Se actualiza la contraseña del usuario'),('AUDI0010','facturas','FACT0003','INSERT','ADMI0003','2025-01-10 21:23:41','Factura generada para el cliente'),('AUDI0011','facturas','FACT0004','INSERT','ADMI0003','2025-01-10 21:28:25','Factura generada para el cliente'),('AUDI0012','facturas','FACT0005','INSERT','ADMI0003','2025-01-10 21:28:25','Factura generada para el cliente'),('AUDI0013','facturas','FACT0006','INSERT','ADMI0003','2025-01-10 21:28:25','Factura generada para el cliente'),('AUDI0014','facturas','FACT0007','INSERT','ADMI0003','2025-01-10 21:28:25','Factura generada para el cliente'),('AUDI0015','facturas','FACT0008','INSERT','ADMI0003','2025-01-10 21:29:42','Factura generada para el cliente'),('AUDI0016','facturas','FACT0009','INSERT','ADMI0003','2025-01-10 21:29:42','Factura generada para el cliente'),('AUDI0017','facturas','FACT0010','INSERT','ADMI0003','2025-01-10 21:29:42','Factura generada para el cliente'),('AUDI0018','facturas','FACT0011','INSERT','ADMI0003','2025-01-10 21:29:42','Factura generada para el cliente'),('AUDI0019','facturas','FACT0012','INSERT','ADMI0003','2025-01-10 21:32:11','Factura generada para el cliente Luis Carlos Zapata'),('AUDI0020','facturas','FACT0013','INSERT','ADMI0003','2025-01-10 21:32:11','Factura generada para el cliente Andrea Bernal'),('AUDI0021','facturas','FACT0014','INSERT','ADMI0003','2025-01-10 21:32:11','Factura generada para el cliente Pedro Salazar'),('AUDI0022','facturas','FACT0015','INSERT','ADMI0003','2025-01-10 21:32:11','Factura generada para el cliente Laura Pedraza');
/*!40000 ALTER TABLE `auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id_cliente` varchar(10) NOT NULL,
  `tipo_documento` varchar(10) DEFAULT NULL,
  `numero_documento` varchar(50) DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `id_estado_cliente` varchar(10) DEFAULT NULL,
  `id_matricula` varchar(10) DEFAULT NULL,
  `id_tarifa_medidor` varchar(10) DEFAULT NULL,
  `id_tarifa_estandar` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_cliente`),
  KEY `id_direccion` (`direccion`),
  KEY `id_estado_cliente` (`id_estado_cliente`),
  KEY `id_matricula` (`id_matricula`),
  KEY `clientes_ibfk_4_idx` (`id_tarifa_medidor`),
  KEY `clientes_ibfk_5_idx` (`id_tarifa_estandar`),
  CONSTRAINT `clientes_ibfk_2` FOREIGN KEY (`id_estado_cliente`) REFERENCES `estado_clientes` (`id_estado_cliente`),
  CONSTRAINT `clientes_ibfk_3` FOREIGN KEY (`id_matricula`) REFERENCES `matriculas` (`id_matricula`),
  CONSTRAINT `clientes_ibfk_4` FOREIGN KEY (`id_tarifa_medidor`) REFERENCES `tarifa_medidores` (`id_tarifa_medidor`),
  CONSTRAINT `clientes_ibfk_5` FOREIGN KEY (`id_tarifa_estandar`) REFERENCES `tarifas_estandar` (`id_tarifa_estandar`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES ('CLI0001','CC','1092347021','Luis Carlos Zapata','31234','Barrio Centro Cra 24 No 12-54','ESTCLI0001','MATR0001','TARM0001',NULL),('CLI0002','CC','23425466','Andrea Bernal','321456567','Barrio Pedregal','ESTCLI0001','MATR0002',NULL,'TARE0001'),('CLI0003','CC','1322342546','Pedro Salazar','32145346567','Barrio Manzano','ESTCLI0001','MATR0003',NULL,'TARE0001'),('CLI0004','CC','123355664','Laura Pedraza','341343543','Barrio Local','ESTCLI0001','MATR0004',NULL,'TARE0001');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direcciones`
--

DROP TABLE IF EXISTS `direcciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `direcciones` (
  `id_direccion` varchar(10) NOT NULL,
  `descripcion_direccion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_direccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direcciones`
--

LOCK TABLES `direcciones` WRITE;
/*!40000 ALTER TABLE `direcciones` DISABLE KEYS */;
INSERT INTO `direcciones` VALUES ('DIRE0001','Barrio Centro'),('DIRE0002','Barrio Esmeralda');
/*!40000 ALTER TABLE `direcciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `egresos`
--

DROP TABLE IF EXISTS `egresos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `egresos` (
  `id_egreso` varchar(10) NOT NULL,
  `descripcion_egreso` varchar(255) DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `total_egreso` int DEFAULT NULL,
  `fecha_egreso` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_producto` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_egreso`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `egresos_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `inventario` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `egresos`
--

LOCK TABLES `egresos` WRITE;
/*!40000 ALTER TABLE `egresos` DISABLE KEYS */;
/*!40000 ALTER TABLE `egresos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado_clientes`
--

DROP TABLE IF EXISTS `estado_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado_clientes` (
  `id_estado_cliente` varchar(10) NOT NULL,
  `descripcion_cliente` varchar(50) DEFAULT NULL COMMENT 'activo inactivo suspendido',
  `id_multa` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_estado_cliente`),
  KEY `id_multa` (`id_multa`),
  CONSTRAINT `estado_clientes_ibfk_1` FOREIGN KEY (`id_multa`) REFERENCES `multas` (`id_multa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado_clientes`
--

LOCK TABLES `estado_clientes` WRITE;
/*!40000 ALTER TABLE `estado_clientes` DISABLE KEYS */;
INSERT INTO `estado_clientes` VALUES ('ESTCLI0001','Activo',NULL),('ESTCLI0002','Inactivo',NULL),('ESTCLI0003','Suspendido','MULT0001');
/*!40000 ALTER TABLE `estado_clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado_empleados`
--

DROP TABLE IF EXISTS `estado_empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado_empleados` (
  `id_estado_empleado` varchar(10) NOT NULL,
  `descripcion_empleado` varchar(50) DEFAULT NULL COMMENT 'activo inactivo varchar',
  PRIMARY KEY (`id_estado_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado_empleados`
--

LOCK TABLES `estado_empleados` WRITE;
/*!40000 ALTER TABLE `estado_empleados` DISABLE KEYS */;
INSERT INTO `estado_empleados` VALUES ('EMPL0001','activo'),('EMPL0002','inactivo');
/*!40000 ALTER TABLE `estado_empleados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado_facturas`
--

DROP TABLE IF EXISTS `estado_facturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado_facturas` (
  `id_estado_factura` varchar(10) NOT NULL,
  `descripcion_estado_factura` varchar(50) DEFAULT NULL COMMENT 'pendiente pagada vencida',
  PRIMARY KEY (`id_estado_factura`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado_facturas`
--

LOCK TABLES `estado_facturas` WRITE;
/*!40000 ALTER TABLE `estado_facturas` DISABLE KEYS */;
INSERT INTO `estado_facturas` VALUES ('ESTFAC0001','Pendiente'),('ESTFAC0002','Pagada'),('ESTFAC0003','Vencida');
/*!40000 ALTER TABLE `estado_facturas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado_matriculas`
--

DROP TABLE IF EXISTS `estado_matriculas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado_matriculas` (
  `id_estado_matricula` varchar(10) NOT NULL,
  `descripcion_estado_matricula` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_estado_matricula`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado_matriculas`
--

LOCK TABLES `estado_matriculas` WRITE;
/*!40000 ALTER TABLE `estado_matriculas` DISABLE KEYS */;
INSERT INTO `estado_matriculas` VALUES ('ESTMAT0001','Parcial'),('ESTMAT0002','Total');
/*!40000 ALTER TABLE `estado_matriculas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facturas`
--

DROP TABLE IF EXISTS `facturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturas` (
  `id_factura` varchar(10) NOT NULL,
  `fecha_factura` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_vencimiento` datetime DEFAULT NULL,
  `id_cliente` varchar(10) DEFAULT NULL,
  `id_estado_factura` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_factura`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_estado_factura` (`id_estado_factura`),
  CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  CONSTRAINT `facturas_ibfk_2` FOREIGN KEY (`id_estado_factura`) REFERENCES `estado_facturas` (`id_estado_factura`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facturas`
--

LOCK TABLES `facturas` WRITE;
/*!40000 ALTER TABLE `facturas` DISABLE KEYS */;
INSERT INTO `facturas` VALUES ('FACT0001','2025-01-09 22:41:41','2025-01-31 00:00:00','CLI0001','ESTFAC0001'),('FACT0002','2025-01-10 21:16:02','2025-01-31 00:00:00','CLI0001','ESTFAC0001'),('FACT0003','2025-01-10 21:23:41','2025-02-10 21:23:41','CLI0001','ESTFAC0001'),('FACT0004','2025-01-10 21:28:25','2025-02-10 21:28:25','CLI0001','ESTFAC0001'),('FACT0005','2025-01-10 21:28:25','2025-02-10 21:28:25','CLI0002','ESTFAC0001'),('FACT0006','2025-01-10 21:28:25','2025-02-10 21:28:25','CLI0003','ESTFAC0001'),('FACT0007','2025-01-10 21:28:25','2025-02-10 21:28:25','CLI0004','ESTFAC0001'),('FACT0008','2025-01-10 21:29:42','2025-02-10 21:29:42','CLI0001','ESTFAC0001'),('FACT0009','2025-01-10 21:29:42','2025-02-10 21:29:42','CLI0002','ESTFAC0001'),('FACT0010','2025-01-10 21:29:42','2025-02-10 21:29:42','CLI0003','ESTFAC0001'),('FACT0011','2025-01-10 21:29:42','2025-02-10 21:29:42','CLI0004','ESTFAC0001'),('FACT0012','2025-01-10 21:32:11','2025-02-10 21:32:12','CLI0001','ESTFAC0001'),('FACT0013','2025-01-10 21:32:11','2025-02-10 21:32:12','CLI0002','ESTFAC0001'),('FACT0014','2025-01-10 21:32:11','2025-02-10 21:32:12','CLI0003','ESTFAC0001'),('FACT0015','2025-01-10 21:32:11','2025-02-10 21:32:12','CLI0004','ESTFAC0001');
/*!40000 ALTER TABLE `facturas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingresos`
--

DROP TABLE IF EXISTS `ingresos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingresos` (
  `id_ingreso` varchar(10) NOT NULL,
  `descripcion_ingreso` varchar(255) DEFAULT NULL,
  `valor_ingreso` int DEFAULT NULL,
  `fecha_ingreso` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_matricula` varchar(10) DEFAULT NULL,
  `id_multa` varchar(10) DEFAULT NULL,
  `id_pago` varchar(10) DEFAULT NULL,
  `id_producto` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_ingreso`),
  KEY `id_pago` (`id_pago`),
  KEY `id_multa` (`id_multa`),
  KEY `id_producto` (`id_producto`),
  KEY `id_matricula` (`id_matricula`),
  CONSTRAINT `ingresos_ibfk_1` FOREIGN KEY (`id_pago`) REFERENCES `pagos` (`id_pago`),
  CONSTRAINT `ingresos_ibfk_2` FOREIGN KEY (`id_multa`) REFERENCES `multas` (`id_multa`),
  CONSTRAINT `ingresos_ibfk_4` FOREIGN KEY (`id_producto`) REFERENCES `inventario` (`id_producto`),
  CONSTRAINT `ingresos_ibfk_5` FOREIGN KEY (`id_matricula`) REFERENCES `matriculas` (`id_matricula`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingresos`
--

LOCK TABLES `ingresos` WRITE;
/*!40000 ALTER TABLE `ingresos` DISABLE KEYS */;
INSERT INTO `ingresos` VALUES ('ING0001','Mesa oficina',200000,'2024-12-18 22:38:14',NULL,NULL,NULL,'PROD0001'),('ING0002','Computador para gerente',1500000,'2024-12-18 22:38:14',NULL,NULL,NULL,'PROD0002');
/*!40000 ALTER TABLE `ingresos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `id_producto` varchar(10) NOT NULL,
  `descripcion_producto` varchar(255) DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `valor_producto` int DEFAULT NULL,
  `fecha_producto` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
INSERT INTO `inventario` VALUES ('PROD0001','Escoba',2,10000,'2024-12-18 22:36:11'),('PROD0002','Computador',3,1500000,'2024-12-18 22:37:01'),('PROD0003','Mesa',2,200000,'2024-12-18 22:37:01');
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matriculas`
--

DROP TABLE IF EXISTS `matriculas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matriculas` (
  `id_matricula` varchar(10) NOT NULL,
  `numero_matricula` int DEFAULT NULL,
  `valor_matricula` int DEFAULT NULL,
  `id_estado_matricula` varchar(10) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_matricula`),
  KEY `id_estado_matricula` (`id_estado_matricula`),
  CONSTRAINT `matriculas_ibfk_1` FOREIGN KEY (`id_estado_matricula`) REFERENCES `estado_matriculas` (`id_estado_matricula`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matriculas`
--

LOCK TABLES `matriculas` WRITE;
/*!40000 ALTER TABLE `matriculas` DISABLE KEYS */;
INSERT INTO `matriculas` VALUES ('MATR0001',40001,20000,'ESTMAT0002','2025-01-08 22:38:40'),('MATR0002',23456,20000,'ESTMAT0001','2025-01-08 23:38:40'),('MATR0003',23445,20000,'ESTMAT0001','2025-01-08 23:39:25'),('MATR0004',NULL,20000,'ESTMAT0001','2025-01-08 23:39:25');
/*!40000 ALTER TABLE `matriculas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `multas`
--

DROP TABLE IF EXISTS `multas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `multas` (
  `id_multa` varchar(10) NOT NULL,
  `motivo_multa` varchar(255) DEFAULT NULL,
  `valor_multa` int DEFAULT NULL,
  PRIMARY KEY (`id_multa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `multas`
--

LOCK TABLES `multas` WRITE;
/*!40000 ALTER TABLE `multas` DISABLE KEYS */;
INSERT INTO `multas` VALUES ('MULT0001','Pago atrasado',5000),('MULT0002','Daño medidor',4000);
/*!40000 ALTER TABLE `multas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos` (
  `id_pago` varchar(10) NOT NULL,
  `valor_pagado` int DEFAULT NULL,
  `metodo_pago` varchar(10) DEFAULT NULL,
  `id_factura` varchar(10) DEFAULT NULL,
  `id_estado_pago` varchar(10) DEFAULT NULL,
  `fecha_pago` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pago`),
  KEY `id_factura` (`id_factura`),
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id_factura`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_permisos`
--

DROP TABLE IF EXISTS `roles_permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles_permisos` (
  `id_rol` varchar(10) NOT NULL,
  `tipo_rol` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_permisos`
--

LOCK TABLES `roles_permisos` WRITE;
/*!40000 ALTER TABLE `roles_permisos` DISABLE KEYS */;
INSERT INTO `roles_permisos` VALUES ('ROL0001','administrador'),('ROL0002','auxiliar'),('ROL0003','contador');
/*!40000 ALTER TABLE `roles_permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarifa_medidores`
--

DROP TABLE IF EXISTS `tarifa_medidores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarifa_medidores` (
  `id_tarifa_medidor` varchar(10) NOT NULL,
  `lectura_actual` int DEFAULT NULL,
  `fecha_lectura` datetime DEFAULT CURRENT_TIMESTAMP,
  `costo_metro3` int DEFAULT NULL,
  `valor_total_lectura` int DEFAULT NULL,
  `lectura_anterior` int DEFAULT NULL,
  `fecha_ultima_lectura` datetime DEFAULT NULL,
  PRIMARY KEY (`id_tarifa_medidor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarifa_medidores`
--

LOCK TABLES `tarifa_medidores` WRITE;
/*!40000 ALTER TABLE `tarifa_medidores` DISABLE KEYS */;
INSERT INTO `tarifa_medidores` VALUES ('TARM0001',23,'2024-12-18 21:59:28',1500,34500,10,'2024-11-17 00:00:00'),('TARM0002',34,'2024-12-20 22:26:05',1500,51000,10,'2024-12-30 00:00:00');
/*!40000 ALTER TABLE `tarifa_medidores` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `calcular_total_lectura` BEFORE INSERT ON `tarifa_medidores` FOR EACH ROW BEGIN
    -- Calcular el total antes de insertar
    SET NEW.valor_total_lectura = NEW.lectura_actual* NEW.costo_metro3;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tarifas_estandar`
--

DROP TABLE IF EXISTS `tarifas_estandar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarifas_estandar` (
  `id_tarifa_estandar` varchar(10) NOT NULL,
  `descripcion` varchar(50) DEFAULT NULL,
  `tarifa_definida` int DEFAULT NULL,
  `fecha_inicio_tarifa` datetime DEFAULT NULL,
  `fecha_final_tarifa` datetime DEFAULT NULL,
  PRIMARY KEY (`id_tarifa_estandar`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarifas_estandar`
--

LOCK TABLES `tarifas_estandar` WRITE;
/*!40000 ALTER TABLE `tarifas_estandar` DISABLE KEYS */;
INSERT INTO `tarifas_estandar` VALUES ('TARE0001','Finca',50000,'2024-12-18 00:00:00','2025-12-18 00:00:00'),('TARE0002','Marranera',40000,'2024-12-18 00:00:00','2025-12-18 00:00:00'),('TARE0003','Quesera',45000,'2024-12-18 00:00:00','2025-12-18 00:00:00'),('TARE0004','Matadero',55000,'2024-12-18 00:00:00','2025-12-18 00:00:00');
/*!40000 ALTER TABLE `tarifas_estandar` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-11 17:24:26
