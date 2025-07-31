--NETFLIX PROJECT

CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

select 
  *  
from netflix;

select 
   count(*) 
from netflix;

select
  distinct type
from netflix;
-- BUSINESS PROBLEM

-- 1. Count the Number of Movies vs TV Shows
select 
  type ,
  count(*)
from netflix
group by 1;

-- 2. Find the Most Common Rating for Movies and TV Shows
select 
  type,
  rating from(
select 
  type,
  rating,
  count(*),
  rank() over (partition by type order by count(*) desc ) as ranking 
from netflix
group by 1,2)as t1
where ranking=1;

-- 3. List All Movies Released in a Specific Year (e.g., 2020)
select
* 
from netflix
where type = 'Movie'
and
release_year = 2020;

-- 4. Find the Top 5 Countries with the Most Content on Netflix
SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;

-- 5. Identify the Longest Movie
select 
  *
from netflix
where 
type = 'Movie' 
and 
duration = (select max(duration) from netflix);

-- 6. Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
select * from netflix
where director ilike '%Rajiv Chilaka%'

-- 8. List All TV Shows with More Than 5 Seasons
select 
   * 
from netflix
where type = 'TV Show' 
and 
split_part(duration,' ',1)::numeric >5;

-- 9. Count the Number of Content Items in Each Genre
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;

-- 10. Find each year and the average number of content releases in India on Netflix. 
-- Return top 5 years with highest average content release.
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE
   country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

-- 11. List All Movies that are Documentaries
select 
  * from netflix
where 
    listed_in like '%Documentaries';
	
-- 12. Find All Content Without a Director
select 
  * from netflix
where
  director is Null;
   
-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*) as total_content
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;









