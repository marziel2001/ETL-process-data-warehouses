use szkolaJazdyHD
go

--if (object_id('drivingHoursMeasures') is not null) drop view drivingHoursMeasures;
--go
--create view drivingHoursMeasures
--as
--Select
--	dl.FK_StudentCourse,
--	NoExtraDrivingHours = sum(datepart(HOUR, dl.EndTime - dl.StartTime)) - 30

--from szkolaJazdyBD.dbo.DrivingLesson as dl
--group by dl.FK_StudentCourse
--go

--select * from drivingHoursMeasures


if (object_id('vDrivingLesson') is not null) drop view vDrivingLesson;
go
create view vDrivingLesson
as
Select
	dl.FK_Instructor,
	dl.FK_StudentCourse,
	dl.FK_Bill,
	id.ID as Bill_Issue_Date,
	pd.ID as  Bill_Payment_Date,
	d.ID as Date_,
	duration = datepart(HOUR, dl.EndTime - dl.StartTime),
	c.ExtraHourPrice as one_hour_pice,
	total_cost = datepart(HOUR, dl.EndTime - dl.StartTime) * c.ExtraHourPrice

from szkolaJazdyBD.dbo.DrivingLesson as dl
inner join szkolaJazdyBD.dbo.Bill as b on dl.FK_Bill = b.ID
inner join szkolaJazdyBD.dbo.StudentCourse as sc on sc.StudentCourse = dl.FK_StudentCourse
inner join szkolaJazdyBD.dbo.Course as c on c.ID = sc.FK_Course
inner join szkolaJazdyHD.dbo.Date as id on CONVERT(varchar(10), id.date, 111) 
										= convert(varchar(10), b.issueTime, 111)
inner join szkolaJazdyHD.dbo.Date as pd on CONVERT(varchar(10), pd.date, 111) 
										= convert(varchar(10), b.PaymentTime, 111)
inner join szkolaJazdyHD.dbo.Date as d on CONVERT(varchar(10), pd.date, 111) 
										= CONVERT(varchar(10), dl.StartTime, 111)
go

select * from vDrivingLesson;

use master
