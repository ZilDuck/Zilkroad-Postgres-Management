-------------------------------------------------------------------------------
-- Created      11-10-2022
-- Purpose      Index
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 11-10-2022  Rich Inital creation.
-------------------------------------------------------------------------------

CREATE INDEX ix_search_term_tbl_nonfungible ON
tbl_nonfungible
USING GIN(simple_tsvector);
