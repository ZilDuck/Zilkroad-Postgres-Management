-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets the listing/delisting/sold activity for a particular wallet
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_fungible" (
	fungible_id SERIAL PRIMARY KEY,
	fungible_address varchar(42) NOT NULL,
	fungible_name varchar(255) NOT NULL,
	fungible_symbol varchar(255) NOT NULL,
	decimals numeric(40,0) NOT NULL
);
ALTER SEQUENCE tbl_fungible_fungible_id_seq RESTART WITH 1;
