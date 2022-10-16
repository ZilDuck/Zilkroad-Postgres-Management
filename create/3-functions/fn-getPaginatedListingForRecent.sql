-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets paginated listing returns most recent first
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-- 16-10-2022  Rich add verification
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedListingForRecent
(
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
    fungible_address varchar,
    verified boolean
) 
AS 
$BODY$
BEGIN

RETURN QUERY
  SELECT
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
    tf.fungible_address,
    CASE WHEN tvc.verified_id IS NULL THEN False ELSE True END AS verified

  FROM tbl_static_listing tsl

  LEFT JOIN tbl_static_sale tss
    ON tsl.listing_id = tss.listing_id

  LEFT JOIN tbl_static_delisting tsd 
    ON tsl.listing_id = tsd.listing_id

  LEFT JOIN tbl_nonfungible_token tnt
    ON tsl.extract_nft_id = tnt.extract_nft_id

  LEFT JOIN tbl_nonfungible tnf
    ON tnt.nonfungible_id = tnf.nonfungible_id

  LEFT JOIN tbl_fungible tf
    ON tsl.fungible_id = tf.fungible_id

  LEFT JOIN tbl_exclude_contract tec
    ON tnt.nonfungible_id = tec.nonfungible_id  

  LEFT JOIN tbl_verified_contract tvc
    ON tnf.nonfungible_id = tvc.nonfungible_id


  WHERE tsl.listing_id NOT IN (
    SELECT listing_id
    FROM tbl_static_delisting
    UNION ALL
    SELECT listing_id
    FROM tbl_static_sale
  )
  AND tec.exclude_id IS NULL

  ORDER BY tsl.static_order_id

  LIMIT _limit_rows
  OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
