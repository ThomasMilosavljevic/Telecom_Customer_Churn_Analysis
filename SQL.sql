-- Overall Churn Rate 
SELECT 
    "Customer Status",
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_churn), 1) AS percentage
FROM customer_churn
GROUP BY "Customer Status"; 

-- Churn Rate by Contract Type 
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_rate_percentage
FROM customer_churn
GROUP BY Contract
ORDER BY churn_rate_percentage DESC;
  
-- Churn Rate by Internet Type 
SELECT 
    "Internet Type",
    COUNT(*) AS total_customers,
    SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_rate_percentage
FROM customer_churn
GROUP BY "Internet Type"
ORDER BY churn_rate_percentage DESC;
  
-- Churn Rate by Premium Tech Support
SELECT 
    "Premium Tech Support",
    COUNT(*) AS total_customers,
    SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_rate_percentage
FROM customer_churn
WHERE "Internet Service" = 'Yes'
GROUP BY "Premium Tech Support";
  
-- Top 10 Churn Reasons 
SELECT 
    "Churn Reason",
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_churn WHERE "Customer Status" = 'Churned'), 1) AS pct_of_churned
FROM customer_churn
WHERE "Customer Status" = 'Churned'
GROUP BY "Churn Reason"
ORDER BY customer_count DESC
LIMIT 10;
 
-- Revenue Lost to Churn
SELECT 
    ROUND(SUM(CASE WHEN "Customer Status" = 'Churned' THEN "Monthly Charge" ELSE 0 END), 2) AS monthly_revenue_lost,
    ROUND(SUM(CASE WHEN "Customer Status" = 'Churned' THEN "Total Revenue" ELSE 0 END), 2) AS total_revenue_lost,
    ROUND(AVG(CASE WHEN "Customer Status" = 'Churned' THEN "Monthly Charge" END), 2) AS avg_monthly_charge_churned,
    ROUND(AVG(CASE WHEN "Customer Status" = 'Stayed' THEN "Monthly Charge" END), 2) AS avg_monthly_charge_stayed
FROM customer_churn;
 
-- Churn Rate by Tenure Group
SELECT 
    CASE 
        WHEN "Tenure in Months" <= 6 THEN '0-6 months'
        WHEN "Tenure in Months" <= 12 THEN '7-12 months'
        WHEN "Tenure in Months" <= 24 THEN '13-24 months'
        WHEN "Tenure in Months" <= 48 THEN '25-48 months'
        ELSE '48+ months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_rate_percentage
FROM customer_churn
GROUP BY tenure_group
ORDER BY churn_rate_percentage DESC;
 
--Top 10 Cities by Churn Volume
SELECT 
    City,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_rate_percentage
FROM customer_churn
GROUP BY City
HAVING total_customers >= 30
ORDER BY churned DESC
LIMIT 10;
  
--Churn by Location for Geographic Map 
SELECT 
    City, "Zip Code", Latitude, Longitude,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_rate_percentage
FROM customer_churn
GROUP BY City, "Zip Code", Latitude, Longitude
HAVING total_customers >= 5
ORDER BY churned DESC;
 
