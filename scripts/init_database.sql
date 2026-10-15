
/*
-------------------------------------------------------------------
Creating Database 'DataWarehouse' and Schemas: bronze, silver, gold
-------------------------------------------------------------------

Purpose:
	This script creates a new database named 'DataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated. After that the script creates three schemas 
	within the database - 'bronze', 'silver', and 'gold'.

WARNING:
	Running this script will drop the entire database 'DataWarehouse' if it exists.
	Meaning all data in the database will be permanently deleted. Please proceed with 
	caution and ensure you have proper backup before running this script. 
*/

USE master;
GO -- More like a separator. It tells sql execute this first before moving to next 

-- Check if the database exists first before trying to create it
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse
END;
GO

-- Create Database 'DataWarehouse' 
CREATE DATABASE DataWarehouse;
GO

-- Use database 'DataWarehouse' (Make it active database)
USE DataWarehouse;
GO

-- Create Data Warehouse (Medallion) architecture schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
