/* ===============================
   CLEAN ADVANCED SQL QUERIES
   =============================== */

-- 1 Total Restaurants
SELECT COUNT(*) AS total_restaurants
FROM zomato_restaurants;


-- 2 Average Rating by City
SELECT city,
ROUND(AVG(average_rating),2) AS avg_rating
FROM zomato_restaurants
GROUP BY city
ORDER BY avg_rating DESC;


-- 3 Top 5 Restaurants Overall
SELECT restaurant_name, average_rating
FROM zomato_restaurants
ORDER BY average_rating DESC
LIMIT 5;


-- 4 Rank Restaurants Within City
SELECT restaurant_name, city, average_rating,
RANK() OVER(PARTITION BY city ORDER BY average_rating DESC) AS city_rank
FROM zomato_restaurants;


-- 5 Highest Votes per City
SELECT *
FROM (
    SELECT restaurant_name, city, votes,
    ROW_NUMBER() OVER(PARTITION BY city ORDER BY votes DESC) AS rn
    FROM zomato_restaurants
) t
WHERE rn = 1;


-- 6 Cumulative Votes
SELECT restaurant_name, votes,
SUM(votes) OVER(ORDER BY votes DESC) AS cumulative_votes
FROM zomato_restaurants;


-- 7 Moving Average of Votes
SELECT restaurant_name, votes,
AVG(votes) OVER(ORDER BY votes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_votes
FROM zomato_restaurants;


-- 8 Compare with Previous Rating
SELECT restaurant_name, average_rating,
LAG(average_rating) OVER(ORDER BY average_rating) AS previous_rating
FROM zomato_restaurants;


-- 9 Restaurants Above City Average
SELECT *
FROM (
    SELECT *,
    AVG(average_rating) OVER(PARTITION BY city) AS city_avg
    FROM zomato_restaurants
) t
WHERE average_rating > city_avg;


-- 10 Revenue Simulation (Cost Proxy)
SELECT restaurant_name,
(cost_for_two * votes) AS estimated_revenue
FROM zomato_restaurants
ORDER BY estimated_revenue DESC;


-- 11 Most Expensive Restaurant per City
SELECT *
FROM (
    SELECT restaurant_name, city, cost_for_two,
    ROW_NUMBER() OVER(PARTITION BY city ORDER BY cost_for_two DESC) AS rn
    FROM zomato_restaurants
) t
WHERE rn = 1;


-- 12 Lowest Rated Restaurant per City
SELECT *
FROM (
    SELECT restaurant_name, city, average_rating,
    ROW_NUMBER() OVER(PARTITION BY city ORDER BY average_rating ASC) AS rn
    FROM zomato_restaurants
) t
WHERE rn = 1;


-- 13 Average Cost by City
SELECT city,
ROUND(AVG(cost_for_two),2) AS avg_cost
FROM zomato_restaurants
GROUP BY city;


-- 14 Vote Share by City
SELECT city,
SUM(votes) AS city_votes,
SUM(votes) * 100 / (SELECT SUM(votes) FROM zomato_restaurants) AS vote_percent
FROM zomato_restaurants
GROUP BY city
ORDER BY vote_percent DESC;


-- 15 Cost Efficiency Ranking
SELECT restaurant_name,
(average_rating / cost_for_two) AS cost_efficiency,
RANK() OVER(ORDER BY (average_rating / cost_for_two) DESC) AS efficiency_rank
FROM zomato_restaurants;


-- 16 Online Order Impact
SELECT online_order,
ROUND(AVG(average_rating),2) AS avg_rating,
AVG(votes) AS avg_votes
FROM zomato_restaurants
GROUP BY online_order;


-- 17 Book Table Impact
SELECT book_table,
ROUND(AVG(average_rating),2) AS avg_rating
FROM zomato_restaurants
GROUP BY book_table;


-- 18 Top Cuisine per City
SELECT *
FROM (
    SELECT city, cuisine,
    AVG(average_rating) AS avg_rating,
    RANK() OVER(PARTITION BY city ORDER BY AVG(average_rating) DESC) AS cuisine_rank
    FROM zomato_restaurants
    GROUP BY city, cuisine
) t
WHERE cuisine_rank = 1;


-- 19 Vote Weighted Rating
SELECT restaurant_name,
(average_rating * votes) AS weighted_score
FROM zomato_restaurants
ORDER BY weighted_score DESC;


-- 20 Standard Deviation of Ratings by City
SELECT city,
STDDEV(average_rating) AS rating_variation
FROM zomato_restaurants
GROUP BY city;
