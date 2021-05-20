/* ACT BD EMPRESA VERSAO 44*/
--atualizar vista dos documentos de venda
EXEC('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.Documento as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, TotalEntidade1, TotalClienteMoedaDocumento, d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado,
(isnull(d.TotalClienteMoedaDocumento,0)-isnull(d.valorpago,0)) as ValorPendente, s.Descricao as DescricaoEstado, e1.Descricao as DescricaoEntidade1, e2.Descricao as DescricaoEntidade2, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, d.CodigoTipoEstado as CodigoTipoEstado, TD.Adiantamento as Adiantamento
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

--atualizar vista do stock
EXEC('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select TD.Codigo as DescricaoTipoDocumento, D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.Documento as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, 
d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, d.CodigoTipoEstado as CodigoTipoEstado, cast(1 as bit) as PermiteImprimir
from tbDocumentosStock d 
left join tbLojas l on d.IDloja=l.id
left join tbClientes c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID and d.ativo=1
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbEstados s on d.IDEstado=s.ID
''where id in (69)')

--atualizar vista dos serviços
EXEC('
update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.Documento as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, TotalEntidade1, TotalClienteMoedaDocumento, d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, 
d.documento as DescricaoSplitterLadoDireito, d.IDEstado,
(isnull(d.TotalClienteMoedaDocumento,0)-isnull(d.valorpago,0)) as ValorPendente, 
s.Descricao as DescricaoEstado, e1.Descricao as DescricaoEntidade1, e2.Descricao as DescricaoEntidade2, TD.IDSistemaTiposDocumento, cast(1 as bit) as PermiteImprimir
from tbDocumentosVendas d 
inner join tbLojas l on d.IDloja=l.id
inner join tbClientes c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbSistemaTiposDocumento STD on TD.IDSistemaTiposDocumento=STD.ID and STD.Tipo=''''VndServico''''
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbEstados s on d.IDEstado=s.ID
left join tbentidades e1 on d.IDEntidade1=e1.ID
left join tbentidades e2 on d.IDEntidade2=e2.ID''
where id in (55)')

--view mapa de caixa
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
tbMapaCaixa.UtilizadorCriacao as Utilizador,
CAST(CONVERT(nvarchar(10), tbMapaCaixa.DataDocumento, 101) AS DATETIME) as DataDocumento,
tbMapaCaixa.Descricao as Documento,
(case when tbMapaCaixa.Descricao=''Saldo Inicial'' then ''A'' when tbMapaCaixa.Descricao=''Valor próxima abertura'' then ''Z'' else ''M'' end) as TipoMovimento,
tbMapaCaixa.IDMoeda,
tbMapaCaixa.Ativo as Ativo,
(case when tbMapaCaixa.Natureza=''P'' then ''Entrada'' else ''Saída'' end) as Natureza,  
(case when tbMapaCaixa.Natureza=''P'' then tbMapaCaixa.TotalMoeda else -(case when isnull(tbMapaCaixa.transporte,0)=0 then tbMapaCaixa.TotalMoeda else tbMapaCaixa.transporte end) end) as TotalMoeda,
(case when tbMapaCaixa.Natureza=''P'' then tbMapaCaixa.TotalMoedaReferencia else -(case when isnull(tbMapaCaixa.transporte,0)=0 then tbMapaCaixa.TotalMoedaReferencia else tbMapaCaixa.transporte end) end) as TotalMoedaReferencia,
Round(isnull((
select Sum((Case tbSaldoAgreg.Natureza when ''P'' then 1 else -1 end) * (case when isnull(tbSaldoAgreg.transporte,0)=0 then tbSaldoAgreg.TotalMoeda else tbSaldoAgreg.transporte end) ) FROM tbMapaCaixa as tbSaldoAgreg
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
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Utilizador'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
END')

--atualizar vista da receita A5H 
EXEC('UPDATE [dbo].[tbMapasVistas] SET SQLQuery=''select c.nome as DescricaoCliente, m.Nome as DescricaoMedicoTecnico, m.cabecalho as DadosMedicoTecnico, c.NContribuinte as NContribuinte, c.NumeroBeneficiario1 as NumeroBeneficiario1, c.NumeroBeneficiario2 as NumeroBeneficiario2, c.Codigo as CodigoCliente, e1.codigo as CodigoEntidade1, e2.codigo as CodigoEntidade2,e.Descricao as DescricaoEspecialidade, x.* from vwExamesProps x left join tbClientes c on x.idcliente=c.id left join tbMedicosTecnicos m on x.idmedicotecnico=m.id left join tbEspecialidades e on x.IDespecialidade=e.id left join tbEntidades e1 on c.identidade1=e1.id left join tbEntidades e2 on c.identidade2=e2.id'' WHERE ID=48')

--atualizar a view dos exames
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwExamesProps'')) drop view vwExamesProps')

EXEC('create view [dbo].[vwExamesProps] as
SELECT IdExame,[AO_OBS],[AO_REL],[DataExame],[IDCliente],[IDEspecialidade],[IDMedicoTecnico],[IDTipoConsulta],[Label_ADD],[Label_AX],[Label_CIL],[Label_DIA],[Label_ESF],[Label_OD],[Label_OE],[Label_PRISM],[Label_RC],[LOD_ADD],[LOD_AX],[LOD_CIL],[LOD_DIAM],[LOD_ESF],[LOD_PRISM],[LOD_RAIO],[LOE_ADD],[LOE_AX],[LOE_CIL],[LOE_DIAM],[LOE_ESF],[LOE_PRISM],[LOE_RAIO] from 
( select IdExame, ComponentTag, ValorID from tbExamesProps where not ComponentTag is null) x
pivot ( max(ValorID) for ComponentTag in ([AO_OBS],[AO_REL],[DataExame],[IDCliente],[IDEspecialidade],[IDMedicoTecnico],[IDTipoConsulta],[Label_ADD],[Label_AX],[Label_CIL],[Label_DIA],[Label_ESF],[Label_OD],[Label_OE],[Label_PRISM],[Label_RC],[LOD_ADD],[LOD_AX],[LOD_CIL],[LOD_DIAM],[LOD_ESF],[LOD_PRISM],[LOD_RAIO],[LOE_ADD],[LOE_AX],[LOE_CIL],[LOE_DIAM],[LOE_ESF],[LOE_PRISM],[LOE_RAIO]) ) p 
')

--atualizar sp_AtualizaDocumentosVendas
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaDocumentosVendas]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaDocumentosVendas]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaDocumentosVendas] 
AS
DECLARE db_cursor CURSOR FOR SELECT D.ID, D.IDTipoDocumento, D.IDTiposDocumentoSeries, D.UtilizadorCriacao, D.IDEntidade
from tbDocumentosVendas D with (nolock) 
left join tbTiposDocumento TD with (nolock) on D.IDTipoDocumento=TD.id 
left join tbSistemaTiposDocumento STD with (nolock) on TD.IDSistemaTiposDocumento=STD.id
order by d.DataControloInterno, d.ID; 

DECLARE @IDDocumento bigint;
DECLARE @IDTipoDocumento bigint;
DECLARE @IDTiposDocumentoSeries bigint;
DECLARE @IDEntidade bigint;
DECLARE @Utilizador varchar(200); 

OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, @Utilizador, @IDEntidade
WHILE @@FETCH_STATUS = 0  
BEGIN 

EXEC sp_ControloDocumentos  @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, 0, ''tbDocumentosVendas'', @Utilizador 
EXEC sp_AtualizaCCEntidades @IDDocumento, @IDTipoDocumento, 0, @Utilizador, @IDEntidade 

FETCH NEXT FROM db_cursor INTO @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, @Utilizador, @IDEntidade;
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;
')

--criar indice único na tabela de tipos de fases
EXEC('IF EXISTS (SELECT * FROM sys.indexes where name = N''IX_tbTiposFases_Codigo'') DROP INDEX [IX_tbTiposFases_Codigo] ON [tbTiposFases]')
EXEC('CREATE UNIQUE NONCLUSTERED INDEX [IX_tbTiposFases_Codigo] ON [tbTiposFases]
(
	[Codigo] ASC
)')

--aviso de nova versão
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.20.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.20.0'', ''A'', ''2019-08-14 00:00'', ''2019-08-19 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.20.0'', ''V'', ''2019-08-19 08:00'', ''2019-08-19 08:00'', ''Funcionalidades da versão'', ''
<li>Melhoria de Performance:</li>
	-Grelhas gerais</br>
	-Consulta de entidades</br>
	-Navegação para as entidades</br>
'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')