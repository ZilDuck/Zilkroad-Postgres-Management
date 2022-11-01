-------------------------------------------------------------------------------
-- Created      23-04-2022
-- Purpose      Returns the current orderID for a nonfungible token
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 23-04-2022 Nines - Inital creation.
-- 22-10-2022 Rich - fix casing for contract address
-- 01-11-2022 Nines - fix delisting logic to inner join
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getOrderIDForNonFungibleToken
(
    _token_id numeric,
    _nonfungible_address varchar
) 
RETURNS TABLE 
(
    static_order_id int8,
    listing_transaction_hash varchar(66),
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
        tsl.listing_transaction_hash,
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
    inner join tbl_static_delisting td 
    on tsl.listing_id = td.delisting_id
    left join tbl_exclude_contract ex 
    on ex.nonfungible_id = tnt.nonfungible_id
    left join tbl_static_sale tss
    on tss.listing_id = tsl.listing_id
    where
        lower(tnf.nonfungible_address) = lower(_nonfungible_address)
      AND tnt.token_id = _token_id
        AND td.delisting_id is null
        AND tsl.listing_id is not null
        AND ex.exclude_id is null
        AND tss.static_sale_id is null
    LIMIT 1;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
