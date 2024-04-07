-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

WITH first_query AS (
	SELECT
		tmp.industry_name,
		tmp.compared_year,
		tmp.avg_wage,
		LAG(tmp.avg_wage) OVER (PARTITION BY tmp.industry_name ORDER BY tmp.compared_year) AS lag_avg_wage
	FROM t_marek_posmura_project_sql_primary_final tmp
	GROUP BY tmp.industry_name, tmp.compared_year
),
second_query AS	(
	SELECT *,
		avg_wage - lag_avg_wage AS difference,
		round((avg_wage / lag_avg_wage - 1) * 100,2) AS percentage_diff
	FROM first_query
	WHERE 1=1
		AND lag_avg_wage IS NOT NULL
)
SELECT
	industry_name,
	sum(percentage_diff) AS total_wage_growth
FROM second_query
GROUP BY industry_name 
ORDER BY total_wage_growth DESC 


-- -------------------------------
-- dotaz na zobrazení všech dat

WITH first_query AS (
	SELECT
		tmp.industry_name,
		tmp.compared_year,
		tmp.avg_wage,
		LAG(tmp.avg_wage) OVER (PARTITION BY tmp.industry_name ORDER BY tmp.compared_year) AS lag_avg_wage
	FROM t_marek_posmura_project_sql_primary_final tmp
	GROUP BY tmp.industry_name, tmp.compared_year
)
SELECT *,
	avg_wage - lag_avg_wage AS difference,
	round((avg_wage / lag_avg_wage - 1) * 100,2) AS percentage_diff
FROM first_query
WHERE 1=1
	AND lag_avg_wage IS NOT NULL
;
