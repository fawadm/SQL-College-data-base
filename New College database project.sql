create table students
(
	student_no integer,
	student_name varchar(20),
	age integer
);

insert into students values (1, 'Michael', 19);
insert into students values (2, 'Doug', 18);
insert into students values (3, 'Samantha', 21);
insert into students values (4, 'Pete', 20);
insert into students values (5, 'Ralph', 19);
insert into students values (6, 'Arnold', 22);
insert into students values (7, 'Michael', 19);
insert into students values (8, 'Jack', 19);
insert into students values (9, 'Rand', 17);
insert into students values (10, 'Sylvia', 20);

create table courses
(
	course_no varchar(5),
	course_title varchar(20),
	credits integer
);

insert into courses values ('CS110', 'Pre Calculus', 4);
insert into courses values ('CS180', 'Physics', 4);
insert into courses values ('CS107', 'Intro to Psychology', 3);
insert into courses values ('CS210', 'Art History', 3);
insert into courses values ('CS220', 'US History', 3);

create table student_enrollment
(
	student_no integer,
	course_no varchar(5)
);

insert into student_enrollment values (1, 'CS110');
insert into student_enrollment values (1, 'CS180');
insert into student_enrollment values (1, 'CS210');
insert into student_enrollment values (2, 'CS107');
insert into student_enrollment values (2, 'CS220');
insert into student_enrollment values (3, 'CS110');
insert into student_enrollment values (3, 'CS180');
insert into student_enrollment values (4, 'CS220');
insert into student_enrollment values (5, 'CS110');
insert into student_enrollment values (5, 'CS180');
insert into student_enrollment values (5, 'CS210');
insert into student_enrollment values (5, 'CS220');
insert into student_enrollment values (6, 'CS110');
insert into student_enrollment values (7, 'CS110');
insert into student_enrollment values (7, 'CS210');


create table professors
(
	last_name varchar(20),
	department varchar(12),
	salary integer,
	hire_date date
);

insert into professors values ('Chong', 'Science', 88000, '2006-04-18');
insert into professors values ('Brown', 'Math', 97000, '2002-08-22');
insert into professors values ('Jones', 'History', 67000, '2009-11-17');
insert into professors values ('Wilson', 'Astronomy', 110000, '2005-01-15');
insert into professors values ('Miller', 'Agriculture', 82000, '2008-05-08');
insert into professors values ('Williams', 'Law', 105000, '2001-06-05');

create table teach
(
	last_name varchar(20),
	course_no varchar(5)
);

insert into teach values ('Chong', 'CS180');
insert into teach values ('Brown', 'CS110');
insert into teach values ('Brown', 'CS180');
insert into teach values ('Jones', 'CS210');
insert into teach values ('Jones', 'CS220');
insert into teach values ('Wilson', 'CS110');
insert into teach values ('Wilson', 'CS180');
insert into teach values ('Williams', 'CS107');

-- Simple Questions
--Q 1; Write a query to display the names of those students that
-- are between ages of 18 and 20
SELECT student_name FROM
students 
WHERE age BETWEEN 18 AND 20;

-- Q 2; Write a query to display all of those students that contain the 
-- letters "ch"  in their name or their name ends with letters "nd".
SELECT * FROM students
WHERE student_name LIKE '%nd%' OR student_name LIKE '%ch%'

-- Q 3; Write a query to display the name of those students that have the letters
-- "ae" or "ph" in their name and are NOT 19 years old
SELECT *
FROM students
WHERE student_name LIKE '%ae%'
	OR student_name LIKE '%ph%'
	AND age != 19
--4; Write a query that lists the names of students sorted by
-- their age from largest to smallest
SELECT *
FROM students
ORDER BY age DESC

-- Q 5; Write a query that displays the names and ages of the top 4
-- oldest students
SELECT TOP 4 student_name
	,age
FROM students
ORDER BY age DESC
--Q6; Write a query that returns students base on the following criteria
-- The student must not be older than age 20
-- if their student_no is either 3 and 5 or theri student_no is 7.
-- your query should also return students older than age 20 but in that
-- case they must have a student_no that is atleast 4.
SELECT *
FROM students
WHERE age <= 20
	AND (
		student_no BETWEEN 3
			AND 5
		OR student_no = 7
		)
	OR (
		age > 20
		AND student_no >= 4
		);
-- Moderate level Questions;
-- Q 1; Write a query against the professors table that can output the following in the result
" chong works in the science department"
SELECT CONCAT (
		last_name
		,' '
		,'works in the '
		,department
		,' department'
		)
FROM professors;

--Q 2; Write a SQL query against the professors table that would return the following result
"it is false that professor chong is "highly paid"
SELECT 
    'it is ' + 
    CASE 
        WHEN salary > 95000 THEN 'true' 
        ELSE 'false' 
    END + 
    ' that professor ' + last_name + ' is "highly paid"' AS result
FROM professors;





--Q1; Write a query that finds those students who do not take CS180  course
SELECT student_name
FROM students
WHERE student_no NOT IN (
		SELECT student_no
		FROM student_enrollment
		WHERE course_no NOT IN (
				SELECT course_no
				FROM student_enrollment
				WHERE course_no = 'CS180'
				)
		);

--Q2; Write a query to find the students who take CS110 or CS107 
-- but not take both

SELECT s.*
	,se.course_no
FROM students s
INNER JOIN student_enrollment se ON s.student_no = se.student_no
WHERE se.course_no IN (
		'CS110'
		,'CS107'
		)
	AND s.student_no NOT IN (
		SELECT a.student_no
		FROM student_enrollment a
			,student_enrollment b
		WHERE a.student_no = b.student_no
			AND a.course_no = 'CS110'
			AND b.course_no = 'CS107'
		);

 --Write a query to find students who take CS110 or CS107 but not both.
SELECT s.student_no
	,s.student_name
	,s.age
FROM students s
	,student_enrollment se
WHERE s.student_no = se.student_no
GROUP BY s.student_no
	,s.student_name
	,s.age
HAVING SUM(CASE 
			WHEN course_no IN (
					'CS110'
					,'CS107'
					)
				THEN 1
			ELSE 0
			END) = 1

SELECT *
FROM students
WHERE student_no NOT IN (
		SELECT student_no
		FROM student_enrollment
		WHERE course_no != 'CS220'
		);

--Q; Write a query that finds those students 
--who take at most 2 courses.Your query should
--exclude students that don't take any courses
-- as well as those that take more than 2 courses.
SELECT s.student_no
	,s.student_name
	,s.age
FROM students s
	,student_enrollment se
WHERE s.student_no = se.student_no
GROUP BY s.student_no
	,s.student_name
	,s.age
HAVING COUNT(*) <= 2;
--Write a query to find students who are older than at most two other students.
SELECT s1.*
FROM students s1
WHERE 2 >= (
		SELECT COUNT(*)
		FROM students s2
		WHERE s2.age < s1.age
		);
--Q; The name of the student that takes the highest number of courses

SELECT student_name
FROM students
WHERE student_no IN (
		SELECT student_no
		FROM (
			SELECT TOP 1 student_no
				,COUNT(course_no) course_cnt
			FROM student_enrollment
			GROUP BY student_no
			ORDER BY course_cnt DESC 
			) a
		);
--Q;--Q; Using subqueries only,write a SQL statement that returns the names
--of those students that are taking the courses PHYSICS and US HISTORY.

SELECT student_name
FROM students
WHERE student_no IN (
		SELECT student_no
		FROM student_enrollment
		WHERE course_no IN (
				SELECT course_no
				FROM courses
				WHERE course_title IN (
						'Physics'
						,'US History'
						)
				)
		);

--Q; Write a query that shows the student's name the courses the sutdent is taking
-- and the professors that teach that course.
SELECT s.student_name
	,se.course_no
	,p.last_name
FROM students s
INNER JOIN student_enrollment se ON s.student_no = se.student_no
INNER JOIN teach t ON t.course_no = se.course_no
INNER JOIN professors p ON t.last_name = p.last_name
ORDER BY student_name;

SELECT student_name,course_no,MIN(last_name) FROM(
SELECT student_name,se.course_no,p.last_name FROM
students s JOIN student_enrollment se ON
s.student_no=se.student_no JOIN teach t
ON t.course_no=se.course_no JOIN 
professors p ON t.last_name=p.last_name) a
GROUP BY student_name,course_no
ORDER BY student_name,course_no;

--Q; Write a query that returns ALL of the students as well as any courses they may or may not be taking;
SELECT student_name
	,course_no
FROM students s
LEFT JOIN student_enrollment se ON s.student_no = se.student_no;




















 
 
 
 
 
 
 
 
 
 
 
 
 