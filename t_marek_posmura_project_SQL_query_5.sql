/*
5)	Má výška HDP vliv na změny ve mzdách a cenách potravin?
	Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to
	na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
*/

-- Pokud výrazněji vzroste HDP ve sledovaném roce (např. o více jak 5 %),
-- vzrostou mzdy nebo ceny potravin v roce následujícím (opět např. o 5 %)?


WITH base AS (
	SELECT
		tmps.compared_year,
-- 		tmps2.GDP AS GDP_previous,
-- 		tmps.GDP AS GDP,
-- 		tmps3.GDP AS GDP_next,
		round(100*(tmps.gdp - tmps2.gdp)/tmps2.gdp,2) AS diff_gdp,
--		round(100*(tmps.gdp - tmps3.gdp)/tmps3.gdp,2) AS diff_gdp_next, -- toto nebude potřeba
-- 		tmps2.avg_price AS price_previous,
-- 		tmps.avg_price AS price,
-- 		tmps3.avg_price AS price_next,
		round(100*(tmps.avg_price - tmps2.avg_price)/tmps2.avg_price,2) AS diff_price,
		round(100*(tmps.avg_price - tmps3.avg_price)/tmps3.avg_price,2) AS diff_price_next,
-- 		tmps2.avg_wage_all AS wage_previous,
-- 		tmps.avg_wage_all AS wage,
-- 		tmps3.avg_wage_all AS wage_next,
		round(100*(tmps.avg_wage_all - tmps2.avg_wage_all)/tmps2.avg_wage_all,2) AS diff_wage,
		round(100*(tmps.avg_wage_all - tmps3.avg_wage_all)/tmps3.avg_wage_all,2) AS diff_wage_next
	FROM t_marek_posmura_project_sql_secondary_final tmps
	LEFT JOIN t_marek_posmura_project_sql_secondary_final tmps2
		ON tmps.compared_year = tmps2.compared_year + 1
	LEFT JOIN t_marek_posmura_project_sql_secondary_final tmps3
		ON tmps.compared_year = tmps3.compared_year - 1 
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

	
	
	
-- stará varianta
/*	
SELECT
	tmps.compared_year,
	tmps.GDP,
	tmps2.GDP AS GDP_previous,
	tmps.gdp - tmps2.gdp AS diff_gdp,
	round(100*(tmps.gdp - tmps2.gdp)/tmps2.gdp,2) AS diff_gdp_perc,
	tmps.avg_price,
	tmps2.avg_price AS avg_price_previous,
	tmps.avg_price - tmps2.avg_price AS diff_price,
	round(100*(tmps.avg_price - tmps2.avg_price)/tmps2.avg_price,2) AS diff_price_perc,
	tmps.avg_wage_all,
	tmps2.avg_wage_all AS avg_wage_all_previous,
	tmps.avg_wage_all - tmps2.avg_wage_all AS diff_wage,
	round(100*(tmps.avg_wage_all - tmps2.avg_wage_all)/tmps2.avg_wage_all,2) AS diff_wage_perc
FROM t_marek_posmura_project_sql_secondary_final tmps
LEFT JOIN t_marek_posmura_project_sql_secondary_final tmps2
	ON tmps.compared_year = tmps2.compared_year + 1
GROUP BY compared_year
ORDER BY compared_year DESC
; 
*/