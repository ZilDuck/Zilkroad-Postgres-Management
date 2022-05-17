-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets paginated nonfungible stats across the whole site
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedNonFungibleStats
(
	_limit_rows numeric,
	_offset_rows numeric
) 
returns TABLE 
(
    nonfungible_address varchar,
    total_sales_usd numeric(15,2),
    total_royalties_usd numeric(15,2),
    nonfungible_name varchar,
    nonfungible_symbol varchar
) 
AS 
$BODY$
BEGIN

RETURN QUERY
    select 
        tnf.nonfungible_address,
        SUM(tss.final_sale_after_taxes_usd) + SUM(tss.royalty_amount_usd) as total_sales_usd,
        SUM(tss.royalty_amount_usd) as total_royalties_usd,
        tnf.nonfungible_name,
        tnf.nonfungible_symbol
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
    AND td.delisting_id is null
    AND tsl.listing_id is not null
    AND ex.exclude_id is null
    group by
    tnf.nonfungible_address,
    tnf.nonfungible_name,
    tnf.nonfungible_symbol,
    tsl.static_order_id
    order by total_sales_usd desc
    LIMIT _limit_rows
   	OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
