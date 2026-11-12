-- ====================================================================
-- DAY 6 OF SQL: WHERE, AND/OR/NOT, ORDER BY, GROUP BY & HAVING
-- Topic: Advanced Filtering, Sorting, and Group Aggregations
-- ====================================================================

-- 1. Setup Database & Sample Table
CREATE DATABASE IF NOT EXISTS day6_db;
USE day6_db;

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    experience_years INT NOT NULL,
    city VARCHAR(50) NOT NULL
);

-- 2. Insert Sample Records
INSERT INTO employees (emp_name, department, salary, experience_years, city) VALUES
('Harish',  'Engineering', 85000.00, 3, 'Hyderabad'),
('Rahul',   'Engineering', 72000.00, 2, 'Bangalore'),
('Priya',   'HR',          55000.00, 4, 'Hyderabad'),
('Amit',    'Engineering', 95000.00, 5, 'Bangalore'),
('Sneha',   'Finance',     68000.00, 3, 'Mumbai'),
('Vikram',  'HR',          48000.00, 1, 'Mumbai'),
('Ananya',  'Finance',     75000.00, 4, 'Hyderabad'),
('Karan',   'Engineering', 62000.00, 1, 'Hyderabad'),
('Divya',   'Finance',     82000.00, 5, 'Bangalore');

-- --------------------------------------------------------------------
-- 3. WHERE CLAUSE (Filter Individual Rows)
-- --------------------------------------------------------------------
-- Filter employees who earn more than 70,000
SELECT emp_name, department, salary 
FROM employees 
WHERE salary > 70000;

-- --------------------------------------------------------------------
-- 4. LOGICAL OPERATORS: AND, OR, NOT
-- --------------------------------------------------------------------
-- AND: Both conditions must be TRUE
SELECT emp_name, department, salary, city 
FROM employees 
WHERE department = 'Engineering' AND city = 'Hyderabad';

-- OR: At least one condition must be TRUE
SELECT emp_name, department, city 
FROM employees 
WHERE city = 'Bangalore' OR city = 'Mumbai';

-- NOT: Inverts the condition (Exclude HR department)
SELECT emp_name, department, salary 
FROM employees 
WHERE NOT department = 'HR';

-- Combining AND, OR, NOT with Parentheses
SELECT emp_name, department, salary, experience_years 
FROM employees 
WHERE (department = 'Engineering' OR department = 'Finance') 
  AND NOT experience_years < 3;

-- --------------------------------------------------------------------
-- 5. ORDER BY (Sort Results)
-- --------------------------------------------------------------------
-- Sort by salary descending (Highest to Lowest)
SELECT emp_name, department, salary 
FROM employees 
ORDER BY salary DESC;

-- Multi-column sorting: Department ascending, then salary descending
SELECT emp_name, department, salary 
FROM employees 
ORDER BY department ASC, salary DESC;

-- --------------------------------------------------------------------
-- 6. GROUP BY (Aggregate Data into Summary Rows)
-- --------------------------------------------------------------------
-- Count employees and calculate average salary per department
SELECT 
    department,
    COUNT(*) AS total_employees,
    ROUND(AVG(salary), 2) AS average_salary,
    MAX(salary) AS highest_salary
FROM employees 
GROUP BY department;

-- Group by multiple columns: Department and City
SELECT 
    department,
    city,
    COUNT(*) AS employee_count,
    SUM(salary) AS total_payroll
FROM employees 
GROUP BY department, city;

-- --------------------------------------------------------------------
-- 7. HAVING CLAUSE (Filter Aggregated Groups)
-- --------------------------------------------------------------------
-- Find departments where average salary is greater than 70,000
SELECT 
    department,
    COUNT(*) AS total_employees,
    ROUND(AVG(salary), 2) AS average_salary
FROM employees 
GROUP BY department 
HAVING AVG(salary) > 70000;

-- Find departments with more than 2 employees
SELECT 
    department,
    COUNT(*) AS employee_count
FROM employees 
GROUP BY department 
HAVING COUNT(*) > 2;

-- --------------------------------------------------------------------
-- 8. MASTER QUERY: WHERE + GROUP BY + HAVING + ORDER BY
-- --------------------------------------------------------------------
-- 1. WHERE filters employees with at least 2 years experience
-- 2. GROUP BY groups remaining rows by department
-- 3. HAVING keeps departments with average salary >= 75000
-- 4. ORDER BY sorts by average salary descending
SELECT 
    department,
    COUNT(*) AS experienced_staff_count,
    ROUND(AVG(salary), 2) AS avg_salary,
    SUM(salary) AS total_budget
FROM employees 
WHERE experience_years >= 2
GROUP BY department 
HAVING AVG(salary) >= 75000
ORDER BY avg_salary DESC;
