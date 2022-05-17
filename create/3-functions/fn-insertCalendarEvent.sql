-------------------------------------------------------------------------------
-- Created      14-01-2022
-- Purpose      Creates a calendar entry 
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 19-01-2022  Nines Inital creation.
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_insertCalendarEvent
(
	_calendar_unixtime int8,
    _calender_heading text,
	_calendar_description text,
	_calendar_website text,
	_calendar_image text
) 
RETURNS VOID
AS 
$BODY$
BEGIN

insert into tbl_calendar_event
(
    calendar_unixtime,
    calender_heading,
    calendar_description,
    calendar_website,
    calendar_image
)
values
(
    _calendar_unixtime,
    _calender_heading,
    _calendar_description,
	_calendar_website,
	_calendar_image
);

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;