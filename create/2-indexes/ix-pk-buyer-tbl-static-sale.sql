-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Index
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE INDEX ix_pk_buyer_tbl_static_sale ON
tbl_static_sale
(
    static_sale_id,
    buyer_address
);
