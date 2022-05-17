-------------------------------------------------------------------------------
-- Created      11-01-2022
-- Purpose      Creates a delisting row where a listing_id can be found for a given blockchain order_id as this is what's emitted to tie back a sale to a listing
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 11-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_insertStaticDelistingForListing
(
    _static_order_id integer, 
    _delisting_transaction_hash varchar(66), 
    _delisting_block numeric, 
    _delisting_unixtime bigint
) 
RETURNS VOID
AS 
$BODY$
BEGIN

    IF NOT EXISTS 
    (
        select block from tbl_handled_block where block = _delisting_block
    )
    THEN
        insert into tbl_handled_block values (_delisting_block);
   ELSE
   END IF;

    insert into tbl_static_delisting
    (   
        listing_id, 
        delisting_transaction_hash, 
        delisting_block, 
        delisting_unixtime
    ) 
    values 
    (
        (select listing_id from tbl_static_listing where static_order_id = _static_order_id order by listing_id desc limit 1), 
        _delisting_transaction_hash, 
        _delisting_block, 
        _delisting_unixtime
    );

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
