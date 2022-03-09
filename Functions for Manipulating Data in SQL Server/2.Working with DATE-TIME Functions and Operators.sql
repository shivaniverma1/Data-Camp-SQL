-- Adding and subtracting date and time values
-- (1)
SELECT f.title, f.rental_duration,
    r.return_date - r.rental_date AS days_rented
FROM film AS f
     INNER JOIN inventory AS i ON f.film_id = i.film_id
     INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;

-- (2)
SELECT f.title, f.rental_duration,
	AGE(r.return_date, r.rental_date) AS days_rented
FROM film AS f
	INNER JOIN inventory AS i ON f.film_id = i.film_id
	INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
ORDER BY f.title;

-- INTERVAL arithmetic
SELECT
	f.title,
    INTERVAL '1' day * f.rental_duration,
    r.return_date - r.rental_date AS days_rented
FROM film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
ORDER BY f.title;

-- Calculating the expected return date
SELECT
    f.title,
	r.rental_date,
    f.rental_duration,
    INTERVAL '1' day * f.rental_duration + r.rental_date AS expected_return_date,
    r.return_date
FROM film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;

-- Working with the current date and time
-- (1)
SELECT NOW();

-- (2)
SELECT CURRENT_DATE;

-- (3)
SELECT CAST( NOW() AS timestamp )

-- (4)
SELECT 
	CURRENT_DATE,
    CAST( NOW() AS date )

-- Manipulating the current date and time
-- (1)
SELECT 
CURRENT_TIMESTAMP::timestamp AS right_now;

-- (2)
SELECT
CURRENT_TIMESTAMP::timestamp AS right_now,
INTERVAL '5 ___' + CURRENT_TIMESTAMP AS five_days_from_now;

-- (3)
SELECT
CURRENT_TIMESTAMP(0)::timestamp AS right_now,
interval '5 days' + CURRENT_TIMESTAMP(0) AS five_days_from_now;

-- Using EXTRACT
-- (1)
SELECT 
  EXTRACT(dow FROM rental_date) AS dayofweek 
FROM rental 
LIMIT 100;

-- (2)
SELECT 
  EXTRACT(dow FROM rental_date) AS dayofweek, 
  COUNT(rental_id) as rentals 
FROM rental 
GROUP BY 1;

-- Using DATE_TRUNC
-- (1)
SELECT DATE_TRUNC('Year', rental_date) AS rental_year
FROM rental;

-- (2)
SELECT DATE_TRUNC('Month', rental_date) AS rental_month
FROM rental;

-- (3)
SELECT DATE_TRUNC('Day', rental_date) AS rental_day 
FROM rental;

-- (4)
SELECT 
  DATE_TRUNC('Day', rental_date) AS rental_day,
  COUNT(rental_id) AS rentals 
FROM rental
GROUP BY 1;

-- Putting it all together
-- (1)
SELECT 
  EXTRACT(dow FROM rental_date) AS dayofweek,
  AGE(return_date, rental_date) AS rental_days
FROM rental AS r 
WHERE 
  rental_date BETWEEN CAST('2005-05-01' AS DATE)
   AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';

-- (2)
SELECT 
  c.first_name || ' ' || c.last_name AS customer_name,
  f.title,
  r.rental_date,
  EXTRACT(dow FROM r.rental_date) AS dayofweek,
  AGE(r.return_date, r.rental_date) AS rental_days,
  CASE WHEN DATE_TRUNC('day', AGE(r.return_date, r.rental_date)) > 
    f.rental_duration * INTERVAL '1' day 
  THEN TRUE 
  ELSE FALSE END AS past_due 
FROM 
  film AS f 
  INNER JOIN inventory AS i 
  	ON f.film_id = i.film_id 
  INNER JOIN rental AS r 
  	ON i.inventory_id = r.inventory_id 
  INNER JOIN customer AS c 
  	ON c.customer_id = r.customer_id 
WHERE 
  r.rental_date BETWEEN CAST('2005-05-01' AS DATE) 
  AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';   