-------------------------------------------------------------------------------
-- Created      14-01-2022
-- Purpose      Creates a advertisement between x and y date with some assets.
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 19-01-2022 - Nines - Inital creation.
-- 15-05-2022 - Nines - Fix function to actually insert data
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_insertAdvertiseContract
(
    _nonfungible_address varchar(42), 
    _advertise_start_unixtime int8,
	_advertise_end_unixtime int8,
	_advertise_description text,
	_half_image text,
	_quarter_image text
) 
RETURNS VOID
AS 
$BODY$
BEGIN

   insert into tbl_advertise_contract
    (   
        nonfungible_id,
        advertise_start_unixtime,
        advertise_end_unixtime,
        advertise_description,
        half_image,
        quarter_image
    )
    values 
    (
        (select nonfungible_id from tbl_nonfungible where nonfungible_address = _nonfungible_address),
        _advertise_start_unixtime,
        _advertise_end_unixtime,
        _advertise_description,
        _half_image,
        _quarter_image
    );

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
