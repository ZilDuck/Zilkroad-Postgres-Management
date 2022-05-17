-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets the listing/delisting/sold activity for a particular wallet
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_static_sale" (
	static_sale_id SERIAL PRIMARY KEY,
	listing_id serial REFERENCES tbl_static_listing (listing_id),
	sale_transaction_hash varchar(66) NOT NULL,
	sale_block numeric NOT NULL,
	sale_unixtime int8 NOT NULL,
	buyer_address varchar(42) NULL,
	royalty_recipient_address varchar(42) NULL,
	tax_recipient_address varchar(42) NULL,
	one_token_as_usd numeric(40,0) NOT NULL,
	tax_amount_token numeric(40,0) NULL,
	tax_amount_usd numeric(15, 2) NULL,
	royalty_amount_token numeric(40,0) NULL,
	royalty_amount_usd numeric(15, 2) NULL,
	final_sale_after_taxes_tokens numeric(40,0) NULL,
	final_sale_after_taxes_usd numeric(15, 2) NULL
);
ALTER SEQUENCE tbl_static_sale_static_sale_id_seq RESTART WITH 1;
