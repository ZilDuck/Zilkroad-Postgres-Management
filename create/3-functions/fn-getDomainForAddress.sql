-------------------------------------------------------------------------------
-- Created      22-02-2022
-- Purpose      From an domain, gets an address - we store all the old lookups to be able to do this.
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 22-2-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getDomainForAddress
(
    _user_address varchar(42)
) 
returns table
(
    user_address varchar(42),
    user_domain text
)
AS 
$BODY$
BEGIN

    RETURN QUERY
    select 
    tld.user_address,
    tld.user_domain
    from tbl_domain_lookup tld
    where tld.user_address = _user_address;


END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;

