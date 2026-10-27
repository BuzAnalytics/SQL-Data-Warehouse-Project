-- Create 'gold.fact_sales' View
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales; 
GO 

-- We replaced prd_key and cust_id with surrogate keys as we use surrogate keys as our star schemas
-- Ordering arrangements: 
	-- dimension keys (order_no, product_key, customer_key) then
	-- dates (order_date, ship_date, due_date) then
	-- measures (sales_amount, quantity, price)
CREATE VIEW gold.fact_sales AS
SELECT 
	sd.sls_ord_num AS order_no, 
	pd.product_key, 
	cd.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS ship_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price 
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pd
ON sd.sls_prd_key = pd.product_no
LEFT JOIN gold.dim_customers cd
ON sls_cust_id = cd.customer_id

-- SELECT * FROM gold.fact_sales


/*
-- Integrity check about the foreign keys after creating the gold architectures 
-- customer check
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
on f.customer_key = c.customer_key
WHERE c.customer_key IS NULL

-- product check
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
on f.product_key = p.product_key
WHERE p.product_key IS NULL
*/
