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

if (object_id('vStudentCourse') is not null) drop view vStudentCourse;
go
create view vStudentCourse
as
Select
	sc.FK_Student,
	sc.FK_Course,
	id.ID as Issue_date,
	pd.ID as payment_date,
	carID = 0,-- add car ID
	sc.FK_Bill,
	c.BasePrice,
	noExtraDrivingHours = m.NoExtraDrivingHours,
	max(ex.TheoryScore) as theoryScore


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

select stc.*, st.ID from 
szkolaJazdyBD.dbo.StudentCourse as stc full join szkolaJazdyBD.dbo.Student as st on stc.FK_Student = st.ID 

merge into szkolaJazdyHD.dbo.StudentCourse as tt
	using vStudentCourse as st
		ON st.FK_Student = tt.ID_Student
		and st.FK_Course = tt.ID_Course
		and st.Issue_date = tt.ID_BillIssueDate
		and st.payment_date = tt.ID_BillPaymentDate
		and st.carID = tt.ID_car
		and st.FK_Bill = tt.Bill
		and st.BasePrice = tt.CoursePrice
		and st.noExtraDrivingHours = No_extra_driving_hours
		and st.theoryScore = tt.theory_score
		when not matched then insert
			values (
				st.FK_Student,
				st.FK_Course,
				st.Issue_date,
				st.payment_date,
				st.carID,
				st.FK_Bill,
				st.BasePrice,
				st.noExtraDrivingHours,
				st.theoryScore
			);

drop view vStudentCourse
drop view drivingHoursMeasures
use master

--CREATE TABLE StudentCourse
--(
--    ID INT PRIMARY KEY IDENTITY(1,1),
--    ID_Student INT NOT NULL,
--    ID_Course INT NOT NULL,
--    ID_BillIssueDate INT NOT NULL,
--    ID_BillPaymentDate INT NOT NULL,
--	  ID_car INT NOT NULL,
--    Bill VARCHAR(15) NOT NULL,
--    CoursePrice MONEY NOT NULL,
--    No_extra_driving_hours INT NOT NULL,
--    theory_score FLOAT NOT NULL,
--    FOREIGN KEY (ID_Student) REFERENCES Student(ID),
--    FOREIGN KEY (ID_Course) REFERENCES Course(ID),
--    FOREIGN KEY (ID_BillIssueDate) REFERENCES Date(ID),
--    FOREIGN KEY (ID_BillPaymentDate) REFERENCES Date(ID),
--    FOREIGN KEY (ID_car) REFERENCES Car(ID),
--);