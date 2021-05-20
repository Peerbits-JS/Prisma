CREATE TABLE [dbo].[tbParametrosLojaLinhas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDLoja] [bigint] NOT NULL,
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
 CONSTRAINT [PK_tbParametrosLojaLinhas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbParametrosLojaLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosLojaLinhas_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbParametrosLojaLinhas] CHECK CONSTRAINT [FK_tbParametrosLojaLinhas_tbLojas]

CREATE TABLE [dbo].[tbCampanhas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](10) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbCampanhas_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbCampanhas_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbCampanhas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbCampanhas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[tbServicos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Ordem] [int] NOT NULL,
	[IDTipoServico] [bigint] NOT NULL,
	[IDMedicoTecnico] [bigint] NULL,
	[DataReceita] [datetime] NULL,
	[DataEntregaLonge] [datetime] NULL,
	[DataEntregaPerto] [datetime] NULL,
	[VerPrismas] [bit] NULL,
	[VisaoIntermedia] [bit] NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[IDTipoServicoOlho] [bigint] NOT NULL,
	[CombinacaoDefeito] [bit] NULL,
	[BoxLonge] [nvarchar] (50) NULL,
	[BoxPerto] [nvarchar] (50) NULL,
 CONSTRAINT [PK_tbServicos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbServicos] ADD  CONSTRAINT [DF_tbServicos_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbServicos] ADD  CONSTRAINT [DF_tbServicos_VerPrismas]  DEFAULT ((0)) FOR [VerPrismas]

ALTER TABLE [dbo].[tbServicos] ADD  CONSTRAINT [DF_tbServicos_VisaoIntermedia]  DEFAULT ((0)) FOR [VisaoIntermedia]

ALTER TABLE [dbo].[tbServicos] ADD  CONSTRAINT [DF_tbServicos_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbServicos] ADD  CONSTRAINT [DF_tbServicos_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbServicos] ADD  CONSTRAINT [DF_tbServicos_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]

ALTER TABLE [dbo].[tbServicos] ADD  CONSTRAINT [DF_tbServicos_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbServicos] ADD  CONSTRAINT [DF_tbServicos_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbServicos]  WITH CHECK ADD  CONSTRAINT [FK_tbServicos_tbMedicosTecnicos] FOREIGN KEY([IDMedicoTecnico])
REFERENCES [dbo].[tbMedicosTecnicos] ([ID])

ALTER TABLE [dbo].[tbServicos] CHECK CONSTRAINT [FK_tbServicos_tbMedicosTecnicos]

ALTER TABLE [dbo].[tbServicos]  WITH CHECK ADD  CONSTRAINT [FK_tbServicos_tbSistemaTiposServicos] FOREIGN KEY([IDTipoServico])
REFERENCES [dbo].[tbSistemaTiposServicos] ([ID])

ALTER TABLE [dbo].[tbServicos] CHECK CONSTRAINT [FK_tbServicos_tbSistemaTiposServicos]

CREATE TABLE [dbo].[tbDocumentosVendas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTipoDocumento] [bigint] NOT NULL,
	[NumeroDocumento] [bigint] NULL,
	[DataDocumento] [datetime] NOT NULL,
	[DataAssinatura] [datetime] NULL,
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
	[Impresso] [bit] NOT NULL,
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
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[IDFormaExpedicao] [bigint] NULL,
	[IDTiposDocumentoSeries] [bigint] NOT NULL,
	[NumeroInterno] [bigint] NULL,
	[IDEntidade] [bigint] NOT NULL,
	[IDTipoEntidade] [bigint] NULL,
	[IDCondicaoPagamento] [bigint] NULL,
	[IDCliente] [bigint] NULL,
	[IDLocalOperacao] [bigint] NULL,
	[CodigoAT] [nvarchar](200) NULL,
	[DataVencimento] datetime null,
	[DataNascimento] datetime null,
	[Idade] int null,
	[IDEntidade1] bigint null,
	[NumeroBeneficiario1] [nvarchar](50) NULL,
	[Parentesco1] [nvarchar](50) null,
	[IDEntidade2] bigint null,
	[NumeroBeneficiario2] [nvarchar](50) NULL,
	[Parentesco2] [nvarchar](50) null,
	[Email] [nvarchar](255) null,
	[SubTotal] [float] NULL,
	[DescontosLinha] [float] NULL,
	[OutrosDescontos] [float] NULL,
	[TotalPontos] [float] NULL,
	[TotalValesOferta] [float] NULL,
	[TotalIva] [float] NULL,
	[TotalEntidade1] [float] NULL,
	[TotalEntidade2] [float] NULL,
	[IDPaisCarga] [bigint] NULL,
	[IDPaisDescarga] [bigint] NULL,
	[Matricula] [nvarchar](255) NULL,
	[IDPaisFiscal] [bigint] NULL,
	[CodigoPostalFiscal] [nvarchar](10) NULL,
	[DescricaoCodigoPostalFiscal] [nvarchar](50) NULL,
	[DescricaoConcelhoFiscal] [nvarchar](50) NULL,
	[DescricaoDistritoFiscal] [nvarchar](50) NULL,
	[IDEspacoFiscal] [bigint] NULL,
	[IDRegimeIva] [bigint] NULL,
	[Entidade1Automatica] bit NULL,
	[ValorPago] [float] NULL,
	[Documento] [nvarchar](50) NULL,
	[CodigoATInterno] [nvarchar](200) NULL,
	[TipoFiscal] [nvarchar](20) NULL,
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
	[MensagemDocAT] [nvarchar](1000) NULL,
	[CodigoMoeda] [nvarchar](20) NULL,
	[IDSisTiposDocPU] bigint NULL,
	[CodigoSisTiposDocPU] nvarchar(6) NULL,
	[DocManual] bit null,
	[DocReposicao] bit null,
	[SerieDocManual] [nvarchar](50) NULL,
	[NumeroDocManual] [nvarchar](50) NULL,
	[OrigemEntidade2] [bit] NULL,
	[SegundaVia] [bit] NULL,
	[SerieManual] [nvarchar](50) NULL,
	[NumeroManual] [nvarchar](50) NULL,
	[Adiantamento] [bit] NULL,
	[TotalClienteMoedaDocumento] [float] NULL,
	[TotalClienteMoedaReferencia] [float] NULL,
	CONSTRAINT [PK_tbDocumentosVendas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbDocumentosVendas] ADD  CONSTRAINT [DF_tbDocumentosVendas_Impresso]  DEFAULT ((0)) FOR [Impresso]


ALTER TABLE [dbo].[tbDocumentosVendas] ADD  CONSTRAINT [DF_tbDocumentosVendas_Sistema]  DEFAULT ((0)) FOR [Sistema]


ALTER TABLE [dbo].[tbDocumentosVendas] ADD  CONSTRAINT [DF_tbDocumentosVendas_Ativo]  DEFAULT ((1)) FOR [Ativo]


ALTER TABLE [dbo].[tbDocumentosVendas] ADD  CONSTRAINT [DF_tbDocumentosVendas_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]


ALTER TABLE [dbo].[tbDocumentosVendas] ADD  CONSTRAINT [DF_tbDocumentosVendas_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]


ALTER TABLE [dbo].[tbDocumentosVendas] ADD  CONSTRAINT [DF_tbDocumentosVendas_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbDocumentosVendas] ADD  CONSTRAINT [DF_tbDocumentosVendas_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbCodigosPostais_Carga] FOREIGN KEY([IDCodigoPostalCarga])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbCodigosPostais_Carga]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbCodigosPostais_Descarga] FOREIGN KEY([IDCodigoPostalDescarga])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbCodigosPostais_Descarga]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbCodigosPostais_Destinatario] FOREIGN KEY([IDCodigoPostalDestinatario])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbCodigosPostais_Destinatario]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbCodigosPostais_Fiscal] FOREIGN KEY([IDCodigoPostalFiscal])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbCodigosPostais_Fiscal]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbConcelhos_Carga] FOREIGN KEY([IDConcelhoCarga])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbConcelhos_Carga]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbConcelhos_Descarga] FOREIGN KEY([IDConcelhoDescarga])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbConcelhos_Descarga]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbConcelhos_Destinatario] FOREIGN KEY([IDConcelhoDestinatario])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbConcelhos_Destinatario]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbConcelhos_Fiscal] FOREIGN KEY([IDConcelhoFiscal])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbConcelhos_Fiscal]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbDistritos_Carga] FOREIGN KEY([IDDistritoCarga])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbDistritos_Carga]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbDistritos_Descarga] FOREIGN KEY([IDDistritoDescarga])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbDistritos_Descarga]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbDistritos_Destinatario] FOREIGN KEY([IDDistritoDestinatario])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbDistritos_Destinatario]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbDistritos_Fiscal] FOREIGN KEY([IDDistritoFiscal])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbDistritos_Fiscal]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbEstados] FOREIGN KEY([IDEstado])
REFERENCES [dbo].[tbEstados] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbEstados]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbFormasExpedicao] FOREIGN KEY([IDFormaExpedicao])
REFERENCES [dbo].[tbFormasExpedicao] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbFormasExpedicao]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbIVA_Portes] FOREIGN KEY([IDTaxaIvaPortes])
REFERENCES [dbo].[tbIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbIVA_Portes]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbLojas]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbMoedas]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbPaises] FOREIGN KEY([IDPaisCarga])
REFERENCES [dbo].[tbPaises] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbPaises]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbPaises_Descarga] FOREIGN KEY([IDPaisDescarga])
REFERENCES [dbo].[tbPaises] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbPaises_Descarga]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbPaises_Fiscal] FOREIGN KEY([IDPaisFiscal])
REFERENCES [dbo].[tbPaises] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbPaises_Fiscal]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbSistemaEspacoFiscal] FOREIGN KEY([IDEspacoFiscalPortes])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbSistemaEspacoFiscal]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbSistemaEspacoFiscal1] FOREIGN KEY([IDEspacoFiscal])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbSistemaEspacoFiscal1]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbSistemaRegimeIVA] FOREIGN KEY([IDRegimeIvaPortes])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbSistemaRegimeIVA]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbSistemaRegimeIVA1] FOREIGN KEY([IDRegimeIva])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbSistemaRegimeIVA1]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbSistemaRegioesIVA] FOREIGN KEY([IDLocalOperacao])
REFERENCES [dbo].[tbSistemaRegioesIVA] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbSistemaRegioesIVA]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbTiposDocumento] FOREIGN KEY([IDTipoDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbTiposDocumento]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbTiposDocumentoSeries] FOREIGN KEY([IDTiposDocumentoSeries])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbTiposDocumentoSeries]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbClientes] FOREIGN KEY([IDEntidade])
REFERENCES [dbo].[tbClientes] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbClientes]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbSistemaTiposEntidade] FOREIGN KEY([IDTipoEntidade])
REFERENCES [dbo].[tbSistemaTiposEntidade] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbSistemaTiposEntidade]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbCondicoesPagamento] FOREIGN KEY([IDCondicaoPagamento])
REFERENCES [dbo].[tbCondicoesPagamento] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbCondicoesPagamento]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbEntidades1] FOREIGN KEY([IDEntidade1])
REFERENCES [dbo].[tbEntidades] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbEntidades1]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbEntidades2] FOREIGN KEY([IDEntidade2])
REFERENCES [dbo].[tbEntidades] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbEntidades2]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbSistemaTiposDocumentoPrecoUnitario] FOREIGN KEY([IDSisTiposDocPU])
REFERENCES [dbo].[tbSistemaTiposDocumentoPrecoUnitario] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbSistemaTiposDocumentoPrecoUnitario]

CREATE TABLE [dbo].[tbDocumentosVendasLinhas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDDocumentoVenda] [bigint] NOT NULL,
	[IDCampanha] bigint null,
	[IDArtigo] [bigint] NULL,
	[Descricao] [nvarchar](200) NULL,
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
	[ValorImposto] [float] NULL,
	[IDEspacoFiscal] [bigint] NULL,
	[EspacoFiscal] [nvarchar](50) NULL,
	[IDRegimeIva] [bigint] NULL,
	[RegimeIva] [nvarchar](50) NULL,
	[SiglaPais] [nvarchar](15) NULL,
	[Ordem] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Diametro] [nvarchar](10) NULL,
	[ValorDescontoLinha] [float] NULL,
	[TotalComDescontoLinha] [float] NULL,
	[ValorDescontoCabecalho] [float] NULL,
	[TotalComDescontoCabecalho] [float] NULL,
	[ValorUnitarioEntidade1] [float] NULL,
	[ValorUnitarioEntidade2] [float] NULL,
	[ValorEntidade1] [float] NULL,
	[ValorEntidade2] [float] NULL,
	[TotalFinal] [float] NULL,
	[IDServico] [bigint] NULL,
	[IDTipoServico] [bigint] NULL,
	[IDTipoOlho] [bigint] NULL,
	[TipoDistancia] [nvarchar](50) NULL,
	[TipoOlho] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbDocumentosVendasLinhas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD  CONSTRAINT [DF_tbDocumentosVendasLinhas_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD  CONSTRAINT [DF_tbDocumentosVendasLinhas_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD  CONSTRAINT [DF_tbDocumentosVendasLinhas_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD  CONSTRAINT [DF_tbDocumentosVendasLinhas_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD  CONSTRAINT [DF_tbDocumentosVendasLinhas_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD  CONSTRAINT [DF_tbDocumentosVendasLinhas_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArmazens] FOREIGN KEY([IDArmazem])
REFERENCES [dbo].[tbArmazens] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArmazens]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArmazens_Destino] FOREIGN KEY([IDArmazemDestino])
REFERENCES [dbo].[tbArmazens] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArmazens_Destino]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArmazensLocalizacoes] FOREIGN KEY([IDArmazemLocalizacao])
REFERENCES [dbo].[tbArmazensLocalizacoes] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArmazensLocalizacoes]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArmazensLocalizacoes_Destino] FOREIGN KEY([IDArmazemLocalizacaoDestino])
REFERENCES [dbo].[tbArmazensLocalizacoes] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArmazensLocalizacoes_Destino]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArtigos] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArtigos]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArtigosLotes] FOREIGN KEY([IDLote])
REFERENCES [dbo].[tbArtigosLotes] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArtigosLotes]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArtigosNumerosSeries] FOREIGN KEY([IDArtigoNumSerie])
REFERENCES [dbo].[tbArtigosNumerosSeries] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArtigosNumerosSeries]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbDocumentosVendas] FOREIGN KEY([IDDocumentoVenda])
REFERENCES [dbo].[tbDocumentosVendas] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbDocumentosVendas]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaEspacoFiscal] FOREIGN KEY([IDEspacoFiscal])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaEspacoFiscal]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaRegimeIVA] FOREIGN KEY([IDRegimeIva])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaRegimeIVA]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbUnidades] FOREIGN KEY([IDUnidade])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbUnidades]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbCampanhas] FOREIGN KEY([IDCampanha])
REFERENCES [dbo].[tbCampanhas] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbCampanhas]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbServicos] FOREIGN KEY([IDServico])
REFERENCES [dbo].[tbServicos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbServicos]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaTiposServicos] FOREIGN KEY([IDTipoServico])
REFERENCES [dbo].[tbSistemaTiposServicos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaTiposServicos]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaTiposOlhos] FOREIGN KEY([IDTipoOlho])
REFERENCES [dbo].[tbSistemaTiposOlhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaTiposOlhos]

CREATE TABLE [dbo].[tbDocumentosVendasLinhasGraduacoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTipoOlho] [bigint] null, 
	[IDTipoGraduacao] [bigint] null, 
	[PotenciaEsferica] [float] null,
	[PotenciaCilindrica] [float] null,
	[PotenciaPrismatica] [float] null,
	[BasePrismatica] [nvarchar](10) null,
	[Adicao] [float] null,
	[Eixo] [int] null,
	[RaioCurvatura] [nvarchar](10) null,
	[DetalheRaio] [nvarchar](10) null,
	[DNP] [float] null,
	[Altura] [float] null,
	[AcuidadeVisual] [nvarchar](10) null,
	[AnguloPantoscopico] [nvarchar](10) null,
	[DistanciaVertex] [nvarchar](10) null,
 	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
CONSTRAINT [PK_tbDocumentosVendasLinhasGraduacoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbDocumentosVendasLinhasGraduacoes] ADD  CONSTRAINT [DF_tbDocumentosVendasLinhasGraduacoes_Sistema]  DEFAULT ((0)) FOR [Sistema]


ALTER TABLE [dbo].[tbDocumentosVendasLinhasGraduacoes] ADD  CONSTRAINT [DF_tbDocumentosVendasLinhasGraduacoes_Ativo]  DEFAULT ((1)) FOR [Ativo]


ALTER TABLE [dbo].[tbDocumentosVendasLinhasGraduacoes] ADD  CONSTRAINT [DF_tbDocumentosVendasLinhasGraduacoes_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]


ALTER TABLE [dbo].[tbDocumentosVendasLinhasGraduacoes] ADD  CONSTRAINT [DF_tbDocumentosVendasLinhasGraduacoes_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]


ALTER TABLE [dbo].[tbDocumentosVendasLinhasGraduacoes] ADD  CONSTRAINT [DF_tbDocumentosVendasLinhasGraduacoes_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]


ALTER TABLE [dbo].[tbDocumentosVendasLinhasGraduacoes] ADD  CONSTRAINT [DF_tbDocumentosVendasLinhasGraduacoes_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbDocumentosVendasLinhasGraduacoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhasGraduacoes_tbSistemaTiposOlhos] FOREIGN KEY([IDTipoOlho])
REFERENCES [dbo].[tbSistemaTiposOlhos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhasGraduacoes] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhasGraduacoes_tbSistemaTiposOlhos]

ALTER TABLE [dbo].[tbDocumentosVendasLinhasGraduacoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhasGraduacoes_tbSistemaTiposGraduacoes] FOREIGN KEY([IDTipoGraduacao])
REFERENCES [dbo].[tbSistemaTiposGraduacoes] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhasGraduacoes] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhasGraduacoes_tbSistemaTiposGraduacoes]

CREATE TABLE [dbo].[tbEntidadesComparticipacoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDEntidade] [bigint] NOT NULL,
	[IDTipoArtigo] [bigint] NOT NULL,
	[IDTipoLente] [bigint] NULL,
	[PotenciaEsfericaDe] [float] NULL,
	[PotenciaEsfericaAte] [float] NULL,
	[PotenciaCilindricaDe] [float] NULL,
	[PotenciaCilindricaAte] [float] NULL,
	[PotenciaPrismaticaDe] [float] NULL,
	[PotenciaPrismaticaAte] [float] NULL,
	[ValorMaximo] [float] NULL,
	[Percentagem] [float] NULL,
	[Quantidade] [float] NULL,
	[Duracao] [float] NULL,
	[Ordem] [int] NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbEntidadesComparticipacoes_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbEntidadesComparticipacoes_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbEntidadesComparticipacoes_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbEntidadesComparticipacoes_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbEntidadesComparticipacoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbEntidadesComparticipacoes_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbEntidadesComparticipacoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbEntidadesComparticipacoes]  WITH CHECK ADD  CONSTRAINT [FK_tbEntidadesComparticipacoes_tbEntidades] FOREIGN KEY([IDEntidade])
REFERENCES [dbo].[tbEntidades] ([ID])

ALTER TABLE [dbo].[tbEntidadesComparticipacoes] CHECK CONSTRAINT [FK_tbEntidadesComparticipacoes_tbEntidades]

ALTER TABLE [dbo].[tbEntidadesComparticipacoes]  WITH CHECK ADD  CONSTRAINT [FK_tbEntidadesComparticipacoes_tbSistemaTiposLentes] FOREIGN KEY([IDTipoLente])
REFERENCES [dbo].[tbSistemaTiposLentes] ([ID])

ALTER TABLE [dbo].[tbEntidadesComparticipacoes] CHECK CONSTRAINT [FK_tbEntidadesComparticipacoes_tbSistemaTiposLentes]

ALTER TABLE [dbo].[tbEntidadesComparticipacoes]  WITH CHECK ADD  CONSTRAINT [FK_tbEntidadesComparticipacoes_tbTiposArtigos] FOREIGN KEY([IDTipoArtigo])
REFERENCES [dbo].[tbTiposArtigos] ([ID])

ALTER TABLE [dbo].[tbEntidadesComparticipacoes] CHECK CONSTRAINT [FK_tbEntidadesComparticipacoes_tbTiposArtigos]

CREATE TABLE [dbo].[tbParametrosLojaLinhasValores](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDParametroLojaLinha] [bigint] NOT NULL,
	[Codigo] [varchar](50) NULL,
	[Descricao] [nvarchar](255) NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbParametrosLojaLinhasValores] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbParametrosLojaLinhasValores]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosLojaLinhasValores_tbParametrosLojaLinhas] FOREIGN KEY([IDParametroLojaLinha])
REFERENCES [dbo].[tbParametrosLojaLinhas] ([ID])

ALTER TABLE [dbo].[tbParametrosLojaLinhasValores] CHECK CONSTRAINT [FK_tbParametrosLojaLinhasValores_tbParametrosLojaLinhas]

--INSERT [dbo].[tbParametrosLoja] ([IDMoedaDefeito], [Morada], [Foto], [FotoCaminho], [DesignacaoComercial], [CodigoPostal], [Localidade], [Concelho], [Distrito], [IDPais], [Telefone], [Fax], [Email], [WebSite], [NIF], [ConservatoriaRegistoComercial], [NumeroRegistoComercial], [CapitalSocial], [CasasDecimaisPercentagem], [IDLoja], [IDIdiomaBase], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'Sede', N'', N'~/Fotos/Lojas/', N'.', N'.', N'.', N'.', N'.', 919, N'.', N'.', N'.', N'.', N'.', N'.', N'.', N'.', 6, 1, 111, 1, 1, CAST(N'2016-06-15 00:00:00.000' AS DateTime), N'f3m', NULL, NULL)
INSERT [dbo].[tbParametrosLoja] ([IDMoedaDefeito], [Morada], [Foto], [FotoCaminho], [DesignacaoComercial], [CodigoPostal], [Localidade], [Concelho], [Distrito], [IDPais], [Telefone], [Fax], [Email], [WebSite], [NIF], [ConservatoriaRegistoComercial], [NumeroRegistoComercial], [CapitalSocial], [CasasDecimaisPercentagem], [IDLoja], [IDIdiomaBase], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'Edifício F3M, Rua de Linhares', N'', N'~/Fotos/Lojas/', N'F3M - Information Systems, SA', N'4715-435', N'Braga', N'Braga', N'Braga', 919, N'', N'', N'', N'', N'', N'', N'', N'', 6, 1, 111, 1, 1, CAST(N'2016-06-15 00:00:00.000' AS DateTime), N'f3m', NULL, NULL)
INSERT [dbo].[tbParametrosLojaLinhas] ([IDLoja], [Codigo], [Descricao], [Valor], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [TipoDados]) VALUES (1, N'ARTIGO_CODIGO', N'0=Não Atribui o código; 1=Atribui o código', 'True', 1, 1, CAST(N'2016-07-25 18:28:10.213' AS DateTime), N'F3M', NULL, NULL, N'Boolean')
INSERT [dbo].[tbParametrosLojaLinhas] ([IDLoja], [Codigo], [Descricao], [Valor], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [TipoDados]) VALUES (1, N'ARTIGO_DESCRICAO', N'0=Não sugere a descrição; 1=Sugere a descrição completa', 'True', 1, 1, CAST(N'2016-07-25 18:28:10.213' AS DateTime), N'F3M', NULL, NULL, N'Boolean')

SET IDENTITY_INSERT [dbo].[tbTiposArtigos] ON 
INSERT [dbo].[tbTiposArtigos] ([ID], [IDSistemaClassificacao], [IDSistemaClassificacaoGeral], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, 1, 1, N'LO', N'Lentes Oftalmicas', NULL, 1, 1, CAST(N'2016-07-01 10:58:03.893' AS DateTime), N'F3M', CAST(N'2016-07-05 15:48:54.550' AS DateTime), N'F3M')
INSERT [dbo].[tbTiposArtigos] ([ID], [IDSistemaClassificacao], [IDSistemaClassificacaoGeral], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, 2, 1, N'AR', N'Aros', NULL, 1, 1, CAST(N'2016-07-01 12:04:11.540' AS DateTime), N'F3M', CAST(N'2016-07-08 16:25:35.253' AS DateTime), N'F3M')
INSERT [dbo].[tbTiposArtigos] ([ID], [IDSistemaClassificacao], [IDSistemaClassificacaoGeral], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, 3, 1, N'LC', N'Lentes de Contato', NULL, 1, 1, CAST(N'2016-07-01 12:04:51.980' AS DateTime), N'F3M', CAST(N'2016-07-05 15:48:21.650' AS DateTime), N'F3M')
INSERT [dbo].[tbTiposArtigos] ([ID], [IDSistemaClassificacao], [IDSistemaClassificacaoGeral], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, 4, 1, N'OS', N'Óculos de Sol', NULL, 1, 1, CAST(N'2016-07-01 12:04:31.407' AS DateTime), N'F3M', CAST(N'2016-07-05 15:48:50.767' AS DateTime), N'F3M')
INSERT [dbo].[tbTiposArtigos] ([ID], [IDSistemaClassificacao], [IDSistemaClassificacaoGeral], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (5, 5, 1, N'DV', N'Diversos', NULL, 1, 1, CAST(N'2016-07-01 12:05:55.867' AS DateTime), N'F3M', CAST(N'2016-07-05 15:48:24.953' AS DateTime), N'F3M')
SET IDENTITY_INSERT [dbo].[tbTiposArtigos] OFF

CREATE TABLE [dbo].[tbCondicionantes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDParametroCamposContexto] [bigint] NOT NULL,
	[CampoCondicionante] [nvarchar](100) NULL,
	[ValorCondicionante] [nvarchar](100) NULL,
	[ValorPorDefeito] [nvarchar](255) NULL,
	[TipoValorPorDefeito] [nvarchar](50) NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](255) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](255) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbCondicionantes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[tbParametrosCamposContexto](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDParametroContexto] [bigint] NOT NULL,
	[CodigoCampo] [nvarchar](20) NOT NULL,
	[DescricaoCampo] [nvarchar](100) NOT NULL,
	[TipoCondicionante] [tinyint] NULL,
	[IDTipoDados] [bigint] NOT NULL,
	[ConteudoLista] [nvarchar](max) NULL,
	[ValorCampo] [nvarchar](100) NULL,
	[Accao] [nvarchar](255) NULL,
	[AccaoExtra] [nvarchar](255) NULL,
	[Filtro] [nvarchar](255) NULL,
	[ValorMax] [nvarchar](100) NULL,
	[ValorMin] [nvarchar](100) NULL,
	[ValorReadOnly] [bit] NOT NULL DEFAULT ((0)),
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](255) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](255) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbParametrosCamposContexto] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[tbParametrosContexto](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDPai] [bigint] NULL,
	[Codigo] [nvarchar](20) NOT NULL,
	[CodigoPai] [nvarchar](20) NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Accao] [nvarchar](255) NULL,
	[MostraConteudo] [bit] NOT NULL DEFAULT ((1)),
	[IDParametrosEmpresa] [bigint] NULL,
	[IDLoja] [bigint] NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](255) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](255) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbParametrosContexto] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[tbTiposDados](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](255) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](255) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbTiposDados] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbCondicionantes]  WITH CHECK ADD  CONSTRAINT [FK_tbCondicionantes_IDParametroCamposContexto] FOREIGN KEY([IDParametroCamposContexto])
REFERENCES [dbo].[tbParametrosCamposContexto] ([ID])
ALTER TABLE [dbo].[tbCondicionantes] CHECK CONSTRAINT [FK_tbCondicionantes_IDParametroCamposContexto]

ALTER TABLE [dbo].[tbParametrosCamposContexto]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosCamposContexto_tbParametrosContexto] FOREIGN KEY([IDParametroContexto])
REFERENCES [dbo].[tbParametrosContexto] ([ID])

ALTER TABLE [dbo].[tbParametrosCamposContexto] CHECK CONSTRAINT [FK_tbParametrosCamposContexto_tbParametrosContexto]

ALTER TABLE [dbo].[tbParametrosCamposContexto]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosCamposContexto_tbTiposDados] FOREIGN KEY([IDTipoDados])
REFERENCES [dbo].[tbTiposDados] ([ID])

ALTER TABLE [dbo].[tbParametrosCamposContexto] CHECK CONSTRAINT [FK_tbParametrosCamposContexto_tbTiposDados]

ALTER TABLE [dbo].[tbParametrosContexto]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosContexto_tbParametrosContexto] FOREIGN KEY([IDPai])
REFERENCES [dbo].[tbParametrosContexto] ([ID])

ALTER TABLE [dbo].[tbParametrosContexto] CHECK CONSTRAINT [FK_tbParametrosContexto_tbParametrosContexto]

ALTER TABLE [dbo].[tbParametrosContexto]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosContexto_tbParametrosEmpresa] FOREIGN KEY([IDParametrosEmpresa])
REFERENCES [dbo].[tbParametrosEmpresa] ([ID])

ALTER TABLE [dbo].[tbParametrosContexto] CHECK CONSTRAINT [FK_tbParametrosContexto_tbParametrosEmpresa]

ALTER TABLE [dbo].[tbParametrosContexto]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosContexto_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbParametrosContexto] CHECK CONSTRAINT [FK_tbParametrosContexto_tbLojas]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbSistemaTiposPrecos] FOREIGN KEY([IDTipoPreco])
REFERENCES [dbo].[tbSistemaTiposPrecos] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbSistemaTiposPrecos]

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_tbUnidadesStock2] FOREIGN KEY([IDUnidadeStock2])
REFERENCES [dbo].[tbUnidades] ([ID])

ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_tbUnidadesStock2]

SET IDENTITY_INSERT [dbo].[tbTiposDados] ON 
INSERT [dbo].[tbTiposDados] ([ID], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'title', 1, 1, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbTiposDados] ([ID], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N'dropdown', 2, 1, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbTiposDados] ([ID], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N'lookup', 3, 1, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbTiposDados] ([ID], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, N'long', 4, 1, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbTiposDados] ([ID], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (5, N'checkbox', 5, 1, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbTiposDados] ([ID], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (6, N'double', 6, 1, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbTiposDados] ([ID], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (7, N'string', 7, 1, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbTiposDados] ([ID], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (8, N'date', 8, 1, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbTiposDados] ([ID], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (9, N'numeric', 9, 1, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbTiposDados] ([ID], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (10, N'password', 10, 1, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbTiposDados] OFF

SET IDENTITY_INSERT [dbo].[tbParametrosContexto] ON 
INSERT [dbo].[tbParametrosContexto] ([ID], [IDPai], [Codigo], [CodigoPai], [Descricao], [Accao], [MostraConteudo], [IDParametrosEmpresa], [IDLoja], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, NULL, N'Artigos', NULL, N'Artigos', N'PartialArtigos', 1, NULL, NULL, 1, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosContexto] ([ID], [IDPai], [Codigo], [CodigoPai], [Descricao], [Accao], [MostraConteudo], [IDParametrosEmpresa], [IDLoja], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, NULL, N'Gerais', NULL, N'Gerais', NULL, 1, 1, NULL, 2, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosContexto] ([ID], [IDPai], [Codigo], [CodigoPai], [Descricao], [Accao], [MostraConteudo], [IDParametrosEmpresa], [IDLoja], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, 2, N'Outros', N'Gerais', N'Outros', N'PartialOutros', 1, 1, NULL, 1, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosContexto] ([ID], [IDPai], [Codigo], [CodigoPai], [Descricao], [Accao], [MostraConteudo], [IDParametrosEmpresa], [IDLoja], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, 2, N'TaxasIVA', N'Gerais', N'TaxasIVA', N'PartialTaxasIVA', 1, 1, NULL, 2, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosContexto] ([ID], [IDPai], [Codigo], [CodigoPai], [Descricao], [Accao], [MostraConteudo], [IDParametrosEmpresa], [IDLoja], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (5, NULL, N'Stocks', NULL, N'Stocks', N'PartialStocks', 1, NULL, NULL, 3, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosContexto] ([ID], [IDPai], [Codigo], [CodigoPai], [Descricao], [Accao], [MostraConteudo], [IDParametrosEmpresa], [IDLoja], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (6, NULL, N'Artigos', NULL, N'Artigos', N'PartialArtigos', 1, NULL, 1, 1, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosContexto] ([ID], [IDPai], [Codigo], [CodigoPai], [Descricao], [Accao], [MostraConteudo], [IDParametrosEmpresa], [IDLoja], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (7, NULL, N'Stocks', NULL, N'Stocks', N'PartialStocks', 1, NULL, 1, 3, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosContexto] ([ID], [IDPai], [Codigo], [CodigoPai], [Descricao], [Accao], [MostraConteudo], [IDParametrosEmpresa], [IDLoja], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (8, NULL, N'Comunicacao', NULL, N'Comunicacao', N'PartialComunicacao', 1, 1, NULL, 1, 0, 1, GETDATE(), N'F3M', NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbParametrosContexto] OFF

SET IDENTITY_INSERT [dbo].[tbParametrosCamposContexto] ON 
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, 4, N'InvSujPassivo', N'InversaoDoSujeitoPassivo', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, 4, N'RegInsencao', N'RegimeDeInsencao', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 4, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, 4, N'MercadoN', N'MercadoNacional', NULL, 3,NULL, N'', N'../TabelasAuxiliares/IVA', N'../TabelasAuxiliares/IVA/IndexGrelha', NULL, NULL, NULL, 0, 2, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, 4, N'MercadoIntrac', N'MercadoIntracomunitario', NULL, 3,NULL, N'', N'../TabelasAuxiliares/IVA', N'../TabelasAuxiliares/IVA/IndexGrelha', NULL, NULL, NULL, 0, 3, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (5, 4, N'mercadoNacIntra', N'MercadoNacional', NULL, 3,NULL, N'', N'../TabelasAuxiliares/IVA', N'../TabelasAuxiliares/IVA/IndexGrelha', NULL, NULL, NULL, 0, 5, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (6, 4, N'MercadoExt', N'MercadoExterno', NULL, 3, NULL, N'', N'../TabelasAuxiliares/IVA', N'../TabelasAuxiliares/IVA/IndexGrelha', NULL, NULL, NULL, 0, 6, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (7, 3, N'NCasaDecimais', N'NCasasDecimais', 1, 9, NULL,N'6', NULL, NULL, NULL, 6, NULL, 1, 2, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (8, 5, N'ValStockTitulo', N'ValorizacaoDoStock', NULL, 1,NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (9, 5, N'ValStock', N'ValorizacaoDoStock', 1, 2,N'CustoMedio|UPC|CustoPadrao', N'2', NULL, NULL, NULL, NULL, NULL, 0, 2, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (10, 5, N'CustoMecVendidas', N'CustoDasMercadoriasVendidas', 1, 2,N'CustoMedio|UPC|CustoPadrao', N'1', NULL, NULL, NULL, NULL, NULL, 0, 3, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (11, 5, N'Lotes', N'Lotes', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (12, 5, N'FinalLote', N'AoFinalizarOLote', NULL, 2, N'Ignorar|DesativarLote', N'1', NULL, NULL, NULL, NULL, NULL, 0, 5, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (13, 5, N'DataExpirEntrada', N'DataDeValidadeExpiradaEntrada', NULL, 2,N'Ignorar|AlertarCom', N'0', NULL, NULL, NULL, 4, NULL, 0, 6, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (14, 5, N'DataAnteEntrada', N'DiasDeAntecedencia', NULL, 9,NULL, N'2', NULL, NULL, NULL, 4, NULL, 0, 7, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (15, 5, N'DataExpirSaida', N'DataDeValidadeExpiradaSaidas', NULL, 2,N'Ignorar|AlertarCom', N'0', NULL, NULL, NULL, 4, NULL, 0, 8, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (16, 5, N'DataAnteSaida', N'DiasDeAntecedencia', NULL, 9,NULL, NULL, NULL, NULL, NULL, 4, NULL, 0, 9, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (17, 5, N'ReativarLote', N'ReativarLoteInativoSeMovimentadoNaEntrada', NULL, 5,NULL, N'True',NULL,  NULL, NULL, NULL, NULL, 0, 10, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (18, 1, N'ArtigoTitulo', N'ArtigoTitulo', NULL, 1,NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (19, 1, N'ArtigoCodigo', N'ArtigoCodigo', NULL, 5,NULL, N'True', NULL, NULL, NULL, NULL, NULL, 0, 2, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (20, 1, N'ArtigoTipoDescricao', N'ArtigoTipoDescricao', NULL, 2, N'0|1', N'0', NULL, NULL, NULL, N'4', N'0', 0, 3, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (21, 3, N'CatalogoNumeroOpcoes', N'CatalogoNumeroOpcoes', NULL, 9,NULL, N'3', NULL, NULL, NULL, N'9', N'3', 0, 3, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (22, 6, N'ArtigoTitulo', N'ArtigoTitulo', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (23, 6, N'ArtigoCodigo', N'ArtigoCodigo', NULL, 5,NULL, N'True', NULL, NULL, NULL, NULL, NULL, 0, 2, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (24, 6, N'ArtigoTipoDescricao', N'ArtigoTipoDescricao', NULL, 2,N'0|1', N'0', NULL, NULL, NULL, NULL, NULL, 0, 3, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (25, 7, N'ValStockTitulo', N'ValorizacaoDoStock', NULL, 1,NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (26, 7, N'ValStock', N'ValorizacaoDoStock', 1, 2,N'CustoMedio|UPC|CustoPadrao', N'2', NULL, NULL, NULL, NULL, NULL, 0, 2, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (27, 7, N'CustoMecVendidas', N'CustoDasMercadoriasVendidas', 1, 2,N'CustoMedio|UPC|CustoPadrao', N'1', NULL, NULL, NULL, NULL, NULL, 0, 3, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (28, 7, N'Lotes', N'Lotes', NULL, 1,NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (29, 7, N'FinalLote', N'AoFinalizarOLote', NULL, 2,N'Ignorar|DesativarLote', N'Desativar o lote', NULL, NULL, NULL, NULL, NULL, 0, 5, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (30, 7, N'DataExpirEntrada', N'DataDeValidadeExpiradaEntrada', NULL, 2,N'Ignorar|AlertarCom', N'0', NULL, NULL, NULL, 4, NULL, 0, 6, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (31, 7, N'DataAnteEntrada', N'DiasDeAntecedencia', NULL, 9,NULL, N'2', NULL, NULL, NULL, 4, NULL, 0, 7, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (32, 7, N'DataExpirSaida', N'DataDeValidadeExpiradaSaidas', NULL, 2,N'Ignorar|AlertarCom', N'0', NULL, NULL, NULL, 4, NULL, 0, 8, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (33, 7, N'DataAnteSaida', N'DiasDeAntecedencia', NULL, 9,NULL, NULL, NULL, NULL, NULL, 4, NULL, 0, 9, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (34, 7, N'ReativarLote', N'ReativarLoteInativoSeMovimentadoNaEntrada', NULL, 5,NULL, N'True', NULL, NULL, NULL, NULL, NULL, 0, 10, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (35, 3, N'Configuracoes', N'Configuracoes', NULL, 1,NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (36, 8, N'DocTransporte', N'DocumentosTransportes', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (37, 8, N'ComViaWebSer', N'ComunicacaoViaWebService', NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (38, 8, N'Subutilizador', N'Subutilizador', NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 0, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (39, 8, N'Password', N'Password', NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4, 0, 1, GETDATE(), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (40, 8, N'Endereco', N'Endereco', NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 5, 0, 1, GETDATE(), N'F3M', NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbParametrosCamposContexto] OFF

SET IDENTITY_INSERT [dbo].[tbCondicionantes] ON 
INSERT [dbo].[tbCondicionantes] ([ID], [IDParametroCamposContexto], [CampoCondicionante], [ValorCondicionante], [ValorPorDefeito], [TipoValorPorDefeito], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, 13, N'DataAnteEntrada', N'Alertar Com', NULL, NULL, 1, 0, 1, CAST(N'2016-08-12 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbCondicionantes] ([ID], [IDParametroCamposContexto], [CampoCondicionante], [ValorCondicionante], [ValorPorDefeito], [TipoValorPorDefeito], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, 15, N'DataAnteSaida', N'Alertar Com', NULL, NULL, 1, 0, 1, CAST(N'2016-08-12 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbCondicionantes] ([ID], [IDParametroCamposContexto], [CampoCondicionante], [ValorCondicionante], [ValorPorDefeito], [TipoValorPorDefeito], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, 30, N'DataAnteEntrada', N'Alertar Com', NULL, NULL, 1, 0, 1, CAST(N'2016-08-12 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbCondicionantes] ([ID], [IDParametroCamposContexto], [CampoCondicionante], [ValorCondicionante], [ValorPorDefeito], [TipoValorPorDefeito], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, 32, N'DataAnteSaida', N'Alertar Com', NULL, NULL, 1, 0, 1, CAST(N'2016-08-12 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbCondicionantes] OFF

update tbParametrosCamposContexto set ValorReadOnly=1 where IDTipoDados=1
update tbParametrosCamposContexto set ValorReadOnly=1 where IDParametroContexto=8 and IDTipoDados<>5

ALTER TABLE tbParametrosCamposContexto ALTER COLUMN ValorCampo NVARCHAR(255) NULL
exec('update tbmoedas set simbolo=''€'' where codigo=''EUR''')

ALTER TABLE tbDocumentosVendasLinhas ADD IDTipoGraduacao bigint null
alter table tbdocumentosvendaslinhas ADD ValorIncidencia float null
alter table tbdocumentosvendaslinhas ADD ValorIVA float null

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaTiposGraduacoes] FOREIGN KEY([IDTipoGraduacao])
REFERENCES [dbo].[tbSistemaTiposGraduacoes] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbSistemaTiposGraduacoes]

CREATE TABLE [dbo].[tbDocumentosVendasPendentes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTipoDocumento] [bigint] NULL,
	[NumeroDocumento] [bigint] NULL,
	[DataDocumento] [datetime] NULL,
	[DataVencimento] [datetime] NULL,
	[Documento] [nvarchar](50) NULL,
	[IDTipoEntidade] [bigint] NULL,
	[IDEntidade] [bigint] NULL,
	[DescricaoEntidade] [nvarchar](200) NULL,
	[TotalMoedaDocumento] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[TotalClienteMoedaDocumento] [float] NULL,
	[TotalClienteMoedaReferencia] [float] NULL,
	[IDMoeda] [bigint] NULL,
	[TaxaConversao] [float] NULL,
	[ValorPendente] [float] NULL,
	[IDSistemaNaturezas] [bigint] NULL,
	[Pago] [bit] NULL CONSTRAINT [DF_tbDocumentosVendasPendentes_Pago]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosVendasPendentes_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosVendasPendentes_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbDocumentosVendasPendentes_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbDocumentosVendasPendentes_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbDocumentosVendasPendentes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbDocumentosVendasPendentes_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
	[IDDocumentoVenda] [bigint] NULL,
 CONSTRAINT [PK_tbDocumentosVendasPendentes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbDocumentosVendasPendentes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasPendentes_tbDocumentosVendas] FOREIGN KEY([IDDocumentoVenda])
REFERENCES [dbo].[tbDocumentosVendas] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasPendentes] CHECK CONSTRAINT [FK_tbDocumentosVendasPendentes_tbDocumentosVendas]

ALTER TABLE [dbo].[tbDocumentosVendasPendentes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasPendentes_tbSistemaNaturezas] FOREIGN KEY([IDSistemaNaturezas])
REFERENCES [dbo].[tbSistemaNaturezas] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasPendentes] CHECK CONSTRAINT [FK_tbDocumentosVendasPendentes_tbSistemaNaturezas]

CREATE TABLE [dbo].[tbDocumentosVendasAnexos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDDocumentoVenda] [bigint] NOT NULL,
	[IDTipoAnexo] [bigint] NULL,
	[Descricao] [nvarchar](255) NULL,
	[FicheiroOriginal] [nvarchar](255) NULL,
	[Ficheiro] [nvarchar](255) NOT NULL,
	[FicheiroThumbnail] [nvarchar](300) NULL,
	[Caminho] [nvarchar](max) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosVendasAnexos_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosVendasAnexos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbDocumentosVendasAnexos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tbDocumentosVendasAnexos] UNIQUE NONCLUSTERED 
(
	[IDDocumentoVenda] ASC,
	[Ficheiro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbDocumentosVendasAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasAnexos_tbDocumentosVendas] FOREIGN KEY([IDDocumentoVenda])
REFERENCES [dbo].[tbDocumentosVendas] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasAnexos] CHECK CONSTRAINT [FK_tbDocumentosVendasAnexos_tbDocumentosVendas]

ALTER TABLE [dbo].[tbDocumentosVendasAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasAnexos_tbSistemaTiposAnexos] FOREIGN KEY([IDTipoAnexo])
REFERENCES [dbo].[tbSistemaTiposAnexos] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasAnexos] CHECK CONSTRAINT [FK_tbDocumentosVendasAnexos_tbSistemaTiposAnexos]

ALTER TABLE tbServicos ADD IDDocumentoVenda bigint null
ALTER TABLE tbServicos ADD CONSTRAINT FK_tbServicos_tbDocumentosVendas  FOREIGN KEY (IDDocumentoVenda) REFERENCES tbDocumentosVendas (ID)

ALTER TABLE tbDocumentosVendasLinhasGraduacoes ADD IDServico bigint null
ALTER TABLE tbDocumentosVendasLinhasGraduacoes ADD CONSTRAINT FK_tbDocumentosVendasLinhasGraduacoes_tbServicos FOREIGN KEY (IDServico) REFERENCES tbServicos (ID)

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbPaises1] FOREIGN KEY([IDPaisCarga])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbPaises1]

ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbPaises2] FOREIGN KEY([IDPaisDescarga])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendas] CHECK CONSTRAINT [FK_tbDocumentosVendas_tbPaises2]

SET IDENTITY_INSERT [dbo].[tbFormasPagamento] ON 
INSERT [dbo].[tbFormasPagamento] ([ID], [Codigo], [Descricao], [IDTipoFormaPagamento], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'NUM', N'NUMERÁRIO', 9, 1, 1, CAST(N'2016-07-11 12:19:24.000' AS DateTime), N'F3M', CAST(N'2016-07-11 12:19:52.220' AS DateTime), N'F3M')
SET IDENTITY_INSERT [dbo].[tbFormasPagamento] OFF
SET IDENTITY_INSERT [dbo].[tbIdiomas] ON 
INSERT [dbo].[tbIdiomas] ([ID], [Codigo], [IDCultura], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N'PT', 111, N'PORTUGUÊS', 1, 1, CAST(N'2016-07-04 11:54:45.387' AS DateTime), N'F3M', CAST(N'2016-07-11 12:22:51.497' AS DateTime), N'F3M')
SET IDENTITY_INSERT [dbo].[tbIdiomas] OFF
SET IDENTITY_INSERT [dbo].[tbUnidades] ON 
INSERT [dbo].[tbUnidades] ([ID], [Codigo], [Descricao], [NumeroDeCasasDecimais], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], Pordefeito) VALUES (1, N'UN', N'UNIDADE', 1, 1, 1, CAST(N'2016-07-01 12:24:31.987' AS DateTime), N'F3M', NULL, NULL,1)
SET IDENTITY_INSERT [dbo].[tbUnidades] OFF

CREATE UNIQUE NONCLUSTERED INDEX [IX_tbDocumentosVendas_Chave] ON [dbo].[tbDocumentosVendas]
(
 [IDTipoDocumento] ASC,
 [IDTiposDocumentoSeries] ASC,
 [NumeroDocumento] ASC,
 [NumeroInterno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER TABLE [dbo].[tbParametrosEmpresa]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosEmpresa_tbPaises] FOREIGN KEY([IDPaisesDesc])
REFERENCES [dbo].tbPaises ([ID])

CREATE NONCLUSTERED INDEX [IX_tbPaisesSigla] ON [dbo].[tbPaises]
(
	[IDSigla] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER TABLE [dbo].[tbTiposDocumentoSeries] ADD	IDParametrosEmpresaCAE bigint NULL

ALTER TABLE [dbo].[tbTiposDocumentoSeries] ADD CONSTRAINT FK_tbTiposDocumentoSeries_tbParametrosEmpresaCAE FOREIGN KEY ( IDParametrosEmpresaCAE ) 
REFERENCES [dbo].[tbParametrosEmpresaCAE] ( ID ) ON UPDATE  NO ACTION  ON DELETE  NO ACTION

INSERT INTO [dbo].[tbPaises] (tbPaises.Descricao, tbPaises.IDSigla, [Sistema] ,[Ativo] ,[DataCriacao] ,[UtilizadorCriacao] ) 
SELECT  DescricaoPais, tbSistemaSiglasPaises.ID ,1, 1,getdate(),'F3M' FROM tbSistemaSiglasPaises

EXEC('UPDATE tbParametrosEmpresa SET IDPaisesDesc = Pa.ID FROM tbParametrosEmpresa As PR
INNER JOIN tbPaises AS Pa On Pa.IDSigla = PR.IDPais')

/****** PagamentosVendas ******/

CREATE TABLE [dbo].[tbPagamentosVendas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Numero] [bigint] NULL,
	[Data] [datetime] NOT NULL,
	[Descricao] [nvarchar](255) NULL,
	[TotalMoeda] [float] NULL,
	[IDMoeda] [bigint] NULL,
	[TaxaConversao] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[ValorEntregue] [float] NULL,
	[Troco] [float] NULL,
	[IDLoja] [bigint] NULL,
	[CodigoTipoEstado] [nvarchar](6) NULL,
	[Observacoes] [nvarchar](max) NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbPagamentosVendas_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbPagamentosVendas_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbPagamentosVendas_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbPagamentosVendas_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbPagamentosVendas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbPagamentosVendas_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbPagamentosVendas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbPagamentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosVendas_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbPagamentosVendas] CHECK CONSTRAINT [FK_tbPagamentosVendas_tbMoedas]

ALTER TABLE [dbo].[tbPagamentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosVendas_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbPagamentosVendas] CHECK CONSTRAINT [FK_tbPagamentosVendas_tbLojas]

CREATE TABLE [dbo].[tbPagamentosVendasLinhas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDPagamentoVenda] [bigint] NOT NULL,
	[IDTipoDocumento] [bigint] NOT NULL,
	[IDTiposDocumentoSeries] [bigint] NOT NULL,
	[IDDocumentoVenda] [bigint] NOT NULL,
	[IDEntidade] [bigint] NOT NULL,
	[NumeroDocumento] [bigint] NULL,
	[DataDocumento] [datetime] NOT NULL,
	[DataVencimento] [datetime] NOT NULL,
	[Documento] [nvarchar](255) NULL,
	[TotalMoedaDocumento] [float] NULL,
	[ValorPendente] [float] NULL,
	[TotalMoeda] [float] NULL,
	[IDMoeda] [bigint] NULL,
	[TaxaConversao] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[ValorPago] [float] NULL,
	[Ordem] [int] NULL,
	[IDLoja] [bigint] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbPagamentosVendasLinhas_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbPagamentosVendasLinhas_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbPagamentosVendasLinhas_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbPagamentosVendasLinhas_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbPagamentosVendasLinhas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbPagamentosVendasLinhas_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbPagamentosVendasLinhas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbPagamentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosVendasLinhas_tbPagamentosVendas] FOREIGN KEY([IDPagamentoVenda])
REFERENCES [dbo].[tbPagamentosVendas] ([ID])

ALTER TABLE [dbo].[tbPagamentosVendasLinhas] CHECK CONSTRAINT [FK_tbPagamentosVendasLinhas_tbPagamentosVendas]

ALTER TABLE [dbo].[tbPagamentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosVendasLinhas_tbDocumentosVendas] FOREIGN KEY([IDDocumentoVenda])
REFERENCES [dbo].[tbDocumentosVendas] ([ID])

ALTER TABLE [dbo].[tbPagamentosVendasLinhas] CHECK CONSTRAINT [FK_tbPagamentosVendasLinhas_tbDocumentosVendas]

ALTER TABLE [dbo].[tbPagamentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosVendasLinhas_tbClientes] FOREIGN KEY([IDEntidade])
REFERENCES [dbo].[tbClientes] ([ID])

ALTER TABLE [dbo].[tbPagamentosVendasLinhas] CHECK CONSTRAINT [FK_tbPagamentosVendasLinhas_tbClientes]

ALTER TABLE [dbo].[tbPagamentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosVendasLinhas_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbPagamentosVendasLinhas] CHECK CONSTRAINT [FK_tbPagamentosVendasLinhas_tbLojas]

ALTER TABLE [dbo].[tbPagamentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosVendasLinhas_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbPagamentosVendasLinhas] CHECK CONSTRAINT [FK_tbPagamentosVendasLinhas_tbMoedas]

ALTER TABLE [dbo].[tbPagamentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosVendasLinhas_tbTiposDocumento] FOREIGN KEY([IDTipoDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbPagamentosVendasLinhas] CHECK CONSTRAINT [FK_tbPagamentosVendasLinhas_tbTiposDocumento]

ALTER TABLE [dbo].[tbPagamentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosVendasLinhas_tbTiposDocumentoSeries] FOREIGN KEY([IDTiposDocumentoSeries])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])

ALTER TABLE [dbo].[tbPagamentosVendasLinhas] CHECK CONSTRAINT [FK_tbPagamentosVendasLinhas_tbTiposDocumentoSeries]


CREATE TABLE [dbo].[tbPagamentosVendasFormasPagamento](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDPagamentoVenda] [bigint] NOT NULL,
	[IDFormaPagamento] [bigint] NOT NULL,
	[TotalMoeda] [float] NULL,
	[IDMoeda] [bigint] NULL,
	[TaxaConversao] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[Valor] [float] NULL,
	[Ordem] [int] NULL,
	[IDLoja] [bigint] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbPagamentosVendasFormasPagamento_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbPagamentosVendasFormasPagamento_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbPagamentosVendasFormasPagamento_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbPagamentosVendasFormasPagamento_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbPagamentosVendasFormasPagamento_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbPagamentosVendasFormasPagamento_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbPagamentosVendasFormasPagamento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbPagamentosVendasFormasPagamento]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosVendasFormasPagamento_tbPagamentosVendas] FOREIGN KEY([IDPagamentoVenda])
REFERENCES [dbo].[tbPagamentosVendas] ([ID])

ALTER TABLE [dbo].[tbPagamentosVendasFormasPagamento] CHECK CONSTRAINT [FK_tbPagamentosVendasFormasPagamento_tbPagamentosVendas]

ALTER TABLE [dbo].[tbPagamentosVendasFormasPagamento]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosVendasFormasPagamento_tbFormasPagamento] FOREIGN KEY([IDFormaPagamento])
REFERENCES [dbo].[tbFormasPagamento] ([ID])

ALTER TABLE [dbo].[tbPagamentosVendasFormasPagamento] CHECK CONSTRAINT [FK_tbPagamentosVendasFormasPagamento_tbFormasPagamento]

ALTER TABLE [dbo].[tbPagamentosVendasFormasPagamento]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosVendasFormasPagamento_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbPagamentosVendasFormasPagamento] CHECK CONSTRAINT [FK_tbPagamentosVendasFormasPagamento_tbLojas]

CREATE TABLE [dbo].[tbTiposFases](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbTiposFases_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbTiposFases_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbTiposFases_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbFases] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[tbServicosFases](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTipoFase] [bigint] NOT NULL,
	[IDServico] [bigint] NOT NULL,
	[Data] [datetime] NULL,
	[Observacoes] [nvarchar](max) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbServicosFases_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbServicosFases_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbServicosFases_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbServicosFases] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbServicosFases]  WITH CHECK ADD  CONSTRAINT [FK_tbServicosFases_tbTiposFases] FOREIGN KEY([IDTipoFase])
REFERENCES [dbo].[tbTiposFases] ([ID])

ALTER TABLE [dbo].[tbServicosFases] CHECK CONSTRAINT [FK_tbServicosFases_tbTiposFases]

ALTER TABLE [dbo].[tbServicosFases]  WITH CHECK ADD  CONSTRAINT [FK_tbServicosFases_tbServicos] FOREIGN KEY([IDServico])
REFERENCES [dbo].[tbServicos] ([ID])

ALTER TABLE [dbo].[tbServicosFases] CHECK CONSTRAINT [FK_tbServicosFases_tbServicos]

Alter Table	tbTiposDocumento ADD IDSistemaNaturezas [bigint] NULL

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaNaturezas] FOREIGN KEY([IDSistemaNaturezas])
REFERENCES [dbo].[tbSistemaNaturezas] ([ID])


ALTER TABLE [dbo].tbTiposDocumento DROP CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumentoMovStockNeg]

ALTER TABLE [dbo].tbTiposDocumento DROP CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoesRupturaStockNeg]

ALTER TABLE [dbo].tbTiposDocumento DROP CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumentoPrecoUnitarioNeg]

Alter Table tbTiposDocumento DROP COLUMN IDSistemaTiposDocumentoMovStockNeg,
IDSistemaAcoesRupturaStockNeg,DataUltimaSaidaNeg , DataPrimeiraSaidaNeg , 
DataUltimaEntradaNeg , DataPrimeiraEntradaNeg , UltimoPrecoCustoNeg , 
CustoMedioNeg , CalculaNecessidadesNeg , LinhasNegativas  , IDSistemaTiposDocumentoPrecoUnitarioNeg


Alter Table tbTiposDocumento Add ReservaStock bit NULL
Alter Table tbTiposDocumento Add GeraPendente bit NULL
Alter Table tbTiposDocumento Drop COLUMN  EntregueCliente

EXEC('update tbTiposDocumento set ReservaStock=0, GeraPendente=0')

CREATE TABLE [dbo].[tbRecibos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTipoDocumento] [bigint] NOT NULL,
	[IDTiposDocumentoSeries] [bigint] NOT NULL,
	[IDPagamentoVenda] [bigint] NULL,
	[NumeroDocumento] [bigint] NULL,
	[DataDocumento] [datetime] NOT NULL,
	[DataAssinatura] [datetime] NULL,
	[DataVencimento] [datetime] NULL,
	[Documento] [nvarchar](255) NULL,
	[IDEntidade] [bigint] NULL,
	[IDTipoEntidade] [bigint] NULL,
	[NomeFiscal] [nvarchar](200) NULL,
	[MoradaFiscal] [nvarchar](100) NULL,
	[IDCodigoPostalFiscal] [bigint] NULL,
	[IDConcelhoFiscal] [bigint] NULL,
	[IDDistritoFiscal] [bigint] NULL,
	[IDPaisFiscal] [bigint] NULL,
	[CodigoPostalFiscal] [nvarchar](50) NULL,
	[DescricaoCodigoPostalFiscal] [nvarchar](50) NULL,
	[DescricaoConcelhoFiscal] [nvarchar](50) NULL,
	[DescricaoDistritoFiscal] [nvarchar](50) NULL,
	[ContribuinteFiscal] [nvarchar](25) NULL,
	[SiglaPaisFiscal] [nvarchar](15) NULL,
	[TotalMoedaDocumento] [float] NULL,
	[IDMoeda] [bigint] NULL,
	[TaxaConversao] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[ValorImposto] [float] NULL,
	[IDLoja] [bigint] NULL,
	[IDLocalOperacao] [bigint] NULL,
	[IDEstado] [bigint] NULL,
	[UtilizadorEstado] [nvarchar](20) NULL,
	[DataHoraEstado] [datetime] NULL,
	[Observacoes] [nvarchar](max) NULL,
	[TipoFiscal] [nvarchar](20) NULL,
	[CodigoTipoEstado] [nvarchar](20) NULL,
	[CodigoEntidade] [nvarchar](20) NULL,
	[CodigoDocOrigem] [nvarchar](255) NULL, 
	[CodigoMoeda] [nvarchar](20) NULL,
	[MensagemDocAT] [nvarchar](1000) NULL,
	[ValorExtenso] [nvarchar](4000) NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbRecibos_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbRecibos_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbRecibos_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbRecibos_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbRecibos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbRecibos_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbRecibos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbRecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibos_tbClientes] FOREIGN KEY([IDEntidade])
REFERENCES [dbo].[tbClientes] ([ID])

ALTER TABLE [dbo].[tbRecibos] CHECK CONSTRAINT [FK_tbRecibos_tbClientes]

ALTER TABLE [dbo].[tbRecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibos_tbCodigosPostais] FOREIGN KEY([IDCodigoPostalFiscal])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbRecibos] CHECK CONSTRAINT [FK_tbRecibos_tbCodigosPostais]

ALTER TABLE [dbo].[tbRecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibos_tbConcelhos] FOREIGN KEY([IDConcelhoFiscal])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbRecibos] CHECK CONSTRAINT [FK_tbRecibos_tbConcelhos]

ALTER TABLE [dbo].[tbRecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibos_tbDistritos] FOREIGN KEY([IDDistritoFiscal])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbRecibos] CHECK CONSTRAINT [FK_tbRecibos_tbDistritos]

ALTER TABLE [dbo].[tbRecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibos_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbRecibos] CHECK CONSTRAINT [FK_tbRecibos_tbLojas]

ALTER TABLE [dbo].[tbRecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibos_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbRecibos] CHECK CONSTRAINT [FK_tbRecibos_tbMoedas]

ALTER TABLE [dbo].[tbRecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibos_tbTiposDocumento] FOREIGN KEY([IDTipoDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbRecibos] CHECK CONSTRAINT [FK_tbRecibos_tbTiposDocumento]

ALTER TABLE [dbo].[tbRecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibos_tbTiposDocumentoSeries] FOREIGN KEY([IDTiposDocumentoSeries])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])

ALTER TABLE [dbo].[tbRecibos] CHECK CONSTRAINT [FK_tbRecibos_tbTiposDocumentoSeries]

ALTER TABLE [dbo].[tbRecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibos_tbPagamentosVendas] FOREIGN KEY([IDPagamentoVenda])
REFERENCES [dbo].[tbPagamentosVendas] ([ID])

ALTER TABLE [dbo].[tbRecibos] CHECK CONSTRAINT [FK_tbRecibos_tbPagamentosVendas]

ALTER TABLE [dbo].[tbRecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibos_tbPaises] FOREIGN KEY([IDPaisFiscal])
REFERENCES [dbo].[tbPaises] ([ID])
ALTER TABLE [dbo].[tbRecibos] CHECK CONSTRAINT [FK_tbRecibos_tbPaises]

ALTER TABLE [dbo].[tbRecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibos_tbEstados] FOREIGN KEY([IDEstado])
REFERENCES [dbo].[tbEstados] ([ID])
ALTER TABLE [dbo].[tbRecibos] CHECK CONSTRAINT [FK_tbRecibos_tbEstados]

ALTER TABLE [dbo].[tbRecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibos_tbSistemaRegioesIVA] FOREIGN KEY([IDLocalOperacao])
REFERENCES [dbo].[tbSistemaRegioesIVA] ([ID])
ALTER TABLE [dbo].[tbRecibos] CHECK CONSTRAINT [FK_tbRecibos_tbSistemaRegioesIVA]

ALTER TABLE [dbo].[tbrecibos]  WITH CHECK ADD  CONSTRAINT [FK_tbrecibos_tbSistemaTiposEntidade] FOREIGN KEY([IDTipoEntidade])
REFERENCES [dbo].[tbSistemaTiposEntidade] ([ID])
ALTER TABLE [dbo].[tbrecibos] CHECK CONSTRAINT [FK_tbrecibos_tbSistemaTiposEntidade]

CREATE TABLE [dbo].[tbRecibosLinhas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDRecibo] [bigint] NOT NULL,
	[IDTipoDocumento] [bigint] NOT NULL,
	[IDTiposDocumentoSeries] [bigint] NOT NULL,
	[IDDocumentoVenda] [bigint] NOT NULL,
	[NumeroDocumento] [bigint] NULL,
	[DataDocumento] [datetime] NOT NULL,
	[DataVencimento] [datetime] NULL,
	[Documento] [nvarchar](255) NULL,
	[IDEntidade] [bigint] NULL,
	[NomeFiscal] [nvarchar](200) NULL,
	[MoradaFiscal] [nvarchar](100) NULL,
	[IDCodigoPostalFiscal] [bigint] NULL,
	[IDConcelhoFiscal] [bigint] NULL,
	[IDDistritoFiscal] [bigint] NULL,
	[CodigoPostalFiscal] [nvarchar](50) NULL,
	[DescricaoCodigoPostalFiscal] [nvarchar](50) NULL,
	[DescricaoConcelhoFiscal] [nvarchar](50) NULL,
	[DescricaoDistritoFiscal] [nvarchar](50) NULL,
	[ContribuinteFiscal] [nvarchar](25) NULL,
	[SiglaPaisFiscal] [nvarchar](15) NULL,
	[TotalMoedaDocumento] [float] NULL,
	[IDMoeda] [bigint] NULL,
	[TaxaConversao] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[ValorPago] [float] NULL,
	[ValorIncidencia] [float] NULL,
	[ValorIva] [float] NULL,
	[DocumentoOrigem] [nvarchar](255) NULL,
	[DataDocOrigem] [datetime] NULL,
	[Adiantamento] [bit] NULL,
	[Ordem] [int] NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbRecibosLinhas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbRecibosLinhas] ADD  CONSTRAINT [DF_tbRecibosLinhas_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbRecibosLinhas] ADD  CONSTRAINT [DF_tbRecibosLinhas_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbRecibosLinhas] ADD  CONSTRAINT [DF_tbRecibosLinhas_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbRecibosLinhas] ADD  CONSTRAINT [DF_tbRecibosLinhas_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]

ALTER TABLE [dbo].[tbRecibosLinhas] ADD  CONSTRAINT [DF_tbRecibosLinhas_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbRecibosLinhas] ADD  CONSTRAINT [DF_tbRecibosLinhas_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbRecibosLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosLinhas_tbClientes] FOREIGN KEY([IDEntidade])
REFERENCES [dbo].[tbClientes] ([ID])

ALTER TABLE [dbo].[tbRecibosLinhas] CHECK CONSTRAINT [FK_tbRecibosLinhas_tbClientes]

ALTER TABLE [dbo].[tbRecibosLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosLinhas_tbCodigosPostais] FOREIGN KEY([IDCodigoPostalFiscal])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbRecibosLinhas] CHECK CONSTRAINT [FK_tbRecibosLinhas_tbCodigosPostais]

ALTER TABLE [dbo].[tbRecibosLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosLinhas_tbConcelhos] FOREIGN KEY([IDConcelhoFiscal])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbRecibosLinhas] CHECK CONSTRAINT [FK_tbRecibosLinhas_tbConcelhos]

ALTER TABLE [dbo].[tbRecibosLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosLinhas_tbDistritos] FOREIGN KEY([IDDistritoFiscal])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbRecibosLinhas] CHECK CONSTRAINT [FK_tbRecibosLinhas_tbDistritos]

ALTER TABLE [dbo].[tbRecibosLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosLinhas_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbRecibosLinhas] CHECK CONSTRAINT [FK_tbRecibosLinhas_tbMoedas]

ALTER TABLE [dbo].[tbRecibosLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosLinhas_tbRecibos] FOREIGN KEY([IDRecibo])
REFERENCES [dbo].[tbRecibos] ([ID])

ALTER TABLE [dbo].[tbRecibosLinhas] CHECK CONSTRAINT [FK_tbRecibosLinhas_tbRecibos]

ALTER TABLE [dbo].[tbRecibosLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosLinhas_tbTiposDocumento] FOREIGN KEY([IDTipoDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbRecibosLinhas] CHECK CONSTRAINT [FK_tbRecibosLinhas_tbTiposDocumento]

ALTER TABLE [dbo].[tbRecibosLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosLinhas_tbTiposDocumentoSeries] FOREIGN KEY([IDTiposDocumentoSeries])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])

ALTER TABLE [dbo].[tbRecibosLinhas] CHECK CONSTRAINT [FK_tbRecibosLinhas_tbTiposDocumentoSeries]

ALTER TABLE [dbo].[tbRecibosLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosLinhas_tbDocumentosVendas] FOREIGN KEY([IDDocumentoVenda])
REFERENCES [dbo].[tbDocumentosVendas] ([ID])

ALTER TABLE [dbo].[tbRecibosLinhas] CHECK CONSTRAINT [FK_tbRecibosLinhas_tbDocumentosVendas]

CREATE TABLE [dbo].[tbRecibosLinhasTaxas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDReciboLinha] [bigint] NOT NULL,
	[TipoTaxa] nvarchar(3) NULL,
	[TaxaIva] [float] NULL,
	[ValorIncidencia] [float] NULL,
	[ValorIva] [float] NULL,
	[CodigoMotivoIsencaoIva] [nvarchar](6) NULL,
	[MotivoIsencaoIva] nvarchar(255) NULL,
	[ValorImposto] [float] NULL,
	[CodigoTipoIva] [nvarchar](20) NULL,	
	[CodigoRegiaoIva] [nvarchar](20) NULL,
	[CodigoTaxaIva] [nvarchar](255) NULL,
	[Ordem] [int] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbRecibosLinhasTaxas_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbRecibosLinhasTaxas_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbRecibosLinhasTaxas_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbRecibosLinhasTaxas_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbRecibosLinhasTaxas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbRecibosLinhasTaxas_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbRecibosLinhasTaxas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

ALTER TABLE [dbo].[tbRecibosLinhasTaxas]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosLinhasTaxas_tbRecibosLinhas] FOREIGN KEY([IDReciboLinha])
REFERENCES [dbo].[tbRecibosLinhas] ([ID])

ALTER TABLE [dbo].[tbRecibosLinhasTaxas] CHECK CONSTRAINT [FK_tbRecibosLinhasTaxas_tbRecibosLinhas]

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbIVA] FOREIGN KEY([IDTaxaIva])
REFERENCES [dbo].[tbIVA] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbIVA]

CREATE TABLE [dbo].[tbRecibosFormasPagamento](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDRecibo] [bigint] NOT NULL,
	[IDFormaPagamento] [bigint] NOT NULL,
	[TotalMoeda] [float] NULL,
	[IDMoeda] [bigint] NULL,
	[TaxaConversao] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[Valor] [float] NULL,
	[ValorEntregue] [float] NULL,
	[Troco] [float] NULL,
	[CodigoFormaPagamento] [nvarchar](6) NULL,
	[Ordem] [int] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbRecibosFormasPagamento_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbRecibosFormasPagamento_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbRecibosFormasPagamento_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbRecibosFormasPagamento_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbRecibosFormasPagamento_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbRecibosFormasPagamento_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbRecibosFormasPagamento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

ALTER TABLE [dbo].[tbRecibosFormasPagamento]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosFormasPagamento_tbRecibos] FOREIGN KEY([IDRecibo])
REFERENCES [dbo].[tbRecibos] ([ID])
ALTER TABLE [dbo].[tbRecibosFormasPagamento] CHECK CONSTRAINT [FK_tbRecibosFormasPagamento_tbRecibos]

ALTER TABLE [dbo].[tbRecibosFormasPagamento]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosFormasPagamento_tbFormasPagamento] FOREIGN KEY([IDFormaPagamento])
REFERENCES [dbo].[tbFormasPagamento] ([ID])
ALTER TABLE [dbo].[tbRecibosFormasPagamento] CHECK CONSTRAINT [FK_tbRecibosFormasPagamento_tbFormasPagamento]

ALTER TABLE [dbo].[tbRecibosFormasPagamento]  WITH CHECK ADD  CONSTRAINT [FK_tbRecibosFormasPagamento_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])
ALTER TABLE [dbo].[tbRecibosFormasPagamento] CHECK CONSTRAINT [FK_tbRecibosFormasPagamento_tbMoedas]

Insert into tbTiposFases (ID, Codigo, Descricao, Ordem, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (1, 'B', 'Balcao', 1, 'True', 'True', '2016-12-25' , 'f3m')
Insert into tbTiposFases (ID, Codigo, Descricao, Ordem, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (2, 'PLD','PedidoLenteDireita', 2, 'True', 'True', '2016-12-25' , 'f3m')
Insert into tbTiposFases (ID, Codigo, Descricao, Ordem, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (3, 'PLE','PedidoLenteEsquerda', 3, 'True', 'True', '2016-12-25' , 'f3m')
Insert into tbTiposFases (ID, Codigo, Descricao, Ordem, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (4, 'PLA','PedidoAro', 4, 'True', 'True', '2016-12-25' , 'f3m')
Insert into tbTiposFases (ID, Codigo, Descricao, Ordem, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (5, 'RLD','RececaoLenteDireita', 5, 'True', 'True', '2016-12-25' , 'f3m')
Insert into tbTiposFases (ID, Codigo, Descricao, Ordem, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (6, 'RLE','RececaoLenteEsquerda', 6, 'True', 'True', '2016-12-25' , 'f3m')
Insert into tbTiposFases (ID, Codigo, Descricao, Ordem, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (7, 'RLA','RececaoAro', 7, 'True', 'True', '2016-12-25' , 'f3m')
Insert into tbTiposFases (ID, Codigo, Descricao, Ordem, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (8, 'M', 'Montagem', 8, 'True', 'True', '2016-12-25' , 'f3m')
Insert into tbTiposFases (ID, Codigo, Descricao, Ordem, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (9, 'C', 'Controlo', 9, 'True', 'True', '2016-12-25' , 'f3m')
Insert into tbTiposFases (ID, Codigo, Descricao, Ordem, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (10, 'L', 'Localizacao', 10, 'True', 'True', '2016-12-25' , 'f3m')
Insert into tbTiposFases (ID, Codigo, Descricao, Ordem, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (11, 'E', 'Entrega', 11, 'True', 'True', '2016-12-25' , 'f3m')

ALTER TABLE dbo.tbDocumentosVendasLinhas ADD CodigoTaxaIva nvarchar(255) NULL, IDTipoIva bigint NULL

ALTER TABLE dbo.tbDocumentosVendasLinhas ADD CONSTRAINT FK_tbDocumentosVendasLinhas_tbSistemaTiposIVA 
FOREIGN KEY ( IDTipoIva ) 
REFERENCES dbo.tbSistemaTiposIVA ( ID )

Alter Table tbTiposDocumentoTipEntPermDoc ADD ContadorDoc bigint NOT NULL DEFAULT(0)

alter table tbDocumentosVendasLinhas add [IDTipoDocumentoOrigem] [bigint] NULL, [IDDocumentoOrigem] [bigint] NULL, [IDLinhaDocumentoOrigem] [bigint] NULL

ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_IDTipoDocumentoOrigem] FOREIGN KEY([IDTipoDocumentoOrigem])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_IDTipoDocumentoOrigem]
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [CodigoMotivoIsencaoIva] [nvarchar](6) NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [DocumentoOrigem] [nvarchar](255) NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [TipoTaxa] nvarchar(3) NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [CodigoArtigo] nvarchar(255) NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [CodigoBarrasArtigo] nvarchar(255) NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [CodigoUnidade] nvarchar(20) NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [CodigoTipoIva] nvarchar(20) NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [CodigoRegiaoIva] nvarchar(20) NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [PercIncidencia] [float] NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [PercDeducao] [float] NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [ValorIvaDedutivel] [float] NULL

ALTER TABLE tbDocumentosVendasPendentes ADD CONSTRAINT tbDocumentosVendasPendentes_ValorPendente_MI_0 CHECK (valorpendente>=0)

CREATE TABLE [dbo].[tbDocumentosVendasFormasPagamento](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDDocumentoVenda] [bigint] NOT NULL,
	[IDFormaPagamento] [bigint] NOT NULL,
	[CodigoFormaPagamento] [nvarchar](6) NULL,
	[TotalMoeda] [float] NULL,
	[IDMoeda] [bigint] NULL,
	[TaxaConversao] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[Valor] [float] NULL,
	[ValorEntregue] [float] NULL,
	[Troco] [float] NULL,
	[Ordem] [int] NULL,
	[IDLoja] [bigint] NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbDocumentosVendasFormasPagamento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbDocumentosVendasFormasPagamento] ADD  CONSTRAINT [DF_tbDocumentosVendasFormasPagamento_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbDocumentosVendasFormasPagamento] ADD  CONSTRAINT [DF_tbDocumentosVendasFormasPagamento_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbDocumentosVendasFormasPagamento] ADD  CONSTRAINT [DF_tbDocumentosVendasFormasPagamento_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbDocumentosVendasFormasPagamento] ADD  CONSTRAINT [DF_tbDocumentosVendasFormasPagamento_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]

ALTER TABLE [dbo].[tbDocumentosVendasFormasPagamento] ADD  CONSTRAINT [DF_tbDocumentosVendasFormasPagamento_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbDocumentosVendasFormasPagamento] ADD  CONSTRAINT [DF_tbDocumentosVendasFormasPagamento_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbDocumentosVendasFormasPagamento]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasFormasPagamento_tbFormasPagamento] FOREIGN KEY([IDFormaPagamento])
REFERENCES [dbo].[tbFormasPagamento] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasFormasPagamento] CHECK CONSTRAINT [FK_tbDocumentosVendasFormasPagamento_tbFormasPagamento]

ALTER TABLE [dbo].[tbDocumentosVendasFormasPagamento]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasFormasPagamento_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasFormasPagamento] CHECK CONSTRAINT [FK_tbDocumentosVendasFormasPagamento_tbLojas]

ALTER TABLE [dbo].[tbDocumentosVendasFormasPagamento]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasFormasPagamento_tbDocumentosVendas] FOREIGN KEY([IDDocumentoVenda])
REFERENCES [dbo].[tbDocumentosVendas] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasFormasPagamento] CHECK CONSTRAINT [FK_tbDocumentosVendasFormasPagamento_tbDocumentosVendas]

CREATE TABLE [dbo].[tbMapasVistas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Ordem] [int] NULL,
	[Entidade] [nvarchar](255) NOT NULL,
	[Descricao] [nvarchar](255) NOT NULL,
	[NomeMapa] [nvarchar](255) NOT NULL,
	[Caminho] [nvarchar](255) NOT NULL,
	[Certificado] [bit] NULL,
	[MapaXML] ntext NULL,
	[IDModulo] [bigint] NULL,
	[IDSistemaTipoDoc] [bigint] NULL,
	[IDSistemaTipoDocFiscal] [bigint] NULL,
	[IDLoja] [bigint] NULL,
	[SQLQuery] [nvarchar](max) NULL,
	[Tabela] [nvarchar](255) NULL,
	[Geral] [bit] NOT NULL CONSTRAINT [DF_tbMapasVistas_Geral]  DEFAULT ((0)),
	[Listagem] [bit] NOT NULL CONSTRAINT [DF_tbMapasVistas_Listagem]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbMapasVistas_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbMapasVistas_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbMapasVistas_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbMapasVistas_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbMapasVistas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbMapasVistas_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbMapasVistas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbMapasVistas]  WITH CHECK ADD  CONSTRAINT [FK_tbMapasVistas_tbSistemaModulos] FOREIGN KEY(IDModulo)
REFERENCES [dbo].[tbSistemaModulos] ([ID])

ALTER TABLE [dbo].[tbMapasVistas]  WITH CHECK ADD  CONSTRAINT [FK_tbMapasVistas_tbSistemaTiposDocumento] FOREIGN KEY(IDSistemaTipoDoc)
REFERENCES [dbo].[tbSistemaTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbMapasVistas]  WITH CHECK ADD  CONSTRAINT [FK_tbMapasVistas_tbSistemaTiposDocumentoFiscal] FOREIGN KEY(IDSistemaTipoDocFiscal)
REFERENCES [dbo].[tbSistemaTiposDocumentoFiscal] ([ID])

ALTER TABLE [dbo].[tbMapasVistas]  WITH CHECK ADD  CONSTRAINT [FK_tbMapasVistas_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbMapasVistas] CHECK CONSTRAINT [FK_tbMapasVistas_tbLojas]

SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (1, 1, N'DocumentosVendas', N'DocumentosVendasA4', N'rptDocumentosVendas', N'\Reporting\Reports\Oticas\DocumentosVendas\', 1, NULL, 1, NULL, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', 4, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (2, 2, N'DocumentosVendas', N'DocumentosVendasA5', N'rptDocumentosVendasA5', N'\Reporting\Reports\Oticas\DocumentosVendas\', 1, NULL, 1, NULL, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', NULL, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (3, 3, N'DocumentosVendasServicos', N'DocumentosVendasServicos', N'rptDocumentosVendasServicos', N'\Reporting\Reports\Oticas\DocumentosVendas\', 1, NULL, 1, NULL, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', NULL, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (4, 4, N'DocumentosVendas', N'Listagem', N'rptReportDinamico', N'\Reporting\Reports\Comum\', 0, NULL, 1, N'select v.Documento, v.NumeroDocumento, v.DataDocumento,p.ValorPendente from tbdocumentosvendas as v left join tbDocumentosVendasPendentes as p on p.IDDocumentoVenda = v.ID', 1, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', NULL, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (5, 5, N'Recibos', N'Recibos', N'rptRecibos', N'\Reporting\Reports\Oticas\DocumentosVendas\', 1, NULL, 1, NULL, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', NULL, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (6, 6, N'CCEntidades', N'Conta Corrente', N'rptCCEntidades', N'\Reporting\Reports\Oticas\DocumentosVendas\', 0, NULL, 1, NULL, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', NULL, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (7, 7, N'MapaCaixa', N'Mapa de Caixa', N'rptMapaCaixa', N'\Reporting\Reports\Oticas\DocumentosVendas\', 0, NULL, 1, NULL, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', NULL, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (8, 8, N'Recibos', N'RecibosA5', N'rptRecibosA5', N'\Reporting\Reports\Oticas\DocumentosVendas\', 1, NULL, 1, NULL, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', NULL, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (9, 9, N'Clientes', N'Listagem', N'rptReportDinamico', N'\Reporting\Reports\Comum\', 0, NULL, 1, N'select Codigo,Nome,DataNascimento,NContribuinte,Saldo from tbclientes', 1, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', NULL, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (10, 10, N'Artigos', N'Listagem', N'rptReportDinamico', N'\Reporting\Reports\Comum\', 0, NULL, 1, N'select Codigo,Descricao from tbartigos', 1, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', NULL, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (12, 12, N'Perfis', N'Listagem', N'rptReportDinamico', N'\Reporting\Reports\Comum\', 0, NULL, 1, N'select descricao, descricaoAbreviada from [F3MOGeral].dbo.tbperfis', 1, 1, 1, GETDATE(), N'F3M', GETDATE(), N'', NULL, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (13, 13, N'Empresas', N'Listagem', N'rptReportDinamico', N'\Reporting\Reports\Comum\', 0, NULL, 1, N'select codigo, nome from [F3MOGeral].dbo.tbempresas', 1, 1, 1, GETDATE(), N'F3M', GETDATE(), N'', NULL, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (14, 14, N'Utilizadores', N'Listagem', N'rptReportDinamico', N'\Reporting\Reports\Comum\', 0, NULL, 1, N'select nome, ativo from [F3MOGeral].dbo.tbutilizadores', 1, 1, 1, GETDATE(), N'F3M', GETDATE(), N'', NULL, NULL, NULL)
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (15, 15, N'DocumentosVendasServicos', N'Listagem', N'rptReportDinamico', N'\Reporting\Reports\Comum\', 0, NULL, NULL, NULL, NULL, 1, N'select v.Documento, v.NumeroDocumento, v.DataDocumento,(v.TotalMoedaDocumento - v.ValorPago) as ValorPendente from tbdocumentosvendas as v left join tbDocumentosVendasPendentes as p on p.IDDocumentoVenda = v.ID left join tbtiposDocumento as d on d.ID = v.IDTipoDocumento where d.Codigo = ''SV'' ', NULL, 0, 1, 1, 1, GETDATE(), N'F3M', NULL, N'')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF

EXEC('IF EXISTS (SELECT * FROM [F3MOGeral].sys.indexes where name = N''IX_tbIEUtilizadoresEmpresa'') DROP INDEX [IX_tbIEUtilizadoresEmpresa] ON [F3MOGeral].[dbo].[tbUtilizadoresEmpresa]')
EXEC('CREATE UNIQUE NONCLUSTERED INDEX [IX_tbIEUtilizadoresEmpresa] ON [F3MOGeral].[dbo].[tbUtilizadoresEmpresa]
(
	[IDEmpresa] ASC,
	[IDUtilizador] ASC,
	[IDPerfil] ASC,
	[IDLoja] ASC
)')

ALTER TABLE [dbo].[tbClientes] ADD [Saldo] [float] NOT NULL, CONSTRAINT [DF_tbClientes_Saldo]  DEFAULT ((0)) FOR [Saldo]
ALTER TABLE [dbo].[tbClientes] ADD [TotalVendas] [float] NOT NULL, CONSTRAINT [DF_tbClientes_TotalVendas]  DEFAULT ((0)) FOR [TotalVendas]

CREATE TABLE [dbo].[tbCCEntidades](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Natureza][nvarchar](2) NULL,
	[IDLoja] [bigint] NULL,
	[IDTipoEntidade] [bigint] NULL,
	[IDEntidade] [bigint] NULL,
	[NomeFiscal] [nvarchar](255) NULL,
	[IDTipoDocumento] [bigint] NULL,
	[IDTipoDocumentoSeries] [bigint] NULL,
	[IDDocumento] [bigint] NULL,
	[NumeroDocumento] [nvarchar](100) NULL,
	[DataDocumento] [datetime] NULL,
	[Descricao] [nvarchar](255) NULL,
	[IDMoeda] [bigint] NULL,
	[TotalMoeda] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[TaxaConversao] [float] NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbCCEntidades] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbCCEntidades] ADD  CONSTRAINT [DF_tbCCEntidades_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbCCEntidades] ADD  CONSTRAINT [DF_tbCCEntidades_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbCCEntidades] ADD  CONSTRAINT [DF_tbCCEntidades_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbCCEntidades] ADD  CONSTRAINT [DF_tbCCEntidades_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]

ALTER TABLE [dbo].[tbCCEntidades] ADD  CONSTRAINT [DF_tbCCEntidades_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbCCEntidades] ADD  CONSTRAINT [DF_tbCCEntidades_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

alter table tbtiposdocumento add Adiantamento bit null
Alter Table tbTiposDocumentoSeries ADD NumeroVias bigint NULL
Alter Table tbClientes add Parentesco1 nvarchar(50) null, Parentesco2 nvarchar(50) null

CREATE TABLE [dbo].[tbMapaCaixa](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDLoja] [bigint] NULL,
	[Natureza] [nvarchar](2) NULL,
	[IDFormaPagamento] [bigint] NULL,
	[DescricaoFormaPagamento] [nvarchar](255) NULL,
	[IDTipoDocumento] [bigint] NULL,
	[IDTipoDocumentoSeries] [bigint] NULL,
	[IDDocumento] [bigint] NULL,
	[NumeroDocumento] [nvarchar](100) NULL,
	[DataDocumento] [datetime] NULL,
	[Descricao] [nvarchar](255) NULL,
	[IDMoeda] [bigint] NULL,
	[TotalMoeda] [float] NULL,
	[TaxaConversao] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[Valor] [float] NULL,
	[ValorEntregue] [float] NULL,
	[Troco] [float] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbMapaCaixa_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbMapaCaixa_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbMapaCaixa_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbMapaCaixa_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbMapaCaixa_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbMapaCaixa_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbMapaCaixa] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaCCEntidades]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0,
	@strUtilizador AS nvarchar(256) = '''',
	@lngidEntidade AS bigint = NULL
AS  BEGIN
SET NOCOUNT ON

DECLARE @strSqlQuery AS varchar(max),--variavel para querys dinamicos
	@strSqlQueryAux AS varchar(max),--variavel para querys dinamicos
	@strSqlQueryUpdates AS varchar(max),--variavel para querys dinamicos
	@strSqlQueryInsert AS varchar(max),--varivale para a parte do insert
	@strFiltro as nvarchar(1024),--variavel para a parte do insert
	@strFiltroIns as nvarchar(1024),--variavel para a parte do insert

	@ErrorMessage   varchar(2000),
	@ErrorSeverity  tinyint,
	@ErrorState     tinyint,
	@rowcount INT

BEGIN TRY
	--Verificar se o tipo de documento gere conta corrente
	IF EXISTS(SELECT ID FROM tbTiposDocumento WHERE ISNULL(GereContaCorrente,0)<>0 AND ID=@lngidTipoDocumento)
		BEGIN
		IF (@intAccao = 0) OR (@intAccao = 1)
			BEGIN
				IF @lngidDocumento>0
					BEGIN
						SET @strFiltro='' and IDDocumento='' + cast(@lngidDocumento as nvarchar(50))
						SET @strFiltroIns='' and DV.ID='' + cast(@lngidDocumento as nvarchar(50))
					END
				ELSE
					BEGIN
						SET @strFiltro=''''
						SET @strFiltroIns=''''
					END

				SET @strSqlQuery=''DELETE FROM tbCCEntidades where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)

				SET @strSqlQueryInsert = ''insert into tbCCEntidades ([Natureza], [IDLoja], [IDTipoEntidade],[IDEntidade],[NomeFiscal],[IDTipoDocumento],[IDTipoDocumentoSeries],[IDDocumento],[NumeroDocumento],
										[DataDocumento],[Descricao], [IDMoeda], [TotalMoeda],[TotalMoedaReferencia],[TaxaConversao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao])''
								
				SELECT @strSqlQuery = @strSqlQueryInsert + '' select (case when (TD.Adiantamento=1 and TSN.Codigo=''''R'''') then ''''P'''' when (TD.Adiantamento=1 and TSN.Codigo=''''P'''') then ''''R'''' else TSN.Codigo end) as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbdocumentosvendas DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)

				SELECT @strSqlQuery = @strSqlQueryInsert + '' select TSN.Codigo as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbrecibos DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)
			END
		ELSE
			BEGIN
				IF @lngidDocumento>0
					BEGIN
						SET @strFiltro='' and IDDocumento='' + cast(@lngidDocumento as nvarchar(50))
						SET @strFiltroIns='' and DV.ID='' + cast(@lngidDocumento as nvarchar(50))
					END

				SET @strSqlQuery=''DELETE FROM tbCCEntidades where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)
			END

		  UPDATE tbclientes set saldo=tbcc.saldo FROM tbclientes Cli
			   INNER JOIN (
			   select identidade, isnull(sum(case when natureza=''R'' then totalmoedareferencia else -totalmoedareferencia end ),0) as saldo from tbccentidades where identidade=@lngidEntidade group by IDEntidade) tbcc
			   ON Cli.ID= tbcc.identidade
	END
END TRY
	BEGIN CATCH
		SET @ErrorMessage  = ERROR_MESSAGE()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState    = ERROR_STATE()
		RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
	END CATCH
END')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaMapaCaixa]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0,
	@strUtilizador AS nvarchar(256) = ''''
AS  BEGIN
SET NOCOUNT ON

DECLARE @strSqlQuery AS varchar(max),--variavel para queries dinamicos
	@strSqlQueryAux AS varchar(max),--variavel para queries dinamicos
	@strSqlQueryUpdates AS varchar(max),--variavel para queries dinamicos
	@strSqlQueryInsert AS varchar(max),--varivale para a parte do insert
	@strFiltro as nvarchar(1024),--variavel para a parte do insert
	@strFiltroIns as nvarchar(1024),--variavel para a parte do insert

	@ErrorMessage   varchar(2000),
	@ErrorSeverity  tinyint,
	@ErrorState     tinyint,
	@rowcount INT

BEGIN TRY
	IF EXISTS(SELECT ID FROM tbTiposDocumento WHERE ISNULL(GereCaixasBancos,0)<>0 and ID=@lngidTipoDocumento)
		BEGIN
		IF (@intAccao = 0) OR (@intAccao = 1)
			BEGIN
				IF @lngidDocumento>0
					BEGIN
						SET @strFiltro='' and IDDocumento='' + cast(@lngidDocumento as nvarchar(50))
						SET @strFiltroIns='' and R.ID='' + cast(@lngidDocumento as nvarchar(50))
					END
				ELSE
					BEGIN
						SET @strFiltro=''''
						SET @strFiltroIns=''''
					END

				SET @strSqlQuery=''DELETE FROM tbMapaCaixa where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)

				SET @strSqlQueryInsert = ''insert into tbMapaCaixa ([IDTipoDocumento],[IDDocumento], [IDLoja], [DataDocumento],[NumeroDocumento],[IDFormaPagamento],
											[Natureza], [Descricao], [IDMoeda], [TotalMoeda],[TaxaConversao],[TotalMoedaReferencia], [Valor], [Troco], [ValorEntregue], [Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao])''

				SELECT @strSqlQuery = @strSqlQueryInsert + ''select r.IDTipoDocumento,r.id as IDDocumento, r.IDLoja, r.DataDocumento, R.NumeroDocumento,rfp.IDFormaPagamento, SN.Codigo, R.Documento, 
									rfp.IDMoeda, rfp.totalmoeda, rfp.TaxaConversao, rfp.TotalMoedaReferencia, rfp.valor, rfp.Troco, rfp.ValorEntregue, 1,0,getdate(),'''''' + @strUtilizador + ''''''
									from tbRecibos R inner join tbTiposDocumento TD on R.IDTipodocumento=TD.ID 
									inner join tbSistemaTiposDocumentoFiscal STD on TD.IDSistemaTiposDocumentoFiscal=STD.ID
									inner join tbSistemaNaturezas SN on TD.IDSistemaNaturezas=SN.ID
									inner join tbRecibosFormasPagamento RFP on RFP.IDRecibo=R.ID
									inner join tbFormasPagamento FP on RFP.IDFormapagamento=FP.ID
									where TD.GereContaCorrente=1 AND R.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)

				SELECT @strSqlQuery = @strSqlQueryInsert + ''select r.IDTipoDocumento,r.id as IDDocumento, r.IDLoja, r.DataDocumento, R.NumeroDocumento,rfp.IDFormaPagamento, SN.Codigo, R.Documento, 
									rfp.IDMoeda, rfp.totalmoeda, rfp.TaxaConversao, rfp.TotalMoedaReferencia, rfp.valor, rfp.Troco, rfp.ValorEntregue, 1,0,getdate(),'''''' + @strUtilizador + ''''''
									from tbDocumentosVendas R inner join tbTiposDocumento TD on R.IDTipodocumento=TD.ID 
									inner join tbSistemaTiposDocumentoFiscal STD on TD.IDSistemaTiposDocumentoFiscal=STD.ID
									inner join tbSistemaNaturezas SN on TD.IDSistemaNaturezas=SN.ID
									inner join tbDocumentosVendasFormasPagamento RFP on RFP.IDDocumentoVenda = R.ID
									inner join tbFormasPagamento FP on RFP.IDFormapagamento=FP.ID
									where R.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)

				SELECT @strSqlQuery = @strSqlQueryInsert + ''select r.IDTipoDocumento,r.id as IDDocumento, r.IDLoja, r.DataDocumento, R.NumeroDocumento,rfp.IDFormaPagamento, SN.Codigo, R.Documento, 
									rfp.IDMoeda, rfp.totalmoeda, rfp.TaxaConversao, rfp.TotalMoedaReferencia, rfp.valor, rfp.Troco, rfp.ValorEntregue, 1,0,getdate(),'''''' + @strUtilizador + ''''''
									from tbPagamentoscompras R inner join tbTiposDocumento TD on R.IDTipodocumento=TD.ID 
									inner join tbSistemaTiposDocumentoFiscal STD on TD.IDSistemaTiposDocumentoFiscal=STD.ID
									inner join tbSistemaNaturezas SN on TD.IDSistemaNaturezas=SN.ID
									inner join tbPagamentoscomprasFormasPagamento RFP on RFP.IDPagamentoCompra = R.ID
									inner join tbFormasPagamento FP on RFP.IDFormapagamento=FP.ID
									where R.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)
			END
		ELSE
			BEGIN
				IF @lngidDocumento>0
					BEGIN
						SET @strFiltro='' and IDDocumento='' + cast(@lngidDocumento as nvarchar(50))
						SET @strFiltroIns='' and R.ID='' + cast(@lngidDocumento as nvarchar(50))
					END

				SET @strSqlQuery=''DELETE FROM tbMapaCaixa where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)
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


SET IDENTITY_INSERT [dbo].[tbCondicoesPagamento] ON 
INSERT [dbo].[tbCondicoesPagamento] ([ID], [IDTipoCondDataVencimento], [Codigo], [Descricao], [DescontosIncluiIva], [ValorCondicao], [Prazo], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importado]) VALUES (1, 1, N'PRONTO', N'A PRONTO', 1, NULL, 0, 1, 1, CAST(N'2016-07-11 12:19:59.000' AS DateTime), N'F3M', CAST(N'2016-07-11 12:20:17.027' AS DateTime), N'F3M', 0)
SET IDENTITY_INSERT [dbo].[tbCondicoesPagamento] OFF

SET IDENTITY_INSERT [dbo].[tbEspecialidades] ON 
INSERT [dbo].[tbEspecialidades] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'1', N'OPTOMETRIA', 1, 1, CAST(N'2016-07-01 15:19:58.440' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbEspecialidades] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N'2 ', N'OFTALMOLOGIA', 1, 1, CAST(N'2016-07-01 15:20:06.633' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbEspecialidades] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N'3', N'CONTATOLOGIA', 1, 1, CAST(N'2016-07-06 18:54:47.800' AS DateTime), N'F3M', NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbEspecialidades] OFF

SET IDENTITY_INSERT [dbo].[tbFormasPagamento] ON 
INSERT [dbo].[tbFormasPagamento] ([ID], [Codigo], [Descricao], [IDTipoFormaPagamento], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N'MB', N'MULTIBANCO', 2, 1, 1, CAST(N'2016-07-11 12:19:24.000' AS DateTime), N'F3M', CAST(N'2016-07-11 12:19:52.220' AS DateTime), N'F3M')
INSERT [dbo].[tbFormasPagamento] ([ID], [Codigo], [Descricao], [IDTipoFormaPagamento], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N'VISA', N'VISA', 1, 1, 1, CAST(N'2016-07-11 12:19:24.000' AS DateTime), N'F3M', CAST(N'2016-07-11 12:19:52.220' AS DateTime), N'F3M')
SET IDENTITY_INSERT [dbo].[tbFormasPagamento] OFF

SET IDENTITY_INSERT [dbo].[tbGruposArtigo] ON 
INSERT [dbo].[tbGruposArtigo] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'1', N'GERAL', NULL, 1, 1, CAST(N'2016-07-01 12:17:14.710' AS DateTime), N'F3M', CAST(N'2016-07-01 12:37:09.780' AS DateTime), N'F3M')
SET IDENTITY_INSERT [dbo].[tbGruposArtigo] OFF

SET IDENTITY_INSERT [dbo].[tbIVA] ON 
INSERT [dbo].[tbIVA] ([ID], [Codigo], [Descricao], [Taxa], [IDTipoIva], [IDCodigoIva], [Mencao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N'ISE', N'TAXA ISENTA', CAST(0.000000000 AS Decimal(12, 9)), 1, 1, N'Artigo 16.º n.º 6 do CIVA (ou similar)', 1, 1, CAST(N'2016-07-01 17:50:24.110' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbIVA] ([ID], [Codigo], [Descricao], [Taxa], [IDTipoIva], [IDCodigoIva], [Mencao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N'RED', N'TAXA REDUZIDA', CAST(6.000000000 AS Decimal(12, 9)), 2, null, null, 1, 1, CAST(N'2016-07-01 17:50:24.110' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbIVA] ([ID], [Codigo], [Descricao], [Taxa], [IDTipoIva], [IDCodigoIva], [Mencao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N'INT', N'TAXA INTERMEDIA', CAST(12.000000000 AS Decimal(12, 9)), 3, null, null, 1, 1, CAST(N'2016-07-01 17:51:06.757' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbIVA] ([ID], [Codigo], [Descricao], [Taxa], [IDTipoIva], [IDCodigoIva], [Mencao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, N'NOR', N'TAXA NORMAL', CAST(23.000000000 AS Decimal(12, 9)), 4, null, null, 1, 1, CAST(N'2016-07-01 17:51:06.757' AS DateTime), N'F3M', NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbIVA] OFF

SET IDENTITY_INSERT [dbo].[tbMarcas] ON 
INSERT [dbo].[tbMarcas] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [AtualizaPrecos]) VALUES (1, N'1', N'ESSILOR', NULL, 1, 1, CAST(N'2016-07-01 09:47:37.513' AS DateTime), N'F3M', NULL, NULL, NULL)
INSERT [dbo].[tbMarcas] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [AtualizaPrecos]) VALUES (2, N'2', N'RAY BAN', NULL, 1, 1, CAST(N'2016-07-01 11:41:14.300' AS DateTime), N'F3M', NULL, NULL, NULL)
INSERT [dbo].[tbMarcas] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [AtualizaPrecos]) VALUES (3, N'3', N'ZEISS', NULL, 1, 1, CAST(N'2016-07-04 09:04:29.770' AS DateTime), N'F3M', NULL, NULL, NULL)
INSERT [dbo].[tbMarcas] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [AtualizaPrecos]) VALUES (4, N'4', N'PRATS', NULL, 1, 1, CAST(N'2016-07-04 15:52:29.367' AS DateTime), N'F3M', NULL, NULL, NULL)
INSERT [dbo].[tbMarcas] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [AtualizaPrecos]) VALUES (5, N'5', N'JOHNSON', NULL, 1, 1, CAST(N'2016-07-11 09:53:57.430' AS DateTime), N'F3M', NULL, NULL, NULL)
INSERT [dbo].[tbMarcas] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [AtualizaPrecos]) VALUES (6, N'6', N'NOVARTIS', NULL, 1, 1, CAST(N'2016-07-11 09:54:07.020' AS DateTime), N'F3M', NULL, NULL, NULL)
INSERT [dbo].[tbMarcas] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [AtualizaPrecos]) VALUES (7, N'7', N'BAUSHLOMB', NULL, 1, 1, CAST(N'2016-07-11 09:54:14.453' AS DateTime), N'F3M', NULL, NULL, NULL)
INSERT [dbo].[tbMarcas] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [AtualizaPrecos]) VALUES (8, N'8', N'HOYA', NULL, 1, 1, CAST(N'2016-07-11 09:54:14.453' AS DateTime), N'F3M', NULL, NULL, NULL)
INSERT [dbo].[tbMarcas] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [AtualizaPrecos]) VALUES (9, N'9', N'FIBO', NULL, 1, 1, CAST(N'2016-07-11 09:54:14.453' AS DateTime), N'F3M', NULL, NULL, NULL)
INSERT [dbo].[tbMarcas] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [AtualizaPrecos]) VALUES (10, N'10', N'SHAMIR', NULL, 1, 1, CAST(N'2016-07-11 09:54:14.453' AS DateTime), N'F3M', NULL, NULL, NULL)
INSERT [dbo].[tbMarcas] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [AtualizaPrecos]) VALUES (11, N'11', N'SYNCHRONY', NULL, 1, 1, CAST(N'2016-07-11 09:54:14.453' AS DateTime), N'F3M', NULL, NULL, NULL)
INSERT [dbo].[tbMarcas] ([ID], [Codigo], [Descricao], [VariavelContabilidade], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [AtualizaPrecos]) VALUES (12, N'12', N'GERAL', NULL, 1, 1, CAST(N'2016-07-01 09:47:37.513' AS DateTime), N'F3M', NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbMarcas] OFF

SET IDENTITY_INSERT [dbo].[tbArtigos] ON 
INSERT [dbo].[tbArtigos] ([ID], [Codigo], [Ativo], [IDFamilia], [IDSubFamilia], [IDTipoArtigo], [IDComposicao], [IDTipoComposicao], [IDGrupoArtigo], [IDMarca], [CodigoBarras], [QRCode], [Descricao], [DescricaoAbreviada], [Observacoes], [GereLotes], [GereStock], [GereNumeroSerie], [DescricaoVariavel], [IDTipoDimensao], [IDDimensaoPrimeira], [IDDimensaoSegunda], [IDOrdemLoteApresentar], [IDUnidade], [IDUnidadeVenda], [IDUnidadeCompra], [VariavelContabilidade], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEstacao], [NE], [DTEX], [CodigoEstatistico], [LimiteMax], [LimiteMin], [Reposicao], [IDOrdemLoteMovEntrada], [IDOrdemLoteMovSaida], [IDTaxa], [DedutivelPercentagem], [IncidenciaPercentagem], [UltimoPrecoCusto], [Medio], [Padrao], [UltimosCustosAdicionais], [UltimosDescontosComerciais], [UltimoPrecoCompra], [TotalQuantidadeVSUPC], [TotalQuantidadeVSPCM], [TotalQuantidadeVSPCPadrao], [IDTiposComponente], [IDCompostoTransformacaoMetodoCusto], [IDImpostoSelo], [FatorFTOFPercentagem], [Foto], [FotoCaminho], [IDUnidadeStock2], [IDTipoPreco], [CodigoAT], [ReferenciaFornecedor], [CodigoBarrasFornecedor], [IDSistemaClassificacao]) VALUES (1, N'DV-ISE', 1, NULL, NULL, 5, NULL, NULL, 1, 12, N'DV-ISE', NULL, N'DV TAXA ISE', NULL, NULL, 0, 0, 0, 1, NULL, NULL, NULL, NULL, 1, 1, 1, NULL, 1, CAST(N'2017-02-02 11:46:32.440' AS DateTime), N'F3M', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 100, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'~/Fotos/Artigos/', NULL, 1, NULL, NULL, NULL, 5)
INSERT [dbo].[tbArtigos] ([ID], [Codigo], [Ativo], [IDFamilia], [IDSubFamilia], [IDTipoArtigo], [IDComposicao], [IDTipoComposicao], [IDGrupoArtigo], [IDMarca], [CodigoBarras], [QRCode], [Descricao], [DescricaoAbreviada], [Observacoes], [GereLotes], [GereStock], [GereNumeroSerie], [DescricaoVariavel], [IDTipoDimensao], [IDDimensaoPrimeira], [IDDimensaoSegunda], [IDOrdemLoteApresentar], [IDUnidade], [IDUnidadeVenda], [IDUnidadeCompra], [VariavelContabilidade], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEstacao], [NE], [DTEX], [CodigoEstatistico], [LimiteMax], [LimiteMin], [Reposicao], [IDOrdemLoteMovEntrada], [IDOrdemLoteMovSaida], [IDTaxa], [DedutivelPercentagem], [IncidenciaPercentagem], [UltimoPrecoCusto], [Medio], [Padrao], [UltimosCustosAdicionais], [UltimosDescontosComerciais], [UltimoPrecoCompra], [TotalQuantidadeVSUPC], [TotalQuantidadeVSPCM], [TotalQuantidadeVSPCPadrao], [IDTiposComponente], [IDCompostoTransformacaoMetodoCusto], [IDImpostoSelo], [FatorFTOFPercentagem], [Foto], [FotoCaminho], [IDUnidadeStock2], [IDTipoPreco], [CodigoAT], [ReferenciaFornecedor], [CodigoBarrasFornecedor], [IDSistemaClassificacao]) VALUES (2, N'DV-RED', 1, NULL, NULL, 5, NULL, NULL, 1, 12, N'DV-RED', NULL, N'DV TAXA RED', NULL, NULL, 0, 0, 0, 1, NULL, NULL, NULL, NULL, 1, 1, 1, NULL, 1, CAST(N'2017-02-02 11:46:32.440' AS DateTime), N'F3M', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 100, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'~/Fotos/Artigos/', NULL, 1, NULL, NULL, NULL, 5)
INSERT [dbo].[tbArtigos] ([ID], [Codigo], [Ativo], [IDFamilia], [IDSubFamilia], [IDTipoArtigo], [IDComposicao], [IDTipoComposicao], [IDGrupoArtigo], [IDMarca], [CodigoBarras], [QRCode], [Descricao], [DescricaoAbreviada], [Observacoes], [GereLotes], [GereStock], [GereNumeroSerie], [DescricaoVariavel], [IDTipoDimensao], [IDDimensaoPrimeira], [IDDimensaoSegunda], [IDOrdemLoteApresentar], [IDUnidade], [IDUnidadeVenda], [IDUnidadeCompra], [VariavelContabilidade], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEstacao], [NE], [DTEX], [CodigoEstatistico], [LimiteMax], [LimiteMin], [Reposicao], [IDOrdemLoteMovEntrada], [IDOrdemLoteMovSaida], [IDTaxa], [DedutivelPercentagem], [IncidenciaPercentagem], [UltimoPrecoCusto], [Medio], [Padrao], [UltimosCustosAdicionais], [UltimosDescontosComerciais], [UltimoPrecoCompra], [TotalQuantidadeVSUPC], [TotalQuantidadeVSPCM], [TotalQuantidadeVSPCPadrao], [IDTiposComponente], [IDCompostoTransformacaoMetodoCusto], [IDImpostoSelo], [FatorFTOFPercentagem], [Foto], [FotoCaminho], [IDUnidadeStock2], [IDTipoPreco], [CodigoAT], [ReferenciaFornecedor], [CodigoBarrasFornecedor], [IDSistemaClassificacao]) VALUES (3, N'DV-INT', 1, NULL, NULL, 5, NULL, NULL, 1, 12, N'DV-INT', NULL, N'DV TAXA INT', NULL, NULL, 0, 0, 0, 1, NULL, NULL, NULL, NULL, 1, 1, 1, NULL, 1, CAST(N'2017-02-02 11:46:32.440' AS DateTime), N'F3M', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 100, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'~/Fotos/Artigos/', NULL, 1, NULL, NULL, NULL, 5)
INSERT [dbo].[tbArtigos] ([ID], [Codigo], [Ativo], [IDFamilia], [IDSubFamilia], [IDTipoArtigo], [IDComposicao], [IDTipoComposicao], [IDGrupoArtigo], [IDMarca], [CodigoBarras], [QRCode], [Descricao], [DescricaoAbreviada], [Observacoes], [GereLotes], [GereStock], [GereNumeroSerie], [DescricaoVariavel], [IDTipoDimensao], [IDDimensaoPrimeira], [IDDimensaoSegunda], [IDOrdemLoteApresentar], [IDUnidade], [IDUnidadeVenda], [IDUnidadeCompra], [VariavelContabilidade], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEstacao], [NE], [DTEX], [CodigoEstatistico], [LimiteMax], [LimiteMin], [Reposicao], [IDOrdemLoteMovEntrada], [IDOrdemLoteMovSaida], [IDTaxa], [DedutivelPercentagem], [IncidenciaPercentagem], [UltimoPrecoCusto], [Medio], [Padrao], [UltimosCustosAdicionais], [UltimosDescontosComerciais], [UltimoPrecoCompra], [TotalQuantidadeVSUPC], [TotalQuantidadeVSPCM], [TotalQuantidadeVSPCPadrao], [IDTiposComponente], [IDCompostoTransformacaoMetodoCusto], [IDImpostoSelo], [FatorFTOFPercentagem], [Foto], [FotoCaminho], [IDUnidadeStock2], [IDTipoPreco], [CodigoAT], [ReferenciaFornecedor], [CodigoBarrasFornecedor], [IDSistemaClassificacao]) VALUES (4, N'DV-NOR', 1, NULL, NULL, 5, NULL, NULL, 1, 12, N'DV-NOR', NULL, N'DV TAXA NOR', NULL, NULL, 0, 0, 0, 1, NULL, NULL, NULL, NULL, 1, 1, 1, NULL, 1, CAST(N'2017-02-02 11:46:32.440' AS DateTime), N'F3M', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 100, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'~/Fotos/Artigos/', NULL, 1, NULL, NULL, NULL, 5)
SET IDENTITY_INSERT [dbo].[tbArtigos] OFF

Alter table tbTiposDocumentoSeries Add IDMapasVistas bigint  NULL

ALTER TABLE [dbo].[tbTiposDocumentoSeries]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumentoSeries_tbMapasVistas] FOREIGN KEY(IDMapasVistas)
REFERENCES [dbo].[tbMapasVistas] ([ID])

CREATE TABLE [dbo].[tbSAFT](
 [ID] [bigint] IDENTITY(1,1) NOT NULL,
 [Ficheiro] [nvarchar](255) NOT NULL,
 [Caminho] [nvarchar](Max) NOT NULL,
 [Versao] [nvarchar](20) NOT NULL,
 [DataInicio] [datetime] NULL,
 [DataFim] [datetime] NULL,
 [FacturacaoMensal] [bit] NOT NULL CONSTRAINT [DF_tbSAFT_FacturacaoMensal]  DEFAULT ((0)),
 [Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSAFT_Ativo]  DEFAULT ((1)),
 [Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSAFT_Sistema]  DEFAULT ((0)),
 [DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbSAFT_DataCriacao]  DEFAULT (getdate()),
 [UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbSAFT_UtilizadorCriacao]  DEFAULT (''),
 [DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSAFT_DataAlteracao]  DEFAULT (getdate()),
 [UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbSAFT_UtilizadorAlteracao]  DEFAULT (''),
 [F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSAFT] PRIMARY KEY CLUSTERED 
(
 [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

EXEC('SET IDENTITY_INSERT [dbo].[tbClientes] ON;INSERT [dbo].[tbClientes] ([ID], [IDLoja], [Codigo], [Nome], [Foto], [FotoCaminho], [DataValidade], [DataNascimento], [IDTipoEntidade], [Apelido], [Abreviatura], [CartaoCidadao], [TituloAcademico], [IDProfissao], [IDMoeda], [IDFormaPagamento], [IDCondicaoPagamento], [IDSegmentoMercado], [IDSetorAtividade], [IDPrecoSugerido], [IDVendedor], [IDFormaExpedicao], [IDTipoPessoa], [IDEspacoFiscal], [IDRegimeIva], [IDLocalOperacao], [IDPais], [IDIdioma], [IDSexo], [Contabilidade], [Prioridade], [IDEmissaoFatura], [IDEmissaoPackingList], [NIB], [RegimeEspecial], [EfetuaRetencao], [ControloCredito], [EmitePedidoLiquidacao], [IvaCaixa], [Observacoes], [Avisos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Desconto1], [Desconto2], [Comissao1], [Comissao2], [Plafond], [NMaximoDiasAtraso], [NContribuinte], [IDEntidade1], [NumeroBeneficiario1], [IDEntidade2], [NumeroBeneficiario2], [IDMedicoTecnico], [Parentesco1], [Parentesco2]) VALUES (1, 1, N''CF'', N''CONSUMIDOR FINAL'', NULL, N''/F3M/Images/gerais/Clientes/'', NULL, NULL, 2, N''FINAL'', NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 1, 1, 1, 184, 2, NULL, NULL, 999, NULL, NULL, NULL, 0, 0, 1, 1, 0, NULL, NULL, 1, 1, CAST(N''2017-02-24 11:01:26.147'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 0, NULL, 0, N''999999990'', NULL, NULL, NULL, NULL, NULL, NULL, NULL);SET IDENTITY_INSERT [dbo].[tbClientes] OFF')

CREATE TABLE [dbo].[tbControloDocumentos](
	[IDTipoDocumento] [bigint] NULL,
	[IDTiposDocumentoSeries] [bigint] NULL,
	[IDDocumento] [bigint] NULL,
	[NumeroDocumento] [bigint] NULL,
	[DataDocumento] [datetime] NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[IDTipoEntidade] [bigint] NULL,
	[IDEntidade] [bigint] NULL,
	[IDLoja] [bigint] NULL,
	[IDEstado] [bigint] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[tbControloDocumentos]  WITH CHECK ADD  CONSTRAINT [FK_tbControloDocumentos_tbSistemaTiposEntidade] FOREIGN KEY([IDTipoEntidade])
REFERENCES [dbo].[tbSistemaTiposEntidade] ([ID])
ALTER TABLE [dbo].[tbControloDocumentos] CHECK CONSTRAINT [FK_tbControloDocumentos_tbSistemaTiposEntidade]

ALTER TABLE [dbo].[tbControloDocumentos]  WITH CHECK ADD  CONSTRAINT [FK_tbControloDocumentos_tbTiposDocumento] FOREIGN KEY([IDTipoDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])
ALTER TABLE [dbo].[tbControloDocumentos] CHECK CONSTRAINT [FK_tbControloDocumentos_tbTiposDocumento]

ALTER TABLE [dbo].[tbControloDocumentos]  WITH CHECK ADD  CONSTRAINT [FK_tbControloDocumentos_tbTiposDocumentoSeries] FOREIGN KEY([IDTiposDocumentoSeries])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])
ALTER TABLE [dbo].[tbControloDocumentos] CHECK CONSTRAINT [FK_tbControloDocumentos_tbTiposDocumentoSeries]

EXEC('CREATE PROCEDURE [dbo].[sp_ControloDocumentos]  
	@lngidDocumento AS bigint = NULL,
	@IDTipoDocumento AS bigint = NULL,
    @IDTiposDocumentoSeries AS bigint = 0,
	@intAccao AS int = 0,
	@strTabelaCabecalho AS nvarchar(250) = '''', 
	@strUtilizador AS nvarchar(256) = ''''
AS  BEGIN
SET NOCOUNT ON
DECLARE	
	@ErrorMessage AS varchar(2000),
	@ErrorSeverity AS tinyint,
	@ErrorState AS tinyint,
	@strSqlQuery AS varchar(max)	
BEGIN TRY
			IF (@intAccao = 0 OR @intAccao = 1) --adiona ou alterar
				BEGIN
						IF (@intAccao = 1) --adiona ou alterar
							BEGIN
								SET @strSqlQuery  = '' DELETE FROM tbControloDocumentos 
												 WHERE IDDocumento = '' + Convert(nvarchar,@lngidDocumento)  + '' AND IDTipoDocumento = '' + Convert(nvarchar,@IDTipoDocumento) 
												+ '' AND IDTiposDocumentoSeries = '' + Convert(nvarchar, @IDTiposDocumentoSeries) 
								EXEC(@strSqlQuery)
							END

						SET @strSqlQuery =''INSERT INTO tbControloDocumentos (IDEntidade, IDTipoEntidade , IDTipoDocumento, IDTiposDocumentoSeries, IDDocumento, NumeroDocumento, DataDocumento, 
									   Ativo, Sistema, DataCriacao, UtilizadorCriacao, IDLoja, IDEstado)''
									   + '' SELECT Cab.IDEntidade , Cab.IDTipoEntidade, Cab.IDTipoDocumento, Cab.IDTiposDocumentoSeries, Cab.ID as IDDocumento, Cab.NumeroDocumento,
										Cab.DataDocumento, 1 as Ativo , 1 as Sistema, getdate() as DataCriacao, '''''' + @strUtilizador + '''''' AS UtilizadorCriacao, Cab.IDLoja as IDLoja, Cab.IDEstado as IDEstado
										FROM '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab
										WHERE Cab.ID = '' + Convert(nvarchar,@lngidDocumento) 
					    EXEC(@strSqlQuery)		
				END
			ELSE--apagar
				BEGIN
					SET @strSqlQuery  = '' DELETE FROM tbControloDocumentos WHERE IDDocumento = '' + Convert(nvarchar,@lngidDocumento)  + '' AND IDTipoDocumento = '' + Convert(nvarchar,@IDTipoDocumento) 
									    + '' AND IDTiposDocumentoSeries = '' + Convert(nvarchar, @IDTiposDocumentoSeries) 
				    EXEC(@strSqlQuery)
				END
END TRY
BEGIN CATCH
	SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
	RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')

Alter table [tbEntidades] add IDClienteEntidade bigint null

ALTER TABLE [dbo].[tbEntidades]  WITH CHECK ADD  CONSTRAINT [FK_tbEntidades_tbClientes] FOREIGN KEY([IDClienteEntidade])
REFERENCES [dbo].[tbClientes] ([ID])
ALTER TABLE [dbo].[tbEntidades] CHECK CONSTRAINT [FK_tbEntidades_tbClientes]

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumento] ON 
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (1, N''SV'', N''Serviço'', 4, 17, 1, 1, CAST(N''2017-02-22 09:04:15.120'' AS DateTime), N''F3M'',NULL,NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, 2, 1, NULL, NULL, NULL, NULL, 2, 2, 2, 4, 0, 0, 0)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (2, N''FA'', N''Fatura Adiantamento'', 4, 14, 1, 1, CAST(N''2017-03-01 06:32:23.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, 16, 0, 1, 1, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 2, 3, NULL, NULL, NULL, NULL, 2, 2, 2, 6, 0, 1, 1)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (3, N''FT'', N''Fatura'', 4, 14, 1, 1, CAST(N''2017-02-22 09:02:53.053'' AS DateTime), N''F3M'', NULL, NULL, NULL, 14, 0, 1, 0, 0, 1, 1, 1, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 2, 3, NULL, NULL, NULL, NULL, 2, 2, 2, 6, 0, 1, 0)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (4, N''FR'', N''Fatura Recibo'', 4, 14, 1, 1, CAST(N''2017-03-01 06:37:55.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, 16, 0, 0, 1, 1, 1, 1, 1, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 2, 3, NULL, NULL, NULL, NULL, 2, 2, 2, 6, 0, 0, 0)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (5, N''FS'', N''Fatura Simplificada'', 4, 14, 1, 1, CAST(N''2017-03-01 06:37:55.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, 15, 0, 0, 1, 1, 1, 1, 1, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 2, 3, NULL, NULL, NULL, NULL, 2, 2, 2, 6, 0, 0, 0)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (6, N''NC'', N''Nota de Crédito'', 4, 14, 1, 1, CAST(N''2017-02-22 09:06:38.087'' AS DateTime), N''F3M'', NULL, NULL, NULL, 18, 0, 1, 0, 0, 1, 1, 1, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 2, 2, NULL, NULL, NULL, NULL, 2, 2, 2, 7, 0, 1, 0)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (7, N''RC'', N''Recibo'', 4, 14, 1, 1, CAST(N''2017-02-22 14:42:49.997'' AS DateTime), N''F3M'', NULL, NULL, NULL, 47, 0, 1, 1, 0, 1, 1, 1, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 2, 3, NULL, NULL, NULL, NULL, 2, 2, 2, 7, 0, 0, 0)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (8, N''NA'', N''Nota de Crédito Adiantamento'', 4, 14, 1, 1, CAST(N''2017-03-01 06:32:23.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 2, 3, NULL, NULL, NULL, NULL, 2, 2, 2, 7, 0, 1, 1)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento]) VALUES (9, N''ND'', N''Nota de Débito'', 4, 14, 1, 1, CAST(N''2017-02-22 09:02:53.053'' AS DateTime), N''F3M'', NULL, NULL, NULL, 17, 0, 1, 0, 0, 1, 1, 1, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 2, 3, NULL, NULL, NULL, NULL, 2, 2, 2, 6, 0, 1, 0)
SET IDENTITY_INSERT [dbo].[tbTiposDocumento] OFF')

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ON 
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (1, 1, 5, 0, 1, CAST(N''2017-02-22 09:02:53.513'' AS DateTime), N''F3M'', CAST(N''2017-02-22 09:02:53.513'' AS DateTime), N''F3M'', 1, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (2, 1, 6, 0, 1, CAST(N''2017-02-22 09:02:53.520'' AS DateTime), N''F3M'', CAST(N''2017-02-22 09:02:53.520'' AS DateTime), N''F3M'', 2, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (3, 2, 5, 0, 1, CAST(N''2017-02-22 09:04:15.133'' AS DateTime), N''F3M'', CAST(N''2017-02-22 09:04:15.133'' AS DateTime), N''F3M'', 3, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (4, 2, 6, 0, 1, CAST(N''2017-02-22 09:04:15.137'' AS DateTime), N''F3M'', CAST(N''2017-02-22 09:04:15.137'' AS DateTime), N''F3M'', 4, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (5, 3, 5, 0, 1, CAST(N''2017-02-22 09:04:15.133'' AS DateTime), N''F3M'', CAST(N''2017-02-22 09:04:15.133'' AS DateTime), N''F3M'', 5, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (6, 3, 6, 0, 1, CAST(N''2017-02-22 09:04:15.137'' AS DateTime), N''F3M'', CAST(N''2017-02-22 09:04:15.137'' AS DateTime), N''F3M'', 6, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (7, 4, 5, 0, 1, CAST(N''2017-02-22 09:06:38.103'' AS DateTime), N''F3M'', CAST(N''2017-02-22 09:06:38.103'' AS DateTime), N''F3M'', 7, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (8, 4, 6, 0, 1, CAST(N''2017-02-22 09:06:38.107'' AS DateTime), N''F3M'', CAST(N''2017-02-22 09:06:38.107'' AS DateTime), N''F3M'', 8, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (9, 5, 5, 0, 1, CAST(N''2017-02-22 14:42:50.043'' AS DateTime), N''F3M'', CAST(N''2017-02-22 14:42:50.043'' AS DateTime), N''F3M'', 9, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (10, 5, 6, 0, 1, CAST(N''2017-02-22 14:42:50.047'' AS DateTime), N''F3M'', CAST(N''2017-02-22 14:42:50.047'' AS DateTime), N''F3M'', 10, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (11, 6, 5, 0, 1, CAST(N''2017-03-01 18:32:55.717'' AS DateTime), N''F3M'', CAST(N''2017-03-01 18:32:55.717'' AS DateTime), N''F3M'', 11, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (12, 6, 6, 0, 1, CAST(N''2017-03-01 18:32:55.717'' AS DateTime), N''F3M'', CAST(N''2017-03-01 18:32:55.717'' AS DateTime), N''F3M'', 12, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (13, 7, 5, 0, 1, CAST(N''2017-03-01 18:38:36.727'' AS DateTime), N''F3M'', CAST(N''2017-03-01 18:38:36.727'' AS DateTime), N''F3M'', 13, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (14, 7, 6, 0, 1, CAST(N''2017-03-01 18:38:36.730'' AS DateTime), N''F3M'', CAST(N''2017-03-01 18:38:36.730'' AS DateTime), N''F3M'', 14, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (15, 8, 5, 0, 1, CAST(N''2017-03-01 18:38:36.727'' AS DateTime), N''F3M'', CAST(N''2017-03-01 18:38:36.727'' AS DateTime), N''F3M'', 15, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (16, 8, 6, 0, 1, CAST(N''2017-03-01 18:38:36.730'' AS DateTime), N''F3M'', CAST(N''2017-03-01 18:38:36.730'' AS DateTime), N''F3M'', 16, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (17, 9, 5, 0, 1, CAST(N''2017-03-01 18:38:36.727'' AS DateTime), N''F3M'', CAST(N''2017-03-01 18:38:36.727'' AS DateTime), N''F3M'', 17, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (18, 9, 6, 0, 1, CAST(N''2017-03-01 18:38:36.730'' AS DateTime), N''F3M'', CAST(N''2017-03-01 18:38:36.730'' AS DateTime), N''F3M'', 18, 0)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] OFF')

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumentoSeries] ON 
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (1, cast(year(getdate()) as nvarchar(4)) +''SV'', cast(year(getdate()) as nvarchar(4)) +''SV'', 1, 1, 0, 1, CAST(N''2017-02-22 09:04:15.127'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (2, cast(year(getdate()) as nvarchar(4)) +''FA'', cast(year(getdate()) as nvarchar(4)) +''FA'', 1, 2, 0, 1, CAST(N''2017-02-22 09:04:15.127'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (3, cast(year(getdate()) as nvarchar(4)) +''FT'', cast(year(getdate()) as nvarchar(4)) +''FT'', 1, 3, 0, 1, CAST(N''2017-02-22 09:04:15.127'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (4, cast(year(getdate()) as nvarchar(4)) +''FR'', cast(year(getdate()) as nvarchar(4)) +''FR'', 1, 4, 0, 1, CAST(N''2017-02-22 09:04:15.127'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (5, cast(year(getdate()) as nvarchar(4)) +''FS'', cast(year(getdate()) as nvarchar(4)) +''FS'', 1, 5, 0, 1, CAST(N''2017-02-22 09:04:15.127'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (6, cast(year(getdate()) as nvarchar(4)) +''NC'', cast(year(getdate()) as nvarchar(4)) +''NC'', 1, 6, 0, 1, CAST(N''2017-02-22 09:04:15.127'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (7, cast(year(getdate()) as nvarchar(4)) +''RC'', cast(year(getdate()) as nvarchar(4)) +''RC'', 1, 7, 0, 1, CAST(N''2017-02-22 09:04:15.127'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (8, cast(year(getdate()) as nvarchar(4)) +''NA'', cast(year(getdate()) as nvarchar(4)) +''NA'', 1, 8, 0, 1, CAST(N''2017-02-22 09:04:15.127'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (9, cast(year(getdate()) as nvarchar(4)) +''ND'', cast(year(getdate()) as nvarchar(4)) +''ND'', 1, 9, 0, 1, CAST(N''2017-02-22 09:04:15.127'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoSeries] OFF')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] WHERE [IDPerfis]=1 and [IDMenusAreasEmpresa] in (1,2,3,4,5,6,7,8,9))
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0,    CAST(N''2017-03-17 10:39:06.000'' AS DateTime), N''F3M'', NULL, NULL, 0, 0)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 3, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-03-17 10:34:37.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 8, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-03-17 10:35:03.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 6, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-03-17 10:35:55.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 7, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-03-17 10:38:53.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 2, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-03-17 10:39:34.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 4, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-03-17 03:03:22.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 5, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-03-17 03:03:34.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 9, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-03-17 03:03:34.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
END')

alter table tbDocumentosVendasLinhas add [DataDocOrigem] [datetime] NULL, [IDAdiantamentoOrigem] [bigint] NULL, PrecoUnitarioEfetivoSemIva [float] NULL, ValorDescontoEfetivoSemIva [float] NULL 

exec('update tbSistemaModulos set TiposDocumentos=0')
exec('update tbSistemaModulos set TiposDocumentos=1 where id=4')
exec('update [F3MOGeral].dbo.tbSistemaModulos set TiposDocumentos=0')
exec('update [F3MOGeral].dbo.tbSistemaModulos set TiposDocumentos=1 where id=4')
exec('update [F3MOGeral].dbo.tbmenus set ativo=0 where id in (1,2,3,5,6,7,8,9,10,11,13,22)')

EXEC('UPDATE [F3MOGeral].dbo.tbColunasListasPersonalizadas SET ColumnWidth = 400 WHERE ColunaVista = ''Nome'' and IDListaPersonalizada IN(25,68)')
EXEC('UPDATE [F3MOGeral].dbo.tbColunasListasPersonalizadas SET ColumnWidth = 150 WHERE ColunaVista = ''Codigo'' and IDListaPersonalizada IN(25,68)')
EXEC('UPDATE [F3MOGeral].dbo.tbColunasListasPersonalizadas SET ColumnWidth = 150 WHERE ColunaVista = ''IDEntidade1'' and IDListaPersonalizada IN(25,68)')
EXEC('UPDATE [F3MOGeral].dbo.tbColunasListasPersonalizadas SET ColumnWidth = 150 WHERE ColunaVista = ''IDEntidade2'' and IDListaPersonalizada IN(25,68)')
EXEC('UPDATE [F3MOGeral].dbo.tbColunasListasPersonalizadas SET ColumnWidth = 400 WHERE ColunaVista = ''IDEntidade'' and IDListaPersonalizada IN(55,58)')
EXEC('UPDATE [F3MOGeral].dbo.tbColunasListasPersonalizadas SET ColumnWidth = 150 WHERE ColunaVista = ''Documento'' and IDListaPersonalizada IN(55,58)')
EXEC('UPDATE [F3MOGeral].dbo.tbColunasListasPersonalizadas SET ColumnWidth = 150 WHERE ColunaVista = ''DataDocumento'' and IDListaPersonalizada IN(55,58)')
EXEC('UPDATE [F3MOGeral].dbo.tbColunasListasPersonalizadas SET ColumnWidth = 150 WHERE ColunaVista = ''IDEntidade1'' and IDListaPersonalizada IN(55,58)')
EXEC('UPDATE [F3MOGeral].dbo.tbColunasListasPersonalizadas SET ColumnWidth = 150 WHERE ColunaVista = ''IDEntidade2'' and IDListaPersonalizada IN(55,58)')
EXEC('UPDATE [F3MOGeral].dbo.tbColunasListasPersonalizadas SET ColumnWidth = 500 WHERE ColunaVista = ''Descricao'' and IDListaPersonalizada = 39')
EXEC('UPDATE [F3MOGeral].dbo.tbColunasListasPersonalizadas SET ColumnWidth = 500 WHERE ColunaVista = ''Nome'' and IDListaPersonalizada = 22')
EXEC('UPDATE [F3MOGeral].dbo.tbUtilizadoresEmpresa SET IdHomePage=102')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] WHERE ID in (1,2,3,4,5) )
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] ON 
INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] ([ID], [IDMenu], [IDUtilizador], [Ordem], [Descricao], [Icon], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, 84, 1, 1, NULL, NULL, 0, 0, CAST(N''2017-03-31 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] ([ID], [IDMenu], [IDUtilizador], [Ordem], [Descricao], [Icon], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, 59, 1, 2, NULL, NULL, 0, 0, CAST(N''2017-03-31 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] ([ID], [IDMenu], [IDUtilizador], [Ordem], [Descricao], [Icon], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, 46, 1, 3, NULL, NULL, 0, 0, CAST(N''2017-03-31 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] ([ID], [IDMenu], [IDUtilizador], [Ordem], [Descricao], [Icon], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, 88, 1, 4, NULL, NULL, 0, 0, CAST(N''2017-03-31 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] ([ID], [IDMenu], [IDUtilizador], [Ordem], [Descricao], [Icon], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (5, 96, 1, 5, NULL, NULL, 0, 0, CAST(N''2017-03-31 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] OFF
END')

EXEC('UPDATE [F3MOGeral].dbo.tbColunasListasPersonalizadas SET ColumnWidth = 150 WHERE ColumnWidth=200')
exec('update [F3MOGeral].dbo.tbColunasListasPersonalizadas set ColunaVista=''CodigoCliente'', ColumnWidth=100  where id=132')
exec('update [F3MOGeral].dbo.tbColunasListasPersonalizadas set ColunaVista=''CodigoCliente'', ColumnWidth=100 where id=199')
exec('update [F3MOGeral].dbo.tbColunasListasPersonalizadas set ColunaVista=''IDEstado'' where id=138')
exec('update [F3MOGeral].dbo.tbColunasListasPersonalizadas set ColunaVista=''IDEstado'' where id=205')

CREATE TABLE [dbo].[tbClientesLojas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDLoja] [bigint] NULL,
	[IDCliente] [bigint] NOT NULL,
	[TotalVendas] [float] NOT NULL,
	[Saldo] [float] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [int] NULL,
 CONSTRAINT [PK_tbClientesLojas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbClientesLojas] ADD  CONSTRAINT [DF_tbClientesLojas_Saldo]  DEFAULT ((0)) FOR [Saldo]

ALTER TABLE [dbo].[tbClientesLojas] ADD  CONSTRAINT [DF_tbClientesLojas_TotalVendas]  DEFAULT ((0)) FOR [TotalVendas]

ALTER TABLE [dbo].[tbClientesLojas] ADD  CONSTRAINT [DF_tbClientesLojas_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbClientesLojas] ADD  CONSTRAINT [DF_tbClientesLojas_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbClientesLojas] ADD  CONSTRAINT [DF_tbClientesLojas_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbClientesLojas] ADD  CONSTRAINT [DF_tbClientesLojas_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]

ALTER TABLE [dbo].[tbClientesLojas] ADD  CONSTRAINT [DF_tbClientesLojas_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbClientesLojas] ADD  CONSTRAINT [DF_tbClientesLojas_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbClientesLojas]  WITH CHECK ADD  CONSTRAINT [FK_tbClientesLojas_tbClientes] FOREIGN KEY([IDCliente])
REFERENCES [dbo].[tbClientes] ([ID])

ALTER TABLE [dbo].[tbClientesLojas] CHECK CONSTRAINT [FK_tbClientesLojas_tbClientes]

ALTER TABLE [dbo].[tbClientesLojas]  WITH CHECK ADD  CONSTRAINT [FK_tbClientesLojas_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbClientesLojas] CHECK CONSTRAINT [FK_tbClientesLojas_tbLojas]

ALTER TABLE tbDocumentosVendas ADD CodigoPostalLoja NVARCHAR(8) NULL
ALTER TABLE tbDocumentosVendas ADD LocalidadeLoja NVARCHAR(50) NULL
ALTER TABLE tbDocumentosVendas ADD SiglaLoja NVARCHAR(3) NULL
ALTER TABLE tbDocumentosVendas ADD NIFLoja NVARCHAR(9) NULL
ALTER TABLE tbDocumentosVendas ADD DesignacaoComercialLoja NVARCHAR(160) NULL
ALTER TABLE tbDocumentosVendas ADD MoradaLoja NVARCHAR(100) NULL

ALTER TABLE tbRecibos ADD CodigoPostalLoja NVARCHAR(8) NULL
ALTER TABLE tbRecibos ADD LocalidadeLoja NVARCHAR(50) NULL
ALTER TABLE tbRecibos ADD SiglaLoja NVARCHAR(3) NULL
ALTER TABLE tbRecibos ADD NIFLoja NVARCHAR(9) NULL
ALTER TABLE tbRecibos ADD DesignacaoComercialLoja NVARCHAR(160) NULL
ALTER TABLE tbRecibos ADD MoradaLoja NVARCHAR(100) NULL

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo 
from tbartigos left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo
left join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=39')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo 
from tbartigos left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo
inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id 
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=63')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, mo.Descricao as DescricaoModelo, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo, 
tb.Tamanho , tb.CodigoCor, tb.CorGenerica, tb.CorLente
from tbartigos left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo
inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id 
inner join tbAros tb on tbartigos.id=tb.IDArtigo
left join tbModelos mo on tb.IDModelo=mo.id
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=59')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, mo.Descricao as DescricaoModelo, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo, 
tb.Tamanho , tb.CodigoCor, tb.CorGenerica, tb.CorLente
from tbartigos left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo
inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id 
inner join tbOculosSol tb on tbartigos.id=tb.IDArtigo
left join tbModelos mo on tb.IDModelo=mo.id
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=62')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, mo.Descricao as DescricaoModelo, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo, 
tb.raio, tb.Diametro, isnull(tb.PotenciaCilindrica,0) as PotenciaCilindrica, isnull(tb.PotenciaEsferica,0) as PotenciaEsferica, isnull(tb.Eixo,0) as Eixo, isnull(tb.Adicao,0) as Adicao
from tbartigos left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo
inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id 
inner join tbLentesContato tb on tbartigos.id=tb.IDArtigo
left join tbModelos mo on tb.IDModelo=mo.id
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=61')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, mo.Descricao as DescricaoModelo, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo, 
tb.Diametro, isnull(tb.PotenciaCilindrica,0) as PotenciaCilindrica, isnull(tb.PotenciaEsferica,0) as PotenciaEsferica, isnull(tb.PotenciaPrismatica,0) as PotenciaPrismatica, isnull(tb.Adicao,0) as Adicao
from tbartigos left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo
inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id 
inner join tbLentesoftalmicas tb on tbartigos.id=tb.IDArtigo
left join tbModelos mo on tb.IDModelo=mo.id
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=60')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''select tbclientes.ID, tbclientes.Codigo, tbclientes.Nome, tbclientes.NContribuinte, tbclientes.Ativo, mt.Nome as MedicoTecnico, en.Descricao as Entidade1, et.Descricao as Entidade2, cc.Telefone, lj.descricao as Loja, isnull(tbclientes.saldo, 0) as Saldo, tbclientes.IdTipoEntidade, cast(tbclientes.nome as nvarchar(20)) as DescricaoSplitterLadoDireito 
from tbclientes  
left join tbLojas lj on tbclientes.idloja=lj.id
left join tbMedicosTecnicos mt on tbclientes.idmedicotecnico=mt.id
left join tbentidades en on tbclientes.identidade1=en.id
left join tbentidades et on tbclientes.identidade2=et.id
left join tbclientescontatos cc on tbclientes.id=cc.idcliente and cc.ordem=1''
where id in (25,66,68)')

SET IDENTITY_INSERT [dbo].[tbParametrosCamposContexto] ON 
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (41, 3, N'NumDiasAnular', N'NumDiasAnular', NULL, 9,NULL, N'30', NULL, NULL, NULL, N'30', N'0', 0, 4, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (42, 3, N'NumDiasAntecedencia', N'NumDiasAntecedencia', NULL, 9,NULL, N'0', NULL, NULL, NULL, N'60', N'0', 0, 4, 0, 1, CAST(N'2016-08-04 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbParametrosCamposContexto] ([ID], [IDParametroContexto], [CodigoCampo], [DescricaoCampo], [TipoCondicionante], [IDTipoDados], [ConteudoLista], [ValorCampo], [Accao], [AccaoExtra], [Filtro], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (43, 7, N'ArmazemLocalizacao', N'ArmazemLocalizacao', NULL, 3, NULL, NULL, '../TabelasAuxiliares/Localizacoes', '../TabelasAuxiliares/Localizacoes/Index', NULL, NULL, NULL, 0, 11, 0, 1, GETDATE(), N'F3M', NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbParametrosCamposContexto] OFF

exec('update [F3MOGeral].dbo.tbempresas set EmpresaDemonstracao=1 where id=1')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, TotalEntidade1, TotalClienteMoedaDocumento, d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as DescricaoSplitterLadoDireito, d.IDEstado,
(isnull(d.TotalClienteMoedaDocumento,0)-isnull(d.valorpago,0)) as ValorPendente, s.Descricao as DescricaoEstado, e1.Descricao as DescricaoEntidade1, e2.Descricao as DescricaoEntidade2, TD.IDSistemaTiposDocumento
from tbDocumentosVendas d 
inner join tbLojas l on d.IDloja=l.id
inner join tbClientes c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbSistemaTiposDocumento STD on TD.IDSistemaTiposDocumento=STD.ID and STD.Tipo=''''VndServico''''
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbEstados s on d.IDEstado=s.ID
left join tbentidades e1 on d.IDEntidade=e1.ID
left join tbentidades e2 on d.IDEntidade1=e2.ID
''where id in (55)')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, TotalEntidade1, TotalClienteMoedaDocumento, d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as DescricaoSplitterLadoDireito, d.IDEstado,
(isnull(d.TotalClienteMoedaDocumento,0)-isnull(d.valorpago,0)) as ValorPendente, s.Descricao as DescricaoEstado, e1.Descricao as DescricaoEntidade1, e2.Descricao as DescricaoEntidade2, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax
from tbDocumentosVendas d 
inner join tbLojas l on d.IDloja=l.id
inner join tbClientes c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbSistemaTiposDocumento STD on TD.IDSistemaTiposDocumento=STD.ID and STD.Tipo<>''''VndServico''''
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbEstados s on d.IDEstado=s.ID
left join tbentidades e1 on d.IDEntidade=e1.ID
left join tbentidades e2 on d.IDEntidade1=e2.ID
''where id in (58)')

alter table tbdocumentosvendas add [DataUltimaImpressao] [datetime] NULL, [NumeroImpressoes] [int] NULL, [IDLojaUltimaImpressao] [bigint] NULL  
alter table tbRecibos add [SegundaVia] [bit] NULL, [DataUltimaImpressao] [datetime] NULL,[NumeroImpressoes] [int] NULL,	[IDLojaUltimaImpressao] [bigint] NULL  

alter table tbSAFT add TipoSAFT bigint null, IDLoja bigint null 
ALTER TABLE [dbo].[tbSAFT]  WITH CHECK ADD  CONSTRAINT [FK_tbSAFT_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

CREATE TABLE [dbo].[tbRazoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDLoja] [bigint] NULL,
	[Data] [Datetime] NOT NULL,
	[TabelaBD] [nvarchar](255) NOT NULL,
	[RegistoID] [bigint] NOT NULL,
	[Opcao] [nvarchar](255) NULL,	
	[Razao] [nvarchar](4000) NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbRazoes_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbRazoes_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbRazoes_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbRazoes_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbRazoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbRazoes_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbRazoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbRazoes]  WITH CHECK ADD  CONSTRAINT [FK_tbRazoes_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])
ALTER TABLE [dbo].[tbRazoes] CHECK CONSTRAINT [FK_tbRazoes_tbLojas]

ALTER TABLE [dbo].[tbArtigos] ADD [IDTipoDocumentoUPC] [bigint] NULL, [IDDocumentoUPC] [bigint] NULL, [DataControloUPC] [datetime] NULL, [RecalculaUPC] [bit] NULL

ALTER TABLE [dbo].[tbArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigos_IDTipoDocumento] FOREIGN KEY([IDTipoDocumentoUPC])
REFERENCES [dbo].[tbTiposDocumento] ([ID])
ALTER TABLE [dbo].[tbArtigos] CHECK CONSTRAINT [FK_tbArtigos_IDTipoDocumento]
