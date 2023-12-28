USE master;
go
DROP DATABASE szkolaJazdyHD;
go
CREATE DATABASE szkolaJazdyHD;
go
USE szkolaJazdyHD;
go

CREATE TABLE Date (
    ID INT PRIMARY KEY IDENTITY(0,1),
	Date date,
    Day INT,
    Month INT,
    Year INT,
    Holiday VARCHAR(50)
);

CREATE TABLE Course (
    ID INT PRIMARY KEY IDENTITY(0,1),
    Edition INT,
    ID_StartDate INT,
    FOREIGN KEY (ID_StartDate) REFERENCES Date(ID)
);

CREATE TABLE Car (
    ID INT PRIMARY KEY IDENTITY(0,1),
    VIN VARCHAR(17),
    Brand VARCHAR(50),
    Model VARCHAR(50),
    Age INT,
    Actual BIT
);

CREATE TABLE Student (
    ID INT PRIMARY KEY IDENTITY(0,1),
    PESEL VARCHAR(11),
    FirstName_LastName VARCHAR(100),
    Age VARCHAR(10),
    Actual BIT
);

CREATE TABLE Employee (
    ID INT PRIMARY KEY IDENTITY(0,1),
    PESEL VARCHAR(11) UNIQUE,
    FirstName_LastName VARCHAR(100)
);

----------- FACTs -----------

CREATE TABLE StudentCourse
(
    ID INT PRIMARY KEY IDENTITY(0,1),
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
	ID INT IDENTITY(0,1) PRIMARY KEY,
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

use szkolaJazdyHD
go

SELECT * FROM Date;
select * from course;
SELECT *, ROW_NUMBER() over (order by ID_StartDate) as number FROM Course;
SELECT * FROM Car;
SELECT * FROM Student;
SELECT * FROM Employee;
SELECT * FROM StudentCourse;
SELECT * FROM DrivingLesson;
SELECT * FROM LectureAttendance;
SELECT * FROM TheoryAttempt;
SELECT * FROM PracticeAttempt;

use master
