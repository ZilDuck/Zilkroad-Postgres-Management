-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Get all the current listings for a given user address
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-- 16-07-2022  Rich Fix exclusions
-- 28-09-2022  Rich Add extra information
-- 16-10-2022  Rich fix exclude contract logic
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
  fungible_symbol              varchar,
  decimals                     numeric,
  listing_block                numeric,
  listing_unixtime             int8,
  verified                     boolean
)
AS 
$BODY$
BEGIN

  RETURN QUERY
  SELECT tsl.listing_user_address,
         tsl.static_order_id,
         tnt.token_id,
         tnf.nonfungible_address,
         tsl.listing_transaction_hash,
         tf.fungible_address,
         tsl.listing_fungible_token_price,
         tf.fungible_symbol,
         tf.decimals,
         tsl.listing_block,
         tsl.listing_unixtime,
         CASE WHEN tvc.verified_id IS NULL THEN False ELSE True END AS verified
         
         FROM tbl_static_listing tsl
         
         INNER JOIN tbl_nonfungible_token tnt
            ON tsl.extract_nft_id = tnt.extract_nft_id
         
         INNER JOIN tbl_fungible tf
            ON tsl.fungible_id = tf.fungible_id
         
         INNER JOIN tbl_nonfungible tnf
            ON tnf.nonfungible_id = tnt.nonfungible_id
         
         LEFT JOIN tbl_exclude_contract ec
            ON ec.nonfungible_id = tnf.nonfungible_id
         
         LEFT JOIN tbl_verified_contract tvc
            ON tnf.nonfungible_id = tvc.nonfungible_id
         
         WHERE listing_id NOT IN (
            SELECT listing_id FROM tbl_static_delisting 
            UNION ALL 
            SELECT listing_id FROM tbl_static_sale
         )
         AND ec.exclude_id IS NULL
         AND lower(tsl.listing_user_address) = lower(_listing_user_address)
         
         LIMIT _limit_rows OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
