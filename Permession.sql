
-- ======================== Permession =======================
--Admain
---------------------------------------
--Tranning Manager
--login for Tranning Manager
create login TrainingManager
with password ='t123';

--create user TranningManager
--for login Instructor

--premision on tables
Grant Select,  Insert, UPDATE On Object::[dbo].[Branch] to TrainingManager;
Grant Select,  Insert, UPDATE On Object:: [dbo].[Tracks]to TrainingManager;
Grant Select,  Insert On Object::[dbo].[Intake] to TrainingManager;
Grant Select,  Insert On Object::[dbo].[Student] to TrainingManager;
Grant Select On Object:: [dbo].[Instructor]to TrainingManager;


---------------------------------------------------
--Instructor
--login for instructor
create login Instructor
with password ='i123';

--create user Instructor
--for login Instructor

--premision on tables 
Grant Select, Insert, UPDATE, Delete On Object::[dbo].[Instructor] to Instructor;
Grant Select, Insert, UPDATE, Delete On Object::[dbo].[Courses] to Instructor;
Grant Select, Insert, UPDATE, Delete On Object::[dbo].[Instructor_Courses] to Instructor;
Grant Select, Insert, UPDATE, Delete On Object::[dbo].[Question] to Instructor;
Grant Select, Insert, UPDATE, Delete On Object::[dbo].[Exam] to Instructor;
Grant Select, Insert, UPDATE, Delete On Object::[dbo].[ExamQuestion] to Instructor;
Grant Select On Object::[dbo].[StudentExam] to Instructor;
Grant Select On Object::[dbo].[Student] to Instructor;

--premision on procedure , function 
--GRANT execute on object ::  to Instructor;

----------------------
--Student
--login for Student
create login Student
with password ='s123';

--create user Student
--for login Student

--premision on tables 
--GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[dbo].[Student] to Student;
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[dbo].[StudentExam]to Student;
GRANT SELECT ON OBJECT::[dbo].[StudentCourse]to Student;
deny SELECT ON OBJECT::[dbo].[ExamQuestion]to Student;
--GRANT SELECT ON OBJECT::[dbo].[Courses]to Student;
--GRANT SELECT ON OBJECT::[dbo].[Class]to Student;

------------------------




-- Transfere each user to their respective schema
Alter User [TrainingManager] WITH DEFAULT_SCHEMA = T_Manager;
Alter User Instructor WITH DEFAULT_SCHEMA = Instructor;
Alter User Student WITH DEFAULT_SCHEMA = Student;

-- Make Access For Control on Schema
Grant Control On Schema::T_Manager to [TrainingManager];
Grant Control On Schema::Instructor to Instructor;
Grant Control On Schema::Student to Student;



