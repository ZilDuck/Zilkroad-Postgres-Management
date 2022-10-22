-------------------------------------------------------------------------------
-- Created      07-05-2022
-- Purpose      Gets the sale history for a NFT
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 07-05-2022  Rich Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedListedTokensForContract
(
    _nonfungible_address varchar,
    _limit_rows numeric,
	_offset_rows numeric
) 
returns TABLE 
(
	collection_name varchar,
	symbol varchar,
	contract_address_b16 varchar,
	token_id numeric
) 
AS 
$BODY$
BEGIN

RETURN QUERY
	SELECT nonfungible_name AS collection_name,
	nonfungible_symbol AS symbol,
	nonfungible_address AS contract_address_b16,
	tnft.token_id

	FROM tbl_nonfungible tnf

	LEFT JOIN tbl_nonfungible_token tnft
	ON tnf.nonfungible_id = tnft.nonfungible_id

	LEFT JOIN tbl_static_listing tsl
	ON tnft.extract_nft_id = tsl.extract_nft_id

	WHERE LOWER(nonfungible_address) = LOWER(_nonfungible_address)
	AND listing_id not in (
		SELECT tsd.listing_id from tbl_static_delisting tsd
		
		LEFT JOIN tbl_static_listing tsl
			ON tsd.listing_id = tsl.listing_id

		LEFT JOIN tbl_nonfungible_token tnft
			ON tsl.extract_nft_id = tnft.extract_nft_id

		LEFT JOIN tbl_nonfungible tnf
			ON tnft.nonfungible_id = tnf.nonfungible_id

		WHERE LOWER(nonfungible_address) = LOWER(_nonfungible_address)

	UNION ALL 

		SELECT tss.listing_id from tbl_static_sale tss
		
		LEFT JOIN tbl_static_listing tsl
			ON tss.listing_id = tsl.listing_id

		LEFT JOIN tbl_nonfungible_token tnft
			ON tsl.extract_nft_id = tnft.extract_nft_id

		LEFT JOIN tbl_nonfungible tnf
			ON tnft.nonfungible_id = tnf.nonfungible_id

		WHERE LOWER(nonfungible_address) = LOWER(_nonfungible_address)
	)
	
	LIMIT _limit_rows
    OFFSET _offset_rows;
END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
