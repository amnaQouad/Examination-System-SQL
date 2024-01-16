-------------------------------------------Many Options-----------------------------------------------
----------------------------------------------Functions-----------------------------------------------
-----------------------------------------------------------------------------------------------------
----- Istructor Function Search By Pattern to show needed data



CREATE OR ALTER FUNCTION InstructorSearchByPattern_FN
(
    @Option1 VARCHAR(MAX),
    @SearchPattern VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        Ins.ID AS InstructorID, Ins.name AS InstructorName, Ex.exam_ID AS ExamID,
        Ex.Type_Exam AS ExamType, Ex.Exam_Date AS ExamDate,Crs.id AS CourseID,
        Crs.name AS CourseName, Crs.description AS CourseDescription
    FROM
        Instructor Ins INNER JOIN Exam Ex ON Ins.ID = Ex.Ins_Exam
    INNER JOIN Courses Crs ON Ex.Crs_Id = Crs.id
    WHERE
        (
            (@Option1 = 'InstructorName' AND Ins.name LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'CourseName' AND Crs.name LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'CourseID' AND CAST(Crs.id AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'InstructorID' AND CAST(Ins.ID AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'ExamID' AND CAST(Ex.exam_ID AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'ExamType' AND CAST(Ex.Type_Exam AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') 

        )
);

Select * from InstructorSearchByPattern_FN ('InstructorName','m')

                     ------------------------------------------------------------

------ Student Function Search By Pattern in student table to show needed data 
CREATE OR ALTER FUNCTION StudentSearchByPattern_FN
(
    @Option1 VARCHAR(MAX),
    @SearchPattern VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        Stu.Std_ID AS StudentID, Stu.std_Name AS StudentName,
        ES.ExamID,  isnull(ES.StudentAnswer,'Not Answer Yet') as StudentAnswer,  ES.Result
    FROM
        StudentExam ES
    INNER JOIN
        Student Stu ON ES.StudentID = Stu.Std_ID  
    INNER JOIN
        Exam Ex ON ES.ExamID = Ex.exam_ID
    WHERE
        (
            (@Option1 = 'StudentName' AND Stu.std_Name LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'StudentAnswer' AND ES.StudentAnswer LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'ExamID' AND CAST(ES.ExamID AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'Result' AND CAST(ES.Result AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') 
        )
);

select * from StudentSearchByPattern_FN ('StudentName','m')


                            --------------------------------------------------

-- Function Search by Pattern to show all data from Student Table 
CREATE OR ALTER FUNCTION SearchByPatternStdTable_FN
    (@option1 VARCHAR(15), @SearchPattern NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Student
    WHERE
        (
            CASE 
                WHEN @option1 = 'Name' THEN std_Name
                WHEN @option1 = 'Email' THEN std_Email
                WHEN @option1 = 'City' THEN std_City
            END
        ) LIKE '%' + @SearchPattern + '%'
);


select * from SearchByPatternStdTable_FN ( 'Name' ,'')

------- Manager FUNCTION Search By Pattern to show needed data
CREATE or alter FUNCTION ManagerSearchByPattern_FN 
    (@Option1 VARCHAR(MAX),
    @SearchPattern VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT
        S.Std_ID AS StudentID, S.std_Name AS StudentName, S.std_City AS StudentCity,
        S.std_Email AS StudentEmail,
        T.Track AS TrackName, B.Name AS BranchName, I.Name AS IntakeName
    FROM
        Student S
    INNER JOIN
        [dbo].[Class] C ON S.class_Id = C.ClassID
    INNER JOIN
        Tracks T ON C.TrackID = T.id
    INNER JOIN
        Branch B ON C.BranchID = B.ID
    INNER JOIN
        Intake I ON C.IntakeID = I.ID
    WHERE
        (
            (@Option1 = 'StudentName' AND  S.std_Name LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'StudentEmail' AND  S.std_Email LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'StudentCity' AND  S.std_City LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'BrancheName' AND B.Name LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'TrackName' AND T.Track LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'IntakeName' AND I.Name LIKE '%' + @SearchPattern + '%')  
        )
);


select * from ManagerSearchByPattern_FN ( 'StudentName' ,'')


--=================== GEt Final Result By ID =====================

CREATE FUNCTION StdCourseInfoByStudentID_FN (@StudentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        S.std_Name AS StudentName,
        C.[name] AS CourseName,
        SC.TotalDegree,
        SC.FinalResult
    FROM
        StudentCourse SC
    INNER JOIN
        Student S ON SC.StudentID = S.Std_ID
    INNER JOIN
        Courses C ON SC.CourseID = C.id
    WHERE
        SC.StudentID = @StudentID
);

SELECT * FROM StdCourseInfoByStudentID_FN (4);


























