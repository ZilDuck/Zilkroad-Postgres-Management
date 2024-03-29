-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets paginated listing where listed in a particular fungible contract
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedListingForFungible
(
    _fungible_address varchar,
	_limit_rows numeric,
	_offset_rows numeric
) 
returns TABLE 
(
    static_order_id int8,
    token_id numeric,
    nonfungible_address varchar,
    listing_fungible_token_price numeric,
    listing_block numeric,
    listing_unixtime int8,
    listing_user_address varchar,
    fungible_name varchar,
    fungible_symbol varchar,
    decimals numeric,
    fungible_address varchar
) 
AS 
$BODY$
BEGIN

    RETURN QUERY
    select 
        tsl.static_order_id,
        tnt.token_id,
        tnf.nonfungible_address,
        tsl.listing_fungible_token_price,
        tsl.listing_block,
        tsl.listing_unixtime,
        tsl.listing_user_address,
        tf.fungible_name,
        tf.fungible_symbol,
        tf.decimals,
        tf.fungible_address
    from tbl_nonfungible_token tnt
    left join tbl_nonfungible tnf
    on tnf.nonfungible_id = tnt.nonfungible_id 
    left join tbl_static_listing tsl 
    on tnt.extract_nft_id = tsl.extract_nft_id
    left join tbl_fungible tf
    on tf.fungible_id = tsl.fungible_id
    left join tbl_static_delisting td 
    on tsl.listing_id = td.delisting_id
    left join tbl_exclude_contract ex 
    on ex.nonfungible_id = tnt.nonfungible_id
    where
    tf.fungible_address = _fungible_address
    AND tsl.listing_id is not null
    AND td.delisting_id is  null
    AND ex.exclude_id is null
    order by tsl.static_order_id
    LIMIT _limit_rows
   	OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;