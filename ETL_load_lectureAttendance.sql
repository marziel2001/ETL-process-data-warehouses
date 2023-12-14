USE szkolaJazdyHD

IF (OBJECT_ID('vLectureAttendance') IS NOT NULL) DROP VIEW vLectureAttendance

GO

CREATE VIEW vLectureAttendance
AS SELECT
	ID_StudentCourse = LAT.FK_StudentCourse,
	ID_Date = D.ID,
	ID_Lecture = L.ID,
	Present = CAST(LAT.Present AS float)
FROM szkolaJazdyBD.dbo.LectureAttendanceList AS LAT
INNER JOIN szkolaJazdyBD.dbo.StudentCourse AS SC ON SC.StudentCourse = LAT.FK_StudentCourse
INNER JOIN szkolaJazdyBD.dbo.Lecture AS L ON L.ID = LAT.FK_Lecture
INNER JOIN szkolaJazdyHD.dbo.Date AS D ON D.Date = CONVERT(VARCHAR(10), L.StartTime, 111)

GO

SELECT * FROM vLectureAttendance

GO

DROP VIEW vLectureAttendance

USE master

/*

Database:

CREATE TABLE LectureAttendanceList
(
    FK_StudentCourse INT,
    FK_Lecture INT,
    Present INT,
    PRIMARY KEY (FK_StudentCourse, FK_Lecture),
    FOREIGN KEY (FK_StudentCourse) REFERENCES StudentCourse (StudentCourse),
    FOREIGN KEY (FK_Lecture) REFERENCES Lecture (ID)
);

Date warehouse:

CREATE TABLE LectureAttendance (
    ID_StudentCourse INT NOT NULL,
    ID_Date INT NOT NULL,
	ID_Lecture INT NOT NULL,
    Present FLOAT NOT NULL,
    PRIMARY KEY (ID_StudentCourse, ID_Lecture),
    FOREIGN KEY (ID_StudentCourse) REFERENCES StudentCourse(ID),
    FOREIGN KEY (ID_Date) REFERENCES Date(ID)
);

*/
