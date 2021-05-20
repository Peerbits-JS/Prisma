/* ACT BD EMPRESA VERSAO 38*/

--novos mapas vistas
EXEC('IF NOT EXISTS(SELECT * FROM [dbo].[tbMapasVistas] WHERE ID=42) 
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
DELETE FROM [dbo].[tbMapasVistas] WHERE ID=42
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (42, 42, N''DocumentosVendasServicos'', N''DocumentosVendasServicosA5'', N''rptDocumentosVendasServicosA5'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, NULL, NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [dbo].[tbMapasVistas] WHERE ID=43) 
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (43, 43, N''DocumentosVendasServicos'', N''DocumentosVendasServicosA5H'', N''rptDocumentosVendasServicosA5H'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, NULL, NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [dbo].[tbMapasVistas] WHERE ID=44) 
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
DELETE FROM [dbo].[tbMapasVistas] WHERE ID=44
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (44, 44, N''DocumentosVendas'', N''DocumentosVendasA5H'', N''rptDocumentosVendasA5H'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 1, NULL, 4, NULL, NULL, @IDLoja, NULL, NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [dbo].[tbMapasVistas] WHERE ID=45) 
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
DELETE FROM [dbo].[tbMapasVistas] WHERE ID=45
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (45, 45, N''Recibos'', N''RecibosA5H'', N''rptRecibosA5H'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 1, NULL, 5, NULL, NULL, @IDLoja, NULL, NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')

-- pré-definir as vstas por tipo documento série
EXEC('IF Not EXISTS(select * from tbdocumentosvendas) 
BEGIN
update tbtiposdocumentoseries set idmapasvistas=44 where idtiposdocumento in (2,3,4,5,6,8,9)
update tbtiposdocumentoseries set idmapasvistas=43 where idtiposdocumento in (1)
END')

--novos campos idlojasede
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbDocumentosVendas'' AND COLUMN_NAME = ''IDLojaSede'') 
BEGIN
	ALTER TABLE [dbo].[tbDocumentosVendas] ADD [IDLojaSede] [bigint] NULL
	ALTER TABLE [dbo].[tbDocumentosVendas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendas_tbLojas2] FOREIGN KEY([IDLojaSede])
	REFERENCES [dbo].[tbLojas] ([ID])
END')

EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbDocumentosCompras'' AND COLUMN_NAME = ''IDLojaSede'') 
BEGIN
	ALTER TABLE [dbo].[tbDocumentosCompras] ADD [IDLojaSede] [bigint] NULL
	ALTER TABLE [dbo].[tbDocumentosCompras]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosCompras_tbLojas2] FOREIGN KEY([IDLojaSede])
	REFERENCES [dbo].[tbLojas] ([ID])
END')

EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbDocumentosStock'' AND COLUMN_NAME = ''IDLojaSede'') 
BEGIN
	ALTER TABLE [dbo].[tbDocumentosStock] ADD [IDLojaSede] [bigint] NULL
	ALTER TABLE [dbo].[tbDocumentosStock]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStock_tbLojas2] FOREIGN KEY([IDLojaSede])
	REFERENCES [dbo].[tbLojas] ([ID])
END')

--atualização das colunas das análises
EXEC('update [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] set EObrigatorio=0, Eleitura=0')

--modificar a vista dos documentos de stock
EXEC('update tbmapasvistas set caminho=''\Reporting\Reports\Oticas\DocumentosStock\'', NomeMapa = ''rptDocumentosStockPrisma'' where id=16')

--modificar a vista dos documentos de stock
EXEC('update tbParametrosCamposContexto set conteudolista=''CustoMedio|UPC|CustoPadrao'' where conteudolista is null and codigocampo in (''ValStock'',''CustoMecVendidas'')')
EXEC('update tbParametrosCamposContexto set conteudolista=''Ignorar|DesativarLote'' where conteudolista is null and codigocampo in (''FinalLote'')')
EXEC('update tbParametrosCamposContexto set conteudolista=''Ignorar|AlertarCom'' where conteudolista is null and codigocampo in (''DataExpirEntrada'', ''DataExpirSaida'')')


--incluir tipo documento nota crédito dinheiro de adiantamento
EXEC('IF NOT EXISTS(SELECT * FROM [dbo].[tbTiposDocumento] WHERE Codigo=''NCDA'' )
BEGIN
INSERT [dbo].[tbTiposDocumento] ([Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], 
[CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], 
[IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento], [Predefinido]) 
VALUES (N''NCDA'', N''Nota de Crédito a Dinheiro de Adiantamento'', 4, 14, 1, 1, CAST(N''2017-07-27 17:24:04.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, 18, 0, 1, 1, 1, 0, 0, 0, 0, 0, 3, 2, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, NULL, NULL, NULL, 1, 1, 1, 7, 0, 0, 1, 0)

DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [dbo].[tbTiposDocumento] WHERE Descricao=''Nota de Crédito a Dinheiro de Adiantamento''
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (@IDLista, 5, 0, 0, CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (@IDLista, 6, 0, 0, CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoSeries] ([CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) 
VALUES (right(year(getdate()),2) + ''NCDA'', right(year(getdate()),2) + ''NCDA'', 1, @IDLista, 0, 1, CAST(N''2017-07-27 17:24:03.447'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, 1, 2, NULL, 2, 1)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ([IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, @IDLista, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:26:30.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
END')

--novos campos morada lojasede
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbDocumentosVendas'' AND COLUMN_NAME = ''MoradaSede'') 
BEGIN
	ALTER TABLE [dbo].[tbDocumentosVendas] ADD MoradaSede nvarchar(100) null
	ALTER TABLE [dbo].[tbDocumentosVendas] ADD CodigoPostalSede nvarchar(8) null
	ALTER TABLE [dbo].[tbDocumentosVendas] ADD LocalidadeSede nvarchar(50) null
	ALTER TABLE [dbo].[tbDocumentosVendas] ADD TelefoneSede nvarchar(50) null
END')

EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbDocumentosCompras'' AND COLUMN_NAME = ''MoradaSede'') 
BEGIN
	ALTER TABLE [dbo].[tbDocumentosCompras] ADD MoradaSede nvarchar(100) null
	ALTER TABLE [dbo].[tbDocumentosCompras] ADD CodigoPostalSede nvarchar(8) null
	ALTER TABLE [dbo].[tbDocumentosCompras] ADD LocalidadeSede nvarchar(50) null
	ALTER TABLE [dbo].[tbDocumentosCompras] ADD TelefoneSede nvarchar(50) null
END')

EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbDocumentosStock'' AND COLUMN_NAME = ''MoradaSede'') 
BEGIN
	ALTER TABLE [dbo].[tbDocumentosStock] ADD MoradaSede nvarchar(100) null
	ALTER TABLE [dbo].[tbDocumentosStock] ADD CodigoPostalSede nvarchar(8) null
	ALTER TABLE [dbo].[tbDocumentosStock] ADD LocalidadeSede nvarchar(50) null
	ALTER TABLE [dbo].[tbDocumentosStock] ADD TelefoneSede nvarchar(50) null
END')

-- nova view de examesprops
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_vwExamesProps]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_vwExamesProps]')

EXEC('
CREATE PROCEDURE [dbo].[sp_vwExamesProps]  
AS  BEGIN
DECLARE @cols AS NVARCHAR(MAX),    
@query  AS NVARCHAR(MAX)

select @cols = STUFF((SELECT '','' + QUOTENAME(ComponentTag) 
                    from tbExamesProps
                    group by ComponentTag
                    order by ComponentTag
            FOR XML PATH(''''), TYPE
            ).value(''.'', ''NVARCHAR(MAX)'') 
        ,1,1,'''')

set @query = ''IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''''vwExamesProps'''')) drop view vwExamesProps''
execute(@query); 

set @query = ''create view [dbo].[vwExamesProps] as
SELECT IdExame,'' + @cols + '' from 
             (
                select IdExame, ComponentTag, ValorID
                from tbExamesProps where not ComponentTag is null
            ) x
            pivot 
            (
                max(ValorID)
                for ComponentTag in ('' + @cols + '')
            ) p ''
execute(@query);
END')
EXEC ('[sp_vwExamesProps]')

EXEC('update tbMapasVistas set idmodulo=4 where id=43')
EXEC('update tbTiposDocumentoSeries set IDMapasVistas=43 where IDTiposDocumento=1')
EXEC('update tbMapasVistas set idmodulo=4, idsistematipodoc=17 where id=43')

--remover condções das análises
EXEC('delete from [F3MOGeral].[dbo].tbCondicoesListasPersonalizadas where IDListaPersonalizada=90')
EXEC('update [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] set EObrigatorio=0, Eleitura=0')

--atualizar vista dos documentos de venda
EXEC('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, TotalEntidade1, TotalClienteMoedaDocumento, d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as DescricaoSplitterLadoDireito, d.IDEstado,
(case when d.CodigoTipoEstado=''''ANL'''' then 0 else (case when (isnull(d.TotalClienteMoedaDocumento,0)-isnull(d.valorpago,0))<0 then 0 else (isnull(d.TotalClienteMoedaDocumento,0)-isnull(d.valorpago,0)) end) end) as ValorPendente, s.Descricao as DescricaoEstado, e1.Descricao as DescricaoEntidade1, e2.Descricao as DescricaoEntidade2, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, d.CodigoTipoEstado as CodigoTipoEstado, TD.Adiantamento as Adiantamento
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

--aviso de nova versão
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.16.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.16.0'', ''A'', ''2019-04-03 00:00'', ''2019-04-18 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.16.0'', ''V'', ''2019-04-08 08:00'', ''2019-04-18 08:00'', ''Funcionalidades da versão'', ''
<li></li>
'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')