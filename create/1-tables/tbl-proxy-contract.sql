-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Stores deployed proxy contracts to buy primary sales from
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_proxy_contract" (
	proxy_id SERIAL PRIMARY KEY,
	proxy_address varchar(42) NOT NULL,
	proxy_nonfungible_address varchar(42) NOT NULL,
	proxy_max_mint numeric NOT NULL,
	proxy_price_cost_qa numeric(42) NOT NULL,
	proxy_beneficiary_address varchar(42) NOT NULL,
	proxy_open_mint_block numeric NOT NULL
);
ALTER SEQUENCE tbl_proxy_contract_proxy_id_seq RESTART WITH 1;
