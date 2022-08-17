-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Index
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE INDEX ix_pk_address_tbl_proxy_contract ON
tbl_proxy_contract
(
    proxy_id,
    proxy_beneficiary_address
);
