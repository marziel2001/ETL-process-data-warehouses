use szkolaJazdyHD
go

if (object_id('drivingHoursMeasures') is not null) drop view drivingHoursMeasures;
go
create view drivingHoursMeasures
as
Select
	dl.FK_StudentCourse,
	NoExtraDrivingHours = sum(datepart(HOUR, dl.EndTime - dl.StartTime)) - 30

from szkolaJazdyBD.dbo.DrivingLesson as dl
group by dl.FK_StudentCourse
go

select * from drivingHoursMeasures


if (object_id('vStudentCourse') is not null) drop view vStudentCourse;
go
create view vStudentCourse
as
Select
	sc.FK_Student,
	sc.FK_Course,
	id.ID as Issue_date,
	pd.ID as payment_date,
	carID = 0,					-- add car ID
	sc.FK_Bill,
	c.BasePrice,
	noExtraDrivingHours = m.NoExtraDrivingHours,
	max(ex.TheoryScore) as TheoryScore


from szkolaJazdyBD.dbo.StudentCourse as sc
inner join szkolaJazdyBD.dbo.Bill as b on sc.FK_Bill = b.ID
inner join szkolaJazdyBD.dbo.Course as c on sc.FK_Course = c.ID
inner join szkolaJazdyHD.dbo.vTheory as ex on ex.stcourse = sc.StudentCourse
inner join drivingHoursMeasures as m on m.FK_StudentCourse = sc.StudentCourse
inner join szkolaJazdyHD.dbo.Date as id on CONVERT(varchar(10), id.date, 111) 
										= convert(varchar(10), b.issueTime, 111)
inner join szkolaJazdyHD.dbo.Date as pd on CONVERT(varchar(10), pd.date, 111) 
										= convert(varchar(10), b.PaymentTime, 111)
group by sc.FK_Student, sc.FK_Course, id.ID, pd.ID, sc.FK_Bill, c.BasePrice, m.NoExtraDrivingHours
go

select * from vStudentCourse;

use master
