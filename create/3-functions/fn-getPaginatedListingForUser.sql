-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Get all the current listings for a given user address
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-- 16-07-2022  Rich Fix exclusions
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_getPaginatedListingForUser
(
    _listing_user_address varchar(42),
    _limit_rows numeric,
    _offset_rows numeric
) 
returns TABLE
        (
            listing_user_address         varchar,
            static_order_id              int8,
            token_id                     numeric,
            nonfungible_address          varchar,
            listing_transaction_hash     varchar,
            fungible_address             varchar,
            listing_fungible_token_price numeric,
            listing_block                numeric,
            listing_unixtime             int8
        )
AS 
$BODY$
BEGIN

    RETURN QUERY
        select tsl.listing_user_address,
               tsl.static_order_id,
               tnt.token_id,
               tnf.nonfungible_address,
               tsl.listing_transaction_hash,
               tf.fungible_address,
               tsl.listing_fungible_token_price,
               tsl.listing_block,
               tsl.listing_unixtime
        from tbl_static_listing tsl
                 left join tbl_nonfungible_token tnt
                           on tsl.extract_nft_id = tnt.extract_nft_id
                 left join tbl_fungible tf
                           on tsl.fungible_id = tf.fungible_id
                 left join tbl_nonfungible tnf
                           on tnf.nonfungible_id = tnt.nonfungible_id
                 left join tbl_exclude_contract ec
                           on ec.nonfungible_id = tf.fungible_id
        where listing_id not in (select listing_id from tbl_static_delisting union all select listing_id from tbl_static_sale)
          AND ec.exclude_id is null
          AND tsl.listing_user_address = _listing_user_address
        LIMIT _limit_rows OFFSET _offset_rows;
       
END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
