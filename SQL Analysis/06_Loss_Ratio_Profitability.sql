-- Loss Ratio & Profitability ( Loss Ratio, Approved Loss Ratio, Premium vs Claims, and Underwriting Margin )



-- 1. Overall Loss Ratio
SELECT
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claims,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(
        SUM(cl.Claim_Amount) * 100.0 /
        NULLIF(SUM(p.Premium_Amount), 0),
        2
    ) AS Loss_Ratio_Pct
FROM Claims cl
JOIN Policies p
    ON cl.Policy_ID = p.Policy_ID;
    
    
    
    
-- 2. Loss Ratio by Policy Type
SELECT
    p.Policy_Type,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claims,
    ROUND(
        SUM(cl.Claim_Amount) * 100.0 /
        NULLIF(SUM(p.Premium_Amount), 0),
        2
    ) AS Loss_Ratio_Pct
FROM Claims cl
JOIN Policies p
    ON cl.Policy_ID = p.Policy_ID
GROUP BY p.Policy_Type
ORDER BY Loss_Ratio_Pct DESC;




-- 3. Loss Ratio by Risk Category
SELECT
    p.Risk_Category,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claims,
    ROUND(
        SUM(cl.Claim_Amount) * 100.0 /
        NULLIF(SUM(p.Premium_Amount), 0),
        2
    ) AS Loss_Ratio_Pct
FROM Claims cl
JOIN Policies p
    ON cl.Policy_ID = p.Policy_ID
GROUP BY p.Risk_Category
ORDER BY Loss_Ratio_Pct DESC;




-- 4. Loss Ratio by Customer Segment
SELECT
    c.Customer_Segment,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claims,
    ROUND(
        SUM(cl.Claim_Amount) * 100.0 /
        NULLIF(SUM(p.Premium_Amount), 0),
        2
    ) AS Loss_Ratio_Pct
FROM Claims cl
JOIN Policies p
    ON cl.Policy_ID = p.Policy_ID
JOIN Customers c
    ON p.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Segment
ORDER BY Loss_Ratio_Pct DESC;




-- 5. Premium vs Approved Claims
SELECT
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(SUM(cl.Approved_Amount), 2) AS Total_Approved_Claims,
    ROUND(
        SUM(cl.Approved_Amount) * 100.0 /
        NULLIF(SUM(p.Premium_Amount), 0),
        2
    ) AS Approved_Loss_Ratio_Pct
FROM Claims cl
JOIN Policies p
    ON cl.Policy_ID = p.Policy_ID;
    
    
    
    
-- 6. Policy-Level Profitability Proxy
SELECT
    p.Policy_Type,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(SUM(cl.Approved_Amount), 2) AS Approved_Claims,
    ROUND(
        SUM(p.Premium_Amount) - SUM(cl.Approved_Amount),
        2
    ) AS Underwriting_Margin_Proxy
FROM Policies p
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY p.Policy_Type
ORDER BY Underwriting_Margin_Proxy DESC;





-- 7. Customer Segment Profitability
SELECT
    c.Customer_Segment,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(COALESCE(SUM(cl.Approved_Amount), 0), 2) AS Approved_Claims,
    ROUND(
        SUM(p.Premium_Amount) -
        COALESCE(SUM(cl.Approved_Amount), 0),
        2
    ) AS Underwriting_Margin_Proxy
FROM Customers c
JOIN Policies p
    ON c.Customer_ID = p.Customer_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY c.Customer_Segment
ORDER BY Underwriting_Margin_Proxy DESC;

 


-- 8. Highest Loss-Ratio Policies
SELECT
    p.Policy_ID,
    p.Policy_Type,
    p.Premium_Amount,
    SUM(cl.Claim_Amount) AS Total_Claims,
    ROUND(
        SUM(cl.Claim_Amount) * 100.0 /
        NULLIF(p.Premium_Amount, 0),
        2
    ) AS Loss_Ratio_Pct
FROM Policies p
JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY
    p.Policy_ID,
    p.Policy_Type,
    p.Premium_Amount
ORDER BY Loss_Ratio_Pct DESC
LIMIT 20;




-- 9. Monthly Premium vs Claims
SELECT
    YEAR(cl.Claim_Date) AS Claim_Year,
    MONTH(cl.Claim_Date) AS Claim_Month,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claims,
    ROUND(SUM(p.Premium_Amount), 2) AS Premium_Amount,
    ROUND(
        SUM(cl.Claim_Amount) * 100.0 /
        NULLIF(SUM(p.Premium_Amount), 0),
        2
    ) AS Loss_Ratio_Pct
FROM Claims cl
JOIN Policies p
    ON cl.Policy_ID = p.Policy_ID
GROUP BY
    YEAR(cl.Claim_Date),
    MONTH(cl.Claim_Date)
ORDER BY Claim_Year, Claim_Month;




-- 10. Overall Portfolio Profitability Proxy
SELECT
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(SUM(cl.Approved_Amount), 2) AS Total_Approved_Claims,
    ROUND(
        SUM(p.Premium_Amount) -
        SUM(cl.Approved_Amount),
        2
    ) AS Underwriting_Margin_Proxy,
    ROUND(
        (SUM(p.Premium_Amount) - SUM(cl.Approved_Amount))
        * 100.0 /
        NULLIF(SUM(p.Premium_Amount), 0),
        2
    ) AS Margin_Pct
FROM Policies p
JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID;