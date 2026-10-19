-- Create 'gold.dim_customers' View
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers; 
GO 

CREATE VIEW gold.dim_customers AS 
SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_no,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status, 
	-- Use CRM as the master for gender information
	CASE
		WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'Unknown')
	END AS gender,
	ca.bdate AS birthdate, 
	ci.cst_create_date AS create_date 
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid

-- Check quality after view creation
-- SELECT * FROM gold.dim_customers


/*
SELECT * FROM silver.erp_loc_a101

-- Check where gender don't match between the two tables - silver.crm_cust_info and silver.erp_cust_az12
SELECT --DISTINCT
	ci.cst_gndr, 
	ca.gen 
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
WHERE cst_gndr != gen
ORDER BY 1, 2
*/


/*
-- Use CRM as the master for gender information 
-- Data integration
SELECT  
	ci.cst_gndr, 
	ca.gen,
	CASE
		WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'Unknown')
	END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid 
--ORDER BY 1, 2
*/