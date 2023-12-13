use szkolaJazdy

-- Address
BULK INSERT Address
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\Hurtownie Danych\new_Address.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Address;


-- Student
BULK INSERT Student
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\Hurtownie Danych\new_Student.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Student;


-- Employee
BULK INSERT Employee
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\Hurtownie Danych\new_Employee.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Employee;


-- Bill
BULK INSERT Bill
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\Hurtownie Danych\new_Bill.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Bill;


-- Course
BULK INSERT Course
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\Hurtownie Danych\new_Course.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Course;


-- StudentCourse
BULK INSERT StudentCourse
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\Hurtownie Danych\new_StudentCourse.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from StudentCourse;


-- Lecture
BULK INSERT Lecture
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\Hurtownie Danych\new_Lecture.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Lecture;


-- LectureAttendanceList
BULK INSERT LectureAttendanceList
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\Hurtownie Danych\new_LectureAttendance.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
select * from LectureAttendanceList;


--Car
BULK INSERT Car
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\Hurtownie Danych\new_Car.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from Car;


--DrivingLesson
BULK INSERT DrivingLesson
FROM 'C:\Users\Marcel\Documents\SQL Server Management Studio\Hurtownie Danych\new_DrivingLesson.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', DATAFILETYPE='widechar', CHECK_CONSTRAINTS);
Select * from DrivingLesson;

use master
