/* ACT BD EMPRESA VERSAO 2 */

/* SISTEMA ENTIDADES MODULOS */
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (1,4,3,1,1,'2016-06-14 00:00:00.000','F3M')
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (2,5,3,1,1,'2016-06-14 00:00:00.000','F3M')
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (3,6,3,1,1,'2016-06-14 00:00:00.000','F3M')
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (4,7,3,1,1,'2016-06-14 00:00:00.000','F3M')
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (5,2,4,1,1,'2016-06-14 00:00:00.000','F3M')
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (6,3,4,1,1,'2016-06-14 00:00:00.000','F3M')
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (7,2,5,1,1,'2016-06-14 00:00:00.000','F3M')
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (8,3,5,1,1,'2016-06-14 00:00:00.000','F3M')
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (9,4,5,1,1,'2016-06-14 00:00:00.000','F3M')
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (10,5,5,1,1,'2016-06-14 00:00:00.000','F3M')
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (11,6,5,1,1,'2016-06-14 00:00:00.000','F3M')
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (12,7,5,1,1,'2016-06-14 00:00:00.000','F3M')

/* ESTRUTURA ARTIS*/
/****** Object:  Table [dbo].[tbArtigos]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](20) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbArtigos_Ativo]  DEFAULT ((1)),
	[IDFamilia] [bigint] NULL,
	[IDSubFamilia] [bigint] NULL,
	[IDTipoArtigo] [bigint] NOT NULL,
	[IDComposicao] [bigint] NULL,
	[IDTipoComposicao] [bigint] NULL,
	[IDGrupoArtigo] [bigint] NULL,
	[IDMarca] [bigint] NOT NULL,
	[CodigoBarras] [nvarchar](50) NULL,
	[QRCode] [nvarchar](50) NULL,
	[Descricao] [nvarchar](200) NOT NULL,
	[DescricaoAbreviada] [nvarchar](20) NULL,
	[Observacoes] [nvarchar](max) NULL,
	[GereLotes] [bit] NULL,
	[GereStock] [bit] NULL,
	[GereNumeroSerie] [bit] NULL,
	[DescricaoVariavel] [bit] NULL,
	[IDTipoDimensao] [bigint] NULL,
	[IDDimensaoPrimeira] [bigint] NULL,
	[IDDimensaoSegunda] [bigint] NULL,
	[IDOrdemLoteApresentar] [bigint] NULL,
	[IDUnidade] [bigint] NOT NULL,
	[IDUnidadeVenda] [bigint] NOT NULL,
	[IDUnidadeCompra] [bigint] NOT NULL,
	[VariavelContabilidade] [nvarchar](20) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbArtigos_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbArtigos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[IDEstacao] [bigint] NULL,
	[NE] [float] NULL,
	[DTEX] [float] NULL,
	[CodigoEstatistico] [nvarchar](25) NULL,
	[LimiteMax] [float] NULL,
	[LimiteMin] [float] NULL,
	[Reposicao] [float] NULL,
	[IDOrdemLoteMovEntrada] [bigint] NULL,
	[IDOrdemLoteMovSaida] [bigint] NULL,
	[IDTaxa] [bigint] NULL,
	[DedutivelPercentagem] [float] NULL,
	[IncidenciaPercentagem] [float] NULL,
	[UltimoPrecoCusto] [float] NULL,
	[Medio] [float] NULL,
	[Padrao] [float] NULL,
	[UltimosCustosAdicionais] [float] NULL,
	[UltimosDescontosComerciais] [float] NULL,
	[UltimoPrecoCompra] [float] NULL,
	[TotalQuantidadeVSUPC] [float] NULL,
	[TotalQuantidadeVSPCM] [float] NULL,
	[TotalQuantidadeVSPCPadrao] [float] NULL,
	[IDTiposComponente] [bigint] NULL,
	[IDCompostoTransformacaoMetodoCusto] [bigint] NULL,
	[IDImpostoSelo] [bigint] NULL,
	[FatorFTOFPercentagem] [float] NULL,
	[Foto] [nvarchar](255) NULL,
	[FotoCaminho] [nvarchar](max) NULL,
	[IDUnidadeStock2] [bigint] NULL,
	[IDTipoPreco] [bigint] NOT NULL DEFAULT ((1)),
	[CodigoAT] [nvarchar](20) NULL,
	[ReferenciaFornecedor] [nvarchar](50) NULL,
	[CodigoBarrasFornecedor] [nvarchar](50) NULL,
	[IDSistemaClassificacao] bigint NOT NULL,
CONSTRAINT [PK_tbArtigos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosAlternativos]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosAlternativos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDArtigoDimensaoLinha1] [bigint] NULL,
	[IDArtigoDimensaoLinha2] [bigint] NULL,
	[IDArtigoAlternativo] [bigint] NOT NULL,
	[IDArtigoDimensaoLinha1Alternativo] [bigint] NULL,
	[IDArtigoDimensaoLinha2Alternativo] [bigint] NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbArtigosAlternativos_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbArtigosAlternativos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbArtigosAlternativos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [bigint] NOT NULL,
 CONSTRAINT [PK_tbArtigosAlternativos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosAnexos]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosAnexos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDTipoAnexo] [bigint] NULL,
	[Descricao] [nvarchar](255) NULL,
	[FicheiroOriginal] [nvarchar](255) NULL,
	[Ficheiro] [nvarchar](255) NOT NULL,
	[FicheiroThumbnail] [nvarchar](300) NULL,
	[Caminho] [nvarchar](max) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbArtigosAnexos_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbArtigosAnexos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbArtigosAnexos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tbArtigosAnexos] UNIQUE NONCLUSTERED 
(
	[IDArtigo] ASC,
	[Ficheiro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosArmazensLocalizacoes]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosArmazensLocalizacoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NULL,
	[IDArmazem] [bigint] NOT NULL,
	[PorDefeito] [bit] NULL,
	[Sistema] [bit] NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [bigint] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[IDArmazemLocalizacao] [bigint] NULL,
 CONSTRAINT [PK_tbArtigosArmazensLocalizacoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosAssociados]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosAssociados](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDArtigoDimensaoLinha1] [bigint] NULL,
	[IDArtigoDimensaoLinha2] [bigint] NULL,
	[IDArtigoAssociado] [bigint] NOT NULL,
	[IDArtigoDimensaoLinha1Associado] [bigint] NULL,
	[IDArtigoDimensaoLinha2Associado] [bigint] NULL,
	[Quantidade] [float] NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbArtigosAssociados_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbArtigosAssociados_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbArtigosAssociados_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [bigint] NOT NULL,
 CONSTRAINT [PK_tbArtigosAssociados] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosComponentes]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosComponentes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDArtigoDimensaoLinha1] [bigint] NULL,
	[IDArtigoDimensaoLinha2] [bigint] NULL,
	[IDArtigoComponente] [bigint] NOT NULL,
	[IDArtigoDimensaoLinha1Componente] [bigint] NULL,
	[IDArtigoDimensaoLinha2Componente] [bigint] NULL,
	[Quantidade] [float] NULL,
	[UltimoPrecoCusto] [float] NULL,
	[PrecoCustoMedio] [float] NULL,
	[PrecoCustoPadrao] [float] NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [bigint] NOT NULL,
	[IDSistemaTiposComponente] [bigint] NULL,
 CONSTRAINT [PK_tbArtigosComponentes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosDadosFinanceiros]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosDadosFinanceiros](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDIva] [bigint] NOT NULL,
	[PercentagemDedutivel] [float] NULL,
	[PercentagemIncidencia] [float] NULL,
	[TextoMotivoIsencaoPersonalizado] [nvarchar](4000) NULL,
	[SujeitoProRata] [bit] NOT NULL,
	[IDArtigoImpostoSelo] [bigint] NULL,
	[UltimoPrecoCusto] [float] NULL,
	[CustoMedio] [float] NULL,
	[PrecoPadrao] [float] NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbArtigosDadosFinanceiros] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosDadosFinanceirosPVsUPCPerc]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosDadosFinanceirosPVsUPCPerc](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[PV1] [float] NULL,
	[PV2] [float] NULL,
	[PV3] [float] NULL,
	[PV4] [float] NULL,
	[PV5] [float] NULL,
	[PV6] [float] NULL,
	[PV7] [float] NULL,
	[PV8] [float] NULL,
	[PV9] [float] NULL,
	[PV10] [float] NULL,
	[PV1IVA] [float] NULL,
	[PV2IVA] [float] NULL,
	[PV3IVA] [float] NULL,
	[PV4IVA] [float] NULL,
	[PV5IVA] [float] NULL,
	[PV6IVA] [float] NULL,
	[PV7IVA] [float] NULL,
	[PV8IVA] [float] NULL,
	[PV9IVA] [float] NULL,
	[PV10IVA] [float] NULL,
	[PercUPC1] [float] NULL,
	[PercUPC2] [float] NULL,
	[PercUPC3] [float] NULL,
	[PercUPC4] [float] NULL,
	[PercUPC5] [float] NULL,
	[PercUPC6] [float] NULL,
	[PercUPC7] [float] NULL,
	[PercUPC8] [float] NULL,
	[PercUPC9] [float] NULL,
	[PercUPC10] [float] NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbArtigosDadosFinanceirosPVsUPCPerc] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosDimensoes]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosDimensoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDDimensaoLinha1] [bigint] NULL,
	[IDDimensaoLinha2] [bigint] NULL,
	[CodigoBarras] [nvarchar](16) NULL,
	[StkMin] [float] NULL,
	[StkMax] [float] NULL,
	[QtdPendenteCompras] [float] NULL,
	[UPC] [float] NULL,
	[UltimoCustoAdicional] [float] NULL,
	[CustoMedio] [float] NULL,
	[PV1] [float] NULL,
	[PV2] [float] NULL,
	[PV3] [float] NULL,
	[PV4] [float] NULL,
	[QtdStockEnc] [float] NULL,
	[PVP] [float] NULL,
	[TextoExtra] [nvarchar](10) NULL,
	[PV5] [float] NULL,
	[PV6] [float] NULL,
	[PV7] [float] NULL,
	[PV8] [float] NULL,
	[PV9] [float] NULL,
	[PV10] [float] NULL,
	[CodEstatistico] [nvarchar](25) NULL,
	[TextoExtra2] [nvarchar](10) NULL,
	[TextoExtra3] [nvarchar](10) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbArtigosDimensoes_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbArtigosDimensoes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbArtigosDimensoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[StkArtigo] [float] NULL,
	[StkArmazem] [float] NULL,
	[StkEncomenda] [float] NULL,
	[Activo] [bit] NULL,
	[CustoPadrao] [float] NULL,
	[IDTipoDocumentoUPC] [bigint] NULL,
	[IDDocumentoUPC] [bigint] NULL,
	[DataControloUPC] [datetime] NULL,
	[RecalculaUPC] [bit] NULL,
	[StkArtigo2] [float] NULL,
	[UltPrecoComp] [float] NULL,
 CONSTRAINT [PK_tbArtigosDimensoes] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosDimensoesEmpresa]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosDimensoesEmpresa](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigosDimensoes] [bigint] NOT NULL,
 CONSTRAINT [PK_tbArtigosDimensoesEmpresa] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tbArtigosDimensoesEmpresa] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosEspecificos]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosEspecificos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDEstacao] [bigint] NULL,
	[NE] [float] NULL,
	[DTEX] [float] NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbArtigosEspecificos_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbArtigosEspecificos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbArtigosEspecificos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbArtigosEspecificos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosIdiomas]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosIdiomas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDIdioma] [bigint] NOT NULL,
	[Descricao] [nvarchar](100) NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbArtigosIdiomas_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbArtigosIdiomas_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbArtigosIdiomas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[DescricaoAbreviada] [nvarchar](20) NULL,
 CONSTRAINT [PK_tbArtigosIdiomas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosImpostoSelo]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosImpostoSelo](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Percentagem] [float] NULL,
	[Valor] [float] NULL,
	[LimiteMinimo] [float] NULL,
	[LimiteMaximo] [float] NULL,
 CONSTRAINT [PK_tbArtigosImpostoSelo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosLotes]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosLotes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[Codigo] [nvarchar](50) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[DataFabrico] [datetime] NULL,
	[DataValidade] [datetime] NULL,
	[Sistema] [bit] NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [bigint] NOT NULL,
 CONSTRAINT [PK_tbArtigosLotes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosNumerosSeries]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosNumerosSeries](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[NumeroSerie] [nvarchar](20) NOT NULL,
	[Descricao] [nvarchar](100) NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbArtigosNumerosSeries] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosPrecos]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosPrecos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDCodigoPreco] [bigint] NOT NULL,
	[ValorComIva] [float] NULL,
	[ValorSemIva] [float] NULL,
	[UPCPercentagem] [float] NULL,
	[IDUnidade] [bigint] NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](255) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](255) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [bigint] NOT NULL,
 CONSTRAINT [PK_tbArtigosPrecos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosStock]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosStock](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[PrimeiraEntrada] [datetime] NULL,
	[UltimaEntrada] [datetime] NULL,
	[PrimeiraSaida] [datetime] NULL,
	[UltimaSaida] [datetime] NULL,
	[Atual] [bigint] NULL,
	[Reservado] [bigint] NULL,
	[Sistema] [bit] NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbArtigosStock] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbArtigosUnidades]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbArtigosUnidades](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDUnidade] [bigint] NOT NULL,
	[IDUnidadeConversao] [bigint] NOT NULL,
	[FatorConversao] [float] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbArtigosUnidades_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbArtigosUnidades_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbArtigosUnidades_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [int] NOT NULL,
 CONSTRAINT [PK_tbArtigosUnidades] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbComposicoes]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbComposicoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbComposicoes_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbComposicoes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbComposicoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbComposicoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbComposicoesIdiomas]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbComposicoesIdiomas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDComposicao] [bigint] NOT NULL,
	[IDIdioma] [bigint] NOT NULL,
	[Descricao] [nvarchar](100) NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbComposicoesIdiomas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbDimensoes]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbDimensoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](20) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbDimensoes_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbDimensoes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbDimensoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbDimensoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbDimensoesLinhas]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbDimensoesLinhas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDDimensao] [bigint] NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbDimensoesLinhas_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbDimensoesLinhas_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbDimensoesLinhas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Virtual] [bit] NOT NULL,
 CONSTRAINT [PK_tbDimensoesLinhas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbEstacoes]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbEstacoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbEstacoes_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbEstacoes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbEstacoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbEstacoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbFamilias]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbFamilias](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[VariavelContabilidade] [nvarchar](20) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbFamilias_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbFamilias_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbFamilias_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbFamilias] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbGruposArtigo]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbGruposArtigo](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[VariavelContabilidade] [nvarchar](20) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbGrupos_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbGrupos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbGrupos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbGrupos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbImpostoSelo]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbImpostoSelo](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[IDVerbaIS] [bigint] NOT NULL,
	[Percentagem] [float] NULL,
	[Valor] [float] NULL,
	[LimiteMinimo] [float] NULL,
	[LimiteMaximo] [float] NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbImpostoSelo_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbImpostoSelo_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbImpostoSelo_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbImpostoSelo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbIVA]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbIVA](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Taxa] [decimal](12, 9) NOT NULL,
	[IDTipoIva] [bigint] NOT NULL,
	[IDCodigoIva] [bigint] NULL,
	[Mencao] [nvarchar](255) NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](255) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](255) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbIVA] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbIVARegioes]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbIVARegioes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDIva] [bigint] NOT NULL,
	[IDRegiao] [bigint] NOT NULL,
	[IDIvaRegiao] [bigint] NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](255) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](255) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbIVARegioes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSubFamilias]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSubFamilias](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDFamilia] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[VariavelContabilidade] [nvarchar](20) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSubFamilias_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSubFamilias_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSubFamilias_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSubFamilias] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbUnidades]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbUnidades](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[NumeroDeCasasDecimais] [smallint] NOT NULL DEFAULT ((0)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbUnidades_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbUnidades_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbUnidades_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[PorDefeito] [bit] NULL,
 CONSTRAINT [PK_tbUnidades] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbUnidadesRelacoes]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbUnidadesRelacoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDUnidade] [bigint] NOT NULL,
	[IDUnidadeConversao] [bigint] NOT NULL,
	[FatorConversao] [float] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbUnidadesRelacoes_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbUnidadesRelacoes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbUnidadesRelacoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbUnidadesRelacoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbUnidadesTempo]    Script Date: 16-06-2016 19:01:13 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbUnidadesTempo](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbUnidadesTempo_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbUnidadesTempo_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbUnidadesTempo_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[FatorConversaoSeg] [float] NOT NULL,
	[IDFormato] [bigint] NOT NULL,
 CONSTRAINT [PK_tbUnidadesTempo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Index [IX_tbArtigosAtivo]    Script Date: 16-06-2016 19:01:13 ******/
CREATE NONCLUSTERED INDEX [IX_tbArtigosAtivo] ON [dbo].[tbArtigos]
(
	[Ativo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbArtigosCodigo]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbArtigosCodigo] ON [dbo].[tbArtigos]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbArtigosCodigoBarras]    Script Date: 16-06-2016 19:01:13 ******/
CREATE NONCLUSTERED INDEX [IX_tbArtigosCodigoBarras] ON [dbo].[tbArtigos]
(
	[CodigoBarras] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbArtigosCodigoDescricao]    Script Date: 16-06-2016 19:01:13 ******/
CREATE NONCLUSTERED INDEX [IX_tbArtigosCodigoDescricao] ON [dbo].[tbArtigos]
(
	[Codigo] ASC,
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbArtigosDescricao]    Script Date: 16-06-2016 19:01:13 ******/
CREATE NONCLUSTERED INDEX [IX_tbArtigosDescricao] ON [dbo].[tbArtigos]
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbArtigosTipoDimensao]    Script Date: 16-06-2016 19:01:13 ******/
CREATE NONCLUSTERED INDEX [IX_tbArtigosTipoDimensao] ON [dbo].[tbArtigos]
(
	[IDTipoDimensao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbArtigosAlternativos]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbArtigosAlternativos] ON [dbo].[tbArtigosAlternativos]
(
	[IDArtigo] ASC,
	[IDArtigoAlternativo] ASC,
	[IDArtigoDimensaoLinha1] ASC,
	[IDArtigoDimensaoLinha2] ASC,
	[IDArtigoDimensaoLinha1Alternativo] ASC,
	[IDArtigoDimensaoLinha2Alternativo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbArtigosDadosFinanceiros]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbArtigosDadosFinanceiros] ON [dbo].[tbArtigosDadosFinanceiros]
(
	[IDArtigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbArtigosDadosFinanceirosPVsUPCPerc]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbArtigosDadosFinanceirosPVsUPCPerc] ON [dbo].[tbArtigosDadosFinanceirosPVsUPCPerc]
(
	[IDArtigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbArtigosDimensoes]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbArtigosDimensoes] ON [dbo].[tbArtigosDimensoes]
(
	[IDArtigo] ASC,
	[IDDimensaoLinha1] ASC,
	[IDDimensaoLinha2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbArtigosIdiomas]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbArtigosIdiomas] ON [dbo].[tbArtigosIdiomas]
(
	[IDArtigo] ASC,
	[IDIdioma] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbArtigosLotes]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbArtigosLotes] ON [dbo].[tbArtigosLotes]
(
	[IDArtigo] ASC,
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbArtigosNumerosSeries_IDArtigo_NumeroSerie]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbArtigosNumerosSeries_IDArtigo_NumeroSerie] ON [dbo].[tbArtigosNumerosSeries]
(
	[IDArtigo] ASC,
	[NumeroSerie] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbArtigosPrecos]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbArtigosPrecos] ON [dbo].[tbArtigosPrecos]
(
	[IDCodigoPreco] ASC,
	[IDUnidade] ASC,
	[IDArtigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbArtigosUnidades]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbArtigosUnidades] ON [dbo].[tbArtigosUnidades]
(
	[IDUnidade] ASC,
	[IDUnidadeConversao] ASC,
	[IDArtigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbComposicoesAtivo]    Script Date: 16-06-2016 19:01:13 ******/
CREATE NONCLUSTERED INDEX [IX_tbComposicoesAtivo] ON [dbo].[tbComposicoes]
(
	[Ativo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbComposicoesCodigo]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbComposicoesCodigo] ON [dbo].[tbComposicoes]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbDimensoes]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbDimensoes] ON [dbo].[tbDimensoes]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbDimensoesLinhas]    Script Date: 16-06-2016 19:01:13 ******/
CREATE NONCLUSTERED INDEX [IX_tbDimensoesLinhas] ON [dbo].[tbDimensoesLinhas]
(
	[Ordem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbDimensoesLinhas_IDD_Descricao]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbDimensoesLinhas_IDD_Descricao] ON [dbo].[tbDimensoesLinhas]
(
	[Descricao] ASC,
	[IDDimensao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbDimensoesLinhas_IDD_Ordem]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbDimensoesLinhas_IDD_Ordem] ON [dbo].[tbDimensoesLinhas]
(
	[IDDimensao] ASC,
	[Ordem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbEstacoes]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbEstacoes] ON [dbo].[tbEstacoes]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbFamiliasAtivo]    Script Date: 16-06-2016 19:01:13 ******/
CREATE NONCLUSTERED INDEX [IX_tbFamiliasAtivo] ON [dbo].[tbFamilias]
(
	[Ativo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbFamiliasCodigo]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbFamiliasCodigo] ON [dbo].[tbFamilias]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbGruposCodigo]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbGruposCodigo] ON [dbo].[tbGruposArtigo]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbImpostoSeloCodigo]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbImpostoSeloCodigo] ON [dbo].[tbImpostoSelo]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbIVA]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbIVA] ON [dbo].[tbIVA]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbIVA_1]    Script Date: 16-06-2016 19:01:13 ******/
CREATE NONCLUSTERED INDEX [IX_tbIVA_1] ON [dbo].[tbIVA]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbSubFamiliasChaveComposta]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbSubFamiliasChaveComposta] ON [dbo].[tbSubFamilias]
(
	[IDFamilia] ASC,
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbSubFamiliasCodigo]    Script Date: 16-06-2016 19:01:13 ******/
CREATE NONCLUSTERED INDEX [IX_tbSubFamiliasCodigo] ON [dbo].[tbSubFamilias]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbUnidadesCodigo]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbUnidadesCodigo] ON [dbo].[tbUnidades]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_tbUnidadesRelacoes]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbUnidadesRelacoes] ON [dbo].[tbUnidadesRelacoes]
(
	[IDUnidade] ASC,
	[IDUnidadeConversao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbUnidadesTempo]    Script Date: 16-06-2016 19:01:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbUnidadesTempo] ON [dbo].[tbUnidadesTempo]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE [dbo].[tbArtigosDadosFinanceiros] ADD  CONSTRAINT [DF_tbArtigosFinanceira_SujeitoProRata]  DEFAULT ((0)) FOR [SujeitoProRata]

ALTER TABLE [dbo].[tbArtigosDadosFinanceiros] ADD  CONSTRAINT [DF_Table_1_ImpostoSelo]  DEFAULT ((0)) FOR [IDArtigoImpostoSelo]

ALTER TABLE [dbo].[tbArtigosDadosFinanceiros] ADD  CONSTRAINT [DF_tbArtigosDadosFinanceiros_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbArtigosDadosFinanceiros] ADD  CONSTRAINT [DF_tbArtigosDadosFinanceiros_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbArtigosDadosFinanceiros] ADD  CONSTRAINT [DF_tbArtigosDadosFinanceiros_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbArtigosDadosFinanceirosPVsUPCPerc] ADD  CONSTRAINT [DF_tbArtigosDadosFinanceirosPVsUPCPerc_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbArtigosDadosFinanceirosPVsUPCPerc] ADD  CONSTRAINT [DF_tbArtigosDadosFinanceirosPVsUPCPerc_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbArtigosDadosFinanceirosPVsUPCPerc] ADD  CONSTRAINT [DF_tbArtigosDadosFinanceirosPVsUPCPerc_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbArtigosNumerosSeries] ADD  CONSTRAINT [DF_tbArtigosNumerosSeries_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbArtigosNumerosSeries] ADD  CONSTRAINT [DF_tbArtigosNumerosSeries_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbArtigosNumerosSeries] ADD  CONSTRAINT [DF_tbArtigosNumerosSeries_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbArtigosNumerosSeries] ADD  CONSTRAINT [DF_tbArtigosNumerosSeries_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]

ALTER TABLE [dbo].[tbArtigosNumerosSeries] ADD  CONSTRAINT [DF_tbArtigosNumerosSeries_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbArtigosNumerosSeries] ADD  CONSTRAINT [DF_tbArtigosNumerosSeries_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbComposicoesIdiomas] ADD  CONSTRAINT [DF_tbComposicoesIdiomas_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbComposicoesIdiomas] ADD  CONSTRAINT [DF_tbComposicoesIdiomas_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbComposicoesIdiomas] ADD  CONSTRAINT [DF_tbComposicoesIdiomas_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbComposicoes] FOREIGN KEY([IDComposicao])
REFERENCES [dbo].[tbComposicoes] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbComposicoes]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbDimensoes] FOREIGN KEY([IDDimensaoPrimeira])
REFERENCES [dbo].[tbDimensoes] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbDimensoes]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbDimensoes1] FOREIGN KEY([IDDimensaoSegunda])
REFERENCES [dbo].[tbDimensoes] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbDimensoes1]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbEstacoes] FOREIGN KEY([IDEstacao])
REFERENCES [dbo].[tbEstacoes] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbEstacoes]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbFamilias] FOREIGN KEY([IDFamilia])
REFERENCES [dbo].[tbFamilias] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbFamilias]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbGruposArtigo] FOREIGN KEY([IDGrupoArtigo])
REFERENCES [dbo].[tbGruposArtigo] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbGruposArtigo]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbImpostoSelo] FOREIGN KEY([IDImpostoSelo])
REFERENCES [dbo].[tbImpostoSelo] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbImpostoSelo]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbIVA] FOREIGN KEY([IDTaxa])
REFERENCES [dbo].[tbIVA] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbIVA]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbMarcas] FOREIGN KEY([IDMarca])
REFERENCES [dbo].[tbMarcas] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbMarcas]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbSistemaCompostoTransformacaoMetodoCusto] FOREIGN KEY([IDCompostoTransformacaoMetodoCusto])
REFERENCES [dbo].[tbSistemaCompostoTransformacaoMetodoCusto] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbSistemaCompostoTransformacaoMetodoCusto]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbSistemaOrdemLotes] FOREIGN KEY([IDOrdemLoteApresentar])
REFERENCES [dbo].[tbSistemaOrdemLotes] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbSistemaOrdemLotes]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbSistemaOrdemLotes1] FOREIGN KEY([IDOrdemLoteMovEntrada])
REFERENCES [dbo].[tbSistemaOrdemLotes] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbSistemaOrdemLotes1]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbSistemaOrdemLotes2] FOREIGN KEY([IDOrdemLoteMovSaida])
REFERENCES [dbo].[tbSistemaOrdemLotes] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbSistemaOrdemLotes2]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbSistemaTiposComponente] FOREIGN KEY([IDTiposComponente])
REFERENCES [dbo].[tbSistemaTiposComponente] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbSistemaTiposComponente]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbSistemaTiposComposicoes] FOREIGN KEY([IDTipoComposicao])
REFERENCES [dbo].[tbSistemaTiposComposicoes] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbSistemaTiposComposicoes]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbSistemaTiposDimensoes] FOREIGN KEY([IDTipoDimensao])
REFERENCES [dbo].[tbSistemaTiposDimensoes] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbSistemaTiposDimensoes]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbSubFamilias] FOREIGN KEY([IDSubFamilia])
REFERENCES [dbo].[tbSubFamilias] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbSubFamilias]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbTiposArtigos] FOREIGN KEY([IDTipoArtigo])
REFERENCES [dbo].[tbTiposArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbTiposArtigos]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbUnidades] FOREIGN KEY([IDUnidade])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbUnidades]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbUnidades_Compra] FOREIGN KEY([IDUnidadeCompra])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbUnidades_Compra]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbUnidades_Venda] FOREIGN KEY([IDUnidadeVenda])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbUnidades_Venda]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbSistemaClassificacoesTiposArtigos] FOREIGN KEY([IDSistemaClassificacao])
REFERENCES [dbo].[tbSistemaClassificacoesTiposArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbSistemaClassificacoesTiposArtigos]

ALTER TABLE [dbo].[tbArtigosAlternativos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAlternativos_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosAlternativos] CHECK CONSTRAINT [FK_tbArtigosAlternativos_tbArtigos]

ALTER TABLE [dbo].[tbArtigosAlternativos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAlternativos_tbArtigos_Alternativo] FOREIGN KEY([IDArtigoAlternativo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosAlternativos] CHECK CONSTRAINT [FK_tbArtigosAlternativos_tbArtigos_Alternativo]

ALTER TABLE [dbo].[tbArtigosAlternativos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAlternativos_tbDimensoesLinhas] FOREIGN KEY([IDArtigoDimensaoLinha1])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosAlternativos] CHECK CONSTRAINT [FK_tbArtigosAlternativos_tbDimensoesLinhas]

ALTER TABLE [dbo].[tbArtigosAlternativos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAlternativos_tbDimensoesLinhas1] FOREIGN KEY([IDArtigoDimensaoLinha1Alternativo])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosAlternativos] CHECK CONSTRAINT [FK_tbArtigosAlternativos_tbDimensoesLinhas1]

ALTER TABLE [dbo].[tbArtigosAlternativos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAlternativos_tbDimensoesLinhas2] FOREIGN KEY([IDArtigoDimensaoLinha2])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosAlternativos] CHECK CONSTRAINT [FK_tbArtigosAlternativos_tbDimensoesLinhas2]

ALTER TABLE [dbo].[tbArtigosAlternativos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAlternativos_tbDimensoesLinhas3] FOREIGN KEY([IDArtigoDimensaoLinha2Alternativo])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosAlternativos] CHECK CONSTRAINT [FK_tbArtigosAlternativos_tbDimensoesLinhas3]

ALTER TABLE [dbo].[tbArtigosAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAnexos_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosAnexos] CHECK CONSTRAINT [FK_tbArtigosAnexos_tbArtigos]

ALTER TABLE [dbo].[tbArtigosAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAnexos_tbSistemaTiposAnexos] FOREIGN KEY([IDTipoAnexo])
REFERENCES [dbo].[tbSistemaTiposAnexos] ([ID])

ALTER TABLE [dbo].[tbArtigosAnexos] CHECK CONSTRAINT [FK_tbArtigosAnexos_tbSistemaTiposAnexos]

ALTER TABLE [dbo].[tbArtigosArmazensLocalizacoes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosArmazensLocalizacoes_tbArmazens] FOREIGN KEY([IDArmazem])
REFERENCES [dbo].[tbArmazens] ([ID])

ALTER TABLE [dbo].[tbArtigosArmazensLocalizacoes] CHECK CONSTRAINT [FK_tbArtigosArmazensLocalizacoes_tbArmazens]

ALTER TABLE [dbo].[tbArtigosArmazensLocalizacoes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosArmazensLocalizacoes_tbArmazensLocalizacoes] FOREIGN KEY([IDArmazemLocalizacao])
REFERENCES [dbo].[tbArmazensLocalizacoes] ([ID])

ALTER TABLE [dbo].[tbArtigosArmazensLocalizacoes] CHECK CONSTRAINT [FK_tbArtigosArmazensLocalizacoes_tbArmazensLocalizacoes]

ALTER TABLE [dbo].[tbArtigosArmazensLocalizacoes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosArmazensLocalizacoes_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosArmazensLocalizacoes] CHECK CONSTRAINT [FK_tbArtigosArmazensLocalizacoes_tbArtigos]

ALTER TABLE [dbo].[tbArtigosAssociados]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAssociados_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosAssociados] CHECK CONSTRAINT [FK_tbArtigosAssociados_tbArtigos]

ALTER TABLE [dbo].[tbArtigosAssociados]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAssociados_tbArtigos_Associado] FOREIGN KEY([IDArtigoAssociado])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosAssociados] CHECK CONSTRAINT [FK_tbArtigosAssociados_tbArtigos_Associado]

ALTER TABLE [dbo].[tbArtigosAssociados]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAssociados_tbDimensoesLinhas] FOREIGN KEY([IDArtigoDimensaoLinha1])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosAssociados] CHECK CONSTRAINT [FK_tbArtigosAssociados_tbDimensoesLinhas]

ALTER TABLE [dbo].[tbArtigosAssociados]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAssociados_tbDimensoesLinhas1] FOREIGN KEY([IDArtigoDimensaoLinha1Associado])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosAssociados] CHECK CONSTRAINT [FK_tbArtigosAssociados_tbDimensoesLinhas1]

ALTER TABLE [dbo].[tbArtigosAssociados]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAssociados_tbDimensoesLinhas2] FOREIGN KEY([IDArtigoDimensaoLinha2])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosAssociados] CHECK CONSTRAINT [FK_tbArtigosAssociados_tbDimensoesLinhas2]

ALTER TABLE [dbo].[tbArtigosAssociados]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosAssociados_tbDimensoesLinhas3] FOREIGN KEY([IDArtigoDimensaoLinha2Associado])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosAssociados] CHECK CONSTRAINT [FK_tbArtigosAssociados_tbDimensoesLinhas3]

ALTER TABLE [dbo].[tbArtigosComponentes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosComponentes_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosComponentes] CHECK CONSTRAINT [FK_tbArtigosComponentes_tbArtigos]

ALTER TABLE [dbo].[tbArtigosComponentes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosComponentes_tbArtigos1] FOREIGN KEY([IDArtigoComponente])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosComponentes] CHECK CONSTRAINT [FK_tbArtigosComponentes_tbArtigos1]

ALTER TABLE [dbo].[tbArtigosComponentes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosComponentes_tbDimensoesLinhas] FOREIGN KEY([IDArtigoDimensaoLinha1])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosComponentes] CHECK CONSTRAINT [FK_tbArtigosComponentes_tbDimensoesLinhas]

ALTER TABLE [dbo].[tbArtigosComponentes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosComponentes_tbDimensoesLinhas1] FOREIGN KEY([IDArtigoDimensaoLinha1Componente])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosComponentes] CHECK CONSTRAINT [FK_tbArtigosComponentes_tbDimensoesLinhas1]

ALTER TABLE [dbo].[tbArtigosComponentes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosComponentes_tbDimensoesLinhas2] FOREIGN KEY([IDArtigoDimensaoLinha2])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosComponentes] CHECK CONSTRAINT [FK_tbArtigosComponentes_tbDimensoesLinhas2]

ALTER TABLE [dbo].[tbArtigosComponentes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosComponentes_tbDimensoesLinhas3] FOREIGN KEY([IDArtigoDimensaoLinha2Componente])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosComponentes] CHECK CONSTRAINT [FK_tbArtigosComponentes_tbDimensoesLinhas3]

ALTER TABLE [dbo].[tbArtigosComponentes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosComponentes_tbSistemaTiposComponente] FOREIGN KEY([IDSistemaTiposComponente])
REFERENCES [dbo].[tbSistemaTiposComponente] ([ID])

ALTER TABLE [dbo].[tbArtigosComponentes] CHECK CONSTRAINT [FK_tbArtigosComponentes_tbSistemaTiposComponente]

ALTER TABLE [dbo].[tbArtigosDadosFinanceiros]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosDadosFinanceiros_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosDadosFinanceiros] CHECK CONSTRAINT [FK_tbArtigosDadosFinanceiros_tbArtigos]

ALTER TABLE [dbo].[tbArtigosDadosFinanceirosPVsUPCPerc]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosDadosFinanceirosPVsUPCPerc_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosDadosFinanceirosPVsUPCPerc] CHECK CONSTRAINT [FK_tbArtigosDadosFinanceirosPVsUPCPerc_tbArtigos]

ALTER TABLE [dbo].[tbArtigosDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosDimensoes_IDTipoDocumento] FOREIGN KEY([IDTipoDocumentoUPC])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbArtigosDimensoes] CHECK CONSTRAINT [FK_tbArtigosDimensoes_IDTipoDocumento]

ALTER TABLE [dbo].[tbArtigosDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosDimensoes_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosDimensoes] CHECK CONSTRAINT [FK_tbArtigosDimensoes_tbArtigos]

ALTER TABLE [dbo].[tbArtigosDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosDimensoes_tbDimensoesLinhas_1] FOREIGN KEY([IDDimensaoLinha1])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosDimensoes] CHECK CONSTRAINT [FK_tbArtigosDimensoes_tbDimensoesLinhas_1]

ALTER TABLE [dbo].[tbArtigosDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosDimensoes_tbDimensoesLinhas_2] FOREIGN KEY([IDDimensaoLinha2])
REFERENCES [dbo].[tbDimensoesLinhas] ([ID])

ALTER TABLE [dbo].[tbArtigosDimensoes] CHECK CONSTRAINT [FK_tbArtigosDimensoes_tbDimensoesLinhas_2]

ALTER TABLE [dbo].[tbArtigosDimensoesEmpresa]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosDimensoesEmpresa_tbArtigosDimensoes] FOREIGN KEY([IDArtigosDimensoes])
REFERENCES [dbo].[tbArtigosDimensoes] ([ID])

ALTER TABLE [dbo].[tbArtigosDimensoesEmpresa] CHECK CONSTRAINT [FK_tbArtigosDimensoesEmpresa_tbArtigosDimensoes]

ALTER TABLE [dbo].[tbArtigosEspecificos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosEspecificos_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosEspecificos] CHECK CONSTRAINT [FK_tbArtigosEspecificos_tbArtigos]

ALTER TABLE [dbo].[tbArtigosEspecificos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosEspecificos_tbEstacoes] FOREIGN KEY([IDEstacao])
REFERENCES [dbo].[tbEstacoes] ([ID])

ALTER TABLE [dbo].[tbArtigosEspecificos] CHECK CONSTRAINT [FK_tbArtigosEspecificos_tbEstacoes]

ALTER TABLE [dbo].[tbArtigosIdiomas]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosIdiomas_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosIdiomas] CHECK CONSTRAINT [FK_tbArtigosIdiomas_tbArtigos]

ALTER TABLE [dbo].[tbArtigosIdiomas]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosIdiomas_tbIdiomas] FOREIGN KEY([IDIdioma])
REFERENCES [dbo].[tbIdiomas] ([ID])

ALTER TABLE [dbo].[tbArtigosIdiomas] CHECK CONSTRAINT [FK_tbArtigosIdiomas_tbIdiomas]

ALTER TABLE [dbo].[tbArtigosLotes]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosLotes_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosLotes] CHECK CONSTRAINT [FK_tbArtigosLotes_tbArtigos]

ALTER TABLE [dbo].[tbArtigosNumerosSeries]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosNumerosSeries_IDArtigo] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosNumerosSeries] CHECK CONSTRAINT [FK_tbArtigosNumerosSeries_IDArtigo]

ALTER TABLE [dbo].[tbArtigosPrecos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosPrecos_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosPrecos] CHECK CONSTRAINT [FK_tbArtigosPrecos_tbArtigos]

ALTER TABLE [dbo].[tbArtigosPrecos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosPrecos_tbArtigosPrecos] FOREIGN KEY([ID])
REFERENCES [dbo].[tbArtigosPrecos] ([ID])

ALTER TABLE [dbo].[tbArtigosPrecos] CHECK CONSTRAINT [FK_tbArtigosPrecos_tbArtigosPrecos]

ALTER TABLE [dbo].[tbArtigosPrecos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosPrecos_tbSistemaCodigosPrecos] FOREIGN KEY([IDCodigoPreco])
REFERENCES [dbo].[tbSistemaCodigosPrecos] ([ID])

ALTER TABLE [dbo].[tbArtigosPrecos] CHECK CONSTRAINT [FK_tbArtigosPrecos_tbSistemaCodigosPrecos]

ALTER TABLE [dbo].[tbArtigosPrecos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosPrecos_tbUnidades] FOREIGN KEY([IDUnidade])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbArtigosPrecos] CHECK CONSTRAINT [FK_tbArtigosPrecos_tbUnidades]

ALTER TABLE [dbo].[tbArtigosUnidades]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosUnidades_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosUnidades] CHECK CONSTRAINT [FK_tbArtigosUnidades_tbArtigos]

ALTER TABLE [dbo].[tbArtigosUnidades]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosUnidades_tbUnidades] FOREIGN KEY([IDUnidade])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbArtigosUnidades] CHECK CONSTRAINT [FK_tbArtigosUnidades_tbUnidades]

ALTER TABLE [dbo].[tbArtigosUnidades]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosUnidades_tbUnidades_Conversao] FOREIGN KEY([IDUnidadeConversao])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbArtigosUnidades] CHECK CONSTRAINT [FK_tbArtigosUnidades_tbUnidades_Conversao]

ALTER TABLE [dbo].[tbArtigosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosStock_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosStock] CHECK CONSTRAINT [FK_tbArtigosStock_tbArtigos]

ALTER TABLE [dbo].[tbComposicoesIdiomas]  WITH CHECK ADD  CONSTRAINT [FK_tbComposicoesIdiomas_tbComposicoes] FOREIGN KEY([IDComposicao])
REFERENCES [dbo].[tbComposicoes] ([ID])

ALTER TABLE [dbo].[tbComposicoesIdiomas] CHECK CONSTRAINT [FK_tbComposicoesIdiomas_tbComposicoes]

ALTER TABLE [dbo].[tbComposicoesIdiomas]  WITH CHECK ADD  CONSTRAINT [FK_tbComposicoesIdiomas_tbIdiomas] FOREIGN KEY([IDIdioma])
REFERENCES [dbo].[tbIdiomas] ([ID])

ALTER TABLE [dbo].[tbComposicoesIdiomas] CHECK CONSTRAINT [FK_tbComposicoesIdiomas_tbIdiomas]

ALTER TABLE [dbo].[tbDimensoesLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDimensoesLinhas_tbDimensoes] FOREIGN KEY([IDDimensao])
REFERENCES [dbo].[tbDimensoes] ([ID])

ALTER TABLE [dbo].[tbDimensoesLinhas] CHECK CONSTRAINT [FK_tbDimensoesLinhas_tbDimensoes]

ALTER TABLE [dbo].[tbImpostoSelo]  WITH CHECK ADD  CONSTRAINT [FK_tbImpostoSelo_tbSistemaVerbasIS] FOREIGN KEY([IDVerbaIS])
REFERENCES [dbo].[tbSistemaVerbasIS] ([ID])

ALTER TABLE [dbo].[tbImpostoSelo] CHECK CONSTRAINT [FK_tbImpostoSelo_tbSistemaVerbasIS]

ALTER TABLE [dbo].[tbIVA]  WITH CHECK ADD  CONSTRAINT [FK_tbIVA_tbSistemaCodigosIVA] FOREIGN KEY([IDCodigoIva])
REFERENCES [dbo].[tbSistemaCodigosIVA] ([ID])

ALTER TABLE [dbo].[tbIVA] CHECK CONSTRAINT [FK_tbIVA_tbSistemaCodigosIVA]

ALTER TABLE [dbo].[tbIVA]  WITH CHECK ADD  CONSTRAINT [FK_tbIVA_tbSistemaTiposIVA] FOREIGN KEY([IDTipoIva])
REFERENCES [dbo].[tbSistemaTiposIVA] ([ID])

ALTER TABLE [dbo].[tbIVA] CHECK CONSTRAINT [FK_tbIVA_tbSistemaTiposIVA]

ALTER TABLE [dbo].[tbIVARegioes]  WITH CHECK ADD  CONSTRAINT [FK_tbIVARegioes_tbIVA] FOREIGN KEY([IDIva])
REFERENCES [dbo].[tbIVA] ([ID])

ALTER TABLE [dbo].[tbIVARegioes] CHECK CONSTRAINT [FK_tbIVARegioes_tbIVA]

ALTER TABLE [dbo].[tbIVARegioes]  WITH CHECK ADD  CONSTRAINT [FK_tbIVARegioes_tbIVA1] FOREIGN KEY([IDIvaRegiao])
REFERENCES [dbo].[tbIVA] ([ID])

ALTER TABLE [dbo].[tbIVARegioes] CHECK CONSTRAINT [FK_tbIVARegioes_tbIVA1]

ALTER TABLE [dbo].[tbIVARegioes]  WITH CHECK ADD  CONSTRAINT [FK_tbIVARegioes_tbSistemaRegioesIVA] FOREIGN KEY([IDRegiao])
REFERENCES [dbo].[tbSistemaRegioesIVA] ([ID])

ALTER TABLE [dbo].[tbIVARegioes] CHECK CONSTRAINT [FK_tbIVARegioes_tbSistemaRegioesIVA]

ALTER TABLE [dbo].[tbSubFamilias]  WITH CHECK ADD  CONSTRAINT [FK_tbSubFamilias_tbFamilias] FOREIGN KEY([IDFamilia])
REFERENCES [dbo].[tbFamilias] ([ID])

ALTER TABLE [dbo].[tbSubFamilias] CHECK CONSTRAINT [FK_tbSubFamilias_tbFamilias]

ALTER TABLE [dbo].[tbUnidadesRelacoes]  WITH CHECK ADD  CONSTRAINT [FK_tbUnidadesRelacoes_tbUnidades] FOREIGN KEY([IDUnidade])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbUnidadesRelacoes] CHECK CONSTRAINT [FK_tbUnidadesRelacoes_tbUnidades]

ALTER TABLE [dbo].[tbUnidadesRelacoes]  WITH CHECK ADD  CONSTRAINT [FK_tbUnidadesRelacoes_tbUnidades_Conversao] FOREIGN KEY([IDUnidadeConversao])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbUnidadesRelacoes] CHECK CONSTRAINT [FK_tbUnidadesRelacoes_tbUnidades_Conversao]

ALTER TABLE [dbo].[tbUnidadesTempo]  WITH CHECK ADD  CONSTRAINT [FK_tbUnidadesTempo_tbSistemaFormatoUnidadeTempo] FOREIGN KEY([IDFormato])
REFERENCES [dbo].[tbSistemaFormatoUnidadeTempo] ([ID])

ALTER TABLE [dbo].[tbUnidadesTempo] CHECK CONSTRAINT [FK_tbUnidadesTempo_tbSistemaFormatoUnidadeTempo]

ALTER TABLE [dbo].[tbArtigosImpostoSelo]  WITH CHECK ADD  CONSTRAINT [CK_tbArtigosImpostoSelo_LimiteMinimoMenorIgualAoMaximo] CHECK  (([LimiteMinimo]<=[LimiteMaximo]))

ALTER TABLE [dbo].[tbArtigosImpostoSelo] CHECK CONSTRAINT [CK_tbArtigosImpostoSelo_LimiteMinimoMenorIgualAoMaximo]

ALTER TABLE [dbo].[tbArtigosImpostoSelo]  WITH CHECK ADD  CONSTRAINT [CK_tbArtigosImpostoSelo_MenorIgualQue100] CHECK  (([Percentagem]<=(100)))

ALTER TABLE [dbo].[tbArtigosImpostoSelo] CHECK CONSTRAINT [CK_tbArtigosImpostoSelo_MenorIgualQue100]

ALTER TABLE [dbo].[tbArtigosImpostoSelo]  WITH CHECK ADD  CONSTRAINT [CK_tbArtigosImpostoSelo_PercentagemMaiorOuIgualAZero] CHECK  (([Percentagem]>=(0)))

ALTER TABLE [dbo].[tbArtigosImpostoSelo] CHECK CONSTRAINT [CK_tbArtigosImpostoSelo_PercentagemMaiorOuIgualAZero]

ALTER TABLE [dbo].[tbArtigosUnidades]  WITH CHECK ADD  CONSTRAINT [CK_tbArtigosUnidades] CHECK  (([IDUnidade]<>[IDUnidadeConversao]))

ALTER TABLE [dbo].[tbArtigosUnidades] CHECK CONSTRAINT [CK_tbArtigosUnidades]

ALTER TABLE [dbo].[tbUnidadesRelacoes]  WITH CHECK ADD  CONSTRAINT [CK_tbUnidadesRelacoes_MesmoValorUnidade] CHECK  (([IDUnidade]<>[IDUnidadeConversao]))

ALTER TABLE [dbo].[tbUnidadesRelacoes] CHECK CONSTRAINT [CK_tbUnidadesRelacoes_MesmoValorUnidade]


/* LC, LO, OS, AR */
create table tbModelos (ID bigint  identity(1,1) , constraint PK_tbModelos primary Key (ID), IDMarca bigint not null,IDTipoArtigo bigint not null,IDTipoLente bigint null,IDMateriaLente bigint null,IDSuperficieLente bigint null,Codigo nvarchar (10) not null,Descricao nvarchar (100) not null,Stock bit not null constraint DF_tbModelos_Stock default 0,Fotocromatica bit not null constraint DF_tbModelos_Fotocromatica default 0,IndiceRefracao float not null constraint DF_tbModelos_IndiceRefracao default 0,NrABBE nvarchar (15) null,TransmissaoLuz nvarchar (15) null,Material nvarchar (15) null,UVA nvarchar (15) null,UVB nvarchar (15) null,Infravermelhos nvarchar (15) null,CodForn nvarchar (100) null,Referencia nvarchar (50) null,ModeloForn nvarchar (50) null,CodCor nvarchar (50) null,CodTratamento nvarchar (50) null,CodInstrucao nvarchar (50) null,Observacoes nvarchar (4000) null,Ativo bit not null constraint DF_tbModelos_Ativo default 1,Sistema bit not null constraint DF_tbModelos_Sistema default 0,DataCriacao datetime not null constraint DF_tbModelos_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbModelos_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbModelos_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbModelos_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbModelos add constraint FK_tbModelos_tbMarcas  foreign key (IDMarca) references tbMarcas (ID)
alter table tbModelos add constraint FK_tbModelos_tbTiposArtigos foreign key (IDTipoArtigo) references tbTiposArtigos (ID)
alter table tbModelos add constraint FK_tbModelos_tbSistemaTiposLentes foreign key (IDTipoLente) references tbSistemaTiposLentes (ID)
alter table tbModelos add constraint FK_tbModelos_tbSistemaMateriasLentes foreign key (IDMateriaLente) references tbSistemaMateriasLentes (ID)
alter table tbModelos add constraint FK_tbModelos_tbSistemaSuperficiesLentes foreign key (IDSuperficieLente) references tbSistemaSuperficiesLentes (ID)
create unique index IX_tbModelos_Codigo on tbModelos (Codigo)

create table tbTratamentosLentes (ID bigint  identity(1,1) , constraint PK_tbTratamentosLentes primary Key (ID), IDMarca bigint not null,IDModelo bigint not null,Codigo nvarchar (10) not null,Descricao nvarchar (100) not null,Cor bit null constraint DF_tbTratamentosLentes_Cor default 0,CodForn nvarchar (100) null,Referencia nvarchar (50) null,ModeloForn nvarchar (50) null,Observacoes nvarchar (4000) null,Ativo bit not null constraint DF_tbTratamentosLentes_Ativo default 1,Sistema bit not null constraint DF_tbTratamentosLentes_Sistema default 0,DataCriacao datetime not null constraint DF_tbTratamentosLentes_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbTratamentosLentes_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbTratamentosLentes_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbTratamentosLentes_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbTratamentosLentes add constraint FK_tbTratamentosLentes_tbMarcas foreign key (IDMarca) references tbMarcas (ID)
alter table tbTratamentosLentes add constraint FK_tbTratamentosLentes_tbModelos foreign key (IDModelo) references tbModelos (ID)
create unique index IX_tbTratamentosLentes_Codigo on tbTratamentosLentes (Codigo) 

create table tbSuplementosLentes (ID bigint  identity(1,1) , constraint PK_tbSuplementosLentes primary Key (ID), IDMarca bigint not null,IDModelo bigint null,IDTipoLente bigint not null,IDMateriaLente bigint not null,Codigo nvarchar (10) not null,Descricao nvarchar (100) not null,Cor bit null constraint DF_tbSuplementosLentes_Cor default 0,PrecoVenda float null constraint DF_tbSuplementosLentes_PrecoVenda default 0,PrecoCusto float null constraint DF_tbSuplementosLentes_PrecoCusto default 0,CodForn nvarchar (100) null,Referencia nvarchar (50) null,ModeloForn nvarchar (50) null,Observacoes nvarchar (4000) null,Ativo bit not null constraint DF_tbSuplementosLentes_Ativo default 1,Sistema bit not null constraint DF_tbSuplementosLentes_Sistema default 0,DataCriacao datetime not null constraint DF_tbSuplementosLentes_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbSuplementosLentes_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbSuplementosLentes_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbSuplementosLentes_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbSuplementosLentes add constraint FK_tbSuplementosLentes_tbMarcas foreign key (IDMarca) references tbMarcas (ID)
alter table tbSuplementosLentes add constraint FK_tbSuplementosLentes_tbModelos foreign key (IDModelo) references tbModelos (ID)
alter table tbSuplementosLentes add constraint FK_tbSuplementosLentes_tbSistemaTiposLentes foreign key (IDTipoLente) references tbSistemaTiposLentes (ID)
alter table tbSuplementosLentes add constraint FK_tbSuplementosLentes_tbSistemaMateriasLentes foreign key (IDMateriaLente) references tbSistemaMateriasLentes (ID)
create unique index IX_tbSuplementosLentes_Codigo on tbSuplementosLentes (Codigo) 

create table tbCoresLentes (ID bigint  identity(1,1) , constraint PK_tbCoresLentes primary Key (ID), IDMarca bigint not null,IDModelo bigint null,IDTipoLente bigint not null,IDMateriaLente bigint not null,Codigo nvarchar (10) not null,Descricao nvarchar (100) not null,Cor bit null constraint DF_tbCoresLentes_Cor default 1,PrecoVenda float null constraint DF_tbCoresLentes_PrecoVenda default 0,PrecoCusto float null constraint DF_tbCoresLentes_PrecoCusto default 0,CodForn nvarchar (100) null,Referencia nvarchar (50) null,ModeloForn nvarchar (50) null,Observacoes nvarchar (4000) null,Ativo bit not null constraint DF_tbCoresLentes_Ativo default 1,Sistema bit not null constraint DF_tbCoresLentes_Sistema default 0,DataCriacao datetime not null constraint DF_tbCoresLentes_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbCoresLentes_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbCoresLentes_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbCoresLentes_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbCoresLentes add constraint FK_tbCoresLentes_tbMarcas foreign key (IDMarca) references tbMarcas (ID)
alter table tbCoresLentes add constraint FK_tbCoresLentes_tbModelos foreign key (IDModelo) references tbModelos (ID)
alter table tbCoresLentes add constraint FK_tbCoresLentes_tbSistemaTiposLentes foreign key (IDTipoLente) references tbSistemaTiposLentes (ID)
alter table tbCoresLentes add constraint FK_tbCoresLentes_tbSistemaMateriasLentes foreign key (IDMateriaLente) references tbSistemaMateriasLentes (ID)
create unique index IX_tbCoresLentes_Codigo on tbCoresLentes (Codigo) 

create table tbAros (ID bigint  identity(1,1) , constraint PK_tbAros primary Key (ID), IDArtigo bigint not null, IDModelo bigint null,CodigoCor nvarchar (50) null,Tamanho nvarchar (50) null,Hastes nvarchar (50) null, CorGenerica nvarchar (50) null, CorLente nvarchar (50) null, TipoLente nvarchar (50) null, Ativo bit not null constraint DF_tbAros_Ativo default 1,Sistema bit not null constraint DF_tbAros_Sistema default 0,DataCriacao datetime not null constraint DF_tbAros_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbAros_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbAros_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbAros_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbAros add constraint FK_tbAros_IDModelo  foreign key (IDModelo) references tbModelos (ID)
create unique index IX_tbAros on tbAros (IDModelo, CodigoCor, Tamanho, Hastes) 
alter table tbAros add constraint FK_tbAros_tbArtigos foreign key (IDArtigo) references tbArtigos (ID)

create table tbOculosSol (ID bigint  identity(1,1) , constraint PK_tbOculosSol primary Key (ID), IDArtigo bigint not null, IDModelo bigint null,CodigoCor nvarchar (50) null,Tamanho nvarchar (50) null,Hastes nvarchar (50) null, CorGenerica nvarchar (50) null, CorLente nvarchar (50) null, TipoLente nvarchar (50) null, Ativo bit not null constraint DF_tbOculosSol_Ativo default 1,Sistema bit not null constraint DF_tbOculosSol_Sistema default 0,DataCriacao datetime not null constraint DF_tbOculosSol_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbOculosSol_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbOculosSol_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbOculosSol_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbOculosSol add constraint FK_tbOculosSol_IDModelo  foreign key (IDModelo) references tbModelos (ID)
create unique index IX_tbOculosSol ON tbOculosSol (IDModelo, CodigoCor, Tamanho, Hastes) 
alter table tbOculosSol add constraint FK_tbOculosSol_tbArtigos foreign key (IDArtigo) references tbArtigos (ID)

create table tbLentesOftalmicas (ID bigint  identity(1,1) , constraint PK_tbLentesOftalmicas primary Key (ID), IDArtigo bigint not null, IDModelo bigint null, IDTratamentoLente bigint null, IDCorLente bigint null, Diametro nvarchar (50) null,PotenciaEsferica float null,PotenciaCilindrica float null,PotenciaPrismatica float null,Adicao float null, CodigosSuplementos nvarchar(360) null, Ativo bit not null constraint DF_tbLentesOftalmicas_Ativo default 1,Sistema bit not null constraint DF_tbLentesOftalmicas_Sistema default 0,DataCriacao datetime not null constraint DF_tbLentesOftalmicas_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbLentesOftalmicas_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbLentesOftalmicas_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbLentesOftalmicas_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbLentesOftalmicas add constraint FK_tbLentesOftalmicas_tbModelos foreign key (IDModelo) references tbModelos (ID)
alter table tbLentesOftalmicas add constraint FK_tbLentesOftalmicas_tbTratamentosLentes foreign key (IDTratamentoLente) references tbTratamentosLentes (ID)
alter table tbLentesOftalmicas add constraint FK_tbLentesOftalmicas_tbCoresLentes foreign key (IDcorLente) references tbCoresLentes (ID)
create unique index IX_tbLentesOftalmicas on tbLentesOftalmicas (IDModelo, IDTratamentoLente, IDCorLente, Diametro, PotenciaEsferica, PotenciaCilindrica, PotenciaPrismatica, Adicao, CodigosSuplementos) 
alter table tbLentesOftalmicas add constraint FK_tbLentesOftalmicas_tbArtigos foreign key (IDArtigo) references tbArtigos (ID)

create table tbLentesContato (ID bigint  identity(1,1) , constraint PK_tbLentesContato primary Key (ID), IDArtigo bigint not null, IDModelo bigint null,Raio nvarchar (50) null,Diametro nvarchar (50) null,PotenciaEsferica float null,PotenciaCilindrica float null,Eixo int null,Adicao float null,Raio2 nvarchar (50) null,Ativo bit not null constraint DF_tbLentesContato_Ativo default 1,Sistema bit not null constraint DF_tbLentesContato_Sistema default 0,DataCriacao datetime not null constraint DF_tbLentesContato_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbLentesContato_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbLentesContato_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbLentesContato_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbLentesContato add constraint FK_tbLentesContato_tbModelos foreign key (IDModelo) references tbModelos (ID)
create unique index IX_tbLentesContato on tbLentesContato (IDModelo, Raio, Diametro, PotenciaEsferica, PotenciaCilindrica, Eixo, Adicao)
alter table tbLentesContato add constraint FK_tbLentesContato_tbArtigos foreign key (IDArtigo) references tbArtigos (ID)

alter table tbEntidadesMoradas add Morada nvarchar(100) null constraint DF_tbEntidadesMoradas_Morada default ''
alter table tbClientesMoradas add Morada nvarchar(100) null constraint DF_tbClientesMoradas_Morada default ''
alter table tbFornecedoresMoradas add Morada nvarchar(100) null constraint DF_tbFornecedoresMoradas_Morada default ''
alter table tbMedicosTecnicosMoradas add Morada nvarchar(100) null constraint DF_tbMedicosTecnicosMoradas_Morada default ''
alter table tbBancosMoradas add Morada nvarchar(100) null constraint DF_tbBancosMoradas_Morada default ''
alter table tbContasBancariasMoradas add Morada nvarchar(100) null constraint DF_tbContasBancariasMoradas_Morada default ''
alter table tbArmazens add Morada nvarchar(100) null constraint DF_tbArmazens_Morada default ''

alter table tbEntidadesMoradas drop column rua, numpolicia
alter table tbClientesMoradas drop column rua, numpolicia
alter table tbFornecedoresMoradas drop column rua, numpolicia
alter table tbMedicosTecnicosMoradas drop column rua, numpolicia
alter table tbBancosMoradas drop column rua, numpolicia
alter table tbContasBancariasMoradas drop column rua, numpolicia
alter table tbArmazens drop column rua, numpolicia

/****** Object:  Table [dbo].[tbEscaloes]    Script Date: 23-06-2016 14:15:52 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbEscaloes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbEscaloes_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbEscaloes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbEscaloes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbEscaloes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbEscaloesEspecificos]    Script Date: 23-06-2016 14:15:52 ******/
CREATE TABLE [dbo].[tbEscaloesEspecificos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDEscalao] [bigint] NOT NULL,
	[IDGruposArtigo] [bigint] NULL,
	[IDFamilia] [bigint] NULL,
	[IDSubFamilia] [bigint] NULL,
	[IDArtigo] [bigint] NULL,
	[Percentagem] [float] NULL,
	[Ordem] [int] NOT NULL,
	[Descricao] [nvarchar](50) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbEscaloesEspecificos_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbEscaloesEspecificos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbEscaloesEspecificos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbEscaloesEspecificos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbEscaloesGerais]    Script Date: 23-06-2016 14:15:52 ******/
CREATE TABLE [dbo].[tbEscaloesGerais](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDEscalao] [bigint] NOT NULL,
	[AteValor] [float] NULL,
	[Percentagem] [float] NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbEscaloesGerais_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbEscaloesGerais_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbEscaloesGerais_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbEscaloesGerais] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbEscaloesPenalizacoes]    Script Date: 23-06-2016 14:15:52 ******/
CREATE TABLE [dbo].[tbEscaloesPenalizacoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDEscalao] [bigint] NOT NULL,
	[AteDias] [float] NULL,
	[Percentagem] [float] NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbEscaloesPenalizacoes_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbEscaloesPenalizacoes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbEscaloesPenalizacoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbEscaloesPenalizacoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [IX_tbEscaloesCodigo] ON [dbo].[tbEscaloes]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE [dbo].[tbEscaloesEspecificos]  WITH CHECK ADD  CONSTRAINT [FK_tbEscaloesEspecificos_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbEscaloesEspecificos] CHECK CONSTRAINT [FK_tbEscaloesEspecificos_tbArtigos]

ALTER TABLE [dbo].[tbEscaloesEspecificos]  WITH CHECK ADD  CONSTRAINT [FK_tbEscaloesEspecificos_tbEscaloes] FOREIGN KEY([IDEscalao])
REFERENCES [dbo].[tbEscaloes] ([ID])

ALTER TABLE [dbo].[tbEscaloesEspecificos] CHECK CONSTRAINT [FK_tbEscaloesEspecificos_tbEscaloes]

ALTER TABLE [dbo].[tbEscaloesEspecificos]  WITH CHECK ADD  CONSTRAINT [FK_tbEscaloesEspecificos_tbFamilias] FOREIGN KEY([IDFamilia])
REFERENCES [dbo].[tbFamilias] ([ID])

ALTER TABLE [dbo].[tbEscaloesEspecificos] CHECK CONSTRAINT [FK_tbEscaloesEspecificos_tbFamilias]

ALTER TABLE [dbo].[tbEscaloesEspecificos]  WITH CHECK ADD  CONSTRAINT [FK_tbEscaloesEspecificos_tbGruposArtigo] FOREIGN KEY([IDGruposArtigo])
REFERENCES [dbo].[tbGruposArtigo] ([ID])

ALTER TABLE [dbo].[tbEscaloesEspecificos] CHECK CONSTRAINT [FK_tbEscaloesEspecificos_tbGruposArtigo]

ALTER TABLE [dbo].[tbEscaloesEspecificos]  WITH CHECK ADD  CONSTRAINT [FK_tbEscaloesEspecificos_tbSubFamilias] FOREIGN KEY([IDSubFamilia])
REFERENCES [dbo].[tbSubFamilias] ([ID])

ALTER TABLE [dbo].[tbEscaloesEspecificos] CHECK CONSTRAINT [FK_tbEscaloesEspecificos_tbSubFamilias]

ALTER TABLE [dbo].[tbEscaloesGerais]  WITH CHECK ADD  CONSTRAINT [FK_tbEscaloesGerais_tbEscaloes] FOREIGN KEY([IDEscalao])
REFERENCES [dbo].[tbEscaloes] ([ID])

ALTER TABLE [dbo].[tbEscaloesGerais] CHECK CONSTRAINT [FK_tbEscaloesGerais_tbEscaloes]

ALTER TABLE [dbo].[tbEscaloesPenalizacoes]  WITH CHECK ADD  CONSTRAINT [FK_tbEscaloesPenalizacoes_tbEscaloes] FOREIGN KEY([IDEscalao])
REFERENCES [dbo].[tbEscaloes] ([ID])

ALTER TABLE [dbo].[tbEscaloesPenalizacoes] CHECK CONSTRAINT [FK_tbEscaloesPenalizacoes_tbEscaloes]

ALTER TABLE [dbo].[tbParametrosEmpresa]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosEmpresa_tbSistemaIdiomas] FOREIGN KEY([IDIdiomaBase])
REFERENCES [dbo].[tbSistemaIdiomas] ([ID])

ALTER TABLE [dbo].[tbParametrosEmpresa] CHECK CONSTRAINT [FK_tbParametrosEmpresa_tbSistemaIdiomas]

alter table tbIdiomas add constraint FK_tbIdiomas_tbSistemaIdiomas foreign key (IDCultura) references tbSistemaIdiomas (ID)

CREATE TABLE [dbo].[tbArtigosFornecedores](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDFornecedor] [bigint] NOT NULL,
	[Referencia] [nvarchar](50) NULL,
	[CodigoBarras] [nvarchar](50) NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL
 CONSTRAINT [PK_tbArtigosFornecedores] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbArtigosFornecedores] ADD  CONSTRAINT [DF_tbArtigosFornecedores_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbArtigosFornecedores] ADD  CONSTRAINT [DF_tbArtigosFornecedores_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbArtigosFornecedores] ADD  CONSTRAINT [DF_tbArtigosFornecedores_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbArtigosFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosFornecedores_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosFornecedores] CHECK CONSTRAINT [FK_tbArtigosFornecedores_tbArtigos]

ALTER TABLE [dbo].[tbArtigosFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosFornecedores_tbFornecedores] FOREIGN KEY([IDFornecedor])
REFERENCES [dbo].[tbFornecedores] ([ID])

ALTER TABLE [dbo].[tbArtigosFornecedores] CHECK CONSTRAINT [FK_tbArtigosFornecedores_tbFornecedores]

create table tbPrecosLentes (ID bigint  identity(1,1) , constraint PK_tbPrecosLentes primary Key (ID), IDModelo bigint not null, IDTratamentoLente bigint null, GamaStock bit null, DiamDe nvarchar(10) null, DiamAte nvarchar(10) null, PotEsfDe float null, PotEsfAte float null, PotCilDe float null, PotCilAte float null, Raio nvarchar (5) null, PrecoVenda float null, PrecoCusto float null, Ativo bit not null constraint DF_tbPrecosLentes_Ativo default 1,Sistema bit not null constraint DF_tbPrecosLentes_Sistema default 0,DataCriacao datetime not null constraint DF_tbPrecosLentes_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbPrecosLentes_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbPrecosLentes_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbPrecosLentes_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbPrecosLentes add constraint FK_tbPrecosLentes_tbModelos  foreign key (IDModelo) references tbModelos (ID)
alter table tbPrecosLentes add constraint FK_tbPrecosLentes_tbTratamentosLentes foreign key (IDTratamentoLente) references tbTratamentosLentes (ID)

create table tbGamasLentes (ID bigint  identity(1,1) , constraint PK_tbGamasLentes primary Key (ID), IDModelo bigint not null, IDTratamentoLente bigint null, Descentrado bit null, DiamDe nvarchar(10) null, DiamAte nvarchar(10) null, PotEsfDe float null, PotEsfAte float null, PotCilDe float null, PotCilAte float null, Raio nvarchar (5) null, AdicaoDe float null, AdicaoAte float null, Ativo bit not null constraint DF_tbGamasLentes_Ativo default 1,Sistema bit not null constraint DF_tbGamasLentes_Sistema default 0,DataCriacao datetime not null constraint DF_tbGamasLentes_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbGamasLentes_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbGamasLentes_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbGamasLentes_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbGamasLentes add constraint FK_tbGamasLentes_tbModelos  foreign key (IDModelo) references tbModelos (ID)
alter table tbGamasLentes add constraint FK_tbGamasLentes_tbTratamentosLentes foreign key (IDTratamentoLente) references tbTratamentosLentes (ID)

create table tbLentesOftalmicasSuplementos (ID bigint  identity(1,1) , constraint PK_tbLentesOftalmicasSuplementos primary Key (ID), IDLenteOftalmica bigint not null, IDSuplementoLente bigint not null, Ativo bit not null constraint DF_tbLentesOftalmicasSuplementos_Ativo default 1,Sistema bit not null constraint DF_tbLentesOftalmicasSuplementos_Sistema default 0,DataCriacao datetime not null constraint DF_tbLentesOftalmicasSuplementos_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbLentesOftalmicasSuplementos_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbLentesOftalmicasSuplementos_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbLentesOftalmicasSuplementos_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbLentesOftalmicasSuplementos add constraint FK_tbLentesOftalmicasSuplementos_tbLentesOftalmicas foreign key (IDLenteOftalmica) references tbLentesOftalmicas (ID) ON DELETE CASCADE
alter table tbLentesOftalmicasSuplementos add constraint FK_tbLentesOftalmicasSuplementos_tbSuplementosLentes foreign key (IDSuplementoLente) references tbSuplementosLentes (ID)

EXEC('Create PROCEDURE [dbo].[sp_F3M_ExecutaQueryeDevolveID] 
  @query nvarchar(4000),
  @id bigint OUTPUT 
AS  
BEGIN 
EXECUTE sp_executesql @query
 SET @id=SCOPE_IDENTITY()
 SELECT @id
END')

EXEC('CREATE TRIGGER UpdateTbUnidades
ON [dbo].[tbUnidades]  
AFTER  INSERT, UPDATE
AS  UPDATE tbUnidades  SET PorDefeito = 0  WHERE (ID <> (SELECT ID FROM  inserted) AND (SELECT PorDefeito FROM inserted) = 1) ')

EXEC('CREATE PROCEDURE [dbo].[sp_F3M_DaResultadoPesquisa] 
  @query nvarchar(4000)
AS  
BEGIN 
EXECUTE sp_executesql @query
END')
