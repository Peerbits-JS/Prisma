--Artigos
drop table tbArtigosStock

CREATE TABLE [dbo].[tbArtigosStock](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[PrimeiraEntrada] [datetime] NULL,
	[UltimaEntrada] [datetime] NULL,
	[PrimeiraSaida] [datetime] NULL,
	[UltimaSaida] [datetime] NULL,
	[Atual] [float] NULL,
	[Reservado] [float] NULL,
	[Sistema] [bit] NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[StockAtual2] [float] NULL,
	[IDArtigo] [bigint] NULL,
	[Reservado2] [float] NULL,
 CONSTRAINT [PK_tbArtigosStock] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[tbCCStockArtigos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Natureza] [nvarchar](2) NULL,
	[IDLoja] [bigint] NULL,
	[IDArmazem] [bigint] NULL,
	[IDArmazemLocalizacao] [bigint] NULL,
	[IDArtigoLote] [bigint] NULL,
	[IDArtigoNumeroSerie] [bigint] NULL,
	[IDArtigoDimensao] [bigint] NULL,
	[IDMoeda] [bigint] NULL,
	[IDTipoEntidade] [bigint] NULL,
	[IDEntidade] [bigint] NULL,
	[IDTipoDocumento] [bigint] NULL,
	[IDDocumento] [bigint] NULL,
	[IDLinhaDocumento] [bigint] NULL,
	[NumeroDocumento] [nvarchar](100) NULL,
	[IDTipoDocumentoOrigem] [bigint] NULL,
	[IDDocumentoOrigem] [bigint] NULL,
	[IDLinhaDocumentoOrigem] [bigint] NULL,
	[DataDocumento] [datetime] NULL,
	[Quantidade] [float] NULL,
	[QuantidadeStock] [float] NULL,
	[QuantidadeStock2] [float] NULL,
	[QtdStockAnterior] [float] NULL,
	[QtdStockAtual] [float] NULL,
	[TaxaConversao] [float] NULL,
	[PrecoUnitario] [float] NULL,
	[PrecoUnitarioEfetivo] [float] NULL,
	[PrecoUnitarioMoedaRef] [float] NULL,
	[PrecoUnitarioEfetivoMoedaRef] [float] NULL,
	[UPCMoedaRef] [float] NULL,
	[PCMAnteriorMoedaRef] [float] NULL,
	[PCMAtualMoedaRef] [float] NULL,
	[PVMoedaRef] [float] NULL,
	[Recalcular] [bit] NULL,
	[QtdAfetacaoStock] [float] NULL,
	[QtdAfetacaoStock2] [float] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbCCStockArtigos_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbCCStockArtigos_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbCCStockArtigos_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbCCStockArtigos_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbCCStockArtigos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbCCStockArtigos_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
	[UPCompraMoedaRef] [float] NULL,
	[UltCustosAdicionaisMoedaRef] [float] NULL,
	[UltDescComerciaisMoedaRef] [float] NULL,
	[DataControloInterno] [datetime] NULL,
 CONSTRAINT [PK_tbCCStockArtigos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[tbStockArtigos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDLoja] [bigint] NULL,
	[IDArmazem] [bigint] NULL,
	[IDArmazemLocalizacao] [bigint] NULL,
	[IDArtigoLote] [bigint] NULL,
	[IDArtigoNumeroSerie] [bigint] NULL,
	[IDArtigoDimensao] [bigint] NULL,
	[Quantidade] [float] NULL,
	[QuantidadeStock] [float] NULL,
	[QuantidadeStock2] [float] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbStockArtigos_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbStockArtigos_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbStockArtigos_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbStockArtigos_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbStockArtigos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbStockArtigos_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
	[QuantidadeReservada] [float] NULL,
	[QuantidadeReservada2] [float] NULL,
 CONSTRAINT [PK_tbStockArtigos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[tbArtigosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosStock_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbArtigosStock] CHECK CONSTRAINT [FK_tbArtigosStock_tbArtigos]

ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_IDArmazem] FOREIGN KEY([IDArmazem])
REFERENCES [dbo].[tbArmazens] ([ID])

ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_IDArmazem]

ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_IDArmazemLocalizacao] FOREIGN KEY([IDArmazemLocalizacao])
REFERENCES [dbo].[tbArmazensLocalizacoes] ([ID])

ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_IDArmazemLocalizacao]

ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_IDArtigo] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_IDArtigo]

ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_IDArtigoDimensao] FOREIGN KEY([IDArtigoDimensao])
REFERENCES [dbo].[tbArtigosDimensoes] ([ID])

ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_IDArtigoDimensao]

ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_IDArtigoLote] FOREIGN KEY([IDArtigoLote])
REFERENCES [dbo].[tbArtigosLotes] ([ID])

ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_IDArtigoLote]

ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_IDArtigoNumeroSerie] FOREIGN KEY([IDArtigoNumeroSerie])
REFERENCES [dbo].[tbArtigosNumerosSeries] ([ID])

ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_IDArtigoNumeroSerie]

ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_IDMoeda] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_IDMoeda]

ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_IDTipoDocumento] FOREIGN KEY([IDTipoDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_IDTipoDocumento]

ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_IDTipoDocumentoOrigem] FOREIGN KEY([IDTipoDocumentoOrigem])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_IDTipoDocumentoOrigem]

ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_IDTipoEntidade] FOREIGN KEY([IDTipoEntidade])
REFERENCES [dbo].[tbSistemaTiposEntidade] ([ID])

ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_IDTipoEntidade]

ALTER TABLE [dbo].[tbStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigos_IDArmazem] FOREIGN KEY([IDArmazem])
REFERENCES [dbo].[tbArmazens] ([ID])

ALTER TABLE [dbo].[tbStockArtigos] CHECK CONSTRAINT [FK_tbStockArtigos_IDArmazem]

ALTER TABLE [dbo].[tbStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigos_IDArmazemLocalizacao] FOREIGN KEY([IDArmazemLocalizacao])
REFERENCES [dbo].[tbArmazensLocalizacoes] ([ID])

ALTER TABLE [dbo].[tbStockArtigos] CHECK CONSTRAINT [FK_tbStockArtigos_IDArmazemLocalizacao]

ALTER TABLE [dbo].[tbStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigos_IDArtigo] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbStockArtigos] CHECK CONSTRAINT [FK_tbStockArtigos_IDArtigo]

ALTER TABLE [dbo].[tbStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigos_IDArtigoDimensao] FOREIGN KEY([IDArtigoDimensao])
REFERENCES [dbo].[tbArtigosDimensoes] ([ID])

ALTER TABLE [dbo].[tbStockArtigos] CHECK CONSTRAINT [FK_tbStockArtigos_IDArtigoDimensao]

ALTER TABLE [dbo].[tbStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigos_IDArtigoLote] FOREIGN KEY([IDArtigoLote])
REFERENCES [dbo].[tbArtigosLotes] ([ID])

ALTER TABLE [dbo].[tbStockArtigos] CHECK CONSTRAINT [FK_tbStockArtigos_IDArtigoLote]

ALTER TABLE [dbo].[tbStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigos_IDArtigoNumeroSerie] FOREIGN KEY([IDArtigoNumeroSerie])
REFERENCES [dbo].[tbArtigosNumerosSeries] ([ID])

ALTER TABLE [dbo].[tbStockArtigos] CHECK CONSTRAINT [FK_tbStockArtigos_IDArtigoNumeroSerie]

--Documentos Stock

CREATE TABLE [dbo].[tbDocumentosStock](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTipoDocumento] [bigint] NOT NULL,
	[NumeroDocumento] [bigint] NULL,
	[DataDocumento] [datetime] NOT NULL,
	[Observacoes] [nvarchar](max) NULL,
	[IDMoeda] [bigint] NULL,
	[TaxaConversao] [float] NULL,
	[TotalMoedaDocumento] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[LocalCarga] [nvarchar](50) NULL,
	[DataCarga] [datetime] NULL,
	[HoraCarga] [datetime] NULL,
	[MoradaCarga] [nvarchar](100) NULL,
	[IDCodigoPostalCarga] [bigint] NULL,
	[IDConcelhoCarga] [bigint] NULL,
	[IDDistritoCarga] [bigint] NULL,
	[LocalDescarga] [nvarchar](50) NULL,
	[DataDescarga] [datetime] NULL,
	[HoraDescarga] [datetime] NULL,
	[MoradaDescarga] [nvarchar](100) NULL,
	[IDCodigoPostalDescarga] [bigint] NULL,
	[IDConcelhoDescarga] [bigint] NULL,
	[IDDistritoDescarga] [bigint] NULL,
	[NomeDestinatario] [nvarchar](100) NULL,
	[MoradaDestinatario] [nvarchar](100) NULL,
	[IDCodigoPostalDestinatario] [bigint] NULL,
	[IDConcelhoDestinatario] [bigint] NULL,
	[IDDistritoDestinatario] [bigint] NULL,
	[SerieDocManual] [nvarchar](6) NULL,
	[NumeroDocManual] [nvarchar](10) NULL,
	[NumeroLinhas] [bigint] NULL,
	[Posto] [nvarchar](512) NULL,
	[IDEstado] [bigint] NULL,
	[UtilizadorEstado] [nvarchar](20) NULL,
	[DataHoraEstado] [datetime] NULL,
	[Assinatura] [nvarchar](255) NULL,
	[VersaoChavePrivada] [int] NULL,
	[NomeFiscal] [nvarchar](200) NULL,
	[MoradaFiscal] [nvarchar](100) NULL,
	[IDCodigoPostalFiscal] [bigint] NULL,
	[IDConcelhoFiscal] [bigint] NULL,
	[IDDistritoFiscal] [bigint] NULL,
	[ContribuinteFiscal] [nvarchar](25) NULL,
	[SiglaPaisFiscal] [nvarchar](15) NULL,
	[IDLoja] [bigint] NULL,
	[Impresso] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosStock_Impresso]  DEFAULT ((0)),
	[ValorImposto] [float] NULL,
	[PercentagemDesconto] [float] NULL,
	[ValorDesconto] [float] NULL,
	[ValorPortes] [float] NULL,
	[IDTaxaIvaPortes] [bigint] NULL,
	[TaxaIvaPortes] [float] NULL,
	[MotivoIsencaoIva] [nvarchar](255) NULL,
	[MotivoIsencaoPortes] [nvarchar](255) NULL,
	[IDEspacoFiscalPortes] [bigint] NULL,
	[EspacoFiscalPortes] [nvarchar](50) NULL,
	[IDRegimeIvaPortes] [bigint] NULL,
	[RegimeIvaPortes] [nvarchar](50) NULL,
	[CustosAdicionais] [float] NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosStock_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosStock_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbDocumentosStock_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](20) NOT NULL CONSTRAINT [DF_tbDocumentosStock_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbDocumentosStock_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL CONSTRAINT [DF_tbDocumentosStock_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
	[IDFormaExpedicao] [bigint] NULL,
	[IDTiposDocumentoSeries] [bigint] NOT NULL,
	[NumeroInterno] [bigint] NULL,
	[IDEntidade] [bigint] NULL DEFAULT ((1)),
	[IDTipoEntidade] [bigint] NULL DEFAULT ((3)),
	[IDCondicaoPagamento] [bigint] NULL DEFAULT ((13)),
	[IDLocalOperacao] [bigint] NULL DEFAULT ((1)),
	[CodigoAT] [nvarchar](200) NULL,
	[IDPaisCarga] [bigint] NULL,
	[IDPaisDescarga] [bigint] NULL,
	[Matricula] [nvarchar](50) NULL,
	[IDPaisFiscal] [bigint] NULL,
	[CodigoPostalFiscal] [nvarchar](10) NULL,
	[DescricaoCodigoPostalFiscal] [nvarchar](50) NULL,
	[DescricaoConcelhoFiscal] [nvarchar](50) NULL,
	[DescricaoDistritoFiscal] [nvarchar](50) NULL,
	[IDEspacoFiscal] [bigint] NULL,
	[IDRegimeIva] [bigint] NULL,
	[CodigoATInterno] [nvarchar](200) NULL,
	[TipoFiscal] [nvarchar](20) NULL,
	[Documento] [nvarchar](255) NULL,
	[CodigoTipoEstado] [nvarchar](20) NULL,
	[CodigoDocOrigem] [nvarchar](255) NULL,
	[DistritoCarga] [nvarchar](255) NULL,
	[ConcelhoCarga] [nvarchar](255) NULL,
	[CodigoPostalCarga] [nvarchar](20) NULL,
	[SiglaPaisCarga] [nvarchar](6) NULL,
	[DistritoDescarga] [nvarchar](255) NULL,
	[ConcelhoDescarga] [nvarchar](255) NULL,
	[CodigoPostalDescarga] [nvarchar](20) NULL,
	[SiglaPaisDescarga] [nvarchar](6) NULL,
	[CodigoEntidade] [nvarchar](20) NULL,
	[CodigoMoeda] [nvarchar](20) NULL,
	[MensagemDocAT] [nvarchar](1000) NULL,
	[IDSisTiposDocPU] [bigint] NULL,
	[CodigoSisTiposDocPU] [nvarchar](6) NULL,
	[DocManual] [bit] NULL,
	[DocReposicao] [bit] NULL,
	[DataAssinatura] [datetime] NULL,
	[DataControloInterno] [datetime] NULL,
	[SubTotal] [float] NULL,
	[DescontosLinha] [float] NULL, 
	[TotalIVA] [float] NULL,
	[DataVencimento] [datetime] NULL,
 CONSTRAINT [PK_tbDocumentosStock] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[tbDocumentosStockAnexos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDDocumentoStock] [bigint] NOT NULL,
	[IDTipoAnexo] [bigint] NULL,
	[Descricao] [nvarchar](255) NULL,
	[FicheiroOriginal] [nvarchar](255) NULL,
	[Ficheiro] [nvarchar](255) NOT NULL,
	[FicheiroThumbnail] [nvarchar](300) NULL,
	[Caminho] [nvarchar](max) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbDocumentosStockAnexos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tbDocumentosStockAnexos] UNIQUE NONCLUSTERED 
(
	[IDDocumentoStock] ASC,
	[Ficheiro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[tbDocumentosStockLinhas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDDocumentoStock] [bigint] NOT NULL,
	[IDArtigo] [bigint] NULL,
	[Descricao] [nvarchar](200) NOT NULL,
	[IDUnidade] [bigint] NULL,
	[NumCasasDecUnidade] [smallint] NULL,
	[Quantidade] [float] NULL,
	[PrecoUnitario] [float] NULL,
	[PrecoUnitarioEfetivo] [float] NULL,
	[PrecoTotal] [float] NULL,
	[Observacoes] [nvarchar](max) NULL,
	[IDLote] [bigint] NULL,
	[CodigoLote] [nvarchar](50) NULL,
	[DescricaoLote] [nvarchar](100) NULL,
	[DataFabricoLote] [datetime] NULL,
	[DataValidadeLote] [datetime] NULL,
	[IDArtigoNumSerie] [bigint] NULL,
	[ArtigoNumSerie] [nvarchar](20) NULL,
	[IDArmazem] [bigint] NULL,
	[IDArmazemLocalizacao] [bigint] NULL,
	[IDArmazemDestino] [bigint] NULL,
	[IDArmazemLocalizacaoDestino] [bigint] NULL,
	[NumLinhasDimensoes] [bigint] NULL,
	[Desconto1] [float] NULL,
	[Desconto2] [float] NULL,
	[IDTaxaIva] [bigint] NULL,
	[TaxaIva] [float] NULL,
	[MotivoIsencaoIva] [nvarchar](255) NULL,
	[IDEspacoFiscal] [bigint] NULL,
	[EspacoFiscal] [nvarchar](50) NULL,
	[IDRegimeIva] [bigint] NULL,
	[RegimeIva] [nvarchar](50) NULL,
	[SiglaPais] [nvarchar](15) NULL,
	[Ordem] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosStockLinhas_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosStockLinhas_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbDocumentosStockLinhas_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](20) NOT NULL CONSTRAINT [DF_tbDocumentosStockLinhas_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbDocumentosStockLinhas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL CONSTRAINT [DF_tbDocumentosStockLinhas_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
	[IDUnidadeStock] [bigint] NULL,
	[IDUnidadeStock2] [bigint] NULL,
	[QuantidadeStock] [float] NULL,
	[QuantidadeStock2] [float] NULL,
	[ValorIva] [float] NULL,
	[ValorIncidencia] [float] NULL,
	[PrecoUnitarioMoedaRef] [float] NULL,
	[PrecoUnitarioEfetivoMoedaRef] [float] NULL,
	[QtdStockAnterior] [float] NULL,
	[QtdStockAtual] [float] NULL,
	[UPCMoedaRef] [float] NULL,
	[PCMAnteriorMoedaRef] [float] NULL,
	[PCMAtualMoedaRef] [float] NULL,
	[PVMoedaRef] [float] NULL,
	[Alterada] [bit] NULL,
	[DataDocOrigem] [datetime] NULL,
	[ValorizouOrigem] [bit] NULL,
	[MovStockOrigem] [bit] NULL,
	[IDTipoDocumentoOrigem] [bigint] NULL,
	[IDDocumentoOrigem] [bigint] NULL,
	[IDLinhaDocumentoOrigem] [bigint] NULL,
	[NumCasasDecUnidadeStk] [smallint] NULL,
	[NumCasasDec2UnidadeStk] [smallint] NULL,
	[FatorConvUnidStk] [float] NULL,
	[FatorConv2UnidStk] [float] NULL,
	[QtdStockAnteriorOrigem] [float] NULL,
	[QtdStockAtualOrigem] [float] NULL,
	[PCMAnteriorMoedaRefOrigem] [float] NULL,
	[QtdAfetacaoStock] [float] NULL,
	[QtdAfetacaoStock2] [float] NULL,
	[CodigoTaxaIva] [nvarchar](6) NULL,
	[IDTipoIva] [bigint] NULL,
	[OperacaoConvUnidStk] [nvarchar](50) NULL,
	[OperacaoConv2UnidStk] [nvarchar](50) NULL,
	[IDTipoPreco] [bigint] NULL,
	[CodigoTipoPreco] [nvarchar](6) NULL,
	[IDCodigoIva] [bigint] NULL,
	[CodigoArtigo] [nvarchar](255) NULL,
	[CodigoBarrasArtigo] [nvarchar](255) NULL,
	[CodigoUnidade] [nvarchar](20) NULL,
	[CodigoTipoIva] [nvarchar](20) NULL,
	[CodigoRegiaoIva] [nvarchar](20) NULL,
	[UPCompraMoedaRef] [float] NULL,
	[UltCustosAdicionaisMoedaRef] [float] NULL,
	[UltDescComerciaisMoedaRef] [float] NULL,
	[PercIncidencia] [float] NULL,
	[PercDeducao] [float] NULL,
	[ValorIvaDedutivel] [float] NULL,
	[PrecoUnitarioEfetivoMoedaRefOrigem] [float] NULL,
	[CodigoMotivoIsencaoIva] nvarchar(6) NULL,
	[QuantidadeSatisfeita] [float] NULL, 
	[QuantidadeDevolvida] [float] NULL,
	[DocumentoOrigem] [nvarchar](255) NULL,
 CONSTRAINT [PK_tbDocumentosStockLinhas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[tbDocumentosStockLinhasDimensoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDDocumentoStockLinha] [bigint] NOT NULL,
	[IDArtigoDimensao] [bigint] NOT NULL,
	[Quantidade] [float] NULL,
	[PrecoUnitario] [float] NULL,
	[PrecoUnitarioEfetivo] [float] NULL,
	[Ordem] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosStockLinhasDimensoes_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosStockLinhasDimensoes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbDocumentosStockLinhasDimensoes_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](20) NOT NULL CONSTRAINT [DF_tbDocumentosStockLinhasDimensoes_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbDocumentosStockLinhasDimensoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL CONSTRAINT [DF_tbDocumentosStockLinhasDimensoes_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
	[QuantidadeStock] [float] NULL,
	[QuantidadeStock2] [float] NULL,
	[PrecoUnitarioMoedaRef] [float] NULL,
	[PrecoUnitarioEfetivoMoedaRef] [float] NULL,
	[QtdStockAnterior] [float] NULL,
	[QtdStockAtual] [float] NULL,
	[UPCMoedaRef] [float] NULL,
	[PCMAnteriorMoedaRef] [float] NULL,
	[PCMAtualMoedaRef] [float] NULL,
	[PVMoedaRef] [float] NULL,
	[Alterada] [bit] NULL,
	[QtdStockAnteriorOrigem] [float] NULL,
	[QtdStockAtualOrigem] [float] NULL,
	[PCMAnteriorMoedaRefOrigem] [float] NULL,
	[QtdAfetacaoStock] [float] NULL,
	[QtdAfetacaoStock2] [float] NULL,
	[CodigoArtigo] [nvarchar](255) NULL,
	[CodigoBarrasArtigo] [nvarchar](255) NULL,
	[UPCompraMoedaRef] [float] NULL,
	[UltCustosAdicionaisMoedaRef] [float] NULL,
	[UltDescComerciaisMoedaRef] [float] NULL,
	[ValorIva] [float] NULL,
	[ValorIvaDedutivel] [float] NULL,
	[ValorIncidencia] [float] NULL,
	[PrecoUnitarioEfetivoMoedaRefOrigem] [float] NULL,
 CONSTRAINT [PK_tbDocumentosStockLinhasDimensoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbDocumentosStockAnexos] ADD  CONSTRAINT [DF_tbDocumentosStockAnexos_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbDocumentosStockAnexos] ADD  CONSTRAINT [DF_tbDocumentosStockAnexos_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbClientes] FOREIGN KEY([IDEntidade])
REFERENCES [dbo].[tbClientes] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbClientes]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbCodigosPostais_Carga] FOREIGN KEY([IDCodigoPostalCarga])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbCodigosPostais_Carga]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbCodigosPostais_Descarga] FOREIGN KEY([IDCodigoPostalDescarga])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbCodigosPostais_Descarga]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbCodigosPostais_Destinatario] FOREIGN KEY([IDCodigoPostalDestinatario])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbCodigosPostais_Destinatario]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbCodigosPostais_Fiscal] FOREIGN KEY([IDCodigoPostalFiscal])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbCodigosPostais_Fiscal]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbConcelhos_Carga] FOREIGN KEY([IDConcelhoCarga])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbConcelhos_Carga]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbConcelhos_Descarga] FOREIGN KEY([IDConcelhoDescarga])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbConcelhos_Descarga]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbConcelhos_Destinatario] FOREIGN KEY([IDConcelhoDestinatario])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbConcelhos_Destinatario]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbConcelhos_Fiscal] FOREIGN KEY([IDConcelhoFiscal])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbConcelhos_Fiscal]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbCondicoesPagamento] FOREIGN KEY([IDCondicaoPagamento])
REFERENCES [dbo].[tbCondicoesPagamento] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbCondicoesPagamento]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbDistritos_Carga] FOREIGN KEY([IDDistritoCarga])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbDistritos_Carga]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbDistritos_Descarga] FOREIGN KEY([IDDistritoDescarga])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbDistritos_Descarga]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbDistritos_Destinatario] FOREIGN KEY([IDDistritoDestinatario])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbDistritos_Destinatario]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbDistritos_Fiscal] FOREIGN KEY([IDDistritoFiscal])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbDistritos_Fiscal]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbEstados] FOREIGN KEY([IDEstado])
REFERENCES [dbo].[tbEstados] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbEstados]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbFormasExpedicao] FOREIGN KEY([IDFormaExpedicao])
REFERENCES [dbo].[tbFormasExpedicao] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbFormasExpedicao]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbIVA_Portes] FOREIGN KEY([IDTaxaIvaPortes])
REFERENCES [dbo].[tbIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbIVA_Portes]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbLojas]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbMoedas]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbPaises] FOREIGN KEY([IDPaisCarga])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbPaises]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbPaises_Descarga] FOREIGN KEY([IDPaisDescarga])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbPaises_Descarga]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbPaises_Fiscal] FOREIGN KEY([IDPaisFiscal])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbPaises_Fiscal]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbSistemaEspacoFiscal] FOREIGN KEY([IDEspacoFiscalPortes])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbSistemaEspacoFiscal]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbSistemaEspacoFiscal1] FOREIGN KEY([IDEspacoFiscal])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbSistemaEspacoFiscal1]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbSistemaRegimeIVA] FOREIGN KEY([IDRegimeIvaPortes])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbSistemaRegimeIVA]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbSistemaRegimeIVA1] FOREIGN KEY([IDRegimeIva])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbSistemaRegimeIVA1]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbSistemaRegioesIVA] FOREIGN KEY([IDLocalOperacao])
REFERENCES [dbo].[tbSistemaRegioesIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbSistemaRegioesIVA]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbSistemaTiposDocumentoPrecoUnitario] FOREIGN KEY([IDSisTiposDocPU])
REFERENCES [dbo].[tbSistemaTiposDocumentoPrecoUnitario] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbSistemaTiposDocumentoPrecoUnitario]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbSistemaTiposEntidade] FOREIGN KEY([IDTipoEntidade])
REFERENCES [dbo].[tbSistemaTiposEntidade] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbSistemaTiposEntidade]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbTiposDocumento] FOREIGN KEY([IDTipoDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbTiposDocumento]

ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbTiposDocumentoSeries] FOREIGN KEY([IDTiposDocumentoSeries])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])

ALTER TABLE [dbo].[tbDocumentosStock] CHECK CONSTRAINT [FK_tbDocumentosStock_tbTiposDocumentoSeries]

ALTER TABLE [dbo].[tbDocumentosStockAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockAnexos_tbDocumentosStock] FOREIGN KEY([IDDocumentoStock])
REFERENCES [dbo].[tbDocumentosStock] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockAnexos] CHECK CONSTRAINT [FK_tbDocumentosStockAnexos_tbDocumentosStock]

ALTER TABLE [dbo].[tbDocumentosStockAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockAnexos_tbSistemaTiposAnexos] FOREIGN KEY([IDTipoAnexo])
REFERENCES [dbo].[tbSistemaTiposAnexos] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockAnexos] CHECK CONSTRAINT [FK_tbDocumentosStockAnexos_tbSistemaTiposAnexos]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_IDTipoDocumentoOrigem] FOREIGN KEY([IDTipoDocumentoOrigem])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_IDTipoDocumentoOrigem]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbArmazens] FOREIGN KEY([IDArmazem])
REFERENCES [dbo].[tbArmazens] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbArmazens]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbArmazens_Destino] FOREIGN KEY([IDArmazemDestino])
REFERENCES [dbo].[tbArmazens] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbArmazens_Destino]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbArmazensLocalizacoes] FOREIGN KEY([IDArmazemLocalizacao])
REFERENCES [dbo].[tbArmazensLocalizacoes] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbArmazensLocalizacoes]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbArmazensLocalizacoes_Destino] FOREIGN KEY([IDArmazemLocalizacaoDestino])
REFERENCES [dbo].[tbArmazensLocalizacoes] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbArmazensLocalizacoes_Destino]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbArtigos]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbArtigosLotes] FOREIGN KEY([IDLote])
REFERENCES [dbo].[tbArtigosLotes] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbArtigosLotes]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbArtigosNumerosSeries] FOREIGN KEY([IDArtigoNumSerie])
REFERENCES [dbo].[tbArtigosNumerosSeries] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbArtigosNumerosSeries]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbDocumentosStock] FOREIGN KEY([IDDocumentoStock])
REFERENCES [dbo].[tbDocumentosStock] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbDocumentosStock]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbIVA] FOREIGN KEY([IDTaxaIva])
REFERENCES [dbo].[tbIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbIVA]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbSistemaCodigosIVA] FOREIGN KEY([IDCodigoIva])
REFERENCES [dbo].[tbSistemaCodigosIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbSistemaCodigosIVA]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbSistemaEspacoFiscal] FOREIGN KEY([IDEspacoFiscal])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbSistemaEspacoFiscal]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbSistemaRegimeIVA] FOREIGN KEY([IDRegimeIva])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbSistemaRegimeIVA]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbSistemaTiposIVA] FOREIGN KEY([IDTipoIva])
REFERENCES [dbo].[tbSistemaTiposIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbSistemaTiposIVA]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbSistemaTiposPrecos] FOREIGN KEY([IDTipoPreco])
REFERENCES [dbo].[tbSistemaTiposPrecos] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbSistemaTiposPrecos]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbUnidades] FOREIGN KEY([IDUnidade])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbUnidades]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbUnidades2] FOREIGN KEY([IDUnidadeStock])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbUnidades2]

ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbUnidades3] FOREIGN KEY([IDUnidadeStock2])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbUnidades3]

ALTER TABLE [dbo].[tbDocumentosStockLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhasDimensoes_tbArtigosDimensoes] FOREIGN KEY([IDArtigoDimensao])
REFERENCES [dbo].[tbArtigosDimensoes] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosStockLinhasDimensoes_tbArtigosDimensoes]

ALTER TABLE [dbo].[tbDocumentosStockLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhasDimensoes_tbDocumentosStockLinhas] FOREIGN KEY([IDDocumentoStockLinha])
REFERENCES [dbo].[tbDocumentosStockLinhas] ([ID])

ALTER TABLE [dbo].[tbDocumentosStockLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosStockLinhasDimensoes_tbDocumentosStockLinhas]

--Documentos Compras


CREATE TABLE [dbo].[tbDocumentosCompras](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTipoDocumento] [bigint] NOT NULL,
	[NumeroDocumento] [bigint] NULL,
	[DataDocumento] [datetime] NOT NULL,
	[Observacoes] [nvarchar](max) NULL,
	[IDMoeda] [bigint] NULL,
	[TaxaConversao] [float] NULL,
	[TotalMoedaDocumento] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[LocalCarga] [nvarchar](50) NULL,
	[DataCarga] [datetime] NULL,
	[HoraCarga] [datetime] NULL,
	[MoradaCarga] [nvarchar](100) NULL,
	[IDCodigoPostalCarga] [bigint] NULL,
	[IDConcelhoCarga] [bigint] NULL,
	[IDDistritoCarga] [bigint] NULL,
	[LocalDescarga] [nvarchar](50) NULL,
	[DataDescarga] [datetime] NULL,
	[HoraDescarga] [datetime] NULL,
	[MoradaDescarga] [nvarchar](100) NULL,
	[IDCodigoPostalDescarga] [bigint] NULL,
	[IDConcelhoDescarga] [bigint] NULL,
	[IDDistritoDescarga] [bigint] NULL,
	[NomeDestinatario] [nvarchar](100) NULL,
	[MoradaDestinatario] [nvarchar](100) NULL,
	[IDCodigoPostalDestinatario] [bigint] NULL,
	[IDConcelhoDestinatario] [bigint] NULL,
	[IDDistritoDestinatario] [bigint] NULL,
	[SerieDocManual] [nvarchar](6) NULL,
	[NumeroDocManual] [nvarchar](10) NULL,
	[NumeroLinhas] [bigint] NULL,
	[Posto] [nvarchar](512) NULL,
	[IDEstado] [bigint] NULL,
	[UtilizadorEstado] [nvarchar](20) NULL,
	[DataHoraEstado] [datetime] NULL,
	[Assinatura] [nvarchar](255) NULL,
	[VersaoChavePrivada] [int] NULL,
	[NomeFiscal] [nvarchar](200) NULL,
	[MoradaFiscal] [nvarchar](100) NULL,
	[IDCodigoPostalFiscal] [bigint] NULL,
	[IDConcelhoFiscal] [bigint] NULL,
	[IDDistritoFiscal] [bigint] NULL,
	[ContribuinteFiscal] [nvarchar](25) NULL,
	[SiglaPaisFiscal] [nvarchar](15) NULL,
	[IDLoja] [bigint] NULL,
	[Impresso] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosCompras_Impresso]  DEFAULT ((0)),
	[ValorImposto] [float] NULL,
	[PercentagemDesconto] [float] NULL,
	[ValorDesconto] [float] NULL,
	[ValorPortes] [float] NULL,
	[IDTaxaIvaPortes] [bigint] NULL,
	[TaxaIvaPortes] [float] NULL,
	[MotivoIsencaoIva] [nvarchar](255) NULL,
	[MotivoIsencaoPortes] [nvarchar](255) NULL,
	[IDEspacoFiscalPortes] [bigint] NULL,
	[EspacoFiscalPortes] [nvarchar](50) NULL,
	[IDRegimeIvaPortes] [bigint] NULL,
	[RegimeIvaPortes] [nvarchar](50) NULL,
	[CustosAdicionais] [float] NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosCompras_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosCompras_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbDocumentosCompras_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](20) NOT NULL CONSTRAINT [DF_tbDocumentosCompras_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbDocumentosCompras_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL CONSTRAINT [DF_tbDocumentosCompras_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
	[IDFormaExpedicao] [bigint] NULL,
	[IDTiposDocumentoSeries] [bigint] NOT NULL,
	[NumeroInterno] [bigint] NULL,
	[IDEntidade] [bigint] NULL DEFAULT ((1)),
	[IDTipoEntidade] [bigint] NULL DEFAULT ((3)),
	[IDCondicaoPagamento] [bigint] NULL DEFAULT ((13)),
	[IDLocalOperacao] [bigint] NULL DEFAULT ((1)),
	[CodigoAT] [nvarchar](200) NULL,
	[IDPaisCarga] [bigint] NULL,
	[IDPaisDescarga] [bigint] NULL,
	[Matricula] [nvarchar](50) NULL,
	[IDPaisFiscal] [bigint] NULL,
	[CodigoPostalFiscal] [nvarchar](10) NULL,
	[DescricaoCodigoPostalFiscal] [nvarchar](50) NULL,
	[DescricaoConcelhoFiscal] [nvarchar](50) NULL,
	[DescricaoDistritoFiscal] [nvarchar](50) NULL,
	[IDEspacoFiscal] [bigint] NULL,
	[IDRegimeIva] [bigint] NULL,
	[CodigoATInterno] [nvarchar](200) NULL,
	[TipoFiscal] [nvarchar](20) NULL,
	[Documento] [nvarchar](255) NULL,
	[CodigoTipoEstado] [nvarchar](20) NULL,
	[CodigoDocOrigem] [nvarchar](255) NULL,
	[DistritoCarga] [nvarchar](255) NULL,
	[ConcelhoCarga] [nvarchar](255) NULL,
	[CodigoPostalCarga] [nvarchar](20) NULL,
	[SiglaPaisCarga] [nvarchar](6) NULL,
	[DistritoDescarga] [nvarchar](255) NULL,
	[ConcelhoDescarga] [nvarchar](255) NULL,
	[CodigoPostalDescarga] [nvarchar](20) NULL,
	[SiglaPaisDescarga] [nvarchar](6) NULL,
	[CodigoEntidade] [nvarchar](20) NULL,
	[CodigoMoeda] [nvarchar](20) NULL,
	[MensagemDocAT] [nvarchar](1000) NULL,
	[IDSisTiposDocPU] [bigint] NULL,
	[CodigoSisTiposDocPU] [nvarchar](6) NULL,
	[DocManual] [bit] NULL,
	[DocReposicao] [bit] NULL,
	[DataAssinatura] [datetime] NULL,
	[DataControloInterno] [datetime] NULL,
	[SubTotal] [float] NULL,
	[DescontosLinha] [float] NULL, 
	[TotalIVA] [float] NULL,
	[DataVencimento] [datetime] NULL,
 CONSTRAINT [PK_tbDocumentosCompras] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[tbDocumentosComprasAnexos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDDocumentoCompra] [bigint] NOT NULL,
	[IDTipoAnexo] [bigint] NULL,
	[Descricao] [nvarchar](255) NULL,
	[FicheiroOriginal] [nvarchar](255) NULL,
	[Ficheiro] [nvarchar](255) NOT NULL,
	[FicheiroThumbnail] [nvarchar](300) NULL,
	[Caminho] [nvarchar](max) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbDocumentosComprasAnexos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tbDocumentosComprasAnexos] UNIQUE NONCLUSTERED 
(
	[IDDocumentoCompra] ASC,
	[Ficheiro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[tbDocumentosComprasLinhas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDDocumentoCompra] [bigint] NOT NULL,
	[IDArtigo] [bigint] NULL,
	[Descricao] [nvarchar](200) NOT NULL,
	[IDUnidade] [bigint] NULL,
	[NumCasasDecUnidade] [smallint] NULL,
	[Quantidade] [float] NULL,
	[PrecoUnitario] [float] NULL,
	[PrecoUnitarioEfetivo] [float] NULL,
	[PrecoTotal] [float] NULL,
	[Observacoes] [nvarchar](max) NULL,
	[IDLote] [bigint] NULL,
	[CodigoLote] [nvarchar](50) NULL,
	[DescricaoLote] [nvarchar](100) NULL,
	[DataFabricoLote] [datetime] NULL,
	[DataValidadeLote] [datetime] NULL,
	[IDArtigoNumSerie] [bigint] NULL,
	[ArtigoNumSerie] [nvarchar](20) NULL,
	[IDArmazem] [bigint] NULL,
	[IDArmazemLocalizacao] [bigint] NULL,
	[IDArmazemDestino] [bigint] NULL,
	[IDArmazemLocalizacaoDestino] [bigint] NULL,
	[NumLinhasDimensoes] [bigint] NULL,
	[Desconto1] [float] NULL,
	[Desconto2] [float] NULL,
	[IDTaxaIva] [bigint] NULL,
	[TaxaIva] [float] NULL,
	[MotivoIsencaoIva] [nvarchar](255) NULL,
	[IDEspacoFiscal] [bigint] NULL,
	[EspacoFiscal] [nvarchar](50) NULL,
	[IDRegimeIva] [bigint] NULL,
	[RegimeIva] [nvarchar](50) NULL,
	[SiglaPais] [nvarchar](15) NULL,
	[Ordem] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosComprasLinhas_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosComprasLinhas_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbDocumentosComprasLinhas_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](20) NOT NULL CONSTRAINT [DF_tbDocumentosComprasLinhas_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbDocumentosComprasLinhas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL CONSTRAINT [DF_tbDocumentosComprasLinhas_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
	[IDUnidadeStock] [bigint] NULL,
	[IDUnidadeStock2] [bigint] NULL,
	[QuantidadeStock] [float] NULL,
	[QuantidadeStock2] [float] NULL,
	[ValorIva] [float] NULL,
	[ValorIncidencia] [float] NULL,
	[PrecoUnitarioMoedaRef] [float] NULL,
	[PrecoUnitarioEfetivoMoedaRef] [float] NULL,
	[QtdStockAnterior] [float] NULL,
	[QtdStockAtual] [float] NULL,
	[UPCMoedaRef] [float] NULL,
	[PCMAnteriorMoedaRef] [float] NULL,
	[PCMAtualMoedaRef] [float] NULL,
	[PVMoedaRef] [float] NULL,
	[Alterada] [bit] NULL,
	[DataDocOrigem] [datetime] NULL,
	[ValorizouOrigem] [bit] NULL,
	[MovStockOrigem] [bit] NULL,
	[IDTipoDocumentoOrigem] [bigint] NULL,
	[IDDocumentoOrigem] [bigint] NULL,
	[IDLinhaDocumentoOrigem] [bigint] NULL,
	[NumCasasDecUnidadeStk] [smallint] NULL,
	[NumCasasDec2UnidadeStk] [smallint] NULL,
	[FatorConvUnidStk] [float] NULL,
	[FatorConv2UnidStk] [float] NULL,
	[QtdStockAnteriorOrigem] [float] NULL,
	[QtdStockAtualOrigem] [float] NULL,
	[PCMAnteriorMoedaRefOrigem] [float] NULL,
	[QtdAfetacaoStock] [float] NULL,
	[QtdAfetacaoStock2] [float] NULL,
	[CodigoTaxaIva] [nvarchar](6) NULL,
	[IDTipoIva] [bigint] NULL,
	[OperacaoConvUnidStk] [nvarchar](50) NULL,
	[OperacaoConv2UnidStk] [nvarchar](50) NULL,
	[IDTipoPreco] [bigint] NULL,
	[CodigoTipoPreco] [nvarchar](6) NULL,
	[IDCodigoIva] [bigint] NULL,
	[CodigoArtigo] [nvarchar](255) NULL,
	[CodigoBarrasArtigo] [nvarchar](255) NULL,
	[CodigoUnidade] [nvarchar](20) NULL,
	[CodigoTipoIva] [nvarchar](20) NULL,
	[CodigoRegiaoIva] [nvarchar](20) NULL,
	[UPCompraMoedaRef] [float] NULL,
	[UltCustosAdicionaisMoedaRef] [float] NULL,
	[UltDescComerciaisMoedaRef] [float] NULL,
	[PercIncidencia] [float] NULL,
	[PercDeducao] [float] NULL,
	[ValorIvaDedutivel] [float] NULL,
	[PrecoUnitarioEfetivoMoedaRefOrigem] [float] NULL,
	[CodigoMotivoIsencaoIva] nvarchar(6) NULL,
	[ValorDescontoLinha] [float] NULL,
	[TotalComDescontoLinha] [float] NULL,
	[ValorDescontoCabecalho] [float] NULL,
	[TotalComDescontoCabecalho] [float] NULL,
	[QuantidadeSatisfeita] [float] NULL, 
	[QuantidadeDevolvida] [float] NULL,
	[DocumentoOrigem] [nvarchar](255) NULL,
 CONSTRAINT [PK_tbDocumentosComprasLinhas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[tbDocumentosComprasLinhasDimensoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDDocumentoCompraLinha] [bigint] NOT NULL,
	[IDArtigoDimensao] [bigint] NOT NULL,
	[Quantidade] [float] NULL,
	[PrecoUnitario] [float] NULL,
	[PrecoUnitarioEfetivo] [float] NULL,
	[Ordem] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosComprasLinhasDimensoes_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosComprasLinhasDimensoes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbDocumentosComprasLinhasDimensoes_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](20) NOT NULL CONSTRAINT [DF_tbDocumentosComprasLinhasDimensoes_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbDocumentosComprasLinhasDimensoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL CONSTRAINT [DF_tbDocumentosComprasLinhasDimensoes_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
	[QuantidadeStock] [float] NULL,
	[QuantidadeStock2] [float] NULL,
	[PrecoUnitarioMoedaRef] [float] NULL,
	[PrecoUnitarioEfetivoMoedaRef] [float] NULL,
	[QtdStockAnterior] [float] NULL,
	[QtdStockAtual] [float] NULL,
	[UPCMoedaRef] [float] NULL,
	[PCMAnteriorMoedaRef] [float] NULL,
	[PCMAtualMoedaRef] [float] NULL,
	[PVMoedaRef] [float] NULL,
	[Alterada] [bit] NULL,
	[QtdStockAnteriorOrigem] [float] NULL,
	[QtdStockAtualOrigem] [float] NULL,
	[PCMAnteriorMoedaRefOrigem] [float] NULL,
	[QtdAfetacaoStock] [float] NULL,
	[QtdAfetacaoStock2] [float] NULL,
	[CodigoArtigo] [nvarchar](255) NULL,
	[CodigoBarrasArtigo] [nvarchar](255) NULL,
	[UPCompraMoedaRef] [float] NULL,
	[UltCustosAdicionaisMoedaRef] [float] NULL,
	[UltDescComerciaisMoedaRef] [float] NULL,
	[ValorIva] [float] NULL,
	[ValorIvaDedutivel] [float] NULL,
	[ValorIncidencia] [float] NULL,
	[PrecoUnitarioEfetivoMoedaRefOrigem] [float] NULL,
 CONSTRAINT [PK_tbDocumentosComprasLinhasDimensoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbDocumentosComprasAnexos] ADD  CONSTRAINT [DF_tbDocumentosComprasAnexos_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbDocumentosComprasAnexos] ADD  CONSTRAINT [DF_tbDocumentosComprasAnexos_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbFornecedores] FOREIGN KEY([IDEntidade])
REFERENCES [dbo].[tbFornecedores] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbFornecedores]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbCodigosPostais_Carga] FOREIGN KEY([IDCodigoPostalCarga])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbCodigosPostais_Carga]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbCodigosPostais_Descarga] FOREIGN KEY([IDCodigoPostalDescarga])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbCodigosPostais_Descarga]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbCodigosPostais_Destinatario] FOREIGN KEY([IDCodigoPostalDestinatario])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbCodigosPostais_Destinatario]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbCodigosPostais_Fiscal] FOREIGN KEY([IDCodigoPostalFiscal])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbCodigosPostais_Fiscal]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbConcelhos_Carga] FOREIGN KEY([IDConcelhoCarga])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbConcelhos_Carga]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbConcelhos_Descarga] FOREIGN KEY([IDConcelhoDescarga])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbConcelhos_Descarga]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbConcelhos_Destinatario] FOREIGN KEY([IDConcelhoDestinatario])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbConcelhos_Destinatario]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbConcelhos_Fiscal] FOREIGN KEY([IDConcelhoFiscal])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbConcelhos_Fiscal]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbCondicoesPagamento] FOREIGN KEY([IDCondicaoPagamento])
REFERENCES [dbo].[tbCondicoesPagamento] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbCondicoesPagamento]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbDistritos_Carga] FOREIGN KEY([IDDistritoCarga])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbDistritos_Carga]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbDistritos_Descarga] FOREIGN KEY([IDDistritoDescarga])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbDistritos_Descarga]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbDistritos_Destinatario] FOREIGN KEY([IDDistritoDestinatario])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbDistritos_Destinatario]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbDistritos_Fiscal] FOREIGN KEY([IDDistritoFiscal])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbDistritos_Fiscal]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbEstados] FOREIGN KEY([IDEstado])
REFERENCES [dbo].[tbEstados] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbEstados]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbFormasExpedicao] FOREIGN KEY([IDFormaExpedicao])
REFERENCES [dbo].[tbFormasExpedicao] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbFormasExpedicao]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbIVA_Portes] FOREIGN KEY([IDTaxaIvaPortes])
REFERENCES [dbo].[tbIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbIVA_Portes]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbLojas]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbMoedas]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbPaises] FOREIGN KEY([IDPaisCarga])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbPaises]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbPaises_Descarga] FOREIGN KEY([IDPaisDescarga])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbPaises_Descarga]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbPaises_Fiscal] FOREIGN KEY([IDPaisFiscal])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbPaises_Fiscal]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbSistemaEspacoFiscal] FOREIGN KEY([IDEspacoFiscalPortes])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbSistemaEspacoFiscal]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbSistemaEspacoFiscal1] FOREIGN KEY([IDEspacoFiscal])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbSistemaEspacoFiscal1]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbSistemaRegimeIVA] FOREIGN KEY([IDRegimeIvaPortes])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbSistemaRegimeIVA]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbSistemaRegimeIVA1] FOREIGN KEY([IDRegimeIva])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbSistemaRegimeIVA1]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbSistemaRegioesIVA] FOREIGN KEY([IDLocalOperacao])
REFERENCES [dbo].[tbSistemaRegioesIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbSistemaRegioesIVA]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbSistemaTiposDocumentoPrecoUnitario] FOREIGN KEY([IDSisTiposDocPU])
REFERENCES [dbo].[tbSistemaTiposDocumentoPrecoUnitario] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbSistemaTiposDocumentoPrecoUnitario]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbSistemaTiposEntidade] FOREIGN KEY([IDTipoEntidade])
REFERENCES [dbo].[tbSistemaTiposEntidade] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbSistemaTiposEntidade]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbTiposDocumento] FOREIGN KEY([IDTipoDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbTiposDocumento]

ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbTiposDocumentoSeries] FOREIGN KEY([IDTiposDocumentoSeries])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])

ALTER TABLE [dbo].[tbDocumentosCompras] CHECK CONSTRAINT [FK_tbDocumentosCompras_tbTiposDocumentoSeries]

ALTER TABLE [dbo].[tbDocumentosComprasAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasAnexos_tbDocumentosCompras] FOREIGN KEY([IDDocumentoCompra])
REFERENCES [dbo].[tbDocumentosCompras] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasAnexos] CHECK CONSTRAINT [FK_tbDocumentosComprasAnexos_tbDocumentosCompras]

ALTER TABLE [dbo].[tbDocumentosComprasAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasAnexos_tbSistemaTiposAnexos] FOREIGN KEY([IDTipoAnexo])
REFERENCES [dbo].[tbSistemaTiposAnexos] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasAnexos] CHECK CONSTRAINT [FK_tbDocumentosComprasAnexos_tbSistemaTiposAnexos]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_IDTipoDocumentoOrigem] FOREIGN KEY([IDTipoDocumentoOrigem])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_IDTipoDocumentoOrigem]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArmazens] FOREIGN KEY([IDArmazem])
REFERENCES [dbo].[tbArmazens] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArmazens]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArmazens_Destino] FOREIGN KEY([IDArmazemDestino])
REFERENCES [dbo].[tbArmazens] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArmazens_Destino]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArmazensLocalizacoes] FOREIGN KEY([IDArmazemLocalizacao])
REFERENCES [dbo].[tbArmazensLocalizacoes] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArmazensLocalizacoes]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArmazensLocalizacoes_Destino] FOREIGN KEY([IDArmazemLocalizacaoDestino])
REFERENCES [dbo].[tbArmazensLocalizacoes] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArmazensLocalizacoes_Destino]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArtigos]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArtigosLotes] FOREIGN KEY([IDLote])
REFERENCES [dbo].[tbArtigosLotes] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArtigosLotes]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArtigosNumerosSeries] FOREIGN KEY([IDArtigoNumSerie])
REFERENCES [dbo].[tbArtigosNumerosSeries] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArtigosNumerosSeries]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbDocumentosCompras] FOREIGN KEY([IDDocumentoCompra])
REFERENCES [dbo].[tbDocumentosCompras] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbDocumentosCompras]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbIVA] FOREIGN KEY([IDTaxaIva])
REFERENCES [dbo].[tbIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbIVA]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbSistemaCodigosIVA] FOREIGN KEY([IDCodigoIva])
REFERENCES [dbo].[tbSistemaCodigosIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbSistemaCodigosIVA]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbSistemaEspacoFiscal] FOREIGN KEY([IDEspacoFiscal])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbSistemaEspacoFiscal]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbSistemaRegimeIVA] FOREIGN KEY([IDRegimeIva])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbSistemaRegimeIVA]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbSistemaTiposIVA] FOREIGN KEY([IDTipoIva])
REFERENCES [dbo].[tbSistemaTiposIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbSistemaTiposIVA]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbSistemaTiposPrecos] FOREIGN KEY([IDTipoPreco])
REFERENCES [dbo].[tbSistemaTiposPrecos] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbSistemaTiposPrecos]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbUnidades] FOREIGN KEY([IDUnidade])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbUnidades]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbUnidades2] FOREIGN KEY([IDUnidadeStock])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbUnidades2]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbUnidades3] FOREIGN KEY([IDUnidadeStock2])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbUnidades3]

ALTER TABLE [dbo].[tbDocumentosComprasLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhasDimensoes_tbArtigosDimensoes] FOREIGN KEY([IDArtigoDimensao])
REFERENCES [dbo].[tbArtigosDimensoes] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhasDimensoes_tbArtigosDimensoes]

ALTER TABLE [dbo].[tbDocumentosComprasLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhasDimensoes_tbDocumentosComprasLinhas] FOREIGN KEY([IDDocumentoCompraLinha])
REFERENCES [dbo].[tbDocumentosComprasLinhas] ([ID])

ALTER TABLE [dbo].[tbDocumentosComprasLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhasDimensoes_tbDocumentosComprasLinhas]

-- Comunicao AT

CREATE TABLE [dbo].[tbATEstadoComunicacao](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDDocumento] [bigint] NULL,
	[IDTipoDocumento] [bigint] NULL,
	[TipoDocumento] [nvarchar](50) NULL,
	[IDSerie] [bigint] NULL,
	[Serie] [nvarchar](50) NULL,
	[Ano] [bigint] NULL,
	[Numero] [bigint] NULL,
	[DataDocumento] [datetime] NULL,
	[TipoEntidade] [bigint] NULL,
	[CodigoEntidade] [nvarchar](25) NULL,
	[NomeEntidade] [nvarchar](50) NULL,
	[ReturnCode] [bigint] NULL,
	[ReturnMessage] [nvarchar](255) NULL,
	[ATDocCodeID] [nvarchar](255) NULL,
	[UtilizadorCriacao] [nvarchar](256) NULL,
	[DataHoraPedido] [datetime] NULL,
	[TipoDocumentoDescricao] [nvarchar](50) NULL,
	[Selecionado] [bit] NULL DEFAULT ((0)),
	[IDLoja] [bigint] NULL,
	[CodigoLoja] [nvarchar](10) NULL,
	[NomeLoja] [nvarchar](50) NULL,
	[Acao] [nvarchar](1) NULL,
	[XMLResposta] [ntext] NULL,
	[DataHoraCarga] [datetime] NULL,
	[Manual] [bit] NOT NULL DEFAULT ((0)),
	[XMLPedidoAT] [ntext] NULL,
	[XMLRespostaAT] [ntext] NULL,
	[strTabela] [nvarchar](255) NULL,
 CONSTRAINT [PK_tbATEstadoComunicacao] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbATEstadoComunicacao]  WITH CHECK ADD  CONSTRAINT [FK_tbATEstadoComunicacao_tbTiposDocumento] FOREIGN KEY([IDTipoDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])
ALTER TABLE [dbo].[tbATEstadoComunicacao] CHECK CONSTRAINT [FK_tbATEstadoComunicacao_tbTiposDocumento]

ALTER TABLE [dbo].[tbATEstadoComunicacao]  WITH CHECK ADD  CONSTRAINT [FK_tbATEstadoComunicacao_tbTiposDocumentoSeries] FOREIGN KEY([IDSerie])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])
ALTER TABLE [dbo].[tbATEstadoComunicacao] CHECK CONSTRAINT [FK_tbATEstadoComunicacao_tbTiposDocumentoSeries]


CREATE TABLE [dbo].[tbATEstadoComunicacaoLinhas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDATEstadoComunicacao] [bigint] NOT NULL,
	[ReturnCode] [bigint] NULL,
	[ReturnMessage] [nvarchar](255) NULL,
	[ATDocCodeID] [nvarchar](255) NULL,
	[UtilizadorAlteracao] [nvarchar](255) NULL,
	[DataHoraPedido] [datetime] NULL,
	[Acao] [nvarchar](1) NULL,
	[XMLResposta] [ntext] NULL,
	[XMLPedidoAT] [ntext] NULL,
	[XMLRespostaAT] [ntext] NULL,
 CONSTRAINT [PK_tbATEstadoComunicacaoLinhas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbATEstadoComunicacaoLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbATEstadoComunicacaoLinhas_tbATEstadoComunicacao] FOREIGN KEY([IDATEstadoComunicacao])
REFERENCES [dbo].[tbATEstadoComunicacao] ([ID])

ALTER TABLE [dbo].[tbATEstadoComunicacaoLinhas] CHECK CONSTRAINT [FK_tbATEstadoComunicacaoLinhas_tbATEstadoComunicacao]

CREATE TABLE [dbo].[tbSemafroGereStock](
	[ID] [bigint] NOT NULL,
	[IDDocumento] [bigint] NULL,
	[IDTipoDocumento] [bigint] NULL,
	[Accao] [int] NULL,
	[TabelaCabecalho] [nvarchar](250) NULL,
	[TabelaLinhas] [nvarchar](250) NULL,
	[TabelaLinhasDist] [nvarchar](250) NULL,
	[CampoRelTabelaLinhasCab] [nvarchar](100) NULL,
	[CampoRelTabelaLinhasDistLinhas] [nvarchar](100) NULL,
	[Utilizador] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSemafroGereStock] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

-- Menus, Listas e Colunas Personalizadas

EXEC('update [F3MOGeral].[dbo].[tbMenus] set [Ativo]=1 where ID in (1,3)')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=105)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) VALUES (105, 1, N''DocumentosStockAnexos'', N''001.001'', N''Anexos'', 1, N''f3icon-glasses'', N''/Documentos/DocumentosStockAnexos'', 1, 1, 1, 1, 1, 1, 1, 1, NULL, 1, 1, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) VALUES (106, 1, N''DocumentosStock'', N''001.002'', N''DocumentosStock'', 2, N''f3icon-doc-stock'', N''/Documentos/DocumentosStock'', 1, 1, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) VALUES (107, 3, N''DocumentosComprasAnexos'', N''003.003'', N''Anexos'', 1, N''f3icon-glasses'', N''/Documentos/DocumentosComprasAnexos'', 1, 3, 1, 1, 1, 1, 1, 1, NULL, 1, 1, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) VALUES (108, 3, N''DocumentosCompras'', N''003.004'', N''DocumentosCompras'', 2, N''f3icon-doc-stock'', N''/Documentos/DocumentosCompras'', 1, 3, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, 1, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=105 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 105, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 106, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 107, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 108, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, NULL)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE TabelaPrincipal=''tbDocumentosStock'')
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ON
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] (ID, [Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query]) VALUES (69, N''Documentos de Stock'', 1, 1, 106, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbDocumentosStock'', 
N''select TD.Codigo as DescricaoTipoDocumento, D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.Documento as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, 
d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax
from tbDocumentosStock d 
left join tbLojas l on d.IDloja=l.id
left join tbClientes c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbEstados s on d.IDEstado=s.ID'')
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE Tabela=''tbDocumentosStock'')
BEGIN
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', 69, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosStock'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', 69, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosStock'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', 69, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosStock'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', 69, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosStock'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', 69, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosStock'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TotalMoedaDocumento'', 69, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosStock'', 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEstado'', 69, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosStock'', 1, 1, 150)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE TabelaPrincipal=''tbDocumentosCompras'')
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ON
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] (ID, [Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query]) VALUES (70, N''Documentos de Compras'', 1, 1, 108, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbDocumentosCompras'', 
N''select TD.Codigo as DescricaoTipoDocumento, D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.documento as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, 
d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax
from tbDocumentosCompras d 
left join tbLojas l on d.IDloja=l.id
left join tbFornecedores c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbSistemaTiposDocumentoFiscal TDF on td.IDSistemaTiposDocumentoFiscal=TDF.ID
left join tbEstados s on d.IDEstado=s.ID'')
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE Tabela=''tbDocumentosCompras'')
BEGIN
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', 70, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosCompras'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', 70, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosCompras'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', 70, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosCompras'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', 70, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosCompras'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', 70, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosCompras'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TotalMoedaDocumento'', 70, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosCompras'', 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEstado'', 70, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbDocumentosCompras'', 1, 1, 150)
END')

exec('update [F3MOGeral].dbo.tbSistemaModulos set TiposDocumentos=1 where id in (1,3)')
exec('update [F3MOGeral].dbo.tbSistemaTiposDocumentoFiscal set Ativo=0 where id=3')
exec('update [F3MOGeral].dbo.tbSistemaTiposDocumento set Ativo=0 where id=1')

exec('update tbSistemaTiposDocumento set Ativo=0 where id=1')
exec('update tbSistemaModulos set TiposDocumentos=1 where id in (1,3)')
exec('update tbSistemaTiposDocumentoFiscal set Ativo=0 where id=3')
exec('update tbmoedas set simbolo=''€'' where IDSistemaMoeda=1 and simbolo is null')

INSERT [dbo].[tbSistemaEntidadesEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N'DC', N'DocumentosCompras', 1, 1, CAST(N'2016-03-09 12:52:02.557' AS DateTime), N'f3m', NULL, NULL)
INSERT [dbo].[tbSistemaEntidadesEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, N'DS', N'DocumentosStocks', 1, 1, CAST(N'2016-03-09 12:52:02.557' AS DateTime), N'f3m', NULL, NULL)

INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (7, N'RSC', N'Rascunho', 1, 1, CAST(N'2016-05-13 15:21:00.000' AS DateTime), N'F3M', NULL, NULL, 3, N'est-rasc')
INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (8, N'EFT', N'Efetivo', 1, 1, CAST(N'2016-07-06 00:00:00.000' AS DateTime), N'F3M', NULL, NULL, 3, N'est-uso')
INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (9, N'ANL', N'Anulado', 1, 1, CAST(N'2016-07-06 00:00:00.000' AS DateTime), N'F3M', NULL, NULL, 3, N'est-final')	
INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (10, N'RSC', N'Rascunho', 1, 1, CAST(N'2016-05-13 15:21:00.000' AS DateTime), N'F3M', NULL, NULL, 4, N'est-rasc')
INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (11, N'EFT', N'Efetivo', 1, 1, CAST(N'2016-07-06 00:00:00.000' AS DateTime), N'F3M', NULL, NULL, 4, N'est-uso')
INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (12, N'ANL', N'Anulado', 1, 1, CAST(N'2016-07-06 00:00:00.000' AS DateTime), N'F3M', NULL, NULL, 4, N'est-final')	

SET IDENTITY_INSERT [dbo].[tbEstados] ON 
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (7, N'C1', N'Rascunho', 1, 1, CAST(N'2016-03-11 04:51:28.000' AS DateTime), N'f3m', CAST(N'2016-05-13 15:28:08.757' AS DateTime), N'f3m', 3, 7, 1, 1)
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (8, N'C2', N'Efetivo', 1, 1, CAST(N'2016-07-13 05:00:33.000' AS DateTime), N'f3m', CAST(N'2016-07-13 17:00:40.757' AS DateTime), N'f3m', 3, 8, 0, 0)
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (9, N'C3', N'Anulado', 1, 1, CAST(N'2016-07-13 05:00:33.000' AS DateTime), N'f3m', CAST(N'2016-07-13 17:00:40.757' AS DateTime), N'f3m', 3, 9, 0, 0)
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (10, N'S1', N'Rascunho', 1, 1, CAST(N'2016-03-11 04:51:28.000' AS DateTime), N'f3m', CAST(N'2016-05-13 15:28:08.757' AS DateTime), N'f3m', 4, 10, 1, 1)
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (11, N'S2', N'Efetivo', 1, 1, CAST(N'2016-07-13 05:00:33.000' AS DateTime), N'f3m', CAST(N'2016-07-13 17:00:40.757' AS DateTime), N'f3m', 4, 11, 0, 0)
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (12, N'S3', N'Anulado', 1, 1, CAST(N'2016-07-13 05:00:33.000' AS DateTime), N'f3m', CAST(N'2016-07-13 17:00:40.757' AS DateTime), N'f3m', 4, 12, 0, 0)
SET IDENTITY_INSERT [dbo].[tbEstados] OFF

SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (16, 16, N'DocumentosStock', N'DocumentosStock', N'rptDocumentosStock', N'\Reporting\Reports\Produz\DocumentosStock\', 1, NULL, 1, NULL, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', 1, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (17, 17, N'DocumentosCompras', N'DocumentosCompras', N'rptDocumentosCompras', N'\Reporting\Reports\Oticas\DocumentosCompras\', 1, NULL, 1, NULL, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', 3, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF

insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (13,2,1,1,1,'2016-06-14 00:00:00.000','F3M')
insert into tbSistemaTiposEntidadeModulos (ID, IDSistemaTiposEntidade, IDSistemaModulos, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (14,3,1,1,1,'2016-06-14 00:00:00.000','F3M')

-- sp_AtualizaUPC

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaUPC]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0,
	@strTabelaCabecalho AS nvarchar(250) = '''', 
	@strTabelaLinhas AS nvarchar(250) = '''',
	@strTabelaLinhasDist AS nvarchar(250) = '''',
	@strCampoRelTabelaLinhasCab AS nvarchar(100) = '''',
	@strCampoRelTabelaLinhasDistLinhas AS nvarchar(100) = '''',
	@strUtilizador AS nvarchar(256) = ''''
AS  BEGIN
SET NOCOUNT ON
DECLARE	
	@ErrorMessage AS varchar(2000),
	@ErrorSeverity AS tinyint,
	@ErrorState AS tinyint,
	@strWhereQuantidades AS nvarchar(1500) = NULL,
	@bitUltimoPrecoCusto AS bit = 0,
	@strSqlQuery AS varchar(max),--variavel para query''s dinamicos
	@strQueryWhere AS nvarchar(1024) = '''',
	@strQueryCampos AS nvarchar(1024) = ''''
BEGIN TRY
	--Carrega propriedades do tipo de documento
	SELECT 	@bitUltimoPrecoCusto = isnull(TD.UltimoPrecoCusto,0)
	FROM tbTiposDocumento TD
	WHERE TD.ID=@lngidTipoDocumento
	--Atualiza ultimo preço de custo com base no artigo e documento
	IF @bitUltimoPrecoCusto<>0
		BEGIN
			SET @strSqlQuery ='' FROM tbArtigos AS ArtStok
								INNER JOIN (
								SELECT distinct Linhas.IDArtigo, isnull(Linhas.UPCMoedaRef ,0) AS UPCMoedaRef, isnull(Linhas.UPCompraMoedaRef ,0) AS UPCompraMoedaRef,
								isnull(Linhas.UltCustosAdicionaisMoedaRef ,0) AS UltCustosAdicionaisMoedaRef, isnull(Linhas.UltDescComerciaisMoedaRef ,0) AS UltDescComerciaisMoedaRef,
								Cab.DataControloInterno, Cab.ID, Cab.IDTipoDocumento
								FROM '' + QUOTENAME(@strTabelaLinhas) + ''  AS Linhas
								LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + ''
								INNER JOIN (
									SELECT IDArtigo, Max(isnull(Ordem,0)) AS Ordem FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas
									LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + ''
									LEFT JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = Cab.IDTipoDocumento
									WHERE NOT Linhas.IDArtigo is NULL and Cab.IDTipoDocumento = '' + Convert(nvarchar,@lngidTipoDocumento) + '' AND Linhas.'' + @strCampoRelTabelaLinhasCab + '' = '' + Convert(nvarchar,@lngidDocumento) +
									'' AND isnull(TPDoc.DocNaoValorizado,0) = 0  
									GROUP BY IDArtigo
								) AS LinhasArtigos
								ON (LinhasArtigos.IDArtigo = Linhas.IDArtigo AND isnull(LinhasArtigos.Ordem,0) = isnull(Linhas.Ordem,0))
								LEFT JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = Cab.IDTipoDocumento
								WHERE NOT Linhas.IDArtigo is NULL and Cab.IDTipoDocumento ='' + Convert(nvarchar,@lngidTipoDocumento) + '' AND Linhas.'' + @strCampoRelTabelaLinhasCab + '' = '' + Convert(nvarchar,@lngidDocumento) + 
								'' AND isnull(TPDoc.DocNaoValorizado,0) = 0  
								) AS ART
								ON ArtStok.ID = ART.IDArtigo ''
			IF (@intAccao = 0 OR @intAccao = 1) --adiona ou alterar
				BEGIN
					SET @strQueryCampos  = ''UPDATE tbArtigos SET UltimoPrecoCusto = ART.UPCMoedaRef, UltimoPrecoCompra = ART.UPCompraMoedaRef,
										   UltimosCustosAdicionais = ART.UltCustosAdicionaisMoedaRef, UltimosDescontosComerciais = ART.UltDescComerciaisMoedaRef,
									       IDTipoDocumentoUPC = ART.IDTipoDocumento, IDDocumentoUPC = ART.ID, DataControloUPC = ART.DataControloInterno, RecalculaUPC = 0 ''
					SET @strQueryWhere = '' WHERE (ArtStok.IDDocumentoUPC IS NULL OR (NOT ArtStok.IDDocumentoUPC IS NULL AND ART.DataControloInterno >= ArtStok.DataControloUPC))''
				END
			ELSE--apagar
				BEGIN
					SET @strQueryWhere  = '' WHERE ArtStok.IDDocumentoUPC = ART.ID AND ArtStok.IDTipoDocumentoUPC = ART.IDTipoDocumento ''
					SET @strQueryCampos = '' UPDATE tbArtigos SET RecalculaUPC = 1 ''
				END
			EXEC(@strQueryCampos + @strSqlQuery + @strQueryWhere)
			--para quem tem dimensoes, atualiza por dimensao FALTA CAMPOS POR DIMENSAO
			IF len(@strTabelaLinhasDist)>0
				BEGIN
					SET @strSqlQuery ='' FROM tbArtigosDimensoes AS ArtStok
										INNER JOIN (
										SELECT distinct Linhas.IDArtigo,LinhasDist.IDArtigoDimensao, isnull(LinhasDist.UPCMoedaRef ,0) AS UPCMoedaRef, isnull(LinhasDist.UPCompraMoedaRef ,0) AS UPCompraMoedaRef,
										isnull(LinhasDist.UltCustosAdicionaisMoedaRef ,0) AS UltCustosAdicionaisMoedaRef, isnull(LinhasDist.UltDescComerciaisMoedaRef ,0) AS UltDescComerciaisMoedaRef,
										Cab.DataControloInterno, Cab.ID, Cab.IDTipoDocumento
										FROM '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhasDist 
										LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON Linhas.ID = LinhasDist.'' + @strCampoRelTabelaLinhasDistLinhas + ''
										LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + ''
										INNER JOIN (
											SELECT Linhas.IDArtigo, LinhasDist.IDArtigoDimensao, Max(isnull(LinhasDist.Ordem,0)) AS Ordem FROM '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhasDist
											LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON Linhas.ID = LinhasDist.'' + @strCampoRelTabelaLinhasDistLinhas + ''
											LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + ''
											LEFT JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = Cab.IDTipoDocumento
											WHERE NOT Linhas.IDArtigo is NULL and Cab.IDTipoDocumento = '' + Convert(nvarchar,@lngidTipoDocumento) + '' AND Linhas.'' + @strCampoRelTabelaLinhasCab + '' = '' + Convert(nvarchar,@lngidDocumento) +
											'' AND isnull(TPDoc.DocNaoValorizado,0) = 0  AND NOT LinhasDist.IDArtigoDimensao IS NULL
											GROUP BY Linhas.IDArtigo,LinhasDist.IDArtigoDimensao
										) AS LinhasArtigos
										ON (LinhasArtigos.IDArtigoDimensao = LinhasDist.IDArtigoDimensao AND LinhasArtigos.IDArtigo = Linhas.IDArtigo AND isnull(LinhasArtigos.Ordem,0) = isnull(LinhasDist.Ordem,0))
										LEFT JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = Cab.IDTipoDocumento
										WHERE NOT Linhas.IDArtigo is NULL and Cab.IDTipoDocumento ='' + Convert(nvarchar,@lngidTipoDocumento) + '' AND Linhas.'' + @strCampoRelTabelaLinhasCab + '' = '' + Convert(nvarchar,@lngidDocumento) + 
										'' AND isnull(TPDoc.DocNaoValorizado,0) = 0  AND NOT LinhasDist.IDArtigoDimensao IS NULL
										) AS ART
										ON ArtStok.IDArtigo = ART.IDArtigo AND ArtStok.ID = ART.IDArtigoDimensao''
					IF (@intAccao = 0 OR @intAccao = 1) --adiona ou alterar
						BEGIN
							SET @strQueryCampos  = ''UPDATE tbArtigosDimensoes SET UPC = ART.UPCMoedaRef, UltPrecoComp  = ART.UPCompraMoedaRef,
													UltimoCustoAdicional = ART.UltCustosAdicionaisMoedaRef, 
													IDTipoDocumentoUPC = ART.IDTipoDocumento, IDDocumentoUPC = ART.ID, DataControloUPC = ART.DataControloInterno, RecalculaUPC = 0 ''
							SET @strQueryWhere = '' WHERE (ArtStok.IDDocumentoUPC IS NULL OR (NOT ArtStok.IDDocumentoUPC IS NULL AND ART.DataControloInterno >= ArtStok.DataControloUPC))''
						END
					ELSE--apagar
						BEGIN
							SET @strQueryWhere  = '' WHERE ArtStok.IDDocumentoUPC = ART.ID AND ArtStok.IDTipoDocumentoUPC = ART.IDTipoDocumento ''
							SET @strQueryCampos = '' UPDATE tbArtigosDimensoes SET RecalculaUPC = 1 ''
						END
					EXEC(@strQueryCampos + @strSqlQuery + @strQueryWhere)
				END			
		END	
END TRY
BEGIN CATCH
	SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
	RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')


-- sp_AtualizaArtigos

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaArtigos]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0,
	@strTabelaCabecalho AS nvarchar(250) = '''', 
	@strTabelaLinhas AS nvarchar(250) = '''',
	@strTabelaLinhasDist AS nvarchar(250) = '''',
	@strCampoRelTabelaLinhasCab AS nvarchar(100) = '''',
	@strCampoRelTabelaLinhasDistLinhas AS nvarchar(100) = '''',
	@strUtilizador AS nvarchar(256) = ''''
AS  BEGIN
SET NOCOUNT ON
DECLARE	
	@ErrorMessage AS varchar(2000),
	@ErrorSeverity AS tinyint,
	@ErrorState AS tinyint,
	@strWhereQuantidades AS nvarchar(1500) = NULL,
	@bitDataPrimeiraEntrada AS bit = 0,
	@bitDataUltimaEntrada AS bit = 0,
	@bitDataPrimeiraSaida AS bit = 0,
	@bitDataUltimaSaida AS bit = 0,
	@bitCustoMedio AS bit = 0,
	@bitGereStock AS bit,
	@strSqlQuery AS varchar(max),--variavel para query''s dinamicos
	@strQueryWhere AS nvarchar(1024) = '''',
	@strQueryCampos AS nvarchar(1024) = ''''
BEGIN TRY
	--Carrega propriedades do tipo de documento
	SELECT @bitDataPrimeiraEntrada = isnull(TD.DataPrimeiraEntrada,0),
	@bitDataUltimaEntrada = isnull(TD.DataUltimaEntrada,0), @bitDataPrimeiraSaida = isnull(TD.DataPrimeiraSaida,0), @bitDataUltimaSaida = isnull(TD.DataUltimaSaida,0),
	@bitCustoMedio = isnull(TD.CustoMedio,0), @bitGereStock = ISNULL(TD.GereStock,0)  
	FROM tbTiposDocumento TD
	WHERE TD.ID=@lngidTipoDocumento
		
    IF @bitGereStock<>0 
		BEGIN
			--inserir os registos que nao existem ainda na tabela
			INSERT INTO tbArtigosStock(IDArtigo, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao) 
			SELECT distinct CCART.IDArtigo,1 AS Ativo,1 AS Sistema, getdate() AS DataCriacao , @strUtilizador as UtilizadorCriacao, getdate() AS DataAlteracao, @strUtilizador AS UtilizadorAlteracao
			FROM tbCCStockArtigos AS CCART 
			LEFT JOIN tbArtigosStock AS ArtStok ON ArtStok.IDArtigo=CCART.IDArtigo
			WHERE ArtStok.IDArtigo is NULL AND CCART.IDTipoDocumento = @lngidTipoDocumento AND CCART.IDDocumento = @lngidDocumento 		
		END
	IF @bitGereStock<>0 AND (@bitDataPrimeiraEntrada<>0 OR @bitDataUltimaEntrada<>0 OR @bitDataPrimeiraSaida<>0 OR @bitDataUltimaSaida<>0) 	
		BEGIN
			IF @intAccao <> 0 
				BEGIN
					--atualiza valores
					UPDATE tbArtigosStock SET UltimaEntrada = CASE WHEN @bitDataUltimaEntrada<>0 THEN ArtigosEntradas.DataUltimaEntrada ELSE UltimaEntrada END,
												PrimeiraEntrada = CASE WHEN @bitDataPrimeiraEntrada<>0 THEN ArtigosEntradas.DataPrimeiraEntrada ELSE PrimeiraEntrada END,
												UltimaSaida = CASE WHEN @bitDataUltimaSaida<>0 THEN ArtigosSaidas.DataUltimaSaida ELSE UltimaSaida END,
												PrimeiraSaida = CASE WHEN @bitDataPrimeiraSaida<>0 THEN ArtigosSaidas.DataPrimeiraSaida ELSE PrimeiraSaida END 
					FROM tbArtigosStock AS ArtStok
					LEFT JOIN tbArtigos As ART ON ART.ID=ArtStok.IDArtigo
					INNER JOIN (SELECT Distinct IDArtigo FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento) AS AR ON AR.IDArtigo = ArtStok.IDArtigo
					LEFT JOIN (
							SELECT TCCS.IDArtigo, MAX(TCCS.DataControloInterno) AS DataUltimaSaida, MIN(TCCS.DataControloInterno) AS DataPrimeiraSaida
							FROM tbCCStockArtigos AS TCCS
							INNER JOIN 
							(SELECT distinct IDArtigo FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento ) AS CCAS
							ON CCAS.IDArtigo= TCCS.IDArtigo
							WHERE TCCS.Natureza=''S'' AND (TCCS.IDTipoDocumento<>@lngidTipoDocumento OR TCCS.IDDocumento<>@lngidDocumento)
							GROUP BY TCCS.IDArtigo
							) AS ArtigosSaidas
					ON (ArtigosSaidas.IDArtigo = ArtStok.IDArtigo)
					LEFT JOIN (
							SELECT TCC.IDArtigo, MAX(TCC.DataControloInterno) AS DataUltimaEntrada, MIN(TCC.DataControloInterno) AS DataPrimeiraEntrada
							FROM tbCCStockArtigos AS TCC
							INNER JOIN 
							(SELECT distinct IDArtigo FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento ) AS CCA
							ON CCA.IDArtigo= TCC.IDArtigo
							WHERE TCC.Natureza=''E'' AND (TCC.IDTipoDocumento<>@lngidTipoDocumento OR TCC.IDDocumento<>@lngidDocumento)
							GROUP BY TCC.IDArtigo
							) AS ArtigosEntradas
					ON (ArtigosEntradas.IDArtigo = ArtStok.IDArtigo)
					WHERE isnull(ART.GereStock,0)<>0
				END
			ELSE
				BEGIN
				--atualiza valores
					UPDATE tbArtigosStock SET UltimaEntrada = CASE WHEN @bitDataUltimaEntrada<>0 THEN ArtigosEntradas.DataUltimaEntrada ELSE UltimaEntrada END,
												PrimeiraEntrada = CASE WHEN @bitDataPrimeiraEntrada<>0 THEN ArtigosEntradas.DataPrimeiraEntrada ELSE PrimeiraEntrada END,
												UltimaSaida = CASE WHEN @bitDataUltimaSaida<>0 THEN ArtigosSaidas.DataUltimaSaida ELSE UltimaSaida END,
												PrimeiraSaida = CASE WHEN @bitDataPrimeiraSaida<>0 THEN ArtigosSaidas.DataPrimeiraSaida ELSE PrimeiraSaida END 
					FROM tbArtigosStock AS ArtStok
					LEFT JOIN tbArtigos As ART ON ART.ID=ArtStok.IDArtigo
					INNER JOIN (SELECT Distinct IDArtigo FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento) AS AR ON AR.IDArtigo = ArtStok.IDArtigo
					LEFT JOIN (
							SELECT TCCS.IDArtigo, MAX(TCCS.DataControloInterno) AS DataUltimaSaida, MIN(TCCS.DataControloInterno) AS DataPrimeiraSaida
							FROM tbCCStockArtigos AS TCCS
							INNER JOIN 
							(SELECT distinct IDArtigo FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento ) AS CCAS
							ON CCAS.IDArtigo= TCCS.IDArtigo
							WHERE TCCS.Natureza=''S''
							GROUP BY TCCS.IDArtigo
							) AS ArtigosSaidas
					ON (ArtigosSaidas.IDArtigo = ArtStok.IDArtigo)
					LEFT JOIN (
							SELECT TCC.IDArtigo, MAX(TCC.DataControloInterno) AS DataUltimaEntrada, MIN(TCC.DataControloInterno) AS DataPrimeiraEntrada
							FROM tbCCStockArtigos AS TCC
							INNER JOIN 
							(SELECT distinct IDArtigo FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento ) AS CCA
							ON CCA.IDArtigo= TCC.IDArtigo
							WHERE TCC.Natureza=''E''
							GROUP BY TCC.IDArtigo
							) AS ArtigosEntradas
					ON (ArtigosEntradas.IDArtigo = ArtStok.IDArtigo)
					WHERE isnull(ART.GereStock,0)<>0
				END
		END
	--daqui para baixo se tem dimensoes e preciso tratar tb			
	--Atualiza custo medio com base no ultimo regsito da CCartigos
	IF @bitCustoMedio<>0
		BEGIN
			IF @intAccao <> 0 
				BEGIN
					UPDATE tbArtigos SET Medio = CCAT.PCMAtualMoedaRef
					FROM tbArtigos AS ArtStok
					INNER JOIN (SELECT Distinct IDArtigo FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento) AS AR ON AR.IDArtigo = ArtStok.ID
					LEFT JOIN ( 
						SELECT distinct CC.IDArtigo,isnull(CC.PCMAtualMoedaRef ,0) AS PCMAtualMoedaRef
						FROM tbCCStockArtigos AS CC
						INNER JOIN (
						SELECT  TCC.IDArtigo, Max(TCC.DataControloInterno) AS Data
						FROM tbCCStockArtigos AS TCC
						INNER JOIN 
							(SELECT distinct IDArtigo FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento) AS CCA
							ON CCA.IDArtigo= TCC.IDArtigo
							INNER JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = TCC.IDTipoDocumento
							WHERE (TCC.Natureza=''E'') AND isnull(TPDoc.CustoMedio,0)<>0 AND (TCC.IDTipoDocumento<>@lngidTipoDocumento OR TCC.IDDocumento<>@lngidDocumento)
							GROUP BY TCC.IDArtigo
						) CCU
						ON CCU.IDArtigo = CC.IDArtigo AND CCU.Data = CC.DataControloInterno
					) AS CCAT
					ON CCAT.IDArtigo = ArtStok.ID
					IF len(@strTabelaLinhasDist)>0
						BEGIN
							UPDATE tbArtigosDimensoes SET CustoMedio = CCAT.PCMAtualMoedaRef
							FROM tbArtigosDimensoes AS ArtStok
							INNER JOIN (SELECT Distinct IDArtigo,IDArtigoDimensao FROM tbCCStockArtigos WHERE NOT IDArtigoDimensao IS NULL AND IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento) AS AR ON AR.IDArtigo = ArtStok.IDArtigo AND AR.IDArtigoDimensao = ArtStok.ID
							LEFT JOIN ( 
								SELECT distinct CC.IDArtigo, CC.IDArtigoDimensao, isnull(CC.PCMAtualMoedaRef ,0) AS PCMAtualMoedaRef
								FROM tbCCStockArtigos AS CC
								INNER JOIN (
								SELECT  TCC.IDArtigo, TCC.IDArtigoDimensao, Max(TCC.DataControloInterno) AS Data
								FROM tbCCStockArtigos AS TCC
								INNER JOIN 
									(SELECT distinct IDArtigo,IDArtigoDimensao FROM tbCCStockArtigos  WHERE NOT IDArtigoDimensao IS NULL AND IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento) AS CCA
									ON CCA.IDArtigo= TCC.IDArtigo AND CCA.IDArtigoDimensao = TCC.IDArtigoDimensao
									INNER JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = TCC.IDTipoDocumento
									WHERE (TCC.Natureza=''E'') AND isnull(TPDoc.CustoMedio,0)<>0 AND NOT TCC.IDArtigoDimensao IS NULL 
									AND (TCC.IDTipoDocumento<>@lngidTipoDocumento OR TCC.IDDocumento<>@lngidDocumento)
									GROUP BY TCC.IDArtigo, TCC.IDArtigoDimensao
								) CCU
								ON CCU.IDArtigo = CC.IDArtigo AND CCU.Data = CC.DataControloInterno AND CCU.IDArtigoDimensao = CC.IDArtigoDimensao
							) AS CCAT
							ON CCAT.IDArtigo = ArtStok.IDArtigo AND CCAT.IDArtigoDimensao = ArtStok.ID
					END
				END
			ELSE
				BEGIN
					UPDATE tbArtigos SET Medio = CCAT.PCMAtualMoedaRef
					FROM tbArtigos AS ArtStok
					INNER JOIN (SELECT Distinct IDArtigo FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento) AS AR ON AR.IDArtigo = ArtStok.ID
					LEFT JOIN ( 
						SELECT distinct CC.IDArtigo,isnull(CC.PCMAtualMoedaRef ,0) AS PCMAtualMoedaRef
						FROM tbCCStockArtigos AS CC
						INNER JOIN (
						SELECT  TCC.IDArtigo, Max(TCC.DataControloInterno) AS Data
						FROM tbCCStockArtigos AS TCC
						INNER JOIN 
							(SELECT distinct IDArtigo FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento) AS CCA
							ON CCA.IDArtigo= TCC.IDArtigo
							INNER JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = TCC.IDTipoDocumento
							WHERE (TCC.Natureza=''E'') AND isnull(TPDoc.CustoMedio,0)<>0
							GROUP BY TCC.IDArtigo
						) CCU
						ON CCU.IDArtigo = CC.IDArtigo AND CCU.Data = CC.DataControloInterno
					) AS CCAT
					ON CCAT.IDArtigo = ArtStok.ID
					IF len(@strTabelaLinhasDist)>0
						BEGIN
							UPDATE tbArtigosDimensoes SET CustoMedio = CCAT.PCMAtualMoedaRef
							FROM tbArtigosDimensoes AS ArtStok
							INNER JOIN (SELECT Distinct IDArtigo,IDArtigoDimensao FROM tbCCStockArtigos WHERE NOT IDArtigoDimensao IS NULL AND IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento) AS AR ON AR.IDArtigo = ArtStok.IDArtigo AND AR.IDArtigoDimensao = ArtStok.ID
							LEFT JOIN ( 
								SELECT distinct CC.IDArtigo, CC.IDArtigoDimensao, isnull(CC.PCMAtualMoedaRef ,0) AS PCMAtualMoedaRef
								FROM tbCCStockArtigos AS CC
								INNER JOIN (
								SELECT  TCC.IDArtigo, TCC.IDArtigoDimensao, Max(TCC.DataControloInterno) AS Data
								FROM tbCCStockArtigos AS TCC
								INNER JOIN 
									(SELECT distinct IDArtigo,IDArtigoDimensao FROM tbCCStockArtigos  WHERE NOT IDArtigoDimensao IS NULL AND IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento) AS CCA
									ON CCA.IDArtigo= TCC.IDArtigo AND CCA.IDArtigoDimensao = TCC.IDArtigoDimensao
									INNER JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = TCC.IDTipoDocumento
									WHERE (TCC.Natureza=''E'') AND isnull(TPDoc.CustoMedio,0)<>0 AND NOT TCC.IDArtigoDimensao IS NULL
									GROUP BY TCC.IDArtigo, TCC.IDArtigoDimensao
								) CCU
								ON CCU.IDArtigo = CC.IDArtigo AND CCU.Data = CC.DataControloInterno AND CCU.IDArtigoDimensao = CC.IDArtigoDimensao
							) AS CCAT
							ON CCAT.IDArtigo = ArtStok.IDArtigo AND CCAT.IDArtigoDimensao = ArtStok.ID
					END
				END

		END	
		
	IF @bitGereStock<>0 	
		BEGIN
			UPDATE tbArtigosStock SET Atual= Round(ST.StockAtual,6), StockAtual2 = Round(ST.StockAtual2,6)  FROM tbArtigosStock as ArtSt
			LEFT JOIN tbArtigos As ART ON ART.ID=ArtSt.IDArtigo
			INNER JOIN (
			SELECT 	SART.IDArtigo, SUM(isnull(QuantidadeStock,0)) AS StockAtual, SUM(isnull(QuantidadeStock2,0)) AS StockAtual2 FROM tbStockArtigos AS SART
			INNER JOIN
			(SELECT distinct IDArtigo FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento) AS CCART
			ON SART.IDArtigo = CCART.IDArtigo
			GROUP BY SART.IDArtigo
			) AS ST
			ON ArtSt.IDArtigo = ST.IDArtigo
			WHERE isnull(ART.GereStock,0)<>0 
			--por dimensao falta stk2
			IF len(@strTabelaLinhasDist)>0
				BEGIN
					UPDATE tbArtigosDimensoes SET StkArtigo= Round(ST.StockAtual,6), StkArtigo2=Round(ST.StockAtual2,6) FROM tbArtigosDimensoes as ArtSt
					LEFT JOIN tbArtigos As ART ON ART.ID=ArtSt.IDArtigo
					INNER JOIN (
					SELECT 	SART.IDArtigo, SART.IDArtigoDimensao, SUM(isnull(QuantidadeStock,0)) AS StockAtual, SUM(isnull(QuantidadeStock2,0)) AS StockAtual2 FROM tbStockArtigos AS SART
					INNER JOIN
					(SELECT distinct IDArtigo, IDArtigoDimensao FROM tbCCStockArtigos  WHERE NOT IDArtigoDimensao IS NULL AND IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento) AS CCART
					ON SART.IDArtigo = CCART.IDArtigo AND SART.IDArtigoDimensao = CCART.IDArtigoDimensao
					WHERE NOT SART.IDArtigoDimensao IS NULL
					GROUP BY SART.IDArtigo, SART.IDArtigoDimensao
					) AS ST
					ON ArtSt.IDArtigo = ST.IDArtigo AND ArtSt.ID = ST.IDArtigoDimensao
					WHERE isnull(ART.GereStock,0)<>0 
				END
		END	
END TRY
BEGIN CATCH
	SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
	RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')


-- sp_AtualizaStock

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaStock]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0,
	@strTabelaCabecalho AS nvarchar(250) = '''', 
	@strTabelaLinhas AS nvarchar(250) = '''',
	@strTabelaLinhasDist AS nvarchar(250) = '''',
	@strCampoRelTabelaLinhasCab AS nvarchar(100) = '''',
	@strCampoRelTabelaLinhasDistLinhas AS nvarchar(100) = '''',
	@strUtilizador AS nvarchar(256) = ''''
AS  BEGIN
SET NOCOUNT ON

DECLARE @strSqlQuery AS varchar(max),--variavel para query''s dinamicos
	@strSqlQueryAux AS varchar(max),--variavel para query''s dinamicos
	@strSqlQueryUpdates AS varchar(max),--variavel para query''s dinamicos
	@strSqlQueryInsert AS varchar(max),--varivale para a parte do insert
	@paramList AS nvarchar(max),--variavel para usar quando necessitamos de carregar para as variaveis parametros/colunas comquery''s dinamicas
	@strNatureza AS nvarchar(15) = NULL,
	@strNaturezaaux AS nvarchar(15) = NULL,
	@strModulo AS nvarchar(50),
	@strTipoDocInterno AS nvarchar(50),
	@cModuloStocks AS nvarchar(3) =''001'',
	@strCodMovStock AS nvarchar(10) = NULL,
	@strQueryQuantidades AS nvarchar(2500) = NULL,
	@strQueryPrecoUnitarios AS nvarchar(2500) = NULL,
	@strQueryLeftJoinDist AS nvarchar(256) = '' '',
	@strQueryLeftJoinDistUpdates AS nvarchar(256) = '' '',
	@strQueryWhereDistUpdates AS nvarchar(max) = '''',
	@strQueryCamposDistUpdates AS nvarchar(1024) = '''',
	@strQueryWhereDistUpdates1 AS nvarchar(1024) = '''',
	@strQueryCamposDistUpdates1 AS nvarchar(1024) = '''',
	@strQueryGroupbyDistUpdates AS nvarchar(1024) = '''',
	@strQueryDocsAtras AS nvarchar(4000) = '''',
	@strQueryDocsAFrente AS nvarchar(4000) = '''',
	@strQueryDocsUpdates AS varchar(max),
	@strQueryWhereFrente AS nvarchar(1024) = '''',
	@strArmazensCodigo AS nvarchar(100) = ''[#F3M-TRANSF-F3M#]'',
	@strArmazem AS nvarchar(200) = ''Linhas.IDArmazem, Linhas.IDArmazemLocalizacao, '',
	@strArmazensDestino AS nvarchar(200) = ''Linhas.IDArmazemDestino, Linhas.IDArmazemLocalizacaoDestino, '',
	@strTransFControlo AS nvarchar(256) = ''[#F3M-QTDSTRANSF-F3M#]'',
	@strTransFSaida AS nvarchar(1024) = '''',
	@strTransFEntrada AS nvarchar(1024) = '''',
    @strArtigoDimensao AS nvarchar(100) = ''NULL AS IDArtigoDimensao, '',
	@ErrorMessage   varchar(2000),
	@ErrorSeverity  tinyint,
	@ErrorState     tinyint,
	@rowcount INT,
	@strQueryOrdenacao AS nvarchar(1024) = '''',
	@strWhereQuantidades AS nvarchar(1500) = NULL

BEGIN TRY
	--Verificar se o tipo de documento gere Stock, caso não gere stock não faz nada
	IF EXISTS(SELECT ID FROM tbTiposDocumento WHERE ISNULL(GereStock,0)<>0 AND ID=@lngidTipoDocumento)
		BEGIN
		  	--Calcular a Natureza do stock a registar, para tal carregar o Modulo e o Tipo Doc para vermos o tipo de movimento , se é S ou E ou NM-não movimenta
			SELECT @strModulo = M.Codigo,  @strTipoDocInterno = STD.Tipo, @strCodMovStock = TDMS.Codigo  FROM tbTiposDocumento TD
			LEFT JOIN tbSistemaModulos M ON M.ID = TD.IDModulo
			LEFT JOIN tbSistemaTiposDocumento STD ON STD.ID = TD.IDSistemaTiposDocumento
			LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TD.IDSistemaTiposDocumentoMovStock
			WHERE ISNULL(TD.GereStock,0)<>0 AND TD.ID=@lngidTipoDocumento
			IF NOT @strCodMovStock IS NULL	--qtds positivas	
				BEGIN
					SET @strNatureza =
					CASE @strCodMovStock
						WHEN ''001'' THEN NULL --não movimenta
						WHEN ''002'' THEN ''E''
						WHEN ''003'' THEN ''S''
						WHEN ''004'' THEN ''[#F3MN#F3M]''--transferencia ??? so deve existir nos stocks para os tipos StkTrfArmazCTrans,StkTrfArmazSTrans e StkTransfArtComp
						WHEN ''005'' THEN NULL--?vazio
					END
				END
			IF NOT @strNatureza IS NULL --se a natureza <> NULL então entra para tratar ccstock
				BEGIN
					SET @strNaturezaaux = @strNatureza
					IF  @strNaturezaaux IS NULL 
						BEGIN
							SET @strNaturezaaux=''''
						END
					--Prepara variaveis a concatenar à query das quantidades / Preços, pois se tem dist, teremos de estar preparados para registos na dist
					IF  len(@strTabelaLinhasDist)>0
						BEGIN
						    SET @strQueryOrdenacao ='' ORDER BY Linhas.Ordem asc, LinhasDist.Ordem asc ''
							SET @strQueryQuantidades = ''ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.Quantidade,0) ELSE ISNULL(LinhasDist.Quantidade,0) END) AS Quantidade, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QuantidadeStock,0) ELSE ISNULL(LinhasDist.QuantidadeStock,0) END) as QuantidadeStock, 
													    ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QuantidadeStock2,0) ELSE ISNULL(LinhasDist.QuantidadeStock2,0) END) as QuantidadeStock2, 
														'' + @strTransFControlo + '' 
														,ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdAfetacaoStock,0) ELSE ISNULL(LinhasDist.QtdAfetacaoStock,0) END) as QtdAfetacaoStock, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdAfetacaoStock2,0) ELSE ISNULL(LinhasDist.QtdAfetacaoStock2,0) END) as QtdAfetacaoStock2, ''
	
													     
							SET @strTransFSaida  = ''Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockAnterior,0) ELSE ISNULL(LinhasDist.QtdStockAnterior,0) END as QtdStockAnterior, Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockAtual,0) ELSE ISNULL(LinhasDist.QtdStockAtual,0) END as QtdStockAtual ''
							SET @strTransFEntrada = ''Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockAnterior,0) - ISNULL(Linhas.QuantidadeStock,0)  ELSE ISNULL(LinhasDist.QtdStockAnterior,0) - ISNULL(LinhasDist.QuantidadeStock,0) END as QtdStockAnterior, Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockAtual,0) + ISNULL(Linhas.QuantidadeStock,0) ELSE ISNULL(LinhasDist.QtdStockAtual,0) + ISNULL(LinhasDist.QuantidadeStock,0) END as QtdStockAtual ''


							SET @strQueryPrecoUnitarios = ''Case WHEN LinhasDist.ID IS NULL THEN Linhas.PrecoUnitario ELSE LinhasDist.PrecoUnitario END AS PrecoUnitario, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PrecoUnitarioEfetivo ELSE LinhasDist.PrecoUnitarioEfetivo END AS PrecoUnitarioEfetivo, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PrecoUnitarioMoedaRef ELSE LinhasDist.PrecoUnitarioMoedaRef END AS PrecoUnitarioMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PrecoUnitarioEfetivoMoedaRef ELSE LinhasDist.PrecoUnitarioEfetivoMoedaRef END AS PrecoUnitarioEfetivoMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.UPCMoedaRef ELSE LinhasDist.UPCMoedaRef END AS UPCMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PCMAnteriorMoedaRef ELSE LinhasDist.PCMAnteriorMoedaRef END AS PCMAnteriorMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PCMAtualMoedaRef ELSE LinhasDist.PCMAtualMoedaRef END AS PCMAtualMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PVMoedaRef ELSE LinhasDist.PVMoedaRef END AS PVMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.UPCompraMoedaRef ELSE LinhasDist.UPCompraMoedaRef END AS UPCompraMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.UltCustosAdicionaisMoedaRef ELSE LinhasDist.UltCustosAdicionaisMoedaRef END AS UltCustosAdicionaisMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.UltDescComerciaisMoedaRef ELSE LinhasDist.UltDescComerciaisMoedaRef END AS UltDescComerciaisMoedaRef, 
															''
							
							SET @strQueryLeftJoinDist = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhasDist ON LinhasDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = Linhas.ID ''
							SET @strArtigoDimensao = ''LinhasDist.IDArtigoDimensao AS IDArtigoDimensao, ''
						END
					ELSE
						BEGIN
						    SET @strQueryOrdenacao ='' ORDER BY Linhas.Ordem asc ''
							SET @strQueryQuantidades = ''ABS(ISNULL(Linhas.Quantidade,0)) AS Quantidade, ABS(ISNULL(Linhas.QuantidadeStock,0)) AS QuantidadeStock, ABS(ISNULL(Linhas.QuantidadeStock2,0)) AS QuantidadeStock2, 
														'' + @strTransFControlo + '' , ABS(ISNULL(Linhas.QtdAfetacaoStock,0)) AS QtdAfetacaoStock, ABS(ISNULL(Linhas.QtdAfetacaoStock2,0)) AS QtdAfetacaoStock2, ''
							

							SET @strTransFSaida  = ''ISNULL(Linhas.QtdStockAnterior,0) AS QtdStockAnterior, ISNULL(Linhas.QtdStockAtual,0) AS QtdStockAtual ''
							SET @strTransFEntrada = ''ISNULL(Linhas.QtdStockAnterior,0) - ISNULL(Linhas.QuantidadeStock,0) AS QtdStockAnterior, ISNULL(Linhas.QtdStockAtual,0) + ISNULL(Linhas.QuantidadeStock,0) AS QtdStockAtual ''
														
							
							
							SET @strQueryPrecoUnitarios = ''Linhas.PrecoUnitario AS PrecoUnitario, Linhas.PrecoUnitarioEfetivo AS PrecoUnitarioEfetivo, Linhas.PrecoUnitarioMoedaRef AS PrecoUnitarioMoedaRef,
													    Linhas.PrecoUnitarioEfetivoMoedaRef AS PrecoUnitarioEfetivoMoedaRef, Linhas.UPCMoedaRef AS UPCMoedaRef, 
														Linhas.PCMAnteriorMoedaRef AS PCMAnteriorMoedaRef, Linhas.PCMAtualMoedaRef AS PCMAtualMoedaRef, Linhas.PVMoedaRef AS PVMoedaRef, 
														Linhas.UPCompraMoedaRef AS UPCompraMoedaRef, Linhas.UltCustosAdicionaisMoedaRef AS UltCustosAdicionaisMoedaRef, Linhas.UltDescComerciaisMoedaRef AS UltDescComerciaisMoedaRef, 
														 ''
						
						END
					--Preparação das Query''s para adicionar e só interessa se ação for adicionar ou alterar na parte seguinte
					IF (@intAccao = 0 OR @intAccao = 1) 
						BEGIN
							SET @paramList = N''@lngidDocumento1 bigint''
							SET @strWhereQuantidades = '' (TDQPos.Codigo=''''002'''' OR TDQPos.Codigo=''''003'''' OR TDQPos.Codigo=''''004'''') ''
							SET @strSqlQueryInsert = ''INSERT INTO tbCCStockArtigos (Natureza, IDArtigo, Descricao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie,
													IDArtigoDimensao, IDMoeda, IDTipoEntidade, IDEntidade, IDTipoDocumento, IDDocumento, IDLinhaDocumento, NumeroDocumento, DataControloInterno, IDTipoDocumentoOrigem,
													IDDocumentoOrigem, IDLinhaDocumentoOrigem,  
													Quantidade, QuantidadeStock, QuantidadeStock2, QtdStockAnterior, QtdStockAtual, QtdAfetacaoStock, QtdAfetacaoStock2, PrecoUnitario, PrecoUnitarioEfetivo, PrecoUnitarioMoedaRef, PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef, 
													PCMAnteriorMoedaRef, PCMAtualMoedaRef, PVMoedaRef, UPCompraMoedaRef, UltCustosAdicionaisMoedaRef, UltDescComerciaisMoedaRef, Recalcular, DataDocumento, TaxaConversao, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, VossoNumeroDocumento, VossoNumeroDocumentoOrigem, NumeroDocumentoOrigem, IDTiposDocumentoSeries, IDTiposDocumentoSeriesOrigem) ''
							SELECT @strSqlQuery = @strSqlQueryInsert + ''
													SELECT '''''' + @strNaturezaaux + '''''' AS Natureza, Linhas.IDArtigo, Linhas.Descricao, Cab.IDLoja, '' + @strArmazensCodigo + '' Linhas.IDLote AS IDArtigoLote, 
													Linhas.IDArtigoNumSerie AS IDArtigoNumeroSerie, '' + @strArtigoDimensao + '' 
													Cab.IDMoeda,Cab.IDTipoEntidade, Cab.IDEntidade, Cab.IDTipoDocumento,Cab.ID as IDDocumento, Linhas.id as IDLinhaDocumento, Cab.NumeroDocumento, Cab.DataControloInterno, 
													Linhas.IDTipoDocumentoOrigem as IDTipoDocumentoOrigem, Linhas.IDDocumentoOrigem as IDDocumentoOrigem,Linhas.IDLinhaDocumentoOrigem as IDLinhaDocumentoOrigem, 
													'' + @strQueryQuantidades + @strQueryPrecoUnitarios + ''isnull(Linhas.Alterada,0) AS Recalcular, Cab.DataDocumento AS DataDocumento, Cab.TaxaConversao, 1 AS Ativo, 1 AS Sistema, Cab.DataCriacao, '''''' + @strUtilizador + '''''' AS UtilizadorCriacao,
													Cab.DataAlteracao, '''''' + @strUtilizador + '''''' AS UtilizadorAlteracao, Cab.VossoNumeroDocumento, Linhas.VossoNumeroDocumentoOrigem, Linhas.NumeroDocumentoOrigem, Cab.IDTiposDocumentoSeries, Linhas.IDTiposDocumentoSeriesOrigem
													FROM '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab 
													LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON Linhas.'' + @strCampoRelTabelaLinhasCab + '' = Cab.ID 
													LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo '' + 
													@strQueryLeftJoinDist + 
													''LEFT JOIN tbTiposDocumento AS TpDocOrigem ON TpDocOrigem.ID =  Linhas.IDTipoDocumentoOrigem 
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDocOrigem.IDSistemaTiposDocumentoMovStock
													LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab.IDTipoDocumento
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDQPos ON TDQPos.id=TpDoc.IDSistemaTiposDocumentoMovStock
													WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND ISNULL(Art.GereStock,0) <> 0 AND NOT Linhas.IDArtigo IS NULL
													AND (TpDocOrigem.ID IS NULL OR (NOT TpDocOrigem.ID IS NULL AND (ISNULL(TpDocOrigem.GereStock,0) = 0 OR (ISNULL(TpDocOrigem.GereStock,0) <> 0 AND NOT TDMS.Codigo is NULL AND TDMS.Codigo<>TDQPos.Codigo)))) AND '' +
													@strWhereQuantidades  + @strQueryOrdenacao
							IF (@intAccao = 1) --se é alterar
								BEGIN
									--1) marcar as linhas no documento como alterada, se a mesma já existe na CCartigos e o custo ou a quantidade ou a data mudou,
									--para depois se marcar para recalcular ao inserir registos. Nas saidas marcar se mudou data e stock apenas - transferencias sao ignoradas
									IF  len(@strTabelaLinhasDist)>0
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(LinhaDist.IDArtigoDimensao,0) = isnull(CCartigos.IDArtigoDimensao,0)) ''
											SET @strQueryWhereDistUpdates = '' AND ((ISNULL(TDMS.Codigo,0) = ''''002'''' AND ((isnull(LinhaDist.IDArtigoDimensao,0)<>0 
																			AND (Round(Convert(float,isnull(LinhaDist.UPCMoedaRef,0)),6) <> Round(Convert(float,isnull(CCartigos.UPCMoedaRef,0)),6) OR (isnull(LinhaDist.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0))) 
																			) OR (CCartigos.DataControloInterno<>Cab1.DataControloInterno) OR (isnull(LinhaDist.IDArtigoDimensao,0) = 0 
																			AND  (Round(Convert(float,isnull(Linhas.UPCMoedaRef,0)),6) <> Round(Convert(float,isnull(CCartigos.UPCMoedaRef,0)),6) OR (isnull(Linhas.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0)))
																			))) OR ((ISNULL(TDMS.Codigo,0) = ''''003'''' AND ((isnull(LinhaDist.IDArtigoDimensao,0)<>0 
																			AND isnull(LinhaDist.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0)
																			) OR (CCartigos.DataControloInterno<>Cab1.DataControloInterno) OR (isnull(LinhaDist.IDArtigoDimensao,0) = 0 
																			AND  isnull(Linhas.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0))
																			)))) ''														
																			  
										END
									ELSE
										BEGIN
											SET @strQueryLeftJoinDistUpdates = ''''
											SET @strQueryWhereDistUpdates = '' AND ((ISNULL(TDMS.Codigo,0) = ''''002'''' AND (CCartigos.DataControloInterno<>Cab1.DataControloInterno OR Round(Convert(float,isnull(Linhas.UPCMoedaRef,0)),6) <> Round(Convert(float,isnull(CCartigos.UPCMoedaRef,0)),6) OR (isnull(Linhas.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0))) OR (
											(ISNULL(TDMS.Codigo,0) = ''''003'''' AND (CCartigos.DataControloInterno<>Cab1.DataControloInterno OR (isnull(Linhas.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0))))
											))) ''
																			
										END
									SET @strSqlQueryUpdates = '' UPDATE '' + QUOTENAME(@strTabelaLinhas) + '' SET Alterada=1 FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
																LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')
																LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab1.IDTipoDocumento
																LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
																LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo 
															    INNER JOIN tbCCStockArtigos AS CCartigos ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) '' 
																+ @strQueryLeftJoinDistUpdates +
																''WHERE NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) 
																+ @strQueryWhereDistUpdates
								EXEC(@strSqlQueryUpdates)
								
								END

								IF (@intAccao = 0 OR @intAccao = 1) 
									BEGIN
									--2) Linhas novas que nao estavam no documento e agora passar a existir nele, marcar tb como alterada a propria da CCartigos , caso 
									---- exista à frente ja artigo.
									IF  len(@strTabelaLinhasDist)>0
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = Linhas.id) ''
											SET @strQueryWhereDistUpdates = '' and isnull(LinhaDist.IDArtigoDimensao,0) = isnull(LinhasFrente.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates ='',isnull(LinhaDist.IDArtigoDimensao,0) as IdDimensao ''
											SET @strQueryWhereDistUpdates1 = '' AND isnull(CC.IDArtigoDimensao,0) = isnull(LinhasNovas.IdDimensao,0) '' 
											SET @strQueryCamposDistUpdates1 =''isnull(CC.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryGroupbyDistUpdates = '', isnull(CC.IDArtigoDimensao,0)''
										END
									ELSE
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' ''
											SET @strQueryWhereDistUpdates = '' ''
											SET @strQueryCamposDistUpdates ='' ''
											SET @strQueryWhereDistUpdates1 = '' '' 
											SET @strQueryCamposDistUpdates1 ='' ''
											SET @strQueryGroupbyDistUpdates = '' ''				
										END

									SET @strSqlQueryUpdates ='' Update '' + QUOTENAME(@strTabelaLinhas) + '' SET Alterada=1 FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
													LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')''
													+ @strQueryLeftJoinDistUpdates +
													''LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab1.IDTipoDocumento
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
													LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo 
													LEFT JOIN	(
													SELECT CC.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Count(CC.ID) as Num FROM tbCCStockArtigos AS CC
													LEFT JOIN tbTiposDocumento AS TpDoc1 ON TpDoc1.ID =  CC.IDTipoDocumento
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS1 ON TDMS1.id=TpDoc1.IDSistemaTiposDocumentoMovStock
													LEFT JOIN		
													(SELECT distinct Linhas.IDArtigo, Cab.DataControloInterno'' + @strQueryCamposDistUpdates + '' FROM  '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
													LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON (Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')
													LEFT JOIN tbCCStockArtigos AS CCartigos ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo)'' 
													+ @strQueryLeftJoinDistUpdates +
													''WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND Cab.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' AND CCartigos.IDDocumento IS NULL) AS LinhasNovas
													ON 	(CC.IDArtigo = LinhasNovas.IDArtigo '' + @strQueryWhereDistUpdates1 + '')
													WHERE CC.DataControloInterno > LinhasNovas.DataControloInterno AND (CC.Natureza=''''E'''' OR CC.Natureza=''''S'''') AND (ISNULL(TDMS1.Codigo,0) = ''''002'''' OR ISNULL(TDMS1.Codigo,0) = ''''003'''')									
													GROUP BY 	CC.IDArtigo '' + @strQueryGroupbyDistUpdates + '') AS LinhasFrente	
													ON Linhas.IDArtigo = LinhasFrente.IDArtigo '' + @strQueryWhereDistUpdates +
													''WHERE  NOT Linhas.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''') AND NOT LinhasFrente.IDArtigo IS NULL AND Cab1.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND Cab1.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) 

									EXEC(@strSqlQueryUpdates)
									--2.1) Linhas novas que nao estavam no documento e agora passam a existir, mas com artigo repetido e nestes casos, marcar essas linhas de artigos 
									        
									SET @strSqlQueryUpdates = '' Update '' + QUOTENAME(@strTabelaLinhas) + '' SET Alterada=1 FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
											                  LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '') 
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab1.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											INNER JOIN (
												select Linhas.IDArtigo, Linhas.'' + @strCampoRelTabelaLinhasCab + '' FROM  '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
												LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')
												LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab1.IDTipoDocumento
												LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
												where Linhas.'' + @strCampoRelTabelaLinhasCab + '' = '' + Convert(nvarchar,@lngidDocumento) + '' and Cab1.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' and (TDMS.Codigo=''''002'''' OR TDMS.Codigo=''''003'''')
												group by Linhas.'' + @strCampoRelTabelaLinhasCab + '', Linhas.IDArtigo
												having count(*) > 1
												) as COM2
												ON COM2.IDArtigo=Linhas.IDArtigo and COM2.'' + @strCampoRelTabelaLinhasCab + ''=linhas.'' + @strCampoRelTabelaLinhasCab + ''
											LEFT JOIN tbCCStockArtigos AS CC ON Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CC.IDDocumento and linhas.IDArtigo =cc.IDArtigo and cc.IDLinhaDocumento = linhas.id and CC.IDTipoDocumento = TpDoc.ID
											where Linhas.'' + @strCampoRelTabelaLinhasCab + ''= '' + Convert(nvarchar,@lngidDocumento) + '' and Cab1.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' and (TDMS.Codigo=''''002'''' OR TDMS.Codigo=''''003'''') 
											and CC.IDLinhaDocumento is null	'' 


									EXEC(@strSqlQueryUpdates)
									
									END
								IF (@intAccao = 1) --se é alterar
									BEGIN
									--3) Linhas que existiam e agora deixaram de existir no documento, para essas, marcar a linha à frente desse artigo para recalcular a partir daí
									---  caso não existe nenhum para à frente não marcar nenhuma
									IF  len(@strTabelaLinhasDist)>0
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = Linhas.id) ''
											SET @strQueryWhereDistUpdates = '' AND isnull(CCART.IDArtigoDimensao,0) = isnull(Docs.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates =''isnull(CCartigos.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryWhereDistUpdates1 = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Doc.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates1 =''isnull(CCART.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryGroupbyDistUpdates = '', isnull(CCART.IDArtigoDimensao,0)''
											SET @strQueryWhereFrente = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Frente.IDArtigoDimensao,0) ''
										END
									ELSE
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' ''
											SET @strQueryWhereDistUpdates = ''''
											SET @strQueryCamposDistUpdates ='' ''
											SET @strQueryWhereDistUpdates1 = '' '' 
											SET @strQueryCamposDistUpdates1 ='' ''
											SET @strQueryGroupbyDistUpdates = '' ''	
											SET @strQueryWhereFrente = '' ''			
										END
									SET @strQueryDocsUpdates = ''LEFT JOIN 
													(SELECT distinct CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + '' CCartigos.DataControloInterno  FROM  tbCCStockArtigos AS CCartigos
													LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
													LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
													'' + @strQueryLeftJoinDistUpdates + ''
													LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
													WHERE CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' 
												    AND (CCartigos.Natureza=''''E'''' OR CCartigos.Natureza=''''S'''')
													AND Linhas.ID IS NULL
													AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
													) AS Docs
													ON (Docs.IDArtigo = CCART.IDArtigo '' + @strQueryWhereDistUpdates + '')''
									
									SET @strQueryDocsAFrente ='' (SELECT CCART.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Min(CCART.DataControloInterno) as Data FROM tbCCStockArtigos AS CCART
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCART.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCART.IDArtigo ''
											+ @strQueryDocsUpdates +
											'' WHERE CCART.DataControloInterno > Docs.DataControloInterno and (CCART.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCART.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCART.Natureza=''''E'''' OR CCART.Natureza=''''S'''')
											AND NOT CCART.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											GROUP BY  CCART.IDArtigo'' + @strQueryGroupbyDistUpdates + '') AS Frente
											ON (Frente.IDArtigo = CCA.IDArtigo '' + @strQueryWhereFrente + '' AND Frente.Data = CCA.DataControloInterno) ''

										SET @strSqlQueryUpdates ='' UPDATE tbCCStockArtigos SET Recalcular = 1 FROM tbCCStockArtigos AS CCA
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCA.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCA.IDArtigo
											INNER JOIN ''
											+ @strQueryDocsAFrente + 
											'' WHERE (CCA.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCA.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCA.Natureza=''''E'''' OR CCA.Natureza=''''S'''')
											AND NOT CCA.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											AND NOT Frente.IDArtigo IS NULL ''
											
									EXEC(@strSqlQueryUpdates)

								 	--retirar as quantidades dos totais as quantidades para as chaves dos artigos do documento
									UPDATE tbStockArtigos SET Quantidade = Round(Quantidade - ArtigosAntigos.Qtd, 6), 
									QuantidadeStock = Round(QuantidadeStock - ArtigosAntigos.QtdStock, 6), 
									QuantidadeStock2 = Round(QuantidadeStock2 - ArtigosAntigos.QtdStock2,6) FROM tbStockArtigos AS CCART
									INNER JOIN (
									SELECT IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, SUM(Case Natureza WHEN ''S'' Then isnull(Quantidade,0)*-1 ELSE isnull(Quantidade,0) END) as Qtd,
									SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock,0)*-1 ELSE isnull(QuantidadeStock,0) END) as QtdStock,
									SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock2,0)*-1 ELSE isnull(QuantidadeStock2,0) END) as QtdStock2
									FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento 
									GROUP BY IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
									) AS ArtigosAntigos
									ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
								--CHAMAR AQUI O OUTRO STORED PROCEDURE COM O ESTADO APAGAR
								
								  Execute sp_AtualizaArtigos @lngidDocumento, @lngidTipoDocumento,2,@strTabelaCabecalho,@strTabelaLinhas,@strTabelaLinhasDist,@strCampoRelTabelaLinhasCab,@strCampoRelTabelaLinhasDistLinhas,@strUtilizador
									--apagar aqui se estiverem a zero
									DELETE tbStockArtigos FROM tbStockArtigos AS CCART
									INNER JOIN (
									SELECT distinct IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
									 FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
									) AS ArtigosAntigos
									ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
											isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
											AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
											AND isnull(CCART.Quantidade,0) = 0 AND isnull(CCART.QuantidadeStock,0) = 0 AND isnull(CCART.QuantidadeStock2,0) = 0
									--apagar registos da ccartigos								
									DELETE FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
								END
								IF  @strNaturezaaux = ''[#F3MN#F3M]''--só existe transferencia para os stocks
									BEGIN
										SET @strSqlQueryAux = REPLACE(@strSqlQuery, @strArmazensCodigo, @strArmazem)
										SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strNaturezaaux, ''S'')
										SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strTransFControlo, @strTransFSaida)
									    EXEC(@strSqlQueryAux)--registo do armazem de saída
										SET @strSqlQueryAux = REPLACE(@strSqlQuery, @strArmazensCodigo, @strArmazensDestino)
										SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strNaturezaaux, ''E'')
										SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strTransFControlo, @strTransFEntrada )
										EXEC(@strSqlQueryAux)--registo do armazem de entrada
									END
								ELSE
									BEGIN
									    SET @strSqlQueryAux = REPLACE(@strSqlQuery, @strTransFControlo, @strTransFSaida)
										IF @strNaturezaaux = ''E''
											BEGIN
												SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strArmazensCodigo, @strArmazensDestino)
											END
										ELSE
											BEGIN
												SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strArmazensCodigo, @strArmazem)
											END
								    	EXEC(@strSqlQueryAux) --registo das linhas diferentes de armazéns
									END
								
								--inserir a zero os registos que nao existem das chaves nos totais
								INSERT INTO tbStockArtigos(IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao,IDArtigoLote,IDArtigoNumeroSerie, IDArtigoDimensao, Quantidade, QuantidadeStock, QuantidadeStock2,
								Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao) 
								SELECT CCART.IDArtigo, CCART.IDLoja, CCART.IDArmazem, CCART.IDArmazemLocalizacao, CCART.IDArtigoLote, CCART.IDArtigoNumeroSerie, CCART.IDArtigoDimensao,
								CCART.Quantidade, CCART.QuantidadeStock,CCART.QuantidadeStock2,
									CCART.Ativo,CCART.Sistema, CCART.DataCriacao, CCART.UtilizadorCriacao, CCART.DataAlteracao,CCART.UtilizadorAlteracao
									FROM (
								SELECT IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, 0 as Quantidade,
								0 as QuantidadeStock,
								0 as QuantidadeStock2,1 as Ativo,1 as Sistema, getdate() AS DataCriacao , @strUtilizador as UtilizadorCriacao, getdate() as DataAlteracao, @strUtilizador as UtilizadorAlteracao
								FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento 
								GROUP BY IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
								) AS CCART
								LEFT JOIN tbStockArtigos AS ArtigosAntigos
								ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
									WHERE ArtigosAntigos.IDArtigo is NULL and ArtigosAntigos.IDArmazem is NULL AND
									ArtigosAntigos.IDArmazemLocalizacao is NULL and ArtigosAntigos.IDArtigoLote is NULL and
									ArtigosAntigos.IDArtigoNumeroSerie is NULL and ArtigosAntigos.IDArtigoDimensao is NULL and ArtigosAntigos.IDLoja is NULL
								
								--update a somar para os totais das quantidades
								UPDATE tbStockArtigos SET Quantidade =  Round(Quantidade + ArtigosAntigos.Qtd,6), 
								QuantidadeStock = Round(QuantidadeStock + ArtigosAntigos.QtdStock,6), 
								QuantidadeStock2 = Round(QuantidadeStock2 + ArtigosAntigos.QtdStock2,6) FROM tbStockArtigos AS CCART
								INNER JOIN (
								SELECT IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, SUM(Case Natureza WHEN ''S'' Then isnull(Quantidade,0)*-1 ELSE isnull(Quantidade,0) END) as Qtd,
								SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock,0)*-1 ELSE isnull(QuantidadeStock,0) END) as QtdStock,
								SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock2,0)*-1 ELSE isnull(QuantidadeStock2,0) END) as QtdStock2
								FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
								GROUP BY IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
								) AS ArtigosAntigos
								ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
								
								--colocar o campo a false nas linhas dos documentos
								SET @strSqlQueryUpdates = '' UPDATE '' + QUOTENAME(@strTabelaLinhas) + '' SET Alterada=0 FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
															LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')'' +  
															'' WHERE Cab1.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND Cab1.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) 
																
								EXEC(@strSqlQueryUpdates)	
								--CHAMAR AQUI O OUTRO STORED PROCEDURE COM O ESTADO inserir		
								 Execute sp_AtualizaArtigos @lngidDocumento, @lngidTipoDocumento,0,@strTabelaCabecalho,@strTabelaLinhas,@strTabelaLinhasDist,@strCampoRelTabelaLinhasCab,@strCampoRelTabelaLinhasDistLinhas,@strUtilizador
								

						END
					ELSE --apagar
						BEGIN
							--3) Linhas que existiam e agora deixaram de existir no documento, para essas, marcar a linha à frente desse artigo para recalcular a partir daí
							---  caso não existe nenhum para à frente não marcar nenhuma
							IF  len(@strTabelaLinhasDist)>0
								BEGIN
									SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = Linhas.id) ''
									SET @strQueryWhereDistUpdates = '' AND isnull(CCART.IDArtigoDimensao,0) = isnull(Docs.IDArtigoDimensao,0) '' 
									SET @strQueryCamposDistUpdates =''isnull(CCartigos.IDArtigoDimensao,0) as IDArtigoDimensao, ''
									SET @strQueryWhereDistUpdates1 = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Doc.IDArtigoDimensao,0) '' 
									SET @strQueryCamposDistUpdates1 =''isnull(CCART.IDArtigoDimensao,0) as IDArtigoDimensao, ''
									SET @strQueryGroupbyDistUpdates = '', isnull(CCART.IDArtigoDimensao,0)''
									SET @strQueryWhereFrente = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Frente.IDArtigoDimensao,0) ''
								END
							ELSE
								BEGIN
									SET @strQueryLeftJoinDistUpdates = '' ''
									SET @strQueryWhereDistUpdates = ''''
									SET @strQueryCamposDistUpdates ='' ''
									SET @strQueryWhereDistUpdates1 = '' '' 
									SET @strQueryCamposDistUpdates1 ='' ''
									SET @strQueryGroupbyDistUpdates = '' ''	
									SET @strQueryWhereFrente = '' ''			
								END
							SET @strQueryDocsUpdates = ''LEFT JOIN 
											(SELECT distinct CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + '' CCartigos.DataControloInterno  FROM  tbCCStockArtigos AS CCartigos
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
											'' + @strQueryLeftJoinDistUpdates + ''
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
											WHERE CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' 
											AND (CCartigos.Natureza=''''E'''' OR CCartigos.Natureza=''''S'''')
											AND Linhas.ID IS NULL
											AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											) AS Docs
											ON (Docs.IDArtigo = CCART.IDArtigo '' + @strQueryWhereDistUpdates + '')''
									

								SET @strQueryDocsAFrente ='' (SELECT CCART.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Min(CCART.DataControloInterno) as Data FROM tbCCStockArtigos AS CCART
										LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCART.IDTipoDocumento
										LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
										LEFT JOIN tbArtigos AS Art ON Art.ID = CCART.IDArtigo ''
										+ @strQueryDocsUpdates +
										'' WHERE CCART.DataControloInterno > Docs.DataControloInterno and (CCART.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCART.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCART.Natureza=''''E'''' OR CCART.Natureza=''''S'''')
										AND NOT CCART.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
										GROUP BY  CCART.IDArtigo'' + @strQueryGroupbyDistUpdates + '') AS Frente
										ON (Frente.IDArtigo = CCA.IDArtigo '' + @strQueryWhereFrente + '' AND Frente.Data = CCA.DataControloInterno) ''

								SET @strSqlQueryUpdates ='' UPDATE tbCCStockArtigos SET Recalcular = 1 FROM tbCCStockArtigos AS CCA
									LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCA.IDTipoDocumento
									LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
									LEFT JOIN tbArtigos AS Art ON Art.ID = CCA.IDArtigo
									INNER JOIN ''
									+ @strQueryDocsAFrente + 
									'' WHERE (CCA.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCA.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCA.Natureza=''''E'''' OR CCA.Natureza=''''S'''')
									AND NOT CCA.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
									AND NOT Frente.IDArtigo IS NULL ''

							EXEC(@strSqlQueryUpdates)
							
						   --retirar as quantidades dos totais para as chaves dos artigos do documento
							UPDATE tbStockArtigos SET Quantidade = Round(Quantidade - ArtigosAntigos.Qtd,6), 
							QuantidadeStock = Round(QuantidadeStock - ArtigosAntigos.QtdStock,6), 
							QuantidadeStock2 = Round(QuantidadeStock2 - ArtigosAntigos.QtdStock2,6) FROM tbStockArtigos AS CCART
							INNER JOIN (
							SELECT IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, SUM(Case Natureza WHEN ''S'' Then isnull(Quantidade,0)*-1 ELSE isnull(Quantidade,0) END) as Qtd,
							SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock,0)*-1 ELSE isnull(QuantidadeStock,0) END) as QtdStock,
							SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock2,0)*-1 ELSE isnull(QuantidadeStock2,0) END) as QtdStock2
							FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento 
							GROUP BY IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
							) AS ArtigosAntigos
							ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
							--CHAMAR AQUI O OUTRO STORED PROCEDURE COM O ESTADO APAGAR
							Execute sp_AtualizaArtigos @lngidDocumento, @lngidTipoDocumento,2,@strTabelaCabecalho,@strTabelaLinhas,@strTabelaLinhasDist,@strCampoRelTabelaLinhasCab,@strCampoRelTabelaLinhasDistLinhas,@strUtilizador
							--apagar aqui se estiverem a zero
							DELETE tbStockArtigos FROM tbStockArtigos AS CCART
							INNER JOIN (
							SELECT distinct IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
							 FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
							) AS ArtigosAntigos
							ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
									AND isnull(CCART.Quantidade,0) = 0 AND isnull(CCART.QuantidadeStock,0) = 0 AND isnull(CCART.QuantidadeStock2,0) = 0
							
							-- apagar CCartigos
							DELETE FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
						END
				END		
		END
END TRY
BEGIN CATCH
	SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
	RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')

alter table tbartigos add [Torcao] [bigint] NULL

alter table tbdocumentosvendas add [DataControloInterno] [datetime] NULL

alter table tbdocumentosvendaslinhas add 
	[IDUnidadeStock] [bigint] NULL, 
	[IDUnidadeStock2] [bigint] NULL, 
	[QuantidadeStock] [float] NULL, 
	[QuantidadeStock2] [float] NULL,
	[PrecoUnitarioMoedaRef] [float] NULL,
	[PrecoUnitarioEfetivoMoedaRef] [float] NULL,
	[QtdStockAnterior] [float] NULL,
	[QtdStockAtual] [float] NULL,
	[UPCMoedaRef] [float] NULL,
	[PCMAnteriorMoedaRef] [float] NULL,
	[PCMAtualMoedaRef] [float] NULL,
	[PVMoedaRef] [float] NULL,
	[Alterada] [bit] NULL,
	[ValorizouOrigem] [bit] NULL,
	[MovStockOrigem] [bit] NULL,
	[NumCasasDecUnidadeStk] [smallint] NULL,
	[NumCasasDec2UnidadeStk] [smallint] NULL,
	[FatorConvUnidStk] [float] NULL,
	[FatorConv2UnidStk] [float] NULL,
	[QtdStockAnteriorOrigem] [float] NULL,
	[QtdStockAtualOrigem] [float] NULL,
	[PCMAnteriorMoedaRefOrigem] [float] NULL,
	[QtdAfetacaoStock] [float] NULL,
	[QtdAfetacaoStock2] [float] NULL,
	[OperacaoConvUnidStk] [nvarchar](50) NULL,
	[OperacaoConv2UnidStk] [nvarchar](50) NULL,
	[IDTipoPreco] [bigint] NULL,
	[CodigoTipoPreco] [nvarchar](6) NULL,
	[IDCodigoIva] [bigint] NULL,
	[UPCompraMoedaRef] [float] NULL,
	[UltCustosAdicionaisMoedaRef] [float] NULL,
	[UltDescComerciaisMoedaRef] [float] NULL,
	[PrecoUnitarioEfetivoMoedaRefOrigem] [float] NULL


ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbUnidades2] FOREIGN KEY([IDUnidadeStock])
REFERENCES [dbo].[tbUnidades] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbUnidades2]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbUnidades3] FOREIGN KEY([IDUnidadeStock2])
REFERENCES [dbo].[tbUnidades] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbUnidades3]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaTiposPrecos] FOREIGN KEY([IDTipoPreco])
REFERENCES [dbo].[tbSistemaTiposPrecos] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaTiposPrecos]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaCodigosIVA] FOREIGN KEY([IDCodigoIva])
REFERENCES [dbo].[tbSistemaCodigosIVA] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaCodigosIVA]

drop table tbFornecedoresTiposFornecimentos

CREATE TABLE [dbo].[tbFornecedoresTiposFornecimento](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTipoFornecimento] [bigint] NOT NULL,
	[IDFornecedor] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [int] NOT NULL,
 CONSTRAINT [PK_tbFornecedoresTiposFornecimento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[tbFornecedoresTiposFornecimento] ADD  CONSTRAINT [DF_tbFornecedoresTiposFornecimento_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbFornecedoresTiposFornecimento] ADD  CONSTRAINT [DF_tbFornecedoresTiposFornecimento_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbFornecedoresTiposFornecimento] ADD  CONSTRAINT [DF_tbFornecedoresTiposFornecimento_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbFornecedoresTiposFornecimento]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresTiposFornecimento_tbFornecedores] FOREIGN KEY([IDFornecedor])
REFERENCES [dbo].[tbFornecedores] ([ID])

ALTER TABLE [dbo].[tbFornecedoresTiposFornecimento] CHECK CONSTRAINT [FK_tbFornecedoresTiposFornecimento_tbFornecedores]

ALTER TABLE [dbo].[tbFornecedoresTiposFornecimento]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresTiposFornecimento_tbTiposFornecimentos] FOREIGN KEY([IDTipoFornecimento])
REFERENCES [dbo].[tbTiposFornecimentos] ([ID])

ALTER TABLE [dbo].[tbFornecedoresTiposFornecimento] CHECK CONSTRAINT [FK_tbFornecedoresTiposFornecimento_tbTiposFornecimentos]


EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumento] ON 
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (10, N''FC'', N''Fatura de Compra'', 3, 10, 0, 1, CAST(N''2017-05-30 09:17:28.037'' AS DateTime), N''F3M'', NULL, NULL, NULL, 5, 1, 1, 0, 0, 1, 0, 0, 1, 0, 2, 3, 0, 0, 0, 0, 0, 0, 0, 1, 2, 15, NULL, NULL, NULL, 1, 1, NULL, 12, 0, 1, 0)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (11, N''ES'', N''Entrada de Stock'', 1, 2, 0, 1, CAST(N''2017-05-30 12:27:39.000'' AS DateTime), N''F3M'', CAST(N''2017-05-30 12:27:53.227'' AS DateTime), N''F3M'', NULL, NULL, 1, 0, 0, 0, 1, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1, 2, 13, NULL, NULL, NULL, 1, 1, NULL, 1, 0, 0, 0)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (12, N''SS'', N''Saída de Stock'', 1, 3, 0, 1, CAST(N''2017-05-30 12:28:50.000'' AS DateTime), N''F3M'', CAST(N''2017-05-30 12:28:58.593'' AS DateTime), N''F3M'', NULL, NULL, 1, 0, 0, 0, 1, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1, 3, 13, NULL, NULL, NULL, 1, 1, NULL, 2, 0, 0, 0)
SET IDENTITY_INSERT [dbo].[tbTiposDocumento] OFF')

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ON 
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (19, 10, 1, 0, 0, CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', 19, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (20, 10, 2, 0, 0, CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', 20, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (21, 10, 3, 0, 0, CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', 21, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (22, 10, 4, 0, 0, CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', 22, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (23, 11, 13, 0, 0, CAST(N''2017-05-30 12:27:53.240'' AS DateTime), N''F3M'', CAST(N''2017-05-30 12:27:53.240'' AS DateTime), N''F3M'', 23, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (24, 11, 14, 0, 0, CAST(N''2017-05-30 12:27:53.243'' AS DateTime), N''F3M'', CAST(N''2017-05-30 12:27:53.243'' AS DateTime), N''F3M'', 24, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (25, 12, 13, 0, 0, CAST(N''2017-05-30 12:28:58.597'' AS DateTime), N''F3M'', CAST(N''2017-05-30 12:28:58.597'' AS DateTime), N''F3M'', 25, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (26, 12, 14, 0, 0, CAST(N''2017-05-30 12:28:58.597'' AS DateTime), N''F3M'', CAST(N''2017-05-30 12:28:58.597'' AS DateTime), N''F3M'', 26, 0)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] OFF')

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumentoSeries] ON 
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (10, cast(year(getdate()) as nvarchar(4)) +''FC'', cast(year(getdate()) as nvarchar(4)) +''FC'', 1, 10, 0, 1, CAST(N''2017-05-30 09:17:28.277'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 17)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (11, cast(year(getdate()) as nvarchar(4)) +''ES'', cast(year(getdate()) as nvarchar(4)) +''ES'', 1, 11, 0, 1, CAST(N''2017-05-30 12:27:38.903'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 16)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (12, cast(year(getdate()) as nvarchar(4)) +''SS'', cast(year(getdate()) as nvarchar(4)) +''SS'', 1, 12, 0, 1, CAST(N''2017-05-30 12:28:50.740'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 16)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoSeries] OFF')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] WHERE [IDPerfis]=1 and [IDMenusAreasEmpresa] in (10,11,12))
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES ( 1, 7, 10, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 09:16:25.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES ( 1, 7, 11, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:26:30.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES ( 1, 7, 12, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:27:59.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
END')


EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbSistemaTipoLista] WHERE ID=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbSistemaTipoLista] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N''1'', N''Lista'', 1, 1, CAST(N''2015-11-11 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2015-11-11 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaTipoLista] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N''2'', N''Consulta'', 1, 1, CAST(N''2015-11-11 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2015-11-11 00:00:00.000'' AS DateTime), N''F3M'')
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbSistemaCategListasPers] WHERE ID=1)
BEGIN
DECLARE @IDMenu as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Artigos''
INSERT [F3MOGeral].[dbo].[tbSistemaCategListasPers] ([ID], [Descricao], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N''Artigos'', @IDMenu, 0, 1, CAST(N''2015-12-18 17:54:54.977'' AS DateTime), N''F3M'', CAST(N''2015-12-18 17:54:54.977'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCategListasPers] ([ID], [Descricao], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N''Fornecedores'', @IDMenu, 0, 1, CAST(N''2015-12-18 17:54:54.977'' AS DateTime), N''F3M'', CAST(N''2015-12-18 17:54:54.977'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCategListasPers] ([ID], [Descricao], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N''Clientes'', @IDMenu, 0, 1, CAST(N''2015-12-18 17:54:54.977'' AS DateTime), N''F3M'', CAST(N''2015-12-18 17:54:54.977'' AS DateTime), N''F3M'')
END')

EXEC('UPDATE [F3MOGeral].[dbo].[tbListasPersonalizadas] SET IDSistemaTipoLista=1')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbSistemaCriterio] WHERE ID=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, 1, N''Igual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, 1, N''ComecaPor'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, 1, N''Contem'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, 1, N''Diferente'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (5, 1, N''EVazio'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (6, 1, N''NaoEVazio'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (7, 4, N''Igual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (8, 4, N''Maior'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (9, 4, N''MaiorOuIgual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (10, 4, N''Menor'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (11, 4, N''MenorOuIgual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (12, 4, N''Diferente'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (13, 4, N''EVazio'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (14, 4, N''NaoEVazio'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (15, 3, N''Igual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (16, 3, N''Maior'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (17, 3, N''MaiorOuIgual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (18, 3, N''Menor'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (19, 3, N''MenorOuIgual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (20, 3, N''Diferente'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (21, 3, N''EVazio'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (22, 3, N''NaoEVazio'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (25, 5, N''Igual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (26, 5, N''Diferente'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (27, 0, N''Igual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (28, 0, N''Maior'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (29, 0, N''MaiorOuIgual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (30, 0, N''Menor'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (31, 0, N''MenorOuIgual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (32, 0, N''Diferente'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (33, 0, N''EVazio'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (34, 0, N''NaoEVazio'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (35, 2, N''Igual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (36, 2, N''Diferente'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (37, 2, N''EVazio'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (38, 2, N''NaoEVazio'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (39, 1, N''Maior'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (40, 1, N''MaiorOuIgual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (41, 1, N''Menor'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbSistemaCriterio] ([ID], [TipoColuna], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (42, 1, N''MenorOuIgual'', 1, 1, CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-05-16 00:00:00.000'' AS DateTime), N''F3M'')
END')

EXEC('ALTER TABLE tbSistemaTiposEstados ADD AtivaPredefNovosDocs bit not null DEFAULT 0')

EXEC('UPDATE tbSistemaTiposEstados SET AtivaPredefNovosDocs = 1 where Codigo=''RSC'' OR Codigo=''EFT''')

EXEC('UPDATE [F3MOGeral].dbo.tbSistemaTiposEstados SET AtivaPredefNovosDocs = 1 where Codigo=''RSC'' OR Codigo=''EFT''')

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumento] ON 
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (13, N''NV'', N''Nota Devolução'', 3, 9, 0, 1, CAST(N''2017-07-04 16:53:27.390'' AS DateTime), N''F3M'', NULL, NULL, NULL, 4, 1, 0, 0, 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1, 3, 15, NULL, NULL, NULL, 1, 1, NULL, 11, 0, 0, 0)
SET IDENTITY_INSERT [dbo].[tbTiposDocumento] OFF')

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ON 
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (27, 13, 1, 0, 0, CAST(N''2017-07-04 16:53:27.743'' AS DateTime), N''F3M'', CAST(N''2017-07-04 16:53:27.743'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (28, 13, 2, 0, 0, CAST(N''2017-07-04 16:53:27.747'' AS DateTime), N''F3M'', CAST(N''2017-07-04 16:53:27.747'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (29, 13, 3, 0, 0, CAST(N''2017-07-04 16:53:27.750'' AS DateTime), N''F3M'', CAST(N''2017-07-04 16:53:27.750'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (30, 13, 4, 0, 0, CAST(N''2017-07-04 16:53:27.753'' AS DateTime), N''F3M'', CAST(N''2017-07-04 16:53:27.753'' AS DateTime), N''F3M'', 0, 0)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] OFF')

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumentoSeries] ON 
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (13, cast(year(getdate()) as nvarchar(4)) +''NV'', cast(year(getdate()) as nvarchar(4)) +''NV'', 1, 13, 0, 1, CAST(N''2017-07-04 16:53:27.487'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 17)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoSeries] OFF')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] WHERE [IDPerfis]=1 and [IDMenusAreasEmpresa] in (13))
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 13, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:27:59.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
END')

update tbParametrosCamposContexto set valorcampo='2' where IDTipoDados=2 and valorcampo='Custo Padrão'
update tbParametrosCamposContexto set valorcampo='1' where IDTipoDados=2 and valorcampo='UPC'
update tbParametrosCamposContexto set valorcampo='1' where IDTipoDados=2 and valorcampo='Desativar o lote'
update tbParametrosCamposContexto set valorcampo='1' where IDTipoDados=2 and valorcampo='Alertar com'

EXEC('Update tbSistemaTiposEstados set [Cor] = ''est-final'' where descricao = ''Efetivo''')

EXEC('ALTER TABLE tbIVA ALTER COLUMN Taxa decimal(5, 2) NOT NULL')

CREATE UNIQUE NONCLUSTERED INDEX [IX_tbIVARegioes] ON [dbo].[tbIVARegioes] (
	[IDIva] ASC,
	[IDRegiao] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

EXEC('alter table [dbo].[tbTiposDocumento] ADD [Predefinido] BIT NULL DEFAULT (0)')
EXEC('update tbtiposdocumento set IDSistemaTiposDocumentoPrecoUnitario=2 where IDModulo in (4)')
EXEC('update tbTiposDocumento set Predefinido=0')
EXEC('update tbtiposdocumento set predefinido=1 where id in (3,10,11)')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=112)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) VALUES (112, 24, N''UnidadesRelacoes'', N''014.004.028'', N''UnidadesRelacoes'', 1600, N''f3icon-units2'', N''/TabelasAuxiliares/UnidadesRelacoes'', 1, 14, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=112 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 112, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-06-02 16:18:43.917'' AS DateTime), N''F3M'', CAST(N''2017-06-02 16:18:43.917'' AS DateTime), N''F3M'', NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (2, 112, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-06-02 16:18:43.917'' AS DateTime), N''F3M'', CAST(N''2017-06-02 16:18:43.917'' AS DateTime), N''F3M'', NULL, NULL)
END')

INSERT [dbo].[tbSistemaClassificacoesTiposArtigos] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (6, N'PR', N'Portes', 1, 1, CAST(N'2015-08-08 00:00:00.000' AS DateTime), N'f3m', CAST(N'2015-07-10 16:47:54.840' AS DateTime), N'f3m')

SET IDENTITY_INSERT [dbo].[tbTiposArtigos] ON 
INSERT [dbo].[tbTiposArtigos] ([ID], [IDSistemaClassificacao], [IDSistemaClassificacaoGeral], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (6, 6, 7, N'PR', N'Portes', NULL, 1, 1, CAST(N'2016-07-01 12:05:55.867' AS DateTime), N'F3M', CAST(N'2016-07-05 15:48:24.953' AS DateTime), N'F3M')
SET IDENTITY_INSERT [dbo].[tbTiposArtigos] OFF

ALTER TABLE [dbo].[tbDocumentosStock] ADD [VossoNumeroDocumento] [nvarchar](256)  NULL
ALTER TABLE [dbo].[tbDocumentosStockLinhas] ADD [VossoNumeroDocumentoOrigem] [nvarchar](256) NULL,[NumeroDocumentoOrigem] [bigint] NULL,[IDTiposDocumentoSeriesOrigem] [bigint] NULL
ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbTiposDocumentoSeriesOrigem] FOREIGN KEY([IDTiposDocumentoSeriesOrigem])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])
ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbTiposDocumentoSeriesOrigem]

ALTER TABLE [dbo].[tbDocumentosCompras] ADD [VossoNumeroDocumento] [nvarchar](256)  NULL
ALTER TABLE [dbo].[tbDocumentosComprasLinhas] ADD [VossoNumeroDocumentoOrigem] [nvarchar](256) NULL,[NumeroDocumentoOrigem] [bigint] NULL,[IDTiposDocumentoSeriesOrigem] [bigint] NULL
ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbTiposDocumentoSeriesOrigem] FOREIGN KEY([IDTiposDocumentoSeriesOrigem])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbTiposDocumentoSeriesOrigem]

ALTER TABLE [dbo].[tbDocumentosVendas] ADD [VossoNumeroDocumento] [nvarchar](256)  NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [VossoNumeroDocumentoOrigem] [nvarchar](256) NULL,[NumeroDocumentoOrigem] [bigint] NULL,[IDTiposDocumentoSeriesOrigem] [bigint] NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbTiposDocumentoSeriesOrigem] FOREIGN KEY([IDTiposDocumentoSeriesOrigem])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbTiposDocumentoSeriesOrigem]

ALTER TABLE [dbo].[tbCCStockArtigos] ADD [IDTiposDocumentoSeries] [bigint] NULL,[IDTiposDocumentoSeriesOrigem] [bigint] NULL,[VossoNumeroDocumento] [nvarchar](256) NULL,[VossoNumeroDocumentoOrigem] [nvarchar](256) NULL,[NumeroDocumentoOrigem] [bigint] NULL
ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_tbTiposDocumentoSeries] FOREIGN KEY([IDTiposDocumentoSeries])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])
ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_tbTiposDocumentoSeries]
ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_tbTiposDocumentoSeriesOrigem] FOREIGN KEY([IDTiposDocumentoSeriesOrigem])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])
ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_tbTiposDocumentoSeriesOrigem]


EXEC('IF (NOT EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwCCArtigos''))
BEGIN
EXECUTE(''create view vwCCArtigos as
select 
(CASE WHEN isnull(tbCCStockArtigos.NumeroDocumento,0) = 0 THEN tbCCStockArtigos.VossoNumeroDocumento
                         ELSE tbTiposDocumento.Codigo + '''' '''' + isnull(tbTiposDocumentoSeries.CodigoSerie,'''''''') + ''''/'''' + CAST(tbCCStockArtigos.NumeroDocumento AS nvarchar(20)) END) as Documento,
(CASE WHEN isnull(tbCCStockArtigos.NumeroDocumentoOrigem,0) = 0 THEN tbCCStockArtigos.VossoNumeroDocumentoOrigem
                         ELSE tbTiposDocumentoOrigem.Codigo + '''' '''' + isnull(tbTiposDocumentoSeriesOrigem.CodigoSerie,'''''''') + ''''/'''' + CAST(tbCCStockArtigos.NumeroDocumentoOrigem AS nvarchar(20)) END) as DocumentoOrigem,
tbCCStockArtigos.NumeroDocumento,
tbCCStockArtigos.DataDocumento,
tbArtigos.Codigo as CodigoArtigo,
tbArtigos.Descricao as DescricaoArtigo,
tbArmazens.Codigo as CodigoArmazem,
tbArmazens.Descricao as DescricaoArmazem,
tbArmazensLocalizacoes.Codigo as CodigoLocalizacao,
tbArmazensLocalizacoes.Descricao as DescricaoLocalizacao,
tbDimensoesLinhas.Descricao as DescricaoDimensaoLinha1,
tbDimensoesLinhas1.Descricao as DescricaoDimensaoLinha2,
tbCCStockArtigos.QuantidadeStock,
tbCCStockArtigos.QuantidadeStock2,
tbCCStockArtigos.PrecoUnitarioEfetivoMoedaRef as PrecoUnitarioMoedaRef,
tbCCStockArtigos.Recalcular as RecalcularCustoMedio,
tbCCStockArtigos.DataControloInterno 
FROM tbCCStockArtigos AS tbCCStockArtigos
LEFT JOIN tbArtigos AS tbArtigos ON tbArtigos.id=tbCCStockArtigos.IDArtigo
LEFT JOIN tbArtigosDimensoes AS tbArtigosDimensoes ON tbArtigosDimensoes.IDArtigo=tbArtigos.ID
LEFT JOIN tbDimensoesLinhas AS tbDimensoesLinhas ON tbDimensoesLinhas.ID = tbArtigosDimensoes.IDDimensaoLinha1
LEFT JOIN tbDimensoesLinhas AS tbDimensoesLinhas1 ON tbDimensoesLinhas1.ID = tbArtigosDimensoes.IDDimensaoLinha2
LEFT JOIN tbArmazens AS tbArmazens ON tbArmazens.ID = tbCCStockArtigos.IDArmazem
LEFT JOIN tbArmazensLocalizacoes AS tbArmazensLocalizacoes ON tbArmazensLocalizacoes.IDArmazem = tbArmazens.id
LEFT JOIN tbTiposDocumento AS tbTiposDocumento ON tbTiposDocumento.ID=tbCCStockArtigos.IDTipoDocumento
LEFT JOIN tbTiposDocumento AS tbTiposDocumentoOrigem ON tbTiposDocumentoOrigem.ID=tbCCStockArtigos.IDTipoDocumentoOrigem
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries ON tbTiposDocumentoSeries.ID=tbCCStockArtigos.IDTiposDocumentoSeries
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeriesOrigem ON tbTiposDocumentoSeriesOrigem.ID=tbCCStockArtigos.IDTiposDocumentoSeriesOrigem
ORDER BY DataControloInterno, DataDocumento, CodigoArmazem, CodigoArtigo, CodigoLocalizacao,DescricaoDimensaoLinha1, DescricaoDimensaoLinha2  OFFSET 0 ROWS 
'')
END')

EXEC('IF (NOT EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwStokArtigos''))
BEGIN
EXECUTE(''create view vwStokArtigos as
select tbArtigos.Codigo as CodigoArtigo,
       tbArtigos.Descricao as DescricaoArtigo,
          tbDimensoesLinhas.Descricao as DescricaoDimensaoLinha1,
          tbDimensoesLinhas1.Descricao as DescricaoDimensaoLinha2,
          (case WHEN tbArtigosDimensoes.IDArtigo is NULL then tbArtigos.Medio else tbArtigosDimensoes.CustoMedio end) as Medio,
          (case WHEN tbArtigosDimensoes.IDArtigo is NULL then tbArtigos.UltimoPrecoCusto else tbArtigosDimensoes.UPC end) as UltimoPrecoCusto,
          (case WHEN tbArtigosDimensoes.IDArtigo is NULL then tbArtigos.UltimoPrecoCompra else tbArtigosDimensoes.UltPrecoComp end) as UltimoPrecoCompra,
          (case WHEN tbArtigosDimensoes.IDArtigo is NULL then tbArtigos.UltimosCustosAdicionais else tbArtigosDimensoes.UltimoCustoAdicional end) as UltimosCustosAdicionais,
          (case WHEN tbArtigosDimensoes.IDArtigo is NULL then tbArtigos.UltimosDescontosComerciais else 0 end) as UltimosDescontosComerciais,
          (case WHEN tbArtigosDimensoes.IDArtigo is NULL then tbArtigosStock.Atual else tbArtigosDimensoes.StkArtigo end) as Atual,
          (case WHEN tbArtigosDimensoes.IDArtigo is NULL then tbArtigosStock.StockAtual2 else tbArtigosDimensoes.StkArtigo2 end) as StockAtual2,
          (case WHEN tbArtigosDimensoes.IDArtigo is NULL then tbArtigosStock.Reservado else 0 end) as Reservado,
          (case WHEN tbArtigosDimensoes.IDArtigo is NULL then tbArtigosStock.Reservado2 else 0 end) as Reservado2,
          tbArtigosStock.PrimeiraEntrada as PrimeiraEntrada,
          tbArtigosStock.UltimaEntrada as UltimaEntrada,
          tbArtigosStock.PrimeiraSaida as PrimeiraSaida,
          tbArtigosStock.UltimaSaida as UltimaSaida,
          tbDimensoesLinhas.Ordem as OrdemDimensaoLinha1,
          tbDimensoesLinhas1.Ordem as OrdemDimensaoLinha2
from tbArtigos
LEFT JOIN tbArtigosStock as tbArtigosStock On tbArtigosStock.IDArtigo = tbArtigos.ID
LEFT JOIN tbArtigosDimensoes AS tbArtigosDimensoes ON tbArtigosDimensoes.IDArtigo=tbArtigos.ID
LEFT JOIN tbDimensoesLinhas AS tbDimensoesLinhas ON tbDimensoesLinhas.ID = tbArtigosDimensoes.IDDimensaoLinha1
LEFT JOIN tbDimensoesLinhas AS tbDimensoesLinhas1 ON tbDimensoesLinhas1.ID = tbArtigosDimensoes.IDDimensaoLinha2
ORDER BY CodigoArtigo, OrdemDimensaoLinha1, OrdemDimensaoLinha2
  OFFSET 0 ROWS 
'')
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao=''Consultas'')
BEGIN
INSERT [F3MOGeral].[dbo].[tbMenus] ([IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) VALUES (NULL, N''Consultas'', N''018'', N''Consultas'', 1800000, N''f3icon-list-alt'', N''../F3M/Consultas/Consultas/Index?IDCategoria=1'', 1, 14, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus in (SELECT ID as IDMenus FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao=''Consultas'') and IDPerfis=1)
BEGIN
DECLARE @IDMenu as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, @IDMenu, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-06-02 16:18:43.917'' AS DateTime), N''F3M'', CAST(N''2017-06-02 16:18:43.917'' AS DateTime), N''F3M'', NULL, NULL)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Artigos'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDCateg as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
SELECT @IDCateg = ID  FROM [F3MOGeral].[dbo].[tbSistemaCategListasPers] WHERE Descricao=''Artigos''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Conta Corrente de Artigos'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbCCStockArtigos'', 
N''select * from vwCCArtigos'', @IDCateg, 2)
END')


EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Stock Artigos'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDCateg as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
SELECT @IDCateg = ID  FROM [F3MOGeral].[dbo].[tbSistemaCategListasPers] WHERE Descricao=''Artigos''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Stock Artigos'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbStockArtigos'', 
N''select * from vwStokArtigos'', @IDCateg, 2)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Caixa'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDCateg as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
SELECT @IDCateg = ID  FROM [F3MOGeral].[dbo].[tbSistemaCategListasPers] WHERE Descricao=''Clientes''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Mapa de Caixa'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbMapaCaixa'', 
N''select IDLoja, Natureza, IDFormaPagamento, DescricaoFormaPagamento, NumeroDocumento, DataDocumento, Descricao, TotalMoeda, Ativo from tbmapacaixa'', @IDCateg, 2)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Clientes'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDCateg as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
SELECT @IDCateg = ID  FROM [F3MOGeral].[dbo].[tbSistemaCategListasPers] WHERE Descricao=''Clientes''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Conta Corrente de Clientes'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbCCEntidades'', 
N''select IDLoja, Natureza,  IDEntidade, NomeFiscal, NumeroDocumento, DataDocumento, Descricao, TotalMoeda, Ativo from tbCCEntidades'', @IDCateg, 2)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada IN (SELECT ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Caixa''))
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Caixa''
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDFormaPagamento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFormasPagamento'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoFormaPagamento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Descricao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TotalMoeda'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 2, 150)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada IN (SELECT ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Clientes''))
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Clientes''
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Descricao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TotalMoeda'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada IN (SELECT ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Stock Artigos''))
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Stock Artigos''
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbArtigos'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 200)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoDimensaoLinha1'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoDimensaoLinha2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Medio'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UltimoPrecoCusto'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UltimoPrecoCompra'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UltimosCustosAdicionais'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UltimosDescontosComerciais'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Atual'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''StockAtual2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL,NULL, 0, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Reservado'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Reservado2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PrimeiraEntrada'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UltimaEntrada'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PrimeiraSaida'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UltimaSaida'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''OrdemDimensaoLinha1'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''OrdemDimensaoLinha2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 100)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada IN (SELECT ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Artigos''))
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Artigos''
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 120)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DocumentoOrigem'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 120)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataControloInterno'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 4, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbArtigos'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoArmazem'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbArmazens'', 1, 5, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoArmazem'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLocalizacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbArmazensLocalizacoes'', 1, 5, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoLocalizacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLote'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoLote'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QuantidadeStock'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QuantidadeStock2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PrecoUnitarioMoedaRef'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''RecalcularCustoMedio'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 2, 150)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] WHERE IDListaPersonalizada IN (SELECT ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Caixa''))
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Caixa''
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''Ativo'', 0, N''Ativo'', N''True'', N'''', 35, N'''', 1, CAST(N''2017-06-19 16:36:41.870'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:36:41.870'' AS DateTime), N''1'')
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] WHERE IDListaPersonalizada IN (SELECT ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Clientes''))
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Clientes''
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''Ativo'', 0, N''Ativo'', N''True'', N'''', 35, N'''', 1, CAST(N''2017-06-19 16:47:10.370'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.370'' AS DateTime), N''1'')
END')

EXEC('update [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] set columnwidth=300 where tabela in (''tbTiposDocumentos'', ''tbUtilizadores'', ''tbPerfis'')') 
EXEC('update [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] set columnwidth=500 where tabela in (''tbTiposDocumentos'', ''tbPerfis'') and colunavista=''Descricao''')