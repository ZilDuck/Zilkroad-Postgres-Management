-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets paginated top royalties
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022 Nines - Inital creation.
-- 14-04-2022 Nines - Add unix filtering.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedTopRoyalties
(
	_limit_rows numeric,
	_offset_rows numeric,
    _time_from int8,
	_time_to int8
) 
returns TABLE 
(
    royalty_address varchar,
    lifetime_sales_usd numeric,
    lifetime_quantity_royalty bigint,
    WZIL_volume numeric,
    GZIL_volume numeric,
    XSGD_volume numeric,
    zWBTC_volume numeric,
    zETH_volume numeric,
    zUSDT_volume numeric,
    DUCK_volume numeric
) 
AS 
$BODY$
BEGIN

RETURN QUERY 
 select 
        tss.royalty_recipient_address as royalty_address,
        SUM(tss.royalty_amount_usd) as lifetime_royalty_usd,
        COUNT(tss.static_sale_id) as lifetime_quantity_royalty,
        SUM(case when tf.fungible_symbol = 'WZIL' then tss.royalty_amount_token else 0 end) as WZIL_volume,
        SUM(case when tf.fungible_symbol = 'GZIL' then tss.royalty_amount_token else 0 end) as GZIL_volume,
        SUM(case when tf.fungible_symbol = 'XSGD' then tss.royalty_amount_token else 0 end) as XSGD_volume,
        SUM(case when tf.fungible_symbol = 'zWBTC' then tss.royalty_amount_token else 0 end) as zWBTC_volume,
        SUM(case when tf.fungible_symbol = 'zETH' then tss.royalty_amount_token else 0 end) as zETH_volume,
        SUM(case when tf.fungible_symbol = 'zUSDT' then tss.royalty_amount_token else 0 end) as zUSDT_volume,
        SUM(case when tf.fungible_symbol = 'DUCK' then tss.royalty_amount_token else 0 end) as DUCK_volume
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
    where tsl.static_order_id is not null
        AND tss.static_sale_id is not null
        AND td.delisting_id is  null
        AND tsl.listing_id is not null
        AND ex.exclude_id is null
        AND tsl.listing_unixtime BETWEEN _time_from AND _time_to
    group by tsl.static_order_id, 
    tss.royalty_amount_usd, 
    tss.final_sale_after_taxes_usd, 
    tss.royalty_recipient_address,
    tf.fungible_symbol
    order by lifetime_royalty_usd desc
    LIMIT _limit_rows
   	OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
