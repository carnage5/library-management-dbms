-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 28, 2022 at 03:48 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6
-- abishek deivam
-- pes1ug20cs012
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `library_management_system`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `borrow_book` (IN `book_id` VARCHAR(20), IN `student_id` VARCHAR(20), OUT `message` VARCHAR(50))   BEGIN 
DECLARE c int ;
DECLARE stdcheck int;
SET c =(SELECT COUNT(*) FROM borrows_return WHERE borrows_return.Book_id=book_id AND borrows_return.return_date IS NULL);
SET stdcheck = (SELECT COUNT(*) FROM borrows_return WHERE borrows_return.Student_id=student_id AND borrows_return.return_date IS NULL AND CURRENT_DATE()>borrows_return.due_date);
IF c>0 THEN
 SET message="this book has already been borrowed";
ELSE
 IF stdcheck > 0 THEN
 SET message="You have to return an overdue book , return it";
 ELSE
 INSERT INTO borrows_return VALUES(CURRENT_DATE(),null,ADDDATE(CURRENT_DATE(),7),student_id,book_id);
 SET message="Successfully borrowed book , return it on time ";
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recent` ()   BEGIN
declare bookname varchar(30);
declare bookid varchar(20);
declare genre varchar(20);
declare counter int default 0;
DECLARE done INT DEFAULT FALSE;
DECLARE c CURSOR FOR SELECT book.Book_id,book.book_name,book.genre FROM book NATURAL JOIN borrows_return ORDER BY borrows_return.issue_date ASC LIMIT 3;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
open c;
read_loop: LOOP
FETCH c into bookid,bookname,genre;
IF done THEN
LEAVE read_loop;
END IF;
INSERT INTO recents VALUES (bookid,bookname,genre); 
END LOOP;
close c;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `return_book` (IN `book_id` VARCHAR(20), IN `student_id` VARCHAR(20), OUT `message` VARCHAR(50))   BEGIN 
DECLARE c int ;
DECLARE rdate DATE;
SET c = (SELECT COUNT(*) FROM borrows_return WHERE borrows_return.Book_id=book_id AND borrows_return.Student_id=student_id AND borrows_return.return_date IS NULL);
IF c>0 THEN
 SET rdate=(SELECT borrows_return.due_date FROM borrows_return WHERE borrows_return.Book_id=book_id AND borrows_return.Student_id=student_id AND borrows_return.return_date IS NULL);
 IF CURRENT_DATE()>rdate THEN
 SET message="You have returned the book late";
 ELSE
 SET message="Book has been returned";
 END IF;
UPDATE borrows_return SET borrows_return.return_date=CURRENT_DATE() WHERE borrows_return.Book_id=book_id AND borrows_return.Student_id=student_id;
ELSE
 SET message="this book has already been returned";
END IF;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `book_status` (`issue_date` DATE, `return_date` DATE, `due_date` DATE) RETURNS VARCHAR(20) CHARSET utf8mb4  BEGIN
  DECLARE bkstatus varchar(20);
    SET bkstatus="";
    IF return_date IS NULL THEN
      SET bkstatus = concat_ws(' ',bkstatus, "Borrowed");
        IF CURRENT_DATE()>due_date THEN
          SET bkstatus = concat_ws(' ',bkstatus, "Late");
        END IF;
    ELSE
       SET bkstatus = concat_ws(' ',bkstatus, "Returned");
       IF return_date > due_date THEN
          SET bkstatus = concat_ws(' ',bkstatus, "Late");
       END IF;
    END IF;
   RETURN bkstatus;
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `added`
--

CREATE TABLE `added` (
  `Date_of_addition` date NOT NULL,
  `Book_id` varchar(20) NOT NULL,
  `Lib_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `added`
--

INSERT INTO `added` (`Date_of_addition`, `Book_id`, `Lib_id`) VALUES
('2022-09-14', 'BK_001', 'LIB001'),
('2022-10-23', 'BK_0010', 'LIB002'),
('2022-10-12', 'BK_0011', 'LIB004'),
('2022-09-15', 'BK_0012', 'LIB004'),
('2022-11-19', 'BK_0013', 'LIB002'),
('2022-04-29', 'BK_0014', 'LIB001'),
('2022-02-15', 'BK_0015', 'LIB001'),
('2022-10-15', 'BK_002', 'LIB002'),
('2022-08-16', 'BK_003', 'LIB004'),
('2022-07-17', 'BK_004', 'LIB005'),
('2022-09-18', 'BK_005', 'LIB002'),
('2022-06-19', 'BK_006', 'LIB003'),
('2022-01-20', 'BK_007', 'LIB005'),
('2022-04-21', 'BK_008', 'LIB001'),
('2022-05-22', 'BK_009', 'LIB003');

-- --------------------------------------------------------

--
-- Table structure for table `book`
--

CREATE TABLE `book` (
  `book_name` varchar(40) NOT NULL,
  `Book_id` varchar(20) NOT NULL,
  `author_fname` varchar(20) NOT NULL,
  `author_lname` varchar(20) NOT NULL,
  `genre` varchar(20) NOT NULL,
  `isbn` varchar(20) NOT NULL,
  `edition` int(11) NOT NULL,
  `Librarian_id` varchar(20) DEFAULT NULL,
  `Publisher_id` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `book`
--

INSERT INTO `book` (`book_name`, `Book_id`, `author_fname`, `author_lname`, `genre`, `isbn`, `edition`, `Librarian_id`, `Publisher_id`) VALUES
('And Then There Were None', 'BK_001', 'Agatha', 'Christie', 'Mystery', '0312330871', 1, 'LR_001', 'PUBL_001'),
('I Wouldn\'t Do That If I Were Me: Modern ', 'BK_0010', 'Jason', 'Gay', 'Humour', '9756327323', 1, 'LR_001', 'PUBL_004'),
('Limca Book of Records 2020–22\r\n', 'BK_0011', 'Hachette', 'India', 'Educational', '7325225230', 1, 'LR_002', 'PUBL_004'),
('The Boys From Biloxi', 'BK_0012', 'John', 'Grisham', 'Thriller', '0812487643', 1, 'LR_004', 'PUBL_004'),
('What\'s for Dessert\r\n', 'BK_0013', 'Claire', 'Saffitz', 'Food', '8452301223', 1, 'LR_003', 'PUBL_005'),
('Distant Thunder', 'BK_0014', 'Stuart', 'Woods', 'Thriller', '9021392024', 1, 'LR_005', 'PUBL_005'),
('Peril in Paris', 'BK_0015', 'Rhys', 'Bowen', 'Mystery', '1023122944', 1, 'LR_004', 'PUBL_005'),
('The India Way : Strategies for an Uncert', 'BK_002', 'S.', 'Jaishankar', 'Drama', '0312330871', 1, 'LR_003', 'PUBL_001'),
('Red Queen', 'BK_003', 'Victoria', 'Aveyard', 'Fantasy', '006231064X', 2, 'LR_004', 'PUBL_001'),
('City of Bones', 'BK_004', 'Cassandra', 'Claire', 'Fantasy', '1442472065', 1, 'LR_002', 'PUBL_002'),
('Maybe Now', 'BK_005', 'Colleen', 'Hoover', 'Romance', '1668013347', 1, 'LR_005', 'PUBL_002'),
('Chainsaw Man', 'BK_006', 'Tatsuki', 'Fujimoto', 'Comic', '1974709930', 1, 'LR_003', 'PUBL_002'),
('Six of Crows', 'BK_007', 'Leigh', 'Bardugo', 'Action', '8395710357', 1, 'LR_002', 'PUBL_003'),
('The Fall of Boris Johnson: The Full Stor', 'BK_008', 'Sebastian', 'Payne', 'Biography', '4259235733', 1, 'LR_001', 'PUBL_003'),
('The Hitchhiker\'s Guide to the Galaxy', 'BK_009', 'Douglas', 'Adams', 'Humour', '1248703523', 1, 'LR_005', 'PUBL_003');

-- --------------------------------------------------------

--
-- Table structure for table `borrows_return`
--

CREATE TABLE `borrows_return` (
  `issue_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `due_date` date NOT NULL,
  `Student_id` varchar(20) NOT NULL,
  `Book_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `borrows_return`
--

INSERT INTO `borrows_return` (`issue_date`, `return_date`, `due_date`, `Student_id`, `Book_id`) VALUES
('2022-11-01', '2022-11-28', '2022-11-15', 'STD_001', 'BK_005'),
('2022-10-28', '2022-11-01', '2022-11-05', 'STD_002', 'BK_0010'),
('2022-11-15', NULL, '2022-11-30', 'STD_002', 'BK_007'),
('2022-10-14', '2022-11-05', '2022-10-28', 'STD_003', 'BK_008'),
('2022-11-28', NULL, '2022-12-05', 'STD_004', 'BK_009'),
('2022-11-01', NULL, '2022-11-14', 'STD_005', 'BK_002');

-- --------------------------------------------------------

--
-- Table structure for table `librarian`
--

CREATE TABLE `librarian` (
  `Librarian_id` varchar(20) NOT NULL,
  `fname` varchar(20) NOT NULL,
  `lname` varchar(20) NOT NULL,
  `email` varchar(30) NOT NULL,
  `Lib_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `librarian`
--

INSERT INTO `librarian` (`Librarian_id`, `fname`, `lname`, `email`, `Lib_id`) VALUES
('LR_001', 'Sheila', 'Joel', 'Sheila.Joel@gmail.com', 'LIB001'),
('LR_002', 'Roshan', 'Shiva', 'Roshan.Shiva@gmail.com', 'LIB001'),
('LR_003', 'Ganesh', 'Malcom', 'Ganesh.Malcom@gmail.com', 'LIB002'),
('LR_004', 'Daria', 'Marina', 'Daria.Marina@gmail.com', 'LIB004'),
('LR_005', 'Eino', 'Ervin', 'Eino.Ervin@gmail.com', 'LIB004');

-- --------------------------------------------------------

--
-- Table structure for table `librarian_phone_no`
--

CREATE TABLE `librarian_phone_no` (
  `phone_no` decimal(10,0) NOT NULL,
  `Librarian_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `librarian_phone_no`
--

INSERT INTO `librarian_phone_no` (`phone_no`, `Librarian_id`) VALUES
('872854029', 'LR_003'),
('7601156977', 'LR_005'),
('7879032164', 'LR_004'),
('8684596278', 'LR_001'),
('9240943280', 'LR_002');

-- --------------------------------------------------------

--
-- Table structure for table `library`
--

CREATE TABLE `library` (
  `Lib_id` varchar(20) NOT NULL,
  `Lib_name` varchar(20) NOT NULL,
  `Location` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `library`
--

INSERT INTO `library` (`Lib_id`, `Lib_name`, `Location`) VALUES
('LIB001', 'Library 1', 'Palm street'),
('LIB002', 'Library 2', 'Star street'),
('LIB003', 'Library 3', 'Central street'),
('LIB004', 'Library 4', 'Metro street'),
('LIB005', 'Library 5', 'Park street');

-- --------------------------------------------------------

--
-- Table structure for table `publisher`
--

CREATE TABLE `publisher` (
  `Publisher_id` varchar(20) NOT NULL,
  `publisher_name` varchar(20) NOT NULL,
  `publisher_address` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `publisher`
--

INSERT INTO `publisher` (`Publisher_id`, `publisher_name`, `publisher_address`) VALUES
('PUBL_001', 'Harper Collins', 'New York , United States'),
('PUBL_002', 'Simon & Schuster', 'New York , United States'),
('PUBL_003', 'Macmillan', 'London , United Kingdom'),
('PUBL_004', 'Hachette', 'Paris , France'),
('PUBL_005', 'Penguin Random House', 'New York , United States');

-- --------------------------------------------------------

--
-- Table structure for table `recents`
--

CREATE TABLE `recents` (
  `bookid` varchar(20) NOT NULL,
  `bookname` varchar(30) DEFAULT NULL,
  `genre` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `recents`
--

INSERT INTO `recents` (`bookid`, `bookname`, `genre`) VALUES
('BK_0010', 'I Wouldn\'t Do That If I Were M', 'Humour'),
('BK_005', 'Maybe Now', 'Romance'),
('BK_008', 'The Fall of Boris Johnson: The', 'Biography');

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `fname` varchar(20) NOT NULL,
  `lname` varchar(20) NOT NULL,
  `email` varchar(30) NOT NULL,
  `Student_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`fname`, `lname`, `email`, `Student_id`) VALUES
('Philip', 'Mckinley', 'Philip.Mckinley@gmail.com', 'STD_001'),
('Rajesh', 'Sands', 'Rajesh.Sands@gmail.com', 'STD_0010'),
('Lucilio', 'Bonney', 'Lucilio.Bonney@gmail.com', 'STD_002'),
('Louise', 'Triggs', 'Louise.Triggs@gmail.com', 'STD_003'),
('Celyn', 'Panza', 'Celyn.Panza@gmail.com', 'STD_004'),
('Brice', 'Adair', 'Brice.Adair@gmail.com', 'STD_005'),
('Blanca', 'Lim', 'Blanca.Lim@gmail.com', 'STD_006'),
('Nia', 'Beck', 'Nia.Beck@gmail.com', 'STD_007'),
('Davey', 'Blue', 'Davey.Blue@gmail.com', 'STD_008'),
('Larisa', 'Troy', 'Larisa.Troy@gmail.com', 'STD_009');

--
-- Triggers `student`
--
DELIMITER $$
CREATE TRIGGER `valid_mail_student` BEFORE INSERT ON `student` FOR EACH ROW BEGIN
DECLARE message varchar(20);
DECLARE email int;
SET message="invalid email";
SET email=(SELECT new.email REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+.[A-Z]{2,4}$');
IF email=0 THEN
  SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT=message;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `student_phone_no`
--

CREATE TABLE `student_phone_no` (
  `phone_no` decimal(10,0) NOT NULL,
  `Student_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `student_phone_no`
--

INSERT INTO `student_phone_no` (`phone_no`, `Student_id`) VALUES
('1933145623', 'STD_005'),
('2033490286', 'STD_007'),
('2869097310', 'STD_009'),
('3485916693', 'STD_001'),
('4141868514', 'STD_008'),
('4442157181', 'STD_002'),
('4857721399', 'STD_0010'),
('6386298426', 'STD_003'),
('8986481841', 'STD_004'),
('9466404558', 'STD_006');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `added`
--
ALTER TABLE `added`
  ADD PRIMARY KEY (`Book_id`,`Lib_id`),
  ADD UNIQUE KEY `Book_id` (`Book_id`),
  ADD KEY `Lib_id` (`Lib_id`);

--
-- Indexes for table `book`
--
ALTER TABLE `book`
  ADD PRIMARY KEY (`Book_id`),
  ADD UNIQUE KEY `Book_id` (`Book_id`),
  ADD KEY `Librarian_id` (`Librarian_id`),
  ADD KEY `Publisher_id` (`Publisher_id`);

--
-- Indexes for table `borrows_return`
--
ALTER TABLE `borrows_return`
  ADD PRIMARY KEY (`Student_id`,`Book_id`),
  ADD KEY `Book_id` (`Book_id`);

--
-- Indexes for table `librarian`
--
ALTER TABLE `librarian`
  ADD PRIMARY KEY (`Librarian_id`),
  ADD UNIQUE KEY `Librarian_id` (`Librarian_id`),
  ADD KEY `Lib_id` (`Lib_id`);

--
-- Indexes for table `librarian_phone_no`
--
ALTER TABLE `librarian_phone_no`
  ADD PRIMARY KEY (`phone_no`,`Librarian_id`),
  ADD UNIQUE KEY `Librarian_id` (`Librarian_id`);

--
-- Indexes for table `library`
--
ALTER TABLE `library`
  ADD PRIMARY KEY (`Lib_id`),
  ADD UNIQUE KEY `Lib_id` (`Lib_id`);

--
-- Indexes for table `publisher`
--
ALTER TABLE `publisher`
  ADD PRIMARY KEY (`Publisher_id`),
  ADD UNIQUE KEY `Publisher_id` (`Publisher_id`);

--
-- Indexes for table `recents`
--
ALTER TABLE `recents`
  ADD PRIMARY KEY (`bookid`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`Student_id`),
  ADD UNIQUE KEY `Student_id` (`Student_id`);

--
-- Indexes for table `student_phone_no`
--
ALTER TABLE `student_phone_no`
  ADD PRIMARY KEY (`phone_no`,`Student_id`),
  ADD KEY `Student_id` (`Student_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `added`
--
ALTER TABLE `added`
  ADD CONSTRAINT `added_ibfk_1` FOREIGN KEY (`Book_id`) REFERENCES `book` (`Book_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `added_ibfk_2` FOREIGN KEY (`Lib_id`) REFERENCES `library` (`Lib_id`) ON DELETE CASCADE;

--
-- Constraints for table `book`
--
ALTER TABLE `book`
  ADD CONSTRAINT `book_ibfk_1` FOREIGN KEY (`Librarian_id`) REFERENCES `librarian` (`Librarian_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `book_ibfk_2` FOREIGN KEY (`Publisher_id`) REFERENCES `publisher` (`Publisher_id`) ON DELETE SET NULL;

--
-- Constraints for table `borrows_return`
--
ALTER TABLE `borrows_return`
  ADD CONSTRAINT `borrows_return_ibfk_1` FOREIGN KEY (`Student_id`) REFERENCES `student` (`Student_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `borrows_return_ibfk_2` FOREIGN KEY (`Book_id`) REFERENCES `book` (`Book_id`) ON DELETE CASCADE;

--
-- Constraints for table `librarian`
--
ALTER TABLE `librarian`
  ADD CONSTRAINT `librarian_ibfk_1` FOREIGN KEY (`Lib_id`) REFERENCES `library` (`Lib_id`) ON DELETE CASCADE;

--
-- Constraints for table `librarian_phone_no`
--
ALTER TABLE `librarian_phone_no`
  ADD CONSTRAINT `librarian_phone_no_ibfk_1` FOREIGN KEY (`Librarian_id`) REFERENCES `librarian` (`Librarian_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_phone_no`
--
ALTER TABLE `student_phone_no`
  ADD CONSTRAINT `student_phone_no_ibfk_1` FOREIGN KEY (`Student_id`) REFERENCES `student` (`Student_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
