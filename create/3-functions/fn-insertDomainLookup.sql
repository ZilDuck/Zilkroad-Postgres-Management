-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Inserts a domain locally if it has been found on UD API 
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_insertDomainLookup
(
    _user_address varchar(42),
    _user_domain text
) 
RETURNS VOID
AS 
$BODY$
BEGIN

    IF NOT EXISTS 
    (
        select domain_id from tbl_domain_lookup
        where user_address = _user_address 
        AND user_domain = _user_domain

    )
    THEN
        insert into tbl_domain_lookup 
        (
            user_address,
            user_domain
        )
        values
        (
            _user_address,
            _user_domain
        );
   ELSE
   END IF;

    

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
