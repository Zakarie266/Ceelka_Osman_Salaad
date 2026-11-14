-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 18, 2022 at 04:22 PM
-- Server version: 10.4.19-MariaDB
-- PHP Version: 8.0.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `water_billing_system`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `accoun_statement_sp` (IN `_acc_id` INT, IN `_from` DATE, IN `_to` DATE)  BEGIN
if(_to ='0000-00-00')THEN
SET _to = now();

END IF;
CREATE TEMPORARY TABLE statement(date date, accoun text,charge double,receipt double);

INSERT INTO statement
SELECT r.month_date,'Receipt',r.amount,0
FROM accoun a  
JOIN receipt r ON a.acc_id=r.to_acc
WHERE a.acc_id=_acc_id AND r.month_date BETWEEN _from AND _to;



INSERT INTO statement
SELECT p.month_date,'Payment',0,p.amoun_pay
FROM accoun a
JOIN payment p ON a.acc_id=p.from_acc
WHERE a.acc_id=_acc_id AND p.month_date BETWEEN _from AND _to;


INSERT INTO statement
SELECT sp.month_date,'Salary',0,sp.salary
FROM accoun a
JOIN salarypayment sp ON a.acc_id=sp.from_acc
WHERE a.acc_id=_acc_id AND sp.month_date BETWEEN _from AND _to;



CREATE TEMPORARY TABLE statement2 SELECT * FROM statement ORDER BY date ASC;

SET @sum = 0;

SELECT date,accoun,charge,receipt,(CASE WHEN charge>0 THEN @sum := @sum + (charge) 
ELSE @sum := @sum - (receipt) END)Balance FROM statement2


UNION
SELECT '','TOTAL',SUM(charge),SUM(receipt),SUM(charge) - SUM(receipt)  FROM statement2;

DROP TABLE statement2;
DROP TABLE statement;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Customer_statement_sp` (IN `_cust_id` INT, IN `_from` DATE, IN `_to` DATE)  BEGIN
if(_to ='0000-00-00')THEN
SET _to = now();

END IF;
CREATE TEMPORARY TABLE statement(date date, Customer text,charge float,receipt float);

INSERT INTO statement
SELECT reg_date,'Resto Hore',round(fee,2),0 
FROM customer c 
JOIN invoice i ON c.cust_id=i.cust_id 
WHERE c.cust_id=_cust_id AND i.month_data BETWEEN _from AND _to;

INSERT INTO statement
SELECT i.month_data,'Charge',round(i.balance,2),0 
FROM customer c 
JOIN invoice i ON c.cust_id=i.cust_id 
WHERE c.cust_id=_cust_id AND i.month_data BETWEEN _from AND _to;



INSERT INTO statement
SELECT r.month_date,'Receipt',0,round(r.amount+r.discount,2)
FROM customer c 
JOIN receipt r ON c.cust_id=r.cust_id 
WHERE c.cust_id=_cust_id AND r.month_date BETWEEN _from AND _to;

CREATE TEMPORARY TABLE statement2 SELECT * FROM statement ORDER BY date ASC;

SET @sum = 0;

SELECT date,Customer,charge,receipt,(CASE WHEN charge>0 THEN @sum := @sum + (charge) 
ELSE @sum := @sum - (receipt) END)Balance FROM statement2


UNION
SELECT '','TOTAL',SUM(charge),SUM(receipt),SUM(charge) - SUM(receipt)  FROM statement2;

DROP TABLE statement2;
DROP TABLE statement;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cust_balanceGreaterThanZero_sp` (IN `_from` DATE, IN `_to` TEXT)  BEGIN
if(_to ='0000-00-00')THEN
SET _to = now();

END IF;
CREATE TEMPORARY TABLE statement(date date,cust_id int, Customer text,charge double);

INSERT INTO statement
SELECT r.month_date,c.cust_id,c.CustomerName,r.remainder
FROM customer c JOIN receipt r ON c.cust_id = r.cust_id
WHERE r.remainder >0 
AND r.month_date BETWEEN _from AND _to;
 



CREATE TEMPORARY TABLE statement2 SELECT * FROM statement ORDER BY date ASC;



SELECT * FROM statement2;



DROP TABLE statement2;
DROP TABLE statement;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cust_balanceZeroAndLess_sp` (IN `_from` DATE, IN `_to` DATE)  BEGIN
if(_to ='0000-00-00')THEN
SET _to = now();

END IF;
CREATE TEMPORARY TABLE statement(date date,cust_id int, Customer text,charge double);

INSERT INTO statement
SELECT r.month_date,c.cust_id,c.CustomerName,r.remainder
FROM customer c JOIN receipt r ON c.cust_id = r.cust_id
WHERE r.remainder <=0 
AND r.month_date BETWEEN _from AND _to;
 



CREATE TEMPORARY TABLE statement2 SELECT * FROM statement ORDER BY date ASC;



SELECT * FROM statement2;



DROP TABLE statement2;
DROP TABLE statement;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `messageWithoutResto_sp` (IN `_from` DATE, IN `_to` DATE)  BEGIN
if(_to ='0000-00-00')THEN
SET _to = now();

END IF;
CREATE TEMPORARY TABLE statement(date date,cust_id int, Customer text,tell int,mhore int,mdanbe int,farqi int,rate float,charge float);

INSERT INTO statement
SELECT i.month_data,c.cust_id,c.CustomerName,c.contact,
i.mchore,i.mcdanbe,i.farqi,i.rate,i.balance
FROM customer c JOIN invoice i ON c.cust_id = i.cust_id
WHERE i.month_data BETWEEN _from AND _to

AND i.balance = c.fee;
 



CREATE TEMPORARY TABLE statement2 SELECT * FROM statement ORDER BY date ASC;



SELECT * FROM statement2;


DROP TABLE statement2;
DROP TABLE statement;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `messageWithResto_sp` (IN `_from` DATE, IN `_to` DATE)  BEGIN
if(_to ='0000-00-00')THEN
SET _to = now();

END IF;
CREATE TEMPORARY TABLE statement(date date,cust_id int, Customer text,tell int,mhore int,mdanbe int,farqi int,rate float,charge float,resto float,balance float);

INSERT INTO statement
SELECT i.month_data,c.cust_id,c.CustomerName,c.contact,
i.mchore,i.mcdanbe,i.farqi,i.rate,i.balance,
(CASE WHEN i.balance<c.fee THEN (c.fee-i.balance) 
ELSE '' END),c.fee
FROM customer c JOIN invoice i ON c.cust_id = i.cust_id
WHERE i.month_data BETWEEN _from AND _to

AND i.balance<c.fee;
 



CREATE TEMPORARY TABLE statement2 SELECT * FROM statement ORDER BY date ASC;



SELECT * FROM statement2;


DROP TABLE statement2;
DROP TABLE statement;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `accoun`
--

CREATE TABLE `accoun` (
  `acc_id` int(11) NOT NULL,
  `acc_no` int(11) NOT NULL,
  `acc_name` varchar(50) DEFAULT NULL,
  `acc_type` varchar(50) DEFAULT NULL,
  `balance` int(11) DEFAULT NULL,
  `reg_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accoun`
--

INSERT INTO `accoun` (`acc_id`, `acc_no`, `acc_name`, `acc_type`, `balance`, `reg_date`) VALUES
(1, 1, 'E.V.C Plus', 'Number', 5990, '2021-12-01');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `cust_id` int(11) NOT NULL,
  `CustomerName` varchar(50) DEFAULT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `zone` varchar(50) DEFAULT NULL,
  `MeterCube` int(11) NOT NULL,
  `fee` float NOT NULL,
  `reg_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`cust_id`, `CustomerName`, `contact`, `zone`, `MeterCube`, `fee`, `reg_date`) VALUES
(1, 'Shamsudiin Macalin Aadan', '615733939', 'deriska ceelka', 371, 42.9, '2022-01-01'),
(2, 'Shamsu Diin Macalin Aadan', '61', 'deriska ceelka', 0, 0, '2022-01-01'),
(3, 'Ayaan Xasan Macalin', '61', 'deriska ceelka', 606, 15.6, '2022-01-01'),
(4, 'Xaawo Bire Nuur', '61', 'deriska ceelka', 164, 16.9, '2022-01-01'),
(5, 'Liiban Cali Calas', '61', 'deriska ceelka', 18, 0, '2022-01-01'),
(6, 'C/risaq Cusman Maxamud', '61', 'deriska ceelka', 284, 106.6, '2022-01-01'),
(7, 'Xaliimo Dable Nuur', '61', 'deriska ceelka', 3084, 132.6, '2022-01-01'),
(8, 'Xaliimo Dable Nuur', '61', 'deriska ceelka', 1286, 32.1, '2022-01-01'),
(9, 'Cabdi Salaad Jaamac', '61', 'Deriska Ceelka', 1095, 0, '2022-01-01'),
(10, 'Duraan Xaashi Af-dhuub', '61', 'Deriska Ceelka', 637, 0, '2022-01-01'),
(11, 'C/laahi Saciid Salaad', '61', 'Deriska Ceelka', 327, 0, '2022-01-01'),
(12, 'Cabdi Diini Cigaal', '61', 'Deriska Ceelka', 1865, 307.4, '2022-01-01'),
(13, 'Fadumo Maxamed Nuur', '61', 'Deriska Ceelka', 8, 41.6, '2022-01-01'),
(14, 'Batuulo Maquulo Kulmiye', '61', 'Deriska Ceelka', 1404, -0.1, '2022-01-01'),
(15, 'Maxamed Muqtar Dhooley', '61', 'Deriska Ceelka', 510, 0, '2022-01-01'),
(16, 'Cabdi Warsame Cabdule', '61', 'Deriska Ceelka', 199, 0.1, '2022-01-01'),
(17, 'Safiyo Axmed Samatar', '61', 'Deriska Ceelka', 137, 0, '2022-01-01'),
(18, 'Sahro Maxamud Siyaad', '61', 'Deriska Ceelka', 32, 0.000000357628, '2022-01-01'),
(19, 'Cibaado Xuseen Cali', '61', 'Deriska Ceelka', 1072, 0.000000715256, '2022-01-01'),
(20, 'Fadumo Cismaan Warsame', '61', 'Deriska Ceelka', 225, 0, '2022-01-01'),
(21, 'Abuukar Shiikh Yusuf', '61', 'Deriska Ceelka', 1435, 0.00000286102, '2022-01-01'),
(22, 'Cali Maxamed Kaahiye', '61', 'Deriska Ceelka', 128, 0.000000476837, '2022-01-01'),
(23, 'Cabdi Xasan Macalin', '61', 'Deriska Ceelka', 944, 0.00000037998, '2022-01-01'),
(24, 'Raxmo Abdulahi Maxamed', '61', 'Deriska Ceelka', 2, 0, '2022-01-01'),
(25, 'Jamaad Faarax Barqadle', '61', 'Deriska Ceelka', 701, -0.1, '2022-01-01'),
(26, 'C/laahi Xaashi Raage', '61', 'Deriska Ceelka', 421, -0.000000193715, '2022-01-01'),
(27, 'Faadumo Canshuur Cadoow', '61', 'Deriska Ceelka', 743, -0.0999999, '2022-01-01'),
(28, 'Foosiyo Yusuf Waal', '61', 'Deriska Ceelka', 616, 0, '2022-01-01'),
(29, 'Bashiir Maxamud Hilowle', '61', 'Deriska Ceelka', 395, -1.1, '2022-01-01'),
(30, 'Cali Guuled ', '61', 'Deriska Ceelka', 201, 0.000000178814, '2022-01-01'),
(31, 'Saciid Abuukar', '61', 'Deriska Ceelka', 139, 0, '2022-01-01'),
(32, 'Qadiijo Shiikh C/laahi', '61', 'Deriska Ceelka', 1162, -0.000000476837, '2022-01-01'),
(33, 'Xaliimo Maxamed Suleyman', '61', 'Deriska Ceelka', 239, -0.0000000968575, '2022-01-01'),
(34, 'Calas Axmed Cali ', '61', 'Deriska Ceelka', 1766, 0, '2022-01-01'),
(35, 'C/raxiin Adan Weheliye', '61', 'Deriska Ceelka', 185, 0, '2022-01-01'),
(36, 'Xabiibo Macalin Xuseen', '61', 'Deriska Ceelka', 1148, 0, '2022-01-01'),
(37, 'Feysal Maxamud Qacle', '61', 'Deriska Ceelka', 29, 20.8, '2022-01-01'),
(38, 'Xasan Ayaanle Cosoble', '61', 'Deriska Ceelka', 360, 0.00000037998, '2022-01-01'),
(39, 'Shariif Axmed Cali', '61', 'Deriska Ceelka', 35, 0, '2022-01-01'),
(40, 'Xaawo Maxamud Farax', '61', 'Deriska Ceelka', 233, 0, '2022-01-01'),
(41, 'Shiikh Cabdu Laahi', '61', 'Deriska Ceelka', 253, 20.8, '2022-01-01'),
(42, 'Maxamed Cali Jiisow', '61', 'Deriska Ceelka', 713, 32.5, '2022-01-01'),
(43, 'Sahro Maxamud Siyaad', '61', 'Deriska Ceelka', 1425, 0, '2022-01-01'),
(44, 'C/rashiid Maxamed Faarax', '61', 'Deriska Ceelka', 281, -1.3, '2022-01-01'),
(45, 'C/rashiid Axmed Kheyre', '61', 'Deriska Ceelka', 574, -1.4, '2022-01-01'),
(46, 'Malyuun Cali Diiriye', '61', 'Deriska Ceelka', 569, -0.000000238419, '2022-01-01'),
(47, 'Cabdi Yare Maxamed Xasan', '61', 'Deriska Ceelka', 965, 49.4, '2022-01-01'),
(48, 'Hodan Maxamed Maxamud', '61', 'Deriska Ceelka', 151, 1.3, '2022-01-01'),
(49, 'Faadumo Maxamed Warsame', '61', 'Deriska Ceelka', 98, 0, '2022-01-01'),
(50, 'Shuceeyb C/laahi Maxamed', '61', 'Deriska Ceelka', 488, -0.2, '2022-01-01'),
(51, 'Maryan Diirye Giije', '61', 'Deriska Ceelka', 346, 26, '2022-01-01'),
(52, 'Caabiyo Maxamed Cali', '61', 'Deriska Ceelka', 36, -0.000000715256, '2022-01-01'),
(53, 'C/kariin Gesey ', '61', 'Deriska Ceelka', 228, 0.000000178814, '2022-01-01'),
(54, 'Caga Dhaqato', '61', 'Deriska Ceelka', 147, 0, '2022-01-01'),
(55, 'Macalin Ciro Guumbe', '61', 'Deriska Ceelka', 664, 0, '2022-01-01'),
(56, 'Khadiijo Samatar Axmed', '61', 'Deriska Ceelka', 8, -0.00000038743, '2022-01-01'),
(57, 'Dhug Dhug Le', '61', 'Deriska Ceelka', 27, 0.000000357628, '2022-01-01'),
(58, 'Siraad Cabdi Ismaciil', '61', 'Deriska Ceelka', 13, -0.00000038743, '2022-01-01'),
(59, 'Axmed Jimcaale', '61', 'Deriska Ceelka', 228, 0.00000037998, '2022-01-01'),
(60, 'Maxamed Yusuf Shiikh Cilmi', '61', 'Deriska Ceelka', 48, 13, '2022-01-01'),
(61, 'C/laahi Saciid Salaad', '61', 'Deriska Ceelka', 1724, -0.00000077486, '2022-01-01'),
(62, 'Cabdi Cilmi Sabriye', '61', 'Deriska Ceelka', 914, 0.000000759959, '2022-01-01'),
(63, 'Caasho Maxamed Cilmi', '61', 'Deriska Ceelka', 642, 0.000000953674, '2022-01-01'),
(64, 'Safiyo Maxamed Kulan', '61', 'Deriska Ceelka', 144, 0, '2022-01-01'),
(65, 'C/naasir Maxamed Xirsi', '61', 'Deriska Ceelka', 315, -0.000000193715, '2022-01-01'),
(66, 'Caasho Maxamed Cilmi', '61', 'Deriska Ceelka', 1783, 31.2, '2022-01-01'),
(67, 'Raxmo Cali', '61', 'Deriska Ceelka', 425, -0.000000357628, '2022-01-01'),
(68, 'Faadumo Jaamac Warsame', '61', 'Deriska Ceelka', 1273, 0, '2022-01-01'),
(69, 'Maxamed Yusuf Cabdulle', '61', 'Deriska Ceelka', 491, 0, '2022-01-01'),
(70, 'Xaawo Xirsi Faarax', '61', 'Deriska Ceelka', 782, 0.00000143051, '2022-01-01'),
(71, 'Canab Cali Cigaal', '61', 'Deriska Ceelka', 1056, 9.1, '2022-01-01'),
(72, 'Shiikh Xasan Guure', '61', 'Deriska Ceelka', 316, -0.000000357628, '2022-01-01'),
(73, 'Cabdi Seerar Cali', '61', 'Deriska Ceelka', 1260, 0.00000037998, '2022-01-01'),
(74, 'C/kariin Maxamud Xasan', '61', 'Deriska Ceelka', 980, -0.000000357628, '2022-01-01'),
(75, 'Siraad Cabdi  ', '61', 'Deriska Ceelka', 290, 19.5, '2022-01-01'),
(76, 'Warsame Cabdulle Yusuf', '61', 'Deriska Ceelka', 901, 0.00000077486, '2022-01-01'),
(77, 'Cabdi Jaamac', '61', 'Deriska Ceelka', 1106, 0, '2022-01-01'),
(78, 'Faadumo Ciise Yusuf', '61', 'Deriska Ceelka', 1543, -0.000000193715, '2022-01-01'),
(79, 'Faadumo Maxamed Warsame', '61', 'Deriska Ceelka', 321, 0, '2022-01-01'),
(80, 'Xaliimo Xayir Daynab', '61', 'Deriska Ceelka', 291, 0, '2022-01-01'),
(81, 'Luul Maxamud Jimcale', '61', 'Deriska Ceelka', 176, 0.000000476837, '2022-01-01'),
(82, 'Xasan Diiriye Geedi', '61', 'Deriska Ceelka', 955, -1, '2022-01-01'),
(83, 'Daahir Maxamed Cabdi', '61', 'Deriska Ceelka', 430, -0.000000715256, '2022-01-01'),
(84, 'Mahad Cabdi Seerar', '61', 'Deriska Ceelka', 241, 31.2, '2022-01-01'),
(85, 'Ruqiyo Idiris Cumar', '61', 'Deriska Ceelka', 988, 0.000000715256, '2022-01-01'),
(86, 'Cali Axmed Nuur', '61', 'Deriska Ceelka', 911, -0.000000357628, '2022-01-01'),
(87, 'Faadumo Maxamed Warsame', '61', 'Deriska Ceelka', 537, -0.0999999, '2022-01-01'),
(88, 'Duraan Xaashi Cali', '61', 'Deriska Ceelka', 167, -0.00000038743, '2022-01-01'),
(89, 'Boosteeye Shiikh C/kariin', '61', 'Deriska Ceelka', 170, 14.3, '2022-01-01'),
(90, 'Maxamed Cismaan Kulmiye', '61', 'Deriska Ceelka', 1824, -0.00000238419, '2022-01-01'),
(91, 'Ismaaciil Maxamed Maxamud', '61', 'Deriska Ceelka', 634, 28.6, '2022-01-01'),
(92, 'Muhiyo Cali Maxamed', '61', 'Deriska Ceelka', 1347, 0.000000715256, '2022-01-01'),
(93, 'Yuusuf Raage Baroow', '61', 'Deriska Ceelka', 74, 0.00000037998, '2022-01-01'),
(94, 'Cabdi Axmed Diiriye', '61', 'Deriska Ceelka', 84, 0.000000178814, '2022-01-01'),
(95, 'C/raxman Maxamud Qayliye', '61', 'Deriska Ceelka', 807, -0.00000038743, '2022-01-01'),
(96, 'Qadiijo Ciise Samatar', '61', 'Deriska Ceelka', 1651, 0, '2022-01-01'),
(97, 'Haweeyo Qaliif Xasan', '61', 'Deriska Ceelka', 424, -0.000000476837, '2022-01-01'),
(98, 'Xaaji Qaliif Xasan', '61', 'Deriska Ceelka', 1125, 10.4, '2022-01-01'),
(99, 'C/laahi Cali Cilmi', '61', 'Deriska Ceelka', 61, 0, '2022-01-01'),
(100, 'Cabdi Cisman Faarax', '61', 'Deriska Ceelka', 123, -7.8, '2022-01-01'),
(101, '', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(102, 'C/kariin Xasan Macalin', '61', 'Deriska Ceelka', 1052, 45.5, '2022-01-01'),
(103, 'Maxamed Maxamud Maxamed', '61', 'Deriska Ceelka', 1643, 0, '2022-01-01'),
(104, 'Siraad Mire Diiriye', '61', 'Deriska Ceelka', 568, 14.3, '2022-01-01'),
(105, 'Farxiyo Aadan Cumar', '61', 'Deriska Ceelka', 283, 10.4, '2022-01-01'),
(106, 'Maxamed Yusuf Shiikh Cilmi', '61', 'Deriska Ceelka', 203, 0, '2022-01-01'),
(107, 'Cabdi Casiis ', '61', 'Deriska Ceelka', 208, 0.000000953674, '2022-01-01'),
(108, 'Aamino Abuukar Xasan', '61', 'Deriska Ceelka', 218, 15.6, '2022-01-01'),
(109, 'Maxamed Aadan Cumar', '61', 'Deriska Ceelka', 131, -0.100001, '2022-01-01'),
(110, 'Ruqiyo Cabdi', '61', 'Deriska Ceelka', 426, 0, '2022-01-01'),
(111, 'Aweys C/laahi C/raxman', '61', 'Deriska Ceelka', 79, -30, '2022-01-01'),
(112, 'Shamso', '61', 'Deriska Ceelka', 1126, 24.7, '2022-01-01'),
(113, 'C/rashid Axmed Qeyre', '61', 'Deriska Ceelka', 1125, 42.9, '2022-01-01'),
(114, 'Sahro C/laahi Xasan', '61', 'Deriska Ceelka', 2313, 27.3, '2022-01-01'),
(115, '', '61', 'Deriska Ceelka', 110, 36.4, '2022-01-01'),
(116, 'C/qadir Nuur Kaahiye', '61', 'Deriska Ceelka', 264, 0, '2022-01-01'),
(117, 'Cabdi Xasan Ducaale', '61', 'Deriska Ceelka', 308, -0.00000038743, '2022-01-01'),
(118, 'Mowliid Cabdi Xasan', '61', 'Deriska Ceelka', 295, 10.4, '2022-01-01'),
(119, 'Abukar Xaaji Muxidiin', '61', 'Deriska Ceelka', 627, -0.000000357628, '2022-01-01'),
(120, 'Cambaro Muxumud', '61', 'Deriska Ceelka', 1140, -0.000000357628, '2022-01-01'),
(121, 'Nuuro Cawaale', '61', 'Deriska Ceelka', 365, 0.00000151992, '2022-01-01'),
(122, 'Mustaf Abashiiq Abu-bakar', '61', 'Deriska Ceelka', 524, 48.1, '2022-01-01'),
(123, 'Fardowso Cali Weheliye', '61', 'Deriska Ceelka', 500, -0.5, '2022-01-01'),
(124, 'Calas Jimcaale Ciyaaye', '61', 'Deriska Ceelka', 844, 88.4, '2022-01-01'),
(125, 'Cali Macalin', '61', 'Deriska Ceelka', 83, -0.00000038743, '2022-01-01'),
(126, 'Farxiyo Axmed', '61', 'Deriska Ceelka', 428, 29.9, '2022-01-01'),
(127, 'Shiikh Cabdu Laahi', '61', 'Deriska Ceelka', 1141, 0.00000077486, '2022-01-01'),
(128, 'Maxamed Cusman Culusow', '61', 'Deriska Ceelka', 215, 0.00000037998, '2022-01-01'),
(129, 'C/naasir Xasan Axmed', '61', 'Deriska Ceelka', 1084, 0, '2022-01-01'),
(130, 'Shiikh Jamac Cumar Aadan', '61', 'Deriska Ceelka', 1857, 85.8, '2022-01-01'),
(131, 'Shiikh Jamac Cumar Aadan', '61', 'Deriska Ceelka', 1690, 78, '2022-01-01'),
(132, 'Shiikh Jamac Cumar Aadan', '61', 'Deriska Ceelka', 1246, 39, '2022-01-01'),
(133, 'C/risaaq Aadan Yaxye', '61', 'Deriska Ceelka', 407, 0, '2022-01-01'),
(134, 'Xaaji Cali Ciise', '61', 'Deriska Ceelka', 208, 0.000000178814, '2022-01-01'),
(135, 'Axmed Maxamed Maxamud', '61', 'Deriska Ceelka', 252, 0, '2022-01-01'),
(136, 'C/qadir Maxamed Kaahiye', '61', 'Deriska Ceelka', 263, 0, '2022-01-01'),
(137, 'Bashiir Maxamud Faarax', '61', 'Deriska Ceelka', 2382, 0, '2022-01-01'),
(138, 'Dahabo Shiikhow', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(139, 'Safiyo Daahir Maxamud', '61', 'Deriska Ceelka', 709, 0, '2022-01-01'),
(140, 'Faadumo Mire Odawaa', '61', 'Deriska Ceelka', 368, -0.000000193715, '2022-01-01'),
(141, 'Salaad Maxamed Cabdi', '61', 'Deriska Ceelka', 541, -0.00000038743, '2022-01-01'),
(142, 'C/rashiid Salaad ', '61', 'Deriska Ceelka', 1482, 21, '2022-01-01'),
(143, 'Xaliimo Maxamed Saciid ', '61', 'Deriska Ceelka', 44, 0.000000178814, '2022-01-01'),
(144, 'Nuur Cali Cibaar', '61', 'Deriska Ceelka', 479, -0.00000077486, '2022-01-01'),
(145, 'Maxamed Macalin Cismaan', '61', 'Deriska Ceelka', 1815, 94.9, '2022-01-01'),
(146, 'Faay Nuur Cabdi', '61', 'Deriska Ceelka', 1077, 0.000000178814, '2022-01-01'),
(147, 'Ibraahim Nageeye Cali', '61', 'Deriska Ceelka', 874, 26, '2022-01-01'),
(148, 'Ruqiyo Abuukar Cabdi', '61', 'Deriska Ceelka', 201, 0, '2022-01-01'),
(149, 'Cumar Cismaan Muse', '61', 'Deriska Ceelka', 841, -0.000000357628, '2022-01-01'),
(150, 'Sahro Maxamud Weheliye', '61', 'Deriska Ceelka', 1226, 0.9, '2022-01-01'),
(151, 'Xaashi Maxamed Qooje', '61', 'Deriska Ceelka', 38, 0, '2022-01-01'),
(152, 'Xuseen Cali Macalin', '61', 'Deriska Ceelka', 41, 0.000000178814, '2022-01-01'),
(153, 'Xuseen Cali Macalin', '61', 'Deriska Ceelka', 263, -0.2, '2022-01-01'),
(154, 'Shiikh Cabdi Fitaax', '61', 'Deriska Ceelka', 2585, 192.4, '2022-01-01'),
(155, 'Bashiir Faarax Cabdi', '61', 'Deriska Ceelka', 126, 0, '2022-01-01'),
(156, '', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(157, 'Xasan Faarax Dhaqane', '61', 'Deriska Ceelka', 751, 0, '2022-01-01'),
(158, 'Shamso Salaad Cabdulle', '61', 'Deriska Ceelka', 150, 39, '2022-01-01'),
(159, 'Xido Xasan ', '61', 'Deriska Ceelka', 1539, -33.6, '2022-01-01'),
(160, 'Daahir Cosoble', '61', 'Deriska Ceelka', 913, 0, '2022-01-01'),
(161, 'Faadumo Aadan Cabdulle', '61', 'Deriska Ceelka', 631, 9.1, '2022-01-01'),
(162, 'Kaaho Axmed Cosoble', '61', 'Deriska Ceelka', 503, -0.000000238419, '2022-01-01'),
(163, 'Sacdiyo Shiikh Cali Maxamed', '61', 'Deriska Ceelka', 58, 9.1, '2022-01-01'),
(164, 'Maxamed Axmed Xasan', '61', 'Deriska Ceelka', 387, 0.000000178814, '2022-01-01'),
(165, 'Xareedo Shabiye Muxumud', '61', 'Deriska Ceelka', 203, 0, '2022-01-01'),
(166, 'Xuseen Shiikhdon Weheliye', '61', 'Deriska Ceelka', 254, 0.000000476837, '2022-01-01'),
(167, 'Xasan Cumar ', '61', 'Deriska Ceelka', 585, 0, '2022-01-01'),
(168, 'Himo Cali Cilmi', '61', 'Deriska Ceelka', 970, 28.6, '2022-01-01'),
(169, 'Xasan Xuseen Barsey', '61', 'Deriska Ceelka', 548, 33.8, '2022-01-01'),
(170, 'Xasan Macalin Xuseen', '61', 'Deriska Ceelka', 2032, -0.00000038743, '2022-01-01'),
(171, 'Xasan Xuseen Barsey', '61', 'Deriska Ceelka', 767, 0.00000037998, '2022-01-01'),
(172, 'Shiikh Maxamed C/laahi', '61', 'Deriska Ceelka', 411, -0.1, '2022-01-01'),
(173, 'Axmed Xaaji Xasan', '61', 'Deriska Ceelka', 341, 0.000000178814, '2022-01-01'),
(174, 'Cali Daahir Cabdi', '61', 'Deriska Ceelka', 91, 0, '2022-01-01'),
(175, 'Maryan C/laahi Sahal', '61', 'Deriska Ceelka', 1461, 0, '2022-01-01'),
(176, 'Shiikh Cismaan', '61', 'Deriska Ceelka', 1158, -0.000000715256, '2022-01-01'),
(177, 'Sahro Nuur Maxamed ', '61', 'Deriska Ceelka', 94, 0, '2022-01-01'),
(178, 'Xaawo Ibraahim Siyaad', '61', 'Deriska Ceelka', 111, -0.00000038743, '2022-01-01'),
(179, 'Maxamed Raajicis', '61', 'Deriska Ceelka', 814, 0, '2022-01-01'),
(180, 'Macalin C/laahi Cismaan', '61', 'Deriska Ceelka', 68, -0.000000119209, '2022-01-01'),
(181, 'Muxudiin Muxumud Xaaji', '61', 'Deriska Ceelka', 859, -2.4, '2022-01-01'),
(182, 'Siraad Maxamed Cali', '61', 'Deriska Ceelka', 668, -0.000000178814, '2022-01-01'),
(183, 'Muxudiin Muxumud Xaaji', '61', 'Deriska Ceelka', 114, -0.000000715256, '2022-01-01'),
(184, 'C/laahi Xasan Abuukar', '61', 'Deriska Ceelka', 72, -0.1, '2022-01-01'),
(185, 'Shiikh Cusmaan Xaaji Xasan', '61', 'Deriska Ceelka', 688, 0, '2022-01-01'),
(186, 'Xamdi', '61', 'Deriska Ceelka', 2161, 0, '2022-01-01'),
(187, 'Muse Cali Gurey', '61', 'Deriska Ceelka', 398, 0, '2022-01-01'),
(188, 'Qaliifo Macalin Cismaan', '61', 'Deriska Ceelka', 108, -0.000000357628, '2022-01-01'),
(189, 'C/laahi Cismaan Maxamud', '61', 'Deriska Ceelka', 777, 72.8, '2022-01-01'),
(190, 'Xamdi Yuusuf', '61', 'Deriska Ceelka', 350, 20.8, '2022-01-01'),
(191, 'Aamino Cabdi Waajid', '61', 'Deriska Ceelka', 1260, -0.000000476837, '2022-01-01'),
(192, 'Aamino C/laahi', '61', 'Deriska Ceelka', 759, 0.000000759959, '2022-01-01'),
(193, 'Shiikh Cumar', '61', 'Deriska Ceelka', 935, 0.000000357628, '2022-01-01'),
(194, 'Cabaas Jaabiri', '61', 'Deriska Ceelka', 452, 0.00000037998, '2022-01-01'),
(195, 'Asli Xasan Xuseen', '61', 'Deriska Ceelka', 92, 0.000000715256, '2022-01-01'),
(196, 'Axmed Faarax Rooble', '61', 'Deriska Ceelka', 1046, 0, '2022-01-01'),
(197, 'C/casiis Ibraahim Siyaad', '61', 'Deriska Ceelka', 462, -0.00000077486, '2022-01-01'),
(198, 'Ilyaas Sheegow Maxamed', '61', 'Deriska Ceelka', 640, 0, '2022-01-01'),
(199, 'Abuukar Xiirey', '61', 'Deriska Ceelka', 113, 0, '2022-01-01'),
(200, 'Aamino Cali Dhex yar', '61', 'Deriska Ceelka', 195, 0, '2022-01-01'),
(201, 'Cali Xaashi Guure', '61', 'Deriska Ceelka', 497, 0, '2022-01-01'),
(202, 'Cali Xaashi Guure', '61', 'Deriska Ceelka', 1035, 6.5, '2022-01-01'),
(203, 'Xaawo Axmed Cilmi', '61', 'Deriska Ceelka', 192, -0.3, '2022-01-01'),
(204, 'Asli Xasan Aadan', '61', 'Deriska Ceelka', 1924, 41.6, '2022-01-01'),
(205, 'Cabdi Jaamac', '61', 'Deriska Ceelka', 681, 0, '2022-01-01'),
(206, 'C/laahi Xuseen Faarax', '61', 'Deriska Ceelka', 543, 1.6, '2022-01-01'),
(207, 'Cabdi Weheliye Barre', '61', 'Deriska Ceelka', 505, -0.00000038743, '2022-01-01'),
(208, 'Baashi Axmed Yare', '61', 'Deriska Ceelka', 141, 0, '2022-01-01'),
(209, 'Axmed Ali Bare', '61', 'Deriska Ceelka', 1167, 106.6, '2022-01-01'),
(210, '', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(211, 'Cabdulle', '61', 'Deriska Ceelka', 304, 0.000000953674, '2022-01-01'),
(212, 'Sangaabo Saaxal Cumar', '61', 'Deriska Ceelka', 1232, 0.00000037998, '2022-01-01'),
(213, 'Maxamed Xuseen Nuur', '61', 'Deriska Ceelka', 779, -0.00000038743, '2022-01-01'),
(214, 'C/laahi Rooble Dhoore', '61', 'Deriska Ceelka', 1692, 0, '2022-01-01'),
(215, 'Warsame Cabdulle Yuusuf', '61', 'Deriska Ceelka', 2887, 20.8, '2022-01-01'),
(216, 'Xasan Maxamed Axmed', '61', 'Deriska Ceelka', 1106, 0, '2022-01-01'),
(217, 'Cali Maxamed Ilkacase', '61', 'Deriska Ceelka', 183, 0, '2022-01-01'),
(218, 'Xaawo Cali Muxumud', '61', 'Deriska Ceelka', 792, 18.2, '2022-01-01'),
(219, 'C/kariin C/laahi Shiikh', '61', 'Deriska Ceelka', 1202, -0.00000154972, '2022-01-01'),
(220, 'Cumar Cali Macalin', '61', 'Deriska Ceelka', 401, 0, '2022-01-01'),
(221, 'Aweys Macalin Xuseen', '61', 'Deriska Ceelka', 316, -0.000000178814, '2022-01-01'),
(222, 'Xuseen Axmed Cali', '61', 'Deriska Ceelka', 1028, 0.00000154972, '2022-01-01'),
(223, 'Sayid Cusmaan Axmed', '61', 'Deriska Ceelka', 1017, 36.2, '2022-01-01'),
(224, 'Sowdo Cabdi Kadiye', '61', 'Deriska Ceelka', 121, -0.000000357628, '2022-01-01'),
(225, 'Nuur Cali Warsame', '61', 'Deriska Ceelka', 1221, 28.6, '2022-01-01'),
(226, 'C/raxmaan Cabdi Shiikh', '61', 'Deriska Ceelka', 319, 0, '2022-01-01'),
(227, 'Nuur Cali Warsame', '61', 'Deriska Ceelka', 103, 0, '2022-01-01'),
(228, 'Faadumo Cali Weheliye', '61', 'Deriska Ceelka', 110, 0.000000357628, '2022-01-01'),
(229, 'Maxamed Axmed Xuseen', '61', 'Deriska Ceelka', 528, 0, '2022-01-01'),
(230, 'Dahabo Abti-doon Cali Cad', '61', 'Deriska Ceelka', 318, 0.000000357628, '2022-01-01'),
(231, 'Muumino Xuseen Ibraahim', '61', 'Deriska Ceelka', 815, 0.000000357628, '2022-01-01'),
(232, 'Dahabo Abti-doon Cali Cad', '61', 'Deriska Ceelka', 1142, 19.5, '2022-01-01'),
(233, 'C/laahi Cali Maxamed', '61', 'Deriska Ceelka', 142, 0, '2022-01-01'),
(234, 'Milgo Xirsi Muuse', '61', 'Deriska Ceelka', 683, 0, '2022-01-01'),
(235, 'Xasan Xirsi Canshuur', '61', 'Deriska Ceelka', 50, -22, '2022-01-01'),
(236, 'Cabdi Maxamed Roonow', '61', 'Deriska Ceelka', 2044, 74.1, '2022-01-01'),
(237, 'C/risaaq Cumar Nuur', '61', 'Deriska Ceelka', 367, -0.00000038743, '2022-01-01'),
(238, 'Shiikh C/raxmaan Cilmi', '61', 'Deriska Ceelka', 275, 0.000000178814, '2022-01-01'),
(239, 'Faadumo Cabdi Maxamed', '61', 'Deriska Ceelka', 166, -0.00000077486, '2022-01-01'),
(240, 'C/laahi Cismaan Maxamud', '61', 'Deriska Ceelka', 5712, 340.6, '2022-01-01'),
(241, 'Maxamed Axmed Maxamed', '61', 'Deriska Ceelka', 183, 33.8, '2022-01-01'),
(242, 'Xaadsan Sahal Cali', '61', 'Deriska Ceelka', 16, -0.00000077486, '2022-01-01'),
(243, 'Deeqo Cabdu Laahi ', '61', 'Deriska Ceelka', 561, -0.000000476837, '2022-01-01'),
(244, 'Xareedo Kulmiye', '61', 'Deriska Ceelka', 85, 0.000000178814, '2022-01-01'),
(245, 'C/laahi Cismaan Maxamud', '61', 'Deriska Ceelka', 765, 40.3, '2022-01-01'),
(246, 'Maan Deeq', '61', 'Deriska Ceelka', 1478, 0, '2022-01-01'),
(247, 'Xaliimo Warsame Cooke', '61', 'Deriska Ceelka', 299, -0.000000715256, '2022-01-01'),
(248, 'Cali Guuleed', '61', 'Deriska Ceelka', 460, -0.00000038743, '2022-01-01'),
(249, 'Nuur C/kariin C/laahi', '61', 'Deriska Ceelka', 613, 22.1, '2022-01-01'),
(250, 'Bile Maxamud Ibraahim', '61', 'Deriska Ceelka', 666, 15.6, '2022-01-01'),
(251, 'Saciido Cabdu Laahi', '61', 'Deriska Ceelka', 850, -0.000000357628, '2022-01-01'),
(252, 'Cabdi Shakuur Maxamed', '61', 'Deriska Ceelka', 65, 19.5, '2022-01-01'),
(253, 'Maxamed Yuusuf Aadan', '61', 'Deriska Ceelka', 120, 11.7, '2022-01-01'),
(254, 'Xaawo Cali xuseen', '61', 'Deriska Ceelka', 528, -0.000000193715, '2022-01-01'),
(255, 'Faadumo Warsame Maxamed3', '61', 'Deriska Ceelka', 220, 0, '2022-01-01'),
(256, 'faadumo maxamuud cosoble', '61', 'Deriska Ceelka', 1185, 22.1, '2022-01-01'),
(257, 'maxamed warsame maxamed', '61', 'Deriska Ceelka', 607, 6.5, '2022-01-01'),
(258, 'faadumo cabdule maxamuud', '61', 'Deriska Ceelka', 386, 0.00000037998, '2022-01-01'),
(259, '', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(260, 'nuuro macalin yuusuf', '61', 'Deriska Ceelka', 467, -0.0999997, '2022-01-01'),
(261, 'maryan maxamuud cali ', '61', 'Deriska Ceelka', 524, 7.8, '2022-01-01'),
(262, 'aamino ibraahim daauud', '61', 'Deriska Ceelka', 569, 45.5, '2022-01-01'),
(263, 'axmed xasan maxamed ', '61', 'Deriska Ceelka', 733, 14.3, '2022-01-01'),
(264, 'cismaan cabdule aadan', '61', 'Deriska Ceelka', 180, -3, '2022-01-01'),
(265, ' cabdi raxman axmed cali', '61', 'Deriska Ceelka', 349, 0, '2022-01-01'),
(266, ' c/casiis c/raxmaan seef   ', '61', 'Deriska Ceelka', 334, 16.9, '2022-01-01'),
(267, '  c/kariin cali xasan', '61', 'Deriska Ceelka', 233, 1.3, '2022-01-01'),
(268, 'xabiibo cali abakar', '61', 'Deriska Ceelka', 452, 3.8, '2022-01-01'),
(269, 'mire cabdi suudi', '61', 'Deriska Ceelka', 367, -0.0000000968575, '2022-01-01'),
(270, 'c /raxmaan maxamed abtidoon', '61', 'Deriska Ceelka', 267, 2.6, '2022-01-01'),
(271, ' xalwo ciise maxamed', '61', 'Deriska Ceelka', 615, 0, '2022-01-01'),
(272, 'xaadsan cali cowke', '61', 'Deriska Ceelka', 1381, 0.000000476837, '2022-01-01'),
(273, 'cali maxamed abtidoon', '61', 'Deriska Ceelka', 407, 11.7, '2022-01-01'),
(274, 'abshiro muxumud jimcaale', '61', 'Deriska Ceelka', 823, 0, '2022-01-01'),
(275, 'c/laahi ciise yuusuf', '61', 'Deriska Ceelka', 80, 6.5, '2022-01-01'),
(276, 'canab maxamuud maalin', '61', 'Deriska Ceelka', 296, 2.6, '2022-01-01'),
(277, 'ciise dhoore cali ', '61', 'Deriska Ceelka', 526, 2.6, '2022-01-01'),
(278, '  axmed cabdi warsame', '61', 'Deriska Ceelka', 327, 0, '2022-01-01'),
(279, 'dhaqan axmed nuur', '61', 'Deriska Ceelka', 83, 20.8, '2022-01-01'),
(280, 'saciido ciise yuusuf ', '61', 'Deriska Ceelka', 203, 5.2, '2022-01-01'),
(281, 'cumar c/raxmaan yuusuf ', '61', 'Deriska Ceelka', 358, 5.2, '2022-01-01'),
(282, 'malyuun xuseen maxamed', '61', 'Deriska Ceelka', 241, 10.4, '2022-01-01'),
(283, 'fartuun maxamed xirsi ', '61', 'Deriska Ceelka', 698, 0.000000759959, '2022-01-01'),
(284, 'nuuro jimcaale baruud ', '61', 'Deriska Ceelka', 130, 3.9, '2022-01-01'),
(285, 'taliil xaashi kadiye ', '61', 'Deriska Ceelka', 827, 0.000000357628, '2022-01-01'),
(286, 'maxamed warsame xaashi ', '61', 'Deriska Ceelka', 336, 20.8, '2022-01-01'),
(287, 'ayuub dhurwaydheere ', '61', 'Deriska Ceelka', 620, 0, '2022-01-01'),
(288, 'axmed maxamed farax ', '61', 'Deriska Ceelka', 428, 0.00000037998, '2022-01-01'),
(289, 'xasan maxamed guutale ', '61', 'Deriska Ceelka', 1175, 5.2, '2022-01-01'),
(290, 'marryan xaashi maxamed ', '61', 'Deriska Ceelka', 196, 9.1, '2022-01-01'),
(291, 'faadumo rooble jimcaale ', '61', 'Deriska Ceelka', 280, 5.2, '2022-01-01'),
(292, 'xuuseen saciid jimcaale ', '61', 'Deriska Ceelka', 891, 0, '2022-01-01'),
(293, 'maryan jimcaale carabeey ', '61', 'Deriska Ceelka', 82, 6.5, '2022-01-01'),
(294, 'maxamed rooble jimcaale ', '61', 'Deriska Ceelka', 341, 0.00000037998, '2022-01-01'),
(295, 'maxamed xaashi maxamed ', '61', 'Deriska Ceelka', 73, -0.00000038743, '2022-01-01'),
(296, 'nadiifo nuur cali ', '61', 'Deriska Ceelka', 849, 16.9, '2022-01-01'),
(297, 'sahro cabdule maxamuud ', '61', 'Deriska Ceelka', 62, 0.00000037998, '2022-01-01'),
(298, '', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(299, 'c/raxmaan maxamuud dhicisow', '61', 'Deriska Ceelka', 935, 14.3, '2022-01-01'),
(300, 'c/nuur c/laahi ciidle ', '61', 'Deriska Ceelka', 435, 0.00000037998, '2022-01-01'),
(301, 'canab cabdulaahi carab', '61', 'Deriska Ceelka', 117, 9.1, '2022-01-01'),
(302, 'nuur cismaan cabduie ', '61', 'Deriska Ceelka', 2, 0.1, '2022-01-01'),
(303, 'xaawo maxamuud agdage ', '61', 'Deriska Ceelka', 521, -0.00000038743, '2022-01-01'),
(304, 'bashiir axmed cismaan ', '61', 'Deriska Ceelka', 792, 22.1, '2022-01-01'),
(305, 'c/casiis cismaan cabdule', '61', 'Deriska Ceelka', 665, 29.9, '2022-01-01'),
(306, 'cali daahir maxamed axmed ', '61', 'Deriska Ceelka', 763, 0.000000759959, '2022-01-01'),
(307, 'farxiyo  cabdi carab', '61', 'Deriska Ceelka', 476, 0.000000178814, '2022-01-01'),
(308, 'xuseen xaaji axmed khayre', '61', 'Deriska Ceelka', 50, 0, '2022-01-01'),
(309, 'salaad cali cabdule ', '61', 'Deriska Ceelka', 193, 0.000000357628, '2022-01-01'),
(310, 'c/nuur xirsi rooble', '61', 'Deriska Ceelka', 178, 0.000000238419, '2022-01-01'),
(311, 'maxamed ilkacase ', '61', 'Deriska Ceelka', 237, 0, '2022-01-01'),
(312, 'c/rashiid c/laahi maxamed ', '61', 'Deriska Ceelka', 421, 32.5, '2022-01-01'),
(313, 'xuseen xaaji axmed khayre', '61', 'Deriska Ceelka', 158, -0.000000193715, '2022-01-01'),
(314, 'faadumo xasan xuseen', '61', 'Deriska Ceelka', 178, 2.6, '2022-01-01'),
(315, 'cilmi xasan maxamed ', '61', 'Deriska Ceelka', 791, 26, '2022-01-01'),
(316, 'saciid axmed nuur ', '61', 'Deriska Ceelka', 581, 20.8, '2022-01-01'),
(317, 'shugri maxamed cali ', '61', 'Deriska Ceelka', 511, 0, '2022-01-01'),
(318, 'bashiir cumar qayshe', '61', 'Deriska Ceelka', 614, -0.00000038743, '2022-01-01'),
(319, 'xakiimo axmed nuur ', '61', 'Deriska Ceelka', 608, -0.000000193715, '2022-01-01'),
(320, 'salaado axmed maxamed ', '61', 'Deriska Ceelka', 712, -0.000000193715, '2022-01-01'),
(321, 'c/laahi ciise yuusuf xaydar ', '61', 'Deriska Ceelka', 226, 3.9, '2022-01-01'),
(322, 'maxauud rooble jimcaale', '61', 'Deriska Ceelka', 432, 0, '2022-01-01'),
(323, 'maxamed rashiid c/laahi ', '61', 'Deriska Ceelka', 235, 0.00000037998, '2022-01-01'),
(324, 'xasno kadiye bare ', '61', 'Deriska Ceelka', 1013, 9.1, '2022-01-01'),
(325, 'xaawo nuur ibraahim ', '61', 'Deriska Ceelka', 1639, 0.00000037998, '2022-01-01'),
(326, 'abuur xaaji xuseen ', '61', 'Deriska Ceelka', 701, 0, '2022-01-01'),
(327, 'maxamed axmed sahal', '61', 'Deriska Ceelka', 442, 13, '2022-01-01'),
(328, 'faadumo diiriye maalin ', '61', 'Deriska Ceelka', 723, -0.000000193715, '2022-01-01'),
(329, 'saciid jimcaale cumar ', '61', 'Deriska Ceelka', 500, -0.00000038743, '2022-01-01'),
(330, 'cali shiikh doon weheliye ', '61', 'Deriska Ceelka', 744, 15.6, '2022-01-01'),
(331, 'xasan axmed khayre ', '61', 'Deriska Ceelka', 328, -0.0999999, '2022-01-01'),
(332, 'faarax maxamuud cali ', '61', 'Deriska Ceelka', 1142, 39, '2022-01-01'),
(333, 'saciido kobro ', '61', 'Deriska Ceelka', 352, 6.5, '2022-01-01'),
(334, 'safiyo maag cali ', '61', 'Deriska Ceelka', 860, 13, '2022-01-01'),
(335, 'saciido xasan maxamed ', '61', 'Deriska Ceelka', 498, -15, '2022-01-01'),
(336, 'c/raxmaan c/laahi maxamed ', '61', 'Deriska Ceelka', 47, -0.000000357628, '2022-01-01'),
(337, 'maxamed daahir maxamed ', '61', 'Deriska Ceelka', 181, 0.00000037998, '2022-01-01'),
(338, 'qaliif warsame xaayow', '61', 'Deriska Ceelka', 630, 0.000000238419, '2022-01-01'),
(339, 'xuseen xaashi maxamed', '61', 'Deriska Ceelka', 417, -0.00000038743, '2022-01-01'),
(340, 'shariif maxamuud weheliye ', '61', 'Deriska Ceelka', 898, 0.00000037998, '2022-01-01'),
(341, 'maxamed daahir xaydar ', '61', 'Deriska Ceelka', 426, 0, '2022-01-01'),
(342, 'samsan xasan aamin ', '61', 'Deriska Ceelka', 383, -0.000000238419, '2022-01-01'),
(343, 'xaliimo maxamed daauud ', '61', 'Deriska Ceelka', 463, -0.0999999, '2022-01-01'),
(344, 'c/naasir xasan sahal ', '61', 'Deriska Ceelka', 435, 0.00000037998, '2022-01-01'),
(345, 'cali shiikh doon weheliye ', '61', 'Deriska Ceelka', 917, 0, '2022-01-01'),
(346, 'daahir cabdi cismaan ', '61', 'Deriska Ceelka', 547, 9.1, '2022-01-01'),
(347, 'axmed salaad maxamed siyaad ', '61', 'Deriska Ceelka', 123, 0, '2022-01-01'),
(348, 'cumar qaanax', '61', 'Deriska Ceelka', 19, -2.2, '2022-01-01'),
(349, 'xabiibo maxamed raage ', '61', 'Deriska Ceelka', 127, 0.000000089407, '2022-01-01'),
(350, 'faadumo maxamed siyaad ', '61', 'Deriska Ceelka', 122, 0, '2022-01-01'),
(351, 'ciise axmed cowl', '61', 'Deriska Ceelka', 0, -427.7, '2022-01-01'),
(352, '', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(353, 'maxamuud cabdi jaamac', '61', 'Deriska Ceelka', 122, 3.9, '2022-01-01'),
(354, 'saciid cabdi fitaax', '61', 'Deriska Ceelka', 148, 10.4, '2022-01-01'),
(355, 'xuseen cabdi jaamac', '61', 'Deriska Ceelka', 118, 6.5, '2022-01-01'),
(356, 'xaawo c/laahi jaamac', '61', 'Deriska Ceelka', 533, 19.5, '2022-01-01'),
(357, 'xaawo warsame xaayow ', '61', 'Deriska Ceelka', 70, 0, '2022-01-01'),
(358, 'jawir xaashi magan ', '61', 'Deriska Ceelka', 222, 10.4, '2022-01-01'),
(359, 'faadumo maxamuud gabeeyre ', '61', 'Deriska Ceelka', 528, 5.2, '2022-01-01'),
(360, 'sahro baraxoow', '61', 'Deriska Ceelka', 131, 10.4, '2022-01-01'),
(361, '', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(362, 'hodon xirsi xaaji ', '61', 'Deriska Ceelka', 683, 0, '2022-01-01'),
(363, 'madiino xaaji axmed ', '61', 'Deriska Ceelka', 551, 13, '2022-01-01'),
(364, 'madiino xaaji axmed ', '61', 'Deriska Ceelka', 560, 0, '2022-01-01'),
(365, 'jamaad nuur canshuur ', '61', 'Deriska Ceelka', 419, -0.00000038743, '2022-01-01'),
(366, 'faadumo deele macalin yuusuf', '61', 'Deriska Ceelka', 395, 10.4, '2022-01-01'),
(367, 'c/laahi warsame xaayow', '61', 'Deriska Ceelka', 472, 7.8, '2022-01-01'),
(368, 'c/raxmaan macalin yuusuf', '61', 'Deriska Ceelka', 806, 13, '2022-01-01'),
(369, 'ruways maxamuud soofe', '61', 'Deriska Ceelka', 181, -0.000000178814, '2022-01-01'),
(370, 'macalin cadaan afrax ', '61', 'Deriska Ceelka', 372, 0.000000178814, '2022-01-01'),
(371, 'cabdi abuukar tuur yare', '61', 'Deriska Ceelka', 341, -0.2, '2022-01-01'),
(372, 'istaahil cabdi carab ', '61', 'Deriska Ceelka', 165, -0.8, '2022-01-01'),
(373, 'ciid jimcaale ciyaaye ', '61', 'Deriska Ceelka', 289, 0.000000178814, '2022-01-01'),
(374, 'mahad buruko ', '61', 'Deriska Ceelka', 633, 0.000000178814, '2022-01-01'),
(375, 'nuuro axmed maalin ', '61', 'Deriska Ceelka', 571, 13, '2022-01-01'),
(376, 'cali diiriye kulmiye', '61', 'Deriska Ceelka', 405, -0.000000357628, '2022-01-01'),
(377, 'maxamed agoon ', '61', 'Deriska Ceelka', 1311, -0.00000038743, '2022-01-01'),
(378, 'maxamed diiriye farax', '61', 'Deriska Ceelka', 660, -0.000000193715, '2022-01-01'),
(379, 'maxamed cumar maxamuud', '61', 'Deriska Ceelka', 251, 20.8, '2022-01-01'),
(380, 'xuseen cabdi warsame ', '61', 'Deriska Ceelka', 239, 2.6, '2022-01-01'),
(381, 'siraad yuusuf aadan ', '61', 'Deriska Ceelka', 633, 0, '2022-01-01'),
(382, 'cumar cabdi geedi ', '61', 'Deriska Ceelka', 719, 0.00000037998, '2022-01-01'),
(383, 'dahabo c/laahi maxamed ', '61', 'Deriska Ceelka', 520, 18.2, '2022-01-01'),
(384, 'qaliif salaad xirsi', '61', 'Deriska Ceelka', 77, 9.1, '2022-01-01'),
(385, 'xasan aadan cabdule', '61', 'Deriska Ceelka', 633, 0.000000238419, '2022-01-01'),
(386, 'cadar nuure abtidoon ', '61', 'Deriska Ceelka', 263, 0, '2022-01-01'),
(387, 'xakiimo aadan jaamac ', '61', 'Deriska Ceelka', 516, 18.2, '2022-01-01'),
(388, 'maxamed cilmi cali ', '61', 'Deriska Ceelka', 397, 7.8, '2022-01-01'),
(389, 'xaliimo cabdi raage', '61', 'Deriska Ceelka', 270, -0.00000038743, '2022-01-01'),
(390, 'faadumo axmed farax', '61', 'Deriska Ceelka', 418, 31.2, '2022-01-01'),
(391, 'xaashi maxamed gaaraad ', '61', 'Deriska Ceelka', 501, 0.000000178814, '2022-01-01'),
(392, 'xaawo axmed cali raage ', '61', 'Deriska Ceelka', 175, 5.2, '2022-01-01'),
(393, 'shariifo yuusuf aadan ', '61', 'Deriska Ceelka', 617, 15.6, '2022-01-01'),
(394, 'cali warsame oreey ', '61', 'Deriska Ceelka', 189, 0, '2022-01-01'),
(395, 'maxamed c/laahi ', '61', 'Deriska Ceelka', 218, 1.3, '2022-01-01'),
(396, 'hibaac cilmi geedi', '61', 'Deriska Ceelka', 449, 0, '2022-01-01'),
(397, 'salaad maxamuud jimcaale ', '61', 'Deriska Ceelka', 86, 5.2, '2022-01-01'),
(398, 'xasan axmed khayre ', '61', 'Deriska Ceelka', 3659, 26, '2022-01-01'),
(399, 'cabdi xasan cosable', '61', 'Deriska Ceelka', 303, 6.5, '2022-01-01'),
(400, 'cismaan maxamed xirsi', '61', 'Deriska Ceelka', 715, 10.4, '2022-01-01'),
(401, 'faadumo xaashi maalin', '61', 'Deriska Ceelka', 168, -0.2, '2022-01-01'),
(402, 'salaad maxamuud jimcaale ', '61', 'Deriska Ceelka', 318, 0.000000178814, '2022-01-01'),
(403, 'maxamed xirsi xaaji ', '61', 'Deriska Ceelka', 1182, 0, '2022-01-01'),
(404, 'nimco xasan xirsi', '61', 'Deriska Ceelka', 52, 11.7, '2022-01-01'),
(405, 'maryan axmed maxamed', '61', 'Deriska Ceelka', 1228, 11.7, '2022-01-01'),
(406, 'macalin c/laahi cismaan', '61', 'Deriska Ceelka', 239, 27.3, '2022-01-01'),
(407, 'cali xirsi cali yare', '61', 'Deriska Ceelka', 541, -0.000000193715, '2022-01-01'),
(408, 'axmed caawale cilmi', '61', 'Deriska Ceelka', 561, 2.6, '2022-01-01'),
(409, 'c/kariin sheekh muuse ', '61', 'Deriska Ceelka', 546, 0.000000178814, '2022-01-01'),
(410, 'salaad axmed cali ', '61', 'Deriska Ceelka', 195, 10.4, '2022-01-01'),
(411, 'xasan xirsi canshuur ', '61', 'Deriska Ceelka', 10, -0.000000193715, '2022-01-01'),
(412, 'boosteeyo sheekh c/kariin ', '61', 'Deriska Ceelka', 539, 24.7, '2022-01-01'),
(413, 'nuur cali yariisow', '61', 'Deriska Ceelka', 173, 7.1, '2022-01-01'),
(414, 'faadumo canshuur cadoow', '61', 'Deriska Ceelka', 562, 6.5, '2022-01-01'),
(415, 'madiino axmed dhiblaawe ', '61', 'Deriska Ceelka', 762, 0, '2022-01-01'),
(416, 'ruqiyo aadan cumar', '61', 'Deriska Ceelka', 455, -0.00000038743, '2022-01-01'),
(417, 'aamino maxamed cismaan ', '61', 'Deriska Ceelka', 339, 0, '2022-01-01'),
(418, 'maryan maxamuud siyaad ', '61', 'Deriska Ceelka', 563, 5.2, '2022-01-01'),
(419, 'xasan xaashi ', '61', 'Deriska Ceelka', 332, -0.2, '2022-01-01'),
(420, 'maxamed abshir faarax ', '61', 'Deriska Ceelka', 1315, 16.9, '2022-01-01'),
(421, 'hani muxumud diiriye', '61', 'Deriska Ceelka', 860, 20.8, '2022-01-01'),
(422, 'ibraahim cumar guure', '61', 'Deriska Ceelka', 38, 9.1, '2022-01-01'),
(423, 'c/laahi daauud xuseen ', '61', 'Deriska Ceelka', 75, -0.000000357628, '2022-01-01'),
(424, 'warmoog abaadir axmed', '61', 'Deriska Ceelka', 49, 33.8, '2022-01-01'),
(425, 'cali maxamed kaahiye ', '61', 'Deriska Ceelka', 403, 0, '2022-01-01'),
(426, 'xaliimo codween ', '61', 'Deriska Ceelka', 5, 0, '2022-01-01'),
(427, 'saynab axmed ', '61', 'Deriska Ceelka', 632, 11.7, '2022-01-01'),
(428, 'maxamed libaax axmed ', '61', 'Deriska Ceelka', 55, 0.00000037998, '2022-01-01'),
(429, 'axmed xasan cali ', '61', 'Deriska Ceelka', 546, 3.2, '2022-01-01'),
(430, 'sahro maxamuud siyaad ', '61', 'Deriska Ceelka', 380, -0.000000715256, '2022-01-01'),
(431, 'xaliimo dable nuur ', '61', 'Deriska Ceelka', 76, 0, '2022-01-01'),
(432, 'maxamed cilmi cali ', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(433, 'shamsudiin macalin aadan ', '61', 'Deriska Ceelka', 56, 0, '2022-01-01'),
(434, 'xamse cali xaashi ', '61', 'Deriska Ceelka', 298, 10.4, '2022-01-01'),
(435, 'qamar jaamac ', '61', 'Deriska Ceelka', 595, 16.9, '2022-01-01'),
(436, 'samsam abshir yuusuf', '61', 'Deriska Ceelka', 573, 10.4, '2022-01-01'),
(437, 'c/laahi macalin aadan ', '61', 'Deriska Ceelka', 571, 16.9, '2022-01-01'),
(438, 'cali macalin ', '61', 'Deriska Ceelka', 42, 0, '2022-01-01'),
(439, 'calas jimcaale ciyaaye', '61', 'Deriska Ceelka', 141, 92.3, '2022-01-01'),
(440, 'raxmo xasan cali ', '61', 'Deriska Ceelka', 771, 15.6, '2022-01-01'),
(441, 'c/fitaax shiikh maxamed ', '61', 'Deriska Ceelka', 390, -0.000000715256, '2022-01-01'),
(442, 'maxamed deeq cismaan ', '61', 'Deriska Ceelka', 1348, -2.6, '2022-01-01'),
(443, 'xaliimo maxamed faarax ', '61', 'Deriska Ceelka', 3, 3.9, '2022-01-01'),
(444, 'faadumo xaashi ', '61', 'Deriska Ceelka', 161, 7.8, '2022-01-01'),
(445, 'maxamed xasan cilmi ', '61', 'Deriska Ceelka', 739, 3.9, '2022-01-01'),
(446, 'maxamuud salad shire ', '61', 'Deriska Ceelka', 18, 0, '2022-01-01'),
(447, 'asmo yaasiin ', '61', 'Deriska Ceelka', 76, 3.9, '2022-01-01'),
(448, 'xaliimo maxamed faarax ', '61', 'Deriska Ceelka', 436, 7.8, '2022-01-01'),
(449, 'farxiyo cabdi carab ', '61', 'Deriska Ceelka', 190, 0.000000119209, '2022-01-01'),
(450, 'maxamed xasan cilmi ', '61', 'Deriska Ceelka', 87, 6.5, '2022-01-01'),
(451, 'maxamed deeq jacafe ', '61', 'Deriska Ceelka', 181, 0, '2022-01-01'),
(452, 'hindi muuse diini ', '61', 'Deriska Ceelka', 374, 0.000000759959, '2022-01-01'),
(453, 'daahir bootaan ', '61', 'Deriska Ceelka', 75, 0.00000037998, '2022-01-01'),
(454, 'xasan  maxamuud jimcaale ', '61', 'Deriska Ceelka', 409, 11.7, '2022-01-01'),
(455, 'maryan c/laahi maxamed ', '61', 'Deriska Ceelka', 545, -0.000000178814, '2022-01-01'),
(456, 'xasan maxamed cali ', '61', 'Deriska Ceelka', 131, 39, '2022-01-01'),
(457, 'c/raxmaan axmed maxamed ', '61', 'Deriska Ceelka', 365, 10.4, '2022-01-01'),
(458, 'muqtaar shiikh maxamuud ', '61', 'Deriska Ceelka', 33, 0, '2022-01-01'),
(459, 'faadumo canshuur cadoow', '61', 'Deriska Ceelka', 7, 9.1, '2022-01-01'),
(460, 'xoor dable nuur ', '61', 'Deriska Ceelka', 240, 6.5, '2022-01-01'),
(461, 'farxaan c/laahi farax ', '61', 'Deriska Ceelka', 143, 9.1, '2022-01-01'),
(462, 'macalin nuur ', '61', 'Deriska Ceelka', 311, -0.000000238419, '2022-01-01'),
(463, 'cabdi xuseen xaaji', '61', 'Deriska Ceelka', 354, 0.000000178814, '2022-01-01'),
(464, 'dhuxcumar yariisoow', '61', 'Deriska Ceelka', 570, 16.9, '2022-01-01'),
(465, 'maxamed axmed nuu', '61', 'Deriska Ceelka', 735, 2.6, '2022-01-01'),
(466, 'sucdi maag cali ', '61', 'Deriska Ceelka', 548, 27.3, '2022-01-01'),
(467, 'faarax maxamuud cali ', '61', 'Deriska Ceelka', 470, 14.3, '2022-01-01'),
(468, 'bashiir axmed cismaam ', '61', 'Deriska Ceelka', 360, 2.6, '2022-01-01'),
(469, 'dhoofo yuusuf diini ', '61', 'Deriska Ceelka', 53, -0.000000193715, '2022-01-01'),
(470, 'axmed maxamed faarax ', '61', 'Deriska Ceelka', 12, -0.0999997, '2022-01-01'),
(471, 'salaado axmed maxamed ', '61', 'Deriska Ceelka', 60, -0.000000193715, '2022-01-01'),
(472, 'liibaan cabdi ', '61', 'Deriska Ceelka', 328, 6.5, '2022-01-01'),
(473, 'bashiir nuur diiriye', '61', 'Deriska Ceelka', 321, 3.9, '2022-01-01'),
(474, 'cismaan gaabow', '61', 'Deriska Ceelka', 646, 0.000000357628, '2022-01-01'),
(475, 'c/casiis cismaan cabdule ', '61', 'Deriska Ceelka', 639, 0.000000178814, '2022-01-01'),
(476, 'cabdi muuse maxamed ', '61', 'Deriska Ceelka', 501, 0, '2022-01-01'),
(477, 'maxamuud cabdi jaamac', '61', 'Deriska Ceelka', 205, 5.2, '2022-01-01'),
(478, 'xaliimo maxamed rooble ', '61', 'Deriska Ceelka', 451, -0.000000193715, '2022-01-01'),
(479, 'macalin axmed nuur ', '61', 'Deriska Ceelka', 435, -10, '2022-01-01'),
(480, 'faadumo diiriye maalin ', '61', 'Deriska Ceelka', 256, -0.0000000968575, '2022-01-01'),
(481, 'caydaruur cumar ', '61', 'Deriska Ceelka', 797, 0, '2022-01-01'),
(482, 'macalin ciro guunbe ', '61', 'Deriska Ceelka', 632, 26, '2022-01-01'),
(483, 'shugri cabdi dhoore ', '61', 'Deriska Ceelka', 311, 11.7, '2022-01-01'),
(484, 'ciise cali gabayre ', '61', 'Deriska Ceelka', 19, 14.3, '2022-01-01'),
(485, 'xasan c/laahi maxamed ', '61', 'Deriska Ceelka', 355, 19.5, '2022-01-01'),
(486, 'faadumo xasan maxamed ', '61', 'Deriska Ceelka', 271, 0.000000119209, '2022-01-01'),
(487, 'macalin maxamuud ', '61', 'Deriska Ceelka', 449, 0.000000178814, '2022-01-01'),
(488, 'c/rashiid maxamed samatar ', '61', 'Deriska Ceelka', 426, 0, '2022-01-01'),
(489, 'maxamed tahaliil xaashi ', '61', 'Deriska Ceelka', 351, -0.000000357628, '2022-01-01'),
(490, 'caasho cali dheere ', '61', 'Deriska Ceelka', 299, 0, '2022-01-01'),
(491, 'axmed cabdi carab ', '61', 'Deriska Ceelka', 91, 1.3, '2022-01-01'),
(492, 'qamar jaamac ', '61', 'Deriska Ceelka', 265, 0.000000178814, '2022-01-01'),
(493, 'cabddi yaasiin maxamuud', '61', 'Deriska Ceelka', 166, 3.9, '2022-01-01'),
(494, 'maryan axmed maxamed', '61', 'Deriska Ceelka', 229, -0.000000193715, '2022-01-01'),
(495, 'canab c/laahi carab ', '61', 'Deriska Ceelka', 298, 6.5, '2022-01-01'),
(496, 'maryan ciise yuusuf', '61', 'Deriska Ceelka', 0, -115.7, '2022-01-01'),
(497, 'siraad cabdi jaamac', '61', 'Deriska Ceelka', 478, 10.4, '2022-01-01'),
(498, 'maxamed ciise cali ', '61', 'Deriska Ceelka', 168, 10.4, '2022-01-01'),
(499, 'axmed maxamed raage ', '61', 'Deriska Ceelka', 165, 3.9, '2022-01-01'),
(500, 'axmed cabdi rooble', '61', 'Deriska Ceelka', 287, -3.5, '2022-01-01'),
(501, 'maxamed aadan diini ', '61', 'Deriska Ceelka', 199, 0, '2022-01-01'),
(502, 'ruun maxamuud cabdi ', '61', 'Deriska Ceelka', 406, 13, '2022-01-01'),
(503, 'yaasiin axmed cabdule', '61', 'Deriska Ceelka', 290, 5.2, '2022-01-01'),
(504, 'c/laahli cali shiikhdoon', '61', 'Deriska Ceelka', 230, 7.8, '2022-01-01'),
(505, 'c/casiis cismaan cabdule ', '61', 'Deriska Ceelka', 358, 0.000000178814, '2022-01-01'),
(506, 'hibaac nuur diiriye ', '61', 'Deriska Ceelka', 263, 7.8, '2022-01-01'),
(507, 'ayuub c/raxmaan axmed ', '61', 'Deriska Ceelka', 467, 10.4, '2022-01-01'),
(508, 'axmed maxamed weheliye ', '61', 'Deriska Ceelka', 226, 5.2, '2022-01-01'),
(509, 'xaawocumar qaylshe', '61', 'Deriska Ceelka', 449, 16.9, '2022-01-01'),
(510, 'faadumo xaashi maalin', '61', 'Deriska Ceelka', 142, 0, '2022-01-01'),
(511, 'cismaan maxamed cabdi', '61', 'Deriska Ceelka', 208, 0, '2022-01-01'),
(512, 'muqtaar macalin xuseen', '61', 'Deriska Ceelka', 264, 2.6, '2022-01-01'),
(513, 'kuulo faarax canbuur ', '61', 'Deriska Ceelka', 68, 0.00000037998, '2022-01-01'),
(514, 'maxamed cabdi ', '61', 'Deriska Ceelka', 311, 0.000000357628, '2022-01-01'),
(515, 'nuuro jimcaale baruud', '61', 'Deriska Ceelka', 42, -0.0999998, '2022-01-01'),
(516, 'xuseen xaaji axmed khayre', '61', 'Deriska Ceelka', 10, 10.4, '2022-01-01'),
(517, 'ibraahim yaasin maxamuud ', '61', 'Deriska Ceelka', 208, 0.000000178814, '2022-01-01'),
(518, 'saynab axmed', '61', 'Deriska Ceelka', 182, 3.9, '2022-01-01'),
(519, 'cumar macalin xuseen ', '61', 'Deriska Ceelka', 126, 0, '2022-01-01'),
(520, 'cali maxamuud afrax', '61', 'Deriska Ceelka', 482, 10.4, '2022-01-01'),
(521, 'fardowso cabdule maxamuud ', '61', 'Deriska Ceelka', 599, 0, '2022-01-01'),
(522, 'maxamed cali yare', '61', 'Deriska Ceelka', 225, 5.2, '2022-01-01'),
(523, 'xasan axmed maxamed ', '61', 'Deriska Ceelka', 279, 15.6, '2022-01-01'),
(524, 'maxamed abuukar xaaji', '61', 'Deriska Ceelka', 257, -0.0000000968575, '2022-01-01'),
(525, 'cabdi mahad', '61', 'Deriska Ceelka', 294, 7.8, '2022-01-01'),
(526, 'xasan sayid cali', '61', 'Deriska Ceelka', 751, 0, '2022-01-01'),
(527, 'nasro ciise cali', '61', 'Deriska Ceelka', 72, 13, '2022-01-01'),
(528, 'axmed naasir nuur dheere ', '61', 'Deriska Ceelka', 277, 9, '2022-01-01'),
(529, 'c/raxmaan xuseen cosoble', '61', 'Deriska Ceelka', 724, 16.9, '2022-01-01'),
(530, 'sahro cabdi suudi ', '61', 'Deriska Ceelka', 68, 1.3, '2022-01-01'),
(531, 'sheekh jaamac cumar aadan ', '61', 'Deriska Ceelka', 70, 5.2, '2022-01-01'),
(532, 'muumino maxamed xasan', '61', 'Deriska Ceelka', 479, 31.2, '2022-01-01'),
(533, 'maxamed aadan muuse', '61', 'Deriska Ceelka', 26, -0.00000038743, '2022-01-01'),
(534, 'dahabo macalin shacbaan ', '61', 'Deriska Ceelka', 35, 0.000000178814, '2022-01-01'),
(535, 'xaawo axmed cali raage', '61', 'Deriska Ceelka', 184, 0, '2022-01-01'),
(536, 'faadumo cabdulaahi ciidle', '61', 'Deriska Ceelka', 60, 11.7, '2022-01-01'),
(537, 'axmed xasan faray ', '61', 'Deriska Ceelka', 696, -14, '2022-01-01'),
(538, 'cayni maxamuud xaaji ', '61', 'Deriska Ceelka', 127, 0.000000178814, '2022-01-01'),
(539, 'deeqo muxumud diiriye', '61', 'Deriska Ceelka', 193, 10.4, '2022-01-01'),
(540, 'shiikh xasan guure ', '61', 'Deriska Ceelka', 446, -0.000000953674, '2022-01-01'),
(541, 'nuuro macalin yuusuf', '61', 'Deriska Ceelka', 88, 0, '2022-01-01'),
(542, 'maariyo daahir shidane', '61', 'Deriska Ceelka', 404, 0, '2022-01-01'),
(543, 'maxamed axmed maxamed ', '61', 'Deriska Ceelka', 35, 0, '2022-01-01'),
(544, 'maxamed macalin cismaan', '61', 'Deriska Ceelka', 197, 0, '2022-01-01'),
(545, 'sahro xasan maxamed', '61', 'Deriska Ceelka', 411, -0.000000178814, '2022-01-01'),
(546, 'kaaho axmed cosoble ', '61', 'Deriska Ceelka', 6, 15.6, '2022-01-01'),
(547, 'xasan nuur ducaale ', '61', 'Deriska Ceelka', 378, 16.9, '2022-01-01'),
(548, 'xasan nuur aadan ', '61', 'Deriska Ceelka', 254, 2.6, '2022-01-01'),
(549, 'abshiro muxumud jimcaale', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(550, 'malyuun xuuseen maxamed', '61', 'Deriska Ceelka', 607, 10.4, '2022-01-01'),
(551, 'axmed cabdi warsaMED ', '61', 'Deriska Ceelka', 153, 3.9, '2022-01-01'),
(552, 'MAXAMED cabdi muxumud ', '61', 'Deriska Ceelka', 134, 3.9, '2022-01-01'),
(553, 'siraad cali xalane', '61', 'Deriska Ceelka', 222, 0.000000089407, '2022-01-01'),
(554, 'c/raxmaan maxamuud qayliye', '61', 'Deriska Ceelka', 69, 15.6, '2022-01-01'),
(555, 'xaliimo codween', '61', 'Deriska Ceelka', 162, 0, '2022-01-01'),
(556, 'nadiifo cabdi xirsi ', '61', 'Deriska Ceelka', 275, -0.000000178814, '2022-01-01'),
(557, 'canbaro kadiye ', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(558, 'cali macalin ', '61', 'Deriska Ceelka', 57, -0.000000193715, '2022-01-01'),
(559, 'cali xaashi guure ', '61', 'Deriska Ceelka', 338, 11.7, '2022-01-01'),
(560, 'astaahil  maxamed ', '61', 'Deriska Ceelka', 546, -0.0999999, '2022-01-01'),
(561, 'nasro aadan ciise', '61', 'Deriska Ceelka', 210, 6.5, '2022-01-01'),
(562, 'shugri xasan xuseen ', '61', 'Deriska Ceelka', 21, 0, '2022-01-01'),
(563, 'xalwo bootaan ', '61', 'Deriska Ceelka', 314, 35.1, '2022-01-01'),
(564, 'maxamed cismaan iftin', '61', 'Deriska Ceelka', 273, -0.0999998, '2022-01-01'),
(565, 'maxamed xasan cilmi', '61', 'Deriska Ceelka', 227, 9.1, '2022-01-01'),
(566, 'yuusuf geedi cabdi', '61', 'Deriska Ceelka', 319, -0.000000953674, '2022-01-01'),
(567, 'c/naasir xirsi xaaji', '61', 'Deriska Ceelka', 210, -0.2, '2022-01-01'),
(568, 'canab c/laahi cilmi', '61', 'Deriska Ceelka', 50, 10.4, '2022-01-01'),
(569, 'cabdi fitaax daahir', '61', 'Deriska Ceelka', 20, 19.5, '2022-01-01'),
(570, 'nadiifo maxamed raage', '61', 'Deriska Ceelka', 51, 5.2, '2022-01-01'),
(571, 'nuur c/raxmaan yuusuf', '61', 'Deriska Ceelka', 50, 3.9, '2022-01-01'),
(572, 'c/raxmaan macalin cismaan ', '61', 'Deriska Ceelka', 179, 0, '2022-01-01'),
(573, 'kaaho axmed cosoble ', '61', 'Deriska Ceelka', 206, -0.00000038743, '2022-01-01'),
(574, 'faadumo xaahi', '61', 'Deriska Ceelka', 56, 5.2, '2022-01-01'),
(575, 'maxamed warsame xaashi ', '61', 'Deriska Ceelka', 166, 7.8, '2022-01-01'),
(576, 'xakiimo axmed nuur', '61', 'Deriska Ceelka', 200, 0.00000037998, '2022-01-01'),
(577, 'daahir xiimaay ', '61', 'Deriska Ceelka', 271, 36.4, '2022-01-01'),
(578, 'xaawo faarax bare', '61', 'Deriska Ceelka', 810, 15.6, '2022-01-01'),
(579, 'istaahil aadan shiikhoow', '61', 'Deriska Ceelka', 39, 0, '2022-01-01'),
(580, 'nsaro saciid shuuriye', '61', 'Deriska Ceelka', 55, 5.2, '2022-01-01'),
(581, 'jamaad daahir salaad', '61', 'Deriska Ceelka', 39, 2.6, '2022-01-01'),
(582, 'xaawo maxamed axmed', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(583, 'xaliimo axamed nuure', '61', 'Deriska Ceelka', 83, 11.7, '2022-01-01'),
(584, 'xaawo axmed cli ', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(585, 'khadiija axmed bare', '61', 'Deriska Ceelka', 185, -0.00000038743, '2022-01-01'),
(586, 'maxamed bulukeeti', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(587, 'dhuux cumar yiiroow', '61', 'Deriska Ceelka', 47, -0.0999999, '2022-01-01'),
(588, 'xabiibo cali abakar', '61', 'Deriska Ceelka', 24, 2.6, '2022-01-01'),
(589, 'naddiifo maxamed cali', '61', 'Deriska Ceelka', 81, 0.000000178814, '2022-01-01'),
(590, 'c/kariin shiikh muuse ', '61', 'Deriska Ceelka', 127, 9.1, '2022-01-01'),
(591, 'kiilo c/laahi culusow', '61', 'Deriska Ceelka', 30, 2.6, '2022-01-01'),
(592, 'nadiifo cumar maxamed ', '61', 'Deriska Ceelka', 10, -0.2, '2022-01-01'),
(593, 'Xaliimo C/raxman Cusmaan', '61', 'Deriska Ceelka', 84, 0, '2022-01-01'),
(594, 'Aamino Maxamed Cusman', '61', 'Deriska Ceelka', 103, 0, '2022-01-01'),
(595, 'Aweys Sheekh C/laahi', '61', 'Deriska Ceelka', 71, 0, '2022-01-01'),
(596, 'maxamed cumar Muse', '61', 'Deriska Ceelka', 87, 0, '2022-01-01'),
(597, 'bilan axmed cowl', '61', 'Deriska Ceelka', 0, 0, '2022-01-01'),
(598, 'maxamed xasan xaaji ', '61', 'Deriska Ceelka', 76, 10.4, '2022-01-01'),
(599, 'fartuun cismaan ', '61', 'Deriska Ceelka', 68, 9.1, '2022-01-01'),
(600, 'Cabdi raxmaan Cali', '61', 'Deriska Ceelka', 35, 0, '2022-01-01'),
(601, 'aways shiikh cabdi ', '61', 'Deriska Ceelka', 72, 9.1, '2022-01-01'),
(602, 'maxamed cilmi', '61', 'Deriska Ceelka', 606, 117, '2022-01-01'),
(603, 'sucdi qaasin ', '61', 'Deriska Ceelka', 194, 6.5, '2022-01-01'),
(604, 'shamsudiin macalin aadan ', '61', 'Deriska Ceelka', 96, -30, '2022-01-01'),
(605, 'rooble cismaan cali', '61', 'Deriska Ceelka', 73, 0, '2022-01-01'),
(606, 'cali xaashi maxamed', '61', 'Deriska Ceelka', 239, 0.000000089407, '2022-01-01'),
(607, '', '61', 'Deriska Ceelka', 0, -0.2, '2022-01-01'),
(608, 'macalin maxamuud', '61', 'Deriska Ceelka', 18, 2.4, '2022-01-01'),
(609, 'raxmo xaaji axmed', '61', 'Deriska Ceelka', 2, -0.2, '2022-01-01'),
(610, 'c/raxmaan ciise', '61', 'Deriska Ceelka', 49, 7.6, '2022-01-01'),
(611, '', '61', 'Deriska Ceelka', 99, 29.9, '2022-01-01'),
(612, 'faadumo maxamed farax', '61', 'Deriska Ceelka', 48, -0.0000000596046, '2022-01-01'),
(613, 'cabdulaahi maxamed xuseen', '61', 'Deriska Ceelka', 81, 0, '2022-01-01'),
(614, 'fowsiyo axmed warsame', '61', 'Deriska Ceelka', 130, 0.00000037998, '2022-01-01'),
(615, '', '61', 'Deriska Ceelka', 36, 2.6, '2022-01-01'),
(616, '', '61', 'Deriska Ceelka', 49, 0, '2022-01-01'),
(617, 'faadumo roole jimcaale', '61', 'Deriska Ceelka', 31, 5.2, '2022-01-01'),
(618, 'madiino xaaji axmed', '61', 'Deriska Ceelka', 39, 9.1, '2022-01-01'),
(619, 'maxmuud axmed jaamac', '61', 'Deriska Ceelka', 53, 9.1, '2022-01-01'),
(620, 'cabdi c/laahi', '61', 'Deriska Ceelka', 29, 3.9, '2022-01-01'),
(621, 'maryan maxamed nuur', '61', 'Deriska Ceelka', 33, 6.5, '2022-01-01'),
(622, 'faadumo deele', '61', 'Deriska Ceelka', 10, 5.2, '2022-01-01'),
(623, 'faadumo siciid ciiro', '61', 'Deriska Ceelka', 114, 9.1, '2022-01-01'),
(624, 'cumar xaashi culusoow', '61', 'Deriska Ceelka', 6, 5.2, '2022-01-01'),
(625, 'maxamed cali yare', '61', 'Deriska Ceelka', 25, 15.6, '2022-01-01'),
(626, 'maxamed cabdi', '61', 'Deriska Ceelka', 17, 13, '2022-01-01'),
(627, 'xasan cabdulaahi', '61', 'Deriska Ceelka', 3, 3.9, '2022-01-01'),
(628, 'sabiriin cali', '61', 'Deriska Ceelka', 13, 11.7, '2022-01-01'),
(629, 'Faadumo', '61', 'deriska ceelka', 0, 0, '2022-01-01');
INSERT INTO `customer` (`cust_id`, `CustomerName`, `contact`, `zone`, `MeterCube`, `fee`, `reg_date`) VALUES
(630, 'maxamuud cabdi jaamac', '61', 'Deriska Ceelka', 82, 2.6, '2022-01-01');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `emp_id` int(11) NOT NULL,
  `fullname` varchar(50) DEFAULT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `position` varchar(20) NOT NULL,
  `gender` varchar(11) NOT NULL,
  `birthdate` date DEFAULT NULL,
  `salary` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`emp_id`, `fullname`, `contact`, `position`, `gender`, `birthdate`, `salary`) VALUES
(1, 'Hussein Osman Salad', '615555252', 'Xamar Jadiid', 'Male', '1940-11-11', 0),
(2, 'Qarduunshe', '615552525', 'Xamar Jadiid', 'Male', '2021-12-02', 0);

-- --------------------------------------------------------

--
-- Table structure for table `invoice`
--

CREATE TABLE `invoice` (
  `invo_id` int(11) NOT NULL,
  `cust_id` int(11) NOT NULL,
  `mchore` float DEFAULT NULL,
  `mcdanbe` float DEFAULT NULL,
  `farqi` float DEFAULT NULL,
  `rate` float DEFAULT NULL,
  `balance` float DEFAULT NULL,
  `month_data` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `invoice`
--

INSERT INTO `invoice` (`invo_id`, `cust_id`, `mchore`, `mcdanbe`, `farqi`, `rate`, `balance`, `month_data`, `user_id`) VALUES
(1, 1, 338, 371, 33, 1.3, 42.9, '2022-01-31', 2),
(2, 3, 590, 606, 16, 1.3, 20.8, '2022-01-31', 2),
(3, 4, 146, 164, 18, 1.3, 23.4, '2022-01-31', 2),
(4, 5, 0, 18, 18, 1.3, 23.4, '2022-01-31', 2),
(5, 6, 233, 284, 51, 1.3, 66.3, '2022-01-31', 2),
(6, 7, 2971, 3084, 113, 1.3, 146.9, '2022-01-31', 2),
(7, 8, 1269, 1286, 17, 1.3, 22.1, '2022-01-31', 2),
(8, 9, 1079, 1095, 16, 1.3, 20.8, '2022-01-31', 2),
(9, 10, 612, 637, 25, 1.3, 32.5, '2022-01-31', 2),
(10, 11, 317, 327, 10, 1.3, 13, '2022-01-31', 2),
(11, 12, 1590, 1865, 275, 1.3, 357.5, '2022-01-31', 2),
(12, 13, 0, 8, 8, 1.3, 10.4, '2022-01-31', 2),
(13, 14, 1387, 1404, 17, 1.3, 22.1, '2022-01-31', 2),
(14, 15, 510, 510, 0, 1.3, 0, '2022-01-31', 2),
(15, 16, 187, 199, 12, 1.3, 15.6, '2022-01-31', 2),
(16, 18, 20, 32, 12, 1.3, 15.6, '2022-01-31', 2),
(17, 19, 1058, 1072, 14, 1.3, 18.2, '2022-01-31', 2),
(18, 21, 1369, 1435, 66, 1.3, 85.8, '2022-01-31', 2),
(19, 22, 111, 128, 17, 1.3, 22.1, '2022-01-31', 2),
(20, 23, 927, 944, 17, 1.3, 22.1, '2022-01-31', 2),
(21, 24, 0, 2, 2, 1.3, 2.6, '2022-01-31', 2),
(22, 25, 688, 701, 13, 1.3, 16.9, '2022-01-31', 2),
(23, 26, 417, 421, 4, 1.3, 5.2, '2022-01-31', 2),
(24, 27, 726, 743, 17, 1.3, 22.1, '2022-01-31', 2),
(25, 28, 606, 616, 10, 1.3, 13, '2022-01-31', 2),
(26, 29, 382, 395, 13, 1.3, 16.9, '2022-01-31', 2),
(27, 30, 195, 201, 6, 1.3, 7.8, '2022-01-31', 2),
(28, 31, 136, 139, 3, 1.3, 3.9, '2022-01-31', 2),
(29, 32, 1144, 1162, 18, 1.3, 23.4, '2022-01-31', 2),
(30, 33, 237, 239, 2, 1.3, 2.6, '2022-01-31', 2),
(31, 34, 1751, 1766, 15, 1.3, 19.5, '2022-01-31', 2),
(32, 35, 150, 185, 35, 1.3, 45.5, '2022-01-31', 2),
(33, 36, 1143, 1148, 5, 1.3, 6.5, '2022-01-31', 2),
(34, 37, 13, 29, 16, 1.3, 20.8, '2022-01-31', 2),
(35, 38, 343, 360, 17, 1.3, 22.1, '2022-01-31', 2),
(36, 39, 27, 35, 8, 1.3, 10.4, '2022-01-31', 2),
(37, 40, 227, 233, 6, 1.3, 7.8, '2022-01-31', 2),
(38, 41, 231, 253, 22, 1.3, 28.6, '2022-01-31', 2),
(39, 42, 684, 713, 29, 1.3, 37.7, '2022-01-31', 2),
(40, 43, 1405, 1425, 20, 1.3, 26, '2022-01-31', 2),
(41, 44, 272, 281, 9, 1.3, 11.7, '2022-01-31', 2),
(42, 45, 546, 574, 28, 1.3, 36.4, '2022-01-31', 2),
(43, 46, 560, 569, 9, 1.3, 11.7, '2022-01-31', 2),
(44, 47, 944, 965, 21, 1.3, 27.3, '2022-01-31', 2),
(45, 48, 150, 151, 1, 1.3, 1.3, '2022-01-31', 2),
(46, 49, 68, 98, 30, 1.3, 39, '2022-01-31', 2),
(47, 50, 485, 488, 3, 1.3, 3.9, '2022-01-31', 2),
(48, 51, 300, 346, 46, 1.3, 59.8, '2022-01-31', 2),
(49, 52, 0, 36, 36, 1.3, 46.8, '2022-01-31', 2),
(50, 53, 222, 228, 6, 1.3, 7.8, '2022-01-31', 2),
(51, 54, 132, 147, 15, 1.3, 19.5, '2022-01-31', 2),
(52, 55, 654, 664, 10, 1.3, 13, '2022-01-31', 2),
(53, 56, 0, 8, 8, 1.3, 10.4, '2022-01-31', 2),
(54, 57, 15, 27, 12, 1.3, 15.6, '2022-01-31', 2),
(55, 58, 0, 13, 13, 1.3, 16.9, '2022-01-31', 2),
(56, 59, 211, 228, 17, 1.3, 22.1, '2022-01-31', 2),
(57, 60, 36, 48, 12, 1.3, 15.6, '2022-01-31', 2),
(58, 61, 1688, 1724, 36, 1.3, 46.8, '2022-01-31', 2),
(59, 62, 900, 914, 14, 1.3, 18.2, '2022-01-31', 2),
(60, 63, 623, 642, 19, 1.3, 24.7, '2022-01-31', 2),
(61, 64, 119, 144, 25, 1.3, 32.5, '2022-01-31', 2),
(62, 65, 311, 315, 4, 1.3, 5.2, '2022-01-31', 2),
(63, 66, 1759, 1783, 24, 1.3, 31.2, '2022-01-31', 2),
(64, 67, 407, 425, 18, 1.3, 23.4, '2022-01-31', 2),
(65, 68, 1263, 1273, 10, 1.3, 13, '2022-01-31', 2),
(66, 69, 456, 491, 35, 1.3, 45.5, '2022-01-31', 2),
(67, 70, 744, 782, 38, 1.3, 49.4, '2022-01-31', 2),
(68, 71, 1053, 1056, 3, 1.3, 3.9, '2022-01-31', 2),
(69, 72, 303, 316, 13, 1.3, 16.9, '2022-01-31', 2),
(70, 73, 1243, 1260, 17, 1.3, 22.1, '2022-01-31', 2),
(71, 74, 967, 980, 13, 1.3, 16.9, '2022-01-31', 2),
(72, 75, 271, 290, 19, 1.3, 24.7, '2022-01-31', 2),
(73, 76, 882, 901, 19, 1.3, 24.7, '2022-01-31', 2),
(74, 77, 1081, 1106, 25, 1.3, 32.5, '2022-01-31', 2),
(75, 78, 1534, 1543, 9, 1.3, 11.7, '2022-01-31', 2),
(76, 79, 296, 321, 25, 1.3, 32.5, '2022-01-31', 2),
(77, 80, 281, 291, 10, 1.3, 13, '2022-01-31', 2),
(78, 81, 154, 176, 22, 1.3, 28.6, '2022-01-31', 2),
(79, 82, 953, 955, 2, 1.3, 2.6, '2022-01-31', 2),
(80, 83, 404, 430, 26, 1.3, 33.8, '2022-01-31', 2),
(81, 84, 217, 241, 24, 1.3, 31.2, '2022-01-31', 2),
(82, 85, 974, 988, 14, 1.3, 18.2, '2022-01-31', 2),
(83, 86, 898, 911, 13, 1.3, 16.9, '2022-01-31', 2),
(84, 87, 531, 537, 6, 1.3, 7.8, '2022-01-31', 2),
(85, 88, 159, 167, 8, 1.3, 10.4, '2022-01-31', 2),
(86, 89, 159, 170, 11, 1.3, 14.3, '2022-01-31', 2),
(87, 90, 1793, 1824, 31, 1.3, 40.3, '2022-01-31', 2),
(88, 91, 619, 634, 15, 1.3, 19.5, '2022-01-31', 2),
(89, 92, 1318, 1347, 29, 1.3, 37.7, '2022-01-31', 2),
(90, 93, 67, 74, 7, 1.3, 9.1, '2022-01-31', 2),
(91, 94, 78, 84, 6, 1.3, 7.8, '2022-01-31', 2),
(92, 95, 799, 807, 8, 1.3, 10.4, '2022-01-31', 2),
(93, 96, 1645, 1651, 6, 1.3, 7.8, '2022-01-31', 2),
(94, 97, 401, 424, 23, 1.3, 29.9, '2022-01-31', 2),
(95, 98, 1117, 1125, 8, 1.3, 10.4, '2022-01-31', 2),
(96, 99, 51, 61, 10, 1.3, 13, '2022-01-31', 2),
(97, 100, 107, 123, 16, 1.3, 20.8, '2022-01-31', 2),
(98, 102, 1030, 1052, 22, 1.3, 28.6, '2022-01-31', 2),
(99, 103, 1623, 1643, 20, 1.3, 26, '2022-01-31', 2),
(100, 104, 557, 568, 11, 1.3, 14.3, '2022-01-31', 2),
(101, 105, 275, 283, 8, 1.3, 10.4, '2022-01-31', 2),
(102, 106, 183, 203, 20, 1.3, 26, '2022-01-31', 2),
(103, 107, 174, 208, 34, 1.3, 44.2, '2022-01-31', 2),
(104, 108, 202, 218, 16, 1.3, 20.8, '2022-01-31', 2),
(105, 109, 110, 131, 21, 1.3, 27.3, '2022-01-31', 2),
(106, 110, 411, 426, 15, 1.3, 19.5, '2022-01-31', 2),
(107, 111, 70, 79, 9, 1.3, 11.7, '2022-01-31', 2),
(108, 112, 1115, 1126, 11, 1.3, 14.3, '2022-01-31', 2),
(109, 113, 1113, 1125, 12, 1.3, 15.6, '2022-01-31', 2),
(110, 114, 2302, 2313, 11, 1.3, 14.3, '2022-01-31', 2),
(111, 115, 96, 110, 14, 1.3, 18.2, '2022-01-31', 2),
(112, 116, 252, 264, 12, 1.3, 15.6, '2022-01-31', 2),
(113, 117, 300, 308, 8, 1.3, 10.4, '2022-01-31', 2),
(114, 118, 285, 295, 10, 1.3, 13, '2022-01-31', 2),
(115, 119, 609, 627, 18, 1.3, 23.4, '2022-01-31', 2),
(116, 120, 1122, 1140, 18, 1.3, 23.4, '2022-01-31', 2),
(117, 121, 337, 365, 28, 1.3, 36.4, '2022-01-31', 2),
(118, 122, 504, 524, 20, 1.3, 26, '2022-01-31', 2),
(119, 123, 491, 500, 9, 1.3, 11.7, '2022-01-31', 2),
(120, 124, 808, 844, 36, 1.3, 46.8, '2022-01-31', 2),
(121, 125, 75, 83, 8, 1.3, 10.4, '2022-01-31', 2),
(122, 126, 416, 428, 12, 1.3, 15.6, '2022-01-31', 2),
(123, 127, 1122, 1141, 19, 1.3, 24.7, '2022-01-31', 2),
(124, 128, 198, 215, 17, 1.3, 22.1, '2022-01-31', 2),
(125, 129, 1074, 1084, 10, 1.3, 13, '2022-01-31', 2),
(126, 130, 1820, 1857, 37, 1.3, 48.1, '2022-01-31', 2),
(127, 131, 1655, 1690, 35, 1.3, 45.5, '2022-01-31', 2),
(128, 132, 1229, 1246, 17, 1.3, 22.1, '2022-01-31', 2),
(129, 133, 400, 407, 7, 1.3, 9.1, '2022-01-31', 2),
(130, 134, 199, 208, 9, 1.3, 11.7, '2022-01-31', 2),
(131, 135, 243, 252, 9, 1.3, 11.7, '2022-01-31', 2),
(132, 136, 238, 263, 25, 1.3, 32.5, '2022-01-31', 2),
(133, 137, 2337, 2382, 45, 1.3, 58.5, '2022-01-31', 2),
(134, 139, 689, 709, 20, 1.3, 26, '2022-01-31', 2),
(135, 140, 364, 368, 4, 1.3, 5.2, '2022-01-31', 2),
(136, 141, 528, 541, 13, 1.3, 16.9, '2022-01-31', 2),
(137, 142, 1442, 1482, 40, 1.3, 52, '2022-01-31', 2),
(138, 143, 33, 44, 11, 1.3, 14.3, '2022-01-31', 2),
(139, 144, 463, 479, 16, 1.3, 20.8, '2022-01-31', 2),
(140, 145, 1777, 1815, 38, 1.3, 49.4, '2022-01-31', 2),
(141, 146, 1066, 1077, 11, 1.3, 14.3, '2022-01-31', 2),
(142, 147, 854, 874, 20, 1.3, 26, '2022-01-31', 2),
(143, 148, 176, 201, 25, 1.3, 32.5, '2022-01-31', 2),
(144, 149, 828, 841, 13, 1.3, 16.9, '2022-01-31', 2),
(145, 150, 1213, 1226, 13, 1.3, 16.9, '2022-01-31', 2),
(146, 152, 35, 41, 6, 1.3, 7.8, '2022-01-31', 2),
(147, 153, 260, 263, 3, 1.3, 3.9, '2022-01-31', 2),
(148, 154, 2421, 2585, 164, 1.3, 213.2, '2022-01-31', 2),
(149, 155, 126, 126, 0, 1.3, 0, '2022-01-31', 2),
(150, 157, 738, 751, 13, 1.3, 16.9, '2022-01-31', 2),
(151, 159, 1521, 1539, 18, 1.3, 23.4, '2022-01-31', 2),
(152, 160, 882, 913, 31, 1.3, 40.3, '2022-01-31', 2),
(153, 161, 623, 631, 8, 1.3, 10.4, '2022-01-31', 2),
(154, 162, 494, 503, 9, 1.3, 11.7, '2022-01-31', 2),
(155, 163, 51, 58, 7, 1.3, 9.1, '2022-01-31', 2),
(156, 164, 381, 387, 6, 1.3, 7.8, '2022-01-31', 2),
(157, 166, 242, 254, 12, 1.3, 15.6, '2022-01-31', 2),
(158, 168, 943, 970, 27, 1.3, 35.1, '2022-01-31', 2),
(159, 169, 522, 548, 26, 1.3, 33.8, '2022-01-31', 2),
(160, 170, 2024, 2032, 8, 1.3, 10.4, '2022-01-31', 2),
(161, 171, 750, 767, 17, 1.3, 22.1, '2022-01-31', 2),
(162, 172, 401, 411, 10, 1.3, 13, '2022-01-31', 2),
(163, 173, 330, 341, 11, 1.3, 14.3, '2022-01-31', 2),
(164, 174, 71, 91, 20, 1.3, 26, '2022-01-31', 2),
(165, 175, 1416, 1461, 45, 1.3, 58.5, '2022-01-31', 2),
(166, 176, 1137, 1158, 21, 1.3, 27.3, '2022-01-31', 2),
(167, 178, 103, 111, 8, 1.3, 10.4, '2022-01-31', 2),
(168, 179, 794, 814, 20, 1.3, 26, '2022-01-31', 2),
(169, 180, 66, 68, 2, 1.3, 2.6, '2022-01-31', 2),
(170, 182, 659, 668, 9, 1.3, 11.7, '2022-01-31', 2),
(171, 183, 88, 114, 26, 1.3, 33.8, '2022-01-31', 2),
(172, 184, 70, 72, 2, 1.3, 2.6, '2022-01-31', 2),
(173, 185, 648, 688, 40, 1.3, 52, '2022-01-31', 2),
(174, 186, 2116, 2161, 45, 1.3, 58.5, '2022-01-31', 2),
(175, 187, 383, 398, 15, 1.3, 19.5, '2022-01-31', 2),
(176, 188, 85, 108, 23, 1.3, 29.9, '2022-01-31', 2),
(177, 189, 748, 777, 29, 1.3, 37.7, '2022-01-31', 2),
(178, 190, 334, 350, 16, 1.3, 20.8, '2022-01-31', 2),
(179, 191, 1242, 1260, 18, 1.3, 23.4, '2022-01-31', 2),
(180, 192, 745, 759, 14, 1.3, 18.2, '2022-01-31', 2),
(181, 193, 923, 935, 12, 1.3, 15.6, '2022-01-31', 2),
(182, 194, 445, 452, 7, 1.3, 9.1, '2022-01-31', 2),
(183, 195, 78, 92, 14, 1.3, 18.2, '2022-01-31', 2),
(184, 196, 1031, 1046, 15, 1.3, 19.5, '2022-01-31', 2),
(185, 197, 441, 462, 21, 1.3, 27.3, '2022-01-31', 2),
(186, 199, 108, 113, 5, 1.3, 6.5, '2022-01-31', 2),
(187, 200, 145, 195, 50, 1.3, 65, '2022-01-31', 2),
(188, 201, 472, 497, 25, 1.3, 32.5, '2022-01-31', 2),
(189, 202, 1016, 1035, 19, 1.3, 24.7, '2022-01-31', 2),
(190, 203, 176, 192, 16, 1.3, 20.8, '2022-01-31', 2),
(191, 204, 1892, 1924, 32, 1.3, 41.6, '2022-01-31', 2),
(192, 206, 531, 543, 12, 1.3, 15.6, '2022-01-31', 2),
(193, 207, 497, 505, 8, 1.3, 10.4, '2022-01-31', 2),
(194, 208, 131, 141, 10, 1.3, 13, '2022-01-31', 2),
(195, 211, 285, 304, 19, 1.3, 24.7, '2022-01-31', 2),
(196, 212, 1225, 1232, 7, 1.3, 9.1, '2022-01-31', 2),
(197, 213, 771, 779, 8, 1.3, 10.4, '2022-01-31', 2),
(198, 214, 1662, 1692, 30, 1.3, 39, '2022-01-31', 2),
(199, 215, 2871, 2887, 16, 1.3, 20.8, '2022-01-31', 2),
(200, 216, 1086, 1106, 20, 1.3, 26, '2022-01-31', 2),
(201, 217, 178, 183, 5, 1.3, 6.5, '2022-01-31', 2),
(202, 218, 778, 792, 14, 1.3, 18.2, '2022-01-31', 2),
(203, 219, 1175, 1202, 27, 1.3, 35.1, '2022-01-31', 2),
(204, 220, 376, 401, 25, 1.3, 32.5, '2022-01-31', 2),
(205, 221, 307, 316, 9, 1.3, 11.7, '2022-01-31', 2),
(206, 222, 995, 1028, 33, 1.3, 42.9, '2022-01-31', 2),
(207, 223, 989, 1017, 28, 1.3, 36.4, '2022-01-31', 2),
(208, 224, 108, 121, 13, 1.3, 16.9, '2022-01-31', 2),
(209, 225, 1199, 1221, 22, 1.3, 28.6, '2022-01-31', 2),
(210, 226, 304, 319, 15, 1.3, 19.5, '2022-01-31', 2),
(211, 227, 88, 103, 15, 1.3, 19.5, '2022-01-31', 2),
(212, 228, 98, 110, 12, 1.3, 15.6, '2022-01-31', 2),
(213, 229, 523, 528, 5, 1.3, 6.5, '2022-01-31', 2),
(214, 230, 306, 318, 12, 1.3, 15.6, '2022-01-31', 2),
(215, 231, 803, 815, 12, 1.3, 15.6, '2022-01-31', 2),
(216, 232, 1133, 1142, 9, 1.3, 11.7, '2022-01-31', 2),
(217, 233, 134, 142, 8, 1.3, 10.4, '2022-01-31', 2),
(218, 234, 668, 683, 15, 1.3, 19.5, '2022-01-31', 2),
(219, 235, 20, 50, 30, 1.3, 39, '2022-01-31', 2),
(220, 236, 2013, 2044, 31, 1.3, 40.3, '2022-01-31', 2),
(221, 237, 349, 367, 18, 1.3, 23.4, '2022-01-31', 2),
(222, 238, 264, 275, 11, 1.3, 14.3, '2022-01-31', 2),
(223, 239, 150, 166, 16, 1.3, 20.8, '2022-01-31', 2),
(224, 240, 5583, 5712, 129, 1.3, 167.7, '2022-01-31', 2),
(225, 241, 170, 183, 13, 1.3, 16.9, '2022-01-31', 2),
(226, 242, 0, 16, 16, 1.3, 20.8, '2022-01-31', 2),
(227, 243, 543, 561, 18, 1.3, 23.4, '2022-01-31', 2),
(228, 244, 74, 85, 11, 1.3, 14.3, '2022-01-31', 2),
(229, 245, 749, 765, 16, 1.3, 20.8, '2022-01-31', 2),
(230, 246, 1463, 1478, 15, 1.3, 19.5, '2022-01-31', 2),
(231, 247, 278, 299, 21, 1.3, 27.3, '2022-01-31', 2),
(232, 248, 452, 460, 8, 1.3, 10.4, '2022-01-31', 2),
(233, 249, 589, 613, 24, 1.3, 31.2, '2022-01-31', 2),
(234, 250, 654, 666, 12, 1.3, 15.6, '2022-01-31', 2),
(235, 251, 832, 850, 18, 1.3, 23.4, '2022-01-31', 2),
(236, 252, 50, 65, 15, 1.3, 19.5, '2022-01-31', 2),
(237, 253, 115, 120, 5, 1.3, 6.5, '2022-01-31', 2),
(238, 254, 524, 528, 4, 1.3, 5.2, '2022-01-31', 2),
(239, 255, 218, 220, 2, 1.3, 2.6, '2022-01-31', 2),
(240, 256, 1178, 1185, 7, 1.3, 9.1, '2022-01-31', 2),
(241, 257, 602, 607, 5, 1.3, 6.5, '2022-01-31', 2),
(242, 258, 379, 386, 7, 1.3, 9.1, '2022-01-31', 2),
(243, 260, 461, 467, 6, 1.3, 7.8, '2022-01-31', 2),
(244, 261, 522, 524, 2, 1.3, 2.6, '2022-01-31', 2),
(245, 262, 550, 569, 19, 1.3, 24.7, '2022-01-31', 2),
(246, 263, 729, 733, 4, 1.3, 5.2, '2022-01-31', 2),
(247, 264, 178, 180, 2, 1.3, 2.6, '2022-01-31', 2),
(248, 265, 344, 349, 5, 1.3, 6.5, '2022-01-31', 2),
(249, 266, 316, 334, 18, 1.3, 23.4, '2022-01-31', 2),
(250, 268, 449, 452, 3, 1.3, 3.9, '2022-01-31', 2),
(251, 269, 365, 367, 2, 1.3, 2.6, '2022-01-31', 2),
(252, 270, 265, 267, 2, 1.3, 2.6, '2022-01-31', 2),
(253, 271, 610, 615, 5, 1.3, 6.5, '2022-01-31', 2),
(254, 272, 1364, 1381, 17, 1.3, 22.1, '2022-01-31', 2),
(255, 273, 402, 407, 5, 1.3, 6.5, '2022-01-31', 2),
(256, 274, 813, 823, 10, 1.3, 13, '2022-01-31', 2),
(257, 275, 75, 80, 5, 1.3, 6.5, '2022-01-31', 2),
(258, 276, 294, 296, 2, 1.3, 2.6, '2022-01-31', 2),
(259, 278, 322, 327, 5, 1.3, 6.5, '2022-01-31', 2),
(260, 279, 67, 83, 16, 1.3, 20.8, '2022-01-31', 2),
(261, 280, 199, 203, 4, 1.3, 5.2, '2022-01-31', 2),
(262, 281, 354, 358, 4, 1.3, 5.2, '2022-01-31', 2),
(263, 282, 233, 241, 8, 1.3, 10.4, '2022-01-31', 2),
(264, 283, 684, 698, 14, 1.3, 18.2, '2022-01-31', 2),
(265, 284, 127, 130, 3, 1.3, 3.9, '2022-01-31', 2),
(266, 285, 820, 827, 7, 1.3, 9.1, '2022-01-31', 2),
(267, 286, 328, 336, 8, 1.3, 10.4, '2022-01-31', 2),
(268, 287, 610, 620, 10, 1.3, 13, '2022-01-31', 2),
(269, 288, 421, 428, 7, 1.3, 9.1, '2022-01-31', 2),
(270, 289, 1171, 1175, 4, 1.3, 5.2, '2022-01-31', 2),
(271, 290, 189, 196, 7, 1.3, 9.1, '2022-01-31', 2),
(272, 291, 279, 280, 1, 1.3, 1.3, '2022-01-31', 2),
(273, 292, 881, 891, 10, 1.3, 13, '2022-01-31', 2),
(274, 293, 76, 82, 6, 1.3, 7.8, '2022-01-31', 2),
(275, 294, 334, 341, 7, 1.3, 9.1, '2022-01-31', 2),
(276, 295, 65, 73, 8, 1.3, 10.4, '2022-01-31', 2),
(277, 296, 841, 849, 8, 1.3, 10.4, '2022-01-31', 2),
(278, 297, 55, 62, 7, 1.3, 9.1, '2022-01-31', 2),
(279, 299, 929, 935, 6, 1.3, 7.8, '2022-01-31', 2),
(280, 300, 428, 435, 7, 1.3, 9.1, '2022-01-31', 2),
(281, 301, 110, 117, 7, 1.3, 9.1, '2022-01-31', 2),
(282, 303, 513, 521, 8, 1.3, 10.4, '2022-01-31', 2),
(283, 304, 777, 792, 15, 1.3, 19.5, '2022-01-31', 2),
(284, 305, 653, 665, 12, 1.3, 15.6, '2022-01-31', 2),
(285, 306, 749, 763, 14, 1.3, 18.2, '2022-01-31', 2),
(286, 307, 470, 476, 6, 1.3, 7.8, '2022-01-31', 2),
(287, 308, 47, 50, 3, 1.3, 3.9, '2022-01-31', 2),
(288, 309, 181, 193, 12, 1.3, 15.6, '2022-01-31', 2),
(289, 310, 167, 178, 11, 1.3, 14.3, '2022-01-31', 2),
(290, 311, 231, 237, 6, 1.3, 7.8, '2022-01-31', 2),
(291, 312, 396, 421, 25, 1.3, 32.5, '2022-01-31', 2),
(292, 313, 149, 158, 9, 1.3, 11.7, '2022-01-31', 2),
(293, 314, 175, 178, 3, 1.3, 3.9, '2022-01-31', 2),
(294, 315, 780, 791, 11, 1.3, 14.3, '2022-01-31', 2),
(295, 316, 572, 581, 9, 1.3, 11.7, '2022-01-31', 2),
(296, 317, 507, 511, 4, 1.3, 5.2, '2022-01-31', 2),
(297, 318, 606, 614, 8, 1.3, 10.4, '2022-01-31', 2),
(298, 319, 604, 608, 4, 1.3, 5.2, '2022-01-31', 2),
(299, 320, 708, 712, 4, 1.3, 5.2, '2022-01-31', 2),
(300, 322, 417, 432, 15, 1.3, 19.5, '2022-01-31', 2),
(301, 323, 228, 235, 7, 1.3, 9.1, '2022-01-31', 2),
(302, 324, 1006, 1013, 7, 1.3, 9.1, '2022-01-31', 2),
(303, 325, 1632, 1639, 7, 1.3, 9.1, '2022-01-31', 2),
(304, 326, 698, 701, 3, 1.3, 3.9, '2022-01-31', 2),
(305, 327, 432, 442, 10, 1.3, 13, '2022-01-31', 2),
(306, 328, 719, 723, 4, 1.3, 5.2, '2022-01-31', 2),
(307, 329, 492, 500, 8, 1.3, 10.4, '2022-01-31', 2),
(308, 330, 732, 744, 12, 1.3, 15.6, '2022-01-31', 2),
(309, 331, 323, 328, 5, 1.3, 6.5, '2022-01-31', 2),
(310, 332, 1121, 1142, 21, 1.3, 27.3, '2022-01-31', 2),
(311, 333, 347, 352, 5, 1.3, 6.5, '2022-01-31', 2),
(312, 334, 851, 860, 9, 1.3, 11.7, '2022-01-31', 2),
(313, 335, 495, 498, 3, 1.3, 3.9, '2022-01-31', 2),
(314, 336, 39, 47, 8, 1.3, 10.4, '2022-01-31', 2),
(315, 337, 174, 181, 7, 1.3, 9.1, '2022-01-31', 2),
(316, 338, 619, 630, 11, 1.3, 14.3, '2022-01-31', 2),
(317, 339, 409, 417, 8, 1.3, 10.4, '2022-01-31', 2),
(318, 340, 891, 898, 7, 1.3, 9.1, '2022-01-31', 2),
(319, 341, 421, 426, 5, 1.3, 6.5, '2022-01-31', 2),
(320, 342, 374, 383, 9, 1.3, 11.7, '2022-01-31', 2),
(321, 343, 460, 463, 3, 1.3, 3.9, '2022-01-31', 2),
(322, 344, 428, 435, 7, 1.3, 9.1, '2022-01-31', 2),
(323, 345, 912, 917, 5, 1.3, 6.5, '2022-01-31', 2),
(324, 346, 540, 547, 7, 1.3, 9.1, '2022-01-31', 2),
(325, 348, 6, 19, 13, 1.3, 16.9, '2022-01-31', 2),
(326, 349, 124, 127, 3, 1.3, 3.9, '2022-01-31', 2),
(327, 353, 119, 122, 3, 1.3, 3.9, '2022-01-31', 2),
(328, 354, 140, 148, 8, 1.3, 10.4, '2022-01-31', 2),
(329, 355, 113, 118, 5, 1.3, 6.5, '2022-01-31', 2),
(330, 357, 66, 70, 4, 1.3, 5.2, '2022-01-31', 2),
(331, 358, 214, 222, 8, 1.3, 10.4, '2022-01-31', 2),
(332, 359, 524, 528, 4, 1.3, 5.2, '2022-01-31', 2),
(333, 360, 121, 131, 10, 1.3, 13, '2022-01-31', 2),
(334, 362, 678, 683, 5, 1.3, 6.5, '2022-01-31', 2),
(335, 363, 547, 551, 4, 1.3, 5.2, '2022-01-31', 2),
(336, 364, 554, 560, 6, 1.3, 7.8, '2022-01-31', 2),
(337, 365, 411, 419, 8, 1.3, 10.4, '2022-01-31', 2),
(338, 366, 385, 395, 10, 1.3, 13, '2022-01-31', 2),
(339, 367, 466, 472, 6, 1.3, 7.8, '2022-01-31', 2),
(340, 368, 796, 806, 10, 1.3, 13, '2022-01-31', 2),
(341, 369, 172, 181, 9, 1.3, 11.7, '2022-01-31', 2),
(342, 370, 366, 372, 6, 1.3, 7.8, '2022-01-31', 2),
(343, 371, 335, 341, 6, 1.3, 7.8, '2022-01-31', 2),
(344, 372, 159, 165, 6, 1.3, 7.8, '2022-01-31', 2),
(345, 373, 283, 289, 6, 1.3, 7.8, '2022-01-31', 2),
(346, 374, 627, 633, 6, 1.3, 7.8, '2022-01-31', 2),
(347, 375, 561, 571, 10, 1.3, 13, '2022-01-31', 2),
(348, 376, 397, 405, 8, 1.3, 10.4, '2022-01-31', 2),
(349, 377, 1303, 1311, 8, 1.3, 10.4, '2022-01-31', 2),
(350, 378, 656, 660, 4, 1.3, 5.2, '2022-01-31', 2),
(351, 379, 235, 251, 16, 1.3, 20.8, '2022-01-31', 2),
(352, 380, 238, 239, 1, 1.3, 1.3, '2022-01-31', 2),
(353, 381, 628, 633, 5, 1.3, 6.5, '2022-01-31', 2),
(354, 382, 712, 719, 7, 1.3, 9.1, '2022-01-31', 2),
(355, 383, 513, 520, 7, 1.3, 9.1, '2022-01-31', 2),
(356, 384, 68, 77, 9, 1.3, 11.7, '2022-01-31', 2),
(357, 385, 622, 633, 11, 1.3, 14.3, '2022-01-31', 2),
(358, 386, 261, 263, 2, 1.3, 2.6, '2022-01-31', 2),
(359, 387, 508, 516, 8, 1.3, 10.4, '2022-01-31', 2),
(360, 388, 391, 397, 6, 1.3, 7.8, '2022-01-31', 2),
(361, 389, 262, 270, 8, 1.3, 10.4, '2022-01-31', 2),
(362, 390, 406, 418, 12, 1.3, 15.6, '2022-01-31', 2),
(363, 391, 495, 501, 6, 1.3, 7.8, '2022-01-31', 2),
(364, 392, 172, 175, 3, 1.3, 3.9, '2022-01-31', 2),
(365, 393, 605, 617, 12, 1.3, 15.6, '2022-01-31', 2),
(366, 394, 184, 189, 5, 1.3, 6.5, '2022-01-31', 2),
(367, 395, 212, 218, 6, 1.3, 7.8, '2022-01-31', 2),
(368, 396, 439, 449, 10, 1.3, 13, '2022-01-31', 2),
(369, 397, 83, 86, 3, 1.3, 3.9, '2022-01-31', 2),
(370, 398, 3648, 3659, 11, 1.3, 14.3, '2022-01-31', 2),
(371, 399, 298, 303, 5, 1.3, 6.5, '2022-01-31', 2),
(372, 400, 707, 715, 8, 1.3, 10.4, '2022-01-31', 2),
(373, 401, 167, 168, 1, 1.3, 1.3, '2022-01-31', 2),
(374, 402, 312, 318, 6, 1.3, 7.8, '2022-01-31', 2),
(375, 403, 1172, 1182, 10, 1.3, 13, '2022-01-31', 2),
(376, 404, 43, 52, 9, 1.3, 11.7, '2022-01-31', 2),
(377, 405, 1219, 1228, 9, 1.3, 11.7, '2022-01-31', 2),
(378, 406, 229, 239, 10, 1.3, 13, '2022-01-31', 2),
(379, 407, 537, 541, 4, 1.3, 5.2, '2022-01-31', 2),
(380, 408, 549, 561, 12, 1.3, 15.6, '2022-01-31', 2),
(381, 409, 540, 546, 6, 1.3, 7.8, '2022-01-31', 2),
(382, 410, 187, 195, 8, 1.3, 10.4, '2022-01-31', 2),
(383, 411, 6, 10, 4, 1.3, 5.2, '2022-01-31', 2),
(384, 412, 529, 539, 10, 1.3, 13, '2022-01-31', 2),
(385, 413, 169, 173, 4, 1.3, 5.2, '2022-01-31', 2),
(386, 414, 557, 562, 5, 1.3, 6.5, '2022-01-31', 2),
(387, 415, 752, 762, 10, 1.3, 13, '2022-01-31', 2),
(388, 416, 447, 455, 8, 1.3, 10.4, '2022-01-31', 2),
(389, 417, 334, 339, 5, 1.3, 6.5, '2022-01-31', 2),
(390, 418, 559, 563, 4, 1.3, 5.2, '2022-01-31', 2),
(391, 419, 330, 332, 2, 1.3, 2.6, '2022-01-31', 2),
(392, 420, 1307, 1315, 8, 1.3, 10.4, '2022-01-31', 2),
(393, 421, 852, 860, 8, 1.3, 10.4, '2022-01-31', 2),
(394, 422, 32, 38, 6, 1.3, 7.8, '2022-01-31', 2),
(395, 423, 67, 75, 8, 1.3, 10.4, '2022-01-31', 2),
(396, 424, 23, 49, 26, 1.3, 33.8, '2022-01-31', 2),
(397, 425, 398, 403, 5, 1.3, 6.5, '2022-01-31', 2),
(398, 426, 0, 5, 5, 1.3, 6.5, '2022-01-31', 2),
(399, 427, 626, 632, 6, 1.3, 7.8, '2022-01-31', 2),
(400, 428, 48, 55, 7, 1.3, 9.1, '2022-01-31', 2),
(401, 429, 522, 546, 24, 1.3, 31.2, '2022-01-31', 2),
(402, 430, 364, 380, 16, 1.3, 20.8, '2022-01-31', 2),
(403, 431, 56, 76, 20, 1.3, 26, '2022-01-31', 2),
(404, 433, 41, 56, 15, 1.3, 19.5, '2022-01-31', 2),
(405, 434, 294, 298, 4, 1.3, 5.2, '2022-01-31', 2),
(406, 435, 582, 595, 13, 1.3, 16.9, '2022-01-31', 2),
(407, 436, 565, 573, 8, 1.3, 10.4, '2022-01-31', 2),
(408, 437, 558, 571, 13, 1.3, 16.9, '2022-01-31', 2),
(409, 438, 27, 42, 15, 1.3, 19.5, '2022-01-31', 2),
(410, 439, 103, 141, 38, 1.3, 49.4, '2022-01-31', 2),
(411, 440, 757, 771, 14, 1.3, 18.2, '2022-01-31', 2),
(412, 441, 374, 390, 16, 1.3, 20.8, '2022-01-31', 2),
(413, 442, 1329, 1348, 19, 1.3, 24.7, '2022-01-31', 2),
(414, 443, 0, 3, 3, 1.3, 3.9, '2022-01-31', 2),
(415, 444, 159, 161, 2, 1.3, 2.6, '2022-01-31', 2),
(416, 445, 735, 739, 4, 1.3, 5.2, '2022-01-31', 2),
(417, 446, 13, 18, 5, 1.3, 6.5, '2022-01-31', 2),
(418, 447, 73, 76, 3, 1.3, 3.9, '2022-01-31', 2),
(419, 448, 430, 436, 6, 1.3, 7.8, '2022-01-31', 2),
(420, 449, 187, 190, 3, 1.3, 3.9, '2022-01-31', 2),
(421, 450, 83, 87, 4, 1.3, 5.2, '2022-01-31', 2),
(422, 452, 360, 374, 14, 1.3, 18.2, '2022-01-31', 2),
(423, 453, 58, 75, 17, 1.3, 22.1, '2022-01-31', 2),
(424, 454, 404, 409, 5, 1.3, 6.5, '2022-01-31', 2),
(425, 455, 536, 545, 9, 1.3, 11.7, '2022-01-31', 2),
(426, 456, 114, 131, 17, 1.3, 22.1, '2022-01-31', 2),
(427, 457, 361, 365, 4, 1.3, 5.2, '2022-01-31', 2),
(428, 458, 31, 33, 2, 1.3, 2.6, '2022-01-31', 2),
(429, 459, 6, 7, 1, 1.3, 1.3, '2022-01-31', 2),
(430, 460, 237, 240, 3, 1.3, 3.9, '2022-01-31', 2),
(431, 461, 136, 143, 7, 1.3, 9.1, '2022-01-31', 2),
(432, 462, 302, 311, 9, 1.3, 11.7, '2022-01-31', 2),
(433, 463, 348, 354, 6, 1.3, 7.8, '2022-01-31', 2),
(434, 464, 563, 570, 7, 1.3, 9.1, '2022-01-31', 2),
(435, 465, 729, 735, 6, 1.3, 7.8, '2022-01-31', 2),
(436, 466, 539, 548, 9, 1.3, 11.7, '2022-01-31', 2),
(437, 467, 464, 470, 6, 1.3, 7.8, '2022-01-31', 2),
(438, 468, 357, 360, 3, 1.3, 3.9, '2022-01-31', 2),
(439, 469, 49, 53, 4, 1.3, 5.2, '2022-01-31', 2),
(440, 470, 6, 12, 6, 1.3, 7.8, '2022-01-31', 2),
(441, 471, 56, 60, 4, 1.3, 5.2, '2022-01-31', 2),
(442, 473, 318, 321, 3, 1.3, 3.9, '2022-01-31', 2),
(443, 474, 634, 646, 12, 1.3, 15.6, '2022-01-31', 2),
(444, 475, 633, 639, 6, 1.3, 7.8, '2022-01-31', 2),
(445, 477, 201, 205, 4, 1.3, 5.2, '2022-01-31', 2),
(446, 478, 447, 451, 4, 1.3, 5.2, '2022-01-31', 2),
(447, 479, 430, 435, 5, 1.3, 6.5, '2022-01-31', 2),
(448, 480, 254, 256, 2, 1.3, 2.6, '2022-01-31', 2),
(449, 481, 792, 797, 5, 1.3, 6.5, '2022-01-31', 2),
(450, 482, 622, 632, 10, 1.3, 13, '2022-01-31', 2),
(451, 483, 306, 311, 5, 1.3, 6.5, '2022-01-31', 2),
(452, 484, 13, 19, 6, 1.3, 7.8, '2022-01-31', 2),
(453, 485, 347, 355, 8, 1.3, 10.4, '2022-01-31', 2),
(454, 486, 268, 271, 3, 1.3, 3.9, '2022-01-31', 2),
(455, 487, 443, 449, 6, 1.3, 7.8, '2022-01-31', 2),
(456, 488, 420, 426, 6, 1.3, 7.8, '2022-01-31', 2),
(457, 489, 338, 351, 13, 1.3, 16.9, '2022-01-31', 2),
(458, 490, 294, 299, 5, 1.3, 6.5, '2022-01-31', 2),
(459, 491, 90, 91, 1, 1.3, 1.3, '2022-01-31', 2),
(460, 492, 259, 265, 6, 1.3, 7.8, '2022-01-31', 2),
(461, 493, 163, 166, 3, 1.3, 3.9, '2022-01-31', 2),
(462, 494, 225, 229, 4, 1.3, 5.2, '2022-01-31', 2),
(463, 495, 293, 298, 5, 1.3, 6.5, '2022-01-31', 2),
(464, 497, 477, 478, 1, 1.3, 1.3, '2022-01-31', 2),
(465, 498, 162, 168, 6, 1.3, 7.8, '2022-01-31', 2),
(466, 499, 164, 165, 1, 1.3, 1.3, '2022-01-31', 2),
(467, 500, 282, 287, 5, 1.3, 6.5, '2022-01-31', 2),
(468, 501, 194, 199, 5, 1.3, 6.5, '2022-01-31', 2),
(469, 502, 395, 406, 11, 1.3, 14.3, '2022-01-31', 2),
(470, 503, 286, 290, 4, 1.3, 5.2, '2022-01-31', 2),
(471, 504, 224, 230, 6, 1.3, 7.8, '2022-01-31', 2),
(472, 505, 352, 358, 6, 1.3, 7.8, '2022-01-31', 2),
(473, 507, 459, 467, 8, 1.3, 10.4, '2022-01-31', 2),
(474, 508, 220, 226, 6, 1.3, 7.8, '2022-01-31', 2),
(475, 509, 436, 449, 13, 1.3, 16.9, '2022-01-31', 2),
(476, 510, 137, 142, 5, 1.3, 6.5, '2022-01-31', 2),
(477, 512, 261, 264, 3, 1.3, 3.9, '2022-01-31', 2),
(478, 513, 51, 68, 17, 1.3, 22.1, '2022-01-31', 2),
(479, 514, 299, 311, 12, 1.3, 15.6, '2022-01-31', 2),
(480, 515, 39, 42, 3, 1.3, 3.9, '2022-01-31', 2),
(481, 516, 6, 10, 4, 1.3, 5.2, '2022-01-31', 2),
(482, 517, 202, 208, 6, 1.3, 7.8, '2022-01-31', 2),
(483, 518, 179, 182, 3, 1.3, 3.9, '2022-01-31', 2),
(484, 519, 121, 126, 5, 1.3, 6.5, '2022-01-31', 2),
(485, 520, 474, 482, 8, 1.3, 10.4, '2022-01-31', 2),
(486, 521, 581, 599, 18, 1.3, 23.4, '2022-01-31', 2),
(487, 522, 220, 225, 5, 1.3, 6.5, '2022-01-31', 2),
(488, 523, 272, 279, 7, 1.3, 9.1, '2022-01-31', 2),
(489, 524, 255, 257, 2, 1.3, 2.6, '2022-01-31', 2),
(490, 525, 288, 294, 6, 1.3, 7.8, '2022-01-31', 2),
(491, 527, 67, 72, 5, 1.3, 6.5, '2022-01-31', 2),
(492, 528, 270, 277, 7, 1.3, 9.1, '2022-01-31', 2),
(493, 529, 711, 724, 13, 1.3, 16.9, '2022-01-31', 2),
(494, 530, 67, 68, 1, 1.3, 1.3, '2022-01-31', 2),
(495, 531, 66, 70, 4, 1.3, 5.2, '2022-01-31', 2),
(496, 532, 465, 479, 14, 1.3, 18.2, '2022-01-31', 2),
(497, 533, 18, 26, 8, 1.3, 10.4, '2022-01-31', 2),
(498, 534, 29, 35, 6, 1.3, 7.8, '2022-01-31', 2),
(499, 535, 181, 184, 3, 1.3, 3.9, '2022-01-31', 2),
(500, 536, 55, 60, 5, 1.3, 6.5, '2022-01-31', 2),
(501, 538, 121, 127, 6, 1.3, 7.8, '2022-01-31', 2),
(502, 539, 189, 193, 4, 1.3, 5.2, '2022-01-31', 2),
(503, 540, 425, 446, 21, 1.3, 27.3, '2022-01-31', 2),
(504, 541, 83, 88, 5, 1.3, 6.5, '2022-01-31', 2),
(505, 542, 395, 404, 9, 1.3, 11.7, '2022-01-31', 2),
(506, 543, 32, 35, 3, 1.3, 3.9, '2022-01-31', 2),
(507, 544, 192, 197, 5, 1.3, 6.5, '2022-01-31', 2),
(508, 545, 402, 411, 9, 1.3, 11.7, '2022-01-31', 2),
(509, 546, 0, 6, 6, 1.3, 7.8, '2022-01-31', 2),
(510, 547, 372, 378, 6, 1.3, 7.8, '2022-01-31', 2),
(511, 550, 599, 607, 8, 1.3, 10.4, '2022-01-31', 2),
(512, 551, 151, 153, 2, 1.3, 2.6, '2022-01-31', 2),
(513, 552, 131, 134, 3, 1.3, 3.9, '2022-01-31', 2),
(514, 553, 219, 222, 3, 1.3, 3.9, '2022-01-31', 2),
(515, 554, 56, 69, 13, 1.3, 16.9, '2022-01-31', 2),
(516, 555, 152, 162, 10, 1.3, 13, '2022-01-31', 2),
(517, 556, 266, 275, 9, 1.3, 11.7, '2022-01-31', 2),
(518, 558, 53, 57, 4, 1.3, 5.2, '2022-01-31', 2),
(519, 559, 329, 338, 9, 1.3, 11.7, '2022-01-31', 2),
(520, 560, 543, 546, 3, 1.3, 3.9, '2022-01-31', 2),
(521, 563, 299, 314, 15, 1.3, 19.5, '2022-01-31', 2),
(522, 564, 270, 273, 3, 1.3, 3.9, '2022-01-31', 2),
(523, 565, 221, 227, 6, 1.3, 7.8, '2022-01-31', 2),
(524, 566, 298, 319, 21, 1.3, 27.3, '2022-01-31', 2),
(525, 567, 204, 210, 6, 1.3, 7.8, '2022-01-31', 2),
(526, 568, 45, 50, 5, 1.3, 6.5, '2022-01-31', 2),
(527, 569, 12, 20, 8, 1.3, 10.4, '2022-01-31', 2),
(528, 570, 49, 51, 2, 1.3, 2.6, '2022-01-31', 2),
(529, 571, 44, 50, 6, 1.3, 7.8, '2022-01-31', 2),
(530, 573, 198, 206, 8, 1.3, 10.4, '2022-01-31', 2),
(531, 574, 52, 56, 4, 1.3, 5.2, '2022-01-31', 2),
(532, 575, 160, 166, 6, 1.3, 7.8, '2022-01-31', 2),
(533, 576, 193, 200, 7, 1.3, 9.1, '2022-01-31', 2),
(534, 577, 258, 271, 13, 1.3, 16.9, '2022-01-31', 2),
(535, 578, 798, 810, 12, 1.3, 15.6, '2022-01-31', 2),
(536, 579, 31, 39, 8, 1.3, 10.4, '2022-01-31', 2),
(537, 580, 51, 55, 4, 1.3, 5.2, '2022-01-31', 2),
(538, 581, 38, 39, 1, 1.3, 1.3, '2022-01-31', 2),
(539, 585, 177, 185, 8, 1.3, 10.4, '2022-01-31', 2),
(540, 587, 44, 47, 3, 1.3, 3.9, '2022-01-31', 2),
(541, 588, 22, 24, 2, 1.3, 2.6, '2022-01-31', 2),
(542, 589, 75, 81, 6, 1.3, 7.8, '2022-01-31', 2),
(543, 590, 120, 127, 7, 1.3, 9.1, '2022-01-31', 2),
(544, 591, 29, 30, 1, 1.3, 1.3, '2022-01-31', 2),
(545, 592, 4, 10, 6, 1.3, 7.8, '2022-01-31', 2),
(546, 594, 100, 103, 3, 1.3, 3.9, '2022-01-31', 2),
(547, 595, 68, 71, 3, 1.3, 3.9, '2022-01-31', 2),
(548, 596, 82, 87, 5, 1.3, 6.5, '2022-01-31', 2),
(549, 598, 68, 76, 8, 1.3, 10.4, '2022-01-31', 2),
(550, 599, 64, 68, 4, 1.3, 5.2, '2022-01-31', 2),
(551, 600, 30, 35, 5, 1.3, 6.5, '2022-01-31', 2),
(552, 601, 65, 72, 7, 1.3, 9.1, '2022-01-31', 2),
(553, 602, 574, 606, 32, 1.3, 41.6, '2022-01-31', 2),
(554, 603, 189, 194, 5, 1.3, 6.5, '2022-01-31', 2),
(555, 604, 88, 96, 8, 1.3, 10.4, '2022-01-31', 2),
(556, 605, 63, 73, 10, 1.3, 13, '2022-01-31', 2),
(557, 606, 236, 239, 3, 1.3, 3.9, '2022-01-31', 2),
(558, 608, 18, 18, 0, 1.3, 0, '2022-01-31', 2),
(559, 610, 43, 49, 6, 1.3, 7.8, '2022-01-31', 2),
(560, 611, 76, 99, 23, 1.3, 29.9, '2022-01-31', 2),
(561, 612, 47, 48, 1, 1.3, 1.3, '2022-01-31', 2),
(562, 613, 68, 81, 13, 1.3, 16.9, '2022-01-31', 2),
(563, 614, 123, 130, 7, 1.3, 9.1, '2022-01-31', 2),
(564, 615, 34, 36, 2, 1.3, 2.6, '2022-01-31', 2),
(565, 616, 47, 49, 2, 1.3, 2.6, '2022-01-31', 2),
(566, 617, 27, 31, 4, 1.3, 5.2, '2022-01-31', 2),
(567, 618, 32, 39, 7, 1.3, 9.1, '2022-01-31', 2),
(568, 619, 46, 53, 7, 1.3, 9.1, '2022-01-31', 2),
(569, 620, 26, 29, 3, 1.3, 3.9, '2022-01-31', 2),
(570, 621, 28, 33, 5, 1.3, 6.5, '2022-01-31', 2),
(571, 622, 6, 10, 4, 1.3, 5.2, '2022-01-31', 2),
(572, 623, 107, 114, 7, 1.3, 9.1, '2022-01-31', 2),
(573, 624, 2, 6, 4, 1.3, 5.2, '2022-01-31', 2),
(574, 625, 13, 25, 12, 1.3, 15.6, '2022-01-31', 2),
(575, 626, 7, 17, 10, 1.3, 13, '2022-01-31', 2),
(576, 627, 0, 3, 3, 1.3, 3.9, '2022-01-31', 2),
(577, 628, 4, 13, 9, 1.3, 11.7, '2022-01-31', 2),
(578, 630, 80, 82, 2, 1.3, 2.6, '2022-01-31', 2);

--
-- Triggers `invoice`
--
DELIMITER $$
CREATE TRIGGER `change_cust_back` BEFORE DELETE ON `invoice` FOR EACH ROW UPDATE customer c SET c.MeterCube=old.mchore, c.fee=(fee-old.balance) WHERE c.cust_id=old.cust_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `change_cust_transaction` AFTER INSERT ON `invoice` FOR EACH ROW UPDATE customer c SET c.MeterCube=new.mcdanbe, c.fee=(fee+new.balance) WHERE c.cust_id=new.cust_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `po_id` int(11) NOT NULL,
  `supp_id` int(11) DEFAULT NULL,
  `amoun_pay` int(11) DEFAULT NULL,
  `discount` int(11) DEFAULT NULL,
  `remainder` int(11) DEFAULT NULL,
  `from_acc` int(11) DEFAULT NULL,
  `month_date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `payment`
--
DELIMITER $$
CREATE TRIGGER `delete_fromacc` BEFORE DELETE ON `payment` FOR EACH ROW UPDATE accoun a SET a.balance=(balance+old.amoun_pay) WHERE a.acc_id=old.from_acc
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `delete_supp` BEFORE DELETE ON `payment` FOR EACH ROW UPDATE supplier s SET s.balance=(balance+old.amoun_pay+old.discount) WHERE s.supp_id=old.supp_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `from_acc_min` AFTER INSERT ON `payment` FOR EACH ROW UPDATE accoun a SET a.balance=(balance-new.amoun_pay) WHERE a.acc_id=new.from_acc
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tacc_supp` AFTER INSERT ON `payment` FOR EACH ROW UPDATE supplier s SET s.balance=(balance-new.amoun_pay-new.discount) WHERE s.supp_id= new.supp_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `rate`
--

CREATE TABLE `rate` (
  `id` int(11) NOT NULL,
  `Amount_Type` varchar(20) NOT NULL,
  `rate` float(11,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `rate`
--

INSERT INTO `rate` (`id`, `Amount_Type`, `rate`) VALUES
(1, 'Dollar', 1.3),
(2, 'Cash', 30.0);

-- --------------------------------------------------------

--
-- Table structure for table `receipt`
--

CREATE TABLE `receipt` (
  `rv_id` int(11) NOT NULL,
  `cust_id` int(11) DEFAULT NULL,
  `amount` float DEFAULT NULL,
  `discount` float DEFAULT NULL,
  `remainder` float DEFAULT NULL,
  `to_acc` int(11) DEFAULT NULL,
  `month_date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `receipt`
--

INSERT INTO `receipt` (`rv_id`, `cust_id`, `amount`, `discount`, `remainder`, `to_acc`, `month_date`, `user_id`) VALUES
(1, 3, 19.5, 1.3, 0, 1, '2022-01-31', 2),
(2, 4, 23, 0.4, 0, 1, '2022-01-31', 2),
(3, 5, 23, 0.4, 0, 1, '2022-01-31', 2),
(4, 7, 146.9, 0, 0, 1, '2022-01-31', 2),
(5, 9, 20.5, 0.3, 0, 1, '2022-01-31', 2),
(6, 10, 31, 1.5, 0, 1, '2022-01-31', 2),
(7, 11, 13, 0, 0, 1, '2022-01-31', 2),
(8, 12, 113.1, 0, 0, 1, '2022-01-31', 2),
(9, 13, 10, 0.4, 0, 1, '2022-01-31', 2),
(10, 14, 22, 0.1, 0, 1, '2022-01-31', 2),
(11, 16, 15.5, 0, 0, 1, '2022-01-31', 2),
(12, 18, 15, 0.6, 0, 1, '2022-01-31', 2),
(13, 19, 16, 2.2, 0, 1, '2022-01-31', 2),
(14, 21, 70, 15.8, 0, 1, '2022-01-31', 2),
(15, 22, 20, 2.1, 0, 1, '2022-01-31', 2),
(16, 23, 22, 0.1, 0, 1, '2022-01-31', 2),
(17, 24, 2.6, 0, 0, 1, '2022-01-31', 2),
(18, 25, 17, 0, 0, 1, '2022-01-31', 2),
(19, 26, 5, 0.2, 0, 1, '2022-01-31', 2),
(20, 27, 20, 2.1, 0, 1, '2022-01-31', 2),
(21, 28, 13, 0, 0, 1, '2022-01-31', 2),
(22, 29, 18, 0, 0, 1, '2022-01-31', 2),
(23, 30, 7, 0.8, 0, 1, '2022-01-31', 2),
(24, 31, 3.9, 0, 0, 1, '2022-01-31', 2),
(25, 32, 21, 2.4, 0, 1, '2022-01-31', 2),
(26, 33, 2.5, 0.1, 0, 1, '2022-01-31', 2),
(27, 34, 19, 0.5, 0, 1, '2022-01-31', 2),
(28, 35, 40, 5.5, 0, 1, '2022-01-31', 2),
(29, 36, 6.5, 0, 0, 1, '2022-01-31', 2),
(30, 38, 22, 0.1, 0, 1, '2022-01-31', 2),
(31, 39, 10.4, 0, 0, 1, '2022-01-31', 2),
(32, 40, 7.8, 0, 0, 1, '2022-01-31', 2),
(33, 41, 28, 0.6, 0, 1, '2022-01-31', 2),
(34, 42, 37, 0.7, 0, 1, '2022-01-31', 2),
(35, 43, 24, 2, 0, 1, '2022-01-31', 2),
(36, 44, 11.5, 0.2, 0, 1, '2022-01-31', 2),
(37, 45, 33, 3.4, 0, 1, '2022-01-31', 2),
(38, 46, 10, 1.7, 0, 1, '2022-01-31', 2),
(39, 49, 37, 2, 0, 1, '2022-01-31', 2),
(40, 50, 3.5, 0.4, 0, 1, '2022-01-31', 2),
(41, 51, 40, 19.8, 0, 1, '2022-01-31', 2),
(42, 52, 43, 3.8, 0, 1, '2022-01-31', 2),
(43, 53, 7, 0.8, 0, 1, '2022-01-31', 2),
(44, 54, 19, 0.5, 0, 1, '2022-01-31', 2),
(45, 55, 12, 1, 0, 1, '2022-01-31', 2),
(46, 56, 10, 0.4, 0, 1, '2022-01-31', 2),
(47, 57, 15, 0.6, 0, 1, '2022-01-31', 2),
(48, 58, 16.5, 0.4, 0, 1, '2022-01-31', 2),
(49, 59, 22, 0.1, 0, 1, '2022-01-31', 2),
(50, 60, 15.6, 0, 0, 1, '2022-01-31', 2),
(51, 61, 46, 0.8, 0, 1, '2022-01-31', 2),
(52, 62, 18, 0.2, 0, 1, '2022-01-31', 2),
(53, 63, 20, 4.7, 0, 1, '2022-01-31', 2),
(54, 64, 27.5, 5, 0, 1, '2022-01-31', 2),
(55, 65, 5, 0.2, 0, 1, '2022-01-31', 2),
(56, 67, 22, 1.4, 0, 1, '2022-01-31', 2),
(57, 68, 13, 0, 0, 1, '2022-01-31', 2),
(58, 69, 40, 5.5, 0, 1, '2022-01-31', 2),
(59, 70, 44, 5.4, 0, 1, '2022-01-31', 2),
(60, 72, 16, 0.9, 0, 1, '2022-01-31', 2),
(61, 73, 22, 0.1, 0, 1, '2022-01-31', 2),
(62, 74, 16, 0.9, 0, 1, '2022-01-31', 2),
(63, 75, 20, 4.7, 0, 1, '2022-01-31', 2),
(64, 76, 24, 0.7, 0, 1, '2022-01-31', 2),
(65, 77, 32, 0.5, 0, 1, '2022-01-31', 2),
(66, 78, 11.5, 0.2, 0, 1, '2022-01-31', 2),
(67, 79, 30, 2.5, 0, 1, '2022-01-31', 2),
(68, 80, 12, 1, 0, 1, '2022-01-31', 2),
(69, 81, 26, 2.6, 0, 1, '2022-01-31', 2),
(70, 82, 2.5, 1, 0, 1, '2022-01-31', 2),
(71, 83, 32, 1.8, 0, 1, '2022-01-31', 2),
(72, 85, 15, 3.2, 0, 1, '2022-01-31', 2),
(73, 86, 15, 1.9, 0, 1, '2022-01-31', 2),
(74, 87, 7.8, 0, 0, 1, '2022-01-31', 2),
(75, 88, 10, 0.4, 0, 1, '2022-01-31', 2),
(76, 90, 36.9, 3.4, 0, 1, '2022-01-31', 2),
(77, 91, 19, 0.5, 0, 1, '2022-01-31', 2),
(78, 92, 35, 2.7, 0, 1, '2022-01-31', 2),
(79, 93, 9, 0.1, 0, 1, '2022-01-31', 2),
(80, 94, 7, 0.8, 0, 1, '2022-01-31', 2),
(81, 95, 10, 0.4, 0, 1, '2022-01-31', 2),
(82, 96, 7.8, 0, 0, 1, '2022-01-31', 2),
(83, 97, 25, 4.9, 0, 1, '2022-01-31', 2),
(84, 99, 13, 0, 0, 1, '2022-01-31', 2),
(85, 100, 20, 8.6, 0, 1, '2022-01-31', 2),
(86, 103, 25, 1, 0, 1, '2022-01-31', 2),
(87, 106, 26, 0, 0, 1, '2022-01-31', 2),
(88, 107, 40, 4.2, 0, 1, '2022-01-31', 2),
(89, 108, 17, 3.8, 0, 1, '2022-01-31', 2),
(90, 109, 27, 0.3, 0, 1, '2022-01-31', 2),
(91, 110, 19, 0.5, 0, 1, '2022-01-31', 2),
(92, 111, 11.7, 0, 0, 1, '2022-01-31', 2),
(93, 116, 15.6, 0, 0, 1, '2022-01-31', 2),
(94, 117, 10, 0.4, 0, 1, '2022-01-31', 2),
(95, 118, 13, 0, 0, 1, '2022-01-31', 2),
(96, 119, 22, 1.4, 0, 1, '2022-01-31', 2),
(97, 120, 22, 1.4, 0, 1, '2022-01-31', 2),
(98, 121, 36, 0.4, 0, 1, '2022-01-31', 2),
(99, 123, 12, 0, 0, 1, '2022-01-31', 2),
(100, 125, 10, 0.4, 0, 1, '2022-01-31', 2),
(101, 127, 24, 0.7, 0, 1, '2022-01-31', 2),
(102, 128, 22, 0.1, 0, 1, '2022-01-31', 2),
(103, 129, 13, 0, 0, 1, '2022-01-31', 2),
(104, 133, 9.1, 0, 0, 1, '2022-01-31', 2),
(105, 134, 11, 0.7, 0, 1, '2022-01-31', 2),
(106, 135, 11.7, 0, 0, 1, '2022-01-31', 2),
(107, 136, 31, 1.5, 0, 1, '2022-01-31', 2),
(108, 137, 50, 8.5, 0, 1, '2022-01-31', 2),
(109, 139, 22, 4, 0, 1, '2022-01-31', 2),
(110, 140, 5, 0.2, 0, 1, '2022-01-31', 2),
(111, 141, 16.5, 0.4, 0, 1, '2022-01-31', 2),
(112, 142, 31, 0, 21, 1, '2022-01-31', 2),
(113, 143, 14, 0.3, 0, 1, '2022-01-31', 2),
(114, 144, 20.5, 0.3, 0, 1, '2022-01-31', 2),
(115, 146, 14, 0.3, 0, 1, '2022-01-31', 2),
(116, 148, 32.5, 0, 0, 1, '2022-01-31', 2),
(117, 149, 16, 0.9, 0, 1, '2022-01-31', 2),
(118, 150, 16, 0, 0, 1, '2022-01-31', 2),
(119, 152, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(120, 153, 4, 0, 0, 1, '2022-01-31', 2),
(121, 154, 209, 4.2, 0, 1, '2022-01-31', 2),
(122, 157, 16.9, 0, 0, 1, '2022-01-31', 2),
(123, 158, 6, 0, 0, 1, '2022-01-31', 2),
(124, 160, 20, 20.3, 0, 1, '2022-01-31', 2),
(125, 161, 10, 0.4, 0, 1, '2022-01-31', 2),
(126, 162, 10, 1.7, 0, 1, '2022-01-31', 2),
(127, 164, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(128, 166, 13, 2.6, 0, 1, '2022-01-31', 2),
(129, 168, 30, 5.1, 0, 1, '2022-01-31', 2),
(130, 170, 10, 0.4, 0, 1, '2022-01-31', 2),
(131, 171, 22, 0.1, 0, 1, '2022-01-31', 2),
(132, 172, 13, 0, 0, 1, '2022-01-31', 2),
(133, 173, 14, 0.3, 0, 1, '2022-01-31', 2),
(134, 174, 26, 0, 0, 1, '2022-01-31', 2),
(135, 175, 40, 18.5, 0, 1, '2022-01-31', 2),
(136, 176, 25, 2.3, 0, 1, '2022-01-31', 2),
(137, 178, 10, 0.4, 0, 1, '2022-01-31', 2),
(138, 179, 24, 2, 0, 1, '2022-01-31', 2),
(139, 180, 2, 0.6, 0, 1, '2022-01-31', 2),
(140, 182, 11, 0.7, 0, 1, '2022-01-31', 2),
(141, 183, 32, 1.8, 0, 1, '2022-01-31', 2),
(142, 184, 2.5, 0.1, 0, 1, '2022-01-31', 2),
(143, 185, 50, 2, 0, 1, '2022-01-31', 2),
(144, 186, 48, 10.5, 0, 1, '2022-01-31', 2),
(145, 187, 19.5, 0, 0, 1, '2022-01-31', 2),
(146, 188, 28, 1.9, 0, 1, '2022-01-31', 2),
(147, 191, 20, 3.4, 0, 1, '2022-01-31', 2),
(148, 192, 18, 0.2, 0, 1, '2022-01-31', 2),
(149, 193, 15, 0.6, 0, 1, '2022-01-31', 2),
(150, 194, 9, 0.1, 0, 1, '2022-01-31', 2),
(151, 195, 17, 1.2, 0, 1, '2022-01-31', 2),
(152, 196, 19, 0.5, 0, 1, '2022-01-31', 2),
(153, 197, 27, 0.3, 0, 1, '2022-01-31', 2),
(154, 199, 6, 0.5, 0, 1, '2022-01-31', 2),
(155, 200, 65, 0, 0, 1, '2022-01-31', 2),
(156, 201, 30, 2.5, 0, 1, '2022-01-31', 2),
(157, 202, 22, 2.7, 0, 1, '2022-01-31', 2),
(158, 203, 20, 0.8, 0, 1, '2022-01-31', 2),
(159, 206, 14, 0, 0, 1, '2022-01-31', 2),
(160, 207, 10, 0.4, 0, 1, '2022-01-31', 2),
(161, 208, 10, 3, 0, 1, '2022-01-31', 2),
(162, 211, 20, 4.7, 0, 1, '2022-01-31', 2),
(163, 212, 9, 0.1, 0, 1, '2022-01-31', 2),
(164, 213, 10, 0.4, 0, 1, '2022-01-31', 2),
(165, 214, 35, 4, 0, 1, '2022-01-31', 2),
(166, 216, 25, 1, 0, 1, '2022-01-31', 2),
(167, 217, 6.5, 0, 0, 1, '2022-01-31', 2),
(168, 219, 34, 1.1, 0, 1, '2022-01-31', 2),
(169, 220, 32.5, 0, 0, 1, '2022-01-31', 2),
(170, 221, 11, 0.7, 0, 1, '2022-01-31', 2),
(171, 222, 42, 0.9, 0, 1, '2022-01-31', 2),
(172, 224, 16, 0.9, 0, 1, '2022-01-31', 2),
(173, 226, 19, 0.5, 0, 1, '2022-01-31', 2),
(174, 227, 19, 0.5, 0, 1, '2022-01-31', 2),
(175, 228, 14, 1.6, 0, 1, '2022-01-31', 2),
(176, 229, 6.5, 0, 0, 1, '2022-01-31', 2),
(177, 230, 15, 0.6, 0, 1, '2022-01-31', 2),
(178, 231, 14, 1.6, 0, 1, '2022-01-31', 2),
(179, 233, 10.4, 0, 0, 1, '2022-01-31', 2),
(180, 234, 19.5, 0, 0, 1, '2022-01-31', 2),
(181, 235, 36, 3, 0, 1, '2022-01-31', 2),
(182, 237, 23, 0.4, 0, 1, '2022-01-31', 2),
(183, 238, 14, 0.3, 0, 1, '2022-01-31', 2),
(184, 239, 20, 0.8, 0, 1, '2022-01-31', 2),
(185, 242, 20, 0.8, 0, 1, '2022-01-31', 2),
(186, 243, 20, 3.4, 0, 1, '2022-01-31', 2),
(187, 244, 14, 0.3, 0, 1, '2022-01-31', 2),
(188, 246, 19, 0.5, 0, 1, '2022-01-31', 2),
(189, 247, 24, 3.3, 0, 1, '2022-01-31', 2),
(190, 248, 10, 0.4, 0, 1, '2022-01-31', 2),
(191, 249, 30, 1.2, 0, 1, '2022-01-31', 2),
(192, 251, 22.5, 0.9, 0, 1, '2022-01-31', 2),
(193, 254, 5, 0.2, 0, 1, '2022-01-31', 2),
(194, 255, 2.6, 0, 0, 1, '2022-01-31', 2),
(195, 258, 9, 0.1, 0, 1, '2022-01-31', 2),
(196, 260, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(197, 264, 2.5, 0.1, 0, 1, '2022-01-31', 2),
(198, 265, 6.5, 0, 0, 1, '2022-01-31', 2),
(199, 266, 23, 0.4, 0, 1, '2022-01-31', 2),
(200, 268, 4, 0, 0, 1, '2022-01-31', 2),
(201, 269, 2.5, 0.1, 0, 1, '2022-01-31', 2),
(202, 271, 6, 0.5, 0, 1, '2022-01-31', 2),
(203, 272, 20, 2.1, 0, 1, '2022-01-31', 2),
(204, 274, 13, 0, 0, 1, '2022-01-31', 2),
(205, 276, 2, 0.6, 0, 1, '2022-01-31', 2),
(206, 278, 6, 0.5, 0, 1, '2022-01-31', 2),
(207, 280, 4, 1.2, 0, 1, '2022-01-31', 2),
(208, 283, 18, 0.2, 0, 1, '2022-01-31', 2),
(209, 285, 8, 1.1, 0, 1, '2022-01-31', 2),
(210, 287, 13, 0, 0, 1, '2022-01-31', 2),
(211, 288, 9, 0.1, 0, 1, '2022-01-31', 2),
(212, 291, 1, 0.3, 0, 1, '2022-01-31', 2),
(213, 292, 13, 0, 0, 1, '2022-01-31', 2),
(214, 293, 7.8, 0, 0, 1, '2022-01-31', 2),
(215, 294, 9, 0.1, 0, 1, '2022-01-31', 2),
(216, 295, 10, 0.4, 0, 1, '2022-01-31', 2),
(217, 297, 9, 0.1, 0, 1, '2022-01-31', 2),
(218, 300, 9, 0.1, 0, 1, '2022-01-31', 2),
(219, 303, 10, 0.4, 0, 1, '2022-01-31', 2),
(220, 304, 19, 0.5, 0, 1, '2022-01-31', 2),
(221, 306, 18, 0.2, 0, 1, '2022-01-31', 2),
(222, 307, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(223, 308, 3.9, 0, 0, 1, '2022-01-31', 2),
(224, 309, 15, 0.6, 0, 1, '2022-01-31', 2),
(225, 310, 13, 1.3, 0, 1, '2022-01-31', 2),
(226, 311, 7.8, 0, 0, 1, '2022-01-31', 2),
(227, 313, 11.5, 0.2, 0, 1, '2022-01-31', 2),
(228, 314, 3.5, 0.4, 0, 1, '2022-01-31', 2),
(229, 317, 5.2, 0, 0, 1, '2022-01-31', 2),
(230, 318, 10, 0.4, 0, 1, '2022-01-31', 2),
(231, 319, 5, 0.2, 0, 1, '2022-01-31', 2),
(232, 320, 5, 0.2, 0, 1, '2022-01-31', 2),
(233, 322, 19, 0.5, 0, 1, '2022-01-31', 2),
(234, 323, 9, 0.1, 0, 1, '2022-01-31', 2),
(235, 324, 9, 0.1, 0, 1, '2022-01-31', 2),
(236, 325, 9, 0.1, 0, 1, '2022-01-31', 2),
(237, 326, 3.9, 0, 0, 1, '2022-01-31', 2),
(238, 328, 5, 0.2, 0, 1, '2022-01-31', 2),
(239, 329, 10, 0.4, 0, 1, '2022-01-31', 2),
(240, 331, 5, 1.5, 0, 1, '2022-01-31', 2),
(241, 334, 11.5, 0.2, 0, 1, '2022-01-31', 2),
(242, 335, 3.9, 0, 0, 1, '2022-01-31', 2),
(243, 336, 9, 1.4, 0, 1, '2022-01-31', 2),
(244, 337, 9, 0.1, 0, 1, '2022-01-31', 2),
(245, 338, 13, 1.3, 0, 1, '2022-01-31', 2),
(246, 339, 10, 0.4, 0, 1, '2022-01-31', 2),
(247, 340, 9, 0.1, 0, 1, '2022-01-31', 2),
(248, 341, 6.5, 0, 0, 1, '2022-01-31', 2),
(249, 342, 10.5, 1.2, 0, 1, '2022-01-31', 2),
(250, 343, 4, 0, 0, 1, '2022-01-31', 2),
(251, 344, 9, 0.1, 0, 1, '2022-01-31', 2),
(252, 345, 6.5, 0, 0, 1, '2022-01-31', 2),
(253, 348, 11, 5.9, 0, 1, '2022-01-31', 2),
(254, 349, 3.5, 0.4, 0, 1, '2022-01-31', 2),
(255, 353, 3.9, 0, 0, 1, '2022-01-31', 2),
(256, 357, 5.2, 0, 0, 1, '2022-01-31', 2),
(257, 360, 13, 0, 0, 1, '2022-01-31', 2),
(258, 362, 6.5, 0, 0, 1, '2022-01-31', 2),
(259, 364, 7.8, 0, 0, 1, '2022-01-31', 2),
(260, 365, 10, 0.4, 0, 1, '2022-01-31', 2),
(261, 366, 12, 1, 0, 1, '2022-01-31', 2),
(262, 369, 11, 0.7, 0, 1, '2022-01-31', 2),
(263, 370, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(264, 371, 8, 0, 0, 1, '2022-01-31', 2),
(265, 372, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(266, 373, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(267, 374, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(268, 376, 9, 1.4, 0, 1, '2022-01-31', 2),
(269, 377, 10, 0.4, 0, 1, '2022-01-31', 2),
(270, 378, 5, 0.2, 0, 1, '2022-01-31', 2),
(271, 381, 6.5, 0, 0, 1, '2022-01-31', 2),
(272, 382, 9, 0.1, 0, 1, '2022-01-31', 2),
(273, 384, 9, 2.7, 0, 1, '2022-01-31', 2),
(274, 385, 13, 1.3, 0, 1, '2022-01-31', 2),
(275, 386, 2.6, 0, 0, 1, '2022-01-31', 2),
(276, 389, 10, 0.4, 0, 1, '2022-01-31', 2),
(277, 390, 15, 0.6, 0, 1, '2022-01-31', 2),
(278, 391, 7, 0.8, 0, 1, '2022-01-31', 2),
(279, 394, 6.5, 0, 0, 1, '2022-01-31', 2),
(280, 395, 7, 0.8, 0, 1, '2022-01-31', 2),
(281, 396, 13, 0, 0, 1, '2022-01-31', 2),
(282, 401, 1.5, 0, 0, 1, '2022-01-31', 2),
(283, 402, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(284, 403, 12, 1, 0, 1, '2022-01-31', 2),
(285, 407, 5, 0.2, 0, 1, '2022-01-31', 2),
(286, 408, 14, 1.6, 0, 1, '2022-01-31', 2),
(287, 409, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(288, 411, 5, 0.2, 0, 1, '2022-01-31', 2),
(289, 413, 5, 0.2, 0, 1, '2022-01-31', 2),
(290, 414, 6, 0.5, 0, 1, '2022-01-31', 2),
(291, 415, 13, 0, 0, 1, '2022-01-31', 2),
(292, 416, 10, 0.4, 0, 1, '2022-01-31', 2),
(293, 417, 6.5, 0, 0, 1, '2022-01-31', 2),
(294, 419, 2.5, 0.1, 0, 1, '2022-01-31', 2),
(295, 422, 7, 0.8, 0, 1, '2022-01-31', 2),
(296, 423, 9, 1.4, 0, 1, '2022-01-31', 2),
(297, 425, 6.5, 0, 0, 1, '2022-01-31', 2),
(298, 426, 6.5, 0, 0, 1, '2022-01-31', 2),
(299, 428, 9, 0.1, 0, 1, '2022-01-31', 2),
(300, 429, 28, 0, 0, 1, '2022-01-31', 2),
(301, 430, 19, 1.8, 0, 1, '2022-01-31', 2),
(302, 431, 26, 0, 0, 1, '2022-01-31', 2),
(303, 433, 19.5, 0, 0, 1, '2022-01-31', 2),
(304, 436, 10, 0.4, 0, 1, '2022-01-31', 2),
(305, 438, 19, 0.5, 0, 1, '2022-01-31', 2),
(306, 440, 18, 0.2, 0, 1, '2022-01-31', 2),
(307, 441, 18, 2.8, 0, 1, '2022-01-31', 2),
(308, 442, 24, 0.7, 0, 1, '2022-01-31', 2),
(309, 445, 5, 0.2, 0, 1, '2022-01-31', 2),
(310, 446, 6, 0.5, 0, 1, '2022-01-31', 2),
(311, 449, 3, 0.9, 0, 1, '2022-01-31', 2),
(312, 450, 5, 0.2, 0, 1, '2022-01-31', 2),
(313, 452, 18, 0.2, 0, 1, '2022-01-31', 2),
(314, 453, 22, 0.1, 0, 1, '2022-01-31', 2),
(315, 455, 11, 0.7, 0, 1, '2022-01-31', 2),
(316, 458, 2.6, 0, 0, 1, '2022-01-31', 2),
(317, 461, 8.9, 0.2, 0, 1, '2022-01-31', 2),
(318, 462, 10, 1.7, 0, 1, '2022-01-31', 2),
(319, 463, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(320, 465, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(321, 468, 3.5, 0.4, 0, 1, '2022-01-31', 2),
(322, 469, 5, 0.2, 0, 1, '2022-01-31', 2),
(323, 470, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(324, 471, 5, 0.2, 0, 1, '2022-01-31', 2),
(325, 474, 15, 0.6, 0, 1, '2022-01-31', 2),
(326, 475, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(327, 478, 5, 0.2, 0, 1, '2022-01-31', 2),
(328, 479, 6.5, 0, 0, 1, '2022-01-31', 2),
(329, 480, 2.5, 0.1, 0, 1, '2022-01-31', 2),
(330, 481, 6, 0.5, 0, 1, '2022-01-31', 2),
(331, 486, 3, 0.9, 0, 1, '2022-01-31', 2),
(332, 487, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(333, 488, 7.8, 0, 0, 1, '2022-01-31', 2),
(334, 489, 15, 1.9, 0, 1, '2022-01-31', 2),
(335, 490, 6.5, 0, 0, 1, '2022-01-31', 2),
(336, 492, 7, 0.8, 0, 1, '2022-01-31', 2),
(337, 493, 3.5, 0.4, 0, 1, '2022-01-31', 2),
(338, 494, 5, 0.2, 0, 1, '2022-01-31', 2),
(339, 501, 6.5, 0, 0, 1, '2022-01-31', 2),
(340, 502, 14, 0.3, 0, 1, '2022-01-31', 2),
(341, 505, 7, 0.8, 0, 1, '2022-01-31', 2),
(342, 508, 7, 0.8, 0, 1, '2022-01-31', 2),
(343, 510, 6.5, 0, 0, 1, '2022-01-31', 2),
(344, 512, 3.5, 0.4, 0, 1, '2022-01-31', 2),
(345, 513, 22, 0.1, 0, 1, '2022-01-31', 2),
(346, 514, 15, 0.6, 0, 1, '2022-01-31', 2),
(347, 515, 3.5, 0.4, 0, 1, '2022-01-31', 2),
(348, 517, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(349, 519, 5, 1.5, 0, 1, '2022-01-31', 2),
(350, 521, 15, 8.4, 0, 1, '2022-01-31', 2),
(351, 522, 6, 0.5, 0, 1, '2022-01-31', 2),
(352, 524, 2.5, 0.1, 0, 1, '2022-01-31', 2),
(353, 533, 10, 0.4, 0, 1, '2022-01-31', 2),
(354, 534, 7, 0.8, 0, 1, '2022-01-31', 2),
(355, 535, 3.9, 0, 0, 1, '2022-01-31', 2),
(356, 537, 14, 0, 0, 1, '2022-01-31', 2),
(357, 538, 7.5, 0.3, 0, 1, '2022-01-31', 2),
(358, 540, 23, 4.3, 0, 1, '2022-01-31', 2),
(359, 541, 6, 0.5, 0, 1, '2022-01-31', 2),
(360, 542, 11.7, 0, 0, 1, '2022-01-31', 2),
(361, 543, 3.9, 0, 0, 1, '2022-01-31', 2),
(362, 544, 6, 0.5, 0, 1, '2022-01-31', 2),
(363, 545, 11, 0.7, 0, 1, '2022-01-31', 2),
(364, 546, 7.8, 0, 0, 1, '2022-01-31', 2),
(365, 551, 2.5, 0.1, 0, 1, '2022-01-31', 2),
(366, 552, 3.5, 0.4, 0, 1, '2022-01-31', 2),
(367, 553, 3.5, 0.4, 0, 1, '2022-01-31', 2),
(368, 554, 16.9, 0, 0, 1, '2022-01-31', 2),
(369, 555, 12, 1, 0, 1, '2022-01-31', 2),
(370, 556, 11, 0.7, 0, 1, '2022-01-31', 2),
(371, 558, 5, 0.2, 0, 1, '2022-01-31', 2),
(372, 559, 10, 1.7, 0, 1, '2022-01-31', 2),
(373, 560, 4, 0, 0, 1, '2022-01-31', 2),
(374, 564, 3.5, 0.4, 0, 1, '2022-01-31', 2),
(375, 565, 7, 0.8, 0, 1, '2022-01-31', 2),
(376, 566, 23, 4.3, 0, 1, '2022-01-31', 2),
(377, 567, 8, 0, 0, 1, '2022-01-31', 2),
(378, 571, 7, 0.8, 0, 1, '2022-01-31', 2),
(379, 573, 10, 0.4, 0, 1, '2022-01-31', 2),
(380, 576, 9, 0.1, 0, 1, '2022-01-31', 2),
(381, 579, 10.4, 0, 0, 1, '2022-01-31', 2),
(382, 581, 1, 0.3, 0, 1, '2022-01-31', 2),
(383, 585, 10, 0.4, 0, 1, '2022-01-31', 2),
(384, 587, 4, 0, 0, 1, '2022-01-31', 2),
(385, 589, 7, 0.8, 0, 1, '2022-01-31', 2),
(386, 590, 9, 0.1, 0, 1, '2022-01-31', 2),
(387, 592, 8, 0, 0, 1, '2022-01-31', 2),
(388, 594, 3.9, 0, 0, 1, '2022-01-31', 2),
(389, 595, 3.9, 0, 0, 1, '2022-01-31', 2),
(390, 596, 6.5, 0, 0, 1, '2022-01-31', 2),
(391, 600, 6.5, 0, 0, 1, '2022-01-31', 2),
(392, 604, 10.4, 0, 0, 1, '2022-01-31', 2),
(393, 605, 13, 0, 0, 1, '2022-01-31', 2),
(394, 606, 3.5, 0.4, 0, 1, '2022-01-31', 2),
(395, 612, 1, 0.3, 0, 1, '2022-01-31', 2),
(396, 613, 16.9, 0, 0, 1, '2022-01-31', 2),
(397, 614, 9, 0.1, 0, 1, '2022-01-31', 2),
(398, 616, 2.6, 0, 0, 1, '2022-01-31', 2);

--
-- Triggers `receipt`
--
DELIMITER $$
CREATE TRIGGER `delete_acc` BEFORE DELETE ON `receipt` FOR EACH ROW UPDATE accoun a SET a.balance=(balance-old.amount) WHERE a.acc_id=old.to_acc
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `delete_cust` BEFORE DELETE ON `receipt` FOR EACH ROW UPDATE customer c SET c.fee=(fee+old.amount+old.discount) WHERE  c.cust_id= old.cust_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `toacc_rec` AFTER INSERT ON `receipt` FOR EACH ROW UPDATE accoun a SET a.balance=(balance+new.amount) WHERE a.acc_id=new.to_acc
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tocust_fee` AFTER INSERT ON `receipt` FOR EACH ROW UPDATE customer c SET c.fee=(fee-new.amount-new.discount) WHERE  c.cust_id= new.cust_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `salarypayment`
--

CREATE TABLE `salarypayment` (
  `sp_id` int(11) NOT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `salary` int(11) DEFAULT NULL,
  `from_acc` int(11) DEFAULT NULL,
  `month_date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `salarypayment`
--
DELIMITER $$
CREATE TRIGGER `delete_accou` BEFORE DELETE ON `salarypayment` FOR EACH ROW UPDATE accoun a SET a.balance=(balance+old.salary) WHERE a.acc_id=old.from_acc
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `from_acc` AFTER INSERT ON `salarypayment` FOR EACH ROW UPDATE accoun a SET a.balance=(balance-new.salary) WHERE a.acc_id=new.from_acc
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `supp_id` int(11) NOT NULL,
  `supp_name` varchar(50) DEFAULT NULL,
  `contact` int(11) DEFAULT NULL,
  `zone` varchar(50) DEFAULT NULL,
  `balance` int(11) NOT NULL,
  `reg_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `transferaccoun`
--

CREATE TABLE `transferaccoun` (
  `check_id` int(11) NOT NULL,
  `acc_id` int(11) DEFAULT NULL,
  `acc_name` varchar(50) DEFAULT NULL,
  `day_data` date DEFAULT NULL,
  `tran_amount` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `password` varchar(10) DEFAULT NULL,
  `Role` varchar(20) DEFAULT NULL,
  `user_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `emp_id`, `username`, `password`, `Role`, `user_date`) VALUES
(1, 1, 'Admin', 'Admin', 'Admin', '2021-12-01'),
(2, 2, 'Qarduunshe', '1212', 'Admin', '2021-12-02');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accoun`
--
ALTER TABLE `accoun`
  ADD PRIMARY KEY (`acc_id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`cust_id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`emp_id`);

--
-- Indexes for table `invoice`
--
ALTER TABLE `invoice`
  ADD PRIMARY KEY (`invo_id`),
  ADD KEY `cust_id` (`cust_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`po_id`),
  ADD KEY `cust_id` (`supp_id`),
  ADD KEY `acc_id` (`from_acc`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `rate`
--
ALTER TABLE `rate`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `receipt`
--
ALTER TABLE `receipt`
  ADD PRIMARY KEY (`rv_id`),
  ADD KEY `cust_id` (`cust_id`),
  ADD KEY `acc_id` (`to_acc`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `salarypayment`
--
ALTER TABLE `salarypayment`
  ADD PRIMARY KEY (`sp_id`),
  ADD KEY `acc_id` (`from_acc`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `emp_id` (`emp_id`) USING BTREE;

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`supp_id`);

--
-- Indexes for table `transferaccoun`
--
ALTER TABLE `transferaccoun`
  ADD PRIMARY KEY (`check_id`),
  ADD KEY `acc_id` (`acc_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `emp_id` (`emp_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accoun`
--
ALTER TABLE `accoun`
  MODIFY `acc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `cust_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=631;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `emp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `invoice`
--
ALTER TABLE `invoice`
  MODIFY `invo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=579;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `po_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rate`
--
ALTER TABLE `rate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `receipt`
--
ALTER TABLE `receipt`
  MODIFY `rv_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=399;

--
-- AUTO_INCREMENT for table `salarypayment`
--
ALTER TABLE `salarypayment`
  MODIFY `sp_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `supp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `transferaccoun`
--
ALTER TABLE `transferaccoun`
  MODIFY `check_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `invoice`
--
ALTER TABLE `invoice`
  ADD CONSTRAINT `invoice_ibfk_1` FOREIGN KEY (`cust_id`) REFERENCES `customer` (`cust_id`),
  ADD CONSTRAINT `invoice_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`supp_id`) REFERENCES `customer` (`cust_id`),
  ADD CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`from_acc`) REFERENCES `accoun` (`acc_id`),
  ADD CONSTRAINT `payment_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `receipt`
--
ALTER TABLE `receipt`
  ADD CONSTRAINT `receipt_ibfk_1` FOREIGN KEY (`cust_id`) REFERENCES `customer` (`cust_id`),
  ADD CONSTRAINT `receipt_ibfk_2` FOREIGN KEY (`to_acc`) REFERENCES `accoun` (`acc_id`),
  ADD CONSTRAINT `receipt_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `transferaccoun`
--
ALTER TABLE `transferaccoun`
  ADD CONSTRAINT `transferaccoun_ibfk_1` FOREIGN KEY (`acc_id`) REFERENCES `accoun` (`acc_id`),
  ADD CONSTRAINT `transferaccoun_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`emp_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
