-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Index
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE INDEX ix_pk_fungible_tbl_static_listing ON
tbl_static_listing
(
    listing_id,
    fungible_id
);
