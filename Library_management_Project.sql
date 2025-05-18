-- Create Database
CREATE DATABASE Library_Mgmt;
USE Library_Mgmt;

-- Authors table
CREATE TABLE Authors (
    Author_ID INT AUTO_INCREMENT PRIMARY KEY,
    Author_Name VARCHAR(200) NOT NULL
);

-- Books table
CREATE TABLE Books (
    Book_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(260) NOT NULL,
    Author_ID INT,
    Category VARCHAR(70),
    Price DECIMAL(10, 2),
    FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID)
);

-- Members table
CREATE TABLE Members (
    Member_ID INT AUTO_INCREMENT PRIMARY KEY,
    Member_Name VARCHAR(120) NOT NULL,
    DOJ DATE
);

-- Borrowing table
CREATE TABLE Borrowing (
    Borrow_ID INT AUTO_INCREMENT PRIMARY KEY,
    Member_ID INT,
    Book_ID INT,
    Borrow_Date DATE,
    Return_Date DATE,
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);

-- Insert Authors
INSERT INTO Authors (Author_ID, Author_Name)
VALUES ('1101', 'William Shakespeare'),
('1102', 'Rabindranath Tagore'),
('1103', 'Chetan Bhagat'),
('1104', 'Arundhati Roy'),
('1105', 'Salman Rushdie');

-- Insert books
INSERT INTO Books (Book_ID, Title, Author_ID, Category, Price) VALUES
(1, 'Hamlet', 1101, 'Drama', 109.99),
(2, 'Romeo and Juliet', 1101, 'Drama', 350.50),
(3, 'Macbeth', 1101, 'Drama', 180.00),
(4, 'Gitanjali', 1102, 'Poetry', 247.75),
(5, 'The Home and the World', 1102, 'Fiction', 160.00),
(6, 'Five Point Someone', 1103, 'Fiction', 200.99),
(7, '2 States', 1103, 'Fiction', 311.50),
(8, 'The God of Small Things', 1104, 'Fiction', 149.99),
(9, 'The Ministry of Utmost Happiness', 1104, 'Fiction', 189.00),
(10, 'Midnight\'s Children', 1105, 'Fiction', 290.50),
(11, 'The Satanic Verses', 1105, 'Fiction', 199.25);
SELECT price FROM Books;

-- Insert members
INSERT INTO Members (Member_ID, Member_Name, DOJ) VALUES
	(101, 'Suraj Singh', '2020-01-15'),
	(102, 'Shiwani Kumari', '2020-03-22'),
	(103, 'Chandni Parween', '2021-05-10'),
	(104, 'Shreya Kumari', '2021-07-30'),
    (105, 'Eva Garg', '2022-02-14'),
	(106, 'Himali Parween', '2024-09-24'),
	(107, 'Shruti Singh', '2025-02-15'),
	(108, 'Animesh Singh', '2023-07-27'),
	(109, 'Abhinit Mishra', '2022-08-12'),
	(110, 'Lakshmi Mishra', '2023-05-24');

-- Insert borrowing records
INSERT INTO Borrowing (Member_ID, Book_ID, Borrow_Date, Return_Date) VALUES
(107, 1, '2024-01-10', '2024-01-17'),
(105, 8, '2024-02-05', '2024-02-20'),
(101, 2, '2024-01-15', NULL),
(102, 4, '2024-03-01', '2024-03-10'),
(104, 9, '2024-01-15', '2024-01-22'),
(106, 2, '2024-04-01', NULL),
(103, 3, '2024-04-10', '2024-04-25'),
(105, 5, '2024-02-05', '2024-02-20'),
(110, 10, '2024-05-15', NULL),
(102, 3, '2024-05-11', '2024-05-19'),
(103, 5, '2024-03-15', '2024-03-22'),
(105, 11, '2024-02-01', '2024-02-12'),
(102, 4, '2024-05-01', '2024-05-10'),
(106, 10, '2024-03-05', '2024-03-12'),
(105, 2, '2024-05-01', NULL),
(103, 11, '2024-04-09', '2024-04-20');

-- 1. Join Queries 
-- a). List all books and their authors
SELECT 
    b.Title AS Book_Title,
    a.Author_Name AS Author_Name,
    b.Category,
    b.Price
FROM 
    Books b
INNER JOIN 
    Authors a ON b.Author_ID = a.Author_ID;

-- b). Show all books borrowed along with the member’s name
SELECT 
    b.Title AS Book_Title,
    m.Member_Name,
    br.Borrow_Date,
    br.Return_Date
FROM 
    Borrowing br
INNER JOIN 
    Members m ON br.Member_ID = m.Member_ID
INNER JOIN 
    Books b ON br.Book_ID = b.Book_ID;
    
-- c). Find members who have borrowed Fiction books
SELECT 
    DISTINCT m.Member_Name
FROM 
    Borrowing br
INNER JOIN 
    Books b ON br.Book_ID = b.Book_ID
INNER JOIN 
    Members m ON br.Member_ID = m.Member_ID
WHERE 
    b.Category = 'Fiction';
    
-- 2. Indexing for Optimization Queries 
-- a). Create an index on AuthorID in the Books table to speed up searches
CREATE INDEX idx_AuthorID ON Books (Author_ID);

-- b). Create an index on BookID in Borrowing for faster lookup
CREATE INDEX idx_BookID ON Borrowing (Book_ID);

-- 3. Views Queries
-- a). Create a view to display borrowed books and their members
CREATE VIEW BorrowedBooks AS
SELECT 
    b.Title AS Book_Title,
    m.Member_Name,
    br.Borrow_Date,
    br.Return_Date
FROM 
    Borrowing br
INNER JOIN 
    Members m ON br.Member_ID = m.Member_ID
INNER JOIN 
    Books b ON br.Book_ID = b.Book_ID;
    
-- b). Query the view
SELECT * FROM BorrowedBooks;

-- 4. Stored Procedure Queries
-- a). Create a stored procedure to list books by category
DELIMITER //

CREATE PROCEDURE ListBooksByCategory(IN categoryName VARCHAR(70))
BEGIN
    SELECT 
        Title, Author_ID, Price 
    FROM 
        Books 
    WHERE 
        Category = categoryName;
END //

DELIMITER ;

-- Call the procedure
CALL ListBooksByCategory('Fiction');

-- 5. User-defined functions Queries
-- a). Create a function to calculate late fine (₹5 per day after 7 days)
DELIMITER //

CREATE FUNCTION CalculateLateFine(borrow_date DATE, return_date DATE) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE days_late INT;
    DECLARE fine DECIMAL(10,2) DEFAULT 0;
    
    -- Calculate days between return and borrow dates
    SET days_late = DATEDIFF(return_date, borrow_date) - 7;
    
    -- If returned after 7 days, calculate fine (₹5 per day)
    IF days_late > 0 THEN
        SET fine = days_late * 5;
    END IF;
    
    RETURN fine;
END //

DELIMITER ;
-- 6. Triggers Queries
-- a). Create a trigger to update fine when a book is returned late
ALTER TABLE Borrowing ADD COLUMN Fine DECIMAL(10,2) DEFAULT 0;

DELIMITER //

CREATE TRIGGER UpdateFineOnReturn
BEFORE UPDATE ON Borrowing
FOR EACH ROW
BEGIN
    -- Only calculate fine if the return date is being set/changed
    IF NEW.Return_Date IS NOT NULL AND (OLD.Return_Date IS NULL OR NEW.Return_Date <> OLD.Return_Date) THEN
        SET NEW.Fine = CalculateLateFine(NEW.Borrow_Date, NEW.Return_Date);
    END IF;
END //

DELIMITER ;
-- Test the function with different scenarios
SELECT 
    CalculateLateFine('2024-01-10', '2024-01-17') AS 'Returned On Time',        
    CalculateLateFine('2024-02-05', '2024-02-20') AS 'Returned Late',      
    CalculateLateFine('2024-01-15', NULL) AS 'Not Returned Yet',            
    CalculateLateFine('2024-03-01', '2024-03-10') AS 'Returned Late',           
    CalculateLateFine('2024-01-15', '2024-01-22') AS 'Returned On Time',           
	CalculateLateFine('2024-04-01', NULL) AS 'Not Returned Yet',
	CalculateLateFine('2024-04-10', '2024-04-25') AS 'Returned Late',           
	CalculateLateFine('2024-02-05', '2024-02-20') AS 'Returned Late',
	CalculateLateFine('2024-05-15', NULL) AS 'Not Returned Yet',
	CalculateLateFine('2024-05-11', '2024-05-19') AS 'Returned Late',
	CalculateLateFine('2024-03-15', '2024-03-22') AS 'Returned On Time', 
	CalculateLateFine('2024-02-01', '2024-02-12') AS 'Returned Late',
	CalculateLateFine('2024-05-01', '2024-05-10') AS 'Returned Late',
	CalculateLateFine('2024-03-05', '2024-03-12') AS 'Returned On Time', 
	CalculateLateFine('2024-05-01', NULL) AS 'Not Returned Yet',
	CalculateLateFine('2024-04-09', '2024-04-20') AS 'Returned Late';
    -- View current borrowing records with fines
SELECT 
    Borrow_ID, 
    Member_ID, 
    Book_ID, 
    Borrow_Date, 
    Return_Date, 
    Fine AS Current_Fine,
    CalculateLateFine(Borrow_Date, Return_Date) AS Calculated_Fine
FROM Borrowing
ORDER BY Borrow_ID;

-- Update a record to test the trigger
UPDATE Borrowing 
SET Return_Date = '2024-01-25'  
WHERE Borrow_ID = 3;

UPDATE Borrowing 
SET Return_Date = '2024-04-15'  
WHERE Borrow_ID = 6;

-- View the updated record
SELECT 
    Borrow_ID, 
    Member_ID, 
    Book_ID, 
    Borrow_Date, 
    Return_Date, 
    Fine
FROM Borrowing
WHERE Borrow_ID = 3;

SELECT 
    Borrow_ID, 
    Member_ID, 
    Book_ID, 
    Borrow_Date, 
    Return_Date, 
    Fine
FROM Borrowing
WHERE Borrow_ID = 6;

-- View updated records with fines
SELECT 
    Borrow_ID, 
    Member_ID, 
    (SELECT Member_Name FROM Members WHERE Member_ID = Borrowing.Member_ID) AS Member_Name,
    Book_ID, 
    (SELECT Title FROM Books WHERE Book_ID = Borrowing.Book_ID) AS Book_Title,
    Borrow_Date, 
    Return_Date,
    DATEDIFF(IFNULL(Return_Date, CURRENT_DATE), Borrow_Date) - 7 AS Days_Late,
    Fine
FROM Borrowing
ORDER BY Fine DESC;


-- The END --
