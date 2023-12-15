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

merge into szkolaJazdyHD.dbo.Car as tt
	using vCar as st
		ON st.VIN = tt.VIN
		and st.Brand = tt.Brand
		and st.Model = tt.Model
			when not matched then insert
				values (
					st.VIN,
					st.Brand,
					st.Model,
					st.Age,
					st.Actual
				);

DROP VIEW vCar

select * from szkolaJazdyHD.dbo.Car

USE master

/*
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
