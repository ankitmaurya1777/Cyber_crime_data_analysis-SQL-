# 🛡️ Cybersecurity Incidents in India: SQL Analysis

## 📌 Project Overview
This project involves a deep-dive data analysis of reported cybersecurity incidents across various cities and sectors in India. Using standard SQL, this repository answers complex business and analytical questions to uncover trends in financial losses, prevalent cyber threats (e.g., Phishing, Ransomware, Data Breaches), and regional vulnerability. 

This project serves as a demonstration of **advanced SQL querying techniques** for data manipulation and analytical reporting.

## 🗄️ Dataset Description
The analysis is based on the `cybersecurity_cases_india_combined.csv` dataset. The table schema includes the following key columns:
* `Year`: The year the incident occurred.
* `Day`: The day of the month.
* `Amount_Lost_INR`: The financial loss incurred due to the incident (in Indian Rupees).
* `Incident_Type`: The nature of the cyberattack (e.g., Phishing, Ransomware, Malware Attacks, Data Breach).
* `City`: The Indian city where the incident was reported.
* `Category`: The targeted sector (e.g., Corporate, Educational, Health, Government).

## 🛠️ SQL Techniques Demonstrated
This project heavily utilizes intermediate to advanced SQL features, including:
- **Data Aggregation & Grouping:** `SUM()`, `AVG()`, `COUNT()`, `MAX()`, `GROUP BY`, `HAVING`
- **Conditional Logic:** `CASE WHEN` statements for risk bucketing and targeted aggregations.
- **Common Table Expressions (CTEs):** Breaking down complex queries (e.g., Year-over-Year comparisons, Theoretical Matrix generation).
- **Window Functions:** - `RANK()` and `DENSE_RANK()` for top N analyses per partition.
  - `LAG()` for comparing chronological data points.
  - `SUM() OVER()` for calculating cumulative running totals and percentage contributions.
- **Advanced Joins:** `INNER JOIN`, `LEFT JOIN`, `CROSS JOIN`, and self-joins for complex relational analysis.
- **Subqueries:** Utilizing nested queries in `SELECT` and `WHERE` clauses.

## 📊 Key Analytical Insights Explored
The SQL script (`queries.sql`) answers 25 targeted questions, including but not limited to:
1. Identifying the specific incident type causing the highest overall financial damage.
2. Categorizing incidents into 'High', 'Medium', and 'Low' loss buckets.
3. Calculating the running cumulative total of financial losses for specific cities over time.
4. Comparing the financial loss of consecutive incidents within the same sector to identify patterns.
5. Determining the percentage contribution of individual cyberattacks to the total yearly loss.
6. Generating Year-over-Year (YoY) loss comparisons for different cities using joined CTEs.
7. Finding "safe zones" by cross-joining distinct cities and threats to find combinations with zero recorded cases.

## 🚀 How to Run the Project
1. **Database Setup:** * Create a new database in your SQL environment (e.g., MySQL, PostgreSQL).
   ```sql
   CREATE DATABASE cyber_security;
   USE cyber_security;
