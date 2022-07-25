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
('0x049346a00627b89441b2d5110b09c376913f19ff','Testnet Wrapped Zilliqa Ethereum','zETH',18),
('0x9fce53c80e07fddb02450fc9b435b0a7781b68a8','Testnet Wrapped Zilliqa Tether Dollar','zUSDT', 6),
('0xe743ff40e780fe08dee4e2ad830983d1979ff2e6','Testnet Duck Duck','DUCK', 2)
ON CONFLICT DO NOTHING;
