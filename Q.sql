use online_learning_and_progress_tracking_system;

select * from lessons;
select * from progress;
select * from students;

-- Write query retrieves all lessons for first course 
SELECT lesson_id, lesson_name
FROM Lessons
WHERE course_id = 1;

-- Write query get record of certificates issued after October 15-2024.
SELECT certificate_id, student_id, course_id, issued_date
FROM Certificates
WHERE issued_date > '2024-10-15';

-- Write the query to search for lessons containing "Intro"
SELECT lesson_id, lesson_name
FROM Lessons
WHERE lesson_name LIKE '%Intro%';

-- WAQ categorizes students based on the number of completed lessons recorded in the Progress table.
SELECT student_id,
       CASE
           WHEN COUNT(*) >= 4 THEN 'Advanced'
           WHEN COUNT(*) BETWEEN 2 AND 3 THEN 'Intermediate'
           WHEN COUNT(*) BETWEEN 0 AND 1 THEN 'Beginner'
           ELSE 'No Progress'
       END AS progress_level
FROM Progress
WHERE status = 'Completed'
GROUP BY student_id;

-- Write a Query to Find Students with Certificates
SELECT student_id, name
FROM Students
WHERE student_id IN (SELECT DISTINCT student_id FROM Certificates);

-- WAQ to find number Lessons Completed by Each Student
SELECT student_id, COUNT(*) AS completed_lessons
FROM Progress
WHERE status = 'Completed'
GROUP BY student_id;

-- WQA to lists students who have completed more than 2 lessons
SELECT student_id, COUNT(*) AS completed_lessons
FROM Progress
WHERE status = 'Completed'
GROUP BY student_id
HAVING COUNT(*) > 2;

-- WAQ to retrieves the first 3 courses sorted by their course_id in ascending order.
SELECT course_id, course_name
FROM Courses
ORDER BY course_id
LIMIT 3;

-- WAQ to show Certificates issued for each Student
SELECT s.student_id, s.name, c.course_id, co.course_name, c.issued_date
FROM Certificates c
JOIN Students s ON c.student_id = s.student_id
JOIN Courses co ON c.course_id = co.course_id
ORDER BY c.issued_date;

-- WAQ to ranks students based on the total number of completed lessons across all courses.
SELECT s.student_id, s.name, COUNT(p.lesson_id) AS completed_lessons
FROM Students s
JOIN Progress p ON s.student_id = p.student_id
WHERE p.status = 'Completed'
GROUP BY s.student_id
ORDER BY completed_lessons DESC;

--  WAQ to shows each course along with the total number of lessons
SELECT c.course_id, c.course_name, COUNT(l.lesson_id) AS lesson_count
FROM Courses c
JOIN Lessons l ON c.course_id = l.course_id
GROUP BY c.course_id, c.course_name;

SELECT lesson_id FROM Lessons WHERE course_id = 1;
-- WAQ to get student_id and student_name of students who have completed all lessons for Course ID 1
SELECT s.student_id, s.name
FROM Students s
JOIN Progress p ON s.student_id = p.student_id
WHERE p.lesson_id IN (
    SELECT lesson_id
    FROM Lessons
    WHERE course_id = 1
) AND p.status = 'Completed'
GROUP BY s.student_id, s.name;

-- WAQ retrieves each student_id, student_name, course_id, and the number of completed lessons per course.
SELECT s.student_id, s.name, l.course_id, COUNT(p.lesson_id) AS completed_lessons
FROM Students s
JOIN Progress p ON s.student_id = p.student_id
JOIN Lessons l ON p.lesson_id = l.lesson_id
WHERE p.status = 'Completed'
GROUP BY s.student_id, s.name, l.course_id
ORDER BY s.student_id, l.course_id;
