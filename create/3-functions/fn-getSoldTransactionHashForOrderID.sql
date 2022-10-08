-------------------------------------------------------------------------------
-- Created      15-08-2022
-- Purpose      Given an orderID return the transaction hash for the sold order
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 15-08-2022 - Nines - Inital creation
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getSoldTransactionHashForOrderID
(
    _static_order_id bigint
) 
RETURNS TABLE 
(
	tx_hash varchar(66)
)
AS 
$BODY$
BEGIN

    RETURN QUERY
        SELECT tss.sale_transaction_hash 
        FROM tbl_static_sale tss
        LEFT JOIN tbl_static_listing tsl
        ON tss.listing_id = tsl.listing_id
        WHERE tsl.static_order_id = _static_order_id; 


END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
