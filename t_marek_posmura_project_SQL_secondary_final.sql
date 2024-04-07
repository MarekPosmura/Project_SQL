
-- ---------------------------
-- GDP v datasetu od roku 1990


CREATE OR REPLACE TABLE t_marek_posmura_project_SQL_secondary_final AS
WITH europe AS (
	SELECT
		country AS state,
		continent 
	FROM countries
	WHERE 1=1
		AND continent = 'Europe'
),
main_table AS (
	SELECT 
		country,
		year AS compared_year, 
		round(GDP, 0) AS GDP,
		gini
	FROM economies
),
price_wage AS (
	SELECT 
		compared_year AS compared_year_2,
		round(avg(price),2) AS avg_price,
		round(avg(avg_wage),2) AS avg_wage_all
	FROM t_marek_posmura_project_sql_primary_final tmp
	GROUP BY compared_year 
)
SELECT
	mt.country,
	mt.compared_year,
	mt.GDP,
	mt.gini,
	pw.avg_price,
	pw.avg_wage_all
FROM main_table mt
RIGHT JOIN europe e
	ON e.state = mt.country
	AND e.continent = 'Europe'
LEFT JOIN price_wage pw
	ON mt.compared_year = pw.compared_year_2
	AND mt.country = 'Czech republic'
WHERE 1=1
		AND mt.compared_year BETWEEN 2006 AND 2016
		-- AND mt.country = 'Czech republic'
;