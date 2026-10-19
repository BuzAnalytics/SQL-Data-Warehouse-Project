-- Create 'gold.dim_products' View
IF OBJECT_ID('gold.dim_product', 'V') IS NOT NULL
	DROP VIEW gold.dim_products; 
GO

CREATE VIEW gold.dim_products AS
SELECT
ROW_NUMBER() OVER(ORDER BY pa.prd_start_dt, pa.prd_key) AS product_key,
	pa.prd_id AS product_id,
	pa.prd_key AS product_no,
	pa.prd_nm AS product_name,
	pa.prd_cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pa.prd_cost AS cost,
	pa.prd_line AS product_line,
	pa.prd_start_dt AS start_date 
FROM silver.crm_prd_info pa
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pa.prd_cat_id = pc.id
-- Filter historical data
WHERE pa.prd_end_dt IS NULL 


-- SELECT * FROM gold.dim_products
-- SELECT * FROM silver.erp_px_cat_g1v2


/*
-- Check product key is unique (no duplicates) as we will join products with customers
SELECT prd_key, COUNT(*) FROM 
(
SELECT 
	pa.prd_id,
	pa.prd_cat_id,
	pa.prd_key,
	pa.prd_nm,
	pa.prd_cost,
	pa.prd_line,
	pa.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver.crm_prd_info pa
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pa.prd_cat_id = pc.id
-- Filter historical data
WHERE pa.prd_end_dt IS NULL
)t
GROUP BY prd_key
HAVING COUNT(*) > 1
*/