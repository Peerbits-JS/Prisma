/* ACT BD EMPRESA VERSAO 7 */
exec('Alter Table [dbo].[tbSistemaTiposDocumento] Add ActivaPredefTipoDoc bit null')
exec('Update [dbo].[tbSistemaTiposDocumento] Set ActivaPredefTipoDoc = 0')
exec('Alter Table [dbo].[tbSistemaTiposDocumento] alter column ActivaPredefTipoDoc bit not null')

exec('INSERT INTO tbSistemaTiposDocumentoMovStock (ID, Codigo, Descricao, Ativo, Sistema, DataCriacao, UtilizadorCriacao) VALUES (6,''006'',''Reserva'',1,1, GETDATE(),''F3M'')')
exec('INSERT INTO tbSistemaTiposDocumentoMovStock (ID, Codigo, Descricao, Ativo, Sistema, DataCriacao, UtilizadorCriacao) VALUES (7,''007'',''LibertarReserva'',1,1, GETDATE(),''F3M'')')
exec('INSERT [dbo].[tbSistemaTiposDocumento] ([ID], [Tipo], [Descricao], [IDModulo], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [TipoFiscal],[ActivaPredefTipoDoc]) VALUES (18, N''StkReserva'', N''StockReserva'', 2, 1, 1, GETDATE(), N''F3M'', NULL, NULL, 0, 0)')
exec('INSERT [dbo].[tbSistemaTiposDocumento] ([ID], [Tipo], [Descricao], [IDModulo], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [TipoFiscal],[ActivaPredefTipoDoc]) VALUES (19, N''StkLibertarReserva'', N''StockLibertarReserva'', 2, 1, 1, GETDATE(), N''F3M'', NULL, NULL, 0, 0)')
exec('INSERT INTO tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao) VALUES (19, ''R'', ''Reserva'', ''001'', '''', 1, 1, GETDATE() , ''f3m'')')
exec('INSERT INTO tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao) VALUES (20, ''LR'', ''LibertarReserva'', ''001'', '''', 1, 1, GETDATE() , ''f3m'')')

exec('update [F3MOGeral].dbo.tbMenus set ordem=1 where Descricao=''Fornecedores''')
exec('update [F3MOGeral].dbo.tbMenus set ordem=3 where Descricao=''DocumentosPagamentosCompras''')
exec('update tbtiposdocumento set gerecontacorrente=0 where id in (4,5)')
exec('update [F3MOGeral].dbo.tbColunasListasPersonalizadas set TipoColuna=3, columnwidth=120 where IDListaPersonalizada in (26,67) and ColunaVista=''saldo''')
exec('update [F3MOGeral].dbo.tbmenus set btnContextoImportar=1 where ID in (36,46,48,102,108)')
exec('update [F3MOGeral].dbo.tbPerfisAcessos set importar=1 where IDMenus in (36,46,48,102,108)')
exec('update [F3MOGeral].dbo.tbmenus set  accao=''/Utilitarios/Consultas/Index?IDCategoria=1''  where descricao= ''Consultas''')
exec('update tbartigos set dedutivelpercentagem=100 where dedutivelpercentagem is null')
exec('update tbartigos set incidenciapercentagem=100 where incidenciapercentagem is null')
exec('update tbDocumentosVendasLinhasGraduacoes set DetalheRaio=0 where DetalheRaio is null')
exec('update tbDocumentosVendasLinhasGraduacoes set AcuidadeVisual=0 where AcuidadeVisual is null')

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
left join tbentidades e1 on d.IDEntidade1=e1.ID
left join tbentidades e2 on d.IDEntidade2=e2.ID
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
left join tbentidades e1 on d.IDEntidade1=e1.ID
left join tbentidades e2 on d.IDEntidade2=e2.ID
''where id in (58)')

EXEC('
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (23, 23, N''MapaIvaVendas'', N''Mapa de Iva de Vendas'', N''rptMapaIVA'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, N''select * from vwMapaIvaVendas'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (24, 24, N''MapaIvaCompras'', N''Mapa de Iva de Compras'', N''rptMapaIVA'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, N''select * from vwMapaIvaCompras'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')

EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwStokArtigos'')) drop view vwStokArtigos')

EXEC('
BEGIN
EXECUTE(''create view vwStokArtigos as
select 
	tbArtigos.Codigo as CodigoArtigo,
	tbArtigos.Descricao as DescricaoArtigo,
	tbTiposArtigos.Codigo as CodigoTipoArtigo,
	tbTiposArtigos.Descricao as DescricaoTipoArtigo,
	tbFornecedores.Codigo as CodigoFornecedor,
	tbFornecedores.Nome as DescricaoFornecedor,
	tbArmazens.Codigo as CodigoArmazem,
	tbArmazens.Descricao as DescricaoArmazem,
	tbArmazensLocalizacoes.Codigo as CodigoArmazemLocalizacao,
	tbArmazensLocalizacoes.Descricao as DescricaoArmazemLocalizacao,
	tbArtigosLotes.Codigo as CodigoLote,
	tbArtigosLotes.Descricao as DescricaoLote,
    tbArtigos.Medio as Medio,
	tbArtigos.UltimoPrecoCusto as UltimoPrecoCusto,
	tbArtigos.UltimoPrecoCompra as UltimoPrecoCompra,
	tbstockartigos.quantidade as Quantidade,
	tbstockartigos.quantidadestock as QuantidadeStock,
    tbArtigosstock.UltimaEntrada as UltimaEntrada,
    tbArtigosstock.UltimaSaida as UltimaSaida,
	tbArtigos.CodigoBarras as CodigoBarras
from tbstockartigos
LEFT JOIN tbArtigos as tbArtigos On tbArtigos.ID=tbstockartigos.IDArtigo  
LEFT JOIN tbArtigosstock AS tbArtigosstock ON tbArtigosstock.IDartigo=tbstockartigos.IDArtigo
LEFT JOIN tbTiposArtigos as tbTiposArtigos On tbTiposArtigos.ID=tbArtigos.IDTipoArtigo 
LEFT JOIN tbArmazens AS tbArmazens on tbArmazens.ID=tbstockartigos.IDArmazem
LEFT JOIN tbArmazensLocalizacoes AS tbArmazensLocalizacoes on tbArmazensLocalizacoes.ID=tbstockartigos.IDArmazemLocalizacao 
LEFT JOIN tbArtigosLotes as tbArtigosLotes on tbArtigosLotes.ID=tbstockartigos.IDArtigoLote
LEFT JOIN tbArtigosFornecedores as tbArtigosFornecedores On tbArtigosFornecedores.IDArtigo=tbArtigos.ID and tbArtigosFornecedores.Ordem=1 
LEFT JOIN tbFornecedores as tbFornecedores On tbFornecedores.ID=tbArtigosFornecedores.IDFornecedor and tbArtigosFornecedores.Ordem=1 
ORDER BY CodigoArtigo
  OFFSET 0 ROWS   '')
END')

EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Stock Artigos''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoTipoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoTipoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbArtigos'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 200)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoFornecedor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoFornecedor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoArmazem'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoArmazem'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoArmazemLocalizacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoArmazemLocalizacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLote'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoLote'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Quantidade'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Medio'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UltimoPrecoCusto'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UltimoPrecoCompra'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UltimaEntrada'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UltimaSaida'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoBarras'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 110)
END')


EXEC('ALTER PROCEDURE [dbo].[sp_AtualizaMapaCaixa]  
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

				SET @strSqlQueryInsert = ''insert into tbMapaCaixa ([IDTipoDocumentoSeries],[IDTipoDocumento],[IDDocumento], [IDLoja], [DataDocumento],[NumeroDocumento],[IDFormaPagamento],
											[Natureza], [Descricao], [IDMoeda], [TotalMoeda],[TaxaConversao],[TotalMoedaReferencia], [Valor], [Troco], [ValorEntregue], [Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao])''

				SELECT @strSqlQuery = @strSqlQueryInsert + ''select r.IDTiposDocumentoSeries,r.IDTipoDocumento,r.id as IDDocumento, r.IDLoja, r.DataDocumento, R.NumeroDocumento,rfp.IDFormaPagamento, SN.Codigo, R.Documento, 
									rfp.IDMoeda, rfp.totalmoeda, rfp.TaxaConversao, rfp.TotalMoedaReferencia, rfp.valor, rfp.Troco, rfp.ValorEntregue, 1,0,getdate(),'''''' + @strUtilizador + ''''''
									from tbRecibos R inner join tbTiposDocumento TD on R.IDTipodocumento=TD.ID 
									inner join tbSistemaTiposDocumentoFiscal STD on TD.IDSistemaTiposDocumentoFiscal=STD.ID
									inner join tbSistemaNaturezas SN on TD.IDSistemaNaturezas=SN.ID
									inner join tbRecibosFormasPagamento RFP on RFP.IDRecibo=R.ID
									inner join tbFormasPagamento FP on RFP.IDFormapagamento=FP.ID
									where TD.GereContaCorrente=1 AND R.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)

				SELECT @strSqlQuery = @strSqlQueryInsert + ''select r.IDTiposDocumentoSeries,r.IDTipoDocumento,r.id as IDDocumento, r.IDLoja, r.DataDocumento, R.NumeroDocumento,rfp.IDFormaPagamento, (case when SN.Codigo=''''R'''' then ''''P'''' else ''''R'''' end), R.Documento, 
									rfp.IDMoeda, rfp.totalmoeda, rfp.TaxaConversao, rfp.TotalMoedaReferencia, rfp.valor, rfp.Troco, rfp.ValorEntregue, 1,0,getdate(),'''''' + @strUtilizador + ''''''
									from tbDocumentosVendas R inner join tbTiposDocumento TD on R.IDTipodocumento=TD.ID 
									inner join tbSistemaTiposDocumentoFiscal STD on TD.IDSistemaTiposDocumentoFiscal=STD.ID
									inner join tbSistemaNaturezas SN on TD.IDSistemaNaturezas=SN.ID
									inner join tbDocumentosVendasFormasPagamento RFP on RFP.IDDocumentoVenda = R.ID
									inner join tbFormasPagamento FP on RFP.IDFormapagamento=FP.ID
									where R.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)

				SELECT @strSqlQuery = @strSqlQueryInsert + ''select r.IDTiposDocumentoSeries,r.IDTipoDocumento,r.id as IDDocumento, r.IDLoja, r.DataDocumento, R.NumeroDocumento,rfp.IDFormaPagamento, SN.Codigo, R.Documento, 
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


EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwCCClientes'')) drop view vwCCClientes')

EXEC('create view [dbo].[vwCCClientes] as
select 
tbClientes.Codigo as CodigoCliente,
tbCCEntidades.NomeFiscal,
tbCCEntidades.IDLoja,
tbCCEntidades.IDEntidade,
tbCCEntidades.IDTipoDocumento,
tbCCEntidades.IDTipoDocumentoSeries,
tbCCEntidades.NumeroDocumento,
tbCCEntidades.DataDocumento,
tbCCEntidades.Descricao as Documento,
tbCCEntidades.IDMoeda,
tbCCEntidades.Ativo as Ativo,
(case when tbCCEntidades.Natureza=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,  
(case when tbCCEntidades.Natureza=''R'' then tbCCEntidades.TotalMoeda else -(tbCCEntidades.TotalMoeda) end) as TotalMoeda,
(case when tbCCEntidades.Natureza=''R'' then tbCCEntidades.TotalMoeda else -(tbCCEntidades.TotalMoeda) end) as Valor,
(case when tbCCEntidades.Natureza=''R'' then tbCCEntidades.TotalMoedaReferencia else -(tbCCEntidades.TotalMoedaReferencia) end) as TotalMoedaReferencia,
Round(isnull((
select Sum((Case tbCCSaldoAgreg.Natureza when ''R'' then 1 else -1 end) * tbCCSaldoAgreg.TotalMoeda) FROM tbCCEntidades as tbCCSaldoAgreg
WHERE tbCCSaldoAgreg.IDEntidade= tbCCEntidades.IDEntidade
AND (tbCCSaldoAgreg.Natureza =''P'' OR tbCCSaldoAgreg.Natureza =''R'')
AND tbCCSaldoAgreg.DataCriacao <= tbCCEntidades.DataCriacao
AND ((tbCCSaldoAgreg.IDTipoDocumento<>tbCCEntidades.IDTipoDocumento OR tbCCSaldoAgreg.IDDocumento <> tbCCEntidades.IDDocumento
       ) OR (tbCCSaldoAgreg.IDTipoDocumento = tbCCEntidades.IDTipoDocumento AND tbCCSaldoAgreg.IDDocumento = tbCCEntidades.IDDocumento
                     AND tbCCSaldoAgreg.ID<=tbCCEntidades.ID
                     )
       )
),0),isnull(tbMoedas.CasasDecimaisTotais,0)) as Saldo,
tbmoedas.descricao as tbMoedas_Descricao, 
tbmoedas.Simbolo as tbMoedas_Simbolo, 
tbmoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
tblojas.Codigo as CodigoLoja,
tblojas.Descricao as DescricaoLoja
FROM tbCCEntidades AS tbCCEntidades
LEFT JOIN tbClientes AS tbClientes ON tbClientes.id=tbCCEntidades.IDentidade
LEFT JOIN tbLojas AS tbLojas ON tbLojas.id=tbCCEntidades.IDLoja
LEFT JOIN tbMoedas as tbMoedas ON tbMoedas.ID=tbccentidades.IDMoeda
LEFT JOIN tbTiposDocumento AS tbTiposDocumento ON tbTiposDocumento.ID=tbCCEntidades.IDTipoDocumento
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries ON tbTiposDocumentoSeries.ID=tbCCEntidades.IDTipoDocumentoSeries
ORDER BY tbCCEntidades.ID  OFFSET 0 ROWS ')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Clientes''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoCliente'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 200)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 1, 5, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Valor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTiposDocumento'', 0, 5, 150)
END')



EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwCCFornecedores'')) drop view vwCCFornecedores')

exec('create view [dbo].[vwCCFornecedores] as
select 
tbFornecedores.Codigo as CodigoFornecedor,
tbCCFornecedores.NomeFiscal,
tbCCFornecedores.IDLoja,
tbCCFornecedores.IDEntidade,
tbCCFornecedores.IDTipoDocumento,
tbCCFornecedores.IDTipoDocumentoSeries,
tbCCFornecedores.NumeroDocumento,
tbCCFornecedores.DataDocumento,
tbCCFornecedores.Descricao as Documento,
tbCCFornecedores.IDMoeda,
tbCCFornecedores.Ativo as Ativo,
(case when tbCCFornecedores.Natureza=''R'' then ''Crédito'' else ''Débito'' end) as Natureza,  
(case when tbCCFornecedores.Natureza=''P'' then tbCCFornecedores.TotalMoeda else -(tbCCFornecedores.TotalMoeda) end) as TotalMoeda,
(case when tbCCFornecedores.Natureza=''P'' then tbCCFornecedores.TotalMoeda else -(tbCCFornecedores.TotalMoeda) end) as Valor,
(case when tbCCFornecedores.Natureza=''P'' then tbCCFornecedores.TotalMoedaReferencia else -(tbCCFornecedores.TotalMoedaReferencia) end) as TotalMoedaReferencia,
Round(isnull((
select Sum((Case tbCCSaldoAgreg.Natureza when ''P'' then 1 else -1 end) * tbCCSaldoAgreg.TotalMoeda) FROM tbCCFornecedores as tbCCSaldoAgreg
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
tblojas.Codigo as CodigoLoja,
tblojas.Descricao as DescricaoLoja
FROM tbCCFornecedores AS tbCCFornecedores
LEFT JOIN tbFornecedores AS tbFornecedores ON tbFornecedores.id=tbCCFornecedores.IDentidade
LEFT JOIN tbLojas AS tbLojas ON tbLojas.id=tbCCFornecedores.IDLoja
LEFT JOIN tbMoedas as tbMoedas ON tbMoedas.ID=tbccFornecedores.IDMoeda
LEFT JOIN tbTiposDocumento AS tbTiposDocumento ON tbTiposDocumento.ID=tbCCFornecedores.IDTipoDocumento
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries ON tbTiposDocumentoSeries.ID=tbCCFornecedores.IDTipoDocumentoSeries
ORDER BY tbCCFornecedores.ID  OFFSET 0 ROWS ')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Fornecedores''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoFornecedor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Valor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTiposDocumento'', 0, 5, 150)
END')

--mapas de iva

exec('update [F3MOGeral].dbo.tbmenus set  accao=''/Utilitarios/Consultas/Index?IDCategoria=1''  where descricao= ''Consultas''')

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
(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIVA) as ValorIva,
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

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Iva de Vendas'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDCateg as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Mapa de Iva de Vendas'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbMapaIvaVendas'', 
N''select * from vwMapaIvaVendas'', 3, 2)
END')

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
(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIVA) as ValorIva,
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

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Iva de Compras'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDCateg as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Mapa de Iva de Compras'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbMapaIvaCompras'', 
N''select * from vwMapaIvaCompras'', 2 , 2)
END')


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