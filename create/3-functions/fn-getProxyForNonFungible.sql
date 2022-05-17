-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets the proxy_contract if it exists for a nonfungible token
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getProxyForNonFungible
(
    _nonfungible_address varchar(42)
) 
RETURNS TABLE
(
    proxy_address varchar(42),
    proxy_nonfungible_address varchar(42),
    proxy_max_mint numeric,
    proxy_price_cost_qa numeric(42,0),
    proxy_beneficiary_address varchar(42),
    proxy_open_mint_block numeric
)
AS 
$BODY$
BEGIN
RETURN QUERY

select 
    tpc.proxy_address,
    tpc.proxy_nonfungible_address,
    tpc.proxy_max_mint,
    tpc.proxy_price_cost_qa,
    tpc.proxy_beneficiary_address,	
    tpc.proxy_open_mint_block
from tbl_proxy_contract tpc
where tpc.proxy_nonfungible_address = _nonfungible_address
LIMIT 1;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;