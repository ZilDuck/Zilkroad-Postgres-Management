-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose     Stores contracts deemed to be non ruggable
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_verified_contract" (
	verified_id SERIAL PRIMARY KEY,
	nonfungible_id serial REFERENCES tbl_nonfungible (nonfungible_id)
);
