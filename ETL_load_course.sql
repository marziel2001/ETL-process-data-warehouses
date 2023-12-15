USE szkolaJazdyHD

IF (OBJECT_ID('vCourse') IS NOT NULL) DROP VIEW vCourse
GO

CREATE VIEW vCourse
AS SELECT
	Edition =  C.ID + 1, -- change it to edition after new bulk
	ID_StartDate = D.ID
FROM szkolaJazdyBD.dbo.Course AS C
INNER JOIN szkolaJazdyHD.dbo.Date AS D ON D.Date = CONVERT(VARCHAR(10), C.StartDate, 111)
GO

merge into szkolaJazdyHD.dbo.Course as tt
	using vCourse as st
		ON tt.edition = st.edition
		and tt.ID_StartDate = st.ID_StartDate
			when not matched then insert
				values (
					ST.edition,
					ST.ID_StartDate
				);

DROP VIEW vCourse;

select * from szkolaJazdyHD.dbo.Course

USE master;

/*
Data warehouse:

CREATE TABLE Course (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Edition INT,
    ID_StartDate INT,
    ID_EndDate INT,
    FOREIGN KEY (ID_StartDate) REFERENCES Date(ID),
    FOREIGN KEY (ID_EndDate) REFERENCES Date(ID)
);
*/
