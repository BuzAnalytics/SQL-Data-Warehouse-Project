/*
=================================
bronze.crm_prd_info Data cleaning to silver.crm_prd_info
=================================
*/

SELECT * FROM bronze.crm_prd_info

-- Check for Duplicates or NULLs in primary key
-- Expectation: No result
SELECT 
	prd_id,
	COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL


-- Check for leading or trailing spaces (prd_key & prd_nm)
SELECT prd_nm FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

SELECT DISTINCT prd_line FROM bronze.crm_prd_info

SELECT * FROM bronze.crm_prd_info

-- Check for NULLS or negative numbers
-- Expectation: No results
SELECT prd_cost FROM bronze.crm_prd_info WHERE prd_cost IS NULL OR prd_cost < 0

-- Check for invalid date orders
SELECT 
*
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt
