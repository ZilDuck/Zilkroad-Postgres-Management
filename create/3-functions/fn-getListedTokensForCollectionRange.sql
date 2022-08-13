-------------------------------------------------------------------------------
-- Created      12-08-2022
-- Purpose      Gets any listed tokens within a range for a given collection
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 12-08-2022  Badman Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getListedTokensForCollectionRange
(
    _nonfungible_address varchar,
	_min_token numeric,
	_max_token numeric
) 
returns TABLE 
(
    token_id numeric,
    listing_fungible_token_price numeric,
    fungible_symbol varchar,
    decimals numeric
) 
AS 
$BODY$
BEGIN

    RETURN QUERY
    SELECT 
        tnft.token_id,
        tsl.listing_fungible_token_price,
        tf.fungible_symbol,
        tf.decimals
    
    FROM tbl_nonfungible tnf

    INNER JOIN tbl_nonfungible_token tnft
        ON tnf.nonfungible_id = tnft.nonfungible_id
    
    INNER JOIN tbl_static_listing tsl
        ON tnft.extract_nft_id = tsl.extract_nft_id

    INNER JOIN tbl_fungible tf
        ON tsl.fungible_id = tf.fungible_id

    WHERE 
        LOWER(tnf.nonfungible_address) = LOWER(_nonfungible_address)
        AND tsl.listing_id NOT IN (
            SELECT listing_id FROM tbl_static_delisting
            UNION 
            SELECT listing_id FROM tbl_static_sale
        )
        AND tnft.token_id BETWEEN _min_token AND _max_token

    ORDER BY tnft.token_id ASC;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;