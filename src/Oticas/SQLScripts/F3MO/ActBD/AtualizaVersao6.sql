/* ACT BD EMPRESA VERSAO 6 */
exec('alter table tbdocumentosvendaslinhas alter column [Ordem] [int] NOT NULL')
exec('alter table tbdocumentoscompraslinhas alter column [Ordem] [int] NOT NULL')
exec('alter table tbdocumentosstocklinhas alter column [Ordem] [int] NOT NULL')
exec('alter table tbdocumentoscompras add [SegundaVia] [bit] NULL, [DataUltimaImpressao] [datetime] NULL, [NumeroImpressoes] [int] NULL, [IDLojaUltimaImpressao] [bigint] NULL')  
exec('alter table tbdocumentosstock add [SegundaVia] [bit] NULL, [DataUltimaImpressao] [datetime] NULL,[NumeroImpressoes] [int] NULL, [IDLojaUltimaImpressao] [bigint] NULL')

/* MAPAS VISTAS*/
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (20, 20, N'CCStockArtigos', N'Conta Corrente', N'rptCCArtigos', N'\Reporting\Reports\Oticas\DocumentosVendas\', 0, NULL, NULL, NULL, NULL, 1, N'select * from vwCCArtigos', NULL, 0, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'')
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (21, 21, N'StockArtigos', N'Stock Artigos', N'rptStockArtigos', N'\Reporting\Reports\Oticas\DocumentosVendas\', 0, NULL, NULL, NULL, NULL, 1, N'select * from vwStokArtigos', NULL, 0, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'')
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (22, 22, N'CCFornecedores', N'Conta Corrente', N'rptCCEntidades', N'\Reporting\Reports\Oticas\DocumentosVendas\', 0, NULL, NULL, NULL, NULL, 1, N'select tbCCfornecedores.*, (case when Natureza=''R'' then ''Crédito'' else ''Débito'' end) as Natureza,  (case when Natureza=''R'' then -TotalMoeda else TotalMoeda end) as TotalMoeda, m.descricao as tbMoedas_Descricao, m.Simbolo as tbMoedas_Simbolo, m.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais from tbCCfornecedores left join tbMoedas M on tbCCFornecedores.IDMoeda=m.ID', NULL, 0, 0, 1, 1, CAST(N'2017-01-31 00:00:00.000' AS DateTime), N'F3M', CAST(N'2017-01-17 16:58:42.120' AS DateTime), N'')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF

exec('update [F3MOGeral].dbo.tblistaspersonalizadas set pordefeito=0 where not IDSistemaCategListasPers is null')
exec('update [F3MOGeral].dbo.tblistaspersonalizadas set pordefeito=1 where ID in (71,74,78)')
exec('update [F3MOGeral].dbo.tblistaspersonalizadas set idsistematipolista=1 where IDSistemaCategListasPers is null and idsistematipolista is null')
exec('update tbcodigospostais set utilizadorcriacao=''F3M''')
exec('update tbdistritos set utilizadorcriacao=''F3M''')
exec('update tbconcelhos set utilizadorcriacao=''F3M''')
exec('update tbestados set predefinido=0, estadoinicial=0')
exec('update tbestados set predefinido=1, estadoinicial=1 where descricao=''efetivo''')
exec('update tbtiposdocumento set idsistematiposdocumento=10, idsistematiposdocumentoprecounitario=13, acompanhabenscirculacao=0, gerestock=1, gerapendente=1, gerecontacorrente=1, idsistemanaturezas=13 where id=16')
exec('update tbtiposdocumento set idsistematiposdocumento=10, idsistematiposdocumentoprecounitario=13, acompanhabenscirculacao=0, gerestock=1, gerapendente=1, gerecontacorrente=1, idsistemanaturezas=12 where id=10')
exec('update tbTiposDocumento set DataPrimeiraSaida=1, DataUltimaSaida=1 where codigo in (''FA'', ''FR'', ''FS'', ''FT'', ''SS'',''NV'')')
exec('update tbTiposDocumento set customedio=1, UltimoPrecoCusto=1, DataPrimeiraEntrada=1, DataUltimaEntrada=1 where codigo in (''FC'', ''ES'', ''GTC'',''GRC'')')
exec('update tbparametroscamposcontexto set valorcampo=1 where codigocampo=''ArmazemLocalizacao''')
exec('delete from [F3MOGeral].dbo.tbcondicoeslistaspersonalizadas where campo=''DataDocumento''')
exec('update tbTiposDocumento set gerapendente=0, gerecontacorrente=0 where codigo in (''GTC'',''GRC'')')
exec('update tbTiposDocumento set gerecontacorrente=1 where codigo in (''NL'')')
exec('update tbTiposDocumento set customedio=0, UltimoPrecoCusto=0, DataPrimeiraEntrada=1, DataUltimaEntrada=1, DataPrimeiraSaida=1, DataUltimaSaida=1  where codigo in (''GT'')')
exec('update tbparametroscamposcontexto set tipocondicionante=1 where codigocampo=''ArmazemLocalizacao''')
exec('update tbtiposdocumento set Gerecontacorrente=0, GeraPendente=0, GereStock=0, IDSistemaAcoesRupturaStock=1, IDSistemaAcoesReposicaoStock=1, IDSistemaAcoesStockMaximo=1, IDSistemaAcoesStockMinimo=1 where idmodulo=4 and codigo=''SV''')
exec('update tbtiposdocumento set Gerecontacorrente=1, GeraPendente=1, GereStock=0, IDSistemaAcoesRupturaStock=1, IDSistemaAcoesReposicaoStock=1, IDSistemaAcoesStockMaximo=1, IDSistemaAcoesStockMinimo=1 where idmodulo=4 and codigo in (''FA'', ''NA'')')
exec('update tbtiposdocumento set Gerecontacorrente=1, GeraPendente=1, GereStock=1, IDSistemaAcoesRupturaStock=1, IDSistemaAcoesReposicaoStock=1, IDSistemaAcoesStockMaximo=1, IDSistemaAcoesStockMinimo=1 where idmodulo=4 and codigo in (''FT'', ''NC'', ''ND'')')
exec('update tbtiposdocumento set Gerecontacorrente=1, GeraPendente=0, GereStock=0, IDSistemaAcoesRupturaStock=1, IDSistemaAcoesReposicaoStock=1, IDSistemaAcoesStockMaximo=1, IDSistemaAcoesStockMinimo=1 where idmodulo=4 and codigo=''RC''')
exec('update tbtiposdocumento set Gerecontacorrente=0, GeraPendente=0, GereStock=1, IDSistemaAcoesRupturaStock=1, IDSistemaAcoesReposicaoStock=1, IDSistemaAcoesStockMaximo=1, IDSistemaAcoesStockMinimo=1 where idmodulo=4 and codigo in (''FR'', ''FS'')')
exec('update tbtiposdocumento set idsistemanaturezas=10 where codigo=''GRC''')
exec('update tbTiposDocumento set IDSistemaTiposDocumentoMovStock=3 where IDModulo=3 and codigo=''NCC''')
exec('update tbTiposDocumento set IDSistemaTiposDocumentoMovStock=2 where IDModulo=4 and codigo in (''NA'', ''ND'')')
exec('update tbunidades set NumeroDeCasasDecimais=0')
exec('update [F3MOGeral].dbo.tbperfisacessos set adicionar=1 , remover=1 where idmenus in (93,94,95,97)')
exec('update tbtiposdocumento set GereContaCorrente=0 where codigo=''NA'' and IDModulo=4')
exec('update a set a.Adicionar=b.Adicionar, a.alterar= b.alterar, a.Consultar=b.Consultar,a.Remover=b.Remover, a.Duplicar=b.Duplicar, a.Exportar=b.Exportar,a.F4=b.F4,a.Importar=b.Importar,a.Imprimir=b.Imprimir 
from (select * from [F3MOGeral].dbo.tbPerfisacessos where IDPerfis=2) a 
inner join (select * from [F3MOGeral].dbo.tbPerfisacessos where IDPerfis=1) b
on a.IDMenus=b.IDMenus')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Clientes''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoCliente'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TotalMoeda'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTiposDocumento'', 0, 5, 150)
END')

update [tbMapasVistas] set sqlquery='select * from vwCCClientes' where entidade='CCEntidades'
update [F3MOGeral].[dbo].[tbListasPersonalizadas] set query='select * from vwCCClientes' where id=74

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
tbmoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais

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
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Fornecedores''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoFornecedor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NomeFiscal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TotalMoeda'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTiposDocumento'', 0, 5, 150)
END')


update [tbMapasVistas] set sqlquery='select * from vwCCFornecedores' where entidade='CCFornecedores'
update [F3MOGeral].[dbo].[tbListasPersonalizadas] set query='select * from vwCCFornecedores' where id=78

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
tbmoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais

FROM tbCCFornecedores AS tbCCFornecedores
LEFT JOIN tbFornecedores AS tbFornecedores ON tbFornecedores.id=tbCCFornecedores.IDentidade
LEFT JOIN tbLojas AS tbLojas ON tbLojas.id=tbCCFornecedores.IDLoja
LEFT JOIN tbMoedas as tbMoedas ON tbMoedas.ID=tbccFornecedores.IDMoeda
LEFT JOIN tbTiposDocumento AS tbTiposDocumento ON tbTiposDocumento.ID=tbCCFornecedores.IDTipoDocumento
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries ON tbTiposDocumentoSeries.ID=tbCCFornecedores.IDTipoDocumentoSeries
ORDER BY tbCCFornecedores.ID  OFFSET 0 ROWS ')

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
tbCCStockArtigos.PCMAtualMoedaRef,
tbCCStockArtigos.PCMAnteriorMoedaRef,
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
LEFT JOIN tbFornecedores AS tbFornecedores ON tbFornecedores.ID = tbCCStockArtigos.IDEntidade
LEFT JOIN tbclientes AS tbclientes ON tbclientes.ID = tbCCStockArtigos.IDEntidade
LEFT JOIN tbtiposartigos AS tbtiposartigos ON tbtiposartigos.ID = tbArtigos.IDtipoartigo
LEFT JOIN tbLojas AS tbLojas ON tbLojas.ID = tbCCStockArtigos.IDLoja
ORDER BY DataControloInterno, tbCCStockArtigos.ID  OFFSET 0 ROWS 
'')
END')
     
	 
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Artigos''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 120)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DocumentoOrigem'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 120)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoTipoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTiposArtigos'', 1, 5, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoTipoDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbArtigos'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoArtigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 250)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 0, 5, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoArmazem'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbArmazens'', 1, 5, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoArmazem'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoArmazemLocalizacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbArmazensLocalizacoes'', 1, 5, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoArmazemLocalizacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 60)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLote'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 60)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoLote'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 60)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoCF'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 60)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoCF'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 250)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QtdLinhaStock'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QuantidadeStock'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QtdStockAtual'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PrecoUnitarioMoedaRef'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PCMAtualMoedaRef'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 150)
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


EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Fornecedores''
DELETE FROM [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''Ativo'', 0, N''Ativo'', N''True'', N'''', 35, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 9, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 11, N'''', 1, CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'')
END')

EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Clientes''
DELETE FROM [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''Ativo'', 0, N''Ativo'', N''True'', N'''', 35, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 9, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 11, N'''', 1, CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'')
END')


EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Artigos''
DELETE FROM [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''Ativo'', 0, N''Ativo'', N''True'', N'''', 35, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 9, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 11, N'''', 1, CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'')
END')


EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Caixa''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoFormaPagamento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFormasPagamento'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoFormaPagamento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbSistemaNaturezas'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TotalMoeda'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Ativo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 2, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 0, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NumeroDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipoDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTiposDocumento'', 0, 5, 150)
END')

update [tbMapasVistas] set sqlquery='select * from vwMapaCaixa' where entidade='MapaCaixa'
update [F3MOGeral].[dbo].[tbListasPersonalizadas] set query='select * from vwMapaCaixa' where descricao='Mapa de Caixa'
update tbmapasvistas SET Nomemapa='rptCCEntidades' WHERE Nomemapa='rptCCentidades'

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
WHERE tbSaldoAgreg.IDLoja= tbMapaCaixa.IDLoja
AND (tbSaldoAgreg.Natureza =''P'' OR tbSaldoAgreg.Natureza =''R'')
AND tbSaldoAgreg.DataCriacao <= tbMapaCaixa.DataCriacao
AND ((tbSaldoAgreg.IDTipoDocumento<>tbMapaCaixa.IDTipoDocumento OR tbSaldoAgreg.IDDocumento <> tbMapaCaixa.IDDocumento
       ) OR (tbSaldoAgreg.IDTipoDocumento = tbMapaCaixa.IDTipoDocumento AND tbSaldoAgreg.IDDocumento = tbMapaCaixa.IDDocumento
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


Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (17, 'P', 'Recebimento', '006', 'CntCorrLiquidacao', 'True', 'True', '2017-12-09' , 'f3m')
Insert into tbSistemaNaturezas (ID, Codigo, Descricao, Modulo, TipoDoc, Sistema, Ativo, DataCriacao, UtilizadorCriacao) Values (18, 'R', 'Pagamento', '006', 'CntCorrLiquidacao', 'True', 'True', '2017-12-09' , 'f3m')
update tbtiposdocumento set idmodulo=5,idsistematiposdocumento=15, idsistematiposdocumentofiscal=20, GereStock=0, idsistemanaturezas=17 where codigo='RC'
update tbtiposdocumento set idmodulo=5,idsistematiposdocumento=15, idsistematiposdocumentofiscal=20, GereStock=0, idsistemanaturezas=18 where codigo='NL'

EXEC('DROP PROCEDURE [dbo].[sp_ControloDocumentos]')

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
	@strSqlQuery AS varchar(max),
	@strQueryEstado AS nvarchar(256) = '', Cab.IDEstado as IDEstado ''
BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N''IDEstado'' AND Object_ID = Object_ID(N'' + QUOTENAME(@strTabelaCabecalho) + '')) 
			BEGIN 
				SET @strQueryEstado = '', NULL as IDEstado ''
			END
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
										Cab.DataDocumento, 1 as Ativo , 1 as Sistema, getdate() as DataCriacao, '''''' + @strUtilizador + '''''' AS UtilizadorCriacao, Cab.IDLoja as IDLoja '' + @strQueryEstado + ''
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
											SET @strQueryCamposDistUpdates =''CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, '''''' + @strUtilizador + '''''' as UtilizadorCriacao ''
								
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


exec('update [F3MOGeral].dbo.tblistaspersonalizadas set idsistematipolista=2 where not idsistemacateglistaspers is null')
exec('update [F3MOGeral].dbo.tbcolunaslistaspersonalizadas set visivel=0 where idlistapersonalizada=71 and colunavista in (''Natureza'',''codigocf'') ')
exec('update [F3MOGeral].dbo.tbcolunaslistaspersonalizadas set visivel=1 where idlistapersonalizada=71 and colunavista in (''descricaocf'') ')
exec('update [F3MOGeral].dbo.tbmenus set accao = ''/Utilitarios/SAFTPT'' where descricao = ''SAFTPT''')
exec('update [F3MOGeral].dbo.tbmenus set accao = ''/Utilitarios/SAFTPTMensal'' where descricao = ''SAFTPTMensal''')
exec('update [F3MOGeral].dbo.tbmenus set accao = ''/Utilitarios/SAFTPTGestao'' where descricao = ''SAFTPTGestao''')

--Validar se deve ativar estas opcoes
--exec('update tbtiposdocumento set idsistemanaturezas=6, gerestock=1, idSistemaTiposDocumentoMovStock=3 where idmodulo=4 and codigo=''SV''')
--exec('update [F3MOGeral].dbo.tbmenus set btnContextoImportar=1 where ID in (36,46,48)')
--exec('update [F3MOGeral].dbo.tbPerfisAcessos set importar=1 where IDMenus in (36,46,48)')





exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select tbfornecedores.ID, tbfornecedores.Codigo, tbfornecedores.Nome, tbfornecedores.NContribuinte, tbfornecedores.Ativo, fc.Telefone as Telefone, fc.Fax as Fax, 
isnull(tbfornecedores.saldo, 0) as Saldo, tbfornecedores.IdTipoEntidade, cast(tbfornecedores.nome as nvarchar(20)) as DescricaoSplitterLadoDireito 
from tbfornecedores  
left join tbfornecedorescontatos fc on tbfornecedores.id=fc.idfornecedor and fc.ordem=1''
where id in (26,67)')


EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE ID=26
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE idlistapersonalizada=26
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Codigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Nome'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 1, 250)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NContribuinte'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telefone'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 1, 100)
END')


EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE ID=67
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE idlistapersonalizada=67
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Codigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 1, 80)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Nome'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 1, 200)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NContribuinte'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 1, 80)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telefone'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 1, 80)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFornecedores'', 1, 1, 80)
END')


EXEC('SET IDENTITY_INSERT [dbo].[tbTiposDocumentoSeries] ON 
INSERT [dbo].[tbTiposDocumentoSeries] ([ID], [CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (19, right(year(getdate()),2) + ''CV'', right(year(getdate()),2) + ''CV'', 0, 1, 0, 1, CAST(N''2017-07-27 17:24:03.447'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoSeries] OFF')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] WHERE [IDPerfis]=1 and [IDMenusAreasEmpresa] in (19))
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ([IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES ( 1, 7, 19, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:26:30.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
END')