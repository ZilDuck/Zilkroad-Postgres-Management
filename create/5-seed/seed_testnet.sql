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
	'0x75DC1D9d047303EC51B787869D44034E838a76Ed',
	'https://cdn.discordapp.com/attachments/914536079225421904/1016067052949213325/ducks.png',
	''
),
( 
	0,
	292277026590,
	'Bizarre Biomes',
	'Bizarre Biomes (BB) was a project by Duck team to support funding for the community indexer `zildexer.com`. BB launched with 43.3% supply being airdropped to Duck holders and LPers. To date, BB has the record for most tokens freely distributed for no cost.',
	'https://bizarrebiomes.com/',
	'0x38c30391667d178e982af3a14e8bd2aa00efc771',
	'https://cdn.discordapp.com/attachments/914536079225421904/1016067052609470545/biomes.png',
	''
),
(
	0,
	292277026590,
	'Envizion : Tell stories the web3 way.',
	'Envizion provides a platform for NFTs to expand their storytelling ability, enabling NFT community users to jointly create and promote cooperation between different NFT projects.',
	'https://envizion.world/',
	'0xD0ee34dA6cce460152840fbA08348fc19f5a1A18',
	'https://cdn.discordapp.com/attachments/924409140485423144/1016671092338851840/0011.png',
	'https://cdn.discordapp.com/attachments/924409140485423144/1016671092573745273/0021.png'
),
( 
	0,
	292277026590,
	'Become part of the storyline. Chapter 2: The Rise of the Women Warriors minting soon!',
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
	0,
	292277026590,
	'Alfie Members Club',
	'Alfie the Crypto Butler! 👾 Manage your Zilliqa portfolio on one dashboard! By holding an Alfie NFT, users get access to premium features on the HeyAlfie dashboard. 😎',
	'https://app.heyalfie.io/membership',
	'0x63502ab7f13c5ba42d6f57e78471e8a95b608ce5',
	'https://cdn.discordapp.com/attachments/924409140485423144/1031312978940796938/Zilkroad_Ads_-_2448.png',
	'https://cdn.discordapp.com/attachments/924409140485423144/1031312979637047296/Zilkroad_Ads_-_1200.png'
);

ON CONFLICT DO NOTHING;