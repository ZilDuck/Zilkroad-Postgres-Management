-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Inserts a new nonfungible contract
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 08-01-2022 Nines - Inital creation.
-- 06-04-2022 Nines - Add nonfungible_address check
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_insertProxyContract
(
	_proxy_nonfungible_address varchar(42),
    _nonfungible_name varchar,   -- NULLABLE
    _nonfungible_symbol varchar, -- NULLABLE
    _proxy_address varchar(42),
	_proxy_max_mint numeric,
	_proxy_price_cost_qa numeric(42),
	_proxy_beneficiary_address varchar(42),
	_proxy_open_mint_block numeric
) 
RETURNS VOID
AS 
$BODY$
BEGIN

    IF NOT EXISTS 
    (
        (select nonfungible_id from tbl_nonfungible where nonfungible_address = _proxy_nonfungible_address)
    )
    THEN
    insert into tbl_nonfungible 
    (
        nonfungible_address,
        nonfungible_name,
        nonfungible_symbol
    )
    values
    (
        _proxy_nonfungible_address,
        _nonfungible_name,
        _nonfungible_symbol
    );
    ELSE
    END IF;

    insert into tbl_proxy_contract 
    (
        proxy_address, 
        proxy_nonfungible_address,
        proxy_max_mint,
        proxy_price_cost_qa,
        proxy_beneficiary_address,
        proxy_open_mint_block
    )
    values 
    (
        _proxy_address,
        _proxy_nonfungible_address,
        _proxy_max_mint,
        _proxy_price_cost_qa,
        _proxy_beneficiary_address,
        _proxy_open_mint_block
    );

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
