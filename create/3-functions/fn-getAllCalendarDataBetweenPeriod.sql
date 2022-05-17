-------------------------------------------------------------------------------
-- Created      16-04-2022
-- Purpose      Gets calender data between a period
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 16-04-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getAllCalendarDataBetweenPeriod
(
	_limit_rows numeric,
	_offset_rows numeric,
    _time_from int8,
	_time_to int8
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
    from tbl_calendar_event tce
    where 
        tce.calendar_unixtime BETWEEN _time_from and _time_to
    order by tce.calendar_unixtime desc
    LIMIT _limit_rows
   	OFFSET _offset_rows;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;

