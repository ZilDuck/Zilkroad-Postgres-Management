insert into tbl_fungible 
(
	fungible_address,
	fungible_name,
	fungible_symbol, 
	decimals
)
values 
('0x4306f921c982766810cf342775fd79aa2d0d0e24','Wrapped Zilliqa','WZIL',12),
('0xa845c1034cd077bd8d32be0447239c7e4be6cb21','Governance Zilliqa','GZIL',15), 
('0x3bd9ad6fee7bfdf5b5875828b555e4f702e427cd','StraitsX Singapore Dollar','XSGD',6), 
('0x75fa7d8ba6bed4a68774c758a5e43cfb6633d9d6','Wrapped Zilliqa Bitcoin','zWBTC',8),
('0x2ca315f4329654614d1e8321f9c252921192c5f2','Wrapped Zilliqa Ethereum','zETH',18),
('0x818ca2e217e060ad17b7bd0124a483a1f66930a9','Wrapped Zilliqa Tether Dollar','zUSDT', 6),
('0xc6bb661eda683bdc792b3e456a206a92cc3cb92e','Duck Duck','DUCK', 2)
ON CONFLICT DO NOTHING;

INSERT INTO tbl_nonfungible
(
	nonfungible_address, 
	nonfungible_symbol, 
	nonfungible_name
) 
VALUES 
(	
	('0x8ab2af0cccee7195a7c16030fbdfde6501d91903','NFD','Non Fungible Ducks'),
	('0x38c30391667d178e982af3a14e8bd2aa00efc771','BIOME','Bizarre Biomes'),
	('0x8a79bac7a6383211ae902f34e86c6b729906346d','TSC','The Soulless Citadel'),
	('0xd2b54e791930dd7d06ea51f3c2a6cf2c00f165ea','BEANEL','Beanterra'),
	('0x92ae7E92E0804501c67cF43Fdb333c9B79bc0Fc5','DEM','DeMons'),
	('0xb3b9d125da9b2a5414da60bc001844113498b738','ORDER','The Order of the Redeemed Exodus Token'),
	('0xc27bd09322a86e5abdafbcd60248e1f4d601f881','ORDER','The Order of the Redeemed Genesis Token'),
	('0xf79a456a5afd412d3890e2232f6205f664be8957','ZOA','Metazoa'),
	('0xd793f378a925b9f0d3c4b6ee544d31c707899386','BEAR','The Bear Market'),
	('0xe6af3c79f12c39c661627c8f9457c14ea2b9fd52','FJNFT','FootballJunkz'),
	('0xf1ae398e00f6c0e5d7f55d56c9e05194f62925af','CTI','Project Centauri'),
	('0xf559c705c21631912dfed62157471f683c2c20b3','ROOM','Roomz'),
	('0x1de7bc91b48137365ad87234f3cb644592fa95dc','AUA','Ailuaractos'),
	('0xd0ee34da6cce460152840fba08348fc19f5a1a18','PANDA','DirectorPanda')
)
ON CONFLICT DO NOTHING;



insert into tbl_verified_contract 
(   
	nonfungible_id
)
values 
(
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0x8ab2af0cccee7195a7c16030fbdfde6501d91903'),
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0x38c30391667d178e982af3a14e8bd2aa00efc771'),
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0x8a79bac7a6383211ae902f34e86c6b729906346d'),
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0xd2b54e791930dd7d06ea51f3c2a6cf2c00f165ea'),
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0x92ae7E92E0804501c67cF43Fdb333c9B79bc0Fc5'),
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0xb3b9d125da9b2a5414da60bc001844113498b738'),
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0xc27bd09322a86e5abdafbcd60248e1f4d601f881'),
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0xf79a456a5afd412d3890e2232f6205f664be8957'),
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0xd793f378a925b9f0d3c4b6ee544d31c707899386'),
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0xe6af3c79f12c39c661627c8f9457c14ea2b9fd52')
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0xf1ae398e00f6c0e5d7f55d56c9e05194f62925af')
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0xf559c705c21631912dfed62157471f683c2c20b3')
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0x1de7bc91b48137365ad87234f3cb644592fa95dc')
	(SELECT nonfungible_id from tbl_nonfungible where nonfungible_address = '0xd0ee34da6cce460152840fba08348fc19f5a1a18')
)
ON CONFLICT DO NOTHING;

insert into tbl_proxy_contract
(
	proxy_address, 
	proxy_nonfungible_address,
	proxy_max_mint,
	proxy_price_cost_qa,
	proxy_beneficiary_address,
	proxy_open_mint_block
)
values
(
	( -- DUCK
	  '0xb00c8237e286abcac07e6795ab74e1ec1b075870', 
	  '0x8ab2af0cccee7195a7c16030fbdfde6501d91903', 
	  '8192', 
	  '', -- varies - we might need to pull the logic from duck.community for just this one proxy?
	  '',
	  '1961613' 
	),

	( -- BIOMES
	  '0xe9a3b0779af1dfa756187f333dba88e8187d21e9', 
	  '0x38c30391667d178e982af3a14e8bd2aa00efc771', 
	  '3000', 
	  '2000000000000000',
	  '',
	  '2151756' 
	),
)
ON CONFLICT DO NOTHING;