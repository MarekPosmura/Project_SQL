-- User name on Discord: marekp._


-- A) první varianta za pomocí spojení dvou pohledů (5,472 záznamů)

CREATE OR REPLACE VIEW v_payroll_view AS
SELECT
	cpib.name AS industry_name,
	round(avg(cp.value),0) AS avg_wage,
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

CREATE OR REPLACE VIEW v_prices_view AS
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
;
-- -----------------------------------------------

CREATE OR REPLACE TABLE t_marek_posmura_project_SQL_primary_final AS
SELECT
	vpr.product,
	vpr.price,
	vpa.industry_name,
	vpa.avg_wage,
	vpa.payroll_year AS compared_year
FROM v_prices_view vpr
LEFT JOIN v_payroll_view vpa 
	ON vpr.price_year = vpa.payroll_year
ORDER BY vpr.product, vpa.payroll_year, vpa.industry_name 
;