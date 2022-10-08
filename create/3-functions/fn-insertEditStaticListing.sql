-------------------------------------------------------------------------------
-- Created      01-08-2022
-- Purpose      Creates a new history row of A.B -> Y.Z in tbl_static_edit_listing, and updates tbl_static_listing to the latest value
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 01-08-2022 - Nines - Inital creation.
-- 13-08-2022 - Badman - Add secondary row logic 
-- 21-09-2022 - Badman - Fix typos in types and duplicate end
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_insertEditStaticListing
(
    _static_order_id integer,
    _edit_listing_transaction_hash varchar(66),
    _previous_fungible_address varchar(42),
    _previous_fungible_token_price numeric(40),
    _new_fungible_address varchar(42),
    _new_fungible_token_price numeric(40),
    _edit_listing_block numeric,
    _edit_listing_unixtime bigint
)
RETURNS VOID
AS
$BODY$
BEGIN
  
    -- Does this listing exist?
    IF NOT EXISTS 
    (
        select listing_id from tbl_static_listing where static_order_id = _static_order_id
    )
    THEN
    -- noop
    ELSE

        -- Is this the first time editing price?
        IF NOT EXISTS 
        (
            select tsel.listing_id
            from tbl_static_edit_listing tsel

            inner join tbl_static_listing tsl
                on tsel.listing_id = tsl.listing_id

            where tsl.static_order_id = _static_order_id
        )
        THEN
        
            -- Add row 0 (Null, Original price)
            WITH listing_data AS (
                SELECT listing_id,
                    listing_transaction_hash,
                    fungible_id,
                    listing_fungible_token_price,
                    listing_block,
                    listing_unixtime

                FROM tbl_static_listing where static_order_id = _static_order_id
            )

            INSERT INTO tbl_static_edit_listing 
            (
                listing_id,
                edit_listing_transaction_hash,
                previous_fungible_id,
                previous_fungible_token_price,
                new_fungible_id,
                new_fungible_token_price,
                edit_listing_block,
                edit_listing_unixtime
            )
            SELECT 
                listing_data.listing_id,
                listing_data.listing_transaction_hash,
                (select fungible_id from tbl_fungible where fungible_address = '0x0000000000000000000000000000000000000000'),
                '0',
                listing_data.fungible_id,
                listing_data.listing_fungible_token_price,
                listing_data.listing_block,
                listing_data.listing_unixtime
            FROM listing_data

            UNION

            SELECT 
                listing_data.listing_id,
                _edit_listing_transaction_hash,
                listing_data.fungible_id,
                listing_data.listing_fungible_token_price,
                (select fungible_id from tbl_fungible where fungible_address = _new_fungible_address),
                _new_fungible_token_price,
                _edit_listing_block,
                _edit_listing_unixtime
            FROM listing_data

            ORDER BY listing_unixtime asc;

            -- Update price in listing table
            UPDATE tbl_static_listing
            SET 
                fungible_id = (select fungible_id from tbl_fungible where fungible_address = _new_fungible_address),
                listing_fungible_token_price = _new_fungible_token_price
            WHERE 
                listing_id = (select listing_id from tbl_static_listing where static_order_id = _static_order_id);

        ELSE

            -- Add row 1 (Original price, Changed price)
            INSERT INTO tbl_static_edit_listing 
           (
                listing_id,
                edit_listing_transaction_hash,
                previous_fungible_id,
                previous_fungible_token_price,
                new_fungible_id,
                new_fungible_token_price,
                edit_listing_block,
                edit_listing_unixtime
            )
            VALUES 
            (
                (select listing_id from tbl_static_listing where static_order_id = _static_order_id),
                _edit_listing_transaction_hash,
                (select fungible_id from tbl_fungible where fungible_address = _previous_fungible_address),
                _previous_fungible_token_price,
                (select fungible_id from tbl_fungible where fungible_address = _new_fungible_address),
                _new_fungible_token_price,
                _edit_listing_block,
                _edit_listing_unixtime
            );

            -- Update tbl_static_listing with the latest price
            UPDATE tbl_static_listing
            SET 
                fungible_id = (select fungible_id from tbl_fungible where fungible_address = _new_fungible_address),
                listing_fungible_token_price = _new_fungible_token_price
            WHERE 
                listing_id = (select listing_id from tbl_static_listing where static_order_id = _static_order_id);
        END IF;
    END IF;

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
