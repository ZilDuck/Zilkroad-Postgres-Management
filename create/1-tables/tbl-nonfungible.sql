-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Stores non fungible contracts
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-- 11-10-2022  Rich add ts vector.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_nonfungible" (
	nonfungible_id SERIAL PRIMARY KEY,
	nonfungible_address varchar(42) NOT NULL,
	nonfungible_symbol varchar(255) NOT NULL,
	nonfungible_name varchar(255) NOT NULL,
	simple_tsvector tsvector
	GENERATED ALWAYS AS
	(
		setweight(
			to_tsvector(
				'simple', coalesce(nonfungible_symbol, '')
			),
			'A'
		) ||
		setweight(
			to_tsvector(
				'simple', coalesce(nonfungible_name, '')
			),
			'B'
		)
	) STORED;
);
ALTER SEQUENCE tbl_nonfungible_nonfungible_id_seq RESTART WITH 1;
