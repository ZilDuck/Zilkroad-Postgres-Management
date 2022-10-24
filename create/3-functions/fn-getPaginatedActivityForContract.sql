-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets the paginated listing/delisting/sold activity for a particular user
--              Copies the logic from ActivityForUser, but removes some unions
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 24-10-2022 - Nines - Inital creation
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedActivityForContract
(
    _contract_address varchar(42),
	_limit_rows numeric,
	_offset_rows numeric
) 
returns TABLE 
(
	activity varchar,
	tx_hash varchar(66),
	unixtime int8,
	token_id numeric(78,0),
	contract varchar,
	price_symbol varchar,
	price numeric(40,0),
	royalty_amount numeric(40,0),
	previous_price numeric(40,0),
	previous_symbol varchar
) 
AS 
$BODY$
BEGIN
	RETURN QUERY

	-- Get listings that haven't been edited
	SELECT 
		'Listed'::varchar as activity,
		tsl.listing_transaction_hash as tx_hash,
		tsl.listing_unixtime as unixtime,
		tnft.token_id as token_id,
		tnf.nonfungible_address as contract,
		tf.fungible_symbol as price_symbol,
		tsl.listing_fungible_token_price as price,
		0 as royalty_amount,
		0 as previous_price,
		'NULL' as previous_symbol

	FROM tbl_static_listing tsl

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id

	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE LOWER(tnf.nonfungible_address) = LOWER(_contract_address)

	UNION ALL

	-- Get the first listing prices for the listed that HAVE been edited
	SELECT
		'Listed'::varchar as activity,
		tsl.listing_transaction_hash as tx_hash,
		tsl.listing_unixtime as unixtime,
		tnft.token_id as token_id,
		tnf.nonfungible_address as contract,
		tf.fungible_symbol as price_symbol,
		tsel.new_fungible_token_price as price,
		0 as royalty_amount,
		tsel.previous_fungible_token_price as previous_price,
		(SELECT fungible_symbol from tbl_fungible where fungible_id in (SELECT previous_fungible_id FROM tbl_static_edit_listing where edit_listing_id = tsel.edit_listing_id)) as previous_symbol

	FROM tbl_static_listing tsl

	LEFT JOIN tbl_static_edit_listing tsel
		ON tsl.listing_id = tsel.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id

	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE LOWER(tnf.nonfungible_address) = LOWER(_contract_address) -- for a user

	UNION ALL

	SELECT
		'Delisted'::varchar AS activity,
		tsd.delisting_transaction_hash as tx_hash,
		tsd.delisting_unixtime as unixtime,
		tnft.token_id as token_id,
		tnf.nonfungible_address as contract,
		tf.fungible_symbol as price_symbol,
		tsl.listing_fungible_token_price as price,
		0 as royalty_amount,
		0 as previous_price,
		'NULL' as previous_symbol

	FROM tbl_static_delisting tsd

	LEFT JOIN tbl_static_listing tsl
		ON tsd.listing_id = tsl.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id
	
	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE LOWER(tnf.nonfungible_address) = LOWER(_contract_address)

	UNION ALL

	SELECT
		'Admin-Delist'::varchar AS activity,
		tsd.delisting_transaction_hash as tx_hash,
		tsd.delisting_unixtime as unixtime,
		tnft.token_id as token_id,
		tnf.nonfungible_address as contract,
		tf.fungible_symbol as price_symbol,
		tsl.listing_fungible_token_price as price,
		0 as royalty_amount,
		0 as previous_price,
		'NULL' as previous_symbol

	FROM tbl_static_delisting tsd

	LEFT JOIN tbl_static_listing tsl
		ON tsd.listing_id = tsl.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id
	
	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE LOWER(tnf.nonfungible_address) = LOWER(_contract_address)

	UNION ALL

	SELECT
		'Sale'::varchar AS activity,
		tss.sale_transaction_hash,
		tss.sale_unixtime as unixtime,
		tnft.token_id as token_id,
		tnf.nonfungible_address as contract,
		tf.fungible_symbol as price_symbol,
		tsl.listing_fungible_token_price as price,
		tss.royalty_amount_token as royalty_amount,
		0 as previous_price,
		'NULL' as previous_symbol

	FROM tbl_static_sale tss

	LEFT JOIN tbl_static_listing tsl
		ON tss.listing_id = tsl.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id

	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE LOWER(tnf.nonfungible_address) = LOWER(_contract_address)

	ORDER BY unixtime DESC
	LIMIT _limit_rows
   	OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
