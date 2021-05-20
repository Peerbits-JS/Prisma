-- CONTAS CAIXA
EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbContasCaixa]'') AND type in (N''U''))
BEGIN
CREATE TABLE tbContasCaixa (
	ID bigint IDENTITY NOT NULL,
	Codigo nvarchar(10) NOT NULL,
	Descricao nvarchar(50) NOT NULL,
	IDLoja bigint NULL,
	PorDefeito bit,
	Ativo bit NOT NULL CONSTRAINT [DF_tbContasCaixa_Ativo] DEFAULT 1,
	Sistema bit NOT NULL CONSTRAINT [DF_tbContasCaixa_Sistema] DEFAULT 0,
	DataCriacao datetime NOT NULL CONSTRAINT [DF_tbContasCaixa_DataCriacao] DEFAULT getdate(),
	UtilizadorCriacao nvarchar(256) NOT NULL CONSTRAINT [DF_tbContasCaixa_UtilizadorCriacao] DEFAULT '''',
	DataAlteracao datetime NULL CONSTRAINT [DF_tbContasCaixa_DataAlteracao] DEFAULT getdate(),
	UtilizadorAlteracao nvarchar(256) NULL CONSTRAINT [DF_tbContasCaixa_UtilizadorAlteracao] DEFAULT '''',
	F3MMarcador timestamp NULL,
	CONSTRAINT [PK_tbContasCaixa] PRIMARY KEY CLUSTERED (
		ID ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE tbContasCaixa WITH CHECK ADD CONSTRAINT FK_tbContasCaixa_tbLojas FOREIGN KEY (IDLoja) REFERENCES tbLojas(ID)
ALTER TABLE tbContasCaixa CHECK CONSTRAINT FK_tbContasCaixa_tbLojas

CREATE UNIQUE NONCLUSTERED INDEX [IX_tbContasCaixa_Codigo] ON [tbContasCaixa] (
	[Codigo] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
END')

EXEC('INSERT INTO tbContasCaixa(Codigo, Descricao, IDLoja, PorDefeito, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao)
SELECT N''CC'' + left(L.codigo,4), L.Descricao, L.ID, 1, 1, 0, getdate(), N''F3M'', NULL, NULL
FROM tbLojas L')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral]..tbMenus WHERE Descricao = ''ContasCaixa'')
BEGIN
	DECLARE @IDMenuCaixa as bigint
	DECLARE @IDModulo as bigint

	SELECT @IDMenuCaixa = ID FROM [F3MOGeral]..tbMenus WHERE Descricao = ''CaixaeBancos'' AND DescricaoAbreviada = N''014.009''
	SELECT @IDModulo = ID FROM [F3MOGeral]..tbModulos WHERE Descricao = N''Tabelas''

	INSERT INTO [F3MOGeral]..tbMenus ([IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar], [OpenType])
	VALUES (@IDMenuCaixa, N''ContasCaixa'', N''014.009.003'', N''ContasCaixa'', 1200, N''f3icon-caixa-user'', N''/Caixas/ContasCaixa'', 1, @IDModulo, 1, 1, 1, 1, 1, 0, NULL, 1, 0, getdate(), N''F3M'', NULL, NULL, NULL, NULL, NULL)

	DECLARE @IDMenuContasCaixa as bigint
	SELECT @IDMenuContasCaixa = ID FROM [F3MOGeral]..tbMenus WHERE Descricao = ''ContasCaixa''
	
	INSERT [F3MOGeral]..tbPerfisAcessos ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar])
	VALUES (1, @IDMenuContasCaixa, 1, 1, 1, 1, 0, 1, 1, 1, 0, getdate(), N''F3M'', getdate(), N''F3M'', NULL, NULL)
END')

-- MOVIMENTOS DE CAIXA
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbMapaCaixa'' AND COLUMN_NAME = ''IDContaCaixa'') 
Begin
	ALTER TABLE tbMapaCaixa ADD IDContaCaixa bigint NULL
	ALTER TABLE tbMapaCaixa ADD CONSTRAINT FK_tbMapaCaixa_tbContasCaixa FOREIGN KEY (IDContaCaixa) REFERENCES tbContasCaixa(ID)
End')

EXEC('UPDATE tbMapaCaixa
SET IDContaCaixa = CC.ID
FROM tbContasCaixa CC
WHERE tbMapaCaixa.IDLoja = CC.IDLoja')

EXEC('ALTER TABLE tbMapaCaixa ALTER COLUMN IDContaCaixa bigint NOT NULL')

-- Menu de Conta Caixa
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral]..tbMenus WHERE Descricao = ''UtilizadoresContaCaixa'')
BEGIN
	DECLARE @IDMenuAdministracao as bigint
	DECLARE @IDModulo as bigint

	SELECT @IDMenuAdministracao = ID FROM [F3MOGeral]..tbMenus WHERE Descricao = ''Administracao''
	SELECT @IDModulo = ID FROM [F3MOGeral]..tbModulos WHERE Descricao = N''Administracao''

	INSERT INTO [F3MOGeral]..tbMenus ([IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar], [OpenType])
	VALUES (@IDMenuAdministracao, N''UtilizadoresContaCaixa'', N''015.001.004'', N''UtilizadoresContaCaixa'', 2800, N''f3icon-group'', N''../F3M/Administracao/UtilizadoresContaCaixa'', 3, @IDModulo, 1, 1, 1, 1, 1, 0, NULL, 1, 1, getdate(), N''F3M'', NULL, NULL, NULL, NULL, NULL)
END')

-- atualizar view de mapa de caixa
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaCaixa'')) drop view vwMapaCaixa')

EXEC('create view [dbo].[vwMapaCaixa] as
select 
tbLojas.Codigo as CodigoLoja,
tbLojas.Descricao as DescricaoLoja,
tbFormasPagamento.Codigo as CodigoFormaPagamento,
tbFormasPagamento.Descricao as DescricaoFormaPagamento,
tbContasCaixa.Codigo as CodigoContaCaixa,
tbContasCaixa.Descricao as DescricaoContaCaixa,
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
tbMapaCaixa.IDContaCaixa as IDContaCaixa,
tbMapaCaixa.IDDocumento as IDDocumento,
tbMapaCaixa.ID as ID
FROM tbMapaCaixa AS tbMapaCaixa
LEFT JOIN tbContasCaixa AS tbContasCaixa ON tbContasCaixa.id=tbMapaCaixa.IDContaCaixa
LEFT JOIN tbFormasPagamento AS tbFormasPagamento ON tbFormasPagamento.id=tbMapaCaixa.IDFormaPagamento
LEFT JOIN tbLojas AS tbLojas ON tbLojas.id=tbMapaCaixa.IDLoja
LEFT JOIN tbMoedas as tbMoedas ON tbMoedas.ID=tbMapaCaixa.IDMoeda
LEFT JOIN tbTiposDocumento AS tbTiposDocumento ON tbTiposDocumento.ID=tbMapaCaixa.IDTipoDocumento
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries ON tbTiposDocumentoSeries.ID=tbMapaCaixa.IDTipoDocumentoSeries
ORDER BY tbMapaCaixa.ID  OFFSET 0 ROWS ')

-- atualizar colunas view de mapa de caixa
EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Caixa''
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoFormaPagamento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFormasPagamento'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoFormaPagamento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoContaCaixa'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbContasCaixa'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoContaCaixa'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150)
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

--condicao por defeito
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Caixa''
DELETE FROM [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 7, N'''', 1, CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''CodigoLoja'', 0, N''CodigoLoja'', N'''', N'''', 3, N'''', 1, CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''CodigoContaCaixa'', 0, N''CodigoContaCaixa'', N'''', N'''', 3, N'''', 1, CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'')
END')

EXEC('ALTER PROCEDURE [dbo].[sp_AtualizaMapaCaixa]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0,
	@strUtilizador AS nvarchar(256) = '''',
	@idContaCaixa As int = 0
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
											[Natureza], [Descricao], [IDMoeda], [TotalMoeda],[TaxaConversao],[TotalMoedaReferencia], [Valor], [Troco], [ValorEntregue], [IDContaCaixa], [Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao])''

				SELECT @strSqlQuery = @strSqlQueryInsert + ''select r.IDTiposDocumentoSeries,r.IDTipoDocumento,r.id as IDDocumento, r.IDLoja, r.DataDocumento, R.NumeroDocumento,rfp.IDFormaPagamento, SN.Codigo, R.Documento, 
									rfp.IDMoeda, rfp.totalmoeda, rfp.TaxaConversao, rfp.TotalMoedaReferencia, rfp.valor, rfp.Troco, rfp.ValorEntregue, '' + cast(@idContaCaixa as nvarchar(50)) + '',1,0,getdate(),'''''' + @strUtilizador + ''''''
									from tbRecibos R inner join tbTiposDocumento TD on R.IDTipodocumento=TD.ID 
									inner join tbSistemaTiposDocumentoFiscal STD on TD.IDSistemaTiposDocumentoFiscal=STD.ID
									inner join tbSistemaNaturezas SN on TD.IDSistemaNaturezas=SN.ID
									inner join tbRecibosFormasPagamento RFP on RFP.IDRecibo=R.ID
									inner join tbFormasPagamento FP on RFP.IDFormapagamento=FP.ID
									where TD.GereContaCorrente=1 AND R.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)

				SELECT @strSqlQuery = @strSqlQueryInsert + ''select r.IDTiposDocumentoSeries,r.IDTipoDocumento,r.id as IDDocumento, r.IDLoja, r.DataDocumento, R.NumeroDocumento,rfp.IDFormaPagamento, (case when SN.Codigo=''''R'''' then ''''P'''' else ''''R'''' end), R.Documento, 
									rfp.IDMoeda, rfp.totalmoeda, rfp.TaxaConversao, rfp.TotalMoedaReferencia, rfp.valor, rfp.Troco, rfp.ValorEntregue, '' + cast(@idContaCaixa as nvarchar(50)) + '',1,0,getdate(),'''''' + @strUtilizador + ''''''
									from tbDocumentosVendas R inner join tbTiposDocumento TD on R.IDTipodocumento=TD.ID 
									inner join tbSistemaTiposDocumentoFiscal STD on TD.IDSistemaTiposDocumentoFiscal=STD.ID
									inner join tbSistemaNaturezas SN on TD.IDSistemaNaturezas=SN.ID
									inner join tbDocumentosVendasFormasPagamento RFP on RFP.IDDocumentoVenda = R.ID
									inner join tbFormasPagamento FP on RFP.IDFormapagamento=FP.ID
									where R.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)

				SELECT @strSqlQuery = @strSqlQueryInsert + ''select r.IDTiposDocumentoSeries,r.IDTipoDocumento,r.id as IDDocumento, r.IDLoja, r.DataDocumento, R.NumeroDocumento,rfp.IDFormaPagamento, SN.Codigo, R.Documento, 
									rfp.IDMoeda, rfp.totalmoeda, rfp.TaxaConversao, rfp.TotalMoedaReferencia, rfp.valor, rfp.Troco, rfp.ValorEntregue, '' + cast(@idContaCaixa as nvarchar(50)) + '',1,0,getdate(),'''''' + @strUtilizador + ''''''
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

--ativar menu de oficina
exec('UPDATE [F3MOGeral].[dbo].[tbMenus] SET ATIVO=1, Ordem=5 WHERE ID=7')
exec('UPDATE [F3MOGeral].[dbo].[tbMenus] SET Ordem=6 WHERE ID=5')
exec('UPDATE [F3MOGeral].[dbo].[tbMenus] SET Ordem=7 WHERE ID=6')
exec('UPDATE [F3MOGeral].[dbo].[tbMenus] SET IDPai=7, IDModulo=7, DescricaoAbreviada=''007.001'' WHERE ID=139')
exec('update [F3MOGeral].[dbo].tbPerfisAcessos set Imprimir=0, Duplicar=0 where IDMenus=139')

--incluir conta de caixa nos movimentos de caixa
exec('update [F3MOGeral].dbo.tbListasPersonalizadas set 
query=''select Distinct D.Descricao as Descricao, D.Descricao as Documento, D.ID, D.Ativo, D.IDContaCaixa, CC.Descricao as DescricaoContaCaixa, D.IDTipoDocumentoSeries, d.IDTipoDocumento, D.IDDocumento, D.NumeroDocumento, D.IDFormaPagamento, FP.Descricao as DescricaoFormaPagamento, D.IDLoja as IDLoja, l.Descricao as DescricaoLoja, (case when D.Natureza=''''P'''' then ''''Entrada'''' else ''''Saída'''' end) as Natureza, DataDocumento, D.IDMoeda, D.TotalMoeda, d.TotalMoedareferencia, D.Descricao as DescricaoSplitterLadoDireito 
from tbmapacaixa d left join tbLojas l on d.IDloja=l.id 
inner join tbFormasPagamento FP on d.IDFormaPagamento=FP.ID 
inner join tbTiposDocumento TD on d.IDTipoDocumento is null
inner join tbContasCaixa CC on d.IDContaCaixa=CC.ID ''
where Descricao=''Movimentos de Caixa'' ')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Movimentos de Caixa''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE [IDListaPersonalizada]=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoContaCaixa'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataDocumento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoFormaPagamento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 0, 250)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Descricao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Natureza'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''TotalMoeda'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 1, 3, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDFormaPagamento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbFormasPagamento'', 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 0, 0, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDContaCaixa'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbLojas'', 0, 0, 150)
END')

--aviso de versão 1.22
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.22.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.22.0'', ''A'', ''2019-11-14 00:00'', ''2019-11-19 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.22.0'', ''V'', ''2019-11-19 08:00'', ''2019-11-19 08:00'', ''Funcionalidades da versão'', ''
<li>Gestão de Caixa</li>
		&emsp;Caixas em simultâneo por loja<br>
		&emsp;Movimentos de acerto com o caixa fechado<br>
<li>Transferência de Stocks</li>
		&emsp;Sugestão de armazém de entrada<br>
<li>Serviços</li>
		&emsp;Edição de serviço no estado Efetivo<br>
		&emsp;Edição das medições após Faturação<br>
<li>Oficina</li>
		&emsp;Substituição de Artigos do Serviço<br>
'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')


-- CONTA CAIXA NOS PAGAMENTOS

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbPagamentosVendas'' AND COLUMN_NAME = ''IDContaCaixa'') 
Begin
	ALTER TABLE tbPagamentosVendas ADD IDContaCaixa bigint NULL
	ALTER TABLE tbPagamentosVendas ADD CONSTRAINT FK_tbPagamentosVendas_tbContasCaixa FOREIGN KEY (IDContaCaixa) REFERENCES tbContasCaixa(ID)
End')