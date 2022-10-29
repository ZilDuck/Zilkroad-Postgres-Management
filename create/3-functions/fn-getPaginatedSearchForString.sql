-------------------------------------------------------------------------------
-- Created      16-03-2022
-- Purpose      Gets paginated search results. 
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 16-03-2022 Nines - Inital creation.
-- 09-04-2022 Nines - Add excluded and verified logic, don't remove brackets in where clause.
-- 22-07-2022 Nines - Resolve bug with freetext of 0x address and add sorting
-- 11-10-2022 Rich  - Added search term vectors into query
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedSearchForString
(
    _user_search varchar,
    _search_term varchar,
    _limit_rows numeric,
	_offset_rows numeric
) 
returns TABLE 
(
    nonfungible_address varchar,
    nonfungible_symbol varchar, 
    result_text varchar,
    is_verified integer
) 
AS 
$BODY$
BEGIN

RETURN QUERY 
    select 
	tnf.nonfungible_address,
        tnf.nonfungible_symbol, 
        tnf.nonfungible_name as result_text,
        tvc.verified_id as is_verified
    from tbl_nonfungible tnf
    left join tbl_nonfungible_token tnt
    on tnt.nonfungible_id = tnf.nonfungible_id
    left join tbl_exclude_contract ex 
    on ex.nonfungible_id = tnt.nonfungible_id
    left join tbl_verified_contract tvc   
    on tvc.nonfungible_id = tnf.nonfungible_id
    WHERE (
        tnf.simple_tsvector @@ to_tsquery('simple', _search_term)
        OR SIMILARITY(tnf.nonfungible_name, _user_search) > 0.2
        OR SIMILARITY(tnf.nonfungible_symbol, _user_search) > 0.2
        OR tnf.nonfungible_address like concat(_user_search, '%') 
    )
    AND ex.exclude_id is null
    GROUP BY 
        tnf.nonfungible_address, 
        tnf.nonfungible_symbol, 
        tnf.nonfungible_name,
        tvc.verified_id,
        ts_rank(tnf.simple_tsvector, to_tsquery('english', _search_term))
    ORDER BY 
        tvc.verified_id,
        ts_rank(tnf.simple_tsvector, to_tsquery('english', _search_term)) desc,
        tnf.nonfungible_name
    LIMIT _limit_rows
    OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
