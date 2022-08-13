-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Stores ZNS lookups 
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_domain_lookup" (
	domain_id SERIAL PRIMARY KEY,
	user_address varchar(42),
	user_domain text
);
ALTER SEQUENCE tbl_domain_lookup_domain_id_seq RESTART WITH 1;
