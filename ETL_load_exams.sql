use szkolaJazdyHD
go


if (OBJECT_ID('dbo.examTemp') is not null) drop table dbo.examTemp;
create table dbo.examTemp(
	PESEL nVARCHAR(11),
	firstName nVARCHAR(50),
	lastName nVARCHAR(50),
	theoryAttempt int,
	theoryDate datetime,
	theoryResult varchar(4), -- change grtr to generate floats
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
	stc.StudentCourse as stcourse,
	[PracticeAttempt],
	[PracticeResult],
	d.ID as DateID

from szkolaJazdyHD.dbo.examTemp inner join szkolaJazdyBD.dbo.Student as st on 
examTemp.PESEL = st.PESEL inner join szkolaJazdyBD.dbo.StudentCourse as stc on stc.FK_Student = st.ID 
inner join szkolaJazdyHD.dbo.Date as d on CONVERT(varchar(10), d.date, 111) = CONVERT(varchar(10), examTemp.practiceDate, 111)
go

if (object_id('vTheory') is not null) Drop view vTheory;
go
create view vTheory
as 
Select distinct
	stc.StudentCourse as stcourse,
	[TheoryAttempt],
	theoryResult = case
		when theoryResult = 'PASS' 
			then cast(1.0 as float)
			else 0.0
		end,
	[TheoryScore],
	d.ID as DateID

from szkolaJazdyHD.dbo.examTemp inner join szkolaJazdyBD.dbo.Student as st on 
examTemp.PESEL = st.PESEL inner join szkolaJazdyBD.dbo.StudentCourse as stc on stc.FK_Student = st.ID 
inner join szkolaJazdyHD.dbo.Date as d on CONVERT(varchar(10), d.date, 111) = CONVERT(varchar(10), examTemp.theoryDate, 111)
go

merge into szkolaJazdyHD.dbo.TheoryAttempt as tt
	using vTheory as st
		ON st.stcourse = tt.ID_StudentCourse
		and st.TheoryAttempt = tt.AttemptNumber
		and st.TheoryResult = tt.Result
		and st.TheoryScore = tt.Score
		and st.DateID = tt.ID_Date
		
		when not matched then insert
			values (
				st.stcourse,
				st.TheoryAttempt,
				st.TheoryResult,
				st.TheoryScore,
				st.DateID
			);

merge into szkolaJazdyHD.dbo.PracticeAttempt as tt
	using vPractice as st
		ON st.stcourse = tt.ID_StudentCourse
		and st.PracticeAttempt = tt.AttemptNumber
		and st.PracticeResult = tt.Result
		and st.DateID = tt.ID_Date
		
		when not matched then insert
			values (
				st.stcourse,
				st.PracticeAttempt,
				st.PracticeResult,
				st.DateID
			);


select * from szkolaJazdyHD.dbo.TheoryAttempt
select * from szkolaJazdyHD.dbo.PracticeAttempt

drop view vTheory
drop view vPractice
use master



--CREATE TABLE PracticeAttempt (
--    ID_StudentCourse INT NOT NULL,
--    AttemptNumber INT NOT NULL,
--    Result FLOAT NOT NULL,
--    ID_Date INT NOT NULL,
--    FOREIGN KEY (ID_StudentCourse) REFERENCES StudentCourse(ID),
--    FOREIGN KEY (ID_Date) REFERENCES Date(ID)
--);
