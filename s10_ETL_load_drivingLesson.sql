use szkolaJazdyHD
go

if (object_id('vDrivingLessonTmp') is not null) drop view vDrivingLessonTmp;
go

select * from szkolaJazdyBD.dbo.DrivingLesson
go

create view vDrivingLessonTmp as
Select
	ID_Instructor = e.ID
	,ID_StudentCourse = sc.ID
	,Bill_id = 
		case
			when bd_dl.FK_Bill is null
				then 0
				else bd_dl.FK_Bill
			end
	,Date_ = d.ID
	,duration = datepart(HOUR, bd_dl.EndTime - bd_dl.StartTime)
	,Bill_Issue_Date = 
		case
			when id.ID is null
				then 0
				else id.ID
			end
	,Bill_Payment_Date = 
		case
			when pd.ID is null
				then 0
				else pd.ID
			end
	,one_hour_price = bd_c.ExtraHourPrice
	,total_cost = datepart(HOUR, bd_dl.EndTime - bd_dl.StartTime) * bd_c.ExtraHourPrice

from szkolaJazdyBD.dbo.DrivingLesson as bd_dl
join szkolaJazdyBD.dbo.Employee as bd_e on bd_e.ID = bd_dl.FK_Instructor
join szkolaJazdyHD.dbo.Employee as e on e.PESEL = bd_e.PESEL --BK

-- wyciagnac pesel z BD i potem tym peselem wyciagnac ID z HD
join szkolaJazdyBD.dbo.StudentCourse as bd_sc on bd_sc.StudentCourse = bd_dl.FK_StudentCourse
join szkolaJazdyBD.dbo.Student as bd_s on bd_s.ID = bd_sc.FK_Student
join szkolaJazdyHD.dbo.Student as s on s.PESEL = bd_s.PESEL
join szkolaJazdyHD.dbo.StudentCourse as sc on sc.ID_Student = s.ID

join szkolaJazdyBD.dbo.Course as bd_c on bd_c.ID = bd_sc.FK_Course
left join szkolaJazdyBD.dbo.Bill as bd_b on bd_dl.FK_Bill = bd_b.ID

left join szkolaJazdyHD.dbo.Date as id on CONVERT(varchar(10), id.date, 111) = convert(varchar(10), bd_b.issueTime, 111)
left join szkolaJazdyHD.dbo.Date as pd on CONVERT(varchar(10), pd.date, 111) = convert(varchar(10), bd_b.PaymentTime, 111)
left join szkolaJazdyHD.dbo.Date as d on CONVERT(varchar(10), d.date, 111) = CONVERT(varchar(10), bd_dl.StartTime, 111)
go

--select * from szkolaJazdyBD.dbo.DrivingLesson
select count(*) as x from vDrivingLessonTmp
select * from vDrivingLessonTmp order by ID_StudentCourse 

merge into szkolaJazdyHD.dbo.DrivingLesson as tt
	using vDrivingLessonTmp as st
		ON st.ID_StudentCourse = tt.ID_StudentCourse
		and st.Date_ = tt.ID_Date
			when not matched then insert
				values (
					st.ID_Instructor,
					st.ID_StudentCourse,
					st.Bill_id,
					st.Date_,
					st.duration,
					st.Bill_Issue_Date,
					st.Bill_Payment_Date,
					st.one_hour_price,
					st.total_cost
				);

drop view vDrivingLessonTmp

select * from szkolaJazdyHD.dbo.DrivingLesson

use master
