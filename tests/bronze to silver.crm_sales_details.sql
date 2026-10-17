
/*
=================================
bronze.crm_sales_details Data cleaning to silver.crm_sales_details
=================================
*/

 
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id, 
	CASE 
		WHEN sls_order_dt = 0 OR LEN(sls_order_dt) < 8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) -- Cast to VARCHAR before casting to DATE
	END AS sls_order_dt,
	CASE 
		WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) < 8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) -- Cast to VARCHAR before casting to DATE
	END AS sls_ship_dt,
	CASE 
		WHEN sls_due_dt = 0 OR LEN(sls_due_dt) < 8 THEN NULL
		ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) -- Cast to VARCHAR before casting to DATE
	END AS sls_due_dt, 
	CASE
		WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales, 
	sls_quantity,
		CASE
		WHEN sls_price IS NULL OR sls_price <= 0 THEN ABS(sls_sales) / NULLIF(sls_quantity, 0)
		ELSE sls_price
	END AS sls_price 
FROM bronze.crm_sales_details


 -- Check for extra (leading and trailing) space
SELECT 
	*
FROM bronze.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key)


SELECT * FROM bronze.crm_sales_details
-- Check values not found in other related table (sls_prd_key, sls_cust_id)
SELECT 
	*
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN 
(SELECT cst_id FROM silver.crm_cust_info)


-- Check for NULLs or negative numbers (sls_sales, sls_quantity, sls_price)
-- Expectation: No result
SELECT
	*
FROM bronze.crm_sales_details
WHERE sls_price IS NULL OR sls_price < 0 


-- Check for NULLs or negative numbers (sls_sales, sls_quantity, sls_price)
-- Expectation: No result
SELECT * FROM bronze.crm_sales_details

SELECT
	*
FROM
(
SELECT 
	CASE
		WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales,
	sls_quantity,
	CASE
		WHEN sls_price IS NULL OR sls_price <= 0 THEN ABS(sls_sales) / NULLIF(sls_quantity, 0)
		ELSE sls_price
	END AS sls_price 
FROM bronze.crm_sales_details
)t
WHERE sls_sales != sls_quantity * sls_price
	OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
	OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
 

-- Check for invalid dates (sls_order_dt, sls_ship_dt, sls_due_dt)
SELECT
	sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
	OR LEN(sls_due_dt) < 8 -- 20101229 for eg is 8 characters (2012 for year, 12 12 for month, and 29 for day) 
	OR sls_due_dt > 20500101 -- Upper date boundary
	OR sls_due_dt < 19000101 -- Lower date boundary
	-- Convert any of these date abnormaties to NULL

-- Check for invalid date orders (be sure order date is less than ship or due date)
SELECT 
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

 