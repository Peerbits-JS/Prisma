/* ACT BD EMPRESA VERSAO 36*/
EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbContabilidadeConfiguracao]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbContabilidadeConfiguracao](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Ano] [nvarchar](10) NOT NULL,
	[CodigoModulo] [nvarchar](50) NOT NULL,
	[DescricaoModulo] [nvarchar](256) NOT NULL,
	[CodigoTipo] [nvarchar](50) NOT NULL,
	[DescricaoTipo] [nvarchar](256) NOT NULL,
	[CodigoAlternativa] [nvarchar](50) NOT NULL,
	[DescricaoAlternativa] [nvarchar](256) NOT NULL,
	[Predefinido] [bit] NULL,
	[Diario] [nvarchar](50) NULL,
	[CodDocumento] [nvarchar](50) NULL,
	[RefleteClasseIVAContaFinanceira] [bit] NULL,
	[RefleteCentroCustoContaFinanceira] [bit] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracao_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracao_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracao_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracao_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbContabilidadeConfiguracao_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbContabilidadeConfiguracao_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbContabilidadeConfiguracao] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END')

EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbContabilidadeConfiguracaoLinhas]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbContabilidadeConfiguracaoLinhas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDConfiguracaoContabilidade] [bigint] NOT NULL,
	[Conta] [nvarchar](256) NULL,
	[IDValor] [bigint] NULL,
	[DescricaoValor] [nvarchar](200) NULL,
	[Natureza] [nvarchar](256) NULL,
	[ClasseIVA] [nvarchar](256) NULL,
	[CentroCusto] [nvarchar](256) NULL,
	[IDTipoDocumento] [bigint] NULL,
	[CodigoTipoDocumento] [nvarchar](50) NULL,
	[DescricaoTipoDocumento] [nvarchar](256) NULL,
	[VariavelContabilidade] [nvarchar](256) NULL,
	[CustoMercadoriaCompras] [bit] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoLinhas_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoLinhas_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoLinhas_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoLinhas_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoLinhas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoLinhas_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbContabilidadeConfiguracaoLinhas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbContabilidadeConfiguracaoLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbContabilidadeConfiguracaoLinhas_tbContabilidadeConfiguracao] FOREIGN KEY([IDConfiguracaoContabilidade])
REFERENCES [dbo].[tbContabilidadeConfiguracao] ([ID])
ALTER TABLE [dbo].[tbContabilidadeConfiguracaoLinhas] CHECK CONSTRAINT [FK_tbContabilidadeConfiguracaoLinhas_tbContabilidadeConfiguracao]
END')


EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbContabilidadeConfiguracaoModulos]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbContabilidadeConfiguracaoModulos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](50) NOT NULL,
	[Descricao] [nvarchar](200) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoModulos_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoModulos_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoModulos_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoModulos_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoModulos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoModulos_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbContabilidadeConfiguracaoModulos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END')


EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbContabilidadeConfiguracaoTipos]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbContabilidadeConfiguracaoTipos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](50) NOT NULL,
	[Descricao] [nvarchar](200) NOT NULL,
	[Tabela] [nvarchar](200) NOT NULL,
	[MostraCustoMercadoriaCompras] [bit] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoTipos_MostraCustoMercadoriaCompras]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoTipos_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoTipos_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoTipos_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoTipos_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoTipos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoTipos_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbContabilidadeConfiguracaoTipos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END')

EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbContabilidadeConfiguracaoValores]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbContabilidadeConfiguracaoValores](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](50) NOT NULL,
	[Descricao] [nvarchar](200) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoValores_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoValores_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoValores_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoValores_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoValores_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbContabilidadeConfiguracaoValores_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbContabilidadeConfiguracaoValores] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END')

 --novos menus contabilidade 
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=135)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (135, 12, N''Contabilidade'', N''012.002.006'', N''Contabilidade'', 6, N''f3icon-calculator'', N''Accao'', 1, 1, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=135 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 135, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')


EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=136)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (136, 135, N''AccountingExport'', N''012.002.007'', N''AccountingExport'', 7, N''f3icon-share-square-o'', N''/Accounting/AccountingExport'', 1, 1, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=136 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 136, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')


EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=137)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (137, 135, N''AccountingConfiguration'', N''012.002.008'', N''AccountingConfiguration'', 8, N''f3icon-cog'', N''/Accounting/AccountingConfiguration'', 1, 1, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=137 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 137, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, 1)
END')


--lista personalizada de configuração contabilidade
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE TabelaPrincipal=''tbContabilidadeConfiguracao'')
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ON
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([ID], [Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query]) 
VALUES (91, N''Configuração da Contabilidade'', 1, 1, 137, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbContabilidadeConfiguracao'', 
N''select D.Ativo, D.ID as ID, D.DataCriacao as CreatedAt, D.UtilizadorCriacao as CreatedBy, D.DataAlteracao as UpdatedAt, Ano as [Year], DescricaoModulo as ModuleDescription, DescricaoTipo as TypeDescription, DescricaoAlternativa as AlternativeDescription from tbContabilidadeConfiguracao D '')
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] OFF
END')



EXEC('
BEGIN
DECLARE @IDLista int
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE TabelaPrincipal=''tbContabilidadeConfiguracao''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE [IDListaPersonalizada]=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [Ordem]) VALUES (N''Year'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbContabilidadeConfiguracao'', 1, 1, 150, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [Ordem]) VALUES (N''ModuleDescription'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbContabilidadeConfiguracao'', 1, 1, 150, 200)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [Ordem]) VALUES (N''TypeDescription'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbContabilidadeConfiguracao'', 1, 1, 150, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [Ordem]) VALUES (N''AlternativeDescription'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbContabilidadeConfiguracao'', 1, 1, 150, 400)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [Ordem]) VALUES (N''CreatedBy'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbContabilidadeConfiguracao'', 0, 1, 150, 500)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [Ordem]) VALUES (N''UpdatedAt'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbContabilidadeConfiguracao'', 0, 1, 200, 600)
END')


EXEC('
BEGIN
DELETE FROM [dbo].[tbContabilidadeConfiguracaoModulos]
SET IDENTITY_INSERT [dbo].[tbContabilidadeConfiguracaoModulos] ON 
INSERT [dbo].[tbContabilidadeConfiguracaoModulos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N''001'', N''Stocks'', 1, 1, CAST(N''2012-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 14:51:38.773'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoModulos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N''002'', N''CaixaBancos'', 1, 1, CAST(N''2012-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 14:51:38.773'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoModulos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N''003'', N''Compras'', 1, 1, CAST(N''2012-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 14:51:38.773'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoModulos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, N''004'', N''Vendas'', 1, 1, CAST(N''2012-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 14:51:38.773'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoModulos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (5, N''006'', N''ContaCorrente'', 1, 1, CAST(N''2012-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 14:51:38.773'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoModulos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (6, N''008'', N''Tabelas'', 1, 1, CAST(N''2012-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 14:51:38.773'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbContabilidadeConfiguracaoModulos] OFF
END')


EXEC('
BEGIN
DELETE FROM [dbo].[tbContabilidadeConfiguracaoTipos]
SET IDENTITY_INSERT [dbo].[tbContabilidadeConfiguracaoTipos] ON
INSERT [dbo].[tbContabilidadeConfiguracaoTipos] ([ID], [Codigo], [Descricao], [Tabela], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao],[MostraCustoMercadoriaCompras]) VALUES (1, N''Artigos'', N''Artigos'', N''tbArtigos'', 1, 1, CAST(N''2017-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:15:19.910'' AS DateTime), N'''',0)
INSERT [dbo].[tbContabilidadeConfiguracaoTipos] ([ID], [Codigo], [Descricao], [Tabela], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao],[MostraCustoMercadoriaCompras]) VALUES (2, N''Armazens'', N''Armazéns'', N''tbArmazens'', 1, 1, CAST(N''2017-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:15:28.220'' AS DateTime), N'''',0)
INSERT [dbo].[tbContabilidadeConfiguracaoTipos] ([ID], [Codigo], [Descricao], [Tabela], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao],[MostraCustoMercadoriaCompras]) VALUES (3, N''Clientes'', N''Clientes'', N''tbClientes'', 1, 1, CAST(N''2017-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:15:31.010'' AS DateTime), N'''',0)
INSERT [dbo].[tbContabilidadeConfiguracaoTipos] ([ID], [Codigo], [Descricao], [Tabela], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao],[MostraCustoMercadoriaCompras]) VALUES (4, N''Entidades'', N''Entidades'', N''tbEntidades'', 1, 1, CAST(N''2017-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:15:32.880'' AS DateTime), N'''',0)
INSERT [dbo].[tbContabilidadeConfiguracaoTipos] ([ID], [Codigo], [Descricao], [Tabela], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao],[MostraCustoMercadoriaCompras]) VALUES (5, N''FormasPagamento'', N''Formas de Pagamento'', N''tbFormasPagamento'', 1, 1, CAST(N''2017-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:15:34.803'' AS DateTime), N'''',0)
INSERT [dbo].[tbContabilidadeConfiguracaoTipos] ([ID], [Codigo], [Descricao], [Tabela], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao],[MostraCustoMercadoriaCompras]) VALUES (6, N''Fornecedores'', N''Fornecedores'', N''tbFornecedores'', 1, 1, CAST(N''2017-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:15:39.117'' AS DateTime), N'''',0)
INSERT [dbo].[tbContabilidadeConfiguracaoTipos] ([ID], [Codigo], [Descricao], [Tabela], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao],[MostraCustoMercadoriaCompras]) VALUES (7, N''Lojas'', N''Lojas'', N''tbLojas'', 1, 1, CAST(N''2017-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:15:41.403'' AS DateTime), N'''',0)
INSERT [dbo].[tbContabilidadeConfiguracaoTipos] ([ID], [Codigo], [Descricao], [Tabela], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao],[MostraCustoMercadoriaCompras]) VALUES (8, N''Paises'', N''Paises'', N''tbPaises'', 1, 1, CAST(N''2017-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:15:41.403'' AS DateTime), N'''',0)
INSERT [dbo].[tbContabilidadeConfiguracaoTipos] ([ID], [Codigo], [Descricao], [Tabela], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao],[MostraCustoMercadoriaCompras]) VALUES (9, N''TaxasIva'', N''Taxas de Iva'', N''tbIva'', 1, 1, CAST(N''2017-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:15:41.403'' AS DateTime), N'''',0)
INSERT [dbo].[tbContabilidadeConfiguracaoTipos] ([ID], [Codigo], [Descricao], [Tabela], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao],[MostraCustoMercadoriaCompras]) VALUES (10, N''TiposArtigo'', N''Tipos de Artigo'', N''tbTiposArtigos'', 1, 1, CAST(N''2017-12-12 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:15:41.403'' AS DateTime), N'''',1)
SET IDENTITY_INSERT [dbo].[tbContabilidadeConfiguracaoTipos] OFF
END')

EXEC('
BEGIN
DELETE FROM [dbo].[tbContabilidadeConfiguracaoValores]
SET IDENTITY_INSERT [dbo].[tbContabilidadeConfiguracaoValores] ON 
INSERT [dbo].[tbContabilidadeConfiguracaoValores] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N''Iva'', N''Iva'', 1, 1, CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoValores] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N''MercadoriaSemIva'', N''Mercadoria sem Iva'', 1, 1, CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoValores] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N''MercadoriaComIva'', N''Mercadoria com Iva'', 1, 1, CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoValores] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, N''CustoMercadoria'', N''Custo mercadoria'', 1, 1, CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoValores] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (5, N''CustoMercadoriaCompras'', N''Custo mercadoria compras'', 1, 1, CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoValores] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (6, N''Desconto'', N''Desconto'', 1, 1, CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoValores] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (7, N''TotalDocumento'', N''Total Documento'', 1, 1, CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoValores] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (8, N''TotalComparticipacao'', N''Total Comparticipação'', 1, 1, CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N'''')
INSERT [dbo].[tbContabilidadeConfiguracaoValores] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (9, N''ValorRecebido'', N''Valor Recebido'', 1, 1, CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N''F3M'', CAST(N''2018-12-17 16:38:46.450'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbContabilidadeConfiguracaoValores] OFF
END')

--correções
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=130 where id=131')
EXEC('update [F3MOGeral].[dbo].tbmenus set Ordem=1150 where id=135')
EXEC('update [F3MOGeral].dbo.tblistaspersonalizadas set descricao=''Documentos de Contagem'' where id=88 and descricao=''DocumentosStockContagem''')
EXEC('update [F3MOGeral].dbo.tbmenus SET descricaoabreviada=''001.004'' where id=130 and descricaoabreviada=''001.003''')
EXEC('update [F3MOGeral].dbo.tbmenus SET descricaoabreviada=''001.004.001'' where id=131 and descricaoabreviada=''001.003.001''')
EXEC('update [F3MOGeral].dbo.tbcolunaslistaspersonalizadas set tipocoluna=3 where Colunavista=''QuantidadeStock'' and tipocoluna=1')
EXEC('update [F3MOGeral].dbo.tbmenus set idmodulo=12 where id in (133,134,135,136,137)')
EXEC('update [F3MOGeral].dbo.tbmenus set idmodulo=6 where id in (117,120)')
EXEC('update tbTiposDocumento set RegistarCosumidorFinal=1 where codigo=''ORC''')
EXEC('update tbSistemaSiglasPaises SET DescricaoPais = ''Desconhecido''  where Descricao = ''Desconhecido''')
EXEC('update tbContabilidadeConfiguracaomodulos set ativo=0 where id in (2,5)')

EXEC('UPDATE [F3MOGeral].dbo.tbmenus set btncontextoadicionar=1, btncontextoalterar=1, btncontextoremover=1, btncontextoimprimir=0, btncontextoexportar=1, btncontextoduplicar=1, btncontextoimportar=0 where id in (135,137)')
EXEC('UPDATE [F3MOGeral].dbo.tbperfisacessos set adicionar=1, alterar=1, remover=1, imprimir=0, exportar=1, duplicar=1, importar=0 where idmenus in (135,137)')
EXEC('UPDATE [F3MOGeral].dbo.tbmenus set btncontextoadicionar=0, btncontextoalterar=0, btncontextoremover=0, btncontextoimprimir=0, btncontextoexportar=0, btncontextoduplicar=0, btncontextoimportar=0 where id in (136)')
EXEC('UPDATE [F3MOGeral].dbo.tbperfisacessos set adicionar=0, alterar=0, remover=0, imprimir=0, exportar=0, duplicar=0, importar=0 where idmenus in (136)')

EXEC('UPDATE [F3MOGeral].[dbo].[tbListasPersonalizadas] SET Query=''select D.Ativo, D.ID as ID, D.DataCriacao as CreatedAt, D.UtilizadorCriacao as CreatedBy, D.DataAlteracao as UpdatedAt, D.DateFilter, D.WareHousesFilterName from tbComunicacaoAutoridadeTributaria D '' where id=89')
EXEC('UPDATE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] set [ColunaVista]=''WareHousesFilterName'' where [ColunaVista] =''WhereHousesFilterName'' ')
EXEC('UPDATE [F3MOGeral].[dbo].[tbListasPersonalizadas] SET Query=''select D.Ativo, D.ID as ID, D.DataCriacao as CreatedAt, D.UtilizadorCriacao as CreatedBy, D.DataAlteracao as UpdatedAt, Ano as [Year], DescricaoModulo as ModuleDescription, DescricaoTipo as TypeDescription, DescricaoAlternativa as AlternativeDescription from tbContabilidadeConfiguracao D '' where id=91')

----aviso de nova versão
--EXEC('
--BEGIN
--DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.16.0''
--insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
--values (''Prisma'', ''1.16.0'', ''A'', ''2019-02-01 00:00'', ''2019-02-01 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
--insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
--values (''Prisma'', ''1.16.0'', ''V'', ''2019-02-01 08:00'', ''2019-02-01 08:00'', ''Funcionalidades da versão'', ''
--<li>CONTABILIDADE - CONFIGURAÇÃO</li>
--'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
--END')