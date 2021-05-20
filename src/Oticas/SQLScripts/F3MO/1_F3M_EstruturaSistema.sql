/****** Object:  Table [dbo].[tbSistemaAcoes]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaAcoes](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaAcoes_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaAcoes_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaAcoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaAcoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaCamposFormulas]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaCamposFormulas](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[IDEntidadesFormulas] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaCamposFormulas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaClassificacoesTiposArtigos]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaClassificacoesTiposArtigos](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbLogicaClassificoesTiposArtigos_Sistema]  DEFAULT ((1)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbLogicaClassificoesTiposArtigos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbLogicaClassificacoesTiposArtigos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaClassificoesTiposArtigos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaClassificacoesTiposArtigosGeral]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaClassificacoesTiposArtigosGeral](
	[ID] [bigint] NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaClassificacoesTiposArtigosGeral_Sistema]  DEFAULT ((1)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaClassificacoesTiposArtigosGeral_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaClassificacoesTiposArtigosGeral_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[CodigoSAFT] [nvarchar](3) NULL,
	[CodigoAT] [nvarchar](3) NULL,
 CONSTRAINT [PK_tbSistemaClassificacoesTiposArtigosGeral] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaCodigosIVA]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaCodigosIVA](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](255) NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaCodigosIVA] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaCodigosPrecos]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaCodigosPrecos](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](255) NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaCodigosPrecos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaCompostoTransformacaoMetodoCusto]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaCompostoTransformacaoMetodoCusto](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbLogicaCompostoTransformacaoMetodoCusto_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbLogicaCompostoTransformacaoMetodoCusto_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbLogicaCompostoTransformacaoMetodoCusto_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaCompostoTransformacaoMetodoCusto] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaEmissaoFatura]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaEmissaoFatura](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](255) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaEmissaoFatura] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaEmissaoPackingList]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaEmissaoPackingList](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](255) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaEmissaoPackingList] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaEntidadesEstados]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaEntidadesEstados](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaEntidadesEstados] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaEntidadesF3M]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaEntidadesF3M](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbLogicaEntidadesF3M_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbLogicaEntidadesF3M_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbLogicaEntidadesF3M_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaEntidadesF3M] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaEntidadesFormulas]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaEntidadesFormulas](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaEntidadesFormulas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaEspacoFiscal]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaEspacoFiscal](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](3) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaEspacoFiscal] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaFormasCalculoComissoes]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaFormasCalculoComissoes](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](25) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[PorDefeito] [bit] NULL,
 CONSTRAINT [PK_tbLogicaFormasCalculoComissoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaFormatoUnidadeTempo]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaFormatoUnidadeTempo](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](3) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaFormatoUnidadeTempo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaModulos]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaModulos](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](50) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[TiposDocumentos] [bit] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_tbLogicaModulos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaMoedas]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaMoedas](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](3) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[CasasDecimaisTotais] [tinyint] NULL,
	[CasasDecimaisIva] [tinyint] NULL,
	[CasasDecimaisPrecosUnitarios] [tinyint] NULL,
 CONSTRAINT [PK_tbLogicaMoedas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaOrdemLotes]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaOrdemLotes](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbLogicaOrdemLotes_Sistema]  DEFAULT ((1)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbLogicaOrdemLotes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbLogicaOrdemLotes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaOrdemLotes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaRegimeIVA]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaRegimeIVA](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](3) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaRegimeIVA] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaRegioesIVA]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaRegioesIVA](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](1) NOT NULL,
	[Descricao] [nvarchar](20) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaRegioesIVA] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaRelacaoEspacoFiscalRegimeIva]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaRelacaoEspacoFiscalRegimeIva](
	[ID] [bigint] NOT NULL,
	[IDEspacoFiscal] [bigint] NOT NULL,
	[IDRegimeIva] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaRelacaoEspacoFiscalRegimeIva] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaSexo]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaSexo](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](3) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaSexo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaSiglasPaises]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaSiglasPaises](
	[ID] [bigint] NOT NULL,
	[Sigla] [nvarchar](15) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Nacional] [bit] NULL,
 CONSTRAINT [PK_tbLogicaSiglasPaises] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTipoDistMatPrima]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTipoDistMatPrima](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTipoDistMatPrima_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTipoDistMatPrima_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaTipoDistMatPrima_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTipoDistMatPrima] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTipoDistOperacoes]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTipoDistOperacoes](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTipoDistOperacoes_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTipoDistOperacoes_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaTipoDistOperacoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTipoDistOperacoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTipoOp]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTipoOp](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTipoOp_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTipoOp_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaTipoOp_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTipoOp] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTipoOperacoes]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTipoOperacoes](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTipoOperacoes_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTipoOperacoes_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaTipoOperacoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTipoOperacoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposAnexos]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposAnexos](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[IDEntidadeF3M] [bigint] NOT NULL,
	[IDTipoExtensaoFicheiro] [bigint] NOT NULL,
	[TamanhoMaximoFicheiro] [int] NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbTiposAnexos_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbTiposAnexos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbTiposAnexos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbTiposAnexos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposComponente]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposComponente](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaTipoComponente] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposComposicoes]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposComposicoes](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](1) NOT NULL,
	[Descricao] [nvarchar](10) NOT NULL,
	[PedeComponentes] [bit] NOT NULL CONSTRAINT [DF_tbLogicaTiposComposicoes_PedeComponentes]  DEFAULT ((0)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbLogicaTiposComposicoes_Sistema]  DEFAULT ((1)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbLogicaTiposComposicoes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbLogicaTiposComposicoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaTiposComposicoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposCondDataVencimento]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposCondDataVencimento](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](3) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaTiposCondDataVencimento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposDimensoes]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposDimensoes](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](1) NOT NULL,
	[Descricao] [nvarchar](10) NOT NULL,
	[PedeMatriz] [bit] NOT NULL CONSTRAINT [DF_tbLogicaTiposDimensoes_PedeMatriz]  DEFAULT ((0)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbLogicaTiposDimensoes_Sistema]  DEFAULT ((1)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbLogicaTiposDimensoes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbLogicaTiposDimensoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaTiposDimensoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposDocumento]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposDocumento](
	[ID] [bigint] NOT NULL,
	[Tipo] [nvarchar](50) NULL,
	[Descricao] [nvarchar](255) NULL,
	[IDModulo] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[TipoFiscal] [bit] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_tbLogicaTiposDocumento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposDocumentoComunicacao]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposDocumentoComunicacao](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposDocumentoComunicacao_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposDocumentoComunicacao_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaTiposDocumentoComunicacao_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTiposDocumentoComunicacao] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposDocumentoFiscal]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposDocumentoFiscal](
	[ID] [bigint] NOT NULL,
	[Tipo] [nvarchar](50) NULL,
	[Descricao] [nvarchar](255) NULL,
	[IDTipoDocumento] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbTiposDocumentoFiscal] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposDocumentoMovStock]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposDocumentoMovStock](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposDocumentoMovStock_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposDocumentoMovStock_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaTiposDocumentoMovStock_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTiposDocumentoMovStock] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposDocumentoOrigem]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposDocumentoOrigem](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposDocumentoOrigem_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposDocumentoOrigem_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaTiposDocumentoOrigem_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTiposDocumentoOrigem] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposEntidade]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposEntidade](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](25) NOT NULL,
	[Entidade] [nvarchar](50) NOT NULL,
	[Tipo] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[PorDefeito] [bit] NULL,
	[TipoAux] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbLogicaTiposEntidade] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposEntidadeModulos]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposEntidadeModulos](
	[ID] [bigint] NOT NULL,
	[IDSistemaTiposEntidade] [bigint] NOT NULL,
	[IDSistemaModulos] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaTiposEntidadeModulos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposEstados]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposEstados](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[IDEntidadeEstado] [bigint] NOT NULL,
	[Cor] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbSistemaTiposEstados] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposExtensoesFicheiros]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposExtensoesFicheiros](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[ExtensoesPermitidas] [nvarchar](50) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbLogicaTiposExtensoesFicheiros_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbLogicaTiposExtensoesFicheiros_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbLogicaTiposExtensoesFicheiros_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaTiposExtensoesFicheiros] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposFormasPagamento]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposFormasPagamento](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](3) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaTiposFormasPagamento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposIVA]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposIVA](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](3) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaTiposIVA] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposLinhasMP]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposLinhasMP](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](3) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTiposLinhasMP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposLiquidacao]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposLiquidacao](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposLiquidacao_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposLiquidacao_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaTiposLiquidacao_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTiposLiquidacao] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposMaquinas]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposMaquinas](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](80) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaTiposMaquinas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposPessoa]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposPessoa](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](3) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbLogicaTiposPessoa] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaTiposTextoBase]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaTiposTextoBase](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTiposTextoBase] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaVerbasIS]    Script Date: 01-06-2016 16:07:37 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaVerbasIS](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](900) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaVerbasIS_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaVerbasIS_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaVerbasIS_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaVerbasIS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[tbSistemaEntidadeComparticipacao]    Script Date: 27-05-2016 12:05:48 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaEntidadeComparticipacao](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](10) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaEntidadeComparticipacao] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSistemaEntidadeDescricao]    Script Date: 27-05-2016 12:05:48 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSistemaEntidadeDescricao](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](10) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaEntidadeDescricao] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[tbSistemaTiposDocumentoPrecoUnitario](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposDocumentoPrecoUnitario_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposDocumentoPrecoUnitario_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaTiposDocumentoPrecoUnitario_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NOT NULL,
 CONSTRAINT [PK_tbSistemaTiposDocumentoPrecoUnitario] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[tbSistemaRelacaoEspacoFiscalRegimeIva]  WITH CHECK ADD  CONSTRAINT [FK_tbSistemaRelacaoEspacoFiscalRegimeIva_tbSistemaEspacoFiscal] FOREIGN KEY([IDEspacoFiscal])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])

ALTER TABLE [dbo].[tbSistemaRelacaoEspacoFiscalRegimeIva] CHECK CONSTRAINT [FK_tbSistemaRelacaoEspacoFiscalRegimeIva_tbSistemaEspacoFiscal]

ALTER TABLE [dbo].[tbSistemaRelacaoEspacoFiscalRegimeIva]  WITH CHECK ADD  CONSTRAINT [FK_tbSistemaRelacaoEspacoFiscalRegimeIva_tbSistemaRegimeIVA] FOREIGN KEY([IDRegimeIva])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])

ALTER TABLE [dbo].[tbSistemaRelacaoEspacoFiscalRegimeIva] CHECK CONSTRAINT [FK_tbSistemaRelacaoEspacoFiscalRegimeIva_tbSistemaRegimeIVA]

ALTER TABLE [dbo].[tbSistemaTiposAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbSistemaTiposAnexos_tbSistemaEntidadesF3M] FOREIGN KEY([IDEntidadeF3M])
REFERENCES [dbo].[tbSistemaEntidadesF3M] ([ID])

ALTER TABLE [dbo].[tbSistemaTiposAnexos] CHECK CONSTRAINT [FK_tbSistemaTiposAnexos_tbSistemaEntidadesF3M]

ALTER TABLE [dbo].[tbSistemaTiposAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbSistemaTiposAnexos_tbSistemaTiposExtensoesFicheiros] FOREIGN KEY([IDTipoExtensaoFicheiro])
REFERENCES [dbo].[tbSistemaTiposExtensoesFicheiros] ([ID])

ALTER TABLE [dbo].[tbSistemaTiposAnexos] CHECK CONSTRAINT [FK_tbSistemaTiposAnexos_tbSistemaTiposExtensoesFicheiros]

ALTER TABLE [dbo].[tbSistemaTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbSistemaTiposDocumento_tbSistemaModulos] FOREIGN KEY([IDModulo])
REFERENCES [dbo].[tbSistemaModulos] ([ID])

ALTER TABLE [dbo].[tbSistemaTiposDocumento] CHECK CONSTRAINT [FK_tbSistemaTiposDocumento_tbSistemaModulos]

ALTER TABLE [dbo].[tbSistemaTiposDocumentoFiscal]  WITH CHECK ADD  CONSTRAINT [FK_tbSistemaTiposDocumentoFiscal_tbSistemaTiposDocumento] FOREIGN KEY([IDTipoDocumento])
REFERENCES [dbo].[tbSistemaTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbSistemaTiposDocumentoFiscal] CHECK CONSTRAINT [FK_tbSistemaTiposDocumentoFiscal_tbSistemaTiposDocumento]

ALTER TABLE [dbo].[tbSistemaTiposEntidadeModulos]  WITH CHECK ADD  CONSTRAINT [FK_tbSistemaTiposEntidadeModulos_tbSistemaModulos] FOREIGN KEY([IDSistemaModulos])
REFERENCES [dbo].[tbSistemaModulos] ([ID])

ALTER TABLE [dbo].[tbSistemaTiposEntidadeModulos] CHECK CONSTRAINT [FK_tbSistemaTiposEntidadeModulos_tbSistemaModulos]

ALTER TABLE [dbo].[tbSistemaTiposEntidadeModulos]  WITH CHECK ADD  CONSTRAINT [FK_tbSistemaTiposEntidadeModulos_tbSistemaTiposEntidade] FOREIGN KEY([IDSistemaTiposEntidade])
REFERENCES [dbo].[tbSistemaTiposEntidade] ([ID])

ALTER TABLE [dbo].[tbSistemaTiposEntidadeModulos] CHECK CONSTRAINT [FK_tbSistemaTiposEntidadeModulos_tbSistemaTiposEntidade]

ALTER TABLE [dbo].[tbSistemaTiposEstados]  WITH CHECK ADD  CONSTRAINT [FK_tbSistemaTiposEstados_tbSistemaEntidadesEstados] FOREIGN KEY([IDEntidadeEstado])
REFERENCES [dbo].[tbSistemaEntidadesEstados] ([ID])

ALTER TABLE [dbo].[tbSistemaTiposEstados] CHECK CONSTRAINT [FK_tbSistemaTiposEstados_tbSistemaEntidadesEstados]