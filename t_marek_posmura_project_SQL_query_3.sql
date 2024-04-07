-- 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?


WITH first_query AS (
	SELECT 
		tmp.product,
		tmp.compared_year,
		tmp.price,
		LAG(tmp.price) OVER (PARTITION BY tmp.product ORDER BY tmp.compared_year) AS lag_price
	FROM t_marek_posmura_project_sql_primary_final tmp
),
second_query AS (
	SELECT *,
		price - lag_price AS difference,
		round((price / lag_price - 1) * 100,2) AS percentage_diff
	FROM first_query
	WHERE lag_price IS NOT NULL
)
SELECT 
	product,
	sum(percentage_diff) AS perc_price_growth
FROM second_query
GROUP BY product
ORDER BY perc_price_growth
;

-- dotaz na průběh cen jednotlivých produktů (pouze měnit konkrétní "product_y" ve WHERE klauzuli)
	
WITH base AS (
	SELECT 
		tmp.product AS product_y,
		tmp.compared_year,
		tmp.price,
		LAG(tmp.price) OVER (PARTITION BY tmp.product ORDER BY tmp.compared_year) AS lag_price
	FROM t_marek_posmura_project_sql_primary_final tmp
	GROUP BY tmp.compared_year, tmp.product
	ORDER BY tmp.product, tmp.compared_year  
)
SELECT *,
	round(((price / lag_price - 1) * 100),2) as percentage_diff
FROM base
WHERE 1=1
	AND lag_price IS NOT NULL
	AND product_y = 'Papriky'	
;	
	
	
	
	
	
	
