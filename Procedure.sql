
--========================== Procedure ==========================
--Create Proc to Add Questions(Random,Manually)
CREATE OR ALTER PROCEDURE AddQuestions_Proc
    @InstructorID int,
    @CourseID int,
    @RandomSelection varchar(15),
	@ExamID int,
	@NumberOfRandomQuestion int,
    @QuestionDegrees QuestionDegreesType readonly
AS
BEGIN
    SET NOCOUNT ON; 
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @TotalDegQuestion float = 0;
        DECLARE @TotalDegree float;
        SELECT @TotalDegree = TotalDegree
        FROM Exam
        WHERE Crs_Id = @CourseID;

        IF EXISTS (
            SELECT 1
            FROM Exam
            WHERE [Ins_Exam] = @InstructorID AND Crs_Id = @CourseID AND exam_ID = @ExamID
        )
        BEGIN
            IF NOT EXISTS (
        SELECT 1
        FROM ExamQuestion ,Exam
        WHERE ExamID = @ExamID AND [Ins_Exam] = @InstructorID AND Crs_Id = @CourseID
    )
      begin
		   --Random Questions
            IF (@RandomSelection = 'Random' or @RandomSelection = 'random')
            BEGIN
                INSERT INTO ExamQuestion(ExamID, QuestionID, Degree)
                SELECT TOP (@NumberOfRandomQuestion)  @ExamID, ID, CAST(RAND() * 5 + 1 AS INT)
                FROM Question
                ORDER BY NEWID();
            END

            --Manually Questions
            ELSE IF (@RandomSelection = 'Manual' or @RandomSelection = 'manual')
            BEGIN
                INSERT INTO ExamQuestion  (ExamID ,QuestionID, Degree)
                SELECT @ExamID, QuestionID, QuestionDegree
                FROM @QuestionDegrees;
            END

			else 
			begin
			print 'Please Enter Random or Manual'
			end
         end
		 else 
		 begin
		 print 'This Exam has already added'
		 end

        END
        ELSE 
        BEGIN
            PRINT 'Check that ExamID, CourseID, InstructorID are related';
        END
         -- Calcalute Total degree of exam
        SET @TotalDegQuestion = (SELECT SUM(Degree) FROM ExamQuestion WHERE ExamID = @ExamID);

        ---- Check Total degree is greater than Course Max Degree
        IF @TotalDegQuestion > @TotalDegree
        BEGIN
            PRINT 'Error: Total degree questions exceeds Total Degree Of Exam.';
            ROLLBACK;
            DELETE FROM ExamQuestion WHERE ExamID = @ExamID; 
            RETURN;
        END
        COMMIT;
    END TRY 
BEGIN CATCH
    print('Please enter valid data');
    ROLLBACK;
    RETURN; 
END CATCH

END;

--Execute Proc
SET NOCOUNT ON;
DECLARE @QuestionDeg AS QuestionDegreesType;
INSERT INTO @QuestionDeg (QuestionID, QuestionDegree)
VALUES
('M1', 30), 	
('T11', 50),     
('X21', 30);
EXEC AddQuestions_Proc 
    @InstructorID = 1,
    @CourseID = 1,
    @RandomSelection = 'Random', 
	@ExamID = 13 ,
	@NumberOfRandomQuestion = 5,
    @QuestionDegrees = @QuestionDeg;

 delete from ExamQuestion


 -------------------------------------------------------------
 -----Order by Specific Column in Stusent Table


CREATE OR ALTER PROC OrderBYStd_Proc @option1 VARCHAR(100)
AS
BEGIN
    SELECT *
    FROM Student
    ORDER BY 
        CASE
            WHEN @option1 = 'Name' THEN std_Name
            WHEN @option1 = 'Age' THEN CAST(std_Age AS varchar(100))
            WHEN @option1 = 'Email' THEN std_Email
            WHEN @option1 = 'City' THEN std_City
        END;
END


--EXECUTE PROC 
Exec OrderBYStd_Proc  'ID'; -- When Search By ID By Default sorting By ID
=======
CREATE OR ALTER proc OrderBYStd_Proc  @option1 VARCHAR(100)
AS
begin

    SELECT *
    FROM Student
    ORDER BY 
        CASE 
         
            WHEN @option1 = 'Name' THEN std_Name 
            WHEN @option1 = 'Age' THEN CAST(std_Age  AS varchar(100))
            WHEN @option1 = 'Email' THEN std_Email
            WHEN @option1 = 'City' THEN std_City
        END;
end;
--EXECUTE PROC 
exec OrderBYStd_Proc  'ID';

-----------------------------------------------------------------
--Order By Specific Column
CREATE OR ALTER proc InstructorDataOrderedBy_Proc @OrderByColumn VARCHAR(max)
AS
begin
    SELECT 
        Ins.ID AS InstructorID, Ins.name AS InstructorName, Ex.exam_ID AS ExamID,
        Ex.Type_Exam AS ExamType,Ex.Exam_Date AS ExamDate, Crs.id AS CourseID,
        Crs.name AS CourseName,Crs.description AS CourseDescription
    FROM 
        Instructor Ins Inner Join Exam Ex ON Ins.ID = Ex.[Ins_Exam]
    Inner Join Courses Crs ON Ex.Crs_Id = Crs.id
    ORDER BY 
        CASE
            WHEN @OrderByColumn = 'InstructorName' THEN Ins.name
            WHEN @OrderByColumn = 'ExamDate' THEN CAST(Ex.Exam_Date AS varchar(max))
            WHEN @OrderByColumn = 'CourseName' THEN Crs.name
           WHEN @OrderByColumn = 'CourseID' THEN  CAST(Crs.id AS varchar(max))
           WHEN @OrderByColumn = 'InstructorID' THEN  CAST(Ins.ID AS varchar(max))
        END
end

exec InstructorDataOrderedBy_Proc 'InstructorName'; -- We Make it as Procedure Because it have Order By
---------------------------------------------------------------
CREATE OR ALTER PROCEDURE MangerDataOrderedBy_Proc  @Option1 VARCHAR(MAX)
AS
BEGIN
    SELECT
        S.Std_ID AS StudentID, S.std_Name AS StudentName, S.std_City AS StudentCity,
        S.std_Email AS StudentEmail,
        T.Track AS TrackName, B.Name AS BranchName, I.Name AS IntakeName
    FROM
        Student S
    Inner Join
        Class C ON S.class_Id = C.ClassID
    Inner Join
        Tracks T ON C.TrackID = T.ID
    Inner Join
        Branch B ON C.BranchID = B.ID
    Inner Join
        Intake I ON C.IntakeID = I.ID
    ORDER BY
        CASE
            WHEN @Option1 = 'StudentName' THEN S.std_Name
            WHEN @Option1 = 'StudentEmail' THEN S.std_Email
            WHEN @Option1 = 'StudentCity' THEN S.std_City
            WHEN @Option1 = 'BrancheName' THEN B.Name
            WHEN @Option1 = 'TrackName' THEN T.Track
            WHEN @Option1 = 'IntakeName' THEN I.Name
        END;
END;




exec MangerDataOrderedBy_Proc 'IntakeName';




-------------------------------------------------------------
--CREATE OR ALTER proc StudentDataOrderedBy_Proc @OrderByColumn VARCHAR(100)
--AS
--begin
--    SELECT
--            Stu.Std_ID AS StudentID,  Stu.std_Name AS StudentName,
--            ES.ExamID,  ES.StudentAnswer,  ES.Result
--        FROM
--            StudentExam ES
--        Inner Join
--            Student Stu ON ES.StudentID = Stu.Std_ID  
--			Inner Join
--        Exam Ex ON ES.ExamID = Ex.exam_ID
--            ORDER BY
--            CASE
--			    WHEN @OrderByColumn = 'ID' THEN CAST(Stu.Std_ID AS varchar(100))
--				WHEN @OrderByColumn = 'Name' THEN Stu.std_Name
--				WHEN @OrderByColumn = 'ExamID' THEN CAST(ES.ExamID AS varchar(100))
--                WHEN @OrderByColumn = 'StudentAnswer' THEN ES.StudentAnswer
--                WHEN @OrderByColumn = 'Result' THEN  CAST(ES.Result AS varchar(100))
           
--            END;
--end

--exec StudentDataOrderedBy_Proc 'ID';  
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE crs_std_inst_INFO_by_course_id 
    @CourseID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Courses WHERE ID = @CourseID)
    BEGIN
        SELECT 
            c.id AS CourseID,
            c.name AS CourseName,
            c.description AS CourseDescription,
            i.ID AS InstructorID,
            i.name AS InstructorName,
            s.Std_ID AS StudentID,
            s.std_Name AS StudentName,
            s.std_Age AS StudentAge,
            s.std_City AS StudentCity,
            s.std_Email AS StudentEmail
        FROM Courses c 
        LEFT JOIN Instructor i ON c.ID = i.ID
        LEFT JOIN Student s ON c.ID = s.[class_Id]
        WHERE c.id = @CourseID
        ORDER BY c.id;
    END
    ELSE
    BEGIN
        PRINT 'Error: Course ID does not exist.';
    END
END;

EXEC crs_std_inst_INFO_by_course_id
@CourseID = 5;
------------------------------------------------------
CREATE OR ALTER PROCEDURE UpdateYearOnIntakeInsert
    @intake VARCHAR(50),
    @id INT
AS
BEGIN
    SET NOCOUNT ON; 
    DECLARE @currentYear INT;
    DECLARE @userProvidedYear INT;
    SET @currentYear = YEAR(GETDATE());
    SET @userProvidedYear = TRY_CAST(@intake AS INT);
    IF @userProvidedYear IS NOT NULL AND @userProvidedYear >= @currentYear AND @userProvidedYear <= @currentYear + 5
    BEGIN
        IF EXISTS (SELECT 1 FROM Intake WHERE [id] = @id)
        BEGIN
            UPDATE Intake
            SET Intake_Year = @userProvidedYear
            WHERE [id] = @id; 
            PRINT 'Year successfully updated.';
        END
        ELSE
        BEGIN
            PRINT 'Invalid ID provided. The specified ID does not exist in the Intake table.';
        END
    END
    ELSE
    BEGIN
        IF @userProvidedYear > @currentYear + 5
        BEGIN
            PRINT 'Invalid year provided. Please ensure the year is not more than 5 years ahead of the current year.';
        END
        ELSE
        BEGIN
            PRINT 'Invalid year provided. Please ensure the year is not less than the current year.';
        END
    END
END;




EXEC UpdateYearOnIntakeInsert @intake = '2027', @id = 9;
----------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE ShowDataByYear
    @inputYear INT
AS
BEGIN
    SELECT  C.id AS CourseID,C.[name] AS CourseName, C.[description] AS CourseDescription,Cl.ClassID AS ClassID,
	B.Name AS BranchName,
	N.Name AS IntakeName,
	T.Track AS TrackName,
	N.Intake_Year AS ClassYear,
	I.ID AS InstructorID,
	I.name AS InstructorName
    FROM Courses C , Instructor I , Class Cl,Intake N,Branch B,Tracks T, Exam E
    where N.ID = Cl.IntakeID and B.ID = Cl.BranchID and Cl.TrackID = T.id
	and N.Intake_Year = @inputYear and E.class_Id = Cl.ClassID and C.id = E.Crs_Id and I.ID = E.Ins_Exam
END;

EXEC ShowDataByYear  2024 ;
------------------------------------------------

CREATE OR ALTER PROCEDURE GetExamsByYearCourseInstructor 
    @year INT,
    @courseId INT,
    @instructorId INT
AS
BEGIN
    DECLARE @classExists INT, @courseExists INT, @instructorExists INT;
    SELECT @classExists = COUNT(*) 
    FROM Class c
    Inner Join Intake i ON c.IntakeID = i.ID
    WHERE i.[Intake_Year] = @year;
    SELECT @courseExists = COUNT(*) FROM [dbo].[Courses] WHERE id = @courseId;
    SELECT @instructorExists = COUNT(*) FROM Instructor WHERE ID = @instructorId;

    IF @classExists = 0
    BEGIN
        PRINT 'Year does not exist in the Class table';
        RETURN;
    END
    IF @courseExists = 0
    BEGIN
        PRINT 'Course ID does not exist in the Course table';
        RETURN;
    END

    IF @instructorExists = 0
    BEGIN
        PRINT 'Instructor ID does not exist in the Instructor table';
        RETURN;
    END
    SELECT 
         e.Type_Exam, e.Exam_Date, e.exam_StartTime, e.exam_TotalDuration, 
        e.TotalDegree, cr.[name] AS CourseName, i.name AS Ins_Name,Ik.Name as Intake, B.Name as Branch, T.Track , Ik.Intake_Year
    FROM 
        Exam e
    Inner Join 
        Class c ON e.class_Id = c.[ClassID]
    Inner Join 
        Instructor i ON e.Ins_Exam = i.ID
    Inner Join 
        [dbo].[Courses] cr ON e.Crs_Id = cr.id
    Inner Join 
        Intake intake ON c.IntakeID = intake.ID
    Inner Join 
        Branch B ON c.BranchID = B.ID
    Inner Join 
        Intake Ik ON c.IntakeID = Ik.ID
    Inner Join 
        Tracks T ON c.TrackID = T.id
    WHERE 
        Ik.Intake_Year = @year
        AND e.Crs_Id = @courseId
        AND e.[Ins_Exam] = @instructorId;
END;



EXEC GetExamsByYearCourseInstructor @year = 2022, @courseId = 5, @instructorId = 2;
-------------------------------------------------------------

CREATE OR ALTER PROCEDURE CreateExam  
    @Type NVARCHAR(50),
    @ExamDate DATE,
    @StartTime NVARCHAR(8),
    @TotalTime INT,
    @TotalDegree INT, 
    @Crs_Id INT,
    @Class_Id INT,
    @InstructorId INT
AS
BEGIN
 SET NOCOUNT ON;
    BEGIN TRY
        IF TRY_CAST(@ExamDate AS DATE) IS NULL
        BEGIN
            RAISERROR('Invalid ExamDate format. Please use yyyy-mm-dd format like (2024-01-12).', 16, 50005);
        END

        IF @ExamDate < GETDATE()
        BEGIN
            RAISERROR('ExamDate must be in the future.', 16, 50006);
        END

        IF TRY_CAST(@TotalTime AS INT) IS NULL OR TRY_CAST(@TotalDegree AS INT) IS NULL
        BEGIN
            RAISERROR('Invalid data type for TotalTime or TotalDegree', 16, 50001);
        END

        IF @Type NOT IN ('Exam', 'Corrective')
        BEGIN
            RAISERROR('Invalid Exam Type. Type should be either ''Exam'' or ''Corrective''', 16, 50002);
        END

        IF TRY_CAST(@StartTime AS TIME) IS NULL
        BEGIN
            SET @StartTime = @StartTime + ':00:00';
            IF TRY_CAST(@StartTime AS TIME) IS NULL
            BEGIN
                RAISERROR('Invalid StartTime format. Please use HH:mm format ', 16, 50003);
            END
        END

        IF @TotalTime <= 0 OR @TotalTime > 180
        BEGIN
            RAISERROR('Invalid TotalTime. Please provide a positive Number less than or equal to 180 for TotalTime.', 16, 50004);
        END

        IF NOT EXISTS (
            SELECT 1 
            FROM dbo.Instructor_Courses 
            WHERE Instructor_id = @InstructorId 
            AND Course_Id = @Crs_Id
        )
        BEGIN
            RAISERROR('Instructor does not have the specified Course', 16, 50000);
        END

        INSERT INTO dbo.Exam (Type_Exam, Exam_Date, exam_StartTime, exam_TotalDuration, TotalDegree, Crs_Id, Class_Id, Ins_Exam)
        VALUES (@Type, @ExamDate, @StartTime, @TotalTime, @TotalDegree, @Crs_Id, @Class_Id, @InstructorId);
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() IN (50000, 50001, 50002, 50003, 50004, 50005, 50006)
        BEGIN
            PRINT ERROR_MESSAGE();
        END
        ELSE
        BEGIN
            PRINT 'Please Enter Correct Data';
        END
    END CATCH
END;

Exec CreateExam 'Corrective','2024-12-31','23:00',170,50,3,2,1
--------------------------------------------------------------------
Create OR Alter PRoc Instructor.AddStudentsToExam
    @InstructorID int,
    @StudentIDs nvarchar(MAX),
    @ExamID int
as
begin
    Set noCount on;

        if NOT EXISTS (Select 1 From exam where Ins_Exam = @InstructorID)
        Begin
            Print 'Invalid Instructor ID';
            Return;
        End;

        if @StudentIDs IS NULL OR @StudentIDs = ''
        Begin
            Print 'Invalid StudentIDs.';
            Return;
        End;

        if NOT EXISTS (Select 1 From exam Where exam_ID = @ExamID)
        Begin
            Print 'Invalid ExamID.';
            Return;
        End;

        Declare @CourseID INT;
        Select @CourseID = Crs_Id FROM Exam Where exam_ID = @ExamID;

        if EXISTS (
            Select 1
            From StudentCourse sc
            INNER JOIN STRING_SPLIT(@StudentIDs, ',') s ON sc.StudentID = CAST(s.value AS INT)
            Where sc.CourseID = @CourseID AND sc.FinalResult = 'pass'
        )
        Begin
            Print 'One or more students have already passed the course related to this exam.';
            Return;
        End;

        if NOT EXISTS (
            Select 1
            From Student
            Where Std_ID IN (Select value FROM STRING_SPLIT(@StudentIDs, ','))
        )
        Begin
            Print 'One or more StudentIDs do not exist in the Student table.';
            Return;
        End;

        Create Table #TempStudentList (StudentID INT);

        Insert into #TempStudentList (StudentID)
        Select CAST(value AS INT)
        From String_Split(@StudentIDs, ',');

        Declare @QuestionIDs Nvarchar(MAX);
        Select @QuestionIDs = STRING_AGG(QuestionID, ',')
        From ExamQuestion
        Where ExamID = @ExamID;

        Insert into dbo.StudentExam (StudentID, ExamID, QuestionID)
        Select ts.StudentID, @ExamID, eq.value
        From #TempStudentList ts
        CROSS JOIN STRING_SPLIT(@QuestionIDs, ',') eq
        Where NOT EXISTS (
            Select 1
            From dbo.StudentExam se
            Where se.StudentID = ts.StudentID
              AND se.ExamID = @ExamID
              AND se.QuestionID = eq.value
        );

        Declare @ExamDate Date;
        Declare @StartTime Time;
        Declare @EndTime Time;

        Select @ExamDate = Exam_Date, @StartTime = exam_StartTime, @EndTime = exam_endTime
        From Exam
        Where exam_ID = @ExamID;

        Drop Table #TempStudentList;
    
End;


Exec Instructor.AddStudentsToExam   1, '21', 9;








-------------------------------------------------------------

Create OR Alter Proc UpdateResults 
    @std_id int, 
    @exam_id int
as
begin
begin try
    set NoCount on;
    If Not Exists (Select 1 From [dbo].[Student] Where Std_ID = @std_id)
    begin
        Print 'Student does not exist.';
        Return;
    End

    If Not Exists (Select 1 From [dbo].[Exam],StudentExam S Where exam_ID = @exam_id and S.ExamID = exam_ID)
    begin
        Print 'Exam does not exist.';
        Return;
    End
    If Exists (
        Select 1
        From [dbo].[StudentCourse] SC
        where SC.StudentID = @std_id AND SC.CourseID IN (SELECT Crs_Id FROM [dbo].[Exam] WHERE exam_ID = @exam_id)
    )
    Begin
        Print 'Exam For This Student Already Marked.';
        Return;
    end
    Update ES
    set Result = Case When Q.correct_answer = ES.StudentAnswer Then EQ.Degree Else 0 End
    From StudentExam ES, ExamQuestion EQ, Question Q
    where ES.StudentID = @std_id
        and ES.ExamID = @exam_id
        and ES.ExamID = EQ.ExamID 
        and ES.QuestionID = EQ.QuestionID 
        and EQ.QuestionID = Q.ID;

    Declare @total_degree int;
    Declare @Crs_ID int;

   SELECT 
    @total_degree = ISNULL(SUM(R.Result) OVER(), 0),
    @Crs_ID = E.Crs_Id
		FROM 
			[dbo].[StudentExam] R
		INNER JOIN 
			[dbo].[Exam] E ON R.ExamID = E.exam_ID
		WHERE 
			R.StudentID = @std_id AND R.ExamID = @exam_id;


    Insert Into [dbo].[StudentCourse] ([CourseID], [StudentID], [TotalDegree])
    Values (@Crs_ID, @std_id, @total_degree);
end try
	begin Catch
	Print 'Please Add Correct Data'
	end Catch
End;

Exec UpdateResults 9,9


--------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE Student.StoreStudentAnswers 
    @std_id INT, 
    @exam_id INT, 
    @student_answers Student.[AnswerTableType] READONLY
AS
BEGIN
SET NOCOUNT ON;

    if NOT EXISTS (
        SELECT 1
        FROM [dbo].[StudentExam]
        WHERE StudentID = @std_id AND ExamID = @exam_id
    )
    BEGIN
        RAISERROR('Invalid Student ID or Exam ID.', 16, 1);
		return;
    END;

	DECLARE @CurrentTime TIME = CAST(GETDATE() AS TIME)
	DECLARE @CurrentDate Date = CAST(GETDATE() AS Date)

	DECLARE @ExamStartTime TIME, @ExamEndTime TIME,@ExamDate DATE;
   SELECT @ExamStartTime = [exam_StartTime], @ExamEndTime = [exam_EndTime],@ExamDate = [Exam_Date] FROM Exam WHERE exam_ID = @exam_id ;
   
		   if  @CurrentTime < @ExamStartTime OR @CurrentTime > @ExamEndTime OR  @CurrentDate != @ExamDate
		BEGIN
		 RAISERROR('Not allowed to answer at this time.', 16, 1);
		 return;
		END;

    DECLARE @Answers AS AnswerTableType;
    INSERT INTO @Answers SELECT * FROM @student_answers;
		DECLARE @QuestionID CHAR(3);
   DECLARE cur CURSOR FOR SELECT QuestionID FROM @student_answers;
   OPEN cur;
   FETCH cur INTO @QuestionID;
   WHILE @@FETCH_STATUS = 0
   BEGIN
       IF NOT EXISTS (
           SELECT 1
           FROM StudentExam
           WHERE QuestionID = @QuestionID
       )
       BEGIN
           RAISERROR('Invalid Question ID.', 16, 1);
           RETURN;
       END;
       FETCH NEXT FROM cur INTO @QuestionID;
   END;
   CLOSE cur;
   DEALLOCATE cur;

    UPDATE [dbo].[StudentExam]
    SET StudentAnswer = S.StudentAnswer
    FROM @Answers AS S
    WHERE [dbo].[StudentExam].QuestionID = S.QuestionID
      AND [dbo].[StudentExam].ExamID = @exam_id
      AND [dbo].[StudentExam].StudentID = @std_id;
	  
END;
--execute 
SET NOCOUNT ON;
DECLARE @StudentAnswers AS AnswerTableType;
INSERT INTO @StudentAnswers (QuestionID, StudentAnswer)
VALUES ('M6', 'Entity-relationship diagram'),('M4', 'Double rectangle');
EXEC StoreStudentAnswers  6, 9, @StudentAnswers;
--------------------------------------------------------------------
CREATE OR ALTER PROCEDURE CreateUserLogin
    @Name VARCHAR(255),
    @Password VARCHAR(255),
    @UserType VARCHAR(255)
AS
BEGIN
SET NOCOUNT ON;
    IF @UserType IN ('Student', 'Training Manager', 'Admin','Instructor')
    BEGIN
        DECLARE @SQLLogin NVARCHAR(MAX);
        DECLARE @SQLUser NVARCHAR(MAX);

        IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = @Name)
        BEGIN
            SET @SQLLogin = 'USE Examination_System; CREATE LOGIN ' + QUOTENAME(@Name) + ' WITH PASSWORD = ''' + @Password + ''', CHECK_POLICY = OFF;';
            EXEC sp_executesql @SQLLogin;

            IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = @Name)
            BEGIN
                SET @SQLUser = 'USE Examination_System; CREATE USER ' + QUOTENAME(@Name) + ' FOR LOGIN ' + QUOTENAME(@Name) + ';';
                EXEC sp_executesql @SQLUser;

                INSERT INTO User_Account (UserName, UserPassword, UserType)
                VALUES (@Name, @Password, @UserType);
            END
            ELSE
            BEGIN
                RAISERROR('User with the same name already exists.', 16, 1);
            END
        END
        ELSE
        BEGIN
            RAISERROR('Login with the same name already exists.', 16, 1);
        END
    END
    ELSE
    BEGIN
        RAISERROR('Invalid UserType. Allowed values are Student, Teacher, and Admin.', 16, 1);
    END
END;

-- Example usage
EXEC CreateUserLogin 'karen', 't123', 'Student';
