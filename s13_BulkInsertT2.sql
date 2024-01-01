use szkolaJazdyBD

BULK INSERT Student
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t2\new_Student.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from Student;

BULK INSERT Employee
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t2\new_Employee.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from Employee;

BULK INSERT Bill
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t2\new_Bill.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from Bill;

BULK INSERT Course
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t2\new_Course.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from Course;

BULK INSERT Car
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t2\new_Car.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from Car;

BULK INSERT StudentCourse
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t2\new_StudentCourse.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from StudentCourse;

BULK INSERT Lecture
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t2\new_Lecture.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	Select * from Lecture;

BULK INSERT LectureAttendanceList
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t2\new_LectureAttendance.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
	select * from LectureAttendanceList;

BULK INSERT DrivingLesson
	FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\HD_ETL\CSV\t2\new_DrivingLesson.csv'
	WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar');
	Select * from DrivingLesson;

--CREATE DATABASE szkolaJazdy_Snapshot_T1 
--ON
--(
--	NAME = szkolaJazdyBD,
--	FILENAME = 'C:\snapshotyHurtownie\DL_snapshot_t1.ss'
--)
--AS SNAPSHOT OF szkolaJazdyBD
--GO

--UPDATE Student
--SET LastName = 'Kowalski'
--WHERE PESEL = '25042139260'

--Select * from Student where PESEL = '25042139260'

use master
