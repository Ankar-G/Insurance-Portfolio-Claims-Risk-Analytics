/* Policy Risk Analysis
What this section answers
Which risk categories have the most policies?
Which risk categories have higher claim frequency?
Which have higher loss ratios?
Which policy types are exposed to greater risk?
Which individual policies have unusually high claim exposure?
How does premium compare with coverage (sum assured)? */


-- 1. Risk category overview
SELECT
    Risk_Category,
    COUNT(*) AS Total_Policies,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    SUM(Premium_Amount) AS Total_Premium,
    SUM(Sum_Assured) AS Total_Sum_Assured
FROM Policies
GROUP BY Risk_Category
ORDER BY Total_Policies DESC;




-- 2. Claims by risk category
SELECT
    p.Risk_Category,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    SUM(cl.Claim_Amount) AS Total_Claim_Amount,
    AVG(cl.Claim_Amount) AS Average_Claim_Amount
FROM Policies p
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY p.Risk_Category
ORDER BY Total_Claim_Amount DESC;




-- 3. Claim frequency by risk category
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




-- 4. Risk category vs loss ratio
SELECT
    p.Risk_Category,
    SUM(p.Premium_Amount) AS Total_Premium,
    SUM(cl.Claim_Amount) AS Total_Claims,
    ROUND(
        SUM(cl.Claim_Amount) * 100.0 /
        NULLIF(SUM(p.Premium_Amount), 0),
        2
    ) AS Loss_Ratio_Pct
FROM Policies p
JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY p.Risk_Category
ORDER BY Loss_Ratio_Pct DESC;




-- 5. Policy type × risk category
SELECT
    Policy_Type,
    Risk_Category,
    COUNT(*) AS Total_Policies,
    SUM(Premium_Amount) AS Total_Premium,
    SUM(Sum_Assured) AS Total_Sum_Assured
FROM Policies
GROUP BY Policy_Type, Risk_Category
ORDER BY Policy_Type, Total_Premium DESC;




-- 6. Policy type × risk × claims
SELECT
    p.Policy_Type,
    p.Risk_Category,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claim_Amount,
    ROUND(AVG(cl.Claim_Amount), 2) AS Avg_Claim_Amount
FROM Policies p
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY p.Policy_Type, p.Risk_Category
ORDER BY Total_Claim_Amount DESC;




-- 7. Highest-risk individual policies
SELECT
    p.Policy_ID,
    p.Customer_ID,
    p.Policy_Type,
    p.Risk_Category,
    p.Premium_Amount,
    p.Sum_Assured,
    COUNT(cl.Claim_ID) AS Total_Claims,
    COALESCE(SUM(cl.Claim_Amount), 0) AS Total_Claim_Amount
FROM Policies p
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY
    p.Policy_ID,
    p.Customer_ID,
    p.Policy_Type,
    p.Risk_Category,
    p.Premium_Amount,
    p.Sum_Assured
ORDER BY Total_Claim_Amount DESC
LIMIT 20;




-- 8. Sum assured vs premium
SELECT
    Policy_Type,
    ROUND(AVG(Premium_Amount), 2) AS Avg_Premium,
    ROUND(AVG(Sum_Assured), 2) AS Avg_Sum_Assured,
    ROUND(
        AVG(Sum_Assured) / NULLIF(AVG(Premium_Amount), 0),
        2
    ) AS Average_Coverage_Multiple
FROM Policies
GROUP BY Policy_Type
ORDER BY Average_Coverage_Multiple DESC;




-- 9. Policy status × risk category
SELECT
    Policy_Status,
    Risk_Category,
    COUNT(*) AS Total_Policies
FROM Policies
GROUP BY Policy_Status, Risk_Category
ORDER BY Total_Policies DESC;




-- 10. Acquisition channel × risk
SELECT
    Acquisition_Channel,
    Risk_Category,
    COUNT(*) AS Total_Policies,
    SUM(Premium_Amount) AS Total_Premium,
    AVG(Premium_Amount) AS Average_Premium
FROM Policies
GROUP BY Acquisition_Channel, Risk_Category
ORDER BY Acquisition_Channel, Total_Premium DESC;
