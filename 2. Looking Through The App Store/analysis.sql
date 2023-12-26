-- Validating data 
-- check the number of unique apps in the both table 
SELECT COUNT(DISTINCT(id)) AS uniqueAppsId FROM apple_store;
SELECT COUNT(DISTINCT(id)) AS uniqueAppsDescId FROM apple_store_description;

-- check for any missing values from any fields in both table
SELECT COUNT(*) FROM apple_store WHERE track_name IS null OR user_rating IS null OR prime_genre IS null;
SELECT COUNT(*) FROM apple_store_description WHERE app_desc IS null;

-- Calculating the total number of apps by genre
-- img_1
SELECT 
	prime_genre AS Category, 
	COUNT(*) AS total_apps
FROM apple_store
GROUP BY prime_genre
ORDER BY total_apps DESC;

-- Calculating the average app size by genre:
-- the app size is converted into megabytes
-- img_2
SELECT 
	prime_genre AS Category, 
	ROUND(AVG(size_bytes/1000000)::numeric, 2) AS avg_app_size
FROM apple_store
GROUP BY prime_genre
ORDER BY avg_app_size DESC;

-- Identifying average price apps by category:
-- img_3
SELECT 
	prime_genre AS category, 
	ROUND(AVG(price)::NUMERIC, 2) AS average_price
FROM apple_store
WHERE price > 0
GROUP BY category
ORDER BY average_price DESC

-- calculating total apps by content rating:
-- img_4
SELECT 
	cont_rating, 
	COUNT(*) AS total_apps
FROM apple_store
GROUP BY cont_rating
ORDER BY total_apps DESC;

-- Finding the average user rating for each genre
-- img_5
SELECT 
	prime_genre, 
	ROUND(AVG(user_rating)::NUMERIC,2) AS avg_user_rating
FROM apple_store
GROUP BY prime_genre
ORDER BY avg_user_rating DESC;


-- Analyze the distribution of user ratings:
-- img_6
SELECT
  CASE
    WHEN user_rating >= 4.5 THEN 'Excellent'
    WHEN user_rating >= 4.0 THEN 'Good'
    WHEN user_rating >= 3.0 THEN 'Average'
    ELSE 'Poor'
  END AS rating_category,
  COUNT(*) AS num_apps
FROM apple_store
GROUP BY rating_category;

-- Calculate the correlation between numeric columns ("rating_count_tot" and "user_rating") to understand relationships between variables.
-- value will indicate the strength and direction of the relationship between "rating_count_tot" and "user_rating." 
-- A correlation close to 1 or -1 suggests a strong positive or negative correlation, respectively, 
-- while a correlation close to 0 indicates a weak or no linear relationship.
-- img_9
SELECT CORR(rating_count_tot, user_rating) AS correlation
FROM apple_store;

-- Calculating the total number of ratings for each genre:
SELECT 
	prime_genre AS category, 
	SUM(rating_count_tot) AS total_ratings
FROM apple_store
GROUP BY category
ORDER BY total_ratings DESC;


-- app rating based on language supports
-- based on https://www.visualcapitalist.com/100-most-spoken-languages/ the there are 10 popular languange in the world, 
-- so i make a 3 language bucket: less than 10, between 10 and 20, and more than 20 languages supports 
-- img_7
SELECT	
	CASE 
		WHEN lang_num < 10 THEN '< 10 language' 
		WHEN lang_num BETWEEN 10 AND 30 THEN 'betweeen 10 and 20'
		ELSE '> 20 language' 
	END AS language_supports,
	ROUND(AVG(user_rating)::NUMERIC,2) AS average_ratings
FROM apple_store
GROUP BY language_supports
ORDER BY average_ratings DESC;

-- Difference rating between paid and free apps
-- img_8
SELECT 
	CASE 
		WHEN price > 0 THEN 'paid' 
		ELSE 'free' 
	END AS app_type,
	ROUND(AVG(user_rating)::NUMERIC,1) AS average_ratings
FROM apple_store	
GROUP BY app_type;

-- correlation between the app des length and the app ratings
-- img_10
SELECT CORR(a.user_rating, LENGTH(b.app_desc)) AS correlation
FROM apple_store AS a
JOIN apple_store_description AS b ON a.id = b.id;

-- img_11
SELECT
	CASE 
		WHEN LENGTH(b.app_desc) < 700 THEN 'Short Description'
		WHEN LENGTH(b.app_desc) BETWEEN 700 AND 1400 THEN 'Medium Description'
		ELSE 'Long Description' 
	END AS description_bucket,
	ROUND(AVG(a.user_rating)::NUMERIC,2) AS average_ratings
FROM apple_store AS a
JOIN apple_store_description AS b
	ON a.id = b.id
GROUP BY description_bucket
ORDER BY average_ratings DESC;

--- popular apps on each genre based on user ratings 
WITH popular_app AS (
	SELECT 
		prime_genre AS Genre, 
		track_name AS App_Name,
		user_rating AS Rating,
		RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS App_Rank
	FROM apple_store
)
SELECT 
	Genre,
	App_Name,
	Rating
FROM 
	popular_app
WHERE App_Rank IN (1, 2, 3);



