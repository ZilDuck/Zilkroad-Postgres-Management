-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose     Stores listing events
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_static_listing" (
	listing_id SERIAL PRIMARY KEY,
	extract_nft_id serial REFERENCES tbl_nonfungible_token (extract_nft_id),
	fungible_id SERIAL REFERENCES tbl_fungible (fungible_id),
	static_order_id int8 not null,
	listing_transaction_hash varchar(66) NOT NULL,
	listing_fungible_token_price numeric(40,0) NOT NULL,
	listing_block numeric NOT NULL,
	listing_unixtime int8 NOT NULL,
	listing_user_address varchar(42) NOT NULL
);
ALTER SEQUENCE tbl_static_listing_listing_id_seq RESTART WITH 1;
