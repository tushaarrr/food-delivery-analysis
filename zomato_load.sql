/* =====================================================
   Zomato Analytics Data Warehouse Setup
   ===================================================== */

DROP DATABASE IF EXISTS zomato_dw;
CREATE DATABASE zomato_dw;
USE zomato_dw;

SET GLOBAL local_infile = 1;

-- =====================================================
-- MAIN FACT TABLE
-- =====================================================

CREATE TABLE zomato_restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(255),
    city VARCHAR(100),
    locality VARCHAR(150),
    cuisine VARCHAR(255),
    cost_for_two DECIMAL(10,2),
    average_rating DECIMAL(3,2),
    votes INT,
    online_order VARCHAR(10),
    book_table VARCHAR(10)
);

-- =====================================================
-- LOAD CSV
-- =====================================================

LOAD DATA LOCAL INFILE 'C:/path/Zomato_Cleaned_and_Engineered.csv'
INTO TABLE zomato_restaurants
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Indexes for performance
CREATE INDEX idx_city ON zomato_restaurants(city);
CREATE INDEX idx_rating ON zomato_restaurants(average_rating);
CREATE INDEX idx_cost ON zomato_restaurants(cost_for_two);
CREATE INDEX idx_votes ON zomato_restaurants(votes);
