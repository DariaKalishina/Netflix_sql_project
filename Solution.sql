-- Netflix Project 

CREATE TABLE netflix
( 
show_id VARCHAR(6),	
type	VARCHAR(10),
title	VARCHAR(150),
director VARCHAR(208),	
casts	VARCHAR(1000),
country	VARCHAR(150),
date_added	VARCHAR(50),
release_year INT,	
rating	VARCHAR(10),
duration VARCHAR(15),	
listed_in	VARCHAR(250),
description VARCHAR(250)
);
select * from netflix;

select count(*) as total_content
from netflix;

select distinct type
from netflix;

-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows
select 
type,
count(*) as total_content
from netflix
group by type;


-- 2. Find the most common rating for movies and TV shows
with most_common_rating AS (select
type,
rating,
count(*),
rank () over(partition by type order by count(*) desc) as ranking
from netflix
group by type, rating
order by count(*) DESC)

select 
type,
rating
from most_common_rating
where ranking=1;


--3. List all movies released in a specific year (e.g., 2020)
select * 
from netflix
where 
type = 'Movie' and
release_year='2020'

-- 4. Find the top 5 countries with the most content on Netflix
select 
trim(unnest(STRING_TO_ARRAY(country, ','))) AS new_country,
count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5

-- 5. Identify the longest movie
select title,  substring(duration, 1,position ('m' in duration)-1)::int duration
from Netflix
where type = 'Movie' and duration is not null
order by 2 desc
limit 1

-- 6. Find content added in the last 5 years

select *
from netflix
where to_date(date_added, 'Month DD,YYYY') >= current_date - interval '5 years'

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select *
from netflix
where director like '%Rajiv Chilaka%'

-- 8. List all TV shows with more than 5 seasons

select *
from netflix
where type = 'TV Show' and split_part(duration, ' ', 1)::numeric > 5

-- 9. Count the number of content items in each genre
select 
trim(unnest(STRING_TO_ARRAY(listed_in, ','))) AS genre,
count(show_id) as total_content
from netflix
group by 1

-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!
select
release_year,
count(show_id) as total_content
from netflix
where country ilike '%India%'
group by release_year
order by 2 DESC
limit 5


-- 11. List all movies that are documentaries
select *
from netflix
where type = 'Movie' and listed_in ilike '%Documentaries%'

-- 12. Find all content without a director
select *
from netflix
where director is NULL

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select
count(*)
from netflix
where type = 'Movie' and casts ilike '%Salman Khan%' and
release_year > extract(year from current_date) - 10

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
trim(unnest(STRING_TO_ARRAY(casts, ','))) AS num_casts,
count(show_id) as total_content
from netflix
where type = 'Movie' and country ilike '%India%'
group by 1
order by 2 DESC
limit 10

-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
with content_categorized AS (select *,
case when description ilike '%kill%' or description ilike '%violence%' then 'Bad'
else 'Good' end as good_bad_content
from netflix)

select
good_bad_content,
count(*)
from content_categorized
group by good_bad_content