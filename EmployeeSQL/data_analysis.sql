/**SQL Challenge - Data Analysis**/

-- Dropping views if they exist
DROP VIEW IF EXISTS employees_by_dept;
DROP VIEW IF EXISTS salary_info;


/*1 - List the following details of each employee: employee number, last name, first name, gender, and salary.*/
SELECT emp_no, last_name, first_name, gender,
	(SELECT salary FROM salaries WHERE employees.emp_no = salaries.emp_no)
FROM employees;


/*2 - List employees who were hired in 1986.*/
SELECT emp_no, first_name, last_name 
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';


/*3 - List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.*/
SELECT dept_no, 
	(SELECT dept_name FROM departments WHERE dept_manager.dept_no = departments.dept_no),
	emp_no, 
	(SELECT last_name FROM employees WHERE dept_manager.emp_no = employees.emp_no),
	(SELECT first_name FROM employees WHERE dept_manager.emp_no = employees.emp_no),
	 from_date, to_date
FROM dept_manager
ORDER BY dept_no, to_date DESC;


/*4 - List the department of each employee with the following information: employee number, last name, first name, and department name.*/
--Creating view for future queries
CREATE VIEW employees_by_dept AS
SELECT emp_no,
	(SELECT last_name FROM employees WHERE dept_emp.emp_no = employees.emp_no),
	(SELECT first_name FROM employees WHERE dept_emp.emp_no = employees.emp_no),
	(SELECT dept_name FROM departments WHERE dept_emp.dept_no = departments.dept_no)
FROM dept_emp
-- filtering by max to_date so that each employee only appears once in the final table and grouping by employee number
WHERE dept_emp.to_date = (SELECT MAX(b.to_date) FROM dept_emp b WHERE dept_emp.emp_no = b.emp_no);
--Pull from view to see query
SELECT * FROM employees_by_dept;


/*5 - List all employees whose first name is "Hercules" and last names begin with "B."*/
SELECT emp_no, last_name, first_name
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';


/*6 - List all employees in the Sales department, including their employee number, last name, first name, and department name.*/
--Use view created in item 4
SELECT *
FROM employees_by_dept
WHERE dept_name = 'Sales';


/*7 - List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.*/
SELECT *
FROM employees_by_dept
WHERE dept_name IN ('Sales', 'Development')
ORDER BY dept_name, emp_no;


/*8 - In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.*/
SELECT last_name, COUNT(emp_no) AS employee_count
FROM employees
GROUP BY last_name
ORDER BY employee_count DESC;


/*Epilogue - searching my ID number. My employee ID number is 499942*/
select *
FROM employees
WHERE emp_no=499942;


/* Bonus Analysis */
-- For easy access of calling the SQL database into Pandas, I created a view of employee number, title, and salary
CREATE VIEW salary_info AS
SELECT emp_no,
	(SELECT title_name FROM position_title WHERE titles.title_id = position_title.title_id),
	(SELECT salary FROM salaries WHERE titles.emp_no = salaries.emp_no)
FROM titles;