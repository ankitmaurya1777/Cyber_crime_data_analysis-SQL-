CREATE  DATABASE cyber_security;

USE cyber_security;








-- 1. Write a query to retrieve all records from the `cybersecurity_incidents` table.

SELECT*FROM cybersecurity_cases_india_combined;





-- 2. Find all incidents that occurred specifically in 'Bangalore'.

SELECT City, Incident_Type FROM cybersecurity_cases_india_combined
WHERE City = "Bangalore";
-- 3. List all the unique `Incident_Type`s present in the dataset.

SELECT Incident_Type 
FROM cybersecurity_cases_india_combined
GROUP BY Incident_Type;


-- 4. Retrieve the top 10 incidents with the highest `Amount_Lost_INR`, sorted in descending order.

SELECT Incident_Type, MAX(Amount_Lost_INR) AS max_amount_lost 
FROM cybersecurity_cases_india_combined
GROUP BY Incident_Type
ORDER BY MAX(Amount_Lost_INR) DESC
LIMIT 10;


-- 5. Find all 'Phishing' incidents that happened in the year 2023
--  where the amount lost was strictly greater than 200,000 INR.

SELECT Year, Incident_Type, Amount_Lost_INR 
FROM cybersecurity_cases_india_combined
WHERE Year = "2023" AND Incident_Type = "Phishing"
AND Amount_Lost_INR > "200000"; 
 
-- 6. Calculate the total `Amount_Lost_INR` across all incidents in the dataset.

SELECT Incident_Type , SUM(Amount_Lost_INR) AS total_amount
FROM cybersecurity_cases_india_combined
GROUP BY Incident_Type
ORDER BY SUM(Amount_Lost_INR) DESC; 



-- 7. Find the total number of cybersecurity incidents reported in each `City`.

SELECT City , COUNT(*) AS total_incidents
FROM cybersecurity_cases_india_combined
GROUP BY City
ORDER BY COUNT(*) DESC;

-- 8. Calculate the average `Amount_Lost_INR` for each targeted `Category` (e.g., Corporate, Health).

SELECT Category, AVG(Amount_Lost_INR) AS avg_lost
FROM cybersecurity_cases_india_combined
GROUP BY Category
ORDER BY AVG(Amount_Lost_INR);



-- 9. Find the `City` and `Year` combinations that had more than 50 recorded incidents.

SELECT Year, City, COUNT(*) AS total_incidents
FROM cybersecurity_cases_india_combined
GROUP BY City
HAVING COUNT(*) > 50;


-- 10. Identify the single `Incident_Type` that caused the highest total financial loss across the entire dataset.
SELECT Incident_Type, SUM(Amount_Lost_INR) AS total_financial_loss
FROM cybersecurity_cases_india_combined
GROUP BY Incident_Type
ORDER BY SUM(Amount_Lost_INR) DESC
LIMIT 1;

-- 11. Categorize incidents into 'High Loss' (> 300,000 INR), 'Medium Loss' (100,000 - 300,000 INR), and 'Low Loss' (< 100,000 INR) using a CASE statement. Count how many incidents fall into each bucket.
SELECT 
    CASE 
        WHEN Amount_Lost_INR > 300000 THEN 'High Loss'
        WHEN Amount_Lost_INR BETWEEN 100000 AND 300000 THEN 'Medium Loss'
        ELSE 'Low Loss' 
    END AS Loss_Category,
    COUNT(*) AS incident_count
FROM cybersecurity_cases_india_combined
GROUP BY 
    CASE 
        WHEN Amount_Lost_INR > 300000 THEN 'High Loss'
        WHEN Amount_Lost_INR BETWEEN 100000 AND 300000 THEN 'Medium Loss'
        ELSE 'Low Loss' 
    END;

-- 12. Create a query that returns the `City` and a newly derived column called `Risk_Level`. Use CASE WHEN to assign 'Critical' to Data Breaches and Ransomware, 'High' to Phishing, and 'Moderate' to everything else.
SELECT 
    City, 
    Incident_Type,
    CASE 
        WHEN Incident_Type IN ('Data Breach', 'Ransomware') THEN 'Critical'
        WHEN Incident_Type = 'Phishing' THEN 'High'
        ELSE 'Moderate' 
    END AS Risk_Level
FROM cybersecurity_cases_india_combined;

-- 13. Calculate the total amount lost for 'Data Breach' compared to 'All Other Incidents' using a CASE WHEN inside a SUM() function.
SELECT 
    SUM(CASE WHEN Incident_Type = 'Data Breach' THEN Amount_Lost_INR ELSE 0 END) AS data_breach_loss,
    SUM(CASE WHEN Incident_Type != 'Data Breach' THEN Amount_Lost_INR ELSE 0 END) AS all_other_loss
FROM cybersecurity_cases_india_combined;

-- 14. Find all incidents where the `Amount_Lost_INR` is strictly greater than the overall average amount lost across all years.
SELECT *
FROM cybersecurity_cases_india_combined
WHERE Amount_Lost_INR > (SELECT AVG(Amount_Lost_INR) FROM cybersecurity_cases_india_combined);

-- 15. Use a CTE to find the average loss per `Incident_Type`, and then write a main query that selects only those incident types whose average loss exceeds 250,000 INR.
WITH AvgLossCTE AS (
    SELECT Incident_Type, AVG(Amount_Lost_INR) AS avg_loss
    FROM cybersecurity_cases_india_combined
    GROUP BY Incident_Type
)
SELECT Incident_Type, avg_loss
FROM AvgLossCTE
WHERE avg_loss > 250000;

-- 16. Write a query using a subquery in the SELECT clause to show each incident's `Amount_Lost_INR` alongside the maximum amount lost in its respective `City` for comparison.
SELECT 
    City, 
    Incident_Type, 
    Amount_Lost_INR, 
    (SELECT MAX(Amount_Lost_INR) 
     FROM cybersecurity_cases_india_combined c2 
     WHERE c2.City = c1.City) AS max_loss_in_city
FROM cybersecurity_cases_india_combined c1;

-- 17. Use a CTE to calculate the total number of incidents per `Year`. Query the CTE to find the year with the maximum number of incidents.
WITH YearlyIncidents AS (
    SELECT Year, COUNT(*) AS total_incidents
    FROM cybersecurity_cases_india_combined
    GROUP BY Year
)
SELECT Year, total_incidents
FROM YearlyIncidents
ORDER BY total_incidents DESC
LIMIT 1;

-- 18. Rank the incidents within each `City` based on `Amount_Lost_INR` in descending order using RANK().
SELECT 
    City, 
    Incident_Type, 
    Amount_Lost_INR, 
    RANK() OVER (PARTITION BY City ORDER BY Amount_Lost_INR DESC) AS rank_in_city
FROM cybersecurity_cases_india_combined;

-- 19. Calculate the running cumulative total of `Amount_Lost_INR` for the city of 'Mumbai', ordered chronologically by `Year` and `Day`.
SELECT 
    Year, 
    Day, 
    Incident_Type, 
    Amount_Lost_INR, 
    SUM(Amount_Lost_INR) OVER (ORDER BY Year, Day) AS cumulative_total
FROM cybersecurity_cases_india_combined
WHERE City = 'Mumbai';

-- 20. Find the top 3 costliest incidents in each `Category` using the DENSE_RANK() window function.
WITH RankedCategories AS (
    SELECT 
        Category, 
        Incident_Type, 
        Amount_Lost_INR, 
        DENSE_RANK() OVER (PARTITION BY Category ORDER BY Amount_Lost_INR DESC) AS rnk
    FROM cybersecurity_cases_india_combined
)
SELECT Category, Incident_Type, Amount_Lost_INR
FROM RankedCategories
WHERE rnk <= 3;

-- 21. Use the LAG() function to compare the `Amount_Lost_INR` of each incident in the 'Corporate' category with the previous incident (ordered by Year and Day). Find the difference between them.
SELECT 
    Year, 
    Day, 
    Amount_Lost_INR, 
    LAG(Amount_Lost_INR) OVER (ORDER BY Year, Day) AS prev_amount,
    Amount_Lost_INR - LAG(Amount_Lost_INR) OVER (ORDER BY Year, Day) AS difference
FROM cybersecurity_cases_india_combined
WHERE Category = 'Corporate';

-- 22. Calculate the percentage contribution of each individual incident's loss to the total loss in its respective `Year` using SUM() OVER(PARTITION BY Year).
SELECT 
    Year, 
    Incident_Type, 
    Amount_Lost_INR, 
    SUM(Amount_Lost_INR) OVER (PARTITION BY Year) AS total_year_loss,
    (Amount_Lost_INR * 100.0 / SUM(Amount_Lost_INR) OVER (PARTITION BY Year)) AS percentage_contribution
FROM cybersecurity_cases_india_combined;

-- 23. Find pairs of incidents (return their Amount_Lost and Day) that occurred in the same `City` and `Year`, share the exact same `Incident_Type`, but occurred on different `Day`s.
SELECT 
    a.City, 
    a.Year, 
    a.Incident_Type, 
    a.Day AS Day_1, 
    a.Amount_Lost_INR AS Amount_1, 
    b.Day AS Day_2, 
    b.Amount_Lost_INR AS Amount_2
FROM cybersecurity_cases_india_combined a
JOIN cybersecurity_cases_india_combined b 
  ON a.City = b.City 
 AND a.Year = b.Year 
 AND a.Incident_Type = b.Incident_Type 
 AND a.Day < b.Day; -- "<" prevents duplicate pairings (e.g. comparing A to B and B to A) and matching with itself.

-- 24. Create two CTEs: one containing total financial losses by `City` in 2022, and another for total losses by `City` in 2023. INNER JOIN these CTEs on the City name to show: `City`, `Loss_2022`, `Loss_2023`, and the numerical difference between the two years.
WITH Loss2022 AS (
    SELECT City, SUM(Amount_Lost_INR) AS total_2022
    FROM cybersecurity_cases_india_combined
    WHERE Year = 2022
    GROUP BY City
),
Loss2023 AS (
    SELECT City, SUM(Amount_Lost_INR) AS total_2023
    FROM cybersecurity_cases_india_combined
    WHERE Year = 2023
    GROUP BY City
)
SELECT 
    L22.City, 
    L22.total_2022 AS Loss_2022, 
    L23.total_2023 AS Loss_2023, 
    (L23.total_2023 - L22.total_2022) AS loss_difference
FROM Loss2022 L22
INNER JOIN Loss2023 L23 
    ON L22.City = L23.City;

-- 25. Generate a theoretical combination of all distinct `City`s and all distinct `Incident_Type`s using a CROSS JOIN. Then, LEFT JOIN this result back to your main table to find out if there are any City-Incident combinations that have zero recorded cases in the dataset.
WITH AllCities AS (
    SELECT DISTINCT City FROM cybersecurity_cases_india_combined
),
AllIncidents AS (
    SELECT DISTINCT Incident_Type FROM cybersecurity_cases_india_combined
),
TheoreticalMatrix AS (
    SELECT C.City, I.Incident_Type
    FROM AllCities C
    CROSS JOIN AllIncidents I
)
SELECT 
    TM.City, 
    TM.Incident_Type,
    COUNT(T.Amount_Lost_INR) AS recorded_cases
FROM TheoreticalMatrix TM
LEFT JOIN cybersecurity_cases_india_combined T 
    ON TM.City = T.City AND TM.Incident_Type = T.Incident_Type
GROUP BY TM.City, TM.Incident_Type
HAVING COUNT(T.Amount_Lost_INR) = 0;