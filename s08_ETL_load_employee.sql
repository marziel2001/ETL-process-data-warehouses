use szkolaJazdyHD
go

if (object_id('vEmployee') is not null) Drop view vEmployee;
go
create view vEmployee
as 
Select
	[PESEL],
	[FirstName_LastName] = cast([FirstName] + ' ' + [LastName] as varchar(100))	
from szkolaJazdyBD.dbo.Employee
go

merge into szkolaJazdyHD.dbo.Employee as tt
	using vEmployee as st
		ON st.PESEL = tt.PESEL
		and st.FirstName_LastName = tt.FirstName_LastName
			when not matched then insert
				values (
				st.PESEL,
				st.FirstName_LastName
				);

drop view vEmployee;
select * from Employee

use master
