use szkolaJazdyBD

-- Address
BULK INSERT Address
FROM 'C:\Users\Pawe許Documents\ETL-process-data-warehouses\csv\t1\Address.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Address;


-- Student
BULK INSERT Student
FROM 'C:\Users\Pawe許Documents\ETL-process-data-warehouses\csv\t1\Student.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Student;


-- Employee
BULK INSERT Employee
FROM 'C:\Users\Pawe許Documents\ETL-process-data-warehouses\csv\t1\Employee.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Employee;


-- Bill
BULK INSERT Bill
FROM 'C:\Users\Pawe許Documents\ETL-process-data-warehouses\csv\t1\Bill.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Bill;


-- Course
BULK INSERT Course
FROM 'C:\Users\Pawe許Documents\ETL-process-data-warehouses\csv\t1\Course.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Course;


-- StudentCourse
BULK INSERT StudentCourse
FROM 'C:\Users\Pawe許Documents\ETL-process-data-warehouses\csv\t1\StudentCourse.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from StudentCourse;


-- Lecture
BULK INSERT Lecture
FROM 'C:\Users\Pawe許Documents\ETL-process-data-warehouses\csv\t1\Lecture.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Lecture;


-- LectureAttendanceList
BULK INSERT LectureAttendanceList
FROM 'C:\Users\Pawe許Documents\ETL-process-data-warehouses\csv\t1\LectureAttendance.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
select * from LectureAttendanceList;


--Car
BULK INSERT Car
FROM 'C:\Users\Pawe許Documents\ETL-process-data-warehouses\csv\t1\Car.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Car;


--DrivingLesson
BULK INSERT DrivingLesson
FROM 'C:\Users\Pawe許Documents\ETL-process-data-warehouses\csv\t1\DrivingLesson.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from DrivingLesson;

--CREATE DATABASE szkolaJazdySnapshotT1 ON
--(
--	NAME = szkolaJazdyBD,
--	FILENAME = 'C:\snapshotyHurtownie\DL_snapshot_t1.ss'
--)
--AS 
--SNAPSHOT OF szkolaJazdyBD
--GO

--UPDATE Student
--SET LastName = 'Kowalski'
--WHERE PESEL = '25042139260'

--Select * from Student where PESEL = '25042139260'

use master
