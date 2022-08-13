-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets the paginated listing/delisting/sold activity for a particular user
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 08-01-2022 - Nines - Inital creation.
-- 04-06-2022 - Badman - Refactor return data and query
-- 06-06-2022 - Nines - Add AdminReturn/UpgradeMarketplace history row
-- 08-08-2022 - Badman - Fix logic for wallet search
-- 13-08-2022 - Nines - Add Edit Price logic with new columns, Add tx hash for all activties
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedActivityForUser
(
    _listing_user_address varchar(42),
	_limit_rows numeric,
	_offset_rows numeric
) 
returns TABLE 
(
	activity varchar,
	unixtime int8,
	token_id numeric(78,0),
	contract varchar,
	price_symbol varchar,
	price numeric(40,0),
	royalty_amount numeric(40,0)
) 
AS 
$BODY$
BEGIN
	RETURN QUERY
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
		'NULL' as previous_symbol,
		0 as changed_price,
		'NULL' as changed_symbol

	FROM tbl_static_listing tsl

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id

	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE LOWER(tsl.listing_user_address) = LOWER(_listing_user_address)
	UNION ALL

	SELECT
		'Edit Price'::varchar as activity,
		tsel.edit_listing_transaction_hash as tx_hash,
		tsel.edit_listing_unixtime as unixtime,
		tnft.token_id as token_id,
		tnf.nonfungible_address as contract,
		tf.fungible_symbol as current_symbol,
		tsl.listing_fungible_token_price as current_price,
		0 as royalty_amount,
		tsel.previous_fungible_token_price as previous_price,
		(SELECT fungible_symbol from tbl_fungible where fungible_id in (SELECT previous_fungible_id FROM tbl_static_edit_listing where edit_listing_id = tsel.edit_listing_id)) as previous_symbol,
		tsel.new_fungible_token_price as changed_price,
		(SELECT fungible_symbol from tbl_fungible where fungible_id in (SELECT new_fungible_id FROM tbl_static_edit_listing where edit_listing_id = tsel.edit_listing_id)) as changed_symbol

	FROM tbl_static_listing tsl

	LEFT JOIN tbl_static_edit_listing tsel
		ON tsl.listing_id = tsel.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id

	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE LOWER(tsl.listing_user_address) = LOWER(_listing_user_address) -- for a user
	AND tsel.edit_listing_id is not null -- where we have edit rows that aren't joined with a null row
	AND tsel.previous_fungible_token_price != 0 -- and don't count the first row that starts 0,NULL -> x,y

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
		'NULL' as previous_symbol,
		0 as changed_price,
		'NULL' as changed_symbol

	FROM tbl_static_delisting tsd

	LEFT JOIN tbl_static_listing tsl
		ON tsd.listing_id = tsl.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id
	
	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE LOWER(tsl.listing_user_address) = LOWER(_listing_user_address)

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
		'NULL' as previous_symbol,
		0 as changed_price,
		'NULL' as changed_symbol

	FROM tbl_static_delisting tsd

	LEFT JOIN tbl_static_listing tsl
		ON tsd.listing_id = tsl.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id
	
	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE LOWER(tsl.listing_user_address) = LOWER(_listing_user_address)


	UNION ALL

	SELECT
		CAST(
			CASE
				WHEN LOWER(buyer_address) != LOWER(_listing_user_address)
				OR (
					LOWER(buyer_address) = LOWER(_listing_user_address)
					AND LOWER(listing_user_address) = LOWER(_listing_user_address)
				) THEN 'Sold' 
			END
			AS varchar
		) AS activity,
                tss.sale_transaction_hash,
		tss.sale_unixtime as unixtime,
		tnft.token_id as token_id,
		tnf.nonfungible_address as contract,
		tf.fungible_symbol as price_symbol,
		tsl.listing_fungible_token_price as price,
		tss.royalty_amount_token as royalty_amount,
		0 as previous_price,
		'NULL' as previous_symbol,
		0 as changed_price,
		'NULL' as changed_symbol

	FROM tbl_static_sale tss

	LEFT JOIN tbl_static_listing tsl
		ON tss.listing_id = tsl.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id

	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE LOWER(tsl.listing_user_address) = LOWER(_listing_user_address)

	UNION ALL

	SELECT
		CAST(
			CASE
				WHEN LOWER(tss.buyer_address) = LOWER(_listing_user_address) THEN 'Bought'
				WHEN LOWER(tss.buyer_address) = LOWER(_listing_user_address) AND LOWER(tsl.listing_user_address) = LOWER(_listing_user_address) THEN 'Bought' 
			END 
			AS varchar
		) AS activity,
                tss.sale_transaction_hash,
		tss.sale_unixtime as unixtime,
		tnft.token_id as token_id,
		tnf.nonfungible_address as contract,
		tf.fungible_symbol as price_symbol,
		tsl.listing_fungible_token_price as price,
		tss.royalty_amount_token as royalty_amount,
		0 as previous_price,
		'NULL' as previous_symbol,
		0 as changed_price,
		'NULL' as changed_symbol

	FROM tbl_static_sale tss

	LEFT JOIN tbl_static_listing tsl
		ON tss.listing_id = tsl.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id

	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE LOWER(tss.buyer_address) = LOWER(_listing_user_address)

	ORDER BY unixtime DESC
	LIMIT _limit_rows
   	OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
