
-- ======================== Trigger =======================
Create Or Alter Trigger Trg_Exam
On Exam
After Insert
as
Begin
    Print 'Exam Created Successfully';
End;

-----------------------------------------------
Create Or Alter Trigger Trg_UpdateStudentAnswer
ON [dbo].[StudentExam]
after Update
as
Begin
    if Update([StudentAnswer])
    begin
        Print 'Answer Added Successfully';
    end
end;
------------------------------------------------
Create Or Alter Trigger Trg_AddStudetToExamFromInstructor
ON [dbo].[StudentExam]
after Insert
as
Begin
        Print 'Students Added SuccessFully';
end;
--------------------------------------------------
Create Or Alter Trigger Trg_MarkExam
ON [dbo].[StudentExam]
after Update
as
begin
if Update(Result)
    begin
        Print 'Exam Marked SuccessFully';
	end
end;
---------------------------------------------
	---Trigger insert data in ExamQuestion table
 create or alter trigger trg_ExamQuestion_inserted
  on ExamQuestion
  after Insert
  As 
  begin
  print 'Inserting Peocess Is Successful';
  end;
-----------------------------------------------------------------
Create or alter Trigger trg_UpdateFinalResult
on [StudentCourse]
After Insert, Update
as
Begin
    Set NoCount on;

    Update sc
    Set FinalResult = 
        Case 
            when sc.TotalDegree < ( (select top 1 e.min_degree from Courses e where e.id = inserted.CourseID)) then 'Corrective'
            else 'Pass'
        end
    from [StudentCourse] sc
    INNER JOIN inserted on sc.StudentID = inserted.StudentID;
end;


--==============================================================



--Taking About This in Meeting

--Create or alter Trigger trg_UpdateFinalResult
--on [StudentCourse]
--After Insert, Update
--as
--Begin
--    Set NoCount on;

--    Update sc
--    Set FinalResult = 
--        Case 
--            when sc.TotalDegree < (0.5 * (select top 1 e.TotalDegree from Exam e where e.Crs_Id = inserted.CourseID order by TotalDegree)) then 'Corrective'
--            else 'Pass'
--        end
--    from [StudentCourse] sc
--    INNER JOIN inserted on sc.StudentID = inserted.StudentID;
--end;