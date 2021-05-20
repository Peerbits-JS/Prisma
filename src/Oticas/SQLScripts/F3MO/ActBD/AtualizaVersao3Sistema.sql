CREATE TABLE [dbo].[tbSistemaTiposServicos](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](10) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposServicos_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposServicos_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbSistemaTiposServicos_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbSistemaTiposServicos_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaTiposServicos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbSistemaTiposServicos_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
	[PorDefeito] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposServicos_PorDefeito] DEFAULT ((0)),
 CONSTRAINT [PK_tbSistemaTiposServicos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[tbSistemaTiposGraduacoes](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](10) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposGraduacoes_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposGraduacoes_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbSistemaTiposGraduacoes_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbSistemaTiposGraduacoes_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaTiposGraduacoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbSistemaTiposGraduacoes_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTiposGraduacoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[tbSistemaTiposOlhos](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](10) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposOlhos_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaTiposOlhos_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbSistemaTiposOlhos_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbSistemaTiposOlhos_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaTiposOlhos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbSistemaTiposOlhos_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTiposOlhos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

INSERT [dbo].[tbSistemaTiposGraduacoes] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'L', N'Longe', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposGraduacoes] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N'I', N'Intermédia', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposGraduacoes] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N'P', N'Perto', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposGraduacoes] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, N'C', N'LentesContacto', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)

INSERT [dbo].[tbSistemaTiposServicos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [PorDefeito]) VALUES (1, N'U', N'Longe/Perto', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL,0)
INSERT [dbo].[tbSistemaTiposServicos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [PorDefeito]) VALUES (2, N'L', N'Longe', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL,1)
INSERT [dbo].[tbSistemaTiposServicos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [PorDefeito]) VALUES (3, N'P', N'Perto', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL,0)
INSERT [dbo].[tbSistemaTiposServicos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [PorDefeito]) VALUES (4, N'B', N'Bifocal', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL,0)
INSERT [dbo].[tbSistemaTiposServicos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [PorDefeito]) VALUES (5, N'G', N'Progressiva', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL,0)
INSERT [dbo].[tbSistemaTiposServicos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [PorDefeito]) VALUES (6, N'C', N'Contato', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL,0)
INSERT [dbo].[tbSistemaTiposServicos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [PorDefeito]) VALUES (7, N'BOD', N'BifocalOlhoDireito', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL,0)
INSERT [dbo].[tbSistemaTiposServicos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [PorDefeito]) VALUES (8, N'BOE', N'BifocalOlhoEsquerdo', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL,0)
INSERT [dbo].[tbSistemaTiposServicos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [PorDefeito]) VALUES (9, N'POD', N'ProgressivaOlhoDireito', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL,0)
INSERT [dbo].[tbSistemaTiposServicos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [PorDefeito]) VALUES (10, N'POE', N'ProgressivaOlhoEsquerdo', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL,0)

INSERT [dbo].[tbSistemaTiposOlhos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'OD', N'Direito', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposOlhos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N'OE', N'Esquerdo', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposOlhos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N'ARO', N'Aro', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposOlhos] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, N'DIV', N'Diverso', 1, 1, CAST(N'2016-06-17 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)

CREATE TABLE [dbo].[tbSistemaParametrosLoja](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](50) NULL,
	[Descricao] [nvarchar](255) NULL,
	[Valor] [nvarchar](255) NULL,
	[TipoDados] [nvarchar](255) NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaParametrosLoja] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

INSERT [dbo].[tbSistemaParametrosLoja] ([ID], [Codigo], [Descricao], [Valor], [TipoDados], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'ARTIGO_CODIGO', N'Sugere Codigo','1','Integer', 1, 1, CAST(N'2016-03-09 12:52:20.820' AS DateTime), N'f3m', NULL, NULL)
INSERT [dbo].[tbSistemaParametrosLoja] ([ID], [Codigo], [Descricao], [Valor], [TipoDados], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N'ARTIGO_DESCRICAO', N'Sugere Descricao','1','Integer', 1, 1, CAST(N'2016-03-09 12:52:20.820' AS DateTime), N'f3m', NULL, NULL)

CREATE TABLE [dbo].[tbSistemaTiposPrecos](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](255) NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NOT NULL,
 CONSTRAINT [PK_tbSistemaTiposPrecos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

INSERT [dbo].[tbSistemaTiposPrecos] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'Unico', N'Unico', 1, 1, CAST(N'2016-03-09 12:52:20.820' AS DateTime), N'f3m', NULL, NULL)

INSERT [dbo].[tbSistemaEntidadesEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'SV', N'Servicos', 1, 1, CAST(N'2016-03-09 12:52:02.557' AS DateTime), N'f3m', NULL, NULL)
INSERT [dbo].[tbSistemaEntidadesEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N'DV', N'DocumentosVendas', 1, 1, CAST(N'2016-03-09 12:52:02.557' AS DateTime), N'f3m', NULL, NULL)

INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (1, N'RSC', N'Rascunho', 1, 1, CAST(N'2016-05-13 15:21:00.000' AS DateTime), N'F3M', NULL, NULL, 1, N'est-rasc')
INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (2, N'EFT', N'Efetivo', 1, 1, CAST(N'2016-07-06 00:00:00.000' AS DateTime), N'F3M', NULL, NULL, 1, N'est-uso')
INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (3, N'ANL', N'Anulado', 1, 1, CAST(N'2016-07-06 00:00:00.000' AS DateTime), N'F3M', NULL, NULL, 1, N'est-final')	

INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (4, N'RSC', N'Rascunho', 1, 1, CAST(N'2016-05-13 15:21:00.000' AS DateTime), N'F3M', NULL, NULL, 2, N'est-rasc')
INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (5, N'EFT', N'Efetivo', 1, 1, CAST(N'2016-07-06 00:00:00.000' AS DateTime), N'F3M', NULL, NULL, 2, N'est-uso')
INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (6, N'ANL', N'Anulado', 1, 1, CAST(N'2016-07-06 00:00:00.000' AS DateTime), N'F3M', NULL, NULL, 2, N'est-final')

SET IDENTITY_INSERT [dbo].[tbEstados] ON 
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (1, N'E1', N'Rascunho', 1, 1, CAST(N'2016-03-11 04:51:28.000' AS DateTime), N'f3m', CAST(N'2016-05-13 15:28:08.757' AS DateTime), N'f3m', 1, 1, 0, 0)
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (2, N'E2', N'Efetivo', 1, 1, CAST(N'2016-03-14 12:07:35.000' AS DateTime), N'f3m', CAST(N'2016-05-13 15:28:14.397' AS DateTime), N'f3m', 1, 2, 1, 1)
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (3, N'E3', N'Anulado', 1, 1, CAST(N'2016-07-13 05:00:33.000' AS DateTime), N'f3m', CAST(N'2016-07-13 17:00:40.757' AS DateTime), N'f3m', 1, 3, 0, 0)

INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (4, N'D1', N'Rascunho', 1, 1, CAST(N'2016-03-11 04:51:28.000' AS DateTime), N'f3m', CAST(N'2016-05-13 15:28:08.757' AS DateTime), N'f3m', 2, 4, 1, 1)
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (5, N'D2', N'Efetivo', 1, 1, CAST(N'2016-07-13 05:00:33.000' AS DateTime), N'f3m', CAST(N'2016-07-13 17:00:40.757' AS DateTime), N'f3m', 2, 5, 0, 0)
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (6, N'D3', N'Anulado', 1, 1, CAST(N'2016-07-13 05:00:33.000' AS DateTime), N'f3m', CAST(N'2016-07-13 17:00:40.757' AS DateTime), N'f3m', 2, 6, 0, 0)
SET IDENTITY_INSERT [dbo].[tbEstados] OFF

EXEC('ALTER TABLE [tbSistemaSiglasPaises] ADD DescricaoPais nvarchar(50) NOT NULL DEFAULT('''')')

EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Andorra'' WHERE [Sigla] = ''AD''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Emirados Árabes Unidos'' WHERE [Sigla] = ''AE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Afeganistão'' WHERE [Sigla] = ''AF''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Antígua e Barbuda'' WHERE [Sigla] = ''AG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Anguilla'' WHERE [Sigla] = ''AI''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Albânia'' WHERE [Sigla] = ''AL''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Armênia'' WHERE [Sigla] = ''AM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Angola'' WHERE [Sigla] = ''AO''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Antártica'' WHERE [Sigla] = ''AQ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Argentina'' WHERE [Sigla] = ''AR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''AS'' WHERE [Sigla] = ''AS''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Áustria'' WHERE [Sigla] = ''AT''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Austrália'' WHERE [Sigla] = ''AU''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Aruba'' WHERE [Sigla] = ''AW''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilhas Aland'' WHERE [Sigla] = ''AX''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Azerbaijão'' WHERE [Sigla] = ''AZ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Bósnia e Herzegovina'' WHERE [Sigla] = ''BA''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Barbados'' WHERE [Sigla] = ''BB''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Bangladesh'' WHERE [Sigla] = ''BD''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Bélgica'' WHERE [Sigla] = ''BE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Burkina Faso'' WHERE [Sigla] = ''BF''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Bulgária'' WHERE [Sigla] = ''BG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Bahrain'' WHERE [Sigla] = ''BH''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Burundi'' WHERE [Sigla] = ''BI''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Benin'' WHERE [Sigla] = ''BJ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''São Bartolomeu'' WHERE [Sigla] = ''BL''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Bermudas'' WHERE [Sigla] = ''BM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Brunei Darussalam'' WHERE [Sigla] = ''BN''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Bolívia, Estado Plurinacional da'' WHERE [Sigla] = ''BO''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Bonaire, Santo Eustáquio e Saba'' WHERE Sigla = ''BQ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Brasil'' WHERE Sigla = ''BR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Bahamas'' WHERE Sigla = ''BS''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Butão'' WHERE Sigla = ''BT''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilha Bouvet'' WHERE Sigla = ''BV''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Botswana'' WHERE Sigla = ''BW''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Belarus'' WHERE Sigla = ''BY''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Belize'' WHERE Sigla = ''BZ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Canadá'' WHERE Sigla = ''CA''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilhas Cocos (Keeling)'' WHERE Sigla = ''CC''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Congo, República Democrática do'' WHERE Sigla = ''CD''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Central Africano República'' WHERE Sigla = ''CF''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Congo'' WHERE Sigla = ''CG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Suíça'' WHERE Sigla = ''CH''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Côte d Ivoire'' WHERE Sigla = ''CI''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilhas Cook'' WHERE Sigla = ''CK''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Chile'' WHERE Sigla = ''CL''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Camarões'' WHERE Sigla = ''CM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''China'' WHERE Sigla = ''CN''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Colômbia'' WHERE Sigla = ''CO''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Costa Rica'' WHERE Sigla = ''CR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Cuba'' WHERE Sigla = ''CU''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Cabo Verde'' WHERE Sigla = ''CV''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Curaçao'' WHERE Sigla = ''CW''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilha do Natal'' WHERE Sigla = ''CX''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Chipre'' WHERE Sigla = ''CY''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''República Checa'' WHERE Sigla = ''CZ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Djibouti'' WHERE Sigla = ''DE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Argentina'' WHERE Sigla = ''DJ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Dinamarca'' WHERE Sigla = ''DK''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Dominica'' WHERE Sigla = ''DM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''DO'' WHERE Sigla = ''DO''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Argélia'' WHERE Sigla = ''DZ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Equador'' WHERE Sigla = ''EC''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Estônia'' WHERE Sigla = ''EE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Egito''WHERE Sigla = ''EG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Saara Ocidental'' WHERE Sigla = ''EH''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Eritrea'' WHERE Sigla = ''ER''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Espanha'' WHERE Sigla = ''ES''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Etiópia'' WHERE Sigla = ''ET''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Finlândia'' WHERE Sigla = ''FI''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Fiji'' WHERE Sigla = ''FJ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilhas Falkland (Malvinas)'' WHERE Sigla = ''FK''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Micronésia, Estados Federados da'' WHERE Sigla = ''FM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''ilhas Faroe'' WHERE Sigla = ''FO''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''França'' WHERE Sigla = ''FR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Gabão'' WHERE Sigla = ''GA''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Reino Unido da Grã-Bretanha e Irlanda do Norte'' WHERE Sigla = ''GB''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Grenada'' WHERE Sigla = ''GD''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Georgia'' WHERE Sigla = ''GE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Guiana Francesa'' WHERE Sigla = ''GF''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Guernsey'' WHERE Sigla = ''GG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Gana'' WHERE Sigla = ''GH''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Gibraltar'' WHERE Sigla = ''GI''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Groenlândia'' WHERE Sigla = ''GL''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Gâmbia'' WHERE Sigla = ''GM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Guiné'' WHERE Sigla = ''GN''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Guadalupe'' WHERE Sigla = ''GP''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Guiné Equatorial'' WHERE Sigla = ''GQ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Grécia'' WHERE Sigla = ''GR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Geórgia do Sul e Sandwich do Sul'' WHERE Sigla = ''GS''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Guatemala'' WHERE Sigla = ''GT''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Guam'' WHERE Sigla = ''GU''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Guiné-Bissau'' WHERE Sigla = ''GW''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Guiana'' WHERE Sigla = ''GY''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Hong Kong'' WHERE Sigla = ''HK''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilha Heard e Ilhas McDonald'' WHERE Sigla = ''HM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Honduras'' WHERE Sigla = ''HN''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Croácia'' WHERE Sigla = ''HR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Haiti'' WHERE Sigla = ''HT''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''HU'' WHERE Sigla = ''HU''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Indonésia'' WHERE Sigla = ''ID''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Irlanda'' WHERE Sigla = ''IE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Israel'' WHERE Sigla = ''IL''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Isle of Man'' WHERE Sigla = ''IM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''IN'' WHERE Sigla = ''IN''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Território Britânico do Oceano Índico'' WHERE Sigla = ''IO''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Iraque'' WHERE Sigla = ''IQ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Irão, República Islâmica do'' WHERE Sigla = ''IR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''IS'' WHERE Sigla = ''IS''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''IT'' WHERE Sigla = ''IT''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''IT'' WHERE Sigla = ''Itália''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''camisola'' WHERE Sigla = ''JE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Jamaica'' WHERE Sigla = ''JM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Jordânia'' WHERE Sigla = ''JO''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Japão'' WHERE Sigla = ''JP''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Quênia'' WHERE Sigla = ''KE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Quirguistão'' WHERE Sigla = ''KG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Camboja'' WHERE Sigla = ''KH''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Kiribati'' WHERE Sigla = ''KI''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Comores'' WHERE Sigla = ''KM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''São Cristóvão e Nevis'' WHERE Sigla = ''KN''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Coreia do Sul, Popular Democrática da'' WHERE Sigla = ''KP''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Republica da Coréia'' WHERE Sigla = ''KR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Kuweit'' WHERE Sigla = ''KW''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilhas Cayman'' WHERE Sigla = ''KY''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Cazaquistão'' WHERE Sigla = ''KZ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''República Democrática Popular do Laos'' WHERE Sigla = ''LA''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Líbano'' WHERE Sigla = ''LB''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Santa Lúcia'' WHERE Sigla = ''LC''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Liechtenstein'' WHERE Sigla = ''LI''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Sri Lanka'' WHERE Sigla = ''LK''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Libéria'' WHERE Sigla = ''LR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Lesoto'' WHERE Sigla = ''LS''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Lituânia'' WHERE Sigla = ''LT''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Luxemburgo'' WHERE Sigla = ''LU''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Letônia'' WHERE Sigla = ''LV''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Líbia'' WHERE Sigla = ''LY''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Marrocos'' WHERE Sigla = ''MA''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Monaco'' WHERE Sigla = ''MC''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Moldávia, República da'' WHERE Sigla = ''MD''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''ME'' WHERE Sigla = ''ME''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Saint Martin (parte francesa)'' WHERE Sigla = ''MF''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Madagáscar'' WHERE Sigla = ''MG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilhas Marshall'' WHERE Sigla = ''MH''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Macedônia, a antiga República Jugoslava da'' WHERE Sigla = ''MK''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Mali'' WHERE Sigla = ''ML''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Myanmar'' WHERE Sigla = ''MM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Mongólia'' WHERE Sigla = ''MN''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Macau'' WHERE Sigla = ''MO''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''MP'' WHERE Sigla = ''MP''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Martinique'' WHERE Sigla = ''MQ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Mauritânia'' WHERE Sigla = ''MR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Montserrat'' WHERE Sigla = ''MS''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Malta'' WHERE Sigla = ''MT''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Mauritius'' WHERE Sigla = ''MU''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Maldivas'' WHERE Sigla = ''MV''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Malavi'' WHERE Sigla = ''MW''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''México'' WHERE Sigla = ''MX''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Malásia'' WHERE Sigla = ''MY''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Moçambique'' WHERE Sigla = ''MZ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Namíbia'' WHERE Sigla = ''NA''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Nova Caledônia'' WHERE Sigla = ''NC''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Níger'' WHERE Sigla = ''NE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilha Norfolk'' WHERE Sigla = ''NF''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Nigéria'' WHERE Sigla = ''NG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Nicarágua'' WHERE Sigla = ''NI''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''países Baixos'' WHERE Sigla = ''NL''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Noruega'' WHERE Sigla = ''NO''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Nepal'' WHERE Sigla = ''NP''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Nauru'' WHERE Sigla = ''NR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Niue'' WHERE Sigla = ''NU''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Nova Zelândia'' WHERE Sigla = ''NZ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Omã'' WHERE Sigla = ''OM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Panamá'' WHERE Sigla = ''PA''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Peru'' WHERE Sigla = ''PE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Polinésia Francesa'' WHERE Sigla = ''PF''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Papua Nova Guiné'' WHERE Sigla = ''PG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Filipinas'' WHERE Sigla = ''PH''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Paquistão'' WHERE Sigla = ''PK''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Polônia'' WHERE Sigla = ''PL''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Saint Pierre e Miquelon'' WHERE Sigla = ''PM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Pitcairn'' WHERE Sigla = ''PN''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Porto Rico'' WHERE Sigla = ''PR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Palestina, Estado de'' WHERE Sigla = ''PS''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Portugal'' WHERE Sigla = ''PT''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Palau'' WHERE Sigla = ''PW''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Paraguai'' WHERE Sigla = ''PY''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Catar'' WHERE Sigla = ''QA''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Reunião'' WHERE Sigla = ''RE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Romênia'' WHERE Sigla = ''RO''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Sérvia'' WHERE Sigla = ''RS''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Federação Russa'' WHERE Sigla = ''RU''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ruanda'' WHERE Sigla = ''RW''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Arábia Saudita'' WHERE Sigla = ''SA''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilhas Salomão'' WHERE Sigla = ''SB''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Seychelles'' WHERE Sigla = ''SC''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Sudão'' WHERE Sigla = ''SD''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Suécia'' WHERE Sigla = ''SE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Cingapura'' WHERE Sigla = ''SG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Santa Helena, Ascensão e Tristão da Cunha'' WHERE Sigla = ''SH''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Eslovenia'' WHERE Sigla = ''SI''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Svalbard e Jan Mayen'' WHERE Sigla = ''SJ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Eslováquia'' WHERE Sigla = ''SK''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Serra Leoa'' WHERE Sigla = ''SL''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''San Marino'' WHERE Sigla = ''SM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Senegal'' WHERE Sigla = ''SN''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Somália'' WHERE Sigla = ''SO''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Suriname'' WHERE Sigla = ''SR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Sudão do Sul'' WHERE Sigla = ''SS''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''São Tomé e Príncipe'' WHERE Sigla = ''ST''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''El Salvador'' WHERE [Sigla] = ''SV''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Sint Maarten (parte holandesa)'' WHERE [Sigla] = ''SX''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''República Árabe da Síria'' WHERE [Sigla] = ''SY''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Suazilândia'' WHERE [Sigla] = ''SZ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilhas Turks e Caicos'' WHERE [Sigla] = ''TC''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Chade'' WHERE [Sigla] = ''TD''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Territórios Franceses do Sul'' WHERE [Sigla] = ''TF''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ir'' WHERE [Sigla] = ''TG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Tailândia'' WHERE [Sigla] = ''TH''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Tajiquistão'' WHERE [Sigla] = ''TJ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Sint Maarten (parte holandesa)'' WHERE [Sigla] = ''TK''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Sint Maarten (parte holandesa)'' WHERE [Sigla] = ''SX''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Tajiquistão'' WHERE [Sigla] = ''TJ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Tokelau'' WHERE [Sigla] = ''TK''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Timor-Leste'' WHERE [Sigla] = ''TL''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Turquemenistão'' WHERE [Sigla] = ''TM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Turquemenistão'' WHERE [Sigla] = ''TN''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''TO'' WHERE [Sigla] = ''TO''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Peru'' WHERE [Sigla] = ''TR''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Portugal'' WHERE [Sigla] = ''PT''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Trinidad e Tobago'' WHERE [Sigla] = ''TT''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Tuvalu'' WHERE [Sigla] = ''TV''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Taiwan, Província da China'' WHERE [Sigla] = ''TW''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Tanzânia, República Unida da'' WHERE [Sigla] = ''TZ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ucrânia'' WHERE [Sigla] = ''UA''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Uganda'' WHERE [Sigla] = ''UG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Estados Unidos Ilhas Menores Distantes'' WHERE [Sigla] = ''UM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Estados Unidos da America'' WHERE [Sigla] = ''US''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Uruguai'' WHERE [Sigla] = ''UY''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Uzbequistão'' WHERE [Sigla] = ''UZ''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Santa Sé'' WHERE [Sigla] = ''VA''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''São Vicente e Granadinas'' WHERE [Sigla] = ''VC''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Venezuela, República Bolivariana da'' WHERE [Sigla] = ''VE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilhas Virgens Britânicas'' WHERE [Sigla] = ''VG''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Ilhas Virgens, EUA'' WHERE [Sigla] = ''VI''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Viet Nam'' WHERE [Sigla] = ''VN''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Vanuatu'' WHERE [Sigla] = ''VU''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Wallis e Futuna'' WHERE [Sigla] = ''WF''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Samoa'' WHERE [Sigla] = ''WS''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Kosovo'' WHERE [Sigla] = ''XK''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Iémen'' WHERE [Sigla] = ''YE''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Mayotte'' WHERE [Sigla] = ''YT''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''África do Sul'' WHERE [Sigla] = ''ZA''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Zâmbia'' WHERE [Sigla] = ''ZM''')
EXEC('UPDATE [tbSistemaSiglasPaises] SET DescricaoPais = ''Zimbábue'' WHERE [Sigla] = ''ZW''')


CREATE TABLE [dbo].[tbSistemaNaturezas](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Modulo] [nvarchar](10) NOT NULL,
	[TipoDoc] [nvarchar](50) NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaNaturezas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

                              
Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (1, 'E', 'Entrada', '001', '', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (2, 'S', 'Saida', '001', '', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (3, 'ES', 'EntradaSaida', '001', '', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (4, 'R', 'AReceber', '004', 'VndTransporte', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (5, 'P', 'APagar', '004', 'VndTransporte', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (6, 'R', 'AReceber', '004', 'VndFinanceiro', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (7, 'P', 'APagar', '004', 'VndFinanceiro', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (8, 'R', 'AReceber', '004', 'VndOrcamento', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (9, 'R', 'AReceber', '004', 'VndEncomenda', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (10, 'P', 'APagar', '003', 'CmpTransporte', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (11, 'R', 'AReceber', '003', 'CmpTransporte', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (12, 'P', 'APagar', '003', 'CmpFinanceiro', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (13, 'R', 'AReceber', '003', 'CmpFinanceiro', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (14, 'P', 'APagar', '003', 'CmpOrcamento', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (15, 'P', 'APagar', '003', 'CmpEncomenda', 'True', 'True', '2016-12-09' , 'f3m')

Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao)
Values (16, 'P', 'APagar', '004', 'VndServico', 'True', 'True', '2016-12-09' , 'f3m')

CREATE TABLE [dbo].[tbSistemaEstadoCivil](
       [ID] [bigint] NOT NULL,
       [Codigo] [nvarchar](3) NOT NULL,
       [Descricao] [nvarchar](50) NOT NULL,
       [Ativo] [bit] NOT NULL,
       [Sistema] [bit] NOT NULL,
       [DataCriacao] [datetime] NOT NULL,
       [UtilizadorCriacao] [nvarchar](256) NOT NULL,
       [DataAlteracao] [datetime] NULL,
       [UtilizadorAlteracao] [nvarchar](256) NULL,
       [F3MMarcador] [timestamp] NULL,
CONSTRAINT [PK_tbSistemaEstadoCivil] PRIMARY KEY CLUSTERED 
(
       [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbSistemaEstadoCivil] ADD  CONSTRAINT [DF_tbSistemaEstadoCivil_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbSistemaEstadoCivil] ADD  CONSTRAINT [DF_tbSistemaEstadoCivil_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbSistemaEstadoCivil] ADD  CONSTRAINT [DF_tbSistemaEstadoCivil_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbSistemaEstadoCivil] ADD  CONSTRAINT [DF_tbSistemaEstadoCivil_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbSistemaEstadoCivil] ADD  CONSTRAINT [DF_tbSistemaEstadoCivil_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbSistemaEstadoCivil] ADD  CONSTRAINT [DF_tbSistemaEstadoCivil_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

CREATE NONCLUSTERED INDEX [IX_tbSistemaEstadoCivil] ON [dbo].[tbSistemaEstadoCivil]
(
       [Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

INSERT [dbo].[tbSistemaEstadoCivil] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'S', N'Solteiro', 1, 0, getdate(), N'F3M',null, null)
INSERT [dbo].[tbSistemaEstadoCivil] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N'C', N'Casado', 1, 0, getdate(), N'F3M',null, null)
INSERT [dbo].[tbSistemaEstadoCivil] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N'D', N'Divorciado', 1, 0, getdate(), N'F3M',null, null)
INSERT [dbo].[tbSistemaEstadoCivil] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, N'V', N'Viúvo', 1, 0, getdate(), N'F3M',null, null)
INSERT [dbo].[tbSistemaEstadoCivil] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (5, N'O', N'Outros', 1, 0, getdate(), N'F3M',null, null)

CREATE TABLE [dbo].[tbSistemaParentesco](
       [ID] [bigint] NOT NULL,
       [Codigo] [nvarchar](3) NOT NULL,
       [Descricao] [nvarchar](50) NOT NULL,
       [Ativo] [bit] NOT NULL,
       [Sistema] [bit] NOT NULL,
       [DataCriacao] [datetime] NOT NULL,
       [UtilizadorCriacao] [nvarchar](256) NOT NULL,
       [DataAlteracao] [datetime] NULL,
       [UtilizadorAlteracao] [nvarchar](256) NULL,
       [F3MMarcador] [timestamp] NULL,
CONSTRAINT [PK_tbSistemaParentesco] PRIMARY KEY CLUSTERED 
(
       [ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[tbSistemaParentesco] ADD  CONSTRAINT [DF_tbSistemaParentesco_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbSistemaParentesco] ADD  CONSTRAINT [DF_tbSistemaParentesco_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbSistemaParentesco] ADD  CONSTRAINT [DF_tbSistemaParentesco_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbSistemaParentesco] ADD  CONSTRAINT [DF_tbSistemaParentesco_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbSistemaParentesco] ADD  CONSTRAINT [DF_tbSistemaParentesco_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbSistemaParentesco] ADD  CONSTRAINT [DF_tbSistemaParentesco_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

INSERT INTO [dbo].[tbSistemaParentesco]([ID],[Codigo],[Descricao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES(1, '1', N'PAIMAE', 1, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT INTO [dbo].[tbSistemaParentesco]([ID],[Codigo],[Descricao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES(2, '2', N'FILHOFILHA', 1, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT INTO [dbo].[tbSistemaParentesco]([ID],[Codigo],[Descricao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES(3, '3', N'IRMAOIRMA', 1, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT INTO [dbo].[tbSistemaParentesco]([ID],[Codigo],[Descricao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES(4, '4', N'CONJUGE', 1, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT INTO [dbo].[tbSistemaParentesco]([ID],[Codigo],[Descricao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES(5, '5', N'TIOTIA', 1, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT INTO [dbo].[tbSistemaParentesco]([ID],[Codigo],[Descricao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES(6, '6', N'SOBRINHOSOBRINHA', 1, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT INTO [dbo].[tbSistemaParentesco]([ID],[Codigo],[Descricao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES(7, '7', N'AVOAVO', 1, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT INTO [dbo].[tbSistemaParentesco]([ID],[Codigo],[Descricao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES(8, '8', N'NETONETA', 1, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT INTO [dbo].[tbSistemaParentesco]([ID],[Codigo],[Descricao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES(9, '9', N'PADRASTOMADRASTA', 1, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT INTO [dbo].[tbSistemaParentesco]([ID],[Codigo],[Descricao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES(10, '10', N'PARCEIROPARCEIRA', 1, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT INTO [dbo].[tbSistemaParentesco]([ID],[Codigo],[Descricao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES(11, '11', N'ENTEADOENTEADA', 1, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT INTO [dbo].[tbSistemaParentesco]([ID],[Codigo],[Descricao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES(12, '12', N'OUTRO', 1, 1, GETDATE(), N'F3M', NULL, NULL)

EXEC('Update tbSistemaTiposDocumento set Ativo = 0 Where Tipo = ''StkTransfArtComp''')