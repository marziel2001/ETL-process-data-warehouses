use szkolaJazdyHD
go

if (object_id('vDrivingLessonTmp') is not null) drop view vDrivingLessonTmp;
go

create view vDrivingLessonTmp as
Select
	ID_Instructor = e.ID
	,ID_StudentCourse = sc.ID
	,Bill_id = 
		case
			when dl.FK_Bill is null
				then 0
				else dl.FK_Bill
			end
	,Date_ = d.ID
	,duration = datepart(HOUR, dl.EndTime - dl.StartTime)
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
	,total_cost = datepart(HOUR, dl.EndTime - dl.StartTime) * bd_c.ExtraHourPrice

from szkolaJazdyBD.dbo.DrivingLesson as dl
join szkolaJazdyBD.dbo.Employee as bd_e on bd_e.ID = dl.FK_Instructor
join szkolaJazdyHD.dbo.Employee as e on e.PESEL = bd_e.PESEL

join szkolaJazdyBD.dbo.StudentCourse as bd_sc on bd_sc.StudentCourse = dl.FK_StudentCourse
join szkolaJazdyHD.dbo.StudentCourse as sc on sc.ID_Student = bd_sc.FK_Student and sc.ID_Course = bd_sc.FK_Course

join szkolaJazdyBD.dbo.Course as bd_c on bd_c.ID = bd_sc.FK_Course

left join szkolaJazdyBD.dbo.Bill as bd_b on dl.FK_Bill = bd_b.ID

left join szkolaJazdyHD.dbo.Date as id on CONVERT(varchar(10), id.date, 111) = convert(varchar(10), bd_b.issueTime, 111)
left join szkolaJazdyHD.dbo.Date as pd on CONVERT(varchar(10), pd.date, 111) = convert(varchar(10), bd_b.PaymentTime, 111)
inner join szkolaJazdyHD.dbo.Date as d on CONVERT(varchar(10), d.date, 111) = CONVERT(varchar(10), dl.StartTime, 111)
go

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


--CREATE TABLE DrivingLesson (
--	ID INT IDENTITY(1,1) PRIMARY KEY,
--    ID_Instructor INT NOT NULL,
--    ID_StudentCourse INT NOT NULL,
--    Bill VARCHAR(15) NOT NULL,
--    ID_Date INT NOT NULL,
--    Duration INT NOT NULL,
--    ID_BillIssueDate INT NOT NULL,
--    ID_BillPaymentDate INT NOT NULL,
--    One_hour_price MONEY NOT NULL,
--    Total_cost MONEY NOT NULL,

--    FOREIGN KEY (ID_Instructor) REFERENCES Employee(ID),
--    FOREIGN KEY (ID_StudentCourse) REFERENCES StudentCourse(ID),
--    FOREIGN KEY (ID_Date) REFERENCES Date(ID),
--    FOREIGN KEY (ID_BillIssueDate) REFERENCES Date(ID),
--    FOREIGN KEY (ID_BillPaymentDate) REFERENCES Date(ID)
--);