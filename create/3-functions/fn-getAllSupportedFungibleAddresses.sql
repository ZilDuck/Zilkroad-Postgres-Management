-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Returns all valid fungible tokens 
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 16-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getAllSupportedFungibleAddresses
(

) 
returns table
(
    fungible_address varchar(42),
	fungible_name varchar(255),
	fungible_symbol varchar(255),
	decimals numeric
)
AS 
$BODY$
BEGIN

RETURN QUERY
    select 
        tf.fungible_address,
        tf.fungible_name,
        tf.fungible_symbol,
        tf.decimals
    from tbl_fungible tf
    order by fungible_address desc;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;