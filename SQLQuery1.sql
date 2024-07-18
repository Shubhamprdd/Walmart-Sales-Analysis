SELECT * FROM Walmart


-- Add the time_of_day column

SELECT
    Time,
    CASE
        WHEN Time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN Time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM Walmart;

ALTER TABLE Walmart ADD time_of_day VARCHAR(20);

UPDATE Walmart
SET time_of_day = (
    CASE
        WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

SELECT * FROM Walmart


-- Add day_name column

SELECT
    date,
    FORMAT(date, 'dddd') AS day_name
FROM Walmart;

ALTER TABLE Walmart ADD day_name VARCHAR(10);

UPDATE Walmart
SET day_name = FORMAT(date, 'dddd');

SELECT * FROM Walmart


-- Add month_name column
SELECT
	date,
	FORMAT(date, 'MMMM') AS month_name
FROM Walmart;

ALTER TABLE Walmart ADD month_name VARCHAR(10);

UPDATE Walmart
SET month_name = FORMAT(date, ',MMMM');

SELECT * FROM Walmart

----------------------------------------------------------------------
------------------------------ Generic ------------------------------
----------------------------------------------------------------------

-- Q1.How many unique cities does the data have?

SELECT 
DISTINCT City 
FROM Walmart

-- Q2.In which city is each branch?

SELECT 
DISTINCT City,
Branch
FROM Walmart
 

----------------------------------------------------------------------
------------------------------ Product -------------------------------
----------------------------------------------------------------------

-- Q1.How many unique product lines does the data have?

SELECT 
DISTINCT Product_line 
FROM Walmart

-- Q2.What is the most selling product line?

SELECT TOP 1
SUM(Quantity)AS Quantity,
Product_line 
FROM Walmart
GROUP BY Product_line
ORDER BY Quantity DESC

-- Q3.What is the total revenue by month?

SELECT
month_name,
SUM(Total)AS total_revenue 
FROM Walmart
GROUP BY month_name

-- Q4.What month had the largest COGS?

SELECT TOP 1
month_name,
SUM(cogs)AS cogs 
FROM Walmart 
GROUP BY month_name
ORDER BY cogs DESC

-- Q5.What product line had the largest revenue?

SELECT TOP 1
Product_line,
SUM(Total)AS total_revenue 
FROM Walmart 
GROUP BY Product_line
ORDER BY total_revenue DESC

-- Q6.What is the city with the largest revenue?

SELECT TOP 1
Branch,
City,
SUM(Total)AS total_revenue 
FROM Walmart 
GROUP BY City, Branch
ORDER BY total_revenue DESC

-- Q7.What product line had the largest VAT?

SELECT TOP 1
Product_line,
AVG(Tax_5)AS VAT
FROM Walmart 
GROUP BY Product_line
ORDER BY VAT DESC

-- Q8.Fetch each product line and add a column to those product 
--    line showing "Good", "Bad". Good if its greater than average sales

SELECT 
ROUND(AVG(Unit_price*Quantity),2) AS total_sales
FROM Walmart;

SELECT
Product_line,
ROUND(AVG(Unit_price*Quantity),2) AS total_sales,
CASE
     WHEN ROUND(AVG(Unit_price*Quantity),2) > 307.59 THEN 'Good'
	 ELSE 'Bad'
	 END
FROM Walmart
GROUP BY Product_line

-- Q9.Which branch sold more products than average product sold?

SELECT 
Branch,
SUM(Quantity)AS quantity
FROM Walmart
GROUP BY Branch
HAVING SUM(Quantity)> (SELECT AVG(Quantity)FROM Walmart)

-- Q10.What is the most common product line by gender?

SELECT
Gender,
Product_line,
COUNT(Gender) AS total_cnt
FROM Walmart
GROUP BY Product_line, Gender
ORDER BY total_cnt

-- Q11.What is the average rating of each product line?

SELECT
Product_line,
ROUND(AVG(Rating), 2) AS avg_rating
FROM Walmart
GROUP BY Product_line
ORDER BY avg_rating DESC


----------------------------------------------------------------------
--------------------------- Customers --------------------------------
----------------------------------------------------------------------

-- Q1.How many unique customer types does the data have?

SELECT 
DISTINCT Customer_type
FROM Walmart

-- Q2.How many unique payment methods does the data have?

SELECT 
DISTINCT Payment
FROM Walmart

-- Q3.What is the most common customer type?

SELECT
Customer_type,
COUNT(*) AS cont
FROM Walmart
GROUP BY Customer_type
ORDER BY cont 

-- Q4.Which customer type buys the most?

SELECT TOP 1
Customer_type,
COUNT(Quantity) AS qty
FROM Walmart
GROUP BY Customer_type
ORDER BY qty DESC

-- Q5.What is the gender of most of the customers?

SELECT
Gender,
COUNT(*) AS cnt
FROM Walmart
GROUP BY Gender
ORDER BY cnt DESC

-- Q6.What is the gender distribution per branch?

SELECT
distinct Branch,
Gender,
COUNT(Gender)AS cnt
FROM Walmart
GROUP BY Branch, Gender

-- Q7.Which time of the day do customers give most ratings?

SELECT 
time_of_day,
ROUND(AVG(Rating),2) AS avg_rating
FROM Walmart
GROUP BY time_of_day
ORDER BY avg_rating DESC

-- Q8.Which time of the day do customers give most ratings per branch?

SELECT
time_of_day,
Branch,
ROUND(AVG(Rating),2) AS avg_rating
FROM Walmart
GROUP BY time_of_day, Branch
ORDER BY Branch,avg_rating DESC
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.

-- Q9.Which day fo the week has the best avg ratings?

SELECT TOP 3
day_name,
ROUND(AVG(Rating),2) AS avg_rating
FROM Walmart
GROUP BY day_name
ORDER BY avg_rating DESC
-- Monday,Friday and Sunday are the top best days for good ratings

-- Q10.why is that the case, how many sales are made on these days?

SELECT TOP 3
day_name,
ROUND(AVG(Rating),2) AS avg_rating,
ROUND(AVG(Unit_price*Quantity),2) AS total_sales
FROM Walmart
GROUP BY day_name
ORDER BY avg_rating DESC


----------------------------------------------------------------------
------------------------------ Sales ---------------------------------
----------------------------------------------------------------------

-- Q1.Number of sales made in each time of the day per weekday?

SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM Walmart
WHERE day_name = 'Sunday'
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are filled during the evening hours.

-- Q2.Which of the customer types brings the most revenue?

SELECT
Customer_type,
ROUND(SUM(Total),2) AS total_revenue
FROM Walmart
GROUP BY Customer_type
ORDER BY total_revenue

-- Which city has the largest tax/VAT percent?

SELECT TOP 1
City,
ROUND(AVG(Tax_5),2)AS avg_tax
FROM Walmart
GROUP BY City
ORDER BY avg_tax

----------------------------------------------------------------------
----------------------------------------------------------------------