/* Customer Risk Analysis
This section helps answer:

Which customer segments generate the most claims?
Which age/income groups have higher claim activity?
Which occupations have higher claim amounts?
Which customers have repeated or high-value claims?
Where should the insurer focus risk assessment and monitoring? */


-- 1. Customer risk overview
SELECT
    c.Customer_Segment,
    COUNT(DISTINCT c.Customer_ID) AS Total_Customers,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claims_Amount
FROM Customers c
LEFT JOIN Policies p
    ON c.Customer_ID = p.Customer_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY c.Customer_Segment
ORDER BY Total_Claims_Amount DESC;





-- 2. Claims by age group
SELECT
    CASE
        WHEN c.Age < 25 THEN 'Under 25'
        WHEN c.Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN c.Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN c.Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS Age_Group,
    COUNT(DISTINCT c.Customer_ID) AS Total_Customers,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claim_Amount,
    ROUND(AVG(cl.Claim_Amount), 2) AS Average_Claim_Amount
FROM Customers c
LEFT JOIN Policies p
    ON c.Customer_ID = p.Customer_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY Age_Group
ORDER BY Total_Claim_Amount DESC;




-- 3. Customer income vs claims
SELECT
    CASE
        WHEN c.Income < 300000 THEN 'Low Income'
        WHEN c.Income < 700000 THEN 'Middle Income'
        WHEN c.Income < 1500000 THEN 'High Income'
        ELSE 'Very High Income'
    END AS Income_Group,
    COUNT(DISTINCT c.Customer_ID) AS Total_Customers,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claim_Amount
FROM Customers c
LEFT JOIN Policies p
    ON c.Customer_ID = p.Customer_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY Income_Group
ORDER BY Total_Claim_Amount DESC;




-- 4. Claims by occupation
SELECT
    c.Occupation,
    COUNT(DISTINCT c.Customer_ID) AS Total_Customers,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claim_Amount,
    ROUND(AVG(cl.Claim_Amount), 2) AS Average_Claim_Amount
FROM Customers c
LEFT JOIN Policies p
    ON c.Customer_ID = p.Customer_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY c.Occupation
ORDER BY Total_Claim_Amount DESC;




-- 5. Claims by gender
SELECT
    c.Gender,
    COUNT(DISTINCT c.Customer_ID) AS Total_Customers,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claim_Amount
FROM Customers c
LEFT JOIN Policies p
    ON c.Customer_ID = p.Customer_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY c.Gender;





-- 6. Claims by marital status
SELECT
    c.Marital_Status,
    COUNT(DISTINCT c.Customer_ID) AS Total_Customers,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claim_Amount
FROM Customers c
LEFT JOIN Policies p
    ON c.Customer_ID = p.Customer_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY c.Marital_Status
ORDER BY Total_Claim_Amount DESC;




-- 7. High-claim customers
SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment,
    c.Age,
    c.Income,
    COUNT(cl.Claim_ID) AS Total_Claims,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claim_Amount,
    ROUND(AVG(cl.Claim_Amount), 2) AS Average_Claim_Amount
FROM Customers c
JOIN Claims cl
    ON c.Customer_ID = cl.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment,
    c.Age,
    c.Income
ORDER BY Total_Claim_Amount DESC
LIMIT 20;




-- 8. Customers with multiple claims
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(cl.Claim_ID) AS Number_of_Claims,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claim_Amount
FROM Customers c
JOIN Claims cl
    ON c.Customer_ID = cl.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
HAVING COUNT(cl.Claim_ID) > 1
ORDER BY Number_of_Claims DESC;




-- 9. Customer-level claim frequency
SELECT
    c.Customer_Segment,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(
        COUNT(DISTINCT cl.Claim_ID) * 100.0 /
        NULLIF(COUNT(DISTINCT p.Policy_ID), 0),
        2
    ) AS Claim_Frequency_Pct
FROM Customers c
JOIN Policies p
    ON c.Customer_ID = p.Customer_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY c.Customer_Segment
ORDER BY Claim_Frequency_Pct DESC;





-- 10. Customer risk profile
SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment,
    c.Age,
    c.Income,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(COALESCE(SUM(cl.Claim_Amount), 0), 2) AS Total_Claim_Amount
FROM Customers c
LEFT JOIN Policies p
    ON c.Customer_ID = p.Customer_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment,
    c.Age,
    c.Income
ORDER BY Total_Claim_Amount DESC;



