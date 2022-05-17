-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets paginated floor prices for all listed NFTs
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 08-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedCollectionFloors
(
	_limit_rows numeric,
	_offset_rows numeric
) 
returns TABLE 
(
    static_order_id int8,
    fungible_address varchar,
    listing_fungible_token_price numeric,
    nonfungible_address varchar,
    token_id numeric
) 
AS 
$BODY$
BEGIN

    RETURN QUERY
    select
        tsl.static_order_id,
        tf.fungible_address,
        min(tsl.listing_fungible_token_price) as floor_minimum_price_in_token,
        tnf.nonfungible_address,
        tnt.token_id 
    from tbl_static_listing tsl 
    left join tbl_static_delisting td 
    on tsl.listing_id = td.listing_id 
    left join tbl_nonfungible_token tnt  
    on tsl.extract_nft_id = tnt.extract_nft_id 
    left join tbl_nonfungible tnf
    on tnf.nonfungible_id = tnt.nonfungible_id 
        left join tbl_fungible tf
        on tf.fungible_id = tsl.fungible_id
    group by 
        tsl.static_order_id,
        tf.fungible_address,    
        tnf.nonfungible_address,
        tnt.token_id 
        LIMIT _limit_rows
        OFFSET _offset_rows;
END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;

