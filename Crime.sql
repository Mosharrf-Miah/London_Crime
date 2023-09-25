-- which year saw the most major crime

SELECT DISTINCT year, SUM(COUNT(major_category + minor_category)) OVER(PARTITION BY year) AS "Number of crime by year"
FROM crime.london
GROUP BY year
ORDER BY 2 ASC
limit 1

--  both major and minor crimes along with number of times those crimes were commited.

SELECT DISTINCT major_category AS "Major and Minor crime", COUNT(1) AS "number of major minor crime"
FROM crime.london
GROUP BY major_category
union ALL
SELECT  DISTINCT minor_category, count(1) AS number_of_minor_crime
FROM crime.london
GROUP BY minor_category
ORDER BY  2 desc

-- what is the increase or decrease in major crime from the first year in the data set to the last year in percentage format

WITH  YR8 AS ( select major_category, count(1) as Count, year
from crime.london
group by major_category, year
having year = 2008
order by 3 desc ), 
YR16 AS (select major_category AS major_category , count(1) as Count, year
from crime.london
group by major_category, year
having year = 2016
order by 3 desc)
select distinct yr8.major_category,YR8.year,YR8.count, yr16.year, yr16.count, ((yr16.count-YR8.count)/YR8.count)*100 AS Percentage_change
from YR8 join yr16 on YR8.major_category = yr16.major_category
order by percentage_change desc

-- difference in major crime between the boroughs, comparing which borough experience the most crime

with Borough AS (select  distinct borough, 
count(case when major_category = 'Burglary' then 1 end)  AS Burglary,
count(case when major_category = 'Violence Against the Person' then 1 end) AS "Violence Against the Person",
count(case when major_category = 'Robbery' then 1 end) AS Robbery,
count(case when major_category = 'Theft and Handling' then 1 end) AS "Theft and Handling",
count(case when major_category = 'Criminal Damage' then 1 end) AS "Criminal Damage",
count(case when major_category = 'Drugs' then 1 end) AS Drugs,
count(case when major_category = 'Fraud or Forgery' then 1 end) AS "Fraud or Forgery",
count(case when major_category = 'Other Notifiable Offences' then 1 end) AS "Other Notifiable Offences",
count(case when major_category = 'Sexual Offences' then 1 end) AS "Sexual Offences", 
count(major_category) AS Total_Major_crime
from crime.london
group by borough
order by Total_Major_crime desc) 
Select b.* , b.Total_Major_crime * 100/P.S AS Major_crime_percentage
from Borough b cross join (select sum(Total_Major_crime) AS S from Borough) P
order by Major_crime_percentage desc

-- Are there any indication crimes increases or decreases during specific months of the year
-- i am going to firstly change the data slightly to show the months rather than the month number to help it look more presentable.

update crime.london 
set month = 'January'
where month = 1

update crime.london 
set month = 'February'
where month = 2

update crime.london 
set month = 'March'
where month = 3

update crime.london 
set month = 'April'
where month = 4

update crime.london 
set month = 'May'
where month = 5

update crime.london 
set month = 'June'
where month = 6

update crime.london 
set month = 'July'
where month = 7

update crime.london 
set month = 'August'
where month = 8

update crime.london 
set month = 'September'
where month = 9

update crime.london 
set month = 'October'
where month = 10

update crime.london 
set month = 'November'
where month = 11

update crime.london 
set month = 'December'
where month = 12

select  distinct month, 
count(case when major_category = 'Burglary' then 1 end)  AS Burglary,
count(case when major_category = 'Violence Against the Person' then 1 end) AS "Violence Against the Person",
count(case when major_category = 'Robbery' then 1 end) AS Robbery,
count(case when major_category = 'Theft and Handling' then 1 end) AS "Theft and Handling",
count(case when major_category = 'Criminal Damage' then 1 end) AS "Criminal Damage",
count(case when major_category = 'Drugs' then 1 end) AS Drugs,
count(case when major_category = 'Fraud or Forgery' then 1 end) AS "Fraud or Forgery",
count(case when major_category = 'Other Notifiable Offences' then 1 end) AS "Other Notifiable Offences",
count(case when major_category = 'Sexual Offences' then 1 end) AS "Sexual Offences", 
count(major_category) AS Total_Major_crime
from crime.london
group by month 
order by field( month, 'January','February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')

-- Top 5 boroughs with the least amount of minor crime

With Minor AS(select distinct borough, count(minor_category) AS Minor_Crime
from crime.london
group by borough
order by Minor_Crime asc), 
CTE AS ( Select *, dense_rank() over(order by Minor_Crime asc) as RNK from Minor)
select distinct borough, Minor_Crime
from CTE
where rnk <6
limit 5


