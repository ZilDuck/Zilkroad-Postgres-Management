-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets paginated top wallets by USD activity
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getTopWalletActivityForPeriod
(
	_limit_rows numeric,
	_offset_rows numeric,
    _time_from int8,
	_time_to int8
) 
returns TABLE 
(
    usd_value numeric,
    quantity bigint,
    address varchar,
    text text
) 
AS 
$BODY$
BEGIN

RETURN QUERY
    (
        select 
            SUM(tss.final_sale_after_taxes_usd) as usd_value, 
            COUNT(tss.final_sale_after_taxes_usd) as quantity,
            tss.buyer_address as address, 
            'Buyer' as text 
        from tbl_static_listing tsl
        inner join tbl_static_sale  tss
        on tsl.listing_id = tss.listing_id
        where tss.sale_unixtime between _time_from and _time_to
        group by tss.final_sale_after_taxes_usd, tss.buyer_address
        order by usd_value desc
        limit _limit_rows
    )
    union 
    (
        select 
            SUM(tss.final_sale_after_taxes_usd - tss.royalty_amount_usd) as usd_value, 
            COUNT(tss.final_sale_after_taxes_usd - tss.royalty_amount_usd) as quantity,
            tsl.listing_user_address as address,
            'Seller' as text
            from tbl_static_listing tsl
        inner join tbl_static_sale  tss
        on tsl.listing_id = tss.listing_id
        where tss.sale_unixtime between _time_from and _time_to
        group by tss.final_sale_after_taxes_usd, tsl.listing_user_address
        order by usd_value desc
        limit _limit_rows
    )
    union 
    (
        select 
            SUM(tss.royalty_amount_usd) as usd_value, 
            COUNT(tss.final_sale_after_taxes_usd) as quantity,
            tss.royalty_recipient_address as address,
            'Royalties' as text
        from tbl_static_listing tsl
        inner join tbl_static_sale  tss
        on tsl.listing_id = tss.listing_id
        where tss.sale_unixtime between _time_from and _time_to
        group by tss.royalty_amount_usd, tss.royalty_recipient_address
        order by usd_value desc
        limit _limit_rows
    )
    order by usd_value desc    
    LIMIT _limit_rows
    OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
