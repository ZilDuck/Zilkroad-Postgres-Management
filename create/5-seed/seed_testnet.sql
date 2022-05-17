insert into tbl_fungible 
(
	fungible_address,
	fungible_name,
	fungible_symbol, 
	decimals
)
values 
('0x864895d52504c388a345ef6cd9c800dbbd0ef92a','Testnet Wrapped Zilliqa','WZIL',12),
('0x607d0ba69c3680ed07262e5d80be98c401fd612c','Testnet Governance Zilliqa','GZIL',15),
('0x56906c825a6df74032ea40b4ff882b5970f3d0a8','Testnet StraitsX Singapore Dollar','XSGD',6),
('0x9fe903bf7c48d6bf4bcc7c53e77d3d2a2ebbf5ae','Testnet Wrapped Zilliqa Bitcoin','zWBTC',8),
('0x2e8e7d992c8dc04f89c4e5e798b2fa8345885b18','Testnet Wrapped Zilliqa Ethereum','zWETH',18),
('0x9fe903bf7c48d6bf4bcc7c53e77d3d2a2ebbf5ae','Testnet Wrapped Zilliqa Tether Dollar','zUSDT', 6),
('0x30832ed39781b7840485f79fb971bb67a595a2b2','Testnet Duck Duck','DUCK', 2)
ON CONFLICT DO NOTHING;




-- mainnet seed

-- insert into tbl_fungible 
-- (
-- 	fungible_address,
-- 	fungible_name,
-- 	fungible_symbol, 
-- 	decimals
-- )
-- values 
-- ('0x4306f921c982766810cf342775fd79aa2d0d0e24','Wrapped Zilliqa','WZIL',12),
-- ('0xa845c1034cd077bd8d32be0447239c7e4be6cb21','Governance Zilliqa','GZIL',15), 
-- ('0x3bd9ad6fee7bfdf5b5875828b555e4f702e427cd','StraitsX Singapore Dollar','XSGD',6), 
-- ('0x75fa7d8ba6bed4a68774c758a5e43cfb6633d9d6','Wrapped Zilliqa Bitcoin','zWBTC',8),
-- ('0x2ca315f4329654614d1e8321f9c252921192c5f2','Wrapped Zilliqa Ethereum','zWETH',18),
-- ('0x818ca2e217e060ad17b7bd0124a483a1f66930a9','Wrapped Zilliqa Tether Dollar','zUSDT', 6),
-- ('0xc6bb661eda683bdc792b3e456a206a92cc3cb92e','Duck Duck','DUCK', 2)
-- ON CONFLICT DO NOTHING;

-- INSERT INTO tbl_nonfungible
-- (
-- 	nonfungible_address, 
-- 	nonfungible_symbol, 
-- 	nonfungible_name
-- ) 
-- VALUES 
-- (	
-- 	('0x8ab2af0cccee7195a7c16030fbdfde6501d91903','NFD','Non Fungible Ducks'),
-- 	('0x8a79bac7a6383211ae902f34e86c6b729906346d','TSC','The Soulless Citadel'),
-- 	('0xd2b54e791930dd7d06ea51f3c2a6cf2c00f165ea','BEANEL','Beanterra')
-- )
-- ON CONFLICT DO NOTHING;

-- insert into tbl_verified_contract 
-- (   
-- 	nonfungible_id
-- )
-- values 
-- (
-- 	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0x8ab2af0cccee7195a7c16030fbdfde6501d91903'),
-- 	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0x8a79bac7a6383211ae902f34e86c6b729906346d'),
-- 	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0xd2b54e791930dd7d06ea51f3c2a6cf2c00f165ea'),
-- )
-- ON CONFLICT DO NOTHING;