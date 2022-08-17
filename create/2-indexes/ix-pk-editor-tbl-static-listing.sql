-------------------------------------------------------------------------------
-- Created      13-08-2022
-- Purpose      Index
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 13-08-2022 - Nines - Inital creation.
-------------------------------------------------------------------------------

CREATE INDEX ix_pk_fk_editer_tbl_static_listing ON
tbl_static_edit_listing
(
    listing_id,
    edit_listing_id
);
