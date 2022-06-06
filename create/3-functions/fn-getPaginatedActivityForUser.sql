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
		'List'::varchar as activity,
		listing_unixtime as unixtime,
		tnft.token_id as token_id,
		nonfungible_address as contract,
		tf.fungible_symbol as price_symbol,
		listing_fungible_token_price as price,
		0 as royalty_amount

	FROM tbl_static_listing tsl

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id

	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE tsl.listing_user_address = _listing_user_address

	UNION ALL

	SELECT
		'De-list'::varchar AS activity,
		delisting_unixtime as unixtime,
		tnft.token_id as token_id,
		nonfungible_address as contract,
		tf.fungible_symbol as price_symbol,
		listing_fungible_token_price as price,
		0 as royalty_amount

	FROM tbl_static_delisting tsd

	LEFT JOIN tbl_static_listing tsl
		ON tsd.listing_id = tsl.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id
	
	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE tsl.listing_user_address = _listing_user_address

	UNION ALL

	SELECT
		'Admin-Delist'::varchar AS activity,
		delisting_unixtime as unixtime,
		tnft.token_id as token_id,
		nonfungible_address as contract,
		tf.fungible_symbol as price_symbol,
		listing_fungible_token_price as price,
		0 as royalty_amount

	FROM tbl_static_delisting tsd

	LEFT JOIN tbl_static_listing tsl
		ON tsd.listing_id = tsl.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id
	
	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE tsl.listing_user_address = '0xD166db1a29Fec78c17DBF2CedA31df3a819B1553'


	UNION ALL

	SELECT
		CAST(
			CASE
				WHEN buyer_address != _listing_user_address OR (buyer_address = _listing_user_address AND listing_user_address = _listing_user_address) THEN 'Sell' 
			END
			AS varchar
		) AS activity,
		sale_unixtime as unixtime,
		tnft.token_id as token_id,
		nonfungible_address as contract,
		tf.fungible_symbol as price_symbol,
		listing_fungible_token_price as price,
		royalty_amount_token as royalty_amount

	FROM tbl_static_sale tss

	LEFT JOIN tbl_static_listing tsl
		ON tss.listing_id = tsl.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id

	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE tsl.listing_user_address = _listing_user_address

	UNION ALL

	SELECT
		CAST(
			CASE
				WHEN buyer_address = _listing_user_address THEN 'Buy'
				WHEN buyer_address = _listing_user_address AND listing_user_address = _listing_user_address THEN 'Buy' 
			END 
			AS varchar
		) AS activity,
		sale_unixtime as unixtime,
		tnft.token_id as token_id,
		nonfungible_address as contract,
		tf.fungible_symbol as price_symbol,
		listing_fungible_token_price as price,
		royalty_amount_token as royalty_amount

	FROM tbl_static_sale tss

	LEFT JOIN tbl_static_listing tsl
		ON tss.listing_id = tsl.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id

	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	WHERE tsl.listing_user_address = _listing_user_address

	ORDER BY unixtime DESC
	LIMIT _limit_rows
   	OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
