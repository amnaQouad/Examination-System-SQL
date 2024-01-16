
-- ======================== View =======================


CREATE VIEW StudentView AS
SELECT [std_Name]'Name', [std_Age]'Age',[std_Email]'E-mail',[std_City]'City'
FROM [dbo].[Student];

SELECT * FROM T_Manager.StudentView;
         ---------------
CREATE VIEW CourseView AS
select [name]'Name',[description]'Description'
from [dbo].[Courses]

SELECT * FROM T_Manager.CourseView;
         
----------------------

CREATE or alter VIEW StudentCourseView AS
SELECT s.std_Name AS Student_Name,s.std_Email'E-mail',s.std_Age'Age', c.[name]'Course Name',FinalResult
FROM [dbo].[Student] s
INNER JOIN StudentCourse sc ON s.Std_ID = sc.StudentID
INNER JOIN [dbo].[Courses] c ON sc.CourseID = c.id;

SELECT * FROM StudentCourseView;
----------------------------
CREATE VIEW InstructorCourseView AS
SELECT i.Name 'Instructor_name', c.[name]'course_name'
FROM Instructor i
INNER JOIN [dbo].[Instructor_Courses] ic ON i.[ID] = ic.[Instructor_id]
INNER JOIN [dbo].[Courses] c ON ic.[Course_id] = c.[id];

select * from InstructorCourseView
----------------------------------------
CREATE or alter VIEW ExamInstructorView AS
SELECT e.[Type_Exam],e.exam_TotalDuration,e.TotalDegree, i.Name AS InstructorName
FROM Exam e
LEFT JOIN Instructor i ON e.[Ins_Exam] = i.[ID];

select * from ExamInstructorView

-------------------------------------------
CREATE or alter VIEW ClassDetailsView AS
SELECT  t.Track, i.[Name] AS IntakeName, b.[Name] AS BranchName
FROM [dbo].[Class] c
LEFT JOIN [dbo].[Tracks] t ON c.[TrackID] = t.[id]
LEFT JOIN [dbo].[Intake] i ON c.[IntakeID] = i.[ID]
LEFT JOIN [dbo].[Branch] b ON c.[BranchID] = b.[ID];

select * from T_Manager.ClassDetailsView

-----------------------------
CREATE or alter  VIEW StudentExamView AS
SELECT se.[ExamID],se.QuestionID,s.[std_Name],se.StudentAnswer,se.Result, q.[text]
FROM [dbo].[StudentExam] se
LEFT JOIN Exam e ON se.ExamID = e.[exam_ID]
LEFT JOIN Question q ON se.QuestionID = q.[ID]
LEFT JOIN Student s ON se.StudentID = s.[Std_ID];

select * from StudentExamView