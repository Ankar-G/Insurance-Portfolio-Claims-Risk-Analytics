/* Agent Performance
This section answers:

Which agents generate the most policies?
Which generate the most premium?
Which agents have higher claim frequency?
How does agent performance vary by region/type/experience?
Does an agent's portfolio show different claim exposure? */


-- 1. Overall agent performance
SELECT
    a.Agent_ID,
    a.Agent_Name,
    a.Agent_Type,
    a.Region,
    COUNT(p.Policy_ID) AS Total_Policies,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium
FROM Agents a
LEFT JOIN Policies p
    ON a.Agent_ID = p.Agent_ID
GROUP BY
    a.Agent_ID,
    a.Agent_Name,
    a.Agent_Type,
    a.Region
ORDER BY Total_Premium DESC;




-- 2. Agent premium comparison
SELECT
    a.Agent_ID,
    a.Agent_Name,
    a.Policies_Sold AS Recorded_Policies_Sold,
    COUNT(p.Policy_ID) AS Calculated_Policies_Sold,
    a.Premium_Generated AS Recorded_Premium,
    ROUND(COALESCE(SUM(p.Premium_Amount), 0), 2) AS Calculated_Premium
FROM Agents a
LEFT JOIN Policies p
    ON a.Agent_ID = p.Agent_ID
GROUP BY
    a.Agent_ID,
    a.Agent_Name,
    a.Policies_Sold,
    a.Premium_Generated
ORDER BY Calculated_Premium DESC;




-- 	3. Average premium per policy by agent
SELECT
    a.Agent_ID,
    a.Agent_Name,
    COUNT(p.Policy_ID) AS Total_Policies,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(AVG(p.Premium_Amount), 2) AS Average_Premium
FROM Agents a
JOIN Policies p
    ON a.Agent_ID = p.Agent_ID
GROUP BY a.Agent_ID, a.Agent_Name
ORDER BY Average_Premium DESC;




-- 4. Agent performance by region
SELECT
    a.Region,
    COUNT(DISTINCT a.Agent_ID) AS Total_Agents,
    COUNT(p.Policy_ID) AS Total_Policies,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium
FROM Agents a
LEFT JOIN Policies p
    ON a.Agent_ID = p.Agent_ID
GROUP BY a.Region
ORDER BY Total_Premium DESC;




-- 5. Agent performance by agent type
SELECT
    a.Agent_Type,
    COUNT(DISTINCT a.Agent_ID) AS Total_Agents,
    COUNT(p.Policy_ID) AS Total_Policies,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(AVG(p.Premium_Amount), 2) AS Average_Premium
FROM Agents a
LEFT JOIN Policies p
    ON a.Agent_ID = p.Agent_ID
GROUP BY a.Agent_Type
ORDER BY Total_Premium DESC;




-- 6. Claims associated with each agent
SELECT
    a.Agent_ID,
    a.Agent_Name,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claim_Amount
FROM Agents a
LEFT JOIN Policies p
    ON a.Agent_ID = p.Agent_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY a.Agent_ID, a.Agent_Name
ORDER BY Total_Claim_Amount DESC;




-- 7. Agent claim frequency
SELECT
    a.Agent_ID,
    a.Agent_Name,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(
        COUNT(DISTINCT cl.Claim_ID) * 100.0 /
        NULLIF(COUNT(DISTINCT p.Policy_ID), 0),
        2
    ) AS Claim_Frequency_Pct
FROM Agents a
LEFT JOIN Policies p
    ON a.Agent_ID = p.Agent_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY a.Agent_ID, a.Agent_Name
ORDER BY Claim_Frequency_Pct DESC;




-- 8. Agent loss ratio
SELECT
    a.Agent_ID,
    a.Agent_Name,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claims,
    ROUND(
        SUM(cl.Claim_Amount) * 100.0 /
        NULLIF(SUM(p.Premium_Amount), 0),
        2
    ) AS Loss_Ratio_Pct
FROM Agents a
JOIN Policies p
    ON a.Agent_ID = p.Agent_ID
JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY a.Agent_ID, a.Agent_Name
ORDER BY Loss_Ratio_Pct DESC;




-- 9. Agent experience vs premium
SELECT
    CASE
        WHEN a.Experience_Years < 3 THEN '0-2 Years'
        WHEN a.Experience_Years BETWEEN 3 AND 5 THEN '3-5 Years'
        WHEN a.Experience_Years BETWEEN 6 AND 10 THEN '6-10 Years'
        ELSE '10+ Years'
    END AS Experience_Group,
    COUNT(DISTINCT a.Agent_ID) AS Total_Agents,
    COUNT(p.Policy_ID) AS Total_Policies,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium
FROM Agents a
LEFT JOIN Policies p
    ON a.Agent_ID = p.Agent_ID
GROUP BY Experience_Group
ORDER BY Total_Premium DESC;




-- 10. Agent performance summary
SELECT
    a.Agent_ID,
    a.Agent_Name,
    a.Region,
    a.Experience_Years,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    COUNT(DISTINCT cl.Claim_ID) AS Total_Claims,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claim_Amount
FROM Agents a
LEFT JOIN Policies p
    ON a.Agent_ID = p.Agent_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
GROUP BY
    a.Agent_ID,
    a.Agent_Name,
    a.Region,
    a.Experience_Years
ORDER BY Total_Premium DESC;