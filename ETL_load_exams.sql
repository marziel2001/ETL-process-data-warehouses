use szkolaJazdyHD
go

if (OBJECT_ID('dbo.examTemp') is not null) drop table dbo.examTemp;
create table dbo.examTemp(
	PESEL nVARCHAR(11),
	firstName nVARCHAR(50),
	lastName nVARCHAR(50),
	theoryAttempt int,
	theoryDate datetime,
	theoryResult varchar(4), 
	theoryScore int,
	practiceAttempt int,
	practiceDate datetime,
	practiceResult nvarchar(4) check (practiceResult in ('PASS','FAIL'))
);
go

BULK INSERT dbo.examTemp
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t1\ExamResult.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
go

if (object_id('vPractice') is not null) Drop view vPractice;
go

create view vPractice as 
Select 
	ID_StudentCourse = sc.ID
	,PracticeAttempt
	,PracticeResult = case
		when theoryResult = 'PASS' 
			then cast(1.0 as float)
			else cast(0.0 as float)
		end,
	ID_Date = d.ID

from szkolaJazdyHD.dbo.examTemp 
join szkolaJazdyHD.dbo.Student as st on examTemp.PESEL = st.PESEL 
join szkolaJazdyHD.dbo.StudentCourse as sc on sc.ID_Student = st.ID 
inner join szkolaJazdyHD.dbo.Date as d on CONVERT(varchar(10), d.date, 111) = CONVERT(varchar(10), examTemp.practiceDate, 111)
go

if (object_id('vTheory') is not null) Drop view vTheory;
go
create view vTheory
as 
Select distinct
	ID_StudentCourse = sc.ID
	,TheoryAttempt
	,theoryResult = case
		when theoryResult = 'PASS' 
			then cast(1.0 as float)
			else cast(0.0 as float)
		end
	,TheoryScore
	,ID_Date = d.ID
from szkolaJazdyHD.dbo.examTemp 
join szkolaJazdyHD.dbo.Student as st on examTemp.PESEL = st.PESEL 
join szkolaJazdyHD.dbo.StudentCourse as sc on sc.ID_Student = st.ID 
inner join szkolaJazdyHD.dbo.Date as d on CONVERT(varchar(10), d.date, 111) = CONVERT(varchar(10), examTemp.theoryDate, 111)
go

merge into szkolaJazdyHD.dbo.PracticeAttempt as tt
	using vPractice as st
		ON st.ID_StudentCourse = tt.ID_StudentCourse
		and st.PracticeAttempt = tt.AttemptNumber
		
		when not matched then insert
			values (
				st.ID_StudentCourse,
				st.PracticeAttempt,
				st.PracticeResult,
				st.ID_Date
			);

merge into szkolaJazdyHD.dbo.TheoryAttempt as tt
	using vTheory as st
		ON 
		st.ID_StudentCourse = tt.ID_StudentCourse
		and st.TheoryAttempt = tt.AttemptNumber
		when not matched then insert
			values (
				st.ID_StudentCourse,
				st.TheoryAttempt,
				st.TheoryResult,
				st.TheoryScore,
				st.ID_Date
			);

select * from szkolaJazdyHD.dbo.TheoryAttempt
select * from szkolaJazdyHD.dbo.PracticeAttempt

use master
