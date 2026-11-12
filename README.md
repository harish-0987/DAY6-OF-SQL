# 📘 Day 6 of SQL: WHERE, AND/OR/NOT, ORDER BY, GROUP BY & HAVING

Welcome to **Day 6 of SQL**! 🚀

Today's focus is on mastering data filtering, sorting, and aggregate grouping in SQL:
1. **WHERE Clause**: Filtering individual rows based on conditions.
2. **AND, OR, NOT**: Combining, chaining, and inverting logical conditions.
3. **ORDER BY**: Sorting query results in ascending or descending order.
4. **GROUP BY**: Grouping rows that share values into summary records.
5. **HAVING**: Filtering aggregated groups (and how it differs from `WHERE`).

---

## 📑 Table of Contents
1. [SQL Query Execution Order (The Mental Model)](#1-sql-query-execution-order-the-mental-model)
2. [4. WHERE Clause](#2-4-where-clause)
3. [5. Logical Operators: AND, OR, NOT](#3-5-logical-operators-and-or-not)
   - [AND Operator](#and-operator)
   - [OR Operator](#or-operator)
   - [NOT Operator](#not-operator)
   - [Operator Precedence & Parentheses](#operator-precedence--parentheses)
4. [6. ORDER BY (Sorting Results)](#4-6-order-by-sorting-results)
5. [7. GROUP BY (Aggregate Grouping)](#5-7-group-by-aggregate-grouping)
   - [Common Aggregate Functions](#common-aggregate-functions)
   - [The Golden Rule of GROUP BY](#the-golden-rule-of-group-by)
6. [8. HAVING Clause (Filtering Aggregates)](#6-8-having-clause-filtering-aggregates)
7. [WHERE vs HAVING: Key Differences](#7-where-vs-having-key-differences)
8. [Master Query (Putting It All Together)](#8-master-query-putting-it-all-together)
9. [Hands-on Practice Script](#9-hands-on-practice-script)
10. [Summary Cheat Sheet](#10-summary-cheat-sheet)

---

## 1. SQL Query Execution Order (The Mental Model)

While we write SQL queries starting with `SELECT`, the database engine processes clauses in a specific order:

```
┌─────────────────────────────────────────────────────────────┐
│                 SQL CLAUSE EXECUTION ORDER                  │
├─────────────────────────────────────────────────────────────┤
│ 1. FROM & JOIN     --> Identify and load tables             │
│ 2. WHERE           --> Filter individual rows               │
│ 3. GROUP BY        --> Group remaining rows into buckets    │
│ 4. HAVING          --> Filter grouped aggregate buckets     │
│ 5. SELECT          --> Pick and compute columns / aliases   │
│ 6. DISTINCT        --> Remove duplicate rows                │
│ 7. ORDER BY        --> Sort final results                   │
│ 8. LIMIT / OFFSET  --> Restrict number of output rows       │
└─────────────────────────────────────────────────────────────┘
```

> **Why this matters**: Because `WHERE` runs **before** `GROUP BY`, you cannot use aggregate functions (`SUM`, `AVG`) in a `WHERE` clause. That is precisely why `HAVING` exists!

---

## 2. 4. WHERE Clause

The `WHERE` clause filters individual rows **before** any grouping or aggregation takes place. Only rows where the condition evaluates to `TRUE` are included.

### Common Comparison Operators
| Operator | Description | Example |
| :--- | :--- | :--- |
| `=` | Equal to | `WHERE department = 'Engineering'` |
| `<>` or `!=` | Not equal to | `WHERE city != 'Mumbai'` |
| `>` , `<` | Greater than, Less than | `WHERE salary > 70000` |
| `>=` , `<=` | Greater than or equal, Less than or equal | `WHERE experience_years >= 3` |
| `BETWEEN` | Inclusive range (`BETWEEN min AND max`) | `WHERE salary BETWEEN 50000 AND 80000` |
| `IN` | Matches any value in a list | `WHERE city IN ('Hyderabad', 'Bangalore')` |
| `LIKE` | Pattern matching (`%` = any chars, `_` = single char) | `WHERE emp_name LIKE 'H%'` |
| `IS NULL` | Checks for missing / NULL value | `WHERE dept_id IS NULL` |

```sql
-- Example: Retrieve employees with salary above 70,000
SELECT emp_name, department, salary 
FROM employees 
WHERE salary > 70000;
```

---

## 3. 5. Logical Operators: AND, OR, NOT

Logical operators combine or negate multiple boolean conditions in a `WHERE` or `HAVING` clause.

### AND Operator
Returns `TRUE` only if **all** conditions separated by `AND` are true.
```sql
-- Employee must be in Engineering AND located in Hyderabad
SELECT emp_name, department, city 
FROM employees 
WHERE department = 'Engineering' AND city = 'Hyderabad';
```

### OR Operator
Returns `TRUE` if **at least one** of the conditions separated by `OR` is true.
```sql
-- Employee located in either Bangalore OR Mumbai
SELECT emp_name, department, city 
FROM employees 
WHERE city = 'Bangalore' OR city = 'Mumbai';
```

### NOT Operator
Inverts the truth value of a condition.
```sql
-- All employees who do NOT belong to HR
SELECT emp_name, department, salary 
FROM employees 
WHERE NOT department = 'HR';
```

### Operator Precedence & Parentheses
In SQL, **`NOT`** has the highest precedence, followed by **`AND`**, and finally **`OR`**.
- Without parentheses, `A OR B AND C` evaluates as `A OR (B AND C)`.
- **Always use parentheses `()`** to group conditions clearly and avoid unintended logic bugs:

```sql
-- Correct: Employees in Engineering or Finance who also have >= 3 years experience
SELECT emp_name, department, experience_years 
FROM employees 
WHERE (department = 'Engineering' OR department = 'Finance') 
  AND experience_years >= 3;
```

---

## 4. 6. ORDER BY (Sorting Results)

The `ORDER BY` clause sorts the returned records based on one or more columns:
- `ASC`: Ascending order (smallest to largest, A to Z) — **default**.
- `DESC`: Descending order (largest to smallest, Z to A).

### Single Column Sorting
```sql
-- Highest salary first
SELECT emp_name, department, salary 
FROM employees 
ORDER BY salary DESC;
```

### Multi-Column Sorting
Sorts first by the primary column; if ties exist, sorts by the secondary column:
```sql
-- Sort alphabetically by department, then highest salary within each department
SELECT emp_name, department, salary 
FROM employees 
ORDER BY department ASC, salary DESC;
```

---

## 5. 7. GROUP BY (Aggregate Grouping)

The `GROUP BY` clause groups rows that have identical values in specified columns into summary rows (like "total payroll by department" or "count of customers per city").

### Common Aggregate Functions
- `COUNT(*)`: Total number of rows in the group.
- `SUM(column)`: Total sum of values.
- `AVG(column)`: Average value of the column.
- `MIN(column)`: Smallest value in the group.
- `MAX(column)`: Largest value in the group.

```sql
-- Count employees and calculate average salary per department
SELECT 
    department,
    COUNT(*) AS total_employees,
    ROUND(AVG(salary), 2) AS average_salary,
    MAX(salary) AS highest_salary
FROM employees 
GROUP BY department;
```

### Grouping by Multiple Columns
```sql
-- Breakdown headcount and payroll by department AND city
SELECT 
    department,
    city,
    COUNT(*) AS employee_count,
    SUM(salary) AS total_payroll
FROM employees 
GROUP BY department, city;
```

> ⚠️ **The Golden Rule of GROUP BY**: Any column in your `SELECT` list that is **not** enclosed in an aggregate function (`COUNT`, `SUM`, `AVG`, etc.) **must** be listed in the `GROUP BY` clause.

---

## 6. 8. HAVING Clause (Filtering Aggregates)

The `HAVING` clause filters groups of rows produced by `GROUP BY`.
- Because the `WHERE` clause runs before aggregation, you **cannot** write `WHERE AVG(salary) > 70000`.
- Instead, use `HAVING` to filter aggregate metrics:

```sql
-- Only return departments whose average salary exceeds 70,000
SELECT 
    department,
    COUNT(*) AS total_employees,
    ROUND(AVG(salary), 2) AS average_salary
FROM employees 
GROUP BY department 
HAVING AVG(salary) > 70000;

-- Only return departments that have more than 2 employees
SELECT 
    department,
    COUNT(*) AS employee_count
FROM employees 
GROUP BY department 
HAVING COUNT(*) > 2;
```

---

## 7. WHERE vs HAVING: Key Differences

| Feature | `WHERE` Clause | `HAVING` Clause |
| :--- | :--- | :--- |
| **Purpose** | Filters individual rows | Filters aggregated groups |
| **When it Executes** | **Before** `GROUP BY` aggregation | **After** `GROUP BY` aggregation |
| **Aggregate Functions** | ❌ Cannot use (`SUM`, `AVG`, etc.) | ✅ Can use (`HAVING AVG(salary) > 50000`) |
| **Works With** | `SELECT`, `UPDATE`, `DELETE` | `SELECT` queries with `GROUP BY` |
| **Performance** | Fast (reduces rows before grouping) | Operates on already grouped data |

```
All Table Rows ──► [ WHERE filters rows ] ──► [ GROUP BY aggregates ] ──► [ HAVING filters groups ] ──► Output
```

---

## 8. Master Query (Putting It All Together)

Here is a single query demonstrating how `WHERE`, `GROUP BY`, `HAVING`, and `ORDER BY` work seamlessly together:

```sql
-- 1. WHERE: Filter employees with at least 2 years of experience
-- 2. GROUP BY: Group remaining employees by department
-- 3. HAVING: Keep departments where the average salary is >= 75,000
-- 4. ORDER BY: Sort departments by highest average salary
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
```

---

## 9. Hands-on Practice Script

Run the companion SQL practice file [day6_queries.sql](day6_queries.sql) in your database environment (MySQL, PostgreSQL, SQLite, or DB client).

It includes:
- Complete table definition and sample datasets
- Clean queries for `WHERE`
- Real-world examples of `AND`, `OR`, `NOT`
- Single and multi-column `ORDER BY`
- Group aggregations with `GROUP BY`
- Filtering aggregated results with `HAVING`
- The combined master query

---

## 10. Summary Cheat Sheet

```
+---------------+-------------------------------------------------------------------+
| Clause        | Purpose & Syntax Example                                          |
+---------------+-------------------------------------------------------------------+
| WHERE         | Filter individual rows: WHERE salary >= 60000                     |
| AND           | All conditions must match: WHERE dept = 'Eng' AND city = 'Hyd'    |
| OR            | Any condition matches: WHERE city = 'Blr' OR city = 'Mum'         |
| NOT           | Invert condition: WHERE NOT dept = 'HR'                           |
| ORDER BY      | Sort ascending/descending: ORDER BY salary DESC, name ASC         |
| GROUP BY      | Collapse rows: GROUP BY department                                |
| HAVING        | Filter groups after aggregation: HAVING AVG(salary) > 70000       |
+---------------+-------------------------------------------------------------------+
```

---

⭐ **Stay tuned for Day 7!** Keep practicing and writing queries.
