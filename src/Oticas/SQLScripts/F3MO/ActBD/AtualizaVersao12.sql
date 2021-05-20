/* ACT BD EMPRESA VERSAO 12*/

--novos campos 
exec('ALTER TABLE tbTiposDocumento ADD IDTipoDocReserva bigint null')
exec('ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbTiposDocumento1] FOREIGN KEY([IDTipoDocReserva])
REFERENCES [dbo].[tbTiposDocumento] ([ID])
ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbTiposDocumento1]')

exec('ALTER TABLE tbTiposDocumento ADD IDTipoDocLibertaReserva bigint null')
exec('ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbTiposDocumento2] FOREIGN KEY([IDTipoDocLibertaReserva])
REFERENCES [dbo].[tbTiposDocumento] ([ID])
ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbTiposDocumento2]')

exec('ALTER TABLE tbDocumentosComprasLinhas ADD IDTipoDocumentoOrigemInicial bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbTiposDocumentoOrigemInicial] FOREIGN KEY([IDTipoDocumentoOrigemInicial])
REFERENCES [dbo].[tbTiposDocumento] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbTiposDocumentoOrigemInicial]')
exec('ALTER TABLE tbDocumentosComprasLinhas ADD IDDocumentoOrigemInicial bigint null')
exec('ALTER TABLE tbDocumentosComprasLinhas ADD IDLinhaDocumentoOrigemInicial bigint null')
exec('ALTER TABLE tbDocumentosComprasLinhas ADD DocumentoOrigemInicial nvarchar(255) null')

exec('ALTER TABLE tbDocumentosComprasLinhas ADD IDLinhaDocumentoStockInicial bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbDocumentosStockLinhasInicial] FOREIGN KEY([IDLinhaDocumentoStockInicial])
REFERENCES [dbo].[tbDocumentosStockLinhas] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbDocumentosStockLinhasInicial]')

exec('ALTER TABLE tbDocumentosComprasLinhas ADD IDLinhaDocumentoCompraInicial bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbDocumentosComprasLinhasInicial] FOREIGN KEY([IDLinhaDocumentoCompraInicial])
REFERENCES [dbo].[tbDocumentosComprasLinhas] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasLinhas] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhas_tbDocumentosComprasLinhasInicial]')

exec('ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD IDLinhaDimensaoDocumentoCompraInicial bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosComprasLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhasDimensoes_tbDocumentosComprasLinhasDimensoesInicial] FOREIGN KEY([IDLinhaDimensaoDocumentoCompraInicial])
REFERENCES [dbo].[tbDocumentosComprasLinhasDimensoes] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhasDimensoes_tbDocumentosComprasLinhasDimensoesInicial]')
exec('ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD IDLinhaDimensaoDocumentoStockInicial bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosComprasLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhasDimensoes_tbDocumentosStockLinhasDimensoesInicial] FOREIGN KEY([IDLinhaDimensaoDocumentoStockInicial])
REFERENCES [dbo].[tbDocumentosStockLinhasDimensoes] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhasDimensoes_tbDocumentosStockLinhasDimensoesInicial]')

exec('ALTER TABLE tbDocumentosStockLinhas ADD IDTipoDocumentoOrigemInicial bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbTiposDocumentoOrigemInicial] FOREIGN KEY([IDTipoDocumentoOrigemInicial])
REFERENCES [dbo].[tbTiposDocumento] ([ID])
ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbTiposDocumentoOrigemInicial]')
exec('ALTER TABLE tbDocumentosStockLinhas ADD IDDocumentoOrigemInicial bigint null')
exec('ALTER TABLE tbDocumentosStockLinhas ADD IDLinhaDocumentoOrigemInicial bigint null')
exec('ALTER TABLE tbDocumentosStockLinhas ADD DocumentoOrigemInicial nvarchar(255) null')

exec('ALTER TABLE tbDocumentosStockLinhas ADD IDLinhaDocumentoStockInicial bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbDocumentosStockLinhasInicial] FOREIGN KEY([IDLinhaDocumentoStockInicial])
REFERENCES [dbo].[tbDocumentosStockLinhas] ([ID])
ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbDocumentosStockLinhasInicial]')

exec('ALTER TABLE tbDocumentosStockLinhasDimensoes ADD IDLinhaDimensaoDocumentoStockInicial bigint null')

exec('ALTER TABLE [dbo].[tbDocumentosStockLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhasDimensoes_tbDocumentosStockLinhasDimensoesInicial] FOREIGN KEY([IDLinhaDimensaoDocumentoStockInicial])
REFERENCES [dbo].[tbDocumentosStockLinhasDimensoes] ([ID])
ALTER TABLE [dbo].[tbDocumentosStockLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosStockLinhasDimensoes_tbDocumentosStockLinhasDimensoesInicial]')

exec('ALTER TABLE tbArtigosStock add StockReqPendente float null')
exec('ALTER TABLE tbArtigosStock add StockReqPendente2Uni float null')
exec('ALTER TABLE tbArtigosDimensoes add QtdPendenteCompras2 float null')

exec('ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD IDLinhaDimensaoDocumentoCompra bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosComprasLinhasDimensoes] WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhasDimensoes_tbDocumentosComprasLinhasDimensoes] FOREIGN KEY([IDLinhaDimensaoDocumentoCompra])
REFERENCES [dbo].[tbDocumentosComprasLinhasDimensoes] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhasDimensoes_tbDocumentosComprasLinhasDimensoes]')
exec('ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD IDLinhaDimensaoDocumentoStock bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosComprasLinhasDimensoes] WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhasDimensoes_tbDocumentosStockLinhasDimensoes] FOREIGN KEY([IDLinhaDimensaoDocumentoStock])
REFERENCES [dbo].[tbDocumentosStockLinhasDimensoes] ([ID])
ALTER TABLE [dbo].[tbDocumentosComprasLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosComprasLinhasDimensoes_tbDocumentosStockLinhasDimensoes]')

exec('ALTER TABLE tbDocumentosStockLinhasDimensoes ADD IDLinhaDimensaoDocumentoStock bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosStockLinhasDimensoes] WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhasDimensoes_tbDocumentosStockLinhasDimensoes] FOREIGN KEY([IDLinhaDimensaoDocumentoStock])
REFERENCES [dbo].[tbDocumentosStockLinhasDimensoes] ([ID])
ALTER TABLE [dbo].[tbDocumentosStockLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosStockLinhasDimensoes_tbDocumentosStockLinhasDimensoes]')

EXEC('ALTER TABLE tbDocumentosStockLinhas ADD IDOFArtigo bigint null')
EXEC('ALTER TABLE tbDocumentosComprasLinhas ADD IDOFArtigo bigint null')

--nova tabela
CREATE TABLE [dbo].[tbSistemaTiposDocumentoColunasAutomaticas](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [IDSistemaTipoDocumento] [bigint] NOT NULL, --liga a tbSistemaTiposDocumentos (stocks, vendas, ordens fabrico) etc.
    [Coluna] [nvarchar] (50) NOT NULL,     
    [ChaveColunaTraducao] [nvarchar] (100) NOT NULL,
    [IDPai] [bigint] NULL, -- . Quer dizer cascata da coluna id
    [ControladorExtra] [nvarchar](255) NULL,
    [Controlador] [nvarchar](255) NULL,
    [CampoTexto] [nvarchar](50) NULL,
    [EnviaParametros] [nvarchar](255) NULL,
    [Validador] [nvarchar](255) NULL,
    [IDTipoEditor] [bigint] NULL, --liga a tbTiposDados (lookup,dropdown,checkbox,date) etc    
    [Width] [float] NULL, -- Width
    [Maximo] [float] NULL, -- Maximo
    [Minimo] [float] NULL, -- Minimo
    [TamMaximo] [float] NULL, -- TamMaximo
    [CasasDecimais] [tinyint] NULL, -- tinyint
    [Editavel] [bit] NOT NULL DEFAULT(0), -- EEditavel / Bloqueada
    [Obrigatoria] [bit] NOT NULL DEFAULT(0), -- EObrigatorio / ValidaObrigatorio
    [NaoPermiteNegativos] [bit] NOT NULL DEFAULT(0), -- NaoPermiteNegativos
    [ElementoUnico] [bit] NOT NULL DEFAULT(0), -- ValidaElementoUnico
    [Visivel] [bit] NOT NULL DEFAULT(0), -- mostrar ou não colunas
    [CamposPreencher] [nvarchar](max) NULL,  -- lista de campos a preencher
    [Ordem] [int] NOT NULL,  --Ordem das Automaticas
    [Sistema] [bit] NOT NULL,
    [Ativo] [bit] NOT NULL,
    [DataCriacao] [datetime] NOT NULL,
    [UtilizadorCriacao] [nvarchar](20) NOT NULL,
    [DataAlteracao] [datetime] NULL,
    [UtilizadorAlteracao] [nvarchar](20) NULL,
    [F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaTiposDocumentoColunasAutomaticas] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) 
ALTER TABLE [dbo].[tbSistemaTiposDocumentoColunasAutomaticas] WITH CHECK ADD  CONSTRAINT [FK_tbSistemaTiposDocumentoColunasAutomaticas_tbSistemaTiposDocumento]
FOREIGN KEY([IDSistemaTipoDocumento]) REFERENCES [dbo].[tbSistemaTiposDocumento] ([ID])
ALTER TABLE [dbo].[tbSistemaTiposDocumentoColunasAutomaticas] WITH CHECK ADD  CONSTRAINT [FK_tbSistemaTiposDocumentoColunasAutomaticas_tbSistemaTiposDocumentoColunasAutomaticas]
FOREIGN KEY([IDPai]) REFERENCES [dbo].[tbSistemaTiposDocumentoColunasAutomaticas] ([ID])
ALTER TABLE [dbo].[tbSistemaTiposDocumentoColunasAutomaticas] WITH CHECK ADD  CONSTRAINT [FK_tbSistemaTiposDocumentoColunasAutomaticas_tbTiposDados]
FOREIGN KEY([IDTipoEditor]) REFERENCES [dbo].[tbTiposDados] ([ID])

--cg  14/02/2018
ALTER TABLE tbDocumentosComprasLinhas ADD QtdStockSatisfeita float null
ALTER TABLE tbDocumentosComprasLinhas ADD QtdStockDevolvida float null
ALTER TABLE tbDocumentosComprasLinhas ADD QtdStockAcerto float null
ALTER TABLE tbDocumentosComprasLinhas ADD QtdStock2Satisfeita float null
ALTER TABLE tbDocumentosComprasLinhas ADD QtdStock2Devolvida float null
ALTER TABLE tbDocumentosComprasLinhas ADD QtdStock2Acerto float null
ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD QtdStockSatisfeita float null
ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD QtdStockDevolvida float null
ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD QtdStockAcerto float null
ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD QtdStock2Satisfeita float null
ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD QtdStock2Devolvida float null
ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD QtdStock2Acerto float null

ALTER TABLE tbDocumentosStockLinhas ADD QtdStockSatisfeita float null
ALTER TABLE tbDocumentosStockLinhas ADD QtdStockDevolvida float null
ALTER TABLE tbDocumentosStockLinhas ADD QtdStockAcerto float null
ALTER TABLE tbDocumentosStockLinhas ADD QtdStock2Satisfeita float null
ALTER TABLE tbDocumentosStockLinhas ADD QtdStock2Devolvida float null
ALTER TABLE tbDocumentosStockLinhas ADD QtdStock2Acerto float null
ALTER TABLE tbDocumentosStockLinhasDimensoes ADD QtdStockSatisfeita float null
ALTER TABLE tbDocumentosStockLinhasDimensoes ADD QtdStockDevolvida float null
ALTER TABLE tbDocumentosStockLinhasDimensoes ADD QtdStockAcerto float null
ALTER TABLE tbDocumentosStockLinhasDimensoes ADD QtdStock2Satisfeita float null
ALTER TABLE tbDocumentosStockLinhasDimensoes ADD QtdStock2Devolvida float null
ALTER TABLE tbDocumentosStockLinhasDimensoes ADD QtdStock2Acerto float null

CREATE TABLE [dbo].[tbStockArtigosNecessidades](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTipoDocumento] [bigint] NULL,
	[IDDocumento] [bigint] NULL,
	[IDLinhaDocumento] [bigint] NULL,
	[IDOrdemFabrico] [bigint] NULL,
	[IDEncomenda] [bigint] NULL,
	[Documento] [nvarchar](255) NULL,
	[IDArtigoPA] [bigint] NULL,
	[IDArtigo] [bigint] NOT NULL,
	[IDLoja] [bigint] NULL,
	[IDArmazem] [bigint] NULL,
	[IDArmazemLocalizacao] [bigint] NULL,
	[IDArtigoLote] [bigint] NULL,
	[IDArtigoNumeroSerie] [bigint] NULL,
	[IDArtigoDimensao] [bigint] NULL,
	[IDDimensaolinha1] [bigint] NULL,
	[IDDimensaolinha2] [bigint] NULL,
	[QtdStockReservado] [float] NULL,
	[QtdStockReservado2] [float] NULL,
	[QtdStockRequisitado] [float] NULL,
	[QtdStockRequisitado2] [float] NULL,
	[QtdStockRequisitadoPnd] [float] NULL,
	[QtdStockRequisitadoPnd2] [float] NULL,
	[QtdStockConsumido] [float] NULL,
	[QtdStockConsumido2] [float] NULL,
	IDArtigoPara bigint null,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbStockArtigosNecessidades_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbStockArtigosNecessidades_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbStockArtigosNecessidades_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbStockArtigosNecessidades_UtilizadorCriacao]  DEFAULT (''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbStockArtigosNecessidades_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbStockArtigosNecessidades_UtilizadorAlteracao]  DEFAULT (''),
	[F3MMarcador] [timestamp] NULL
 CONSTRAINT [PK_tbStockArtigosNecessidades] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
) ON [PRIMARY]

ALTER TABLE [dbo].[tbStockArtigosNecessidades]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigosNecessidades_IDArmazem] FOREIGN KEY([IDArmazem])
REFERENCES [dbo].[tbArmazens] ([ID])
ALTER TABLE [dbo].[tbStockArtigosNecessidades] CHECK CONSTRAINT [FK_tbStockArtigosNecessidades_IDArmazem]

ALTER TABLE [dbo].[tbStockArtigosNecessidades]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigosNecessidades_IDArmazemLocalizacao] FOREIGN KEY([IDArmazemLocalizacao])
REFERENCES [dbo].[tbArmazensLocalizacoes] ([ID])
ALTER TABLE [dbo].[tbStockArtigosNecessidades] CHECK CONSTRAINT [FK_tbStockArtigosNecessidades_IDArmazemLocalizacao]

ALTER TABLE [dbo].[tbStockArtigosNecessidades]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigosNecessidades_IDArtigo] FOREIGN KEY([IDArtigo])
REFERENCES [dbo].[tbArtigos] ([ID])
ALTER TABLE [dbo].[tbStockArtigosNecessidades] CHECK CONSTRAINT [FK_tbStockArtigosNecessidades_IDArtigo]

ALTER TABLE [dbo].[tbStockArtigosNecessidades]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigosNecessidades_IDArtigoPA] FOREIGN KEY([IDArtigoPA])
REFERENCES [dbo].[tbArtigos] ([ID])
ALTER TABLE [dbo].[tbStockArtigosNecessidades] CHECK CONSTRAINT [FK_tbStockArtigosNecessidades_IDArtigoPA]

ALTER TABLE [dbo].[tbStockArtigosNecessidades]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigosNecessidades_IDArtigoDimensao] FOREIGN KEY([IDArtigoDimensao])
REFERENCES [dbo].[tbArtigosDimensoes] ([ID])
ALTER TABLE [dbo].[tbStockArtigosNecessidades] CHECK CONSTRAINT [FK_tbStockArtigosNecessidades_IDArtigoDimensao]

ALTER TABLE [dbo].[tbStockArtigosNecessidades]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigosNecessidades_IDArtigoLote] FOREIGN KEY([IDArtigoLote])
REFERENCES [dbo].[tbArtigosLotes] ([ID])
ALTER TABLE [dbo].[tbStockArtigosNecessidades] CHECK CONSTRAINT [FK_tbStockArtigosNecessidades_IDArtigoLote]

ALTER TABLE [dbo].[tbStockArtigosNecessidades]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigosNecessidades_IDArtigoNumeroSerie] FOREIGN KEY([IDArtigoNumeroSerie])
REFERENCES [dbo].[tbArtigosNumerosSeries] ([ID])
ALTER TABLE [dbo].[tbStockArtigosNecessidades] CHECK CONSTRAINT [FK_tbStockArtigosNecessidades_IDArtigoNumeroSerie]

ALTER TABLE [dbo].[tbStockArtigosNecessidades]  WITH CHECK ADD  CONSTRAINT [FK_tbStockArtigosNecessidades_IDArtigoPara] FOREIGN KEY([IDArtigoPara])
REFERENCES [dbo].[tbArtigos] ([ID])
ALTER TABLE [dbo].[tbStockArtigosNecessidades] CHECK CONSTRAINT [FK_tbStockArtigosNecessidades_IDArtigoPara]
