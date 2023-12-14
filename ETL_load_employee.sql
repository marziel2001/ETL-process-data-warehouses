use szkolaJazdyHD
go

if (object_id('vEmployees') is not null) Drop view vEmployees;
go
create view vEmployees
as 
Select
	[PESEL],
	[FirstName_LastName] = cast([FirstName] + ' ' + [LastName] as varchar(100))	
from szkolaJazdyBD.dbo.Employee
go


select * from vEmployees;

drop view vEmployees;

use master
