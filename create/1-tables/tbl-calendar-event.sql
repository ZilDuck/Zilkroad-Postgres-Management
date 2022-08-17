-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Stores calender entries
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 17-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_calendar_event" (
	calendar_id SERIAL PRIMARY KEY,
	calendar_unixtime int8 NOT NULL,
	calender_heading text NOT NULL,
	calendar_description text NOT NULL,
	calendar_website text NOT NULL,
	calendar_image text NOT NULL
);
ALTER SEQUENCE tbl_calendar_event_calendar_id_seq RESTART WITH 1;
