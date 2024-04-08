/*
5)	Má výška HDP vliv na změny ve mzdách a cenách potravin?
	Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to
	na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
*/

-- Pokud výrazněji vzroste HDP ve sledovaném roce (např. o více jak 5 %),
-- vzrostou mzdy nebo ceny potravin v roce následujícím (opět např. o 5 %)?


WITH first_query AS (
	SELECT
		tmp.compared_year,
		LAG(tmp.GDP) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lag_GDP,
		tmp.gdp,
		LEAD(tmp.GDP) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_GDP,
		LAG(tmp.avg_price) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lag_price,
		tmp.avg_price AS price,
		LEAD(tmp.avg_price) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_price,
		LAG(tmp.avg_wage_all) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lag_wage,
		tmp.avg_wage_all AS wage,
		LEAD(tmp.avg_wage_all) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_wage
	FROM t_marek_posmura_project_sql_secondary_final tmp
	WHERE tmp.country = 'Czech Republic' 
	GROUP BY compared_year
	ORDER BY compared_year DESC
)
SELECT
	compared_year,
	round((gdp - lag_gdp) / gdp * 100,2) AS lag_gdp_diff,
	round((price - lag_price) / price * 100,2) AS lag_price_diff,
	round((price - lead_price) / price * 100,2) AS lead_price_diff,
	round((wage - lag_wage) / wage * 100,2) AS lag_wage_diff,
	round((wage - lead_wage) / wage * 100,2) AS lead_wage_diff
FROM first_query

SELECT
		tmp.compared_year,
		LAG(tmp.GDP) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lag_GDP,
		tmp.gdp,
		LEAD(tmp.GDP) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_GDP,
		LAG(tmp.avg_price) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lag_price,
		tmp.avg_price AS price,
		LEAD(tmp.avg_price) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_price,
		LAG(tmp.avg_wage_all) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lag_wage,
		tmp.avg_wage_all AS wage,
		LEAD(tmp.avg_wage_all) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_wage
	FROM t_marek_posmura_project_sql_secondary_final tmp
	WHERE tmp.country = 'Czech Republic' 
	GROUP BY compared_year
	ORDER BY compared_year DESC
-- 		round(100*(tmps.gdp - tmps2.gdp)/tmps2.gdp,2) AS diff_gdp,
--		round(100*(tmps.gdp - tmps3.gdp)/tmps3.gdp,2) AS diff_gdp_next, -- toto nebude potřeba
-- 		tmps2.avg_price AS price_previous,
-- 		round(100*(tmp.avg_price - tmps2.avg_price)/tmps2.avg_price,2) AS diff_price,
-- 		round(100*(tmp.avg_price - tmps3.avg_price)/tmps3.avg_price,2) AS diff_price_next
-- 		tmps2.avg_wage_all AS wage_previous,
-- 		tmps.avg_wage_all AS wage,
-- 		tmps3.avg_wage_all AS wage_next,
-- 		round(100*(tmps.avg_wage_all - tmps2.avg_wage_all)/tmps2.avg_wage_all,2) AS diff_wage,
-- 		round(100*(tmps.avg_wage_all - tmps3.avg_wage_all)/tmps3.avg_wage_all,2) AS diff_wage_next



	SELECT
		tmp.compared_year,
		LAG(tmp.GDP) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lag_GDP,
		tmp.gdp,
		LEAD(tmp.GDP) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_GDP,
		LAG(tmp.avg_price) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lag_price,
		tmp.avg_price AS price,
		LEAD(tmp.avg_price) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_price,
		LAG(tmp.avg_wage_all) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lag_wage,
		tmp.avg_wage_all AS wage,
		LEAD(tmp.avg_wage_all) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_wage
	FROM t_marek_posmura_project_sql_secondary_final tmp
	WHERE tmp.country = 'Czech Republic' 
	GROUP BY compared_year
	ORDER BY compared_year DESC
	
	
	),
main AS (
SELECT *,
	CASE
		WHEN diff_gdp > 5 THEN 1
		WHEN diff_gdp < - 5 THEN - 1
		ELSE 0
	END AS is_gdp_big,
	CASE
		WHEN diff_price_next > 5 THEN 1
		WHEN diff_price_next < - 5 THEN - 1
		ELSE 0
	END AS is_price_big,
	CASE
		WHEN diff_wage_next > 5 THEN 1
		WHEN diff_wage_next < - 5 THEN - 1
		ELSE 0
	END AS is_wage_big
FROM base
)
SELECT *,
	is_gdp_big + is_price_big + is_wage_big AS sum_all
FROM main
WHERE 1=1
	AND diff_gdp IS NOT NULL
;

	
WITH first_query as(
	SELECT
		tmp.compared_year,
		tmp.gdp,
		LEAD(tmp.GDP, 1) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_GDP,
-- 		LEAD(tmp.GDP, 2) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_GDP2,
		tmp.avg_price AS price,
		LEAD(tmp.avg_price, 1) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_price,
-- 		LEAD(tmp.avg_price, 2) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_price2,
		tmp.avg_wage_all AS wage,
		LEAD(tmp.avg_wage_all, 1) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_wage
-- 		LEAD(tmp.avg_wage_all, 2) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_wage2
	FROM t_marek_posmura_project_sql_secondary_final tmp
	WHERE tmp.country = 'Czech Republic' 
	GROUP BY compared_year
	ORDER BY compared_year ASC
),
second_query AS (
	SELECT
		compared_year,
		round((lead_GDP - gdp) / gdp * 100,2) AS lead_gdp_diff,
		round((lead_price - price) / price * 100,2) AS lead_price_diff,
		round((lead_wage - wage) / wage * 100,2) AS lead_wage_diff
	FROM first_query
)
SELECT
	*,
	sum(lead_gdp_diff) OVER (ORDER BY compared_year) AS acc_gdp_sum,
	sum(lead_price_diff) OVER (ORDER BY compared_year) AS acc_price_sum,
	sum(lead_wage_diff) OVER (ORDER BY compared_year) AS acc_wage_sum
FROM second_query



	SELECT
		tmp.compared_year,
		tmp.gdp,
		LEAD(tmp.GDP, 1) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_GDP,
-- 		LEAD(tmp.GDP, 2) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_GDP2,
		tmp.avg_price AS price,
		LEAD(tmp.avg_price, 1) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_price,
-- 		LEAD(tmp.avg_price, 2) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_price2,
		tmp.avg_wage_all AS wage,
		LEAD(tmp.avg_wage_all, 1) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_wage
-- 		LEAD(tmp.avg_wage_all, 2) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_wage2
	FROM t_marek_posmura_project_sql_secondary_final tmp
	WHERE tmp.country = 'Czech Republic' 
	GROUP BY compared_year
	ORDER BY compared_year ASC