-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Inserts a new nonfungible contract
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 08-01-2022 Nines - Inital creation.
-- 18-04-2022 Nines - Change input from ID to address, add if not exists logic
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_insertVerifiedContract
(
    _nonfungible_address varchar(42)
) 
RETURNS VOID
AS 
$BODY$
BEGIN

    IF NOT EXISTS 
    (
        SELECT nonfungible_id FROM tbl_nonfungible where nonfungible_address = _nonfungible_address
    )
    THEN
        RAISE EXCEPTION 'Needs to be a valid nonfungible_address'; 
   ELSE
        INSERT INTO tbl_verified_contract 
        (   
            nonfungible_id
        )
        VALUES 
        (
            (SELECT nonfungible_id FROM tbl_nonfungible where nonfungible_address = _nonfungible_address)
        );
   END IF;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
