
/*
=================================
load silver.erp_cust_az12 from transformed bronze.erp_cust_az12
=================================
*/
INSERT INTO silver.erp_cust_az12 (
	cid,
	bdate,
	gen
)
SELECT 
	-- Remove 'NAS' from cid that have them (cid)
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END cid, 
	-- Remove impossible birthday from the list (bdate) 
	-- (Assumption is we remove birthday in the future only even though there are some that are more than 100 years)
	CASE
		WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END AS bdate, 
	-- Data standardization and consistency
	-- Have only Male, Female, and Unkwown (gen) 
	CASE 
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
 		ELSE 'Unkown'
	END gen
FROM bronze.erp_cust_az12
 
 


 
