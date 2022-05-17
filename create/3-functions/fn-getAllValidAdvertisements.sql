-------------------------------------------------------------------------------
-- Created      07-02-2022
-- Purpose      Gets all advertisements in the future
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 07-02-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getAllValidBannerAdvertisements
(

) 
returns TABLE 
(
    _advertise_start_unixtime int8,
	_advertise_end_unixtime int8,
	_advertise_description text,
	_half_image text,
	_quarter_image text
) 
AS 
$BODY$
BEGIN

    RETURN QUERY
    select 
        advertise_start_unixtime,
        advertise_end_unixtime,
        advertise_description,
        half_image,
        quarter_image
    from tbl_advertise_contract tac
    where tac.advertise_start_unixtime < (select extract(epoch from now()))
    and tac.advertise_end_unixtime > (select extract(epoch from now()));

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
