/*1.	Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv into the employee database from the given resources
*/
create database employees;
use employees;
/*    CREATED ER DIAGRAM FOR THE GIVEN EMPLOYEE DATABASE
*/
/*  3.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.
*/
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM emp_record_table

 /*  4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
●	less than two
●	greater than four 
●	between two and four
*/
----LESS THAN TWO
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
where EMP_RATING < 2;
---- LESS THAN FOUR
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
where EMP_RATING < 4; 
----- between two and four
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
where EMP_RATING BETWEEN 2 AND 4;

----- 5.Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.
SELECT concat(FIRST_NAME, ' ', LAST_NAME) AS NAME
FROM emp_record_table
WHERE DEPT = 'FINANCE';

--- 6.	Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).
select e.emp_id, e.first_name, e.last_name, count(r.emp_id) as num_reporters
from emp_record_table e
join emp_record_table r on e.emp_id = r.MANAGER_ID
GROUP BY e.emp_id, e.first_name, e.last_name;

---- 7.	Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.
select * from emp_record_table where dept = 'healthcare'
union
select * from emp_record_table where dept = 'finance';

---- 8.	Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.
select emp_id, first_name, last_name, role, dept, emp_rating,
MAX(emp_rating)OVER (PARTITION BY DEPT)AS MAX_DEPT_RATING
FROM emp_record_table

---- 9.	Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.
select role, min(salary) as min_salary, max(salary) as max_salary
from emp_record_table
group by role;

----- 10.	Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.
select emp_id, first_name, last_name, exp,
rank() over(order by exp desc) as exp_rank
from emp_record_table;

--- 11.	Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.
USE employees;
create view high_salary_employees as 
select emp_id, first_name, last_name, country, salary from emp_record_table
where salary> 6000;
select * from high_salary_employees;

--- 12.	Write a nested query to find employees with experience of more than ten years. Take data from the employee record table. 
select * from emp_record_table
where EMP_ID in (select emp_id from emp_record_table where exp > 10);

--- 13.	Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.
delimiter $$
create procedure getexperiencedemployees()
begin
select * from emp_record_table where exp > 3;
end $$
delimiter ;

--- 14.Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard
DELIMITER $$
CREATE FUNCTION check_role(exp INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE role_title VARCHAR(50);
    IF exp <= 2 THEN
        SET role_title = 'JUNIOR DATA SCIENTIST';
    ELSEIF exp <= 5 THEN
        SET role_title = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF exp <= 10 THEN
        SET role_title = 'SENIOR DATA SCIENTIST';
    ELSEIF exp <= 12 THEN
        SET role_title = 'LEAD DATA SCIENTIST';
    ELSEIF exp <= 16 THEN
        SET role_title = 'MANAGER';
    END IF;
    RETURN role_title;
END $$
DELIMITER ;

-- 15.	Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan
CREATE INDEX idx_firstname ON emp_record_table(FIRST_NAME(50));
SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';

-- 16.	Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).
select emp_id, first_name, last_name, salary, emp_rating,
( 0.05 * salary * emp_rating) as bonus
from emp_record_table;

-- 17.	Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.
select country, continent, avg(salary) as avg_salary
from emp_record_table
group by country, continent;

