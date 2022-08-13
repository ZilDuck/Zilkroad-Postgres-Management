-------------------------------------------------------------------------------
-- Created      08-01-2022
-- Purpose      Gets all calender data
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 07-02-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getAllCalendarData
(

) 
returns table
(
    calendar_unixtime int8,
	calendar_description text,
	calendar_website text,
	calendar_image text
)
AS 
$BODY$
BEGIN

    RETURN QUERY
    select 
    tce.calendar_unixtime,
    tce.calendar_description, 
    tce.calendar_website, 
    tce.calendar_image
    from tbl_calendar_event tce;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;

