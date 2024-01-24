-- 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

-- hledám za sledované období (2006-2016) nejmenší průměrný roční nárůst (průměr za všechny roky)

-- "jakostní víno bílé" je na seznamu pouze od roku 2015, starší údaje nejsou


SELECT
	product_x,
	round(avg(percentage_diff),2) AS avg_percentage_diff
FROM
(
	SELECT 
		tmp.product AS product_x,
		tmp.price,
		tmp.compared_year,
		tmp2.price AS price_previous_year,
		tmp2.compared_year AS previous_year,
		round((((tmp.price/tmp2.price)-1)*100),2) as percentage_diff
	FROM t_marek_posmura_project_sql_primary_finale tmp
	LEFT JOIN t_marek_posmura_project_sql_primary_finale tmp2
		ON 1=1
		AND tmp.product = tmp2.product 
		AND tmp.compared_year = tmp2.compared_year + 1
	GROUP BY tmp.compared_year, tmp.product
	ORDER BY tmp.product, tmp.compared_year  
) AS x
GROUP BY product_x
ORDER BY avg_percentage_diff
;
	
-- dotaz na průběh cen jednotlivých produktů (pouze měnit konkrétní "product_y" ve WHERE klauzuli)
SELECT *
FROM (
	SELECT 
		tmp.product AS product_y,
		tmp.price,
		tmp.compared_year,
		tmp2.price AS price_previous_year,
		tmp2.compared_year AS previous_year,
		round((((tmp.price/tmp2.price)-1)*100),2) as percentage_diff
	FROM t_marek_posmura_project_sql_primary_finale tmp
	LEFT JOIN t_marek_posmura_project_sql_primary_finale tmp2
		ON tmp.product = tmp2.product 
		AND tmp.compared_year = tmp2.compared_year + 1
	GROUP BY tmp.compared_year, tmp.product
	ORDER BY tmp.product, tmp.compared_year  
) AS y
WHERE 1=1
	AND previous_year IS NOT NULL
	AND product_y = 'Papriky'
