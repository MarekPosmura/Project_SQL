-- 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- první a poslední srovnávané období = první a podlední rok, tedy v letech 2006 a 2016


-- -----------------------------------------------------------------------
-- A) varianta do jednoho dotazu bez použití pohledů


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
	WHERE 1=1
		AND compared_year IN (2006, 2016)
	) AS x
WHERE product IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
GROUP BY product, compared_year 


-- -----------------------------------------------------------------------
-- B) varianta do jednoho dotazu s použitím CTE (with)

WITH draft_tabel AS
	(
	SELECT *
	FROM t_marek_posmura_project_sql_primary_finale tmp
	WHERE 1=1
		AND compared_year IN (2006, 2016)
	)
SELECT 
	product,
	price,
	compared_year,
	-- round(avg(avg_wage),0) AS avg_wage_month,
	round(avg((avg_wage)*12),0) AS avg_wage_year,
	floor(avg(avg_wage)*12 / price) AS product_per_year -- funkce floor vrátí nějvětší celou hodnotu
FROM draft_tabel
WHERE product IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
GROUP BY product, compared_year 












