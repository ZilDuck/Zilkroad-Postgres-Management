-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Index
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE INDEX ix_pk_tbl_advertise_card ON
tbl_advertise_card
(
    advertise_card_id,
    advertise_start_unixtime,
	advertise_end_unixtime
);
