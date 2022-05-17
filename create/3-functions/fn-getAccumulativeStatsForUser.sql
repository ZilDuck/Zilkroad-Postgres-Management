-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets the listing/delisting/sold activity for a particular wallet
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getAccumulativeStatsForUser
(
    _user_address varchar(42)
) 
returns TABLE 
(
    listing_count integer,
    delisting_count integer,
    sold_count integer,
    bought_count integer,
    royaltys_in_count integer,
	sum_royalty_usd numeric(15,2)
) 
AS 
$BODY$
BEGIN

CREATE TEMP TABLE tmp_accum_data
(
    listing_count integer,
    delisting_count integer,
    sold_count integer,
    bought_count integer,
    royaltys_in_count integer,
	sum_royalty_usd numeric(15,2)
);

INSERT INTO tmp_accum_data
(
    listing_count,
    delisting_count,
    sold_count,
    bought_count,
    royaltys_in_count,
	sum_royalty_usd
)
values 
(
	( --listing
		select count(listing_id) from tbl_static_listing where listing_user_address = _user_address
	),
	( --delisting
		select count(tsd.delisting_id)
		from tbl_static_listing tsl 
		left join tbl_static_delisting tsd  
		on tsl.listing_id = tsd.listing_id 
		where tsl.listing_user_address = _user_address
	),
	( --sold
		select count(tss.static_sale_id) 
		from tbl_static_listing tsl 
		left join tbl_static_sale tss  
		on tsl.listing_id = tss.listing_id
		where tsl.listing_user_address = _user_address
	),
	(--bought
		select count(tss.static_sale_id)
		from tbl_static_listing tsl 
		left join tbl_static_sale tss  
		on tsl.listing_id = tss.listing_id
		where tss.buyer_address = _user_address
	),
	(--royaltyrecip
		select count(tss.static_sale_id) 
		from tbl_static_listing tsl 
		left join tbl_static_sale tss  
		on tsl.listing_id = tss.listing_id
		where tss.royalty_recipient_address = _user_address
	),
	(--royaltyrecip total
		select SUM(tss.royalty_amount_usd)
		from tbl_static_listing tsl 
		left join tbl_static_sale tss  
		on tsl.listing_id = tss.listing_id
		where tss.royalty_recipient_address = _user_address
	)
);

RETURN QUERY
SELECT * 
FROM tmp_accum_data;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
