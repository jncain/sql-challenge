/* Before running code - make sure to update the file paths in the second step (importing data)
*/

-- database:  employee_sql

--Drop any tables that already may exist
DROP TABLE IF EXISTS departments, employees, position_title, dept_emp,
    dept_manager, salaries, titles CASCADE;


--Database scheme
CREATE TABLE departments (
    dept_no VARCHAR(4)   NOT NULL,
    dept_name VARCHAR(30)   NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (dept_no)
);

CREATE TABLE employees (
    emp_no INT   NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR(30)   NOT NULL,
    last_name VARCHAR(30)   NOT NULL,
    gender VARCHAR(1)   NOT NULL,
    hire_date DATE   NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (emp_no)
);

CREATE TABLE position_title (
    title_id VARCHAR(4)   NOT NULL,
    title_name VARCHAR(30)   NOT NULL,
    CONSTRAINT pk_position_title PRIMARY KEY (title_id)
);

CREATE TABLE dept_emp (
    emp_no INT   NOT NULL,
    dept_no VARCHAR(4)   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
    CONSTRAINT pk_dept_emp PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(4)   NOT NULL,
    emp_no INT   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
    CONSTRAINT pk_dept_manager PRIMARY KEY (dept_no,emp_no)
);

CREATE TABLE salaries (
    emp_no INT   NOT NULL,
    salary INT   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
    CONSTRAINT pk_salaries PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
    table_id SERIAL   NOT NULL,
    emp_no INT   NOT NULL,
    title_id VARCHAR(4)   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
    CONSTRAINT pk_titles PRIMARY KEY (table_id)
);

--Adding foreign key constraints
ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE titles ADD CONSTRAINT fk_titles_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE titles ADD CONSTRAINT fk_titles_title_id FOREIGN KEY(title_id)
REFERENCES position_title (title_id);

-- Entering data into tables
-- entering data into position_title table
INSERT INTO position_title (title_id, title_name)
VALUES ('t001', 'Staff'),
		('t002', 'Assistant Engineer'),
		('t003', 'Engineer'),
		('t004', 'Senior Staff'),
		('t005', 'Senior Engineer'),
		('t006', 'Technique Leader'),
		('t007', 'Manager');

-- Importing csvs into tables
-- Change file path names to match the location on your computer
COPY departments
FROM 'path\...\departments.csv'
WITH (format CSV, HEADER);

COPY employees
FROM 'path\...\employees.csv'
WITH (format CSV, HEADER);

COPY dept_emp
FROM 'path\...\dept_emp.csv'
WITH (format CSV, HEADER);

COPY dept_manager
FROM 'path\...\dept_manager.csv'
WITH (format CSV, HEADER);

COPY salaries
FROM 'path\...\salaries.csv'
WITH (format CSV, HEADER);

COPY titles (emp_no, title_id, from_date, to_date)
FROM 'path\...\titles_updated.csv'
WITH (format CSV, HEADER);
