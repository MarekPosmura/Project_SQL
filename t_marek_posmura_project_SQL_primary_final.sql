
/* Výzkumné otázky pro primární tabulku   
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

czechia_payroll
czechia_price
5958	Průměrná hrubá mzda na zaměstnance
 */

-- u JOINu můžou byt použity podmínky AND atd, nahradí se tím WHERE
  

/* toto mi nejde sestavit, zkusím to pomocí views, pak se k tomu vrátím
SELECT 
	cpc.name AS product,
	cp.value AS price,
	cpib.name AS industry,
	cp2.value AS average_wage,
	YEAR(cp.date_from),
	cp2.payroll_year 
FROM czechia_price cp 
LEFT JOIN czechia_payroll cp2 
	ON YEAR(cp.date_from) = cp2.payroll_year 
	AND cp2.value_type_code = 5958
	AND cp.region_code IS NULL 
LEFT JOIN czechia_price_category cpc 
	ON cpc.code = cp.category_code 
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON cpib.code = cp2.industry_branch_code

	;
	
*/

SELECT
	max(date_from),
	min(date_from)
FROM czechia_price cp 
-- 2006-2018

SELECT
	max(payroll_year),
	min(payroll_year)
FROM czechia_payroll cp 
-- 2000-2021


/*	Vytvoření pomocné tabulky payroll_table do roku 2016 (včetně)
	V datové sadě czechia_payroll jsou data do roku 2016 definitivní, údaje za rok 2017, 2018 a 2019 jsou předběžné.
	Dle dokumentace na Portálu otevřených dat ČR.
	Tabulka czechia_price obsahuje údaje za roky 2006-2018.
	Finální použité roky jsou tedy 2006-2016. 
*/

CREATE VIEW IF NOT EXISTS v_payroll_view AS
SELECT
	cpib.name AS industry_name,
	round(avg(cp.value),0) AS avg_payroll,
	cp.payroll_year
FROM czechia_payroll cp 
LEFT JOIN czechia_payroll_industry_branch cpib
	ON cp.industry_branch_code = cpib.code 
WHERE cp.value_type_code = 5958
	AND cp.payroll_year BETWEEN 2006 AND 2016
	AND cp.industry_branch_code IS NOT NULL
GROUP BY
	cpib.name,
	cp.payroll_year 
ORDER BY cp.industry_branch_code, cp.payroll_year
;

-- -----------------------------------------------

CREATE VIEW IF NOT EXISTS v_prices_view AS
SELECT
	cpc.name AS product,
	round(avg(cp.value),2) AS price,
	year(date_from) AS price_year
FROM czechia_price cp
LEFT JOIN czechia_price_category cpc 
	ON cpc.code = cp.category_code 
WHERE YEAR(date_from) BETWEEN 2006 AND 2016
	AND region_code IS NULL 
GROUP BY
	cpc.name,
	year(date_from)

-- -----------------------------------------------

CREATE TABLE IF NOT EXISTS t_marek_posmura_project_SQL_primary_finale AS
SELECT
	vpr.product,
	vpr.price,
	vpa.industry_name,
	vpa.avg_payroll,
	vpa.payroll_year AS compared_year
FROM v_prices_view vpr
LEFT JOIN v_payroll_view vpa 
	ON vpr.price_year = vpa.payroll_year
ORDER BY vpr.product, vpa.payroll_year, vpa.industry_name 










