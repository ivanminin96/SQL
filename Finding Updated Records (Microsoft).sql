--We have a table with employees and their salaries, however, some of the records are old and contain outdated salary information. 
--Find the current salary of each employee assuming that salaries increase each year. 
--Output their id, first name, last name, department ID, and current salary. 
--Order your list by employee ID in ascending order.

SELECT id,
       first_name,
       last_name,
       department_id,
       last_salary
FROM
  (SELECT id,
          first_name,
          last_name,
          salary,
          department_id,
          max(salary) OVER (PARTITION BY id) AS last_salary,
          max(salary) OVER (PARTITION BY id) = salary AS is_current_salary
   FROM ms_employee_salary) es
WHERE is_current_salary = TRUE
ORDER BY id ASC