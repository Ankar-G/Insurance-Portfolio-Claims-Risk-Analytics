-- Data validation & quality checks


-- 1. Record counts
SELECT 'Customers' AS Table_Name, COUNT(*) AS Total_Rows FROM Customers
UNION ALL
SELECT 'Policies', COUNT(*) FROM Policies
UNION ALL
SELECT 'Claims', COUNT(*) FROM Claims
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payments
UNION ALL
SELECT 'Agents', COUNT(*) FROM Agents
UNION ALL
SELECT 'Dim_Date', COUNT(*) FROM Dim_Date;



-- 2. Duplicate Customer IDs
SELECT Customer_ID, COUNT(*) AS Duplicate_Count
FROM Customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;



-- 3. Duplicate Policy IDs
SELECT Policy_ID, COUNT(*) AS Duplicate_Count
FROM Policies
GROUP BY Policy_ID
HAVING COUNT(*) > 1;


-- 4. Duplicate Claim IDs
SELECT Claim_ID, COUNT(*) AS Duplicate_Count
FROM Claims
GROUP BY Claim_ID
HAVING COUNT(*) > 1;


-- 5. Orphan Policies
SELECT p.Policy_ID
FROM Policies p
LEFT JOIN Customers c ON p.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;



-- 6. Orphan Claims
SELECT cl.Claim_ID
FROM Claims cl
LEFT JOIN Policies p ON cl.Policy_ID = p.Policy_ID
WHERE p.Policy_ID IS NULL;



-- 7. Claims with wrong Customer_ID
SELECT cl.Claim_ID
FROM Claims cl
JOIN Policies p ON cl.Policy_ID = p.Policy_ID
WHERE cl.Customer_ID <> p.Customer_ID;



-- 8. Approved amount greater than claim amount
SELECT Claim_ID, Claim_Amount, Approved_Amount
FROM Claims
WHERE Approved_Amount > Claim_Amount;



-- 9. Claim amount greater than sum assured
SELECT cl.Claim_ID, cl.Claim_Amount, p.Sum_Assured
FROM Claims cl
JOIN Policies p ON cl.Policy_ID = p.Policy_ID
WHERE cl.Claim_Amount > p.Sum_Assured;



-- 10. Invalid policy dates
SELECT Policy_ID, Policy_Start_Date, Policy_End_Date
FROM Policies
WHERE Policy_End_Date < Policy_Start_Date;