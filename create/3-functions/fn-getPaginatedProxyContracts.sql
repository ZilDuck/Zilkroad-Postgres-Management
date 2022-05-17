-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets paginated proxy primary sales
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getPaginatedProxyContracts
(
	_limit_rows numeric,
	_offset_rows numeric
) 
returns TABLE 
(
	proxy_address varchar,
	proxy_nonfungible_address varchar,
	proxy_max_mint numeric,
	proxy_price_cost_qa numeric,
	proxy_beneficiary_address varchar,
	proxy_open_mint_block numeric
) 
AS 
$BODY$
BEGIN

RETURN QUERY
	SELECT 
		tpc.proxy_address,
		tpc.proxy_nonfungible_address,
		tpc.proxy_max_mint,
		tpc.proxy_price_cost_qa,
		tpc.proxy_beneficiary_address,
		tpc.proxy_open_mint_block
	FROM tbl_proxy_contract tpc   
	order by tpc.proxy_open_mint_block
	LIMIT _limit_rows
	OFFSET _offset_rows;


END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
