use szkolaJazdyHD
go

if (object_id('vDrivingLessonTmp') is not null) drop view vDrivingLessonTmp;
go
create view vDrivingLessonTmp
as
Select
	dl.FK_Instructor,
	dl.FK_StudentCourse,
	Bill_id = 
		case
			when dl.FK_Bill is null
				then 0
				else dl.FK_Bill
			end,
	Bill_Issue_Date = 
		case
			when id.ID is null
				then 0
				else id.ID
			end,
	Bill_Payment_Date = 
		case
			when pd.ID is null
				then 0
				else pd.ID
			end,
	d.ID as Date_,
	duration = datepart(HOUR, dl.EndTime - dl.StartTime),
	c.ExtraHourPrice as one_hour_pice,
	total_cost = datepart(HOUR, dl.EndTime - dl.StartTime) * c.ExtraHourPrice

from szkolaJazdyBD.dbo.DrivingLesson as dl
left join szkolaJazdyBD.dbo.Bill as b on dl.FK_Bill = b.ID
	inner join szkolaJazdyBD.dbo.StudentCourse as sc on sc.StudentCourse = dl.FK_StudentCourse
	inner join szkolaJazdyBD.dbo.Course as c on c.ID = sc.FK_Course

left join szkolaJazdyHD.dbo.Date as id on CONVERT(varchar(10), id.date, 111) 
										= convert(varchar(10), b.issueTime, 111)
left join szkolaJazdyHD.dbo.Date as pd on CONVERT(varchar(10), pd.date, 111) 
										= convert(varchar(10), b.PaymentTime, 111)
inner join szkolaJazdyHD.dbo.Date as d on CONVERT(varchar(10), d.date, 111) 
										= CONVERT(varchar(10), dl.StartTime, 111)

go

select * from vDrivingLessonTmp
select count(*) as d from vDrivingLessonTmp

use master
