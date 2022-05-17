-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets the listing/delisting/sold activity for a particular wallet
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_exclude_contract" (
	exclude_id SERIAL PRIMARY KEY,
	nonfungible_id SERIAL REFERENCES tbl_nonfungible (nonfungible_id)
);
ALTER SEQUENCE tbl_exclude_contract_exclude_id_seq RESTART WITH 1;
