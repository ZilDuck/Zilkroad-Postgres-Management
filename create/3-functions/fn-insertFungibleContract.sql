-------------------------------------------------------------------------------
-- Created      14-01-2022
-- Purpose      Creates a fungible contract row
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 11-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_insertFungible
(
    _fungible_address varchar(42), 
    _fungible_name varchar(255), 
    _fungible_symbol varchar(255), 
    _decimals numeric(40,0)
) 
RETURNS VOID
AS 
$BODY$
BEGIN

   insert into tbl_fungible 
    (   
        fungible_address, 
        fungible_name, 
        fungible_symbol, 
        decimals
    )
    values 
    (
        _fungible_address, 
        _fungible_name, 
        _fungible_symbol, 
        _decimals
    );

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
