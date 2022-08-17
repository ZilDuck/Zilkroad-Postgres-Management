-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Stores nonfungible tokens
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_nonfungible_token" (
	extract_nft_id SERIAL PRIMARY KEY,
	nonfungible_id serial REFERENCES tbl_nonfungible (nonfungible_id),
	token_id numeric(78,0) not null
);
ALTER SEQUENCE tbl_nonfungible_token_extract_nft_id_seq RESTART WITH 1;
