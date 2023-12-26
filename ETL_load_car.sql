USE szkolaJazdyHD
go

IF (OBJECT_ID('vCar') IS NOT NULL) DROP VIEW vCar
GO

CREATE VIEW vCar
AS SELECT
	VIN,
	Brand,
	Model,
	Age = cast(DATEPART(YEAR, CURRENT_TIMESTAMP) as int) - Year --returns cars year in time of ETL process
FROM szkolaJazdyBD.dbo.Car
GO

CREATE TABLE tmpCar (
    ID INT PRIMARY KEY IDENTITY(0,1),
    VIN VARCHAR(17),
    Brand VARCHAR(50),
    Model VARCHAR(50),
    Age INT,
    Actual BIT
);

insert into dbo.tmpCar (VIN, Brand, Model, Age, Actual)
select VIN, Brand, Model, Age, 1
from
(
merge into szkolaJazdyHD.dbo.Car as tt
	using vCar as st
		ON st.VIN = tt.VIN
			when not matched then insert
				(VIN, Brand, Model, Age, Actual)
				values (st.VIN,st.Brand,st.Model,st.Age,1)
			when matched
				and tt.Actual = 1
				and (st.age <> tt.age)
			then update
				set tt.actual = 0
				OUTPUT 
					st.VIN,
					st.Brand,
					st.Model,
					st.Age,
					$Action as MergeAction
					) as MRG
where mrg.MergeAction = 'UPDATE';


insert into Car(VIN, Brand, Model, Age, Actual) select VIN, Brand, Model, Age, Actual from tmpCar

Drop table tmpCar
DROP VIEW vCar

select * from szkolaJazdyHD.dbo.Car

USE master


-- Gdyby ktoœ pytal
-- https://www.sqlservercentral.com/articles/slowly-changing-dimensions-using-t-sql-merge
-- po co tabela pomocnicza
-- https://stackoverflow.com/questions/2642504/scd2-merge-statement-sql-server