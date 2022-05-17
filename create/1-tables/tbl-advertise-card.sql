-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets the promoted cards on the front page
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_advertise_card" (
	advertise_card_id SERIAL PRIMARY KEY,
	advertise_start_unixtime int8 NOT NULL,
	advertise_end_unixtime int8 NOT NULL,
	advertise_description text NOT NULL,
    advertise_uri text NOT NULL,
	half_image text,   /* nullable */
	quarter_image text /* nullable */
);
ALTER SEQUENCE tbl_advertise_card_advertise_card_id_seq RESTART WITH 1;
