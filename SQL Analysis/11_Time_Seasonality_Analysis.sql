/* Time & Seasonality Analysis 
What this section answers
Are policies and premiums growing over time?
Which months/quarters have more claims?
Are there seasonal claim patterns?
How does claim frequency change over time?
Is claim processing time changing?
How is premium revenue growing year over year? */



-- 1. Policies and premium by year
SELECT
    YEAR(Policy_Start_Date) AS Year,
    COUNT(*) AS Total_Policies,
    ROUND(SUM(Premium_Amount), 2) AS Total_Premium
FROM Policies
GROUP BY YEAR(Policy_Start_Date)
ORDER BY Year;




-- 2. Claims by year
SELECT
    YEAR(Claim_Date) AS Year,
    COUNT(*) AS Total_Claims,
    ROUND(SUM(Claim_Amount), 2) AS Total_Claim_Amount,
    ROUND(SUM(Approved_Amount), 2) AS Total_Approved_Amount
FROM Claims
GROUP BY YEAR(Claim_Date)
ORDER BY Year;




-- 3. Monthly policy acquisition
SELECT
    YEAR(Policy_Start_Date) AS Year,
    MONTH(Policy_Start_Date) AS Month_Number,
    MONTHNAME(Policy_Start_Date) AS Month_Name,
    COUNT(*) AS New_Policies,
    ROUND(SUM(Premium_Amount), 2) AS Total_Premium
FROM Policies
GROUP BY
    YEAR(Policy_Start_Date),
    MONTH(Policy_Start_Date),
    MONTHNAME(Policy_Start_Date)
ORDER BY Year, Month_Number;




-- 4. Monthly claims
SELECT
    YEAR(Claim_Date) AS Year,
    MONTH(Claim_Date) AS Month_Number,
    MONTHNAME(Claim_Date) AS Month_Name,
    COUNT(*) AS Total_Claims,
    ROUND(SUM(Claim_Amount), 2) AS Total_Claim_Amount
FROM Claims
GROUP BY
    YEAR(Claim_Date),
    MONTH(Claim_Date),
    MONTHNAME(Claim_Date)
ORDER BY Year, Month_Number;




-- 5. Claims by quarter
SELECT
    YEAR(Claim_Date) AS Year,
    QUARTER(Claim_Date) AS Quarter,
    COUNT(*) AS Total_Claims,
    ROUND(SUM(Claim_Amount), 2) AS Total_Claim_Amount
FROM Claims
GROUP BY
    YEAR(Claim_Date),
    QUARTER(Claim_Date)
ORDER BY Year, Quarter;




-- 6. Premium vs claims by year\
SELECT
    YEAR(p.Policy_Start_Date) AS Year,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claims,
    ROUND(
        SUM(cl.Claim_Amount) * 100.0 /
        NULLIF(SUM(p.Premium_Amount), 0),
        2
    ) AS Loss_Ratio_Pct
FROM Policies p
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY YEAR(p.Policy_Start_Date)
ORDER BY Year;




-- 7. Claim type seasonality
SELECT
    MONTH(Claim_Date) AS Month_Number,
    MONTHNAME(Claim_Date) AS Month_Name,
    Claim_Type,
    COUNT(*) AS Total_Claims,
    ROUND(SUM(Claim_Amount), 2) AS Total_Claim_Amount
FROM Claims
GROUP BY
    MONTH(Claim_Date),
    MONTHNAME(Claim_Date),
    Claim_Type
ORDER BY Month_Number, Total_Claim_Amount DESC;




-- 8. Monthly claim frequency
SELECT
    YEAR(p.Policy_Start_Date) AS Year,
    MONTH(p.Policy_Start_Date) AS Month_Number,
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
GROUP BY
    YEAR(p.Policy_Start_Date),
    MONTH(p.Policy_Start_Date)
ORDER BY Year, Month_Number;




-- 9. Claim processing time by month
SELECT
    YEAR(Claim_Date) AS Year,
    MONTH(Claim_Date) AS Month_Number,
    MONTHNAME(Claim_Date) AS Month_Name,
    COUNT(*) AS Total_Claims,
    ROUND(AVG(Claim_Processing_Days), 2) AS Avg_Processing_Days
FROM Claims
WHERE Claim_Processing_Days IS NOT NULL
GROUP BY
    YEAR(Claim_Date),
    MONTH(Claim_Date),
    MONTHNAME(Claim_Date)
ORDER BY Year, Month_Number;




-- 10. Year-over-year premium growth
WITH yearly_premium AS (
    SELECT
        YEAR(Policy_Start_Date) AS Year,
        SUM(Premium_Amount) AS Total_Premium
    FROM Policies
    GROUP BY YEAR(Policy_Start_Date)
)
SELECT
    Year,
    ROUND(Total_Premium, 2) AS Total_Premium,
    ROUND(
        (Total_Premium - LAG(Total_Premium) OVER (ORDER BY Year))
        * 100.0 /
        NULLIF(LAG(Total_Premium) OVER (ORDER BY Year), 0),
        2
    ) AS YoY_Growth_Pct
FROM yearly_premium
ORDER BY Year;