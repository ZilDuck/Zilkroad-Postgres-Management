-------------------------------------------------------------------------------
-- Created      15-01-2022
-- Purpose      
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 15-01-2022  Nines Inital creation.
-- 02-02-2022  Resolves multiple prior extract_nft_id's and takes latest
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_insertAllRowsForStaticListing
(
    _nonfungible_address varchar(42),             -- nonfungible      @Emitted
    _nonfungible_symbol varchar(255),             -- nonfungible      @Lookup
    _nonfungible_name varchar(255),               -- nonfungible      @Lookup
    _token_id numeric(78,0),                      -- nonfungibletoken @Emitted
    _fungible_address varchar(42),                -- fungible         @Emitted
    _static_order_id integer,                     -- listing          @Emitted
    _listing_transaction_hash varchar(66),        -- listing          @Emitted
    _listing_fungible_token_price numeric(40),    -- listing          @Emitted
    _listing_block numeric,                       -- listing          @Emitted
    _listing_unixtime bigint,                     -- listing          @Calculated
    _listing_user_address varchar(42)             -- listing          @Emitted
) 
RETURNS VOID
AS 
$BODY$
BEGIN

    IF NOT EXISTS 
    (
        select block from tbl_handled_block where block = _listing_block
    )
    THEN
        insert into tbl_handled_block values (_listing_block);
   ELSE
   END IF;
   
    IF NOT EXISTS 
    (
        select nonfungible_id from tbl_nonfungible where nonfungible_address = LOWER(_nonfungible_address)
    )
    THEN
        -- 1 Add non fungible contract and get a nonfungible_id
        -- 1A If nonfungible_id doesn't exist for tbl_nonfungible then insert the data
        INSERT INTO tbl_nonfungible
        (
            nonfungible_address,
            nonfungible_symbol,
            nonfungible_name
        ) 
        VALUES 
        (	
            _nonfungible_address,
            _nonfungible_symbol,
            _nonfungible_name
        );
   ELSE
   END IF;

    IF NOT EXISTS 
    (
        SELECT nft.extract_nft_id 
        FROM tbl_nonfungible nf 
        left join tbl_nonfungible_token nft
        on nft.nonfungible_id = nf.nonfungible_id
        WHERE nf.nonfungible_address = LOWER(_nonfungible_address) -- previously computed 1A, now exists for all tokens
        AND nft.token_id = _token_id 
        ORDER BY nft.extract_nft_id
        LIMIT 1
    )
    THEN
        -- 2 Add non fungible token and get extract_nft_id
        -- 2A If extract_nft_id doesn't exist for address/tokenid then insert the data
        INSERT INTO tbl_nonfungible_token
        (
            nonfungible_id, 
            token_id
        ) 
        VALUES 
        (	
            (
                SELECT nf.nonfungible_id 
                FROM tbl_nonfungible nf 
                left join tbl_nonfungible_token nft
                on nft.nonfungible_id = nf.nonfungible_id
                WHERE nf.nonfungible_address = LOWER(_nonfungible_address) -- previously computed 1A, now exists for all tokens, wont know what the token id is first time
                group by nf.nonfungible_id
            ), 
            _token_id
        )
        ON CONFLICT DO NOTHING;
   ELSE
   END IF;

    -- 3 Add a static listing and get a listing_id
    insert into tbl_static_listing 
    (
        extract_nft_id, 
        fungible_id,
        listing_transaction_hash,
        listing_fungible_token_price,
        listing_block,
        listing_unixtime,
        listing_user_address,
        static_order_id
    )
    values 
    (
        (
            SELECT nft.extract_nft_id 
            FROM tbl_nonfungible nf 
            left join tbl_nonfungible_token nft
            on nft.nonfungible_id = nf.nonfungible_id
            WHERE nf.nonfungible_address = LOWER(_nonfungible_address) -- previously computed 1A, now exists for all tokens
            AND nft.token_id = _token_id                        -- previously computed 2A, now exists for all tokens
        ),
        (
            select fungible_id from tbl_fungible where fungible_address = _fungible_address
        ),
        _listing_transaction_hash,
        _listing_fungible_token_price,
        _listing_block,
        _listing_unixtime,
        _listing_user_address,
        _static_order_id
    );

END;
$BODY$
LANGUAGE plpgsql VOLATILE SECURITY DEFINER COST 100;
