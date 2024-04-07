-- 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT
	tmp.product,
	tmp.price,
	tmp.compared_year,
	round(avg((tmp.avg_wage) * 12),0) AS avg_wage_year,
	floor(avg(tmp.avg_wage) * 12 / price) AS product_per_year
FROM t_marek_posmura_project_sql_primary_final tmp
WHERE 1=1
	AND tmp.compared_year IN (2006, 2016)
	AND tmp.product IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
GROUP BY tmp.product, tmp.compared_year
;