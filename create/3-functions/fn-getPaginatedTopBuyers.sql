-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets paginated top buyers
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022 Nines - Inital creation.
-- 14-04-2022 Nines - Add unix filtering.
-- 01-07-2022 Rich  - Fix logic  
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedTopBuyers
(
	_limit_rows numeric,
	_offset_rows numeric,
    _time_from int8,
	_time_to int8
) 
returns TABLE 
(
    address varchar,
    total_usd numeric,
    WZIL numeric,
    GZIL numeric,
    XSGD numeric,
    zWBTC numeric,
    zWETH numeric,
    zUSDT numeric,
    DUCK numeric
) 
AS 
$BODY$
BEGIN

RETURN QUERY 
    SELECT
        tss.buyer_address as address,
        SUM(tss.final_sale_after_Taxes_usd) as total_usd,
        SUM(case when tf.fungible_symbol = 'WZIL' then tsl.listing_fungible_token_price else 0 end) as WZIL,
        SUM(case when tf.fungible_symbol = 'GZIL' then tsl.listing_fungible_token_price else 0 end) as GZIL,
        SUM(case when tf.fungible_symbol = 'XSGD' then tsl.listing_fungible_token_price else 0 end) as XSGD,
        SUM(case when tf.fungible_symbol = 'zWBTC' then tsl.listing_fungible_token_price else 0 end) as zWBTC,
        SUM(case when tf.fungible_symbol = 'zWETH' then tsl.listing_fungible_token_price else 0 end) as zWETH,
        SUM(case when tf.fungible_symbol = 'zUSDT' then tsl.listing_fungible_token_price else 0 end) as zUSDT,
        SUM(case when tf.fungible_symbol = 'DUCK' then tsl.listing_fungible_token_price else 0 end) as DUCK

    FROM tbl_static_listing tsl

    INNER JOIN tbl_static_sale tss
        ON tsl.listing_id = tss.listing_id

    LEFT JOIN tbl_nonfungible_token tnft 
        ON tsl.extract_nft_id = tnft.extract_nft_id

    LEFT JOIN tbl_nonfungible tnf
        ON tnft.nonfungible_id = tnf.nonfungible_id

    LEFT JOIN tbl_fungible tf
        ON tsl.fungible_id = tf.fungible_id

    WHERE tss.listing_id NOT IN (
        SELECT listing_id FROM tbl_static_delisting
    )
    AND tnft.nonfungible_id NOT IN (
        SELECT nonfungible_id FROM tbl_exclude_contract
    )
    AND tsl.listing_unixtime BETWEEN _time_from AND _time_to

    GROUP BY 
        tss.buyer_address,
        tf.fungible_symbol

    ORDER BY sum(tss.final_sale_after_Taxes_usd) DESC
    LIMIT _limit_rows
   	OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
