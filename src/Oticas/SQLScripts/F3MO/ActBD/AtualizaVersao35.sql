/* ACT BD EMPRESA VERSAO 35*/
--valores das siglas por defeito
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''AS'', DescricaoPais = ''Samoa Americana''  where id = 746')
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''DO'', DescricaoPais = ''República Dominicana''  where id = 796')
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''HU'', DescricaoPais = ''Hungria''  where id = 835')
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''IN'', DescricaoPais = ''India''  where id = 840')
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''SI'', DescricaoPais = ''Islândia''  where id = 844')
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''IT'', DescricaoPais = ''Itália'' where id = 845')
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''ME'', DescricaoPais = ''Montenegro''  where id = 875')
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''TG'', DescricaoPais = ''Togo''  where id = 952')
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''TO'', DescricaoPais = ''Tonga''  where id = 959')
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''TR'', DescricaoPais = ''Turquia''  where id = 960')
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''DJ'', DescricaoPais = ''Djibouti''  where id = 793')
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''DE'', DescricaoPais = ''Alemanha''  where id = 792')
EXEC('UPDATE tbSistemaSiglasPaises SET Descricao = ''MP'', DescricaoPais = ''Ilhas Marianas do Norte''  where id = 884')

EXEC('UPDATE tbPaises SET Descricao = ''Samoa Americana''  where IDSigla = 746')
EXEC('UPDATE tbPaises SET Descricao = ''República Dominicana''  where IDSigla = 796')
EXEC('UPDATE tbPaises SET Descricao = ''Hungria''  where IDSigla = 835')
EXEC('UPDATE tbPaises SET Descricao = ''India''  where IDSigla = 840')
EXEC('UPDATE tbPaises SET Descricao = ''Islândia''  where IDSigla = 844')
EXEC('UPDATE tbPaises SET Descricao = ''Itália'' where IDSigla = 845')
EXEC('UPDATE tbPaises SET Descricao = ''Montenegro''  where IDSigla = 875')
EXEC('UPDATE tbPaises SET Descricao = ''Togo''  where IDSigla = 952')
EXEC('UPDATE tbPaises SET Descricao = ''Tonga''  where IDSigla = 959')
EXEC('UPDATE tbPaises SET Descricao = ''Turquia''  where IDSigla = 960')
EXEC('UPDATE tbPaises SET Descricao = ''Djibouti''  where IDSigla = 793')
EXEC('UPDATE tbPaises SET Descricao = ''Alemanha''  where IDSigla = 792')
EXEC('UPDATE tbPaises SET Descricao = ''Ilhas Marianas do Norte''  where IDSigla = 884')
EXEC('UPDATE [F3MOGeral].dbo.tbmenus set btncontextoalterar=0, btncontextoexportar=0, btncontextoduplicar=0, btncontextoimprimir=0 where descricao=''InventarioAT''')

--configurações por defeito
EXEC('update [F3MOGeral].dbo.tbUtilizadores set VendaAbaixoCustoMedio=1 where VendaAbaixoCustoMedio is null')

--mapa vista das etiquetas
EXEC('
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
DELETE FROM [dbo].[tbMapasVistas] WHERE ID=40
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (40, 40, N''EtiquetasRoloB'', N''EtiquetasRoloC'', N''rptEtiquetasRoloC'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, N''select * from vwArtigos'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')
 

  --nova tabela de inventario AT
EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbComunicacaoAutoridadeTributaria]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbComunicacaoAutoridadeTributaria](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Filtro] [text] NOT NULL,
	[Observacoes] [text] NULL,
	[FicheiroXML] [nvarchar](255) NULL, 
	[CaminhoXML] [nvarchar](max) NULL, 
	[FicheiroCSV] [nvarchar](255) NULL, 
	[CaminhoCSV] [nvarchar](max) NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Sistema] [bit] NULL CONSTRAINT [DF_tbComunicacaoAutoridadeTributaria_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoAutoridadeTributaria_Ativo]  DEFAULT ((1)),
 CONSTRAINT [PK_tbComunicacaoAutoridadeTributaria] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END')

  --nova tabela de inventario AT Linhas
EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbComunicacaoAutoridadeTributariaLinhas]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbComunicacaoAutoridadeTributariaLinhas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDComunicacaoAutoridadeTributaria] [bigint] NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[CodigoArtigo] [nvarchar](255) NOT NULL,
	[DescricaoArtigo] [nvarchar](255) NOT NULL,
	[Categoria] [varchar](20) NULL,
	[CodigoDeBarras] [nvarchar](50) NULL,
	[IDUnidade] [bigint] NOT NULL,
	[CodigoUnidade] [varchar](255) NOT NULL,
	[DescricaoUnidade] [varchar](255) NOT NULL,
	[QuantidadeEmStock] [float] NOT NULL,
	[Ordem] [int] NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoAutoridadeTributariaLinhas_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoAutoridadeTributariaLinhas_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbComunicacaoAutoridadeTributariaLinhas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbComunicacaoAutoridadeTributariaLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoAutoridadeTributariaLinhas_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])
ALTER TABLE [dbo].[tbComunicacaoAutoridadeTributariaLinhas] CHECK CONSTRAINT [FK_tbComunicacaoAutoridadeTributariaLinhas_tbArtigos]

ALTER TABLE [dbo].[tbComunicacaoAutoridadeTributariaLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoAutoridadeTributariaLinhas_tbUnidades] FOREIGN KEY([IDUnidade])
REFERENCES [dbo].[tbUnidades] ([ID])
ALTER TABLE [dbo].[tbComunicacaoAutoridadeTributariaLinhas] CHECK CONSTRAINT [FK_tbComunicacaoAutoridadeTributariaLinhas_tbUnidades]
END')


--nova tabela de inventario At anexos
EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbComunicacaoAutoridadeTributariaAnexos]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbComunicacaoAutoridadeTributariaAnexos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDComunicacaoAutoridadeTributaria] [bigint] NOT NULL,
	[IDTipoAnexo] [bigint] NULL,
	[Descricao] [nvarchar](255) NULL,
	[FicheiroOriginal] [nvarchar](255) NULL,
	[Ficheiro] [nvarchar](255) NOT NULL,
	[FicheiroThumbnail] [nvarchar](300) NULL,
	[Caminho] [nvarchar](max) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoAutoridadeTributariaAnexos_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoAutoridadeTributariaAnexos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbComunicacaoAutoridadeTributariaAnexos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tbComunicacaoAutoridadeTributariaAnexos] UNIQUE NONCLUSTERED 
(
	[IDComunicacaoAutoridadeTributaria] ASC,
	[Ficheiro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbComunicacaoAutoridadeTributariaAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoAutoridadeTributariaAnexos_tbComunicacaoAutoridadeTributaria] FOREIGN KEY([IDComunicacaoAutoridadeTributaria])
REFERENCES [dbo].[tbComunicacaoAutoridadeTributaria] ([ID])
ALTER TABLE [dbo].[tbComunicacaoAutoridadeTributariaAnexos] CHECK CONSTRAINT [FK_tbComunicacaoAutoridadeTributariaAnexos_tbComunicacaoAutoridadeTributaria]

ALTER TABLE [dbo].[tbComunicacaoAutoridadeTributariaAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoAutoridadeTributariaAnexos_tbSistemaTiposAnexos] FOREIGN KEY([IDTipoAnexo])
REFERENCES [dbo].[tbSistemaTiposAnexos] ([ID])
ALTER TABLE [dbo].[tbComunicacaoAutoridadeTributariaAnexos] CHECK CONSTRAINT [FK_tbComunicacaoAutoridadeTributariaAnexos_tbSistemaTiposAnexos]
END')

 --novo menu Inventario AT
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=133)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (133, 99, N''InventarioAT'', N''012.002.004'', N''InventarioAT'', 1, N''f3icon-inventario'', N''/Utilitarios/InventarioAT'', 1, 1, 1, 0, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=133 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 133, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

--novo menu Inventario AT anexos
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=134)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (134, 133, N''InventarioATAnexos'', N''012.002.005'', N''Anexos'', 2, N''f3icon-puzzle-piece'', N''/Utilitarios/InventarioATAnexos'', 1, 1, 1, 1, 1, 1, 1, 1, NULL, 1, 1, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=134 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 134, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')


--lista personalizada de inventario AT
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE TabelaPrincipal=''tbComunicacaoAutoridadeTributaria'')
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ON
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([ID], [Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query]) 
VALUES (89, N''Inventário AT'', 1, 1, 133, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbComunicacaoAutoridadeTributaria'', 
N''select D.Ativo, D.ID as ID, D.DataCriacao as CreatedAt, D.UtilizadorCriacao as CreatedBy, D.DataAlteracao as UpdatedAt, D.DateFilter, D.WhereHousesFilterName from tbComunicacaoAutoridadeTributaria D '')
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] OFF
END')


EXEC('
BEGIN
DECLARE @IDLista int
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE TabelaPrincipal=''tbComunicacaoAutoridadeTributaria''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE [IDListaPersonalizada]=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [Ordem]) VALUES (N''DateFilter'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbComunicacaoAutoridadeTributaria'', 1, 1, 150, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [Ordem]) VALUES (N''CreatedAt'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbComunicacaoAutoridadeTributaria'', 1, 1, 150, 200)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [Ordem]) VALUES (N''WhereHousesFilterName'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbComunicacaoAutoridadeTributaria'', 1, 1, 700, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [Ordem]) VALUES (N''CreatedBy'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbComunicacaoAutoridadeTributaria'', 1, 1, 150, 400)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [Ordem]) VALUES (N''UpdatedAt'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbComunicacaoAutoridadeTributaria'', 1, 1, 200, 500)
END')

-- criação do campo IDPais nos armazens
EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbArmazens'' AND COLUMN_NAME = ''IDPais'')
Begin
    ALTER TABLE tbArmazens ADD IDPais bigint NULL

	ALTER TABLE [dbo].[tbArmazens]  WITH CHECK ADD  CONSTRAINT [FK_tbArmazens_tbPaises] FOREIGN KEY([IDPais])
	REFERENCES [dbo].[tbPaises] ([ID])
End')

-- criação do campo Inventariado nos artigos
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbArtigos'' AND COLUMN_NAME = ''Inventariado'') 
BEGIN
ALTER TABLE [dbo].[tbArtigos] ADD Inventariado bit null CONSTRAINT [DF_tbArtigos_Inventariado]  DEFAULT (1) WITH VALUES
END')

--criação de campos de importação
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbSistemaTiposDocumentoImportacao'' AND COLUMN_NAME = ''TabelaCabecalhoOrigem'') 
BEGIN
ALTER TABLE tbSistemaTiposDocumentoImportacao ADD TabelaCabecalhoOrigem nvarchar(max) null
END')

EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbSistemaTiposDocumentoImportacao'' AND COLUMN_NAME = ''TabelaLinhasOrigem'') 
BEGIN
ALTER TABLE tbSistemaTiposDocumentoImportacao ADD TabelaLinhasOrigem nvarchar(max) null
END')

EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbSistemaTiposDocumentoImportacao'' AND COLUMN_NAME = ''TabelaLinhasDimOrigem'') 
BEGIN
ALTER TABLE tbSistemaTiposDocumentoImportacao ADD TabelaLinhasDimOrigem nvarchar(max) null
END')

EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbSistemaTiposDocumentoImportacao'' AND COLUMN_NAME = ''CampoRelLinhasCabOrigem'') 
BEGIN
ALTER TABLE tbSistemaTiposDocumentoImportacao ADD CampoRelLinhasCabOrigem nvarchar(max) null
END')

EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbSistemaTiposDocumentoImportacao'' AND COLUMN_NAME = ''CampoRelLinDimLinhasOrigem'') 
BEGIN
ALTER TABLE tbSistemaTiposDocumentoImportacao ADD CampoRelLinDimLinhasOrigem nvarchar(max) null
END')

--criação de campos EstadoSaft documentos de venda/compra
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbDocumentosVendas'' AND COLUMN_NAME = ''EstadoSaft'') 
BEGIN
ALTER TABLE tbDocumentosVendas add EstadoSaft int null
END')

EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbDocumentosCompras'' AND COLUMN_NAME = ''EstadoSaft'') 
BEGIN
ALTER TABLE tbDocumentosCompras add EstadoSaft int null
END')


--impedir notas de crédito com valor superior às faturas
EXEC('DECLARE @IDModulo as bigint
DECLARE @IDSistTipoDoc as bigint
DECLARE @IDSistTipoDocFiscal as bigint
DECLARE @IDSistAcoes as bigint
Select @IDModulo = ID from tbSistemaModulos Where Codigo = ''004''
Select @IDSistTipoDoc =  ID from tbSistemaTiposDocumento Where Tipo = ''VndFinanceiro'' And IDModulo = @IDModulo
Select @IDSistTipoDocFiscal = ID from tbSistemaTiposDocumentoFiscal Where Tipo = ''NC'' And IDTipoDocumento = @IDSistTipoDoc
Select @IDSistAcoes = ID from tbSistemaAcoes Where Codigo = ''003''
UPDATE tbTiposDocumento Set IDSistemaAcoes = @IDSistAcoes Where IDSistemaTiposDocumento = @IDSistTipoDoc And IDSistemaTiposDocumentoFiscal = @IDSistTipoDocFiscal and codigo=''NC''')

EXEC('IF NOT EXISTS(SELECT * FROM [dbo].[tbSistemaCodigosIVA] WHERE ID=18)
BEGIN
INSERT [dbo].[tbSistemaCodigosIVA] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (18, N''M20'', N''IVA - Regime Forfetário'', 1, 1, CAST(N''2018-08-08 00:00:00.000'' AS DateTime), N''f3m'', NULL, NULL)
END')



--inventario
--nova vista de inventario à data
EXEC('
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
DELETE FROM [dbo].[tbMapasVistas] WHERE ID=41
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (41, 41, N''InventarioData'', N''InventarioData'', N''rptInventarioData'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, N''SELECT * FROM [dbo].[fnInventarioData] (''''2018-11-29'''',1)'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')

--lista personalizada de inventario à data
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Inventário à data'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDCateg as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Inventário à data'', @IDUtil, 0, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''fninventariodata'', 
N''SELECT * FROM [dbo].[fnInventarioData] ([@Data], [@IDValorizado])'', 1, 2)
END')


--colunas da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Inventário à data''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbArtigos'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoTipoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoTipoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoMarca'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, ''tbMarcas'', 0, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoMarca'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoArmazem'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoArmazem'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoArmazemLocalizacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoArmazemLocalizacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLote'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoLote'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UltimaEntrada'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UltimaSaida'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Quantidade'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Preco'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TotalMoeda'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Gerestock'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Inventariado'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoFornecedor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, ''tbFornecedores'', 0, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoFornecedor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 100)
END')


--parametros da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Inventário à data''
DELETE FROM [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD]) VALUES (@IDLista, N''Data'', N''F3MData'', 100, NULL, N''Data'', N''Date'', 1, 1, NULL, NULL, NULL, NULL, 1, 1, CAST(N''2018-11-15 00:00:00.000'' AS DateTime), N''MAF'', CAST(N''2018-11-15 00:00:00.000'' AS DateTime), N''F3M'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD]) VALUES (@IDLista, N''Valorizado'', N''F3MDropDownList'', 200, NULL, N''IDValorizado'', N''Long'', 1, 1, 13, N''../Sistema/SistemaTiposDocumentoPrecoUnitario'', NULL, NULL, 1, 1, CAST(N''2018-11-15 00:00:00.000'' AS DateTime), N''MAF'', CAST(N''2018-11-15 00:00:00.000'' AS DateTime), N''F3M'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL)
END')

--condicoes da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Inventário à data''
DELETE FROM [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''Quantidade'', 0, N''Quantidade'', N''0'', N'''', 16, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
END')

--agregadores da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
DECLARE @IDConfiguracao as bigint

SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Inventário à data''
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista

DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasGruposPorDefeito] where IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] where IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] where IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE ID=@IDConfiguracao

INSERT [F3MOGeral].[dbo].[tbConfiguracoesConsultas] ([IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, 1, 1, CAST(N''2018-04-27 17:39:52.217'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:39:52.217'' AS DateTime), N''F3M'')
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista

INSERT [F3MOGeral].[dbo].[tbOpConsultasGruposPorDefeito] ([IDConfiguracoesConsultas], [Coluna], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''CodigoTipoArtigo'', 1, 1, 1, CAST(N''2018-04-27 17:39:52.390'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:39:52.390'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] ([IDConfiguracoesConsultas], [Grupo], [Coluna], [Agregador], [Header], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''CodigoTipoArtigo'', N''Quantidade'', N''sum'', 0, 1, 1, CAST(N''2018-04-27 17:39:52.493'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:39:52.493'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] ([IDConfiguracoesConsultas], [Grupo], [Coluna], [Agregador], [Header], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''CodigoTipoArtigo'', N''TotalMoeda'', N''sum'', 0, 1, 1, CAST(N''2018-04-27 17:39:52.493'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:39:52.493'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''Quantidade'', N''sum'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''TotalMoeda'', N''sum'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
END')


--funcao inventario
EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnInventarioData]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnInventarioData]')

EXEC('CREATE FUNCTION [dbo].[fnInventarioData] (@Data as date, @IDValorizado as int)
RETURNS TABLE
AS
RETURN (
	   select cc.idartigo, CodigoArtigo, DescricaoArtigo, CodigoTipoArtigo, DescricaoTipoArtigo, CodigoMarca, DescricaoMarca,cc.IDArmazem, CodigoArmazem, DescricaoArmazem, 
	   cc.IDArmazemLocalizacao, CodigoArmazemLocalizacao, DescricaoArmazemLocalizacao, CodigoLote, DescricaoLote, UltimaEntrada, UltimaSaida, Quantidade, Medio, UltimoPrecoCompra, CustoPadrao, 
	   (case when @IDValorizado=12 then CustoPadrao when @IDValorizado=13 then Medio when @IDValorizado=14 then UltimoPrecoCompra else Preco end) as Preco, 
	   (case when @IDValorizado=12 then CustoPadrao when @IDValorizado=13 then Medio when @IDValorizado=14 then UltimoPrecoCompra else Preco end)*Quantidade as TotalMoeda,
	   Ativo, Gerestock, Inventariado, 
	   Codigofornecedor, DescricaoFornecedor, 2 as Quantidadenumcasasdecimais, 3 as Preconumcasasdecimais, 3 as TotalMoedanumcasasdecimais  
	   from (select ar.id as idartigo, ar.codigo as CodigoArtigo, ar.Descricao as DescricaoArtigo, ta.codigo as CodigoTipoArtigo, ta.Descricao as DescricaoTipoArtigo, ma.codigo as CodigoMarca, ma.Descricao as DescricaoMarca, 
		isnull(ar.Padrao,0) as CustoPadrao, isnull(ap.valorcomiva,0) as Preco, ar.ativo, ar.gerestock, ar.inventariado, isnull(f.Codigo,'''') as CodigoFornecedor, isnull(f.Nome,'''') as DescricaoFornecedor
		from tbartigos ar 
		LEFT JOIN tbtiposartigos AS ta ON ta.ID = ar.IDtipoartigo
		LEFT JOIN tbMarcas AS ma ON ma.ID = ar.IDmarca
		left join tbartigosprecos ap on ar.id=ap.idartigo and ap.idcodigopreco=@IDValorizado-1 and ap.idloja is null
		left join tbartigosfornecedores af on ar.id=af.idartigo and af.ordem=1
		left join tbfornecedores f on f.id=af.idfornecedor) a

		inner join
		(select idartigo, IDArmazem, IDArmazemLocalizacao,  
		max((Case Natureza when ''E'' then DataDocumento else null end)) as UltimaEntrada, 
		max((Case Natureza when ''S'' then DataDocumento else null end)) as UltimaSaida
		FROM tbCCStockArtigos  
		where DataDocumento<=dateadd(d,1,@Data)
		group by idartigo, IDArmazem, IDArmazemLocalizacao) b on a.idartigo=b.idartigo
		
		left join
		(Select idartigo, UltimoPrecoCompra from (select idartigo, isnull(UPCMoedaRef,0) as UltimoPrecoCompra, ROW_NUMBER() OVER (PARTITION BY IDArtigo Order by DataDocumento desc) as lin 
		from tbCCStockArtigos where datadocumento<dateadd(d,1,@Data)) p where p.lin=1) c on a.idartigo=c.idartigo

		left join
		(Select idartigo, Medio from (select idartigo, isnull(PCMAtualMoedaRef,0) as Medio, ROW_NUMBER() OVER (PARTITION BY IDArtigo Order by DataDocumento desc) as lin 
		from tbCCStockArtigos where datadocumento<=dateadd(d,1,@Data)) p where p.lin=1) d on a.idartigo=d.idartigo

		left join
		(select tbCCStockArtigos.IDArtigo, tbCCStockArtigos.IDArmazem, tbCCStockArtigos.IDArmazemLocalizacao, 
		tbArmazens.Codigo as CodigoArmazem, tbArmazens.Descricao as DescricaoArmazem,
		tbArmazensLocalizacoes.Codigo as CodigoArmazemLocalizacao, tbArmazensLocalizacoes.Descricao as DescricaoArmazemLocalizacao,
		tbArtigosLotes.Codigo as CodigoLote, tbArtigosLotes.Descricao as DescricaoLote,
		isnull(Sum((Case tbCCStockArtigos.Natureza when ''E'' then 1 else -1 end) * tbCCStockArtigos.Quantidade),0) as Quantidade 
		FROM tbCCStockArtigos left join tbArmazens on tbCCStockArtigos.IDArmazem=tbArmazens.id 
		left join tbArmazensLocalizacoes on tbCCStockArtigos.IDArmazemLocalizacao=tbArmazensLocalizacoes.id
		left join tbArtigosLotes on tbCCStockArtigos.IDArtigoLote=tbArtigosLotes.id
		where DataDocumento<=dateadd(d,1,@Data)
		group by tbCCStockArtigos.IDArtigo, tbCCStockArtigos.IDArmazem, tbCCStockArtigos.IDArmazemLocalizacao, tbArmazens.Codigo, tbArmazens.Descricao ,
		tbArmazensLocalizacoes.Codigo , tbArmazensLocalizacoes.Descricao,tbArtigosLotes.Codigo, tbArtigosLotes.Descricao) cc
		on b.idartigo=cc.idartigo and b.IDArmazem=cc.idarmazem and b.IDArmazemLocalizacao=cc.IDArmazemLocalizacao
)')


EXEC('update tbmapasvistas set descricao=''Etiqueta preço venda 1'' where id=26')
EXEC('update tbmapasvistas set descricao=''Etiqueta preço venda 2'' where id=38')
EXEC('update tbmapasvistas set descricao=''Etiqueta sem preços'' where id=40')
EXEC('update tbSistemaTiposIVA set Descricao=''Isenta'' where Descricao=''Isento''')
EXEC('update tbSistemaTiposIVA set Descricao=''Intermédia'' where Descricao=''Intermedia''')
EXEC('update [F3MOGeral].[dbo].tbParametrosListasPersonalizadas set FuncaoJSEnviaParams=''ConsultasParamsIDValorizadoEnviaParams'' where IDListaPersonalizada=90 and ModelPropertyName=''IDValorizado''')

--aviso de nova versão
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.15.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.15.0'', ''A'', ''2019-01-07 00:00'', ''2019-01-14 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.15.0'', ''V'', ''2019-01-14 08:00'', ''2019-01-14 08:00'', ''Funcionalidades da versão'', ''
<li>STOCKS   - COMUNICAÇÃO DO INVENTÁRIO À AT</li>
<li>ANÁLISES - EMISSÃO DE MAPA DE INVENTÁRIO À DATA</li>
<li>ANÁLISES - FILTRO DE CAMPANHA NAS ANÁLISES DE VENDAS</li>
<li>ARTIGOS - CLASSIFICAÇÃO COMO INVENTARIADOS</li>
<li>SERVIÇOS DE ÓPTICA - DIVERSAS MELHORIAS</li>
<li>ETIQUETAS - ETIQUETA DE ROLO SEM PREÇO</li>
<li>MORADA DE CARGA E DESCARGA - SUGESTÃO DE PAÍS</li>
    '', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')