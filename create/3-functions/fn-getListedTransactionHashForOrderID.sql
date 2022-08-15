-------------------------------------------------------------------------------
-- Created      15-08-2022
-- Purpose      Given an orderID return the transaction hash for the listed order
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 15-08-2022 - Nines - Inital creation
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getListedTransactionHashForOrderID
(
    _static_order_id int8
) 
RETURNS TABLE 
(
	tx_hash varchar(66)
)
AS 
$BODY$
BEGIN

        RETURN QUERY
            SELECT listing_transaction_hash 
            FROM tbl_static_listing 
            WHERE static_order_id = _static_order_id;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
