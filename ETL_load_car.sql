USE szkolaJazdyHD

IF (OBJECT_ID('vCar') IS NOT NULL) DROP VIEW vCar

GO

CREATE VIEW vCar
AS SELECT
	VIN,
	Brand,
	Model,
	Age = 0,
	Actual = 1
FROM szkolaJazdyBD.dbo.Car

GO

SELECT * FROM vCar

GO

DROP VIEW vCar

USE master

/*

Database:

CREATE TABLE Car
(
    VIN NVARCHAR(17) PRIMARY KEY,
    Year INT,
    Brand NVARCHAR(50),
    Model NVARCHAR(50)
);

Data warehouse:

CREATE TABLE Car (
    ID INT PRIMARY KEY IDENTITY(1,1),
    VIN VARCHAR(17),
    Brand VARCHAR(50),
    Model VARCHAR(50),
    Age INT,
    Actual BIT
);

*/
