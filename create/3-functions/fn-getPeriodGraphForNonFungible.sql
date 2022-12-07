-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets USD/Time data for token_id sales to plot graph for 
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022  Nines - Inital creation.
-- 07-12-2022  Nines - Fix sorting order
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPeriodGraphForNonFungible
(
    _nonfungible_address varchar,
    _time_from int8,
    _time_to int8
) 
returns TABLE 
(
    unixtime int8,
    price numeric(15,2)
) 
AS 
$BODY$
BEGIN

RETURN QUERY    
    select 
        tss.sale_unixtime as unixtime,
        SUM(tss.tax_amount_usd + tss.final_sale_after_taxes_usd) as price
    FROM tbl_static_listing tsl 
    left join tbl_static_sale tss
    on tss.listing_id = tsl.listing_id
    left join tbl_nonfungible_token tnt
    on tnt.extract_nft_id = tsl.extract_nft_id
    left join tbl_nonfungible tnf
    on tnf.nonfungible_id = tnt.nonfungible_id 
    where tnf.nonfungible_address = LOWER(_nonfungible_address) 
    AND tss.sale_unixtime between _time_from and _time_to
    AND tsl.static_order_id is not null
    AND tss.listing_id is not null
    AND tsl.listing_id is not null
    group by tsl.static_order_id, 
    tss.sale_block,
    tss.sale_unixtime,      
    tss.tax_amount_usd,
    tss.final_sale_after_taxes_usd
    order by tss.sale_unixtime;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
