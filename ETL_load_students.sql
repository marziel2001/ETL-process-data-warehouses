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


select * from vStudents order by [year_of_joining];

drop view vStudents;

use master

--Select * from Student;