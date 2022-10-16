CREATE EXTENSION pg_trgm;

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


insert into tbl_advertise_card 
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
values 
(
	0,
	292277026590,
	'Non Fungible Ducks 3 : Project Feathers'
	'With the release of Zilkroad, the last chapter in the NFD trilogy begins now. Firstly pioneering the first hyped ZRC-6 collection, then built the most open and robust marketplace, including a community indexer. Some efforts have moved to Project Feathers (NFT DeFi) and progress is faster than ever. Your key into the next degenerate play? You bet your feathery ass it is.',
	'https://duck.community/'
	'0x8ab2af0cccee7195a7c16030fbdfde6501d91903',
	'https://cdn.discordapp.com/attachments/914536079225421904/1016067052949213325/ducks.png',
	''
),
( 
	0,
	292277026590,
	'Bizarre Biomes'
	'Bizarre Biomes (BB) was a project by Duck team to support funding for the community indexer `zildexer.com`. BB launched with 43.3% supply being airdropped to Duck holders and LPers. To date, BB has the record for most tokens freely distributed for no cost.',
	'https://bizarrebiomes.com/'
	'0x38c30391667d178e982af3a14e8bd2aa00efc771',
	'https://cdn.discordapp.com/attachments/914536079225421904/1016067052609470545/biomes.png',
	''
),
( 
	1662727866, -- 9th sept
	1672002558, -- 25th dec
	'Envizion : Tell stories the web3 way.'
	'Envizion provides a platform for NFTs to expand their storytelling ability, enabling NFT community users to jointly create and promote cooperation between different NFT projects.',
	'https://envizion.world/'
	'0xD0ee34dA6cce460152840fbA08348fc19f5a1A18',
	'https://cdn.discordapp.com/attachments/924409140485423144/1016671092338851840/0011.png',
	'https://cdn.discordapp.com/attachments/924409140485423144/1016671092573745273/0021.png'
),
( 
	1662727866, -- 9th sept
	1672002558, -- 25th dec
	'Become part of the storyline created by award-winning filmmakers that unravels the secrets of The Soulless Citadel in Chapters. Chapter 2: The Rise of the Women Warriors minting soon!'
	'The Soulless Citadel is a cinematic universe around a meticulously designed storyline created by award-winning filmmakers— supported by unique and verifiable NFTs across multiple Blockchains. After partnering up with the leading development team Quinence, and Hollywood screenwriters Janet and Lee Batchler, they are now building their universe in Chapters. As Chapter 1, the Soulless Citadel, launched and sold out in February, had great success, they began moving onto Chapter 2, The Rise of the Women Warriors.


Mint date: 30 Sept, 2022.

Collection size: 5555.

WL Mint price: $63 (1750 ZIL)

Public Mint price: $80 (2250 ZIL)


IMPORTANT INFO: Mint will be one-click with debit/credit card/Apple/Google Pay, no extra steps or verification needed. No need to use ZIL unless you want to. WL available through community events and for Ch 1 holders, snapshot will be taken at a random time after 23rd Sept.',
	'https://soullesscitadel.com/mint/chapter-2',
	'',
	'https://cdn.discordapp.com/attachments/924409140485423144/1031314001763766352/Women_warrior_Mint_date.png',
	'https://cdn.discordapp.com/attachments/924409140485423144/1031314001407250432/Women_mint_date_squarer_file.png'
),
(
	1662727866, -- 9th sept
	1672002558, -- 25th dec
	'Alfie Members Club'
	'Alfie the Crypto Butler! 👾 Manage your Zilliqa portfolio on one dashboard! By holding an Alfie NFT, users get access to premium features on the HeyAlfie dashboard. 😎',
	'https://app.heyalfie.io/membership'
	'0x63502ab7f13c5ba42d6f57e78471e8a95b608ce5',
		'https://cdn.discordapp.com/attachments/924409140485423144/1031312978940796938/Zilkroad_Ads_-_2448.png',
	'https://cdn.discordapp.com/attachments/924409140485423144/1031312979637047296/Zilkroad_Ads_-_1200.png'
),
ON CONFLICT DO NOTHING;