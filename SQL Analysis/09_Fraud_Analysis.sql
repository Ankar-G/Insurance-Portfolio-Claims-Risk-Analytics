/* Fraud Analysis
What this section answers
What percentage of claims are fraud-flagged?
Which claim types show more fraud flags?
Which policy/risk/customer segments have more fraud flags?
What is the financial value of fraud-flagged claims?
Which customers have repeated fraud flags? */

-- 1. Overall fraud summary
SELECT
    Fraud_Flag,
    COUNT(*) AS Total_Claims,
    SUM(Claim_Amount) AS Total_Claim_Amount,
    SUM(Approved_Amount) AS Total_Approved_Amount,
    AVG(Claim_Amount) AS Average_Claim_Amount
FROM Claims
GROUP BY Fraud_Flag
ORDER BY Total_Claims DESC;




-- 2. Fraud rate
SELECT
    COUNT(*) AS Total_Claims,
    SUM(CASE WHEN Fraud_Flag = 'Yes' THEN 1 ELSE 0 END) AS Fraud_Flagged_Claims,
    ROUND(
        SUM(CASE WHEN Fraud_Flag = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS Fraud_Rate_Pct
FROM Claims;




-- 3. Fraud by claim type
SELECT
    Claim_Type,
    COUNT(*) AS Total_Claims,
    SUM(CASE WHEN Fraud_Flag = 'Yes' THEN 1 ELSE 0 END) AS Fraud_Claims,
    ROUND(
        SUM(CASE WHEN Fraud_Flag = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS Fraud_Rate_Pct,
    SUM(CASE WHEN Fraud_Flag = 'Yes' THEN Claim_Amount ELSE 0 END) AS Fraud_Claim_Amount
FROM Claims
GROUP BY Claim_Type
ORDER BY Fraud_Rate_Pct DESC;




-- 4. Fraud by policy type
SELECT
    p.Policy_Type,
    COUNT(cl.Claim_ID) AS Total_Claims,
    SUM(CASE WHEN cl.Fraud_Flag = 'Yes' THEN 1 ELSE 0 END) AS Fraud_Claims,
    ROUND(
        SUM(CASE WHEN cl.Fraud_Flag = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(cl.Claim_ID), 0),
        2
    ) AS Fraud_Rate_Pct,
    SUM(
        CASE WHEN cl.Fraud_Flag = 'Yes'
        THEN cl.Claim_Amount ELSE 0 END
    ) AS Fraud_Claim_Amount
FROM Policies p
JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY p.Policy_Type
ORDER BY Fraud_Rate_Pct DESC;




-- 5. Fraud by risk category
SELECT
    p.Risk_Category,
    COUNT(cl.Claim_ID) AS Total_Claims,
    SUM(CASE WHEN cl.Fraud_Flag = 'Yes' THEN 1 ELSE 0 END) AS Fraud_Claims,
    ROUND(
        SUM(CASE WHEN cl.Fraud_Flag = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(cl.Claim_ID), 0),
        2
    ) AS Fraud_Rate_Pct
FROM Policies p
JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY p.Risk_Category
ORDER BY Fraud_Rate_Pct DESC;




-- 6. Fraud by customer segment
SELECT
    c.Customer_Segment,
    COUNT(cl.Claim_ID) AS Total_Claims,
    SUM(CASE WHEN cl.Fraud_Flag = 'Yes' THEN 1 ELSE 0 END) AS Fraud_Claims,
    ROUND(
        SUM(CASE WHEN cl.Fraud_Flag = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(cl.Claim_ID), 0),
        2
    ) AS Fraud_Rate_Pct,
    SUM(
        CASE WHEN cl.Fraud_Flag = 'Yes'
        THEN cl.Claim_Amount ELSE 0 END
    ) AS Fraud_Claim_Amount
FROM Customers c
JOIN Claims cl
    ON c.Customer_ID = cl.Customer_ID
GROUP BY c.Customer_Segment
ORDER BY Fraud_Rate_Pct DESC;




-- 7. Fraud by claim status
SELECT
    Claim_Status,
    COUNT(*) AS Total_Claims,
    SUM(CASE WHEN Fraud_Flag = 'Yes' THEN 1 ELSE 0 END) AS Fraud_Claims,
    SUM(
        CASE WHEN Fraud_Flag = 'Yes'
        THEN Claim_Amount ELSE 0 END
    ) AS Fraud_Claim_Amount
FROM Claims
GROUP BY Claim_Status
ORDER BY Fraud_Claims DESC;




-- 8. Top fraud-flagged claims
SELECT
    Claim_ID,
    Policy_ID,
    Customer_ID,
    Claim_Type,
    Claim_Amount,
    Approved_Amount,
    Claim_Status,
    Fraud_Flag
FROM Claims
WHERE Fraud_Flag = 'Yes'
ORDER BY Claim_Amount DESC
LIMIT 20;




-- 9. Fraud claim approval ratio
SELECT
    ROUND(SUM(Claim_Amount), 2) AS Fraud_Claim_Amount,
    ROUND(SUM(Approved_Amount), 2) AS Fraud_Approved_Amount,
    ROUND(
        SUM(Approved_Amount) * 100.0 /
        NULLIF(SUM(Claim_Amount), 0),
        2
    ) AS Fraud_Approval_Ratio_Pct
FROM Claims
WHERE Fraud_Flag = 'Yes';




-- 10. Customers with multiple fraud-flagged claims
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(cl.Claim_ID) AS Fraud_Claims,
    SUM(cl.Claim_Amount) AS Fraud_Claim_Amount
FROM Customers c
JOIN Claims cl
    ON c.Customer_ID = cl.Customer_ID
WHERE cl.Fraud_Flag = 'Yes'
GROUP BY c.Customer_ID, c.Customer_Name
HAVING COUNT(cl.Claim_ID) > 1
ORDER BY Fraud_Claims DESC;