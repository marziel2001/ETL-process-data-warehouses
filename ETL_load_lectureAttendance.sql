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
GO


merge into szkolaJazdyHD.dbo.LectureAttendance as tt
	using vLectureAttendance as st
		ON st.ID_StudentCourse = tt.ID_StudentCourse
		and st.ID_Date = tt.ID_Date
		and st.ID_Lecture = tt.ID_Lecture
		and st.Present = tt.Present
		when not matched then insert
			values (
				st.ID_StudentCourse,
				st.ID_Date,
				st.ID_Lecture,
				st.Present
			);

DROP VIEW vLectureAttendance

select * from szkolaJazdyHD.dbo.LectureAttendance

USE master

/*

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
