-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets the paginated listing/delisting/sold activity for a particular user
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 08-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedActivityForUser
(
    _listing_user_address varchar(42),
	_limit_rows numeric,
	_offset_rows numeric
) 
returns TABLE 
(
	static_order_id int8,
	listing_fungible_token_price numeric,
	listing_unixtime int8,
	listing_block numeric,
	listing_transaction_hash varchar,
	json_build_object json,
	sale_transaction_hash varchar,
	sale_block numeric,
	sale_unixtime int8,
	buyer_address varchar,
	royalty_recipient_address varchar,
	tax_recipient_address varchar,
	one_token_as_usd numeric,
	tax_amount_token numeric,
	tax_amount_usd numeric,
	royalty_amount_token numeric,
	royalty_amount_usd numeric,
	final_sale_after_taxes_tokens numeric,
	final_sale_after_taxes_usd numeric,
	delisting_transaction_hash varchar,
	delisting_block numeric,
	delisting_unixtime int8
) 
AS 
$BODY$
BEGIN

    RETURN QUERY
	select 
		tsl.static_order_id,
		tsl.listing_fungible_token_price,
		tsl.listing_unixtime,
		tsl.listing_block,
		tsl.listing_transaction_hash,
		json_build_object(tf.fungible_address , tf.fungible_name, tf.fungible_symbol, tf.decimals),
		tss.sale_transaction_hash,
		tss.sale_block,
		tss.sale_unixtime,
		tss.buyer_address,
		tss.royalty_recipient_address,
		tss.tax_recipient_address,
		tss.one_token_as_usd,
		tss.tax_amount_token,
		tss.tax_amount_usd,
		tss.royalty_amount_token,
		tss.royalty_amount_usd,
		tss.final_sale_after_taxes_tokens,
		tss.final_sale_after_taxes_usd,
		tsd.delisting_transaction_hash,
		tsd.delisting_block,
		tsd.delisting_unixtime
	from tbl_nonfungible_token tnft
	left join tbl_static_listing tsl 
	on tnft.extract_nft_id = tsl.extract_nft_id 
	left join tbl_static_delisting td 
	on tsl.listing_id  = td.listing_id 
	left join tbl_fungible tf 
	on tsl.fungible_id = tf.fungible_id
	left join tbl_static_sale tss  
	on tsl.listing_id = tss.listing_id
	left join tbl_static_delisting tsd  
	on tsl.listing_id = tsd.listing_id
	where 
	tsl.listing_user_address = _listing_user_address and 
	tsl.listing_id is not null
	order by tsl.listing_unixtime desc
	LIMIT _limit_rows
   	OFFSET _offset_rows;


END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
