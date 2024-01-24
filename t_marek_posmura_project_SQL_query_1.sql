-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- A) varianta pomocí subselectů

SELECT
	industry_name,
	round(avg(percentage_diff),2) AS avg_wage_growth,
	sum(percentage_diff) AS total_wage_growth
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
		ON 1=1
		AND tmp.industry_name = tmp2.industry_name 
		AND tmp.compared_year = tmp2.compared_year + 1 
	GROUP BY tmp.industry_name, tmp.compared_year 
	ORDER BY tmp.industry_name
) AS first_query
WHERE previous_year IS NOT NULL
GROUP BY industry_name


-- B) varianta pomocí CTE (WITH)

WITH first_query AS (
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
)
SELECT 
	industry_name,
	avg(percentage_diff) AS avg_wage_growth,
	sum(percentage_diff) AS total_wage_growth
FROM first_query
WHERE 1=1
	AND previous_year IS NOT NULL
GROUP BY industry_name
;

-- dotaz na zobrazení všech dat

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
WHERE 1=1
	AND previous_year IS NOT NULL
	
	
	