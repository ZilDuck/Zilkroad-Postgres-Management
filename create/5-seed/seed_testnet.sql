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
('0x2e8e7d992c8dc04f89c4e5e798b2fa8345885b18','Testnet Wrapped Zilliqa Ethereum','zETH',18),
('0x9fe903bf7c48d6bf4bcc7c53e77d3d2a2ebbf5ae','Testnet Wrapped Zilliqa Tether Dollar','zUSDT', 6),
('0x30832ed39781b7840485f79fb971bb67a595a2b2','Testnet Duck Duck','DUCK', 2)
ON CONFLICT DO NOTHING;
