-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets statistics for nonfungible contracts
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getStatsForNonFungible
(
    _nonfungible_address varchar(42)
) 
returns TABLE 
(
    sitewide_listed bigint,
    sitewide_sold bigint,
    sitewide_sum_buyer_spent numeric,
    sitewide_sum_royalty_sent numeric,
    sitewide_unique_buyers bigint,
    sitewide_unique_sellers bigint,
    sitewide_unique_royalty_recipient bigint
) 
AS 
$BODY$
BEGIN

    RETURN QUERY
    select 
        count(tsl.listing_id) as "Sitewide listed",
        count(tss.static_sale_id) as "Sitewide Sold",
        sum(tss.final_sale_after_taxes_usd) as "Sitewide buyers spent (USD at sale time)",
        sum(tss.royalty_amount_usd) as "Sitewide royalty sent (USD at sale time)",
        COUNT(DISTINCT tss.buyer_address) as "Unique Buyers",
        COUNT(DISTINCT tss.buyer_address) as "Unique Sellers",
        COUNT(DISTINCT tss.buyer_address) as "Unique Royalty Recipients"
    from tbl_nonfungible tnf
    left join tbl_nonfungible_token tnt
    on tnf.nonfungible_id = tnt.nonfungible_id
    left join tbl_static_listing tsl 
    on tnt.extract_nft_id = tsl.extract_nft_id
    left join tbl_fungible tf
    on tf.fungible_id = tsl.fungible_id
    left join tbl_static_delisting td 
    on tsl.listing_id = td.delisting_id
    left join tbl_exclude_contract ex 
    on ex.nonfungible_id = tnt.nonfungible_id
    left join tbl_static_sale tss
    on tss.listing_id = tsl.listing_id
    WHERE
        tnf.nonfungible_address = LOWER(_nonfungible_address)
        AND td.delisting_id is  null
        AND tsl.listing_id is not null
        AND ex.exclude_id is null;     

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
