-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets the promoted cards on the front page
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-03-2022 - Nines Inital creation.
-- 22-08-2022 - Nines - Refine model
--
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getAllValidCardAdvertisements
(

) 
returns TABLE 
(
    advertise_start_unixtime int8,
    advertise_end_unixtime int8,
    advertise_header varchar(30),
    advertise_description varchar(200),
    advertise_uri text,
    nonfungible_address varchar(42),
    desktop_image_uri text,
    mobile_image_uri text
) 
AS 
$BODY$
BEGIN

    RETURN QUERY
    SELECT 
        tac.advertise_start_unixtime,
	    tac.advertise_end_unixtime,
        tac.advertise_header,
	    tac.advertise_description,
        tac.advertise_uri,
        tac.nonfungible_address,
	    tac.desktop_image_uri,
	    tac.mobile_image_uri
    FROM tbl_advertise_card tac
    WHERE tac.advertise_start_unixtime < (SELECT extract(epoch FROM now()))
    AND tac.advertise_end_unixtime > (SELECT extract(epoch FROM now()));

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
