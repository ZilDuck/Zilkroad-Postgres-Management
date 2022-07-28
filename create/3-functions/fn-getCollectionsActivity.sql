-------------------------------------------------------------------------------
-- Created      19-04-2022
-- Purpose      Returns top collections which are paginated and sortable
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 19-04-2022 Nines - Inital creation
-- 28-07-2022 Rich  - Fixed collections not showing
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
            COALESCE(SUM(tss.royalty_amount_usd), 0) as "royalties_paid",
            COALESCE(SUM(tss.final_sale_after_taxes_usd), 0) as "trading_vol_usd",
            COALESCE(CAST(COUNT(tss.static_sale_id) as BIGINT), 0) as "trade_quantity"
        FROM tbl_static_listing tsl 
        left join tbl_static_sale tss
        on tss.listing_id = tsl.listing_id
        inner join tbl_nonfungible_token tnt
        on tnt.extract_nft_id = tsl.extract_nft_id
        inner join tbl_nonfungible tnf
        on tnf.nonfungible_id = tnt.nonfungible_id 
        left join tbl_exclude_contract ex 
        on ex.nonfungible_id = tnt.nonfungible_id
        where ex.exclude_id is null
        group by 
            tnf.nonfungible_address,
            tnf.nonfungible_name,
            tnf.nonfungible_symbol
        order by trading_vol_usd desc;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
