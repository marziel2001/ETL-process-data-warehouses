use szkolaJazdyBD

BULK INSERT Student
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t1\Student.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from Student;

BULK INSERT Employee
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t1\Employee.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from Employee;

BULK INSERT Bill
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t1\Bill.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from Bill;

BULK INSERT Course
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t1\Course.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from Course;

BULK INSERT Car
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t1\Car.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from Car;

BULK INSERT StudentCourse
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t1\StudentCourse.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from StudentCourse;

BULK INSERT Lecture
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t1\Lecture.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from Lecture;

BULK INSERT LectureAttendanceList
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t1\LectureAttendance.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	select * from LectureAttendanceList;

BULK INSERT DrivingLesson
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t1\DrivingLesson.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar');
	Select * from DrivingLesson;

use szkolaJazdyHD
go

if (OBJECT_ID('dbo.examTemp') is not null) drop table dbo.examTemp;
create table dbo.examTemp(
	PESEL nVARCHAR(11),
	firstName nVARCHAR(50),
	lastName nVARCHAR(50),
	theoryAttempt int,
	theoryDate datetime,
	theoryResult varchar(4), 
	theoryScore int,
	practiceAttempt int,
	practiceDate datetime,
	practiceResult nvarchar(4) check (practiceResult in ('PASS','FAIL'))
);
go

BULK INSERT dbo.examTemp
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t1\ExamResult.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
go

use master
