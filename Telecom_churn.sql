SELECT * FROM telecome

-- Creating a new column name 'Age_group' 
SELECT
    *,
    CASE
        WHEN Age BETWEEN 19 AND 28 THEN '19-28'
        WHEN Age BETWEEN 29 AND 38 THEN '29-38'
        WHEN Age BETWEEN 39 AND 48 THEN '39-48'
        WHEN Age BETWEEN 49 AND 58 THEN '49-58'
        WHEN Age BETWEEN 59 AND 68 THEN '59-68'
        WHEN Age BETWEEN 69 AND 78 THEN '69-78'
        WHEN Age BETWEEN 79 AND 88 THEN '79-88'
        ELSE 'Other'
    END AS Age_Group
FROM 
    telecome;



-- Q.1 How many customers joined the company? Based on their Demographic.
-- BY GENDER
SELECT Gender, COUNT(Customer_ID) AS total_customers, CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS Percentage
FROM telecome
WHERE Customer_Status = 'Joined'
GROUP BY Gender;

-- BY AGE
SELECT
  age_group,
  COUNT(*) AS counts
FROM (
  SELECT
    CASE
      WHEN Age BETWEEN 19 AND 28 THEN '19-28'
      WHEN Age BETWEEN 29 AND 38 THEN '29-38'
      WHEN Age BETWEEN 39 AND 48 THEN '39-48'
      WHEN Age BETWEEN 49 AND 58 THEN '49-58'
      WHEN Age BETWEEN 59 AND 68 THEN '59-68'
      WHEN Age BETWEEN 69 AND 78 THEN '69-78'
      WHEN Age BETWEEN 79 AND 88 THEN '79-88'
    END AS age_group
  FROM telecome
  WHERE Customer_Status = 'Joined'
) AS subquery
GROUP BY age_group;

-- BY CUSTOMER STATUS
SELECT Customer_Status, COUNT(Avg_Monthly_GB_Download) AS counts
FROM telecome
GROUP BY Customer_Status;

-- BY INTERNET SERVICES
SELECT Internet_Service, COUNT(Customer_ID) AS total_customer
FROM telecome
WHERE Customer_Status = 'Joined'
GROUP BY Internet_Service;

-- BY UNLIMITED DATA
SELECT Unlimited_Data, COUNT(Customer_ID) AS counts
FROM telecome
WHERE Customer_Status = 'Joined'
GROUP BY Unlimited_Data;

-- BY CITY
SELECT City, COUNT(Customer_ID) AS counts
FROM telecome
WHERE Customer_Status = 'Joined'
GROUP BY City 
ORDER BY counts DESC;



-- Q.2 What is the customer profile for a customer that churned, joined, and stayed? Are they different?
-- BY - Gender, Internet services, Avg Revenue, Avg GB consumed, Unlimited data

SELECT
    Gender,
    SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS Churned,
    SUM(CASE WHEN Customer_Status = 'Joined' THEN 1 ELSE 0 END) AS Joined,
    SUM(CASE WHEN Customer_Status = 'Stayed' THEN 1 ELSE 0 END) AS Stayed,
    COUNT(Customer_ID) AS Total,  CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS Percentage
FROM telecome
GROUP BY Gender
ORDER BY Gender;

-- BY Internet Services
SELECT 
    Internet_Service,
    SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS Churned,
    SUM(CASE WHEN Customer_Status = 'Joined' THEN 1 ELSE 0 END) AS Joined,
    SUM(CASE WHEN Customer_Status = 'Stayed' THEN 1 ELSE 0 END) AS Stayed,
    COUNT(Customer_ID) AS Total
FROM telecome
GROUP BY Internet_Service
ORDER BY Internet_Service;

-- BY Avg Revenue
SELECT Customer_Status, ROUND(AVG(Total_Revenue), 2) AS Avg_revenue
FROM telecome
GROUP BY Customer_Status;

-- BY Avg monthly GB consumed
SELECT Customer_Status, SUM(Avg_Monthly_GB_Download) AS Total_GB
FROM telecome
GROUP BY Customer_Status;

-- BY Unlimited Data
SELECT 
    Unlimited_Data,
	SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS Churned,
	SUM(CASE WHEN Customer_Status = 'Joined' THEN 1 ELSE 0 END) AS Joined,
	SUM(CASE WHEN Customer_Status = 'Stayed' THEN 1 ELSE 0 END) AS Stayed,
	COUNT(Customer_ID) AS Total
FROM telecome
GROUP BY Unlimited_Data
ORDER BY Unlimited_Data;


-- Q.3 What seems to be the key drivers of customer churn?
SELECT Churn_Category, COUNT(Churn_Reason) AS churn_count, CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS Percentage
FROM telecome
GROUP BY Churn_Category;


-- Q.4 Is the company losing high value customers? If so, how can they retain them?
SELECT Customer_Status, COUNT(Churn_Category) AS total_category, SUM(Total_Revenue) AS total_rev
FROM telecome
GROUP BY Customer_Status
ORDER BY total_category, total_rev;

SELECT Churn_Category, SUM(Total_Revenue) AS total_reve
FROM telecome
GROUP BY Churn_Category;


-- Q.5 Out of the 3 customer statuses, stayed, churned, and joined which has the highest %?
SELECT 
    Customer_Status,
    COUNT(*) AS Count_of_Customer_Status,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS Percentage
FROM telecome
GROUP BY Customer_Status
ORDER BY Customer_Status;


-- Q.6 What payment method was preferred by churned users?
SELECT Payment_Method, COUNT(*) AS status_count, CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS percentage
FROM telecome
WHERE Customer_Status = 'Churned'
GROUP BY Payment_Method;


-- Q.7 What are the top 12 cities that churned?
SELECT TOP (12) City, COUNT(*) AS stats_count, CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS Percentage
FROM telecome
WHERE Customer_Status = 'Churned'
GROUP BY City
ORDER BY stats_count DESC;


-- Q.8 What churn offers were preferable by the customers?
SELECT Offer, COUNT(Customer_Status) AS counts, CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS Percentage
FROM telecome
WHERE Customer_Status = 'Churned'
GROUP BY Offer;


select * from telecome