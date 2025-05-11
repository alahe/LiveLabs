-- Work with JSON Relational Duality Views in Oracle Database 23ai
-- https://livelabs.oracle.com/pls/apex/f?p=133:202:10816107933488::::P202_WORKSHOP_ID,P202_VOUCHER_ID:3797,

-- creating a table called: student.
CREATE TABLE IF NOT EXISTS student (
   STUDENT_ID           number       not null,
   STUDENT_NAME         varchar2(40) not null,
   STUDENT_INFO         json,
   PRIMARY KEY          (STUDENT_ID) 
  );

-- insert data into the student table
INSERT INTO student (STUDENT_ID, STUDENT_NAME, STUDENT_INFO) VALUES (1, 'John Doe', '{ "age": 20, "major": "Computer Science", "GPA": 3.5 }');
INSERT INTO student (student_id, student_name, student_info) VALUES
       (3245, 'Jill', '{ "lastName" : "Jones", "Major" : "Radiology" }'),
       (8524, 'John', '{ "lastName" : "Johnson", "Major" : "Journalism" }'),
       (1735, 'Jane', '{ "lastName" : "Jameson", "Major" : "Accounting" }'),
       (1555, 'Jayanth', '{ "lastName" : "Juraya", "Major" : "Chemistry" }'),
       (1035, 'Janet', '{ "lastName" : "Jurgen", "Major" : "Chemistry" }'),
       (2560, 'Jerri', '{ "lastName" : "Jefferson", "Major" : "Law" }'),
       (2267, 'Jake', '{ "lastName" : "Jenson", "Major" : "Journalism" }'),
       (3311, 'Jeremy', '{ "lastName" : "Jettson", "Major" : "Law" }'),
       (1015, 'Jorge', '{ "lastName" : "Jaraba", "Major" : "Biology" }'),
       (3409, 'Jim', '{ "lastName" : "Jackson", "Major" : "Economics" }'),
       (5454, 'Joanne', '{ "lastName" : "Jinosa", "Major" : "Linguisitics" }'),
       (4533, 'Jesse', '{ "lastName" : "James", "Major" : "Accounting" }') ;

SELECT * FROM student ;

CREATE TABLE IF NOT EXISTS teacher (
   TEACHER_ID           number       not null,
   TEACHER_NAME         varchar2(40) not null,
   TEACHER_INFO         json,
   PRIMARY KEY          (TEACHER_ID) 
  );
-- insert data into the teacher table
INSERT INTO teacher (TEACHER_ID, TEACHER_NAME, TEACHER_INFO) VALUES (1, 'Dr. Smith', '{ "age": 45, "department": "Computer Science", "years_of_experience": 20 }');


INSERT INTO teacher (teacher_id, teacher_name, teacher_info) VALUES
       (3245, 'Dr. Jones', '{ "lastName" : "Jones", "Department" : "Radiology" }'),
       (8524, 'Dr. Johnson', '{ "lastName" : "Johnson", "Department" : "Journalism" }'),
       (1735, 'Dr. Jameson', '{ "lastName" : "Jameson", "Department" : "Accounting" }'),
       (1555, 'Dr. Juraya', '{ "lastName" : "Juraya", "Department" : "Chemistry" }'),
       (1035, 'Dr. Jurgen', '{ "lastName" : "Jurgen", "Department" : "Chemistry" }'),
       (2560, 'Dr. Jefferson', '{ "lastName" : "Jefferson", "Department" : "Law" }'),
       (2267, 'Dr. Jenson', '{ "lastName" : "Jenson", "Department" : "Journalism" }'),
       (3311, 'Dr. Jettson', '{ "lastName" : "Jettson", "Department" : "Law" }'),
       (1015, 'Dr. Jaraba', '{ "lastName" : "Jaraba", "Department" : "Biology" }'),
       (3409, 'Dr. Jackson', '{ "lastName" : "Jackson", "Department" : "Economics" }'),
       (5454, 'Dr. Jinosa', '{ "lastName" : "Jinosa", "Department" : "Linguisitics" }'),
       (4533, 'Dr. James', '{ "lastName" : "James",  "Department": "Accounting" }') ;

INSERT INTO teacher (teacher_id, teacher_name, teacher_info) VALUES
       (123, 'Anika', '{ "lastName" : "Ansell", "Suffix" : "PhD", "email" : "a.ansell@college.edu" }'),
       (543, 'Adam',  '{ "lastName" : "Apple", "Suffix" : "EdD", "email" : "a.apple@college.edu" }') ,
       (486, 'Anusha', '{ "lastName" : "Ahmed", "Suffix" : "PhD", "email" : "a.ahmed@college.edu" }'),
       (789, 'Anita', '{ "lastName" : "Allen", "Suffix" : "PhD", "email" : "a.allen@college.edu" }'),
       (612, 'Alex',  '{ "lastName" : "Andrade", "Suffix" : "Esq.", "email" : "a.andrade@college.edu" }'),
       (404, 'Anakin', '{ "lastName" : "Alderon", "Suffix" : "Jed", "email" : "a.alderon@college.edu" }'),
       (645, 'Anna',  '{ "lastName" : "Anderson", "Suffix" : "PhD", "email" : "a.anderson@college.edu" }'),
       (809, 'Andrea', '{ "lastName" : "Antonelli", "Suffix" : "EdD", "email" : "a.antonelli@college.edu" }') ;
 commit;

-- selet data from the teacher table
select * from teacher;

CREATE TABLE IF NOT EXISTS course (
   COURSE_ID               varchar2(5)  not null,
   COURSE_NAME             varchar2(10) not null,
   ROOM                    varchar2(5),
   TIME                    varchar2(5),
   TEACHER_ID              number  not null,
   VIRTUAL                 boolean,
   COURSE_INFO             json,
   FOREIGN KEY(teacher_id) REFERENCES teacher(teacher_Id),
   PRIMARY KEY             (COURSE_ID) 
  );
/
-- insert data into the course table
INSERT INTO course (course_id, course_name, room, time, teacher_id, virtual, course_info) VALUES
   ('C123', 'MATH_01', 'A102', '14:00', 543, 'FALSE', 
              '{ "courseNameFull" : "Mathematics 101", "preRequisites" : "none" }'),
   ('C124', 'MATH_02', 'A102', '16:00', 543, 'FALSE', 
              '{ "courseNameFull" : "Mathematics 102", "preRequisites" : "MATH_01" }'),
   ('C152', 'CALC_01', 'A104', '10:00', 645, 'FALSE',
              '{ "courseNameFull" : "Calculus 201", "preRequisites" : "none" }'),
   ('C203', 'ENGL_01', 'A202', '15:00', 543, 'FALSE', 
              '{ "courseNameFull" : "English Literature 1", "preRequisites" : "none" }'),
   ('C300', 'PHYS_01', 'B405', '10:00', 789, 'FALSE', 
              '{ "courseNameFull" : "Physics 101", "preRequisites" : "CALC_01" }'),
   ('C345', 'SCIE_02', 'B405', '16:00', 789, 'FALSE', 
              '{ "courseNameFull" : "Science 102", "preRequisites" : "SCIE_01" }'),
   ('C450', 'SCIE_03', 'B405', '14:00', 486, 'FALSE', 
              '{ "courseNameFull" : "Science 103", "preRequisites" : "SCIE_02" }'),
   ('C567', 'HIST_01', 'A102', '14:00', 612, 'FALSE', 
              '{ "courseNameFull" : "History 101", "preRequisites" : "none" }'),
   ('C568', 'HIST_02', 'A102', '16:00', 612, 'FALSE', 
              '{ "courseNameFull" : "History 102", "preRequisites" : "HIST_01" }'),
   ('C789', 'LANG_01', 'A256', '12:00', 543, 'FALSE', 
              '{ "courseNameFull" : "Language 101", "preRequisites" : "none" }'), 
   ('C813', 'PSYC_01', 'B301', '11:00', 809, 'FALSE',
              '{ "courseNameFull" : "Psychology 101", "preRequisites" : "none" }') ;
COMMIT;
-- select data from the course table
SELECT * FROM course;

CREATE TABLE IF NOT EXISTS student_courses (
   SCID                     integer generated always as identity, 
   STUDENT_ID               number        not null,
   COURSE_ID                varchar2(5)   not null,
   FOREIGN KEY(student_id)  REFERENCES student(student_id),
   FOREIGN KEY(course_id)   REFERENCES course(course_id), 
   PRIMARY KEY              (scId) 
);

INSERT INTO student_courses (student_id, course_id) VALUES
   ('3245', 'C123'),
   ('8524', 'C567'),
   ('3245', 'C345'),
   ('3409', 'C123'),
   ('2560', 'C789'),
   ('1555', 'C450'),
   ('1555', 'C123'),
   ('1035', 'C152'), 
   ('2560', 'C203'),
   ('2560', 'C567'),
   ('5454', 'C203'),
   ('1555', 'C152'),
   ('4533', 'C123'),
   ('5454', 'C300'),
   ('1035', 'C450'), 
   ('1015', 'C345'),
   ('1035', 'C124') ;
COMMIT;
-- select data from the student_courses table
SELECT * FROM student_courses;
--

SELECT json_serialize(dbms_json_schema.describe('TEACHER') PRETTY) "Teacher";

SELECT json_serialize(dbms_json_schema.describe('COURSE') PRETTY) "Course";

SELECT json_serialize(course_info pretty) FROM course;


SELECT json_serialize(course_info PRETTY) "courseInfo"
FROM   course c
WHERE  c.course_name = 'MATH_01' ;

SELECT JSON {*} FROM student ;

SELECT JSON {*}
FROM   student 
WHERE  json_value(student_info, '$.Major') IN ('Biology', 'Chemistry');

-- JSON_DATAGUIDE provides the ability to render the contents of a JSON document to appear as a database relational view that can then be queried using the SQL language.
-- Generate a hierarchical schema for the JSON data in the 'student_info' column
-- kuidas on võimalik JSON-dokumendi sisu SQL-paketi JSON_DATAGUIDE abil relatsioonivaateks üle kanda
 SELECT JSON_DATAGUIDE(student_info, DBMS_JSON.FORMAT_HIERARCHICAL) from student;

-- This block generates a JSON Data Guide for the 'student_info' column and creates a relational view based on it.
DECLARE     
   dGuide CLOB ; 
BEGIN
   -- Ensure the STUDENT table and student_info column exist
   SELECT JSON_DATAGUIDE(student_info, DBMS_JSON.FORMAT_HIERARCHICAL)     
   INTO   dGuide 
   FROM   student;

   -- Create the view using the data guide
   dbms_json.create_view('DG_AutoView', 'STUDENT', 'student_info', dGuide); 
END;


-- 
SELECT * FROM DG_AutoView ORDER BY 1 ;

-- use SQLclient to query the view
desc DG_AutoView;/

-- view definition
SELECT * FROM user_views WHERE view_name = 'DG_AUTOVIEW';
-- view select statement
SELECT RT."STUDENT_ID",RT."STUDENT_NAME",JT."GPA",JT."age",JT."Major",JT."major",JT."lastName"
FROM "JSON_DEMO_TEST"."STUDENT" RT,
JSON_TABLE("STUDENT_INFO", '$[*]' COLUMNS 
"GPA" number path '$.GPA',
"age" number path '$.age',
"Major" varchar2(16) path '$.Major',
"major" varchar2(16) path '$.major',
"lastName" varchar2(16) path '$.lastName')JT


SELECT student_id, "lastName", "Major"  FROM  DG_AutoView ORDER BY 1 ;

UPDATE DG_AutoView SET  "Major" = 'Law' WHERE  student_id = 1015 ;
-- result ORA-01733: virtual column not allowed here https://docs.oracle.com/error-help/db/ora-01733/


--------------------------------------
-- Lab 3 Build JSON Relational Duality View
--------------------------------------
-- This lab demonstrates the extreme flexibility of JSON Duality Views in Oracle Database 23ai.
-- You will learn how to work with SQL data and JSON documents simultaneously, leveraging the true duality of the views.
-- With JSON Duality Views, you have the flexibility and data access benefits of the JSON document model combined with the storage efficiency and power of the relational model.
--------------------------------------------
-- Lab 3 - Task 2 Create a JSON Duality View

-- create a JSON Relational Duality View
CREATE OR REPLACE JSON RELATIONAL DUALITY VIEW student_schedule AS
SELECT JSON {'_id'     : sc.scid,
             'student' :
                    (SELECT JSON {'studentId' : s.student_id,
                                'studentName' : s.student_name,
                                'studentInfo' : s.student_info }
                    FROM   student s WITH NOINSERT UPDATE NODELETE
                    WHERE  sc.student_id = s.student_id
                    ),
               'schedule' : 
                    (SELECT JSON {'courseId' : c.course_id,
                                'courseName' : c.course_name,
                                'courseRoom' : c.room,
                                'courseTime' : c.time,
                                'teacher'    : 
                                                (SELECT JSON { 'teacherName' : t.teacher_name,
                                                               'teacherId'   : t.teacher_id }
                                                FROM   teacher t WITH NOINSERT UPDATE NODELETE 
                                                WHERE  c.teacher_id = t.teacher_id)
                                }
                    FROM   course c WITH NOINSERT UPDATE NODELETE
                    WHERE  sc.course_id = c.course_id
                    )
                }
FROM  student_courses sc WITH INSERT UPDATE DELETE ;

-- use SQLcl
DESC student_schedule


SELECT dbms_json_schema.describe('STUDENT_SCHEDULE') ;

-- SELECT json_serialize(dbms_json_schema.describe('STUDENT_SCHEDULE') PRETTY) "JSON Document" ;
--         studentInfo : student_info
-- ei tööta       
-- Error starting at line : 1 in command -
-- SELECT json_serialize(dbms_json_schema.describe('STUDENT_SCHEDULE') PRETTY) "JSON Document"
-- Error report -
-- ORA-40478: output value too large (maximum: 4000)
-- JZN-00018: Input to serializer is too large
 

SELECT * FROM student_schedule ;

SELECT json_serialize(data pretty) 
FROM   student_schedule ;

SELECT json_serialize(data pretty) 
FROM   student_schedule
WHERE  json_value(data, '$.student.studentName') IN ('Janet') ;


SELECT json_serialize(data pretty) 
FROM   student_schedule
WHERE  json_value(data, '$.schedule.teacherName') IN ('Adam') ;
-- NOTE: This query does not return any rows and it incorrectly displays: "No rows selected"
-- The reason there are no rows returned is that the query is incorrect. The "Teacher" information is stored in an underlying table called TEACHER. 
-- In order to see the STUDENT_SCHEDULE for a specific Teacher we need to use the following query-

SELECT json_serialize(data pretty) 
FROM   student_schedule
WHERE  json_value(data, '$.schedule.teacher.teacherName') IN ('Adam') ;

-----------------------------------------
-- Lab 3 - Task 2 Create a JSON Duality View with UNNEST

-- Kuigi see lähenemisviis lahendab meie probleemi ja võib olla kasulik pesastatud dokumendi või massiivi salvestamisel, on see ebamugav ja tüütu, kui otsime ainult teavet kursuse kohta. 
-- Selle probleemi lahendamiseks saame kasutada parameetrit UNNEST , mis liigutab tabeli elemendid TEACHER vastavusse ülejäänud kursuse teabega. 
-- UNNEST - võiks seda tõlkida kui “pesast välja võtma” või “välja pesitsema”

CREATE OR REPLACE JSON RELATIONAL DUALITY VIEW student_schedule_unnest AS
SELECT JSON {'_id'     : sc.scId,
             'student' :
                 (SELECT JSON {'studentId'   : s.student_id,
                               'studentName' : s.student_name,
                               'studentInfo' : s.student_info }
                  FROM   student s WITH NOINSERT UPDATE NODELETE
                  WHERE  sc.student_id = s.student_id
                 ),
             'schedule' : 
                 (SELECT JSON {'courseId'   : c.course_id,
                               'courseName' : c.course_name,
                               'courseRoom' : c.room,
                               'courseTime' : c.time,
                                UNNEST
                                    (SELECT JSON { 'teacherName' : t.teacher_name,
                                                   'teacherId'   : t.teacher_id }
                                     FROM   teacher t WITH NOINSERT NOUPDATE NODELETE 
                                     WHERE  c.teacher_id = t.teacher_id)
                 }
                  FROM   course c WITH NOINSERT UPDATE NODELETE
                  WHERE  sc.course_id = c.course_id
                 )
             }
FROM  student_courses sc WITH INSERT UPDATE DELETE ;

SELECT json_serialize(dbms_json_schema.describe('STUDENT_SCHEDULE_UNNEST') PRETTY) "JSON Document" ;

SELECT json_serialize(data pretty) 
FROM   student_schedule_unnest
WHERE  json_value(data, '$.student.studentName') IN ('Jerri') ;

SELECT json_serialize(data pretty) 
FROM   STUDENT_SCHEDULE_UNNEST
WHERE  json_value(data, '$.schedule.teacherName') IN ('Adam') ;

-- Lab3 - Task3  Perform insert and update operations on Duality Views via the SQL base tables

SELECT json_serialize(data pretty) 
FROM   student_schedule_unnest
WHERE  json_value(data, '$.schedule.courseId') IN ('C124') ;

-- Update the teacherid from 543 (Adam) to 645 (Anna) for course C124-
UPDATE course SET teacher_id=645 WHERE course_id = 'C124' ;

-- Let's revisit the entry for MATH_02 by looking again at the Schedule for Course C124-
SELECT json_serialize(data pretty) 
FROM   student_schedule
WHERE  json_value(data, '$.schedule.courseId') IN ('C124') ;

SELECT json_serialize(data pretty) 
FROM   student_schedule_unnest
WHERE  json_value(data, '$.schedule.courseId') IN ('C124') ;


-- Lab3 - Task 4: Perform insert and update operations on Duality Views directly.
SELECT json_serialize(data pretty) 
FROM   student_schedule_unnest
WHERE  json_value(data, '$.student.studentId') IN ('1735');

SELECT json_serialize(data pretty) 
FROM   student_schedule_unnest
WHERE  json_value(data, '$.student.studentName') IN ('Jane');

-- NOTE: You should see no rows returned from this query. 
-- We're running this query to confirm that Jane is not enrolled in any existing courses, so there's no entries in the student_schedule.

SELECT * FROM student WHERE student_name = 'Jane' ;

SELECT * FROM student_courses WHERE student_id = 1735 ;

-- NOTE: For this code, we see a row returned for the student table as Jane is a existing student. 
-- However we see no rows returned for the student_schedule as Jane is not yet enrolled in any courses.
-- Once you've established that there are no entries for the new Student, we can insert the student into the JSON Document-
INSERT INTO student_schedule_unnest VALUES('{ "student" : {"studentId" : "1735",
                                                    "studentName" : "Jane",
                                                    "studentInfo" : {"lastName": "Jameson", "Major": "Accounting"}
                                                   },
                                       "schedule": {"courseId" : "C123",
                                                    "courseName" : "MATH_01",
                                                    "courseRoom" : "A102",
                                                    "courseTime" : "14:00",
                                                    "teacherName" : "Adam",
                                                    "teacherId" : 543 }
                                                   }');
--We should now see the newly enrolled Student in our JSON Duality View as well as all of the related underlying tables.
-- We will start by checking the student_schedule JSON Duality View-    

SELECT json_serialize(data pretty) 
FROM   student_schedule_unnest
WHERE  json_value(data, '$.student.studentId') IN ('1735');

SELECT json_serialize(data pretty) 
FROM   student_schedule_unnest
WHERE  json_value(data, '$.student.studentName') IN ('Jane');

-- NOTE: You will need to scroll up in the results pane to see the output for both statements. Each statement now returns a single row.
-- Also take a look at the underlying tables:
SELECT * FROM student WHERE student_name = 'Jane' ;

SELECT * FROM student_courses WHERE student_id = 1735 ;

--------------------------------------------------
-- Lab 4 Tools for working with JSON Duality Views
--------------------------------------------------
--Task 1: Explore the metadata associated with JSON Duality Views.
SELECT * FROM all_json_duality_views

-- The ALL_JSON_DUALITY_VIEWS view displays:

-- the Owner and Name of the Duality View
-- the Owner and Name of the underlying Root table
-- information about the operations permitted on the Daulity View
-- whether the Duality View is Read Only
-- JSON Schema information for the Duality View
-- the status or validity of the Duality View
-- More information on ALL_JSON_DUALITY_VIEWS is available here.
-- https://docs.oracle.com/en/database/oracle/oracle-database/23/refrn/ALL_JSON_DUALITY_VIEWS.html
----------------------------


-- For our next query, we will drill one step deeper and see a listing of all Duality Views and the underlying tables that the Duality View maps to. 

SELECT * FROM all_json_duality_view_tabs ;

-- The ALL_JSON_DUALITY_VIEW_TABS view displays:
-- the Owner and Name of the Duality View
-- the Owner and Name of each of the underlying Base tables
-- the SQL expression from the where clause applied to the Base tables to create the Duality View
-- information about the operations permitted on the Duality View
-- whether the Duality View is Read Only
-- the parent of table, if the table is child table
-- the relationship of the table to the parent table - in this case singleton means the child table is the target of an inner join
-- https://docs.oracle.com/en/database/oracle/oracle-database/23/refrn/ALL_JSON_DUALITY_VIEW_TABS.html



-- We can also see a listing of all Duality Views and the underlying tables and columns that the Duality View maps to. 

SELECT * FROM all_json_duality_view_tab_cols ;

-- The ALL_JSON_DUALITY_VIEW_TAB_COLS view displays:
-- the Owner and Name of the Duality View
-- the Owner and Name of each of the underlying Base tables
-- the Owner and Name of each of the underlying Base table columns
-- the SQL expression from the where clause applied to the Base tables to create the Duality View
-- information about the operations permitted on the Duality View
-- whether the Duality View is Read Only
-- the parent of table, if the table is child table
-- the relationship of the table to the parent table - in this case singleton means the child table is the target of an inner join
-- https://docs.oracle.com/en/database/oracle/oracle-database/23/refrn/ALL_JSON_DUALITY_VIEW_TAB_COLS.html

-- The final dictionary view we'll look at in this lab provides information about the links associated with the base tables for the specified Duality Views

SELECT * FROM all_json_duality_view_links ;

-- The ALL_JSON_DUALITY_VIEW_TAB_LINKS view displays:

-- the Owner and Name of the Duality View
-- the Owner and Name of each of the underlying "parent" base tables
-- the Owner and Name of each of the underlying "child" base tables
-- the column mappings between the parent and child tables
-- the type of join in use for the parent-child relationship
-- the name of the JSON key associated with the link
-- JSON key name being mapped to the column
-- information about the operations permitted on the Duality View
-- whether the column is read-only, generated or hidden
-- whether the column is part of a primary-key
-- position of the column in an ETAG, if it is part of an ETAG
-- More information on ALL_JSON_DUALITY_VIEW_TAB_LINKS is available here.


-- Lab 4 - Task 2: Create a JSON Duality View using the JSON-To-Duality Migrator.
----------------------------
-- The JSON-to-Duality Migrator is a tool that allows you to create a JSON Duality View from an existing JSON document.

 

DECLARE
  schema_sql clob;
BEGIN
  schema_sql :=
   dbms_json_duality.infer_and_generate_schema(
   json('{"tableNames"    : [ "STUDENT", "TEACHER", "COURSE],
          "useFlexFields" : true,
          "updatability"  : false,
          "sourceSchema"  : "JSON_DEMO_TEST",
          "resolveConflicts" : true}')); -- Added resolveConflicts to handle duplicate column names

  dbms_output.put_line('DDL Script: ');
  dbms_output.put_line(schema_sql);

  -- execute immediate schema_sql;

  -- dbms_json_duality.import(table_name => 'COURSE',  view_name => 'COURSE_DUALITY_AG');
  -- dbms_json_duality.import(table_name => 'STUDENT', view_name => 'STUDENT_DUALITY_AG');
  -- dbms_json_duality.import(table_name => 'TEACHER', view_name => 'TEACHER_DUALITY_AG');
END;
/

-- ei tööta





BEGIN
    ORDS.ENABLE_OBJECT(
        P_ENABLED  => TRUE,
        P_SCHEMA  => 'CLASSMATE',
        P_OBJECT  => 'STUDENT_DUALITY',
        P_OBJECT_TYPE  => 'VIEW',
        P_OBJECT_ALIAS  => 'student_duality_unnest',
        P_AUTO_REST_AUTH  => FALSE
    );
    COMMIT;
END;

BEGIN
    ORDS.ENABLE_OBJECT(
        P_ENABLED  => TRUE,
        P_SCHEMA  => 'CLASSMATE',
        P_OBJECT  => 'STUDENT_DUALITY',
        P_OBJECT_TYPE  => 'VIEW',
        P_OBJECT_ALIAS  => 'student_duality',
        P_AUTO_REST_AUTH  => FALSE
    );
    COMMIT;
END;