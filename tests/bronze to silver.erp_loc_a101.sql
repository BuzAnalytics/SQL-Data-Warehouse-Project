
/*
=================================
load silver.erp_loc_a101 from transformed bronze.erp_loc_a101
=================================
*/
INSERT INTO silver.erp_loc_a101 (
	cid,
	cntry
)
SELECT 
	-- Replace character from cid
	REPLACE(cid, '-', '') cid,  
	-- Data standardization and consistency (cntry)
	CASE
		WHEN cntry IN ('DE', 'Germany') THEN 'Germany'
		WHEN cntry IN ('USA', 'US', 'United States') THEN 'United States'
		WHEN TRIM(cntry) IS NULL OR cntry = '' THEN 'Unkown'
		ELSE cntry 
	END AS cntry 
FROM bronze.erp_loc_a101 


  
 
 