-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets the listing/delisting/sold activity for a particular wallet
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE INDEX ix_pk_fk_tbl_static_delisting ON
tbl_static_delisting
(
    delisting_id,
    listing_id
);
