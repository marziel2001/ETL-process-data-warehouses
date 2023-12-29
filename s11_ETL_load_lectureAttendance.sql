USE szkolaJazdyHD

IF (OBJECT_ID('vLectureAttendance') IS NOT NULL) DROP VIEW vLectureAttendance
GO

CREATE VIEW vLectureAttendance AS 
SELECT
	ID_StudentCourse = sc.ID
	,ID_Date = d.ID
	,ID_Lecture = bd_l.ID -- degenerate dim
	,Present = CAST(bd_la.Present AS float)

FROM szkolaJazdyBD.dbo.LectureAttendanceList AS bd_la
join szkolaJazdyBD.dbo.StudentCourse as bd_sc on bd_sc.StudentCourse = bd_la.FK_StudentCourse
join szkolaJazdyBD.dbo.Student as bd_s on bd_s.ID = bd_sc.FK_Student
join szkolaJazdyHD.dbo.Student as s on s.PESEL = bd_s.PESEL
join szkolaJazdyHD.dbo.StudentCourse as sc on sc.ID_Student = s.ID

INNER JOIN szkolaJazdyBD.dbo.Lecture AS bd_l ON bd_l.ID = bd_la.FK_Lecture
INNER JOIN szkolaJazdyHD.dbo.Date AS d ON D.Date = CONVERT(VARCHAR(10), bd_l.StartTime, 111)
GO

select * from vLectureAttendance order by ID_StudentCourse

merge into szkolaJazdyHD.dbo.LectureAttendance as tt
	using vLectureAttendance as st
		ON st.ID_StudentCourse = tt.ID_StudentCourse
		and st.ID_Lecture = tt.ID_Lecture
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
