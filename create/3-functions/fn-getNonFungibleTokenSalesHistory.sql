-------------------------------------------------------------------------------
-- Created      07-05-2022
-- Purpose      Gets the sale history for a NFT
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 07-05-2022  Rich  - Inital creation.
-- 02-11-2022  Nines - Replaced contract with buyer/seller
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getNonFungibleTokenSalesHistory
(
    _nonfungible_address varchar,
    _token_id numeric
) 
returns TABLE 
(
    activity varchar,
	unixtime int8,
	seller varchar,
	buyer varchar,
	price_symbol varchar,
	price numeric(40,0)
) 
AS 
$BODY$
BEGIN

RETURN QUERY
    SELECT 'Buy'::varchar as activity,
    	sale_unixtime as unixtime,
		tsl.listing_user_address as seller,
		tss.buyer_address as buyer,
		tf.fungible_symbol as price_symbol,
		listing_fungible_token_price as price

	FROM tbl_static_sale tss

	LEFT JOIN tbl_static_listing tsl
		ON tss.listing_id = tsl.listing_id

	LEFT JOIN tbl_nonfungible_token tnft
		ON tsl.extract_nft_id = tnft.extract_nft_id

	LEFT JOIN tbl_nonfungible tnf
		ON tnft.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

    WHERE   tnf.nonfungible_address = LOWER(_nonfungible_address)
    AND     tnft.token_id = _token_id
    AND     tsl.listing_id NOT IN (
        SELECT listing_id
        FROM tbl_static_delisting
    );

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;