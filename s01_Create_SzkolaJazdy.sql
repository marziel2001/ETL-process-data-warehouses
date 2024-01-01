USE master;
go

DROP DATABASE szkolaJazdyBD;
go

CREATE DATABASE szkolaJazdyBD;
go

USE szkolaJazdyBD;
go

CREATE TABLE Student
(
    ID INT PRIMARY KEY IDENTITY(0,1),
    PESEL CHAR(11) UNIQUE, --BK
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);

CREATE TABLE Employee
(
    ID INT PRIMARY KEY IDENTITY(0,1),
    PESEL CHAR(11) UNIQUE, --BK
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);

CREATE TABLE Bill
(
    ID INT PRIMARY KEY, --BK
    Amount FLOAT(2),
    IssueTime DATETIME2(0),
    PaymentTime DATETIME2(0) NULL
);


CREATE TABLE Course
(
    ID INT PRIMARY KEY IDENTITY(0,1),
    StartDate DATE, --BK
    BasePrice FLOAT(2),
    ExtraHourPrice FLOAT(2)
);

CREATE TABLE Car
(
    VIN NVARCHAR(17) PRIMARY KEY, --BK
    Year INT,
    Brand NVARCHAR(50),
    Model NVARCHAR(50)
);

CREATE TABLE StudentCourse
(
    StudentCourse INT PRIMARY KEY IDENTITY(0,1),
    FK_Student INT, --BK
    FK_Course INT, --BK
    FK_Bill INT,
	FK_Car NVARCHAR(17),
    FOREIGN KEY (FK_Student) REFERENCES Student(ID),
    FOREIGN KEY (FK_Course) REFERENCES Course(ID),
    FOREIGN KEY (FK_Bill) REFERENCES Bill(ID),
	FOREIGN KEY (FK_Car) REFERENCES Car(VIN),
    CONSTRAINT StudentCourseConstraint UNIQUE (FK_Student, FK_Course)
);
CREATE TABLE Lecture
(
    ID INT PRIMARY KEY IDENTITY(0,1),
    StartTime DATETIME, --BK
    EndTime DATETIME
);

CREATE TABLE LectureAttendanceList
(
    FK_StudentCourse INT, --BK
    FK_Lecture INT, --BK
    Present INT,
    PRIMARY KEY (FK_StudentCourse, FK_Lecture),
    FOREIGN KEY (FK_StudentCourse) REFERENCES StudentCourse (StudentCourse),
    FOREIGN KEY (FK_Lecture) REFERENCES Lecture (ID)
);

CREATE TABLE DrivingLesson
(
    ID INT PRIMARY KEY IDENTITY(0,1),
    FK_Instructor INT,
    FK_StudentCourse INT, --BK
    FK_Bill INT NULL,
    StartTime DATETIME, --BK
    EndTime DATETIME,
    FOREIGN KEY (FK_Instructor) REFERENCES Employee(ID),
    FOREIGN KEY (FK_StudentCourse) REFERENCES StudentCourse(StudentCourse),
    FOREIGN KEY (FK_Bill) REFERENCES Bill(ID)
);

Select * from DrivingLesson;
Select * from Car;
Select * from Bill;
Select * from Employee;
Select * from Student;
Select * from Course;
Select * from StudentCourse;
Select * from Lecture;
Select * from LectureAttendanceList;

use master
