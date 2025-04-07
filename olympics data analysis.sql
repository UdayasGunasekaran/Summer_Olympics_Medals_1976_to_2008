SELECT 
    *
FROM
    netflix.summer_olympic_medals_1976_to_2008;


-- Handling Missing Data

SELECT 
    *
FROM
    netflix.summer_olympic_medals_1976_to_2008
WHERE
    City IS NULL OR Year IS NULL
        OR Sport IS NULL
        OR Discipline IS NULL
        OR Event IS NULL
        OR Athlete IS NULL
        OR Gender IS NULL
        OR Country_Code IS NULL
        OR Country IS NULL
        OR Event_gender IS NULL
        OR Medal IS NULL;


-- Identifying Duplicate rows

SELECT 
    City,
    Year,
    Sport,
    Discipline,
    Event,
    Athlete,
    Gender,
    Country_Code,
    Country,
    Event_gender,
    Medal,
    COUNT(*) AS count
FROM
    netflix.summer_olympic_medals_1976_to_2008
GROUP BY City , Year , Sport , Discipline , Event , Athlete , Gender , Country_Code , Country , Event_gender , Medal
HAVING COUNT(*) > 1;


-- Removing Duplicate rows

DELETE FROM netflix.summer_olympic_medals_1976_to_2008 
WHERE
    (City , Year,
    Sport,
    Discipline,
    Event,
    Athlete,
    Gender,
    Country_Code,
    Country,
    Event_gender,
    Medal) NOT IN (SELECT 
        City,
            Year,
            Sport,
            Discipline,
            Event,
            Athlete,
            Gender,
            Country_Code,
            Country,
            Event_gender,
            Medal
    FROM
        netflix.summer_olympic_medals_1976_to_2008
    GROUP BY City , Year , Sport , Discipline , Event , Athlete , Gender , Country_Code , Country , Event_gender , Medal);


-- 1. Put some light on gender ratio in winning teams

SELECT 
    Gender,
    COUNT(Gender) AS Distribution,
    ROUND(COUNT(Gender) * 100 / (SELECT 
                    COUNT(Gender)
                FROM
                    netflix.summer_olympic_medals_1976_to_2008)) AS Percentage
FROM
    netflix.summer_olympic_medals_1976_to_2008
GROUP BY Gender
ORDER BY Percentage DESC;
    
    
-- 2. To identify gender distribution in medals

SELECT 
    Gender,
    Medal,
    COUNT(Medal) AS Distribution,
    ROUND(COUNT(Medal) * 100 / (SELECT 
                    COUNT(Medal)
                FROM
                    netflix.summer_olympic_medals_1976_to_2008)) AS Percentage
FROM
    netflix.summer_olympic_medals_1976_to_2008
GROUP BY Gender , Medal
ORDER BY Percentage DESC;
    
    
-- 3. Which country has the maximum olympic medals?

SELECT 
    Country, COUNT(Medal) AS TotalMedals
FROM
    netflix.summer_olympic_medals_1976_to_2008
GROUP BY Country
ORDER BY TotalMedals DESC
LIMIT 1;


-- 4. Which country has the minimum olympic medals?

SELECT 
    Country, COUNT(Medal) AS TotalMedals
FROM
    netflix.summer_olympic_medals_1976_to_2008
GROUP BY Country
HAVING COUNT(Medal) = 1;

    
-- 5. To find the Distinct Events and their count information from Dataset

SELECT DISTINCT
    Event, COUNT(Event) AS Distinct_Event_Count
FROM
    netflix.summer_olympic_medals_1976_to_2008
GROUP BY Event
ORDER BY Distinct_Event_Count DESC;


-- 6. Which city hosted maximum number of olympics year-wise?

SELECT DISTINCT
    City, Year, COUNT(City) AS Max_Hostings
FROM
    netflix.summer_olympic_medals_1976_to_2008
GROUP BY City , Year
ORDER BY Year ASC;


-- 7. Which city hosted most events?
-- logic:FocusonCity.Findcountofuniquevalues.Print thecount

SELECT DISTINCT
    City, COUNT(Event) AS Events_Count
FROM
    netflix.summer_olympic_medals_1976_to_2008
GROUP BY City
ORDER BY Events_Count DESC
LIMIT 1;


-- 8. Understand the events themselves
-- logic : Focus on Sport, Discipline and Event. Use groupby and see how many kinds and variations are there.

SELECT DISTINCT
    Sport, Discipline, Event
FROM
    netflix.summer_olympic_medals_1976_to_2008
GROUP BY Sport , Discipline , Event;


-- 9. Which Athlete has win most medal from given period?

SELECT 
    Athlete, COUNT(Medal) AS Medal_Count
FROM
    netflix.summer_olympic_medals_1976_to_2008
GROUP BY Athlete
ORDER BY Medal_Count DESC
LIMIT 1;


-- 10. Which country has win most medal and how many in each year?

SELECT DISTINCT
    Country, Medal_Count, Year
FROM
    (SELECT 
        Country, COUNT(Medal) AS Medal_Count, Year
    FROM
        netflix.summer_olympic_medals_1976_to_2008
    GROUP BY Country , Year) MedalData
WHERE
    Medal_Count = (SELECT 
            MAX(Medal_Count)
        FROM
            (SELECT 
                Country, COUNT(Medal) AS Medal_Count, Year
            FROM
                netflix.summer_olympic_medals_1976_to_2008
            GROUP BY Country , Year) YearlyData
        WHERE
            YearlyData.Year = MedalData.Year)
ORDER BY Year;


-- 11. Can you tell me which country has dominated any particular sport? My Choice - Wrestling

SELECT 
    Country, Sport, COUNT(Medal) AS Total_Medals
FROM
    netflix.summer_olympic_medals_1976_to_2008
WHERE
    Sport = 'Wrestling'
GROUP BY Country
ORDER BY Total_Medals DESC
LIMIT 1;
