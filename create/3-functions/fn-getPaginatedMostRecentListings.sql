CREATE OR REPLACE FUNCTION public.fn_getPaginatedMostRecentListings(_limit_rows numeric, _offset_rows numeric)
RETURNS TABLE(
	static_order_id bigint,
	token_id numeric,
	nonfungible_address character varying,
	listing_fungible_token_price numeric,
	listing_block numeric,
	listing_unixtime bigint,
	listing_user_address character varying,
	fungible_name character varying,
	fungible_symbol character varying,
	decimals numeric,
	fungible_address character varying
)
AS
$BODY$
BEGIN
RETURN QUERY
	SELECT
		tsl.static_order_id,
		tnt.token_id,
		tnf.nonfungible_address,
		tsl.listing_fungible_token_price,
		tsl.listing_block,
		tsl.listing_unixtime,
		tsl.listing_user_address,
		tf.fungible_name,
		tf.fungible_symbol,
		tf.decimals,
		tf.fungible_address

	FROM tbl_static_listing tsl

	LEFT JOIN tbl_static_sale tss
		ON tsl.listing_id = tss.listing_id

	LEFT JOIN tbl_static_delisting tsd 
		ON tsl.listing_id = tsd.listing_id

	LEFT JOIN tbl_nonfungible_token tnt
		ON tsl.extract_nft_id = tnt.extract_nft_id

	LEFT JOIN tbl_nonfungible tnf
		ON tnt.nonfungible_id = tnf.nonfungible_id

	LEFT JOIN tbl_fungible tf
		ON tsl.fungible_id = tf.fungible_id

	LEFT JOIN tbl_exclude_contract tec
		ON tnt.nonfungible_id = tec.nonfungible_id	


	WHERE tsl.listing_id NOT IN (
		SELECT listing_id
		FROM tbl_static_delisting
		UNION ALL
		SELECT listing_id
		FROM tbl_static_sale
	)

	ORDER BY tsl.static_order_id

	LIMIT _limit_rows
	OFFSET _offset_rows;
END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;