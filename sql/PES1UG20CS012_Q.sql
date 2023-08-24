--abishek deivam
--pes1ug20cs012
--join queries
--1
SELECT * FROM book NATURAL JOIN borrows_return WHERE borrows_return.return_date IS NULL;
--2
SELECT * FROM student JOIN borrows_return WHERE student.Student_id =borrows_return.Student_id AND borrows_return.return_date IS NULL;
--3
SELECT * FROM book INNER JOIN added ON book.Book_id=added.Book_id;
--4
SELECT * FROM student LEFT OUTER JOIN borrows_return ON student.Student_id=borrows_return.Student_id;
--aggregate functions
--1
SELECT Lib_id,COUNT(*) as book_count FROM book NATURAL JOIN added GROUP BY Lib_id;
--2
SELECT COUNT(*) total_number_books FROM book;
--3
SELECT AVG(borrows_return.due_date-borrows_return.issue_date) AS average_time FROM borrows_return;
--4
SELECT MAX(CURRENT_DATE()-added.Date_of_addition) AS book_age,book.book_name FROM added NATURAL JOIN book;
--set operations
--1
SELECT book.book_name FROM book NATURAL JOIN publisher WHERE publisher.publisher_name="Harper collins" 
UNION
SELECT book.book_name FROM book NATURAL JOIN publisher WHERE publisher.publisher_name="Macmillan";
--2
SELECT borrows_return.Student_id FROM borrows_return NATURAL JOIN added WHERE added.Lib_id="LIB002"
INTERSECT
SELECT borrows_return.Student_id FROM borrows_return NATURAL JOIN added WHERE added.Lib_id="LIB005";
--3
SELECT * FROM student WHERE fname like "L%"
UNION ALL
SELECT * FROM student WHERE fname like "%a";
--4
SELECT * FROM book WHERE book.book_name LIKE "T%"
EXCEPT 
SELECT * FROM book WHERE book.Publisher_id="PUBL_003";
--functions and procedures
--1
DELIMITER $$
CREATE FUNCTION book_status(issue_date DATE , return_date DATE , due_date DATE)
returns varchar(20)
BEGIN
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
END; $$

SELECT *, book_status(borrows_return.issue_date,borrows_return.return_date,borrows_return.due_date) as book_status FROM borrows_return;

--2
DELIMITER $$
CREATE PROCEDURE borrow_book(
    IN book_id varchar(20) , IN student_id varchar(20) , OUT message varchar(50))
BEGIN 
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
END; $$

CALL borrow_book("BK_009","STD_004",@M)
SELECT @M;

CALL borrow_book("BK_003","STD_001",@M);
SELECT @M;

--3
DELIMITER $$
CREATE PROCEDURE return_book(
    IN book_id varchar(20) , IN student_id varchar(20) , OUT message varchar(50))
BEGIN 
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
END; $$

CALL return_book("BK_005","STD_001",@M);
SELECT @M;

--triggers and cursors
--1
DELIMITER $$
CREATE TRIGGER valid_mail_student
BEFORE INSERT ON student FOR EACH ROW
BEGIN
DECLARE message varchar(20);
DECLARE email int;
SET message="invalid email";
SET email=(SELECT new.email REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$');
IF email=0 THEN
  SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT=message;
END IF;
END; $$

INSERT INTO student VALUES ("Abishek","Deivam","Abishekmail","STD_0011");

--2
CREATE TABLE recents(
    bookid varchar(20),
    bookname varchar(30),
    genre varchar(20),
    PRIMARY KEY(bookid)
);

DELIMITER $$
create PROCEDURE get_recent()
BEGIN
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
END; $$

CALL get_recent();
SELECT * FROM recents;

--end--


