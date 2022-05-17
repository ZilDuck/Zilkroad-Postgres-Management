-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets paginated sales for a particular contract returns most recent first
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 13-02-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedMostRecentSalesForContract
(
	_limit_rows numeric,
	_offset_rows numeric,
    _nonfungible_address varchar
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
    FROM tbl_static_listing tsl 
    left join tbl_static_sale tss
    on tss.listing_id = tsl.listing_id
    left join tbl_nonfungible_token tnt
    on tnt.extract_nft_id = tsl.extract_nft_id
    left join tbl_nonfungible tnf
    on tnf.nonfungible_id = tnt.nonfungible_id 
    left join tbl_fungible tf
    on tf.fungible_id = tsl.fungible_id
    left join tbl_static_delisting td 
    on tsl.listing_id = td.delisting_id
    left join tbl_exclude_contract ex 
    on ex.nonfungible_id = tnt.nonfungible_id
    where tnf.nonfungible_address = _nonfungible_address
    AND tsl.static_order_id is not null
    AND tss.static_sale_id is not null
    AND td.delisting_id is null
    AND tsl.listing_id is not null
    AND ex.exclude_id is null
    order by tsl.static_order_id
    LIMIT _limit_rows
   	OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;