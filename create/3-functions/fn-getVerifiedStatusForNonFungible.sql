-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Given a nonfungible address, is it verified?
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 04-04-2022  Nines Inital creation.
-- 16-10-2022  Rich fix address conversion
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_getVerifiedStatusForNonFungible
(
    _nonfungible_address varchar
) 
returns TABLE 
(
    nonfungible_address varchar,
    nonfungible_symbol varchar,
    nonfungible_name varchar
) 
AS 
$BODY$
BEGIN

RETURN QUERY
    select 
        tnf.nonfungible_address,
        tnf.nonfungible_symbol,
        tnf.nonfungible_name
    from tbl_verified_contract tvc
    left join tbl_nonfungible tnf
    on tvc.nonfungible_id = tnf.nonfungible_id
    left join tbl_nonfungible_token tnt
    on tnf.nonfungible_id = tnt.nonfungible_id
    left join tbl_exclude_contract tsc
    on tnf.nonfungible_id = tsc.nonfungible_id
    where 
        lower(tnf.nonfungible_address) = lower(_nonfungible_address) AND
        tsc.exclude_id is null 
    group by
        tnf.nonfungible_address,
        tnf.nonfungible_symbol,
        tnf.nonfungible_name;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
