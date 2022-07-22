-------------------------------------------------------------------------------
-- Created      16-03-2022
-- Purpose      Gets paginated search results. 
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 16-03-2022 Nines - Inital creation.
-- 09-04-2022 Nines - Add excluded and verified logic, don't remove brackets in where clause.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedSearchForString
(
    _user_search varchar,
    _limit_rows numeric,
	_offset_rows numeric
) 
returns TABLE 
(
    nonfungible_address varchar, 
    nonfungible_symbol varchar, 
    nonfungible_name varchar,
    verified_id integer
) 
AS 
$BODY$
BEGIN

RETURN QUERY 
    select 
        tnf.nonfungible_address, 
        tnf.nonfungible_symbol, 
        tnf.nonfungible_name,
        tvc.verified_id
    from tbl_nonfungible tnf
    left join tbl_nonfungible_token tnt
    on tnt.nonfungible_id = tnf.nonfungible_id
    left join tbl_exclude_contract ex 
    on ex.nonfungible_id = tnt.nonfungible_id
    left join tbl_verified_contract tvc   
    on tvc.nonfungible_id = tnf.nonfungible_id
    WHERE SIMILARITY(tnf.nonfungible_name,'test') > 0.5
    OR SIMILARITY(nonfungible_symbol,'test') > 0.5
    OR nonfungible_address like 'test%'
    AND ex.exclude_id is null
    GROUP BY 
        tnf.nonfungible_address, 
        tnf.nonfungible_symbol, 
        tnf.nonfungible_name,
        tvc.verified_id
    LIMIT _limit_rows
   	OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;