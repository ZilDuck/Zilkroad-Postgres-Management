-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets paginated listing where listed in a particular fungible contract
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getNonFungibleLifetimeSalesData
(
    _nonfungible_address varchar
) 
returns TABLE 
(
    lifetime_sales_usd numeric,
    lifetime_royalty_usd numeric,
    lifetime_quantity_sold bigint
) 
AS 
$BODY$
BEGIN

RETURN QUERY
    select 
        SUM(tss.final_sale_after_taxes_usd) as lifetime_sales_usd,
        SUM(tss.royalty_amount_usd) as lifetime_royalty_usd,
        COUNT(tss.static_sale_id) as lifetime_quantity_sold
    FROM tbl_static_listing tsl 
    left join tbl_static_sale tss
    on tss.listing_id = tsl.listing_id
    left join tbl_nonfungible_token tnt
    on tnt.extract_nft_id = tsl.extract_nft_id
    left join tbl_nonfungible tnf
    on tnf.nonfungible_id = tnt.nonfungible_id 
    left join tbl_fungible tf
    on tf.fungible_id = tsl.fungible_id
    left join tbl_exclude_contract ex 
    on ex.nonfungible_id = tnt.nonfungible_id
    where tnf.nonfungible_address = LOWER(_nonfungible_address)
        AND tsl.static_order_id is not null
        AND tss.static_sale_id is not null
        AND tsl.listing_id is not null
        AND ex.exclude_id is null
        AND tsl.listing_id not in (
            select listing_id from tbl_static_delisting
        );

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
