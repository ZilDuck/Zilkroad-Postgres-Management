-------------------------------------------------------------------------------
-- Created      14-01-2022
-- Purpose      Creates a advertisement between x and y date with some assets.
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 19-01-2022 - Nines - Inital creation.
-- 15-05-2022 - Nines - Fix function to actually insert data
-- 22-08-2022 - Nines - Refine model
--
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_insertAdvertiseCard
(
    _advertise_start_unixtime int8,
	_advertise_end_unixtime int8,
    _advertise_header varchar(30),
	_advertise_description varchar(200),
    _advertise_uri text,
    _nonfungible_address varchar(42),
	_desktop_image_uri text,
	_mobile_image_uri text
) 
RETURNS VOID
AS 
$BODY$
BEGIN

    INSERT INTO tbl_advertise_card
    (   
        advertise_start_unixtime,
	    advertise_end_unixtime,
        advertise_header,
	    advertise_description,
        advertise_uri,
        nonfungible_address,
	    desktop_image_uri,
	    mobile_image_uri
    )
    VALUES 
    (
        _advertise_start_unixtime,
	    _advertise_end_unixtime,
        _advertise_header,
	    _advertise_description,
        _advertise_uri,
        _nonfungible_address,
	    _desktop_image_uri,
	    _mobile_image_uri
    );

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
