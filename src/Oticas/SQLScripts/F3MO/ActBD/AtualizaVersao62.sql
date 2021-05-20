/* ACT BD EMPRESA VERSAO 62*/
EXEC('update [F3MOGeral]..tbMenus set Ordem = -100 WHERE Descricao = ''Consultas''')

--novo tipo documento ACCR
EXEC('IF NOT EXISTS(SELECT * FROM tbTiposDocumento WHERE Codigo = ''ACCR'')
BEGIN
	DECLARE @IDSistTpDoc as bigint
	DECLARE @IDSistMod as bigint
	DECLARE @IDAcaoAvisa as bigint
	DECLARE @IDAcaoIgnora as bigint
	DECLARE @IDTpLiquidacao as bigint
	DECLARE @IDTpDocMovStock as bigint
	DECLARE @IDTpDocPrecoUnitario as bigint
	DECLARE @IDNatureza as bigint
	DECLARE @IDTipoFisc as bigint
	DECLARE @IDMapaVista as bigint

	SELECT @IDMapaVista = ID from tbMapasVistas WHERE Entidade=''DocumentosVendas'' and ISNULL(SubReport,0)=0 and ISNULL(Sistema,0)=1
	SELECT @IDAcaoAvisa = ID FROM tbSistemaAcoes WHERE Codigo = ''002''
	SELECT @IDSistTpDoc = ID FROM tbSistemaTiposDocumento WHERE Tipo = ''VndFinanceiro''
	SELECT @IDSistMod = ID FROM tbSistemaModulos WHERE Codigo = ''004''
	SELECT @IDAcaoIgnora = ID FROM tbSistemaAcoes WHERE Codigo = ''001''
	SELECT @IDTpLiquidacao = ID FROM tbSistemaTiposLiquidacao WHERE Codigo = ''002''
	SELECT @IDTpDocMovStock = ID FROM tbSistemaTiposDocumentoMovStock WHERE Codigo = ''003''
	SELECT @IDTpDocPrecoUnitario = ID FROM tbSistemaTiposDocumentoPrecoUnitario WHERE Codigo = ''005''
	SELECT @IDNatureza = ID FROM tbSistemaNaturezas WHERE Codigo = ''R'' AND Modulo = ''004'' AND TipoDoc = ''VndFinanceiro''
	SELECT @IDTipoFisc = fisc.ID FROM tbSistemaTiposDocumentoFiscal as fisc
	 LEFT JOIN tbSistemaTiposDocumento as st on st.ID = fisc.IDTipoDocumento
	 WHERE fisc.Tipo=''NF'' AND st.Tipo=''VndFinanceiro''
	 
	INSERT tbTiposDocumento ([Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento], [Predefinido]) 
	VALUES (N''ACCR'', N''Acerto de CC Receber'', @IDSistMod, @IDSistTpDoc, 0, 1, getdate(), N''F3M'', NULL, NULL, NULL, @IDTipoFisc, 0, 1, 0, 0, 1, 1, 1, 0, 0, @IDAcaoAvisa, @IDTpLiquidacao, 0, 0, 0, 0, 0, 0, 0, @IDAcaoIgnora, @IDTpDocMovStock, @IDTpDocPrecoUnitario, NULL, NULL, NULL, @IDAcaoIgnora, @IDAcaoIgnora, @IDAcaoIgnora, @IDNatureza, 0, 0, 0, 0)

	DECLARE @IDTipoDocumento as bigint
	DECLARE @IDTpDocOrigem as bigint
	DECLARE @IDTpDocComunicacao as bigint

	SELECT @IDTipoDocumento = ID FROM tbTiposDocumento WHERE Codigo = ''ACCR''
	SELECT @IDTpDocOrigem = ID FROM tbSistemaTiposDocumentoOrigem WHERE Codigo = ''001''
	SELECT @IDTpDocComunicacao = ID FROM tbSistemaTiposDocumentoComunicacao WHERE Codigo = ''001''

	INSERT tbTiposDocumentoSeries ([CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) 
	VALUES (''A'', ''A'', 1, @IDTipoDocumento, 0, 1, getdate(), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, @IDTpDocOrigem, @IDTpDocComunicacao, NULL, 1, @IDMapaVista)
END')

--novo tipo documento ACCP
EXEC('IF NOT EXISTS(SELECT * FROM tbTiposDocumento WHERE Codigo = ''ACCP'')
BEGIN
	DECLARE @IDSistTpDoc as bigint
	DECLARE @IDSistMod as bigint
	DECLARE @IDAcaoAvisa as bigint
	DECLARE @IDAcaoIgnora as bigint
	DECLARE @IDTpLiquidacao as bigint
	DECLARE @IDTpDocMovStock as bigint
	DECLARE @IDTpDocPrecoUnitario as bigint
	DECLARE @IDNatureza as bigint
	DECLARE @IDTipoFisc as bigint
	DECLARE @IDMapaVista as bigint

	select @IDMapaVista = ID from tbMapasVistas WHERE Entidade=''DocumentosVendas'' and ISNULL(SubReport,0)=0 and ISNULL(Sistema,0)=1
	SELECT @IDAcaoAvisa = ID FROM tbSistemaAcoes WHERE Codigo = ''002''
	SELECT @IDSistTpDoc = ID FROM tbSistemaTiposDocumento WHERE Tipo = ''VndFinanceiro''
	SELECT @IDSistMod = ID FROM tbSistemaModulos WHERE Codigo = ''004''
	SELECT @IDAcaoIgnora = ID FROM tbSistemaAcoes WHERE Codigo = ''001''
	SELECT @IDTpLiquidacao = ID FROM tbSistemaTiposLiquidacao WHERE Codigo = ''002''
	SELECT @IDTpDocMovStock = ID FROM tbSistemaTiposDocumentoMovStock WHERE Codigo = ''002''
	SELECT @IDTpDocPrecoUnitario = ID FROM tbSistemaTiposDocumentoPrecoUnitario WHERE Codigo = ''005''
	SELECT @IDNatureza = ID FROM tbSistemaNaturezas WHERE Codigo = ''P'' AND Modulo = ''004'' AND TipoDoc = ''VndFinanceiro''
	SELECT @IDTipoFisc = fisc.ID FROM tbSistemaTiposDocumentoFiscal as fisc
	 LEFT JOIN tbSistemaTiposDocumento as st on st.ID = fisc.IDTipoDocumento
	 WHERE fisc.Tipo=''NF'' and st.Tipo=''VndFinanceiro''
	 
	INSERT tbTiposDocumento ([Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento], [Predefinido]) 
	VALUES (N''ACCP'', N''Acerto de CC Pagar'', @IDSistMod, @IDSistTpDoc, 0, 1, getdate(), N''F3M'', NULL, NULL, NULL, @IDTipoFisc, 0, 1, 0, 0, 1, 1, 1, 0, 0, @IDAcaoAvisa, @IDTpLiquidacao, 0, 0, 0, 0, 0, 0, 0, @IDAcaoIgnora, @IDTpDocMovStock, @IDTpDocPrecoUnitario, NULL, NULL, NULL, @IDAcaoIgnora, @IDAcaoIgnora, @IDAcaoIgnora, @IDNatureza, 0, 0, 0, 0)

	DECLARE @IDTipoDocumento as bigint
	DECLARE @IDTpDocOrigem as bigint
	DECLARE @IDTpDocComunicacao as bigint

	SELECT @IDTipoDocumento = ID FROM tbTiposDocumento WHERE Codigo = ''ACCP''
	SELECT @IDTpDocOrigem = ID FROM tbSistemaTiposDocumentoOrigem WHERE Codigo = ''001''
	SELECT @IDTpDocComunicacao = ID FROM tbSistemaTiposDocumentoComunicacao WHERE Codigo = ''001''

	INSERT tbTiposDocumentoSeries ([CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) 
	VALUES (''A'', ''A'', 1, @IDTipoDocumento, 0, 1, getdate(), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, @IDTpDocOrigem, @IDTpDocComunicacao, NULL, 1, @IDMapaVista)
END')

--ajuste tipo documento VD
EXEC('update tbTiposDocumento set Adiantamento=0, Predefinido=0 where codigo=''VD''')

--novo tipo de lista
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbSistemaTipoLista] WHERE ID=3)
BEGIN
INSERT [F3MOGeral].[dbo].[tbSistemaTipoLista] ([ID], [Codigo], [Descricao], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N''3'', N''AnaliseDinamica'', 1, 1, CAST(N''2015-11-11 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2015-11-11 00:00:00.000'' AS DateTime), N''F3M'')
END')

--nova lista Consentimento por Cliente
EXEC('IF NOT EXISTS (SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao = ''Consentimento por Cliente'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Clientes''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Consentimento por Cliente'', @IDUtil, 0, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbRespostasConsentimentos'', N''
SELECT  CL.Codigo  ,CL.Nome ,cast(C.DataConsentimento as date) as Data, RC.[Descricao] as Questão, Case When  RC.[Resposta] = 1 Then ''''Sim'''' ELSE ''''Não'''' END as Resposta FROM [dbo].[tbRespostasConsentimentos] RC       inner join dbo.tbConsentimentos C on RC.IDConsentimento = C.ID       inner join dbo.tbClientes CL on CL.ID = C.IDCodigoEntidade  WHERE    RC.IDConsentimento = (SELECT MAX([tbRespostasConsentimentos].IDConsentimento )                                                    
FROM [dbo].[tbRespostasConsentimentos]    
inner join dbo.tbConsentimentos on tbRespostasConsentimentos.IDConsentimento = tbConsentimentos.ID        
WHERE tbConsentimentos.IDCodigoEntidade = C.IDCodigoEntidade           Group by tbConsentimentos.IDCodigoEntidade)   and RC.[Ativo] = 1  and  @IDCliente = case when @IDCliente = '''''''' then '''''''' else  CL.ID END   and cast(C.DataConsentimento as date)  >= case when @DataDe = '''''''' then ''''1900-01-01'''' else  @DataDe END           and cast(C.DataConsentimento as date)  <= case when @DataAte ='''''''' then ''''9999-12-31'''' else @DataAte END  
ORDER BY cl.Nome , c.DataConsentimento, RC.[OrdemApresentaPerguntas]
'', 3, 3)
END
')

--colunas da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Consentimento por Cliente''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Codigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 100, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Nome'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 360, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Data'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 100,0 )
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Questão'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 400, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Resposta'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 75, 0)
END')

--parâmetros da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Consentimento por Cliente''
DELETE FROM [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''Cliente'', N''F3MLookup'', 100, NULL, N''IDCliente'', NULL, 0, 1, N'''', N''../Clientes/Clientes'', N''../Clientes/Clientes/IndexGrelha'', N''Nome'', 0, 1, CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, N''tbClientes'', NULL, NULL, NULL, N'''', N''Listas Personalizadas'', N''tbClientes'', N''Clientes'', N''ID'', NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''De'', N''F3MData'', 200, NULL, N''DataDe'', NULL, 0, 1, N'''', NULL, NULL, NULL, 0, 1, CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL, NULL, NULL, NULL, N'''', N''Sem Lookup'', NULL, NULL, NULL, N''Data'')
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''Até'', N''F3MData'', 300, NULL, N''DataAte'', NULL, 0, 1, N'''', NULL, NULL, NULL, 0, 1, CAST(N''2020-08-07T15:37:11.537'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.537'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL, NULL, NULL, NULL, N'''', N''Sem Lookup'', NULL, NULL, NULL, N''Data'')
END')

--configurações da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
DECLARE @IDConfiguracao as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Consentimento por Cliente''
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasGruposPorDefeito] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbConfiguracoesConsultas] ([IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, 0, 1, CAST(N''2020-07-21T12:28:59.820'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.180'' AS DateTime), N''1'')
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbOpConsultasGruposPorDefeito] ([IDConfiguracoesConsultas], [Coluna], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''Codigo'', 1, 0, 1, CAST(N''2020-08-06T17:14:50.237'' AS DateTime), N''F3M'', CAST(N''2020-08-06T17:14:50.237'' AS DateTime), N''1'')
END')

--mapa vista da lista
EXEC('
DECLARE @intOrdem as int;
DECLARE @ptrval xml;  
DECLARE @IDLista as varchar(max);  
SELECT @intOrdem = Max(isnull(Ordem,0)) + 1 FROM tbMapasVistas
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Consentimento por Cliente''

SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="ConsentimentoporCliente" Margins="55, 26, 25, 25" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" DataMember="QueryParam" DataSource="#Ref-0" TextAlignment="MiddleRight">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="1" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item3 Ref="7" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item4 Ref="8" Visible="false" Description="Via" Name="Via" />
    <Item5 Ref="9" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item6 Ref="10" Description="Utilizador" Name="Utilizador" />
    <Item7 Ref="11" Description="Titulo" Name="Titulo" />
    <Item8 Ref="12" AllowNull="true" Name="UrlServerPath" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="13" Name="CalculatedField2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputs.QueryDistOutputsQueryDistOutputArtigo" />
    <Item2 Ref="14" Name="Dim2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputArtigo" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="15" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="16" ControlType="ReportHeaderBand" Name="ReportHeader" Expanded="false" HeightF="0" />
    <Item3 Ref="17" ControlType="PageHeaderBand" Name="PageHeader" HeightF="80.52">
      <SubBands>
        <Item1 Ref="18" ControlType="SubBand" Name="SubBand3" HeightF="0" />
      </SubBands>
      <Controls>
        <Item1 Ref="19" ControlType="XRLine" Name="line2" SizeF="386.99,2" LocationFloat="344.79, 78.52" />
        <Item2 Ref="20" ControlType="XRLabel" Name="label9" Multiline="true" Text="Resposta" TextAlignment="MiddleRight" SizeF="53.98,23" LocationFloat="682.77, 56.01" Font="Arial, 8pt" Padding="2,2,0,0,100">
          <StylePriority Ref="21" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="22" ControlType="XRLabel" Name="label8" Multiline="true" Text="Questão" TextAlignment="MiddleLeft" SizeF="328.79,23" LocationFloat="344.79, 56.01" Font="Arial, 8pt" Padding="2,2,0,0,100">
          <StylePriority Ref="23" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="24" ControlType="XRPageInfo" Name="XrPageInfo1" PageInfo="DateTime" TextFormatString="{0:dd/MM/yyyy HH:mm}" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="603.98, 14.57" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="25" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="26" ControlType="XRLabel" Name="fldDesignacaoComercial" TextAlignment="TopLeft" SizeF="373.1997,19.14" LocationFloat="2.583885, 0" Font="Arial, 12pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="27" Expression="[QueryParam.DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="28" UseFont="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="29" ControlType="XRLine" Name="XrLine1" LineWidth="2" SizeF="732.69,6.910007" LocationFloat="2.7, 37.77" />
        <Item7 Ref="30" ControlType="XRLabel" Name="XrLabel7" TextAlignment="TopRight" SizeF="289.02,10" LocationFloat="447.73, 25" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="31" Expression="?Utilizador" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="32" UseFont="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="33" ControlType="XRLabel" Name="XrLabel6" Text="Consentimento por Cliente" TextAlignment="MiddleLeft" SizeF="373.1997,18.62502" LocationFloat="2.583885, 19.15" Font="Arial, 11.25pt" Padding="2,2,0,0,100">
          <StylePriority Ref="34" UseFont="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="35" ControlType="XRLabel" Name="XrLabel3" Text="Emissão" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="603.98, 5" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="36" UseFont="false" UseTextAlignment="false" />
        </Item9>
      </Controls>
    </Item3>
    <Item4 Ref="37" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="38" ControlType="DetailReportBand" Name="DetailReport1" Level="0" DataMember="QueryBase" DataSource="#Ref-0">
      <Bands>
        <Item1 Ref="39" ControlType="GroupHeaderBand" Name="GroupHeader1" HeightF="29.29">
          <GroupFields>
            <Item1 Ref="40" FieldName="Codigo" />
          </GroupFields>
          <Controls>
            <Item1 Ref="41" ControlType="XRLine" Name="line1" SizeF="343.75,2.16" LocationFloat="2.08, 22.85" />
            <Item2 Ref="42" ControlType="XRLabel" Name="label2" TextFormatString="{0:dd/MM/yyyy}" Multiline="true" Text="label2" TextAlignment="TopCenter" SizeF="64.56,16.6" LocationFloat="281.25, 6.25" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="43" Expression="GetDate([Data])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="44" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="45" ControlType="XRLabel" Name="label3" Multiline="true" Text="label3" TextAlignment="TopLeft" SizeF="234.39,16.6" LocationFloat="46.87, 6.25" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="46" Expression="[Nome]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="47" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="48" ControlType="XRLabel" Name="label1" Multiline="true" Text="label1" TextAlignment="TopRight" SizeF="46,16.58" LocationFloat="0, 6.25" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="49" Expression="[Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="50" UseFont="false" UseTextAlignment="false" />
            </Item4>
          </Controls>
        </Item1>
        <Item2 Ref="51" ControlType="DetailBand" Name="Detail1" HeightF="18.68">
          <SortFields>
            <Item1 Ref="52" FieldName="Localizacao" />
            <Item2 Ref="53" FieldName="CodigoArtigo" />
            <Item3 Ref="54" FieldName="OrdemDimensaoLinha1" />
            <Item4 Ref="55" FieldName="OrdemDimensaoLinha2" />
          </SortFields>
          <Controls>
            <Item1 Ref="56" ControlType="XRLabel" Name="label5" Multiline="true" Text="label5" TextAlignment="MiddleCenter" SizeF="34.94,16.6" LocationFloat="696.87, 0" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="57" Expression="[Resposta]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="58" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="59" ControlType="XRLabel" Name="label4" Multiline="true" Text="label4" TextAlignment="MiddleLeft" SizeF="349.33,16.6" LocationFloat="344.79, 0" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="60" Expression="[Questão]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="61" UseFont="false" UseTextAlignment="false" />
            </Item2>
          </Controls>
        </Item2>
      </Bands>
    </Item5>
    <Item6 Ref="62" ControlType="GroupFooterBand" Name="GroupFooter1" PrintAtBottom="true" RepeatEveryPage="true" PageBreak="AfterBand" HeightF="45.23">
      <Controls>
        <Item1 Ref="63" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="615.75, 9.24" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="64" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="65" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="733.31,4.000028" LocationFloat="2.08, 5.34" BorderWidth="1">
          <StylePriority Ref="66" UseBorderWidth="false" />
        </Item2>
      </Controls>
    </Item6>
    <Item7 Ref="67" ControlType="ReportFooterBand" Name="ReportFooter" HeightF="23" />
    <Item8 Ref="68" ControlType="PageFooterBand" Name="PageFooter" HeightF="1.583354">
      <SubBands>
        <Item1 Ref="69" ControlType="SubBand" Name="SubBand1" HeightF="23" Visible="false" />
      </SubBands>
    </Item8>
    <Item9 Ref="70" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9UFJJU01BLUxBQi1WTVxDMjtVc2VyIElEPUYzTU87UGFzc3dvcmQ9O0luaXRpYWwgQ2F0YWxvZyA9MjgxNEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0iUXVlcnlCYXNlIj48U3FsPg0KU0VMRUNUICBDTC5Db2RpZ28gICxDTC5Ob21lICxjYXN0KEMuRGF0YUNvbnNlbnRpbWVudG8gYXMgZGF0ZSkgYXMgRGF0YSwgUkMuW0Rlc2NyaWNhb10gYXMgUXVlc3TDo28sIENhc2UgV2hlbiAgUkMuW1Jlc3Bvc3RhXSA9IDEgVGhlbiAnU2ltJyBFTFNFICdOw6NvJyBFTkQgYXMgUmVzcG9zdGEgRlJPTSBbZGJvXS5bdGJSZXNwb3N0YXNDb25zZW50aW1lbnRvc10gUkMgICAgICAgaW5uZXIgam9pbiBkYm8udGJDb25zZW50aW1lbnRvcyBDIG9uIFJDLklEQ29uc2VudGltZW50byA9IEMuSUQgICAgICAgaW5uZXIgam9pbiBkYm8udGJDbGllbnRlcyBDTCBvbiBDTC5JRCA9IEMuSURDb2RpZ29FbnRpZGFkZSAgV0hFUkUgICAgUkMuSURDb25zZW50aW1lbnRvID0gKFNFTEVDVCBNQVgoW3RiUmVzcG9zdGFzQ29uc2VudGltZW50b3NdLklEQ29uc2VudGltZW50byApICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEZST00gW2Rib10uW3RiUmVzcG9zdGFzQ29uc2VudGltZW50b3NdICAgICAgICAgIGlubmVyIGpvaW4gZGJvLnRiQ29uc2VudGltZW50b3Mgb24gdGJSZXNwb3N0YXNDb25zZW50aW1lbnRvcy5JRENvbnNlbnRpbWVudG8gPSB0YkNvbnNlbnRpbWVudG9zLklEICAgICAgICAgIFdIRVJFIHRiQ29uc2VudGltZW50b3MuSURDb2RpZ29FbnRpZGFkZSA9IEMuSURDb2RpZ29FbnRpZGFkZSAgICAgICAgICAgR3JvdXAgYnkgdGJDb25zZW50aW1lbnRvcy5JRENvZGlnb0VudGlkYWRlKSAgIGFuZCBSQy5bQXRpdm9dID0gMSAgYW5kICBudWxsID0gY2FzZSB3aGVuIG51bGwgPSAnJyB0aGVuICcnIGVsc2UgIENMLklEIEVORCAgIGFuZCBDLmRhdGFjb25zZW50aW1lbnRvICZndDs9IGNhc2Ugd2hlbiBudWxsID0gJycgdGhlbiAnMTkwMC0wMS0wMScgZWxzZSAgbnVsbCBFTkQgICAgICAgICAgIGFuZCBDLmRhdGFjb25zZW50aW1lbnRvICZsdDs9IGNhc2Ugd2hlbiBudWxsID0nJyB0aGVuICc5OTk5LTEyLTMxJyBlbHNlIG51bGwgRU5EICAgT1JERVIgQlkgY2wuTm9tZSAsIGMuRGF0YUNvbnNlbnRpbWVudG8sIFJDLltPcmRlbUFwcmVzZW50YVBlcmd1bnRhc10NCjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IkN1c3RvbVNxbFF1ZXJ5IiBOYW1lPSJRdWVyeVBhcmFtIj48U3FsPnNlbGVjdCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklEIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklETW9lZGFEZWZlaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIk1vcmFkYSIsICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRm90byIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGb3RvQ2FtaW5obyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJEZXNpZ25hY2FvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNvZGlnb1Bvc3RhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJMb2NhbGlkYWRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNvbmNlbGhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRpc3RyaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklERW1wcmVzYSIsDQogICAgICAgInRiU2lzdGVtYVNpZ2xhc1BhaXNlcyIuIlNpZ2xhIiwgInRiTW9lZGFzIi4iRGVzY3JpY2FvIiwNCiAgICAgICAidGJNb2VkYXMiLiJUYXhhQ29udmVyc2FvIiwgInRiTW9lZGFzIi4iU2ltYm9sbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRFBhaXMiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iVGVsZWZvbmUiLCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZheCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJFbWFpbCIsICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iTklGIg0KICBmcm9tICgoImRibyIuInRiUGFyYW1ldHJvc0VtcHJlc2EiICJ0YlBhcmFtZXRyb3NFbXByZXNhIg0KICBpbm5lciBqb2luICJkYm8iLiJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiDQogICAgICAgb24gKCJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiLiJJRCIgPSAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklEUGFpcyIpKQ0KICBpbm5lciBqb2luICJkYm8iLiJ0Yk1vZWRhcyIgInRiTW9lZGFzIg0KICAgICAgIG9uICgidGJNb2VkYXMiLiJJRCIgPSAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklETW9lZGFEZWZlaXRvIikpPC9TcWw+PE1ldGEgWD0iNDAiIFk9IjIwIiBXaWR0aD0iMTAwIiBIZWlnaHQ9IjUwNyIgLz48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQ+PFZpZXcgTmFtZT0iUXVlcnlCYXNlIj48RmllbGQgTmFtZT0iQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik5vbWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlF1ZXN0w6NvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlJlc3Bvc3RhIiBUeXBlPSJTdHJpbmciIC8+PC9WaWV3PjxWaWV3IE5hbWU9IlF1ZXJ5UGFyYW0iPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxobyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVtcHJlc2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJTaWdsYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGF4YUNvbnZlcnNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTaW1ib2xvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZheCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOSUYiIFR5cGU9IlN0cmluZyIgLz48L1ZpZXc+PC9EYXRhU2V0PjwvUmVzdWx0U2NoZW1hPjxDb25uZWN0aW9uT3B0aW9ucyBDbG9zZUNvbm5lY3Rpb249InRydWUiIERiQ29tbWFuZFRpbWVvdXQ9IjE4MDAiIC8+PC9TcWxEYXRhU291cmNlPg==" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
--Mapa 
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito],[SubReport]) 
VALUES (@intOrdem, N''RespostasConsentimentos#F3M#''+ @IDLista, N''Consentimento por Cliente'', N''ConsentimentoporCliente'', N'''', 0, @ptrval, NULL, N''
  SELECT  CL.Codigo  ,CL.Nome ,cast(C.DataConsentimento as date) as Data, RC.[Descricao] as Questão, Case When  RC.[Resposta] = 1 Then ''''Sim'''' ELSE ''''Não'''' END as Resposta FROM [dbo].[tbRespostasConsentimentos] RC       inner join dbo.tbConsentimentos C on RC.IDConsentimento = C.ID       inner join dbo.tbClientes CL on CL.ID = C.IDCodigoEntidade  WHERE    RC.IDConsentimento = (SELECT MAX([tbRespostasConsentimentos].IDConsentimento )                                                    FROM [dbo].[tbRespostasConsentimentos]          inner join dbo.tbConsentimentos on tbRespostasConsentimentos.IDConsentimento = tbConsentimentos.ID          WHERE tbConsentimentos.IDCodigoEntidade = C.IDCodigoEntidade           Group by tbConsentimentos.IDCodigoEntidade)   and RC.[Ativo] = 1  and  @IDCliente = case when @IDCliente = '''''''' then '''''''' else  CL.ID END   and C.dataconsentimento >= case when @DataDe = '''''''' then ''''1900-01-01'''' else  @DataDe END           and C.dataconsentimento <= case when @DataAte ='''''''' then ''''9999-12-31'''' else @DataAte END   ORDER BY cl.Nome , c.DataConsentimento, RC.[OrdemApresentaPerguntas]  
'', 1, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''', NULL, NULL, NULL, 1,0)
')



--nova lista Conta Corrente de Clientes
EXEC('IF NOT EXISTS (SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao = ''Conta Corrente de Cliente'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Clientes''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Conta Corrente de Cliente'', @IDUtil, 0, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbCCClientes'', N''
select  CodigoCliente as Código, NomeFiscal as Nome, DescricaoLoja as Loja, Documento , cast(DataDocumento as date) as Data,  case when Natureza = ''''Débito'''' then abs(valor) else '''''''' end as Débito, case when Natureza = ''''Crédito'''' then abs(valor) else '''''''' end as Crédito, Saldo  from dbo.vwCCClientes Where @CodigoCliente = case when @CodigoCliente = '''''''' then '''''''' else  dbo.vwCCClientes.IDEntidade end  order by codigocliente, data 
'', 3, 3)
END
')

--colunas da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Cliente''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Codigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 100, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Nome'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 220, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Loja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 110, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 100, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Data'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 95, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Débito'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 120, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Crédito'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 130, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 130, 0)
END')

--parâmetros da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Cliente''
DELETE FROM [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''Cliente'', N''F3MLookup'', 100, NULL, N''CodigoCliente'', NULL, 0, 1, NULL,N''../Clientes/Clientes'', N''../Clientes/Clientes/IndexGrelha'', N''Nome'', 0, 1, CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, N''tbClientes'', NULL, NULL, NULL, N'''', N''Listas Personalizadas'', N''vwCCClientes'', N''Clientes'', N''IDEntidade'', NULL)
END')

--configurações da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
DECLARE @IDConfiguracao as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Cliente''
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasGruposPorDefeito] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbConfiguracoesConsultas] ([IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, 0, 1, CAST(N''2020-07-21T12:28:59.820'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.180'' AS DateTime), N''1'')
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbOpConsultasGruposPorDefeito] ([IDConfiguracoesConsultas], [Coluna], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''Código'', 1, 0, 1, CAST(N''2020-08-11T16:59:00.907'' AS DateTime), N''F3M'', CAST(N''2020-08-11T16:59:00.907'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] ([IDConfiguracoesConsultas], [Grupo], [Coluna], [Agregador], [Header], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''Débito'', N''Débito'', N''sum'', 0, 0, 1, CAST(N''2020-08-11T16:59:01.080'' AS DateTime), N''F3M'', CAST(N''2020-08-11T16:59:01.080'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] ([IDConfiguracoesConsultas], [Grupo], [Coluna], [Agregador], [Header], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''Crédito'', N''Crédito'', N''sum'', 0, 0, 1, CAST(N''2020-08-11T16:59:01.083'' AS DateTime), N''F3M'', CAST(N''2020-08-11T16:59:01.083'' AS DateTime), N''1'')  
END')

--mapa vista da lista
EXEC('
DECLARE @intOrdem as int;
DECLARE @ptrval xml;  
DECLARE @IDLista as varchar(max);  
SELECT @intOrdem = Max(isnull(Ordem,0)) + 1 FROM tbMapasVistas
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Cliente''

SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="Conta Corrente de Cliente" Margins="26, 0, 25, 25" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" DataMember="QueryParam" DataSource="#Ref-0" TextAlignment="MiddleRight">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="1" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item3 Ref="7" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item4 Ref="8" Visible="false" Description="Via" Name="Via" />
    <Item5 Ref="9" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item6 Ref="10" Description="Utilizador" Name="Utilizador" />
    <Item7 Ref="11" Description="Titulo" Name="Titulo" />
    <Item8 Ref="12" AllowNull="true" Name="UrlServerPath" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="13" Name="CalculatedField2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputs.QueryDistOutputsQueryDistOutputArtigo" />
    <Item2 Ref="14" Name="Dim2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputArtigo" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="15" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="16" ControlType="ReportHeaderBand" Name="ReportHeader" Expanded="false" HeightF="0" />
    <Item3 Ref="17" ControlType="PageHeaderBand" Name="PageHeader" HeightF="85.19">
      <SubBands>
        <Item1 Ref="18" ControlType="SubBand" Name="SubBand3" HeightF="0" />
      </SubBands>
      <Controls>
        <Item1 Ref="19" ControlType="XRLabel" Name="label17" Multiline="true" Text="Loja" TextAlignment="MiddleLeft" SizeF="100,23" LocationFloat="433.33, 56.99" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="20" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="21" ControlType="XRLabel" Name="label16" Multiline="true" Text="Data" TextAlignment="MiddleCenter" SizeF="71.46,23" LocationFloat="361.83, 56.99" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="22" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="23" ControlType="XRLabel" Name="label15" Multiline="true" Text="Documento" TextAlignment="MiddleLeft" SizeF="100,23" LocationFloat="258.71, 56.99" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="24" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="25" ControlType="XRLine" Name="line1" SizeF="768.42,6.31" LocationFloat="2.69, 74.71" />
        <Item5 Ref="26" ControlType="XRLabel" Name="label9" Multiline="true" Text="Saldo" TextAlignment="MiddleRight" SizeF="81.25,23" LocationFloat="689.58, 57" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="27" UseFont="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="28" ControlType="XRLabel" Name="label8" Multiline="true" Text="Crédito" TextAlignment="MiddleRight" SizeF="79.16,23" LocationFloat="610.41, 56.98" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="29" UseFont="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="30" ControlType="XRLabel" Name="label7" Multiline="true" Text="Débito" TextAlignment="MiddleRight" SizeF="74.95,23" LocationFloat="533.33, 57" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="31" UseFont="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="32" ControlType="XRLabel" Name="label1" Multiline="true" Text="Cliente" TextAlignment="MiddleLeft" SizeF="100,23" LocationFloat="2.69, 57" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="33" UseFont="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="34" ControlType="XRPageInfo" Name="XrPageInfo1" PageInfo="DateTime" TextFormatString="{0:dd/MM/yyyy HH:mm}" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="638.36, 14.57" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="35" UseFont="false" UseTextAlignment="false" />
        </Item9>
        <Item10 Ref="36" ControlType="XRLabel" Name="fldDesignacaoComercial" TextAlignment="TopLeft" SizeF="373.1997,19.14" LocationFloat="2.583885, 0" Font="Arial, 12pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="37" Expression="[QueryParam.DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="38" UseFont="false" UseTextAlignment="false" />
        </Item10>
        <Item11 Ref="39" ControlType="XRLine" Name="XrLine1" LineWidth="2" SizeF="768.43,6.910007" LocationFloat="2.7, 37.77" />
        <Item12 Ref="40" ControlType="XRLabel" Name="XrLabel7" TextAlignment="TopRight" SizeF="289.02,10" LocationFloat="482.11, 25" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="41" Expression="?Utilizador" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="42" UseFont="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="43" ControlType="XRLabel" Name="XrLabel6" Text="Conta Corrente Cliente" TextAlignment="MiddleLeft" SizeF="373.1997,18.62502" LocationFloat="2.583885, 19.15" Font="Arial, 11.25pt" Padding="2,2,0,0,100">
          <StylePriority Ref="44" UseFont="false" UseTextAlignment="false" />
        </Item13>
        <Item14 Ref="45" ControlType="XRLabel" Name="XrLabel3" Text="Emissão" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="638.36, 5" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="46" UseFont="false" UseTextAlignment="false" />
        </Item14>
      </Controls>
    </Item3>
    <Item4 Ref="47" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="48" ControlType="DetailReportBand" Name="DetailReport1" Level="0" DataMember="QueryBase" DataSource="#Ref-0">
      <Bands>
        <Item1 Ref="49" ControlType="GroupHeaderBand" Name="GroupHeader1" GroupUnion="WithFirstDetail" HeightF="29.16" KeepTogether="true">
          <GroupFields>
            <Item1 Ref="50" FieldName="Código" />
          </GroupFields>
          <Controls>
            <Item1 Ref="51" ControlType="XRLine" Name="line3" SizeF="256.13,6.31" LocationFloat="2.58, 20.77" />
            <Item2 Ref="52" ControlType="XRLabel" Name="label2" Multiline="true" CanGrow="false" Text="label2" TextAlignment="MiddleLeft" SizeF="359.14,20" LocationFloat="2.69, 4.07" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="53" Expression="[Código] + '''' - '''' + [Nome] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="54" UseFont="false" UseTextAlignment="false" />
            </Item2>
          </Controls>
        </Item1>
        <Item2 Ref="55" ControlType="DetailBand" Name="Detail1" KeepTogetherWithDetailReports="true" HeightF="22.09" KeepTogether="true" Font="Times New Roman, 8pt">
          <SortFields>
            <Item1 Ref="56" FieldName="Localizacao" />
            <Item2 Ref="57" FieldName="CodigoArtigo" />
            <Item3 Ref="58" FieldName="OrdemDimensaoLinha1" />
            <Item4 Ref="59" FieldName="OrdemDimensaoLinha2" />
          </SortFields>
          <Controls>
            <Item1 Ref="60" ControlType="XRLabel" Name="label3" TextFormatString="{0:dd/MM/yyyy}" Multiline="true" Text="label3" TextAlignment="MiddleCenter" SizeF="71.5,20" LocationFloat="361.84, 0" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="61" Expression="[Data]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="62" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="63" ControlType="XRLabel" Name="label11" Multiline="true" CanGrow="false" Text="label11" TextAlignment="MiddleLeft" SizeF="100.01,20" LocationFloat="433.33, 0" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="64" Expression="[Loja]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="65" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="66" ControlType="XRLabel" Name="label10" Multiline="true" Text="label10" TextAlignment="MiddleLeft" SizeF="103.12,20" LocationFloat="258.72, 0" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="67" Expression="[Documento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="68" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="69" ControlType="XRLabel" Name="label6" TextFormatString="{0:## ### ##0.00 €}" Multiline="true" Text="label6" SizeF="79.16,20" LocationFloat="610.41, 0" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="70" Expression="[Crédito]" PropertyName="Text" EventName="BeforePrint" />
                <Item2 Ref="71" Expression="iif( [Crédito]  &lt;&gt; 0,True, iif( [Débito]  = 0,True,False ) )" PropertyName="Visible" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="72" UseFont="false" />
            </Item4>
            <Item5 Ref="73" ControlType="XRLabel" Name="label5" TextFormatString="{0:## ### ##0.00 €}" Multiline="true" Text="label5" SizeF="77.08,20" LocationFloat="533.33, 0" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="74" Expression="[Débito]" PropertyName="Text" EventName="BeforePrint" />
                <Item2 Ref="75" Expression="iif( [Débito] &lt;&gt; 0,True, False)" PropertyName="Visible" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="76" UseFont="false" />
            </Item5>
            <Item6 Ref="77" ControlType="XRLabel" Name="label4" TextFormatString="{0:## ### ##0.00 €}" Multiline="true" Text="label4" SizeF="81.25,20" LocationFloat="689.58, 0" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="78" Expression="[Saldo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="79" UseFont="false" />
            </Item6>
          </Controls>
          <StylePriority Ref="80" UseFont="false" />
        </Item2>
        <Item3 Ref="81" ControlType="GroupFooterBand" Name="GroupFooter2" GroupUnion="WithLastDetail" HeightF="25.09" KeepTogether="true">
          <Controls>
            <Item1 Ref="82" ControlType="XRLabel" Name="label14" Multiline="true" Text="Total:" TextAlignment="MiddleRight" SizeF="100,23" LocationFloat="433.32, 0" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <StylePriority Ref="83" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="84" ControlType="XRLine" Name="line2" SizeF="510,2.08" LocationFloat="258.33, 0" />
            <Item3 Ref="85" ControlType="XRLabel" Name="label13" TextFormatString="{0:## ### ##0.00 €}" Multiline="true" Text="label5" SizeF="77.08,23" LocationFloat="612.5, 0" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="86" Expression="[][[Código] == [^.Código]].Sum([Crédito])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="87" UseFont="false" />
            </Item3>
            <Item4 Ref="88" ControlType="XRLabel" Name="label12" TextFormatString="{0:## ### ##0.00 €}" Multiline="true" Text="label5" SizeF="77.08,23" LocationFloat="533.32, 0" Font="Arial, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="89" Expression="[][[Código] == [^.Código]].Sum([Débito])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="90" UseFont="false" />
            </Item4>
          </Controls>
        </Item3>
      </Bands>
    </Item5>
    <Item6 Ref="91" ControlType="GroupFooterBand" Name="GroupFooter1" PrintAtBottom="true" RepeatEveryPage="true" PageBreak="AfterBand" HeightF="32.33">
      <Controls>
        <Item1 Ref="92" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="650.13, 9.24" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="93" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="94" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="768.43,4.000028" LocationFloat="2.7, 5.34" BorderWidth="1">
          <StylePriority Ref="95" UseBorderWidth="false" />
        </Item2>
      </Controls>
    </Item6>
    <Item7 Ref="96" ControlType="ReportFooterBand" Name="ReportFooter" HeightF="23" />
    <Item8 Ref="97" ControlType="PageFooterBand" Name="PageFooter" HeightF="1.583354">
      <SubBands>
        <Item1 Ref="98" ControlType="SubBand" Name="SubBand1" HeightF="23" Visible="false" />
      </SubBands>
    </Item8>
    <Item9 Ref="99" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9UFJJU01BLUxBQi1WTVxDMjtVc2VyIElEPUYzTU87UGFzc3dvcmQ9O0luaXRpYWwgQ2F0YWxvZyA9Nzk0N0YzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0iUXVlcnlCYXNlIj48U3FsPnNlbGVjdCAgQ29kaWdvQ2xpZW50ZSBhcyBDw7NkaWdvLCBOb21lRmlzY2FsIGFzIE5vbWUsIERlc2NyaWNhb0xvamEgYXMgTG9qYSwgRG9jdW1lbnRvICwgY2FzdChEYXRhRG9jdW1lbnRvIGFzIGRhdGUpIGFzIERhdGEsIA0KY2FzZSB3aGVuIE5hdHVyZXphID0gJ0TDqWJpdG8nIHRoZW4gYWJzKHZhbG9yKSBlbHNlICcnIGVuZCBhcyBEw6liaXRvLCBjYXNlIHdoZW4gTmF0dXJlemEgPSAnQ3LDqWRpdG8nIHRoZW4gYWJzKHZhbG9yKSBlbHNlICcnIGVuZCBhcyBDcsOpZGl0bywgU2FsZG8gDQpmcm9tIGRiby52d0NDQ2xpZW50ZXMNCldoZXJlIG51bGwgPSBjYXNlIHdoZW4gbnVsbCA9ICcnIHRoZW4gJycgZWxzZSAgZGJvLnZ3Q0NDbGllbnRlcy5JREVudGlkYWRlIGVuZCANCm9yZGVyIGJ5IGNvZGlnb2NsaWVudGUsIGRhdGENCjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IkN1c3RvbVNxbFF1ZXJ5IiBOYW1lPSJRdWVyeVBhcmFtIj48U3FsPnNlbGVjdCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklEIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklETW9lZGFEZWZlaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIk1vcmFkYSIsICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRm90byIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGb3RvQ2FtaW5obyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJEZXNpZ25hY2FvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNvZGlnb1Bvc3RhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJMb2NhbGlkYWRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNvbmNlbGhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRpc3RyaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklERW1wcmVzYSIsDQogICAgICAgInRiU2lzdGVtYVNpZ2xhc1BhaXNlcyIuIlNpZ2xhIiwgInRiTW9lZGFzIi4iRGVzY3JpY2FvIiwNCiAgICAgICAidGJNb2VkYXMiLiJUYXhhQ29udmVyc2FvIiwgInRiTW9lZGFzIi4iU2ltYm9sbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRFBhaXMiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iVGVsZWZvbmUiLCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZheCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJFbWFpbCIsICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iTklGIg0KICBmcm9tICgoImRibyIuInRiUGFyYW1ldHJvc0VtcHJlc2EiICJ0YlBhcmFtZXRyb3NFbXByZXNhIg0KICBpbm5lciBqb2luICJkYm8iLiJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiDQogICAgICAgb24gKCJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiLiJJRCIgPSAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklEUGFpcyIpKQ0KICBpbm5lciBqb2luICJkYm8iLiJ0Yk1vZWRhcyIgInRiTW9lZGFzIg0KICAgICAgIG9uICgidGJNb2VkYXMiLiJJRCIgPSAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklETW9lZGFEZWZlaXRvIikpPC9TcWw+PE1ldGEgWD0iNDAiIFk9IjIwIiBXaWR0aD0iMTAwIiBIZWlnaHQ9IjUwNyIgLz48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQ+PFZpZXcgTmFtZT0iUXVlcnlCYXNlIj48RmllbGQgTmFtZT0iQ8OzZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOb21lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkxvamEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRG9jdW1lbnRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGEiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJEw6liaXRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkNyw6lkaXRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlNhbGRvIiBUeXBlPSJEb3VibGUiIC8+PC9WaWV3PjxWaWV3IE5hbWU9IlF1ZXJ5UGFyYW0iPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxobyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVtcHJlc2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJTaWdsYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGF4YUNvbnZlcnNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTaW1ib2xvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZheCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOSUYiIFR5cGU9IlN0cmluZyIgLz48L1ZpZXc+PC9EYXRhU2V0PjwvUmVzdWx0U2NoZW1hPjxDb25uZWN0aW9uT3B0aW9ucyBDbG9zZUNvbm5lY3Rpb249InRydWUiIC8+PC9TcWxEYXRhU291cmNlPg==" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
--Mapa 
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito],[SubReport]) 
VALUES (@intOrdem, N''CCClientes#F3M#''+ @IDLista, N''Conta Corrente de Cliente'', N''Conta Corrente de Cliente'', N'''', 0, @ptrval, NULL, N''
select  CodigoCliente as Código, NomeFiscal as Nome, DescricaoLoja as Loja, Documento , cast(DataDocumento as date) as Data,  case when Natureza = ''''Débito'''' then abs(valor) else '''''''' end as Débito, case when Natureza = ''''Crédito'''' then abs(valor) else '''''''' end as Crédito, Saldo  from dbo.vwCCClientes Where @CodigoCliente = case when @CodigoCliente = '''''''' then '''''''' else  dbo.vwCCClientes.IDEntidade end  order by codigocliente, data 
'', 1, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''', NULL, NULL, NULL, 1,0)
')



--nova lista Serviços Não Faturados
EXEC('IF NOT EXISTS (SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao = ''Serviços Não Faturados'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Clientes''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Serviços Não Faturados'', @IDUtil, 0, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbdocumentosvendas'', N''
Select  Loja, Documento, cast(DataDocumento as date) As Data, Cliente , Nome , round(TotalServiço,2) as TotalServiço, round(Adiantamento,2) as Adiantamento  from ( select distinct tbLojas.Descricao  AS Loja, tbdocumentosVendas.Documento As Documento, tbdocumentosVendas.datadocumento AS [DataDocumento] ,                  tbclientes.Codigo AS Cliente , tbclientes.Nome AS Nome , tbdocumentosVendas.TotalClienteMoedaDocumento AS TotalServiço ,                 E.Descricao as DescricaoEstado , E.Codigo as CodigoEstado,  (SELECT  round(ISNULL(SUM( ( case when TN.Codigo = ''''P'''' Then -1 Else 1 end * (DVL.ValorIncidencia + DVL.ValorIVA)  ) ), 0) , 2)    FROM tbDocumentosVendas AS DV      INNER JOIN tbDocumentosVendasLinhas AS DVL ON DV.ID = DVL.IDDocumentoVenda      INNER JOIN tbTiposDocumento AS TD ON DV.IDTipoDocumento = TD.ID      INNER JOIN tbSistemaTiposDocumentoFiscal AS TDF ON TDF.ID = TD.IDSistemaTiposDocumentoFiscal     INNER JOIN tbEstados as E ON E.ID = DV.IDEstado      INNER JOIN tbSistemaTiposEstados as TE ON TE.ID = E.IDTipoEstado       INNER JOIN tbSistemaNaturezas TN on Tn.ID = TD.IDSistemaNaturezas      INNER join tbDocumentosVendasLinhas as DVLSRV on dvL.IDLinhaDocumentoOrigem  = DVLSRV.ID      INNER JOIN tbDocumentosVendas as DVSRV on DVSRV.ID = DVLSRV.IDDocumentoVenda     WHERE TE.Codigo = ''''EFT''''  AND TD.Adiantamento = 1 AND (TDF.Tipo = ''''FR'''' or TDF.Tipo = ''''NC'''')     and dvsrv.ID = tbdocumentosVendas.id    ) as Adiantamento,   (SELECT  round(ISNULL(SUM( ( case when TN1.Codigo = ''''P'''' Then -1 Else 1 end * (DVL1.ValorIncidencia + DVL1.ValorIVA)  ) ), 0) , 2)      FROM tbDocumentosVendas AS DV1      INNER JOIN tbDocumentosVendasLinhas AS DVL1 ON DV1.ID = DVL1.IDDocumentoVenda      INNER JOIN tbTiposDocumento AS TD1 ON DV1.IDTipoDocumento = TD1.ID      INNER JOIN tbSistemaTiposDocumentoFiscal AS TDF1 ON TDF1.ID = TD1.IDSistemaTiposDocumentoFiscal     INNER JOIN tbEstados as E1 ON E1.ID = DV1.IDEstado      INNER JOIN tbSistemaTiposEstados as TE1 ON TE1.ID = E1.IDTipoEstado       INNER JOIN tbSistemaNaturezas TN1 on Tn1.ID = TD1.IDSistemaNaturezas      INNER join tbDocumentosVendasLinhas as DVLSRV1 on dvL1.IDLinhaDocumentoOrigem  = DVLSRV1.ID      INNER JOIN tbDocumentosVendas as DVSRV1 on DVSRV1.ID = DVLSRV1.IDDocumentoVenda    WHERE TE1.Codigo = ''''EFT''''  AND TD1.Adiantamento = 0 and dvsrv1.ID = tbdocumentosVendas.id     ) as Faturado  FROM dbo.tbdocumentosvendas tbdocumentosVendas      left join dbo.tbDocumentosVendasLinhas tbDocumentosVendasLinhas on tbDocumentosVendasLinhas.IDdocumentovenda = tbdocumentosVendas.ID        left join dbo.tbTiposDocumento TD on tbdocumentosVendas.IDTipoDocumento = TD.ID       left join dbo.tblojas tbLojas on tbLojas.id = tbdocumentosVendas.IDLoja       left join dbo.tbClientes tbclientes on tbdocumentosVendas.IDEntidade   = tbclientes.ID         left JOIN tbEstados as E ON E.ID = tbdocumentosVendas.IDEstado       left JOIN tbSistemaTiposEstados as TE ON TE.ID = E.IDTipoEstado   where TD.IDSistemaTiposDocumento = 17 and  TE.Codigo  = ''''EFT''''      and tbdocumentosvendas .DataDocumento>= case when @DataDe = '''''''' then ''''1900-01-01'''' else  @DataDe END           and tbdocumentosvendas .DataDocumento <= case when @DataAte ='''''''' then ''''9999-12-31'''' else @DataAte END     and (tbclientes.ID = @CodigoCliente or @CodigoCliente ='''''''') and @filtro ) AS SRV  Where SRV.Faturado =0  order by SRV.DataDocumento, SRV .Documento desc
'', 3, 3)
END
')

--colunas da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Serviços Não Faturados''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Loja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 140, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Documento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 130, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Data'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 4, 130, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Cliente'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 110, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Nome'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 330, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''TotalServiço'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Adiantamento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 130, 0)
END')

--parâmetros da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Serviços Não Faturados''
DELETE FROM [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''Cliente'', N''F3MLookup'', 100, NULL, N''CodigoCliente'', NULL, 0, 1, N'''', N''../Clientes/Clientes'', N''../Clientes/Clientes/IndexGrelha'', N''Nome'', 0, 1, CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, N''tbClientes'', NULL, NULL, NULL, N'''', N''Listas Personalizadas'', N''tbClientes'', N''Clientes'', N''ID'', NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''De'', N''F3MData'', 200, NULL, N''DataDe'', NULL, 0, 1, N'''', NULL, NULL, NULL, 0, 1, CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL, NULL, NULL, NULL, N'''', N''Sem Lookup'', NULL, NULL, NULL, N''Data'')
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''Até'', N''F3MData'', 300, NULL, N''DataAte'', NULL, 0, 1, N'''', NULL, NULL, NULL, 0, 1, CAST(N''2020-08-07T15:37:11.537'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.537'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL, NULL, NULL, NULL, N'''', N''Sem Lookup'', NULL, NULL, NULL, N''Data'')
END')

--configurações da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
DECLARE @IDConfiguracao as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Serviços Não Faturados''
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasGruposPorDefeito] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbConfiguracoesConsultas] ([IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, 0, 1, CAST(N''2020-07-21T12:28:59.820'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.180'' AS DateTime), N''1'')
END')

--mapa vista da lista
EXEC('
DECLARE @intOrdem as int;
DECLARE @ptrval xml;  
DECLARE @IDLista as varchar(max);  
SELECT @intOrdem = Max(isnull(Ordem,0)) + 1 FROM tbMapasVistas
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Serviços Não Faturados''

SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="Serviços Não Faturados" Margins="26, 0, 25, 25" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" DataMember="QueryParam" DataSource="#Ref-0" TextAlignment="MiddleRight">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="1" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item3 Ref="7" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item4 Ref="8" Visible="false" Description="Via" Name="Via" />
    <Item5 Ref="9" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item6 Ref="10" Description="Utilizador" Name="Utilizador" />
    <Item7 Ref="11" Description="Titulo" Name="Titulo" />
    <Item8 Ref="12" AllowNull="true" Name="UrlServerPath" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="13" Name="CalculatedField2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputs.QueryDistOutputsQueryDistOutputArtigo" />
    <Item2 Ref="14" Name="Dim2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputArtigo" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="15" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="16" ControlType="ReportHeaderBand" Name="ReportHeader" Expanded="false" HeightF="0" />
    <Item3 Ref="17" ControlType="PageHeaderBand" Name="PageHeader" HeightF="79.8">
      <SubBands>
        <Item1 Ref="18" ControlType="SubBand" Name="SubBand3" HeightF="0" />
      </SubBands>
      <Controls>
        <Item1 Ref="19" ControlType="XRLine" Name="line1" SizeF="764.95,5.27" LocationFloat="2.69, 72.44" />
        <Item2 Ref="20" ControlType="XRLabel" Name="label13" Multiline="true" Text="Adiantamento" TextAlignment="MiddleRight" SizeF="93.71,23" LocationFloat="673.95, 49.45" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="21" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="22" ControlType="XRLabel" Name="label12" Multiline="true" Text="Total Serviço" TextAlignment="MiddleRight" SizeF="94.79,23" LocationFloat="580.2, 49.45" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="23" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="24" ControlType="XRLabel" Name="label11" Multiline="true" Text="Cliente" TextAlignment="MiddleRight" SizeF="69.71,23" LocationFloat="266.66, 49.45" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="25" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="26" ControlType="XRLabel" Name="label10" Multiline="true" Text="Data" TextAlignment="MiddleCenter" SizeF="87.5,23" LocationFloat="179.16, 49.45" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="27" UseFont="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="28" ControlType="XRLabel" Name="label9" Multiline="true" Text="Documento" TextAlignment="MiddleLeft" SizeF="111.45,23" LocationFloat="67.71, 49.44" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="29" UseFont="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="30" ControlType="XRLabel" Name="label8" Multiline="true" Text="Loja" TextAlignment="MiddleLeft" SizeF="65.02,23" LocationFloat="2.69, 49.45" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="31" UseFont="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="32" ControlType="XRPageInfo" Name="XrPageInfo1" PageInfo="DateTime" TextFormatString="{0:dd/MM/yyyy HH:mm}" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="638.36, 14.57" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="33" UseFont="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="34" ControlType="XRLabel" Name="fldDesignacaoComercial" TextAlignment="TopLeft" SizeF="373.1997,19.14" LocationFloat="2.583885, 0" Font="Arial, 12pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="35" Expression="[QueryParam.DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="36" UseFont="false" UseTextAlignment="false" />
        </Item9>
        <Item10 Ref="37" ControlType="XRLine" Name="XrLine1" LineWidth="2" SizeF="768.43,6.910007" LocationFloat="2.7, 37.77" />
        <Item11 Ref="38" ControlType="XRLabel" Name="XrLabel7" TextAlignment="TopRight" SizeF="289.02,10" LocationFloat="482.11, 25" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="39" Expression="?Utilizador" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="40" UseFont="false" UseTextAlignment="false" />
        </Item11>
        <Item12 Ref="41" ControlType="XRLabel" Name="XrLabel6" Text="Serviços não Faturados" TextAlignment="MiddleLeft" SizeF="373.1997,18.62502" LocationFloat="2.583885, 19.15" Font="Arial, 11.25pt" Padding="2,2,0,0,100">
          <StylePriority Ref="42" UseFont="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="43" ControlType="XRLabel" Name="XrLabel3" Text="Emissão" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="638.36, 5" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="44" UseFont="false" UseTextAlignment="false" />
        </Item13>
      </Controls>
    </Item3>
    <Item4 Ref="45" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="46" ControlType="DetailReportBand" Name="DetailReport1" Level="0" DataMember="QueryBase" DataSource="#Ref-0">
      <Bands>
        <Item1 Ref="47" ControlType="GroupHeaderBand" Name="GroupHeader1" HeightF="35.61">
          <GroupFields>
            <Item1 Ref="48" FieldName="Loja" />
          </GroupFields>
          <Controls>
            <Item1 Ref="49" ControlType="XRLabel" Name="label1" Multiline="true" Text="label1" TextAlignment="MiddleLeft" SizeF="197.31,23" LocationFloat="2.69, 10.54" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="50" Expression="[Loja]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="51" UseFont="false" UseTextAlignment="false" />
            </Item1>
          </Controls>
        </Item1>
        <Item2 Ref="52" ControlType="DetailBand" Name="Detail1" HeightF="25.08" KeepTogether="true">
          <SortFields>
            <Item1 Ref="53" FieldName="Localizacao" />
            <Item2 Ref="54" FieldName="CodigoArtigo" />
            <Item3 Ref="55" FieldName="OrdemDimensaoLinha1" />
            <Item4 Ref="56" FieldName="OrdemDimensaoLinha2" />
          </SortFields>
          <Controls>
            <Item1 Ref="57" ControlType="XRLabel" Name="label7" CanGrow="false" Text="label7" TextAlignment="MiddleLeft" SizeF="250.04,23" LocationFloat="341.63, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="58" Expression="[Nome]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="59" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="60" ControlType="XRLabel" Name="label6" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label6" SizeF="92.62,23" LocationFloat="675, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="61" Expression="[Adiantamento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="62" UseFont="false" />
            </Item2>
            <Item3 Ref="63" ControlType="XRLabel" Name="label5" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label5" SizeF="83.33,23" LocationFloat="591.67, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="64" Expression="[TotalServiço]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="65" UseFont="false" />
            </Item3>
            <Item4 Ref="66" ControlType="XRLabel" Name="label4" Multiline="true" Text="label4" TextAlignment="MiddleRight" SizeF="69.72,23" LocationFloat="266.66, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="67" Expression="[Cliente]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="68" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="69" ControlType="XRLabel" Name="label3" TextFormatString="{0:dd/MM/yyyy}" Multiline="true" Text="label3" TextAlignment="MiddleCenter" SizeF="87.5,23" LocationFloat="179.16, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="70" Expression="[Data]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="71" UseFont="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="72" ControlType="XRLabel" Name="label2" Multiline="true" Text="label2" TextAlignment="MiddleLeft" SizeF="111.45,23" LocationFloat="67.71, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="73" Expression="[Documento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="74" UseFont="false" UseTextAlignment="false" />
            </Item6>
          </Controls>
        </Item2>
      </Bands>
    </Item5>
    <Item6 Ref="75" ControlType="GroupFooterBand" Name="GroupFooter1" PrintAtBottom="true" RepeatEveryPage="true" PageBreak="AfterBand" HeightF="32.27">
      <Controls>
        <Item1 Ref="76" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="650.13, 9.24" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="77" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="78" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="768.43,4.000028" LocationFloat="2.7, 5.34" BorderWidth="1">
          <StylePriority Ref="79" UseBorderWidth="false" />
        </Item2>
      </Controls>
    </Item6>
    <Item7 Ref="80" ControlType="ReportFooterBand" Name="ReportFooter" HeightF="23" />
    <Item8 Ref="81" ControlType="PageFooterBand" Name="PageFooter" HeightF="1.583354">
      <SubBands>
        <Item1 Ref="82" ControlType="SubBand" Name="SubBand1" HeightF="23" Visible="false" />
      </SubBands>
    </Item8>
    <Item9 Ref="83" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9UFJJU01BLUxBQi1WTVxDMjtVc2VyIElEPUYzTU87UGFzc3dvcmQ9O0luaXRpYWwgQ2F0YWxvZyA9MjgxNEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0iUXVlcnlCYXNlIj48U3FsPlNlbGVjdCAgTG9qYSwgRG9jdW1lbnRvLCBjYXN0KERhdGFEb2N1bWVudG8gYXMgZGF0ZSkgQXMgRGF0YSwgQ2xpZW50ZSAsIE5vbWUgLCByb3VuZChUb3RhbFNlcnZpw6dvLDIpIGFzIFRvdGFsU2VydmnDp28sIHJvdW5kKEFkaWFudGFtZW50bywyKSBhcyBBZGlhbnRhbWVudG8gIGZyb20gKCBzZWxlY3QgZGlzdGluY3QgdGJMb2phcy5EZXNjcmljYW8gIEFTIExvamEsIHRiZG9jdW1lbnRvc1ZlbmRhcy5Eb2N1bWVudG8gQXMgRG9jdW1lbnRvLCB0YmRvY3VtZW50b3NWZW5kYXMuZGF0YWRvY3VtZW50byBBUyBbRGF0YURvY3VtZW50b10gLCAgICAgICAgICAgICAgICAgIHRiY2xpZW50ZXMuQ29kaWdvIEFTIENsaWVudGUgLCB0YmNsaWVudGVzLk5vbWUgQVMgTm9tZSAsIHRiZG9jdW1lbnRvc1ZlbmRhcy5Ub3RhbENsaWVudGVNb2VkYURvY3VtZW50byBBUyBUb3RhbFNlcnZpw6dvICwgICAgICAgICAgICAgICAgIEUuRGVzY3JpY2FvIGFzIERlc2NyaWNhb0VzdGFkbyAsIEUuQ29kaWdvIGFzIENvZGlnb0VzdGFkbywgIChTRUxFQ1QgIHJvdW5kKElTTlVMTChTVU0oICggY2FzZSB3aGVuIFROLkNvZGlnbyA9ICdQJyBUaGVuIC0xIEVsc2UgMSBlbmQgKiAoRFZMLlZhbG9ySW5jaWRlbmNpYSArIERWTC5WYWxvcklWQSkgICkgKSwgMCkgLCAyKSAgICBGUk9NIHRiRG9jdW1lbnRvc1ZlbmRhcyBBUyBEViAgICAgIElOTkVSIEpPSU4gdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIEFTIERWTCBPTiBEVi5JRCA9IERWTC5JRERvY3VtZW50b1ZlbmRhICAgICAgSU5ORVIgSk9JTiB0YlRpcG9zRG9jdW1lbnRvIEFTIFREIE9OIERWLklEVGlwb0RvY3VtZW50byA9IFRELklEICAgICAgSU5ORVIgSk9JTiB0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCBBUyBUREYgT04gVERGLklEID0gVEQuSURTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwgICAgIElOTkVSIEpPSU4gdGJFc3RhZG9zIGFzIEUgT04gRS5JRCA9IERWLklERXN0YWRvICAgICAgSU5ORVIgSk9JTiB0YlNpc3RlbWFUaXBvc0VzdGFkb3MgYXMgVEUgT04gVEUuSUQgPSBFLklEVGlwb0VzdGFkbyAgICAgICBJTk5FUiBKT0lOIHRiU2lzdGVtYU5hdHVyZXphcyBUTiBvbiBUbi5JRCA9IFRELklEU2lzdGVtYU5hdHVyZXphcyAgICAgIElOTkVSIGpvaW4gdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIGFzIERWTFNSViBvbiBkdkwuSURMaW5oYURvY3VtZW50b09yaWdlbSAgPSBEVkxTUlYuSUQgICAgICBJTk5FUiBKT0lOIHRiRG9jdW1lbnRvc1ZlbmRhcyBhcyBEVlNSViBvbiBEVlNSVi5JRCA9IERWTFNSVi5JRERvY3VtZW50b1ZlbmRhICAgICBXSEVSRSBURS5Db2RpZ28gPSAnRUZUJyAgQU5EIFRELkFkaWFudGFtZW50byA9IDEgQU5EIChUREYuVGlwbyA9ICdGUicgb3IgVERGLlRpcG8gPSAnTkMnKSAgICAgYW5kIGR2c3J2LklEID0gdGJkb2N1bWVudG9zVmVuZGFzLmlkICAgICkgYXMgQWRpYW50YW1lbnRvLCAgIChTRUxFQ1QgIHJvdW5kKElTTlVMTChTVU0oICggY2FzZSB3aGVuIFROMS5Db2RpZ28gPSAnUCcgVGhlbiAtMSBFbHNlIDEgZW5kICogKERWTDEuVmFsb3JJbmNpZGVuY2lhICsgRFZMMS5WYWxvcklWQSkgICkgKSwgMCkgLCAyKSAgICAgIEZST00gdGJEb2N1bWVudG9zVmVuZGFzIEFTIERWMSAgICAgIElOTkVSIEpPSU4gdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIEFTIERWTDEgT04gRFYxLklEID0gRFZMMS5JRERvY3VtZW50b1ZlbmRhICAgICAgSU5ORVIgSk9JTiB0YlRpcG9zRG9jdW1lbnRvIEFTIFREMSBPTiBEVjEuSURUaXBvRG9jdW1lbnRvID0gVEQxLklEICAgICAgSU5ORVIgSk9JTiB0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCBBUyBUREYxIE9OIFRERjEuSUQgPSBURDEuSURTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwgICAgIElOTkVSIEpPSU4gdGJFc3RhZG9zIGFzIEUxIE9OIEUxLklEID0gRFYxLklERXN0YWRvICAgICAgSU5ORVIgSk9JTiB0YlNpc3RlbWFUaXBvc0VzdGFkb3MgYXMgVEUxIE9OIFRFMS5JRCA9IEUxLklEVGlwb0VzdGFkbyAgICAgICBJTk5FUiBKT0lOIHRiU2lzdGVtYU5hdHVyZXphcyBUTjEgb24gVG4xLklEID0gVEQxLklEU2lzdGVtYU5hdHVyZXphcyAgICAgIElOTkVSIGpvaW4gdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIGFzIERWTFNSVjEgb24gZHZMMS5JRExpbmhhRG9jdW1lbnRvT3JpZ2VtICA9IERWTFNSVjEuSUQgICAgICBJTk5FUiBKT0lOIHRiRG9jdW1lbnRvc1ZlbmRhcyBhcyBEVlNSVjEgb24gRFZTUlYxLklEID0gRFZMU1JWMS5JRERvY3VtZW50b1ZlbmRhICAgIFdIRVJFIFRFMS5Db2RpZ28gPSAnRUZUJyAgQU5EIFREMS5BZGlhbnRhbWVudG8gPSAwIGFuZCBkdnNydjEuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXMuaWQgICAgICkgYXMgRmF0dXJhZG8gIEZST00gZGJvLnRiZG9jdW1lbnRvc3ZlbmRhcyB0YmRvY3VtZW50b3NWZW5kYXMgICAgICBsZWZ0IGpvaW4gZGJvLnRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMgb24gdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzLklEZG9jdW1lbnRvdmVuZGEgPSB0YmRvY3VtZW50b3NWZW5kYXMuSUQgICAgICAgIGxlZnQgam9pbiBkYm8udGJUaXBvc0RvY3VtZW50byBURCBvbiB0YmRvY3VtZW50b3NWZW5kYXMuSURUaXBvRG9jdW1lbnRvID0gVEQuSUQgICAgICAgbGVmdCBqb2luIGRiby50YmxvamFzIHRiTG9qYXMgb24gdGJMb2phcy5pZCA9IHRiZG9jdW1lbnRvc1ZlbmRhcy5JRExvamEgICAgICAgbGVmdCBqb2luIGRiby50YkNsaWVudGVzIHRiY2xpZW50ZXMgb24gdGJkb2N1bWVudG9zVmVuZGFzLklERW50aWRhZGUgICA9IHRiY2xpZW50ZXMuSUQgICAgICAgICBsZWZ0IEpPSU4gdGJFc3RhZG9zIGFzIEUgT04gRS5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhcy5JREVzdGFkbyAgICAgICBsZWZ0IEpPSU4gdGJTaXN0ZW1hVGlwb3NFc3RhZG9zIGFzIFRFIE9OIFRFLklEID0gRS5JRFRpcG9Fc3RhZG8gICB3aGVyZSBURC5JRFNpc3RlbWFUaXBvc0RvY3VtZW50byA9IDE3IGFuZCAgVEUuQ29kaWdvICA9ICdFRlQnICAgICAgYW5kIHRiZG9jdW1lbnRvc3ZlbmRhcyAuRGF0YURvY3VtZW50byZndDs9IGNhc2Ugd2hlbiBudWxsID0gJycgdGhlbiAnMTkwMC0wMS0wMScgZWxzZSAgbnVsbCBFTkQgICAgICAgICAgIGFuZCB0YmRvY3VtZW50b3N2ZW5kYXMgLkRhdGFEb2N1bWVudG8gJmx0Oz0gY2FzZSB3aGVuIG51bGwgPScnIHRoZW4gJzk5OTktMTItMzEnIGVsc2UgbnVsbCBFTkQgICAgIGFuZCAodGJjbGllbnRlcy5JRCA9IG51bGwgb3IgbnVsbCA9JycpIGFuZCAxPTEgKSBBUyBTUlYgIFdoZXJlIFNSVi5GYXR1cmFkbyA9MCAgb3JkZXIgYnkgU1JWLkRhdGFEb2N1bWVudG8sIFNSViAuRG9jdW1lbnRvIGRlc2MNCjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IkN1c3RvbVNxbFF1ZXJ5IiBOYW1lPSJRdWVyeVBhcmFtIj48U3FsPnNlbGVjdCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklEIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklETW9lZGFEZWZlaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIk1vcmFkYSIsICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRm90byIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGb3RvQ2FtaW5obyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJEZXNpZ25hY2FvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNvZGlnb1Bvc3RhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJMb2NhbGlkYWRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNvbmNlbGhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRpc3RyaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklERW1wcmVzYSIsDQogICAgICAgInRiU2lzdGVtYVNpZ2xhc1BhaXNlcyIuIlNpZ2xhIiwgInRiTW9lZGFzIi4iRGVzY3JpY2FvIiwNCiAgICAgICAidGJNb2VkYXMiLiJUYXhhQ29udmVyc2FvIiwgInRiTW9lZGFzIi4iU2ltYm9sbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRFBhaXMiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iVGVsZWZvbmUiLCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZheCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJFbWFpbCIsICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iTklGIg0KICBmcm9tICgoImRibyIuInRiUGFyYW1ldHJvc0VtcHJlc2EiICJ0YlBhcmFtZXRyb3NFbXByZXNhIg0KICBpbm5lciBqb2luICJkYm8iLiJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiDQogICAgICAgb24gKCJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiLiJJRCIgPSAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklEUGFpcyIpKQ0KICBpbm5lciBqb2luICJkYm8iLiJ0Yk1vZWRhcyIgInRiTW9lZGFzIg0KICAgICAgIG9uICgidGJNb2VkYXMiLiJJRCIgPSAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklETW9lZGFEZWZlaXRvIikpPC9TcWw+PE1ldGEgWD0iNDAiIFk9IjIwIiBXaWR0aD0iMTAwIiBIZWlnaHQ9IjUwNyIgLz48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQ+PFZpZXcgTmFtZT0iUXVlcnlCYXNlIj48RmllbGQgTmFtZT0iTG9qYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEb2N1bWVudG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkNsaWVudGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTm9tZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUb3RhbFNlcnZpw6dvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkFkaWFudGFtZW50byIgVHlwZT0iRG91YmxlIiAvPjwvVmlldz48VmlldyBOYW1lPSJRdWVyeVBhcmFtIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRE1vZWRhRGVmZWl0byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG9DYW1pbmhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2lnbmFjYW9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkxvY2FsaWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFbXByZXNhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lnbGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUZWxlZm9uZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGYXgiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTklGIiBUeXBlPSJTdHJpbmciIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiBEYkNvbW1hbmRUaW1lb3V0PSIxODAwIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
--Mapa 
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito],[SubReport]) 
VALUES (@intOrdem, N''documentosvendas#F3M#''+ @IDLista, N''Serviços Não Faturados'', N''Serviços Não Faturados'', N'''', 0, @ptrval, NULL, N''
Select  Loja, Documento, cast(DataDocumento as date) As Data, Cliente , Nome , round(TotalServiço,2) as TotalServiço, round(Adiantamento,2) as Adiantamento  from ( select distinct tbLojas.Descricao  AS Loja, tbdocumentosVendas.Documento As Documento, tbdocumentosVendas.datadocumento AS [DataDocumento] ,                  tbclientes.Codigo AS Cliente , tbclientes.Nome AS Nome , tbdocumentosVendas.TotalClienteMoedaDocumento AS TotalServiço ,                 E.Descricao as DescricaoEstado , E.Codigo as CodigoEstado,  (SELECT  round(ISNULL(SUM( ( case when TN.Codigo = ''''P'''' Then -1 Else 1 end * (DVL.ValorIncidencia + DVL.ValorIVA)  ) ), 0) , 2)    FROM tbDocumentosVendas AS DV      INNER JOIN tbDocumentosVendasLinhas AS DVL ON DV.ID = DVL.IDDocumentoVenda      INNER JOIN tbTiposDocumento AS TD ON DV.IDTipoDocumento = TD.ID      INNER JOIN tbSistemaTiposDocumentoFiscal AS TDF ON TDF.ID = TD.IDSistemaTiposDocumentoFiscal     INNER JOIN tbEstados as E ON E.ID = DV.IDEstado      INNER JOIN tbSistemaTiposEstados as TE ON TE.ID = E.IDTipoEstado       INNER JOIN tbSistemaNaturezas TN on Tn.ID = TD.IDSistemaNaturezas      INNER join tbDocumentosVendasLinhas as DVLSRV on dvL.IDLinhaDocumentoOrigem  = DVLSRV.ID      INNER JOIN tbDocumentosVendas as DVSRV on DVSRV.ID = DVLSRV.IDDocumentoVenda     WHERE TE.Codigo = ''''EFT''''  AND TD.Adiantamento = 1 AND (TDF.Tipo = ''''FR'''' or TDF.Tipo = ''''NC'''')     and dvsrv.ID = tbdocumentosVendas.id    ) as Adiantamento,   (SELECT  round(ISNULL(SUM( ( case when TN1.Codigo = ''''P'''' Then -1 Else 1 end * (DVL1.ValorIncidencia + DVL1.ValorIVA)  ) ), 0) , 2)      FROM tbDocumentosVendas AS DV1      INNER JOIN tbDocumentosVendasLinhas AS DVL1 ON DV1.ID = DVL1.IDDocumentoVenda      INNER JOIN tbTiposDocumento AS TD1 ON DV1.IDTipoDocumento = TD1.ID      INNER JOIN tbSistemaTiposDocumentoFiscal AS TDF1 ON TDF1.ID = TD1.IDSistemaTiposDocumentoFiscal     INNER JOIN tbEstados as E1 ON E1.ID = DV1.IDEstado      INNER JOIN tbSistemaTiposEstados as TE1 ON TE1.ID = E1.IDTipoEstado       INNER JOIN tbSistemaNaturezas TN1 on Tn1.ID = TD1.IDSistemaNaturezas      INNER join tbDocumentosVendasLinhas as DVLSRV1 on dvL1.IDLinhaDocumentoOrigem  = DVLSRV1.ID      INNER JOIN tbDocumentosVendas as DVSRV1 on DVSRV1.ID = DVLSRV1.IDDocumentoVenda    WHERE TE1.Codigo = ''''EFT''''  AND TD1.Adiantamento = 0 and dvsrv1.ID = tbdocumentosVendas.id     ) as Faturado  FROM dbo.tbdocumentosvendas tbdocumentosVendas      left join dbo.tbDocumentosVendasLinhas tbDocumentosVendasLinhas on tbDocumentosVendasLinhas.IDdocumentovenda = tbdocumentosVendas.ID        left join dbo.tbTiposDocumento TD on tbdocumentosVendas.IDTipoDocumento = TD.ID       left join dbo.tblojas tbLojas on tbLojas.id = tbdocumentosVendas.IDLoja       left join dbo.tbClientes tbclientes on tbdocumentosVendas.IDEntidade   = tbclientes.ID         left JOIN tbEstados as E ON E.ID = tbdocumentosVendas.IDEstado       left JOIN tbSistemaTiposEstados as TE ON TE.ID = E.IDTipoEstado   where TD.IDSistemaTiposDocumento = 17 and  TE.Codigo  = ''''EFT''''      and tbdocumentosvendas .DataDocumento>= case when @DataDe = '''''''' then ''''1900-01-01'''' else  @DataDe END           and tbdocumentosvendas .DataDocumento <= case when @DataAte ='''''''' then ''''9999-12-31'''' else @DataAte END     and (tbclientes.ID = @CodigoCliente or @CodigoCliente ='''''''') and @filtro ) AS SRV  Where SRV.Faturado =0  order by SRV.DataDocumento, SRV.Documento 
'', 1, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''', NULL, NULL, NULL, 1,0)
')



--nova lista Vendas Resumo
EXEC('IF NOT EXISTS (SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao = ''Vendas Resumo'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Clientes''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Vendas Resumo'', @IDUtil, 0, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbdocumentosvendas'', N''
SELECT              CASE   WHEN @Grupo = ''''Loja'''' THEN tbLojas.Descricao   WHEN @Grupo = ''''Marca'''' THEN tbMarcas.Descricao   WHEN @Grupo = ''''Tipo Artigo'''' Then tbTiposArtigos.Descricao  WHEN @Grupo = ''''Fornecedor'''' THEN tbFornecedores.Nome  WHEN @Grupo = ''''Campanha'''' THEN tbCampanhas.Descricao         ELSE tbLojas.Descricao  END as Grupo,    SUM((CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END))    AS Quantidade,    round(SUM((ISNULL(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoSemIva , 0) + ISNULL(tbdocumentosVendaslinhas.ValorDescontoEfetivoSemIva  , 0)) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R''''    THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)),2)    AS ValorBruto,   round(SUM(ISNULL(tbdocumentosVendaslinhas.ValorDescontoEfetivoSemIva  , 0) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)),2)    AS Descontos,   round(SUM(ISNULL(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoSemIva , 0) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)),2)    AS [ValorLiquido],   round(SUM(ISNULL(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoSemIva , 0) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)) /      (select   round(SUM(ISNULL(tbdocumentosVendaslinhas2.PrecoUnitarioEfetivoSemIva , 0) * (CASE WHEN tbSistemaNaturezas2.codigo = ''''R'''' THEN tbdocumentosVendaslinhas2.Quantidade ELSE - (tbdocumentosVendaslinhas2.Quantidade) END)),2)       from   dbo.tbDocumentosVendas AS tbdocumentosVendas2 WITH (nolock) LEFT OUTER JOIN  dbo.tbDocumentosVendasLinhas AS tbdocumentosVendaslinhas2 WITH (nolock) ON tbdocumentosVendaslinhas2.IDDocumentoVenda = tbdocumentosVendas2.ID LEFT OUTER JOIN  dbo.tbArtigos AS tbArtigos2 WITH (nolock) ON tbArtigos2.ID = tbdocumentosVendaslinhas2.IDArtigo LEFT OUTER JOIN  dbo.tbArtigosFornecedores AS tbArtigosFornecedores2 WITH (nolock) ON tbArtigos2.ID = tbArtigosFornecedores2.IDArtigo AND tbArtigosFornecedores2.Ordem = 1 LEFT OUTER JOIN  dbo.tbFornecedores AS tbFornecedores2 WITH (nolock) ON tbFornecedores2.ID = tbArtigosFornecedores2.IDFornecedor AND tbArtigosFornecedores2.Ordem = 1 LEFT OUTER JOIN  dbo.tbMarcas AS tbMarcas2 WITH (nolock) ON tbMarcas2.ID = tbArtigos2.IDMarca LEFT OUTER JOIN  dbo.tbLojas AS tbLojas2 WITH (nolock) ON tbLojas2.ID = tbdocumentosVendas2.IDLoja LEFT OUTER JOIN  dbo.tbEstados AS tbEstados2 WITH (nolock) ON tbEstados2.ID = tbdocumentosVendas2.IDEstado LEFT OUTER JOIN  dbo.tbCampanhas AS tbCampanhas2 WITH (nolock) ON tbdocumentosVendaslinhas2.IDCampanha = tbCampanhas2.ID LEFT OUTER JOIN  dbo.tbSistemaTiposEstados AS tbsistematiposestados2 WITH (nolock) ON tbsistematiposestados2.ID = tbEstados2.IDTipoEstado LEFT OUTER JOIN  dbo.tbUnidades AS tbUnidades2 WITH (nolock) ON tbUnidades2.ID = tbArtigos2.IDUnidade LEFT OUTER JOIN  dbo.tbTiposDocumento AS tbTiposDocumento2 WITH (nolock) ON tbTiposDocumento2.ID = tbdocumentosVendas2.IDTipoDocumento LEFT OUTER JOIN  dbo.tbSistemaTiposDocumento AS tbSistemaTiposDocumento2 WITH (nolock) ON tbSistemaTiposDocumento2.ID = tbTiposDocumento2.IDSistemaTiposDocumento LEFT OUTER JOIN  dbo.tbSistemaNaturezas AS tbSistemaNaturezas2 WITH (nolock) ON tbSistemaNaturezas2.ID = tbTiposDocumento2.IDSistemaNaturezas LEFT OUTER JOIN  dbo.tbTiposDocumentoSeries AS tbTiposDocumentoSeries2 WITH (nolock) ON tbTiposDocumentoSeries2.ID = tbdocumentosVendas2.IDTiposDocumentoSeries LEFT OUTER JOIN  dbo.tbArtigosLotes AS tbArtigosLotes2 WITH (nolock) ON tbArtigosLotes2.ID = tbdocumentosVendaslinhas2.IDLote LEFT OUTER JOIN  dbo.tbClientes AS tbClientes2 WITH (nolock) ON tbClientes2.ID = tbdocumentosVendas2.IDEntidade LEFT OUTER JOIN  dbo.tbTiposArtigos AS tbtiposartigos2 WITH (nolock) ON tbtiposartigos2.ID = tbArtigos2.IDTipoArtigo LEFT OUTER JOIN  dbo.tbParametrosEmpresa AS P2 WITH (nolock) ON 1 = 1 LEFT OUTER JOIN  dbo.tbMoedas AS tbMoedas2 WITH (nolock) ON tbMoedas2.ID = P2.IDMoedaDefeito  Where  (tbsistematiposestados2.Codigo = ''''EFT'''') AND (tbSistemaTiposDocumento2.Tipo = ''''VndFinanceiro'''') and tbdocumentosVendaslinhas2.CodigoArtigo is not null ) *100 ,2) as Percentagem FROM              dbo.tbDocumentosVendas AS tbdocumentosVendas WITH (nolock) LEFT OUTER JOIN  dbo.tbDocumentosVendasLinhas AS tbdocumentosVendaslinhas WITH (nolock) ON tbdocumentosVendaslinhas.IDDocumentoVenda = tbdocumentosVendas.ID LEFT OUTER JOIN  dbo.tbArtigos AS tbArtigos WITH (nolock) ON tbArtigos.ID = tbdocumentosVendaslinhas.IDArtigo LEFT OUTER JOIN  dbo.tbArtigosFornecedores AS tbArtigosFornecedores WITH (nolock) ON tbArtigos.ID = tbArtigosFornecedores.IDArtigo AND tbArtigosFornecedores.Ordem = 1 LEFT OUTER JOIN  dbo.tbFornecedores AS tbFornecedores WITH (nolock) ON tbFornecedores.ID = tbArtigosFornecedores.IDFornecedor AND tbArtigosFornecedores.Ordem = 1 LEFT OUTER JOIN  dbo.tbMarcas AS tbMarcas WITH (nolock) ON tbMarcas.ID = tbArtigos.IDMarca LEFT OUTER JOIN  dbo.tbLojas AS tbLojas WITH (nolock) ON tbLojas.ID = tbdocumentosVendas.IDLoja LEFT OUTER JOIN  dbo.tbEstados AS tbEstados WITH (nolock) ON tbEstados.ID = tbdocumentosVendas.IDEstado LEFT OUTER JOIN  dbo.tbCampanhas WITH (nolock) ON tbdocumentosVendaslinhas.IDCampanha = dbo.tbCampanhas.ID LEFT OUTER JOIN  dbo.tbSistemaTiposEstados AS tbsistematiposestados WITH (nolock) ON tbsistematiposestados.ID = tbEstados.IDTipoEstado LEFT OUTER JOIN  dbo.tbUnidades AS tbUnidades WITH (nolock) ON tbUnidades.ID = tbArtigos.IDUnidade LEFT OUTER JOIN  dbo.tbTiposDocumento AS tbTiposDocumento WITH (nolock) ON tbTiposDocumento.ID = tbdocumentosVendas.IDTipoDocumento LEFT OUTER JOIN  dbo.tbSistemaTiposDocumento AS tbSistemaTiposDocumento WITH (nolock) ON tbSistemaTiposDocumento.ID = tbTiposDocumento.IDSistemaTiposDocumento LEFT OUTER JOIN  dbo.tbSistemaNaturezas AS tbSistemaNaturezas WITH (nolock) ON tbSistemaNaturezas.ID = tbTiposDocumento.IDSistemaNaturezas LEFT OUTER JOIN  dbo.tbTiposDocumentoSeries AS tbTiposDocumentoSeries WITH (nolock) ON tbTiposDocumentoSeries.ID = tbdocumentosVendas.IDTiposDocumentoSeries LEFT OUTER JOIN  dbo.tbArtigosLotes AS tbArtigosLotes WITH (nolock) ON tbArtigosLotes.ID = tbdocumentosVendaslinhas.IDLote LEFT OUTER JOIN  dbo.tbClientes AS tbClientes WITH (nolock) ON tbClientes.ID = tbdocumentosVendas.IDEntidade LEFT OUTER JOIN  dbo.tbTiposArtigos AS tbtiposartigos WITH (nolock) ON tbtiposartigos.ID = tbArtigos.IDTipoArtigo LEFT OUTER JOIN  dbo.tbParametrosEmpresa AS P WITH (nolock) ON 1 = 1 LEFT OUTER JOIN  dbo.tbMoedas AS tbMoedas WITH (nolock) ON tbMoedas.ID = P.IDMoedaDefeito WHERE          (tbsistematiposestados.Codigo = ''''EFT'''') AND (tbSistemaTiposDocumento.Tipo = ''''VndFinanceiro'''') and tbdocumentosVendaslinhas.CodigoArtigo is not null          and tbDocumentosVendas.datadocumento >= case when @DataDe = '''''''' then ''''1900-01-01'''' else  @DataDe END         and tbDocumentosVendas.datadocumento <= case when @DataAte ='''''''' then ''''9999-12-31'''' else @DataAte END      and @IDLoja = Case when @IDLoja ='''''''' Then '''''''' else tbDocumentosVendas.IDLoja End and @filtro   GROUP BY   CASE   WHEN @Grupo = ''''Lojas'''' THEN tbLojas.Descricao   WHEN @Grupo = ''''Marca'''' THEN tbMarcas.Descricao   WHEN @Grupo = ''''Tipo Artigo'''' Then tbTiposArtigos.Descricao  WHEN @Grupo = ''''Fornecedor'''' THEN tbFornecedores.Nome  WHEN @Grupo = ''''Campanha'''' THEN tbCampanhas.Descricao         ELSE tbLojas.Descricao END order by  percentagem desc
'', 3, 3)
END
')

--colunas da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Vendas Resumo''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Grupo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 125, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Quantidade'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 160, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''ValorBruto'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 125, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Descontos'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 125, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''ValorLiquido'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 125, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Percentagem'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 125, 0)
END')

--parâmetros da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Vendas Resumo''
DELETE FROM [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''De'', N''F3MData'', 300, NULL, N''DataDe'', NULL, 0, 1, N'''', NULL, NULL, NULL, 0, 1, CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL, NULL, NULL, NULL, N'''', N''Sem Lookup'', NULL, NULL, NULL, N''Data'')
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''Até'', N''F3MData'', 400, NULL, N''DataAte'', NULL, 0, 1, N'''', NULL, NULL, NULL, 0, 1, CAST(N''2020-08-07T15:37:11.537'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.537'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL, NULL, NULL, NULL, N'''', N''Sem Lookup'', NULL, NULL, NULL, N''Data'')
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''Loja'', N''F3MLookup'', 200, NULL, N''IDLoja'', NULL, 0, 1, N'''', N''../Admin/Lojas'', N''../../Admin/Lojas/IndexGrelha'', N''Descricao'', 0, 1, CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, N''tbLojas'', NULL, NULL, NULL, N'''', N''Listas Personalizadas'', N''tbdocumentosVendas'', N''Lojas'', N''IDLoja'', NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''Grupo'', N''F3MDropDownList'', 100, NULL, N''Grupo'', NULL, 0, 1, N'''', N''../AnalisesDinamicas/LookupGeneric'', NULL, NULL, 0, 1, CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''1'', N''col-f3m col-3'', 0, N''DropDownEnviaParams'', NULL, 1, NULL, NULL, NULL, NULL, N''Loja;Tipo Artigo;Marca;Campanha;Fornecedor'', N''Sem Lookup'', NULL, NULL, NULL, N''Dropdown'')
END')

--configurações da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
DECLARE @IDConfiguracao as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Vendas Resumo''
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasGruposPorDefeito] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbConfiguracoesConsultas] ([IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, 0, 1, CAST(N''2020-07-21T12:28:59.820'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.180'' AS DateTime), N''1'')
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''ValorBruto'', N''sum'', 0, 1, CAST(N''2020-08-07T16:08:57.030'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:08:57.030'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''Quantidade'', N''sum'', 0, 1, CAST(N''2020-08-07T16:08:57.037'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:08:57.030'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''Descontos'', N''sum'', 0, 1, CAST(N''2020-08-07T16:08:57.037'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:08:57.037'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''ValorLiquido'', N''min'', 0, 1, CAST(N''2020-08-07T16:08:57.037'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:08:57.037'' AS DateTime), N''1'')
END')

--mapa vista da lista
EXEC('
DECLARE @intOrdem as int;
DECLARE @ptrval xml;  
DECLARE @IDLista as varchar(max);  
SELECT @intOrdem = Max(isnull(Ordem,0)) + 1 FROM tbMapasVistas
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Vendas Resumo''

SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="Vendas Resumo" Margins="26, 0, 25, 25" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" DataMember="QueryParam" DataSource="#Ref-0" TextAlignment="MiddleRight">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="1" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item3 Ref="7" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item4 Ref="8" Visible="false" Description="Via" Name="Via" />
    <Item5 Ref="9" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item6 Ref="10" Description="Utilizador" Name="Utilizador" />
    <Item7 Ref="11" Description="Titulo" Name="Titulo" />
    <Item8 Ref="12" AllowNull="true" Name="UrlServerPath" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="13" Name="CalculatedField2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputs.QueryDistOutputsQueryDistOutputArtigo" />
    <Item2 Ref="14" Name="Dim2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputArtigo" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="15" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="16" ControlType="ReportHeaderBand" Name="ReportHeader" Expanded="false" HeightF="0" />
    <Item3 Ref="17" ControlType="PageHeaderBand" Name="PageHeader" HeightF="87.51">
      <SubBands>
        <Item1 Ref="18" ControlType="SubBand" Name="SubBand3" HeightF="0" />
      </SubBands>
      <Controls>
        <Item1 Ref="19" ControlType="XRLabel" Name="label14" Multiline="true" Text="%" TextAlignment="MiddleCenter" SizeF="46.04,23" LocationFloat="721.87, 62.41" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="20" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="21" ControlType="XRLabel" Name="label13" Multiline="true" Text="Valor Liquido" TextAlignment="MiddleRight" SizeF="93.66,23" LocationFloat="621.87, 62.41" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="22" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="23" ControlType="XRLabel" Name="label12" Multiline="true" Text="Descontos" TextAlignment="MiddleRight" SizeF="96.84,23" LocationFloat="523.95, 62.41" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="24" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="25" ControlType="XRLabel" Name="label11" Multiline="true" Text="Valor Bruto" TextAlignment="MiddleRight" SizeF="98.92,23" LocationFloat="421.87, 62.41" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="26" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="27" ControlType="XRLabel" Name="label10" Multiline="true" Text="Qtd." TextAlignment="MiddleRight" SizeF="101,23" LocationFloat="319.79, 62.41" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="28" UseFont="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="29" ControlType="XRLabel" Name="label9" Multiline="true" Text="Grupo" TextAlignment="MiddleLeft" SizeF="100,23" LocationFloat="17.7, 62.41" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="30" UseFont="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="31" ControlType="XRLine" Name="line1" SizeF="750.21,6.02" LocationFloat="17.7, 81.47" />
        <Item8 Ref="32" ControlType="XRPageInfo" Name="XrPageInfo1" PageInfo="DateTime" TextFormatString="{0:dd/MM/yyyy HH:mm}" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="638.36, 14.57" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="33" UseFont="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="34" ControlType="XRLabel" Name="fldDesignacaoComercial" TextAlignment="TopLeft" SizeF="373.1997,19.14" LocationFloat="2.583885, 0" Font="Arial, 12pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="35" Expression="[QueryParam.DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="36" UseFont="false" UseTextAlignment="false" />
        </Item9>
        <Item10 Ref="37" ControlType="XRLine" Name="XrLine1" LineWidth="2" SizeF="768.43,6.910007" LocationFloat="2.7, 37.77" />
        <Item11 Ref="38" ControlType="XRLabel" Name="XrLabel7" TextAlignment="TopRight" SizeF="289.02,10" LocationFloat="482.11, 25" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="39" Expression="?Utilizador" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="40" UseFont="false" UseTextAlignment="false" />
        </Item11>
        <Item12 Ref="41" ControlType="XRLabel" Name="XrLabel6" Text="Vendas Resumo" TextAlignment="MiddleLeft" SizeF="373.1997,18.62502" LocationFloat="2.583885, 19.15" Font="Arial, 11.25pt" Padding="2,2,0,0,100">
          <StylePriority Ref="42" UseFont="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="43" ControlType="XRLabel" Name="XrLabel3" Text="Emissão" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="638.36, 5" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="44" UseFont="false" UseTextAlignment="false" />
        </Item13>
      </Controls>
    </Item3>
    <Item4 Ref="45" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="46" ControlType="DetailReportBand" Name="DetailReport1" Level="0" DataMember="QueryBase" DataSource="#Ref-0">
      <Bands>
        <Item1 Ref="47" ControlType="DetailBand" Name="Detail1" HeightF="25.09" KeepTogether="true">
          <Controls>
            <Item1 Ref="48" ControlType="XRLabel" Name="label2" Multiline="true" Text="label2" TextAlignment="MiddleLeft" SizeF="302.96,23" LocationFloat="17.7, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="49" Expression="[Grupo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="50" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="51" ControlType="XRLabel" Name="label7" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label7" SizeF="96.84,23" LocationFloat="523.95, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="52" Expression="[Descontos]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="53" UseFont="false" />
            </Item2>
            <Item3 Ref="54" ControlType="XRLabel" Name="label6" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label6" SizeF="95.75,23" LocationFloat="621.87, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="55" Expression="[ValorLiquido]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="56" UseFont="false" />
            </Item3>
            <Item4 Ref="57" ControlType="XRLabel" Name="label5" TextFormatString="{0:0.00}" Multiline="true" Text="label5" SizeF="45,23" LocationFloat="722.91, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="58" Expression="[Percentagem]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="59" UseFont="false" />
            </Item4>
            <Item5 Ref="60" ControlType="XRLabel" Name="label4" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label4" SizeF="98.97,23" LocationFloat="421.87, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="61" Expression="[ValorBruto]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="62" UseFont="false" />
            </Item5>
            <Item6 Ref="63" ControlType="XRLabel" Name="label3" TextFormatString="{0:# ### ##0.00}" Multiline="true" Text="label3" SizeF="100,23" LocationFloat="320.8, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="64" Expression="[Quantidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="65" UseFont="false" />
            </Item6>
          </Controls>
        </Item1>
        <Item2 Ref="66" ControlType="GroupFooterBand" Name="GroupFooter3" HeightF="39.58">
          <Controls>
            <Item1 Ref="67" ControlType="XRLabel" Name="label23" Multiline="true" Text="Total Global:" TextAlignment="MiddleLeft" SizeF="154.13,23" LocationFloat="17.7, 12.51" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <StylePriority Ref="68" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="69" ControlType="XRLine" Name="line4" SizeF="750.22,6.02" LocationFloat="17.7, 6.5" />
            <Item3 Ref="70" ControlType="XRLabel" Name="label22" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label15" SizeF="95.8,23" LocationFloat="621.84, 12.5" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="71" Expression="&#xA;&#xA;[].Sum( [ValorLiquido]  )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="72" UseFont="false" />
            </Item3>
            <Item4 Ref="73" ControlType="XRLabel" Name="label21" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label15" SizeF="96.84,23" LocationFloat="523.95, 12.5" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="74" Expression="&#xA;&#xA;[].Sum( [Descontos]   )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="75" UseFont="false" />
            </Item4>
            <Item5 Ref="76" ControlType="XRLabel" Name="label20" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label15" SizeF="98.95,23" LocationFloat="421.87, 12.5" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="77" Expression="&#xA;&#xA;[].Sum(  [ValorBruto]  )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="78" UseFont="false" />
            </Item5>
            <Item6 Ref="79" ControlType="XRLabel" Name="label19" TextFormatString="{0:# ### ##0.00}" Multiline="true" Text="label15" SizeF="100,23" LocationFloat="320.81, 12.5" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="80" Expression="&#xA;&#xA;[].Sum( [Quantidade] )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="81" UseFont="false" />
            </Item6>
          </Controls>
        </Item2>
      </Bands>
    </Item5>
    <Item6 Ref="82" ControlType="GroupFooterBand" Name="GroupFooter1" PrintAtBottom="true" RepeatEveryPage="true" PageBreak="AfterBand" HeightF="31.21">
      <Controls>
        <Item1 Ref="83" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="650.13, 11.32" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="84" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="85" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="768.43,4.000028" LocationFloat="2.7, 7.41" BorderWidth="1">
          <StylePriority Ref="86" UseBorderWidth="false" />
        </Item2>
      </Controls>
    </Item6>
    <Item7 Ref="87" ControlType="ReportFooterBand" Name="ReportFooter" HeightF="23" />
    <Item8 Ref="88" ControlType="PageFooterBand" Name="PageFooter" HeightF="1.583354">
      <SubBands>
        <Item1 Ref="89" ControlType="SubBand" Name="SubBand1" HeightF="23" Visible="false" />
      </SubBands>
    </Item8>
    <Item9 Ref="90" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9UFJJU01BLUxBQi1WTVxDNDtVc2VyIElEPUYzTU87UGFzc3dvcmQ9O0luaXRpYWwgQ2F0YWxvZyA9MjgxNEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0iUXVlcnlCYXNlIj48U3FsPg0KU0VMRUNUICAgICAgICAgICAgICBDQVNFICAgV0hFTiBudWxsID0gJ0xvamEnIFRIRU4gdGJMb2phcy5EZXNjcmljYW8gICBXSEVOIG51bGwgPSAnTWFyY2EnIFRIRU4gdGJNYXJjYXMuRGVzY3JpY2FvICAgV0hFTiBudWxsID0gJ1RpcG8gQXJ0aWdvJyBUaGVuIHRiVGlwb3NBcnRpZ29zLkRlc2NyaWNhbyAgV0hFTiBudWxsID0gJ0Zvcm5lY2Vkb3InIFRIRU4gdGJGb3JuZWNlZG9yZXMuTm9tZSAgV0hFTiBudWxsID0gJ0NhbXBhbmhhJyBUSEVOIHRiQ2FtcGFuaGFzLkRlc2NyaWNhbyAgICAgICAgIEVMU0UgdGJMb2phcy5EZXNjcmljYW8gIEVORCBhcyBHcnVwbywgICAgU1VNKChDQVNFIFdIRU4gdGJTaXN0ZW1hTmF0dXJlemFzLmNvZGlnbyA9ICdSJyBUSEVOIHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5RdWFudGlkYWRlIEVMU0UgLSAodGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlF1YW50aWRhZGUpIEVORCkpICAgIEFTIFF1YW50aWRhZGUsICAgIHJvdW5kKFNVTSgoSVNOVUxMKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5QcmVjb1VuaXRhcmlvRWZldGl2b1NlbUl2YSAsIDApICsgSVNOVUxMKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5WYWxvckRlc2NvbnRvRWZldGl2b1NlbUl2YSAgLCAwKSkgKiAoQ0FTRSBXSEVOIHRiU2lzdGVtYU5hdHVyZXphcy5jb2RpZ28gPSAnUicgICAgVEhFTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUXVhbnRpZGFkZSBFTFNFIC0gKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5RdWFudGlkYWRlKSBFTkQpKSwyKSAgICBBUyBWYWxvckJydXRvLCAgIHJvdW5kKFNVTShJU05VTEwodGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlZhbG9yRGVzY29udG9FZmV0aXZvU2VtSXZhICAsIDApICogKENBU0UgV0hFTiB0YlNpc3RlbWFOYXR1cmV6YXMuY29kaWdvID0gJ1InIFRIRU4gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlF1YW50aWRhZGUgRUxTRSAtICh0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUXVhbnRpZGFkZSkgRU5EKSksMikgICAgQVMgRGVzY29udG9zLCAgIHJvdW5kKFNVTShJU05VTEwodGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlByZWNvVW5pdGFyaW9FZmV0aXZvU2VtSXZhICwgMCkgKiAoQ0FTRSBXSEVOIHRiU2lzdGVtYU5hdHVyZXphcy5jb2RpZ28gPSAnUicgVEhFTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUXVhbnRpZGFkZSBFTFNFIC0gKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5RdWFudGlkYWRlKSBFTkQpKSwyKSAgICBBUyBbVmFsb3JMaXF1aWRvXSwgICByb3VuZChTVU0oSVNOVUxMKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5QcmVjb1VuaXRhcmlvRWZldGl2b1NlbUl2YSAsIDApICogKENBU0UgV0hFTiB0YlNpc3RlbWFOYXR1cmV6YXMuY29kaWdvID0gJ1InIFRIRU4gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlF1YW50aWRhZGUgRUxTRSAtICh0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUXVhbnRpZGFkZSkgRU5EKSkgLyAgICAgIChzZWxlY3QgICByb3VuZChTVU0oSVNOVUxMKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhczIuUHJlY29Vbml0YXJpb0VmZXRpdm9TZW1JdmEgLCAwKSAqIChDQVNFIFdIRU4gdGJTaXN0ZW1hTmF0dXJlemFzMi5jb2RpZ28gPSAnUicgVEhFTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMyLlF1YW50aWRhZGUgRUxTRSAtICh0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMyLlF1YW50aWRhZGUpIEVORCkpLDIpICAgICAgIGZyb20gICBkYm8udGJEb2N1bWVudG9zVmVuZGFzIEFTIHRiZG9jdW1lbnRvc1ZlbmRhczIgV0lUSCAobm9sb2NrKSBMRUZUIE9VVEVSIEpPSU4gIGRiby50YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMgQVMgdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzMiBXSVRIIChub2xvY2spIE9OIHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhczIuSUREb2N1bWVudG9WZW5kYSA9IHRiZG9jdW1lbnRvc1ZlbmRhczIuSUQgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJBcnRpZ29zIEFTIHRiQXJ0aWdvczIgV0lUSCAobm9sb2NrKSBPTiB0YkFydGlnb3MyLklEID0gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzMi5JREFydGlnbyBMRUZUIE9VVEVSIEpPSU4gIGRiby50YkFydGlnb3NGb3JuZWNlZG9yZXMgQVMgdGJBcnRpZ29zRm9ybmVjZWRvcmVzMiBXSVRIIChub2xvY2spIE9OIHRiQXJ0aWdvczIuSUQgPSB0YkFydGlnb3NGb3JuZWNlZG9yZXMyLklEQXJ0aWdvIEFORCB0YkFydGlnb3NGb3JuZWNlZG9yZXMyLk9yZGVtID0gMSBMRUZUIE9VVEVSIEpPSU4gIGRiby50YkZvcm5lY2Vkb3JlcyBBUyB0YkZvcm5lY2Vkb3JlczIgV0lUSCAobm9sb2NrKSBPTiB0YkZvcm5lY2Vkb3JlczIuSUQgPSB0YkFydGlnb3NGb3JuZWNlZG9yZXMyLklERm9ybmVjZWRvciBBTkQgdGJBcnRpZ29zRm9ybmVjZWRvcmVzMi5PcmRlbSA9IDEgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJNYXJjYXMgQVMgdGJNYXJjYXMyIFdJVEggKG5vbG9jaykgT04gdGJNYXJjYXMyLklEID0gdGJBcnRpZ29zMi5JRE1hcmNhIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiTG9qYXMgQVMgdGJMb2phczIgV0lUSCAobm9sb2NrKSBPTiB0YkxvamFzMi5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhczIuSURMb2phIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiRXN0YWRvcyBBUyB0YkVzdGFkb3MyIFdJVEggKG5vbG9jaykgT04gdGJFc3RhZG9zMi5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhczIuSURFc3RhZG8gTEVGVCBPVVRFUiBKT0lOICBkYm8udGJDYW1wYW5oYXMgQVMgdGJDYW1wYW5oYXMyIFdJVEggKG5vbG9jaykgT04gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzMi5JRENhbXBhbmhhID0gdGJDYW1wYW5oYXMyLklEIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiU2lzdGVtYVRpcG9zRXN0YWRvcyBBUyB0YnNpc3RlbWF0aXBvc2VzdGFkb3MyIFdJVEggKG5vbG9jaykgT04gdGJzaXN0ZW1hdGlwb3Nlc3RhZG9zMi5JRCA9IHRiRXN0YWRvczIuSURUaXBvRXN0YWRvIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiVW5pZGFkZXMgQVMgdGJVbmlkYWRlczIgV0lUSCAobm9sb2NrKSBPTiB0YlVuaWRhZGVzMi5JRCA9IHRiQXJ0aWdvczIuSURVbmlkYWRlIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiVGlwb3NEb2N1bWVudG8gQVMgdGJUaXBvc0RvY3VtZW50bzIgV0lUSCAobm9sb2NrKSBPTiB0YlRpcG9zRG9jdW1lbnRvMi5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhczIuSURUaXBvRG9jdW1lbnRvIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIEFTIHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvMiBXSVRIIChub2xvY2spIE9OIHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvMi5JRCA9IHRiVGlwb3NEb2N1bWVudG8yLklEU2lzdGVtYVRpcG9zRG9jdW1lbnRvIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiU2lzdGVtYU5hdHVyZXphcyBBUyB0YlNpc3RlbWFOYXR1cmV6YXMyIFdJVEggKG5vbG9jaykgT04gdGJTaXN0ZW1hTmF0dXJlemFzMi5JRCA9IHRiVGlwb3NEb2N1bWVudG8yLklEU2lzdGVtYU5hdHVyZXphcyBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlRpcG9zRG9jdW1lbnRvU2VyaWVzIEFTIHRiVGlwb3NEb2N1bWVudG9TZXJpZXMyIFdJVEggKG5vbG9jaykgT04gdGJUaXBvc0RvY3VtZW50b1NlcmllczIuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXMyLklEVGlwb3NEb2N1bWVudG9TZXJpZXMgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJBcnRpZ29zTG90ZXMgQVMgdGJBcnRpZ29zTG90ZXMyIFdJVEggKG5vbG9jaykgT04gdGJBcnRpZ29zTG90ZXMyLklEID0gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzMi5JRExvdGUgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJDbGllbnRlcyBBUyB0YkNsaWVudGVzMiBXSVRIIChub2xvY2spIE9OIHRiQ2xpZW50ZXMyLklEID0gdGJkb2N1bWVudG9zVmVuZGFzMi5JREVudGlkYWRlIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiVGlwb3NBcnRpZ29zIEFTIHRidGlwb3NhcnRpZ29zMiBXSVRIIChub2xvY2spIE9OIHRidGlwb3NhcnRpZ29zMi5JRCA9IHRiQXJ0aWdvczIuSURUaXBvQXJ0aWdvIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiUGFyYW1ldHJvc0VtcHJlc2EgQVMgUDIgV0lUSCAobm9sb2NrKSBPTiAxID0gMSBMRUZUIE9VVEVSIEpPSU4gIGRiby50Yk1vZWRhcyBBUyB0Yk1vZWRhczIgV0lUSCAobm9sb2NrKSBPTiB0Yk1vZWRhczIuSUQgPSBQMi5JRE1vZWRhRGVmZWl0byAgV2hlcmUgICh0YnNpc3RlbWF0aXBvc2VzdGFkb3MyLkNvZGlnbyA9ICdFRlQnKSBBTkQgKHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvMi5UaXBvID0gJ1ZuZEZpbmFuY2Vpcm8nKSBhbmQgdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzMi5Db2RpZ29BcnRpZ28gaXMgbm90IG51bGwgKSAqMTAwICwyKSBhcyBQZXJjZW50YWdlbSBGUk9NICAgICAgICAgICAgICBkYm8udGJEb2N1bWVudG9zVmVuZGFzIEFTIHRiZG9jdW1lbnRvc1ZlbmRhcyBXSVRIIChub2xvY2spIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyBBUyB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMgV0lUSCAobm9sb2NrKSBPTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuSUREb2N1bWVudG9WZW5kYSA9IHRiZG9jdW1lbnRvc1ZlbmRhcy5JRCBMRUZUIE9VVEVSIEpPSU4gIGRiby50YkFydGlnb3MgQVMgdGJBcnRpZ29zIFdJVEggKG5vbG9jaykgT04gdGJBcnRpZ29zLklEID0gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLklEQXJ0aWdvIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiQXJ0aWdvc0Zvcm5lY2Vkb3JlcyBBUyB0YkFydGlnb3NGb3JuZWNlZG9yZXMgV0lUSCAobm9sb2NrKSBPTiB0YkFydGlnb3MuSUQgPSB0YkFydGlnb3NGb3JuZWNlZG9yZXMuSURBcnRpZ28gQU5EIHRiQXJ0aWdvc0Zvcm5lY2Vkb3Jlcy5PcmRlbSA9IDEgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJGb3JuZWNlZG9yZXMgQVMgdGJGb3JuZWNlZG9yZXMgV0lUSCAobm9sb2NrKSBPTiB0YkZvcm5lY2Vkb3Jlcy5JRCA9IHRiQXJ0aWdvc0Zvcm5lY2Vkb3Jlcy5JREZvcm5lY2Vkb3IgQU5EIHRiQXJ0aWdvc0Zvcm5lY2Vkb3Jlcy5PcmRlbSA9IDEgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJNYXJjYXMgQVMgdGJNYXJjYXMgV0lUSCAobm9sb2NrKSBPTiB0Yk1hcmNhcy5JRCA9IHRiQXJ0aWdvcy5JRE1hcmNhIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiTG9qYXMgQVMgdGJMb2phcyBXSVRIIChub2xvY2spIE9OIHRiTG9qYXMuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXMuSURMb2phIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiRXN0YWRvcyBBUyB0YkVzdGFkb3MgV0lUSCAobm9sb2NrKSBPTiB0YkVzdGFkb3MuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXMuSURFc3RhZG8gTEVGVCBPVVRFUiBKT0lOICBkYm8udGJDYW1wYW5oYXMgV0lUSCAobm9sb2NrKSBPTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuSURDYW1wYW5oYSA9IGRiby50YkNhbXBhbmhhcy5JRCBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlNpc3RlbWFUaXBvc0VzdGFkb3MgQVMgdGJzaXN0ZW1hdGlwb3Nlc3RhZG9zIFdJVEggKG5vbG9jaykgT04gdGJzaXN0ZW1hdGlwb3Nlc3RhZG9zLklEID0gdGJFc3RhZG9zLklEVGlwb0VzdGFkbyBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlVuaWRhZGVzIEFTIHRiVW5pZGFkZXMgV0lUSCAobm9sb2NrKSBPTiB0YlVuaWRhZGVzLklEID0gdGJBcnRpZ29zLklEVW5pZGFkZSBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlRpcG9zRG9jdW1lbnRvIEFTIHRiVGlwb3NEb2N1bWVudG8gV0lUSCAobm9sb2NrKSBPTiB0YlRpcG9zRG9jdW1lbnRvLklEID0gdGJkb2N1bWVudG9zVmVuZGFzLklEVGlwb0RvY3VtZW50byBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlNpc3RlbWFUaXBvc0RvY3VtZW50byBBUyB0YlNpc3RlbWFUaXBvc0RvY3VtZW50byBXSVRIIChub2xvY2spIE9OIHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvLklEID0gdGJUaXBvc0RvY3VtZW50by5JRFNpc3RlbWFUaXBvc0RvY3VtZW50byBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlNpc3RlbWFOYXR1cmV6YXMgQVMgdGJTaXN0ZW1hTmF0dXJlemFzIFdJVEggKG5vbG9jaykgT04gdGJTaXN0ZW1hTmF0dXJlemFzLklEID0gdGJUaXBvc0RvY3VtZW50by5JRFNpc3RlbWFOYXR1cmV6YXMgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJUaXBvc0RvY3VtZW50b1NlcmllcyBBUyB0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIFdJVEggKG5vbG9jaykgT04gdGJUaXBvc0RvY3VtZW50b1Nlcmllcy5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhcy5JRFRpcG9zRG9jdW1lbnRvU2VyaWVzIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiQXJ0aWdvc0xvdGVzIEFTIHRiQXJ0aWdvc0xvdGVzIFdJVEggKG5vbG9jaykgT04gdGJBcnRpZ29zTG90ZXMuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuSURMb3RlIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiQ2xpZW50ZXMgQVMgdGJDbGllbnRlcyBXSVRIIChub2xvY2spIE9OIHRiQ2xpZW50ZXMuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXMuSURFbnRpZGFkZSBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlRpcG9zQXJ0aWdvcyBBUyB0YnRpcG9zYXJ0aWdvcyBXSVRIIChub2xvY2spIE9OIHRidGlwb3NhcnRpZ29zLklEID0gdGJBcnRpZ29zLklEVGlwb0FydGlnbyBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlBhcmFtZXRyb3NFbXByZXNhIEFTIFAgV0lUSCAobm9sb2NrKSBPTiAxID0gMSBMRUZUIE9VVEVSIEpPSU4gIGRiby50Yk1vZWRhcyBBUyB0Yk1vZWRhcyBXSVRIIChub2xvY2spIE9OIHRiTW9lZGFzLklEID0gUC5JRE1vZWRhRGVmZWl0byBXSEVSRSAgICAgICAgICAodGJzaXN0ZW1hdGlwb3Nlc3RhZG9zLkNvZGlnbyA9ICdFRlQnKSBBTkQgKHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvLlRpcG8gPSAnVm5kRmluYW5jZWlybycpIGFuZCB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuQ29kaWdvQXJ0aWdvIGlzIG5vdCBudWxsICAgICAgICAgIGFuZCB0YkRvY3VtZW50b3NWZW5kYXMuZGF0YWRvY3VtZW50byAmZ3Q7PSBjYXNlIHdoZW4gbnVsbCA9ICcnIHRoZW4gJzE5MDAtMDEtMDEnIGVsc2UgIG51bGwgRU5EICAgICAgICAgYW5kIHRiRG9jdW1lbnRvc1ZlbmRhcy5kYXRhZG9jdW1lbnRvICZsdDs9IGNhc2Ugd2hlbiBudWxsID0nJyB0aGVuICc5OTk5LTEyLTMxJyBlbHNlIG51bGwgRU5EICAgICAgICAgIGFuZCAodGJEb2N1bWVudG9zVmVuZGFzLklETG9qYSA9IG51bGwgb3IgbnVsbCA9ICcnKSAgICAgICAgICBhbmQgMT0xICBHUk9VUCBCWSAgIENBU0UgICBXSEVOIG51bGwgPSAnTG9qYXMnIFRIRU4gdGJMb2phcy5EZXNjcmljYW8gICBXSEVOIG51bGwgPSAnTWFyY2EnIFRIRU4gdGJNYXJjYXMuRGVzY3JpY2FvICAgV0hFTiBudWxsID0gJ1RpcG8gQXJ0aWdvJyBUaGVuIHRiVGlwb3NBcnRpZ29zLkRlc2NyaWNhbyAgV0hFTiBudWxsID0gJ0Zvcm5lY2Vkb3InIFRIRU4gdGJGb3JuZWNlZG9yZXMuTm9tZSAgV0hFTiBudWxsID0gJ0NhbXBhbmhhJyBUSEVOIHRiQ2FtcGFuaGFzLkRlc2NyaWNhbyAgICAgICAgIEVMU0UgdGJMb2phcy5EZXNjcmljYW8gRU5EIG9yZGVyIGJ5ICBwZXJjZW50YWdlbSBkZXNjIC8qR3J1cG86IExvamE7VGlwbyBBcnRpZ287TWFyY2E7Q2FtcGFuaGE7Rm9ybmVjZWRvciovDQo8L1NxbD48L1F1ZXJ5PjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0iUXVlcnlQYXJhbSI+PFNxbD5zZWxlY3QgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJNb3JhZGEiLCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZvdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRm90b0NhbWluaG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRGVzaWduYWNhb0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDb2RpZ29Qb3N0YWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iTG9jYWxpZGFkZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDb25jZWxobyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJEaXN0cml0byIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJREVtcHJlc2EiLA0KICAgICAgICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiLiJTaWdsYSIsICJ0Yk1vZWRhcyIuIkRlc2NyaWNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iVGF4YUNvbnZlcnNhbyIsICJ0Yk1vZWRhcyIuIlNpbWJvbG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURQYWlzIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIlRlbGVmb25lIiwgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGYXgiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRW1haWwiLCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIk5JRiINCiAgZnJvbSAoKCJkYm8iLiJ0YlBhcmFtZXRyb3NFbXByZXNhIiAidGJQYXJhbWV0cm9zRW1wcmVzYSINCiAgaW5uZXIgam9pbiAiZGJvIi4idGJTaXN0ZW1hU2lnbGFzUGFpc2VzIiAidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIg0KICAgICAgIG9uICgidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIi4iSUQiID0gInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRFBhaXMiKSkNCiAgaW5uZXIgam9pbiAiZGJvIi4idGJNb2VkYXMiICJ0Yk1vZWRhcyINCiAgICAgICBvbiAoInRiTW9lZGFzIi4iSUQiID0gInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIpKTwvU3FsPjxNZXRhIFg9IjQwIiBZPSIyMCIgV2lkdGg9IjEwMCIgSGVpZ2h0PSI1MDciIC8+PC9RdWVyeT48UmVzdWx0U2NoZW1hPjxEYXRhU2V0PjxWaWV3IE5hbWU9IlF1ZXJ5QmFzZSI+PEZpZWxkIE5hbWU9IkdydXBvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlF1YW50aWRhZGUiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JCcnV0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEZXNjb250b3MiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JMaXF1aWRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlBlcmNlbnRhZ2VtIiBUeXBlPSJEb3VibGUiIC8+PC9WaWV3PjxWaWV3IE5hbWU9IlF1ZXJ5UGFyYW0iPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxobyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVtcHJlc2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJTaWdsYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGF4YUNvbnZlcnNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTaW1ib2xvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZheCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOSUYiIFR5cGU9IlN0cmluZyIgLz48L1ZpZXc+PC9EYXRhU2V0PjwvUmVzdWx0U2NoZW1hPjxDb25uZWN0aW9uT3B0aW9ucyBDbG9zZUNvbm5lY3Rpb249InRydWUiIERiQ29tbWFuZFRpbWVvdXQ9IjE4MDAiIC8+PC9TcWxEYXRhU291cmNlPg==" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
--Mapa 
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito],[SubReport]) 
VALUES (@intOrdem, N''DocumentosVendas#F3M#''+ @IDLista, N''Vendas Resumo'', N''Vendas Resumo'', N'''', 0, @ptrval, NULL, N''
SELECT              CASE   WHEN @Grupo = ''''Loja'''' THEN tbLojas.Descricao   WHEN @Grupo = ''''Marca'''' THEN tbMarcas.Descricao   WHEN @Grupo = ''''Tipo Artigo'''' Then tbTiposArtigos.Descricao  WHEN @Grupo = ''''Fornecedor'''' THEN tbFornecedores.Nome  WHEN @Grupo = ''''Campanha'''' THEN tbCampanhas.Descricao         ELSE tbLojas.Descricao  END as Grupo,    SUM((CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END))    AS Quantidade,    round(SUM((ISNULL(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoSemIva , 0) + ISNULL(tbdocumentosVendaslinhas.ValorDescontoEfetivoSemIva  , 0)) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R''''    THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)),2)    AS ValorBruto,   round(SUM(ISNULL(tbdocumentosVendaslinhas.ValorDescontoEfetivoSemIva  , 0) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)),2)    AS Descontos,   round(SUM(ISNULL(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoSemIva , 0) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)),2)    AS [ValorLiquido],   round(SUM(ISNULL(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoSemIva , 0) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)) /      (select   round(SUM(ISNULL(tbdocumentosVendaslinhas2.PrecoUnitarioEfetivoSemIva , 0) * (CASE WHEN tbSistemaNaturezas2.codigo = ''''R'''' THEN tbdocumentosVendaslinhas2.Quantidade ELSE - (tbdocumentosVendaslinhas2.Quantidade) END)),2)       from   dbo.tbDocumentosVendas AS tbdocumentosVendas2 WITH (nolock) LEFT OUTER JOIN  dbo.tbDocumentosVendasLinhas AS tbdocumentosVendaslinhas2 WITH (nolock) ON tbdocumentosVendaslinhas2.IDDocumentoVenda = tbdocumentosVendas2.ID LEFT OUTER JOIN  dbo.tbArtigos AS tbArtigos2 WITH (nolock) ON tbArtigos2.ID = tbdocumentosVendaslinhas2.IDArtigo LEFT OUTER JOIN  dbo.tbArtigosFornecedores AS tbArtigosFornecedores2 WITH (nolock) ON tbArtigos2.ID = tbArtigosFornecedores2.IDArtigo AND tbArtigosFornecedores2.Ordem = 1 LEFT OUTER JOIN  dbo.tbFornecedores AS tbFornecedores2 WITH (nolock) ON tbFornecedores2.ID = tbArtigosFornecedores2.IDFornecedor AND tbArtigosFornecedores2.Ordem = 1 LEFT OUTER JOIN  dbo.tbMarcas AS tbMarcas2 WITH (nolock) ON tbMarcas2.ID = tbArtigos2.IDMarca LEFT OUTER JOIN  dbo.tbLojas AS tbLojas2 WITH (nolock) ON tbLojas2.ID = tbdocumentosVendas2.IDLoja LEFT OUTER JOIN  dbo.tbEstados AS tbEstados2 WITH (nolock) ON tbEstados2.ID = tbdocumentosVendas2.IDEstado LEFT OUTER JOIN  dbo.tbCampanhas AS tbCampanhas2 WITH (nolock) ON tbdocumentosVendaslinhas2.IDCampanha = tbCampanhas2.ID LEFT OUTER JOIN  dbo.tbSistemaTiposEstados AS tbsistematiposestados2 WITH (nolock) ON tbsistematiposestados2.ID = tbEstados2.IDTipoEstado LEFT OUTER JOIN  dbo.tbUnidades AS tbUnidades2 WITH (nolock) ON tbUnidades2.ID = tbArtigos2.IDUnidade LEFT OUTER JOIN  dbo.tbTiposDocumento AS tbTiposDocumento2 WITH (nolock) ON tbTiposDocumento2.ID = tbdocumentosVendas2.IDTipoDocumento LEFT OUTER JOIN  dbo.tbSistemaTiposDocumento AS tbSistemaTiposDocumento2 WITH (nolock) ON tbSistemaTiposDocumento2.ID = tbTiposDocumento2.IDSistemaTiposDocumento LEFT OUTER JOIN  dbo.tbSistemaNaturezas AS tbSistemaNaturezas2 WITH (nolock) ON tbSistemaNaturezas2.ID = tbTiposDocumento2.IDSistemaNaturezas LEFT OUTER JOIN  dbo.tbTiposDocumentoSeries AS tbTiposDocumentoSeries2 WITH (nolock) ON tbTiposDocumentoSeries2.ID = tbdocumentosVendas2.IDTiposDocumentoSeries LEFT OUTER JOIN  dbo.tbArtigosLotes AS tbArtigosLotes2 WITH (nolock) ON tbArtigosLotes2.ID = tbdocumentosVendaslinhas2.IDLote LEFT OUTER JOIN  dbo.tbClientes AS tbClientes2 WITH (nolock) ON tbClientes2.ID = tbdocumentosVendas2.IDEntidade LEFT OUTER JOIN  dbo.tbTiposArtigos AS tbtiposartigos2 WITH (nolock) ON tbtiposartigos2.ID = tbArtigos2.IDTipoArtigo LEFT OUTER JOIN  dbo.tbParametrosEmpresa AS P2 WITH (nolock) ON 1 = 1 LEFT OUTER JOIN  dbo.tbMoedas AS tbMoedas2 WITH (nolock) ON tbMoedas2.ID = P2.IDMoedaDefeito  Where  (tbsistematiposestados2.Codigo = ''''EFT'''') AND (tbSistemaTiposDocumento2.Tipo = ''''VndFinanceiro'''') and tbdocumentosVendaslinhas2.CodigoArtigo is not null ) *100 ,2) as Percentagem FROM              dbo.tbDocumentosVendas AS tbdocumentosVendas WITH (nolock) LEFT OUTER JOIN  dbo.tbDocumentosVendasLinhas AS tbdocumentosVendaslinhas WITH (nolock) ON tbdocumentosVendaslinhas.IDDocumentoVenda = tbdocumentosVendas.ID LEFT OUTER JOIN  dbo.tbArtigos AS tbArtigos WITH (nolock) ON tbArtigos.ID = tbdocumentosVendaslinhas.IDArtigo LEFT OUTER JOIN  dbo.tbArtigosFornecedores AS tbArtigosFornecedores WITH (nolock) ON tbArtigos.ID = tbArtigosFornecedores.IDArtigo AND tbArtigosFornecedores.Ordem = 1 LEFT OUTER JOIN  dbo.tbFornecedores AS tbFornecedores WITH (nolock) ON tbFornecedores.ID = tbArtigosFornecedores.IDFornecedor AND tbArtigosFornecedores.Ordem = 1 LEFT OUTER JOIN  dbo.tbMarcas AS tbMarcas WITH (nolock) ON tbMarcas.ID = tbArtigos.IDMarca LEFT OUTER JOIN  dbo.tbLojas AS tbLojas WITH (nolock) ON tbLojas.ID = tbdocumentosVendas.IDLoja LEFT OUTER JOIN  dbo.tbEstados AS tbEstados WITH (nolock) ON tbEstados.ID = tbdocumentosVendas.IDEstado LEFT OUTER JOIN  dbo.tbCampanhas WITH (nolock) ON tbdocumentosVendaslinhas.IDCampanha = dbo.tbCampanhas.ID LEFT OUTER JOIN  dbo.tbSistemaTiposEstados AS tbsistematiposestados WITH (nolock) ON tbsistematiposestados.ID = tbEstados.IDTipoEstado LEFT OUTER JOIN  dbo.tbUnidades AS tbUnidades WITH (nolock) ON tbUnidades.ID = tbArtigos.IDUnidade LEFT OUTER JOIN  dbo.tbTiposDocumento AS tbTiposDocumento WITH (nolock) ON tbTiposDocumento.ID = tbdocumentosVendas.IDTipoDocumento LEFT OUTER JOIN  dbo.tbSistemaTiposDocumento AS tbSistemaTiposDocumento WITH (nolock) ON tbSistemaTiposDocumento.ID = tbTiposDocumento.IDSistemaTiposDocumento LEFT OUTER JOIN  dbo.tbSistemaNaturezas AS tbSistemaNaturezas WITH (nolock) ON tbSistemaNaturezas.ID = tbTiposDocumento.IDSistemaNaturezas LEFT OUTER JOIN  dbo.tbTiposDocumentoSeries AS tbTiposDocumentoSeries WITH (nolock) ON tbTiposDocumentoSeries.ID = tbdocumentosVendas.IDTiposDocumentoSeries LEFT OUTER JOIN  dbo.tbArtigosLotes AS tbArtigosLotes WITH (nolock) ON tbArtigosLotes.ID = tbdocumentosVendaslinhas.IDLote LEFT OUTER JOIN  dbo.tbClientes AS tbClientes WITH (nolock) ON tbClientes.ID = tbdocumentosVendas.IDEntidade LEFT OUTER JOIN  dbo.tbTiposArtigos AS tbtiposartigos WITH (nolock) ON tbtiposartigos.ID = tbArtigos.IDTipoArtigo LEFT OUTER JOIN  dbo.tbParametrosEmpresa AS P WITH (nolock) ON 1 = 1 LEFT OUTER JOIN  dbo.tbMoedas AS tbMoedas WITH (nolock) ON tbMoedas.ID = P.IDMoedaDefeito WHERE          (tbsistematiposestados.Codigo = ''''EFT'''') AND (tbSistemaTiposDocumento.Tipo = ''''VndFinanceiro'''') and tbdocumentosVendaslinhas.CodigoArtigo is not null          and tbDocumentosVendas.datadocumento >= case when @DataDe = '''''''' then ''''1900-01-01'''' else  @DataDe END         and tbDocumentosVendas.datadocumento <= case when @DataAte ='''''''' then ''''9999-12-31'''' else @DataAte END          and (tbDocumentosVendas.IDLoja = @IDLoja or @IDLoja = '''''''')          and @filtro  GROUP BY   CASE   WHEN @Grupo = ''''Lojas'''' THEN tbLojas.Descricao   WHEN @Grupo = ''''Marca'''' THEN tbMarcas.Descricao   WHEN @Grupo = ''''Tipo Artigo'''' Then tbTiposArtigos.Descricao  WHEN @Grupo = ''''Fornecedor'''' THEN tbFornecedores.Nome  WHEN @Grupo = ''''Campanha'''' THEN tbCampanhas.Descricao         ELSE tbLojas.Descricao END order by  percentagem desc /*Grupo: Loja;Tipo Artigo;Marca;Campanha;Fornecedor*/
'', 1, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''', NULL, NULL, NULL, 1,0)
')


--nova lista Vendas Loja/Grupo
EXEC('IF NOT EXISTS (SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao = ''Vendas Loja/Grupo'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Clientes''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Vendas Loja/Grupo'', @IDUtil, 0, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbdocumentosvendas'', N''
SELECT          tbLojas.Descricao AS Loja,    CASE   WHEN @Grupo = ''''Marca'''' THEN tbMarcas.Descricao   WHEN @Grupo = ''''Tipo Artigo'''' Then tbTiposArtigos.Descricao  WHEN @Grupo = ''''Fornecedor'''' THEN tbFornecedores.Nome  WHEN @Grupo = ''''Campanha'''' THEN tbCampanhas.Descricao         ELSE tbTiposArtigos.Descricao  END as Grupo,    SUM((CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END))    AS Quantidade,    round(SUM((ISNULL(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoSemIva , 0) + ISNULL(tbdocumentosVendaslinhas.ValorDescontoEfetivoSemIva  , 0)) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R''''    THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)),2)    AS ValorBruto,   round(SUM(ISNULL(tbdocumentosVendaslinhas.ValorDescontoEfetivoSemIva  , 0) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)),2)    AS Descontos,   round(SUM(ISNULL(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoSemIva , 0) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)),2)    AS [ValorLiquido],   round(SUM(ISNULL(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoSemIva , 0) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)) /      (select   round(SUM(ISNULL(tbdocumentosVendaslinhas2.PrecoUnitarioEfetivoSemIva , 0) * (CASE WHEN tbSistemaNaturezas2.codigo = ''''R'''' THEN tbdocumentosVendaslinhas2.Quantidade ELSE - (tbdocumentosVendaslinhas2.Quantidade) END)),2)       from   dbo.tbDocumentosVendas AS tbdocumentosVendas2 WITH (nolock) LEFT OUTER JOIN  dbo.tbDocumentosVendasLinhas AS tbdocumentosVendaslinhas2 WITH (nolock) ON tbdocumentosVendaslinhas2.IDDocumentoVenda = tbdocumentosVendas2.ID LEFT OUTER JOIN  dbo.tbArtigos AS tbArtigos2 WITH (nolock) ON tbArtigos2.ID = tbdocumentosVendaslinhas2.IDArtigo LEFT OUTER JOIN  dbo.tbArtigosFornecedores AS tbArtigosFornecedores2 WITH (nolock) ON tbArtigos2.ID = tbArtigosFornecedores2.IDArtigo AND tbArtigosFornecedores2.Ordem = 1 LEFT OUTER JOIN  dbo.tbFornecedores AS tbFornecedores2 WITH (nolock) ON tbFornecedores2.ID = tbArtigosFornecedores2.IDFornecedor AND tbArtigosFornecedores2.Ordem = 1 LEFT OUTER JOIN  dbo.tbMarcas AS tbMarcas2 WITH (nolock) ON tbMarcas2.ID = tbArtigos2.IDMarca LEFT OUTER JOIN  dbo.tbLojas AS tbLojas2 WITH (nolock) ON tbLojas2.ID = tbdocumentosVendas2.IDLoja LEFT OUTER JOIN  dbo.tbEstados AS tbEstados2 WITH (nolock) ON tbEstados2.ID = tbdocumentosVendas2.IDEstado LEFT OUTER JOIN  dbo.tbCampanhas AS tbCampanhas2 WITH (nolock) ON tbdocumentosVendaslinhas2.IDCampanha = tbCampanhas2.ID LEFT OUTER JOIN  dbo.tbSistemaTiposEstados AS tbsistematiposestados2 WITH (nolock) ON tbsistematiposestados2.ID = tbEstados2.IDTipoEstado LEFT OUTER JOIN  dbo.tbUnidades AS tbUnidades2 WITH (nolock) ON tbUnidades2.ID = tbArtigos2.IDUnidade LEFT OUTER JOIN  dbo.tbTiposDocumento AS tbTiposDocumento2 WITH (nolock) ON tbTiposDocumento2.ID = tbdocumentosVendas2.IDTipoDocumento LEFT OUTER JOIN  dbo.tbSistemaTiposDocumento AS tbSistemaTiposDocumento2 WITH (nolock) ON tbSistemaTiposDocumento2.ID = tbTiposDocumento2.IDSistemaTiposDocumento LEFT OUTER JOIN  dbo.tbSistemaNaturezas AS tbSistemaNaturezas2 WITH (nolock) ON tbSistemaNaturezas2.ID = tbTiposDocumento2.IDSistemaNaturezas LEFT OUTER JOIN  dbo.tbTiposDocumentoSeries AS tbTiposDocumentoSeries2 WITH (nolock) ON tbTiposDocumentoSeries2.ID = tbdocumentosVendas2.IDTiposDocumentoSeries LEFT OUTER JOIN  dbo.tbArtigosLotes AS tbArtigosLotes2 WITH (nolock) ON tbArtigosLotes2.ID = tbdocumentosVendaslinhas2.IDLote LEFT OUTER JOIN  dbo.tbClientes AS tbClientes2 WITH (nolock) ON tbClientes2.ID = tbdocumentosVendas2.IDEntidade LEFT OUTER JOIN  dbo.tbTiposArtigos AS tbtiposartigos2 WITH (nolock) ON tbtiposartigos2.ID = tbArtigos2.IDTipoArtigo LEFT OUTER JOIN  dbo.tbParametrosEmpresa AS P2 WITH (nolock) ON 1 = 1 LEFT OUTER JOIN  dbo.tbMoedas AS tbMoedas2 WITH (nolock) ON tbMoedas2.ID = P2.IDMoedaDefeito  Where  (tbsistematiposestados2.Codigo = ''''EFT'''') AND (tbSistemaTiposDocumento2.Tipo = ''''VndFinanceiro'''') and tbdocumentosVendaslinhas2.CodigoArtigo is not null and   tbLojas2.codigo  = tblojas.codigo  ) *100 ,2) as Percentagem FROM              dbo.tbDocumentosVendas AS tbdocumentosVendas WITH (nolock) LEFT OUTER JOIN  dbo.tbDocumentosVendasLinhas AS tbdocumentosVendaslinhas WITH (nolock) ON tbdocumentosVendaslinhas.IDDocumentoVenda = tbdocumentosVendas.ID LEFT OUTER JOIN  dbo.tbArtigos AS tbArtigos WITH (nolock) ON tbArtigos.ID = tbdocumentosVendaslinhas.IDArtigo LEFT OUTER JOIN  dbo.tbArtigosFornecedores AS tbArtigosFornecedores WITH (nolock) ON tbArtigos.ID = tbArtigosFornecedores.IDArtigo AND tbArtigosFornecedores.Ordem = 1 LEFT OUTER JOIN  dbo.tbFornecedores AS tbFornecedores WITH (nolock) ON tbFornecedores.ID = tbArtigosFornecedores.IDFornecedor AND tbArtigosFornecedores.Ordem = 1 LEFT OUTER JOIN  dbo.tbMarcas AS tbMarcas WITH (nolock) ON tbMarcas.ID = tbArtigos.IDMarca LEFT OUTER JOIN  dbo.tbLojas AS tbLojas WITH (nolock) ON tbLojas.ID = tbdocumentosVendas.IDLoja LEFT OUTER JOIN  dbo.tbEstados AS tbEstados WITH (nolock) ON tbEstados.ID = tbdocumentosVendas.IDEstado LEFT OUTER JOIN  dbo.tbCampanhas WITH (nolock) ON tbdocumentosVendaslinhas.IDCampanha = dbo.tbCampanhas.ID LEFT OUTER JOIN  dbo.tbSistemaTiposEstados AS tbsistematiposestados WITH (nolock) ON tbsistematiposestados.ID = tbEstados.IDTipoEstado LEFT OUTER JOIN  dbo.tbUnidades AS tbUnidades WITH (nolock) ON tbUnidades.ID = tbArtigos.IDUnidade LEFT OUTER JOIN  dbo.tbTiposDocumento AS tbTiposDocumento WITH (nolock) ON tbTiposDocumento.ID = tbdocumentosVendas.IDTipoDocumento LEFT OUTER JOIN  dbo.tbSistemaTiposDocumento AS tbSistemaTiposDocumento WITH (nolock) ON tbSistemaTiposDocumento.ID = tbTiposDocumento.IDSistemaTiposDocumento LEFT OUTER JOIN  dbo.tbSistemaNaturezas AS tbSistemaNaturezas WITH (nolock) ON tbSistemaNaturezas.ID = tbTiposDocumento.IDSistemaNaturezas LEFT OUTER JOIN  dbo.tbTiposDocumentoSeries AS tbTiposDocumentoSeries WITH (nolock) ON tbTiposDocumentoSeries.ID = tbdocumentosVendas.IDTiposDocumentoSeries LEFT OUTER JOIN  dbo.tbArtigosLotes AS tbArtigosLotes WITH (nolock) ON tbArtigosLotes.ID = tbdocumentosVendaslinhas.IDLote LEFT OUTER JOIN  dbo.tbClientes AS tbClientes WITH (nolock) ON tbClientes.ID = tbdocumentosVendas.IDEntidade LEFT OUTER JOIN  dbo.tbTiposArtigos AS tbtiposartigos WITH (nolock) ON tbtiposartigos.ID = tbArtigos.IDTipoArtigo LEFT OUTER JOIN  dbo.tbParametrosEmpresa AS P WITH (nolock) ON 1 = 1 LEFT OUTER JOIN  dbo.tbMoedas AS tbMoedas WITH (nolock) ON tbMoedas.ID = P.IDMoedaDefeito WHERE          (tbsistematiposestados.Codigo = ''''EFT'''') AND (tbSistemaTiposDocumento.Tipo = ''''VndFinanceiro'''') and tbdocumentosVendaslinhas.CodigoArtigo is not null          and tbDocumentosVendas.datadocumento >= case when @DataDe = '''''''' then ''''1900-01-01'''' else  @DataDe END         and tbDocumentosVendas.datadocumento <= case when @DataAte ='''''''' then ''''9999-12-31'''' else @DataAte END  and @IDLoja = Case when @IDLoja ='''''''' Then '''''''' else tbDocumentosVendas.IDLoja End and @filtro GROUP BY   CASE   WHEN @Grupo = ''''Marca'''' THEN tbMarcas.Descricao   WHEN @Grupo = ''''Tipo Artigo'''' Then tbTiposArtigos.Descricao  WHEN @Grupo = ''''Fornecedor'''' THEN tbFornecedores.Nome  WHEN @Grupo = ''''Campanha'''' THEN tbCampanhas.Descricao         ELSE tbTiposArtigos.Descricao END, tbLojas.Codigo, tbLojas.Descricao order by tbLojas.Descricao, percentagem desc /*Grupo: Tipo Artigo;Marca;Campanha;Fornecedor*/
'', 3, 3)
END
')

--colunas da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Vendas Loja/Grupo''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Loja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 150, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Grupo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 250, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Quantidade'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''ValorBruto'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Descontos'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''ValorLiquido'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 150, 0)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth], [ECondicao]) VALUES (N''Percentagem'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 100, 0)
END')

--parâmetros da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Vendas Loja/Grupo''
DELETE FROM [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''De'', N''F3MData'', 300, NULL, N''DataDe'', NULL, 0, 1, N'''', NULL, NULL, NULL, 0, 1, CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL, NULL, NULL, NULL, N'''', N''Sem Lookup'', NULL, NULL, NULL, N''Data'')
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''Até'', N''F3MData'', 400, NULL, N''DataAte'', NULL, 0, 1, N'''', NULL, NULL, NULL, 0, 1, CAST(N''2020-08-07T15:37:11.537'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.537'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, NULL, NULL, NULL, NULL, N'''', N''Sem Lookup'', NULL, NULL, NULL, N''Data'')
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''Loja'', N''F3MLookup'', 200, NULL, N''IDLoja'', NULL, 0, 1, N'''', N''../Admin/Lojas'', N''../../Admin/Lojas/IndexGrelha'', N''Descricao'', 0, 1, CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''1'', N''col-f3m col-3'', 0, NULL, NULL, 1, N''tbLojas'', NULL, NULL, NULL, N'''', N''Listas Personalizadas'', N''tbdocumentosVendas'', N''Lojas'', N''IDLoja'', NULL)
INSERT [F3MOGeral].[dbo].[tbParametrosListasPersonalizadas] ([IDListaPersonalizada], [Label], [TipoComponente], [Ordem], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [CampoTexto], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ViewClassesCSS], [DesenhaBotaoLimpar], [FuncaoJSEnviaParams], [FuncaoJSChange], [RowNumber], [TabelaBD], [CasasDecimais], [CampoValor], [QueryField], [DropDownValue], [IsLookup], [MainTable], [EntityTable], [Field], [ConditionType]) VALUES (@IDLista, N''Grupo'', N''F3MDropDownList'', 100, NULL, N''Grupo'', NULL, 0, 1, N'''', N''../AnalisesDinamicas/LookupGeneric'', NULL, NULL, 0, 1, CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.530'' AS DateTime), N''1'', N''col-f3m col-3'', 0, N''DropDownEnviaParams'', NULL, 1, NULL, NULL, NULL, NULL, N''Tipo Artigo;Marca;Campanha;Fornecedor'', N''Sem Lookup'', NULL, NULL, NULL, N''Dropdown'')
END')

--configurações da lista
EXEC('
BEGIN 
DECLARE @IDLista as bigint
DECLARE @IDConfiguracao as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Vendas Loja/Grupo''
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasGruposPorDefeito] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] WHERE IDConfiguracoesConsultas=@IDConfiguracao
DELETE FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbConfiguracoesConsultas] ([IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, 0, 1, CAST(N''2020-07-21T12:28:59.820'' AS DateTime), N''F3M'', CAST(N''2020-08-07T15:37:11.180'' AS DateTime), N''1'')
SELECT @IDConfiguracao=ID FROM [F3MOGeral].[dbo].[tbConfiguracoesConsultas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbOpConsultasGruposPorDefeito] ([IDConfiguracoesConsultas], [Coluna], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''Loja'', 1, 0, 1, CAST(N''2020-08-07T16:40:32.163'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:40:32.163'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] ([IDConfiguracoesConsultas], [Grupo], [Coluna], [Agregador], [Header], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''ValorBruto'', N''ValorBruto'', N''sum'', 0, 0, 1, CAST(N''2020-08-07T16:40:32.180'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:40:32.180'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] ([IDConfiguracoesConsultas], [Grupo], [Coluna], [Agregador], [Header], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''Descontos'', N''Descontos'', N''sum'', 0, 0, 1, CAST(N''2020-08-07T16:40:32.183'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:40:32.183'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] ([IDConfiguracoesConsultas], [Grupo], [Coluna], [Agregador], [Header], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''Quantidade'', N''Quantidade'', N''sum'', 0, 0, 1, CAST(N''2020-08-07T16:40:32.183'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:40:32.183'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisGrupo] ([IDConfiguracoesConsultas], [Grupo], [Coluna], [Agregador], [Header], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''ValorLiquido'', N''ValorLiquido'', N''sum'', 0, 0, 1, CAST(N''2020-08-07T16:40:32.183'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:40:32.183'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''ValorBruto'', N''sum'', 0, 1, CAST(N''2020-08-07T16:40:32.160'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:40:32.160'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''Descontos'', N''sum'', 0, 1, CAST(N''2020-08-07T16:40:32.160'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:40:32.160'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''ValorLiquido'', N''sum'', 0, 1, CAST(N''2020-08-07T16:40:32.160'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:40:32.160'' AS DateTime), N''1'')
INSERT [F3MOGeral].[dbo].[tbOpConsultasTotaisRodape] ([IDConfiguracoesConsultas], [Coluna], [Agregador], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDConfiguracao, N''Quantidade'', N''sum'', 0, 1, CAST(N''2020-08-07T16:40:32.160'' AS DateTime), N''F3M'', CAST(N''2020-08-07T16:40:32.160'' AS DateTime), N''1'')	
END')

--mapa vista da lista
EXEC('
DECLARE @intOrdem as int;
DECLARE @ptrval xml;  
DECLARE @IDLista as varchar(max);  
SELECT @intOrdem = Max(isnull(Ordem,0)) + 1 FROM tbMapasVistas
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Vendas Loja/Grupo''

SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="Vendas Loja/Grupo" Margins="26, 0, 25, 25" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" DataMember="QueryParam" DataSource="#Ref-0" TextAlignment="MiddleRight">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="1" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item3 Ref="7" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item4 Ref="8" Visible="false" Description="Via" Name="Via" />
    <Item5 Ref="9" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item6 Ref="10" Description="Utilizador" Name="Utilizador" />
    <Item7 Ref="11" Description="Titulo" Name="Titulo" />
    <Item8 Ref="12" AllowNull="true" Name="UrlServerPath" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="13" Name="CalculatedField2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputs.QueryDistOutputsQueryDistOutputArtigo" />
    <Item2 Ref="14" Name="Dim2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputArtigo" />
    <Item3 Ref="15" Name="TotalQtd" Expression="[].Sum( [Quantidade] ) " DataMember="QueryBase" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="16" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="17" ControlType="ReportHeaderBand" Name="ReportHeader" Expanded="false" HeightF="0" />
    <Item3 Ref="18" ControlType="PageHeaderBand" Name="PageHeader" HeightF="92.57">
      <SubBands>
        <Item1 Ref="19" ControlType="SubBand" Name="SubBand3" HeightF="0" />
      </SubBands>
      <Controls>
        <Item1 Ref="20" ControlType="XRLabel" Name="label14" Multiline="true" Text="%" TextAlignment="MiddleCenter" SizeF="48.3,23" LocationFloat="721.87, 58.82" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="21" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="22" ControlType="XRLabel" Name="label13" Multiline="true" Text="Valor Liquido" TextAlignment="MiddleRight" SizeF="93.66,23" LocationFloat="621.87, 58.82" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="23" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="24" ControlType="XRLabel" Name="label12" Multiline="true" Text="Descontos" TextAlignment="MiddleRight" SizeF="96.84,23" LocationFloat="523.95, 58.82" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="25" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="26" ControlType="XRLabel" Name="label11" Multiline="true" Text="Valor Bruto" TextAlignment="MiddleRight" SizeF="98.92,23" LocationFloat="421.87, 58.82" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="27" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="28" ControlType="XRLabel" Name="label10" Multiline="true" Text="Qtd." TextAlignment="MiddleRight" SizeF="101,23" LocationFloat="319.79, 58.82" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="29" UseFont="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="30" ControlType="XRLabel" Name="label9" Multiline="true" Text="Grupo" TextAlignment="MiddleLeft" SizeF="100,23" LocationFloat="50, 57.29" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="31" UseFont="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="32" ControlType="XRLine" Name="line1" SizeF="768.09,6.02" LocationFloat="2.08, 79.15" />
        <Item8 Ref="33" ControlType="XRLabel" Name="label8" Multiline="true" Text="Loja" TextAlignment="MiddleLeft" SizeF="47.31,23" LocationFloat="2.69, 57.29" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="34" UseFont="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="35" ControlType="XRPageInfo" Name="XrPageInfo1" PageInfo="DateTime" TextFormatString="{0:dd/MM/yyyy HH:mm}" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="638.36, 14.57" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="36" UseFont="false" UseTextAlignment="false" />
        </Item9>
        <Item10 Ref="37" ControlType="XRLabel" Name="fldDesignacaoComercial" TextAlignment="TopLeft" SizeF="373.1997,19.14" LocationFloat="2.583885, 0" Font="Arial, 12pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="38" Expression="[QueryParam.DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="39" UseFont="false" UseTextAlignment="false" />
        </Item10>
        <Item11 Ref="40" ControlType="XRLine" Name="XrLine1" LineWidth="2" SizeF="768.43,6.910007" LocationFloat="2.7, 37.77" />
        <Item12 Ref="41" ControlType="XRLabel" Name="XrLabel7" TextAlignment="TopRight" SizeF="289.02,10" LocationFloat="482.11, 25" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="42" Expression="?Utilizador" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="43" UseFont="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="44" ControlType="XRLabel" Name="XrLabel6" Text="Vendas Loja/Grupo" TextAlignment="MiddleLeft" SizeF="373.1997,18.62502" LocationFloat="2.583885, 19.15" Font="Arial, 11.25pt" Padding="2,2,0,0,100">
          <StylePriority Ref="45" UseFont="false" UseTextAlignment="false" />
        </Item13>
        <Item14 Ref="46" ControlType="XRLabel" Name="XrLabel3" Text="Emissão" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="638.36, 5" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="47" UseFont="false" UseTextAlignment="false" />
        </Item14>
      </Controls>
    </Item3>
    <Item4 Ref="48" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="49" ControlType="DetailReportBand" Name="DetailReport1" Level="0" DataMember="QueryBase" DataSource="#Ref-0">
      <Bands>
        <Item1 Ref="50" ControlType="GroupHeaderBand" Name="GroupHeader2" HeightF="29.25">
          <GroupFields>
            <Item1 Ref="51" FieldName="Loja" />
          </GroupFields>
          <SortingSummary Ref="52" SortOrder="Descending" />
          <Controls>
            <Item1 Ref="53" ControlType="XRLine" Name="line2" SizeF="318.11,6.02" LocationFloat="2.69, 21.15" />
            <Item2 Ref="54" ControlType="XRLabel" Name="label1" Multiline="true" Text="label1" TextAlignment="MiddleLeft" SizeF="247.91,23" LocationFloat="2.69, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="55" Expression="[Loja]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="56" UseFont="false" UseTextAlignment="false" />
            </Item2>
          </Controls>
        </Item1>
        <Item2 Ref="57" ControlType="DetailBand" Name="Detail1" HeightF="25.09" KeepTogether="true">
          <Controls>
            <Item1 Ref="58" ControlType="XRLabel" Name="label2" Multiline="true" Text="label2" TextAlignment="MiddleLeft" SizeF="270.7,23" LocationFloat="50, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="59" Expression="[Grupo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="60" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="61" ControlType="XRLabel" Name="label7" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label7" SizeF="96.84,23" LocationFloat="523.95, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="62" Expression="[Descontos]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="63" UseFont="false" />
            </Item2>
            <Item3 Ref="64" ControlType="XRLabel" Name="label6" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label6" SizeF="95.75,23" LocationFloat="621.87, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="65" Expression="[ValorLiquido]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="66" UseFont="false" />
            </Item3>
            <Item4 Ref="67" ControlType="XRLabel" Name="label5" TextFormatString="{0:0.00}" Multiline="true" Text="label5" SizeF="47.91,23" LocationFloat="722.91, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="68" Expression="[Percentagem]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="69" UseFont="false" />
            </Item4>
            <Item5 Ref="70" ControlType="XRLabel" Name="label4" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label4" SizeF="98.97,23" LocationFloat="421.87, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="71" Expression="[ValorBruto]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="72" UseFont="false" />
            </Item5>
            <Item6 Ref="73" ControlType="XRLabel" Name="label3" TextFormatString="{0:# ### ##0.00}" Multiline="true" Text="label3" SizeF="100,23" LocationFloat="319.79, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="74" Expression="[Quantidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="75" UseFont="false" />
            </Item6>
          </Controls>
        </Item2>
        <Item3 Ref="76" ControlType="GroupFooterBand" Name="GroupFooter2" HeightF="35.5">
          <Controls>
            <Item1 Ref="77" ControlType="XRLabel" Name="label25" Multiline="true" Text="Total :" TextAlignment="MiddleLeft" SizeF="270.73,23" LocationFloat="49.98, 5.99" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="78" Expression="''''Total '''' + [Loja] + '''':''''" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="79" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="80" ControlType="XRLabel" Name="label18" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label15" SizeF="95.8,23" LocationFloat="621.87, 5.74" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="81" Expression="&#xA;&#xA;[][ [Loja]  == [^.Loja]].Sum( [ValorLiquido]  )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="82" UseFont="false" />
            </Item2>
            <Item3 Ref="83" ControlType="XRLabel" Name="label17" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label15" SizeF="96.84,23" LocationFloat="523.96, 5.74" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="84" Expression="&#xA;&#xA;[][ [Loja]  == [^.Loja]].Sum( [Descontos]   )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="85" UseFont="false" />
            </Item3>
            <Item4 Ref="86" ControlType="XRLabel" Name="label16" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label15" SizeF="98.92,23" LocationFloat="421.87, 5.74" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="87" Expression="&#xA;&#xA;[][ [Loja]  == [^.Loja]].Sum(  [ValorBruto]  )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="88" UseFont="false" />
            </Item4>
            <Item5 Ref="89" ControlType="XRLine" Name="line3" SizeF="719.01,6.02" LocationFloat="50, 0" />
            <Item6 Ref="90" ControlType="XRLabel" Name="label15" TextFormatString="{0:# ### ##0.00}" Multiline="true" Text="label15" SizeF="100,23" LocationFloat="320.8, 6.01" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="91" Expression="&#xA;&#xA;[][ [Loja]  == [^.Loja]].Sum( [Quantidade] )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="92" UseFont="false" />
            </Item6>
          </Controls>
        </Item3>
        <Item4 Ref="93" ControlType="GroupFooterBand" Name="GroupFooter3" Level="1" HeightF="39.58">
          <Controls>
            <Item1 Ref="94" ControlType="XRLabel" Name="label23" Multiline="true" Text="Total Global:" TextAlignment="MiddleLeft" SizeF="121.85,23" LocationFloat="50, 12.51" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <StylePriority Ref="95" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="96" ControlType="XRLine" Name="line4" SizeF="717.96,6.02" LocationFloat="50, 6.5" />
            <Item3 Ref="97" ControlType="XRLabel" Name="label22" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label15" SizeF="95.8,23" LocationFloat="621.84, 12.5" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="98" Expression="&#xA;&#xA;[].Sum( [ValorLiquido]  )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="99" UseFont="false" />
            </Item3>
            <Item4 Ref="100" ControlType="XRLabel" Name="label21" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label15" SizeF="96.84,23" LocationFloat="523.95, 12.5" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="101" Expression="&#xA;&#xA;[].Sum( [Descontos]   )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="102" UseFont="false" />
            </Item4>
            <Item5 Ref="103" ControlType="XRLabel" Name="label20" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label15" SizeF="98.95,23" LocationFloat="421.87, 12.5" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="104" Expression="&#xA;&#xA;[].Sum(  [ValorBruto]  )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="105" UseFont="false" />
            </Item5>
            <Item6 Ref="106" ControlType="XRLabel" Name="label19" TextFormatString="{0:# ### ##0.00}" Multiline="true" Text="label15" SizeF="100,23" LocationFloat="320.81, 12.5" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="107" Expression="&#xA;&#xA;[].Sum( [Quantidade] )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="108" UseFont="false" />
            </Item6>
          </Controls>
        </Item4>
      </Bands>
    </Item5>
    <Item6 Ref="109" ControlType="GroupFooterBand" Name="GroupFooter1" PrintAtBottom="true" RepeatEveryPage="true" PageBreak="AfterBand" HeightF="31.21">
      <Controls>
        <Item1 Ref="110" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="650.13, 11.32" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="111" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="112" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="768.43,4.000028" LocationFloat="2.7, 7.41" BorderWidth="1">
          <StylePriority Ref="113" UseBorderWidth="false" />
        </Item2>
      </Controls>
    </Item6>
    <Item7 Ref="114" ControlType="ReportFooterBand" Name="ReportFooter" HeightF="23" />
    <Item8 Ref="115" ControlType="PageFooterBand" Name="PageFooter" HeightF="1.583354">
      <SubBands>
        <Item1 Ref="116" ControlType="SubBand" Name="SubBand1" HeightF="23" Visible="false" />
      </SubBands>
    </Item8>
    <Item9 Ref="117" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9UFJJU01BLUxBQi1WTVxDMjtVc2VyIElEPUYzTU87UGFzc3dvcmQ9O0luaXRpYWwgQ2F0YWxvZyA9Nzk0N0YzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0iUXVlcnlCYXNlIj48U3FsPlNFTEVDVCAgICAgICAgICB0YkxvamFzLkRlc2NyaWNhbyBBUyBMb2phLCANCiAgQ0FTRSANCglXSEVOIG51bGwgPSAnTWFyY2EnIFRIRU4gdGJNYXJjYXMuRGVzY3JpY2FvIA0KCVdIRU4gbnVsbCA9ICdUaXBvIEFydGlnbycgVGhlbiB0YlRpcG9zQXJ0aWdvcy5EZXNjcmljYW8NCglXSEVOIG51bGwgPSAnRm9ybmVjZWRvcicgVEhFTiB0YkZvcm5lY2Vkb3Jlcy5Ob21lDQoJV0hFTiBudWxsID0gJ0NhbXBhbmhhJyBUSEVOIHRiQ2FtcGFuaGFzLkRlc2NyaWNhbw0KICAgICAgICBFTFNFIHRiVGlwb3NBcnRpZ29zLkRlc2NyaWNhbw0KCUVORCBhcyBHcnVwbywgDQogIFNVTSgoQ0FTRSBXSEVOIHRiU2lzdGVtYU5hdHVyZXphcy5jb2RpZ28gPSAnUicgVEhFTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUXVhbnRpZGFkZSBFTFNFIC0gKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5RdWFudGlkYWRlKSBFTkQpKSANCiAgQVMgUXVhbnRpZGFkZSwgDQogIHJvdW5kKFNVTSgoSVNOVUxMKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5QcmVjb1VuaXRhcmlvRWZldGl2b1NlbUl2YSAsIDApICsgSVNOVUxMKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5WYWxvckRlc2NvbnRvRWZldGl2b1NlbUl2YSAgLCAwKSkgKiAoQ0FTRSBXSEVOIHRiU2lzdGVtYU5hdHVyZXphcy5jb2RpZ28gPSAnUicgDQogIFRIRU4gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlF1YW50aWRhZGUgRUxTRSAtICh0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUXVhbnRpZGFkZSkgRU5EKSksMikgDQogIEFTIFZhbG9yQnJ1dG8sDQogIHJvdW5kKFNVTShJU05VTEwodGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlZhbG9yRGVzY29udG9FZmV0aXZvU2VtSXZhICAsIDApICogKENBU0UgV0hFTiB0YlNpc3RlbWFOYXR1cmV6YXMuY29kaWdvID0gJ1InIFRIRU4gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlF1YW50aWRhZGUgRUxTRSAtICh0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUXVhbnRpZGFkZSkgRU5EKSksMikgDQogIEFTIERlc2NvbnRvcywNCiAgcm91bmQoU1VNKElTTlVMTCh0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUHJlY29Vbml0YXJpb0VmZXRpdm9TZW1JdmEgLCAwKSAqIChDQVNFIFdIRU4gdGJTaXN0ZW1hTmF0dXJlemFzLmNvZGlnbyA9ICdSJyBUSEVOIHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5RdWFudGlkYWRlIEVMU0UgLSAodGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlF1YW50aWRhZGUpIEVORCkpLDIpIA0KICBBUyBbVmFsb3JMaXF1aWRvXSwNCiAgcm91bmQoU1VNKElTTlVMTCh0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUHJlY29Vbml0YXJpb0VmZXRpdm9TZW1JdmEgLCAwKSAqIChDQVNFIFdIRU4gdGJTaXN0ZW1hTmF0dXJlemFzLmNvZGlnbyA9ICdSJyBUSEVOIHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5RdWFudGlkYWRlIEVMU0UgLSAodGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlF1YW50aWRhZGUpIEVORCkpIC8NCiAgDQogIChzZWxlY3QgICByb3VuZChTVU0oSVNOVUxMKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhczIuUHJlY29Vbml0YXJpb0VmZXRpdm9TZW1JdmEgLCAwKSAqIChDQVNFIFdIRU4gdGJTaXN0ZW1hTmF0dXJlemFzMi5jb2RpZ28gPSAnUicgVEhFTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMyLlF1YW50aWRhZGUgRUxTRSAtICh0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMyLlF1YW50aWRhZGUpIEVORCkpLDIpIA0KIA0KICAgZnJvbSANCglkYm8udGJEb2N1bWVudG9zVmVuZGFzIEFTIHRiZG9jdW1lbnRvc1ZlbmRhczIgV0lUSCAobm9sb2NrKSBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIEFTIHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhczIgV0lUSCAobm9sb2NrKSBPTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMyLklERG9jdW1lbnRvVmVuZGEgPSB0YmRvY3VtZW50b3NWZW5kYXMyLklEIExFRlQgT1VURVIgSk9JTg0KCWRiby50YkFydGlnb3MgQVMgdGJBcnRpZ29zMiBXSVRIIChub2xvY2spIE9OIHRiQXJ0aWdvczIuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMyLklEQXJ0aWdvIExFRlQgT1VURVIgSk9JTg0KCWRiby50YkFydGlnb3NGb3JuZWNlZG9yZXMgQVMgdGJBcnRpZ29zRm9ybmVjZWRvcmVzMiBXSVRIIChub2xvY2spIE9OIHRiQXJ0aWdvczIuSUQgPSB0YkFydGlnb3NGb3JuZWNlZG9yZXMyLklEQXJ0aWdvIEFORCB0YkFydGlnb3NGb3JuZWNlZG9yZXMyLk9yZGVtID0gMSBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJGb3JuZWNlZG9yZXMgQVMgdGJGb3JuZWNlZG9yZXMyIFdJVEggKG5vbG9jaykgT04gdGJGb3JuZWNlZG9yZXMyLklEID0gdGJBcnRpZ29zRm9ybmVjZWRvcmVzMi5JREZvcm5lY2Vkb3IgQU5EIHRiQXJ0aWdvc0Zvcm5lY2Vkb3JlczIuT3JkZW0gPSAxIExFRlQgT1VURVIgSk9JTg0KCWRiby50Yk1hcmNhcyBBUyB0Yk1hcmNhczIgV0lUSCAobm9sb2NrKSBPTiB0Yk1hcmNhczIuSUQgPSB0YkFydGlnb3MyLklETWFyY2EgTEVGVCBPVVRFUiBKT0lODQoJZGJvLnRiTG9qYXMgQVMgdGJMb2phczIgV0lUSCAobm9sb2NrKSBPTiB0YkxvamFzMi5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhczIuSURMb2phIExFRlQgT1VURVIgSk9JTg0KCWRiby50YkVzdGFkb3MgQVMgdGJFc3RhZG9zMiBXSVRIIChub2xvY2spIE9OIHRiRXN0YWRvczIuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXMyLklERXN0YWRvIExFRlQgT1VURVIgSk9JTg0KCWRiby50YkNhbXBhbmhhcyBBUyB0YkNhbXBhbmhhczIgV0lUSCAobm9sb2NrKSBPTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMyLklEQ2FtcGFuaGEgPSB0YkNhbXBhbmhhczIuSUQgTEVGVCBPVVRFUiBKT0lODQoJZGJvLnRiU2lzdGVtYVRpcG9zRXN0YWRvcyBBUyB0YnNpc3RlbWF0aXBvc2VzdGFkb3MyIFdJVEggKG5vbG9jaykgT04gdGJzaXN0ZW1hdGlwb3Nlc3RhZG9zMi5JRCA9IHRiRXN0YWRvczIuSURUaXBvRXN0YWRvIExFRlQgT1VURVIgSk9JTg0KCWRiby50YlVuaWRhZGVzIEFTIHRiVW5pZGFkZXMyIFdJVEggKG5vbG9jaykgT04gdGJVbmlkYWRlczIuSUQgPSB0YkFydGlnb3MyLklEVW5pZGFkZSBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJUaXBvc0RvY3VtZW50byBBUyB0YlRpcG9zRG9jdW1lbnRvMiBXSVRIIChub2xvY2spIE9OIHRiVGlwb3NEb2N1bWVudG8yLklEID0gdGJkb2N1bWVudG9zVmVuZGFzMi5JRFRpcG9Eb2N1bWVudG8gTEVGVCBPVVRFUiBKT0lODQoJZGJvLnRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIEFTIHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvMiBXSVRIIChub2xvY2spIE9OIHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvMi5JRCA9IHRiVGlwb3NEb2N1bWVudG8yLklEU2lzdGVtYVRpcG9zRG9jdW1lbnRvIExFRlQgT1VURVIgSk9JTg0KCWRiby50YlNpc3RlbWFOYXR1cmV6YXMgQVMgdGJTaXN0ZW1hTmF0dXJlemFzMiBXSVRIIChub2xvY2spIE9OIHRiU2lzdGVtYU5hdHVyZXphczIuSUQgPSB0YlRpcG9zRG9jdW1lbnRvMi5JRFNpc3RlbWFOYXR1cmV6YXMgTEVGVCBPVVRFUiBKT0lODQoJZGJvLnRiVGlwb3NEb2N1bWVudG9TZXJpZXMgQVMgdGJUaXBvc0RvY3VtZW50b1NlcmllczIgV0lUSCAobm9sb2NrKSBPTiB0YlRpcG9zRG9jdW1lbnRvU2VyaWVzMi5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhczIuSURUaXBvc0RvY3VtZW50b1NlcmllcyBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJBcnRpZ29zTG90ZXMgQVMgdGJBcnRpZ29zTG90ZXMyIFdJVEggKG5vbG9jaykgT04gdGJBcnRpZ29zTG90ZXMyLklEID0gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzMi5JRExvdGUgTEVGVCBPVVRFUiBKT0lODQoJZGJvLnRiQ2xpZW50ZXMgQVMgdGJDbGllbnRlczIgV0lUSCAobm9sb2NrKSBPTiB0YkNsaWVudGVzMi5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhczIuSURFbnRpZGFkZSBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJUaXBvc0FydGlnb3MgQVMgdGJ0aXBvc2FydGlnb3MyIFdJVEggKG5vbG9jaykgT04gdGJ0aXBvc2FydGlnb3MyLklEID0gdGJBcnRpZ29zMi5JRFRpcG9BcnRpZ28gTEVGVCBPVVRFUiBKT0lODQoJZGJvLnRiUGFyYW1ldHJvc0VtcHJlc2EgQVMgUDIgV0lUSCAobm9sb2NrKSBPTiAxID0gMSBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJNb2VkYXMgQVMgdGJNb2VkYXMyIFdJVEggKG5vbG9jaykgT04gdGJNb2VkYXMyLklEID0gUDIuSURNb2VkYURlZmVpdG8NCglXaGVyZSAJKHRic2lzdGVtYXRpcG9zZXN0YWRvczIuQ29kaWdvID0gJ0VGVCcpIEFORCAodGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8yLlRpcG8gPSAnVm5kRmluYW5jZWlybycpIGFuZCB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMyLkNvZGlnb0FydGlnbyBpcyBub3QgbnVsbCBhbmQgDQoJdGJMb2phczIuY29kaWdvICA9IHRibG9qYXMuY29kaWdvICApICoxMDAgLDIpIGFzIFBlcmNlbnRhZ2VtDQpGUk9NICAgICAgICAgICAgDQoJZGJvLnRiRG9jdW1lbnRvc1ZlbmRhcyBBUyB0YmRvY3VtZW50b3NWZW5kYXMgV0lUSCAobm9sb2NrKSBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIEFTIHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcyBXSVRIIChub2xvY2spIE9OIHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5JRERvY3VtZW50b1ZlbmRhID0gdGJkb2N1bWVudG9zVmVuZGFzLklEIExFRlQgT1VURVIgSk9JTg0KCWRiby50YkFydGlnb3MgQVMgdGJBcnRpZ29zIFdJVEggKG5vbG9jaykgT04gdGJBcnRpZ29zLklEID0gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLklEQXJ0aWdvIExFRlQgT1VURVIgSk9JTg0KCWRiby50YkFydGlnb3NGb3JuZWNlZG9yZXMgQVMgdGJBcnRpZ29zRm9ybmVjZWRvcmVzIFdJVEggKG5vbG9jaykgT04gdGJBcnRpZ29zLklEID0gdGJBcnRpZ29zRm9ybmVjZWRvcmVzLklEQXJ0aWdvIEFORCB0YkFydGlnb3NGb3JuZWNlZG9yZXMuT3JkZW0gPSAxIExFRlQgT1VURVIgSk9JTg0KCWRiby50YkZvcm5lY2Vkb3JlcyBBUyB0YkZvcm5lY2Vkb3JlcyBXSVRIIChub2xvY2spIE9OIHRiRm9ybmVjZWRvcmVzLklEID0gdGJBcnRpZ29zRm9ybmVjZWRvcmVzLklERm9ybmVjZWRvciBBTkQgdGJBcnRpZ29zRm9ybmVjZWRvcmVzLk9yZGVtID0gMSBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJNYXJjYXMgQVMgdGJNYXJjYXMgV0lUSCAobm9sb2NrKSBPTiB0Yk1hcmNhcy5JRCA9IHRiQXJ0aWdvcy5JRE1hcmNhIExFRlQgT1VURVIgSk9JTg0KCWRiby50YkxvamFzIEFTIHRiTG9qYXMgV0lUSCAobm9sb2NrKSBPTiB0YkxvamFzLklEID0gdGJkb2N1bWVudG9zVmVuZGFzLklETG9qYSBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJFc3RhZG9zIEFTIHRiRXN0YWRvcyBXSVRIIChub2xvY2spIE9OIHRiRXN0YWRvcy5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhcy5JREVzdGFkbyBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJDYW1wYW5oYXMgV0lUSCAobm9sb2NrKSBPTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuSURDYW1wYW5oYSA9IGRiby50YkNhbXBhbmhhcy5JRCBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJTaXN0ZW1hVGlwb3NFc3RhZG9zIEFTIHRic2lzdGVtYXRpcG9zZXN0YWRvcyBXSVRIIChub2xvY2spIE9OIHRic2lzdGVtYXRpcG9zZXN0YWRvcy5JRCA9IHRiRXN0YWRvcy5JRFRpcG9Fc3RhZG8gTEVGVCBPVVRFUiBKT0lODQoJZGJvLnRiVW5pZGFkZXMgQVMgdGJVbmlkYWRlcyBXSVRIIChub2xvY2spIE9OIHRiVW5pZGFkZXMuSUQgPSB0YkFydGlnb3MuSURVbmlkYWRlIExFRlQgT1VURVIgSk9JTg0KCWRiby50YlRpcG9zRG9jdW1lbnRvIEFTIHRiVGlwb3NEb2N1bWVudG8gV0lUSCAobm9sb2NrKSBPTiB0YlRpcG9zRG9jdW1lbnRvLklEID0gdGJkb2N1bWVudG9zVmVuZGFzLklEVGlwb0RvY3VtZW50byBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8gQVMgdGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8gV0lUSCAobm9sb2NrKSBPTiB0YlNpc3RlbWFUaXBvc0RvY3VtZW50by5JRCA9IHRiVGlwb3NEb2N1bWVudG8uSURTaXN0ZW1hVGlwb3NEb2N1bWVudG8gTEVGVCBPVVRFUiBKT0lODQoJZGJvLnRiU2lzdGVtYU5hdHVyZXphcyBBUyB0YlNpc3RlbWFOYXR1cmV6YXMgV0lUSCAobm9sb2NrKSBPTiB0YlNpc3RlbWFOYXR1cmV6YXMuSUQgPSB0YlRpcG9zRG9jdW1lbnRvLklEU2lzdGVtYU5hdHVyZXphcyBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJUaXBvc0RvY3VtZW50b1NlcmllcyBBUyB0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIFdJVEggKG5vbG9jaykgT04gdGJUaXBvc0RvY3VtZW50b1Nlcmllcy5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhcy5JRFRpcG9zRG9jdW1lbnRvU2VyaWVzIExFRlQgT1VURVIgSk9JTg0KCWRiby50YkFydGlnb3NMb3RlcyBBUyB0YkFydGlnb3NMb3RlcyBXSVRIIChub2xvY2spIE9OIHRiQXJ0aWdvc0xvdGVzLklEID0gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLklETG90ZSBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJDbGllbnRlcyBBUyB0YkNsaWVudGVzIFdJVEggKG5vbG9jaykgT04gdGJDbGllbnRlcy5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhcy5JREVudGlkYWRlIExFRlQgT1VURVIgSk9JTg0KCWRiby50YlRpcG9zQXJ0aWdvcyBBUyB0YnRpcG9zYXJ0aWdvcyBXSVRIIChub2xvY2spIE9OIHRidGlwb3NhcnRpZ29zLklEID0gdGJBcnRpZ29zLklEVGlwb0FydGlnbyBMRUZUIE9VVEVSIEpPSU4NCglkYm8udGJQYXJhbWV0cm9zRW1wcmVzYSBBUyBQIFdJVEggKG5vbG9jaykgT04gMSA9IDEgTEVGVCBPVVRFUiBKT0lODQoJZGJvLnRiTW9lZGFzIEFTIHRiTW9lZGFzIFdJVEggKG5vbG9jaykgT04gdGJNb2VkYXMuSUQgPSBQLklETW9lZGFEZWZlaXRvDQpXSEVSRSAgICAgICAgDQoJKHRic2lzdGVtYXRpcG9zZXN0YWRvcy5Db2RpZ28gPSAnRUZUJykgQU5EICh0YlNpc3RlbWFUaXBvc0RvY3VtZW50by5UaXBvID0gJ1ZuZEZpbmFuY2Vpcm8nKSBhbmQgdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLkNvZGlnb0FydGlnbyBpcyBub3QgbnVsbCANCiAgICAgICAgYW5kIHRiRG9jdW1lbnRvc1ZlbmRhcy5kYXRhZG9jdW1lbnRvICZndDs9IGNhc2Ugd2hlbiBudWxsID0gJycgdGhlbiAnMTkwMC0wMS0wMScgZWxzZSAgbnVsbCBFTkQNCiAgICAgICAgYW5kIHRiRG9jdW1lbnRvc1ZlbmRhcy5kYXRhZG9jdW1lbnRvICZsdDs9IGNhc2Ugd2hlbiBudWxsID0nJyB0aGVuICc5OTk5LTEyLTMxJyBlbHNlIG51bGwgRU5EIA0KICAgICAgICBhbmQgMT0xIA0KR1JPVVAgQlkgDQogQ0FTRSANCglXSEVOIG51bGwgPSAnTWFyY2EnIFRIRU4gdGJNYXJjYXMuRGVzY3JpY2FvIA0KCVdIRU4gbnVsbCA9ICdUaXBvIEFydGlnbycgVGhlbiB0YlRpcG9zQXJ0aWdvcy5EZXNjcmljYW8NCglXSEVOIG51bGwgPSAnRm9ybmVjZWRvcicgVEhFTiB0YkZvcm5lY2Vkb3Jlcy5Ob21lDQoJV0hFTiBudWxsID0gJ0NhbXBhbmhhJyBUSEVOIHRiQ2FtcGFuaGFzLkRlc2NyaWNhbw0KICAgICAgICBFTFNFIHRiVGlwb3NBcnRpZ29zLkRlc2NyaWNhbw0KRU5ELCB0YkxvamFzLkNvZGlnbywgdGJMb2phcy5EZXNjcmljYW8NCm9yZGVyIGJ5IHRiTG9qYXMuRGVzY3JpY2FvLCBwZXJjZW50YWdlbSBkZXNjDQovKkdydXBvOiBUaXBvIEFydGlnbztNYXJjYTtDYW1wYW5oYTtGb3JuZWNlZG9yKi88L1NxbD48L1F1ZXJ5PjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0iUXVlcnlQYXJhbSI+PFNxbD5zZWxlY3QgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJNb3JhZGEiLCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZvdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRm90b0NhbWluaG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRGVzaWduYWNhb0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDb2RpZ29Qb3N0YWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iTG9jYWxpZGFkZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDb25jZWxobyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJEaXN0cml0byIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJREVtcHJlc2EiLA0KICAgICAgICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiLiJTaWdsYSIsICJ0Yk1vZWRhcyIuIkRlc2NyaWNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iVGF4YUNvbnZlcnNhbyIsICJ0Yk1vZWRhcyIuIlNpbWJvbG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURQYWlzIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIlRlbGVmb25lIiwgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGYXgiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRW1haWwiLCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIk5JRiINCiAgZnJvbSAoKCJkYm8iLiJ0YlBhcmFtZXRyb3NFbXByZXNhIiAidGJQYXJhbWV0cm9zRW1wcmVzYSINCiAgaW5uZXIgam9pbiAiZGJvIi4idGJTaXN0ZW1hU2lnbGFzUGFpc2VzIiAidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIg0KICAgICAgIG9uICgidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIi4iSUQiID0gInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRFBhaXMiKSkNCiAgaW5uZXIgam9pbiAiZGJvIi4idGJNb2VkYXMiICJ0Yk1vZWRhcyINCiAgICAgICBvbiAoInRiTW9lZGFzIi4iSUQiID0gInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIpKTwvU3FsPjxNZXRhIFg9IjQwIiBZPSIyMCIgV2lkdGg9IjEwMCIgSGVpZ2h0PSI1MDciIC8+PC9RdWVyeT48UmVzdWx0U2NoZW1hPjxEYXRhU2V0PjxWaWV3IE5hbWU9IlF1ZXJ5QmFzZSI+PEZpZWxkIE5hbWU9IkxvamEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iR3J1cG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iUXVhbnRpZGFkZSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckJydXRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRlc2NvbnRvcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckxpcXVpZG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUGVyY2VudGFnZW0iIFR5cGU9IkRvdWJsZSIgLz48L1ZpZXc+PFZpZXcgTmFtZT0iUXVlcnlQYXJhbSI+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURNb2VkYURlZmVpdG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvQ2FtaW5obyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNpZ25hY2FvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJMb2NhbGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERW1wcmVzYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlNpZ2xhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUYXhhQ29udmVyc2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlNpbWJvbG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGVsZWZvbmUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRmF4IiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkVtYWlsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik5JRiIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
--Mapa 
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito],[SubReport]) 
VALUES (@intOrdem, N''DocumentosVendas#F3M#''+ @IDLista, N''Vendas Loja/Grupo'', N''Vendas Loja/Grupo'', N'''', 0, @ptrval, NULL, N''
SELECT          tbLojas.Descricao AS Loja,    CASE   WHEN @Grupo = ''''Marca'''' THEN tbMarcas.Descricao   WHEN @Grupo = ''''Tipo Artigo'''' Then tbTiposArtigos.Descricao  WHEN @Grupo = ''''Fornecedor'''' THEN tbFornecedores.Nome  WHEN @Grupo = ''''Campanha'''' THEN tbCampanhas.Descricao         ELSE tbTiposArtigos.Descricao  END as Grupo,    SUM((CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END))    AS Quantidade,    round(SUM((ISNULL(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoSemIva , 0) + ISNULL(tbdocumentosVendaslinhas.ValorDescontoEfetivoSemIva  , 0)) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R''''    THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)),2)    AS ValorBruto,   round(SUM(ISNULL(tbdocumentosVendaslinhas.ValorDescontoEfetivoSemIva  , 0) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)),2)    AS Descontos,   round(SUM(ISNULL(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoSemIva , 0) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)),2)    AS [ValorLiquido],   round(SUM(ISNULL(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoSemIva , 0) * (CASE WHEN tbSistemaNaturezas.codigo = ''''R'''' THEN tbdocumentosVendaslinhas.Quantidade ELSE - (tbdocumentosVendaslinhas.Quantidade) END)) /      (select   round(SUM(ISNULL(tbdocumentosVendaslinhas2.PrecoUnitarioEfetivoSemIva , 0) * (CASE WHEN tbSistemaNaturezas2.codigo = ''''R'''' THEN tbdocumentosVendaslinhas2.Quantidade ELSE - (tbdocumentosVendaslinhas2.Quantidade) END)),2)       from   dbo.tbDocumentosVendas AS tbdocumentosVendas2 WITH (nolock) LEFT OUTER JOIN  dbo.tbDocumentosVendasLinhas AS tbdocumentosVendaslinhas2 WITH (nolock) ON tbdocumentosVendaslinhas2.IDDocumentoVenda = tbdocumentosVendas2.ID LEFT OUTER JOIN  dbo.tbArtigos AS tbArtigos2 WITH (nolock) ON tbArtigos2.ID = tbdocumentosVendaslinhas2.IDArtigo LEFT OUTER JOIN  dbo.tbArtigosFornecedores AS tbArtigosFornecedores2 WITH (nolock) ON tbArtigos2.ID = tbArtigosFornecedores2.IDArtigo AND tbArtigosFornecedores2.Ordem = 1 LEFT OUTER JOIN  dbo.tbFornecedores AS tbFornecedores2 WITH (nolock) ON tbFornecedores2.ID = tbArtigosFornecedores2.IDFornecedor AND tbArtigosFornecedores2.Ordem = 1 LEFT OUTER JOIN  dbo.tbMarcas AS tbMarcas2 WITH (nolock) ON tbMarcas2.ID = tbArtigos2.IDMarca LEFT OUTER JOIN  dbo.tbLojas AS tbLojas2 WITH (nolock) ON tbLojas2.ID = tbdocumentosVendas2.IDLoja LEFT OUTER JOIN  dbo.tbEstados AS tbEstados2 WITH (nolock) ON tbEstados2.ID = tbdocumentosVendas2.IDEstado LEFT OUTER JOIN  dbo.tbCampanhas AS tbCampanhas2 WITH (nolock) ON tbdocumentosVendaslinhas2.IDCampanha = tbCampanhas2.ID LEFT OUTER JOIN  dbo.tbSistemaTiposEstados AS tbsistematiposestados2 WITH (nolock) ON tbsistematiposestados2.ID = tbEstados2.IDTipoEstado LEFT OUTER JOIN  dbo.tbUnidades AS tbUnidades2 WITH (nolock) ON tbUnidades2.ID = tbArtigos2.IDUnidade LEFT OUTER JOIN  dbo.tbTiposDocumento AS tbTiposDocumento2 WITH (nolock) ON tbTiposDocumento2.ID = tbdocumentosVendas2.IDTipoDocumento LEFT OUTER JOIN  dbo.tbSistemaTiposDocumento AS tbSistemaTiposDocumento2 WITH (nolock) ON tbSistemaTiposDocumento2.ID = tbTiposDocumento2.IDSistemaTiposDocumento LEFT OUTER JOIN  dbo.tbSistemaNaturezas AS tbSistemaNaturezas2 WITH (nolock) ON tbSistemaNaturezas2.ID = tbTiposDocumento2.IDSistemaNaturezas LEFT OUTER JOIN  dbo.tbTiposDocumentoSeries AS tbTiposDocumentoSeries2 WITH (nolock) ON tbTiposDocumentoSeries2.ID = tbdocumentosVendas2.IDTiposDocumentoSeries LEFT OUTER JOIN  dbo.tbArtigosLotes AS tbArtigosLotes2 WITH (nolock) ON tbArtigosLotes2.ID = tbdocumentosVendaslinhas2.IDLote LEFT OUTER JOIN  dbo.tbClientes AS tbClientes2 WITH (nolock) ON tbClientes2.ID = tbdocumentosVendas2.IDEntidade LEFT OUTER JOIN  dbo.tbTiposArtigos AS tbtiposartigos2 WITH (nolock) ON tbtiposartigos2.ID = tbArtigos2.IDTipoArtigo LEFT OUTER JOIN  dbo.tbParametrosEmpresa AS P2 WITH (nolock) ON 1 = 1 LEFT OUTER JOIN  dbo.tbMoedas AS tbMoedas2 WITH (nolock) ON tbMoedas2.ID = P2.IDMoedaDefeito  Where  (tbsistematiposestados2.Codigo = ''''EFT'''') AND (tbSistemaTiposDocumento2.Tipo = ''''VndFinanceiro'''') and tbdocumentosVendaslinhas2.CodigoArtigo is not null and   tbLojas2.codigo  = tblojas.codigo  ) *100 ,2) as Percentagem FROM              dbo.tbDocumentosVendas AS tbdocumentosVendas WITH (nolock) LEFT OUTER JOIN  dbo.tbDocumentosVendasLinhas AS tbdocumentosVendaslinhas WITH (nolock) ON tbdocumentosVendaslinhas.IDDocumentoVenda = tbdocumentosVendas.ID LEFT OUTER JOIN  dbo.tbArtigos AS tbArtigos WITH (nolock) ON tbArtigos.ID = tbdocumentosVendaslinhas.IDArtigo LEFT OUTER JOIN  dbo.tbArtigosFornecedores AS tbArtigosFornecedores WITH (nolock) ON tbArtigos.ID = tbArtigosFornecedores.IDArtigo AND tbArtigosFornecedores.Ordem = 1 LEFT OUTER JOIN  dbo.tbFornecedores AS tbFornecedores WITH (nolock) ON tbFornecedores.ID = tbArtigosFornecedores.IDFornecedor AND tbArtigosFornecedores.Ordem = 1 LEFT OUTER JOIN  dbo.tbMarcas AS tbMarcas WITH (nolock) ON tbMarcas.ID = tbArtigos.IDMarca LEFT OUTER JOIN  dbo.tbLojas AS tbLojas WITH (nolock) ON tbLojas.ID = tbdocumentosVendas.IDLoja LEFT OUTER JOIN  dbo.tbEstados AS tbEstados WITH (nolock) ON tbEstados.ID = tbdocumentosVendas.IDEstado LEFT OUTER JOIN  dbo.tbCampanhas WITH (nolock) ON tbdocumentosVendaslinhas.IDCampanha = dbo.tbCampanhas.ID LEFT OUTER JOIN  dbo.tbSistemaTiposEstados AS tbsistematiposestados WITH (nolock) ON tbsistematiposestados.ID = tbEstados.IDTipoEstado LEFT OUTER JOIN  dbo.tbUnidades AS tbUnidades WITH (nolock) ON tbUnidades.ID = tbArtigos.IDUnidade LEFT OUTER JOIN  dbo.tbTiposDocumento AS tbTiposDocumento WITH (nolock) ON tbTiposDocumento.ID = tbdocumentosVendas.IDTipoDocumento LEFT OUTER JOIN  dbo.tbSistemaTiposDocumento AS tbSistemaTiposDocumento WITH (nolock) ON tbSistemaTiposDocumento.ID = tbTiposDocumento.IDSistemaTiposDocumento LEFT OUTER JOIN  dbo.tbSistemaNaturezas AS tbSistemaNaturezas WITH (nolock) ON tbSistemaNaturezas.ID = tbTiposDocumento.IDSistemaNaturezas LEFT OUTER JOIN  dbo.tbTiposDocumentoSeries AS tbTiposDocumentoSeries WITH (nolock) ON tbTiposDocumentoSeries.ID = tbdocumentosVendas.IDTiposDocumentoSeries LEFT OUTER JOIN  dbo.tbArtigosLotes AS tbArtigosLotes WITH (nolock) ON tbArtigosLotes.ID = tbdocumentosVendaslinhas.IDLote LEFT OUTER JOIN  dbo.tbClientes AS tbClientes WITH (nolock) ON tbClientes.ID = tbdocumentosVendas.IDEntidade LEFT OUTER JOIN  dbo.tbTiposArtigos AS tbtiposartigos WITH (nolock) ON tbtiposartigos.ID = tbArtigos.IDTipoArtigo LEFT OUTER JOIN  dbo.tbParametrosEmpresa AS P WITH (nolock) ON 1 = 1 LEFT OUTER JOIN  dbo.tbMoedas AS tbMoedas WITH (nolock) ON tbMoedas.ID = P.IDMoedaDefeito WHERE          (tbsistematiposestados.Codigo = ''''EFT'''') AND (tbSistemaTiposDocumento.Tipo = ''''VndFinanceiro'''') and tbdocumentosVendaslinhas.CodigoArtigo is not null          and tbDocumentosVendas.datadocumento >= case when @DataDe = '''''''' then ''''1900-01-01'''' else  @DataDe END         and tbDocumentosVendas.datadocumento <= case when @DataAte ='''''''' then ''''9999-12-31'''' else @DataAte END    and (tbDocumentosVendas.IDLoja = @IDLoja or @IDLoja = '''''''')      and @filtro  GROUP BY   CASE   WHEN @Grupo = ''''Marca'''' THEN tbMarcas.Descricao   WHEN @Grupo = ''''Tipo Artigo'''' Then tbTiposArtigos.Descricao  WHEN @Grupo = ''''Fornecedor'''' THEN tbFornecedores.Nome  WHEN @Grupo = ''''Campanha'''' THEN tbCampanhas.Descricao         ELSE tbTiposArtigos.Descricao END, tbLojas.Codigo, tbLojas.Descricao order by tbLojas.Descricao, percentagem desc /*Grupo: Tipo Artigo;Marca;Campanha;Fornecedor*/
'', 1, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''', NULL, NULL, NULL, 1,0)
')

--ajuste tbparametrosListasPersonalizadas
EXEC('update [F3MOGeral].[dbo].[tbparametrosListasPersonalizadas] set valorpordefeito=null where  valorpordefeito=''../Clientes/Clientes''')

--Mapa base Analise Dinamicas
EXEC('DECLARE @ptrval xml;  
Declare @Ordem as bigint;
SET @Ordem = (Select Max(Ordem) Ordem from tbMapasVistas)
SET @ptrval = N''<?xml version="1.0" ?>
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="F3MAnalisesDinamicasBaseF3M" Margins="26, 0, 25, 25" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" DataMember="QueryParam" DataSource="#Ref-0" TextAlignment="MiddleRight">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="1" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item3 Ref="7" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item4 Ref="8" Visible="false" Description="Via" Name="Via" />
    <Item5 Ref="9" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item6 Ref="10" Description="Utilizador" Name="Utilizador" />
    <Item7 Ref="11" Description="Titulo" Name="Titulo" />
    <Item8 Ref="12" AllowNull="true" Name="UrlServerPath" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="13" Name="CalculatedField2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputs.QueryDistOutputsQueryDistOutputArtigo" />
    <Item2 Ref="14" Name="Dim2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputArtigo" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="15" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="16" ControlType="ReportHeaderBand" Name="ReportHeader" Expanded="false" HeightF="0" />
    <Item3 Ref="17" ControlType="PageHeaderBand" Name="PageHeader" HeightF="45.71">
      <SubBands>
        <Item1 Ref="18" ControlType="SubBand" Name="SubBand3" HeightF="0" />
      </SubBands>
      <Controls>
        <Item1 Ref="19" ControlType="XRPageInfo" Name="XrPageInfo1" PageInfo="DateTime" TextFormatString="{0:dd/MM/yyyy HH:mm}" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="638.36, 14.57" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="20" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="21" ControlType="XRLabel" Name="fldDesignacaoComercial" TextAlignment="TopLeft" SizeF="373.1997,19.14" LocationFloat="2.583885, 0" Font="Arial, 12pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="22" Expression="[QueryParam.DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="23" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="24" ControlType="XRLine" Name="XrLine1" LineWidth="2" SizeF="768.43,6.910007" LocationFloat="2.7, 37.77" />
        <Item4 Ref="25" ControlType="XRLabel" Name="XrLabel7" TextAlignment="TopRight" SizeF="289.02,10" LocationFloat="482.11, 25" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="26" Expression="?Utilizador" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="27" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="28" ControlType="XRLabel" Name="XrLabel6" Text="Análise " TextAlignment="MiddleLeft" SizeF="373.1997,18.62502" LocationFloat="2.583885, 19.15" Font="Arial, 11.25pt" Padding="2,2,0,0,100">
          <StylePriority Ref="29" UseFont="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="30" ControlType="XRLabel" Name="XrLabel3" Text="Emissão" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="638.36, 5" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="31" UseFont="false" UseTextAlignment="false" />
        </Item6>
      </Controls>
    </Item3>
    <Item4 Ref="32" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="33" ControlType="DetailReportBand" Name="DetailReport1" Level="0" DataMember="QueryBase" DataSource="#Ref-0">
      <Bands>
        <Item1 Ref="34" ControlType="DetailBand" Name="Detail1" HeightF="113.39" KeepTogether="true">
          <SortFields>
            <Item1 Ref="35" FieldName="Localizacao" />
            <Item2 Ref="36" FieldName="CodigoArtigo" />
            <Item3 Ref="37" FieldName="OrdemDimensaoLinha1" />
            <Item4 Ref="38" FieldName="OrdemDimensaoLinha2" />
          </SortFields>
        </Item1>
      </Bands>
    </Item5>
    <Item6 Ref="39" ControlType="GroupFooterBand" Name="GroupFooter1" PrintAtBottom="true" RepeatEveryPage="true" PageBreak="AfterBand" HeightF="32.27">
      <Controls>
        <Item1 Ref="40" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="650.13, 9.24" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="41" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="42" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="768.43,4.000028" LocationFloat="2.7, 5.34" BorderWidth="1">
          <StylePriority Ref="43" UseBorderWidth="false" />
        </Item2>
      </Controls>
    </Item6>
    <Item7 Ref="44" ControlType="ReportFooterBand" Name="ReportFooter" HeightF="23" />
    <Item8 Ref="45" ControlType="PageFooterBand" Name="PageFooter" HeightF="1.583354">
      <SubBands>
        <Item1 Ref="46" ControlType="SubBand" Name="SubBand1" HeightF="23" Visible="false" />
      </SubBands>
    </Item8>
    <Item9 Ref="47" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9cHJpc21hLWxhYi12bS53ZXN0ZXVyb3BlLmNsb3VkYXBwLmF6dXJlLmNvbSwxNDMzO1VzZXIgSUQ9RjNNTztQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID03OTQ3RjNNTzsiIC8+PFF1ZXJ5IFR5cGU9IkN1c3RvbVNxbFF1ZXJ5IiBOYW1lPSJRdWVyeUJhc2UiPjxTcWw+c2VsZWN0ICogZnJvbSBkYm8udndDQ0NsaWVudGVzPC9TcWw+PC9RdWVyeT48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9IlF1ZXJ5UGFyYW0iPjxTcWw+c2VsZWN0ICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSUQiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURNb2VkYURlZmVpdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iTW9yYWRhIiwgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGb3RvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZvdG9DYW1pbmhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRlc2lnbmFjYW9Db21lcmNpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ29kaWdvUG9zdGFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkxvY2FsaWRhZGUiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ29uY2VsaG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRGlzdHJpdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURFbXByZXNhIiwNCiAgICAgICAidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIi4iU2lnbGEiLCAidGJNb2VkYXMiLiJEZXNjcmljYW8iLA0KICAgICAgICJ0Yk1vZWRhcyIuIlRheGFDb252ZXJzYW8iLCAidGJNb2VkYXMiLiJTaW1ib2xvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklEUGFpcyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJUZWxlZm9uZSIsICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRmF4IiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkVtYWlsIiwgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJOSUYiDQogIGZyb20gKCgiZGJvIi4idGJQYXJhbWV0cm9zRW1wcmVzYSIgInRiUGFyYW1ldHJvc0VtcHJlc2EiDQogIGlubmVyIGpvaW4gImRibyIuInRiU2lzdGVtYVNpZ2xhc1BhaXNlcyIgInRiU2lzdGVtYVNpZ2xhc1BhaXNlcyINCiAgICAgICBvbiAoInRiU2lzdGVtYVNpZ2xhc1BhaXNlcyIuIklEIiA9ICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURQYWlzIikpDQogIGlubmVyIGpvaW4gImRibyIuInRiTW9lZGFzIiAidGJNb2VkYXMiDQogICAgICAgb24gKCJ0Yk1vZWRhcyIuIklEIiA9ICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURNb2VkYURlZmVpdG8iKSk8L1NxbD48TWV0YSBYPSI0MCIgWT0iMjAiIFdpZHRoPSIxMDAiIEhlaWdodD0iNTA3IiAvPjwvUXVlcnk+PFJlc3VsdFNjaGVtYT48RGF0YVNldD48VmlldyBOYW1lPSJRdWVyeUJhc2UiPjxGaWVsZCBOYW1lPSJDb2RpZ29DbGllbnRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik5vbWVGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFbnRpZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETG9qYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0RvY3VtZW50b1NlcmllcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY3VtZW50byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhRG9jdW1lbnRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRG9jdW1lbnRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklETW9lZGEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iTmF0dXJlemEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVG90YWxNb2VkYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvciIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhUmVmZXJlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTYWxkbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJTYWxkb251bWNhc2FzZGVjaW1haXMiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9ybnVtY2FzYXNkZWNpbWFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iQ29kaWdvTG9qYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9Mb2phIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1RpcG9Eb2N1bWVudG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvVGlwb0RvY3VtZW50byIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48VmlldyBOYW1lPSJRdWVyeVBhcmFtIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRE1vZWRhRGVmZWl0byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG9DYW1pbmhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2lnbmFjYW9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkxvY2FsaWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFbXByZXNhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lnbGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUZWxlZm9uZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGYXgiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTklGIiBUeXBlPSJTdHJpbmciIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
--Criar Mapa Vazio
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito]) 
VALUES (@Ordem + 1, N''AnalisesDinamicas'', N''F3MAnalisesDinamicasBaseF3M'', N''F3MAnalisesDinamicasBaseF3M'', N'''', 0, @ptrval, NULL, NULL, 1, 1, 1, GETDATE(), N''F3M'', GETDATE(), N''F3M'', NULL, NULL, NULL, 0)
')

 --atualizar sp_AtualizaCCEntidades
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaCCEntidades]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaCCEntidades]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaCCEntidades]  
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

				SET @strSqlQuery=''DELETE FROM tbCCEntidades where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)

				SET @strSqlQueryInsert = ''insert into tbCCEntidades ([Natureza], [IDLoja], [IDTipoEntidade],[IDEntidade],[NomeFiscal],[IDTipoDocumento],[IDTipoDocumentoSeries],[IDDocumento],[NumeroDocumento],
										[DataDocumento],[Descricao], [IDMoeda], [TotalMoeda],[TotalMoedaReferencia],[TaxaConversao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao])''
								
				SELECT @strSqlQuery = @strSqlQueryInsert + '' select (case when (TD.Adiantamento=1 and TSN.Codigo=''''R'''') then ''''P'''' when (TD.Adiantamento=1 and TSN.Codigo=''''P'''') then ''''R'''' else TSN.Codigo end) as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbdocumentosvendas DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)


				SELECT @strSqlQuery = @strSqlQueryInsert + '' select (case when (TSN.Codigo=''''R'''') then ''''P'''' when (TSN.Codigo=''''P'''') then ''''R'''' else TSN.Codigo end) as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbdocumentosvendas DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaTiposDocumentoFiscal STDF on TD.IDSistemaTiposDocumentoFiscal=STDF.ID
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where TD.Adiantamento=0 and TD.GeraPendente=0 and isnull(STDF.Tipo,''''NF'''')<>''''NF'''' and DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns

				EXEC(@strSqlQuery)


				SELECT @strSqlQuery = @strSqlQueryInsert + '' select TSN.Codigo as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbrecibos DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
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

				SET @strSqlQuery=''DELETE FROM tbCCEntidades where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)
			END

		  UPDATE tbclientes set saldo=tbcc.saldo FROM tbclientes Cli
			   INNER JOIN (
			   select identidade, isnull(sum(case when natureza=''R'' then totalmoedareferencia else -totalmoedareferencia end ),0) as saldo from tbccentidades where identidade=@lngidEntidade group by IDEntidade) tbcc
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

--Permissões dos tipos de documento ACCR e ACCP
EXEC('
DECLARE @IDTipoDocEntPerm As BIGINT
DECLARE @IDTipoDocSerie As BIGINT
DECLARE @IDTipoDocSerie1 As BIGINT
DECLARE @IDPerEmpresa As BIGINT
DECLARE @IDMenuAreasEmpresa As BIGINT
Select @IDPerEmpresa  = MAX(ID) + 1 From [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa]
SELECT @IDTipoDocEntPerm = isnull(MAX(ID),0) + 1 FROM [dbo].[tbTiposDocumentoTipEntPermDoc]

SELECT TOP 1 @IDTipoDocSerie = ser.ID
FROM tbTiposDocumentoSeries AS ser
left join tbTiposDocumento as Tip On tip.ID = ser.IDTiposDocumento
left join tbSistemaTiposDocumento as St On ST.ID = Tip.IDSistemaTiposDocumento
WHERE  St.Tipo =''VndFinanceiro'' and Tip.Codigo=''ACCR''
ORDER BY ser.ID asc

SELECT TOP 1 @IDTipoDocSerie1 =  ser.ID
FROM tbTiposDocumentoSeries AS ser
left join tbTiposDocumento as Tip On tip.ID = ser.IDTiposDocumento
left join tbSistemaTiposDocumento as St On ST.ID = Tip.IDSistemaTiposDocumento
WHERE  St.Tipo =''VndFinanceiro'' and Tip.Codigo=''ACCP''
ORDER BY ser.ID asc

DECLARE @IDEMP As BIGINT
DECLARE @NomeBD as nvarchar(50)
DECLARE @CodigoBD as nvarchar(8)
SET @NomeBD = DB_name()

if replace(@NomeBD,SUBSTRING(@NomeBD,0,CHARINDEX (''F3MO'',@NomeBD, 1)) + ''F3MO'', '''') = ''''
		set @CodigoBD = ''1''
else
        set @CodigoBD = replace(@NomeBD,SUBSTRING(@NomeBD,0,CHARINDEX (''F3MO'', @NomeBD, 1)) + ''F3MO'', '''')
		
Select @IDEMP = (Select ID From [F3MOGeral].[dbo].[tbEmpresas] with(nolock) WHERE Codigo=@CodigoBD)

DECLARE @IDMenuTabelas as bigint
DECLARE @IDAreaMenuPai as bigint

SELECT @IDMenuTabelas = ID FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Tabelas''

if not exists(select ID FROM [F3MOGeral].[dbo].[tbMenusAreasEmpresa] WHERE Descricao = ''TiposDocumento'' AND IDEmpresa = @IDEMP)
begin
INSERT [F3MOGeral].[dbo].[tbMenusAreasEmpresa] ([IDMenuPai], [IDEmpresa], [Descricao], [DescricaoAbreviada], [Tabela], [Ordem], [Icon], [btnContextoConsultar], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoRemover], [btnContextoImprimir], [btnContextoExportar], [btnContextoF4], [Activo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar], [IDPaiAreaEmpresa], [CampoDescricao], [CampoRelacaoPai])
VALUES (@IDMenuTabelas, @IDEMP, N''TiposDocumento'', N''TiposDocumento'', N''tbTiposDocumento'', 2, NULL, 1, 0, 0, 0, 0, 0, 0, 1, 0, getdate(), N''F3M'', NULL, NULL, 0, 0, NULL, N''Descricao'', NULL)
end

SELECT @IDAreaMenuPai = ID FROM [F3MOGeral].[dbo].[tbMenusAreasEmpresa] WHERE Descricao = ''TiposDocumento'' AND IDEmpresa = @IDEMP

if not exists(Select ID From [F3MOGeral].[dbo].[tbMenusAreasEmpresa] Where Descricao = ''DocumentosSeries'' and IDEmpresa = @IDEMP)
begin
INSERT [F3MOGeral].[dbo].[tbMenusAreasEmpresa] ([IDMenuPai], [IDEmpresa], [Descricao], [DescricaoAbreviada], [Tabela], [Ordem], [Icon], [btnContextoConsultar], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoRemover], [btnContextoImprimir], [btnContextoExportar], [btnContextoF4], [Activo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar], [IDPaiAreaEmpresa], [CampoDescricao], [CampoRelacaoPai])
VALUES (@IDMenuTabelas, @IDEMP, N''DocumentosSeries'', N''DocumentosSeries'', N''tbTiposDocumentoSeries'', 3, NULL, 1, 0, 0, 0, 0, 0, 0, 1, 0, getdate(), N''F3M'', NULL, NULL, 0, 0, @IDAreaMenuPai, N''CodigoSerie'', N''IDTiposDocumento'')
end

Select @IDMenuAreasEmpresa  = (Select ID From [F3MOGeral].[dbo].[tbMenusAreasEmpresa] Where Descricao = ''DocumentosSeries'' and IDEmpresa = @IDEMP)

if not exists(select ID FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] WHERE IDPerfis=1 and IDMenusAreasEmpresa= @IDMenuAreasEmpresa and IDLinhaTabela=@IDTipoDocSerie)
begin
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ON 
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ([ID], [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar])
VALUES (@IDPerEmpresa, 1, @IDMenuAreasEmpresa, @IDTipoDocSerie, 1, 1, 1, 1, 0, 0, NULL, 0, 0, GETDATE(), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] OFF 
end

SET @IDPerEmpresa = @IDPerEmpresa +1
if not exists(select ID FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] WHERE IDPerfis=1 and IDMenusAreasEmpresa= @IDMenuAreasEmpresa and IDLinhaTabela=@IDTipoDocSerie1)
begin
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ON 
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ([ID], [IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar])
VALUES (@IDPerEmpresa, 1, @IDMenuAreasEmpresa, @IDTipoDocSerie1, 1, 1, 1, 1, 0, 0, NULL, 0, 0, GETDATE(), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] OFF 
end

DECLARE @IDSistTipoEntMod As BIGINT
DECLARE @IDSistTipoEntMod1 As BIGINT
DECLARE @IDTipoDoc As BIGINT
DECLARE @IDTipoDoc1 As BIGINT
select @IDTipoDoc = ID from tbTiposDocumento WHERE Codigo=''ACCR''
select @IDTipoDoc1 = ID from tbTiposDocumento WHERE Codigo=''ACCP''

select @IDSistTipoEntMod = Md.ID from tbSistemaTiposEntidadeModulos as Md
left join tbSistemaTiposEntidade ent on ent.ID = Md.IDSistemaTiposEntidade
left join tbSistemaModulos Mod1 on Mod1.ID = Md.IDSistemaModulos
WHERE Mod1.Codigo =''004'' and ent.Codigo=''Clt'' and ent.Tipo=''Clientes''

select @IDSistTipoEntMod1 = Md.ID from tbSistemaTiposEntidadeModulos as Md
left join tbSistemaTiposEntidade ent on ent.ID = Md.IDSistemaTiposEntidade
left join tbSistemaModulos Mod1 on Mod1.ID = Md.IDSistemaModulos
WHERE Mod1.Codigo =''004'' and ent.Codigo=''Clt'' and ent.Tipo=''OutrosDevedores''

SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ON
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) 
VALUES (@IDTipoDocEntPerm, @IDTipoDoc, @IDSistTipoEntMod1, 0, 0, GETDATE(), N''F3M'', GETDATE(), N''F3M'', 0, 0)
SET @IDTipoDocEntPerm = @IDTipoDocEntPerm + 1
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc])
VALUES (@IDTipoDocEntPerm, @IDTipoDoc, @IDSistTipoEntMod, 0, 0, GETDATE(), N''F3M'', GETDATE(), N''F3M'', 0, 0)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] OFF

SET @IDTipoDocEntPerm = @IDTipoDocEntPerm + 1
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ON
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) 
VALUES (@IDTipoDocEntPerm, @IDTipoDoc1, @IDSistTipoEntMod1, 0, 0, GETDATE(), N''F3M'', GETDATE(), N''F3M'', 0, 0)
SET @IDTipoDocEntPerm = @IDTipoDocEntPerm + 1
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([ID], [IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc])
VALUES (@IDTipoDocEntPerm, @IDTipoDoc1, @IDSistTipoEntMod, 0, 0, GETDATE(), N''F3M'', GETDATE(), N''F3M'', 0, 0)
SET IDENTITY_INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] OFF
')

--ativar menu
EXEC('update [F3MOGeral]..tbMenus set ativo=1 WHERE Descricao = ''AnalisesDinamicas''')

--aviso de versão 1.28
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.28.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.28.0'', ''A'', ''2020-09-15 00:00'', ''2020-09-21 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.28.0'', ''V'', ''2020-09-21 08:00'', ''2020-09-21 08:00'', ''Funcionalidades da versão'', ''
<li>Análises Dinâmicas (nova opção)</li>
&emsp;- Consentimento por Cliente<br>
&emsp;- Conta Corrente de Cliente<br>
&emsp;- Serviços Não Faturados<br>
&emsp;- Vendas Loja/Grupo<br>
&emsp;- Vendas Resumo
<li>Gestor de Análises</li>
&emsp;- Criação de novas análises<br>
&emsp;- Vistas de impressão
'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')