USE szkolaJazdyHD
GO 

IF (object_id('tmpStudent') IS NOT NULL) DROP TABLE tmpStudent;
GO

IF (object_id('vStudentsAges') IS NOT NULL) DROP VIEW vStudentsAges;
GO

IF (object_id('vStudents') IS NOT NULL) DROP VIEW vStudents;
GO

CREATE VIEW vStudentsAges AS
SELECT 
		[PESEL],
		[FirstName_LastName] = cast([FirstName] + ' ' + [LastName] AS varchar(100)),
		[Age] = CASE
                   WHEN CONVERT(int, SUBSTRING([PESEL], 3, 2)) >= 20 THEN abs(cast(DATEPART(YEAR, CURRENT_TIMESTAMP) as int) - (CONVERT(int, SUBSTRING([PESEL], 1, 2)) + 2000))
                   ELSE abs(cast(DATEPART(YEAR, CURRENT_TIMESTAMP) as int) - (CONVERT(int, SUBSTRING([PESEL], 1, 2)) + 1900))
               END
FROM szkolaJazdyBD.dbo.Student AS st
GO

--select * from vStudentsAges where PESEL='10292407441'
--GO

CREATE VIEW vStudents AS
SELECT 
		[PESEL],
		[FirstName_LastName],
		[Age] = CASE
					WHEN Age between 0 and 17 then '18-'
					WHEN Age between 18 and 20 then '18-20'
					WHEN Age between 21 and 30 then '21-30'
					WHEN Age between 31 and 40 then '31-40'
					WHEN Age between 41 and 60 then '41-60'
					WHEN Age > 60 then '60+'
               END
FROM vStudentsAges AS st
GO

select * from vStudents

CREATE TABLE tmpStudent (ID INT PRIMARY KEY IDENTITY(0, 1), PESEL VARCHAR(11), FirstName_LastName VARCHAR(100), Age VARCHAR(10), Actual BIT);

INSERT INTO dbo.tmpStudent(PESEL, FirstName_LastName, Age, Actual)
SELECT PESEL, FirstName_LastName, Age, 1 -- jesli dodajemy cos nowego to zawsze jest actual
FROM
  (
	MERGE INTO szkolaJazdyHD.dbo.Student AS tt 
	USING szkolaJazdyHD.dbo.vStudents AS st
	ON st.PESEL = tt.PESEL 
		WHEN NOT matched
			THEN INSERT (PESEL, FirstName_LastName, Age, Actual)
				VALUES (st.PESEL, st.FirstName_LastName, st.Age, 1) 
		WHEN matched
			AND (st.age <> tt.age
			or st.FirstName_LastName <> tt.FirstName_LastName)
			AND tt.Actual = 1
			THEN UPDATE
			SET tt.actual = 0 
			OUTPUT 
					st.PESEL,
					st.FirstName_LastName,
					st.Age,
					$Action AS MergeAction
	) AS MRG
WHERE mrg.MergeAction = 'Update'; -- return only rows that have been updated

INSERT INTO szkolaJazdyHD.dbo.student(PESEL, FirstName_LastName, Age, Actual)
SELECT PESEL, FirstName_LastName, Age, Actual
FROM tmpStudent

SELECT * FROM szkolaJazdyHD.dbo.Student
--WHERE FirstName_LastName like 'Aniela Nyc' 

USE master

