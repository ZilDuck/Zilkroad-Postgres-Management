-------------------------------------------------------------------------------
-- Created      27-02-2022
-- Purpose      Gets the listing/delisting/sold activity for a particular wallet
-- Copyright © 2022, Zilkroad, All Rights Reserved
-------------------------------------------------------------------------------
-- Modification History
--
-- 27-02-2022  Richard Initial creation.
-------------------------------------------------------------------------------

CREATE TABLE "tbl_deployments" (
	file_name text PRIMARY KEY,
	manual_deployment boolean DEFAULT False NOT NULL,
	date_applied timestamp DEFAULT now() NOT NULL
);
