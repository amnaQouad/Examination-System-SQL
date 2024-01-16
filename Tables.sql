

-- ======================== Tables =======================





Create TABLE User_Account (
    UserID int Primary key identity (1,1),
	UserName varchar(50),
	UserPassword varchar(20),
    UserType varchar(20),
	 CONSTRAINT chk_typeuser CHECK (UserType IN ('Admin', 'Student', 'Instructor', 'Training_Manager'))
);







-- Create ExamQuestion Table
Create Table ExamQuestion (
    ExamID int,
    QuestionID varchar(5),
    Degree int,
    PRIMARY KEY (QuestionID),
    FOREIGN KEY (ExamID) References Exam (exam_ID),
    FOREIGN KEY (QuestionID) References Question (ID)
);






Create Table StudentExam (
    ExamID int,
	QuestionID VARCHAR(5),
    StudentID int,
    StudentAnswer varchar(255),
    Result int,
    Foreign Key (ExamID) References Exam (exam_ID),
    Foreign Key (StudentID) References Student (Std_ID),
	FOREIGN KEY (QuestionID) REFERENCES dbo.ExamQuestion (QuestionID)
);






-- Create StudentCourse Table
Create Table StudentCourse (
    StudentID int,
    CourseID int,
    TotalDegree int,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) References Student (Std_ID),
    FOREIGN KEY (CourseID) References dbo.Courses (id)
);







-- Table: Class
Create TABLE Class (
   ClassID INT PRIMARY KEY,
   TrackID INT,
   BranchID INT,
   IntakeID INT,
   FOREIGN KEY (TrackID) REFERENCES Tracks(ID),
   FOREIGN KEY (BranchID) REFERENCES Branch(ID),
   FOREIGN KEY (IntakeID) REFERENCES Intake(ID)
);




	CREATE TABLE Instructor
	(
	ID int Primary Key,
	name varchar(100) ,
	)




   Create Table Intake
(
	ID int Primary Key identity(1,1),
	Name varchar(20),
	Intake_Year int
)






Create Table Branch
(
	ID int Primary Key identity(1,1),
	Name varchar(20)
)







 Create Table Track
(
	ID int Primary Key identity(1,1),
	Name varchar(20)
)






CREATE  TABLE Question (
    ID VARCHAR(5) PRIMARY KEY,
    text VARCHAR(1000), 
    type VARCHAR(10), 
    option_1 VARCHAR(100),
    option_2 VARCHAR(100),
    option_3 VARCHAR(100),
    option_4 VARCHAR(100),
    correct_answer VARCHAR(100),
    CONSTRAINT chk_type CHECK (type IN ('MCQ', 'T&F', 'Text')) 
);






CREATE TABLE Courses 
(
	id int IDENTITY(1,1) PRIMARY KEY,
	[name] VARCHAR(50) NOT NULL ,
	[description] VARCHAR(max),
	max_degree int NOT NULL,
	min_degree int NOT NULL,
)




CREATE TABLE Instructor_Courses 
(
	Instructor_id int FOREIGN KEY REFERENCES Instructor(ID),
	Course_id int FOREIGN KEY REFERENCES Courses(id),
)





create TABLE Student 
(
   Std_ID INT PRIMARY KEY,
   std_Name VARCHAR(50),
   std_Age INT,
   std_City VARCHAR(50),
   std_Email VARCHAR(100),
   std_UserID varchar(5) foreign key references User_Account(User_ID) not null,
   class_Id  int foreign key references [dbo].[Class] (id) not null
);







Create Table Exam (
   exam_ID INT PRIMARY KEY IDENTITY(1,1),
   Type_Exam varchar(15),
   Exam_Date Date,
   exam_StartTime time,
   exam_EndTime AS DateAdd(Minute, exam_TotalDuration, exam_StartTime),
   exam_TotalDuration INT,
   TotalDegree INT,
   Crs_Id  int foreign key references [dbo].[Courses] (id) not null,
   class_Id  int foreign key references [dbo].[Class] (id) not null,
   Ins_Id  int foreign key references [dbo].[Instructor] (ID) not null,
    Constraint chk_typeExam check (Type_Exam in ('Corrective', 'Exam')) 
);

   -- =================================================