-- =============================================
-- PROJECT 1: Employee Performance Analysis
-- Author: [Tumhara Naam]
-- Date: May 2026
-- Tools: MySQL
-- Description: Comprehensive employee salary
-- and performance analysis using advanced SQL
-- =============================================

-- ---- SETUP ----
CREATE DATABASE practice;
USE practice;

CREATE TABLE employees (
  id INT,
  name VARCHAR(50),
  department VARCHAR(50),
  salary INT,
  city VARCHAR(50)
);

-- [Baaki sara code jo tumne likha]

-- ---- FINAL ANALYSIS QUERY ----
WITH dept_summary AS (
    SELECT 
        department,
        COUNT(*) as total_employees,
        AVG(salary) as dept_avg,
        MAX(salary) as dept_max,
        MIN(salary) as dept_min
    FROM employees
    WHERE salary IS NOT NULL
    GROUP BY department
),
employee_ranked AS (
    SELECT 
        name,
        department,
        salary,
        joining_date,
        RANK() OVER(PARTITION BY department ORDER BY salary DESC) as dept_rank,
        salary - AVG(salary) OVER() as diff_from_company_avg,
        DATEDIFF(CURDATE(), joining_date) as days_worked
    FROM employees
    WHERE salary IS NOT NULL
)
SELECT 
    e.name,
    e.department,
    e.salary,
    CASE
        WHEN e.salary > 80000 THEN 'High'
        WHEN e.salary BETWEEN 60000 AND 80000 THEN 'Medium'
        ELSE 'Low'
    END as salary_level,
    CASE
        WHEN YEAR(e.joining_date) < 2021 THEN 'Senior'
        WHEN YEAR(e.joining_date) = 2021 THEN 'Mid Level'
        ELSE 'Junior'
    END as experience_level,
    e.dept_rank,
    ROUND(e.diff_from_company_avg, 2) as diff_from_avg,
    e.days_worked,
    d.total_employees as dept_size,
    ROUND(d.dept_avg, 2) as dept_avg_salary
FROM employee_ranked e
INNER JOIN dept_summary d ON e.department = d.department
ORDER BY e.salary DESC;
