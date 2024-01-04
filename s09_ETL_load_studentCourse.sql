use szkolaJazdyHD;
go

if (object_id('drivingHoursMeasures') is not null) drop view drivingHoursMeasures;
go

if (object_id('vStudentCourse') is not null) drop view vStudentCourse;
go

create view drivingHoursMeasures as
Select
	ID_studentCourse = dl.FK_StudentCourse,
	NoExtraDrivingHours = sum(datepart(HOUR, dl.EndTime - dl.StartTime)) - 30
from szkolaJazdyBD.dbo.DrivingLesson as dl
group by dl.FK_StudentCourse
go

create view vStudentCourse as
Select
	ID_Student = s.ID --ok
	, ID_Course = c.ID --ok
	, Issue_date = id.ID
	, Payment_date = pd.ID
	, ID_Car = car.ID
	, ID_Bill = bd_sc.FK_Bill
	, bd_c.BasePrice
	, noExtraDrivingHours = m.NoExtraDrivingHours
	, theoryScore = 0
	, prace_attempts_no = 0
	, presence = CASE
					WHEN cast(sum(la.Present) as float) / 5.0 between 0 and 0.2 then '0-20%'
					WHEN cast(sum(la.Present) as float) / 5.0 between 0.2 and 0.5 then '20-50%'
					WHEN cast(sum(la.Present) as float) / 5.0 between 0.5 and 0.8 then '50-80%'
					WHEN cast(sum(la.Present) as float)  / 5.0 > 0.8 then '80-100%'
               END
	, ID_course_start_date = c.ID_StartDate
	-- student po kluczu biznesowym
from szkolaJazdyBD.dbo.StudentCourse as bd_sc 
join szkolaJazdyBD.dbo.Student as bd_s on bd_sc.FK_Student = bd_s.ID 
join szkolaJazdyHD.dbo.Student as s on bd_s.PESEL = s.PESEL
-- course po kluczu biznesowym
join szkolaJazdyBD.dbo.Course as bd_c on bd_sc.FK_Course = bd_c.ID 
join szkolaJazdyHD.dbo.Date as cd on CONVERT(varchar(10), bd_c.StartDate, 111) = convert(varchar(10), cd.date, 111) 
join szkolaJazdyHD.dbo.Course as c on c.ID_StartDate = cd.ID
-- bill jako degenerate dimension
join szkolaJazdyBD.dbo.Bill as b on bd_sc.FK_Bill = b.ID
-- wyniki z teorii 
--join szkolaJazdyHD.dbo.vTheory as ex on ex.stcourse = bd_sc.StudentCourse
-- ilosc dodatkowych godzin jazd
join drivingHoursMeasures as m on m.ID_studentCourse = bd_sc.StudentCourse
-- issue date rachunku
inner join szkolaJazdyHD.dbo.Date as id on CONVERT(varchar(10), id.date, 111) 
										= convert(varchar(10), b.issueTime, 111)
-- payment date rachunku
inner join szkolaJazdyHD.dbo.Date as pd on CONVERT(varchar(10), pd.date, 111) 
										= convert(varchar(10), b.PaymentTime, 111)
-- samochud
join szkolaJazdyHD.dbo.Car as car on VIN = bd_sc.FK_Car

-- lecture attendance
join szkolaJazdyBD.dbo.LectureAttendanceList as la on la.FK_StudentCourse = bd_sc.FK_Student
group by s.ID, c.ID, id.ID, pd.ID, car.ID, bd_sc.FK_Bill, BasePrice, noExtraDrivingHours, ID_StartDate
go

select * from szkolaJazdyBD.dbo.Student order by PESEL
select * from szkolaJazdyHD.dbo.Student order by PESEL
select * from vStudentCourse order by ID_Course

merge into szkolaJazdyHD.dbo.StudentCourse as tt
	using vStudentCourse as st
		ON st.ID_Student = tt.ID_Student
		and st.ID_Course = tt.ID_Course
		when not matched then insert
			values (
				st.ID_Student,
				st.ID_Course,
				st.Issue_date,
				st.Payment_date,
				st.ID_Car,
				st.ID_Bill,
				st.BasePrice,
				st.noExtraDrivingHours,
				st.theoryScore,
				st.prace_attempts_no,
				st.presence,
				st.ID_course_start_date
			);

select * from szkolaJazdyHD.dbo.StudentCourse

use master
