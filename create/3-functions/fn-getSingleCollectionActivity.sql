-------------------------------------------------------------------------------
-- Created      19-04-2022
-- Purpose      Returns a single collection activity row
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 06-06-2022 - Nines - Inital creation
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getSingleCollectionsActivity
(
    _contract_address varchar(42),
    _time_from int8,
	_time_to int8
) 
RETURNS TABLE
(
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
        tnf.nonfungible_name,
        tnf.nonfungible_symbol,
        SUM(tss.royalty_amount_usd) as "royalties_paid",
        SUM(tss.final_sale_after_taxes_usd) as "trading_vol_usd",
        COUNT(tss.static_sale_id) as "trade_quantity"
    FROM tbl_static_listing tsl 
    inner join tbl_static_sale tss
    on tss.listing_id = tsl.listing_id
    inner join tbl_nonfungible_token tnt
    on tnt.extract_nft_id = tsl.extract_nft_id
    inner join tbl_nonfungible tnf
    on tnf.nonfungible_id = tnt.nonfungible_id 
    left join tbl_exclude_contract ex 
    on ex.nonfungible_id = tnt.nonfungible_id
        where 
        tss.sale_unixtime between _time_from and _time_to
        AND tnf.nonfungible_address = _contract_address
        AND ex.exclude_id is null
    group by 
        tnf.nonfungible_name,
        tnf.nonfungible_symbol
    order by trading_vol_usd desc;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
