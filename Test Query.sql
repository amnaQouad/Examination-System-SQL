

---- Use this command to reset the identity value to 1
--DBCC CHECKIDENT ('Exam', RESEED, 0);

--======================Test Query=========================

delete from Exam
                   -----------Tables--------------
select* from [dbo].[Branch]
----------------
select* from [dbo].[Tracks]
-----------------
select* from [dbo].[Intake]
----------------
select* from [dbo].[Class]
-----------------
select* from [dbo].[Instructor]
-----------------
select* from [dbo].[Student]
-----------------
select* from [dbo].[Courses]
-----------------
select* from [dbo].[Exam]
-----------------
select* from [dbo].[Question]
-----------------
select* from [dbo].[ExamQuestion]
-----------------
select* from [dbo].[StudentCourse]
-----------------
select* from [dbo].[StudentExam]
-----------------
select* from [dbo].[Instructor_Courses]
-----------------
select* from[dbo].[User_Account]
----------------
delete from Exam
		--------------------Procedure--------------------
--======Exam cycle=======--
-- Exam or Corrective
--Create Exam
--exam type,date,start time,duration,total degree,course_id,class_id,instructor_id
--begin try 
		Exec Instructor.CreateExam 'Exam','2024-01-17','23:00',170,100,1,1,1
--end try
--begin catch
--print 'Adsf'
--end catch
----------------------
--Add Question to Exam
SET NOCOUNT ON;
DECLARE @QuestionDeg AS Instructor.QuestionDegreeType;
INSERT INTO @QuestionDeg (QuestionID, QuestionDegree)
----Manual/ Random
--VALUES
--('M1', 30), 	
--('M2', 50),     
--('X21', 30);
-- @InstructorID, @CourseID, @RandomSelection, @ExamID, @NumberOfRandomQuestion, @QuestionDegrees
		Exec Instructor.AddQuestions_Proc 1, 1, 'Random', 10 , 3 , @QuestionDeg;
-----------------------

--Add Student to exam 
--istructor_id,student_id,exam_id
	Exec Instructor.AddStudentsToExam   1, '1,2',10;


-------------------------------
--Store Student Answer 
SET NOCOUNT ON;
DECLARE @StudentAnswers AS Student.AnswerTableType;
INSERT INTO @StudentAnswers (QuestionID, StudentAnswer)
VALUES ('T18', 'True'),('X24', 'Double rectangle');
-- @StudentID,@ExamID
	EXEC Student.StoreStudentAnswers  2, 10, @StudentAnswers;
------------------------------------------
--Update Result of student

--student id,exam id 
exec UpdateResults 2,10

--============================--
---Order by Specific Column in Stusent Table
--T_Manager
exec T_Manager.OrderBYStd_Proc  'ID';
--Name,ID,Age,Email,City--

---------------------------------
---Order by Specific Column in instructor data

exec T_Manager.InstructorDataOrderedBy_Proc 'InstructorName';

--InstructorName,ExamDate,CourseName,CourseID,InstructorID
--------------------------------------------
---Order by Specific Column in Manager data
-- Order By Student Data By ==>
exec T_Manager.MangerDataOrderedBy_Proc 'IntakeName';
--IntakeName,BrancheName,StudentCity

------------------------------------------------------
-- Order course_student_instructor by course ID

--course id--
EXEC T_Manager.crs_std_inst_INFO_by_course_id 1;
-----------------------------------------------
--update year of intake 

--intake year,intake id--
EXEC T_Manager.UpdateYearOnIntakeInsert @intake = '2027', @id = 9;
----------------------------------------------------------
--show data by year

EXEC T_Manager.ShowDataByYear  2024 ;
----------------------------------------------------
--get exam by year,course_is,instructor_id

EXEC T_Manager.GetExamsByYearCourseInstructor  2022,  5,  2;
----------------------------------------------------
-- create User Account

--login user ,password,type of user--
EXEC T_Manager.CreateUserLogin 'karen', 't123', 'Student';


		  ---------------Function------------------

--Search By Pattern in Instructor

Select * from T_Manager.InstructorSearchByPattern_FN ('InstructorName','m')
--InstructorName,CourseName,CourseID,InstructorID,ExamID,ExamType
---------------------------------------------------
--Search By Pattern in Student

select * from Instructor.StudentSearchByPattern_FN ('StudentName','M')

--StudentName,StudentAnswer,ExamID,Result
----------------------------------------------
-- Function Search by Pattern to show all data from Student Table

select * from T_Manager.SearchByPatternStdTable_FN ( 'Name' ,'')
--Name,Email,City
---------------------------------------------------
--Manager FUNCTION Search By Pattern to show needed data

select * from T_Manager.ManagerSearchByPattern_FN ( 'StudentName' ,'M')

--StudentName,StudentEmail,StudentCity,BrancheName,TrackName,IntakeName

-------------------------------------------------
--get student result by id

SELECT * FROM Student.StdCourseInfoByStudentID_FN (1);

		----------------------Views--------------------------

SELECT * FROM dbo.StudentView;
-----------------
SELECT * FROM T_Manager.CourseView;
-------------------
SELECT * FROM T_Manager.StudentCourseView;
-------------------
SELECT * FROM InstructorCourseView
-------------------
SELECT * FROM Instructor.ExamInstructorView
-------------------
SELECT * FROM T_Manager.ClassDetailsView
--------------------
SELECT * FROM T_Manager.StudentExamView



