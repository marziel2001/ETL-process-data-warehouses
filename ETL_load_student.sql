USE szkolaJazdyHD;
GO 

IF (object_id('vStudents') IS NOT NULL) DROP VIEW vStudents;
GO

CREATE VIEW vStudents AS
SELECT [PESEL],
		[FirstName_LastName] = cast([FirstName] + ' ' + [LastName] AS varchar(100)),
		[Age] = CASE
                   WHEN CONVERT(int, SUBSTRING([PESEL], 3, 2)) >= 20 THEN abs(year(c.StartDate) - (CONVERT(int, SUBSTRING([PESEL], 1, 2)) + 2000))
                   ELSE abs(year(c.StartDate) - (CONVERT(int, SUBSTRING([PESEL], 1, 2)) + 1900))
               END,
		[year_of_joining] = year(c.StartDate)
FROM szkolaJazdyBD.dbo.Student AS st
INNER JOIN szkolaJazdyBD.dbo.StudentCourse stc ON st.ID = stc.FK_Student
INNER JOIN szkolaJazdyBD.dbo.Course c ON c.ID = stc.FK_Course 
GO

--SELECT * FROM vStudents
--WHERE FirstName_LastName like 'Aniela Nyc' USE master

CREATE TABLE tmpStudent (ID INT PRIMARY KEY IDENTITY(0, 1), PESEL VARCHAR(11), FirstName_LastName VARCHAR(100), Age INT, Actual BIT);


















INSERT INTO dbo.tmpStudent(PESEL, FirstName_LastName, Age, Actual)
SELECT PESEL,
       FirstName_LastName,
       Age,
       1 -- check this



FROM
  (
	MERGE INTO szkolaJazdyHD.dbo.Student AS tt 
	USING szkolaJazdyHD.dbo.vStudents AS st
	ON st.PESEL = tt.PESEL 
		WHEN NOT matched
			THEN INSERT (PESEL,FirstName_LastName,Age,Actual)
				VALUES (st.PESEL,
						st.FirstName_LastName,
						st.Age,
						1) 
		WHEN matched
			AND tt.Actual = 1
			AND st.age <> tt.age
			THEN UPDATE
			SET tt.actual = 0 
			OUTPUT st.PESEL,
					st.FirstName_LastName,
					st.Age,
					$Action AS MergeAction
	) AS MRG
WHERE mrg.MergeAction = 'Update'; -- return only rows that have been updated


select * from dbo.tmpStudent







INSERT INTO szkolaJazdyHD.dbo.student(PESEL, FirstName_LastName, Age, Actual)
SELECT PESEL, FirstName_LastName, Age, Actual
FROM tmpStudent











DROP TABLE tmpStudent
DROP VIEW szkolaJazdyHD.dbo.vStudents

SELECT * FROM szkolaJazdyHD.dbo.Student
WHERE FirstName_LastName like 'Aniela Nyc' 
USE master











-- inserting same student 2nd time for test purposes
--select * from szkolaJazdyBD.dbo.Student
--select * from szkolaJazdyBD.dbo.StudentCourse
--insert into szkolaJazdyBD.dbo.StudentCourse values
--(0, 521, 77078)