-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Creates a static_sale row if a listing_id exists
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 08-01-2022  Nines 
--      Inital creation.
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_insertStaticSaleForListing
(
    _static_order_id integer,
	_sale_transaction_hash varchar(66),
	_sale_block numeric,
	_sale_unixtime int8,
	_buyer_address varchar(42),
	_royalty_recipient_address varchar(42),
	_tax_recipient_address varchar(42),
	_one_token_as_usd numeric(40,0),
	_tax_amount_token numeric(40,0),
	_tax_amount_usd numeric(15, 2),
	_royalty_amount_token numeric(40,0),
	_royalty_amount_usd numeric(15, 2),
	_final_sale_after_taxes_tokens numeric(40,0),
	_final_sale_after_taxes_usd numeric(15, 2)
) 
RETURNS VOID
AS 
$BODY$
BEGIN

    IF NOT EXISTS 
    (
        select block from tbl_handled_block where block = _sale_block
    )
    THEN
        insert into tbl_handled_block values (_sale_block);
   ELSE
   END IF;

    insert into tbl_static_sale
    (
        listing_id, -- computed
        sale_transaction_hash,
        sale_block,
        sale_unixtime,
        buyer_address,
        royalty_recipient_address,
        tax_recipient_address,
        one_token_as_usd,
        tax_amount_token,
        tax_amount_usd,
        royalty_amount_token,
        royalty_amount_usd,
        final_sale_after_taxes_tokens,
        final_sale_after_taxes_usd
    )
    values 
    (
        -- get the listing_id for the static_order_id (contract orderID emited on list/sale)
        (
            (select listing_id from tbl_static_listing where static_order_id = _static_order_id)
        ),
        _sale_transaction_hash,
        _sale_block,
        _sale_unixtime,
        _buyer_address,
        _royalty_recipient_address,
        _tax_recipient_address,
        _one_token_as_usd,
        _tax_amount_token,
        _tax_amount_usd,
        _royalty_amount_token,
        _royalty_amount_usd,
        _final_sale_after_taxes_tokens,
        _final_sale_after_taxes_usd
    );

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;