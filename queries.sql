-- sqlite
/* Assumptions:
  - Don't report countries without a value from the POV
  - Countries with a zero value from the POV are valid
  - If the country and corresponding latest year don't have an income group for that year, 
  leave blank but don't drop (if I were to drop nulls, I'd add AND IncomeGroup IS NOT null to 
  the WHERE clause)
*/

/* Query 1
For all countries, a) which year the latest data was available and b) the value at that year
From https://data.worldbank.org/indicator/SI.POV.DDAY?locations=1W&start=1981&end=2015&view=chart
*/

SELECT Country
	, MAX(ReportedYear) AS "Year"
	, RatioValue AS "Value"
FROM poverty_headcount
WHERE RatioValue IS NOT null
GROUP BY Code;

/* Query 2
 For each country,  the latest poverty data available, the year in which it was available, 
 and the country income grouping during that specific year 
 (from https://datahelpdesk.worldbank.org/knowledgebase/articles/906519-world-bank-country-and-lending-groups )
 */
 
SELECT p.Country
	, MAX(p.ReportedYear) AS "Year"
	, RatioValue AS "Value"
	, IncomeGroup AS "Income Group"
FROM poverty_headcount AS p
LEFT JOIN 
	(SELECT Code, ReportedYear, IncomeGroup
	FROM income_group) AS i
	ON i.Code = p.Code
		AND i.ReportedYear = p.ReportedYear
WHERE RatioValue IS NOT null
GROUP BY p.Code;
