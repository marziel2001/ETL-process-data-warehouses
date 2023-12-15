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
	d.ID as Date_,
	duration = datepart(HOUR, dl.EndTime - dl.StartTime),
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
	c.ExtraHourPrice as one_hour_price,
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

--select * from vDrivingLessonTmp

merge into szkolaJazdyHD.dbo.DrivingLesson as tt
	using vDrivingLessonTmp as st
		ON st.FK_Instructor = tt.ID_Instructor
		and st.FK_StudentCourse = tt.ID_StudentCourse
		and st.Bill_id = tt.Bill
		and st.Date_ = tt.ID_Date
		and st.duration = tt.Duration
		and st.Bill_Issue_Date = tt.ID_BillIssueDate
		and st.Bill_Payment_Date = tt.ID_BillPaymentDate
		and st.one_hour_price = tt.One_hour_price 
		and st.total_cost = tt.Total_cost
			when not matched then insert
				values (
					st.FK_Instructor,
					st.FK_StudentCourse,
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