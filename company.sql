
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 1-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- This query retrieves the project numbers for projects either managed by or worked on by an employee named 'SCOTT'

-- First part: Find project numbers for projects managed by 'SCOTT'
(
    SELECT DISTINCT P.PNO
    -- Joining PROJECT, DEPARTMENT, and EMPLOYEE tables
    FROM PROJECT P, DEPARTMENT D, EMPLOYEE E
    -- Applying join conditions
    WHERE P.DNO = D.DNO             -- Joining PROJECT with DEPARTMENT on department number
        AND D.MGRSSN = E.SSN         -- Joining DEPARTMENT with EMPLOYEE on manager SSN
        AND E.NAME = 'SCOTT'         -- Filtering for employee named 'SCOTT'
) 
-- UNION operator to combine results with the second part
UNION
-- Second part: Find project numbers for projects worked on by 'SCOTT'
(
    SELECT DISTINCT P.PNO
    -- Joining PROJECT, WORKS_ON, and EMPLOYEE tables
    FROM PROJECT P, WORKS_ON W, EMPLOYEE E
    -- Applying join conditions
    WHERE P.PNO = W.PNO              -- Joining PROJECT with WORKS_ON on project number
        AND W.SSN = E.SSN            -- Joining WORKS_ON with EMPLOYEE on employee SSN
        AND E.NAME = 'SCOTT'         -- Filtering for employee named 'SCOTT'
);

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 2-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- This query selects the names of employees and their salaries after a 10% salary hike for employees working on the 'IOT' project

SELECT 
    E.NAME,                      -- Employee name
    1.1 * E.SALARY AS HIKE_SALARY  -- Salary after a 10% hike
-- Joining EMPLOYEE, WORKS_ON, and PROJECT tables
FROM 
    EMPLOYEE E,     -- Alias for EMPLOYEE table
    WORKS_ON W,     -- Alias for WORKS_ON table
    PROJECT P       -- Alias for PROJECT table
-- Applying join conditions
WHERE 
    E.SSN = W.SSN          -- Joining EMPLOYEE with WORKS_ON on employee SSN
    AND P.PNO = W.PNO      -- Joining PROJECT with WORKS_ON on project number
    AND P.PNAME = 'IOT';   -- Filtering for projects named 'IOT'

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 3-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- This query calculates various statistical measures for the salaries of employees in the 'ACCOUNTS' department

SELECT 
    SUM(E.SALARY) AS SUM_SAL,    -- Sum of salaries
    MAX(E.SALARY) AS MAX_SAL,    -- Maximum salary
    MIN(E.SALARY) AS MIN_SAL,    -- Minimum salary
    AVG(E.SALARY) AS AVG_SAL     -- Average salary
-- Joining EMPLOYEE and DEPARTMENT tables
FROM 
    EMPLOYEE E,     -- Alias for EMPLOYEE table
    DEPARTMENT D    -- Alias for DEPARTMENT table
-- Applying join condition
WHERE 
    E.DNO = D.DNO            -- Joining EMPLOYEE with DEPARTMENT on department number
    AND D.DNAME = 'ACCOUNTS';   -- Filtering for departments named 'ACCOUNTS'


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 4-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- This query selects the names of employees who are not working on any project in department 5

SELECT 
    E.NAME   -- Selecting employee names
FROM 
    EMPLOYEE E   -- Alias for EMPLOYEE table
WHERE 
    NOT EXISTS(   -- Checking for non-existence of certain conditions
        SELECT *
        FROM 
            WORKS_ON W1   -- Alias for the first WORKS_ON subquery
        WHERE 
            W1.PNO IN (   -- Selecting project numbers for projects in department 5
                SELECT P.PNO
                FROM PROJECT P 
                WHERE P.DNO = 5   -- Filtering for department number 5
            )
            AND
            NOT EXISTS(   -- Checking for non-existence of certain conditions within another subquery
                SELECT *
                FROM 
                    WORKS_ON W2   -- Alias for the second WORKS_ON subquery
                WHERE 
                    W2.SSN = E.SSN   -- Matching the employee SSN
                    AND 
                    W2.PNO = W1.PNO   -- Matching the project number with the outer subquery
            )
    );

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------OR-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
SELECT 
    E.NAME   -- Selecting employee names
FROM 
    EMPLOYEE E   -- Alias for EMPLOYEE table
LEFT JOIN 
    WORKS_ON W1   -- Alias for the first WORKS_ON subquery
ON 
    E.SSN = W1.SSN
LEFT JOIN 
    PROJECT P   -- Alias for PROJECT table
ON 
    W1.PNO = P.PNO
    AND P.DNO = 5   -- Joining projects in department 5
WHERE 
    P.PNO IS NULL;   -- Filtering for employees not working on any project in department 5





----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 5-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- This query selects the department numbers and counts the number of employees in each department 
-- where the salary is greater than 600,000 and the department has more than 5 employees.

SELECT 
    DNO,                           -- Selecting the department number
    COUNT(*) AS NO_OF_EMP         -- Counting the number of employees in each department
FROM 
    EMPLOYEE                      -- Selecting from the EMPLOYEE table
WHERE 
    SALARY > 600000               -- Filtering employees with salary greater than 600,000
    AND 
    DNO IN (
        SELECT 
            DNO                     -- Subquery to find department numbers
        FROM 
            EMPLOYEE                 -- Selecting from the EMPLOYEE table
        GROUP BY 
            DNO                     -- Grouping by department number
        HAVING 
            COUNT(*) > 5            -- Filtering departments with more than 5 employees
    )
GROUP BY 
    DNO;                           -- Grouping the results by department number
