/* ACT BD EMPRESA VERSAO 21*/
EXEC('ALTER TABLE [dbo].[tbCCStockArtigos] ALTER COLUMN [Descricao] [nvarchar](200) NOT NULL')
EXEC('update tbclientes set sistema=1 where codigo=''CF''')
EXEC('UPDATE [dbo].[tbSistemaNaturezas] SET Descricao = ''AReceber'' WHERE Descricao = ''Recebimento'' AND TipoDoc = ''CntCorrLiquidacao''') 
EXEC('UPDATE [dbo].[tbSistemaNaturezas] SET Descricao = ''APagar'' WHERE Descricao = ''Pagamento'' AND TipoDoc = ''CntCorrLiquidacao''') 
EXEC('update m set m.DescricaoFormaPagamento=f.Descricao from tbmapacaixa m inner join tbFormasPagamento f on m.IDFormaPagamento=f.id where m.DescricaoFormaPagamento is null')

EXEC('insert into tbSistemaTiposDocumentoFiscal (ID, Tipo, Descricao, IDTipoDocumento, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (48,''OR'',''Orcamento'',11,1,1,''2016-05-19 00:00:00.000'',''F3M'')')
EXEC('insert into tbSistemaTiposDocumentoFiscal (ID, Tipo, Descricao, IDTipoDocumento, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (49,''PF'',''FaturaProForma'',14,1,1,''2016-05-19 00:00:00.000'',''F3M'')')
EXEC('insert into tbSistemaTiposDocumentoFiscal (ID, Tipo, Descricao, IDTipoDocumento, Sistema, Ativo, DataCriacao, UtilizadorCriacao)  VALUES (50,''NE'',''Encomenda'',12,1,1,''2016-05-19 00:00:00.000'',''F3M'')')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=120)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (120, 116, N''MovimentosCaixa'', N''006.001.002'', N''MovimentosCaixa'', 2, N''fm f3icon-caixa-registadora'', N''/Caixas/MovimentosCaixa'', 1, 6, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=120 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) 
VALUES (1, 120, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Movimentos de Caixa'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''MovimentosCaixa''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Movimentos de Caixa'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbMovimentosCaixa'', 
N''select Distinct D.Descricao as Descricao, D.Descricao as Documento, D.ID, D.Ativo, D.IDTipoDocumentoSeries, d.IDTipoDocumento, D.IDDocumento, D.NumeroDocumento, D.IDFormaPagamento, FP.Descricao as DescricaoFormaPagamento, D.IDLoja as IDLoja, l.Descricao as DescricaoLoja, (case when D.Natureza=''''P'''' then ''''Entrada'''' else ''''Saída'''' end) as Natureza, DataDocumento, D.IDMoeda, D.TotalMoeda, d.TotalMoedareferencia, D.Descricao as DescricaoSplitterLadoDireito 
from tbmapacaixa d 
left join tbLojas l on d.IDloja=l.id 
inner join tbFormasPagamento FP on d.IDFormaPagamento=FP.ID 
inner join tbTiposDocumento TD on d.IDTipoDocumento is null'', null, 1)
END')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Movimentos de Caixa''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE [IDListaPersonalizada]=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoFormaPagamento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 0, 250)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Descricao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TotalMoeda'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDFormaPagamento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFormasPagamento'', 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 0, 0, 150)
END')

EXEC('INSERT [dbo].[tbTiposDocumento] ([Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento], [Predefinido]) 
VALUES (N''ORC'', N''Orçamento de Venda'', 4, 11, 0, 1, CAST(N''2017-07-27 17:24:04.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, NULL, 1, 2, NULL, NULL, NULL, NULL, NULL, NULL, 8, 0, 0, 0, 0)')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [dbo].[tbTiposDocumento] WHERE Descricao=''Orçamento de Venda''
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (@IDLista, 5, 0, 0, CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (@IDLista, 6, 0, 0, CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoSeries] ([CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) 
VALUES (right(year(getdate()),2) + ''ORC'', right(year(getdate()),2) + ''ORC'', 1, @IDLista, 0, 1, CAST(N''2017-07-27 17:24:03.447'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ([IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, @IDLista, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:26:30.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
END')

EXEC('INSERT [dbo].[tbTiposDocumento] ([Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento], [Predefinido]) 
VALUES (N''PRF'', N''Fatura Pró-Forma'', 4, 14, 0, 1, CAST(N''2017-07-27 17:24:04.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, NULL, 1, 2, NULL, NULL, NULL, NULL, NULL, NULL, 8, 0, 0, 0, 0)')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [dbo].[tbTiposDocumento] WHERE Descricao=''Fatura Pró-Forma''
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (@IDLista, 5, 0, 0, CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (@IDLista, 6, 0, 0, CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoSeries] ([CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) 
VALUES (right(year(getdate()),2) + ''PRF'', right(year(getdate()),2) + ''PRF'', 1, @IDLista, 0, 1, CAST(N''2017-07-27 17:24:03.447'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ([IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, @IDLista, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:26:30.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
END')

--Recalculo de stocks
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=121)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (121, NULL, N''RecalculoStocks'', N''019'', N''RecalculoStocks'', 1900000, N''fm f3icon-tipoartigos'', N''/Recalculos/Recalculos/RecalculoStocks'', 1, 14, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=121 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) 
VALUES (1, 121, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

--contas correntes
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwCCClientes'')) drop view vwCCClientes')

EXEC('create view [dbo].[vwCCClientes] as
select 
tbClientes.Codigo as CodigoCliente,
tbCCEntidades.NomeFiscal,
tbCCEntidades.IDEntidade,
tbCCEntidades.IDLoja,
tbCCEntidades.IDTipoDocumento,
tbCCEntidades.IDTipoDocumentoSeries,
tbCCEntidades.NumeroDocumento,
tbCCEntidades.DataDocumento,
tbCCEntidades.Descricao as Documento,
tbCCEntidades.IDMoeda,
tbCCEntidades.Ativo as Ativo,
(case when tbCCEntidades.Natureza=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,  
(case when tbCCEntidades.Natureza=''R'' then tbCCEntidades.TotalMoeda else -(tbCCEntidades.TotalMoeda) end) as TotalMoeda,
(case when tbCCEntidades.Natureza=''R'' then tbCCEntidades.TotalMoedaReferencia else -(tbCCEntidades.TotalMoedaReferencia) end) as Valor,
(case when tbCCEntidades.Natureza=''R'' then tbCCEntidades.TotalMoedaReferencia else -(tbCCEntidades.TotalMoedaReferencia) end) as TotalMoedaReferencia,
Round(isnull((
select Sum((Case tbCCSaldoAgreg.Natureza when ''R'' then 1 else -1 end) * tbCCSaldoAgreg.TotalMoedaReferencia) FROM tbCCEntidades as tbCCSaldoAgreg
WHERE tbCCSaldoAgreg.IDEntidade= tbCCEntidades.IDEntidade
AND (tbCCSaldoAgreg.Natureza =''P'' OR tbCCSaldoAgreg.Natureza =''R'')
AND tbCCSaldoAgreg.DataCriacao <= tbCCEntidades.DataCriacao
AND ((tbCCSaldoAgreg.IDTipoDocumento<>tbCCEntidades.IDTipoDocumento OR tbCCSaldoAgreg.IDDocumento <> tbCCEntidades.IDDocumento
       ) OR (tbCCSaldoAgreg.IDTipoDocumento = tbCCEntidades.IDTipoDocumento AND tbCCSaldoAgreg.IDDocumento = tbCCEntidades.IDDocumento
                     AND tbCCSaldoAgreg.ID<=tbCCEntidades.ID
                     )
       )
),0),isnull(tbMoedasRef.CasasDecimaisTotais,0)) as Saldo,
tbMoedasRef.descricao as tbMoedas_Descricao, 
tbMoedasRef.Simbolo as tbMoedas_Simbolo, 
tbMoedasRef.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
tbMoedasRef.CasasDecimaisTotais as Saldonumcasasdecimais,
tbMoedasRef.CasasDecimaisTotais as Valornumcasasdecimais,
tblojas.Codigo as CodigoLoja,
tblojas.Descricao as DescricaoLoja
FROM tbCCEntidades AS tbCCEntidades
LEFT JOIN tbClientes AS tbClientes ON tbClientes.id=tbCCEntidades.IDentidade
LEFT JOIN tbLojas AS tbLojas ON tbLojas.id=tbCCEntidades.IDLoja
LEFT JOIN tbMoedas as tbMoedas ON tbMoedas.ID=tbccentidades.IDMoeda
LEFT JOIN tbParametrosEmpresa as P ON 1 = 1
LEFT JOIN tbMoedas as tbMoedasRef ON tbMoedasRef.ID=P.IDMoedaDefeito
LEFT JOIN tbTiposDocumento AS tbTiposDocumento ON tbTiposDocumento.ID=tbCCEntidades.IDTipoDocumento
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries ON tbTiposDocumentoSeries.ID=tbCCEntidades.IDTipoDocumentoSeries
ORDER BY tbCCEntidades.ID  OFFSET 0 ROWS ')

EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwCCFornecedores'')) drop view vwCCFornecedores')

EXEC('create view [dbo].[vwCCFornecedores] as
select 
tbFornecedores.Codigo as CodigoFornecedor,
tbCCFornecedores.NomeFiscal,
tbCCFornecedores.IDEntidade,
tbCCFornecedores.IDLoja,
tbCCFornecedores.IDTipoDocumento,
tbCCFornecedores.IDTipoDocumentoSeries,
tbCCFornecedores.NumeroDocumento,
tbCCFornecedores.DataDocumento,
tbCCFornecedores.Descricao as Documento,
tbCCFornecedores.IDMoeda,
tbCCFornecedores.Ativo as Ativo,
(case when tbCCFornecedores.Natureza=''R'' then ''Crédito'' else ''Débito'' end) as Natureza,  
(case when tbCCFornecedores.Natureza=''P'' then tbCCFornecedores.TotalMoedaReferencia else -(tbCCFornecedores.TotalMoedaReferencia) end) as TotalMoeda,
(case when tbCCFornecedores.Natureza=''P'' then tbCCFornecedores.TotalMoedaReferencia else -(tbCCFornecedores.TotalMoedaReferencia) end) as Valor,
(case when tbCCFornecedores.Natureza=''P'' then tbCCFornecedores.TotalMoedaReferencia else -(tbCCFornecedores.TotalMoedaReferencia) end) as TotalMoedaReferencia,
Round(isnull((
select Sum((Case tbCCSaldoAgreg.Natureza when ''P'' then 1 else -1 end) * tbCCSaldoAgreg.TotalMoedaReferencia) FROM tbCCFornecedores as tbCCSaldoAgreg
WHERE tbCCSaldoAgreg.IDEntidade= tbCCFornecedores.IDEntidade
AND (tbCCSaldoAgreg.Natureza =''P'' OR tbCCSaldoAgreg.Natureza =''R'')
AND tbCCSaldoAgreg.DataCriacao <= tbCCFornecedores.DataCriacao
AND ((tbCCSaldoAgreg.IDTipoDocumento<>tbCCFornecedores.IDTipoDocumento OR tbCCSaldoAgreg.IDDocumento <> tbCCFornecedores.IDDocumento
       ) OR (tbCCSaldoAgreg.IDTipoDocumento = tbCCFornecedores.IDTipoDocumento AND tbCCSaldoAgreg.IDDocumento = tbCCFornecedores.IDDocumento
                     AND tbCCSaldoAgreg.ID<=tbCCFornecedores.ID
                     )
       )
),0),isnull(tbMoedas.CasasDecimaisTotais,0)) as Saldo,
tbmoedas.descricao as tbMoedas_Descricao, 
tbmoedas.Simbolo as tbMoedas_Simbolo, 
tbmoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
tbmoedas.CasasDecimaisTotais as Saldonumcasasdecimais,
tbmoedas.CasasDecimaisTotais as TotalMoedanumcasasdecimais,
tbmoedas.CasasDecimaisTotais as TotalMoedaReferencianumcasasdecimais,
tblojas.Codigo as CodigoLoja,
tblojas.Descricao as DescricaoLoja
FROM tbCCFornecedores AS tbCCFornecedores
LEFT JOIN tbFornecedores AS tbFornecedores ON tbFornecedores.id=tbCCFornecedores.IDentidade
LEFT JOIN tbLojas AS tbLojas ON tbLojas.id=tbCCFornecedores.IDLoja
LEFT JOIN tbParametrosEmpresa as P ON 1 = 1
LEFT JOIN tbMoedas as tbMoedas ON tbMoedas.ID=P.IDMoedaDefeito
LEFT JOIN tbTiposDocumento AS tbTiposDocumento ON tbTiposDocumento.ID=tbCCFornecedores.IDTipoDocumento
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries ON tbTiposDocumentoSeries.ID=tbCCFornecedores.IDTipoDocumentoSeries
ORDER BY tbCCFornecedores.ID  OFFSET 0 ROWS ')


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

--mapa de iva
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
tbTiposDocumento.Descricao as DescricaoTipoDocumento,
tbTiposDocumentoSeries.CodigoSerie as DescricaoTipoDocumentoSerie, 
tbIVA.Codigo as CodigoIva, 
tbsistematiposestados.codigo as CodigoEstado,
tbsistematiposestados.descricao as DescricaoEstado,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIncidencia) as ValorIncidencia,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIVA) as ValorIVA,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIncidencia + tbDocumentosVendasLinhas.ValorIVA) as Valor,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
tbMoedas.CasasDecimaisTotais as ValorIncidencianumcasasdecimais,
tbMoedas.CasasDecimaisTotais as ValorIVAnumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Valornumcasasdecimais
FROM tbDocumentosVendas AS tbDocumentosVendas
INNER JOIN tbDocumentosVendasLinhas AS tbDocumentosVendasLinhas ON tbDocumentosVendas.id=tbDocumentosVendasLinhas.IDDocumentoVenda
INNER JOIN tbClientes AS tbClientes with (nolock) ON tbClientes.id=tbDocumentosVendas.IDentidade
INNER JOIN tbLojas AS tbLojas with (nolock) ON tbLojas.id=tbDocumentosVendas.IDLoja
INNER JOIN tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbdocumentosVendas.IDEstado
INNER JOIN tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
INNER JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosVendas.IDMoeda
INNER JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbDocumentosVendas.IDTipoDocumento AND not tbTiposDocumento.idsistematiposdocumentofiscal is null 
INNER JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbTiposDocumento.IDSistemaNaturezas=tbSistemaNaturezas.ID
INNER JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbDocumentosVendas.IDTiposDocumentoSeries
INNER JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbTiposDocumento.IDSistemaTiposDocumento=tbSistemaTiposDocumento.ID
INNER JOIN tbIVA AS tbIVA  with (nolock) ON tbDocumentosVendasLinhas.IDtaxaiva=tbIVA.ID
WHERE tbsistematiposestados.codigo<>''RSC'' and tbSistemaTiposDocumento.Tipo=''VndFinanceiro''
GROUP BY tbDocumentosVendas.ID, tbDocumentosVendas.IDLoja, tbDocumentosVendas.NomeFiscal, tbDocumentosVendas.IDEntidade, tbDocumentosVendas.IDTipoDocumento, tbDocumentosVendas.IDTiposDocumentoSeries, tbDocumentosVendas.NumeroDocumento,
tbDocumentosVendas.DataDocumento, tbDocumentosVendas.Documento, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbDocumentosVendas.Ativo, tbDocumentosVendasLinhas.TaxaIva, tbDocumentosVendasLinhas.IDTaxaIva,
tbLojas.Codigo, tbLojas.Descricao, tbClientes.Codigo, tbClientes.Nome, tbClientes.NContribuinte, tbTiposDocumento.Codigo,tbTiposDocumentoSeries.CodigoSerie,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end), 
tbSistemaNaturezas.Codigo, tbsistematiposestados.codigo,tbsistematiposestados.Descricao, tbTiposDocumento.Descricao, tbIVA.Codigo,tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao
ORDER BY tbDocumentosVendas.ID  OFFSET 0 ROWS ')

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
tbsistematiposestados.descricao as DescricaoEstado,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIncidencia) as ValorIncidencia,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIVA) as ValorIVA,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIncidencia + tbDocumentosComprasLinhas.ValorIVA) as Valor,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
tbMoedas.CasasDecimaisTotais as ValorIncidencianumcasasdecimais,
tbMoedas.CasasDecimaisTotais as ValorIVAnumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Valornumcasasdecimais
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
WHERE tbsistematiposestados.codigo=''EFT'' and tbSistemaTiposDocumento.Tipo=''CmpFinanceiro''
GROUP BY tbDocumentosCompras.ID, tbDocumentosCompras.IDLoja, tbDocumentosCompras.NomeFiscal, tbDocumentosCompras.IDEntidade, tbDocumentosCompras.IDTipoDocumento, tbDocumentosCompras.IDTiposDocumentoSeries, tbDocumentosCompras.NumeroDocumento,
tbDocumentosCompras.DataDocumento, tbDocumentosCompras.Documento, tbDocumentosCompras.IDMoeda, tbDocumentosCompras.TaxaConversao, tbDocumentosCompras.Ativo, tbDocumentosComprasLinhas.TaxaIva, tbDocumentosComprasLinhas.IDTaxaIva,
tbLojas.Codigo, tbLojas.Descricao, tbFornecedores.Codigo, tbFornecedores.Nome, tbFornecedores.NContribuinte, tbTiposDocumento.Codigo,tbTiposDocumentoSeries.CodigoSerie,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end), tbSistemaTiposEstados.Codigo, tbSistemaNaturezas.Codigo, tbsistematiposestados.codigo, tbsistematiposestados.Descricao, tbTiposDocumento.Descricao, 
 tbIVA.Codigo,tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao
ORDER BY tbDocumentosCompras.ID  OFFSET 0 ROWS ')

--pendentes
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
select Sum((Case tbCCSaldoAgreg.IDSistemaNaturezas when 6 then 1 else -1 end) * tbCCSaldoAgreg.ValorPendente * (Case D.CodigoTipoEstado when ''EFT'' then 1 else 0 end)) FROM tbDocumentosVendasPendentes as tbCCSaldoAgreg inner join tbDocumentosVendas as D on tbCCSaldoAgreg.IDDocumentoVenda=d.ID
WHERE tbCCSaldoAgreg.IDEntidade= tbDocumentosVendasPendentes.IDEntidade
AND tbCCSaldoAgreg.DataCriacao <= tbDocumentosVendasPendentes.DataCriacao
AND (tbCCSaldoAgreg.IDSistemaNaturezas in (6,7))
AND ((tbCCSaldoAgreg.IDTipoDocumento<>tbDocumentosVendasPendentes.IDTipoDocumento OR tbCCSaldoAgreg.IDDocumentoVenda <> tbDocumentosVendasPendentes.IDDocumentoVenda
       ) OR (tbCCSaldoAgreg.IDTipoDocumento = tbDocumentosVendasPendentes.IDTipoDocumento AND tbCCSaldoAgreg.IDDocumentoVenda = tbDocumentosVendasPendentes.IDDocumentoVenda
		AND tbCCSaldoAgreg.ID<=tbDocumentosVendasPendentes.ID))),0),isnull(tbMoedas.CasasDecimaisTotais,0)) as Saldo,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
datediff(day,tbDocumentosVendas.DataDocumento,getdate()) as NumeroDias,
tbMoedas.CasasDecimaisTotais as Valornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as ValorPendentenumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Saldonumcasasdecimais,
0 as NumeroDiasnumcasasdecimais
FROM tbDocumentosVendasPendentes AS tbDocumentosVendasPendentes with (nolock) 
LEFT JOIN  tbDocumentosVendas AS tbDocumentosVendas with (nolock) ON tbDocumentosVendas.id=tbDocumentosVendasPendentes.IDDocumentoVenda
LEFT JOIN  tbClientes AS tbClientes with (nolock) ON tbClientes.id=tbDocumentosVendas.IDentidade
LEFT JOIN  tbLojas AS tbLojas with (nolock) ON tbLojas.id=tbDocumentosVendas.IDLoja
LEFT JOIN  tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosVendas.IDMoeda
LEFT JOIN  tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbDocumentosVendas.IDTipoDocumento AND not tbTiposDocumento.idsistematiposdocumentofiscal is null 
LEFT JOIN  tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbTiposDocumento.IDSistemaNaturezas=tbSistemaNaturezas.ID
LEFT JOIN  tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbDocumentosVendas.IDTiposDocumentoSeries
LEFT JOIN  tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbTiposDocumento.IDSistemaTiposDocumento=tbSistemaTiposDocumento.ID
LEFT JOIN  tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbdocumentosvendas.IDEstado
LEFT JOIN  tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
WHERE tbsistematiposestados.codigo=''EFT'' and tbSistemaTiposDocumento.Tipo=''VndFinanceiro'' and isnull(tbDocumentosVendasPendentes.ValorPendente,0)>0
GROUP BY tbDocumentosVendas.ID, tbDocumentosVendas.IDLoja, tbDocumentosVendas.NomeFiscal, tbDocumentosVendas.IDEntidade, tbDocumentosVendas.IDTipoDocumento, tbDocumentosVendas.IDTiposDocumentoSeries, tbDocumentosVendas.NumeroDocumento,
tbDocumentosVendas.DataDocumento, tbDocumentosVendas.Documento, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbDocumentosVendas.Ativo, 
tbLojas.Codigo, tbLojas.Descricao, tbClientes.Codigo, tbClientes.Nome, tbClientes.NContribuinte, tbTiposDocumento.Codigo,tbTiposDocumentoSeries.CodigoSerie,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end),
tbSistemaNaturezas.Codigo, tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao,
isnull(tbDocumentosVendasPendentes.TotalMoedaDocumento, 0), isnull(tbDocumentosVendasPendentes.ValorPendente,0), isnull(tbDocumentosVendasPendentes.Pago, 0) 
,tbDocumentosVendasPendentes.IDEntidade, tbDocumentosVendasPendentes.DataCriacao,tbDocumentosVendasPendentes.IDTipoDocumento,tbDocumentosVendasPendentes.IDDocumentoVenda,tbDocumentosVendasPendentes.ID                    
ORDER BY tbDocumentosVendas.ID  OFFSET 0 ROWS ')


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
select Sum((Case tbCCSaldoAgreg.IDSistemaNaturezas when 12 then 1 else -1 end) * tbCCSaldoAgreg.ValorPendente * (Case D.CodigoTipoEstado when ''EFT'' then 1 else 0 end)) FROM tbDocumentosComprasPendentes as tbCCSaldoAgreg inner join tbDocumentosCompras as D on tbCCSaldoAgreg.IDDocumentoCompra=d.ID
WHERE tbCCSaldoAgreg.IDEntidade= tbDocumentosComprasPendentes.IDEntidade
AND tbCCSaldoAgreg.DataCriacao <= tbDocumentosComprasPendentes.DataCriacao
AND (tbCCSaldoAgreg.IDSistemaNaturezas in (12,13))
AND ((tbCCSaldoAgreg.IDTipoDocumento<>tbDocumentosComprasPendentes.IDTipoDocumento OR tbCCSaldoAgreg.IDDocumentoCompra <> tbDocumentosComprasPendentes.IDDocumentoCompra
       ) OR (tbCCSaldoAgreg.IDTipoDocumento = tbDocumentosComprasPendentes.IDTipoDocumento AND tbCCSaldoAgreg.IDDocumentoCompra = tbDocumentosComprasPendentes.IDDocumentoCompra
		AND tbCCSaldoAgreg.ID<=tbDocumentosComprasPendentes.ID))),0),isnull(tbMoedas.CasasDecimaisTotais,0)) as Saldo,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
datediff(day,tbDocumentosCompras.DataDocumento,getdate()) as NumeroDias,
tbMoedas.CasasDecimaisTotais as Valornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as ValorPendentenumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Saldonumcasasdecimais,
0 as NumeroDiasnumcasasdecimais
FROM tbDocumentosComprasPendentes AS tbDocumentosComprasPendentes with (nolock) 
LEFT JOIN  tbDocumentosCompras AS tbDocumentosCompras with (nolock) ON tbDocumentosCompras.id=tbDocumentosComprasPendentes.IDDocumentoCompra
LEFT JOIN  tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.id=tbDocumentosCompras.IDentidade
LEFT JOIN  tbLojas AS tbLojas with (nolock) ON tbLojas.id=tbDocumentosCompras.IDLoja
LEFT JOIN  tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosCompras.IDMoeda
LEFT JOIN  tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbDocumentosCompras.IDTipoDocumento AND not tbTiposDocumento.idsistematiposdocumentofiscal is null 
LEFT JOIN  tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbTiposDocumento.IDSistemaNaturezas=tbSistemaNaturezas.ID
LEFT JOIN  tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbDocumentosCompras.IDTiposDocumentoSeries
LEFT JOIN  tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbTiposDocumento.IDSistemaTiposDocumento=tbSistemaTiposDocumento.ID
LEFT JOIN  tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbDocumentosCompras.IDEstado
LEFT JOIN  tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
WHERE tbsistematiposestados.codigo=''EFT'' and tbSistemaTiposDocumento.Tipo=''CmpFinanceiro'' and isnull(tbDocumentosComprasPendentes.ValorPendente,0)>0
GROUP BY tbDocumentosCompras.ID, tbDocumentosCompras.IDLoja, tbDocumentosCompras.NomeFiscal, tbDocumentosCompras.IDEntidade, tbDocumentosCompras.IDTipoDocumento, tbDocumentosCompras.IDTiposDocumentoSeries, tbDocumentosCompras.NumeroDocumento,
tbDocumentosCompras.DataDocumento, tbDocumentosCompras.Documento, tbDocumentosCompras.IDMoeda, tbDocumentosCompras.TaxaConversao, tbDocumentosCompras.Ativo, 
tbLojas.Codigo, tbLojas.Descricao, tbFornecedores.Codigo, tbFornecedores.Nome, tbFornecedores.NContribuinte, tbTiposDocumento.Codigo,tbTiposDocumentoSeries.CodigoSerie,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end),
tbSistemaNaturezas.Codigo, tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao,
isnull(tbDocumentosComprasPendentes.TotalMoedaDocumento, 0), isnull(tbDocumentosComprasPendentes.ValorPendente,0), isnull(tbDocumentosComprasPendentes.Pago, 0) 
,tbDocumentosComprasPendentes.IDEntidade, tbDocumentosComprasPendentes.DataCriacao,tbDocumentosComprasPendentes.IDTipoDocumento,tbDocumentosComprasPendentes.IDDocumentoCompra,tbDocumentosComprasPendentes.ID                    
ORDER BY tbDocumentosCompras.ID  OFFSET 0 ROWS ')

--rankings
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaRankingVendas'')) drop view vwMapaRankingVendas')

EXEC('create view [dbo].[vwMapaRankingVendas] as
select 
tbClientes.Codigo as CodigoCliente,
tbClientes.Nome as NomeFiscal,
tbLojas.Codigo as CodigoLoja,
tbLojas.Descricao as DescricaoLoja,
tbMarcas.Codigo as CodigoMarca,
tbMarcas.Descricao as DescricaoMarca,
tbTiposArtigos.Codigo as CodigoTipoArtigo,
tbTiposArtigos.Descricao as DescricaoTipoArtigo,
tbArtigos.Codigo as CodigoArtigo,
tbArtigos.Descricao as DescricaoArtigo,
tbArtigosLotes.Codigo as CodigoLote,
tbArtigosLotes.Descricao as DescricaoLote,
tbFornecedores.Codigo as CodigoFornecedor,
tbFornecedores.Nome as DescricaoFornecedor,
tbdocumentosVendas.UtilizadorCriacao as Utilizador,
tbDocumentosVendas.IDMoeda, 
tbDocumentosVendas.TaxaConversao, 
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
Sum((case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Quantidade,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Valor,
Sum((isnull(tbdocumentosVendaslinhas.PrecoUnitarioMoedaRef,0)-isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivo,0))*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end))  as Desconto,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Liquido,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as TotalValor,
Sum(isnull(tbdocumentosVendaslinhas.PCMAtualMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as TotalCustoMedio,
tbMoedas.CasasDecimaisTotais as Valornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Descontonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Liquidonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as TotalValornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as TotalCustoMedionumcasasdecimais
FROM tbdocumentosVendas AS tbdocumentosVendas with (nolock) 
LEFT JOIN tbdocumentosVendaslinhas AS tbdocumentosVendaslinhas with (nolock) ON tbdocumentosVendaslinhas.iddocumentoVenda=tbdocumentosVendas.ID
LEFT JOIN tbArtigos AS tbArtigos with (nolock) ON tbArtigos.id=tbdocumentosVendaslinhas.IDArtigo
LEFT JOIN tbArtigosFornecedores AS tbArtigosFornecedores with (nolock) ON tbArtigos.id=tbArtigosFornecedores.IDArtigo and tbArtigosFornecedores.Ordem=1
LEFT JOIN tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.id=tbArtigosFornecedores.IDFornecedor and tbArtigosFornecedores.Ordem=1
LEFT JOIN tbMarcas as tbMarcas with (nolock) ON tbMarcas.ID=tbArtigos.IDMarca
LEFT JOIN tbLojas as tbLojas with (nolock) ON tbLojas.ID=tbdocumentosVendas.IDLoja
LEFT JOIN tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbdocumentosVendas.IDEstado
LEFT JOIN tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
LEFT JOIN tbUnidades as tbUnidades with (nolock) ON tbUnidades.ID=tbArtigos.IDUnidade
LEFT JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbdocumentosVendas.IDTipoDocumento
LEFT JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbSistemaTiposDocumento.ID=tbTiposDocumento.IDSistemaTiposDocumento
LEFT JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbSistemaNaturezas.ID=tbTiposDocumento.IDSistemaNaturezas
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbdocumentosVendas.IDTiposDocumentoSeries
LEFT JOIN tbArtigosLotes AS tbArtigosLotes with (nolock) ON tbArtigosLotes.ID = tbdocumentosVendaslinhas.IDLote
LEFT JOIN tbClientes AS tbClientes with (nolock) ON tbClientes.ID = tbdocumentosVendas.IDEntidade
LEFT JOIN tbtiposartigos AS tbtiposartigos with (nolock) ON tbtiposartigos.ID = tbArtigos.IDtipoartigo
LEFT JOIN tbParametrosEmpresa as P with (nolock) ON 1 = 1
LEFT JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=P.IDMoedaDefeito
where 
tbsistematiposestados.codigo=''EFT'' and tbsistematiposdocumento.tipo=''VndFinanceiro''
group by 
tbArtigos.Codigo,tbArtigos.Descricao,tbArtigosLotes.Codigo ,tbArtigosLotes.Descricao ,tbTiposArtigos.Codigo ,tbTiposArtigos.Descricao ,tbLojas.Codigo ,tbLojas.Descricao ,
tbClientes.Codigo ,tbClientes.Nome ,tbMarcas.Codigo,tbMarcas.Descricao,tbFornecedores.Codigo ,tbFornecedores.Nome ,tbdocumentosVendas.UtilizadorCriacao, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais')

EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaRankingCompras'')) drop view vwMapaRankingCompras')

EXEC('create view [dbo].[vwMapaRankingCompras] as
select 
tbFornecedores.Codigo as CodigoFornecedor,
tbFornecedores.Nome as NomeFiscal,
tbFornecedores.Nome as DescricaoFornecedor,
tbLojas.Codigo as CodigoLoja,
tbLojas.Descricao as DescricaoLoja,
tbMarcas.Codigo as CodigoMarca,
tbMarcas.Descricao as DescricaoMarca,
tbTiposArtigos.Codigo as CodigoTipoArtigo,
tbTiposArtigos.Descricao as DescricaoTipoArtigo,
tbArtigos.Codigo as CodigoArtigo,
tbArtigos.Descricao as DescricaoArtigo,
tbArtigosLotes.Codigo as CodigoLote,
tbArtigosLotes.Descricao as DescricaoLote,
tbdocumentoscompras.IDMoeda, 
tbdocumentoscompras.TaxaConversao, 
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
Sum((case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as Quantidade,
Sum(isnull(tbdocumentoscompraslinhas.PrecoUnitarioMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as Valor,
Sum((isnull(tbdocumentoscompraslinhas.PrecoUnitarioMoedaRef,0)-isnull(tbdocumentoscompraslinhas.PrecoUnitarioEfetivo,0))*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end))  as Desconto,
Sum(isnull(tbdocumentoscompraslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as Liquido,
Sum(isnull(tbdocumentoscompraslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as TotalValor,
Sum(isnull(tbdocumentoscompraslinhas.PCMAtualMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as TotalCustoMedio,
tbMoedas.CasasDecimaisTotais as Valornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Descontonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Liquidonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as TotalValornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as TotalCustoMedionumcasasdecimais
FROM tbdocumentoscompras AS tbdocumentoscompras with (nolock) 
LEFT JOIN tbdocumentoscompraslinhas AS tbdocumentoscompraslinhas with (nolock) ON tbdocumentoscompraslinhas.iddocumentocompra=tbdocumentoscompras.ID
LEFT JOIN tbArtigos AS tbArtigos with (nolock) ON tbArtigos.id=tbdocumentoscompraslinhas.IDArtigo
LEFT JOIN tbMarcas as tbMarcas with (nolock) ON tbMarcas.ID=tbArtigos.IDMarca
LEFT JOIN tbLojas as tbLojas with (nolock) ON tbLojas.ID=tbdocumentoscompras.IDLoja
LEFT JOIN tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbdocumentoscompras.IDEstado
LEFT JOIN tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
LEFT JOIN tbUnidades as tbUnidades with (nolock) ON tbUnidades.ID=tbArtigos.IDUnidade
LEFT JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbdocumentoscompras.IDTipoDocumento
LEFT JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbSistemaTiposDocumento.ID=tbTiposDocumento.IDSistemaTiposDocumento
LEFT JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbSistemaNaturezas.ID=tbTiposDocumento.IDSistemaNaturezas
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbdocumentoscompras.IDTiposDocumentoSeries
LEFT JOIN tbArtigosLotes AS tbArtigosLotes with (nolock) ON tbArtigosLotes.ID = tbdocumentoscompraslinhas.IDLote
LEFT JOIN tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.ID = tbdocumentoscompras.IDEntidade
LEFT JOIN tbtiposartigos AS tbtiposartigos with (nolock) ON tbtiposartigos.ID = tbArtigos.IDtipoartigo
LEFT JOIN tbParametrosEmpresa as P with (nolock) ON 1 = 1
LEFT JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=P.IDMoedaDefeito
where 
tbsistematiposestados.codigo=''EFT'' and tbsistematiposdocumento.tipo=''CmpFinanceiro''
group by 
tbArtigos.Codigo,tbArtigos.Descricao,tbArtigosLotes.Codigo ,tbArtigosLotes.Descricao ,tbTiposArtigos.Codigo ,tbTiposArtigos.Descricao ,tbLojas.Codigo ,tbLojas.Descricao ,tbFornecedores.Codigo ,tbFornecedores.Nome ,tbMarcas.Codigo,tbMarcas.Descricao,
tbdocumentoscompras.IDMoeda, tbdocumentoscompras.TaxaConversao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais')


EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaMargemVendas'')) drop view vwMapaMargemVendas')

EXEC('create view [dbo].[vwMapaMargemVendas] as
select 
tbLojas.Codigo as CodigoLoja,
tbLojas.Descricao as DescricaoLoja,
tbMarcas.Codigo as CodigoMarca,
tbMarcas.Descricao as DescricaoMarca,
tbTiposArtigos.Codigo as CodigoTipoArtigo,
tbTiposArtigos.Descricao as DescricaoTipoArtigo,
tbArtigos.Codigo as CodigoArtigo,
tbArtigos.Descricao as DescricaoArtigo,
tbFornecedores.Codigo as CodigoFornecedor,
tbFornecedores.Nome as DescricaoFornecedor,
tbDocumentosVendas.IDMoeda, 
tbDocumentosVendas.TaxaConversao, 
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
tbMoedas.CasasDecimaisTotais as ValorVendanumcasasdecimais,
tbMoedas.CasasDecimaisTotais as PrecoCustonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as ValorCustonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as ValorMargemnumcasasdecimais,
tbUnidades.NumeroDeCasasDecimais as Quantidadenumcasasdecimais,
Sum((case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Quantidade,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as ValorVenda,
Sum(isnull(tbdocumentosVendaslinhas.UPCMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as PrecoCusto,
Sum(isnull(tbdocumentosVendaslinhas.PCMAtualMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as ValorCusto

,(Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) 
-Sum(isnull(tbdocumentosVendaslinhas.PCMAtualMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end))) 
as ValorMargem

,cast((case when (Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)))=0 then 0 
else
(Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) 
-Sum(isnull(tbdocumentosVendaslinhas.PCMAtualMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)))*100
/(Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end))) 
end) as decimal(30,2)) as Margem

FROM tbdocumentosVendas AS tbdocumentosVendas with (nolock) 
LEFT JOIN tbdocumentosVendaslinhas AS tbdocumentosVendaslinhas with (nolock) ON tbdocumentosVendaslinhas.iddocumentoVenda=tbdocumentosVendas.ID
LEFT JOIN tbUnidades as tbUnidades with (nolock) ON tbUnidades.id=tbdocumentosVendaslinhas.IDUnidade
LEFT JOIN tbArtigos AS tbArtigos with (nolock) ON tbArtigos.id=tbdocumentosVendaslinhas.IDArtigo
LEFT JOIN tbArtigosFornecedores AS tbArtigosFornecedores with (nolock) ON tbArtigos.id=tbArtigosFornecedores.IDArtigo and tbArtigosFornecedores.Ordem=1
LEFT JOIN tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.id=tbArtigosFornecedores.IDFornecedor and tbArtigosFornecedores.Ordem=1
LEFT JOIN tbMarcas as tbMarcas with (nolock) ON tbMarcas.ID=tbArtigos.IDMarca
LEFT JOIN tbLojas as tbLojas with (nolock) ON tbLojas.ID=tbdocumentosVendas.IDLoja
LEFT JOIN tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbdocumentosVendas.IDEstado
LEFT JOIN tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
LEFT JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbdocumentosVendas.IDTipoDocumento
LEFT JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbSistemaTiposDocumento.ID=tbTiposDocumento.IDSistemaTiposDocumento
LEFT JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbSistemaNaturezas.ID=tbTiposDocumento.IDSistemaNaturezas
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbdocumentosVendas.IDTiposDocumentoSeries
LEFT JOIN tbArtigosLotes AS tbArtigosLotes with (nolock) ON tbArtigosLotes.ID = tbdocumentosVendaslinhas.IDLote
LEFT JOIN tbClientes AS tbClientes with (nolock) ON tbClientes.ID = tbdocumentosVendas.IDEntidade
LEFT JOIN tbtiposartigos AS tbtiposartigos with (nolock) ON tbtiposartigos.ID = tbArtigos.IDtipoartigo
LEFT JOIN tbParametrosEmpresa as P with (nolock) ON 1 = 1
LEFT JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=P.IDMoedaDefeito
where tbsistematiposestados.codigo=''EFT'' and tbsistematiposdocumento.tipo=''VndFinanceiro''
group by 
tbLojas.Codigo,tbLojas.Descricao,tbTiposArtigos.Codigo,tbTiposArtigos.Descricao, tbMarcas.Codigo,tbMarcas.Descricao,tbFornecedores.Codigo ,tbFornecedores.Nome,tbArtigos.Codigo,tbArtigos.Descricao, 
tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbUnidades.NumeroDeCasasDecimais')


---DOCUMENTOS DE VENDA LINHAS DIMENSOES
CREATE TABLE [dbo].[tbDocumentosVendasLinhasDimensoes](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [IDDocumentoVendaLinha] [bigint] NOT NULL,
    [IDArtigoDimensao] [bigint] NOT NULL,
    [Quantidade] [float] NULL,
    [PrecoUnitario] [float] NULL,
    [PrecoUnitarioEfetivo] [float] NULL,
    [Ordem] [int] NOT NULL,
    [Sistema] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosVendasLinhasDimensoes_Sistema]  DEFAULT ((0)),
    [Ativo] [bit] NOT NULL CONSTRAINT [DF_tbDocumentosVendasLinhasDimensoes_Ativo]  DEFAULT ((1)),
    [DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbDocumentosVendasLinhasDimensoes_DataCriacao]  DEFAULT (getdate()),
    [UtilizadorCriacao] [nvarchar](20) NOT NULL CONSTRAINT [DF_tbDocumentosVendasLinhasDimensoes_UtilizadorCriacao]  DEFAULT (''),
    [DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbDocumentosVendasLinhasDimensoes_DataAlteracao]  DEFAULT (getdate()),
    [UtilizadorAlteracao] [nvarchar](20) NULL CONSTRAINT [DF_tbDocumentosVendasLinhasDimensoes_UtilizadorAlteracao]  DEFAULT (''),
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
    [QuantidadeSatisfeita] [float] NULL,
    [QuantidadeDevolvida] [float] NULL,
    [Satisfeito] [bit] NULL,
    [IDLinhaDimensaoDocumentoVenda] [bigint] NULL,
    [IDLinhaDimensaoDocumentoStock] [bigint] NULL,
    [IDLinhaDimensaoDocumentoVendaInicial] [bigint] NULL,
    [IDLinhaDimensaoDocumentoStockInicial] [bigint] NULL,
    [QtdStockSatisfeita] [float] NULL,
    [QtdStockDevolvida] [float] NULL,
    [QtdStockAcerto] [float] NULL,
    [QtdStock2Satisfeita] [float] NULL,
    [QtdStock2Devolvida] [float] NULL,
    [QtdStock2Acerto] [float] NULL,
    [IDLinhaDimensaoDocumentoOrigem] [bigint] NULL,
    [QtdStockReserva] [float] NULL,
    [QtdStockReserva2Uni] [float] NULL,
 CONSTRAINT [PK_tbDocumentosVendasLinhasDimensoes] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[tbDocumentosVendasLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhasDimensoes_tbArtigosDimensoes] FOREIGN KEY([IDArtigoDimensao])
REFERENCES [dbo].[tbArtigosDimensoes] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhasDimensoes_tbArtigosDimensoes]
ALTER TABLE [dbo].[tbDocumentosVendasLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhasDimensoes_tbDocumentosVendasLinhas] FOREIGN KEY([IDDocumentoVendaLinha])
REFERENCES [dbo].[tbDocumentosVendasLinhas] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhasDimensoes_tbDocumentosVendasLinhas]
ALTER TABLE [dbo].[tbDocumentosVendasLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhasDimensoes_tbDocumentosVendasLinhasDimensoes] FOREIGN KEY([IDLinhaDimensaoDocumentoVenda])
REFERENCES [dbo].[tbDocumentosVendasLinhasDimensoes] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhasDimensoes_tbDocumentosVendasLinhasDimensoes]
ALTER TABLE [dbo].[tbDocumentosVendasLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhasDimensoes_tbDocumentosVendasLinhasDimensoesInicial] FOREIGN KEY([IDLinhaDimensaoDocumentoVendaInicial])
REFERENCES [dbo].[tbDocumentosVendasLinhasDimensoes] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhasDimensoes_tbDocumentosVendasLinhasDimensoesInicial]
ALTER TABLE [dbo].[tbDocumentosVendasLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhasDimensoes_tbDocumentosStockLinhasDimensoes] FOREIGN KEY([IDLinhaDimensaoDocumentoStock])
REFERENCES [dbo].[tbDocumentosStockLinhasDimensoes] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhasDimensoes_tbDocumentosStockLinhasDimensoes]
ALTER TABLE [dbo].[tbDocumentosVendasLinhasDimensoes]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhasDimensoes_tbDocumentosStockLinhasDimensoesInicial] FOREIGN KEY([IDLinhaDimensaoDocumentoStockInicial])
REFERENCES [dbo].[tbDocumentosStockLinhasDimensoes] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhasDimensoes] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhasDimensoes_tbDocumentosStockLinhasDimensoesInicial]


EXEC('UPDATE [dbo].[tbSistemaTiposDocumento] SET Tipo=''CntCorrLiquidacaoClt'',ActivaPredefTipoDoc = 1, Descricao = ''LiquidacaoCliente'' WHERE Tipo = ''CntCorrLiquidacao'' And Descricao=''Liquidacao''')
EXEC('DECLARE @IDSistTipoDoc As BIGINT
DECLARE @IDSistMod As BIGINT
SELECT @IDSistTipoDoc = MAX(ID) + 1  FROM [dbo].[tbSistemaTiposDocumento]
SELECT @IDSistMod = ID  FROM [dbo].[tbSistemaModulos] Where Codigo = ''006''
INSERT INTO tbSistemaTiposDocumento(ID ,Tipo ,Descricao, IDModulo ,Sistema,Ativo,DataCriacao ,UtilizadorCriacao,TipoFiscal, ActivaPredefTipoDoc)
VALUES (@IDSistTipoDoc,''CntCorrLiquidacaoFnd'',''LiquidacaoFornecedor'',@IDSistMod, 1, 1, getdate(),''F3M'',1,1)')

EXEC('UPDATE [dbo].[tbSistemaNaturezas] SET TipoDoc=''CntCorrLiquidacaoClt'' WHERE Modulo = ''006''')
EXEC('DECLARE @IDSistNat As BIGINT
SELECT @IDSistNat = MAX(ID) + 1  FROM [dbo].[tbSistemaNaturezas]
INSERT INTO tbSistemaNaturezas(ID ,Codigo ,Descricao, Modulo ,TipoDoc, Sistema,Ativo,DataCriacao ,UtilizadorCriacao)
VALUES (@IDSistNat,''P'',''AReceber'', ''006'',''CntCorrLiquidacaoFnd'',1, 1, getdate(),''F3M'')
SELECT @IDSistNat = MAX(ID) + 1  FROM [dbo].[tbSistemaNaturezas]
INSERT INTO tbSistemaNaturezas(ID ,Codigo ,Descricao, Modulo ,TipoDoc, Sistema,Ativo,DataCriacao ,UtilizadorCriacao)
VALUES (@IDSistNat,''R'',''APagar'', ''006'',''CntCorrLiquidacaoFnd'',1, 1, getdate(),''F3M'')')

EXEC('UPDATE  tbTiposDocumento SET  IDSistemaTiposDocumento = (select ID FROM tbSistemaTiposDocumento where Tipo=''CntCorrLiquidacaoClt'') 
FROM tbTiposDocumento as TDoc
LEFT JOIN [dbo].[tbTiposDocumentoTipEntPermDoc] as TipoEnt ON TipoEnt.IDTiposDocumento =TDoc.ID
LEFT JOIN tbSistemaModulos as Modu ON Modu.ID = TDoc.idModulo
left join [tbSistemaTiposEntidadeModulos] as stent ON stent.ID = TipoEnt.IDSistemaTiposEntidadeModulos and stent.IDSistemaModulos = Modu.ID
left join [tbSistemaTiposEntidade] as ent on ent.id = stent.IDSistemaTiposEntidade 
where Modu.Codigo=''006'' and ent.codigo=''Clt'' and NOT TDoc.ID is null')

EXEC('UPDATE  tbTiposDocumento SET  IDSistemaTiposDocumento = (select ID FROM tbSistemaTiposDocumento where Tipo=''CntCorrLiquidacaoFnd'') 
FROM tbTiposDocumento as TDoc
LEFT JOIN [dbo].[tbTiposDocumentoTipEntPermDoc] as TipoEnt ON TipoEnt.IDTiposDocumento =TDoc.ID
LEFT JOIN tbSistemaModulos as Modu ON Modu.ID = TDoc.idModulo
left join [tbSistemaTiposEntidadeModulos] as stent ON stent.ID = TipoEnt.IDSistemaTiposEntidadeModulos and stent.IDSistemaModulos = Modu.ID
left join [tbSistemaTiposEntidade] as ent on ent.id = stent.IDSistemaTiposEntidade 
where Modu.Codigo=''006'' and ent.codigo=''Fnd'' and NOT TDoc.ID is null')

EXEC('DECLARE @IDSistTipoDocFis As BIGINT
DECLARE @IDSitTipoDocFnd As BIGINT
SELECT @IDSistTipoDocFis = MAX(ID) + 1  FROM [dbo].[tbSistemaTiposDocumentoFiscal]
SELECT @IDSitTipoDocFnd = ID  FROM [dbo].[tbSistemaTiposDocumento] Where Tipo = ''CntCorrLiquidacaoFnd''
INSERT INTO tbSistemaTiposDocumentoFiscal(ID ,Tipo ,Descricao, IDTipoDocumento , Sistema,Ativo,DataCriacao ,UtilizadorCriacao)
VALUES (@IDSistTipoDocFis,''RC'',''RecRegimeIvaCx'', @IDSitTipoDocFnd,1, 1, getdate(),''F3M'')
SELECT @IDSistTipoDocFis = MAX(ID) + 1  FROM [dbo].[tbSistemaTiposDocumentoFiscal]
INSERT INTO tbSistemaTiposDocumentoFiscal(ID ,Tipo ,Descricao, IDTipoDocumento , Sistema,Ativo,DataCriacao ,UtilizadorCriacao)
VALUES (@IDSistTipoDocFis,''RG'',''OutRecEmitidos'', @IDSitTipoDocFnd,1, 1, getdate(),''F3M'')')


EXEC('UPDATE  tbTiposDocumento SET IDSistemaTiposDocumentoFiscal = (select id FROM tbSistemaTiposDocumentoFiscal where idtipodocumento=20 and tipo=''RG'') 
FROM tbTiposDocumento as TDoc
LEFT JOIN [dbo].[tbTiposDocumentoTipEntPermDoc] as TipoEnt ON TipoEnt.IDTiposDocumento =TDoc.ID
LEFT JOIN tbSistemaModulos as Modu ON Modu.ID = TDoc.idModulo
left join [tbSistemaTiposEntidadeModulos] as stent ON stent.ID = TipoEnt.IDSistemaTiposEntidadeModulos and stent.IDSistemaModulos = Modu.ID
left join [tbSistemaTiposEntidade] as ent on ent.id = stent.IDSistemaTiposEntidade 
where Modu.Codigo=''006'' and ent.codigo=''Fnd'' and NOT TDoc.ID is null')

EXEC('UPDATE  tbTiposDocumento SET IDSistemaTiposDocumentoFiscal = (select id FROM tbSistemaTiposDocumentoFiscal where idtipodocumento=15 and tipo=''RG'') 
FROM tbTiposDocumento as TDoc
LEFT JOIN [dbo].[tbTiposDocumentoTipEntPermDoc] as TipoEnt ON TipoEnt.IDTiposDocumento =TDoc.ID
LEFT JOIN tbSistemaModulos as Modu ON Modu.ID = TDoc.idModulo
left join [tbSistemaTiposEntidadeModulos] as stent ON stent.ID = TipoEnt.IDSistemaTiposEntidadeModulos and stent.IDSistemaModulos = Modu.ID
left join [tbSistemaTiposEntidade] as ent on ent.id = stent.IDSistemaTiposEntidade 
where Modu.Codigo=''006'' and ent.codigo=''Clt'' and NOT TDoc.ID is null')

EXEC('UPDATE [F3MOGeral].[dbo].[tbListasPersonalizadas]  SET Descricao = ''Liquidação Fornecedores'' WHERE Descricao=''Pagamentos de Compras''')

EXEC('BEGIN
DECLARE @ID as bigint
SELECT @ID=ID FROM [dbo].[tbSistemaTiposDocumentoFiscal] WHERE Descricao=''Orcamento''
UPDATE [dbo].[tbTiposDocumento] set IDSistemaTiposDocumentoFiscal=@ID WHERE Descricao=''Orçamento de Venda'' AND IDModulo=4 AND IDSistemaTiposDocumento=11
END')

EXEC('BEGIN
DECLARE @ID as bigint
SELECT @ID=ID FROM [dbo].[tbSistemaTiposDocumentoFiscal] WHERE Descricao=''FaturaProForma''
UPDATE [dbo].[tbTiposDocumento] set IDSistemaTiposDocumentoFiscal=@ID WHERE Descricao=''Fatura Pró-Forma'' AND IDModulo=4 AND IDSistemaTiposDocumento=14
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
    SELECT     @bitUltimoPrecoCusto = isnull(TD.UltimoPrecoCusto,0)
    FROM tbTiposDocumento TD
    LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TD.IDSistemaTiposDocumentoMovStock
    WHERE TD.ID=@lngidTipoDocumento and TDMS.Codigo = ''002''
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
                                    SELECT Linhas.IDArtigo, Max(isnull(Linhas.Ordem,0)) AS Ordem FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas
                                    LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + ''
                                    LEFT JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = Cab.IDTipoDocumento
                                    WHERE NOT Linhas.IDArtigo is NULL and Cab.IDTipoDocumento = '' + Convert(nvarchar,@lngidTipoDocumento) + '' AND Linhas.'' + @strCampoRelTabelaLinhasCab + '' = '' + Convert(nvarchar,@lngidDocumento) +
                                    '' AND isnull(TPDoc.DocNaoValorizado,0) = 0  
                                    GROUP BY Linhas.IDArtigo
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

--listas personalizadas de clientes
exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''select tbclientes.ID, tbclientes.Codigo, tbclientes.Nome, tbclientes.NContribuinte, tbclientes.Ativo, mt.Nome as DescricaoMedicoTecnico, tbclientes.Datanascimento, convert(nvarchar(MAX), tbclientes.Datanascimento, 105) as DiaNascimento, cc.Telefone, cc.Telemovel, en.Descricao as DescricaoEntidade1, et.Descricao as DescricaoEntidade2, lj.descricao as DescricaoLoja, isnull(tbclientes.saldo, 0) as Saldo, tbclientes.IdTipoEntidade, cast(tbclientes.nome as nvarchar(100)) as DescricaoSplitterLadoDireito 
from tbclientes  
left join tbLojas lj on tbclientes.idloja=lj.id
left join tbMedicosTecnicos mt on tbclientes.idmedicotecnico=mt.id
left join tbentidades en on tbclientes.identidade1=en.id
left join tbentidades et on tbclientes.identidade2=et.id
left join tbclientescontatos cc on tbclientes.id=cc.idcliente and cc.ordem=1''
where id in (25,66,68)')

EXEC('UPDATE [dbo].[tbSistemaTiposDocumento] SET ATIVO=0 WHERE Tipo=''CntCorrAdiantamento''')
EXEC('update tbDocumentosStockLinhas set ValorIncidencia=precounitarioefetivo*Quantidade, Valoriva=cast(precounitarioefetivo*Quantidade*TaxaIva/100 as decimal(30,2)) from tbDocumentosStockLinhas where cast(ValorIncidencia as decimal(30,2))<> cast(precounitarioefetivo*Quantidade as decimal(30,2))') 
EXEC('update tbSistemaTiposDocumento set ativo=0 where tipo in (''VndTransporte'')')

--data de entrega
ALTER TABLE [dbo].[tbDocumentosCompras] ADD [DataEntrega] [DateTime] NULL
ALTER TABLE [dbo].[tbDocumentosStock] ADD [DataEntrega] [DateTime] NULL
ALTER TABLE [dbo].[tbDocumentosVendas] ADD [DataEntrega] [DateTime] NULL
ALTER TABLE [dbo].[tbDocumentosComprasLinhas] ADD [DataEntrega] [DateTime] NULL
ALTER TABLE [dbo].[tbDocumentosStockLinhas] ADD [DataEntrega] [DateTime] NULL
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD [DataEntrega] [DateTime] NULL
ALTER TABLE tbMapasVistas DROP COLUMN MapaXML 
ALTER TABLE tbMapasVistas ADD MapaXML nvarchar(max)
ALTER TABLE tbMapasVistas ADD MapaBin varbinary(max)


--Recálculo de Artigos
CREATE NONCLUSTERED INDEX [IX_tbCCStockArtigos_IDArtigo] ON [dbo].[tbCCStockArtigos]
(
	[IDArtigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

--drop table tbF3MRecalculo
CREATE TABLE [dbo].[tbF3MRecalculo](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDRecalculo] bigint NOT NULL,
	[IDArtigo] bigint NOT NULL,
	[IDArtigoDimensao] bigint NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbF3MRecalculo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbF3MRecalculo] ADD  CONSTRAINT [DF_tbF3MRecalculo_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbF3MRecalculo] ADD  CONSTRAINT [DF_tbF3MRecalculo_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbF3MRecalculo] ADD  CONSTRAINT [DF_tbF3MRecalculo_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbF3MRecalculo] ADD  CONSTRAINT [DF_tbF3MRecalculo_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbF3MRecalculo] ADD  CONSTRAINT [DF_tbF3MRecalculo_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbF3MRecalculo] ADD  CONSTRAINT [DF_tbF3MRecalculo_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]


EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_Recalculo_AtualizaArtigos]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_Recalculo_AtualizaArtigos]')

EXEC('CREATE PROCEDURE [dbo].[sp_Recalculo_AtualizaArtigos]  
	@IDRecalculo as bigint,
	@strUtilizador AS nvarchar(256) = ''F3M'',
	@strTabelaLinhasDist AS nvarchar(250) = ''''

AS  BEGIN
	delete tbArtigosStock from tbArtigosStock inner join tbf3mrecalculo on tbArtigosStock.idartigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo  

	--inserir os registos que nao existem ainda na tabela
	INSERT INTO tbArtigosStock(IDArtigo, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao) 
	SELECT distinct CCART.IDArtigo,1 AS Ativo,1 AS Sistema, getdate() AS DataCriacao , @strUtilizador as UtilizadorCriacao, getdate() AS DataAlteracao, @strUtilizador AS UtilizadorAlteracao
	FROM tbCCStockArtigos AS CCART INNER JOIN tbF3MRecalculo on CCART.IDArtigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo
	LEFT JOIN tbArtigosStock AS ArtStok ON ArtStok.IDArtigo=CCART.IDArtigo
	WHERE ArtStok.IDArtigo is NULL 

	--atualiza valores
	UPDATE tbArtigosStock SET UltimaEntrada = ArtigosEntradas.DataUltimaEntrada,
								PrimeiraEntrada = ArtigosEntradas.DataPrimeiraEntrada,
								UltimaSaida = ArtigosSaidas.DataUltimaSaida,
								PrimeiraSaida = ArtigosSaidas.DataPrimeiraSaida
	FROM tbArtigosStock AS ArtStok
	LEFT JOIN tbArtigos As ART ON ART.ID=ArtStok.IDArtigo
	INNER JOIN (SELECT Distinct tbCCStockArtigos.IDArtigo FROM tbCCStockArtigos inner join tbF3MRecalculo on tbCCStockArtigos.IDArtigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo) AS AR ON AR.IDArtigo = ArtStok.IDArtigo
	LEFT JOIN (
			SELECT TCCS.IDArtigo, MAX(TCCS.DataControloInterno) AS DataUltimaSaida, MIN(TCCS.DataControloInterno) AS DataPrimeiraSaida
			FROM tbCCStockArtigos AS TCCS
			INNER JOIN 
			(SELECT distinct tbCCStockArtigos.IDArtigo FROM tbCCStockArtigos inner join tbF3MRecalculo on tbCCStockArtigos.IDArtigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo) AS CCAS
			ON CCAS.IDArtigo= TCCS.IDArtigo
			WHERE TCCS.Natureza=''S''
			GROUP BY TCCS.IDArtigo
			) AS ArtigosSaidas
	ON (ArtigosSaidas.IDArtigo = ArtStok.IDArtigo)
	LEFT JOIN (
			SELECT TCC.IDArtigo, MAX(TCC.DataControloInterno) AS DataUltimaEntrada, MIN(TCC.DataControloInterno) AS DataPrimeiraEntrada
			FROM tbCCStockArtigos AS TCC
			INNER JOIN 
			(SELECT distinct tbCCStockArtigos.IDArtigo FROM tbCCStockArtigos inner join tbF3MRecalculo on tbCCStockArtigos.IDArtigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo) AS CCA
			ON CCA.IDArtigo= TCC.IDArtigo
			WHERE TCC.Natureza=''E''
			GROUP BY TCC.IDArtigo
			) AS ArtigosEntradas
	ON (ArtigosEntradas.IDArtigo = ArtStok.IDArtigo)
	WHERE isnull(ART.GereStock,0)<>0

	--Atualiza custo medio com base no ultimo registo de CCartigos
	UPDATE tbArtigos SET Medio = CCAT.PCMAtualMoedaRef
	FROM tbArtigos AS ArtStok
	INNER JOIN (SELECT Distinct tbCCStockArtigos.IDArtigo FROM tbCCStockArtigos inner join tbF3MRecalculo on tbCCStockArtigos.IDArtigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo) AS AR ON AR.IDArtigo = ArtStok.ID
	LEFT JOIN ( 
		SELECT distinct CC.IDArtigo,isnull(CC.PCMAtualMoedaRef ,0) AS PCMAtualMoedaRef
		FROM tbCCStockArtigos AS CC
		INNER JOIN (
		SELECT  TCC.IDArtigo, Max(TCC.DataControloInterno) AS Data
		FROM tbCCStockArtigos AS TCC
		INNER JOIN 
			(SELECT distinct tbCCStockArtigos.IDArtigo FROM tbCCStockArtigos inner join tbF3MRecalculo on tbCCStockArtigos.IDArtigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo) AS CCA
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
			INNER JOIN (SELECT Distinct tbCCStockArtigos.IDArtigo, tbCCStockArtigos.IDArtigoDimensao FROM tbCCStockArtigos inner join tbF3MRecalculo on tbCCStockArtigos.IDArtigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo WHERE NOT tbCCStockArtigos.IDArtigoDimensao IS NULL) AS AR ON AR.IDArtigo = ArtStok.IDArtigo AND AR.IDArtigoDimensao = ArtStok.ID
			LEFT JOIN ( 
				SELECT distinct CC.IDArtigo, CC.IDArtigoDimensao, isnull(CC.PCMAtualMoedaRef ,0) AS PCMAtualMoedaRef
				FROM tbCCStockArtigos AS CC
				INNER JOIN (
				SELECT  TCC.IDArtigo, TCC.IDArtigoDimensao, Max(TCC.DataControloInterno) AS Data
				FROM tbCCStockArtigos AS TCC
				INNER JOIN 
					(SELECT distinct tbCCStockArtigos.IDArtigo, tbCCStockArtigos.IDArtigoDimensao FROM tbCCStockArtigos inner join tbF3MRecalculo on tbCCStockArtigos.IDArtigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo WHERE NOT tbCCStockArtigos.IDArtigoDimensao IS NULL) AS CCA
					ON CCA.IDArtigo= TCC.IDArtigo AND CCA.IDArtigoDimensao = TCC.IDArtigoDimensao
					INNER JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = TCC.IDTipoDocumento
					WHERE (TCC.Natureza=''E'') AND isnull(TPDoc.CustoMedio,0)<>0 AND NOT TCC.IDArtigoDimensao IS NULL
					GROUP BY TCC.IDArtigo, TCC.IDArtigoDimensao
				) CCU
				ON CCU.IDArtigo = CC.IDArtigo AND CCU.Data = CC.DataControloInterno AND CCU.IDArtigoDimensao = CC.IDArtigoDimensao
			) AS CCAT
			ON CCAT.IDArtigo = ArtStok.IDArtigo AND CCAT.IDArtigoDimensao = ArtStok.ID
		END	
			
		UPDATE tbArtigosStock SET Atual= Round(ST.StockAtual,6), StockAtual2 = Round(ST.StockAtual2,6)  FROM tbArtigosStock as ArtSt
		LEFT JOIN tbArtigos As ART ON ART.ID=ArtSt.IDArtigo
		INNER JOIN (
		SELECT 	SART.IDArtigo, SUM(isnull(QuantidadeStock,0)) AS StockAtual, SUM(isnull(QuantidadeStock2,0)) AS StockAtual2 FROM tbStockArtigos AS SART
		INNER JOIN
		(SELECT distinct tbCCStockArtigos.IDArtigo FROM tbCCStockArtigos inner join tbF3MRecalculo on tbCCStockArtigos.IDArtigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo) AS CCART
		ON SART.IDArtigo = CCART.IDArtigo
		GROUP BY SART.IDArtigo
		) AS ST
		ON ArtSt.IDArtigo = ST.IDArtigo
		WHERE isnull(ART.GereStock,0)<>0 

		IF len(@strTabelaLinhasDist)>0
			BEGIN
				UPDATE tbArtigosDimensoes SET StkArtigo= Round(ST.StockAtual,6), StkArtigo2=Round(ST.StockAtual2,6) FROM tbArtigosDimensoes as ArtSt
				LEFT JOIN tbArtigos As ART ON ART.ID=ArtSt.IDArtigo
				INNER JOIN (
				SELECT 	SART.IDArtigo, SART.IDArtigoDimensao, SUM(isnull(QuantidadeStock,0)) AS StockAtual, SUM(isnull(QuantidadeStock2,0)) AS StockAtual2 FROM tbStockArtigos AS SART
				INNER JOIN
				(SELECT distinct tbCCStockArtigos.IDArtigo, tbCCStockArtigos.IDArtigoDimensao FROM tbCCStockArtigos inner join tbF3MRecalculo on tbCCStockArtigos.IDArtigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo WHERE NOT tbCCStockArtigos.IDArtigoDimensao IS NULL) AS CCART
				ON SART.IDArtigo = CCART.IDArtigo AND SART.IDArtigoDimensao = CCART.IDArtigoDimensao
				WHERE NOT SART.IDArtigoDimensao IS NULL
				GROUP BY SART.IDArtigo, SART.IDArtigoDimensao
				) AS ST
				ON ArtSt.IDArtigo = ST.IDArtigo AND ArtSt.ID = ST.IDArtigoDimensao
				WHERE isnull(ART.GereStock,0)<>0 
			END
END')

EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_Recalculo_AtualizaStock]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_Recalculo_AtualizaStock]')

EXEC('CREATE PROCEDURE [dbo].[sp_Recalculo_AtualizaStock]  
	@IDRecalculo as bigint,
	@strUtilizador AS nvarchar(256) = ''F3M''

AS  BEGIN
	delete tbStockArtigos from tbStockArtigos inner join tbf3mrecalculo on tbStockArtigos.idartigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo

	--inserir a zero os registos que nao existem das chaves nos totais
	INSERT INTO tbStockArtigos(IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao,IDArtigoLote,IDArtigoNumeroSerie, IDArtigoDimensao, Quantidade, QuantidadeStock, QuantidadeStock2,
	Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao) 
	SELECT CCART.IDArtigo, CCART.IDLoja, CCART.IDArmazem, CCART.IDArmazemLocalizacao, CCART.IDArtigoLote, CCART.IDArtigoNumeroSerie, CCART.IDArtigoDimensao,
	CCART.Quantidade, CCART.QuantidadeStock,CCART.QuantidadeStock2,
		CCART.Ativo,CCART.Sistema, CCART.DataCriacao, CCART.UtilizadorCriacao, CCART.DataAlteracao,CCART.UtilizadorAlteracao
		FROM (
	SELECT tbCCStockArtigos.IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, tbCCStockArtigos.IDArtigoDimensao, 0 as Quantidade,
	0 as QuantidadeStock,
	0 as QuantidadeStock2,1 as Ativo,1 as Sistema, getdate() AS DataCriacao , @strUtilizador as UtilizadorCriacao, getdate() as DataAlteracao, @strUtilizador as UtilizadorAlteracao
	FROM tbCCStockArtigos  inner join tbf3mrecalculo on tbCCStockArtigos.idartigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo
	GROUP BY tbCCStockArtigos.IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, tbCCStockArtigos.IDArtigoDimensao
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
	QuantidadeStock2 = Round(QuantidadeStock2 + ArtigosAntigos.QtdStock2,6),
	QuantidadeReservada = Round(isnull(QuantidadeReservada,0) + ArtigosAntigos.QtdStockReservado, 6), 
	QuantidadeReservada2 = Round(isnull(QuantidadeReservada2,0) + ArtigosAntigos.QtdStock2Reservado, 6) FROM tbStockArtigos AS CCART
	INNER JOIN (
	SELECT tbCCStockArtigos.IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, tbCCStockArtigos.IDArtigoDimensao, 
	SUM(Case Natureza WHEN ''S'' Then isnull(Quantidade,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(Quantidade,0) ELSE 0 END END) as Qtd,
	SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock,0) ELSE 0 END END) as QtdStock,
	SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock2,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock2,0) ELSE 0 END END) as QtdStock2,
	SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva,0) ELSE isnull(QtdStockReserva,0)*-1 END) as QtdStockReservado,
	SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva2Uni,0) ELSE isnull(QtdStockReserva2Uni,0)*-1 END) as QtdStock2Reservado
	FROM tbCCStockArtigos  inner join tbf3mrecalculo on tbCCStockArtigos.idartigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo
	GROUP BY tbCCStockArtigos.IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, tbCCStockArtigos.IDArtigoDimensao
	) AS ArtigosAntigos
	ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
		isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
		AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
								
END')


EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_Recalculo_PCM_UPC]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_Recalculo_PCM_UPC]')

EXEC('CREATE PROCEDURE [dbo].[sp_Recalculo_PCM_UPC] 
	@IDRecalculo as bigint
AS
DECLARE db_cursor CURSOR FOR SELECT C.ID, C.IDArtigo, Natureza, isnull(QuantidadeStock,0), isnull(PrecoUnitarioEfetivoMoedaRef,0) + isnull(UltCustosAdicionaisMoedaRef,0), isnull(PrecoUnitarioMoedaRef,0), isnull(UltCustosAdicionaisMoedaRef,0), isnull(UltDescComerciaisMoedaRef,0)
from tbCCStockArtigos C with (nolock) inner join tbf3mrecalculo on c.idartigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo 
left join tbTiposDocumento TD with (nolock) on C.IDTipoDocumento=TD.id
left join tbSistemaTiposDocumento STD with (nolock) on TD.IDSistemaTiposDocumento=STD.id
order by c.idartigo, c.DataControloInterno, c.ID; 

DECLARE @ID bigint;
DECLARE @IDArtigo bigint;
DECLARE @IDArtigoAux bigint;
DECLARE @Natureza varchar(10); 
DECLARE @QuantidadeStock float; 
DECLARE @QtdStockAnterior float; 
DECLARE @QtdStockAtual float;
DECLARE @PCMAnteriorMoedaRef decimal(30,4);  
DECLARE @PCMAtualMoedaRef decimal(30,4); 
DECLARE @UPCMoedaRef decimal(30,4); 
DECLARE @CustoMedio decimal(30,4);
DECLARE @PrecoUnitarioEfetivoMoedaRef decimal(30,4);
DECLARE @UltCustosAdicionaisMoedaRef decimal(30,4);
DECLARE @UltDescComerciaisMoedaRef decimal(30,4);

set @QtdStockAnterior=0;
set @QtdStockAtual=0;
set @IDArtigoAux=0;
set @PCMAnteriorMoedaRef=0;
set @CustoMedio=0;
set @IDArtigo=0;
set @PrecoUnitarioEfetivoMoedaRef=0;

OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @ID, @IDArtigo, @Natureza, @QuantidadeStock, @PrecoUnitarioEfetivoMoedaRef, @UPCMoedaRef, @UltCustosAdicionaisMoedaRef, @UltDescComerciaisMoedaRef;
WHILE @@FETCH_STATUS = 0  
BEGIN 

if @IDArtigoAux<>@IDArtigo 
begin
set @IDArtigoAux=@IDArtigo;
set @QtdStockAnterior=0;
set @QtdStockAtual=0;
set @PCMAnteriorMoedaRef=0;
set @CustoMedio=0;
end
else
begin
set @IDArtigoAux=@IDArtigo;
end

IF @Natureza=''E''
begin
SET @QtdStockAnterior=@QtdStockAtual;
SET @PCMAnteriorMoedaRef=@CustoMedio;
SET @QtdStockAtual=@QtdStockAtual+@QuantidadeStock;
end 
else
begin
set @PrecoUnitarioEfetivoMoedaRef=@CustoMedio;
SET @QtdStockAnterior=@QtdStockAtual;
SET @QtdStockAtual=@QtdStockAtual-@QuantidadeStock;
SET @PCMAnteriorMoedaRef=@CustoMedio;
end 

IF (@QtdStockAnterior+@QuantidadeStock)<=0
begin
set @CustoMedio=0;
end
else
begin

if @QtdStockAnterior<0 
begin
set @CustoMedio=@PrecoUnitarioEfetivoMoedaRef;
end
else
begin
set @CustoMedio=CAST((@QtdStockAnterior*@PCMAnteriorMoedaRef+@PrecoUnitarioEfetivoMoedaRef*@QuantidadeStock)/(@QtdStockAnterior+@QuantidadeStock) as decimal(30,4));
end
end

update tbCCStockArtigos set QtdStockAtual=@QtdStockAtual, QtdStockAnterior=@QtdStockAnterior, PCMAnteriorMoedaRef=@PCMAnteriorMoedaRef, PCMAtualMoedaRef=@CustoMedio, UPCompraMoedaRef=@PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef=@UPCMoedaRef, recalcular=0 where id=@ID;

IF @Natureza=''E''
begin
update tbartigos set medio=@CustoMedio, UltimoPrecoCusto=@PrecoUnitarioEfetivoMoedaRef, UltimoPrecoCompra=@UPCMoedaRef, UltimosCustosAdicionais=@UltCustosAdicionaisMoedaRef, UltimosDescontosComerciais=@UltDescComerciaisMoedaRef where id=@IDArtigo;
end 
else
begin
update tbartigos set medio=@CustoMedio, UltimoPrecoCusto=@PrecoUnitarioEfetivoMoedaRef where id=@IDArtigo;
end 

FETCH NEXT FROM db_cursor INTO @ID, @IDArtigo, @Natureza, @QuantidadeStock, @PrecoUnitarioEfetivoMoedaRef, @UPCMoedaRef, @UltCustosAdicionaisMoedaRef, @UltDescComerciaisMoedaRef;
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;')

EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_Recalculo_VendasStocks]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_Recalculo_VendasStocks]')

EXEC('CREATE PROCEDURE [dbo].[sp_Recalculo_VendasStocks]
	@IDRecalculo as bigint
AS  BEGIN
update l set l.UPCMoedaRef = isnull(C.UPCMoedaRef,0), l.PCMAtualMoedaRef= isnull(C.PCMAtualMoedaRef,0)
from tbCCStockArtigos C with (nolock) inner join tbf3mrecalculo on c.idartigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo  
inner join tbDocumentosVendas D with (nolock) on d.ID=C.iddocumento and d.IDTipoDocumento=C.IDTipoDocumento and d.IDTiposDocumentoSeries=c.IDTiposDocumentoSeries
left join tbDocumentosVendaslinhas L with (nolock) on L.ID=C.idlinhadocumento
inner join tbTiposDocumento TD with (nolock) on d.IDTipoDocumento=TD.id
where TD.IDSistemaTiposDocumentoMovStock=3

update l set l.UPCMoedaRef = isnull(C.UPCMoedaRef,0), l.PCMAtualMoedaRef= isnull(C.PCMAtualMoedaRef,0)
from tbCCStockArtigos C with (nolock) inner join tbf3mrecalculo on c.idartigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo  
inner join tbDocumentosStock D with (nolock) on d.ID=C.iddocumento and d.IDTipoDocumento=C.IDTipoDocumento and d.IDTiposDocumentoSeries=c.IDTiposDocumentoSeries
left join tbDocumentosStocklinhas L with (nolock) on L.ID=C.idlinhadocumento
inner join tbTiposDocumento TD with (nolock) on d.IDTipoDocumento=TD.id
where TD.IDSistemaTiposDocumentoMovStock=3

update l set l.UPCMoedaRef = isnull(C.UPCMoedaRef,0), l.PCMAtualMoedaRef= isnull(C.PCMAtualMoedaRef,0)
from tbCCStockArtigos C with (nolock) inner join tbf3mrecalculo on c.idartigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo  
inner join tbDocumentosCompras D with (nolock) on d.ID=C.iddocumento and d.IDTipoDocumento=C.IDTipoDocumento and d.IDTiposDocumentoSeries=c.IDTiposDocumentoSeries
left join tbDocumentosCompraslinhas L with (nolock) on L.ID=C.idlinhadocumento
inner join tbTiposDocumento TD with (nolock) on d.IDTipoDocumento=TD.id
where TD.IDSistemaTiposDocumentoMovStock=3
END')


EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_Recalculo_AtualizaContaCorrente]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_Recalculo_AtualizaContaCorrente]')

EXEC('CREATE PROCEDURE [dbo].[sp_Recalculo_AtualizaContaCorrente]
	@IDRecalculo as bigint
AS BEGIN
update C set C.recalcular=0 from tbCCStockArtigos C inner join tbf3mrecalculo on c.idartigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo 
update C set C.recalculaupc=0 from tbArtigos C inner join tbf3mrecalculo on c.id=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo
delete tbf3mrecalculo where IDRecalculo=@IDRecalculo
END')

EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaParametrosContexto]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaParametrosContexto]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaParametrosContexto] 
	@IDLoja AS bigint = 1
AS
DECLARE db_cursor CURSOR FOR SELECT ID FROM TBLOJAS order by ID; 

DECLARE @ID bigint;
DECLARE @IDParametros bigint;

update tbParametrosContexto set idloja=null, IDParametrosEmpresa=null where codigo=''Comunicacao'' and idloja is null

OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @ID;
WHILE @@FETCH_STATUS = 0  
BEGIN 

insert into tbParametrosContexto (codigo, Descricao,Accao, MostraConteudo, idloja, ordem, sistema,ativo,DataCriacao,UtilizadorCriacao) 
select codigo, Descricao,Accao, MostraConteudo, @ID as idloja, ordem, sistema,ativo,DataCriacao,UtilizadorCriacao from tbParametrosContexto where idloja is null and codigo=''Comunicacao''

select @IDParametros=max(id) from tbParametrosContexto 

insert into tbParametroscamposContexto (IDParametroContexto,CodigoCampo,DescricaoCampo,TipoCondicionante,IDTipoDados,ConteudoLista,ValorCampo,Accao,AccaoExtra,Filtro,ValorMax,ValorMin,ValorReadOnly,Ordem,Sistema,Ativo,DataCriacao,UtilizadorCriacao)
select @IDParametros as IDParametroContexto,CodigoCampo,DescricaoCampo,TipoCondicionante,IDTipoDados,ConteudoLista,ValorCampo,cc.Accao,AccaoExtra,Filtro,ValorMax,ValorMin,ValorReadOnly,cc.Ordem,cc.Sistema,cc.Ativo,cc.DataCriacao,cc.UtilizadorCriacao
from tbParametrosCamposContexto cc inner join tbParametrosContexto c on cc.IDParametroContexto=c.id where c.codigo=''Comunicacao'' and c.IDLoja is null

FETCH NEXT FROM db_cursor INTO @ID;
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;')


EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaCaixa'')) drop view vwMapaCaixa')

EXEC('create view [dbo].[vwMapaCaixa] as
select 
tbLojas.Codigo as CodigoLoja,
tbLojas.Descricao as DescricaoLoja,
tbFormasPagamento.Codigo as CodigoFormaPagamento,
tbFormasPagamento.Descricao as DescricaoFormaPagamento,
tbMapaCaixa.IDTipoDocumento,
tbMapaCaixa.IDTipoDocumentoSeries,
tbMapaCaixa.NumeroDocumento,
CAST(CONVERT(nvarchar(10), tbMapaCaixa.DataDocumento, 101) AS DATETIME) as DataDocumento,
tbMapaCaixa.Descricao as Documento,
tbMapaCaixa.IDMoeda,
tbMapaCaixa.Ativo as Ativo,
(case when tbMapaCaixa.Natureza=''P'' then ''Entrada'' else ''Saída'' end) as Natureza,  
(case when tbMapaCaixa.Natureza=''P'' then tbMapaCaixa.TotalMoeda else -(tbMapaCaixa.TotalMoeda) end) as TotalMoeda,
(case when tbMapaCaixa.Natureza=''P'' then tbMapaCaixa.TotalMoedaReferencia else -(tbMapaCaixa.TotalMoedaReferencia) end) as TotalMoedaReferencia,
Round(isnull((
select Sum((Case tbSaldoAgreg.Natureza when ''P'' then 1 else -1 end) * tbSaldoAgreg.TotalMoeda) FROM tbMapaCaixa as tbSaldoAgreg
WHERE tbSaldoAgreg.IDLoja= tbMapaCaixa.IDLoja and tbSaldoAgreg.Datadocumento= tbMapaCaixa.Datadocumento
AND (tbSaldoAgreg.Natureza =''P'' OR tbSaldoAgreg.Natureza =''R'')
AND tbSaldoAgreg.DataCriacao <= tbMapaCaixa.DataCriacao
AND ((isnull(tbSaldoAgreg.IDTipoDocumento,0)<>isnull(tbMapaCaixa.IDTipoDocumento,0) OR isnull(tbSaldoAgreg.IDDocumento,0) <> isnull(tbMapaCaixa.IDDocumento,0)
       ) OR (isnull(tbSaldoAgreg.IDTipoDocumento,0) = isnull(tbMapaCaixa.IDTipoDocumento,0) AND isnull(tbSaldoAgreg.IDDocumento,0) = isnull(tbMapaCaixa.IDDocumento,0)
                     AND tbSaldoAgreg.ID<=tbMapaCaixa.ID
                     )
       )
),0),isnull(tbMoedas.CasasDecimaisTotais,0)) as Saldo,
tbmoedas.descricao as tbMoedas_Descricao, 
tbmoedas.Simbolo as tbMoedas_Simbolo, 
tbmoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
tbmoedas.TaxaConversao as tbMoedas_TaxaConversao,
tbMapaCaixa.IDLoja as IDLoja,
tbMapaCaixa.IDFormaPagamento as IDFormaPagamento,
tbMapaCaixa.IDDocumento as IDDocumento,
tbMapaCaixa.ID as ID
FROM tbMapaCaixa AS tbMapaCaixa
LEFT JOIN tbFormasPagamento AS tbFormasPagamento ON tbFormasPagamento.id=tbMapaCaixa.IDFormaPagamento
LEFT JOIN tbLojas AS tbLojas ON tbLojas.id=tbMapaCaixa.IDLoja
LEFT JOIN tbMoedas as tbMoedas ON tbMoedas.ID=tbMapaCaixa.IDMoeda
LEFT JOIN tbTiposDocumento AS tbTiposDocumento ON tbTiposDocumento.ID=tbMapaCaixa.IDTipoDocumento
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries ON tbTiposDocumentoSeries.ID=tbMapaCaixa.IDTipoDocumentoSeries
ORDER BY tbMapaCaixa.ID  OFFSET 0 ROWS ')

EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.8.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.8.0'', ''A'', ''2018-05-08 00:00:00.000'', ''2018-05-11 08:00:00.000'', ''Nova versão disponível:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.8.0'', ''V'', ''2018-05-11 08:00:00.000'', ''2018-05-11 08:00:00.000'', ''Funcionalidades da versão'', ''<span><span>Novos tipos de documento: </span><ul><li></li><li>Orçamentos e Faturas pró-forma</li><li>Envio para o SAF-T dos documentos de conferência</li><li>Movimentos Diretos de Caixa</li><li>Recálculo de Stocks</li></ul>'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')

EXEC('update [dbo].[tbSistemaTiposDocumentoImportacao] set TipoFiscal= ''NF''  where TipoFiscal=''EC'' and TipoDocSist = ''CmpEncomenda''')