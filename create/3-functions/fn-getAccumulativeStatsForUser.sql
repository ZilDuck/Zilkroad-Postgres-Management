-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets the listing/delisting/sold activity for a particular wallet
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022 - Nines - Inital creation.
-- 18-08-2022 - Nines - Add lowercase casting for addresses
-- 27-09-2022 - Nines - Fix temporary table logic
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

CREATE TEMPORARY TABLE tmp_accum_data
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
		SELECT COUNT(tsl.listing_id) 
		FROM tbl_static_listing tsl
		LEFT JOIN tbl_static_sale tss
		on tsl.listing_id = tss.listing_id
		LEFT JOIN tbl_static_delisting tsd
		on tsd.listing_id = tsl.listing_id
		WHERE LOWER(tsl.listing_user_address) = LOWER(_user_address)
		AND tss.static_sale_id IS NULL
		AND tsd.delisting_id IS NULL
	),
	( --delisting
		SELECT count(tsd.delisting_id)
		FROM tbl_static_listing tsl 
		LEFT JOIN tbl_static_delisting tsd  
		ON tsl.listing_id = tsd.listing_id 
		WHERE LOWER(tsl.listing_user_address) = LOWER(_user_address)
	),
	( --sold
		SELECT count(tss.static_sale_id) 
		FROM tbl_static_listing tsl 
		LEFT JOIN tbl_static_sale tss  
		ON tsl.listing_id = tss.listing_id
		WHERE LOWER(tsl.listing_user_address) = LOWER(_user_address)
	),
	(--bought
		SELECT count(tss.static_sale_id)
		FROM tbl_static_listing tsl 
		LEFT JOIN tbl_static_sale tss  
		ON tsl.listing_id = tss.listing_id
		WHERE LOWER(tss.buyer_address) = LOWER(_user_address)
	),
	(--royaltyrecip
		SELECT count(tss.static_sale_id) 
		FROM tbl_static_listing tsl 
		LEFT JOIN tbl_static_sale tss  
		ON tsl.listing_id = tss.listing_id
		WHERE LOWER(tss.royalty_recipient_address) = LOWER(_user_address)
	),
	(--royaltyrecip total
		SELECT SUM(tss.royalty_amount_usd)
		FROM tbl_static_listing tsl 
		LEFT JOIN tbl_static_sale tss  
		ON tsl.listing_id = tss.listing_id
		WHERE LOWER(tss.royalty_recipient_address) = LOWER(_user_address)
	)
);

RETURN QUERY
SELECT * 
FROM tmp_accum_data;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
