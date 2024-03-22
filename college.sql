
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 1-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Select student details from the STUDENT table for students in class 4C

SELECT 
    S.USN,        -- Student USN
    S.SNAME,      -- Student name
    S.ADDRESS,    -- Student address
    S.PHONE,      -- Student phone number
    S.GENDER      -- Student gender
-- Joining the STUDENT, CLASS, and SEMSEC tables
FROM 
    STUDENT S,    -- Alias for STUDENT table
    CLASS C,      -- Alias for CLASS table
    SEMSEC SS     -- Alias for SEMSEC table
-- Applying join conditions
WHERE 
    S.USN = C.USN           -- Joining STUDENT with CLASS on USN
    AND SS.SSID = C.SSID    -- Joining SEMSEC with CLASS on SSID
    AND SS.SEM = 4          -- Filtering for SEM=4
    AND SS.SEC = 'C';       -- Filtering for SEC='C'


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 2-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Select the semester, section, gender, and count of students for each combination of semester, section, and gender

SELECT 
    SS.SEM,                 -- Semester
    SS.SEC,                 -- Section
    S.GENDER,               -- Gender
    COUNT(S.GENDER)         -- Count of students with each gender
-- Joining the STUDENT, SEMSEC, and CLASS tables
FROM 
    STUDENT S,              -- Alias for STUDENT table
    SEMSEC SS,              -- Alias for SEMSEC table
    CLASS C                 -- Alias for CLASS table
-- Applying join conditions
WHERE 
    S.USN = C.USN           -- Joining STUDENT with CLASS on USN
    AND SS.SSID = C.SSID    -- Joining SEMSEC with CLASS on SSID
-- Grouping the results by semester, section, and gender
GROUP BY 
    SS.SEM,                 -- Grouping by semester
    SS.SEC,                 -- Grouping by section
    S.GENDER;               -- Grouping by gender

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 3-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Create a view named TEST1_MARKS to store test1 marks for a specific student

-- Create the view TEST1_MARKS
CREATE VIEW TEST1_MARKS AS 
    -- Select USN, SUBCODE, and TEST1 columns from IAMARKS table for a specific student
    SELECT USN, SUBCODE, TEST1 
    FROM IAMARKS
    WHERE USN = '1MV15CS060';

-- Select all records from the TEST1_MARKS view
SELECT * FROM TEST1_MARKS;


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 4-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

-- Change the delimiter to allow defining stored procedures
DELIMITER #

-- Create a stored procedure named AVGMARKS
CREATE PROCEDURE AVGMARKS()
BEGIN
    -- Declare variables
    DECLARE C_A INT;
    DECLARE C_B INT;
    DECLARE C_C INT;
    DECLARE C_SUM INT;
    DECLARE C_AVG INT;
    DECLARE C_USN CHAR(10);

    -- Declare cursor for iterating through IAMARKS table
    DECLARE C_IAMARKS CURSOR FOR
        SELECT GREATEST(TEST1, TEST2), GREATEST(TEST1, TEST3), GREATEST(TEST2, TEST3), USN
        FROM IAMARKS
        WHERE FINALIA IS NULL;

    -- Open the cursor
    OPEN C_IAMARKS;
    
    -- Start looping through cursor results
    LOOP
        -- Fetch data from the cursor into variables
        FETCH C_IAMARKS INTO C_A, C_B, C_C, C_USN;
        
        -- Calculate the sum of the two highest marks
        IF C_A != C_B THEN
            SET C_SUM = C_A + C_B;
        ELSE
            SET C_SUM = C_A + C_C;
        END IF; 

        -- Calculate the average of the two highest marks
        SET C_AVG = C_SUM / 2;

        -- Update the FINALIA column with the calculated average
        UPDATE IAMARKS SET FINALIA = C_AVG WHERE USN = C_USN;
    END LOOP;

    -- Close the cursor
    CLOSE C_IAMARKS; 
END #

-- Reset the delimiter to semicolon
DELIMITER ;  

-- Call the AVGMARKS stored procedure
CALL AVGMARKS();

-- Select all records from the IAMARKS table to see the changes
SELECT * FROM IAMARKS;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 5-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

-- Select student details along with a categorized column based on final marks for students in semester 8

SELECT 
    S.USN,          -- Student USN
    S.SNAME,        -- Student name
    S.ADDRESS,      -- Student address
    S.PHONE,        -- Student phone number
    S.GENDER,       -- Student gender
    (
        -- Use CASE statement to categorize students based on their final marks
        CASE
            WHEN IA.FINALIA BETWEEN 17 AND 20 THEN 'OUTSTANDING'
            WHEN IA.FINALIA BETWEEN 12 AND 16 THEN 'AVERAGE'
            ELSE 'WEAK'
        END
    ) AS CAT         -- Categorized column based on final marks
-- Join STUDENT, SEMSEC, and IAMARKS tables
FROM 
    STUDENT S,      -- Alias for STUDENT table
    SEMSEC SS,      -- Alias for SEMSEC table
    IAMARKS IA      -- Alias for IAMARKS table
-- Apply join conditions
WHERE 
    S.USN = IA.USN         -- Join STUDENT with IAMARKS on USN
    AND SS.SSID = IA.SSID  -- Join SEMSEC with IAMARKS on SSID
    AND SS.SEM = 8;        -- Filter for semester 8
