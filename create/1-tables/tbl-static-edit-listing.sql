-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Stores edit listing events
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 01-08-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_static_edit_listing" (
	edit_listing_id SERIAL PRIMARY KEY,
	listing_id SERIAL REFERENCES tbl_static_listing (listing_id),
	edit_listing_transaction_hash varchar(66) NOT NULL,
	previous_fungible_id SERIAL REFERENCES tbl_fungible (fungible_id),
	previous_fungible_token_price numeric(40,0) NOT NULL,
	new_fungible_id SERIAL REFERENCES tbl_fungible (fungible_id),
	new_fungible_token_price numeric(40,0) NOT NULL,
	edit_listing_block numeric NOT NULL,
	edit_listing_unixtime int8 NOT NULL,
);
ALTER SEQUENCE tbl_static_listing_listing_id_seq RESTART WITH 1;
