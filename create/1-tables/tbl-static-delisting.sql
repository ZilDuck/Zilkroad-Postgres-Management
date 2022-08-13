-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Stores delisted events
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_static_delisting" (
	delisting_id SERIAL PRIMARY KEY,
	listing_id serial REFERENCES tbl_static_listing (listing_id),
	delisting_transaction_hash varchar(66) NOT NULL,
	delisting_block numeric NOT NULL,
	delisting_unixtime int8 NOT NULL
);
ALTER SEQUENCE tbl_static_delisting_delisting_id_seq RESTART WITH 1;
