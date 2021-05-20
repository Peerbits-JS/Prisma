/* ACT BD EMPRESA VERSAO 9*/
EXEC('ALTER TABLE [dbo].[tbDocumentosStockLinhas] ADD IDArtigoPara bigint NULL')
EXEC('ALTER TABLE [dbo].[tbDocumentosComprasLinhas] ADD IDArtigoPara bigint NULL')
EXEC('ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbArtigos1] FOREIGN KEY([IDArtigoPara]) REFERENCES [dbo].[tbArtigos] ([ID])')
EXEC('ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArtigos1] FOREIGN KEY([IDArtigoPara]) REFERENCES [dbo].[tbArtigos] ([ID])')

EXEC('
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (27, 27, N''MapaPendentesVendas'', N''Mapa de Pendentes de Vendas'', N''rptMapaPendentes'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, N''select * from vwMapaPendentesVendas'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (28, 28, N''MapaPendentesCompras'', N''Mapa de Pendentes de Compras'', N''rptMapaPendentes'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, N''select * from vwMapaPendentesCompras'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=118)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) VALUES (118, 12, N''Etiquetas'', N''012.005'', N''Etiquetas'', 2, N''fm f3icon-barcode'', N''/Etiquetas/Etiquetas'', 1, 12, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=118 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 118, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

EXEC('update tbmapasvistas set idmodulo=4 where descricao =''DocumentosVendasA5''')
EXEC('update tbmapasvistas set idmodulo=4 where descricao =''DocumentosVendasA4''')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbSistemaCategListasPers] WHERE Descricao=''Caixas'')
BEGIN
DECLARE @IDMenu as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Artigos''
INSERT [F3MOGeral].[dbo].[tbSistemaCategListasPers] ([ID], [Descricao], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, N''Caixas'', @IDMenu, 0, 1, CAST(N''2015-12-18 17:54:54.977'' AS DateTime), N''F3M'', CAST(N''2015-12-18 17:54:54.977'' AS DateTime), N''F3M'')
END')

EXEC('UPDATE [F3MOGeral].[dbo].tbListasPersonalizadas set IDSistemaCategListasPers=4 where Descricao=''Mapa de Caixa''')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Fornecedores''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoFornecedor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Valor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTiposDocumento'', 0, 5, 150)
END')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Clientes''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoCliente'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Valor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTiposDocumento'', 0, 5, 150)
END')

EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwCCArtigos'')) drop view vwCCArtigos')

EXEC('
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
tbArtigos.Codigo + ''''-'''' + tbArtigos.Descricao as DescricaoArtigo,
tbArtigos.Ativo as Ativo,
tbLojas.Codigo as CodigoLoja,
tbLojas.Descricao as DescricaoLoja,
tbArmazens.Codigo as CodigoArmazem,
tbArmazens.Descricao as DescricaoArmazem,
tbArmazensLocalizacoes.Codigo as CodigoLocalizacao,
tbArmazensLocalizacoes.Descricao as DescricaoLocalizacao,
tbArtigosLotes.Codigo as CodigoLote,
tbArtigosLotes.Descricao as DescricaoLote,
tbTiposDocumento.Descricao as DescricaoTipoDocumento,
tbTiposArtigos.Descricao as DescricaoTipoArtigo,
(case when tbCCStockArtigos.idtipoentidade<4 then tbClientes.Codigo else tbFornecedores.Codigo end) as CodigoCF,
(case when tbCCStockArtigos.idtipoentidade<4 then tbClientes.Nome else tbFornecedores.Nome end) as DescricaoCF,
tbDimensoesLinhas.Descricao as DescricaoDimensaoLinha1,
tbDimensoesLinhas1.Descricao as DescricaoDimensaoLinha2,
(case when tbCCStockArtigos.Natureza=''''E'''' then ''''Entrada'''' else ''''Saida'''' end) as Natureza,
tbCCStockArtigos.QtdStockAtual,
tbCCStockArtigos.QtdStockAnterior,
isnull(tbCCStockArtigos.PCMAtualMoedaRef,0) as PCMAtualMoedaRef,
isnull(tbCCStockArtigos.PCMAnteriorMoedaRef,0) as PCMAnteriorMoedaRef,
(case when tbCCStockArtigos.Natureza=''''E'''' then tbCCStockArtigos.Quantidade else -(tbCCStockArtigos.Quantidade) end) as QtdLinhaStock,
Round(isnull((
select Sum((Case tbCCStockAgreg.Natureza when ''''E'''' then 1 else -1 end) * tbCCStockAgreg.Quantidade) FROM tbCCStockArtigos as tbCCStockAgreg
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
isnull(tbCCStockArtigos.PrecoUnitarioEfetivoMoedaRef,0) as PrecoUnitarioMoedaRef,
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
LEFT JOIN tbFornecedores AS tbFornecedores ON tbFornecedores.ID = tbCCStockArtigos.IDEntidade
LEFT JOIN tbclientes AS tbclientes ON tbclientes.ID = tbCCStockArtigos.IDEntidade
LEFT JOIN tbtiposartigos AS tbtiposartigos ON tbtiposartigos.ID = tbArtigos.IDtipoartigo
LEFT JOIN tbLojas AS tbLojas ON tbLojas.ID = tbCCStockArtigos.IDLoja
ORDER BY DataControloInterno, tbCCStockArtigos.ID  OFFSET 0 ROWS 
'')
END')

EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaIvaVendas'')) drop view vwMapaIvaVendas')

EXEC('create view [dbo].[vwMapaIvaVendas] as
select 
tbDocumentosVendas.ID, 
tbDocumentosVendas.IDLoja, 
tbDocumentosVendas.NomeFiscal, 
tbDocumentosVendas.IDEntidade, 
tbDocumentosVendas.IDTipoDocumento, 
tbDocumentosVendas.IDTiposDocumentoSeries, 
tbDocumentosVendas.NumeroDocumento, 
tbDocumentosVendas.DataDocumento,
tbDocumentosVendas.Documento, 
tbDocumentosVendas.IDMoeda, 
tbDocumentosVendas.TaxaConversao, 
tbDocumentosVendas.Ativo as Ativo, 
tbDocumentosVendasLinhas.TaxaIva, 
tbDocumentosVendasLinhas.IDTaxaIva, 
tbLojas.Codigo as CodigoLoja, 
tbLojas.Descricao as DescricaoLoja,
tbClientes.Codigo as CodigoCliente, 
tbClientes.NContribuinte as NContribuinte, 
tbTiposDocumento.Codigo, 
tbTiposDocumento.Codigo as DescricaoTipoDocumento,
tbTiposDocumentoSeries.CodigoSerie as DescricaoTipoDocumentoSerie, 
tbIVA.Codigo as CodigoIva, 
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,
(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIncidencia) as ValorIncidencia,
(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIVA) as ValorIVA,
(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIncidencia + tbDocumentosVendasLinhas.ValorIVA) as Valor,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais
FROM tbDocumentosVendas AS tbDocumentosVendas
INNER JOIN tbDocumentosVendasLinhas AS tbDocumentosVendasLinhas ON tbDocumentosVendas.id=tbDocumentosVendasLinhas.IDDocumentoVenda
INNER JOIN tbClientes AS tbClientes with (nolock) ON tbClientes.id=tbDocumentosVendas.IDentidade
INNER JOIN tbLojas AS tbLojas with (nolock) ON tbLojas.id=tbDocumentosVendas.IDLoja
INNER JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosVendas.IDMoeda
INNER JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbDocumentosVendas.IDTipoDocumento AND not tbTiposDocumento.idsistematiposdocumentofiscal is null 
INNER JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbTiposDocumento.IDSistemaNaturezas=tbSistemaNaturezas.ID
INNER JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbDocumentosVendas.IDTiposDocumentoSeries
INNER JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbTiposDocumento.IDSistemaTiposDocumento=tbSistemaTiposDocumento.ID
INNER JOIN tbIVA AS tbIVA  with (nolock) ON tbDocumentosVendasLinhas.IDtaxaiva=tbIVA.ID
WHERE tbSistemaTiposDocumento.Tipo=''VndFinanceiro''
GROUP BY tbDocumentosVendas.ID, tbDocumentosVendas.IDLoja, tbDocumentosVendas.NomeFiscal, tbDocumentosVendas.IDEntidade, tbDocumentosVendas.IDTipoDocumento, tbDocumentosVendas.IDTiposDocumentoSeries, tbDocumentosVendas.NumeroDocumento,
tbDocumentosVendas.DataDocumento, tbDocumentosVendas.Documento, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbDocumentosVendas.Ativo, tbDocumentosVendasLinhas.TaxaIva, tbDocumentosVendasLinhas.IDTaxaIva,
tbLojas.Codigo, tbLojas.Descricao, tbClientes.Codigo, tbClientes.Nome, tbClientes.NContribuinte, tbTiposDocumento.Codigo,tbTiposDocumentoSeries.CodigoSerie,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end),
tbSistemaNaturezas.Codigo, tbIVA.Codigo,tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao
ORDER BY tbDocumentosVendas.ID  OFFSET 0 ROWS ')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Iva de Vendas''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoCliente'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 200)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoIva'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TaxaIva'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''ValorIncidencia'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''ValorIVA'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Valor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTiposDocumento'', 0, 5, 150)
END')


EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaIvaCompras'')) drop view vwMapaIvaCompras')

EXEC('create view [dbo].[vwMapaIvaCompras] as
select 
tbDocumentosCompras.ID, 
tbDocumentosCompras.IDLoja, 
tbDocumentosCompras.NomeFiscal, 
tbDocumentosCompras.IDEntidade, 
tbDocumentosCompras.IDTipoDocumento, 
tbDocumentosCompras.IDTiposDocumentoSeries, 
tbDocumentosCompras.NumeroDocumento, 
tbDocumentosCompras.DataDocumento,
tbDocumentosCompras.Documento, 
tbDocumentosCompras.IDMoeda, 
tbDocumentosCompras.TaxaConversao, 
tbDocumentosCompras.Ativo as Ativo, 
tbDocumentosComprasLinhas.TaxaIva, 
tbDocumentosComprasLinhas.IDTaxaIva, 
tbLojas.Codigo as CodigoLoja, 
tbLojas.Descricao as DescricaoLoja,
tbFornecedores.Codigo as CodigoFornecedor, 
tbFornecedores.NContribuinte as NContribuinte, 
tbTiposDocumento.Codigo, 
tbTiposDocumento.Codigo as DescricaoTipoDocumento,
tbTiposDocumentoSeries.CodigoSerie as DescricaoTipoDocumentoSerie, 
tbIVA.Codigo as CodigoIva, 
tbSistemaTiposEstados.Codigo as Estado,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,
(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIncidencia) as ValorIncidencia,
(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIVA) as ValorIVA,
(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIncidencia + tbDocumentosComprasLinhas.ValorIVA) as Valor,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais
FROM tbDocumentosCompras AS tbDocumentosCompras
INNER JOIN tbDocumentosComprasLinhas AS tbDocumentosComprasLinhas ON tbDocumentosCompras.id=tbDocumentosComprasLinhas.IDDocumentoCompra
INNER JOIN tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.id=tbDocumentosCompras.IDentidade
INNER JOIN tbLojas AS tbLojas with (nolock) ON tbLojas.id=tbDocumentosCompras.IDLoja
INNER JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosCompras.IDMoeda
INNER JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbDocumentosCompras.IDTipoDocumento AND not tbTiposDocumento.idsistematiposdocumentofiscal is null 
INNER JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbTiposDocumento.IDSistemaNaturezas=tbSistemaNaturezas.ID
INNER JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbDocumentosCompras.IDTiposDocumentoSeries
INNER JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbTiposDocumento.IDSistemaTiposDocumento=tbSistemaTiposDocumento.ID
INNER JOIN tbIVA AS tbIVA  with (nolock) ON tbDocumentosComprasLinhas.IDtaxaiva=tbIVA.ID
INNER JOIN tbestados AS tbestados with (nolock) ON tbDocumentosCompras.IDEstado=tbEstados.ID
INNER JOIN tbSistemaTiposEstados AS tbSistemaTiposEstados with (nolock) ON tbEstados.IDTipoEstado=tbSistemaTiposEstados.ID
WHERE tbSistemaTiposDocumento.Tipo=''CmpFinanceiro''
GROUP BY tbDocumentosCompras.ID, tbDocumentosCompras.IDLoja, tbDocumentosCompras.NomeFiscal, tbDocumentosCompras.IDEntidade, tbDocumentosCompras.IDTipoDocumento, tbDocumentosCompras.IDTiposDocumentoSeries, tbDocumentosCompras.NumeroDocumento,
tbDocumentosCompras.DataDocumento, tbDocumentosCompras.Documento, tbDocumentosCompras.IDMoeda, tbDocumentosCompras.TaxaConversao, tbDocumentosCompras.Ativo, tbDocumentosComprasLinhas.TaxaIva, tbDocumentosComprasLinhas.IDTaxaIva,
tbLojas.Codigo, tbLojas.Descricao, tbFornecedores.Codigo, tbFornecedores.Nome, tbFornecedores.NContribuinte, tbTiposDocumento.Codigo,tbTiposDocumentoSeries.CodigoSerie,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end), tbSistemaTiposEstados.Codigo, tbSistemaNaturezas.Codigo, tbIVA.Codigo,tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao
ORDER BY tbDocumentosCompras.ID  OFFSET 0 ROWS ')


EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Iva de Compras''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoFornecedor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 200)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoIva'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TaxaIva'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''ValorIncidencia'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''ValorIVA'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Valor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTiposDocumento'', 0, 5, 150)
END')


EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaPendentesVendas'')) drop view vwMapaPendentesVendas')

EXEC('create view [dbo].[vwMapaPendentesVendas] as
select 
tbDocumentosVendas.ID, 
tbDocumentosVendas.IDLoja, 
tbDocumentosVendas.NomeFiscal, 
tbDocumentosVendas.IDEntidade, 
tbDocumentosVendas.IDTipoDocumento, 
tbDocumentosVendas.IDTiposDocumentoSeries, 
tbDocumentosVendas.NumeroDocumento, 
tbDocumentosVendas.DataDocumento,
tbDocumentosVendas.Documento, 
tbDocumentosVendas.IDMoeda, 
tbDocumentosVendas.TaxaConversao, 
tbDocumentosVendas.Ativo as Ativo, 
tbLojas.Codigo as CodigoLoja, 
tbLojas.Descricao as DescricaoLoja,
tbClientes.Codigo as CodigoCliente, 
tbClientes.NContribuinte as NContribuinte, 
tbTiposDocumento.Codigo, 
tbTiposDocumento.Codigo as DescricaoTipoDocumento,
tbTiposDocumentoSeries.CodigoSerie as DescricaoTipoDocumentoSerie, 
tbSistemaNaturezas.Codigo as CodigoNatureza,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,
isnull(tbDocumentosVendasPendentes.TotalMoedaDocumento, 0)*(case when tbSistemaNaturezas.Codigo=''P'' then -1 else  1 end) as Valor,
isnull(tbDocumentosVendasPendentes.ValorPendente, 0)*(case when tbSistemaNaturezas.Codigo=''P'' then -1 else  1 end) as ValorPendente,
isnull(tbDocumentosVendasPendentes.Pago, 0) as Pago,
Round(isnull((
select Sum((Case tbCCSaldoAgreg.IDSistemaNaturezas when 6 then 1 else -1 end) * tbCCSaldoAgreg.ValorPendente) FROM tbDocumentosVendasPendentes as tbCCSaldoAgreg
WHERE tbCCSaldoAgreg.IDEntidade= tbDocumentosVendasPendentes.IDEntidade
AND tbCCSaldoAgreg.DataCriacao <= tbDocumentosVendasPendentes.DataCriacao
AND (tbCCSaldoAgreg.IDSistemaNaturezas in (6,7))
AND ((tbCCSaldoAgreg.IDTipoDocumento<>tbDocumentosVendasPendentes.IDTipoDocumento OR tbCCSaldoAgreg.IDDocumentoVenda <> tbDocumentosVendasPendentes.IDDocumentoVenda
       ) OR (tbCCSaldoAgreg.IDTipoDocumento = tbDocumentosVendasPendentes.IDTipoDocumento AND tbCCSaldoAgreg.IDDocumentoVenda = tbDocumentosVendasPendentes.IDDocumentoVenda
		AND tbCCSaldoAgreg.ID<=tbDocumentosVendasPendentes.ID))),0),isnull(tbMoedas.CasasDecimaisTotais,0)) as Saldo,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
datediff(day,tbDocumentosVendas.DataDocumento,getdate()) as NumeroDias
FROM tbDocumentosVendasPendentes AS tbDocumentosVendasPendentes with (nolock) 
INNER JOIN tbDocumentosVendas AS tbDocumentosVendas with (nolock) ON tbDocumentosVendas.id=tbDocumentosVendasPendentes.IDDocumentoVenda
INNER JOIN tbClientes AS tbClientes with (nolock) ON tbClientes.id=tbDocumentosVendas.IDentidade
INNER JOIN tbLojas AS tbLojas with (nolock) ON tbLojas.id=tbDocumentosVendas.IDLoja
INNER JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosVendas.IDMoeda
INNER JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbDocumentosVendas.IDTipoDocumento AND not tbTiposDocumento.idsistematiposdocumentofiscal is null 
INNER JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbTiposDocumento.IDSistemaNaturezas=tbSistemaNaturezas.ID
INNER JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbDocumentosVendas.IDTiposDocumentoSeries
INNER JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbTiposDocumento.IDSistemaTiposDocumento=tbSistemaTiposDocumento.ID
WHERE tbSistemaTiposDocumento.Tipo=''VndFinanceiro'' and isnull(tbDocumentosVendasPendentes.ValorPendente,0)>0
GROUP BY tbDocumentosVendas.ID, tbDocumentosVendas.IDLoja, tbDocumentosVendas.NomeFiscal, tbDocumentosVendas.IDEntidade, tbDocumentosVendas.IDTipoDocumento, tbDocumentosVendas.IDTiposDocumentoSeries, tbDocumentosVendas.NumeroDocumento,
tbDocumentosVendas.DataDocumento, tbDocumentosVendas.Documento, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbDocumentosVendas.Ativo, 
tbLojas.Codigo, tbLojas.Descricao, tbClientes.Codigo, tbClientes.Nome, tbClientes.NContribuinte, tbTiposDocumento.Codigo,tbTiposDocumentoSeries.CodigoSerie,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end),
tbSistemaNaturezas.Codigo, tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao,
isnull(tbDocumentosVendasPendentes.TotalMoedaDocumento, 0), isnull(tbDocumentosVendasPendentes.ValorPendente,0), isnull(tbDocumentosVendasPendentes.Pago, 0) 
,tbDocumentosVendasPendentes.IDEntidade, tbDocumentosVendasPendentes.DataCriacao,tbDocumentosVendasPendentes.IDTipoDocumento,tbDocumentosVendasPendentes.IDDocumentoVenda,tbDocumentosVendasPendentes.ID                    
ORDER BY tbDocumentosVendas.ID  OFFSET 0 ROWS ')


EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Pendentes de Vendas'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDCateg as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Mapa de Pendentes de Vendas'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''vwMapaPendentesVendas'', 
N''select * from vwMapaPendentesVendas'', 3, 2)
END')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Pendentes de Vendas''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoCliente'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDias'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Valor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''ValorPendente'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTiposDocumento'', 0, 5, 150)
END')

EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaPendentesCompras'')) drop view vwMapaPendentesCompras')

EXEC('create view [dbo].[vwMapaPendentesCompras] as
select 
tbDocumentosCompras.ID, 
tbDocumentosCompras.IDLoja, 
tbDocumentosCompras.NomeFiscal, 
tbDocumentosCompras.IDEntidade, 
tbDocumentosCompras.IDTipoDocumento, 
tbDocumentosCompras.IDTiposDocumentoSeries, 
tbDocumentosCompras.NumeroDocumento, 
tbDocumentosCompras.DataDocumento,
tbDocumentosCompras.Documento, 
tbDocumentosCompras.IDMoeda, 
tbDocumentosCompras.TaxaConversao, 
tbDocumentosCompras.Ativo as Ativo, 
tbLojas.Codigo as CodigoLoja, 
tbLojas.Descricao as DescricaoLoja,
tbFornecedores.Codigo as CodigoFornecedor, 
tbFornecedores.NContribuinte as NContribuinte, 
tbTiposDocumento.Codigo, 
tbTiposDocumento.Codigo as DescricaoTipoDocumento,
tbTiposDocumentoSeries.CodigoSerie as DescricaoTipoDocumentoSerie, 
tbSistemaNaturezas.Codigo as CodigoNatureza,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,
isnull(tbDocumentosComprasPendentes.TotalMoedaDocumento, 0)*(case when tbSistemaNaturezas.Codigo=''R'' then -1 else  1 end) as Valor,
isnull(tbDocumentosComprasPendentes.ValorPendente, 0)*(case when tbSistemaNaturezas.Codigo=''R'' then -1 else  1 end) as ValorPendente,
isnull(tbDocumentosComprasPendentes.Pago, 0) as Pago,
Round(isnull((
select Sum((Case tbCCSaldoAgreg.IDSistemaNaturezas when 12 then 1 else -1 end) * tbCCSaldoAgreg.ValorPendente) FROM tbDocumentosComprasPendentes as tbCCSaldoAgreg
WHERE tbCCSaldoAgreg.IDEntidade= tbDocumentosComprasPendentes.IDEntidade
AND tbCCSaldoAgreg.DataCriacao <= tbDocumentosComprasPendentes.DataCriacao
AND (tbCCSaldoAgreg.IDSistemaNaturezas in (12,13))
AND ((tbCCSaldoAgreg.IDTipoDocumento<>tbDocumentosComprasPendentes.IDTipoDocumento OR tbCCSaldoAgreg.IDDocumentoCompra <> tbDocumentosComprasPendentes.IDDocumentoCompra
       ) OR (tbCCSaldoAgreg.IDTipoDocumento = tbDocumentosComprasPendentes.IDTipoDocumento AND tbCCSaldoAgreg.IDDocumentoCompra = tbDocumentosComprasPendentes.IDDocumentoCompra
		AND tbCCSaldoAgreg.ID<=tbDocumentosComprasPendentes.ID))),0),isnull(tbMoedas.CasasDecimaisTotais,0)) as Saldo,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
datediff(day,tbDocumentosCompras.DataDocumento,getdate()) as NumeroDias
FROM tbDocumentosComprasPendentes AS tbDocumentosComprasPendentes with (nolock) 
INNER JOIN tbDocumentosCompras AS tbDocumentosCompras with (nolock) ON tbDocumentosCompras.id=tbDocumentosComprasPendentes.IDDocumentoCompra
INNER JOIN tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.id=tbDocumentosCompras.IDentidade
INNER JOIN tbLojas AS tbLojas with (nolock) ON tbLojas.id=tbDocumentosCompras.IDLoja
INNER JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosCompras.IDMoeda
INNER JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbDocumentosCompras.IDTipoDocumento AND not tbTiposDocumento.idsistematiposdocumentofiscal is null 
INNER JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbTiposDocumento.IDSistemaNaturezas=tbSistemaNaturezas.ID
INNER JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbDocumentosCompras.IDTiposDocumentoSeries
INNER JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbTiposDocumento.IDSistemaTiposDocumento=tbSistemaTiposDocumento.ID
WHERE tbSistemaTiposDocumento.Tipo=''CmpFinanceiro'' and isnull(tbDocumentosComprasPendentes.ValorPendente,0)>0
GROUP BY tbDocumentosCompras.ID, tbDocumentosCompras.IDLoja, tbDocumentosCompras.NomeFiscal, tbDocumentosCompras.IDEntidade, tbDocumentosCompras.IDTipoDocumento, tbDocumentosCompras.IDTiposDocumentoSeries, tbDocumentosCompras.NumeroDocumento,
tbDocumentosCompras.DataDocumento, tbDocumentosCompras.Documento, tbDocumentosCompras.IDMoeda, tbDocumentosCompras.TaxaConversao, tbDocumentosCompras.Ativo, 
tbLojas.Codigo, tbLojas.Descricao, tbFornecedores.Codigo, tbFornecedores.Nome, tbFornecedores.NContribuinte, tbTiposDocumento.Codigo,tbTiposDocumentoSeries.CodigoSerie,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end),
tbSistemaNaturezas.Codigo, tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao,
isnull(tbDocumentosComprasPendentes.TotalMoedaDocumento, 0), isnull(tbDocumentosComprasPendentes.ValorPendente,0), isnull(tbDocumentosComprasPendentes.Pago, 0) 
,tbDocumentosComprasPendentes.IDEntidade, tbDocumentosComprasPendentes.DataCriacao,tbDocumentosComprasPendentes.IDTipoDocumento,tbDocumentosComprasPendentes.IDDocumentoCompra,tbDocumentosComprasPendentes.ID                    
ORDER BY tbDocumentosCompras.ID  OFFSET 0 ROWS ')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Pendentes de Compras'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDCateg as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Mapa de Pendentes de Compras'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''vwMapaPendentesCompras'', 
N''select * from vwMapaPendentesCompras'', 2, 2)
END')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Pendentes de Compras''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoFornecedor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDias'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Valor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''ValorPendente'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTiposDocumento'', 0, 5, 150)
END')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''select tbclientes.ID, tbclientes.Codigo, tbclientes.Nome, tbclientes.NContribuinte, tbclientes.Ativo, mt.Nome as MedicoTecnico, tbclientes.Datanascimento, cc.Telefone, cc.Telemovel, en.Descricao as Entidade1, et.Descricao as Entidade2, lj.descricao as Loja, isnull(tbclientes.saldo, 0) as Saldo, tbclientes.IdTipoEntidade, cast(tbclientes.nome as nvarchar(20)) as DescricaoSplitterLadoDireito 
from tbclientes  
left join tbLojas lj on tbclientes.idloja=lj.id
left join tbMedicosTecnicos mt on tbclientes.idmedicotecnico=mt.id
left join tbentidades en on tbclientes.identidade1=en.id
left join tbentidades et on tbclientes.identidade2=et.id
left join tbclientescontatos cc on tbclientes.id=cc.idcliente and cc.ordem=1''
where id in (25,66,68)')


EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE ID=25
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE idlistapersonalizada=25
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Codigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Nome'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataNascimento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telefone'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telemovel'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NContribuinte'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDMedicoTecnico'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade1'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 100)
END')


EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE ID=66
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE idlistapersonalizada=66
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Codigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Nome'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataNascimento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telefone'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telemovel'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NContribuinte'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDMedicoTecnico'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade1'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 100)
END')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE ID=68
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE idlistapersonalizada=68
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Codigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Nome'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataNascimento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telefone'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telemovel'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NContribuinte'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDMedicoTecnico'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade1'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 100)
END')