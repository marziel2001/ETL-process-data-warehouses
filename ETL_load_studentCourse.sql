use szkolaJazdyHD
go


if (object_id('drivingHoursMeasures') is not null) drop view drivingHoursMeasures;
go
create view drivingHoursMeasures
as
Select
	dl.FK_StudentCourse,
	duration = sum(datepart(HOUR, dl.EndTime - dl.StartTime)) -30

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
	convert(varchar(10), b.issueTime, 111) as issue_date,
	convert(varchar(10), b.PaymentTime, 111) as payment_date,
	carID = 0, -- add car ID
	sc.FK_Bill,
	c.BasePrice,
	noExtraDrivingHours = 0, -- do extra driving hours count
	max(ex.TheoryScore) as TheoryScore


from szkolaJazdyBD.dbo.StudentCourse as sc
inner join szkolaJazdyBD.dbo.Bill as b on sc.FK_Bill = b.ID
inner join szkolaJazdyBD.dbo.Course as c on sc.FK_Course = c.ID
inner join szkolaJazdyHD.dbo.vTheory as ex on ex.stcourse = sc.StudentCourse
group by sc.FK_Student, sc.FK_Course, convert(varchar(10), b.issueTime, 111), convert(varchar(10), b.PaymentTime, 111), sc.FK_Bill, c.BasePrice
go

select * from vStudentCourse;

use master
