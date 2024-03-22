
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 1-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Selecting specific columns from multiple tables
SELECT 
    C.PROGRAMME_ID,        -- Programme ID from BOOK_COPIES
    L.PROGRAMME_NAME,      -- Programme name from LIBRARY_PROGRAMME
    B.BOOK_ID,             -- Book ID from BOOK
    B.TITLE,               -- Title of the book from BOOK
    B.PUBLISHER_NAME,      -- Publisher name from BOOK
    B.PUB_YEAR,            -- Publication year from BOOK
    A.AUTHOR_NAME,         -- Author name from BOOK_AUTHORS
    C.NO_OF_COPIES        -- Number of copies from BOOK_COPIES
-- Specifying the tables involved
FROM 
    BOOK B,                 -- Main table for books
    BOOK_AUTHORS A,         -- Table for book authors
    LIBRARY_PROGRAMME L,    -- Table for library programmes
    BOOK_COPIES C           -- Table for book copies
-- Joining conditions between the tables
WHERE 
    B.BOOK_ID = A.BOOK_ID AND        -- Joining BOOK with BOOK_AUTHORS on BOOK_ID
    B.BOOK_ID = C.BOOK_ID AND        -- Joining BOOK with BOOK_COPIES on BOOK_ID
    L.PROGRAMME_ID = C.PROGRAMME_ID  -- Joining LIBRARY_PROGRAMME with BOOK_COPIES on PROGRAMME_ID
-- Filtering based on matching pairs of (PROGRAMME_ID, BOOK_ID) in a subquery
    AND (C.PROGRAMME_ID, C.BOOK_ID) IN 
    (
        -- Subquery to select distinct pairs of (PROGRAMME_ID, BOOK_ID)
        SELECT 
            PROGRAMME_ID,    -- Selecting PROGRAMME_ID
            BOOK_ID          -- Selecting BOOK_ID
        FROM 
            BOOK_COPIES      -- Table being queried
        GROUP BY 
            PROGRAMME_ID,    -- Grouping by PROGRAMME_ID
            BOOK_ID          -- Grouping by BOOK_ID
    );


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 2-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Selecting all columns from the BOOK_LENDING table
SELECT * 
FROM 
    BOOK_LENDING
-- Filtering records where DATE_OUT falls between January 1, 2017, and June 30, 2017
WHERE 
    DATE_OUT BETWEEN '2017-01-01' AND '2017-06-30' 
-- Filtering records where CARD_NO appears more than three times within the specified time frame
    AND CARD_NO IN 
        (
            -- Subquery: Selecting CARD_NO from BOOK_LENDING and grouping by CARD_NO
            SELECT 
                CARD_NO 
            FROM 
                BOOK_LENDING 
            GROUP BY 
                CARD_NO 
            -- Filtering groups where the count of CARD_NO is greater than 3
            HAVING 
                COUNT(CARD_NO) > 3
        );


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 3-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Deleting a record from the BOOK table where BOOK_ID is 5555
DELETE FROM BOOK WHERE BOOK_ID = 5555;

-- Selecting all records from the BOOK table
SELECT * FROM BOOK;


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 4-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- This query creates a view named "YEAR" that selects the PUB_YEAR column from the BOOK table.
-- It then selects all records from the "YEAR" view.

-- Create a view named "YEAR" that selects the PUB_YEAR column from the BOOK table
CREATE VIEW YEAR AS 
    SELECT PUB_YEAR 
    FROM BOOK;

-- Select all records from the "YEAR" view
SELECT * 
FROM YEAR;



----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 5-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- This query creates a view named "ALL_BOOK" that combines information about books, their copies, and the corresponding library programmes.
-- The view includes the book ID, title, number of copies, and programme name.

-- Create a view named "ALL_BOOK" that selects specific columns from multiple tables
CREATE VIEW ALL_BOOK AS
    SELECT 
        B.BOOK_ID,          -- Selecting BOOK_ID from BOOK table
        B.TITLE,            -- Selecting TITLE from BOOK table
        C.NO_OF_COPIES,     -- Selecting NO_OF_COPIES from BOOK_COPIES table
        L.PROGRAMME_NAME    -- Selecting PROGRAMME_NAME from LIBRARY_PROGRAMME table
    FROM 
        BOOK B,                 -- Main table for books
        BOOK_COPIES C,          -- Table for book copies
        LIBRARY_PROGRAMME L     -- Table for library programmes
    WHERE 
        B.BOOK_ID = C.BOOK_ID  -- Joining BOOK with BOOK_COPIES on BOOK_ID
        AND L.PROGRAMME_ID = C.PROGRAMME_ID; -- Joining LIBRARY_PROGRAMME with BOOK_COPIES on PROGRAMME_ID

-- Select all records from the "ALL_BOOK" view
SELECT * 
FROM ALL_BOOK;

