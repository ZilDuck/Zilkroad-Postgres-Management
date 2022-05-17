-------------------------------------------------------------------------------
-- Created      27-03-2022
-- Purpose      Gets a promoted card by ID
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 12-04-2022  Nines Inital creation.
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_getCardByID
(
    _advertise_card_id integer
) 
returns TABLE 
(
	advertise_start_unixtime int8,
	advertise_end_unixtime int8,
	advertise_description text,
    advertise_uri text,
	half_image text,   
	quarter_image text 
) 
AS 
$BODY$
BEGIN

    RETURN QUERY
    select 
        tac.advertise_start_unixtime,
        tac.advertise_end_unixtime,
        tac.advertise_description,
        tac.advertise_uri,
        tac.half_image,   
        tac.quarter_image 
    from tbl_advertise_card tac
    where tac.advertise_card_id = _advertise_card_id;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
