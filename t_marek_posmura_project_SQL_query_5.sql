/*
5)	Má výška HDP vliv na změny ve mzdách a cenách potravin?
	Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to
	na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
*/

	
WITH first_query AS (
	SELECT
		tmp.compared_year,
		tmp.gdp,
		LEAD(tmp.GDP, 1) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_GDP,
		tmp.avg_price AS price,
		LEAD(tmp.avg_price, 1) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_price,
		tmp.avg_wage_all AS wage,
		LEAD(tmp.avg_wage_all, 1) OVER (PARTITION BY tmp.country ORDER BY tmp.compared_year) AS lead_wage
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
;