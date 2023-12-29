--use szkolaJazdyBD
--Select * from Student;
--Select * from Employee;
--Select * from Bill;
--Select * from Course;
--Select * from StudentCourse;
--Select * from Lecture;
--select * from LectureAttendanceList;
--Select * from Car;
--Select * from DrivingLesson;
--use master


use szkolaJazdyHD
Select * from Student;
Select * from Employee;
Select * from Course;
Select * from StudentCourse;
select * from LectureAttendance;
Select * from Car;
Select * from DrivingLesson;
use master

use szkolaJazdyHD
Select count(*) from Student;
Select count(*) from Employee;
Select count(*) from Course;
Select count(*) from StudentCourse;
select count(*) from LectureAttendance;
Select count(*) from Car;
Select count(*) from DrivingLesson;
use master