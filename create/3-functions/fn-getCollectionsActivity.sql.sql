-------------------------------------------------------------------------------
-- Created      19-04-2022
-- Purpose      Returns top collections which are paginated and sortable
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 19-04-2022 Nines - Inital creation
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getCollectionsActivity
(
	_limit_rows numeric,
	_offset_rows numeric,
    _time_from int8,
	_time_to int8
) 
RETURNS TABLE
(
    nonfungible_address varchar(255),
    nonfungible_name varchar(255),
    nonfungible_symbol varchar(255),
    royalties_paid numeric(15,2),
    trading_vol_usd numeric(15,2),
    trade_quantity bigint
)
AS 
$BODY$
BEGIN

    RETURN QUERY
    SELECT 
        tnf.nonfungible_address,
        tnf.nonfungible_name,
        tnf.nonfungible_symbol,
        SUM(tss.royalty_amount_usd) as "royalties_paid",
        SUM(tss.final_sale_after_taxes_usd) as "trading_vol_usd",
        COUNT(tss.static_sale_id) as "trade_quantity"
    FROM tbl_static_listing tsl 
    left join tbl_static_sale tss
    on tss.listing_id = tsl.listing_id
    left join tbl_nonfungible_token tnt
    on tnt.extract_nft_id = tsl.extract_nft_id
    left join tbl_nonfungible tnf
    on tnf.nonfungible_id = tnt.nonfungible_id 
    left join tbl_exclude_contract ex 
    on ex.nonfungible_id = tnt.nonfungible_id
    where 
        tss.sale_unixtime between _time_from and _time_to
        AND tsl.static_order_id is not null
        AND tss.static_sale_id is not null
        AND tsl.listing_id is not null
        AND ex.exclude_id is null
    group by 
        tnf.nonfungible_address,
        tnf.nonfungible_name,
        tnf.nonfungible_symbol
    order by trading_vol_usd desc
    LIMIT _limit_rows
   	OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;