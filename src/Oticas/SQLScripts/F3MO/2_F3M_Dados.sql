﻿INSERT tbVersao (Major, Minor, Version, dbversion,dbversionsistema,[Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) values ( 1, 0, 1, 1,1, 1, 0, getdate(), 'F3M', getdate(), 'F3M')

SET IDENTITY_INSERT [dbo].[tbMoedas] ON ; INSERT INTO [dbo].[tbMoedas] ([ID],[Codigo] ,[Descricao],[TaxaConversao] ,[DescricaoDecimal],[DescricaoInteira],[CasasDecimaisTotais],[CasasDecimaisIva],[CasasDecimaisPrecosUnitarios] ,[Sistema] ,[Ativo] ,[DataCriacao] ,[UtilizadorCriacao], [IDSistemaMoeda]) VALUES(1,'EUR', 'Euro', 1, 'Cêntimo','Euro', 2,2,4,1,1, GETDATE(),N'F3M',1) ; SET IDENTITY_INSERT [dbo].[tbMoedas] OFF

INSERT tbLojas (Id, IdEmpresa, Codigo, Descricao, IdLojaSede, DescricaoLojaSede , SedeGrupo,[Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) values ( 1, 1, 1, 'Sede', 1, 'Sede', 1, 1, 0, getdate(), 'F3M', getdate(), 'F3M')

SET IDENTITY_INSERT [dbo].[tbParametrosEmpresa] ON ; INSERT INTO [dbo].[tbParametrosEmpresa] ([ID],[IDMoedaDefeito], [CasasDecimaisPercentagem], [Morada], [Foto], [FotoCaminho], [DesignacaoComercial], [CodigoPostal],[Localidade], [Concelho], [Distrito], [IDPais], [Telefone], [Fax], [Email], [WebSite], [NIF], [ConservatoriaRegistoComercial], [NumeroRegistoComercial], [CapitalSocial], [IDIdiomaBase], [IDEmpresa], [Sistema] ,[Ativo] ,[DataCriacao] ,[UtilizadorCriacao]) VALUES(1,1, 6, 'Edifício F3M, Rua de Linhares', '', '/F3M/Images/gerais/Empresas/', 'F3M - Information Systems, SA', '4715-435', 'Braga', 'Braga', 'Braga',919, '253 250 300', '253 613 561', 'contacto@f3m.pt', 'www.f3m.pt','501854371', 'CRC de Braga','2472','450.000€',111,1,1,1, GETDATE(),N'F3M') ; SET IDENTITY_INSERT [dbo].[tbParametrosEmpresa] OFF

SET IDENTITY_INSERT [dbo].[tbParametrosEmpresaCAE] ON ; INSERT INTO [dbo].[tbParametrosEmpresaCAE] ([ID],[IDParametrosEmpresa],[Codigo],[Descricao], [Sistema] ,[Ativo] ,[DataCriacao] ,[UtilizadorCriacao]) VALUES(1,1,1,'Cae1',1,1,GETDATE(),N'F3M') ; SET IDENTITY_INSERT [dbo].[tbParametrosEmpresaCAE] OFF