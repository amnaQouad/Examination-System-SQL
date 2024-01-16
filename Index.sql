
-- ======================== Index =======================
----------------index by student name---------------
create nonclustered index stud_index_byname
on Student(std_Name)

----------------index by instructor name---------------
create nonclustered index  instructor_index_byname
on Instructor(name)

----------------index by course name---------------
create nonclustered index  course_index_byname
on Courses(name)

----------------index by exam type--------------
create nonclustered index exam_index_bytype
on Exam(Type_Exam)

----------------index by question type---------------
create nonclustered index question_index_bytype
on Question(type)

----------------index by student result---------------
create nonclustered index examStudent_index_byresult
on StudentExam(Result)