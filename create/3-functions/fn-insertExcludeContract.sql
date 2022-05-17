-------------------------------------------------------------------------------
-- Created      14-01-2022
-- Purpose      Creates an exclude row. Hides this address from being shown in queries.
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 11-01-2022 - Nines - Inital creation.
-- 15-05-2022 - Nines - Fix function to actually insert data
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_insertExcludeContract
(
    _nonfungible_address varchar(42)
) 
RETURNS VOID
AS 
$BODY$
BEGIN

   insert into tbl_exclude_contract
    (   
        nonfungible_id
    )
    values 
    (
        (select nonfungible_id from tbl_nonfungible where nonfungible_address = _nonfungible_address)
    );

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
