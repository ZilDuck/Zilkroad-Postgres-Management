-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets the listing/delisting/sold activity for a particular wallet
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE INDEX ix_pk_fungible_tbl_fungible ON
tbl_fungible
(
    fungible_id,
    fungible_address
);
