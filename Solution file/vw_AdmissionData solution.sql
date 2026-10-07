-- Q1 Total discharges
SELECT
     COUNT(*) As Total_Discharges
     FROM vw_AdmissionData
     WHERE OUTCOME = 'DISCHARGE'

-- Q2 Average Daily Discharge Rate
-- It is total discharges divided by the total lenght of stay
SELECT
    (SELECT
    COUNT(*) As Total_Discharges
    FROM vw_AdmissionData
    WHERE OUTCOME = 'DISCHARGE')/
    (SELECT SUM(DURATION_OF_STAY)AS _total_lenght_of_stay
FROM vw_AdmissionData)

-- Casting this
SELECT CAST(
           CAST((SELECT COUNT(*) As Total_Discharges
           FROM vw_AdmissionData
           WHERE OUTCOME = 'DISCHARGE') AS FLOAT)/
           CAST((SELECT SUM(DURATION_OF_STAY)AS _total_lenght_of_stay
           FROM vw_AdmissionData) AS FLOAT)
  AS DECIMAL(10,2) )* 100 AS avg_DailyDischargesRate

 --Avoiding Subquery
       SELECT
            ROUND(SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END)/
            SUM(DURATION_OF_STAY),2) * 100 AS Avg_DailyDischargeRate
       FROM vw_AdmissionData

--Q3 Average lenght of Stay (ALOS)
-- It it total lenght of stay divide by total Discharge
--Reverse of Q2
      SELECT
           ROUND(SUM(DURATION_OF_STAY)/
           SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END),0) AS Avg_lenght_of_stay
      FROM vw_AdmissionData

 -- Q4 Distribution of discharges by Age Group
 -- <16 Paedistric
 -- 16 < 65 Adult
 -- 65 >= Senior Citism
    SELECT 
         CASE
            WHEN AGE < 16 THEN 'Paedistric'
            WHEN AGE < 65 THEN 'Adult'
            WHEN AGE >= 65 THEN 'Senior Citizen'
            ELSE 'Unknown'
         END AS Age_Group, COUNT(*) AS Age_Distribution
      FROM vw_AdmissionData
      WHERE OUTCOME = 'DISCHARGE'
      GROUP BY CASE
            WHEN AGE < 16 THEN 'Paedistric'
            WHEN AGE < 65 THEN 'Adult'
            WHEN AGE >= 65 THEN 'Senior Citizen'
            ELSE 'Unknown'
         END 
         ORDER BY 2 DESC

--Q5 DISTRIBUTION OF discharge by gender
SELECT 
     GENDER,
     COUNT(*) AS gender_Distribution
     FROM vw_AdmissionData 
     WHERE OUTCOME = 'DISCHARGE'
     GROUP BY GENDER
ORDER BY COUNT(*) DESC 

-- Q6 Distribution of discharge by day of the week
SELECT
     DATEPART(WEEKDAY, D_O_D) AS Day_of_week,
     COUNT(*) AS Day_Distribution
     FROM vw_AdmissionData
     WHERE OUTCOME = 'DISCHARGE'
     GROUP BY DATEPART(WEEKDAY,D_O_D)
ORDER BY 2 DESC

-- Get Date Name
SELECT
     FORMAT(D_O_D,'ddd') AS Day_of_week,
     COUNT(*) AS Day_Distribution
     FROM vw_AdmissionData
     WHERE OUTCOME = 'DISCHARGE'AND D_O_D IS NOT NULL
     GROUP BY FORMAT(D_O_D,'ddd')
ORDER BY 2 DESC
