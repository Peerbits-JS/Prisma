/* ACT BD EMPRESA VERSAO 39*/
--novo campo nas especialidades
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbespecialidades'' AND COLUMN_NAME = ''EContactologia'') 
Begin
	ALTER TABLE [dbo].[tbespecialidades] ADD EContactologia bit not null default (0) with values
End')
EXEC('update tbespecialidades set Econtactologia=1 where descricao=''CONTATOLOGIA''')

--modificar os nomes das categorias de consultas
EXEC('
BEGIN
UPDATE [F3MOGeral].[dbo].[tbSistemaCategListasPers] SET Descricao=''Stocks'' WHERE Descricao=''Artigos''
UPDATE [F3MOGeral].[dbo].[tbSistemaCategListasPers] SET Descricao=''Compras'' WHERE Descricao=''Fornecedores''
UPDATE [F3MOGeral].[dbo].[tbSistemaCategListasPers] SET Descricao=''Vendas'' WHERE Descricao=''Clientes''
END')

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

----performance de médico técnico

--funções de calculo
EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnRetornaExamesContactologiaMedTec]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnRetornaExamesContactologiaMedTec]')

EXEC('CREATE FUNCTION  [dbo].[fnRetornaExamesContactologiaMedTec](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja BIGINT
)
RETURNS TABLE
AS
RETURN 
(
SELECT DISTINCT IDMedicoTecnico, COUNT(*) AS ''COUNT''
FROM tbExames AS E
	INNER JOIN tbEspecialidades AS ESP ON ESP.ID = E.IDEspecialidade
WHERE 
	IDMedicoTecnico IS NOT NULL
	AND ESP.EContactologia= 1
	AND (CAST(FLOOR(CAST(E.DataExame AS float)) AS datetime) >= @DataDe OR @DataDe IS NULL)
	AND (CAST(FLOOR(CAST(E.DataExame AS float)) AS datetime) <= @DataDe OR @DataDe IS NULL)
	AND (E.IDLoja = @IDLoja OR @IDLoja IS NULL)
GROUP BY E.IDMedicoTecnico
)
')

EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnRetornaExamesMedTec]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnRetornaExamesMedTec]')

EXEC('CREATE FUNCTION  [dbo].[fnRetornaExamesMedTec](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja BIGINT
)
RETURNS TABLE
AS
RETURN 
(
SELECT DISTINCT IDMedicoTecnico, COUNT(*) AS ''COUNT''
FROM tbExames AS E
WHERE 
	IDMedicoTecnico IS NOT NULL
	AND (CAST(FLOOR(CAST(E.DataExame AS float)) AS datetime) >= @DataDe OR @DataDe IS NULL)
	AND (CAST(FLOOR(CAST(E.DataExame AS float)) AS datetime) <= @DataDe OR @DataDe IS NULL)
	AND (E.IDLoja = @IDLoja OR @IDLoja IS NULL)
GROUP BY E.IDMedicoTecnico
)
')


EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnRetornaServicosComTipoArtigoMedTec]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnRetornaServicosComTipoArtigoMedTec]')

EXEC('CREATE FUNCTION  [dbo].[fnRetornaServicosComTipoArtigoMedTec](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@IDTipoArtigo AS BIGINT)
RETURNS TABLE
AS
RETURN 
(
SELECT T.IDMedicoTecnico, SUM(CASE WHEN T.IDTipoArtigo IS NOT NULL THEN 1 ELSE 0 END) AS ''COUNT''
 FROM (
 SELECT DISTINCT MT.ID AS ''IDMedicoTecnico''  , V.ID, A.IDTipoArtigo
FROM tbMedicosTecnicos AS MT
	INNER JOIN tbServicos AS S ON S.IDMedicoTecnico = MT.ID
	INNER JOIN tbDocumentosVendas AS V ON V.ID = S.IDDocumentoVenda
	INNER JOIN tbDocumentosVendasLinhas AS VL ON VL.IDDocumentoVenda = V.ID
	INNER JOIN tbEstados AS E ON E.ID = V.IDEstado
	INNER JOIN tbSistemaTiposEstados AS TE ON TE.ID = E.IDTipoEstado
	LEFT JOIN tbCampanhas AS C ON C.ID = VL.IDCampanha
	INNER JOIN tbArtigos AS A ON A.ID = VL.IDArtigo AND A.IDTipoArtigo = @IDTipoArtigo
WHERE 
	TE.Codigo = ''EFT''
	AND A.IDTipoArtigo = @IDTipoArtigo
	AND (V.DataDocumento >= @DataDe OR @DataDe IS NULL)
	AND (V.DataDocumento <= @DataAte OR @DataAte IS NULL )
	AND (V.IDLoja = @IDLoja OR @IDLoja IS NULL)
	AND (C.ID = @IDCampanha OR @IDCampanha IS NULL)
) AS T
GROUP BY T.IDMedicoTecnico
)
')


EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnRetornaServicosContactologiaMedTec]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnRetornaServicosContactologiaMedTec]')

EXEC('CREATE FUNCTION  [dbo].[fnRetornaServicosContactologiaMedTec](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT
)
RETURNS TABLE
AS
RETURN 
(

SELECT T.IDMedicoTecnico, SUM(CASE WHEN T.ID IS NOT NULL THEN 1 ELSE 0 END) AS ''COUNT''
FROM 
(
SELECT DISTINCT MT.ID AS ''IDMedicoTecnico'', V.ID
FROM tbMedicosTecnicos AS MT
	INNER JOIN tbServicos AS S ON S.IDMedicoTecnico = MT.ID
	INNER JOIN tbSistemaTiposServicos AS TS ON TS.ID = S.IDTipoServico
	INNER JOIN tbDocumentosVendas AS V ON V.ID = S.IDDocumentoVenda
	INNER JOIN tbDocumentosVendasLinhas AS VL ON  VL.IDDocumentoVenda = V.ID
	INNER JOIN tbEstados AS E ON E.ID = V.IDEstado
	INNER JOIN tbSistemaTiposEstados AS TE ON TE.ID = E.IDTipoEstado
	LEFT JOIN tbCampanhas AS C ON C.ID = VL.IDCampanha
WHERE
	TS.Codigo = ''C''
	AND TE.Codigo = ''EFT''
	AND (V.DataDocumento >= @DataDe OR @DataDe IS NULL)
	AND (V.DataDocumento <= @DataAte OR @DataAte IS NULL )
	AND (V.IDLoja = @IDLoja OR @IDLoja IS NULL)
	AND (C.ID = @IDCampanha OR @IDCampanha IS NULL)
)
AS T
GROUP BY T.IDMedicoTecnico
)
')


EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnRetornaServicosMedTec]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnRetornaServicosMedTec]')

EXEC('CREATE FUNCTION  [dbo].[fnRetornaServicosMedTec](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT
)
RETURNS TABLE
AS
RETURN 
(
SELECT T.IDMedicoTecnico, SUM(CASE WHEN T.ID IS NOT NULL THEN 1 ELSE 0 END) AS ''COUNT''
FROM 
(
SELECT DISTINCT MT.ID AS ''IDMedicoTecnico'', V.ID
FROM tbMedicosTecnicos AS MT
	INNER JOIN tbServicos AS S ON S.IDMedicoTecnico = MT.ID
	INNER JOIN tbDocumentosVendas AS V ON V.ID = S.IDDocumentoVenda
	INNER JOIN tbDocumentosVendasLinhas AS VL ON  VL.IDDocumentoVenda = V.ID
	INNER JOIN tbEstados AS E ON E.ID = V.IDEstado
	INNER JOIN tbSistemaTiposEstados AS TE ON TE.ID = E.IDTipoEstado
	LEFT JOIN tbCampanhas AS C ON C.ID = VL.IDCampanha
WHERE
	 TE.Codigo = ''EFT''
	AND (V.DataDocumento >= @DataDe OR @DataDe IS NULL)
	AND (V.DataDocumento <= @DataAte OR @DataAte IS NULL )
	AND (V.IDLoja = @IDLoja OR @IDLoja IS NULL)
	AND (C.ID = @IDCampanha OR @IDCampanha IS NULL)
)
AS T
GROUP BY T.IDMedicoTecnico
)
')

EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnPerformanceMedicoTecnico]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnPerformanceMedicoTecnico]')

EXEC('CREATE FUNCTION  [dbo].[fnPerformanceMedicoTecnico](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@IDTipoArtigo AS BIGINT,
	@IDMedicoTecnico AS BIGINT)
RETURNS TABLE
AS
RETURN 
(
	SELECT ID AS ''IDMedicoTecnico'', 
	MT.Nome AS ''DescricaoMedicoTecnico'', 
	S.COUNT AS ''NumServicos'', 
	SC.COUNT AS ''NumServicosContactologia'', 
	E.COUNT AS ''NumExames'', 
	EC.COUNT AS ''NumExamesContactologia'',
	STA.COUNT AS ''NumServicosSaudeOcularAux'',
	ISNULL(ROUND((CAST(S.COUNT AS float) / CAST(E.COUNT AS float)) * 100, 2), 0) AS ''PercConsultasServicos'',
	ISNULL(ROUND((CAST(EC.COUNT AS float) / CAST( E.COUNT AS float)) * 100, 2), 0)  AS ''PercExamesContactologia'',
	ISNULL(ROUND((CAST(SC.COUNT AS float) / CAST( EC.COUNT AS float)) * 100, 2), 0)  AS ''PercContactologiaServico'',
	ISNULL(STA.COUNT, 0) AS ''NumServicosSaudeOcular'',
	ISNULL(ROUND((CAST(STA.COUNT AS float) / CAST( E.COUNT AS float)) * 100, 2), 0)  AS ''PercNumServicosSaudeOcular'',
	0 as NumServicosSaudeOcularnumcasasdecimais
	FROM tbMedicosTecnicos AS MT
		LEFT JOIN fnRetornaServicosMedTec(@DataDe, @DataAte, @IDLoja, @IDCampanha) AS S ON S.IDMedicoTecnico = MT.ID
		LEFT JOIN fnRetornaExamesMedTec(@DataDe, @DataAte, @IDLoja) AS E  ON E.IDMedicoTecnico = MT.ID
		LEFT JOIN fnRetornaExamesContactologiaMedTec(@DataDe, @DataAte, @IDLoja) AS EC ON EC.IDMedicoTecnico = MT.ID
		LEFT JOIN fnRetornaServicosContactologiaMedTec(@DataDe, @DataAte, @IDLoja, @IDCampanha) AS SC ON SC.IDMedicoTecnico = MT.ID
		LEFT JOIN fnRetornaServicosComTipoArtigoMedTec(@DataDe, @DataAte, @IDLoja, @IDCampanha, @IDTipoArtigo) AS STA ON STA.IDMedicoTecnico = MT.ID
	WHERE
	MT.IDUtilizador IS NOT NULL
	AND (MT.ID = @IDMedicoTecnico OR @IDMedicoTecnico IS NULL)
	ORDER BY MT.Nome OFFSET 0 ROWS
)
')

--nova vista
EXEC('
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
DELETE FROM [dbo].[tbMapasVistas] WHERE ID=46
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (46, 46, N''PerformanceMedicoTecnico'', N''PerformanceMedicoTecnico'', N''rptPerformanceMedicoTecnico'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, N''SELECT * FROM [dbo].[fnPerformanceMedicoTecnico] (1)'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')

--lista personalizada
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Performance de Médico/Técnico'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDCateg as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Performance de Médico/Técnico'', @IDUtil, 0, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''fnPerformanceMedicoTecnico'', 
N''SELECT * FROM [dbo].[fnPerformanceMedicoTecnico] ([@DataDe],[@DataAte], [@IDLojaF], [@IDCampanha], [@IDTipoArtigo], [@IDMedicoTecnico])'', 3, 2)
END')

--colunas da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Performance de Médico/Técnico''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''IDMedicoTecnico'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 5, 150, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''DescricaoMedicoTecnico'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 300, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''NumServicos'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''NumServicosContactologia'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''NumExames'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''NumExamesContactologia'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''NumServicosSaudeOcularAux'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''PercConsultasServicos'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''PercExamesContactologia'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''PercContactologiaServico'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''NumServicosSaudeOcular'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''PercNumServicosSaudeOcular'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
END')


--parâmetros da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Performance de Médico/Técnico''
DELETE FROM [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais]) VALUES (@IDLista, N''Médico Técnico'', N''F3MLookup'', 100, NULL, N''IDMedicoTecnico'', N''Long'', 0, 1, NULL, N''../TabelasAuxiliares/MedicosTecnicos'', N''../../TabelasAuxiliares/MedicosTecnicos/IndexGrelha'', N''Nome'', 1, 1, CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', N''col-f3m col-3'', 0, NULL, NULL, 2, N''tbMedicosTecnicos'', NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais]) VALUES (@IDLista, N''Loja'', N''F3MLookup'', 300, NULL, N''IDLojaF'', N''Long'', 0, 1, NULL, N''../Admin/Lojas'', N''../../Admin/Lojas/IndexGrelha'', NULL, 1, 1, CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', N''col-f3m col-3'', 0, NULL, NULL, 1, N''tbLojas'', NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais]) VALUES (@IDLista, N''Campanha'', N''F3MLookup'', 300, NULL, N''IDCampanha'', N''Long'', 0, 1, NULL, N''../TabelasAuxiliares/Campanhas'', N''../../TabelasAuxiliares/Campanhas/Index'', NULL, 1, 1, CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', N''col-f3m col-3'', 0, NULL, NULL, 2, N''tbCampanhas'', NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais]) VALUES (@IDLista, N''Tipo de Artigo'', N''F3MDropDownList'', 400, NULL, N''IDTipoArtigo'', N''Long'', 0, 1, NULL, N''../TabelasAuxiliares/TiposArtigos'', NULL, NULL, 1, 1, CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', N''col-f3m col-3'', 1, NULL, NULL, 1, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais]) VALUES (@IDLista, N''De'', N''F3MData'', 100, NULL, N''DataDe'', N''Date'', 0, 1, N'''', NULL, NULL, NULL, 1, 1, CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''MAF'', CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''MAF'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais]) VALUES (@IDLista, N''Até'', N''F3MData'', 200, NULL, N''DataAte'', N''Date'', 0, 1, N'''', NULL, NULL, NULL, 1, 1, CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''MAF'', CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''MAF'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL, NULL)
END')

--agregadores da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
DECLARE @IDConfiguracao as bigint

SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Performance de Médico/Técnico''
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista

DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasGruposPorDefeito] where IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] where IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] where IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE ID=@IDConfiguracao

INSERT [F3MOGeral].[dbo].[tbConfiguracoesConsultas] ([IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, 1, 1, CAST(N''2018-04-27 17:39:52.217'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:39:52.217'' AS DateTime), N''F3M'')
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista

INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''PercConsultasServicos'', N''average'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''PercExamesContactologia'', N''average'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''PercContactologiaServico'', N''average'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''NumServicosSaudeOcular'', N''average'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''PercNumServicosSaudeOcular'', N''average'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
END')



----performance de utilizador
--funções de calculo
EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnDocumentosVendasTiposArtigos]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnDocumentosVendasTiposArtigos]')

EXEC('CREATE FUNCTION  [dbo].[fnDocumentosVendasTiposArtigos](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@UtilizadorCriacao AS NVARCHAR(50),
	@Idade AS INT
)
RETURNS TABLE
AS
RETURN 
(

select V.UtilizadorCriacao, VL.iddocumentovenda, datadocumento, TSN.codigo as Natureza,
sum(case when TA.codigo=''AR'' then VL.Quantidade else 0 end) as AR,
sum(case when TA.codigo=''LC'' then VL.Quantidade else 0 end) as LC,
sum(case when TA.codigo=''LO'' then VL.Quantidade else 0 end) as LO,
sum(case when TA.codigo=''OS'' then VL.Quantidade else 0 end) as OS,
sum(case when MO.IDTipoLente=3 then VL.Quantidade else 0 end) as PRG,
sum(VL.valorincidencia*(case when TSN.Codigo=''P'' then -1 else 1 end)) as valorincidencia
from 
	tbDocumentosVendas AS V 
	INNER JOIN tbDocumentosVendasLinhas AS VL ON VL.IDDocumentoVenda = v.ID
	INNER JOIN tbartigos A ON VL.IDartigo=A.id
	INNER JOIN tbClientes AS CL ON V.IDEntidade = CL.ID
	LEFT JOIN tbtiposartigos TA ON A.IDtipoartigo=TA.id
	LEFT JOIN tbLentesOftalmicas LO ON LO.IDartigo=A.id
	LEFT JOIN tbModelos MO ON LO.IDModelo=mo.id
	LEFT JOIN tbLojas AS L ON L.ID = V.IDLoja
	LEFT JOIN tbCampanhas AS C ON C.ID = VL.IDCampanha
	LEFT JOIN tbTiposDocumento TD ON TD.ID=V.IDTipoDocumento
	LEFT JOIN tbsistemanaturezas TSN ON TD.IDsistemanaturezas=TSN.ID
where 
	CodigoTipoEstado=''EFT'' and TD.idsistematiposdocumento=14
	AND (V.UtilizadorCriacao= @UtilizadorCriacao OR @UtilizadorCriacao IS NULL)
	AND (V.DataDocumento >= @DataDe OR @DataDe IS NULL)
	AND (V.DataDocumento <= @DataAte OR @DataAte IS NULL )
	AND (L.ID = @IDLoja OR @IDLoja IS NULL)
	AND (C.ID = @IDCampanha OR @IDCampanha IS NULL)
	AND (isnull(datediff(YYYY,cl.DataNascimento, v.DataDocumento),0)>=@Idade OR @Idade IS NULL)

group by V.UtilizadorCriacao, VL.iddocumentovenda, datadocumento, TSN.Codigo
)
')

EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnDocumentosVendasCruzadas]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnDocumentosVendasCruzadas]')

EXEC('CREATE FUNCTION  [dbo].[fnDocumentosVendasCruzadas](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@UtilizadorCriacao AS NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN 
(

select UtilizadorCriacao, sum(case when natureza=''R'' then 1 else -1 end) as ''NumVendas'' from
(select UtilizadorCriacao, iddocumentovenda, natureza from [fnDocumentosVendasTiposArtigos] (@DataDe,@DataAte,@IDLoja,@IDCampanha,@UtilizadorCriacao,null)
group by UtilizadorCriacao,iddocumentovenda, natureza 
having 
(sum(ar)>=1 and sum(lo)>=2 and sum(lc)>=1) or
(sum(ar)>=1 and sum(lo)>=2 and sum(os)>=1) or 
(sum(ar)>=2 and sum(lo)>=4) or 
(sum(lc)>=1 and sum(os)>=1)  
) T
group by UtilizadorCriacao
)
')

EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnDocumentosVendasOculos]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnDocumentosVendasOculos]')

EXEC('CREATE FUNCTION  [dbo].[fnDocumentosVendasOculos](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@UtilizadorCriacao AS NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN 
(

select UtilizadorCriacao, SUM(valorincidencia) as ''TotalSemIva'', sum(case when natureza=''R'' then 1 else -1 end) as ''NumVendas''  from
(select UtilizadorCriacao, iddocumentovenda, valorincidencia, natureza from [fnDocumentosVendasTiposArtigos] (@DataDe,@DataAte,@IDLoja,@IDCampanha,@UtilizadorCriacao,null)
group by UtilizadorCriacao,iddocumentovenda,valorincidencia, natureza 
having 
(sum(ar)>=1 and sum(lo)>=2)  
) T
group by UtilizadorCriacao
)
')

EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnDocumentosVendasTiposArtigosTipo]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnDocumentosVendasTiposArtigosTipo]')

EXEC('CREATE FUNCTION  [dbo].[fnDocumentosVendasTiposArtigosTipo](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@UtilizadorCriacao AS NVARCHAR(50),
	@Idade AS INT,
	@Tipo AS NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN 
(

select V.UtilizadorCriacao, VL.iddocumentovenda, datadocumento, TSN.codigo as Natureza,
sum(case when TA.codigo=''AR'' then VL.Quantidade else 0 end) as AR,
sum(case when TA.codigo=''LC'' then VL.Quantidade else 0 end) as LC,
sum(case when TA.codigo=''LO'' then VL.Quantidade else 0 end) as LO,
sum(case when TA.codigo=''OS'' then VL.Quantidade else 0 end) as OS,
sum(case when MO.IDTipoLente=3 then VL.Quantidade else 0 end) as PRG,
sum((case when TA.codigo=@Tipo then VL.valorincidencia else 0 end)*(case when TSN.Codigo=''P'' then -1 else 1 end)) as valorincidencia
from 
	tbDocumentosVendas AS V 
	INNER JOIN tbDocumentosVendasLinhas AS VL ON VL.IDDocumentoVenda = v.ID
	INNER JOIN tbartigos A ON VL.IDartigo=A.id
	INNER JOIN tbClientes AS CL ON V.IDEntidade = CL.ID
	LEFT JOIN tbtiposartigos TA ON A.IDtipoartigo=TA.id
	LEFT JOIN tbLentesOftalmicas LO ON LO.IDartigo=A.id
	LEFT JOIN tbModelos MO ON LO.IDModelo=mo.id
	LEFT JOIN tbLojas AS L ON L.ID = V.IDLoja
	LEFT JOIN tbCampanhas AS C ON C.ID = VL.IDCampanha
	LEFT JOIN tbTiposDocumento TD ON TD.ID=V.IDTipoDocumento
	LEFT JOIN tbsistemanaturezas TSN ON TD.IDsistemanaturezas=TSN.ID
where 
	CodigoTipoEstado=''EFT'' and TD.idsistematiposdocumento=14
	AND (V.UtilizadorCriacao= @UtilizadorCriacao OR @UtilizadorCriacao IS NULL)
	AND (V.DataDocumento >= @DataDe OR @DataDe IS NULL)
	AND (V.DataDocumento <= @DataAte OR @DataAte IS NULL )
	AND (L.ID = @IDLoja OR @IDLoja IS NULL)
	AND (C.ID = @IDCampanha OR @IDCampanha IS NULL)
	AND (isnull(datediff(YYYY,cl.DataNascimento, v.DataDocumento),0)>=@Idade OR @Idade IS NULL)

group by V.UtilizadorCriacao, VL.iddocumentovenda, datadocumento, TSN.Codigo
)
')


EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnDocumentosVendasOS]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnDocumentosVendasOS]')

EXEC('CREATE FUNCTION  [dbo].[fnDocumentosVendasOS](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@UtilizadorCriacao AS NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN 
(

select UtilizadorCriacao, SUM(valorincidencia) as ''TotalSemIva'', sum(case when natureza=''R'' then os else -1*os end) as ''NumVendas''  from
(select UtilizadorCriacao, iddocumentovenda, valorincidencia, natureza, os from [fnDocumentosVendasTiposArtigosTipo] (@DataDe,@DataAte,@IDLoja,@IDCampanha,@UtilizadorCriacao,null,''OS'')
group by UtilizadorCriacao,iddocumentovenda,valorincidencia, natureza,os 
having 
(sum(os)>=1)  
) T
group by UtilizadorCriacao
)
')

EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnDocumentosVendasLC]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnDocumentosVendasLC]')

EXEC('CREATE FUNCTION  [dbo].[fnDocumentosVendasLC](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@UtilizadorCriacao AS NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN 
(

select UtilizadorCriacao, SUM(valorincidencia) as ''TotalSemIva'', sum(case when natureza=''R'' then lc else -1*lc end) as ''NumVendas''  from
(select UtilizadorCriacao, iddocumentovenda, valorincidencia, natureza, lc from [fnDocumentosVendasTiposArtigosTipo] (@DataDe,@DataAte,@IDLoja,@IDCampanha,@UtilizadorCriacao,null,''LC'')
group by UtilizadorCriacao,iddocumentovenda,valorincidencia, natureza, lc 
having 
(sum(lc)>=1)  
) T
group by UtilizadorCriacao
)
')

EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnDocumentosVendasPRG]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnDocumentosVendasPRG]')

EXEC('CREATE FUNCTION  [dbo].[fnDocumentosVendasPRG](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@UtilizadorCriacao AS NVARCHAR(50),
	@Idade AS BIGINT
)
RETURNS TABLE
AS
RETURN 
(

select UtilizadorCriacao, SUM(valorincidencia) as ''TotalSemIva'', sum(case when natureza=''R'' then 1 else -1 end) as ''NumVendas''  from
(select UtilizadorCriacao, iddocumentovenda, valorincidencia, natureza from [fnDocumentosVendasTiposArtigos] (@DataDe,@DataAte,@IDLoja,@IDCampanha,@UtilizadorCriacao,@Idade)
group by UtilizadorCriacao,iddocumentovenda,valorincidencia, natureza 
having 
(sum(prg)>=1)  
) T
group by UtilizadorCriacao
)
')

EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnDocumentosVendasIdade]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnDocumentosVendasIdade]')

EXEC('CREATE FUNCTION  [dbo].[fnDocumentosVendasIdade](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@UtilizadorCriacao AS NVARCHAR(50),
	@Idade AS INT
)
RETURNS TABLE
AS
RETURN 
(

select UtilizadorCriacao, sum(case when natureza=''R'' then 1 else -1 end) as ''NumVendas''  from
(select UtilizadorCriacao, iddocumentovenda, natureza from [fnDocumentosVendasTiposArtigos] (@DataDe,@DataAte,@IDLoja,@IDCampanha,@UtilizadorCriacao,@Idade)
group by UtilizadorCriacao,iddocumentovenda, natureza
having 
(sum(lo)>=1)  
) T
group by UtilizadorCriacao
)
')

EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnDocumentosVendasClientesPorDia]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnDocumentosVendasClientesPorDia]')

EXEC('CREATE FUNCTION  [dbo].[fnDocumentosVendasClientesPorDia](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@UtilizadorCriacao AS NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN 
(
SELECT SUM(NumClientes) as NumClientes, UtilizadorCriacao from (
SELECT COUNT(DISTINCT V.IDEntidade) as ''NumClientes'' , v.DataDocumento, V.UtilizadorCriacao
FROM 
	tbDocumentosVendas AS V 
	INNER JOIN tbLojas AS L ON L.ID = V.IDLoja
	INNER JOIN tbDocumentosVendasLinhas AS VL ON VL.IDDocumentoVenda = v.ID
	LEFT JOIN tbCampanhas AS C ON C.ID = VL.IDCampanha
	LEFT JOIN tbTiposDocumento ON tbTiposDocumento.ID=V.IDTipoDocumento
	LEFT JOIN tbsistemanaturezas ON tbTiposDocumento.IDsistemanaturezas=tbsistemanaturezas.ID
WHERE 
	CodigoTipoEstado=''EFT'' and tbTiposDocumento.idsistematiposdocumento=14
	AND (V.UtilizadorCriacao= @UtilizadorCriacao OR @UtilizadorCriacao IS NULL)
	AND (V.DataDocumento >= @DataDe OR @DataDe IS NULL)
	AND (V.DataDocumento <= @DataAte OR @DataAte IS NULL )
	AND (L.ID = @IDLoja OR @IDLoja IS NULL)
	AND (C.ID = @IDCampanha OR @IDCampanha IS NULL)
GROUP BY v.DataDocumento, V.UtilizadorCriacao
) T
GROUP BY UtilizadorCriacao
)
')

EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnDocumentosVendasTotalSemIva]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnDocumentosVendasTotalSemIva]')

EXEC('CREATE FUNCTION  [dbo].[fnDocumentosVendasTotalSemIva](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@UtilizadorCriacao AS NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN 
(
SELECT V.UtilizadorCriacao, sum(Vl.ValorIncidencia) as totalsemiva
FROM 
	tbDocumentosVendas AS V 
	INNER JOIN tbLojas AS L ON L.ID = V.IDLoja
	INNER JOIN tbDocumentosVendasLinhas AS VL ON VL.IDDocumentoVenda = v.ID
	LEFT JOIN tbCampanhas AS C ON C.ID = VL.IDCampanha
	LEFT JOIN tbTiposDocumento ON tbTiposDocumento.ID=V.IDTipoDocumento
	LEFT JOIN tbsistemanaturezas ON tbTiposDocumento.IDsistemanaturezas=tbsistemanaturezas.ID
WHERE 
	CodigoTipoEstado=''EFT'' and tbTiposDocumento.idsistematiposdocumento=14
	AND (V.UtilizadorCriacao= @UtilizadorCriacao OR @UtilizadorCriacao IS NULL)
	AND (V.DataDocumento >= @DataDe OR @DataDe IS NULL)
	AND (V.DataDocumento <= @DataAte OR @DataAte IS NULL )
	AND (L.ID = @IDLoja OR @IDLoja IS NULL)
	AND (C.ID = @IDCampanha OR @IDCampanha IS NULL)
GROUP BY V.UtilizadorCriacao
)
')

EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnPerformanceUtilizador]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnPerformanceUtilizador]')

EXEC('CREATE FUNCTION  [dbo].[fnPerformanceUtilizador](
	@DataDe AS DATE,
	@DataAte AS DATE,
	@IDLoja AS BIGINT,
	@IDCampanha AS BIGINT,
	@UtilizadorCriacao AS NVARCHAR(50),
	@Idade AS BIGINT)
RETURNS TABLE
AS
RETURN 
(
	SELECT distinct mt.UtilizadorCriacao, isnull(dia.NumClientes,0) as ''NumClientesDiferentes'', isnull(iva.totalsemiva,0) as ''TotalSemIva'',
	cast((case when isnull(dia.NumClientes,0)=0 then 0 else (isnull(iva.totalsemiva,0)/isnull(dia.NumClientes,0)) end) as decimal (20,2))  as ''VendaMedia'', isnull(CRZ.NumVendas,0) as ''NumVendasCruzadas'',
	isnull(OCL.NumVendas,0) as ''NumVendasOculos'', (case when isnull(OCL.NumVendas,0)=0 then 0 else (CAST(isnull(OCL.TotalSemIva,0)/isnull(OCL.NumVendas,0) AS decimal (20,2))) end) as ''ValorMedioOculos'',
	isnull(LC.NumVendas,0) as ''NumVendasLC'', (case when isnull(LC.NumVendas,0)=0 then 0 else (CAST(isnull(LC.TotalSemIva,0)/isnull(LC.NumVendas,0) AS decimal (20,2))) end) as ''ValorMedioLC'',
	isnull(OS.NumVendas,0) as ''NumVendasOS'', (case when isnull(OS.NumVendas,0)=0 then 0 else (CAST(isnull(OS.TotalSemIva,0)/isnull(OS.NumVendas,0) AS decimal (20,2))) end) as ''ValorMedioOS'',
	isnull(PRG.NumVendas,0) as ''NumVendasPRG'', isnull(IDA.NumVendas,0) as ''NumVendasIdade'',
	cast((case when isnull(IDA.NumVendas,0)=0 then 0 else isnull(PRG.Numvendas,0)*100/isnull(IDA.NumVendas,0) end) as decimal (20,2)) as ''Eficiencia'',
	0 as NumClientesDiferentesnumcasasdecimais, 2 as TotalSemIvanumcasasdecimais, 2 as VendaMedianumcasasdecimais,0 as NumVendasCruzadasnumcasasdecimais, 0 as NumVendasOculosnumcasasdecimais, 2 as ValorMedioOculosnumcasasdecimais,  
	0 as NumVendasLCnumcasasdecimais, 2 as ValorMedioLCnumcasasdecimais, 0 as NumVendasOSnumcasasdecimais, 2 as ValorMedioOSnumcasasdecimais, 2 as EficienciaLCnumcasasdecimais
	FROM (select distinct UtilizadorCriacao from tbdocumentosvendas) AS MT
		LEFT JOIN fnDocumentosVendasClientesPorDia(@DataDe, @DataAte, @IDLoja, @IDCampanha, @UtilizadorCriacao) AS DIA ON DIA.UtilizadorCriacao=MT.UtilizadorCriacao 
		LEFT JOIN fnDocumentosVendasTotalSemIva(@DataDe, @DataAte, @IDLoja, @IDCampanha, @UtilizadorCriacao) AS IVA ON IVA.UtilizadorCriacao=MT.UtilizadorCriacao 
		LEFT JOIN fnDocumentosVendasCruzadas(@DataDe, @DataAte, @IDLoja, @IDCampanha, @UtilizadorCriacao) AS CRZ ON CRZ.UtilizadorCriacao=MT.UtilizadorCriacao
		LEFT JOIN fnDocumentosVendasLC(@DataDe, @DataAte, @IDLoja, @IDCampanha, @UtilizadorCriacao) AS LC ON LC.UtilizadorCriacao=MT.UtilizadorCriacao
		LEFT JOIN fnDocumentosVendasOculos(@DataDe, @DataAte, @IDLoja, @IDCampanha, @UtilizadorCriacao) AS OCL ON OCL.UtilizadorCriacao=MT.UtilizadorCriacao
		LEFT JOIN fnDocumentosVendasOS(@DataDe, @DataAte, @IDLoja, @IDCampanha, @UtilizadorCriacao) AS OS ON OS.UtilizadorCriacao=MT.UtilizadorCriacao
		LEFT JOIN fnDocumentosVendasPRG(@DataDe, @DataAte, @IDLoja, @IDCampanha, @UtilizadorCriacao, @Idade) AS PRG ON PRG.UtilizadorCriacao=MT.UtilizadorCriacao
		LEFT JOIN fnDocumentosVendasIdade(@DataDe, @DataAte, @IDLoja, @IDCampanha, @UtilizadorCriacao, @Idade) AS IDA ON IDA.UtilizadorCriacao=MT.UtilizadorCriacao
	WHERE (MT.UtilizadorCriacao=@UtilizadorCriacao OR @UtilizadorCriacao IS NULL)
	ORDER BY mt.UtilizadorCriacao OFFSET 0 ROWS
) 
')

--nova vista
EXEC('
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
DELETE FROM [dbo].[tbMapasVistas] WHERE ID=47
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) 
VALUES (47, 47, N''PerformanceUtilizador'', N''PerformanceUtilizador'', N''rptPerformanceUtilizador'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, N''SELECT * FROM [dbo].[fnPerformanceUtilizador] (1)'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')

--lista personalizada
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Performance de Utilizador'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDCateg as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Consultas''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Performance de Utilizador'', @IDUtil, 0, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''fnPerformanceUtilizador'', 
N''SELECT * FROM [dbo].[fnPerformanceUtilizador] ([@DataDe], [@DataAte], [@IDLojaF], [@IDCampanha], [@IDUtilizadorF], [@Idade])'', 3, 2)
END')

--colunas da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Performance de Utilizador''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''UtilizadorCriacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''NumClientesDiferentes'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''TotalSemIva'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''VendaMedia'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''NumVendasCruzadas'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''NumVendasOculos'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''ValorMedioOculos'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''NumVendasOS'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''ValorMedioOS'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''NumVendasLC'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''ValorMedioLC'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth],[ECondicao],[EColunaGrelha]) VALUES (N''Eficiencia'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0, 1)
END')

--parâmetros da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Performance de Utilizador''
DELETE FROM [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais]) VALUES (@IDLista, N''Utilizador'', N''F3MLookup'', 500, NULL, N''IDUtilizadorF'', N''Long'', 0, 1, NULL, N''../Admin/Utilizadores'', N''../../Admin/Utilizadores/IndexGrelha'', N''Nome'', 1, 1, CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', N''col-f3m col-3'', 0, NULL, NULL, 2, N''tbUtilizadores'', NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais]) VALUES (@IDLista, N''Loja'', N''F3MLookup'', 300, NULL, N''IDLojaF'', N''Long'', 0, 1, NULL, N''../Admin/Lojas'', N''../../Admin/Lojas/IndexGrelha'', NULL, 1, 1, CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', N''col-f3m col-3'', 0, NULL, NULL, 1, N''tbLojas'', NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais]) VALUES (@IDLista, N''Campanha'', N''F3MLookup'', 600, NULL, N''IDCampanha'', N''Long'', 0, 1, NULL, N''../TabelasAuxiliares/Campanhas'', N''../../TabelasAuxiliares/Campanhas/Index'', NULL, 1, 1, CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', N''col-f3m col-3'', 0, NULL, NULL, 2, N''tbCampanhas'', NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais]) VALUES (@IDLista, N''Idade'', N''F3MNumeroInteiro'', 600, NULL, N''Idade'', N''Long'', 0, 1, 44, NULL, NULL, NULL, 1, 1, CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''F3M'', N''col-f3m col-3'', 1, NULL, NULL, 1, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais]) VALUES (@IDLista, N''De'', N''F3MData'', 100, NULL, N''DataDe'', N''Date'', 0, 1, N'''', NULL, NULL, NULL, 1, 1, CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''MAF'', CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''MAF'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL, NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais]) VALUES (@IDLista, N''Até'', N''F3MData'', 200, NULL, N''DataAte'', N''Date'', 0, 1, N'''', NULL, NULL, NULL, 1, 1, CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''MAF'', CAST(N''2018-11-15T00:00:00.000'' AS DateTime), N''MAF'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL, NULL)
END')

--agregadores da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
DECLARE @IDConfiguracao as bigint

SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Performance de Utilizador''
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista

DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasGruposPorDefeito] where IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] where IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] where IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE ID=@IDConfiguracao

INSERT [F3MOGeral].[dbo].[tbConfiguracoesConsultas] ([IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, 1, 1, CAST(N''2018-04-27 17:39:52.217'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:39:52.217'' AS DateTime), N''F3M'')
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''NumClientesDiferentes'', N''sum'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''TotalSemIva'', N''sum'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''NumVendasCruzadas'', N''sum'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''NumVendasOculos'', N''sum'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''NumVendasOS'', N''sum'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''NumVendasLC'', N''sum'', 1, 1, CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'', CAST(N''2018-04-27 17:51:52.000'' AS DateTime), N''F3M'')
END')
