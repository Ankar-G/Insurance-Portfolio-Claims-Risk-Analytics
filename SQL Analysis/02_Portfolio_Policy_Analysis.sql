/* Portfolio & Policy Analysis - ( what the insurance portfolio looks like, where the policies are concentrated,
how much premium is generated, and what types of customers/policies dominate the portfolio. */


-- 1. Total policies
SELECT COUNT(*) AS Total_Policies
FROM Policies;



-- 2. Policies by policy type
SELECT * FROM POLICIES;
SELECT POLICY_TYPE, COUNT(*) AS TOTAL_POLICIES
FROM POLICIES
GROUP BY POLICY_TYPE
ORDER BY TOTAL_POLICIES DESC;



-- 3. Policies by status
SELECT 
    Policy_Status,
    COUNT(*) AS Total_Policies
FROM Policies
GROUP BY Policy_Status
ORDER BY Total_Policies DESC;



-- 4. Policies by risk category
SELECT 
    Risk_Category,
    COUNT(*) AS Total_Policies
FROM Policies
GROUP BY Risk_Category
ORDER BY Total_Policies DESC;



-- 5. Total premium and average premium by policy type
SELECT 
    Policy_Type,
    COUNT(*) AS Total_Policies,
    SUM(Premium_Amount) AS Total_Premium,
    AVG(Premium_Amount) AS Average_Premium
FROM Policies
GROUP BY Policy_Type
ORDER BY Total_Premium DESC;



-- 6. Total sum assured by policy type
SELECT 
    Policy_Type,
    SUM(Sum_Assured) AS Total_Sum_Assured,
    AVG(Sum_Assured) AS Average_Sum_Assured
FROM Policies
GROUP BY Policy_Type
ORDER BY Total_Sum_Assured DESC;



-- 7. Policies by payment frequency
SELECT 
    Payment_Frequency,
    COUNT(*) AS Total_Policies
FROM Policies
GROUP BY Payment_Frequency
ORDER BY Total_Policies DESC;



-- 8. Policies by acquisition channel
SELECT 
    Acquisition_Channel,
    COUNT(*) AS Total_Policies
FROM Policies
GROUP BY Acquisition_Channel
ORDER BY Total_Policies DESC;




-- 9. Policies by customer segment
SELECT 
    c.Customer_Segment,
    COUNT(p.Policy_ID) AS Total_Policies
FROM Policies p
JOIN Customers c 
    ON p.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Segment
ORDER BY Total_Policies DESC;




-- 10. Policy portfolio summary
SELECT
    COUNT(*) AS Total_Policies,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    SUM(Premium_Amount) AS Total_Premium,
    AVG(Premium_Amount) AS Average_Premium,
    SUM(Sum_Assured) AS Total_Sum_Assured,
    AVG(Sum_Assured) AS Average_Sum_Assured
FROM Policies;