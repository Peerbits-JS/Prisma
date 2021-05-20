-- Pagamentos de Compras
exec('alter table tbfornecedores add [Saldo] [float] NULL')
exec('alter table tbDocumentosVendasLinhas add [QuantidadeSatisfeita] [float] NULL, [QuantidadeDevolvida] [float] NULL')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=114)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) VALUES (114, 3, N''DocumentosPagamentosCompras'', N''003.005'', N''DocumentosPagamentosCompras'', 2, N''f3icon-doc-stock'', N''/Documentos/DocumentosPagamentosCompras'', 1, 3, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=114 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 114, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE TabelaPrincipal=''tbPagamentosCompras'')
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ON
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] (ID, [Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query]) VALUES (77, N''Pagamentos de Compras'', 1, 1, 114, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbPagamentosCompras'', 
N''select D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, isnull(D.Assinatura,''''.'''') as Assinatura, D.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, d.IDEntidade, c.nome as DescricaoEntidade, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento from tbPagamentosCompras d left join tbLojas l on d.IDloja=l.id left join tbFornecedores c on d.IDEntidade=c.id inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID left join tbSistemaTiposDocumentoFiscal TDF on td.IDSistemaTiposDocumentoFiscal=TDF.ID left join tbEstados s on d.IDEstado=s.ID'')
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE Tabela=''tbPagamentosCompras'')
BEGIN
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', 77, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbPagamentosCompras'', 1, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', 77, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbPagamentosCompras'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', 77, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbPagamentosCompras'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade'', 77, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbPagamentosCompras'', 1, 0, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', 77, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbPagamentosCompras'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TotalMoedaDocumento'', 70, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbPagamentosCompras'', 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEstado'', 77, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbPagamentosCompras'', 1, 0, 150)
END')

CREATE TABLE [dbo].[tbPagamentosCompras](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTipoDocumento] [bigint] NOT NULL,
	[NumeroDocumento] [bigint] NULL,
	[DataDocumento] [datetime] NOT NULL,
	[Observacoes] [nvarchar](max) NULL,
	[IDMoeda] [bigint] NULL,
	[TaxaConversao] [float] NULL,
	[TotalMoedaDocumento] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[TotalMoeda] [float] NULL,
	[ValorEntregue] [float] NULL,
	[Troco] [float] NULL,
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
	[Impresso] [bit] NOT NULL CONSTRAINT [DF_tbPagamentosCompras_Impresso]  DEFAULT ((0)),
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
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbPagamentosCompras_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbPagamentosCompras_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbPagamentosCompras_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](20) NOT NULL CONSTRAINT [DF_tbPagamentosCompras_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbPagamentosCompras_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL CONSTRAINT [DF_tbPagamentosCompras_UtilizadorAlteracao]  DEFAULT (''),
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
	[VossoNumeroDocumento] [nvarchar](256) NULL,
	[ValorPago] [float] NULL,
	[CodigoPostalLoja] [nvarchar](8) NULL,
	[LocalidadeLoja] [nvarchar](50) NULL,
	[SiglaLoja] [nvarchar](3) NULL,
	[NIFLoja] [nvarchar](9) NULL,
	[DesignacaoComercialLoja] [nvarchar](160) NULL,
	[MoradaLoja] [nvarchar](100) NULL,
	[SegundaVia] [bit] NULL,
	[DataUltimaImpressao] [datetime] NULL,
	[NumeroImpressoes] [int] NULL,
	[IDLojaUltimaImpressao] [bigint] NULL,
	[TotalDocumentos] [float] NULL, 
	[TotalDescontos] [float] NULL,
 CONSTRAINT [PK_tbPagamentosCompras] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbCodigosPostais_Carga] FOREIGN KEY([IDCodigoPostalCarga])
REFERENCES [dbo].[tbCodigosPostais] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbCodigosPostais_Carga]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbCodigosPostais_Descarga] FOREIGN KEY([IDCodigoPostalDescarga])
REFERENCES [dbo].[tbCodigosPostais] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbCodigosPostais_Descarga]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbCodigosPostais_Destinatario] FOREIGN KEY([IDCodigoPostalDestinatario])
REFERENCES [dbo].[tbCodigosPostais] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbCodigosPostais_Destinatario]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbCodigosPostais_Fiscal] FOREIGN KEY([IDCodigoPostalFiscal])
REFERENCES [dbo].[tbCodigosPostais] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbCodigosPostais_Fiscal]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbConcelhos_Carga] FOREIGN KEY([IDConcelhoCarga])
REFERENCES [dbo].[tbConcelhos] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbConcelhos_Carga]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbConcelhos_Descarga] FOREIGN KEY([IDConcelhoDescarga])
REFERENCES [dbo].[tbConcelhos] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbConcelhos_Descarga]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbConcelhos_Destinatario] FOREIGN KEY([IDConcelhoDestinatario])
REFERENCES [dbo].[tbConcelhos] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbConcelhos_Destinatario]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbConcelhos_Fiscal] FOREIGN KEY([IDConcelhoFiscal])
REFERENCES [dbo].[tbConcelhos] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbConcelhos_Fiscal]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbCondicoesPagamento] FOREIGN KEY([IDCondicaoPagamento])
REFERENCES [dbo].[tbCondicoesPagamento] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbCondicoesPagamento]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbDistritos_Carga] FOREIGN KEY([IDDistritoCarga])
REFERENCES [dbo].[tbDistritos] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbDistritos_Carga]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbDistritos_Descarga] FOREIGN KEY([IDDistritoDescarga])
REFERENCES [dbo].[tbDistritos] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbDistritos_Descarga]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbDistritos_Destinatario] FOREIGN KEY([IDDistritoDestinatario])
REFERENCES [dbo].[tbDistritos] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbDistritos_Destinatario]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbDistritos_Fiscal] FOREIGN KEY([IDDistritoFiscal])
REFERENCES [dbo].[tbDistritos] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbDistritos_Fiscal]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbEstados] FOREIGN KEY([IDEstado])
REFERENCES [dbo].[tbEstados] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbEstados]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbFormasExpedicao] FOREIGN KEY([IDFormaExpedicao])
REFERENCES [dbo].[tbFormasExpedicao] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbFormasExpedicao]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbFornecedores] FOREIGN KEY([IDEntidade])
REFERENCES [dbo].[tbFornecedores] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbFornecedores]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbIVA_Portes] FOREIGN KEY([IDTaxaIvaPortes])
REFERENCES [dbo].[tbIVA] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbIVA_Portes]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbLojas]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbMoedas]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbPaises] FOREIGN KEY([IDPaisCarga])
REFERENCES [dbo].[tbPaises] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbPaises]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbPaises_Descarga] FOREIGN KEY([IDPaisDescarga])
REFERENCES [dbo].[tbPaises] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbPaises_Descarga]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbPaises_Fiscal] FOREIGN KEY([IDPaisFiscal])
REFERENCES [dbo].[tbPaises] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbPaises_Fiscal]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbSistemaEspacoFiscal] FOREIGN KEY([IDEspacoFiscalPortes])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbSistemaEspacoFiscal]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbSistemaEspacoFiscal1] FOREIGN KEY([IDEspacoFiscal])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbSistemaEspacoFiscal1]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbSistemaRegimeIVA] FOREIGN KEY([IDRegimeIvaPortes])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbSistemaRegimeIVA]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbSistemaRegimeIVA1] FOREIGN KEY([IDRegimeIva])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbSistemaRegimeIVA1]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbSistemaRegioesIVA] FOREIGN KEY([IDLocalOperacao])
REFERENCES [dbo].[tbSistemaRegioesIVA] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbSistemaRegioesIVA]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbSistemaTiposDocumentoPrecoUnitario] FOREIGN KEY([IDSisTiposDocPU])
REFERENCES [dbo].[tbSistemaTiposDocumentoPrecoUnitario] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbSistemaTiposDocumentoPrecoUnitario]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbSistemaTiposEntidade] FOREIGN KEY([IDTipoEntidade])
REFERENCES [dbo].[tbSistemaTiposEntidade] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbSistemaTiposEntidade]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbTiposDocumento] FOREIGN KEY([IDTipoDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbTiposDocumento]

ALTER TABLE [dbo].[tbPagamentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosCompras_tbTiposDocumentoSeries] FOREIGN KEY([IDTiposDocumentoSeries])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])
ALTER TABLE [dbo].[tbPagamentosCompras] CHECK CONSTRAINT [FK_tbPagamentosCompras_tbTiposDocumentoSeries]

CREATE TABLE [dbo].[tbPagamentosComprasLinhas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDPagamentoCompra] [bigint] NOT NULL,
	[IDTipoDocumento] [bigint] NOT NULL,
	[IDTiposDocumentoSeries] [bigint] NOT NULL,
	[IDDocumentoCompra] [bigint] NOT NULL,
	[IDEntidade] [bigint] NOT NULL,
	[IDTipoEntidade] [bigint] NULL,
	[DescricaoEntidade] [nvarchar](200) NULL,
	[IDSistemaNaturezas] [bigint] NULL,
	[NumeroDocumento] [bigint] NULL,
	[DataDocumento] [datetime] NOT NULL,
	[DataVencimento] [datetime] NOT NULL,
	[Documento] [nvarchar](255) NULL,
	[TotalMoedaDocumento] [float] NULL,
	[ValorPendente] [float] NULL,
	[PercentagemDesconto] [float] NULL, 
	[ValorDesconto] [float] NULL,
	[TotalMoeda] [float] NULL,
	[IDMoeda] [bigint] NULL,
	[TaxaConversao] [float] NULL,
	[TotalMoedaReferencia] [float] NULL,
	[ValorPago] [float] NULL,
	[Ordem] [int] NULL,
	[IDLoja] [bigint] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbPagamentosComprasLinhas_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbPagamentosComprasLinhas_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbPagamentosComprasLinhas_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbPagamentosComprasLinhas_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbPagamentosComprasLinhas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbPagamentosComprasLinhas_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbPagamentosComprasLinhas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbPagamentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasLinhas_tbClientes] FOREIGN KEY([IDEntidade])
REFERENCES [dbo].[tbFornecedores] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasLinhas] CHECK CONSTRAINT [FK_tbPagamentosComprasLinhas_tbClientes]

ALTER TABLE [dbo].[tbPagamentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasLinhas_tbDocumentosCompras] FOREIGN KEY([IDDocumentoCompra])
REFERENCES [dbo].[tbDocumentosCompras] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasLinhas] CHECK CONSTRAINT [FK_tbPagamentosComprasLinhas_tbDocumentosCompras]

ALTER TABLE [dbo].[tbPagamentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasLinhas_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasLinhas] CHECK CONSTRAINT [FK_tbPagamentosComprasLinhas_tbLojas]

ALTER TABLE [dbo].[tbPagamentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasLinhas_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasLinhas] CHECK CONSTRAINT [FK_tbPagamentosComprasLinhas_tbMoedas]

ALTER TABLE [dbo].[tbPagamentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasLinhas_tbPagamentosCompras] FOREIGN KEY([IDPagamentoCompra])
REFERENCES [dbo].[tbPagamentosCompras] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasLinhas] CHECK CONSTRAINT [FK_tbPagamentosComprasLinhas_tbPagamentosCompras]

ALTER TABLE [dbo].[tbPagamentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasLinhas_tbTiposDocumento] FOREIGN KEY([IDTipoDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasLinhas] CHECK CONSTRAINT [FK_tbPagamentosComprasLinhas_tbTiposDocumento]

ALTER TABLE [dbo].[tbPagamentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasLinhas_tbTiposDocumentoSeries] FOREIGN KEY([IDTiposDocumentoSeries])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasLinhas] CHECK CONSTRAINT [FK_tbPagamentosComprasLinhas_tbTiposDocumentoSeries]

ALTER TABLE [dbo].[tbPagamentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasLinhas_tbSistemaNaturezas] FOREIGN KEY([IDSistemaNaturezas])
REFERENCES [dbo].[tbSistemaNaturezas] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasLinhas] CHECK CONSTRAINT [FK_tbPagamentosComprasLinhas_tbSistemaNaturezas]

CREATE TABLE [dbo].[tbPagamentosComprasFormasPagamento](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDPagamentoCompra] [bigint] NOT NULL,
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
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbPagamentosComprasFormasPagamento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbPagamentosComprasFormasPagamento] ADD  CONSTRAINT [DF_tbPagamentosComprasFormasPagamento_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbPagamentosComprasFormasPagamento] ADD  CONSTRAINT [DF_tbPagamentosComprasFormasPagamento_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbPagamentosComprasFormasPagamento] ADD  CONSTRAINT [DF_tbPagamentosComprasFormasPagamento_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbPagamentosComprasFormasPagamento] ADD  CONSTRAINT [DF_tbPagamentosComprasFormasPagamento_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbPagamentosComprasFormasPagamento] ADD  CONSTRAINT [DF_tbPagamentosComprasFormasPagamento_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbPagamentosComprasFormasPagamento] ADD  CONSTRAINT [DF_tbPagamentosComprasFormasPagamento_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbPagamentosComprasFormasPagamento]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasFormasPagamento_tbFormasPagamento] FOREIGN KEY([IDFormaPagamento])
REFERENCES [dbo].[tbFormasPagamento] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasFormasPagamento] CHECK CONSTRAINT [FK_tbPagamentosComprasFormasPagamento_tbFormasPagamento]

ALTER TABLE [dbo].[tbPagamentosComprasFormasPagamento]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasFormasPagamento_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasFormasPagamento] CHECK CONSTRAINT [FK_tbPagamentosComprasFormasPagamento_tbMoedas]

ALTER TABLE [dbo].[tbPagamentosComprasFormasPagamento]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasFormasPagamento_tbPagamentosCompras] FOREIGN KEY([IDPagamentoCompra])
REFERENCES [dbo].[tbPagamentosCompras] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasFormasPagamento] CHECK CONSTRAINT [FK_tbPagamentosComprasFormasPagamento_tbPagamentosCompras]

CREATE TABLE [dbo].[tbDocumentosComprasPendentes](
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
	[Pago] [bit] NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[IDDocumentoCompra] [bigint] NULL,
 CONSTRAINT [PK_tbDocumentosComprasPendentes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbDocumentosComprasPendentes] ADD  CONSTRAINT [DF_tbDocumentosComprasPendentes_Pago]  DEFAULT ((0)) FOR [Pago]
ALTER TABLE [dbo].[tbDocumentosComprasPendentes] ADD  CONSTRAINT [DF_tbDocumentosComprasPendentes_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbDocumentosComprasPendentes] ADD  CONSTRAINT [DF_tbDocumentosComprasPendentes_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbDocumentosComprasPendentes] ADD  CONSTRAINT [DF_tbDocumentosComprasPendentes_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbDocumentosComprasPendentes] ADD  CONSTRAINT [DF_tbDocumentosComprasPendentes_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbDocumentosComprasPendentes] ADD  CONSTRAINT [DF_tbDocumentosComprasPendentes_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbDocumentosComprasPendentes] ADD  CONSTRAINT [DF_tbDocumentosComprasPendentes_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]
ALTER TABLE [dbo].[tbDocumentosComprasPendentes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasPendentes_tbDocumentosCompras] FOREIGN KEY([IDDocumentoCompra])
REFERENCES [dbo].[tbDocumentosCompras] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasPendentes] CHECK CONSTRAINT [FK_tbDocumentosComprasPendentes_tbDocumentosCompras]
ALTER TABLE [dbo].[tbDocumentosComprasPendentes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasPendentes_tbSistemaNaturezas] FOREIGN KEY([IDSistemaNaturezas])
REFERENCES [dbo].[tbSistemaNaturezas] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasPendentes] CHECK CONSTRAINT [FK_tbDocumentosComprasPendentes_tbSistemaNaturezas]
ALTER TABLE [dbo].[tbDocumentosComprasPendentes]  WITH CHECK ADD  CONSTRAINT [tbDocumentosComprasPendentes_ValorPendente_MI_0] CHECK  (([valorpendente]>=(0)))
ALTER TABLE [dbo].[tbDocumentosComprasPendentes] CHECK CONSTRAINT [tbDocumentosComprasPendentes_ValorPendente_MI_0]

ALTER TABLE [dbo].[tbDocumentosCompras] ADD [ValorPago] [float] NULL
ALTER TABLE [dbo].[tbDocumentosCompras] ADD [Satisfeito] [bit] NULL
ALTER TABLE [dbo].[tbDocumentosComprasLinhas] ADD [Satisfeito] [bit] NULL
ALTER TABLE [dbo].[tbDocumentosStock] ADD [Satisfeito] [bit] NULL
ALTER TABLE [dbo].[tbDocumentosStockLinhas] ADD [Satisfeito] [bit] NULL
ALTER TABLE [dbo].[tbDocumentosVendas] ADD [Satisfeito] [bit] NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [Satisfeito] [bit] NULL
alter table tbCondicoesPagamento alter column IDTipoCondDataVencimento bigint Null

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] ADD [IDLinhaDocumentoCompra] [bigint] NULL
ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbDocumentosComprasLinhas] FOREIGN KEY([IDLinhaDocumentoCompra])
REFERENCES [dbo].[tbDocumentosComprasLinhas] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbDocumentosComprasLinhas]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] ADD [IDLinhaDocumentoVenda] [bigint] NULL
ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbDocumentosVendasLinhas] FOREIGN KEY([IDLinhaDocumentoVenda])
REFERENCES [dbo].[tbDocumentosVendasLinhas] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbDocumentosVendasLinhas]

ALTER TABLE [dbo].[tbDocumentosComprasLinhas] ADD [IDLinhaDocumentoStock] [bigint] NULL
ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbDocumentosStockLinhas] FOREIGN KEY([IDLinhaDocumentoStock])
REFERENCES [dbo].[tbDocumentosStockLinhas] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbDocumentosStockLinhas]

CREATE TABLE [dbo].[tbPagamentosComprasAnexos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDPagamentoCompra] [bigint] NOT NULL,
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
 CONSTRAINT [PK_tbPagamentosComprasAnexos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tbPagamentosComprasAnexos] UNIQUE NONCLUSTERED 
(
	[IDPagamentoCompra] ASC,
	[Ficheiro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbPagamentosComprasAnexos] ADD  CONSTRAINT [DF_tbPagamentosComprasAnexos_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbPagamentosComprasAnexos] ADD  CONSTRAINT [DF_tbPagamentosComprasAnexos_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbPagamentosComprasAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasAnexos_tbPagamentosCompras] FOREIGN KEY([IDPagamentoCompra])
REFERENCES [dbo].[tbPagamentosCompras] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasAnexos] CHECK CONSTRAINT [FK_tbPagamentosComprasAnexos_tbPagamentosCompras]
ALTER TABLE [dbo].[tbPagamentosComprasAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbPagamentosComprasAnexos_tbSistemaTiposAnexos] FOREIGN KEY([IDTipoAnexo])
REFERENCES [dbo].[tbSistemaTiposAnexos] ([ID])
ALTER TABLE [dbo].[tbPagamentosComprasAnexos] CHECK CONSTRAINT [FK_tbPagamentosComprasAnexos_tbSistemaTiposAnexos]

-- Pagamentos de Compras Anexos
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=115)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) VALUES (115, 3, N''DocumentosPagamentosComprasAnexos'', N''003.005.001'', N''Anexos'', 3, N''f3icon-glasses'', N''/Documentos/DocumentosPagamentosComprasAnexos'', 1, 3, 1, 1, 1, 1, 1, 1, NULL, 1, 1, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=115 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 115, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

CREATE TABLE [dbo].[tbCCFornecedores](
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
 CONSTRAINT [PK_tbCCFornecedores] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbCCFornecedores] ADD  CONSTRAINT [DF_tbCCFornecedores_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbCCFornecedores] ADD  CONSTRAINT [DF_tbCCFornecedores_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbCCFornecedores] ADD  CONSTRAINT [DF_tbCCFornecedores_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbCCFornecedores] ADD  CONSTRAINT [DF_tbCCFornecedores_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbCCFornecedores] ADD  CONSTRAINT [DF_tbCCFornecedores_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbCCFornecedores] ADD  CONSTRAINT [DF_tbCCFornecedores_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]


EXEC('DROP PROCEDURE [dbo].[sp_AtualizaArtigos]')

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



--apagar o stored procedure
EXEC('DROP PROCEDURE [dbo].[sp_AtualizaUPC]')

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

CREATE TABLE [dbo].[tbControloValidacaoStock](
	[IDTipoDocumento] [bigint] NULL,
	[IDDocumento] [bigint] NULL,
	[IDArtigo] [bigint] NULL,
	[IDLoja] [bigint] NULL,
	[IDArmazem] [bigint] NULL,
	[IDArmazemLocalizacao] [bigint] NULL,
	[IDArtigoLote] [bigint] NULL,
	[IDArtigoNumeroSerie] [bigint] NULL,
	[IDArtigoDimensao] [bigint] NULL,
	[CodArtigo] [nvarchar](20) NULL,
	[CodigoDimensao1] [nvarchar](50) NULL,
	[CodigoDimensao2] [nvarchar](50) NULL,
	[LimiteMax] [bit] NOT NULL,
	[LimiteMaxMsgBlq] [bit] NOT NULL,
	[LimiteMin] [bit] NOT NULL,
	[LimiteMinMsgBlq] [bit] NOT NULL,
	[RuturaUnd1] [bit] NOT NULL,
	[RuturaUnd1MsgBlq] [bit] NOT NULL,
	[RuturaUnd2] [bit] NOT NULL,
	[RuturaUnd2MsgBlq] [bit] NOT NULL,
	[UltEmLimiteMax] [float] NULL,
	[UltEmLimiteMin] [float] NULL,
	[UltEmRuturaUnd1] [float] NULL,
	[UltEmRuturaUnd2] [float] NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL
) ON [PRIMARY]


EXEC('CREATE PROCEDURE [dbo].[sp_ValidaStock]  
	@inlngidDocumento AS bigint = NULL,
	@inlngidTipoDocumento AS bigint = NULL,
	@instrTabelaLinhasDist AS nvarchar(250) = '''',
	@instrUtilizador AS nvarchar(256) = '''',
    @inLimitMax as tinyint,--1 ignora, 2 avisa, 3 bloqueia
    @inLimitMin as tinyint,
    @inRutura as tinyint,
	@inLimitMaxDel as tinyint,--1 ignora, 2 avisa, 3 bloqueia
    @inLimitMinDel as tinyint,
    @inRuturaDel as tinyint,
	@instrNaturezaStock AS nvarchar(15)
AS  BEGIN
SET NOCOUNT ON
DECLARE	
	@ErrorMessage AS varchar(2000),
	@ErrorSeverity AS tinyint,
	@ErrorState AS tinyint
	
BEGIN TRY
	IF @inLimitMaxDel > 1 OR @inLimitMinDel > 1 OR @inRuturaDel > 1
	BEGIN
		INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, CodArtigo, CodigoDimensao1, CodigoDimensao2, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	UltEmLimiteMax,	UltEmLimiteMin,	UltEmRuturaUnd1, UltEmRuturaUnd2, Ativo, Sistema, DataCriacao, UtilizadorCriacao)
		SELECT @inlngidTipoDocumento as IDTipoDocumento, @inlngidDocumento as IDDocumento,
		       Art.Codigo as CodArtigo, DimLinhas1.Descricao as CodigoDimensao1, DimLinhas2.Descricao as CodigoDimensao2,
			  CASE WHEN ((Case When @inLimitMaxDel>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) > ROUND(isnull(Art.LimiteMax,0),Und1.NumeroDeCasasDecimais))) THEN 1 ELSE 0 END as LimiteMax,
			  CASE WHEN @inLimitMaxDel = 3 THEN 1 ELSE 0 END LimiteMaxMsgBlq,
			  CASE WHEN ((Case When @inLimitMinDel>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) < ROUND(isnull(Art.LimiteMin,0),Und1.NumeroDeCasasDecimais))) THEN 1 ELSE 0 END as LimiteMin,
			  CASE WHEN @inLimitMinDel = 3 THEN 1 ELSE 0 END LimiteMinMsgBlq,
			  CASE WHEN ((Case When @inRuturaDel>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) < ROUND(0,Und1.NumeroDeCasasDecimais))) THEN 1 ELSE 0 END AS RuturaUnd1,
			  CASE WHEN @inRuturaDel = 3 THEN 1 ELSE 0 END RuturaUnd1MsgBlq,
			  CASE WHEN ((Case When @inRuturaDel>1 then 1 Else 0 END) > 0 AND isnull(TpArt.StkUnidade2,0)<>0 AND (ROUND(isnull(tbQtds.StockAtual2,0),Und2.NumeroDeCasasDecimais) < 0)) THEN 1 ELSE 0 END AS RuturaUnd2,
			  CASE WHEN @inRuturaDel = 3 THEN 1 ELSE 0 END RuturaUnd2MsgBlq,
			  CASE WHEN ((Case When @inLimitMaxDel>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) > ROUND(isnull(Art.LimiteMax,0),Und1.NumeroDeCasasDecimais))) THEN ABS(ROUND(isnull(tbQtds.StockAtual,0) - isnull(Art.LimiteMax,0),Und1.NumeroDeCasasDecimais))  ELSE 0 END as UltEmLimiteMax,
			  CASE WHEN ((Case When @inLimitMinDel>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) < ROUND(isnull(Art.LimiteMin,0),Und1.NumeroDeCasasDecimais))) THEN ABS(ROUND(isnull(Art.LimiteMin,0) - isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais))  ELSE 0 END as UltEmLimiteMin,	
			  CASE WHEN ((Case When @inRuturaDel>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) < ROUND(0,Und1.NumeroDeCasasDecimais))) THEN ABS(ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais)) ELSE 0 END AS UltEmRuturaUnd1, 
			  CASE WHEN ((Case When @inRuturaDel>1 then 1 Else 0 END) > 0 AND isnull(TpArt.StkUnidade2,0)<>0 AND (ROUND(isnull(tbQtds.StockAtual2,0),Und2.NumeroDeCasasDecimais) < 0)) THEN ABS(ROUND(isnull(tbQtds.StockAtual2,0),Und2.NumeroDeCasasDecimais)) ELSE 0 END AS UltEmRuturaUnd2, 
			  1 AS Ativo, 1 AS Sistema, getdate() AS DataCriacao, @instrUtilizador AS UtilizadorCriacao
		 FROM 
		(SELECT CCART.IDArtigo,  
				CCART.IDArtigoDimensao, 
				CCART.IDArmazem, 
				CCART.IDArmazemLocalizacao, 
				CCART.IDArtigoLote, 
				CCART.IDArtigoNumeroSerie,
				CCART.IDLoja,
				SUM(isnull(QuantidadeStock,0)) AS StockAtual, 
				SUM(isnull(QuantidadeStock2,0)) AS StockAtual2 
				FROM 
				(SELECT distinct IDArtigo, IDArtigoDimensao, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDLoja
				 FROM tbControloValidacaoStock  
				 WHERE  IDTipoDocumento = @inlngidTipoDocumento AND IDDocumento = @inlngidDocumento 
				 AND isnull(LimiteMax,0) = 0 AND isnull(LimiteMin,0) = 0 AND isnull(RuturaUnd1,0) = 0 AND isnull(RuturaUnd2,0) = 0
				 ) AS CCART
				 LEFT JOIN tbStockArtigos AS SART
				 ON SART.IDArtigo = CCART.IDArtigo AND isnull(SART.IDArtigoDimensao,0) = isnull(CCART.IDArtigoDimensao,0)
					AND isnull(SART.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND isnull(SART.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0)
					AND isnull(SART.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0) AND isnull(SART.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0)
					AND isnull(SART.IDLoja,0) = isnull(CCART.IDLoja,0)
		 GROUP BY CCART.IDArtigo, CCART.IDArtigoDimensao, CCART.IDArmazem, CCART.IDArmazemLocalizacao, CCART.IDArtigoLote, CCART.IDArtigoNumeroSerie, CCART.IDLoja
		) AS tbQtds
		LEFT JOIN tbArtigos as Art ON Art.ID = tbQtds.IDArtigo
		LEFT JOIN tbTiposArtigos as TpArt ON TpArt.id=Art.IDTipoArtigo
		LEFT JOIN tbUnidades as Und1 ON Und1.ID = Art.IDUnidade
		LEFT JOIN tbUnidades as Und2 ON Und2.ID = Art.IDUnidadeStock2
		LEFT JOIN tbArtigosDimensoes as ArtDim ON (ArtDim.IDArtigo = Art.ID AND isnull(ArtDim.ID,0)=isnull(tbQtds.IDArtigoDimensao,0))
		LEFT JOIN tbDimensoesLinhas as DimLinhas1 ON DimLinhas1.ID = ArtDim.IDDimensaoLinha1
		LEFT JOIN tbDimensoesLinhas as DimLinhas2 ON DimLinhas2.ID = ArtDim.IDDimensaoLinha2
		WHERE ((Case When @inLimitMaxDel>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) > ROUND(isnull(Art.LimiteMax,0),Und1.NumeroDeCasasDecimais))) OR
			  ((Case When @inLimitMinDel>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) < ROUND(isnull(Art.LimiteMin,0),Und1.NumeroDeCasasDecimais))) OR
			  ((Case When @inRuturaDel>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) < ROUND(0,Und1.NumeroDeCasasDecimais))) OR
			  ((Case When @inRuturaDel>1 then 1 Else 0 END) > 0 AND isnull(TpArt.StkUnidade2,0)<>0 AND (ROUND(isnull(tbQtds.StockAtual2,0),Und2.NumeroDeCasasDecimais) < 0)) 
	  
		DELETE FROM tbControloValidacaoStock  
		WHERE  IDTipoDocumento = @inlngidTipoDocumento AND IDDocumento = @inlngidDocumento 
	    AND isnull(LimiteMax,0) = 0 AND isnull(LimiteMin,0) = 0 AND isnull(RuturaUnd1,0) = 0 AND isnull(RuturaUnd2,0) = 0
	END

	IF @inLimitMax > 1 OR @inLimitMin > 1 OR @inRutura > 1
	BEGIN
		INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, CodArtigo, CodigoDimensao1, CodigoDimensao2, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	UltEmLimiteMax,	UltEmLimiteMin,	UltEmRuturaUnd1, UltEmRuturaUnd2, Ativo, Sistema, DataCriacao, UtilizadorCriacao)
		SELECT @inlngidTipoDocumento as IDTipoDocumento, @inlngidDocumento as IDDocumento,
		       Art.Codigo as CodArtigo, DimLinhas1.Descricao as CodigoDimensao1, DimLinhas2.Descricao as CodigoDimensao2,
			  CASE WHEN ((Case When @inLimitMax>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) > ROUND(isnull(Art.LimiteMax,0),Und1.NumeroDeCasasDecimais))) THEN 1 ELSE 0 END as LimiteMax,
			  CASE WHEN @inLimitMax = 3 THEN 1 ELSE 0 END LimiteMaxMsgBlq,
			  CASE WHEN ((Case When @inLimitMin>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) < ROUND(isnull(Art.LimiteMin,0),Und1.NumeroDeCasasDecimais))) THEN 1 ELSE 0 END as LimiteMin,
			  CASE WHEN @inLimitMin = 3 THEN 1 ELSE 0 END LimiteMinMsgBlq,
			  CASE WHEN ((Case When @inRutura>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) < ROUND(0,Und1.NumeroDeCasasDecimais))) THEN 1 ELSE 0 END AS RuturaUnd1,
			  CASE WHEN @inRutura = 3 THEN 1 ELSE 0 END RuturaUnd1MsgBlq,
			  CASE WHEN ((Case When @inRutura>1 then 1 Else 0 END) > 0 AND isnull(TpArt.StkUnidade2,0)<>0 AND (ROUND(isnull(tbQtds.StockAtual2,0),Und2.NumeroDeCasasDecimais) < 0)) THEN 1 ELSE 0 END AS RuturaUnd2,
			  CASE WHEN @inRutura = 3 THEN 1 ELSE 0 END RuturaUnd2MsgBlq,
			  CASE WHEN ((Case When @inLimitMax>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) > ROUND(isnull(Art.LimiteMax,0),Und1.NumeroDeCasasDecimais))) THEN ABS(ROUND(isnull(tbQtds.StockAtual,0) - isnull(Art.LimiteMax,0),Und1.NumeroDeCasasDecimais))  ELSE 0 END as UltEmLimiteMax,
			  CASE WHEN ((Case When @inLimitMin>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) < ROUND(isnull(Art.LimiteMin,0),Und1.NumeroDeCasasDecimais))) THEN ABS(ROUND(isnull(Art.LimiteMin,0) - isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais))  ELSE 0 END as UltEmLimiteMin,	
			  CASE WHEN ((Case When @inRutura>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) < ROUND(0,Und1.NumeroDeCasasDecimais))) THEN ABS(ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais)) ELSE 0 END AS UltEmRuturaUnd1, 
			  CASE WHEN ((Case When @inRutura>1 then 1 Else 0 END) > 0 AND isnull(TpArt.StkUnidade2,0)<>0 AND (ROUND(isnull(tbQtds.StockAtual2,0),Und2.NumeroDeCasasDecimais) < 0)) THEN ABS(ROUND(isnull(tbQtds.StockAtual2,0),Und2.NumeroDeCasasDecimais)) ELSE 0 END AS UltEmRuturaUnd2, 
			  1 AS Ativo, 1 AS Sistema, getdate() AS DataCriacao, @instrUtilizador AS UtilizadorCriacao
		 FROM 
		(SELECT CCART.IDArtigo,  
				CCART.IDArtigoDimensao, 
				CCART.IDArmazem, 
				CCART.IDArmazemLocalizacao, 
				CCART.IDArtigoLote, 
				CCART.IDArtigoNumeroSerie,
				CCART.IDLoja,
				SUM(isnull(QuantidadeStock,0)) AS StockAtual, 
				SUM(isnull(QuantidadeStock2,0)) AS StockAtual2 
				FROM 
				(SELECT distinct IDArtigo, IDArtigoDimensao, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDLoja
				 FROM tbCCStockArtigos  
				 WHERE Natureza=@instrNaturezaStock AND IDTipoDocumento =@inlngidTipoDocumento AND IDDocumento = @inlngidDocumento
				 ) AS CCART
				 LEFT JOIN tbStockArtigos AS SART
				 ON SART.IDArtigo = CCART.IDArtigo AND isnull(SART.IDArtigoDimensao,0) = isnull(CCART.IDArtigoDimensao,0)
					AND isnull(SART.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND isnull(SART.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0)
					AND isnull(SART.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0) AND isnull(SART.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0)
					AND isnull(SART.IDLoja,0) = isnull(CCART.IDLoja,0)
		 GROUP BY CCART.IDArtigo, CCART.IDArtigoDimensao, CCART.IDArmazem, CCART.IDArmazemLocalizacao, CCART.IDArtigoLote, CCART.IDArtigoNumeroSerie, CCART.IDLoja
		) AS tbQtds
		LEFT JOIN tbArtigos as Art ON Art.ID = tbQtds.IDArtigo
		LEFT JOIN tbTiposArtigos as TpArt ON TpArt.id=Art.IDTipoArtigo
		LEFT JOIN tbUnidades as Und1 ON Und1.ID = Art.IDUnidade
		LEFT JOIN tbUnidades as Und2 ON Und2.ID = Art.IDUnidadeStock2
		LEFT JOIN tbArtigosDimensoes as ArtDim ON (ArtDim.IDArtigo = Art.ID AND isnull(ArtDim.ID,0)=isnull(tbQtds.IDArtigoDimensao,0))
		LEFT JOIN tbDimensoesLinhas as DimLinhas1 ON DimLinhas1.ID = ArtDim.IDDimensaoLinha1
		LEFT JOIN tbDimensoesLinhas as DimLinhas2 ON DimLinhas2.ID = ArtDim.IDDimensaoLinha2
		WHERE ((Case When @inLimitMax>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) > ROUND(isnull(Art.LimiteMax,0),Und1.NumeroDeCasasDecimais))) OR
			  ((Case When @inLimitMin>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) < ROUND(isnull(Art.LimiteMin,0),Und1.NumeroDeCasasDecimais))) OR
			  ((Case When @inRutura>1 then 1 Else 0 END) > 0 AND (ROUND(isnull(tbQtds.StockAtual,0),Und1.NumeroDeCasasDecimais) < ROUND(0,Und1.NumeroDeCasasDecimais))) OR
			  ((Case When @inRutura>1 then 1 Else 0 END) > 0 AND isnull(TpArt.StkUnidade2,0)<>0 AND (ROUND(isnull(tbQtds.StockAtual2,0),Und2.NumeroDeCasasDecimais) < 0)) 
	  
	  END
END TRY
BEGIN CATCH
	SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
	RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')


EXEC('DROP PROCEDURE [dbo].[sp_AtualizaStock]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaStock]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0,
	@strTabelaCabecalho AS nvarchar(250) = '''', 
	@strTabelaLinhas AS nvarchar(250) = '''',
	@strTabelaLinhasDist AS nvarchar(250) = '''',
	@strCampoRelTabelaLinhasCab AS nvarchar(100) = '''',
	@strCampoRelTabelaLinhasDistLinhas AS nvarchar(100) = '''',
	@strUtilizador AS nvarchar(256) = '''',
	@inValidaStock AS bit
AS  BEGIN
SET NOCOUNT ON

DECLARE @strSqlQuery AS varchar(max),--variavel para query''s dinamicos
	@strSqlQueryAux AS varchar(max),--variavel para query''s dinamicos
	@strSqlQueryUpdates AS varchar(max),--variavel para query''s dinamicos
	@strSqlQueryInsert AS varchar(max),--varivale para a parte do insert
	@paramList AS nvarchar(max),--variavel para usar quando necessitamos de carregar para as variaveis parametros/colunas comquery''s dinamicas
	@strNatureza AS nvarchar(15) = NULL,
	@strNaturezaStock AS nvarchar(15) = NULL,
	@strNaturezaaux AS nvarchar(15) = NULL,
	@strNaturezaBase AS nvarchar(15) = ''[#F3MNAT#]'',
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
	@strQueryONDist AS nvarchar(1024) = '''',
	@strQueryDocsAtras AS nvarchar(4000) = '''',
	@strQueryDocsAFrente AS nvarchar(4000) = '''',
	@strQueryDocsUpdates AS varchar(max),
	@strQueryDocsUpdatesaux AS varchar(max),
	@strQueryWhereFrente AS nvarchar(1024) = '''',
	@strArmazensCodigo AS nvarchar(100) = ''[#F3M-TRANSF-F3M#]'',
	@strArmazem AS nvarchar(200) = ''Linhas.IDArmazem, Linhas.IDArmazemLocalizacao, '',
	@strArmazensDestino AS nvarchar(200) = ''Linhas.IDArmazemDestino, Linhas.IDArmazemLocalizacaoDestino, '',
	@strTransFControlo AS nvarchar(256) = ''[#F3M-QTDSTRANSF-F3M#]'',
	@strTransFSaida AS nvarchar(1024) = '''',
	@strTransFEntrada AS nvarchar(1024) = '''',
    @strArtigoDimensao AS nvarchar(100) = ''NULL AS IDArtigoDimensao, '',
	@inLimitMax as tinyint,--1 ignora, 2 avisa, 3 bloqueia
    @inLimitMin as tinyint,
    @inRutura as tinyint,
	@inLimitMaxDel as tinyint,--1 ignora, 2 avisa, 3 bloqueia
    @inLimitMinDel as tinyint,
    @inRuturaDel as tinyint,
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
			SELECT @strModulo = M.Codigo,  @strTipoDocInterno = STD.Tipo, @strCodMovStock = TDMS.Codigo,  
			       @inRutura = Cast(AcaoRutura.Codigo as tinyint), @inLimitMax = CAST(AcaoLimiteMax.Codigo as tinyint), @inLimitMin = CAST(AcaoLimiteMin.Codigo AS tinyint)
			FROM tbTiposDocumento TD
			LEFT JOIN tbSistemaModulos M ON M.ID = TD.IDModulo
			LEFT JOIN tbSistemaTiposDocumento STD ON STD.ID = TD.IDSistemaTiposDocumento
			LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TD.IDSistemaTiposDocumentoMovStock
			LEFT JOIN tbSistemaAcoes as AcaoRutura ON AcaoRutura.id=TD.IDSistemaAcoesRupturaStock
			LEFT JOIN tbSistemaAcoes as AcaoLimiteMax ON AcaoLimiteMax.id=TD.IDSistemaAcoesStockMaximo
			LEFT JOIN tbSistemaAcoes as AcaoLimiteMin ON AcaoLimiteMin.id=TD.IDSistemaAcoesStockMinimo
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
				    SET @strNaturezaStock = @strNatureza
				    --apaga registos caso existam da de validação de stock
				    DELETE FROM tbControloValidacaoStock WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
					--atualiza variaveis de validação de stock do apagar e trata de acordo com a natureza as var do adiccionar e alterar
					SET @inRuturaDel = @inRutura
					SET @inLimitMinDel = @inLimitMin
					SET @inLimitMaxDel = @inLimitMax
					IF  @strNatureza = ''E''
						BEGIN
							SET @inRutura = 1--ignora
							SET @inLimitMin = 1--ignora
						END
					IF  @strNatureza = ''S''
						BEGIN
							SET @inLimitMax = 1--ignora
						END
					--verificar se é apagar a acao e atribuir as var do delete e retirar os do insert/update e delete
					IF (@intAccao = 2) 
						BEGIN
						    SET @inRutura = 1--ignora
							SET @inLimitMin = 1--ignora
							SET @inLimitMax = 1--ignora
							IF  @strNatureza = ''E''
								BEGIN
								    SET @inLimitMaxDel = 1--ignora
								
								END
							IF  @strNatureza = ''S''
								BEGIN
							    	SET @inRuturaDel = 1--ignora
									SET @inLimitMinDel = 1--ignora
								END

					    END
					

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
											SET @strQueryONDist = '' AND isnull(CCartigos.IDArtigoDimensao,0)=isnull(LinhaDist.IDArtigoDimensao,0) ''
										END
									ELSE
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' ''
											SET @strQueryWhereDistUpdates = '' ''
											SET @strQueryCamposDistUpdates ='' ''
											SET @strQueryWhereDistUpdates1 = '' '' 
											SET @strQueryCamposDistUpdates1 ='' ''
											SET @strQueryGroupbyDistUpdates = '' ''
											SET @strQueryONDist = '' ''
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
													LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON (Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')''
													+ @strQueryLeftJoinDistUpdates +
													'' LEFT JOIN tbCCStockArtigos AS CCartigos ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo '' + @strQueryONDist + '')	
													WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND Cab.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' AND CCartigos.IDDocumento IS NULL) AS LinhasNovas
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
											SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
											SET @strQueryWhereDistUpdates = '' AND isnull(CCART.IDArtigoDimensao,0) = isnull(Docs.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates =''isnull(CCartigos.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryWhereDistUpdates1 = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Doc.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates1 =''isnull(CCART.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryGroupbyDistUpdates = '', isnull(CCART.IDArtigoDimensao,0)''
											SET @strQueryWhereFrente = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Frente.IDArtigoDimensao,0) ''
											SET @strQueryONDist = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) ''
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
											SET @strQueryONDist = '' ''
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
													AND (Linhas.ID IS NULL '' + @strQueryONDist + '')
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
									--aqui faz os deletes


									IF @inValidaStock<>0
										BEGIN
											SET @strQueryCamposDistUpdates =''CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, '' + @strUtilizador + '' as UtilizadorCriacao ''
								
											IF  len(@strTabelaLinhasDist)>0
												BEGIN
													SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
													SET @strQueryWhereDistUpdates = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) '' 
											
												END
											ELSE
												BEGIN
													SET @strQueryLeftJoinDistUpdates = '' ''
													SET @strQueryWhereDistUpdates = ''''
													
												END
											SET @strQueryDocsUpdates = '' INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, IDArtigo, IDArtigoDimensao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	Ativo, Sistema, DataCriacao, UtilizadorCriacao)   
															SELECT distinct TpDoc.ID AS IDTipoDocumento, CCartigos.IDDocumento AS IDDocumento, CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + ''  FROM  tbCCStockArtigos AS CCartigos
															LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
															'' + @strQueryLeftJoinDistUpdates + ''
															LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
															WHERE '' + @strNaturezaBase + ''  CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' 
															AND (Linhas.ID IS NULL '' + @strQueryWhereDistUpdates + '' )
															AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 ''
											
											IF @strNaturezaStock <> ''[#F3MN#F3M]''
												BEGIN
													 SET @strQueryDocsUpdatesaux = REPLACE(@strQueryDocsUpdates, @strNaturezaBase, '' '')
													 EXEC(@strQueryDocsUpdatesaux)
													 IF Exists(SELECT IDArtigo FROM tbControloValidacaoStock WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento AND isnull(LimiteMax,0) = 0 AND isnull(LimiteMin,0) = 0 AND isnull(RuturaUnd1,0) = 0 AND isnull(RuturaUnd2,0) = 0 )
														BEGIN
															IF  @strNaturezaStock = ''E''
																BEGIN
																	SET @inLimitMaxDel = 1--ignora
								
																END
															IF  @strNaturezaStock = ''S''
																BEGIN
							    									SET @inRuturaDel = 1--ignora
																	SET @inLimitMinDel = 1--ignora
																END

															Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, 1, 1, 1, @inLimitMaxDel, @inLimitMinDel, @inRuturaDel , @strNaturezaStock 
														END
												END
											ELSE
												BEGIN
												     --Entrada
													 SET @strQueryDocsUpdatesaux = REPLACE(@strQueryDocsUpdates, @strNaturezaBase, ''CCartigos.Natureza=''''E'''' AND '')
													 EXEC(@strQueryDocsUpdatesaux)

												      IF Exists(SELECT IDArtigo FROM tbControloValidacaoStock WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento AND isnull(LimiteMax,0) = 0 AND isnull(LimiteMin,0) = 0 AND isnull(RuturaUnd1,0) = 0 AND isnull(RuturaUnd2,0) = 0 )
													  BEGIN
														Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, 1, 1, 1, 1, @inLimitMinDel, @inRuturaDel , ''E''
													  END

													  --saída
													 SET @strQueryDocsUpdatesaux = REPLACE(@strQueryDocsUpdates, @strNaturezaBase, ''CCartigos.Natureza=''''S'''' AND '')
	  												 EXEC(@strQueryDocsUpdatesaux)

												      IF Exists(SELECT IDArtigo FROM tbControloValidacaoStock WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento AND isnull(LimiteMax,0) = 0 AND isnull(LimiteMin,0) = 0 AND isnull(RuturaUnd1,0) = 0 AND isnull(RuturaUnd2,0) = 0 )
													  BEGIN
														Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, 1, 1, 1, @inLimitMaxDel, 1, 1 , ''S'' 
													  END
												END
										END

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
								
								IF  @strNaturezaaux = ''[#F3MN#F3M]''--só existe transferencia para os stocks
									BEGIN
										IF @inValidaStock<>0
											BEGIN
												--entrada
												Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, 1, 1, 1 , 1, 1 , ''E'' 
										
												--saída
												Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, 1, @inLimitMin, @inRutura, 1 , 1, 1 , ''S'' 
											END
									END
								ELSE
									BEGIN
									   IF @inValidaStock<>0
											BEGIN
											   Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, @inLimitMin, @inRutura, 1, 1, 1, @strNaturezaaux 
											END
									END


						END
					ELSE --apagar
						BEGIN
							--3) Linhas que existiam e agora deixaram de existir no documento, para essas, marcar a linha à frente desse artigo para recalcular a partir daí
							---  caso não existe nenhum para à frente não marcar nenhuma
							IF  len(@strTabelaLinhasDist)>0
								BEGIN
									SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
									SET @strQueryWhereDistUpdates = '' AND isnull(CCART.IDArtigoDimensao,0) = isnull(Docs.IDArtigoDimensao,0) '' 
									SET @strQueryCamposDistUpdates =''isnull(CCartigos.IDArtigoDimensao,0) as IDArtigoDimensao, ''
									SET @strQueryWhereDistUpdates1 = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Doc.IDArtigoDimensao,0) '' 
									SET @strQueryCamposDistUpdates1 =''isnull(CCART.IDArtigoDimensao,0) as IDArtigoDimensao, ''
									SET @strQueryGroupbyDistUpdates = '', isnull(CCART.IDArtigoDimensao,0)''
									SET @strQueryWhereFrente = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Frente.IDArtigoDimensao,0) ''
									SET @strQueryONDist = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) ''
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
									SET @strQueryONDist = '' ''
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
											AND (Linhas.ID IS NULL '' + @strQueryONDist + '')
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
							
							IF @inValidaStock<>0
							BEGIN	
							
								IF @strNaturezaStock <> ''[#F3MN#F3M]''
									BEGIN
										INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, IDArtigo, IDArtigoDimensao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	Ativo, Sistema, DataCriacao, UtilizadorCriacao)
										SELECT distinct CCartigos.IDTipoDocumento AS IDTipoDocumento, CCartigos.IDDocumento AS IDDocumento, CCartigos.IDArtigo,
										CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, @strUtilizador as UtilizadorCriacao 
										FROM tbCCStockArtigos  as CCartigos WHERE CCartigos.IDTipoDocumento = @lngidTipoDocumento AND CCartigos.IDDocumento = @lngidDocumento 	
										Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, @inLimitMin, @inRutura, @inLimitMaxDel, @inLimitMinDel, @inRuturaDel , @strNaturezaStock 
									END
								ELSE
									BEGIN
										 SET @inRutura = 1--ignora
										 SET @inLimitMin = 1--ignora
										 SET @inLimitMax = 1--ignora
								 
								        --Entrada
										INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, IDArtigo, IDArtigoDimensao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	Ativo, Sistema, DataCriacao, UtilizadorCriacao)
										SELECT distinct CCartigos.IDTipoDocumento AS IDTipoDocumento, CCartigos.IDDocumento AS IDDocumento, CCartigos.IDArtigo,
										CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, @strUtilizador as UtilizadorCriacao 
										FROM tbCCStockArtigos  as CCartigos WHERE CCartigos.IDTipoDocumento = @lngidTipoDocumento AND CCartigos.IDDocumento = @lngidDocumento AND CCartigos.Natureza = ''E''
										Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, @inLimitMin, @inRutura, 1 , @inLimitMinDel, @inRuturaDel , ''E'' 

										--Saída
										INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, IDArtigo, IDArtigoDimensao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	Ativo, Sistema, DataCriacao, UtilizadorCriacao)
										SELECT distinct CCartigos.IDTipoDocumento AS IDTipoDocumento, CCartigos.IDDocumento AS IDDocumento, CCartigos.IDArtigo,
										CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, @strUtilizador as UtilizadorCriacao 
										FROM tbCCStockArtigos  as CCartigos WHERE CCartigos.IDTipoDocumento = @lngidTipoDocumento AND CCartigos.IDDocumento = @lngidDocumento AND CCartigos.Natureza = ''S''
										Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, @inLimitMin, @inRutura, @inLimitMaxDel, 1, 1 , ''S'' 
									END
							END
							
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

-- Tipos de Documentos
exec('update tbSistemaModulos set TiposDocumentos=1 where id=5')
exec('update [F3MOGeral].dbo.tbSistemaModulos set TiposDocumentos=1 where id=5')
exec('update [F3MOGeral].dbo.tbmenus set ativo=0 where Descricao=''TiposRetencao''')
exec('update [F3MOGeral].dbo.tbmenus set icon=''f3icon-doc-compra'' where descricao=''DocumentosCompras''') 
exec('update tbsistematiposdocumento set ativo=1 where id in (11,12,13)')
exec('UPDATE tbTiposDocumento SET GereStock=1 where IDModulo in (1,3,4)')

INSERT [tbarmazens] ([IDLoja], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, 'ASEDE', 'ASEDE', 0, 1, getdate(), 'F3M' ,null, null) 
INSERT [tbarmazenslocalizacoes] ([IDArmazem], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem]) VALUES (1, 'LSEDE', 'LSEDE', 0, 1, getdate(),'F3M',null, null,1) 

SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal]) VALUES (19, 19, N'DocumentosPagamentosCompras', N'DocumentosPagamentosCompras', N'rptPagamentosCompras', N'\Reporting\Reports\Oticas\DocumentosCompras\', 1, NULL, 1, NULL, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'', 5, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumento] ON 
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento], [Predefinido]) VALUES (14, N''GT'', N''Transferência'', 1, 4, 0, 1, CAST(N''2017-07-27 17:24:04.000'' AS DateTime), N''F3M'', CAST(N''2017-07-27 17:24:14.677'' AS DateTime), N''F3M'', NULL, 46, 1, 0, 0, 0, 1, 0, 0, 1, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1, 4, 13, NULL, NULL, NULL, 1, 1, NULL, 3, 0, 0, 0, 1)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento], [Predefinido]) VALUES (15, N''NL'', N''Nota Liquidação'', 5, 15, 0, 1, CAST(N''2017-08-10 17:08:36.077'' AS DateTime), N''F3M'', NULL, NULL, NULL, 20, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, NULL, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 13, 0, 0, 0, 1)
SET IDENTITY_INSERT [dbo].[tbTiposDocumento] OFF')

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ON 
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (35, 14, 13, 0, 0, CAST(N''2017-07-27 17:24:14.747'' AS DateTime), N''F3M'', CAST(N''2017-07-27 17:24:14.747'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (36, 14, 14, 0, 0, CAST(N''2017-07-27 17:24:14.753'' AS DateTime), N''F3M'', CAST(N''2017-07-27 17:24:14.753'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (37, 15, 9, 0, 0, CAST(N''2017-08-10 17:08:36.330'' AS DateTime), N''F3M'', CAST(N''2017-08-10 17:08:36.330'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (38, 15, 10, 0, 0, CAST(N''2017-08-10 17:08:36.337'' AS DateTime), N''F3M'', CAST(N''2017-08-10 17:08:36.337'' AS DateTime), N''F3M'', 0, 0)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] OFF')

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumentoSeries] ON 
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (14, cast(year(getdate()) as nvarchar(4)) +''GT'', cast(year(getdate()) as nvarchar(4)) +''GT'', 1, 14, 0, 1, CAST(N''2017-07-27 17:24:03.447'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 2, 16)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (15, cast(year(getdate()) as nvarchar(4)) +''NL'', cast(year(getdate()) as nvarchar(4)) +''NL'', 1, 15, 0, 1, CAST(N''2017-08-10 17:08:36.170'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 19)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoSeries] OFF')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] WHERE [IDPerfis]=1 and [IDMenusAreasEmpresa] in (14,15))
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ([IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES ( 1, 7, 14, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:26:30.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ([IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES ( 1, 7, 15, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:27:59.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
END')

--notas de crédito de compras
EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumento] ON 
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento], [Predefinido]) VALUES (16, N''NCC'', N''Nota de Crédito de Compra'', 3, 10, 0, 1, CAST(N''2017-07-27 17:24:04.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, 9, 1, 1, 0, 0, 1, 0, 0, 0, 0, 2, 3, 0, 0, 0, 0, 0, 0, 0, 1, 2, 12, NULL, NULL, NULL, 1, 1, NULL, 13, 0, 1, 0, 1)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento], [Predefinido]) VALUES (17, N''GTC'', N''Guia de Transporte de Compra'', 3, 9, 0, 1, CAST(N''2017-07-27 17:24:04.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, 2, 1, 1, 0, 0, 1, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1, 2, 12, NULL, NULL, NULL, 1, 1, NULL, 12, 0, 1, 0, 1)
INSERT [dbo].[tbTiposDocumento] ([ID], [Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento], [Predefinido]) VALUES (18, N''GRC'', N''Guia de Remessa de Compra'', 3, 9, 0, 1, CAST(N''2017-07-27 17:24:04.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1, 2, 12, NULL, NULL, NULL, 1, 1, NULL, 12, 0, 1, 0, 1)
SET IDENTITY_INSERT [dbo].[tbTiposDocumento] OFF')

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ON 
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (39, 16, 1, 0, 0, CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', 39, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (40, 16, 2, 0, 0, CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', 40, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (41, 16, 3, 0, 0, CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', 41, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (42, 16, 4, 0, 0, CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', 42, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (44, 17, 1, 0, 0, CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', 44, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (45, 17, 2, 0, 0, CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', 45, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (46, 17, 3, 0, 0, CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', 46, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (47, 17, 4, 0, 0, CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', 47, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (48, 18, 1, 0, 0, CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', 48, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (49, 18, 2, 0, 0, CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', 49, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (50, 18, 3, 0, 0, CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', 50, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (51, 18, 4, 0, 0, CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.430'' AS DateTime), N''F3M'', 51, 0)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] OFF')

EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumentoSeries] ON 
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (16, right(year(getdate()),2) + ''NCC'', right(year(getdate()),2) + ''NCC'', 1, 16, 0, 1, CAST(N''2017-07-27 17:24:03.447'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 17)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (17, right(year(getdate()),2) + ''GTC'', right(year(getdate()),2) + ''GTC'', 1, 17, 0, 1, CAST(N''2017-07-27 17:24:03.447'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 17)
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (18, right(year(getdate()),2) + ''GRC'', right(year(getdate()),2) + ''GRC'', 1, 18, 0, 1, CAST(N''2017-07-27 17:24:03.447'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 17)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoSeries] OFF')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] WHERE [IDPerfis]=1 and [IDMenusAreasEmpresa] in (16,17,18))
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 16, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:26:30.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 17, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:26:30.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ( [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, 18, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:26:30.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
END')


INSERT [dbo].[tbSistemaEntidadesEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (5, N'DPC', N'DocumentosPagamentosCompras', 1, 1, CAST(N'2016-03-09 12:52:02.557' AS DateTime), N'f3m', NULL, NULL)

INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (13, N'EFT', N'Efetivo', 1, 1, CAST(N'2016-07-06 00:00:00.000' AS DateTime), N'F3M', NULL, NULL, 5, N'est-final')
INSERT [dbo].[tbSistemaTiposEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [Cor]) VALUES (14, N'ANL', N'Anulado', 1, 1, CAST(N'2016-07-06 00:00:00.000' AS DateTime), N'F3M', NULL, NULL, 5, N'est-final')	

SET IDENTITY_INSERT [dbo].[tbEstados] ON 
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (13, N'P1', N'Efetivo', 1, 1, CAST(N'2016-07-13 05:00:33.000' AS DateTime), N'f3m', CAST(N'2016-07-13 17:00:40.757' AS DateTime), N'f3m', 5, 13, 1, 1)
INSERT [dbo].[tbEstados] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDEntidadeEstado], [IDTipoEstado], [Predefinido], [EstadoInicial]) VALUES (14, N'P2', N'Anulado', 1, 1, CAST(N'2016-07-13 05:00:33.000' AS DateTime), N'f3m', CAST(N'2016-07-13 17:00:40.757' AS DateTime), N'f3m', 5, 14, 0, 0)
SET IDENTITY_INSERT [dbo].[tbEstados] OFF

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] WHERE ID in (6,7,8,9))
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] ON 
INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] ([ID], [IDMenu], [IDUtilizador], [Ordem], [Descricao], [Icon], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (6, 106, 1, 6, NULL, NULL, 0, 0, CAST(N''2017-03-31 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] ([ID], [IDMenu], [IDUtilizador], [Ordem], [Descricao], [Icon], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (7, 108, 1, 7, NULL, NULL, 0, 0, CAST(N''2017-03-31 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] ([ID], [IDMenu], [IDUtilizador], [Ordem], [Descricao], [Icon], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (8, 113, 1, 8, NULL, NULL, 0, 0, CAST(N''2017-03-31 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] ([ID], [IDMenu], [IDUtilizador], [Ordem], [Descricao], [Icon], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (9, 114, 1, 9, NULL, NULL, 0, 0, CAST(N''2017-03-31 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenusAtalhosRapidos] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Fornecedores'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDCateg as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
SELECT @IDCateg = ID  FROM [F3MOGeral].[dbo].[tbSistemaCategListasPers] WHERE Descricao=''Fornecedores''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Conta Corrente de Fornecedores'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbCCFornecedores'', 
N''select IDLoja, Natureza,  IDEntidade, NomeFiscal, NumeroDocumento, DataDocumento, Descricao, TotalMoeda, Ativo from tbCCFornecedores'', @IDCateg, 2)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada IN (SELECT ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Fornecedores''))
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Fornecedores''
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Descricao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TotalMoeda'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
END')


EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] WHERE IDListaPersonalizada IN (SELECT ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Fornecedores''))
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Fornecedores''
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''Ativo'', 0, N''Ativo'', N''True'', N'''', 35, N'''', 1, CAST(N''2017-06-19 16:47:10.370'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.370'' AS DateTime), N''1'')
END')


EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwCCArtigos''))
BEGIN
EXECUTE(''ALTER view vwCCArtigos as
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
tbArtigosLotes.Codigo as CodigoLote,
tbArtigosLotes.Descricao as DescricaoLote,
tbDimensoesLinhas.Descricao as DescricaoDimensaoLinha1,
tbDimensoesLinhas1.Descricao as DescricaoDimensaoLinha2,
(case when tbCCStockArtigos.Natureza=''''E'''' then ''''Entrada'''' else ''''Saida'''' end) as Natureza,
tbCCStockArtigos.QtdStockAtual,
tbCCStockArtigos.QtdStockAnterior,
tbCCStockArtigos.PCMAtualMoedaRef,
tbCCStockArtigos.PCMAnteriorMoedaRef,
(case when tbCCStockArtigos.Natureza=''''E'''' then tbCCStockArtigos.QuantidadeStock else -(tbCCStockArtigos.QuantidadeStock) end) as QtdLinhaStock,
Round(isnull((
select Sum((Case tbCCStockAgreg.Natureza when ''''E'''' then 1 else -1 end) * tbCCStockAgreg.QuantidadeStock) FROM tbCCStockArtigos as tbCCStockAgreg
WHERE tbCCStockAgreg.IDartigo = tbCCStockArtigos.IDartigo
and   isnull(tbCCStockAgreg.IDArtigoDimensao,0) = isnull(tbCCStockArtigos.IDArtigoDimensao,0)   
and   isnull(tbCCStockAgreg.IDArmazem,0) = isnull(tbCCStockArtigos.IDArmazem,0)   
and   isnull(tbCCStockAgreg.IDArmazemLocalizacao,0) = isnull(tbCCStockArtigos.IDArmazemLocalizacao,0)   
AND (tbCCStockAgreg.Natureza =''''E'''' OR tbCCStockAgreg.Natureza =''''S'''')
AND tbCCStockAgreg.DataControloInterno <= tbCCStockArtigos.DataControloInterno
AND ((tbCCStockAgreg.IDTipoDocumento<>tbCCStockArtigos.IDTipoDocumento OR tbCCStockAgreg.IDDocumento <> tbCCStockArtigos.IDDocumento
       ) OR (tbCCStockAgreg.IDTipoDocumento = tbCCStockArtigos.IDTipoDocumento AND tbCCStockAgreg.IDDocumento = tbCCStockArtigos.IDDocumento
                     AND tbCCStockAgreg.ID<=tbCCStockArtigos.ID
                     )
       )
),0),isnull(tbUnidades.NumeroDeCasasDecimais,0)) as QuantidadeStock,
tbCCStockArtigos.QuantidadeStock2 as QtdLinhaStock2,
Round(isnull((
select Sum((Case tbCCStockAgreg.Natureza when ''''E'''' then 1 else -1 end) * tbCCStockAgreg.QuantidadeStock2) FROM tbCCStockArtigos as tbCCStockAgreg
WHERE tbCCStockAgreg.IDartigo = tbCCStockArtigos.IDartigo
and   isnull(tbCCStockAgreg.IDArtigoDimensao,0) = isnull(tbCCStockArtigos.IDArtigoDimensao,0)   
and   isnull(tbCCStockAgreg.IDArmazem,0) = isnull(tbCCStockArtigos.IDArmazem,0)   
and   isnull(tbCCStockAgreg.IDArmazemLocalizacao,0) = isnull(tbCCStockArtigos.IDArmazemLocalizacao,0)   
AND (tbCCStockAgreg.Natureza =''''E'''' OR tbCCStockAgreg.Natureza =''''S'''')
AND tbCCStockAgreg.DataControloInterno <= tbCCStockArtigos.DataControloInterno 
AND ((tbCCStockAgreg.IDTipoDocumento<>tbCCStockArtigos.IDTipoDocumento OR tbCCStockAgreg.IDDocumento <> tbCCStockArtigos.IDDocumento
       ) OR (tbCCStockAgreg.IDTipoDocumento = tbCCStockArtigos.IDTipoDocumento AND tbCCStockAgreg.IDDocumento = tbCCStockArtigos.IDDocumento
                     AND tbCCStockAgreg.ID<=tbCCStockArtigos.ID
                     )
       )
),0),isnull(tbUnidades2.NumeroDeCasasDecimais,0)) as QuantidadeStock2,
tbCCStockArtigos.PrecoUnitarioEfetivoMoedaRef as PrecoUnitarioMoedaRef,
isnull(tbCCStockArtigos.Recalcular,0) as RecalcularCustoMedio,
tbCCStockArtigos.DataControloInterno 
FROM tbCCStockArtigos AS tbCCStockArtigos
LEFT JOIN tbArtigos AS tbArtigos ON tbArtigos.id=tbCCStockArtigos.IDArtigo
LEFT JOIN tbUnidades as tbUnidades ON tbUnidades.ID=tbArtigos.IDUnidade
LEFT JOIN tbUnidades as tbUnidades2 ON tbUnidades2.ID=tbArtigos.IDUnidadeStock2
LEFT JOIN tbArtigosDimensoes AS tbArtigosDimensoes ON (tbArtigosDimensoes.ID = tbCCStockArtigos.IDArtigoDimensao and tbArtigosDimensoes.IDArtigo=tbArtigos.ID) 
LEFT JOIN tbDimensoesLinhas AS tbDimensoesLinhas ON tbDimensoesLinhas.ID = tbArtigosDimensoes.IDDimensaoLinha1
LEFT JOIN tbDimensoesLinhas AS tbDimensoesLinhas1 ON tbDimensoesLinhas1.ID = tbArtigosDimensoes.IDDimensaoLinha2
LEFT JOIN tbArmazens AS tbArmazens ON tbArmazens.ID = tbCCStockArtigos.IDArmazem
LEFT JOIN tbArmazensLocalizacoes AS tbArmazensLocalizacoes ON (tbArmazensLocalizacoes.IDArmazem =tbArmazens.ID and tbArmazensLocalizacoes.ID = tbCCStockArtigos.IDArmazemLocalizacao)
LEFT JOIN tbTiposDocumento AS tbTiposDocumento ON tbTiposDocumento.ID=tbCCStockArtigos.IDTipoDocumento
LEFT JOIN tbTiposDocumento AS tbTiposDocumentoOrigem ON tbTiposDocumentoOrigem.ID=tbCCStockArtigos.IDTipoDocumentoOrigem
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries ON tbTiposDocumentoSeries.ID=tbCCStockArtigos.IDTiposDocumentoSeries
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeriesOrigem ON tbTiposDocumentoSeriesOrigem.ID=tbCCStockArtigos.IDTiposDocumentoSeriesOrigem
LEFT JOIN tbArtigosLotes AS tbArtigosLotes ON tbArtigosLotes.ID = tbCCStockArtigos.IDArtigoLote
ORDER BY DataControloInterno, tbCCStockArtigos.ID  OFFSET 0 ROWS 
'')
END')
        
EXEC('IF NOT EXISTS(SELECT top 1 LstCol.ID FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] as LstCol
LEFT JOIN [F3MOGeral].[dbo].[tbListasPersonalizadas] as lst ON LstCol.IDListaPersonalizada = lst.ID
WHERE lst.Descricao=''Conta Corrente de Artigos'' and LstCol.ColunaVista=''QtdLinhaStock'')
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Artigos''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where ColunaVista=''Nat'' and IDListaPersonalizada=@IDLista
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where ColunaVista=''QuantidadeStock'' and IDListaPersonalizada=@IDLista
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where ColunaVista=''QuantidadeStock2'' and IDListaPersonalizada=@IDLista
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where ColunaVista=''QtdStockAtual'' and IDListaPersonalizada=@IDLista
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where ColunaVista=''QtdStockAnterior'' and IDListaPersonalizada=@IDLista
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where ColunaVista=''PCMAtualMoedaRef'' and IDListaPersonalizada=@IDLista
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where ColunaVista=''PCMAnteriorMoedaRef'' and IDListaPersonalizada=@IDLista
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where ColunaVista=''PrecoUnitarioMoedaRef'' and IDListaPersonalizada=@IDLista
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where ColunaVista=''RecalcularCustoMedio'' and IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Nat'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QtdLinhaStock'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QuantidadeStock'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QtdLinhaStock2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QuantidadeStock2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QtdStockAtual'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QtdStockAnterior'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PCMAtualMoedaRef'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PCMAnteriorMoedaRef'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PrecoUnitarioMoedaRef'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''RecalcularCustoMedio'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 100)
END')


EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaCCFornecedores]  
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

				SET @strSqlQuery=''DELETE FROM tbCCFornecedores where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)

				SET @strSqlQueryInsert = ''insert into tbCCFornecedores ([Natureza], [IDLoja], [IDTipoEntidade],[IDEntidade],[NomeFiscal],[IDTipoDocumento],[IDTipoDocumentoSeries],[IDDocumento],[NumeroDocumento],
										[DataDocumento],[Descricao], [IDMoeda], [TotalMoeda],[TotalMoedaReferencia],[TaxaConversao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao])''
								
				SELECT @strSqlQuery = @strSqlQueryInsert + '' select (case when (TD.Adiantamento=1 and TSN.Codigo=''''R'''') then ''''P'''' when (TD.Adiantamento=1 and TSN.Codigo=''''P'''') then ''''R'''' else TSN.Codigo end) as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbdocumentoscompras DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)

				SELECT @strSqlQuery = @strSqlQueryInsert + '' select TSN.Codigo as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbpagamentoscompras DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
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

				SET @strSqlQuery=''DELETE FROM tbCCFornecedores where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)
			END

		  UPDATE tbfornecedores set saldo=tbcc.saldo FROM tbfornecedores Cli
			   INNER JOIN (
			   select identidade, isnull(sum(case when natureza=''R'' then totalmoedareferencia else -totalmoedareferencia end ),0) as saldo from tbCCFornecedores where identidade=@lngidEntidade group by IDEntidade) tbcc
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

CREATE TABLE [dbo].[tbSistemaTiposDocumentoImportacao](
	[ID] [bigint] NOT NULL,
	[TipoFiscal] [nvarchar](50) NOT NULL,
	[TipoDocSist] [nvarchar](50) NOT NULL,
	[Natureza] [nvarchar](50) NULL,
	[TipoFiscalOrigem] [nvarchar](50) NULL,
	[TipoDocSistOrigem] [nvarchar](50) NOT NULL,
	[NaturezaOrigem] [nvarchar](50) NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTiposDocumentoImportacao] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


--REGRAS IMPORTACAO DOCUMENTOS
-----MODULO Compras-----
---------------TIPO DOC Orçamento ---------------
---------------TIPO DOC Encomenda ---------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (1, N'EC', N'CmpEncomenda',  NULL, NULL, N'CmpOrcamento', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
---------------TIPO DOC Transporte ---------------
-------------------------TIPO FISCAL Transporte -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (2, N'GT', N'CmpTransporte',  NULL, NULL, N'CmpOrcamento', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (3, N'GT', N'CmpTransporte',  NULL, NULL, N'CmpEncomenda', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (4, N'GT', N'CmpTransporte',  N'R', N'GT', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (5, N'GT', N'CmpTransporte',  N'P', N'GT', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (6, N'GT', N'CmpTransporte',  N'R', N'GR', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (7, N'GT', N'CmpTransporte',  N'P', N'GR', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (8, N'GT', N'CmpTransporte',  N'P', N'FT', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (9, N'GT', N'CmpTransporte',  N'P', N'FS', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (10, N'GT', N'CmpTransporte',  N'P', N'FR', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (11, N'GT', N'CmpTransporte',  N'R', N'GD', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
-------------------------TIPO FISCAL Remessa -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (12, N'GR', N'CmpTransporte',  NULL, NULL, N'CmpOrcamento', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (13, N'GR', N'CmpTransporte',  NULL, NULL, N'CmpEncomenda', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (14, N'GR', N'CmpTransporte',  N'P', N'GT', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (15, N'GR', N'CmpTransporte',  N'R', N'GT', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (16, N'GR', N'CmpTransporte',  N'P', N'GR', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (17, N'GR', N'CmpTransporte',  N'R', N'GR', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (18, N'GR', N'CmpTransporte',  N'P', N'FT', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (19, N'GR', N'CmpTransporte',  N'P', N'FS', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (20, N'GR', N'CmpTransporte',  N'P', N'FR', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (21, N'GR', N'CmpTransporte',  N'R', N'GD', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
------------------------- TIPO FISCAL Devolução -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (22, N'GD', N'CmpTransporte',  N'P', N'GT', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (23, N'GD', N'CmpTransporte',  N'R', N'GT', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (24, N'GD', N'CmpTransporte',  N'P', N'GR', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (25, N'GD', N'CmpTransporte',  N'R', N'GR', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (26, N'GD', N'CmpTransporte',  NULL, N'FT', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (27, N'GD', N'CmpTransporte',  NULL, N'FR', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (28, N'GD', N'CmpTransporte',  NULL, N'FS', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
---------------TIPO DOC Financeiro ---------------
------------------------- TIPO FISCAL Fatura -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (29, N'FT', N'CmpFinanceiro',  NULL, NULL, N'CmpOrcamento', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (30, N'FT', N'CmpFinanceiro',  NULL, NULL, N'CmpEncomenda', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (31, N'FT', N'CmpFinanceiro',  N'P', N'GT', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (32, N'FT', N'CmpFinanceiro',  N'R', N'GT', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (33, N'FT', N'CmpFinanceiro',  N'P', N'GR', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (34, N'FT', N'CmpFinanceiro',  N'R', N'GR', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (35, N'FT', N'CmpFinanceiro',  NULL, N'GD', N'CmpTransporte', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
------------------------- TIPO FISCAL Fatura-Recibo -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (36, N'FR', N'CmpFinanceiro',  NULL, NULL, N'CmpOrcamento', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (37, N'FR', N'CmpFinanceiro',  NULL, NULL, N'CmpEncomenda', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (38, N'FR', N'CmpFinanceiro',  N'P', N'GT', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (39, N'FR', N'CmpFinanceiro',  N'R', N'GT', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (40, N'FR', N'CmpFinanceiro',  N'P', N'GR', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (41, N'FR', N'CmpFinanceiro',  N'R', N'GR', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (42, N'FR', N'CmpFinanceiro',  NULL, N'GD', N'CmpTransporte', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
------------------------- TIPO FISCAL Fatura Simplificada -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (43, N'FS', N'CmpFinanceiro',  NULL, NULL, N'CmpOrcamento', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (44, N'FS', N'CmpFinanceiro',  NULL, NULL, N'CmpEncomenda', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (45, N'FS', N'CmpFinanceiro',  N'P', N'GT', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (46, N'FS', N'CmpFinanceiro',  N'R', N'GT', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (47, N'FS', N'CmpFinanceiro',  N'P', N'GR', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (48, N'FS', N'CmpFinanceiro',  N'R', N'GR', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (49, N'FS', N'CmpFinanceiro',  NULL, N'GD', N'CmpTransporte', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
------------------------- TIPO FISCAL Nota Débito -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (50, N'ND', N'CmpFinanceiro',  NULL, N'FT', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (51, N'ND', N'CmpFinanceiro',  NULL, N'FR', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (52, N'ND', N'CmpFinanceiro',  NULL, N'FS', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (53, N'ND', N'CmpFinanceiro',  NULL, N'NC', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
------------------------- TIPO FISCAL Nota Crédito -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (54, N'NC', N'CmpFinanceiro',  NULL, N'FT', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (55, N'NC', N'CmpFinanceiro',  NULL, N'FR', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (56, N'NC', N'CmpFinanceiro',  NULL, N'FS', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (57, N'NC', N'CmpFinanceiro',  NULL, N'NC', N'CmpFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (58, N'NC', N'CmpFinanceiro',  N'P', N'GT', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (59, N'NC', N'CmpFinanceiro',  N'R', N'GT', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (60, N'NC', N'CmpFinanceiro',  N'P', N'GR', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (61, N'NC', N'CmpFinanceiro',  N'R', N'GR', N'CmpTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (62, N'NC', N'CmpFinanceiro',  NULL, N'GD', N'CmpTransporte', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)



-----MODULO Vendas----- Conforme compras considerando a inversão das naturezas (Nota MJS: Onde tem "compra" fica "venda" e onde tem "a receber" fica "a pagar")
---------------TIPO DOC Orçamento ---------------
---------------TIPO DOC Encomenda ---------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (63, N'EV', N'VndEncomenda',  NULL, NULL, N'VndOrcamento', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
---------------TIPO DOC Transporte ---------------
-------------------------TIPO FISCAL Transporte -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (64, N'GT', N'VndTransporte',  NULL, NULL, N'VndOrcamento', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (65, N'GT', N'VndTransporte',  NULL, NULL, N'VndEncomenda', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (66, N'GT', N'VndTransporte',  N'R', N'GT', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (67, N'GT', N'VndTransporte',  N'P', N'GT', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (68, N'GT', N'VndTransporte',  N'R', N'GR', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (69, N'GT', N'VndTransporte',  N'P', N'GR', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (70, N'GT', N'VndTransporte',  N'P', N'FT', N'VndTransporte', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (71, N'GT', N'VndTransporte',  N'P', N'FS', N'VndTransporte', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (72, N'GT', N'VndTransporte',  N'P', N'FR', N'VndTransporte', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (73, N'GT', N'VndTransporte',  N'R', N'GD', N'VndTransporte', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
-------------------------TIPO FISCAL Remessa -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (74, N'GR', N'VndTransporte',  NULL, NULL, N'VndOrcamento', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (75, N'GR', N'VndTransporte',  NULL, NULL, N'VndEncomenda', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (76, N'GR', N'VndTransporte',  N'P', N'GT', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (77, N'GR', N'VndTransporte',  N'R', N'GT', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (78, N'GR', N'VndTransporte',  N'P', N'GR', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (79, N'GR', N'VndTransporte',  N'R', N'GR', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (80, N'GR', N'VndTransporte',  N'P', N'FT', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (81, N'GR', N'VndTransporte',  N'P', N'FS', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (82, N'GR', N'VndTransporte',  N'P', N'FR', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (83, N'GR', N'VndTransporte',  N'R', N'GD', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
------------------------- TIPO FISCAL Devolução -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (84, N'GD', N'VndTransporte',  N'P', N'GT', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (85, N'GD', N'VndTransporte',  N'R', N'GT', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (86, N'GD', N'VndTransporte',  N'P', N'GR', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (87, N'GD', N'VndTransporte',  N'R', N'GR', N'CmpTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (88, N'GD', N'VndTransporte',  NULL, N'FT', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (89, N'GD', N'VndTransporte',  NULL, N'FR', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (90, N'GD', N'VndTransporte',  NULL, N'FS', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
---------------TIPO DOC Financeiro ---------------
------------------------- TIPO FISCAL Fatura -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (91, N'FT', N'VndFinanceiro',  NULL, NULL, N'VndOrcamento', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (92, N'FT', N'VndFinanceiro',  NULL, NULL, N'VndEncomenda', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (93, N'FT', N'VndFinanceiro',  N'P', N'GT', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (94, N'FT', N'VndFinanceiro',  N'R', N'GT', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (95, N'FT', N'VndFinanceiro',  N'P', N'GR', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (96, N'FT', N'VndFinanceiro',  N'R', N'GR', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (97, N'FT', N'VndFinanceiro',  NULL, N'GD', N'VndTransporte', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
------------------------- TIPO FISCAL Fatura-Recibo -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (98, N'FR', N'VndFinanceiro',  NULL, NULL, N'VndOrcamento', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (99, N'FR', N'VndFinanceiro',  NULL, NULL, N'VndEncomenda', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (100, N'FR', N'VndFinanceiro',  N'P', N'GT', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (101, N'FR', N'VndFinanceiro',  N'R', N'GT', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (102, N'FR', N'VndFinanceiro',  N'P', N'GR', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (103, N'FR', N'VndFinanceiro',  N'R', N'GR', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (104, N'FR', N'VndFinanceiro',  NULL, N'GD', N'VndTransporte', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
------------------------- TIPO FISCAL Fatura Simplificada -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (105, N'FS', N'VndFinanceiro',  NULL, NULL, N'VndOrcamento', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (106, N'FS', N'VndFinanceiro',  NULL, NULL, N'VndEncomenda', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (107, N'FS', N'VndFinanceiro',  N'P', N'GT', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (108, N'FS', N'VndFinanceiro',  N'R', N'GT', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (109, N'FS', N'VndFinanceiro',  N'P', N'GR', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (110, N'FS', N'VndFinanceiro',  N'R', N'GR', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (111, N'FS', N'VndFinanceiro',  NULL, N'GD', N'VndTransporte', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
------------------------- TIPO FISCAL Nota Débito -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (112, N'ND', N'VndFinanceiro',  NULL, N'FT', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (113, N'ND', N'VndFinanceiro',  NULL, N'FR', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (114, N'ND', N'VndFinanceiro',  NULL, N'FS', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (115, N'ND', N'VndFinanceiro',  NULL, N'NC', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
------------------------- TIPO FISCAL Nota Crédito -------------------------
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (116, N'NC', N'VndFinanceiro',  NULL, N'FT', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (117, N'NC', N'VndFinanceiro',  NULL, N'FR', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (118, N'NC', N'VndFinanceiro',  NULL, N'FS', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (119, N'NC', N'VndFinanceiro',  NULL, N'NC', N'VndFinanceiro', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (120, N'NC', N'VndFinanceiro',  N'P', N'GT', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (121, N'NC', N'VndFinanceiro',  N'R', N'GT', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (122, N'NC', N'VndFinanceiro',  N'P', N'GR', N'VndTransporte', N'P', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (123, N'NC', N'VndFinanceiro',  N'R', N'GR', N'VndTransporte', N'R', 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)
INSERT [dbo].[tbSistemaTiposDocumentoImportacao] ([ID], [TipoFiscal], [TipoDocSist], [Natureza], [TipoFiscalOrigem], [TipoDocSistOrigem], [NaturezaOrigem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (124, N'NC', N'VndFinanceiro',  NULL, N'GD', N'VndTransporte', NULL, 1, 1, CAST(N'2017-01-01 00:00:00.000' AS DateTime), N'F3M', NULL, NULL)