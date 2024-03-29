CREATE EXTENSION pg_trgm;

insert into tbl_fungible 
(
	fungible_address,
	fungible_name,
	fungible_symbol, 
	decimals
)
values 
('0x0000000000000000000000000000000000000000','NULL','NULL','NULL',0),
('0x864895d52504c388a345ef6cd9c800dbbd0ef92a','Testnet Wrapped Zilliqa','WZIL',12),
('0x607d0ba69c3680ed07262e5d80be98c401fd612c','Testnet Governance Zilliqa','GZIL',15),
('0x56906c825a6df74032ea40b4ff882b5970f3d0a8','Testnet StraitsX Singapore Dollar','XSGD',6),
('0x9fe903bf7c48d6bf4bcc7c53e77d3d2a2ebbf5ae','Testnet Wrapped Zilliqa Bitcoin','zWBTC',8),
('0x049346a00627b89441b2d5110b09c376913f19ff','Testnet Wrapped Zilliqa Ethereum','zETH',18),
('0x9fce53c80e07fddb02450fc9b435b0a7781b68a8','Testnet Wrapped Zilliqa Tether Dollar','zUSDT', 6),
('0xe743ff40e780fe08dee4e2ad830983d1979ff2e6','Testnet Duck Duck','DUCK', 2)
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
	'Non Fungible Ducks 3 : Project Feathers',
	'With the release of Zilkroad, the last chapter in the NFD trilogy begins now. Firstly pioneering the first hyped ZRC-6 collection, then built the most open and robust marketplace, including a community indexer. Some efforts have moved to Project Feathers (NFT DeFi) and progress is faster than ever. Your key into the next degenerate play? You bet your feathery ass it is.',
	'https://duck.community/',
	'zil1whwpm8gywvp7c5dhs7rf63qrf6pc5ahdgudn55',
	'https://cdn.discordapp.com/attachments/914536079225421904/1016067052949213325/ducks.png',
	''
),
( 
	0,
	292277026590,
	'Bizarre Biomes',
	'Bizarre Biomes (BB) was a project by Duck team to support funding for the community indexer `zildexer.com`. BB launched with 43.3% supply being airdropped to Duck holders and LPers. To date, BB has the record for most tokens freely distributed for no cost.',
	'https://bizarrebiomes.com/',
	'zil1nnkpx4agts4zp6fay6hj4f7klewx52wp95ejyt',
	'https://cdn.discordapp.com/attachments/914536079225421904/1016067052609470545/biomes.png',
	''
),
(
	0,
	292277026590,
	'Envizion : Tell stories the web3 way.',
	'Envizion provides a platform for NFTs to expand their storytelling ability, enabling NFT community users to jointly create and promote cooperation between different NFT projects.',
	'https://envizion.world/',
	'zil16rhrfknveerqz55yp7aqsdy0cx045xscg55w6c',
	'https://cdn.discordapp.com/attachments/924409140485423144/1016671092338851840/0011.png',
	'https://cdn.discordapp.com/attachments/924409140485423144/1016671092573745273/0021.png'
),
( 
	0,
	292277026590,
	'Become part of the Legend.',
	'The Soulless Citadel is a cinematic universe around a meticulously designed storyline created by award-winning filmmakers and supported by unique and verifiable NFTs.',
	'https://soullesscitadel.com/mint/chapter-2',
	'zil13fum43ax8qeprt5s9u6wsmrtw2vsvdrdhmvtrm',
	'https://cdn.discordapp.com/attachments/954800274491461702/1036624875386851400/IMG_0427_2.PNG',
	'https://cdn.discordapp.com/attachments/954800274491461702/1036624875760123974/IMG_0428.PNG'
),
(
	0,
	292277026590,
	'Alfie Members Club',
	'Alfie the Crypto Butler! 👾 Manage your Zilliqa portfolio on one dashboard! By holding an Alfie NFT, users get access to premium features on the HeyAlfie dashboard. 😎',
	'https://app.heyalfie.io/membership',
	'zil1vdgz4dl383d6gtt02lncgu0g49dkpr899qwlmn',
	'https://cdn.discordapp.com/attachments/924409140485423144/1031312978940796938/Zilkroad_Ads_-_2448.png',
	'https://cdn.discordapp.com/attachments/924409140485423144/1031312979637047296/Zilkroad_Ads_-_1200.png'
);

ON CONFLICT DO NOTHING;