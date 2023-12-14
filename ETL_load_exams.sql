use szkolaJazdyHD
go


if (OBJECT_ID('dbo.examTemp') is not null) drop table dbo.examTemp;
create table dbo.examTemp(
	PESEL nVARCHAR(11),
	firstName nVARCHAR(50),
	lastName nVARCHAR(50),
	theoryAttempt int,
	theoryDate datetime,
	theoryResult nvarchar(4) check (theoryResult in ('PASS','FAIL')),
	theoryScore int,
	practiceAttempt int,
	practiceDate datetime,
	practiceResult nvarchar(4) check (practiceResult in ('PASS','FAIL'))
);
go

BULK INSERT dbo.examTemp
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t1\ExamResult.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from examTemp;
go

-- CREATING VIEWS FOR PRACTICE AND THEORY
if (object_id('vPractice') is not null) Drop view vPractice;
go
create view vPractice
as 
Select 
	stc.StudentCourse,
	[PracticeAttempt],
	[PracticeResult],
	--[PracticeDate],
	d.ID as DateID

from szkolaJazdyHD.dbo.examTemp inner join szkolaJazdyBD.dbo.Student as st on 
examTemp.PESEL = st.PESEL inner join szkolaJazdyBD.dbo.StudentCourse as stc on stc.FK_Student = st.ID 
inner join szkolaJazdyHD.dbo.Date as d on CONVERT(varchar(10), d.date, 111) = CONVERT(varchar(10), examTemp.practiceDate, 111)
go

--select * from szkolaJazdyHD.dbo.Date
select * from vPractice;

if (object_id('vTheory') is not null) Drop view vTheory;
go
create view vTheory
as 
Select distinct
	stc.StudentCourse as stcourse,--TODO: change to studenCourse
	[TheoryAttempt],
	[TheoryResult],
	[TheoryScore],
	--[TheoryDate],
	d.ID as DateID

from szkolaJazdyHD.dbo.examTemp inner join szkolaJazdyBD.dbo.Student as st on 
examTemp.PESEL = st.PESEL inner join szkolaJazdyBD.dbo.StudentCourse as stc on stc.FK_Student = st.ID 
inner join szkolaJazdyHD.dbo.Date as d on CONVERT(varchar(10), d.date, 111) = CONVERT(varchar(10), examTemp.theoryDate, 111)
go

select * from vTheory order by stcourse;

use master