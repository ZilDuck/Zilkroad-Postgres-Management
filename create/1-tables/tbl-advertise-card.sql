-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets the long banner card shown on most pages
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022 - Nines - Inital creation.
-- 22-08-2022 - Nines - Refine model
-------------------------------------------------------------------------------

CREATE TABLE "tbl_advertise_card" (
	advertise_card_id SERIAL PRIMARY KEY,
	advertise_start_unixtime int8 NOT NULL,
	advertise_end_unixtime int8 NOT NULL,
	advertise_header varchar(30) NOT NULL,
	advertise_description varchar(200) NOT NULL,
    advertise_uri text NOT NULL,
	nonfungible_address varchar(42), /* nullable */
	desktop_image_uri text,    /* nullable */
	mobile_image_uri text  /* nullable */
);
ALTER SEQUENCE tbl_advertise_card_advertise_card_id_seq RESTART WITH 1;
