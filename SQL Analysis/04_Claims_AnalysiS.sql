/* Claims Analysis - how many claims the insurer receives, how much is being claimed/approved, 
which policy and customer segments generate claims, and where the largest claims are occurring.*/




-- 1. Total claims
SELECT 
    COUNT(*) AS Total_Claims
FROM Claims;



-- 2. Claims by status
SELECT
    Claim_Status,
    COUNT(*) AS Total_Claims,
    SUM(Claim_Amount) AS Total_Claim_Amount,
    SUM(Approved_Amount) AS Total_Approved_Amount
FROM Claims
GROUP BY Claim_Status
ORDER BY Total_Claims DESC;





-- 3. Claims by claim type
SELECT
    Claim_Type,
    COUNT(*) AS Total_Claims,
    SUM(Claim_Amount) AS Total_Claim_Amount,
    SUM(Approved_Amount) AS Total_Approved_Amount,
    AVG(Claim_Amount) AS Average_Claim_Amount
FROM Claims
GROUP BY Claim_Type
ORDER BY Total_Claim_Amount DESC;




-- 4. Total claims and approved amounts
SELECT
    COUNT(*) AS Total_Claims,
    SUM(Claim_Amount) AS Total_Claim_Amount,
    SUM(Approved_Amount) AS Total_Approved_Amount,
    AVG(Claim_Amount) AS Average_Claim_Amount,
    AVG(Approved_Amount) AS Average_Approved_Amount
FROM Claims;





-- 5. Claims by policy type
SELECT
    p.Policy_Type,
    COUNT(cl.Claim_ID) AS Total_Claims,
    SUM(cl.Claim_Amount) AS Total_Claim_Amount,
    SUM(cl.Approved_Amount) AS Total_Approved_Amount
FROM Claims cl
JOIN Policies p
    ON cl.Policy_ID = p.Policy_ID
GROUP BY p.Policy_Type
ORDER BY Total_Claim_Amount DESC;




-- 6. Claims by risk category
SELECT
    p.Risk_Category,
    COUNT(cl.Claim_ID) AS Total_Claims,
    SUM(cl.Claim_Amount) AS Total_Claim_Amount,
    SUM(cl.Approved_Amount) AS Total_Approved_Amount
FROM Claims cl
JOIN Policies p
    ON cl.Policy_ID = p.Policy_ID
GROUP BY p.Risk_Category
ORDER BY Total_Claims DESC;




-- 7. Claims by customer segment
SELECT
    c.Customer_Segment,
    COUNT(cl.Claim_ID) AS Total_Claims,
    SUM(cl.Claim_Amount) AS Total_Claim_Amount,
    SUM(cl.Approved_Amount) AS Total_Approved_Amount
FROM Claims cl
JOIN Customers c
    ON cl.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Segment
ORDER BY Total_Claim_Amount DESC;




-- 8. Top 10 largest claims
SELECT
    Claim_ID,
    Policy_ID,
    Customer_ID,
    Claim_Type,
    Claim_Amount,
    Approved_Amount,
    Claim_Status
FROM Claims
ORDER BY Claim_Amount DESC
LIMIT 10;




-- 9. Claim approval percentage
SELECT
    ROUND(
        SUM(Approved_Amount) * 100.0 /
        NULLIF(SUM(Claim_Amount), 0),
        2
    ) AS Overall_Approval_Rate_Pct
FROM Claims;




-- 10. Claims by fraud flag
SELECT
    Fraud_Flag,
    COUNT(*) AS Total_Claims,
    SUM(Claim_Amount) AS Total_Claim_Amount,
    SUM(Approved_Amount) AS Total_Approved_Amount
FROM Claims
GROUP BY Fraud_Flag
ORDER BY Total_Claims DESC;