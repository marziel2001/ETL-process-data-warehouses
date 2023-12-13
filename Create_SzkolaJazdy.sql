USE master;
DROP DATABASE szkolaJazdy;
CREATE DATABASE szkolaJazdy;
USE szkolaJazdy;

CREATE TABLE Address
(
    ID INT PRIMARY KEY IDENTITY(0,1),
    StreetAddress NVARCHAR(100),
    ApartmentNumber NVARCHAR(20) NULL,
    City NVARCHAR(50),
    ZIPCode CHAR(6) CHECK (ZIPCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]'),
    Country NVARCHAR(50) DEFAULT 'Polska'
);

Select * from Address;

CREATE TABLE Student
(
    ID INT PRIMARY KEY IDENTITY(0,1),
    PESEL CHAR(11) UNIQUE,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    FK_Address INT,
    FOREIGN KEY (FK_Address) REFERENCES Address(ID)
);

Select * from Student;

CREATE TABLE Employee
(
    ID INT PRIMARY KEY IDENTITY(0,1),
    PESEL CHAR(11) UNIQUE,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    FK_Address INT,
    FOREIGN KEY (FK_Address) REFERENCES Address(ID)
);

Select * from Employee;

CREATE TABLE Bill
(
    ID INT PRIMARY KEY,
    Amount FLOAT(2),
    IssueTime DATETIME2(0),
    PaymentTime DATETIME2(0) NULL
);

SELECT * FROM Bill;

CREATE TABLE Course
(
    ID INT PRIMARY KEY IDENTITY(0,1),
    StartDate DATE,
    BasePrice FLOAT(2),
    ExtraHourPrice FLOAT(2)
);

SELECT * FROM Course;

CREATE TABLE StudentCourse
(
    StudentCourse INT PRIMARY KEY IDENTITY(0,1),
    FK_Student INT,
    FK_Course INT,
    FK_Bill INT,
    FOREIGN KEY (FK_Student) REFERENCES Student(ID),
    FOREIGN KEY (FK_Course) REFERENCES Course(ID),
    FOREIGN KEY (FK_Bill) REFERENCES Bill(ID),
    CONSTRAINT StudentCourseConstraint UNIQUE (FK_Student, FK_Course)
);

SELECT * FROM StudentCourse;

CREATE TABLE Lecture
(
    ID INT PRIMARY KEY IDENTITY(0,1),
    StartTime DATETIME,
    EndTime DATETIME
);

SELECT * FROM Lecture;

CREATE TABLE LectureAttendanceList
(
    FK_StudentCourse INT,
    FK_Lecture INT,
    Present INT,
    PRIMARY KEY (FK_StudentCourse, FK_Lecture),
    FOREIGN KEY (FK_StudentCourse) REFERENCES StudentCourse (StudentCourse),
    FOREIGN KEY (FK_Lecture) REFERENCES Lecture (ID)
);

SELECT * FROM LectureAttendanceList;

CREATE TABLE Car
(
    VIN NVARCHAR(17) PRIMARY KEY,
    Year INT,
    Brand NVARCHAR(50),
    Model NVARCHAR(50)
);

SELECT * FROM Car;

CREATE TABLE DrivingLesson
(
    ID INT PRIMARY KEY IDENTITY(0,1),
    FK_Instructor INT,
    FK_Car NVARCHAR(17),
    FK_StudentCourse INT,
    FK_Bill INT NULL,
    StartTime DATETIME,
    EndTime DATETIME,
    FOREIGN KEY (FK_Instructor) REFERENCES Employee(ID),
    FOREIGN KEY (FK_Car) REFERENCES Car(VIN),
    FOREIGN KEY (FK_StudentCourse) REFERENCES StudentCourse(StudentCourse),
    FOREIGN KEY (FK_Bill) REFERENCES Bill(ID)
);

SELECT count(*) FROM DrivingLesson;
use master