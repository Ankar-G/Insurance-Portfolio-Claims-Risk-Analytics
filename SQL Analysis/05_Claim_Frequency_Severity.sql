-- Claim Frequency & Severity - ( the core insurance risk measures: frequency + severity )


-- 1. Overall claim frequency
SELECT
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    ROUND(
        COUNT(DISTINCT cl.Claim_ID) * 100.0 /
        NULLIF(COUNT(DISTINCT p.Policy_ID), 0),
        2
    ) AS Claim_Frequency_Pct
FROM Policies p
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID;
    
    
    

-- 2. Claim frequency by policy type
SELECT
    p.Policy_Type,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(
        COUNT(DISTINCT cl.Claim_ID) * 100.0 /
        NULLIF(COUNT(DISTINCT p.Policy_ID), 0),
        2
    ) AS Claim_Frequency_Pct
FROM Policies p
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY p.Policy_Type
ORDER BY Claim_Frequency_Pct DESC;




-- 3. Average claim severity
SELECT
    AVG(Claim_Amount) AS Average_Claim_Severity
FROM Claims;




-- 4. Claim severity by policy type
SELECT
    p.Policy_Type,
    COUNT(cl.Claim_ID) AS Total_Claims,
    AVG(cl.Claim_Amount) AS Average_Claim_Severity,
    MAX(cl.Claim_Amount) AS Maximum_Claim
FROM Claims cl
JOIN Policies p
    ON cl.Policy_ID = p.Policy_ID
GROUP BY p.Policy_Type
ORDER BY Average_Claim_Severity DESC;




-- 5. Claim severity by risk category
SELECT
    p.Risk_Category,
    COUNT(cl.Claim_ID) AS Total_Claims,
    AVG(cl.Claim_Amount) AS Average_Claim_Severity,
    MAX(cl.Claim_Amount) AS Maximum_Claim
FROM Claims cl
JOIN Policies p
    ON cl.Policy_ID = p.Policy_ID
GROUP BY p.Risk_Category
ORDER BY Average_Claim_Severity DESC;




-- 6. Claim frequency by risk category
SELECT
    p.Risk_Category,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(
        COUNT(DISTINCT cl.Claim_ID) * 100.0 /
        NULLIF(COUNT(DISTINCT p.Policy_ID), 0),
        2
    ) AS Claim_Frequency_Pct
FROM Policies p
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY p.Risk_Category
ORDER BY Claim_Frequency_Pct DESC;




-- 7. Claim severity by customer segment
SELECT
    c.Customer_Segment,
    COUNT(cl.Claim_ID) AS Total_Claims,
    AVG(cl.Claim_Amount) AS Average_Claim_Severity,
    SUM(cl.Claim_Amount) AS Total_Claim_Amount
FROM Claims cl
JOIN Customers c
    ON cl.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Segment
ORDER BY Average_Claim_Severity DESC;




-- 8. High-severity claims
SELECT
    Claim_ID,
    Policy_ID,
    Claim_Type,
    Claim_Amount,
    Approved_Amount
FROM Claims
WHERE Claim_Amount >= (
    SELECT AVG(Claim_Amount) * 2
    FROM Claims
)
ORDER BY Claim_Amount DESC;




-- 9. Claim-to-approved amount ratio
SELECT
    Claim_Type,
    ROUND(
        SUM(Approved_Amount) * 100.0 /
        NULLIF(SUM(Claim_Amount), 0),
        2
    ) AS Approval_Ratio_Pct
FROM Claims
GROUP BY Claim_Type
ORDER BY Approval_Ratio_Pct DESC;




-- 10. Frequency + severity together
SELECT
    p.Policy_Type,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(
        COUNT(DISTINCT cl.Claim_ID) * 100.0 /
        NULLIF(COUNT(DISTINCT p.Policy_ID), 0),
        2
    ) AS Claim_Frequency_Pct,
    ROUND(AVG(cl.Claim_Amount), 2) AS Average_Claim_Severity,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claim_Amount
FROM Policies p
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY p.Policy_Type
ORDER BY Claim_Frequency_Pct DESC;