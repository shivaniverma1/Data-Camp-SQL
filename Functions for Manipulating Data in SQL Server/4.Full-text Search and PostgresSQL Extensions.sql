-- A review of the LIKE operator
-- (1)
SELECT *
FROM film
WHERE title LIKE 'GOLD%';

-- (2)
SELECT *
FROM film
WHERE title LIKE '%GOLD';

-- (3)
SELECT *
FROM film
WHERE title LIKE '%GOLD%';

-- What is a tsvector?
SELECT to_tsvector(description)
FROM film;

-- Basic full-text search
SELECT title, description
FROM film
WHERE to_tsvector(title) @@ to_tsquery('elf');

-- User-defined data types
-- (1)
CREATE TYPE compass_position AS ENUM (
  	'North', 
  	'West',
  	'South', 
  	'East'
);

-- (2)
CREATE TYPE compass_position AS ENUM (
  	'North', 
  	'South',
  	'East', 
  	'West'
);
SELECT typname
FROM pg_type
WHERE typname='compass_position';

-- Getting info about user-defined data types
-- (1)
SELECT column_name, data_type, udt_name
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE table_name ='film' and column_name='rating';

-- (2)
SELECT *
FROM pg_type 
WHERE typname='mpaa_rating'

-- User-defined functions in Sakila
-- (1)
SELECT 
	f.title, 
    r.rental_id, 
    i.inventory_id
FROM film as f 
	INNER JOIN inventory AS i ON f.film_id=i.film_id 
    INNER JOIN rental AS r on i.inventory_id=r.inventory_id

-- (2)
SELECT 
	f.title, 
    r.rental_id, 
    i.inventory_id,
    inventory_held_by_customer(i.inventory_id) AS held_by_cust
FROM film as f 
	INNER JOIN inventory AS i ON f.film_id=i.film_id 
    INNER JOIN rental AS r on i.inventory_id=r.inventory_id

-- (3)
SELECT 
	f.title, 
    r.rental_id, 
    i.inventory_id,
    inventory_held_by_customer(i.inventory_id) as held_by_cust
FROM film as f 
	INNER JOIN inventory AS i ON f.film_id=i.film_id 
    INNER JOIN rental AS r on i.inventory_id=r.inventory_id
WHERE
    inventory_held_by_customer(i.inventory_id) IS NOT NULL

-- Enabling extensions
-- (1)
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- (2)
SELECT * 
FROM pg_extension;

-- Measuring similarity between two strings
SELECT 
  title, 
  description, 
  similarity(title, description)
FROM film

-- Levenshtein distance examples
SELECT  
  title, 
  description, 
  levenshtein(title, 'JET NEIGHBOR') AS distance
FROM 
  film
ORDER BY 3

-- Putting it all together
-- (1)
SELECT  
  title, 
  description 
FROM 
  film 
WHERE 
  to_tsvector(description) @@ 
  to_tsquery('Astounding & Drama');

-- (2)
SELECT 
  title, 
  description, 
  similarity(description, 'Astounding Drama') 
FROM 
  film 
WHERE 
  to_tsvector(description) @@ 
  to_tsquery('Astounding & Drama') 
ORDER BY 
	similarity(description, 'Astounding Drama') DESC;