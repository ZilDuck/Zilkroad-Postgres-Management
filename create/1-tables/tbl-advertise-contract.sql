-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets the long banner card shown on most pages
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_advertise_contract" (
	advertise_id SERIAL PRIMARY KEY,
	nonfungible_id SERIAL REFERENCES tbl_nonfungible (nonfungible_id),
	advertise_start_unixtime int8 NOT NULL,
	advertise_end_unixtime int8 NOT NULL,
	advertise_description text NOT NULL,
	half_image text,   /* nullable */
	quarter_image text /* nullable */
);
ALTER SEQUENCE tbl_advertise_contract_advertise_id_seq RESTART WITH 1;
