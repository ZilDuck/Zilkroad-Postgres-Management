-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets Fungible Token Data
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 18-09-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getAllFungibleTokens
(

) 
returns table
(
    fungible_name varchar,
    fungible_symbol varchar,
    decimals numeric,
    fungible_address varchar
)
AS 
$BODY$
BEGIN

    RETURN QUERY
    SELECT 
        tf.fungible_name,
        tf.fungible_symbol,
        tf.decimals,
        tf.fungible_address
    from tbl_fungible tf;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;

