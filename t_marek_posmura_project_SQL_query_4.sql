-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH first_query AS (
	SELECT
		tmp.compared_year,
		tmp.industry_name,
		round(avg(tmp.avg_wage),2) AS avg_wage_all,
		tmp.product,
		round(avg(tmp.price),2) AS avg_price_all
	FROM t_marek_posmura_project_sql_primary_final tmp
	GROUP BY tmp.compared_year
),
second_query AS (
	SELECT 
		compared_year,
		avg_wage_all,
		LAG(avg_wage_all) OVER (PARTITION BY industry_name ORDER BY compared_year) AS lag_avg_wage_all,
		avg_price_all,
		LAG(avg_price_all) OVER (PARTITION BY product ORDER BY compared_year) AS lag_avg_price_all
	FROM first_query
),
third_query AS (
	SELECT 
		compared_year,
		round((avg_wage_all - lag_avg_wage_all) / avg_wage_all * 100,2) AS wage_percentage_diff,
		round((avg_price_all - lag_avg_price_all) / avg_price_all * 100,2) AS price_percentage_diff
	FROM second_query
)
SELECT
	compared_year,
	wage_percentage_diff,
	price_percentage_diff,
	price_percentage_diff - wage_percentage_diff AS abs_diff,
	CASE
		WHEN price_percentage_diff - wage_percentage_diff >= 10 THEN 1
		ELSE 0
	END AS is_bigger_then_10
FROM third_query
ORDER BY abs_diff DESC
;