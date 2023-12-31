USE szkolaJazdyHD

IF (OBJECT_ID('vCourse') IS NOT NULL) DROP VIEW vCourse
GO

CREATE VIEW vCourse
AS SELECT
	Edition = ROW_NUMBER() OVER (ORDER BY D.ID) 
	, ID_StartDate = D.ID
FROM 
	szkolaJazdyBD.dbo.Course AS C
INNER JOIN
	szkolaJazdyHD.dbo.Date AS D ON D.Date = CONVERT(VARCHAR(10), C.StartDate, 111)
GO

merge into szkolaJazdyHD.dbo.Course as tt
	using vCourse as st
		ON tt.edition = st.edition
		and tt.ID_StartDate = st.ID_StartDate
			when not matched then insert
				values (
					Edition,
					ST.ID_StartDate
				);

drop view vCourse;

select * from szkolaJazdyHD.dbo.Course

USE master;
