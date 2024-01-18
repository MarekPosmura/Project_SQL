-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?


SELECT *
FROM (
	SELECT
		tmp.industry_name,
		tmp.avg_wage,
		tmp2.avg_wage AS avg_wage_previous_year,
		tmp.avg_wage - tmp2.avg_wage AS difference,
		round(((tmp.avg_wage / tmp2.avg_wage)-1)*100,2) AS percentage_diff,
		tmp.compared_year,
		tmp2.compared_year AS previous_year
	FROM t_marek_posmura_project_sql_primary_finale tmp
	LEFT JOIN t_marek_posmura_project_sql_primary_finale tmp2
		ON tmp.industry_name = tmp2.industry_name 
		AND tmp.compared_year = tmp2.compared_year + 1 
	GROUP BY tmp.industry_name, tmp.compared_year 
	ORDER BY tmp.industry_name
) AS first_query
WHERE previous_year IS NOT NULL
-- AND percentage_diff < 0
