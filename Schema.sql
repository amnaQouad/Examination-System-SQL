








-- ======================== Schema =======================



create schema Mng;--for Manage
create schema trn;-- for Train
create schema Acc;-- for Access

alter schema Acc;
transfer dbo.User_Account,dbo.Instructor,dbo.Student

alter schema trn
transfer dbo.Instructor,dbo.Courses,StudentCourse,Instructor_Courses,student,examstudent,exam,Question,ExamQuestion  

alter schema Mng
transfer dbo.Class,
dbo.Intake,
dbo.Branch,
dbo.Track


alter schema Student 
transfer dbo.StdCourseInfoByStudentID_FN