-------------------------------------------------------------------------------
-- Created      10-06-2022
-- Purpose      Returns top collections which are paginated and sortable
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 10-06-2022 Rich - Inital creation
-- 25-07-2022 Rich - Remove case sensitivity
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getCollectionStats
(
	_nonfungible_address varchar
) 
RETURNS TABLE
(
    listed_tokens bigint,
    volume numeric(15, 2)
)
AS 
$BODY$
BEGIN

    RETURN QUERY
    SELECT 
        listing.count as listed_tokens,
        volume.volume as volume
        FROM 
        (
            SELECT count(listing_id) as count
            FROM tbl_static_listing tsl

            INNER JOIN tbl_nonfungible_token tnft
                ON tsl.extract_nft_id = tnft.extract_nft_id

            INNER JOIN tbl_nonfungible tnf
                ON tnft.nonfungible_id = tnf.nonfungible_id

            WHERE LOWER(nonfungible_address) = LOWER(_nonfungible_address)
            AND tsl.listing_id NOT IN (
                SELECT listing_id
                FROM tbl_static_delisting
                UNION ALL
                SELECT listing_id
                FROM tbl_static_sale
            )
        ) listing ,
        (
            SELECT COALESCE(SUM(final_sale_after_taxes_usd), 0) as volume

            FROM tbl_static_sale tss

            INNER JOIN tbl_static_listing tsl
                ON tss.listing_id = tsl.listing_id

            INNER JOIN tbl_nonfungible_token tnft
                ON tsl.extract_nft_id = tnft.extract_nft_id

            INNER JOIN tbl_nonfungible tnf
                ON tnft.nonfungible_id = tnf.nonfungible_id

            WHERE LOWER(nonfungible_address) = LOWER(_nonfungible_address)
            AND tss.listing_id NOT IN (
                SELECT listing_id
                FROM tbl_static_delisting
            )
        ) volume;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
