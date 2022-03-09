/*
-- Text data types
Q: Which of the following is not a valid text data type in PostgreSQL?
A: STRING
*/

/*
In relational databases, the information schema is an ANSI-standard set of read-only views which provide information about all of the tables, views, columns, and procedures in a database.
*/

-- Getting information about your database
-- (1)
 SELECT * 
 FROM INFORMATION_SCHEMA.TABLES
 WHERE table_schema = 'public';

 -- (2)
 SELECT * 
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_name = 'actor';

 -- Determining data types
SELECT
 	column_name, 
    data_type
FROM INFORMATION_SCHEMA.COLUMNS 
-- For the customer table
WHERE table_name = 'customer';

/*
-- Properties of date and time data types
Q: Which of the following is NOT correct?
A: TIME data types are stored with a timezone by default.
*/

-- Interval data types
SELECT
	rental_date,
	return_date,
	rental_date + INTERVAL  '3 days'  AS expected_return_date
FROM rental;

-- Accessing data in an ARRAY
-- (1)
SELECT 
  title, 
  special_features 
FROM film;

-- (2)
SELECT 
  title, 
  special_features 
FROM film

-- (3)
SELECT 
  title, 
  special_features 
FROM film
WHERE special_features[2] = 'Deleted Scenes';

-- Searching an ARRAY with ANY
SELECT
  title, 
  special_features 
FROM film 
WHERE 'Trailers' = ANY (special_features);

-- Searching an ARRAY with @>
SELECT 
  title, 
  special_features 
FROM film 
WHERE special_features @> ARRAY['Deleted Scenes'];