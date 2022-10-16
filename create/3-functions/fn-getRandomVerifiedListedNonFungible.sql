-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets 4 random paginated listings which are verified
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_getRandomVerifiedListedNonFungible
(

) 
returns TABLE 
(
    verified_id integer,
    nonfungible_address varchar,
    nonfungible_symbol varchar,
    nonfungible_name varchar,
    token_id numeric,
    static_order_id int8,
    fungible_address varchar,
    fungible_symbol varchar,
    fungible_name varchar,
    decimals numeric,
    listing_transaction_hash varchar,
    listing_fungible_token_price numeric,
    listing_block numeric,
    listing_unixtime int8,
    verified boolean
) 
AS 
$BODY$
BEGIN

RETURN QUERY
  select 
        tvc.verified_id,
        tnf.nonfungible_address,
        tnf.nonfungible_symbol,
        tnf.nonfungible_name,
        tnt.token_id,
        tsl.static_order_id,
        tf.fungible_address,
        tf.fungible_symbol,
        tf.fungible_name,
        tf.decimals,
        tsl.listing_transaction_hash,
        tsl.listing_fungible_token_price,
        tsl.listing_block,
        tsl.listing_unixtime,
        True AS verified
    from tbl_verified_contract tvc
    left join tbl_nonfungible tnf
    on tvc.nonfungible_id = tnf.nonfungible_id
    left join tbl_nonfungible_token tnt
    on tnf.nonfungible_id = tnt.nonfungible_id
    left join tbl_static_listing tsl
    on tnt.extract_nft_id = tsl.extract_nft_id
    left join tbl_static_sale tss
    on tss.listing_id = tsl.listing_id
    left join tbl_static_delisting tsd
    on tsl.listing_id = tsd.listing_id
    left join tbl_fungible tf
    on tf.fungible_id = tsl.fungible_id
    where
    tsd.delisting_id is null AND
    tss.static_sale_id is null and 
    tsl.listing_id is not null
    ORDER BY random()
    LIMIT 3;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
