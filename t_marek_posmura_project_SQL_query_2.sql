-- 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- první a poslední srovnávané období = první a podlední rok, tedy v letech 2006 a 2016

-- první varianta s použitím pohledů

CREATE OR REPLACE VIEW v_product_view AS
SELECT *
FROM t_marek_posmura_project_sql_primary_finale tmp
WHERE compared_year  = 2006
	OR compared_year = 2016
 	

SELECT 
	product,
	price,
	compared_year,
	round(avg(avg_wage),0) AS avg_wage_year,
	floor(avg(avg_wage) / price) AS product_per_year -- funkce floor vrátí nějvětší celou hodnotu
FROM v_product_view vpv 
WHERE product IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
GROUP BY product, compared_year 

-- -----------------------------------------------------------------------
-- druhá varianta do jednoho dotazu bez použití pohledů

SELECT *
FROM
	(
	SELECT 
		product,
		price,
		compared_year,
		round(avg(avg_wage),0) AS avg_wage_year,
		floor(avg(avg_wage) / price) AS product_per_year -- funkce floor vrátí nějvětší celou hodnotu
	FROM 
		(
		SELECT *
		FROM t_marek_posmura_project_sql_primary_finale tmp
		WHERE
			compared_year  = 2006
			OR compared_year = 2016
		) AS x
	WHERE product IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
	GROUP BY product, compared_year 
	) AS y
WHERE
	compared_year  = 2006
	OR compared_year = 2016
 
