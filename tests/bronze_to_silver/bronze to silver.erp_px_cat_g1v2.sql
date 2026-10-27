
/*
=================================
load silver.erp_px_cat_g1v2 from transformed bronze.erp_px_cat_g1v2
There is no data cleaning or trnasformation performed on this table
But there is a row (id = CO_PD) found here that is no in silver.crm_prd_info table 
=================================
*/
INSERT INTO silver.erp_px_cat_g1v2 (
	id,
	cat,
	subcat,
	maintenance
)
SELECT 
	id,
	cat,
	subcat,
	maintenance
FROM bronze.erp_px_cat_g1v2
 


-- Check for unwanted spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat)

-- Data standardization and consistency 
SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2

 
