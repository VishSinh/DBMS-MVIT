
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 1-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Count the number of customer IDs from the CUSTOMER table
SELECT COUNT(CUSTOMER_ID) 
-- Filter customers where the grade is greater than the average grade of customers from Bangalore
FROM CUSTOMER
WHERE GRADE > (
    -- Subquery: Calculate the average grade of customers from Bangalore
    SELECT AVG(GRADE)
    FROM CUSTOMER
    WHERE CITY = 'BANGALORE'
);


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 2-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Select the name and salesman ID from the SALESMAN table
SELECT S.NAME, S.SALESMAN_ID 
-- Joining the SALESMAN and CUSTOMER tables
FROM SALESMAN S, CUSTOMER C
-- Applying the join condition
WHERE S.SALESMAN_ID = C.SALESMAN_ID 
-- Grouping the results by salesman name and ID
GROUP BY S.NAME, S.SALESMAN_ID 
-- Filtering groups where the count of customer IDs is greater than 1
HAVING COUNT(C.CUSTOMER_ID) > 1;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 3-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Combine results from two SELECT queries using UNION

-- Query 1: Select salesman ID, name, and customer name where salesman's city matches customer's city
(SELECT S.SALESMAN_ID, S.NAME, C.CUST_NAME 
FROM SALESMAN S, CUSTOMER C
-- Joining SALESMAN and CUSTOMER tables based on matching cities and salesman ID
WHERE S.CITY = C.CITY AND S.SALESMAN_ID = C.SALESMAN_ID) 

-- UNION operator to combine results with Query 2
UNION

-- Query 2: Select salesman ID, name, and 'NO CUSTOMER' where salesman's city doesn't match any customer's city
(SELECT S1.SALESMAN_ID, S1.NAME, 'NO CUSTOMER' 
FROM SALESMAN S1, CUSTOMER C1
-- Joining SALESMAN and CUSTOMER tables based on non-matching cities and salesman ID
WHERE S1.CITY != C1.CITY AND S1.SALESMAN_ID = C1.SALESMAN_ID);


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 4-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

-- Create a view named "HIGH_ORDER_DAY" to store details of orders with the highest purchase amount for each order date
CREATE VIEW HIGH_ORDER_DAY AS
    SELECT 
        O.ORD_DATE,           -- Order date
        S.SALESMAN_ID,        -- Salesman ID
        S.NAME,               -- Salesman name
        C.CUST_NAME,          -- Customer name
        O.PURCHASE_AMT        -- Purchase amount
    FROM 
        ORDERS O,             -- Orders table
        SALESMAN S,           -- Salesman table
        CUSTOMER C            -- Customer table
    WHERE 
        O.SALESMAN_ID = S.SALESMAN_ID  -- Joining Orders with Salesman on Salesman ID
        AND C.CUSTOMER_ID = O.CUSTOMER_ID;  -- Joining Orders with Customer on Customer ID

-- Select all records from the "HIGH_ORDER_DAY" view where purchase amount is the maximum for each order date
SELECT * 
FROM HIGH_ORDER_DAY H
WHERE H.PURCHASE_AMT = (
    -- Subquery: Find the maximum purchase amount for each order date
    SELECT MAX(H1.PURCHASE_AMT)
    FROM HIGH_ORDER_DAY H1
    WHERE H1.ORD_DATE = H.ORD_DATE  -- Matching order date in the subquery
);

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 5-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

-- Delete the record from the SALESMAN table where SALESMAN_ID is 1000
DELETE FROM SALESMAN WHERE SALESMAN_ID = 1000;

-- Display the contents of the CUSTOMER table
SELECT * FROM CUSTOMER;

-- Display the contents of the ORDERS table
SELECT * FROM ORDERS;

-- Display the contents of the SALESMAN table
SELECT * FROM SALESMAN;

