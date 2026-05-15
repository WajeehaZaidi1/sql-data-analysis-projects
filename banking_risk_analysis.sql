-- =============================================
-- PROJECT 2: Banking Transaction Risk Analysis
-- Author: [Tumhara Naam]
-- Date: May 2026
-- Tools: MySQL
-- Description: AML (Anti Money Laundering)
-- analysis to identify high risk customers
-- based on transaction patterns
-- =============================================

-- ---- SETUP ----
CREATE TABLE customers (
    customer_id INT,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    age INT
);

-- [Baaki sara setup code]

-- ---- RISK ANALYSIS QUERY ----
WITH customer_summary AS (
    SELECT
        customers.customer_name,
        customers.city,
        SUM(transactions.amount) AS total_transactions,
        COUNT(transactions.transaction_id) AS total_activity
    FROM customers
    JOIN accounts ON customers.customer_id = accounts.customer_id
    JOIN transactions ON accounts.account_id = transactions.account_id
    GROUP BY customers.customer_name, customers.city
)
SELECT
    customer_name,
    city,
    total_transactions,
    total_activity,
    CASE
        WHEN total_transactions >= 400000 THEN 'Very High Risk'
        WHEN total_transactions >= 200000 THEN 'High Risk'
        ELSE 'Normal'
    END AS customer_risk,
    RANK() OVER (
        ORDER BY total_transactions DESC
    ) AS risk_rank
FROM customer_summary;
