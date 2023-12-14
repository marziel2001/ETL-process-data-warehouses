USE szkolaJazdyHD

IF (OBJECT_ID('vCourse') IS NOT NULL) DROP VIEW vCourse

GO

CREATE VIEW vCourse
AS SELECT
	Edition =  C.ID,
	ID_StartDate = D.ID
FROM szkolaJazdyBD.dbo.Course AS C
INNER JOIN szkolaJazdyHD.dbo.Date AS D ON D.Date = CONVERT(VARCHAR(10), C.StartDate, 111)

GO

SELECT * FROM vCourse

GO

DROP VIEW vCourse

USE master

/*

Database:

CREATE TABLE Course
(
    ID INT PRIMARY KEY IDENTITY(0,1),
    StartDate DATE,
    BasePrice FLOAT(2),
    ExtraHourPrice FLOAT(2)
);

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
