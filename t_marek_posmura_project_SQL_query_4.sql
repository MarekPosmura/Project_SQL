-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

-- porovnat průměrné roční zdražení všech potravin a průměrné roční zvýšení mezd (mzdy všech odvětví)


SELECT
	*,
	CASE
		WHEN wage_percentage_diff - price_percentage_diff >= 10 THEN 1
		ELSE 0
	END AS is_bigger_then_10
FROM
(
SELECT
	round(avg(tmp.avg_wage),2) AS avg_wage_all,
	round(avg(tmp2.avg_wage),2) AS avg_wage_all_previous_year,
	round(avg(tmp.avg_wage),2) - round(avg(tmp2.avg_wage),2) AS diff,
	round(avg(tmp.price),2) AS avg_price,
	round(avg(tmp2.price),2) AS avg_price_previous_year,
	round(((avg(tmp.avg_wage) / avg(tmp2.avg_wage))-1)*100,2) AS wage_percentage_diff,
	round((((avg(tmp.price)/avg(tmp2.price))-1)*100),2) as price_percentage_diff,
	round(abs((((avg(tmp.avg_wage) / avg(tmp2.avg_wage))-1)*100) - (((avg(tmp.price)/avg(tmp2.price))-1)*100)),2) AS abs_diff,
	tmp.compared_year
FROM t_marek_posmura_project_sql_primary_finale tmp
LEFT JOIN t_marek_posmura_project_sql_primary_finale tmp2
	ON 1=1
	AND tmp.industry_name = tmp2.industry_name
	AND tmp.product = tmp2.product 
	AND tmp.compared_year = tmp2.compared_year + 1 
GROUP BY tmp.compared_year
ORDER BY tmp.compared_year
) AS z
ORDER BY abs_diff DESC
LIMIT 3
;
