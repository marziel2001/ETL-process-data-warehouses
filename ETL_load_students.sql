use szkolaJazdyHD
go

if (object_id('vStudents') is not null) Drop view vStudents;
go
create view vStudents
as 
Select
	[PESEL],
	[FirstName_LastName] = cast([FirstName] + ' ' + [LastName] as varchar(100)),
	[Age] = 
		CASE 
			WHEN CONVERT(int, SUBSTRING([PESEL], 3, 2)) >= 20
				THEN abs(year(c.StartDate) - (CONVERT(int, SUBSTRING([PESEL], 1, 2)) + 2000))
			ELSE abs(year(c.StartDate) - (CONVERT(int, SUBSTRING([PESEL], 1, 2)) + 1900))
		END,
	[Actual] = 1,
	[year_of_joining] = year(c.StartDate)
	
from szkolaJazdyBD.dbo.Student as st 
inner join szkolaJazdyBD.dbo.StudentCourse stc on st.ID = stc.FK_Student
inner join szkolaJazdyBD.dbo.Course c on c.ID = stc.FK_Course
go

merge into szkolaJazdyHD.dbo.Student as tt
	using vStudents as st
		ON st.PESEL = tt.PESEL
		and st.FirstName_LastName = tt.FirstName_LastName
		and st.Age = tt.Age
		and st.Actual = tt.Actual
		when not matched then insert
			values (
				st.PESEL,
				st.FirstName_LastName,
				st.Age,
				st.Actual
			);

drop view vStudents;

select * from szkolaJazdyHD.dbo.Student

use master

--Select * from Student;
--CREATE TABLE Student (
--    ID INT PRIMARY KEY IDENTITY(1,1),
--    PESEL VARCHAR(11),
--    FirstName_LastName VARCHAR(100),
--    Age INT,
--    Actual BIT
--);
