/*
=================================
load silver.crm_cust_info from transformed bronze.crm_cust_info
=================================
*/
-- Check for Duplicates or NULLs in primary key
-- Expectation: No result

SELECT 
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

SELECT * FROM bronze.crm_cust_info




-- Check for leading or trailing spaces (cst_firstname & cst_lastname)
SELECT cst_firstname FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

--Data standardization & Consistency (cst_marital_status & cst_gndr)
SELECT DISTINCT cst_gndr FROM bronze.crm_cust_info
 
-- SELECT * FROM bronze.crm_cust_info WHERE cst_id  = 29466