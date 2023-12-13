USE master;
DROP DATABASE szkolaJazdyHD;
CREATE DATABASE szkolaJazdyHD;
USE szkolaJazdyHD;

CREATE TABLE Date (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Day INT,
    Month INT,
    Year INT,
    Holiday VARCHAR(50)
);

CREATE TABLE Course (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Edition INT,
    ID_StartDate INT,
    ID_EndDate INT,
    FOREIGN KEY (ID_StartDate) REFERENCES Date(ID),
    FOREIGN KEY (ID_EndDate) REFERENCES Date(ID)
);

CREATE TABLE Car (
    ID INT PRIMARY KEY IDENTITY(1,1),
    VIN VARCHAR(17),
    Brand VARCHAR(50),
    Model VARCHAR(50),
    Age INT,
    Actual BIT
);

CREATE TABLE Student (
    ID INT PRIMARY KEY IDENTITY(1,1),
    PESEL VARCHAR(11),
    FirstName_LastName VARCHAR(100),
    Age INT,
    Actual BIT
);

CREATE TABLE Employee (
    ID INT PRIMARY KEY IDENTITY(1,1),
    PESEL VARCHAR(11) UNIQUE,
    FirstName_LastName VARCHAR(100)
);

----------- FACTs -----------

CREATE TABLE StudentCourse
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    ID_Student INT NOT NULL,
    ID_Course INT NOT NULL,
    ID_BillIssueDate INT NOT NULL,
    ID_BillPaymentDate INT NOT NULL,
	ID_car INT NOT NULL,
    Bill VARCHAR(15) NOT NULL,
    CoursePrice MONEY NOT NULL,
    No_extra_driving_hours INT NOT NULL,
    theory_score FLOAT NOT NULL,
    FOREIGN KEY (ID_Student) REFERENCES Student(ID),
    FOREIGN KEY (ID_Course) REFERENCES Course(ID),
    FOREIGN KEY (ID_BillIssueDate) REFERENCES Date(ID),
    FOREIGN KEY (ID_BillPaymentDate) REFERENCES Date(ID),
    FOREIGN KEY (ID_car) REFERENCES Car(ID),
);

CREATE TABLE DrivingLesson (
	ID INT IDENTITY(1,1) PRIMARY KEY,
    ID_Instructor INT NOT NULL,
    ID_StudentCourse INT NOT NULL,
    Bill VARCHAR(15) NOT NULL,
    ID_Date INT NOT NULL,
    Duration INT NOT NULL,
    ID_BillIssueDate INT NOT NULL,
    ID_BillPaymentDate INT NOT NULL,
    One_hour_price MONEY NOT NULL,
    Total_cost MONEY NOT NULL,
    FOREIGN KEY (ID_Instructor) REFERENCES Employee(ID),
    FOREIGN KEY (ID_StudentCourse) REFERENCES StudentCourse(ID),
    FOREIGN KEY (ID_Date) REFERENCES Date(ID),
    FOREIGN KEY (ID_BillIssueDate) REFERENCES Date(ID),
    FOREIGN KEY (ID_BillPaymentDate) REFERENCES Date(ID)
);


CREATE TABLE LectureAttendance (
    ID_StudentCourse INT NOT NULL,
    ID_Date INT NOT NULL,
	ID_Lecture INT NOT NULL,
    Present FLOAT NOT NULL,
    PRIMARY KEY (ID_StudentCourse, ID_Lecture),
    FOREIGN KEY (ID_StudentCourse) REFERENCES StudentCourse(ID),
    FOREIGN KEY (ID_Date) REFERENCES Date(ID)
);

CREATE TABLE TheoryAttempt (
    ID_StudentCourse INT NOT NULL,
    AttemptNumber INT NOT NULL,
    Result FLOAT NOT NULL,
    Score FLOAT NOT NULL,
    ID_Date INT NOT NULL,
    FOREIGN KEY (ID_StudentCourse) REFERENCES StudentCourse(ID),
    FOREIGN KEY (ID_Date) REFERENCES Date(ID)
);

CREATE TABLE PracticeAttempt (
    ID_StudentCourse INT NOT NULL,
    AttemptNumber INT NOT NULL,
    Result FLOAT NOT NULL,
    ID_Date INT NOT NULL,
    FOREIGN KEY (ID_StudentCourse) REFERENCES StudentCourse(ID),
    FOREIGN KEY (ID_Date) REFERENCES Date(ID)
);


INSERT INTO Date (Day, Month, Year, Holiday) VALUES
(1, 1, 2023, 'New Year'),
(1, 2, 2023, NULL),
(10, 1, 2023, NULL),
(12, 1, 2023, NULL),
(14, 1, 2023, NULL),
(2, 2, 2023, NULL),
(3, 2, 2023, NULL),
(13, 1, 2023, NULL),
(15, 1, 2023, NULL),
(21, 1, 2023, NULL),--10
(16, 1, 2023, NULL),	--11
(28, 1, 2023, NULL),	--12
(29, 1, 2023, NULL)	--13
;

INSERT INTO Course (Edition, ID_StartDate, ID_EndDate) VALUES (1, 1, 2);

INSERT INTO Car (VIN, Brand, Model, Age, Actual) VALUES ('e23ac67ad1234cs71', 'Toyota', 'Corolla', 5, 1),
													    ('a23ac67ad1234cs22', 'Mazda', '3', 5, 1);

INSERT INTO Student (PESEL, FirstName_LastName, Age, Actual) VALUES 
('12345678901', 'Jan Kowalski', 25, 1),
('12345678902', 'Marcel Zieliñski', 22, 1)
;

INSERT INTO Employee (PESEL, FirstName_LastName) VALUES ('11111111111', 'Adam Smith');

INSERT INTO StudentCourse (ID_Student, ID_Course, ID_BillIssueDate, ID_BillPaymentDate, ID_car, Bill,				CoursePrice,	No_extra_driving_hours, theory_score) VALUES
							(1,		   1,		  1,				3,					1,		'123456789012345',	1200.00,		5,						 85.0),
							(2,		   1,		  1,				1,					1,		'123456789012347',	1200.00,		10,						 95.0);

INSERT INTO DrivingLesson (ID_Instructor, ID_StudentCourse, Bill,				ID_Date, Duration, ID_BillIssueDate, ID_BillPaymentDate, One_hour_price, Total_cost)
				   VALUES (1,			  1,				'123456789012345',	4,		 2,		   		     1,				   3,				   0.00,		   0.00),
						  (1,			  1,				'123456789012345',	5,		 5,		   		     1,				   3,				   0.00,		   0.00),
						  (1,			  1,				'123456789012346',	10,		 5,		   		     1,				   1,				   70.00,		   350.00);

INSERT INTO DrivingLesson (ID_Instructor, ID_StudentCourse, Bill,				 ID_Date, Duration, ID_BillIssueDate, ID_BillPaymentDate, One_hour_price, Total_cost)
				   VALUES (1,			  2,				'123456789012347',	 4,	      3,				  1,				1,					0.00,			0.00),
				          (1,			  2,				'123456789012348',	 9,	      10,				  9,				9,					70.00,			700.00);

INSERT INTO LectureAttendance (ID_StudentCourse, ID_Date, ID_Lecture, Present)
					VALUES (   1,				 5,		  1,		   1),
						   (   2,				 5,		  1,		   1),
						   (   1,				 11,	  2,		   1),
						   (   2,				 11,	  2,		   0);
				

INSERT INTO TheoryAttempt (ID_StudentCourse, AttemptNumber, Result, Score, ID_Date) VALUES    
						  (1,				 1,			    1,	    85.0,  6),
						  (2,				 1,			    1,	    95.0,  12)
						  ;

INSERT INTO PracticeAttempt (ID_StudentCourse, AttemptNumber, Result, ID_Date) VALUES 
							( 1,				   1,		      1,	  7),
							( 1,				   1,		      1,	  13)
							;


SELECT * FROM Date;
SELECT * FROM Course;
SELECT * FROM Car;
SELECT * FROM Student;
SELECT * FROM Employee;
SELECT * FROM StudentCourse;
SELECT * FROM DrivingLesson;
SELECT * FROM LectureAttendance;
SELECT * FROM TheoryAttempt;
SELECT * FROM PracticeAttempt;

use master
