
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 1-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Select the movie titles from the MOVIES table directed by a director with the name 'HITCHCOCK'

SELECT M.MOV_TITLE
-- Joining the MOVIES and DIRECTOR tables based on the director ID
FROM MOVIES M, DIRECTOR D
-- Applying the join condition where the director ID matches and the director's name is 'HITCHCOCK'
WHERE D.DIR_ID = M.DIR_ID AND D.DIR_NAME = 'HITCHCOCK';

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 2-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Select movie titles and actor names for actors who have appeared in more than one movie

SELECT M.MOV_TITLE, A.ACT_NAME
-- Joining MOVIES, ACTOR, and MOVIE_CAST tables
FROM MOVIES M, ACTOR A, MOVIE_CAST M1
-- Applying join conditions
WHERE 
    M.MOV_ID = M1.MOV_ID -- Joining MOVIES with MOVIE_CAST on MOV_ID
    AND M1.ACT_ID = A.ACT_ID -- Joining MOVIE_CAST with ACTOR on ACT_ID
    -- Filtering actors who have appeared in more than one movie
    AND M1.ACT_ID IN (
        -- Subquery to find ACT_IDs of actors who have appeared in multiple movies
        SELECT ACT_ID
        FROM MOVIE_CAST 
        GROUP BY ACT_ID
        HAVING COUNT(MOV_ID) > 1 -- Filtering ACT_IDs with more than one MOV_ID (movie appearances)
    );


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 3-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Find actors who appeared in movies released before 2000 and after 2015

(
    -- First part: Find actors who appeared in movies released before 2000

    SELECT A.ACT_NAME
    -- Joining ACTOR, MOVIE_CAST, and MOVIES tables
    FROM ACTOR A 
    JOIN MOVIE_CAST M ON A.ACT_ID = M.ACT_ID 
    JOIN MOVIES M1 ON M.MOV_ID = M1.MOV_ID
    -- Filtering movies released before 2000
    WHERE M1.MOV_YEAR < 2000
)

INTERSECT 

(
    -- Second part: Find actors who appeared in movies released after 2015

    SELECT A.ACT_NAME
    -- Joining ACTOR, MOVIE_CAST, and MOVIES tables
    FROM ACTOR A 
    JOIN MOVIE_CAST M ON A.ACT_ID = M.ACT_ID 
    JOIN MOVIES M1 ON M.MOV_ID = M1.MOV_ID
    -- Filtering movies released after 2015
    WHERE M1.MOV_YEAR > 2015
);

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 4-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

-- Select the movie title and the maximum rating stars for each movie

SELECT M.MOV_TITLE, MAX(R.REV_STARS) 
-- Joining the MOVIES and RATING tables based on MOV_ID
FROM MOVIES M
JOIN RATING R ON M.MOV_ID = R.MOV_ID
-- Filtering MOV_IDs where REV_STARS is greater than 0
WHERE M.MOV_ID IN (
    SELECT MOV_ID
    FROM RATING
    GROUP BY MOV_ID, REV_STARS
    HAVING REV_STARS > 0
)
-- Grouping the result by movie title
GROUP BY M.MOV_TITLE 
-- Ordering the result by movie title
ORDER BY M.MOV_TITLE;


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------QUERY 5-----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

-- Update the review stars to 5 for movies directed by 'STEVEN SPIELBERG'

-- Update the REV_STARS column in the RATING table
UPDATE RATING 
-- Set REV_STARS to 5 for movies directed by 'STEVEN SPIELBERG'
SET REV_STARS = 5
-- Filtering MOV_IDs for movies directed by 'STEVEN SPIELBERG'
WHERE MOV_ID IN (
    -- Subquery to find MOV_IDs for movies directed by 'STEVEN SPIELBERG'
    SELECT MOV_ID
    FROM MOVIES
    -- Filtering MOVIES table for movies directed by 'STEVEN SPIELBERG'
    WHERE DIR_ID = (
        -- Subquery to find DIR_ID for 'STEVEN SPIELBERG'
        SELECT DIR_ID
        FROM DIRECTOR
        WHERE DIR_NAME = 'STEVEN SPIELBERG'
    )
);

-- Select all records from the RATING table after the update
SELECT * FROM RATING;

