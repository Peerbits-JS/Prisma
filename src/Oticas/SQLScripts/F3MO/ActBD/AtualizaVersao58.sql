
-- DOCUMENTOS NAO FISCAIS

EXEC('ALTER TABLE tbDocumentosVendas ALTER COLUMN IDEntidade bigint null')


EXEC('
DECLARE @IDSistemaTipoDocumentoFiscal as bigint;
DECLARE @IDSistemaTipoDocumento as bigint;

SELECT @IDSistemaTipoDocumentoFiscal = MAX(ID) + 1 FROM tbSistemaTiposDocumentoFiscal
SELECT @IDSistemaTipoDocumento = ID FROM tbSistemaTiposDocumento WHERE Tipo = ''VndFinanceiro''

INSERT INTO tbSistemaTiposDocumentoFiscal(ID, Tipo, Descricao, IDTipoDocumento, Sistema, Ativo, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao)
VALUES(@IDSistemaTipoDocumentoFiscal, ''NF'', ''NaoFiscal'', @IDSistemaTipoDocumento, 1, 1, getdate(), ''F3M'', NULL, NULL)
')

EXEC('IF NOT EXISTS(SELECT * FROM tbTiposDocumento WHERE Codigo = ''SIR'')
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
	VALUES (N''SIR'', N''Saldo Inicial a Receber'', @IDSistMod, @IDSistTpDoc, 0, 1, getdate(), N''F3M'', NULL, NULL, NULL, @IDTipoFisc, 0, 1, 0, 0, 1, 1, 1, 0, 0, @IDAcaoAvisa, @IDTpLiquidacao, 0, 0, 0, 0, 0, 0, 0, @IDAcaoIgnora, @IDTpDocMovStock, @IDTpDocPrecoUnitario, NULL, NULL, NULL, @IDAcaoIgnora, @IDAcaoIgnora, @IDAcaoIgnora, @IDNatureza, 0, 1, 0, 0)

	DECLARE @IDTipoDocumento as bigint
	DECLARE @IDTpDocOrigem as bigint
	DECLARE @IDTpDocComunicacao as bigint

	SELECT @IDTipoDocumento = ID FROM tbTiposDocumento WHERE Codigo = ''SIR''
	SELECT @IDTpDocOrigem = ID FROM tbSistemaTiposDocumentoOrigem WHERE Codigo = ''001''
	SELECT @IDTpDocComunicacao = ID FROM tbSistemaTiposDocumentoComunicacao WHERE Codigo = ''001''

	INSERT tbTiposDocumentoSeries ([CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) 
	VALUES (''A'', ''A'', 1, @IDTipoDocumento, 0, 1, getdate(), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, @IDTpDocOrigem, @IDTpDocComunicacao, NULL, 1, @IDMapaVista)
END')


EXEC('IF NOT EXISTS(SELECT * FROM tbTiposDocumento WHERE Codigo = ''SIP'')
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
	VALUES (N''SIP'', N''Saldo Inicial a Pagar'', @IDSistMod, @IDSistTpDoc, 0, 1, getdate(), N''F3M'', NULL, NULL, NULL, @IDTipoFisc, 0, 1, 0, 0, 1, 1, 1, 0, 0, @IDAcaoAvisa, @IDTpLiquidacao, 0, 0, 0, 0, 0, 0, 0, @IDAcaoIgnora, @IDTpDocMovStock, @IDTpDocPrecoUnitario, NULL, NULL, NULL, @IDAcaoIgnora, @IDAcaoIgnora, @IDAcaoIgnora, @IDNatureza, 0, 1, 0, 0)

	DECLARE @IDTipoDocumento as bigint
	DECLARE @IDTpDocOrigem as bigint
	DECLARE @IDTpDocComunicacao as bigint

	SELECT @IDTipoDocumento = ID FROM tbTiposDocumento WHERE Codigo = ''SIP''
	SELECT @IDTpDocOrigem = ID FROM tbSistemaTiposDocumentoOrigem WHERE Codigo = ''001''
	SELECT @IDTpDocComunicacao = ID FROM tbSistemaTiposDocumentoComunicacao WHERE Codigo = ''001''

	INSERT tbTiposDocumentoSeries ([CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) 
	VALUES (''A'', ''A'', 1, @IDTipoDocumento, 0, 1, getdate(), N''F3M'', NULL, NULL, 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, @IDTpDocOrigem, @IDTpDocComunicacao, NULL, 1, @IDMapaVista)
END')


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
WHERE  St.Tipo =''VndFinanceiro'' and Tip.Codigo=''SIR''
ORDER BY ser.ID asc

SELECT TOP 1 @IDTipoDocSerie1 =  ser.ID
FROM tbTiposDocumentoSeries AS ser
left join tbTiposDocumento as Tip On tip.ID = ser.IDTiposDocumento
left join tbSistemaTiposDocumento as St On ST.ID = Tip.IDSistemaTiposDocumento
WHERE  St.Tipo =''VndFinanceiro'' and Tip.Codigo=''SIP''
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
select @IDTipoDoc = ID from tbTiposDocumento WHERE Codigo=''SIR''
select @IDTipoDoc1 = ID from tbTiposDocumento WHERE Codigo=''SIP''

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



-- VISTA SERVICOS A5 HORIZONTAL

EXEC('
INSERT INTO tbMapasVistas ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], [PorDefeito])
SELECT (SELECT MAX(ordem) FROM [dbo].[tbMapasVistas] WHERE entidade = ''DocumentosVendasServicos'') + 1 ordem, [Entidade], ''Serviços - Cabeçalho'' Descricao , ''DocumentosVendasServicosCabecalho'' [NomeMapa], '''' [Caminho], [Certificado], [IDLoja], null [SQLQuery], [Listagem], [Ativo], [Sistema], GetDate() [DataCriacao], N''F3M'' [UtilizadorCriacao], NULL [DataAlteracao],
NULL [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], 0 [PorDefeito]
FROM [dbo].[tbMapasVistas] where NomeMapa = ''rptDocumentosVendasServicosA5H''

Declare @IDSubCabecalho As bigint;
SET @IDSubCabecalho = SCOPE_IDENTITY();
DECLARE @ptrvalCabecalho xml;  
SET @ptrvalCabecalho = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosVendasServicosCabecalho" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Microsoft.VisualBasic&#xD;&#xA;&#xD;&#xA;Private Sub fldDesignacaoComercial_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;&#xD;&#xA;    Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;    Dim titulo As String = Me.Parameters(&quot;Titulo&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    Dim strValor As String&#xD;&#xA;&#xD;&#xA;    Me.lblEmitido.Text = resource.GetResource(&quot;EmitidoEm&quot;, culture)&#xD;&#xA;&#xD;&#xA;    Me.fldEmitido.Text = Now.ToShortDateString &amp; &quot; &quot; &amp; Now.ToShortTimeString&#xD;&#xA;    Me.lblTitulo.Text = titulo&#xD;&#xA;&#xD;&#xA;    If Me.Parameters(&quot;DesignacaoComercial&quot;).Value.ToString = &quot;&quot; Then&#xD;&#xA;        strValor = Convert.ToString(GetCurrentColumnValue(&quot;DesignacaoComercial&quot;))&#xD;&#xA;    Else&#xD;&#xA;        strValor = Me.Parameters(&quot;DesignacaoComercial&quot;).Value.ToString&#xD;&#xA;    End If&#xD;&#xA;    &#xD;&#xA;    fldDesignacaoComercial.Text = strValor&#xD;&#xA;End Sub&#xD;&#xA;" SnapGridSize="0.1" Margins="0, 101, 0, 0" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="19.1" DataMember="tbParametrosLoja" DataSource="#Ref-0">
  <Parameters>
    <Item1 Ref="3" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-2" />
    <Item2 Ref="5" Description="Culture" Name="Culture" />
    <Item3 Ref="6" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item4 Ref="7" Description="DesignacaoComercial" Name="DesignacaoComercial" />
    <Item5 Ref="8" Description="Titulo" ValueInfo="Mapa" Name="Titulo" />
    <Item6 Ref="9" Visible="false" Description="Parameter1" Name="Utilizador" />
  </Parameters>
  <Bands>
    <Item1 Ref="10" ControlType="TopMarginBand" Name="TopMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="11" ControlType="ReportHeaderBand" Name="ReportHeaderBand1" HeightF="42">
      <Controls>
        <Item1 Ref="12" ControlType="XRLabel" Name="XrLabel3" TextAlignment="TopRight" SizeF="288.0001,10" LocationFloat="457.9999, 20" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="13" Expression="?Utilizador" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="14" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="15" ControlType="XRLine" Name="XrLine1" LineWidth="2" SizeF="746,6.91" LocationFloat="0, 35.09" />
        <Item3 Ref="16" ControlType="XRLabel" Name="lblEmitido" TextAlignment="TopRight" SizeF="103.54,10" LocationFloat="642.4569, 0" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="17" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="18" ControlType="XRLabel" Name="fldEmitido" TextAlignment="TopRight" SizeF="103.5432,10" LocationFloat="642.46, 10" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="19" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="20" ControlType="XRLabel" Name="lblTitulo" TextAlignment="TopLeft" SizeF="373.1997,20" LocationFloat="0, 15" Font="Arial, 11.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="21" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="22" ControlType="XRLabel" Name="fldDesignacaoComercial" Text="fldDesignacaoComercial" TextAlignment="TopLeft" SizeF="373.1997,15" LocationFloat="0, 0" Font="Arial, 12pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <Scripts Ref="23" OnBeforePrint="fldDesignacaoComercial_BeforePrint" />
          <ExpressionBindings>
            <Item1 Ref="24" Expression="[DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="25" UseFont="false" UseTextAlignment="false" />
        </Item6>
      </Controls>
    </Item2>
    <Item3 Ref="26" ControlType="DetailBand" Name="Detail" Expanded="false" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item4 Ref="27" ControlType="PageFooterBand" Name="PageFooterBand1" HeightF="0.8749962" />
    <Item5 Ref="28" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <StyleSheet>
    <Item1 Ref="29" Name="Title" BorderStyle="Inset" Font="Times New Roman, 20pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item2 Ref="30" Name="FieldCaption" BorderStyle="Inset" Font="Arial, 10pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item3 Ref="31" Name="PageInfo" BorderStyle="Inset" Font="Times New Roman, 10pt, style=Bold" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item4 Ref="32" Name="DataField" BorderStyle="Inset" Padding="2,2,0,0,100" Font="Times New Roman, 10pt" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
  </StyleSheet>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="2" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9cHJpc21hLWxhYi12bS53ZXN0ZXVyb3BlLmNsb3VkYXBwLmF6dXJlLmNvbSwxNDMzO1VzZXIgSUQ9RjNNTztQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID0xMDAwMEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJQYXJhbWV0cm9zTG9qYSI+PFBhcmFtZXRlciBOYW1lPSJJRExvamEiIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKFtQYXJhbWV0ZXJzLklETG9qYV0pPC9QYXJhbWV0ZXI+PFNxbD4NCnNlbGVjdCAidGJQYXJhbWV0cm9zTG9qYSIuIklEIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklETW9lZGFEZWZlaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIk1vcmFkYSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJGb3RvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkZvdG9DYW1pbmhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkRlc2lnbmFjYW9Db21lcmNpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ29kaWdvUG9zdGFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkxvY2FsaWRhZGUiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ29uY2VsaG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRGlzdHJpdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iSURQYWlzIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIlRlbGVmb25lIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkZheCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJFbWFpbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJXZWJTaXRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIk5JRiIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNhcGl0YWxTb2NpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklETG9qYSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRElkaW9tYUJhc2UiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iU2lzdGVtYSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJBdGl2byIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJEYXRhQ3JpYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJVdGlsaXphZG9yQ3JpYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJEYXRhQWx0ZXJhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIlV0aWxpemFkb3JBbHRlcmFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRjNNTWFyY2Fkb3IiLA0KICAgICAgICJ0Yk1vZWRhcyIuIlNpbWJvbG8iLA0KICAgICAgICJ0Yk1vZWRhcyIuIlRheGFDb252ZXJzYW8iLA0KICAgICAgICJ0Yk1vZWRhcyIuIkRlc2NyaWNhb0RlY2ltYWwiLA0KICAgICAgICJ0Yk1vZWRhcyIuIkRlc2NyaWNhb0ludGVpcmEiLA0KICAgICAgICJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNUb3RhaXMiLA0KICAgICAgICJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNJdmEiLA0KICAgICAgICJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiLA0KICAgICAgICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiLlNpZ2xhDQogIGZyb20gImRibyIuInRiUGFyYW1ldHJvc0xvamEiICJ0YlBhcmFtZXRyb3NMb2phIg0KICBsZWZ0IGpvaW4gImRibyIuInRiTW9lZGFzIiAidGJNb2VkYXMiDQogICAgICAgb24gInRiTW9lZGFzIi4iSUQiID0gInRiUGFyYW1ldHJvc0xvamEiLiJJRE1vZWRhRGVmZWl0byINCiAgbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiDQogICAgICAgb24gInRiU2lzdGVtYVNpZ2xhc1BhaXNlcyIuIklEIiA9ICJ0YlBhcmFtZXRyb3NMb2phIi4iSURQYWlzIg0Kd2hlcmUgaWRsb2phPUBJRExvamE8L1NxbD48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQ+PFZpZXcgTmFtZT0idGJQYXJhbWV0cm9zTG9qYSI+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURNb2VkYURlZmVpdG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvQ2FtaW5obyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNpZ25hY2FvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJMb2NhbGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZheCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJXZWJTaXRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik5JRiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhcGl0YWxTb2NpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJJRExvamEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRElkaW9tYUJhc2UiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvciIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJTaW1ib2xvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvRGVjaW1hbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9JbnRlaXJhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNUb3RhaXMiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNJdmEiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IlNpZ2xhIiBUeXBlPSJTdHJpbmciIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''

update tbMapasVistas set SubReport=1, MapaXML = @ptrvalCabecalho where id = @IDSubCabecalho


INSERT INTO tbMapasVistas ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], [PorDefeito])
SELECT (SELECT MAX(ordem) FROM [dbo].[tbMapasVistas] WHERE entidade = ''DocumentosVendasServicos'') + 1 ordem, [Entidade], ''Serviços - Graduações'' Descricao , ''DocumentosVendasServicosGraduacoes'' [NomeMapa], '''' [Caminho], [Certificado], [IDLoja], null [SQLQuery], [Listagem], [Ativo], [Sistema], GetDate() [DataCriacao], N''F3M'' [UtilizadorCriacao], NULL [DataAlteracao],
NULL [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], 0 [PorDefeito]
FROM [dbo].[tbMapasVistas] where NomeMapa = ''rptDocumentosVendasServicosA5H''

Declare @IDSubGraduacoes As bigint;
SET @IDSubGraduacoes = SCOPE_IDENTITY();
DECLARE @ptrvalGraduacoes xml;  
SET @ptrvalGraduacoes = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosVendasServicosGraduacoes" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Microsoft.VisualBasic&#xD;&#xA;&#xD;&#xA;Private Sub DocumentosVendasServicosGraduacoes_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    resource.LoadResources(sender)&#xD;&#xA;&#xD;&#xA;    Dim Culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;    Dim Simbolo As String = Me.Parameters(&quot;Simbolo&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    Dim strvalor As String = String.Empty&#xD;&#xA;    Dim dtData As Date&#xD;&#xA;    Dim NumeroCasasDecimais As Integer = 2&#xD;&#xA;&#xD;&#xA;    Me.lblOlho.Text = resource.GetResource(&quot;Olho&quot;, Culture)&#xD;&#xA;    Me.lblDiametro.Text = resource.GetResource(&quot;Diametro&quot;, Culture)&#xD;&#xA;    Me.lblPotenciaEsferica.Text = resource.GetResource(&quot;PotEsf&quot;, Culture)&#xD;&#xA;    Me.lblPotenciaCilindrica.Text = resource.GetResource(&quot;PotCil&quot;, Culture)&#xD;&#xA;    Me.lblPotenciaPrismatica.Text = resource.GetResource(&quot;Prisma&quot;, Culture)&#xD;&#xA;    Me.lblEixo.Text = resource.GetResource(&quot;Eixo&quot;, Culture)&#xD;&#xA;    Me.lblAdicao.Text = resource.GetResource(&quot;Adicao&quot;, Culture)&#xD;&#xA;    Me.lblCodigoArtigo.Text = resource.GetResource(&quot;Artigo&quot;, Culture)&#xD;&#xA;    Me.lblDistancia.Text = resource.GetResource(&quot;Distancia&quot;, Culture)&#xD;&#xA;&#xD;&#xA;    Me.lblDNP.Text = resource.GetResource(&quot;DNP&quot;, Culture)&#xD;&#xA;    Me.lblAltura.Text = resource.GetResource(&quot;AL&quot;, Culture)&#xD;&#xA;    Me.lblBasePrismatica.Text = resource.GetResource(&quot;BP&quot;, Culture)&#xD;&#xA;    Me.lblAnguloPantoscopico.Text = resource.GetResource(&quot;PAN&quot;, Culture)&#xD;&#xA;    Me.lblDistanciaVertex.Text = resource.GetResource(&quot;VTX&quot;, Culture)&#xD;&#xA;&#xD;&#xA;    Me.lblQuantidade.Text = resource.GetResource(&quot;Qtd&quot;, Culture)&#xD;&#xA;    Me.lblPrecoUnitario.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;Preco&quot;, Culture)&#xD;&#xA;    Me.lblValorDesconto.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoLinha&quot;, Culture)&#xD;&#xA;    Me.lblValorEntidade1.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;ValorEntidade1&quot;, Culture)&#xD;&#xA;    Me.lblValorEntidade2.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;ValorEntidade2&quot;, Culture)&#xD;&#xA;    Me.lblTotal.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;Total&quot;, Culture)&#xD;&#xA;&#xD;&#xA;    ''''cabecalho&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;tbsistematiposservicos_descricao&quot;))&#xD;&#xA;    If strvalor = &quot;Contato&quot; Then&#xD;&#xA;        strvalor = &quot;Lentes de Contato&quot;&#xD;&#xA;    End If&#xD;&#xA;    Me.lblNumeroServico.Text = resource.GetResource(&quot;Servico&quot;, Culture) &amp; &quot; &quot; &amp; strvalor&#xD;&#xA;&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;tbMedicosTecnicos_Nome&quot;))&#xD;&#xA;    Me.lblMedico.Text = resource.GetResource(&quot;Medico&quot;, Culture) &amp; &quot; &quot; &amp; strvalor&#xD;&#xA;&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;DataEntregaLonge&quot;))&#xD;&#xA;    If strvalor &lt;&gt; String.Empty Then&#xD;&#xA;        dtData = GetCurrentColumnValue(&quot;DataEntregaLonge&quot;)&#xD;&#xA;        Me.lblDataEntrega.Text = resource.GetResource(&quot;Entrega&quot;, Culture) &amp; &quot; &quot; &amp; dtData.ToShortDateString &amp; &quot; &quot; &amp; dtData.ToShortTimeString&#xD;&#xA;    End If&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;BoxLonge&quot;))&#xD;&#xA;    If strvalor &lt;&gt; String.Empty Then&#xD;&#xA;        Me.lblBox.Text = &quot;Box &quot; &amp; strvalor&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;IDTipoGraduacao&quot;))&#xD;&#xA;    If strvalor = &quot;3&quot; Then '''' Perto&#xD;&#xA;        strvalor = Convert.ToString(GetCurrentColumnValue(&quot;DataEntregaPerto&quot;))&#xD;&#xA;        If strvalor &lt;&gt; String.Empty Then&#xD;&#xA;            dtData = GetCurrentColumnValue(&quot;DataEntregaPerto&quot;)&#xD;&#xA;            Me.lblDataEntrega.Text = resource.GetResource(&quot;Entrega&quot;, Culture) &amp; &quot; &quot; &amp; dtData.ToShortDateString &amp; &quot; &quot; &amp; dtData.ToShortTimeString&#xD;&#xA;        End If&#xD;&#xA;&#xD;&#xA;        strvalor = Convert.ToString(GetCurrentColumnValue(&quot;BoxPerto&quot;))&#xD;&#xA;        If strvalor &lt;&gt; String.Empty Then&#xD;&#xA;            Me.lblBox.Text = &quot;Box &quot; &amp; strvalor&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;ValorEntidade1&quot;))&#xD;&#xA;    Me.fldValorEntidade1.Text = strvalor&#xD;&#xA;    Me.fldValorEntidade1.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;ValorEntidade2&quot;))&#xD;&#xA;    Me.fldValorEntidade2.Text = strvalor&#xD;&#xA;    Me.fldValorEntidade2.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;End Sub&#xD;&#xA;" SnapGridSize="0.1" Margins="10, 0, 0, 0" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="19.1" DataMember="tbServicosGraduacoes" DataSource="#Ref-0">
  <Parameters>
    <Item1 Ref="3" Visible="false" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item2 Ref="5" Description="IDServico" ValueInfo="28" Name="IDServico" Type="#Ref-4" />
    <Item3 Ref="6" Visible="false" Description="Simbolo" Name="Simbolo" />
    <Item4 Ref="7" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
  </Parameters>
  <Bands>
    <Item1 Ref="8" ControlType="TopMarginBand" Name="TopMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="9" ControlType="ReportHeaderBand" Name="ReportHeaderBand1" HeightF="33.69445">
      <Controls>
        <Item1 Ref="10" ControlType="XRLabel" Name="lblBox" Text="Box" SizeF="133.27,13" LocationFloat="451.13, 2" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="11" UseFont="false" />
        </Item1>
        <Item2 Ref="12" ControlType="XRLabel" Name="lblValorEntidade2" Text="Comp. 2 " TextAlignment="MiddleRight" SizeF="54.44891,12" LocationFloat="634.4026, 19.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="13" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="14" ControlType="XRLabel" Name="lblMedico" Text="Médico Nome Sobrenome" SizeF="276.53,13" LocationFloat="174.6, 2" Font="Arial, 8.25pt, charSet=0" ForeColor="Black" Padding="2,2,0,0,100" Visible="false">
          <StylePriority Ref="15" UseFont="false" UseForeColor="false" />
        </Item3>
        <Item4 Ref="16" ControlType="XRLabel" Name="lblDataEntrega" Text="Entrega 12/12/2012 - 11:20:33" TextAlignment="TopRight" SizeF="160.34,13" LocationFloat="583.66, 2" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="17" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="18" ControlType="XRLabel" Name="lblNumeroServico" Text="Serviço n " SizeF="174.6,13" LocationFloat="0, 2" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="19" UseFont="false" />
        </Item5>
        <Item6 Ref="20" ControlType="XRLine" Name="XrLine1" SizeF="744,2" LocationFloat="0, 31" />
        <Item7 Ref="21" ControlType="XRLabel" Name="lblQuantidade" Text="Qtd." TextAlignment="TopRight" SizeF="34.77689,12" LocationFloat="451.1349, 19.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="22" UseFont="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="23" ControlType="XRLabel" Name="lblPrecoUnitario" Text="Preço" TextAlignment="TopRight" SizeF="55.99139,12" LocationFloat="485.9118, 19.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="24" UseFont="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="25" ControlType="XRLabel" Name="lblValorDesconto" Text="Desc." TextAlignment="TopRight" SizeF="41.76263,12" LocationFloat="541.9032, 19.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="26" UseFont="false" UseTextAlignment="false" />
        </Item9>
        <Item10 Ref="27" ControlType="XRLabel" Name="lblValorEntidade1" Text="Comp. 1" TextAlignment="TopRight" SizeF="50.73682,12" LocationFloat="583.6658, 19.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="28" UseFont="false" UseTextAlignment="false" />
        </Item10>
        <Item11 Ref="29" ControlType="XRLabel" Name="lblTotal" Text="Total" TextAlignment="TopRight" SizeF="55.14838,12" LocationFloat="688.8516, 19.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="30" UseFont="false" UseTextAlignment="false" />
        </Item11>
        <Item12 Ref="31" ControlType="XRLabel" Name="lblCodigoArtigo" Text="Artigo" TextAlignment="TopLeft" SizeF="73.09,13" LocationFloat="0, 18" Font="Arial, 6.75pt, style=Bold, charSet=0" BackColor="Transparent" Padding="2,2,0,0,100">
          <StylePriority Ref="32" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item12>
      </Controls>
    </Item2>
    <Item3 Ref="33" ControlType="GroupHeaderBand" Name="GroupHeader1" HeightF="12.26795" KeepTogether="true">
      <GroupFields>
        <Item1 Ref="34" FieldName="Ordem_1" />
        <Item2 Ref="35" FieldName="IDTipoOlho_1" />
      </GroupFields>
      <Controls>
        <Item1 Ref="36" ControlType="XRLabel" Name="lblDistanciaVertex" ProcessDuplicatesMode="Suppress" TextAlignment="TopCenter" SizeF="37.29697,12" LocationFloat="504.3424, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="37" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="38" ControlType="XRLabel" Name="lblAnguloPantoscopico" ProcessDuplicatesMode="Suppress" TextAlignment="TopCenter" SizeF="37.29697,12" LocationFloat="467.0454, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="39" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="40" ControlType="XRLabel" Name="lblBasePrismatica" ProcessDuplicatesMode="Suppress" TextAlignment="TopCenter" SizeF="37.29697,12" LocationFloat="429.7483, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="41" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="42" ControlType="XRLabel" Name="lblPotenciaPrismatica" ProcessDuplicatesMode="Suppress" TextAlignment="TopCenter" SizeF="37.29697,12" LocationFloat="392.4515, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="43" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="44" ControlType="XRLabel" Name="lblAltura" ProcessDuplicatesMode="Suppress" TextAlignment="TopCenter" SizeF="38.79001,12" LocationFloat="353.6615, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="45" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="46" ControlType="XRLabel" Name="lblDNP" ProcessDuplicatesMode="Suppress" TextAlignment="TopCenter" SizeF="41.79001,12" LocationFloat="311.8715, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="47" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="48" ControlType="XRLabel" Name="lblDiametro" Multiline="true" ProcessDuplicatesMode="Suppress" Text="&#xD;&#xA;" TextAlignment="TopCenter" SizeF="39,12" LocationFloat="73.97675, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="49" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="50" ControlType="XRLabel" Name="lblPotenciaEsferica" ProcessDuplicatesMode="Suppress" TextAlignment="TopCenter" SizeF="48.10474,12" LocationFloat="112.9767, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="51" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="52" ControlType="XRLabel" Name="lblPotenciaCilindrica" ProcessDuplicatesMode="Suppress" TextAlignment="TopCenter" SizeF="50.79,12" LocationFloat="161.0814, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="53" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item9>
        <Item10 Ref="54" ControlType="XRLabel" Name="lblOlho" Multiline="true" ProcessDuplicatesMode="Suppress" Text="Olho" TextAlignment="TopCenter" SizeF="26.36,12" LocationFloat="47.61, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="55" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item10>
        <Item11 Ref="56" ControlType="XRLabel" Name="lblEixo" ProcessDuplicatesMode="Suppress" TextAlignment="TopCenter" SizeF="46.21,12" LocationFloat="211.8714, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="57" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item11>
        <Item12 Ref="58" ControlType="XRLabel" Name="lblAdicao" ProcessDuplicatesMode="Suppress" TextAlignment="TopCenter" SizeF="53.79,12" LocationFloat="258.0815, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="59" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="60" ControlType="XRLabel" Name="lblDistancia" Multiline="true" ProcessDuplicatesMode="Suppress" Text="Distância" TextAlignment="TopCenter" SizeF="47.79,12" LocationFloat="0, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
          <StylePriority Ref="61" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
        </Item13>
      </Controls>
    </Item3>
    <Item4 Ref="62" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100">
      <SubBands>
        <Item1 Ref="63" ControlType="SubBand" Name="SubBand1" HeightF="12">
          <Controls>
            <Item1 Ref="64" ControlType="XRLabel" Name="XrLabel3" TextFormatString="{0:0.00}" TextAlignment="MiddleCenter" SizeF="37.3,12" LocationFloat="504.34, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="65" Expression="[DistanciaVertex]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="66" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="67" ControlType="XRLabel" Name="XrLabel1" TextFormatString="{0:0.00}" TextAlignment="MiddleCenter" SizeF="37.3,12" LocationFloat="467.05, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="68" Expression="[AnguloPantoscopico]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="69" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="70" ControlType="XRLabel" Name="fldBasePrismatica" TextFormatString="{0:0.00}" TextAlignment="MiddleCenter" SizeF="37.3,12" LocationFloat="429.75, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="71" Expression="[BasePrismatica]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="72" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="73" ControlType="XRLabel" Name="fldAltura" TextFormatString="{0:0.00}" TextAlignment="MiddleCenter" SizeF="38.79,12" LocationFloat="353.66, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="74" Expression="[Altura]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="75" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="76" ControlType="XRLabel" Name="fldDNP" TextFormatString="{0:0.00}" TextAlignment="MiddleCenter" SizeF="41.79,12" LocationFloat="311.87, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="77" Expression="[DNP]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="78" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="79" ControlType="XRLabel" Name="XrLabel2" Text="XrLabel2" TextAlignment="MiddleCenter" SizeF="26.36,12" LocationFloat="47.61, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="80" Expression="[Olho]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="81" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="82" ControlType="XRLabel" Name="fldDiametro" TextFormatString="{0:0.00}" TextAlignment="MiddleCenter" SizeF="39,12" LocationFloat="73.98, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="83" Expression="[Diametro]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="84" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="85" ControlType="XRLabel" Name="fldPotenciaEsferica" TextFormatString="{0:+#,##0.00;-#,##0.00;0.00}" TextAlignment="MiddleCenter" SizeF="48.1,12" LocationFloat="112.98, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="86" Expression="[PotenciaEsferica]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="87" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="88" ControlType="XRLabel" Name="fldPotenciaCilindrica" TextFormatString="{0:+#,##0.00;-#,##0.00;0.00}" TextAlignment="MiddleCenter" SizeF="50.79,12" LocationFloat="161.08, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="89" Expression="[PotenciaCilindrica]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="90" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="91" ControlType="XRLabel" Name="fldEixo" TextFormatString="{0:0.00}" TextAlignment="MiddleCenter" SizeF="46.21,12" LocationFloat="211.87, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="92" Expression="[Eixo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="93" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="94" ControlType="XRLabel" Name="fldAdicao" TextFormatString="{0:+#,##0.00;-#,##0.00;0.00}" TextAlignment="MiddleCenter" SizeF="53.79,12" LocationFloat="258.08, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="95" Expression="[Adicao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="96" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item11>
            <Item12 Ref="97" ControlType="XRLabel" Name="fldDistancia" CanGrow="false" Text="fldDistancia" TextAlignment="MiddleCenter" SizeF="47.79,12" LocationFloat="0, 0" Font="Arial, 6.75pt, charSet=0" ForeColor="Black" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="98" Expression="[Graduacao]" PropertyName="Text" EventName="BeforePrint" />
                <Item2 Ref="99" Expression="Iif([IDTipoServico] = 6, False, ?)" PropertyName="Visible" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="100" UseFont="false" UseForeColor="false" UseBackColor="false" UseTextAlignment="false" />
            </Item12>
            <Item13 Ref="101" ControlType="XRLabel" Name="fldPotenciaPrismatica" TextFormatString="{0:+#,##0.00;-#,##0.00;0.00}" TextAlignment="MiddleCenter" SizeF="37.3,12" LocationFloat="392.45, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="102" Expression="[PotenciaPrismatica]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="103" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item13>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="104" Expression="Iif([Diametro] = null Or [Diametro] = ''''0'''', True, ?)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item1>
      </SubBands>
    </Item4>
    <Item5 Ref="105" ControlType="GroupFooterBand" Name="GroupFooter1" HeightF="23.18052" KeepTogether="true">
      <Controls>
        <Item1 Ref="106" ControlType="XRLabel" Name="fldValorEntidade2" TextFormatString="{0:0.00}" TextAlignment="MiddleRight" SizeF="54.45,17" LocationFloat="634.4, 3.92" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="107" Expression="[ValorEntidade2]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="108" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="109" ControlType="XRLabel" Name="fldValorDesconto" TextFormatString="{0:0.00}" TextAlignment="MiddleRight" SizeF="41.76,17" LocationFloat="541.9, 3.71" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="110" Expression="[ValorDescontoLinha]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="111" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="112" ControlType="XRLabel" Name="fldQuantidade" Text="fldQuantidade" TextAlignment="MiddleRight" SizeF="34.78,17" LocationFloat="451.13, 3.71" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="113" Expression="[Quantidade]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="114" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="115" ControlType="XRLabel" Name="fldPrecoUnitario" TextFormatString="{0:0.00}" TextAlignment="MiddleRight" SizeF="55.99,17" LocationFloat="485.91, 3.71" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="116" Expression="[PrecoUnitario]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="117" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="118" ControlType="XRLabel" Name="fldValorEntidade1" TextFormatString="{0:0.00}" TextAlignment="MiddleRight" SizeF="50.74,17" LocationFloat="583.66, 3.71" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="119" Expression="[ValorEntidade1]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="120" UseFont="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="121" ControlType="XRLabel" Name="fldCodigo" Text="fldCodigo" TextAlignment="MiddleLeft" SizeF="73.09,17" LocationFloat="0, 3.92" Font="Arial, 6.75pt, charSet=0" ForeColor="Black" BackColor="Transparent" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="122" Expression="[Codigo]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="123" UseFont="false" UseForeColor="false" UseBackColor="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="124" ControlType="XRLabel" Name="fldTotal" TextFormatString="{0:0.00}" TextAlignment="MiddleRight" SizeF="55.15,17" LocationFloat="688.85, 3.71" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="125" Expression="[TotalFinal]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="126" UseFont="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="127" ControlType="XRLabel" Name="fldDescricaoArtigo" Text="fldDescricaoArtigo" TextAlignment="MiddleLeft" SizeF="393.96,17" LocationFloat="73.09, 3.92" Font="Arial, 6.75pt, charSet=0" ForeColor="Black" BackColor="Transparent" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="128" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="129" UseFont="false" UseForeColor="false" UseBackColor="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="130" ControlType="XRLine" Name="XrLine3" LineStyle="Dot" SizeF="744,2" LocationFloat="0, 20.92" BorderDashStyle="Solid">
          <StylePriority Ref="131" UseBorderDashStyle="false" />
        </Item9>
      </Controls>
    </Item5>
    <Item6 Ref="132" ControlType="PageFooterBand" Name="PageFooterBand1" Expanded="false" HeightF="0" />
    <Item7 Ref="133" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="134" OnBeforePrint="DocumentosVendasServicosGraduacoes_BeforePrint" />
  <StyleSheet>
    <Item1 Ref="135" Name="Title" BorderStyle="Inset" Font="Times New Roman, 20pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item2 Ref="136" Name="FieldCaption" BorderStyle="Inset" Font="Arial, 10pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item3 Ref="137" Name="PageInfo" BorderStyle="Inset" Font="Times New Roman, 10pt, style=Bold" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item4 Ref="138" Name="DataField" BorderStyle="Inset" Padding="2,2,0,0,100" Font="Times New Roman, 10pt" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
  </StyleSheet>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="4" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9cHJpc21hLWxhYi12bS53ZXN0ZXVyb3BlLmNsb3VkYXBwLmF6dXJlLmNvbSwxNDMzO1VzZXIgSUQ9RjNNTztQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID0xMDAwMEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJTZXJ2aWNvc0dyYWR1YWNvZXMiPjxQYXJhbWV0ZXIgTmFtZT0iSURTZXJ2aWNvIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5JbnQ2NCwgbXNjb3JsaWIsIFZlcnNpb249NC4wLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5KShbUGFyYW1ldGVycy5JRFNlcnZpY29dKTwvUGFyYW1ldGVyPjxTcWw+c2VsZWN0IGRpc3RpbmN0IHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc0dyYWR1YWNvZXMuKiwgIHRic2Vydmljb3MuKiwgdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzLiosIHRiYXJ0aWdvcy4qLCB0YlNlcnZpY29zLklEVGlwb1NlcnZpY28sIHRiU2lzdGVtYVRpcG9zT2xob3MuY29kaWdvIGFzIE9saG8sIHRiU2lzdGVtYVRpcG9zR3JhZHVhY29lcy5EZXNjcmljYW8gYXMgR3JhZHVhY2FvLA0KdGJtZWRpY29zdGVjbmljb3Mubm9tZSBhcyB0Yk1lZGljb3NUZWNuaWNvc19Ob21lLCB0YnNlcnZpY29zLmlkIGFzIHRiU2Vydmljb3NfSUQsIHRic2lzdGVtYXRpcG9zc2Vydmljb3MuZGVzY3JpY2FvIGFzIHRic2lzdGVtYXRpcG9zc2Vydmljb3NfZGVzY3JpY2FvDQpmcm9tIHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyANCmxlZnQgam9pbiB0YnNlcnZpY29zIG9uIHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcy5JRFNlcnZpY289dGJzZXJ2aWNvcy5JRCANCmxlZnQgam9pbiB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNHcmFkdWFjb2VzIG9uIHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcy5JRFNlcnZpY289dGJEb2N1bWVudG9zVmVuZGFzTGluaGFzR3JhZHVhY29lcy5JRFNlcnZpY28gDQphbmQgICh0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMuSURUaXBvR3JhZHVhY2FvPXRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc0dyYWR1YWNvZXMuSURUaXBvR3JhZHVhY2FvIG9yICh0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNHcmFkdWFjb2VzLklEVGlwb0dyYWR1YWNhbz0zIGFuZCB0YnNlcnZpY29zLklEVGlwb1NlcnZpY28mbHQ7Jmd0OzIgYW5kIHRic2Vydmljb3MuSURUaXBvU2VydmljbyZsdDsmZ3Q7NikpDQphbmQgIHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcy5pZHRpcG9vbGhvPXRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc0dyYWR1YWNvZXMuaWR0aXBvb2xobw0KbGVmdCBqb2luIHRiU2lzdGVtYVRpcG9zT2xob3Mgb24gdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzR3JhZHVhY29lcy5JRFRpcG9PbGhvPXRiU2lzdGVtYVRpcG9zT2xob3MuSUQgDQpsZWZ0IGpvaW4gdGJTaXN0ZW1hVGlwb3NHcmFkdWFjb2VzIG9uIHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc0dyYWR1YWNvZXMuSURUaXBvR3JhZHVhY2FvPXRiU2lzdGVtYVRpcG9zR3JhZHVhY29lcy5JRCANCmxlZnQgam9pbiB0YmFydGlnb3Mgb24gdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzLklEQXJ0aWdvPXRiYXJ0aWdvcy5JRCANCmxlZnQgam9pbiB0Ym1lZGljb3N0ZWNuaWNvcyBvbiB0YlNlcnZpY29zLklEbWVkaWNvdGVjbmljbz10Ym1lZGljb3N0ZWNuaWNvcy5JRCANCmxlZnQgam9pbiB0YnNpc3RlbWF0aXBvc3NlcnZpY29zIG9uIHRic2Vydmljb3MuSUR0aXBvU2Vydmljbz10YnNpc3RlbWF0aXBvc3NlcnZpY29zLklEIA0Kd2hlcmUgdGJTZXJ2aWNvcy5JRD1ASURTZXJ2aWNvPC9TcWw+PC9RdWVyeT48UmVzdWx0U2NoZW1hPjxEYXRhU2V0PjxWaWV3IE5hbWU9InRiU2Vydmljb3NHcmFkdWFjb2VzIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9PbGhvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvR3JhZHVhY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUG90ZW5jaWFFc2ZlcmljYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQb3RlbmNpYUNpbGluZHJpY2EiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUG90ZW5jaWFQcmlzbWF0aWNhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkJhc2VQcmlzbWF0aWNhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkFkaWNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJFaXhvIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iUmFpb0N1cnZhdHVyYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXRhbGhlUmFpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJETlAiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iQWx0dXJhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkFjdWlkYWRlVmlzdWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkFuZ3Vsb1BhbnRvc2NvcGljbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0YW5jaWFWZXJ0ZXgiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iSURTZXJ2aWNvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik9yZGVtIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iSURUaXBvU2VydmljbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETWVkaWNvVGVjbmljbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRhdGFSZWNlaXRhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YUVudHJlZ2FMb25nZSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkRhdGFFbnRyZWdhUGVydG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJWZXJQcmlzbWFzIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJWaXNhb0ludGVybWVkaWEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IlNpc3RlbWFfMSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm9fMSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW9fMSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JDcmlhY2FvXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhb18xIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhb18xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkYzTU1hcmNhZG9yXzEiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iSURUaXBvU2Vydmljb09saG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb21iaW5hY2FvRGVmZWl0byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQm94TG9uZ2UiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQm94UGVydG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSUREb2N1bWVudG9WZW5kYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEXzIiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERvY3VtZW50b1ZlbmRhXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENhbXBhbmhhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURBcnRpZ28iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURVbmlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtQ2FzYXNEZWNVbmlkYWRlIiBUeXBlPSJJbnQxNiIgLz48RmllbGQgTmFtZT0iUXVhbnRpZGFkZSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlByZWNvVW5pdGFyaW9FZmV0aXZvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlByZWNvVG90YWwiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iT2JzZXJ2YWNvZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb3RlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvTG90ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9Mb3RlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFGYWJyaWNvTG90ZSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkRhdGFWYWxpZGFkZUxvdGUiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJJREFydGlnb051bVNlcmllIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQXJ0aWdvTnVtU2VyaWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURBcm1hemVtIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURBcm1hemVtTG9jYWxpemFjYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1EZXN0aW5vIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURBcm1hemVtTG9jYWxpemFjYW9EZXN0aW5vIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtTGluaGFzRGltZW5zb2VzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRGVzY29udG8xIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRlc2NvbnRvMiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFRheGFJdmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUYXhhSXZhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9JdmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmFsb3JJbXBvc3RvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRXNwYWNvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUmVnaW1lSXZhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUmVnaW1lSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJPcmRlbV8xIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iU2lzdGVtYV8yIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2b18yIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ3JpYWNhb18yIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW9fMiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvXzIiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvXzIiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3JfMiIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJEaWFtZXRybyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJWYWxvckRlc2NvbnRvTGluaGEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxDb21EZXNjb250b0xpbmhhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRGVzY29udG9DYWJlY2FsaG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxDb21EZXNjb250b0NhYmVjYWxobyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvclVuaXRhcmlvRW50aWRhZGUxIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yVW5pdGFyaW9FbnRpZGFkZTIiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JFbnRpZGFkZTEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JFbnRpZGFkZTIiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxGaW5hbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFNlcnZpY29fMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb1NlcnZpY29fMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb09saG9fMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRpcG9EaXN0YW5jaWEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwb09saG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURUaXBvR3JhZHVhY2FvXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJWYWxvckluY2lkZW5jaWEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JJVkEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGF4YUl2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9JdmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Eb2N1bWVudG9PcmlnZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERvY3VtZW50b09yaWdlbSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETGluaGFEb2N1bWVudG9PcmlnZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Nb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRvY3VtZW50b09yaWdlbSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUaXBvVGF4YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BcnRpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvQmFycmFzQXJ0aWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1VuaWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb0l2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29SZWdpYW9JdmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iUGVyY0luY2lkZW5jaWEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUGVyY0RlZHVjYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JJdmFEZWR1dGl2ZWwiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRGF0YURvY09yaWdlbSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IklEQWRpYW50YW1lbnRvT3JpZ2VtIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpb0VmZXRpdm9TZW1JdmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JEZXNjb250b0VmZXRpdm9TZW1JdmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURVbmlkYWRlU3RvY2siIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFVuaWRhZGVTdG9jazIiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJRdWFudGlkYWRlU3RvY2siIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXVhbnRpZGFkZVN0b2NrMiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvTW9lZGFSZWYiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpb0VmZXRpdm9Nb2VkYVJlZiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9ja0FudGVyaW9yIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlF0ZFN0b2NrQXR1YWwiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVVBDTW9lZGFSZWYiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUENNQW50ZXJpb3JNb2VkYVJlZiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQQ01BdHVhbE1vZWRhUmVmIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlBWTW9lZGFSZWYiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iQWx0ZXJhZGEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IlZhbG9yaXpvdU9yaWdlbSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iTW92U3RvY2tPcmlnZW0iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9Ik51bUNhc2FzRGVjVW5pZGFkZVN0ayIgVHlwZT0iSW50MTYiIC8+PEZpZWxkIE5hbWU9Ik51bUNhc2FzRGVjMlVuaWRhZGVTdGsiIFR5cGU9IkludDE2IiAvPjxGaWVsZCBOYW1lPSJGYXRvckNvbnZVbmlkU3RrIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkZhdG9yQ29udjJVbmlkU3RrIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlF0ZFN0b2NrQW50ZXJpb3JPcmlnZW0iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2tBdHVhbE9yaWdlbSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQQ01BbnRlcmlvck1vZWRhUmVmT3JpZ2VtIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlF0ZEFmZXRhY2FvU3RvY2siIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkQWZldGFjYW9TdG9jazIiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iT3BlcmFjYW9Db252VW5pZFN0ayIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJPcGVyYWNhb0NvbnYyVW5pZFN0ayIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9QcmVjbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1RpcG9QcmVjbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb0l2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlVQQ29tcHJhTW9lZGFSZWYiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVWx0Q3VzdG9zQWRpY2lvbmFpc01vZWRhUmVmIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlVsdERlc2NDb21lcmNpYWlzTW9lZGFSZWYiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpb0VmZXRpdm9Nb2VkYVJlZk9yaWdlbSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWb3Nzb051bWVyb0RvY3VtZW50b09yaWdlbSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9Eb2N1bWVudG9PcmlnZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzT3JpZ2VtIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUXVhbnRpZGFkZVNhdGlzZmVpdGEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXVhbnRpZGFkZURldm9sdmlkYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTYXRpc2ZlaXRvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJJREFydGlnb1BhcmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Eb2N1bWVudG9PcmlnZW1JbmljaWFsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREb2N1bWVudG9PcmlnZW1JbmljaWFsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURMaW5oYURvY3VtZW50b09yaWdlbUluaWNpYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEb2N1bWVudG9PcmlnZW1JbmljaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklETGluaGFEb2N1bWVudG9Db21wcmFJbmljaWFsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURMaW5oYURvY3VtZW50b1N0b2NrSW5pY2lhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklET0ZBcnRpZ28iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9ja1NhdGlzZmVpdGEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2tEZXZvbHZpZGEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2tBY2VydG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2syU2F0aXNmZWl0YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9jazJEZXZvbHZpZGEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2syQWNlcnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvUEEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9ja1Jlc2VydmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2tSZXNlcnZhMlVuaSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEYXRhRW50cmVnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IklEXzMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQXRpdm9fMyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iSURGYW1pbGlhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURTdWJGYW1pbGlhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvQXJ0aWdvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb21wb3NpY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvQ29tcG9zaWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklER3J1cG9BcnRpZ28iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRE1hcmNhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQmFycmFzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlFSQ29kZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9BYnJldmlhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iT2JzZXJ2YWNvZXNfMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJHZXJlTG90ZXMiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkdlcmVTdG9jayIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iR2VyZU51bWVyb1NlcmllIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9WYXJpYXZlbCIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iSURUaXBvRGltZW5zYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpbWVuc2FvUHJpbWVpcmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpbWVuc2FvU2VndW5kYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklET3JkZW1Mb3RlQXByZXNlbnRhciIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVW5pZGFkZV8xIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURVbmlkYWRlVmVuZGEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFVuaWRhZGVDb21wcmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJWYXJpYXZlbENvbnRhYmlsaWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lzdGVtYV8zIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ3JpYWNhb18zIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW9fMyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvXzMiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvXzMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3JfMyIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJJREVzdGFjYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJORSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEVEVYIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0VzdGF0aXN0aWNvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkxpbWl0ZU1heCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJMaW1pdGVNaW4iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUmVwb3NpY2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklET3JkZW1Mb3RlTW92RW50cmFkYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklET3JkZW1Mb3RlTW92U2FpZGEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRheGEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEZWR1dGl2ZWxQZXJjZW50YWdlbSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJbmNpZGVuY2lhUGVyY2VudGFnZW0iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVWx0aW1vUHJlY29DdXN0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJNZWRpbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQYWRyYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVWx0aW1vc0N1c3Rvc0FkaWNpb25haXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVWx0aW1vc0Rlc2NvbnRvc0NvbWVyY2lhaXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVWx0aW1vUHJlY29Db21wcmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxRdWFudGlkYWRlVlNVUEMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxRdWFudGlkYWRlVlNQQ00iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxRdWFudGlkYWRlVlNQQ1BhZHJhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9zQ29tcG9uZW50ZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29tcG9zdG9UcmFuc2Zvcm1hY2FvTWV0b2RvQ3VzdG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREltcG9zdG9TZWxvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRmF0b3JGVE9GUGVyY2VudGFnZW0iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRm90byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvQ2FtaW5obyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFVuaWRhZGVTdG9jazJfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb1ByZWNvXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BVCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJSZWZlcmVuY2lhRm9ybmVjZWRvciIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29CYXJyYXNGb3JuZWNlZG9yIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEU2lzdGVtYUNsYXNzaWZpY2FjYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Eb2N1bWVudG9VUEMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERvY3VtZW50b1VQQyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRhdGFDb250cm9sb1VQQyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlJlY2FsY3VsYVVQQyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iVG9yY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSW52ZW50YXJpYWRvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9QZXNvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUGVzb0tnIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZvbHVtZSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9TZXJ2aWNvXzIiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJPbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkdyYWR1YWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1lZGljb3NUZWNuaWNvc19Ob21lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2Vydmljb3NfSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJ0YnNpc3RlbWF0aXBvc3NlcnZpY29zX2Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''

update tbMapasVistas set SubReport=1, MapaXML = @ptrvalGraduacoes where id = @IDSubGraduacoes


INSERT INTO tbMapasVistas ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], [PorDefeito])
SELECT (SELECT MAX(ordem) FROM [dbo].[tbMapasVistas] WHERE entidade = ''DocumentosVendasServicos'') + 1 ordem, [Entidade], ''Serviços - Diversos'' Descricao , ''DocumentosVendasServicosDiversos'' [NomeMapa], '''' [Caminho], [Certificado], [IDLoja], null [SQLQuery], [Listagem], [Ativo], [Sistema], GetDate() [DataCriacao], N''F3M'' [UtilizadorCriacao], NULL [DataAlteracao],
NULL [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], 0 [PorDefeito]
FROM [dbo].[tbMapasVistas] where NomeMapa = ''rptDocumentosVendasServicosA5H''

Declare @IDSubDiversos As bigint;
SET @IDSubDiversos = SCOPE_IDENTITY();
DECLARE @ptrvalDiversos xml;  
SET @ptrvalDiversos = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosVendasServicosDiversos" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Microsoft.VisualBasic&#xD;&#xA;&#xD;&#xA;Private Sub DocumentosVendasServicosDiversos_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    resource.LoadResources(sender)&#xD;&#xA;&#xD;&#xA;    Dim Culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;    Dim Simbolo As String = Me.Parameters(&quot;Simbolo&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    Dim strvalor As String = String.Empty&#xD;&#xA;    Dim NumeroCasasDecimais As Integer = 2&#xD;&#xA;&#xD;&#xA;    Me.lblQuantidade.Text = resource.GetResource(&quot;Qtd&quot;, Culture)&#xD;&#xA;    Me.lblPrecoUnitario.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;Preco&quot;, Culture)&#xD;&#xA;    Me.lblValorDesconto.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoLinha&quot;, Culture)&#xD;&#xA;    Me.lblValorEntidade1.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;ValorEntidade1&quot;, Culture)&#xD;&#xA;    Me.lblValorEntidade2.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;ValorEntidade2&quot;, Culture)&#xD;&#xA;    Me.lblTotal.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;Total&quot;, Culture)&#xD;&#xA;&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;ValorEntidade1&quot;))&#xD;&#xA;    Me.fldValorEntidade1.Text = strvalor&#xD;&#xA;    Me.fldValorEntidade1.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;ValorEntidade2&quot;))&#xD;&#xA;    Me.fldValorEntidade2.Text = strvalor&#xD;&#xA;    Me.fldValorEntidade2.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;End Sub&#xD;&#xA;" SnapGridSize="0.1" Margins="10, 0, 0, 0" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="19.1" DataMember="tbServicosGraduacoes" DataSource="#Ref-0">
  <Parameters>
    <Item1 Ref="3" Visible="false" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item2 Ref="5" Description="IDDocumentoVenda" ValueInfo="28" Name="IDDocumentoVenda" Type="#Ref-4" />
    <Item3 Ref="6" Visible="false" Description="Simbolo" Name="Simbolo" />
    <Item4 Ref="7" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
  </Parameters>
  <Bands>
    <Item1 Ref="8" ControlType="TopMarginBand" Name="TopMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="9" ControlType="ReportHeaderBand" Name="ReportHeaderBand1" HeightF="0">
      <SubBands>
        <Item1 Ref="10" ControlType="SubBand" Name="SubBand4" HeightF="19.42">
          <Controls>
            <Item1 Ref="11" ControlType="XRLabel" Name="lblValorEntidade2" Text="Comp. 2 " TextAlignment="MiddleRight" SizeF="54.44891,12" LocationFloat="634.4026, 4.999998" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="12" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="13" ControlType="XRLabel" Name="lblQuantidade" Text="Qtd." TextAlignment="TopRight" SizeF="34.77689,12" LocationFloat="451.1349, 4.999998" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="14" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="15" ControlType="XRLabel" Name="lblPrecoUnitario" Text="Preço" TextAlignment="TopRight" SizeF="55.99139,12" LocationFloat="485.912, 4.999998" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="16" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="17" ControlType="XRLabel" Name="lblValorDesconto" Text="Desc." TextAlignment="TopRight" SizeF="41.76263,12" LocationFloat="541.9033, 4.999998" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="18" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="19" ControlType="XRLabel" Name="lblTotal" Text="Total" TextAlignment="TopRight" SizeF="55.14838,12" LocationFloat="688.8516, 4.999998" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="20" UseFont="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="21" ControlType="XRLabel" Name="lblValorEntidade1" Text="Comp. 1" TextAlignment="TopRight" SizeF="50.73682,12" LocationFloat="583.6656, 4.999998" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="22" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="23" ControlType="XRLine" Name="XrLine1" SizeF="744,2" LocationFloat="0, 17.41667" />
            <Item8 Ref="24" ControlType="XRLabel" Name="lblDiversos" Text="Diversos" TextAlignment="TopLeft" SizeF="73.08937,13" LocationFloat="0, 4" Font="Arial, 6.75pt, style=Bold, charSet=0" BackColor="Transparent" Padding="2,2,0,0,100">
              <StylePriority Ref="25" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item8>
          </Controls>
        </Item1>
      </SubBands>
    </Item2>
    <Item3 Ref="26" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100">
      <SubBands>
        <Item1 Ref="27" ControlType="SubBand" Name="SubBand2" HeightF="19.21">
          <Controls>
            <Item1 Ref="28" ControlType="XRLabel" Name="fldValorEntidade2" TextFormatString="{0:0.00}" TextAlignment="MiddleRight" SizeF="54.44897,17.00001" LocationFloat="634.4011, 0.2083482" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="29" Expression="[ValorEntidade2]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="30" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="31" ControlType="XRLabel" Name="fldValorDesconto" TextFormatString="{0:0.00}" TextAlignment="MiddleRight" SizeF="41.76,17" LocationFloat="541.9016, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="32" Expression="[ValorDescontoLinha]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="33" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="34" ControlType="XRLabel" Name="fldQuantidade" Text="fldQuantidade" TextAlignment="MiddleRight" SizeF="34.78,17" LocationFloat="451.1333, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="35" Expression="[Quantidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="36" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="37" ControlType="XRLabel" Name="fldPrecoUnitario" TextFormatString="{0:0.00}" TextAlignment="MiddleRight" SizeF="55.98691,17" LocationFloat="485.9132, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="38" Expression="[PrecoUnitario]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="39" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="40" ControlType="XRLabel" Name="fldValorEntidade1" TextFormatString="{0:0.00}" TextAlignment="MiddleRight" SizeF="50.73682,17" LocationFloat="583.6642, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="41" Expression="[ValorEntidade1]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="42" UseFont="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="43" ControlType="XRLine" Name="XrLine3" LineStyle="Dot" SizeF="744,2" LocationFloat="0, 17.20836" BorderDashStyle="Solid">
              <StylePriority Ref="44" UseBorderDashStyle="false" />
            </Item6>
            <Item7 Ref="45" ControlType="XRLabel" Name="fldTotal" TextFormatString="{0:0.00}" TextAlignment="MiddleRight" SizeF="55.15,17" LocationFloat="688.85, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="46" Expression="[TotalFinal]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="47" UseFont="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="48" ControlType="XRLabel" Name="fldDescricaoArtigo" Text="fldDescricaoArtigo" TextAlignment="MiddleLeft" SizeF="374.0407,17" LocationFloat="73.08936, 0.2083482" Font="Arial, 6.75pt, charSet=0" BackColor="Transparent" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="49" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="50" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="51" ControlType="XRLabel" Name="fldCodigo" TextAlignment="MiddleLeft" SizeF="73.08936,17.00001" LocationFloat="0, 0.2083482" Font="Arial, 6.75pt, charSet=0" BackColor="Transparent" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="52" Expression="[Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="53" UseFont="false" UseBackColor="false" UseTextAlignment="false" />
            </Item9>
          </Controls>
        </Item1>
      </SubBands>
    </Item3>
    <Item4 Ref="54" ControlType="PageFooterBand" Name="PageFooterBand1" Expanded="false" HeightF="0" />
    <Item5 Ref="55" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="56" OnBeforePrint="DocumentosVendasServicosDiversos_BeforePrint" />
  <StyleSheet>
    <Item1 Ref="57" Name="Title" BorderStyle="Inset" Font="Times New Roman, 20pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item2 Ref="58" Name="FieldCaption" BorderStyle="Inset" Font="Arial, 10pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item3 Ref="59" Name="PageInfo" BorderStyle="Inset" Font="Times New Roman, 10pt, style=Bold" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item4 Ref="60" Name="DataField" BorderStyle="Inset" Padding="2,2,0,0,100" Font="Times New Roman, 10pt" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
  </StyleSheet>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="4" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9cHJpc21hLWxhYi12bS53ZXN0ZXVyb3BlLmNsb3VkYXBwLmF6dXJlLmNvbSwxNDMzO1VzZXIgSUQ9RjNNTztQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID0xMDAwMEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJTZXJ2aWNvc0dyYWR1YWNvZXMiPjxQYXJhbWV0ZXIgTmFtZT0iSUREb2N1bWVudG9WZW5kYSIgVHlwZT0iRGV2RXhwcmVzcy5EYXRhQWNjZXNzLkV4cHJlc3Npb24iPihTeXN0ZW0uSW50NjQsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OSkoW1BhcmFtZXRlcnMuSUREb2N1bWVudG9WZW5kYV0pPC9QYXJhbWV0ZXI+PFNxbD5zZWxlY3QgZGlzdGluY3QgdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzLiosIHRiYXJ0aWdvcy4qIGZyb20gdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIA0KbGVmdCBqb2luIHRiYXJ0aWdvcyBvbiB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMuSURBcnRpZ289dGJhcnRpZ29zLklEIA0Kd2hlcmUgdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzLmlkdGlwb29saG89NA0KYW5kIElERG9jdW1lbnRvVmVuZGE9QElERG9jdW1lbnRvVmVuZGENCm9yZGVyIGJ5IHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcy5vcmRlbTwvU3FsPjwvUXVlcnk+PFJlc3VsdFNjaGVtYT48RGF0YVNldD48VmlldyBOYW1lPSJ0YlNlcnZpY29zR3JhZHVhY29lcyI+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREb2N1bWVudG9WZW5kYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ2FtcGFuaGEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFydGlnbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFVuaWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1DYXNhc0RlY1VuaWRhZGUiIFR5cGU9IkludDE2IiAvPjxGaWVsZCBOYW1lPSJRdWFudGlkYWRlIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlByZWNvVW5pdGFyaW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpb0VmZXRpdm8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Ub3RhbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJPYnNlcnZhY29lcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRExvdGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Mb3RlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0xvdGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUZhYnJpY29Mb3RlIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YVZhbGlkYWRlTG90ZSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvTnVtU2VyaWUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJBcnRpZ29OdW1TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1Mb2NhbGl6YWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJtYXplbURlc3Rpbm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1Mb2NhbGl6YWNhb0Rlc3Rpbm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1MaW5oYXNEaW1lbnNvZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEZXNjb250bzEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRGVzY29udG8yIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEVGF4YUl2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFJdmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iTW90aXZvSXNlbmNhb0l2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJWYWxvckltcG9zdG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJSZWdpbWVJdmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik9yZGVtIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iRGlhbWV0cm8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmFsb3JEZXNjb250b0xpbmhhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsQ29tRGVzY29udG9MaW5oYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckRlc2NvbnRvQ2FiZWNhbGhvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsQ29tRGVzY29udG9DYWJlY2FsaG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JVbml0YXJpb0VudGlkYWRlMSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvclVuaXRhcmlvRW50aWRhZGUyIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRW50aWRhZGUxIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRW50aWRhZGUyIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsRmluYWwiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURTZXJ2aWNvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvU2VydmljbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb09saG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUaXBvRGlzdGFuY2lhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG9PbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEVGlwb0dyYWR1YWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW5jaWRlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvcklWQSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29UYXhhSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEVGlwb0l2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0RvY3VtZW50b09yaWdlbSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERG9jdW1lbnRvT3JpZ2VtIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURMaW5oYURvY3VtZW50b09yaWdlbSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb01vdGl2b0lzZW5jYW9JdmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRG9jdW1lbnRvT3JpZ2VtIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG9UYXhhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0FydGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29CYXJyYXNBcnRpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvVW5pZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29UaXBvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1JlZ2lhb0l2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJQZXJjSW5jaWRlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQZXJjRGVkdWNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckl2YURlZHV0aXZlbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEYXRhRG9jT3JpZ2VtIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSURBZGlhbnRhbWVudG9PcmlnZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvRWZldGl2b1NlbUl2YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckRlc2NvbnRvRWZldGl2b1NlbUl2YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFVuaWRhZGVTdG9jayIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVW5pZGFkZVN0b2NrMiIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlF1YW50aWRhZGVTdG9jayIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdWFudGlkYWRlU3RvY2syIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlByZWNvVW5pdGFyaW9Nb2VkYVJlZiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvRWZldGl2b01vZWRhUmVmIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlF0ZFN0b2NrQW50ZXJpb3IiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2tBdHVhbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJVUENNb2VkYVJlZiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQQ01BbnRlcmlvck1vZWRhUmVmIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlBDTUF0dWFsTW9lZGFSZWYiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUFZNb2VkYVJlZiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJBbHRlcmFkYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iVmFsb3Jpem91T3JpZ2VtIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJNb3ZTdG9ja09yaWdlbSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iTnVtQ2FzYXNEZWNVbmlkYWRlU3RrIiBUeXBlPSJJbnQxNiIgLz48RmllbGQgTmFtZT0iTnVtQ2FzYXNEZWMyVW5pZGFkZVN0ayIgVHlwZT0iSW50MTYiIC8+PEZpZWxkIE5hbWU9IkZhdG9yQ29udlVuaWRTdGsiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRmF0b3JDb252MlVuaWRTdGsiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2tBbnRlcmlvck9yaWdlbSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9ja0F0dWFsT3JpZ2VtIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlBDTUFudGVyaW9yTW9lZGFSZWZPcmlnZW0iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkQWZldGFjYW9TdG9jayIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdGRBZmV0YWNhb1N0b2NrMiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJPcGVyYWNhb0NvbnZVbmlkU3RrIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik9wZXJhY2FvQ29udjJVbmlkU3RrIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEVGlwb1ByZWNvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb1ByZWNvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvSXZhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVVBDb21wcmFNb2VkYVJlZiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJVbHRDdXN0b3NBZGljaW9uYWlzTW9lZGFSZWYiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVWx0RGVzY0NvbWVyY2lhaXNNb2VkYVJlZiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvRWZldGl2b01vZWRhUmVmT3JpZ2VtIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZvc3NvTnVtZXJvRG9jdW1lbnRvT3JpZ2VtIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY3VtZW50b09yaWdlbSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb3NEb2N1bWVudG9TZXJpZXNPcmlnZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJRdWFudGlkYWRlU2F0aXNmZWl0YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdWFudGlkYWRlRGV2b2x2aWRhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlNhdGlzZmVpdG8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvUGFyYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0RvY3VtZW50b09yaWdlbUluaWNpYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERvY3VtZW50b09yaWdlbUluaWNpYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRExpbmhhRG9jdW1lbnRvT3JpZ2VtSW5pY2lhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRvY3VtZW50b09yaWdlbUluaWNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMaW5oYURvY3VtZW50b0NvbXByYUluaWNpYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRExpbmhhRG9jdW1lbnRvU3RvY2tJbmljaWFsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURPRkFydGlnbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlF0ZFN0b2NrU2F0aXNmZWl0YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9ja0Rldm9sdmlkYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9ja0FjZXJ0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9jazJTYXRpc2ZlaXRhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlF0ZFN0b2NrMkRldm9sdmlkYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9jazJBY2VydG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURBcnRpZ29QQSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlF0ZFN0b2NrUmVzZXJ2YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9ja1Jlc2VydmEyVW5pIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRhdGFFbnRyZWdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSURfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJBdGl2b18xIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJJREZhbWlsaWEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFN1YkZhbWlsaWEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9BcnRpZ28iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbXBvc2ljYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Db21wb3NpY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURHcnVwb0FydGlnbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETWFyY2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29CYXJyYXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iUVJDb2RlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb18xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0FicmV2aWFkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJPYnNlcnZhY29lc18xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkdlcmVMb3RlcyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iR2VyZVN0b2NrIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJHZXJlTnVtZXJvU2VyaWUiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb1ZhcmlhdmVsIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9EaW1lbnNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGltZW5zYW9QcmltZWlyYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGltZW5zYW9TZWd1bmRhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURPcmRlbUxvdGVBcHJlc2VudGFyIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURVbmlkYWRlXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFVuaWRhZGVWZW5kYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVW5pZGFkZUNvbXByYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlZhcmlhdmVsQ29udGFiaWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hXzEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvXzEiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhb18xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFBbHRlcmFjYW9fMSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvcl8xIiBUeXBlPSJCeXRlQXJyYXkiIC8+PEZpZWxkIE5hbWU9IklERXN0YWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik5FIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRURVgiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iQ29kaWdvRXN0YXRpc3RpY28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTGltaXRlTWF4IiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkxpbWl0ZU1pbiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJSZXBvc2ljYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURPcmRlbUxvdGVNb3ZFbnRyYWRhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURPcmRlbUxvdGVNb3ZTYWlkYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGF4YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRlZHV0aXZlbFBlcmNlbnRhZ2VtIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkluY2lkZW5jaWFQZXJjZW50YWdlbSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJVbHRpbW9QcmVjb0N1c3RvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9Ik1lZGlvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlBhZHJhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJVbHRpbW9zQ3VzdG9zQWRpY2lvbmFpcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJVbHRpbW9zRGVzY29udG9zQ29tZXJjaWFpcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJVbHRpbW9QcmVjb0NvbXByYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbFF1YW50aWRhZGVWU1VQQyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbFF1YW50aWRhZGVWU1BDTSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbFF1YW50aWRhZGVWU1BDUGFkcmFvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEVGlwb3NDb21wb25lbnRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb21wb3N0b1RyYW5zZm9ybWFjYW9NZXRvZG9DdXN0byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklESW1wb3N0b1NlbG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJGYXRvckZUT0ZQZXJjZW50YWdlbSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJGb3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG9DYW1pbmhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEVW5pZGFkZVN0b2NrMl8xIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvUHJlY29fMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0FUIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlJlZmVyZW5jaWFGb3JuZWNlZG9yIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0JhcnJhc0Zvcm5lY2Vkb3IiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURTaXN0ZW1hQ2xhc3NpZmljYWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0RvY3VtZW50b1VQQyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERG9jdW1lbnRvVVBDIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRGF0YUNvbnRyb2xvVVBDIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iUmVjYWxjdWxhVVBDIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJUb3JjYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJbnZlbnRhcmlhZG8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IklEVGlwb1Blc28iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJQZXNvS2ciIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVm9sdW1lIiBUeXBlPSJEb3VibGUiIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''

update tbMapasVistas set SubReport=1, MapaXML = @ptrvalDiversos where id = @IDSubDiversos


INSERT INTO tbMapasVistas ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], [PorDefeito])
SELECT (SELECT MAX(ordem) FROM [dbo].[tbMapasVistas] WHERE entidade = ''DocumentosVendasServicos'') + 1 ordem, [Entidade], ''Serviços - Observações'' Descricao , ''DocumentosVendasServicosObservacoes'' [NomeMapa], '''' [Caminho], [Certificado], [IDLoja], null [SQLQuery], [Listagem], [Ativo], [Sistema], GetDate() [DataCriacao], N''F3M'' [UtilizadorCriacao], NULL [DataAlteracao],
NULL [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], 0 [PorDefeito]
FROM [dbo].[tbMapasVistas] where NomeMapa = ''rptDocumentosVendasServicosA5H''

Declare @IDSubObservacoes As bigint;
SET @IDSubObservacoes = SCOPE_IDENTITY();
DECLARE @ptrvalObservacoes xml;  
SET @ptrvalObservacoes = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosVendasServicosObservacoes" ScriptsSource="Imports Reporting&#xD;&#xA;&#xD;&#xA;&#xD;&#xA;Private Sub DocumentosVendasServicosObservacoes_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim sqlQuery = Me.Parameters.Item(&quot;Observacoes&quot;).Value&#xD;&#xA;    Dim idDocumento = Me.Parameters.Item(&quot;IDDocumento&quot;).Value&#xD;&#xA;&#xD;&#xA;    Dim query = sender.DataSource.Queries(0)&#xD;&#xA;    query.Sql = sqlQuery &amp; idDocumento&#xD;&#xA;    sender.DataSource.Fill()&#xD;&#xA;&#xD;&#xA;    fldFraseFiscal.Visible = False&#xD;&#xA;    &#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    Me.lblObservacoes.Text = resource.GetResource(&quot;Observacoes&quot;, culture)&#xD;&#xA;    Dim observacoes As String = Convert.ToString(GetCurrentColumnValue(&quot;Observacoes&quot;))&#xD;&#xA;    fldObservacoes.Text = observacoes&#xD;&#xA;End Sub&#xD;&#xA;" SnapGridSize="0.1" Margins="0, 97, 0, 0" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="19.1" DataMember="tbDocumentos" DataSource="#Ref-0">
  <Parameters>
    <Item1 Ref="3" Visible="false" Description="Culture" Name="Culture" />
    <Item2 Ref="4" Visible="false" Description="Observacoes" ValueInfo="select ID, Observacoes from tbDocumentosVendas where ID=" Name="Observacoes" />
    <Item3 Ref="6" Visible="false" Description="IDDocumento" ValueInfo="0" Name="IDDocumento" Type="#Ref-5" />
    <Item4 Ref="7" Visible="false" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-5" />
    <Item5 Ref="8" Visible="false" Description="FraseFiscal" Name="FraseFiscal" />
    <Item6 Ref="9" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item7 Ref="11" Visible="false" Description="AcompanhaBens" ValueInfo="true" Name="AcompanhaBens" Type="#Ref-10" />
    <Item8 Ref="12" Visible="false" Description="Parameter1" Name="TipoFiscal" />
  </Parameters>
  <Bands>
    <Item1 Ref="13" ControlType="TopMarginBand" Name="TopMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="14" ControlType="ReportHeaderBand" Name="ReportHeaderBand1" HeightF="34.05968">
      <Controls>
        <Item1 Ref="15" ControlType="XRLabel" Name="fldFraseFiscal" TextAlignment="TopLeft" SizeF="551.4506,9.132431" LocationFloat="0, 14" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
          <StylePriority Ref="16" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="17" ControlType="XRLabel" Name="lblObservacoes" Text="Observações" TextAlignment="MiddleLeft" SizeF="90.12,12" LocationFloat="0, 2" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
          <StylePriority Ref="18" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="19" ControlType="XRLabel" Name="fldObservacoes" Multiline="true" TextAlignment="TopLeft" SizeF="742.9999,9.132427" LocationFloat="0, 23.13243" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
          <StylePriority Ref="20" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
      </Controls>
    </Item2>
    <Item3 Ref="21" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item4 Ref="22" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="23" OnBeforePrint="DocumentosVendasServicosObservacoes_BeforePrint" />
  <StyleSheet>
    <Item1 Ref="24" Name="Title" BorderStyle="Inset" Font="Times New Roman, 20pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item2 Ref="25" Name="FieldCaption" BorderStyle="Inset" Font="Arial, 10pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item3 Ref="26" Name="PageInfo" BorderStyle="Inset" Font="Times New Roman, 10pt, style=Bold" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item4 Ref="27" Name="DataField" BorderStyle="Inset" Padding="2,2,0,0,100" Font="Times New Roman, 10pt" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
  </StyleSheet>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="5" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="10" Content="System.Boolean" Type="System.Type" />
    <Item3 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9cHJpc21hLWxhYi12bS53ZXN0ZXVyb3BlLmNsb3VkYXBwLmF6dXJlLmNvbSwxNDMzO1VzZXIgSUQ9RjNNTztQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID0xMDAwMEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJEb2N1bWVudG9zIj48U3FsPnNlbGVjdCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklEIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklETW9lZGFEZWZlaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIk1vcmFkYSIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGb3RvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZvdG9DYW1pbmhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRlc2lnbmFjYW9Db21lcmNpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ29kaWdvUG9zdGFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkxvY2FsaWRhZGUiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ29uY2VsaG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRGlzdHJpdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURQYWlzIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIlRlbGVmb25lIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZheCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJFbWFpbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJXZWJTaXRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIk5JRiIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNhcGl0YWxTb2NpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklESWRpb21hQmFzZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJTaXN0ZW1hIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkF0aXZvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRhdGFDcmlhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIlV0aWxpemFkb3JDcmlhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRhdGFBbHRlcmFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGM01NYXJjYWRvciIsDQogICAgICAgInRiTW9lZGFzIi4iU2ltYm9sbyIsDQogICAgICAgInRiTW9lZGFzIi4iVGF4YUNvbnZlcnNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iRGVzY3JpY2FvRGVjaW1hbCIsDQogICAgICAgInRiTW9lZGFzIi4iRGVzY3JpY2FvSW50ZWlyYSIsDQogICAgICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1RvdGFpcyIsDQogICAgICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc0l2YSIsDQogICAgICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyINCiAgZnJvbSAoImRibyIuInRiUGFyYW1ldHJvc0VtcHJlc2EiDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiDQogIGxlZnQgam9pbiAiZGJvIi4idGJNb2VkYXMiICJ0Yk1vZWRhcyINCiAgICAgICBvbiAoInRiTW9lZGFzIi4iSUQiID0gInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIpKTwvU3FsPjwvUXVlcnk+PFJlc3VsdFNjaGVtYT48RGF0YVNldD48VmlldyBOYW1lPSJ0YkRvY3VtZW50b3MiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxobyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUZWxlZm9uZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGYXgiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iV2ViU2l0ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOSUYiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXBpdGFsU29jaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iSURJZGlvbWFCYXNlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUYXhhQ29udmVyc2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0RlY2ltYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvSW50ZWlyYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzVG90YWlzIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzSXZhIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiBUeXBlPSJCeXRlIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''

update tbMapasVistas set SubReport=1, MapaXML = @ptrvalObservacoes where id = @IDSubObservacoes


INSERT INTO tbMapasVistas ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], [PorDefeito])
SELECT (SELECT MAX(ordem) FROM [dbo].[tbMapasVistas] WHERE entidade = ''DocumentosVendasServicos'') + 1 ordem, [Entidade], ''Serviços - Totais'' Descricao , ''DocumentosVendasServicosTotais'' [NomeMapa], '''' [Caminho], [Certificado], [IDLoja], null [SQLQuery], [Listagem], [Ativo], [Sistema], GetDate() [DataCriacao], N''F3M'' [UtilizadorCriacao], NULL [DataAlteracao],
NULL [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], 0 [PorDefeito]
FROM [dbo].[tbMapasVistas] where NomeMapa = ''rptDocumentosVendasServicosA5H''

Declare @IDSubTotais As bigint;
SET @IDSubTotais = SCOPE_IDENTITY();
DECLARE @ptrvalTotais xml;  
SET @ptrvalTotais = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosVendasServicosTotais" ScriptsSource="Imports Reporting&#xD;&#xA;&#xD;&#xA;Private Sub DocumentosVendasServicosTotais_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    resource.LoadResources(sender)&#xD;&#xA;&#xD;&#xA;    Dim Culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;    Dim Simbolo As String = Me.Parameters(&quot;Simbolo&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    Me.lblFaturado.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;Faturado&quot;, Culture)&#xD;&#xA;    Me.lblAdiantamentos.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;Adiantamento&quot;, Culture)&#xD;&#xA;    Me.lblPago.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;Pago&quot;, Culture)&#xD;&#xA;    Me.lblAPagar.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;Por pagar&quot;, Culture)&#xD;&#xA;&#xD;&#xA;    Me.fldAdiantamentos.Visible = False&#xD;&#xA;    Me.lblAdiantamentos.Visible = False&#xD;&#xA;    Me.fldFaturado.Visible = False&#xD;&#xA;    Me.lblFaturado.Visible = False&#xD;&#xA;&#xD;&#xA;    Dim strTotal As String = Convert.ToString(GetCurrentColumnValue(&quot;TotalFaturado&quot;))&#xD;&#xA;    If strTotal = &quot;0&quot; Then&#xD;&#xA;        Me.fldAdiantamentos.Visible = True&#xD;&#xA;        Me.lblAdiantamentos.Visible = True&#xD;&#xA;        Me.fldPago.Visible = False&#xD;&#xA;        Me.fldFaturado.Left = Me.fldPago.LeftF&#xD;&#xA;        Me.fldFaturado.WidthF = Me.fldPago.WidthF&#xD;&#xA;        Me.fldFaturado.Visible = True&#xD;&#xA;    Else&#xD;&#xA;        Me.fldFaturado.Visible = True&#xD;&#xA;        Me.lblFaturado.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;" SnapGridSize="0.1" Margins="10, 0, 0, 0" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="19.1" DataMember="tbTotalFaturado" DataSource="#Ref-0">
  <Parameters>
    <Item1 Ref="3" Visible="false" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item2 Ref="5" Description="IDDocumentoVenda" ValueInfo="28" Name="IDDocumentoVenda" Type="#Ref-4" />
    <Item3 Ref="6" Visible="false" Description="Simbolo" Name="Simbolo" />
    <Item4 Ref="7" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
  </Parameters>
  <Bands>
    <Item1 Ref="8" ControlType="TopMarginBand" Name="TopMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="9" ControlType="ReportHeaderBand" Name="ReportHeaderBand1" HeightF="16">
      <Controls>
        <Item1 Ref="10" ControlType="XRLabel" Name="lblAPagar" Text="A pagar" TextAlignment="TopRight" SizeF="82.72349,16" LocationFloat="180.4521, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="11" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="12" ControlType="XRLabel" Name="lblFaturado" Text="Faturado" TextAlignment="TopRight" SizeF="94.43687,16" LocationFloat="1.29172, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="13" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="14" ControlType="XRLabel" Name="lblPago" Text="Pago" TextAlignment="TopRight" SizeF="82.72349,16" LocationFloat="97, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="15" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="16" ControlType="XRLabel" Name="lblAdiantamentos" Text="Adiantamentos" TextAlignment="TopRight" SizeF="94.43687,16" LocationFloat="1.291718, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="17" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
      </Controls>
    </Item2>
    <Item3 Ref="18" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100">
      <SubBands>
        <Item1 Ref="19" ControlType="SubBand" Name="SubBand2" HeightF="23">
          <Controls>
            <Item1 Ref="20" ControlType="XRLabel" Name="fldApagar" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="82.72349,17.62498" LocationFloat="180.4521, 0" Font="Arial, 8.25pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="21" Expression="[tbTotalPago.APagar]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="22" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="23" ControlType="XRLabel" Name="fldPago" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="82.72349,17.62498" LocationFloat="97, 0" Font="Arial, 8.25pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="24" Expression="[tbTotalPago.Pago]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="25" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="26" ControlType="XRLabel" Name="fldFaturado" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="94.43687,17.62498" LocationFloat="1.29172, 0" Font="Arial, 8.25pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="27" Expression="[tbTotalFaturado.TotalFaturado]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="28" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="29" ControlType="XRLabel" Name="fldAdiantamentos" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="94.43687,17.62498" LocationFloat="1.291723, 0" Font="Arial, 8.25pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="30" Expression="[tbTotalAdiantamento.TotalAdiantamento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="31" UseFont="false" UseTextAlignment="false" />
            </Item4>
          </Controls>
        </Item1>
      </SubBands>
    </Item3>
    <Item4 Ref="32" ControlType="PageFooterBand" Name="PageFooterBand1" Expanded="false" HeightF="0" />
    <Item5 Ref="33" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="34" OnBeforePrint="DocumentosVendasServicosTotais_BeforePrint" />
  <StyleSheet>
    <Item1 Ref="35" Name="Title" BorderStyle="Inset" Font="Times New Roman, 20pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item2 Ref="36" Name="FieldCaption" BorderStyle="Inset" Font="Arial, 10pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item3 Ref="37" Name="PageInfo" BorderStyle="Inset" Font="Times New Roman, 10pt, style=Bold" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item4 Ref="38" Name="DataField" BorderStyle="Inset" Padding="2,2,0,0,100" Font="Times New Roman, 10pt" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
  </StyleSheet>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="4" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9cHJpc21hLWxhYi12bS53ZXN0ZXVyb3BlLmNsb3VkYXBwLmF6dXJlLmNvbSwxNDMzO1VzZXIgSUQ9RjNNTztQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID0xMDAwMEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJUb3RhbEZhdHVyYWRvIj48UGFyYW1ldGVyIE5hbWU9IklERG9jdW1lbnRvIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5JbnQ2NCwgbXNjb3JsaWIsIFZlcnNpb249NC4wLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5KShbUGFyYW1ldGVycy5JRERvY3VtZW50b1ZlbmRhXSk8L1BhcmFtZXRlcj48U3FsPlNlbGVjdCBzdW0odG90YWwpIEFzIFRvdGFsRmF0dXJhZG8gZnJvbSAoc2VsZWN0IGlzbnVsbChzdW0oKENhc2UgV2hlbiB0LklEU2lzdGVtYU5hdHVyZXphcz02IFRoZW4gVmFsb3JJbmNpZGVuY2lhK3ZhbG9yaXZhIEVsc2UgLShWYWxvckluY2lkZW5jaWErdmFsb3JpdmEpIEVuZCkpLDApIEFzIHRvdGFsIA0KZnJvbSB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMgRFZMIGlubmVyIGpvaW4NCihTZWxlY3QgZGlzdGluY3QgZHYuaWQsIHRkLklEU2lzdGVtYU5hdHVyZXphcyBmcm9tICB0YkRvY3VtZW50b3NWZW5kYXMgRFYgaW5uZXIgam9pbiB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMgRFZMIE9uIERWLklEPWR2bC5JRERvY3VtZW50b1ZlbmRhIA0KaW5uZXIgSm9pbiB0YnRpcG9zZG9jdW1lbnRvIFREIE9uIERWLklEVGlwb0RvY3VtZW50bz1URC5pZCANCndoZXJlIHRkLkFkaWFudGFtZW50bz0wIEFuZCBkdi5pZGVzdGFkbz01IEFuZCBkdmwuaWRkb2N1bWVudG9vcmlnZW09QElERG9jdW1lbnRvKSB0IA0Kb24gZHZsLmlkZG9jdW1lbnRvdmVuZGE9dC5pZCkgdiANCjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IkN1c3RvbVNxbFF1ZXJ5IiBOYW1lPSJ0YlRvdGFsQWRpYW50YW1lbnRvIj48UGFyYW1ldGVyIE5hbWU9IklERG9jdW1lbnRvIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5JbnQ2NCwgbXNjb3JsaWIsIFZlcnNpb249NC4wLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5KShbUGFyYW1ldGVycy5JRERvY3VtZW50b1ZlbmRhXSk8L1BhcmFtZXRlcj48U3FsPlNFTEVDVCBJU05VTEwoU1VNKERWTC5WYWxvckluY2lkZW5jaWEgKyBEVkwuVmFsb3JJVkEpLCAwKSBBUyBUb3RhbEFkaWFudGFtZW50bw0KRlJPTSB0YmRvY3VtZW50b3N2ZW5kYXMgQVMgRFYgDQpJTk5FUiBKT0lOIHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyBBUyBEVkwgT04gRFYuSUQgPSBEVkwuSUREb2N1bWVudG9WZW5kYQ0KSU5ORVIgSk9JTiB0YlRpcG9zRG9jdW1lbnRvIEFTIFREIE9OIERWLklEVGlwb0RvY3VtZW50byA9IFRELklEDQpJTk5FUiBKT0lOIHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIEFTIFRERiBPTiBUREYuSUQgPSBURC5JRFNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbA0KV0hFUkUgRFYuSURFc3RhZG8gPTUgQU5EIERWTC5pZGRvY3VtZW50b29yaWdlbSA9QElERG9jdW1lbnRvDQpBTkQgVEQuQWRpYW50YW1lbnRvID0gMSBBTkQgVERGLlRpcG8gPSAnRlInPC9TcWw+PC9RdWVyeT48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiVG90YWxQYWdvIj48UGFyYW1ldGVyIE5hbWU9IklERG9jdW1lbnRvIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5JbnQ2NCwgbXNjb3JsaWIsIFZlcnNpb249NC4wLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5KShbUGFyYW1ldGVycy5JRERvY3VtZW50b1ZlbmRhXSk8L1BhcmFtZXRlcj48U3FsPlNFTEVDVCBJU05VTEwoRFYuVmFsb3JQYWdvLCAwKSBBUyBQYWdvLA0KSVNOVUxMKERWLlRvdGFsTW9lZGFEb2N1bWVudG8sIDApIC0NCklTTlVMTChEVi5Ub3RhbEVudGlkYWRlMSwgMCkgKw0KSVNOVUxMKERWLlRvdGFsRW50aWRhZGUyLCAwKSAtDQpJU05VTEwoRFYuVmFsb3JQYWdvLCAwKSBBUyBBUGFnYXINCkZST00gdGJkb2N1bWVudG9zdmVuZGFzIEFTIERWIA0KV0hFUkUgRFYuSUQ9QElERG9jdW1lbnRvPC9TcWw+PC9RdWVyeT48UmVzdWx0U2NoZW1hPjxEYXRhU2V0PjxWaWV3IE5hbWU9InRiVG90YWxGYXR1cmFkbyI+PEZpZWxkIE5hbWU9IlRvdGFsRmF0dXJhZG8iIFR5cGU9IkRvdWJsZSIgLz48L1ZpZXc+PFZpZXcgTmFtZT0idGJUb3RhbEFkaWFudGFtZW50byI+PEZpZWxkIE5hbWU9IlRvdGFsQWRpYW50YW1lbnRvIiBUeXBlPSJEb3VibGUiIC8+PC9WaWV3PjxWaWV3IE5hbWU9InRiVG90YWxQYWdvIj48RmllbGQgTmFtZT0iUGFnbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJBUGFnYXIiIFR5cGU9IkRvdWJsZSIgLz48L1ZpZXc+PC9EYXRhU2V0PjwvUmVzdWx0U2NoZW1hPjxDb25uZWN0aW9uT3B0aW9ucyBDbG9zZUNvbm5lY3Rpb249InRydWUiIC8+PC9TcWxEYXRhU291cmNlPg==" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''

update tbMapasVistas set SubReport=1, MapaXML = @ptrvalTotais where id = @IDSubTotais


DECLARE @ptrvalP xml;  
SET @ptrvalP = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosVendasServicosA5HNovo250" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Microsoft.VisualBasic&#xD;&#xA;&#xD;&#xA;Private Sub DocumentosVendasServicosA5HNovo49_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim SimboloMoeda As String = String.Empty&#xD;&#xA;    Dim strEntidade As String = String.Empty&#xD;&#xA;    Dim strEntidade1 As String = String.Empty&#xD;&#xA;    Dim strEntidade2 As String = String.Empty&#xD;&#xA;    Dim strBeneficiario1 As String = String.Empty&#xD;&#xA;    Dim strBeneficiario2 As String = String.Empty&#xD;&#xA;    Dim strParentesco1 As String = String.Empty&#xD;&#xA;    Dim strParentesco2 As String = String.Empty&#xD;&#xA;    Dim strValor As String = String.Empty&#xD;&#xA;    Dim strTipo As String = String.Empty&#xD;&#xA;    Dim strSerie As String = String.Empty&#xD;&#xA;    Dim strNumero As String = String.Empty&#xD;&#xA;    Dim strData As String = String.Empty&#xD;&#xA;    Dim strCodigoPostal As String = String.Empty&#xD;&#xA;    Dim strLocalidade As String = String.Empty&#xD;&#xA;    Dim NumeroCasasDecimais As Int16 = 0&#xD;&#xA;    Dim dtData As Date&#xD;&#xA;&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    SimboloMoeda = Convert.ToString(GetCurrentColumnValue(&quot;tbMoedas_Simbolo&quot;))&#xD;&#xA;    Me.Parameters.Item(&quot;Simbolo&quot;).Value = SimboloMoeda&#xD;&#xA;&#xD;&#xA;    NumeroCasasDecimais = Convert.ToInt16(GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;&#xD;&#xA;    strEntidade1 = Convert.ToString(GetCurrentColumnValue(&quot;tbEntidades1_Codigo&quot;))&#xD;&#xA;&#xD;&#xA;    strEntidade2 = Convert.ToString(GetCurrentColumnValue(&quot;tbEntidades2_Codigo&quot;))&#xD;&#xA;&#xD;&#xA;    strBeneficiario1 = Convert.ToString(GetCurrentColumnValue(&quot;NumeroBeneficiario1&quot;))&#xD;&#xA;&#xD;&#xA;    strBeneficiario2 = Convert.ToString(GetCurrentColumnValue(&quot;NumeroBeneficiario2&quot;))&#xD;&#xA;&#xD;&#xA;    strParentesco1 = Convert.ToString(GetCurrentColumnValue(&quot;Parentesco1&quot;))&#xD;&#xA;&#xD;&#xA;    strParentesco2 = Convert.ToString(GetCurrentColumnValue(&quot;Parentesco2&quot;))&#xD;&#xA;&#xD;&#xA;    If strEntidade1 &lt;&gt; &quot;&quot; Then&#xD;&#xA;        If strEntidade2 &lt;&gt; &quot;&quot; Then&#xD;&#xA;            Me.fldEntidade.Text = strEntidade1 &amp; &quot; / &quot; &amp; strEntidade2&#xD;&#xA;            Me.fldNumBeneficiario.Text = strBeneficiario1 &amp; &quot; / &quot; &amp; strBeneficiario2&#xD;&#xA;            Me.fldParentesco.Text = strParentesco1 &amp; &quot; / &quot; &amp; strParentesco2&#xD;&#xA;        Else&#xD;&#xA;            Me.fldEntidade.Text = strEntidade1&#xD;&#xA;            Me.fldNumBeneficiario.Text = strBeneficiario1&#xD;&#xA;            Me.fldParentesco.Text = strParentesco1&#xD;&#xA;        End If&#xD;&#xA;    Else&#xD;&#xA;        Me.fldEntidade.Text = strEntidade2&#xD;&#xA;        Me.fldNumBeneficiario.Text = strBeneficiario2&#xD;&#xA;        Me.fldParentesco.Text = strParentesco2&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;))&#xD;&#xA;    strTipo = Convert.ToString(GetCurrentColumnValue(&quot;tbTiposDocumento_Codigo&quot;))&#xD;&#xA;    strSerie = Convert.ToString(GetCurrentColumnValue(&quot;CodigoSerie&quot;))&#xD;&#xA;    strNumero = Convert.ToString(GetCurrentColumnValue(&quot;NumeroDocumento&quot;))&#xD;&#xA;    dtData = GetCurrentColumnValue(&quot;DataDocumento&quot;)&#xD;&#xA;&#xD;&#xA;    Me.Parameters.Item(&quot;Titulo&quot;).Value = &quot;Serviço &quot; + strTipo &amp; &quot; &quot; &amp; strSerie &amp; &quot;/&quot; &amp; strNumero + &quot; | &quot; + dtData.ToShortDateString&#xD;&#xA;&#xD;&#xA;    strNumero = Convert.ToString(GetCurrentColumnValue(&quot;Codigo&quot;))&#xD;&#xA;&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;NomeFiscal&quot;))&#xD;&#xA;    Me.fldClienteCodigo.Text = &quot;Cliente &quot; + strNumero + &quot; &quot; + strValor&#xD;&#xA;&#xD;&#xA;    strNumero = Convert.ToString(GetCurrentColumnValue(&quot;Telefone&quot;))&#xD;&#xA;&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;Telemovel&quot;))&#xD;&#xA;    Me.fldTelefone.Text = &quot;Telf/Telm.: &quot; + strNumero + &quot; / &quot; + strValor&#xD;&#xA;    Me.fldTelefone.Visible = False&#xD;&#xA;&#xD;&#xA;    Me.lblSubTotal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;SubTotal&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;SubTotal&quot;))&#xD;&#xA;    Me.fldSubTotal.Text = strValor&#xD;&#xA;    Me.fldSubTotal.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.lblDescontosLinha.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontosLinha&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;DescontosLinha&quot;))&#xD;&#xA;    Me.fldDescontosLinha.Text = strValor&#xD;&#xA;    Me.fldDescontosLinha.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.lblDescontoGlobal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoGlobal&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;ValorDesconto&quot;))&#xD;&#xA;    Me.fldDescontoGlobal.Text = strValor&#xD;&#xA;    Me.fldDescontoGlobal.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.lblOutrosDescontos.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;OutrosDescontos&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;OutrosDescontos&quot;))&#xD;&#xA;    Me.fldOutrosDescontos.Text = strValor&#xD;&#xA;    Me.fldOutrosDescontos.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.lblTotalEntidade1.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalEntidade1&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;TotalEntidade1&quot;))&#xD;&#xA;    Me.fldTotalEntidade1.Text = strValor&#xD;&#xA;    Me.fldTotalEntidade1.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.lblTotalEntidade2.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalEntidade2&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;TotalEntidade2&quot;))&#xD;&#xA;    Me.fldTotalEntidade2.Text = strValor&#xD;&#xA;    Me.fldTotalEntidade2.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.lblTotalMoedaDocumento.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalMoedaDocumento&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;TotalMoedaDocumento&quot;))&#xD;&#xA;    Me.fldTotalMoedaDocumento.Text = strValor&#xD;&#xA;    Me.fldTotalMoedaDocumento.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.Parameters.Item(&quot;FraseFiscal&quot;).Value = &quot;&quot;&#xD;&#xA;End Sub&#xD;&#xA;" SnapGridSize="0.1" Margins="55, 25, 25, 600" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="19.1" DataMember="tbDocumentosVendas" DataSource="#Ref-0">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="16" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item3 Ref="7" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item4 Ref="8" Visible="false" Description="Via" Name="Via" />
    <Item5 Ref="9" Visible="false" Description="Formas" ValueInfo="select distinct tbDocumentosVendas.ID, tbDocumentosVendasFormasPagamento.IDFormaPagamento, tbFormasPagamento.Descricao, tbDocumentosVendasFormasPagamento.Valor,  tbDocumentosVendasFormasPagamento.ValorEntregue,  tbDocumentosVendasFormasPagamento.Troco from tbDocumentosVendas inner join tbDocumentosVendasFormasPagamento on tbDocumentosVendasFormasPagamento.IDDocumentoVenda = tbDocumentosVendas.ID inner join tbFormasPagamento on tbDocumentosVendasFormasPagamento.IDFormaPagamento=tbFormasPagamento.ID where tbDocumentosVendas.ID=" Name="Formas" />
    <Item6 Ref="11" Visible="false" Description="NumeroCasasDecimais" ValueInfo="2" Name="NumeroCasasDecimais" Type="#Ref-10" />
    <Item7 Ref="12" Visible="false" Description="Observacoes" ValueInfo="select ID, Observacoes from tbDocumentosVendas where ID=" Name="Observacoes" />
    <Item8 Ref="13" Visible="false" Description="Assinatura" ValueInfo="select ID, Assinatura from tbDocumentosVendas where ID=" Name="Assinatura" />
    <Item9 Ref="14" Visible="false" Description="FraseFiscal" Name="FraseFiscal" />
    <Item10 Ref="15" Visible="false" Description="Simbolo" Name="Simbolo" />
    <Item11 Ref="16" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item12 Ref="17" Visible="false" Description="Utilizador" Name="Utilizador" />
    <Item13 Ref="18" Visible="false" Description="Titulo" Name="Titulo" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="19" Name="SomaQuantidade" FieldType="Float" DisplayName="SomaQuantidade" Expression="[].Sum([Quantidade])" DataMember="tbDocumentosVendas" />
    <Item2 Ref="20" Name="SomaValorIVA" FieldType="Float" Expression="[].Sum([ValorIVA])" DataMember="tbDocumentosVendas" />
    <Item3 Ref="21" Name="SomaValorIncidencia" FieldType="Float" Expression="[].Sum([ValorIncidencia])" DataMember="tbDocumentosVendas" />
    <Item4 Ref="22" Name="SomaTotalFinal" FieldType="Double" Expression="[].Sum([TotalFinal])" DataMember="tbDocumentosVendas" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="23" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="24" ControlType="ReportHeaderBand" Name="ReportHeader" HeightF="22.01096">
      <Controls>
        <Item1 Ref="25" ControlType="XRSubreport" Name="DocumentosVendasServicosCabecalho" ReportSourceUrl="10000" SizeF="745.979,21.01097" LocationFloat="0.02150297, 0.9999911">
          <ParameterBindings>
            <Item1 Ref="27" ParameterName="IDLoja" Parameter="#Ref-5" />
            <Item2 Ref="28" ParameterName="Culture" Parameter="#Ref-7" />
            <Item3 Ref="29" ParameterName="BDEmpresa" Parameter="#Ref-16" />
            <Item4 Ref="30" ParameterName="DesignacaoComercial" DataMember="tbParametrosLojas.DesignacaoComercial" />
            <Item5 Ref="31" ParameterName="Titulo" Parameter="#Ref-18" />
            <Item6 Ref="32" ParameterName="Utilizador" Parameter="#Ref-17" />
          </ParameterBindings>
        </Item1>
      </Controls>
    </Item2>
    <Item3 Ref="33" ControlType="PageHeaderBand" Name="PageHeader" HeightF="24.87202">
      <SubBands>
        <Item1 Ref="34" ControlType="SubBand" Name="SubBand1" HeightF="1.011985" />
      </SubBands>
      <Controls>
        <Item1 Ref="35" ControlType="XRLabel" Name="fldParentesco" TextAlignment="TopRight" SizeF="114.3236,4.000008" LocationFloat="630.6296, 12.82109" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0" Visible="false">
          <StylePriority Ref="36" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="37" ControlType="XRLabel" Name="lblParentesco" Text="Parentesco" TextAlignment="TopLeft" SizeF="68.495,4" LocationFloat="562.1346, 12.82111" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Parentesco" Visible="false">
          <StylePriority Ref="38" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="39" ControlType="XRLabel" Name="fldNumBeneficiario" TextAlignment="TopRight" SizeF="114.3236,3.99999" LocationFloat="630.6296, 5.82111" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0" Visible="false">
          <StylePriority Ref="40" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="41" ControlType="XRLabel" Name="lblEntidade" Text="Entidade" TextAlignment="TopLeft" SizeF="68.495,4" LocationFloat="562.1346, 0.8211098" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Entidade" Visible="false">
          <StylePriority Ref="42" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="43" ControlType="XRLabel" Name="fldEntidade" TextAlignment="TopRight" SizeF="114.3236,4.00001" LocationFloat="630.6296, 0.8211308" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0" Visible="false">
          <StylePriority Ref="44" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="45" ControlType="XRLabel" Name="lblNumBeneficiario" Text="Beneficário" TextAlignment="TopLeft" SizeF="68.495,4" LocationFloat="562.1346, 5.82111" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Beneficiario" Visible="false">
          <StylePriority Ref="46" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="47" ControlType="XRLabel" Name="fldTelefone" Text="Telefone" TextAlignment="TopLeft" SizeF="294.2916,3.999983" LocationFloat="2, 18.82112" Font="Arial, 9pt" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="48" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="49" ControlType="XRLabel" Name="fldClienteCodigo" TextAlignment="TopLeft" SizeF="544.2128,17" LocationFloat="0, 0.9999911" Font="Arial, 9pt" Padding="2,2,0,0,100" BorderWidth="0">
          <StylePriority Ref="50" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item8>
      </Controls>
    </Item3>
    <Item4 Ref="51" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="52" ControlType="DetailReportBand" Name="DetailReport" Level="0" DataMember="tbServicos" DataSource="#Ref-0">
      <Bands>
        <Item1 Ref="53" ControlType="GroupHeaderBand" Name="GroupHeader1" HeightF="2.245522" />
        <Item2 Ref="54" ControlType="DetailBand" Name="Detail1" HeightF="44.22347">
          <Controls>
            <Item1 Ref="55" ControlType="XRSubreport" Name="DocumentosVendasServicosGraduacoes" ReportSourceUrl="30000" SizeF="745.52,44.22" LocationFloat="1.021449, 0">
              <ParameterBindings>
                <Item1 Ref="56" ParameterName="Culture" Parameter="#Ref-7" />
                <Item2 Ref="57" ParameterName="Simbolo" Parameter="#Ref-15" />
                <Item3 Ref="58" ParameterName="IDServico" DataMember="tbDocumentosVendas.idservico" />
                <Item4 Ref="59" ParameterName="BDEmpresa" Parameter="#Ref-16" />
              </ParameterBindings>
              <Scripts Ref="60" OnBeforePrint="DocumentosVendasServicosA5HNovo49_BeforePrint" />
            </Item1>
          </Controls>
        </Item2>
      </Bands>
    </Item5>
    <Item6 Ref="61" ControlType="GroupFooterBand" Name="GroupFooter1" HeightF="23.25">
      <SubBands>
        <Item1 Ref="62" ControlType="SubBand" Name="SubBand3" HeightF="63.1246">
          <Controls>
            <Item1 Ref="63" ControlType="XRSubreport" Name="DocumentosVendasServicosTotais" ReportSourceUrl="40000" SizeF="385.2569,35.95837" LocationFloat="1.958211, 20.48538">
              <ParameterBindings>
                <Item1 Ref="64" ParameterName="Culture" Parameter="#Ref-7" />
                <Item2 Ref="65" ParameterName="IDDocumentoVenda" Parameter="#Ref-4" />
                <Item3 Ref="66" ParameterName="Simbolo" Parameter="#Ref-15" />
                <Item4 Ref="67" ParameterName="BDEmpresa" Parameter="#Ref-16" />
              </ParameterBindings>
              <Scripts Ref="68" OnBeforePrint="DocumentosVendasServicosTotais_BeforePrint" />
            </Item1>
            <Item2 Ref="69" ControlType="XRLabel" Name="fldAssinatura" Text="Documento para uso interno. Este documento não serve de fatura, não serve de documento de transporte, nem serve de documento de conferência." TextAlignment="MiddleLeft" SizeF="747.0004,13" LocationFloat="0, 1.261658" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <StylePriority Ref="70" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="71" ControlType="XRLine" Name="XrLine4" SizeF="747.0004,2.041214" LocationFloat="0, 61.08338" />
            <Item4 Ref="72" ControlType="XRLine" Name="XrLine5" SizeF="747.0004,2" LocationFloat="0, 14.2617" />
            <Item5 Ref="73" ControlType="XRLabel" Name="fldTotalEntidade1" TextAlignment="TopRight" SizeF="70.00003,20.9583" LocationFloat="386.2152, 36.48517" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <ExpressionBindings>
                <Item1 Ref="74" Expression="[TotalEntidade1]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="75" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="76" ControlType="XRLabel" Name="lblSubTotal" TextAlignment="TopRight" SizeF="70,16" LocationFloat="0, 20.48519" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <StylePriority Ref="77" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="78" ControlType="XRLabel" Name="lblDescontosLinha" TextAlignment="TopRight" SizeF="70,16" LocationFloat="81.08317, 20.48519" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <StylePriority Ref="79" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="80" ControlType="XRLabel" Name="lblDescontoGlobal" TextAlignment="TopRight" SizeF="80,16" LocationFloat="175.3952, 20.48544" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <StylePriority Ref="81" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="82" ControlType="XRLabel" Name="fldOutrosDescontos" TextAlignment="TopRight" SizeF="113,20.9583" LocationFloat="257.2154, 36.48517" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <ExpressionBindings>
                <Item1 Ref="83" Expression="[OutrosDescontos]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="84" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="85" ControlType="XRLabel" Name="lblTotalEntidade1" TextAlignment="TopRight" SizeF="70,16" LocationFloat="386.2152, 20.48512" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <StylePriority Ref="86" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="87" ControlType="XRLabel" Name="lblTotalMoedaDocumento" TextAlignment="TopRight" SizeF="121.383,17" LocationFloat="616.1201, 19.48523" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="88" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item11>
            <Item12 Ref="89" ControlType="XRLabel" Name="lblTotalEntidade2" TextAlignment="TopRight" SizeF="69.99997,16" LocationFloat="474.2129, 20.48512" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <StylePriority Ref="90" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item12>
            <Item13 Ref="91" ControlType="XRLabel" Name="fldTotalMoedaDocumento" TextAlignment="TopRight" SizeF="176.209,25.59814" LocationFloat="561.7495, 36.4853" Font="Arial, 14.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="92" Expression="[TotalMoedaDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="93" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item13>
            <Item14 Ref="94" ControlType="XRLabel" Name="fldTotalEntidade2" TextAlignment="TopRight" SizeF="70.00003,20.9583" LocationFloat="474.2129, 36.48517" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <ExpressionBindings>
                <Item1 Ref="95" Expression="[TotalEntidade2]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="96" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item14>
            <Item15 Ref="97" ControlType="XRLabel" Name="XrLabel4" SizeF="190,46" LocationFloat="555.7953, 16.26168" BackColor="Gainsboro" Padding="2,2,0,0,100" Borders="None" BorderWidth="1">
              <StylePriority Ref="98" UseBackColor="false" UseBorders="false" UseBorderWidth="false" />
            </Item15>
            <Item16 Ref="99" ControlType="XRLabel" Name="fldSubTotal" TextFormatString="{0:€0.00}" TextAlignment="TopRight" SizeF="70,20.9583" LocationFloat="0, 36.48517" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <ExpressionBindings>
                <Item1 Ref="100" Expression="[SubTotal]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="101" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item16>
            <Item17 Ref="102" ControlType="XRLabel" Name="fldDescontoGlobal" TextAlignment="TopRight" SizeF="80,20.96" LocationFloat="175.3952, 36.4853" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <ExpressionBindings>
                <Item1 Ref="103" Expression="[ValorDesconto]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="104" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item17>
            <Item18 Ref="105" ControlType="XRLabel" Name="fldDescontosLinha" TextAlignment="TopRight" SizeF="70,20.9583" LocationFloat="81.08317, 36.48517" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <ExpressionBindings>
                <Item1 Ref="106" Expression="[DescontosLinha]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="107" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item18>
            <Item19 Ref="108" ControlType="XRLabel" Name="lblOutrosDescontos" TextAlignment="TopRight" SizeF="113,16" LocationFloat="257.2154, 20.48512" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <StylePriority Ref="109" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item19>
          </Controls>
        </Item1>
      </SubBands>
      <Controls>
        <Item1 Ref="110" ControlType="XRSubreport" Name="DocumentosVendasServicosDiversos" ReportSourceUrl="50000" CanShrink="true" SizeF="743.0005,23" LocationFloat="0, 0.2496402">
          <ParameterBindings>
            <Item1 Ref="111" ParameterName="Culture" Parameter="#Ref-7" />
            <Item2 Ref="112" ParameterName="IDDocumentoVenda" Parameter="#Ref-4" />
            <Item3 Ref="113" ParameterName="Simbolo" Parameter="#Ref-15" />
            <Item4 Ref="114" ParameterName="BDEmpresa" Parameter="#Ref-16" />
          </ParameterBindings>
        </Item1>
      </Controls>
    </Item6>
    <Item7 Ref="115" ControlType="ReportFooterBand" Name="ReportFooter" PrintAtBottom="true" HeightF="13.69">
      <Controls>
        <Item1 Ref="116" ControlType="XRSubreport" Name="DocumentosVendasServicosObservacoes" ReportSourceUrl="20000" CanShrink="true" SizeF="747.0002,12.84752" LocationFloat="0, 0.8408864">
          <ParameterBindings>
            <Item1 Ref="117" ParameterName="Culture" Parameter="#Ref-7" />
            <Item2 Ref="118" ParameterName="Observacoes" Parameter="#Ref-12" />
            <Item3 Ref="119" ParameterName="IDDocumento" Parameter="#Ref-4" />
            <Item4 Ref="120" ParameterName="IDLoja" Parameter="#Ref-5" />
            <Item5 Ref="121" ParameterName="FraseFiscal" Parameter="#Ref-14" />
            <Item6 Ref="122" ParameterName="BDEmpresa" Parameter="#Ref-16" />
          </ParameterBindings>
          <Scripts Ref="123" OnBeforePrint="DocumentosVendasServicosObservacoes_BeforePrint" />
        </Item1>
      </Controls>
    </Item7>
    <Item8 Ref="124" ControlType="PageFooterBand" Name="PageFooter" HeightF="17">
      <Controls>
        <Item1 Ref="125" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="746.6705,4" LocationFloat="0, 0" BorderWidth="3">
          <StylePriority Ref="126" UseBorderWidth="false" />
        </Item1>
        <Item2 Ref="127" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="625.5449, 4.000005" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="128" UseFont="false" UseTextAlignment="false" />
        </Item2>
      </Controls>
    </Item8>
    <Item9 Ref="129" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="600" TextAlignment="TopLeft" Padding="0,0,0,0,100">
      <Scripts Ref="130" OnBeforePrint="BottomMargin_BeforePrint" />
    </Item9>
  </Bands>
  <Scripts Ref="131" OnBeforePrint="DocumentosVendasServicosA5HNovo49_BeforePrint" />
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="10" Content="System.Int32" Type="System.Type" />
    <Item3 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9cHJpc21hLWxhYi12bS53ZXN0ZXVyb3BlLmNsb3VkYXBwLmF6dXJlLmNvbSwxNDMzO1VzZXIgSUQ9RjNNTztQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID0xMDAwMEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJEb2N1bWVudG9zVmVuZGFzIj48UGFyYW1ldGVyIE5hbWU9IklERG9jdW1lbnRvIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5JbnQ2NCwgbXNjb3JsaWIsIFZlcnNpb249NC4wLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5KShbUGFyYW1ldGVycy5JRERvY3VtZW50b10pPC9QYXJhbWV0ZXI+PFNxbD5zZWxlY3QgZGlzdGluY3QgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRCIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEVGlwb0RvY3VtZW50byIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk51bWVyb0RvY3VtZW50byIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFEb2N1bWVudG8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJPYnNlcnZhY29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklETW9lZGEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJUYXhhQ29udmVyc2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVG90YWxNb2VkYURvY3VtZW50byIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRvdGFsTW9lZGFSZWZlcmVuY2lhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iTG9jYWxDYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFDYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkhvcmFDYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk1vcmFkYUNhcmdhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29uY2VsaG9DYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERGlzdHJpdG9DYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkxvY2FsRGVzY2FyZ2EiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEYXRhRGVzY2FyZ2EiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJIb3JhRGVzY2FyZ2EiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3JhZGFEZXNjYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRENvbmNlbGhvRGVzY2FyZ2EiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRERpc3RyaXRvRGVzY2FyZ2EiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOb21lRGVzdGluYXRhcmlvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iTW9yYWRhRGVzdGluYXRhcmlvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRENvbmNlbGhvRGVzdGluYXRhcmlvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlNlcmllRG9jTWFudWFsIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iTnVtZXJvRG9jTWFudWFsIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iTnVtZXJvTGluaGFzIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iUG9zdG8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREVzdGFkbyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlV0aWxpemFkb3JFc3RhZG8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEYXRhSG9yYUVzdGFkbyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkFzc2luYXR1cmEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJWZXJzYW9DaGF2ZVByaXZhZGEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOb21lRmlzY2FsIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iTW9yYWRhRmlzY2FsIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRENvbmNlbGhvRmlzY2FsIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSUREaXN0cml0b0Zpc2NhbCIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkNvbnRyaWJ1aW50ZUZpc2NhbCIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlNpZ2xhUGFpc0Zpc2NhbCIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklETG9qYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkltcHJlc3NvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVmFsb3JJbXBvc3RvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iUGVyY2VudGFnZW1EZXNjb250byIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlZhbG9yRGVzY29udG8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJWYWxvclBvcnRlcyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEVGF4YUl2YVBvcnRlcyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRheGFJdmFQb3J0ZXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3Rpdm9Jc2VuY2FvSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iTW90aXZvSXNlbmNhb1BvcnRlcyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERXNwYWNvRmlzY2FsUG9ydGVzIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iRXNwYWNvRmlzY2FsUG9ydGVzIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURSZWdpbWVJdmFQb3J0ZXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJSZWdpbWVJdmFQb3J0ZXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJDdXN0b3NBZGljaW9uYWlzIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iU2lzdGVtYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkF0aXZvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YUNyaWFjYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJVdGlsaXphZG9yQ3JpYWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFBbHRlcmFjYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJVdGlsaXphZG9yQWx0ZXJhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iRjNNTWFyY2Fkb3IiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREZvcm1hRXhwZWRpY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURUaXBvc0RvY3VtZW50b1NlcmllcyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk51bWVyb0ludGVybm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREVudGlkYWRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURUaXBvRW50aWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRENvbmRpY2FvUGFnYW1lbnRvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDbGllbnRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iQ29kaWdvQVQiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEYXRhVmVuY2ltZW50byIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFOYXNjaW1lbnRvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREVudGlkYWRlMSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk51bWVyb0JlbmVmaWNpYXJpbzEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJQYXJlbnRlc2NvMSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERW50aWRhZGUyIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iTnVtZXJvQmVuZWZpY2lhcmlvMiIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlBhcmVudGVzY28yIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iRW1haWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJTdWJUb3RhbCIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRlc2NvbnRvc0xpbmhhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iT3V0cm9zRGVzY29udG9zIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVG90YWxQb250b3MiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJUb3RhbFZhbGVzT2ZlcnRhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVG90YWxJdmEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJUb3RhbEVudGlkYWRlMSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRvdGFsRW50aWRhZGUyIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURQYWlzQ2FyZ2EiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRFBhaXNEZXNjYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk1hdHJpY3VsYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkVudGlkYWRlMUF1dG9tYXRpY2EiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRExvY2FsT3BlcmFjYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNZW5zYWdlbURvY0FUIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iU2VndW5kYVZpYSIsDQogICAgICAgInRiQ2xpZW50ZXMiLiJDb2RpZ28iLCAidGJDbGllbnRlcyIuIk5vbWUiLA0KICAgICAgICJ0YkVzdGFkb3MiLiJDb2RpZ28iIGFzICJ0YkVzdGFkb3NfQ29kaWdvIiwNCiAgICAgICAidGJFc3RhZG9zIi4iRGVzY3JpY2FvIiBhcyAidGJFc3RhZG9zX0Rlc2NyaWNhbyIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG8iLiJDb2RpZ28iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0NvZGlnbyIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0Rlc2NyaWNhbyIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJEZXNjcmljYW9TZXJpZSIsDQogICAgICAgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiwNCiAgICAgICAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJUaXBvIiwNCiAgICAgICAidGJFbnRpZGFkZXMxIi4iQ29kaWdvIiBhcyAidGJFbnRpZGFkZXMxX0NvZGlnbyIsDQogICAgICAgInRiRW50aWRhZGVzMSIuIkRlc2NyaWNhbyIgYXMgInRiRW50aWRhZGVzMV9EZXNjcmljYW8iLA0KICAgICAgICJ0YkVudGlkYWRlczIiLiJDb2RpZ28iIGFzICJ0YkVudGlkYWRlczJfQ29kaWdvIiwNCiAgICAgICAidGJFbnRpZGFkZXMyIi4iRGVzY3JpY2FvIiBhcyAidGJFbnRpZGFkZXMyX0Rlc2NyaWNhbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMxIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc19Db2RpZ28iLA0KICAgICAgICJ0YkNvZGlnb3NQb3N0YWlzMSIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNfRGVzY3JpY2FvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczIiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfQ29kaWdvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczIiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczMiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfQ29kaWdvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczMiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfRGVzY3JpY2FvIiwNCiAgICAgICAidGJNb2VkYXMiLiJDb2RpZ28iIGFzICJ0Yk1vZWRhc19Db2RpZ28iLA0KICAgICAgICJ0Yk1vZWRhcyIuIkRlc2NyaWNhbyIgYXMgInRiTW9lZGFzX0Rlc2NyaWNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iU2ltYm9sbyIgYXMgInRiTW9lZGFzX1NpbWJvbG8iLA0KICAgICAgICJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNUb3RhaXMiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzIiwNCiAgICAgICAidGJTaXN0ZW1hTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIsDQogICAgICAgInRiQ2xpZW50ZXNDb250YXRvcyIuIlRlbGVmb25lIiwgInRiQ2xpZW50ZXNDb250YXRvcyIuIlRlbGVtb3ZlbCIsDQoJIHRic2Vydmljb3MuaWQgYXMgaWRzZXJ2aWNvLCB0YnNlcnZpY29zLm9yZGVtLCB0YnNlcnZpY29zLmlkdGlwb3NlcnZpY28NCmZyb20gImRibyIuInRiRG9jdW1lbnRvc1ZlbmRhcyIgInRiRG9jdW1lbnRvc1ZlbmRhcyINCmlubmVyIGpvaW4gImRibyIuInRiQ2xpZW50ZXMiICJ0YkNsaWVudGVzIiBvbiAidGJDbGllbnRlcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREVudGlkYWRlIg0KbGVmdCBqb2luICJkYm8iLiJ0YkNsaWVudGVzQ29udGF0b3MiICJ0YkNsaWVudGVzQ29udGF0b3MiIG9uICJ0YkNsaWVudGVzIi4iSUQiID0gInRiQ2xpZW50ZXNDb250YXRvcyIuIklEQ2xpZW50ZSINCmxlZnQgam9pbiB0YnNlcnZpY29zIHRic2Vydmljb3Mgb24gdGJEb2N1bWVudG9zVmVuZGFzLmlkPXRic2Vydmljb3MuSUREb2N1bWVudG9WZW5kYQ0KbGVmdCBqb2luIHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc0dyYWR1YWNvZXMgdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzR3JhZHVhY29lcyBvbiB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNHcmFkdWFjb2VzLklEU2Vydmljbz10YnNlcnZpY29zLklEDQpsZWZ0IGpvaW4gdGJNZWRpY29zVGVjbmljb3MgdGJNZWRpY29zVGVjbmljb3Mgb24gdGJzZXJ2aWNvcy5JRE1lZGljb1RlY25pY289dGJNZWRpY29zVGVjbmljb3MuSUQNCmxlZnQgam9pbiAiZGJvIi4idGJFc3RhZG9zIiAidGJFc3RhZG9zIiBvbiAidGJFc3RhZG9zIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERXN0YWRvIg0KbGVmdCBqb2luICJkYm8iLiJ0YlRpcG9zRG9jdW1lbnRvIiAidGJUaXBvc0RvY3VtZW50byIgb24gInRiVGlwb3NEb2N1bWVudG8iLiJJRCIgPSAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURUaXBvRG9jdW1lbnRvIg0KbGVmdCBqb2luICJkYm8iLiJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIiAidGJUaXBvc0RvY3VtZW50b1NlcmllcyIgb24gInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJJRCIgPSAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURUaXBvc0RvY3VtZW50b1NlcmllcyINCmxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIgb24gInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCINCmxlZnQgIGpvaW4gImRibyIuInRiRW50aWRhZGVzIiAidGJFbnRpZGFkZXMxIiBvbiAidGJFbnRpZGFkZXMxIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERW50aWRhZGUxIg0KbGVmdCBqb2luICJkYm8iLiJ0YkVudGlkYWRlcyIgInRiRW50aWRhZGVzMiIgb24gInRiRW50aWRhZGVzMiIuIklEIiA9ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREVudGlkYWRlMiINCmxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMxIiBvbiAidGJDb2RpZ29zUG9zdGFpczEiLiJJRCIgPSAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiDQpsZWZ0IGpvaW4gImRibyIuInRiQ29kaWdvc1Bvc3RhaXMiICJ0YkNvZGlnb3NQb3N0YWlzMiIgb24gInRiQ29kaWdvc1Bvc3RhaXMyIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiDQpsZWZ0IGpvaW4gImRibyIuInRiQ29kaWdvc1Bvc3RhaXMiICJ0YkNvZGlnb3NQb3N0YWlzMyIgb24gInRiQ29kaWdvc1Bvc3RhaXMzIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiDQpsZWZ0IGpvaW4gImRibyIuInRiTW9lZGFzIiAidGJNb2VkYXMiIG9uICJ0Yk1vZWRhcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRE1vZWRhIg0KbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFNb2VkYXMiICJ0YlNpc3RlbWFNb2VkYXMiIG9uICJ0YlNpc3RlbWFNb2VkYXMiLiJJRCIgPSAidGJNb2VkYXMiLiJJRFNpc3RlbWFNb2VkYSINCndoZXJlICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRCI9QElERG9jdW1lbnRvPC9TcWw+PC9RdWVyeT48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiUGFyYW1ldHJvc0xvamFzIj48UGFyYW1ldGVyIE5hbWU9IklETG9qYSIgVHlwZT0iRGV2RXhwcmVzcy5EYXRhQWNjZXNzLkV4cHJlc3Npb24iPihTeXN0ZW0uSW50NjQsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OSkoW1BhcmFtZXRlcnMuSURMb2phXSk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCAidGJMb2phcyIuIkNvZGlnbyIsICJ0YkxvamFzIi4iRGVzY3JpY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuKiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklEIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklETW9lZGFEZWZlaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIk1vcmFkYSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJGb3RvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkZvdG9DYW1pbmhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkRlc2lnbmFjYW9Db21lcmNpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ29kaWdvUG9zdGFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkxvY2FsaWRhZGUiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ29uY2VsaG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRGlzdHJpdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iSURQYWlzIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIlRlbGVmb25lIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkZheCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJFbWFpbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJXZWJTaXRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIk5JRiIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNhcGl0YWxTb2NpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklETG9qYSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRElkaW9tYUJhc2UiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iU2lzdGVtYSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJBdGl2byIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJEYXRhQ3JpYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJVdGlsaXphZG9yQ3JpYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJEYXRhQWx0ZXJhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIlV0aWxpemFkb3JBbHRlcmFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRjNNTWFyY2Fkb3IiLA0KICAgICAgICJ0Yk1vZWRhcyIuIlNpbWJvbG8iDQogIGZyb20gKCgiZGJvIi4idGJMb2phcyIgInRiTG9qYXMiDQogIGlubmVyIGpvaW4gImRibyIuInRiUGFyYW1ldHJvc0xvamEiDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiDQogICAgICAgb24gKCJ0YlBhcmFtZXRyb3NMb2phIi4iSURMb2phIiA9ICJ0YkxvamFzIi4iSUQiKSkNCiAgaW5uZXIgam9pbiAiZGJvIi4idGJNb2VkYXMiICJ0Yk1vZWRhcyINCiAgICAgICBvbiAoInRiTW9lZGFzIi4iSUQiID0gInRiUGFyYW1ldHJvc0xvamEiLiJJRE1vZWRhRGVmZWl0byIpKQ0Kd2hlcmUgInRiUGFyYW1ldHJvc0xvamEiLiJJRExvamEiID0gQElETG9qYTwvU3FsPjxNZXRhIFg9IjE0MCIgWT0iMjAiIFdpZHRoPSIxMDAiIEhlaWdodD0iNTY0IiAvPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IlNlbGVjdFF1ZXJ5IiBOYW1lPSJ0YlNlcnZpY29zIiBEaXN0aW5jdD0idHJ1ZSI+PFBhcmFtZXRlciBOYW1lPSJJRERvY3VtZW50byIgVHlwZT0iU3lzdGVtLkludDY0Ij4wPC9QYXJhbWV0ZXI+PFRhYmxlcz48VGFibGUgTmFtZT0idGJTZXJ2aWNvcyIgLz48VGFibGUgTmFtZT0idGJEb2N1bWVudG9zVmVuZGFzIiAvPjxSZWxhdGlvbiBUeXBlPSJJbm5lciIgUGFyZW50PSJ0YlNlcnZpY29zIiBOZXN0ZWQ9InRiRG9jdW1lbnRvc1ZlbmRhcyI+PEtleUNvbHVtbiBQYXJlbnQ9IklERG9jdW1lbnRvVmVuZGEiIE5lc3RlZD0iSUQiIC8+PC9SZWxhdGlvbj48L1RhYmxlcz48Q29sdW1ucz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NWZW5kYXMiIE5hbWU9IklEIiAvPjwvQ29sdW1ucz48RmlsdGVyPlt0YkRvY3VtZW50b3NWZW5kYXMuSURdID0gP0lERG9jdW1lbnRvPC9GaWx0ZXI+PC9RdWVyeT48UmVzdWx0U2NoZW1hPjxEYXRhU2V0PjxWaWV3IE5hbWU9InRiRG9jdW1lbnRvc1ZlbmRhcyI+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvRG9jdW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtZXJvRG9jdW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRGF0YURvY3VtZW50byIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik9ic2VydmFjb2VzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklETW9lZGEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUYXhhQ29udmVyc2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsTW9lZGFEb2N1bWVudG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxNb2VkYVJlZmVyZW5jaWEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iTG9jYWxDYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ2FyZ2EiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJIb3JhQ2FyZ2EiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFDYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbENhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25jZWxob0NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTG9jYWxEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhRGVzY2FyZ2EiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJIb3JhRGVzY2FyZ2EiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25jZWxob0Rlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Rlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTm9tZURlc3RpbmF0YXJpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFEZXN0aW5hdGFyaW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlNlcmllRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY01hbnVhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9MaW5oYXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJQb3N0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVzdGFkbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JFc3RhZG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUhvcmFFc3RhZG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJBc3NpbmF0dXJhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlZlcnNhb0NoYXZlUHJpdmFkYSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9Ik5vbWVGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTW9yYWRhRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25jZWxob0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb250cmlidWludGVGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklETG9qYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkltcHJlc3NvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJWYWxvckltcG9zdG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUGVyY2VudGFnZW1EZXNjb250byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckRlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yUG9ydGVzIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEVGF4YUl2YVBvcnRlcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFJdmFQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iTW90aXZvSXNlbmNhb0l2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRXNwYWNvRmlzY2FsUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUmVnaW1lSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUmVnaW1lSXZhUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkN1c3Rvc0FkaWNpb25haXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iSURGb3JtYUV4cGVkaWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb3NEb2N1bWVudG9TZXJpZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9JbnRlcm5vIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURFbnRpZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0VudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25kaWNhb1BhZ2FtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ2xpZW50ZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0FUIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFWZW5jaW1lbnRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YU5hc2NpbWVudG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJJZGFkZSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9IklERW50aWRhZGUxIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtZXJvQmVuZWZpY2lhcmlvMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJQYXJlbnRlc2NvMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVudGlkYWRlMiIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0JlbmVmaWNpYXJpbzIiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iUGFyZW50ZXNjbzIiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU3ViVG90YWwiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRGVzY29udG9zTGluaGEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iT3V0cm9zRGVzY29udG9zIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsUG9udG9zIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsVmFsZXNPZmVydGEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxJdmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxFbnRpZGFkZTEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxFbnRpZGFkZTIiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURQYWlzQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNEZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1hdHJpY3VsYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbnRpZGFkZTFBdXRvbWF0aWNhIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJJRExvY2FsT3BlcmFjYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNZW5zYWdlbURvY0FUIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNlZ3VuZGFWaWEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkNvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOb21lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRXN0YWRvc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFc3RhZG9zX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbF9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVudGlkYWRlczFfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRW50aWRhZGVzMV9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFbnRpZGFkZXMyX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVudGlkYWRlczJfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDYXJnYV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19TaW1ib2xvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0Nhc2FzRGVjaW1haXNUb3RhaXMiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYU1vZWRhc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGVsZWZvbmUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGVsZW1vdmVsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Imlkc2VydmljbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Im9yZGVtIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iaWR0aXBvc2VydmljbyIgVHlwZT0iSW50NjQiIC8+PC9WaWV3PjxWaWV3IE5hbWU9InRiUGFyYW1ldHJvc0xvamFzIj48RmllbGQgTmFtZT0iQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxobyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUZWxlZm9uZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGYXgiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iV2ViU2l0ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOSUYiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXBpdGFsU29jaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURJZGlvbWFCYXNlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iSURfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFfMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNpZ25hY2FvQ29tZXJjaWFsXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZV8xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRmF4XzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWxfMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJXZWJTaXRlXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTklGXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWxfMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ2FwaXRhbFNvY2lhbF8xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbV8xIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJJRExvamFfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklESWRpb21hQmFzZV8xIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYV8xIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2b18xIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ3JpYWNhb18xIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvXzEiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3JfMSIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJTaW1ib2xvIiBUeXBlPSJTdHJpbmciIC8+PC9WaWV3PjxWaWV3IE5hbWU9InRiU2Vydmljb3MiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''

Set @ptrvalP.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item2/Controls/Item1/@ReportSourceUrl)[.=10000][1] with sql:variable("@IDSubCabecalho")'')
Set @ptrvalP.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item7/Controls/Item1/@ReportSourceUrl)[.=20000][1] with sql:variable("@IDSubObservacoes")'')
Set @ptrvalP.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item5/Bands/Item2/Controls/Item1/@ReportSourceUrl)[.=30000][1] with sql:variable("@IDSubGraduacoes")'')
Set @ptrvalP.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item6/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=40000][1] with sql:variable("@IDSubTotais")'')
Set @ptrvalP.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item6/Controls/Item1/@ReportSourceUrl)[.=50000][1] with sql:variable("@IDSubDiversos")'')

update tbMapasVistas set MapaXML = @ptrvalP, Caminho='''', NomeMapa = ''DocumentosVendasServicosA5H'', SubReport=0, Entidade = ''DocumentosVendasServicos'' where NomeMapa = ''rptDocumentosVendasServicosA5H''
')



-- VISTA DOCUMENTOS DE VENDA A5 HORIZONTAL

EXEC('
INSERT INTO tbMapasVistas ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], [PorDefeito])
SELECT (SELECT MAX(ordem) FROM [dbo].[tbMapasVistas] WHERE entidade = ''DocumentosVendas'') + 1 ordem, [Entidade], ''Doc. Venda - Cabeçalho'' Descricao , ''DocumentosVendasCabecalho'' [NomeMapa], '''' [Caminho], [Certificado], [IDLoja], null [SQLQuery], [Listagem], [Ativo], [Sistema], GetDate() [DataCriacao], N''F3M'' [UtilizadorCriacao], NULL [DataAlteracao],
NULL [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], 0 [PorDefeito]
FROM [dbo].[tbMapasVistas] where NomeMapa = ''rptDocumentosVendasA5H''

Declare @IDSubCabecalho As bigint;
SET @IDSubCabecalho = SCOPE_IDENTITY();
DECLARE @ptrvalCabecalho xml;  
SET @ptrvalCabecalho = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosVendasCabecalho" ScriptsSource="Imports Reporting&#xD;&#xA;&#xD;&#xA;Private Sub picLogotipo_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    fldDesignacaoComercial.Text = GetParameterValue(&quot;DesignacaoComercial&quot;)&#xD;&#xA;    fldMorada.Text = GetParameterValue(&quot;Morada&quot;)&#xD;&#xA;    fldCodigoPostal.Text = GetParameterValue(&quot;CodigoPostal&quot;) &amp; &quot; &quot; &amp; GetParameterValue(&quot;Localidade&quot;)&#xD;&#xA;    fldNIF.Text = GetParameterValue(&quot;Sigla&quot;) &amp; &quot; &quot; &amp; GetParameterValue(&quot;NIF&quot;)&#xD;&#xA;    fldConservatoria.Text = &quot;Cap. Soc. &quot; &amp; GetParameterValue(&quot;CapitalSocial&quot;) &amp; &quot; &quot; &amp; &quot; Matric. &quot; &amp; GetParameterValue(&quot;ConservatoriaRegistoComercial&quot;) &amp; &quot; &quot; &amp; &quot; Nr. &quot; &amp; GetParameterValue(&quot;NumeroRegistoComercial&quot;)&#xD;&#xA;&#xD;&#xA;    If Not String.IsNullOrEmpty(Parameters(&quot;IDLojaSede&quot;).Value.ToString) AndAlso GetParameterValue(&quot;IDLoja&quot;) &lt;&gt; GetParameterValue(&quot;IDLojaSede&quot;) Then&#xD;&#xA;        LabelSede.Visible = True&#xD;&#xA;        fldMoradaSede.Visible = True&#xD;&#xA;        fldCodigoPostalSede.Visible = True&#xD;&#xA;        lblTelefoneSede.Visible = True&#xD;&#xA;        fldTelefoneSede.Visible = True&#xD;&#xA;        fldMoradaSede.Text = GetParameterValue(&quot;MoradaSede&quot;)&#xD;&#xA;        fldCodigoPostalSede.Text = GetParameterValue(&quot;CodigoPostalSede&quot;) &amp; &quot; &quot; &amp; GetParameterValue(&quot;LocalidadeSede&quot;)&#xD;&#xA;        fldTelefoneSede.Text = GetParameterValue(&quot;TelefoneSede&quot;)&#xD;&#xA;    Else&#xD;&#xA;        LabelSede.Visible = False&#xD;&#xA;        fldMoradaSede.Visible = False&#xD;&#xA;        fldCodigoPostalSede.Visible = False&#xD;&#xA;        lblTelefoneSede.Visible = False&#xD;&#xA;        fldTelefoneSede.Visible = False&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Function GetParameterValue(inParameter As String) As String&#xD;&#xA;    Dim strResult = String.Empty&#xD;&#xA;&#xD;&#xA;    If Parameters(inParameter) IsNot Nothing AndAlso Parameters(inParameter).Value.ToString &lt;&gt; &quot;&quot; Then&#xD;&#xA;        strResult = Me.Parameters(inParameter).Value.ToString&#xD;&#xA;    Else&#xD;&#xA;        strResult = Convert.ToString(GetCurrentColumnValue(inParameter))&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    Return strResult&#xD;&#xA;End Function&#xD;&#xA;" SnapGridSize="0.1" Margins="3, 65, 3, 4" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="19.1" FilterString="[IDLoja] = ?IDLoja" DataMember="tbParametrosLoja" DataSource="#Ref-0">
  <Parameters>
    <Item1 Ref="3" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-2" />
    <Item2 Ref="5" Visible="false" Description="Culture" Name="Culture" />
    <Item3 Ref="6" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item4 Ref="7" Visible="false" Description="DesignacaoComercial" Name="DesignacaoComercial" />
    <Item5 Ref="8" Visible="false" Description="Morada" Name="Morada" />
    <Item6 Ref="9" Visible="false" Description="Localidade" Name="Localidade" />
    <Item7 Ref="10" Visible="false" Description="CodigoPostal" Name="CodigoPostal" />
    <Item8 Ref="11" Visible="false" Description="Sigla" Name="Sigla" />
    <Item9 Ref="12" Visible="false" Description="NIF" Name="NIF" />
    <Item10 Ref="13" Visible="false" Description="MoradaSede" Name="MoradaSede" />
    <Item11 Ref="14" Visible="false" Description="CodigoPostalSede" Name="CodigoPostalSede" />
    <Item12 Ref="15" Visible="false" Description="LocalidadeSede" Name="LocalidadeSede" />
    <Item13 Ref="16" Visible="false" Description="TelefoneSede" Name="TelefoneSede" />
    <Item14 Ref="17" Visible="false" Description="IDLojaSede" ValueInfo="0" Name="IDLojaSede" Type="#Ref-2" />
    <Item15 Ref="18" Description="UrlServerPath" AllowNull="true" Name="UrlServerPath" />
  </Parameters>
  <Bands>
    <Item1 Ref="19" ControlType="TopMarginBand" Name="TopMargin" HeightF="3" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="20" ControlType="ReportHeaderBand" Name="ReportHeaderBand1" HeightF="108.1251">
      <Controls>
        <Item1 Ref="21" ControlType="XRLabel" Name="fldMoradaSede" TextAlignment="TopLeft" SizeF="221.868,15.00001" LocationFloat="395.6411, 62.00003" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="22" Expression="[MoradaSede]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="23" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="24" ControlType="XRLabel" Name="fldCodigoPostalSede" SizeF="221.8679,13.99997" LocationFloat="395.6411, 77.00005" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="25" Expression="[CodigoPostalSede]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="26" UseFont="false" UseBorderWidth="false" />
        </Item2>
        <Item3 Ref="27" ControlType="XRLabel" Name="fldTelefoneSede" SizeF="199.7701,13.99999" LocationFloat="417.7389, 91.00001" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="28" Expression="[TelefoneSede]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="29" UseFont="false" />
        </Item3>
        <Item4 Ref="30" ControlType="XRLabel" Name="lblTelefoneSede" Text="Tel." TextAlignment="TopLeft" SizeF="22.10526,13.99995" LocationFloat="395.6337, 91.00008" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
          <StylePriority Ref="31" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="32" ControlType="XRLabel" Name="LabelSede" Text="Sede" SizeF="221.8755,14" LocationFloat="395.6411, 48.00003" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="33" UseFont="false" />
        </Item5>
        <Item6 Ref="34" ControlType="XRLabel" Name="lblEmail" Text="Email:" TextAlignment="TopLeft" SizeF="27.20552,13.99998" LocationFloat="137.3999, 91.00002" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
          <StylePriority Ref="35" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="36" ControlType="XRLabel" Name="fldConservatoria" Text="Cap.Soc." TextAlignment="TopLeft" SizeF="241.6594,13.99998" LocationFloat="137.3, 77.00005" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
          <StylePriority Ref="37" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="38" ControlType="XRLabel" Name="lblTelefone" Text="Tel." TextAlignment="TopLeft" SizeF="22.10529,14" LocationFloat="137.3999, 48.00003" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
          <StylePriority Ref="39" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="40" ControlType="XRLabel" Name="fldTelefone" Text="fldTelefone" SizeF="219.4542,14.00001" LocationFloat="159.5052, 48.00003" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="41" Expression="[Telefone]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="42" UseFont="false" />
        </Item9>
        <Item10 Ref="43" ControlType="XRLabel" Name="fldEmail" Text="fldEmail" TextAlignment="TopLeft" SizeF="214.354,13.99998" LocationFloat="164.6055, 91.00005" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="44" Expression="[Email]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="45" UseFont="false" UseTextAlignment="false" />
        </Item10>
        <Item11 Ref="46" ControlType="XRLabel" Name="fldCodigoPostal" Text="fldCodigoPostal" SizeF="241.5595,14" LocationFloat="137.3999, 34" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <StylePriority Ref="47" UseFont="false" UseBorderWidth="false" />
        </Item11>
        <Item12 Ref="48" ControlType="XRLabel" Name="lblNIF" Text="Contribuinte nº" TextAlignment="TopLeft" SizeF="74.39218,15" LocationFloat="137.3999, 62.00005" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
          <StylePriority Ref="49" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="50" ControlType="XRLabel" Name="fldNIF" Text="fldNIF" TextAlignment="TopLeft" SizeF="167.1673,15" LocationFloat="211.7921, 62.00005" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="51" Expression="[NIF]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="52" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item13>
        <Item14 Ref="53" ControlType="XRLabel" Name="fldMorada" Text="fldMorada" TextAlignment="TopLeft" SizeF="241.6594,14" LocationFloat="137.3, 20" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="54" Expression="[Morada]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="55" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item14>
        <Item15 Ref="56" ControlType="XRLabel" Name="fldDesignacaoComercial" Text="fldDesignacaoComercial" TextAlignment="TopLeft" SizeF="480.1089,20" LocationFloat="137.3999, 0" Font="Arial, 9pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="57" Expression="[DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="58" UseFont="false" UseTextAlignment="false" />
        </Item15>
        <Item16 Ref="59" ControlType="XRPictureBox" Name="picLogotipo" Sizing="ZoomImage" ImageAlignment="TopLeft" SizeF="121.4168,94.46" LocationFloat="0, 0">
          <ExpressionBindings>
            <Item1 Ref="60" Expression="?UrlServerPath + [FotoCaminho] + [Foto]" PropertyName="ImageUrl" EventName="BeforePrint" />
          </ExpressionBindings>
          <Scripts Ref="61" OnBeforePrint="picLogotipo_BeforePrint" />
        </Item16>
      </Controls>
    </Item2>
    <Item3 Ref="62" ControlType="DetailBand" Name="Detail" Expanded="false" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item4 Ref="63" ControlType="PageFooterBand" Name="PageFooterBand1" HeightF="0.8749962" />
    <Item5 Ref="64" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="4" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <StyleSheet>
    <Item1 Ref="65" Name="Title" BorderStyle="Inset" Font="Times New Roman, 20pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item2 Ref="66" Name="FieldCaption" BorderStyle="Inset" Font="Arial, 10pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item3 Ref="67" Name="PageInfo" BorderStyle="Inset" Font="Times New Roman, 10pt, style=Bold" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item4 Ref="68" Name="DataField" BorderStyle="Inset" Padding="2,2,0,0,100" Font="Times New Roman, 10pt" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
  </StyleSheet>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="2" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9cHJpc21hLWxhYi12bS53ZXN0ZXVyb3BlLmNsb3VkYXBwLmF6dXJlLmNvbSwxNDMzO1VzZXIgSUQ9RjNNTztQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID0xMDAwMEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJQYXJhbWV0cm9zTG9qYSI+PFBhcmFtZXRlciBOYW1lPSJJRExvamEiIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKFtQYXJhbWV0ZXJzLklETG9qYV0pPC9QYXJhbWV0ZXI+PFNxbD5zZWxlY3QgInRiUGFyYW1ldHJvc0xvamFTZWRlIi4iSUQiICJJRExvamFTZWRlIiwNCgkgICAidGJQYXJhbWV0cm9zTG9qYVNlZGUiLiJNb3JhZGEiICJNb3JhZGFTZWRlIiwNCgkgICAidGJQYXJhbWV0cm9zTG9qYVNlZGUiLiJDb2RpZ29Qb3N0YWwiICJDb2RpZ29Qb3N0YWxTZWRlIiwNCgkgICAidGJQYXJhbWV0cm9zTG9qYVNlZGUiLiJMb2NhbGlkYWRlIiAiTG9jYWxpZGFkZVNlZGUiLA0KCSAgICJ0YlBhcmFtZXRyb3NMb2phU2VkZSIuVGVsZWZvbmUgIlRlbGVmb25lU2VkZSIsDQoJICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRE1vZWRhRGVmZWl0byIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJNb3JhZGEiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRm90byIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJGb3RvQ2FtaW5obyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJEZXNpZ25hY2FvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNvZGlnb1Bvc3RhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJMb2NhbGlkYWRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNvbmNlbGhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkRpc3RyaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklEUGFpcyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJUZWxlZm9uZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJGYXgiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRW1haWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iV2ViU2l0ZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJOSUYiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJDYXBpdGFsU29jaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRExvamEiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iSURJZGlvbWFCYXNlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIlNpc3RlbWEiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQXRpdm8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRGF0YUNyaWFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iVXRpbGl6YWRvckNyaWFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRGF0YUFsdGVyYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJVdGlsaXphZG9yQWx0ZXJhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkYzTU1hcmNhZG9yIiwNCiAgICAgICAidGJNb2VkYXMiLiJTaW1ib2xvIiwNCiAgICAgICAidGJNb2VkYXMiLiJUYXhhQ29udmVyc2FvIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW9EZWNpbWFsIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW9JbnRlaXJhIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzSXZhIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiwNCiAgICAgICAidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIi5TaWdsYQ0KZnJvbSAiZGJvIi4idGJMb2phcyIgInRiTG9qYXMiDQppbm5lciBqb2luICJkYm8iLiJ0YkxvamFzIiAidGJMb2phc1NlZGUiIG9uICJ0YkxvamFzIi5pZGxvamFzZWRlPSJ0YkxvamFzU2VkZSIuaWQNCmxlZnQgam9pbiAiZGJvIi4idGJwYXJhbWV0cm9zbG9qYSIgInRicGFyYW1ldHJvc2xvamEiIG9uICJ0YkxvamFzIi5pZD0idGJwYXJhbWV0cm9zbG9qYSIuaWRsb2phDQpsZWZ0IGpvaW4gImRibyIuInRicGFyYW1ldHJvc2xvamEiICJ0YnBhcmFtZXRyb3Nsb2phc2VkZSIgb24gInRiTG9qYXNTZWRlIi5pZD0idGJwYXJhbWV0cm9zbG9qYXNlZGUiLmlkbG9qYQ0KbGVmdCBqb2luICJkYm8iLiJ0Yk1vZWRhcyIgInRiTW9lZGFzIiBvbiAidGJNb2VkYXMiLiJJRCIgPSAidGJQYXJhbWV0cm9zTG9qYSIuIklETW9lZGFEZWZlaXRvIg0KbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiIG9uICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiLiJJRCIgPSAidGJQYXJhbWV0cm9zTG9qYSIuIklEUGFpcyINCndoZXJlICJ0YkxvamFzIi5JRCA9IEBJRExvamE8L1NxbD48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQ+PFZpZXcgTmFtZT0idGJQYXJhbWV0cm9zTG9qYSI+PEZpZWxkIE5hbWU9IklETG9qYVNlZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFTZWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbFNlZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZVNlZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGVsZWZvbmVTZWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURNb2VkYURlZmVpdG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvQ2FtaW5obyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNpZ25hY2FvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJMb2NhbGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZheCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJXZWJTaXRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik5JRiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhcGl0YWxTb2NpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJJRExvamEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRElkaW9tYUJhc2UiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvciIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJTaW1ib2xvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvRGVjaW1hbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9JbnRlaXJhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNUb3RhaXMiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNJdmEiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IlNpZ2xhIiBUeXBlPSJTdHJpbmciIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''

update tbMapasVistas set SubReport=1, MapaXML = @ptrvalCabecalho where id = @IDSubCabecalho


INSERT INTO tbMapasVistas ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], [PorDefeito])
SELECT (SELECT MAX(ordem) FROM [dbo].[tbMapasVistas] WHERE entidade = ''DocumentosVendas'') + 1 ordem, [Entidade], ''Doc. Venda - Formas Pagamento'' Descricao , ''DocumentosVendasFormasPagamento'' [NomeMapa], '''' [Caminho], [Certificado], [IDLoja], null [SQLQuery], [Listagem], [Ativo], [Sistema], GetDate() [DataCriacao], N''F3M'' [UtilizadorCriacao], NULL [DataAlteracao],
NULL [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], 0 [PorDefeito]
FROM [dbo].[tbMapasVistas] where NomeMapa = ''rptDocumentosVendasA5H''

Declare @IDSubFormasPagamento As bigint;
SET @IDSubFormasPagamento = SCOPE_IDENTITY();
DECLARE @ptrvalFormasPagamento xml;  
SET @ptrvalFormasPagamento = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosVendasFormasPagamento" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Microsoft.VisualBasic&#xD;&#xA;Imports system.data&#xD;&#xA;Imports DevExpress.DataAccess.Native.Sql&#xD;&#xA;Imports System.ComponentModel&#xD;&#xA;Imports System.Linq&#xD;&#xA;Imports System.Collections.Generic&#xD;&#xA;Imports Reporting.Constantes.SaftAT&#xD;&#xA;&#xD;&#xA;Private Sub DocumentosVendasFormasPagamento_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim querySQL = Me.Parameters.Item(&quot;Formas&quot;).Value&#xD;&#xA;    Dim numCasasDecimais = Me.Parameters.Item(&quot;NumeroCasasDecimais&quot;).Value&#xD;&#xA;    Dim simboloMoeda = Me.Parameters.Item(&quot;Simbolo&quot;).Value&#xD;&#xA;&#xD;&#xA;    If querySQL &lt;&gt; String.Empty Then&#xD;&#xA;        Dim idDocumento = Me.Parameters.Item(&quot;IDDocumento&quot;).Value&#xD;&#xA;&#xD;&#xA;        Dim query = sender.DataSource.Queries(0)&#xD;&#xA;        query.Sql = querySQL.replace(&quot;where tbRecibos.ID=&quot;, &quot;where tbRecibos.ID=&quot; &amp; idDocumento &amp; &quot; &quot;).replace(&quot;where tbDocumentosVendas.ID=&quot;, &quot;where tbDocumentosVendas.ID=&quot; &amp; idDocumento &amp; &quot; &quot;)&#xD;&#xA;        sender.DataSource.Fill()&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;    &#xD;&#xA;    Dim rs As ResultSet = TryCast(TryCast(sender.DataSource, IListSource).GetList(), ResultSet)&#xD;&#xA;    Dim rsDV As ResultTable = rs.Tables.FirstOrDefault(Function(x) x.TableName.Equals(&quot;tbFormasPagamento&quot;))&#xD;&#xA;&#xD;&#xA;    If Not rsDV Is Nothing andalso rsDV.Count &gt; 0 Then&#xD;&#xA;        Me.lblTitulo.Text = resource.GetResource(&quot;FormasPagamento&quot;, culture)&#xD;&#xA;        Me.lblValorEntregue.Text = simboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;ValorEntregue&quot;, culture)&#xD;&#xA;        Me.lblTroco.Text = simboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Troco&quot;, culture)&#xD;&#xA;        &#xD;&#xA;        Me.lblTitulo.Visible = True&#xD;&#xA;        Me.lblTroco.Visible = True&#xD;&#xA;        Me.lblValorEntregue.Visible = True&#xD;&#xA;    Else&#xD;&#xA;        Me.lblTitulo.Visible = False&#xD;&#xA;        Me.lblTroco.Visible = False&#xD;&#xA;        Me.lblValorEntregue.Visible = False&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;" Margins="7, 100, 0, 0" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="19.1" DataSource="#Ref-0">
  <Parameters>
    <Item1 Ref="3" Description="IDDocumento" ValueInfo="883" Name="IDDocumento" Type="#Ref-2" />
    <Item2 Ref="5" Visible="false" Description="Culture" Name="Culture" />
    <Item3 Ref="6" Visible="false" Description="Formas" ValueInfo="select distinct tbDocumentosVendas.ID, tbDocumentosVendasFormasPagamento.IDFormaPagamento, tbFormasPagamento.Descricao, tbDocumentosVendasFormasPagamento.Valor,  tbDocumentosVendasFormasPagamento.ValorEntregue,  tbDocumentosVendasFormasPagamento.Troco from tbDocumentosVendas inner join tbDocumentosVendasFormasPagamento on tbDocumentosVendasFormasPagamento.IDDocumentoVenda = tbDocumentosVendas.ID inner join tbFormasPagamento on tbDocumentosVendasFormasPagamento.IDFormaPagamento=tbFormasPagamento.ID where tbDocumentosVendas.ID=" Name="Formas" />
    <Item4 Ref="8" Visible="false" Description="NumeroCasasDecimais" ValueInfo="0" Name="NumeroCasasDecimais" Type="#Ref-7" />
    <Item5 Ref="9" Visible="false" Description="Simbolo" Name="Simbolo" />
    <Item6 Ref="10" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="11" Name="SomaTotalIVA" FieldType="Float" DisplayName="SomaTotalIVA" Expression="[].Sum([TotalIVA])" DataMember="tbDocumentosVendasIVA" />
    <Item2 Ref="12" Name="SomaTotalIncidencia" FieldType="Float" DisplayName="SomaTotalIncidencia" Expression="[].Sum([TotalIncidencia])" DataMember="tbDocumentosVendasIVA" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="13" ControlType="TopMarginBand" Name="TopMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="14" ControlType="PageHeaderBand" Name="PageHeader" HeightF="15.78572">
      <Controls>
        <Item1 Ref="15" ControlType="XRLabel" Name="lblTitulo" TextAlignment="MiddleLeft" SizeF="131.6951,12" LocationFloat="25.89286, 1" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Visible="false">
          <StylePriority Ref="16" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="17" ControlType="XRLabel" Name="lblTroco" TextAlignment="MiddleRight" SizeF="54.05638,12" LocationFloat="244.7116, 1.000002" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Visible="false">
          <StylePriority Ref="18" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="19" ControlType="XRLabel" Name="lblValorEntregue" TextAlignment="MiddleRight" SizeF="87.12363,12" LocationFloat="157.588, 1.000002" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Visible="false">
          <StylePriority Ref="20" UseFont="false" UseTextAlignment="false" />
        </Item3>
      </Controls>
    </Item2>
    <Item3 Ref="21" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item4 Ref="22" ControlType="DetailReportBand" Name="DetailReport" Level="0" DataMember="tbFormasPagamento" DataSource="#Ref-0">
      <Bands>
        <Item1 Ref="23" ControlType="DetailBand" Name="Detail1" HeightF="13.82177">
          <Controls>
            <Item1 Ref="24" ControlType="XRLabel" Name="fldValorEntregue" TextFormatString="{0:n2}" Text="fldValorEntregue" TextAlignment="TopRight" SizeF="87.12361,12" LocationFloat="157.588, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="25" Expression="[tbFormasPagamento.ValorEntregue]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="26" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="27" ControlType="XRLabel" Name="fldTroco" TextFormatString="{0:n2}" Text="fldTroco" TextAlignment="TopRight" SizeF="54.0551,12" LocationFloat="244.7116, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="28" Expression="[tbFormasPagamento.Troco]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="29" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="30" ControlType="XRLabel" Name="fldTitulo" Text="fldTitulo" SizeF="131.6951,12" LocationFloat="25.89286, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="31" Expression="[tbFormasPagamento.Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="32" UseFont="false" />
            </Item3>
          </Controls>
        </Item1>
      </Bands>
    </Item4>
    <Item5 Ref="33" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="34" OnBeforePrint="DocumentosVendasFormasPagamento_BeforePrint" />
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="2" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="7" Content="System.Int32" Type="System.Type" />
    <Item3 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9cHJpc21hLWxhYi12bS53ZXN0ZXVyb3BlLmNsb3VkYXBwLmF6dXJlLmNvbSwxNDMzO1VzZXIgSUQ9RjNNTztQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID0xMDAwMEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJGb3JtYXNQYWdhbWVudG8iPjxQYXJhbWV0ZXIgTmFtZT0iSUREb2N1bWVudG8iIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKFtQYXJhbWV0ZXJzLklERG9jdW1lbnRvXSk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCBkaXN0aW5jdCB0YkRvY3VtZW50b3NWZW5kYXMuSUQsIHRiRG9jdW1lbnRvc1ZlbmRhc0Zvcm1hc1BhZ2FtZW50by5JREZvcm1hUGFnYW1lbnRvLCB0YkZvcm1hc1BhZ2FtZW50by5EZXNjcmljYW8sIHRiRG9jdW1lbnRvc1ZlbmRhc0Zvcm1hc1BhZ2FtZW50by5WYWxvciwgIHRiRG9jdW1lbnRvc1ZlbmRhc0Zvcm1hc1BhZ2FtZW50by5WYWxvckVudHJlZ3VlLCAgdGJEb2N1bWVudG9zVmVuZGFzRm9ybWFzUGFnYW1lbnRvLlRyb2NvDQpmcm9tIHRiRG9jdW1lbnRvc1ZlbmRhcyBpbm5lciBqb2luIHRiRG9jdW1lbnRvc1ZlbmRhc0Zvcm1hc1BhZ2FtZW50byBvbiB0YkRvY3VtZW50b3NWZW5kYXNGb3JtYXNQYWdhbWVudG8uSUREb2N1bWVudG9WZW5kYSA9IHRiRG9jdW1lbnRvc1ZlbmRhcy5JRA0KaW5uZXIgam9pbiB0YkZvcm1hc1BhZ2FtZW50byBvbiB0YkRvY3VtZW50b3NWZW5kYXNGb3JtYXNQYWdhbWVudG8uSURGb3JtYVBhZ2FtZW50bz0gdGJGb3JtYXNQYWdhbWVudG8uSUQNCndoZXJlIHRiRG9jdW1lbnRvc1ZlbmRhcy5JRD04ODM8L1NxbD48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQ+PFZpZXcgTmFtZT0idGJGb3JtYXNQYWdhbWVudG8iPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERm9ybWFQYWdhbWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmFsb3IiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JFbnRyZWd1ZSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUcm9jbyIgVHlwZT0iRG91YmxlIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''

update tbMapasVistas set SubReport=1, MapaXML = @ptrvalFormasPagamento where id = @IDSubFormasPagamento


INSERT INTO tbMapasVistas ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], [PorDefeito])
SELECT (SELECT MAX(ordem) FROM [dbo].[tbMapasVistas] WHERE entidade = ''DocumentosVendas'') + 1 ordem, [Entidade], ''Doc. Venda - Motivos Isenção'' Descricao , ''DocumentosVendasMotivosIsencao'' [NomeMapa], '''' [Caminho], [Certificado], [IDLoja], null [SQLQuery], [Listagem], [Ativo], [Sistema], GetDate() [DataCriacao], N''F3M'' [UtilizadorCriacao], NULL [DataAlteracao],
NULL [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], 0 [PorDefeito]
FROM [dbo].[tbMapasVistas] where NomeMapa = ''rptDocumentosVendasA5H''

Declare @IDSubMotivosIsencao As bigint;
SET @IDSubMotivosIsencao = SCOPE_IDENTITY();
DECLARE @ptrvalMotivosIsencao xml;  
SET @ptrvalMotivosIsencao = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosVendasMotivosIsencao" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Microsoft.VisualBasic&#xD;&#xA;Imports DevExpress.DataAccess.Native.Sql&#xD;&#xA;Imports System.ComponentModel&#xD;&#xA;Imports System.Linq&#xD;&#xA;&#xD;&#xA;Private Sub DocumentosVendasMotivosIsencao_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    Me.lblTaxa.Text = resource.GetResource(&quot;Taxa&quot;, culture)&#xD;&#xA;    Me.lblMotivosIsencao.Text = resource.GetResource(&quot;MotivosIsencao&quot;, culture)&#xD;&#xA;&#xD;&#xA;    Dim simboloMoeda As String = Convert.ToString(GetCurrentColumnValue(&quot;tbMoedas_Simbolo&quot;))&#xD;&#xA;    Dim numCasasDecimais As Int16 = Convert.ToInt16(GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;&#xD;&#xA;    Me.lblValorIncidencia.Text = simboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Incidencia&quot;, culture)&#xD;&#xA;    Me.lblValorIva.Text = simboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Iva&quot;, culture)&#xD;&#xA;&#xD;&#xA;    Me.fldTaxaIva.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(2, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;    Me.fldValorIncidencia.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(numCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;    Me.fldTotalIncidencia.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(numCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    numCasasDecimais = Convert.ToInt16(GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisIva&quot;))&#xD;&#xA;&#xD;&#xA;    Me.fldValorIva.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(numCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;    Me.fldTotalIva.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(numCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblMotivosIsencao_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim lstQueries As ResultSet = TryCast(TryCast(sender.RootReport.DataSource, IListSource).GetList(), ResultSet)&#xD;&#xA;    Dim resQuery As ResultTable = lstQueries.Tables.FirstOrDefault(Function(x) x.TableName.Equals(&quot;tbDocumentosVendasMotivosIsencao&quot;))&#xD;&#xA;&#xD;&#xA;    If resQuery IsNot Nothing Then&#xD;&#xA;        Dim temMotivosIsencao As Boolean = False&#xD;&#xA;&#xD;&#xA;        For index As Integer = 0 To resQuery.Count&#xD;&#xA;            Dim linhaArtigo As ResultRow = resQuery.Item(index)&#xD;&#xA;            Dim motivoIsencao = linhaArtigo.ElementAt(1)&#xD;&#xA;&#xD;&#xA;            If motivoIsencao IsNot Nothing Then&#xD;&#xA;                temMotivosIsencao = True&#xD;&#xA;                Exit For&#xD;&#xA;            End If&#xD;&#xA;        Next&#xD;&#xA;&#xD;&#xA;        If Not temMotivosIsencao Then e.Cancel = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldDescricao_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    If Me.fldTaxaIva.Text = String.Empty OrElse CDbl(Me.fldTaxaIva.Text) = 0 Then&#xD;&#xA;        Me.fldDescricao.Visible = True&#xD;&#xA;    Else&#xD;&#xA;        Me.fldDescricao.Visible = False&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldCodigo_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    If Me.fldTaxaIva.Text = String.Empty OrElse CDbl(Me.fldTaxaIva.Text) = 0 Then&#xD;&#xA;        Me.fldCodigo.Visible = True&#xD;&#xA;    Else&#xD;&#xA;        Me.fldCodigo.Visible = False&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;" Margins="7, 496, 0, 0" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="19.1" FilterString="[IDDocumentoVenda] = ?IDDocumento" DataMember="CustomSqlQuery" DataSource="#Ref-0">
  <Parameters>
    <Item1 Ref="3" Description="IDDocumento" ValueInfo="378" Name="IDDocumento" Type="#Ref-2" />
    <Item2 Ref="5" Visible="false" Description="Culture" Name="Culture" />
    <Item3 Ref="6" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item4 Ref="8" Visible="false" Description="NumeroCasasDecimais" ValueInfo="0" Name="NumeroCasasDecimais" Type="#Ref-7" />
    <Item5 Ref="9" Visible="false" Description="Simbolo" Name="Simbolo" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="10" Name="SomaTotalIVA" FieldType="Float" DisplayName="SomaTotalIVA" Expression="[].Sum([TotalIVA])" DataMember="tbDocumentosVendasMotivosIsencao" />
    <Item2 Ref="11" Name="SomaTotalIncidencia" FieldType="Float" DisplayName="SomaTotalIncidencia" Expression="[].Sum([TotalIncidencia])" DataMember="tbDocumentosVendasMotivosIsencao" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="12" ControlType="TopMarginBand" Name="TopMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="13" ControlType="PageHeaderBand" Name="PageHeader" HeightF="15.16102">
      <Controls>
        <Item1 Ref="14" ControlType="XRLabel" Name="lblTaxa" Text="Taxa" TextAlignment="MiddleRight" SizeF="37.66664,12" LocationFloat="204.3453, 1.000008" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="15" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="16" ControlType="XRLabel" Name="lblValorIva" Text="Iva" TextAlignment="MiddleRight" SizeF="38.83,12" LocationFloat="308.17, 1.000008" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="17" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="18" ControlType="XRLabel" Name="lblMotivosIsencao" Text="Motivos de Isenção" TextAlignment="MiddleLeft" SizeF="204.3453,12" LocationFloat="0, 1.000008" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <Scripts Ref="19" OnBeforePrint="lblMotivosIsencao_BeforePrint" />
          <StylePriority Ref="20" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="21" ControlType="XRLabel" Name="lblValorIncidencia" Text="Incidência" TextAlignment="MiddleRight" SizeF="66.1581,12" LocationFloat="242.0119, 1.000008" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="22" UseFont="false" UseTextAlignment="false" />
        </Item4>
      </Controls>
    </Item2>
    <Item3 Ref="23" ControlType="DetailBand" Name="Detail" KeepTogetherWithDetailReports="true" Expanded="false" HeightF="12" KeepTogether="true" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item4 Ref="24" ControlType="DetailReportBand" Name="DetailReport" Level="0" FilterString="[IDDocumentoVenda] = ?IDDocumento" DataMember="tbDocumentosVendasMotivosIsencao" DataSource="#Ref-0">
      <Bands>
        <Item1 Ref="25" ControlType="DetailBand" Name="Detail1" HeightF="13.13159">
          <Controls>
            <Item1 Ref="26" ControlType="XRLabel" Name="fldValorIva" Text="fldValorIva" TextAlignment="BottomRight" SizeF="38.83011,12" LocationFloat="308.17, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="27" Expression="FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [TotalIVA])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="28" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="29" ControlType="XRLabel" Name="fldValorIncidencia" Text="fldValorIncidencia" TextAlignment="BottomRight" SizeF="66.1581,12" LocationFloat="242.0119, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="30" Expression="FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [TotalIncidencia])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="31" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="32" ControlType="XRLabel" Name="fldTaxaIva" TextFormatString="{0:0.00}" TextAlignment="BottomRight" SizeF="37.66664,12" LocationFloat="204.3453, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="33" Expression="[TaxaIva]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="34" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="35" ControlType="XRLabel" Name="fldDescricao" Text="fldDescricao" TextAlignment="TopLeft" SizeF="168.716,12" LocationFloat="35.62926, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <Scripts Ref="36" OnBeforePrint="fldDescricao_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="37" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="38" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="39" ControlType="XRLabel" Name="fldCodigo" Text="fldCodigo" TextAlignment="TopLeft" SizeF="35.62927,12" LocationFloat="0, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <Scripts Ref="40" OnBeforePrint="fldCodigo_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="41" Expression="[Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="42" UseFont="false" UseTextAlignment="false" />
            </Item5>
          </Controls>
        </Item1>
        <Item2 Ref="43" ControlType="GroupFooterBand" Name="GroupFooter1" HeightF="15.08333">
          <Controls>
            <Item1 Ref="44" ControlType="XRLine" Name="XrLine2" SizeF="90.83,2.08" LocationFloat="256.17, 0.003331404" />
            <Item2 Ref="45" ControlType="XRLabel" Name="fldTotalIncidencia" Text="fldTotalIncidencia" TextAlignment="MiddleRight" SizeF="56.00336,13" LocationFloat="252.1667, 2.083334" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="46" Expression="FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [SomaTotalIncidencia] )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="47" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="48" ControlType="XRLabel" Name="fldTotalIva" Text="fldTotalIva" TextAlignment="MiddleRight" SizeF="38.83014,13" LocationFloat="308.17, 2.083334" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="49" Expression="FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [SomaTotalIVA])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="50" UseFont="false" UseTextAlignment="false" />
            </Item3>
          </Controls>
        </Item2>
      </Bands>
    </Item4>
    <Item5 Ref="51" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="52" OnBeforePrint="DocumentosVendasMotivosIsencao_BeforePrint" />
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="2" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="7" Content="System.Int32" Type="System.Type" />
    <Item3 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Name="SqlDataSource" Base64="PFNxbERhdGFTb3VyY2UgTmFtZT0iU3FsRGF0YVNvdXJjZSI+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9cHJpc21hLWxhYi12bS53ZXN0ZXVyb3BlLmNsb3VkYXBwLmF6dXJlLmNvbSwxNDMzO1VzZXIgSUQ9RjNNTztQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID0xMDAwMEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJEb2N1bWVudG9zVmVuZGFzTW90aXZvc0lzZW5jYW8iPjxQYXJhbWV0ZXIgTmFtZT0iSUREb2N1bWVudG8iIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKFtQYXJhbWV0ZXJzLklERG9jdW1lbnRvXSk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCBkaXN0aW5jdCB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMuSUREb2N1bWVudG9WZW5kYSwgdGJTaXN0ZW1hQ29kaWdvc0lWQS5Db2RpZ28sIHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcy5Nb3Rpdm9Jc2VuY2FvSXZhIGFzIERlc2NyaWNhbywgDQpzdW0odGJEb2N1bWVudG9zVmVuZGFzTGluaGFzLlZhbG9ySW5jaWRlbmNpYSkgYXMgVmFsb3JJbmNpZGVuY2lhLCANCnRiTW9lZGFzLlNpbWJvbG8gYXMgdGJNb2VkYXNfU2ltYm9sbywgdGJNb2VkYXMuQ2FzYXNEZWNpbWFpc1RvdGFpcyBhcyB0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzLCB0Yk1vZWRhcy5DYXNhc0RlY2ltYWlzSXZhIGFzIHRiTW9lZGFzX0Nhc2FzRGVjaW1haXNJdmEsIA0KInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlRheGFJdmEiLA0Kc3VtKCJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJWYWxvckluY2lkZW5jaWEiKSBhcyBUb3RhbEluY2lkZW5jaWEsDQpzdW0oInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlZhbG9ySVZBIikgYXMgVG90YWxJVkENCmZyb20gImRibyIuInRiRG9jdW1lbnRvc1ZlbmRhcyIgInRiRG9jdW1lbnRvc1ZlbmRhcyINCmlubmVyIGpvaW4gImRibyIuInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIgb24gInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIklERG9jdW1lbnRvVmVuZGEiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEIg0KbGVmdCBqb2luIHRiU2lzdGVtYUNvZGlnb3NJVkEgb24gdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzLkNvZGlnb01vdGl2b0lzZW5jYW9JdmE9IHRiU2lzdGVtYUNvZGlnb3NJVkEuQ29kaWdvDQpsZWZ0IGpvaW4gdGJNb2VkYXMgb24gdGJNb2VkYXMuSUQ9IHRiRG9jdW1lbnRvc1ZlbmRhcy5JRE1vZWRhDQp3aGVyZSB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMuSUREb2N1bWVudG9WZW5kYT1ASUREb2N1bWVudG8NCmdyb3VwIGJ5ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRCIsInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlRheGFJdmEiLCB0YlNpc3RlbWFDb2RpZ29zSVZBLkNvZGlnbywgdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzLk1vdGl2b0lzZW5jYW9JdmEsIHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcy5JRERvY3VtZW50b1ZlbmRhLCB0Yk1vZWRhcy5TaW1ib2xvLCB0Yk1vZWRhcy5DYXNhc0RlY2ltYWlzVG90YWlzLHRiTW9lZGFzLkNhc2FzRGVjaW1haXNJdmE8L1NxbD48L1F1ZXJ5PjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0iQ3VzdG9tU3FsUXVlcnkiPjxQYXJhbWV0ZXIgTmFtZT0iSWREb2MiIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKD9JRERvY3VtZW50byk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCB0b3AgMSAidGJTaXN0ZW1hQ29kaWdvc0lWQSIuIkNvZGlnbyIgZnJvbSAoKCgiZGJvIi4idGJEb2N1bWVudG9zVmVuZGFzIiAidGJEb2N1bWVudG9zVmVuZGFzIg0KIGlubmVyIGpvaW4gImRibyIuInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIgb24gKCJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJJRERvY3VtZW50b1ZlbmRhIiA9ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRCIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hQ29kaWdvc0lWQSIgInRiU2lzdGVtYUNvZGlnb3NJVkEiIG9uICgidGJTaXN0ZW1hQ29kaWdvc0lWQSIuIkNvZGlnbyIgPSAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iQ29kaWdvTW90aXZvSXNlbmNhb0l2YSIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJNb2VkYXMiICJ0Yk1vZWRhcyIgb24gKCJ0Yk1vZWRhcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRE1vZWRhIikpDQp3aGVyZSAoInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIklEIiA9IEBJZERvYykNCjwvU3FsPjwvUXVlcnk+PFJlc3VsdFNjaGVtYT48RGF0YVNldCBOYW1lPSJTcWxEYXRhU291cmNlIj48VmlldyBOYW1lPSJDdXN0b21TcWxRdWVyeSI+PEZpZWxkIE5hbWU9IkNvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48VmlldyBOYW1lPSJ0YkRvY3VtZW50b3NWZW5kYXNNb3Rpdm9zSXNlbmNhbyI+PEZpZWxkIE5hbWU9IklERG9jdW1lbnRvVmVuZGEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW5jaWRlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19TaW1ib2xvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0Nhc2FzRGVjaW1haXNUb3RhaXMiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0Nhc2FzRGVjaW1haXNJdmEiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IlRheGFJdmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxJbmNpZGVuY2lhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsSVZBIiBUeXBlPSJEb3VibGUiIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''

update tbMapasVistas set SubReport=1, MapaXML = @ptrvalMotivosIsencao where id = @IDSubMotivosIsencao


INSERT INTO tbMapasVistas ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], [PorDefeito])
SELECT (SELECT MAX(ordem) FROM [dbo].[tbMapasVistas] WHERE entidade = ''DocumentosVendas'') + 1 ordem, [Entidade], ''Doc. Venda - Observações'' Descricao , ''DocumentosVendasObservacoes'' [NomeMapa], '''' [Caminho], [Certificado], [IDLoja], null [SQLQuery], [Listagem], [Ativo], [Sistema], GetDate() [DataCriacao], N''F3M'' [UtilizadorCriacao], NULL [DataAlteracao],
NULL [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [Tabela], [Geral], 0 [PorDefeito]
FROM [dbo].[tbMapasVistas] where NomeMapa = ''rptDocumentosVendasA5H''

Declare @IDSubObservacoes As bigint;
SET @IDSubObservacoes = SCOPE_IDENTITY();
DECLARE @ptrvalObservacoes xml;  
SET @ptrvalObservacoes = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosVendasObservacoes" ScriptsSource="Imports Reporting&#xD;&#xA;&#xD;&#xA;Private Sub DocumentosVendasObservacoes_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim querySQL = Me.Parameters.Item(&quot;Observacoes&quot;).Value&#xD;&#xA;    Dim idDocumento = Me.Parameters.Item(&quot;IDDocumento&quot;).Value&#xD;&#xA;    &#xD;&#xA;    Dim query = sender.DataSource.Queries(0)&#xD;&#xA;    query.Sql = querySQL &amp; idDocumento&#xD;&#xA;    sender.DataSource.Fill()&#xD;&#xA;&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    Me.lblObservacoes.Text = resource.GetResource(&quot;Observacoes&quot;, culture)&#xD;&#xA;    fldObservacoes.Text = Convert.ToString(GetCurrentColumnValue(&quot;Observacoes&quot;))&#xD;&#xA;&#xD;&#xA;    Dim acompanhaBens As Boolean = Me.Parameters(&quot;AcompanhaBens&quot;).Value&#xD;&#xA;&#xD;&#xA;    If acompanhaBens Then&#xD;&#xA;        Dim strFraseFiscal = Me.Parameters.Item(&quot;FraseFiscal&quot;).Value&#xD;&#xA;&#xD;&#xA;        If strFraseFiscal &lt;&gt; String.Empty Then&#xD;&#xA;            fldFraseFiscal.Text = resource.GetResource(strFraseFiscal, culture)&#xD;&#xA;        End If&#xD;&#xA;    Else&#xD;&#xA;        fldFraseFiscal.Visible = False&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;" SnapGridSize="0.1" Margins="0, 97, 0, 0" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="19.1" DataMember="tbDocumentos" DataSource="#Ref-0">
  <Parameters>
    <Item1 Ref="3" Visible="false" Description="Culture" Name="Culture" />
    <Item2 Ref="4" Visible="false" Description="Observacoes" Name="Observacoes" />
    <Item3 Ref="6" Visible="false" Description="IDDocumento" ValueInfo="0" Name="IDDocumento" Type="#Ref-5" />
    <Item4 Ref="7" Visible="false" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-5" />
    <Item5 Ref="8" Visible="false" Description="FraseFiscal" Name="FraseFiscal" />
    <Item6 Ref="9" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item7 Ref="11" Description="AcompanhaBens" ValueInfo="true" Name="AcompanhaBens" Type="#Ref-10" />
  </Parameters>
  <Bands>
    <Item1 Ref="12" ControlType="TopMarginBand" Name="TopMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="13" ControlType="ReportHeaderBand" Name="ReportHeaderBand1" HeightF="34.05968">
      <Controls>
        <Item1 Ref="14" ControlType="XRLabel" Name="fldFraseFiscal" TextAlignment="TopLeft" SizeF="334.7667,9.132431" LocationFloat="0, 14" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
          <StylePriority Ref="15" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="16" ControlType="XRLabel" Name="lblObservacoes" Text="Observações" TextAlignment="MiddleLeft" SizeF="90.12,12" LocationFloat="0, 2" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
          <StylePriority Ref="17" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="18" ControlType="XRLabel" Name="fldObservacoes" Multiline="true" TextAlignment="TopLeft" SizeF="334.7667,9.132425" LocationFloat="0, 23.13243" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
          <StylePriority Ref="19" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
      </Controls>
    </Item2>
    <Item3 Ref="20" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item4 Ref="21" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="22" OnBeforePrint="DocumentosVendasObservacoes_BeforePrint" />
  <StyleSheet>
    <Item1 Ref="23" Name="Title" BorderStyle="Inset" Font="Times New Roman, 20pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item2 Ref="24" Name="FieldCaption" BorderStyle="Inset" Font="Arial, 10pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item3 Ref="25" Name="PageInfo" BorderStyle="Inset" Font="Times New Roman, 10pt, style=Bold" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item4 Ref="26" Name="DataField" BorderStyle="Inset" Padding="2,2,0,0,100" Font="Times New Roman, 10pt" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
  </StyleSheet>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="5" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="10" Content="System.Boolean" Type="System.Type" />
    <Item3 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9cHJpc21hLWxhYi12bS53ZXN0ZXVyb3BlLmNsb3VkYXBwLmF6dXJlLmNvbSwxNDMzO1VzZXIgSUQ9RjNNTztQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID0xMDAwMEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJEb2N1bWVudG9zIj48UGFyYW1ldGVyIE5hbWU9IklETG9qYSIgVHlwZT0iRGV2RXhwcmVzcy5EYXRhQWNjZXNzLkV4cHJlc3Npb24iPihTeXN0ZW0uSW50NjQsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OSkoW1BhcmFtZXRlcnMuSURMb2phXSk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklEIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklETW9lZGFEZWZlaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIk1vcmFkYSIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGb3RvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZvdG9DYW1pbmhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRlc2lnbmFjYW9Db21lcmNpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ29kaWdvUG9zdGFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkxvY2FsaWRhZGUiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ29uY2VsaG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRGlzdHJpdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURQYWlzIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIlRlbGVmb25lIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZheCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJFbWFpbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJXZWJTaXRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIk5JRiIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNhcGl0YWxTb2NpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklESWRpb21hQmFzZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJTaXN0ZW1hIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkF0aXZvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRhdGFDcmlhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIlV0aWxpemFkb3JDcmlhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRhdGFBbHRlcmFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGM01NYXJjYWRvciIsDQogICAgICAgInRiTW9lZGFzIi4iU2ltYm9sbyIsDQogICAgICAgInRiTW9lZGFzIi4iVGF4YUNvbnZlcnNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iRGVzY3JpY2FvRGVjaW1hbCIsDQogICAgICAgInRiTW9lZGFzIi4iRGVzY3JpY2FvSW50ZWlyYSIsDQogICAgICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1RvdGFpcyIsDQogICAgICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc0l2YSIsDQogICAgICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyINCiAgZnJvbSAoImRibyIuInRiUGFyYW1ldHJvc0VtcHJlc2EiDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiDQogIGxlZnQgam9pbiAiZGJvIi4idGJNb2VkYXMiICJ0Yk1vZWRhcyINCiAgICAgICBvbiAoInRiTW9lZGFzIi4iSUQiID0gInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIpKTwvU3FsPjwvUXVlcnk+PFJlc3VsdFNjaGVtYT48RGF0YVNldD48VmlldyBOYW1lPSJ0YkRvY3VtZW50b3MiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxobyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUZWxlZm9uZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGYXgiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iV2ViU2l0ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOSUYiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXBpdGFsU29jaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iSURJZGlvbWFCYXNlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUYXhhQ29udmVyc2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0RlY2ltYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvSW50ZWlyYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzVG90YWlzIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzSXZhIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiBUeXBlPSJCeXRlIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''

update tbMapasVistas set SubReport=1, MapaXML = @ptrvalObservacoes where id = @IDSubObservacoes


DECLARE @ptrvalP xml;  
SET @ptrvalP = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosVendasA5HNovo250" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Microsoft.VisualBasic&#xD;&#xA;Imports DevExpress.DataAccess.Native.Sql&#xD;&#xA;Imports System.ComponentModel&#xD;&#xA;Imports System.Linq&#xD;&#xA;&#xD;&#xA;Private dblTotal As Double = 0&#xD;&#xA;Private dblTotalPagina As Double = 0&#xD;&#xA;Private dblTransportar as Double = 0&#xD;&#xA;Private dblTransporte as Double = 0&#xD;&#xA;&#xD;&#xA;&#xD;&#xA;Private Sub DocumentosVendasA5HNovo49_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim SimboloMoeda As String = String.Empty&#xD;&#xA;    Dim strEntidade As String = String.Empty&#xD;&#xA;    Dim strEntidade1 As String = String.Empty&#xD;&#xA;    Dim strEntidade2 As String = String.Empty&#xD;&#xA;    Dim strBeneficiario1 As String = String.Empty&#xD;&#xA;    Dim strBeneficiario2 As String = String.Empty&#xD;&#xA;    Dim strParentesco1 As String = String.Empty&#xD;&#xA;    Dim strParentesco2 As String = String.Empty&#xD;&#xA;    Dim strValor As String = String.Empty&#xD;&#xA;    Dim strTipo As String = String.Empty&#xD;&#xA;    Dim strSerie As String = String.Empty&#xD;&#xA;    Dim strNumero As String = String.Empty&#xD;&#xA;    Dim strData As String = String.Empty&#xD;&#xA;    Dim strCodigoPostal As String = String.Empty&#xD;&#xA;    Dim strLocalidade As String = String.Empty&#xD;&#xA;    Dim strSigla As String = String.Empty&#xD;&#xA;    Dim NumeroCasasDecimais As Int16 = 0&#xD;&#xA;    Dim strMoradaCarga As String = String.Empty&#xD;&#xA;    Dim strMoradaDescarga As String = String.Empty&#xD;&#xA;&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    Me.lblNumVias.Text = Me.Parameters(&quot;Via&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    SimboloMoeda = Convert.ToString(GetCurrentColumnValue(&quot;tbMoedas_Simbolo&quot;))&#xD;&#xA;    Me.Parameters.Item(&quot;Simbolo&quot;).Value = SimboloMoeda&#xD;&#xA;&#xD;&#xA;    NumeroCasasDecimais = Convert.ToInt16(GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;&#xD;&#xA;    strEntidade1 = Convert.ToString(GetCurrentColumnValue(&quot;tbEntidades1_Codigo&quot;))&#xD;&#xA;&#xD;&#xA;    strEntidade2 = Convert.ToString(GetCurrentColumnValue(&quot;tbEntidades2_Codigo&quot;))&#xD;&#xA;&#xD;&#xA;    strBeneficiario1 = Convert.ToString(GetCurrentColumnValue(&quot;NumeroBeneficiario1&quot;))&#xD;&#xA;&#xD;&#xA;    strBeneficiario2 = Convert.ToString(GetCurrentColumnValue(&quot;NumeroBeneficiario2&quot;))&#xD;&#xA;&#xD;&#xA;    strParentesco1 = Convert.ToString(GetCurrentColumnValue(&quot;Parentesco1&quot;))&#xD;&#xA;&#xD;&#xA;    strParentesco2 = Convert.ToString(GetCurrentColumnValue(&quot;Parentesco2&quot;))&#xD;&#xA;&#xD;&#xA;    If strEntidade1 &lt;&gt; &quot;&quot; Then&#xD;&#xA;        If strEntidade2 &lt;&gt; &quot;&quot; Then&#xD;&#xA;            Me.fldEntidade.Text = strEntidade1 &amp; &quot; / &quot; &amp; strEntidade2&#xD;&#xA;            Me.fldNumBeneficiario.Text = strBeneficiario1 &amp; &quot; / &quot; &amp; strBeneficiario2&#xD;&#xA;            Me.fldParentesco.Text = strParentesco1 &amp; &quot; / &quot; &amp; strParentesco2&#xD;&#xA;        Else&#xD;&#xA;            Me.fldEntidade.Text = strEntidade1&#xD;&#xA;            Me.fldNumBeneficiario.Text = strBeneficiario1&#xD;&#xA;            Me.fldParentesco.Text = strParentesco1&#xD;&#xA;        End If&#xD;&#xA;    Else&#xD;&#xA;        Me.fldEntidade.Text = strEntidade2&#xD;&#xA;        Me.fldNumBeneficiario.Text = strBeneficiario2&#xD;&#xA;        Me.fldParentesco.Text = strParentesco2&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;tbSistemaMoedas_Codigo&quot;))&#xD;&#xA;    Me.fldCodigoMoeda.Text = strValor&#xD;&#xA;&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;))&#xD;&#xA;    Me.lblTipoDocumento.Text = resource.GetResource(strValor, culture)&#xD;&#xA;&#xD;&#xA;    Dim strTipoFiscal As String = Convert.ToString(GetCurrentColumnValue(&quot;Tipo&quot;))&#xD;&#xA;&#xD;&#xA;    strTipo = Convert.ToString(GetCurrentColumnValue(&quot;tbTiposDocumento_Codigo&quot;))&#xD;&#xA;&#xD;&#xA;    strSerie = Convert.ToString(GetCurrentColumnValue(&quot;CodigoSerie&quot;))&#xD;&#xA;&#xD;&#xA;    strNumero = Convert.ToString(GetCurrentColumnValue(&quot;NumeroDocumento&quot;))&#xD;&#xA;    Me.fldTipoDocumento.Text = strTipo &amp; &quot; &quot; &amp; strSerie &amp; &quot;/&quot; &amp; strNumero&#xD;&#xA;&#xD;&#xA;    strSigla = Convert.ToString(GetCurrentColumnValue(&quot;SiglaPaisFiscal&quot;))&#xD;&#xA;&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;ContribuinteFiscal&quot;))&#xD;&#xA;    Me.fldContribuinteFiscal.Text = strSigla &amp; &quot; &quot; &amp; strValor&#xD;&#xA;&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;Codigo&quot;))&#xD;&#xA;    Me.fldClienteCodigo.Text = strValor&#xD;&#xA;&#xD;&#xA;    If strTipo.ToLower = &quot;fs&quot; Then&#xD;&#xA;        Me.lblTitulo.Visible = False&#xD;&#xA;        Me.fldNome.Visible = False&#xD;&#xA;        Me.fldMorada.Visible = False&#xD;&#xA;        Me.fldCodigoPostal.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        strValor = Convert.ToString(GetCurrentColumnValue(&quot;NomeFiscal&quot;))&#xD;&#xA;        Me.fldNome.Text = strValor&#xD;&#xA;&#xD;&#xA;        strValor = Convert.ToString(GetCurrentColumnValue(&quot;MoradaFiscal&quot;))&#xD;&#xA;        Me.fldMorada.Text = strValor&#xD;&#xA;&#xD;&#xA;        strValor = Convert.ToString(GetCurrentColumnValue(&quot;IDCodigoPostalFiscal&quot;))&#xD;&#xA;        Me.fldCodigoPostal.Text = strValor&#xD;&#xA;&#xD;&#xA;        strCodigoPostal = Convert.ToString(GetCurrentColumnValue(&quot;tbCodigosPostais_Codigo&quot;))&#xD;&#xA;&#xD;&#xA;        strLocalidade = Convert.ToString(GetCurrentColumnValue(&quot;tbCodigosPostais_Descricao&quot;))&#xD;&#xA;&#xD;&#xA;        Me.fldCodigoPostal.Text = strCodigoPostal &amp; &quot; &quot; &amp; strLocalidade&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    Me.lblPreco.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Preco&quot;, culture)&#xD;&#xA;    Me.lblDescontoLinha.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoLinha&quot;, culture)&#xD;&#xA;    Me.lblTotalFinal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Total&quot;, culture)&#xD;&#xA;&#xD;&#xA;    Me.lblSubTotal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;SubTotal&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;SubTotal&quot;))&#xD;&#xA;    Me.fldSubTotal.Text = strValor&#xD;&#xA;    Me.fldSubTotal.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.lblDescontosLinha.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoLinha&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;DescontosLinha&quot;))&#xD;&#xA;    Me.fldDescontosLinha.Text = strValor&#xD;&#xA;    Me.fldDescontosLinha.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.lblDescontoGlobal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoGlobal&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;ValorDesconto&quot;))&#xD;&#xA;    Me.fldDescontoGlobal.Text = strValor&#xD;&#xA;    Me.fldDescontoGlobal.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.lblOutrosDescontos.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;OutrosDescontos&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;OutrosDescontos&quot;))&#xD;&#xA;    Me.fldOutrosDescontos.Text = strValor&#xD;&#xA;    Me.fldOutrosDescontos.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.lblTotalEntidade1.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalEntidade1&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;TotalEntidade1&quot;))&#xD;&#xA;    Me.fldTotalEntidade1.Text = strValor&#xD;&#xA;    Me.fldTotalEntidade1.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.lblTotalEntidade2.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalEntidade2&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;TotalEntidade2&quot;))&#xD;&#xA;    Me.fldTotalEntidade2.Text = strValor&#xD;&#xA;    Me.fldTotalEntidade2.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    Me.lblTotalMoedaDocumento.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalMoedaDocumento&quot;, culture)&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;TotalMoedaDocumento&quot;))&#xD;&#xA;    Me.fldTotalMoedaDocumento.Text = strValor&#xD;&#xA;    Me.fldTotalMoedaDocumento.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    strCodigoPostal = Convert.ToString(GetCurrentColumnValue(&quot;tbCodigosPostaisCarga_Codigo&quot;))&#xD;&#xA;    strLocalidade = Convert.ToString(GetCurrentColumnValue(&quot;tbCodigosPostaisCarga_Descricao&quot;))&#xD;&#xA;&#xD;&#xA;    Me.fldCodigoPostalCarga.Text = strCodigoPostal &amp; &quot; &quot; &amp; strLocalidade&#xD;&#xA;    If strCodigoPostal = String.Empty Then&#xD;&#xA;        Me.fldDataCarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    strCodigoPostal = Convert.ToString(GetCurrentColumnValue(&quot;tbCodigosPostaisDescarga_Codigo&quot;))&#xD;&#xA;    strLocalidade = Convert.ToString(GetCurrentColumnValue(&quot;tbCodigosPostaisDescarga_Descricao&quot;))&#xD;&#xA;&#xD;&#xA;    Me.fldCodigoPostalDescarga.Text = strCodigoPostal &amp; &quot; &quot; &amp; strLocalidade&#xD;&#xA;    If strCodigoPostal = String.Empty Then&#xD;&#xA;        Me.fldDataDescarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    strMoradaCarga = Convert.ToString(GetCurrentColumnValue(&quot;MoradaCarga&quot;))&#xD;&#xA;    strMoradaDescarga = Convert.ToString(GetCurrentColumnValue(&quot;MoradaDescarga&quot;))&#xD;&#xA;&#xD;&#xA;    If strMoradaCarga &lt;&gt; String.Empty Or strMoradaDescarga &lt;&gt; String.Empty Then&#xD;&#xA;        Me.GrpFooCarga.Visible = True&#xD;&#xA;    Else&#xD;&#xA;        Me.GrpFooCarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    Dim strAssinatura As String = String.Empty&#xD;&#xA;&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;MensagemDocAT&quot;))&#xD;&#xA;&#xD;&#xA;    Dim strAss As String = String.Empty&#xD;&#xA;    Dim strMsg As String = String.Empty&#xD;&#xA;&#xD;&#xA;    If strValor.IndexOf(Constantes.SaftAT.CSeparadorMsgAt) &gt; 0 Then&#xD;&#xA;        strAss = strValor.Substring(0, strValor.IndexOf(Constantes.SaftAT.CSeparadorMsgAt))&#xD;&#xA;        strMsg = strValor.Substring(strValor.IndexOf(Constantes.SaftAT.CSeparadorMsgAt) + Constantes.SaftAT.CSeparadorMsgAt.Length)&#xD;&#xA;    Else&#xD;&#xA;        strAss = strValor&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    Dim dtDataAss As DateTime = Convert.ToDateTime(GetCurrentColumnValue(&quot;DataCriacao&quot;))&#xD;&#xA;&#xD;&#xA;    If strTipoFiscal = &quot;OR&quot; Or strTipoFiscal = &quot;PF&quot; Or strTipoFiscal = &quot;NE&quot; Then&#xD;&#xA;        strAss += New String(&quot; &quot;, 60) + &quot;Emitido:&quot; &amp; dtDataAss.ToShortDateString &amp; &quot; &quot; &amp; dtDataAss.ToShortTimeString&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    Dim strCodigoAT As String = Convert.ToString(GetCurrentColumnValue(&quot;CodigoAT&quot;))&#xD;&#xA;&#xD;&#xA;    If strCodigoAT &lt;&gt; String.Empty Then&#xD;&#xA;        strMsg += &quot; | ATDocCodeId: &quot; &amp; strCodigoAT&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    Me.fldAssinatura.Text = strAss&#xD;&#xA;    Me.fldAssinatura1.Text = strAss&#xD;&#xA;    Me.fldMensagemDocAT1.Text = strMsg&#xD;&#xA;    Me.fldAssinatura11.Text = strMsg&#xD;&#xA;&#xD;&#xA;    Me.Parameters.Item(&quot;FraseFiscal&quot;).Value = &quot;FraseFiscal&quot;&#xD;&#xA;    If strTipo = &quot;FT&quot; Or strTipo = &quot;FR&quot; Then&#xD;&#xA;        Me.Parameters.Item(&quot;AcompanhaBens&quot;).Value = True&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;CodigoTipoEstado&quot;))&#xD;&#xA;    If strValor = &quot;ANL&quot; Then&#xD;&#xA;        Me.lblAnulado.Text = resource.GetResource(&quot;Anulado&quot;, culture)&#xD;&#xA;        Me.lblAnulado.Visible = True&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    strValor = Convert.ToString(GetCurrentColumnValue(&quot;SegundaVia&quot;))&#xD;&#xA;    If strValor = &quot;True&quot; Then&#xD;&#xA;        If Me.lblAnulado.Visible Then&#xD;&#xA;            Me.lblSegundaVia.Visible = False&#xD;&#xA;            Me.lblNumVias.Visible = True&#xD;&#xA;        Else&#xD;&#xA;            Me.lblSegundaVia.Text = resource.GetResource(&quot;SegundaVia&quot;, culture)&#xD;&#xA;            Me.lblSegundaVia.Visible = True&#xD;&#xA;            Me.lblNumVias.Visible = False&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldRunningSum_SummaryCalculated(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs)&#xD;&#xA;    dblTotalPagina += e.Value&#xD;&#xA;    dblTotal += e.Value&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransporte_SummaryGetResult(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs)&#xD;&#xA;    e.Result = dblTotal&#xD;&#xA;    e.Handled = True&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransportar_SummaryGetResult(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs)&#xD;&#xA;    e.Result = dblTotalPagina&#xD;&#xA;    e.Handled = True&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Me.lblTransportar.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.lblTituloTransportar.Visible = True&#xD;&#xA;        Me.lblTransportar.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    &#xD;&#xA;    If e.PageIndex &gt; 0 then&#xD;&#xA;        Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;        Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex - 1)     &#xD;&#xA;        Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;        &#xD;&#xA;        While (iterator.MoveNext())&#xD;&#xA;             if (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;XrLabel33&quot;))&#xD;&#xA;                If (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue &lt;&gt; String.Empty then&#xD;&#xA;                 dblTransporte += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;                End If&#xD;&#xA;            End If&#xD;&#xA;            If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;                label.Text = dblTransporte.ToString()&#xD;&#xA;            Else&#xD;&#xA;              dim strFormatos1 as String = &quot;{0:n&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) &amp; &quot;}&quot;&#xD;&#xA;                 label.Text = string.Format(strFormatos1, dblTransportar)&#xD;&#xA;            &#xD;&#xA;                 End If&#xD;&#xA;        End While&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.lblTituloTransportar.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTransporte.Visible = False&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Me.fldAssinatura1.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.lblTransporte.Visible = True&#xD;&#xA;        Me.lblTituloTransporte.Visible = True&#xD;&#xA;        Me.fldAssinatura1.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    &#xD;&#xA;    Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;    Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex)     &#xD;&#xA;    Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;    While (iterator.MoveNext())&#xD;&#xA;        If (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;XrLabel33&quot;))&#xD;&#xA;            If (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue &lt;&gt; String.Empty then&#xD;&#xA;                dblTransportar += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;                End If&#xD;&#xA;        End If&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;            label.Text = dblTransportar.ToString()&#xD;&#xA;        Else&#xD;&#xA;            dim strFormatos as String = &quot;{0:n&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) &amp; &quot;}&quot;&#xD;&#xA;            label.Text = string.Format(strFormatos, dblTransportar)&#xD;&#xA;        End If&#xD;&#xA;    End While&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.lblTituloTransporte.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura1_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.fldAssinatura1.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.fldAssinatura1.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura11_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.fldAssinatura11.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.fldAssinatura11.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldCodigoMotivoIsencaoIva_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    If Me.fldTaxaIva.Text = String.Empty OrElse CDbl(Me.fldTaxaIva.Text) = 0 Then&#xD;&#xA;        Me.fldCodigoMotivoIsencaoIva.Visible = True&#xD;&#xA;    Else&#xD;&#xA;        Me.fldCodigoMotivoIsencaoIva.Visible = False&#xD;&#xA;    End If&#xD;&#xA;End Sub" SnapGridSize="0.1" DrawWatermark="true" Margins="55, 25, 25, 570" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="19.1" DataMember="CustomSqlQuery" DataSource="#Ref-0">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="138" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item3 Ref="7" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item4 Ref="8" Visible="false" Description="Via" Name="Via" />
    <Item5 Ref="9" Visible="false" Description="Formas" ValueInfo="select distinct tbDocumentosVendas.ID, tbDocumentosVendasFormasPagamento.IDFormaPagamento, tbFormasPagamento.Descricao, tbDocumentosVendasFormasPagamento.Valor,  tbDocumentosVendasFormasPagamento.ValorEntregue,  tbDocumentosVendasFormasPagamento.Troco from tbDocumentosVendas inner join tbDocumentosVendasFormasPagamento on tbDocumentosVendasFormasPagamento.IDDocumentoVenda = tbDocumentosVendas.ID inner join tbFormasPagamento on tbDocumentosVendasFormasPagamento.IDFormaPagamento=tbFormasPagamento.ID where tbDocumentosVendas.ID=" Name="Formas" />
    <Item6 Ref="11" Visible="false" Description="NumeroCasasDecimais" ValueInfo="2" Name="NumeroCasasDecimais" Type="#Ref-10" />
    <Item7 Ref="12" Visible="false" Description="Observacoes" ValueInfo="select ID, Observacoes from tbDocumentosVendas where ID=" Name="Observacoes" />
    <Item8 Ref="13" Visible="false" Description="Assinatura" ValueInfo="select ID, Assinatura from tbDocumentosVendas where ID=" Name="Assinatura" />
    <Item9 Ref="14" Visible="false" Description="FraseFiscal" Name="FraseFiscal" />
    <Item10 Ref="15" Visible="false" Description="Simbolo" Name="Simbolo" />
    <Item11 Ref="16" Visible="false" Description="BDEmpresa" ValueInfo="Teste" Name="BDEmpresa" />
    <Item12 Ref="18" Visible="false" Description="AcompanhaBens" ValueInfo="false" Name="AcompanhaBens" Type="#Ref-17" />
    <Item13 Ref="19" Description="UrlServerPath" AllowNull="true" Name="UrlServerPath" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="20" Name="SomaQuantidade" FieldType="Float" DisplayName="SomaQuantidade" Expression="[].Sum([Quantidade])" DataMember="tbDocumentosVendas" />
    <Item2 Ref="21" Name="SomaValorIVA" FieldType="Float" Expression="[].Sum([ValorIVA])" DataMember="tbDocumentosVendas" />
    <Item3 Ref="22" Name="SomaValorIncidencia" FieldType="Float" Expression="[].Sum([ValorIncidencia])" DataMember="tbDocumentosVendas" />
    <Item4 Ref="23" Name="SomaTotalFinal" FieldType="Double" Expression="[].Sum([TotalFinal])" DataMember="tbDocumentosVendas" />
    <Item5 Ref="24" Name="MotivoIsencao" DisplayName="MotivoIsencao" Expression="IIF([TaxaIva]=0, '''''''', [CodigoMotivoIsencaoIva])" DataMember="tbDocumentosVendas" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="25" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="26" ControlType="ReportHeaderBand" Name="ReportHeader" HeightF="0" />
    <Item3 Ref="27" ControlType="PageHeaderBand" Name="PageHeader" HeightF="98.10085">
      <SubBands>
        <Item1 Ref="28" ControlType="SubBand" Name="SubBand1">
          <Controls>
            <Item1 Ref="29" ControlType="XRPanel" Name="XrPanel1" SizeF="746.837,100" LocationFloat="0, 0">
              <Controls>
                <Item1 Ref="30" ControlType="XRLabel" Name="fldCodigoMoeda" TextAlignment="TopLeft" SizeF="194.7021,13.99999" LocationFloat="86.12649, 38.00002" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
                  <StylePriority Ref="31" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item1>
                <Item2 Ref="32" ControlType="XRLabel" Name="lblCodigoMoeda" Text="Moeda" TextAlignment="TopLeft" SizeF="84.12,14" LocationFloat="1.010074, 38.00002" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Moeda">
                  <StylePriority Ref="33" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item2>
                <Item3 Ref="34" ControlType="XRLabel" Name="fldCodigoPostal" Text="Código Postal" TextAlignment="TopRight" SizeF="296.2915,22.99999" LocationFloat="381.5468, 75.00001" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <StylePriority Ref="35" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item3>
                <Item4 Ref="36" ControlType="XRLabel" Name="fldMorada" Text="Morada" TextAlignment="TopRight" SizeF="296.2915,23" LocationFloat="381.5468, 52" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <StylePriority Ref="37" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item4>
                <Item5 Ref="38" ControlType="XRLabel" Name="fldNome" Text="Nome" TextAlignment="TopRight" SizeF="296.2916,23" LocationFloat="381.5467, 29" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <StylePriority Ref="39" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item5>
                <Item6 Ref="40" ControlType="XRLabel" Name="lblTitulo" Text="Exmo.(a) Sr.(a) " TextAlignment="TopRight" SizeF="296.2916,20" LocationFloat="381.5464, 9" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <StylePriority Ref="41" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item6>
                <Item7 Ref="42" ControlType="XRLabel" Name="lblContribuinte" Text="Contribuinte" TextAlignment="TopLeft" SizeF="84.11,14" LocationFloat="1.009999, 10.00003" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
                  <StylePriority Ref="43" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item7>
                <Item8 Ref="44" ControlType="XRLabel" Name="lblClienteCodigo" Text="Cliente" TextAlignment="TopLeft" SizeF="84.11,14" LocationFloat="1.010029, 24.00003" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Cliente">
                  <StylePriority Ref="45" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item8>
                <Item9 Ref="46" ControlType="XRLabel" Name="fldClienteCodigo" TextAlignment="TopLeft" SizeF="194.7036,14" LocationFloat="86.12495, 24.00003" Font="Arial, 8pt" Padding="2,2,0,0,100" BorderWidth="0">
                  <StylePriority Ref="47" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item9>
                <Item10 Ref="48" ControlType="XRLabel" Name="fldContribuinteFiscal" TextAlignment="TopLeft" SizeF="194.715,13.99999" LocationFloat="86.12502, 10.00003" Font="Arial, 8pt" Padding="2,2,0,0,100" BorderWidth="0">
                  <StylePriority Ref="49" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item10>
                <Item11 Ref="50" ControlType="XRLabel" Name="lblEntidade" Text="Entidade" TextAlignment="TopLeft" SizeF="84.12,14" LocationFloat="1.02147, 57.00002" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Entidade">
                  <StylePriority Ref="51" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item11>
                <Item12 Ref="52" ControlType="XRLabel" Name="fldEntidade" TextAlignment="TopLeft" SizeF="194.6986,14.00001" LocationFloat="86.14146, 57.00002" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
                  <StylePriority Ref="53" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item12>
                <Item13 Ref="54" ControlType="XRLabel" Name="lblNumBeneficiario" Text="Beneficário" TextAlignment="TopLeft" SizeF="84.12,14" LocationFloat="1.02147, 71.00002" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Beneficiario">
                  <StylePriority Ref="55" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item13>
                <Item14 Ref="56" ControlType="XRLabel" Name="fldNumBeneficiario" TextAlignment="TopLeft" SizeF="194.7036,13.99999" LocationFloat="86.13644, 71.00002" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
                  <StylePriority Ref="57" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item14>
                <Item15 Ref="58" ControlType="XRLabel" Name="lblParentesco" Text="Parentesco" TextAlignment="TopLeft" SizeF="84.12,14" LocationFloat="1.02147, 85.00002" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Parentesco">
                  <StylePriority Ref="59" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item15>
                <Item16 Ref="60" ControlType="XRLabel" Name="fldParentesco" TextAlignment="TopLeft" SizeF="194.7021,14" LocationFloat="86.13789, 85.00002" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
                  <StylePriority Ref="61" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item16>
              </Controls>
            </Item1>
          </Controls>
        </Item1>
        <Item2 Ref="62" ControlType="SubBand" Name="SubBand2" HeightF="36.78">
          <Controls>
            <Item1 Ref="63" ControlType="XRLabel" Name="lblComparticipacao" Text="Comp." TextAlignment="TopRight" SizeF="44.84015,13" LocationFloat="657.0474, 5.99999" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="64" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="65" ControlType="XRLabel" Name="XrLabel6" Text="Ise." TextAlignment="TopRight" SizeF="44.78247,13" LocationFloat="701.8876, 5.99999" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="66" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="67" ControlType="XRLabel" Name="lblDocOrigem" Text="Doc. Ref." TextAlignment="TopLeft" SizeF="88.11998,13" LocationFloat="0, 5.99999" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DocRef">
              <StylePriority Ref="68" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="69" ControlType="XRLabel" Name="lblArtigo" Text="Artigo" TextAlignment="TopLeft" SizeF="76.2,13" LocationFloat="88.11998, 5.99999" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="70" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="71" ControlType="XRLabel" Name="lblDescricao" Text="Descrição" TextAlignment="TopLeft" SizeF="248.9346,13" LocationFloat="164.32, 5.99999" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="72" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="73" ControlType="XRLabel" Name="lblQuantidade" Text="Qtd." TextAlignment="TopRight" SizeF="32.51865,13" LocationFloat="413.2546, 5.99999" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="74" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="75" ControlType="XRLabel" Name="lblPreco" Text="Preço" TextAlignment="TopRight" SizeF="59.29944,13" LocationFloat="445.7733, 5.99999" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="76" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="77" ControlType="XRLabel" Name="lblDescontoLinha" Text="Desc. Linha" TextAlignment="TopRight" SizeF="57.71854,13" LocationFloat="505.0727, 5.99999" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="78" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="79" ControlType="XRLabel" Name="lblTotalFinal" Text="Total" TextAlignment="TopRight" SizeF="61.19666,13" LocationFloat="562.7913, 5.99999" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="80" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="81" ControlType="XRLabel" Name="lblIvaLinha" Text="% Iva" TextAlignment="TopRight" SizeF="33.05951,13" LocationFloat="623.9879, 5.99999" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="82" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="83" ControlType="XRLine" Name="XrLine1" SizeF="746.6705,2.252249" LocationFloat="0, 21.94241" />
            <Item12 Ref="84" ControlType="XRLabel" Name="lblTituloTransportar" Text="Transporte" TextAlignment="MiddleRight" SizeF="78.96,12" LocationFloat="475.4603, 24.77799" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <Scripts Ref="85" OnPrintOnPage="lblTituloTransportar_PrintOnPage" />
              <StylePriority Ref="86" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item12>
            <Item13 Ref="87" ControlType="XRLabel" Name="lblTransportar" TextFormatString="{0:0.00}" TextAlignment="MiddleLeft" SizeF="187.58,12" LocationFloat="557.4204, 24.77798" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <Scripts Ref="88" OnSummaryGetResult="lblTransportar_SummaryGetResult" OnPrintOnPage="lblTransportar_PrintOnPage" />
              <Summary Ref="89" Running="Page" IgnoreNullValues="true" />
              <StylePriority Ref="90" UseFont="false" UseTextAlignment="false" />
            </Item13>
          </Controls>
        </Item2>
        <Item3 Ref="91" ControlType="SubBand" Name="SubBand4" SnapLinePadding="0,0,0,0,100" HeightF="3.055573" KeepTogether="true">
          <Controls>
            <Item1 Ref="92" ControlType="XRLabel" Name="fldRunningSum" TextFormatString="{0:0.00}" CanGrow="false" CanShrink="true" SizeF="2,2" LocationFloat="1.021449, 0" ForeColor="Black" Padding="0,0,0,0,100">
              <Scripts Ref="93" OnSummaryCalculated="fldRunningSum_SummaryCalculated" />
              <Summary Ref="94" Running="Page" IgnoreNullValues="true" />
              <ExpressionBindings>
                <Item1 Ref="95" Expression="sumRunningSum([TotalFinal])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="96" UseForeColor="false" UsePadding="false" />
            </Item1>
          </Controls>
        </Item3>
      </SubBands>
      <Controls>
        <Item1 Ref="97" ControlType="XRLabel" Name="lblSegundaVia" Text="2º Via" TextAlignment="TopRight" SizeF="76.16077,18.77632" LocationFloat="670.8397, 0.7763469" Font="Arial, 9.75pt, style=Bold, charSet=0" ForeColor="Black" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
          <StylePriority Ref="98" UseFont="false" UseForeColor="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="99" ControlType="XRSubreport" Name="DocumentosVendasCabecalho" ReportSourceUrl="20000" SizeF="535.2748,95.10086" LocationFloat="0.02147754, 0">
          <ParameterBindings>
            <Item1 Ref="100" ParameterName="IDLoja" DataMember="tbDocumentosVendas.IDLoja" />
            <Item2 Ref="102" ParameterName="Culture" Parameter="#Ref-7" />
            <Item3 Ref="103" ParameterName="BDEmpresa" Parameter="#Ref-16" />
            <Item4 Ref="104" ParameterName="DesignacaoComercial" DataMember="tbDocumentosVendas.DesignacaoComercialLoja" />
            <Item5 Ref="105" ParameterName="Morada" DataMember="tbDocumentosVendas.MoradaLoja" />
            <Item6 Ref="106" ParameterName="Localidade" DataMember="tbDocumentosVendas.LocalidadeLoja" />
            <Item7 Ref="107" ParameterName="CodigoPostal" DataMember="tbDocumentosVendas.CodigoPostalLoja" />
            <Item8 Ref="108" ParameterName="Sigla" DataMember="tbDocumentosVendas.SiglaLoja" />
            <Item9 Ref="109" ParameterName="NIF" DataMember="tbDocumentosVendas.NIFLoja" />
            <Item10 Ref="110" ParameterName="MoradaSede" DataMember="tbDocumentosVendas.MoradaSede" />
            <Item11 Ref="111" ParameterName="CodigoPostalSede" DataMember="tbDocumentosVendas.CodigoPostalSede" />
            <Item12 Ref="112" ParameterName="LocalidadeSede" DataMember="tbDocumentosVendas.LocalidadeSede" />
            <Item13 Ref="113" ParameterName="TelefoneSede" DataMember="tbDocumentosVendas.TelefoneSede" />
            <Item14 Ref="114" ParameterName="IDLojaSede" DataMember="tbDocumentosVendas.IDLojaSede" />
            <Item15 Ref="115" ParameterName="UrlServerPath" Parameter="#Ref-19" />
          </ParameterBindings>
        </Item2>
        <Item3 Ref="116" ControlType="XRLabel" Name="fldTipoDocumento" TextAlignment="TopRight" SizeF="159.7648,20.54824" LocationFloat="586.78, 33.55265" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="117" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="118" ControlType="XRLabel" Name="fldDataDocumento" TextFormatString="{0:dd-MM-yyyy}" TextAlignment="TopRight" SizeF="84.06,20" LocationFloat="586.7797, 78.10085" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="119" Expression="[DataDocumento]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="120" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="121" ControlType="XRLabel" Name="lblDataVencimento" Text="Data Venc." TextAlignment="TopRight" SizeF="76.16,15" LocationFloat="670.8398, 63.10081" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataVencimento">
          <StylePriority Ref="122" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="123" ControlType="XRLabel" Name="lblDataDocumento" Text="Data Doc." TextAlignment="TopRight" SizeF="84.06,15" LocationFloat="586.78, 63.10088" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
          <StylePriority Ref="124" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="125" ControlType="XRLabel" Name="fldDataVencimento" TextFormatString="{0:dd-MM-yyyy}" CanGrow="false" TextAlignment="TopRight" SizeF="75.99713,20" LocationFloat="670.8398, 78.10082" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="126" Expression="[DataVencimento]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="127" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="128" ControlType="XRLabel" Name="lblNumVias" Text="Via" TextAlignment="TopRight" SizeF="160.2199,11.77632" LocationFloat="586.78, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="129" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="130" ControlType="XRLabel" Name="lblTipoDocumento" Text="Fatura" TextAlignment="TopRight" SizeF="159.7648,13.77632" LocationFloat="586.78, 19.77634" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="131" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item9>
        <Item10 Ref="132" ControlType="XRLabel" Name="lblAnulado" Angle="20" Text="ANULADO" TextAlignment="MiddleCenter" SizeF="189.8313,96.7917" LocationFloat="467.2161, 0" Font="Arial, 24pt, style=Bold, charSet=0" ForeColor="Red" Padding="2,2,0,0,100" Visible="false">
          <StylePriority Ref="133" UseFont="false" UseForeColor="false" UseTextAlignment="false" />
        </Item10>
      </Controls>
    </Item3>
    <Item4 Ref="134" ControlType="DetailBand" Name="Detail" KeepTogetherWithDetailReports="true" Expanded="false" SnapLinePadding="0,0,0,0,100" HeightF="0" KeepTogether="true" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="135" ControlType="DetailReportBand" Name="DetailReport" Level="0" DataMember="tbDocumentosVendas" DataSource="#Ref-0">
      <Bands>
        <Item1 Ref="136" ControlType="DetailBand" Name="Detail1" HeightF="14.53226">
          <Controls>
            <Item1 Ref="137" ControlType="XRLabel" Name="fldCodigoMotivoIsencaoIva" Text="fldCodigoMotivoIsencaoIva" TextAlignment="TopRight" SizeF="45.11273,13.91672" LocationFloat="701.8876, 0.08329706" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <Scripts Ref="138" OnBeforePrint="fldCodigoMotivoIsencaoIva_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="139" Expression="[CodigoMotivoIsencaoIva]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="140" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="141" ControlType="XRLabel" Name="XrLabel31" Text="XrLabel31" TextAlignment="TopLeft" SizeF="76.19501,14" LocationFloat="88.12498, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="142" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="143" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="144" ControlType="XRLabel" Name="XrLabel17" TextAlignment="TopLeft" SizeF="248.9346,14" LocationFloat="164.32, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="145" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="146" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="147" ControlType="XRLabel" Name="XrLabel30" TextFormatString="{0:#,#}" TextAlignment="TopRight" SizeF="34.13904,14" LocationFloat="413.2546, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="148" Expression="[Quantidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="149" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="150" ControlType="XRLabel" Name="XrLabel29" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="57.67902,14" LocationFloat="447.3937, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="151" Expression="[PrecoUnitario]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="152" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="153" ControlType="XRLabel" Name="XrLabel32" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="57.71854,14" LocationFloat="505.0726, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="154" Expression="[ValorDescontoLinha]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="155" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="156" ControlType="XRLabel" Name="XrLabel33" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="61.19666,14" LocationFloat="562.7913, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="157" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisTotais]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [PrecoTotal])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="158" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="159" ControlType="XRLabel" Name="fldTaxaIva" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="33.05951,14" LocationFloat="623.9879, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="160" Expression="[TaxaIva]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="161" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="162" ControlType="XRLabel" Name="XrLabel3" Text="XrLabel3" TextAlignment="TopLeft" SizeF="88.12498,14" LocationFloat="0, 0.041677" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="163" Expression="[DocumentoOrigem]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="164" UseFont="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="165" ControlType="XRLabel" Name="XrLabel9" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="44.84015,14.53226" LocationFloat="657.0474, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="166" Expression="[ValorEntidade1]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="167" UseFont="false" UseTextAlignment="false" />
            </Item10>
          </Controls>
        </Item1>
      </Bands>
    </Item5>
    <Item6 Ref="168" ControlType="GroupFooterBand" Name="GroupFooter1" PrintAtBottom="true" HeightF="70.29127">
      <SubBands>
        <Item1 Ref="169" ControlType="SubBand" Name="SubBand5" HeightF="62.00001">
          <Controls>
            <Item1 Ref="170" ControlType="XRSubreport" Name="DocumentosVendasMotivosIsencao" ReportSourceUrl="30000" SizeF="411.2447,60.00001" LocationFloat="0, 2">
              <ParameterBindings>
                <Item1 Ref="171" ParameterName="IDDocumento" Parameter="#Ref-4" />
                <Item2 Ref="172" ParameterName="Culture" Parameter="#Ref-7" />
                <Item3 Ref="173" ParameterName="BDEmpresa" Parameter="#Ref-16" />
              </ParameterBindings>
            </Item1>
            <Item2 Ref="174" ControlType="XRSubreport" Name="DocumentosVendasFormasPagamento" ReportSourceUrl="40000" SizeF="300.8967,60.00001" LocationFloat="446.1037, 2">
              <ParameterBindings>
                <Item1 Ref="175" ParameterName="IDDocumento" Parameter="#Ref-4" />
                <Item2 Ref="176" ParameterName="Culture" Parameter="#Ref-7" />
                <Item3 Ref="177" ParameterName="Formas" Parameter="#Ref-9" />
                <Item4 Ref="178" ParameterName="NumeroCasasDecimais" DataMember="tbMoedas_CasasDecimaisTotais" />
                <Item5 Ref="179" ParameterName="Simbolo" Parameter="#Ref-15" />
                <Item6 Ref="180" ParameterName="BDEmpresa" Parameter="#Ref-16" />
              </ParameterBindings>
            </Item2>
          </Controls>
          <StylePriority Ref="181" UseBackColor="false" />
        </Item1>
      </SubBands>
      <Controls>
        <Item1 Ref="182" ControlType="XRLabel" Name="fldAssinatura" TextAlignment="MiddleLeft" SizeF="509.5312,13" LocationFloat="2.023254, 2.71335" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="183" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="184" ControlType="XRLabel" Name="fldMensagemDocAT1" TextAlignment="MiddleRight" SizeF="510.5057,13" LocationFloat="234.4711, 2.71335" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="185" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="186" ControlType="XRLine" Name="XrLine4" SizeF="747.0004,2.041214" LocationFloat="0, 68.25005" />
        <Item4 Ref="187" ControlType="XRLine" Name="XrLine5" SizeF="747.0004,2" LocationFloat="0, 19.42838" />
        <Item5 Ref="188" ControlType="XRLabel" Name="fldTotalEntidade1" TextAlignment="TopRight" SizeF="70.00003,20.9583" LocationFloat="384.2987, 41.65185" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="189" Expression="[TotalEntidade1]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="190" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="191" ControlType="XRLabel" Name="lblSubTotal" TextAlignment="TopRight" SizeF="70,16" LocationFloat="0, 25.65186" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="192" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="193" ControlType="XRLabel" Name="lblDescontosLinha" TextAlignment="TopRight" SizeF="70,16" LocationFloat="79.16663, 25.65186" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="194" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="195" ControlType="XRLabel" Name="lblDescontoGlobal" TextAlignment="TopRight" SizeF="80,16" LocationFloat="173.4786, 25.65205" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="196" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="197" ControlType="XRLabel" Name="lblOutrosDescontos" TextAlignment="TopRight" SizeF="113,16" LocationFloat="255.2986, 25.6518" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="198" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item9>
        <Item10 Ref="199" ControlType="XRLabel" Name="lblTotalEntidade1" TextAlignment="TopRight" SizeF="70,16" LocationFloat="384.2987, 25.6518" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="200" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item10>
        <Item11 Ref="201" ControlType="XRLabel" Name="lblTotalMoedaDocumento" TextAlignment="TopRight" SizeF="121.383,17" LocationFloat="617.162, 24.65186" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="202" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item11>
        <Item12 Ref="203" ControlType="XRLabel" Name="lblTotalEntidade2" TextAlignment="TopRight" SizeF="69.99997,16" LocationFloat="472.2963, 25.6518" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="204" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="205" ControlType="XRLabel" Name="fldTotalMoedaDocumento" TextAlignment="TopRight" SizeF="176.209,25.59814" LocationFloat="562.7913, 41.65197" Font="Arial, 14.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="206" Expression="[TotalMoedaDocumento]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="207" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item13>
        <Item14 Ref="208" ControlType="XRLabel" Name="fldTotalEntidade2" TextAlignment="TopRight" SizeF="70.00003,20.9583" LocationFloat="472.2963, 41.65185" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="209" Expression="[TotalEntidade2]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="210" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item14>
        <Item15 Ref="211" ControlType="XRLabel" Name="XrLabel4" SizeF="190,46" LocationFloat="556.8371, 21.42836" BackColor="Gainsboro" Padding="2,2,0,0,100" Borders="None" BorderWidth="1">
          <StylePriority Ref="212" UseBackColor="false" UseBorders="false" UseBorderWidth="false" />
        </Item15>
        <Item16 Ref="213" ControlType="XRLabel" Name="fldOutrosDescontos" TextAlignment="TopRight" SizeF="113,20.9583" LocationFloat="255.2986, 41.65185" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="214" Expression="[OutrosDescontos]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="215" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item16>
        <Item17 Ref="216" ControlType="XRLabel" Name="fldDescontoGlobal" TextAlignment="TopRight" SizeF="80,20.96" LocationFloat="173.4786, 41.65198" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="217" Expression="[ValorDesconto]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="218" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item17>
        <Item18 Ref="219" ControlType="XRLabel" Name="fldDescontosLinha" TextAlignment="TopRight" SizeF="70,20.9583" LocationFloat="79.16663, 41.65185" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="220" Expression="[DescontosLinha]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="221" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item18>
        <Item19 Ref="222" ControlType="XRLabel" Name="fldSubTotal" TextFormatString="{0:€0.00}" TextAlignment="TopRight" SizeF="70,20.9583" LocationFloat="0, 41.65185" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="223" Expression="[SubTotal]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="224" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item19>
      </Controls>
    </Item6>
    <Item7 Ref="225" ControlType="GroupFooterBand" Name="GrpFooCarga" PrintAtBottom="true" Level="1" HeightF="56.99596">
      <Controls>
        <Item1 Ref="226" ControlType="XRLabel" Name="fldDataDescarga" TextFormatString="{0:dd-MM-yyyy HH:mm}" SizeF="160,12" LocationFloat="170.42, 40.99998" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="227" Expression="[DataDescarga]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="228" UseFont="false" />
        </Item1>
        <Item2 Ref="229" ControlType="XRLabel" Name="fldDataCarga" TextFormatString="{0:dd-MM-yyyy HH:mm}" SizeF="160.42,12" LocationFloat="0, 40.99998" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="230" Expression="[DataCarga]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="231" UseFont="false" />
        </Item2>
        <Item3 Ref="232" ControlType="XRLine" Name="XrLine9" SizeF="746.67,2" LocationFloat="0, 0" />
        <Item4 Ref="233" ControlType="XRLabel" Name="XrLabel2" Text="Expedição" TextAlignment="TopLeft" SizeF="121.83,12" LocationFloat="340.427, 4.999982" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Espedicao">
          <StylePriority Ref="234" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="235" ControlType="XRLabel" Name="XrLabel1" Text="Descarga" TextAlignment="TopLeft" SizeF="160,12" LocationFloat="170.42, 4.999982" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Descarga">
          <StylePriority Ref="236" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="237" ControlType="XRLabel" Name="lblCarga" Text="Carga" TextAlignment="TopLeft" SizeF="160.42,12" LocationFloat="0, 4.99999" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Carga">
          <StylePriority Ref="238" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="239" ControlType="XRLabel" Name="XrLabel5" Text="XrLabel5" SizeF="160.42,12" LocationFloat="0, 16.99997" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="240" Expression="[MoradaCarga]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="241" UseFont="false" />
        </Item7>
        <Item8 Ref="242" ControlType="XRLabel" Name="XrLabel11" Text="XrLabel11" SizeF="160,12" LocationFloat="170.427, 16.99998" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="243" Expression="[MoradaDescarga]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="244" UseFont="false" />
        </Item8>
        <Item9 Ref="245" ControlType="XRLabel" Name="XrLabel12" Text="XrLabel12" SizeF="121.83,12" LocationFloat="340.427, 16.99996" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="246" Expression="[Matricula]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="247" UseFont="false" />
        </Item9>
        <Item10 Ref="248" ControlType="XRLabel" Name="fldCodigoPostalCarga" Text="fldCodigoPostalCarga" SizeF="160.42,12" LocationFloat="0, 29" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="249" UseFont="false" />
        </Item10>
        <Item11 Ref="250" ControlType="XRLabel" Name="fldCodigoPostalDescarga" Text="fldCodigoPostalDescarga" SizeF="159.9831,12" LocationFloat="170.4369, 29" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="251" UseFont="false" />
        </Item11>
      </Controls>
    </Item7>
    <Item8 Ref="252" ControlType="ReportFooterBand" Name="ReportFooter" PrintAtBottom="true" HeightF="31.6">
      <Controls>
        <Item1 Ref="253" ControlType="XRSubreport" Name="DocumentosVendasObservacoes" ReportSourceUrl="10000" CanShrink="true" SizeF="747.0002,31.59755" LocationFloat="0, 0">
          <ParameterBindings>
            <Item1 Ref="254" ParameterName="Culture" Parameter="#Ref-7" />
            <Item2 Ref="255" ParameterName="Observacoes" Parameter="#Ref-12" />
            <Item3 Ref="256" ParameterName="IDDocumento" Parameter="#Ref-4" />
            <Item4 Ref="257" ParameterName="IDLoja" Parameter="#Ref-5" />
            <Item5 Ref="258" ParameterName="FraseFiscal" Parameter="#Ref-14" />
            <Item6 Ref="259" ParameterName="BDEmpresa" Parameter="#Ref-16" />
            <Item7 Ref="260" ParameterName="AcompanhaBens" Parameter="#Ref-18" />
          </ParameterBindings>
        </Item1>
        <Item2 Ref="261" ControlType="XRLine" Name="XrLine8" SizeF="747.0001,3.000001" LocationFloat="0, 0" />
      </Controls>
    </Item8>
    <Item9 Ref="262" ControlType="PageFooterBand" Name="PageFooter" HeightF="30.8075">
      <SubBands>
        <Item1 Ref="263" ControlType="SubBand" Name="SubBand3" HeightF="17.70833">
          <Controls>
            <Item1 Ref="264" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="746.6705,4" LocationFloat="0, 0" BorderWidth="3">
              <StylePriority Ref="265" UseBorderWidth="false" />
            </Item1>
            <Item2 Ref="266" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="625.4193, 4.000028" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="267" UseFont="false" UseTextAlignment="false" />
            </Item2>
          </Controls>
        </Item1>
      </SubBands>
      <Controls>
        <Item1 Ref="268" ControlType="XRLabel" Name="fldAssinatura1" TextAlignment="MiddleLeft" SizeF="445.7733,13" LocationFloat="2.023193, 15.71143" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="269" OnPrintOnPage="fldAssinatura1_PrintOnPage" />
          <ExpressionBindings>
            <Item1 Ref="270" Expression="Iif([PageIndex] = 0, False, ?)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="271" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="272" ControlType="XRLabel" Name="fldAssinatura11" TextAlignment="MiddleRight" SizeF="445.7733,13" LocationFloat="299.2035, 15.71143" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="273" OnPrintOnPage="fldAssinatura11_PrintOnPage" />
          <ExpressionBindings>
            <Item1 Ref="274" Expression="Iif([PageIndex] = 0, False, ?)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="275" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="276" ControlType="XRLabel" Name="lblTransporte" TextFormatString="{0:0.00}" TextAlignment="MiddleLeft" SizeF="187.58,12" LocationFloat="559.2569, 0.4443703" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <Scripts Ref="277" OnSummaryGetResult="lblTransporte_SummaryGetResult" OnPrintOnPage="lblTransporte_PrintOnPage" />
          <Summary Ref="278" Running="Page" IgnoreNullValues="true" />
          <StylePriority Ref="279" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="280" ControlType="XRLabel" Name="lblTituloTransporte" Text="Transportar" TextAlignment="MiddleRight" SizeF="78.96,12" LocationFloat="477.2983, 0.4443703" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="281" OnPrintOnPage="lblTituloTransporte_PrintOnPage" />
          <StylePriority Ref="282" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
      </Controls>
    </Item9>
    <Item10 Ref="283" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="570" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="284" OnBeforePrint="DocumentosVendasA5HNovo49_BeforePrint" />
  <ExportOptions Ref="285">
    <Html Ref="286" ExportMode="SingleFilePageByPage" />
  </ExportOptions>
  <Watermark Ref="287" ShowBehind="false" Text="CONFIDENTIAL" Font="Arial, 96pt" />
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="10" Content="System.Int32" Type="System.Type" />
    <Item3 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="17" Content="System.Boolean" Type="System.Type" />
    <Item4 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Name="SqlDataSource" Base64="PFNxbERhdGFTb3VyY2UgTmFtZT0iU3FsRGF0YVNvdXJjZSI+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9cHJpc21hLWxhYi12bS53ZXN0ZXVyb3BlLmNsb3VkYXBwLmF6dXJlLmNvbSwxNDMzO1VzZXIgSUQ9RjNNTztQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID0xMDAwMEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJEb2N1bWVudG9zVmVuZGFzIj48UGFyYW1ldGVyIE5hbWU9IklERG9jdW1lbnRvIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5JbnQ2NCwgbXNjb3JsaWIsIFZlcnNpb249NC4wLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5KSg/SUREb2N1bWVudG8pPC9QYXJhbWV0ZXI+PFNxbD5zZWxlY3QgZGlzdGluY3QgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRCIsDQoJICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRExvamFTZWRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iQ29kaWdvUG9zdGFsU2VkZSIsIA0KCSAidGJEb2N1bWVudG9zVmVuZGFzIi4iTG9jYWxpZGFkZVNlZGUiLA0KCSAidGJEb2N1bWVudG9zVmVuZGFzIi4iTW9yYWRhU2VkZSIsDQoJICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJUZWxlZm9uZVNlZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRFRpcG9Eb2N1bWVudG8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOdW1lcm9Eb2N1bWVudG8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEYXRhRG9jdW1lbnRvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iT2JzZXJ2YWNvZXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRE1vZWRhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iQ29kaWdvUG9zdGFsTG9qYSIsIA0KCSAidGJEb2N1bWVudG9zVmVuZGFzIi4iTG9jYWxpZGFkZUxvamEiLA0KCSAidGJEb2N1bWVudG9zVmVuZGFzIi4iU2lnbGFMb2phIiwNCgkgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk5JRkxvamEiLA0KCSAidGJEb2N1bWVudG9zVmVuZGFzIi4iTW9yYWRhTG9qYSIsDQoJICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEZXNpZ25hY2FvQ29tZXJjaWFsTG9qYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRheGFDb252ZXJzYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJUb3RhbE1vZWRhRG9jdW1lbnRvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVG90YWxNb2VkYVJlZmVyZW5jaWEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJMb2NhbENhcmdhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YUNhcmdhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSG9yYUNhcmdhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iTW9yYWRhQ2FyZ2EiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRENvZGlnb1Bvc3RhbENhcmdhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb25jZWxob0NhcmdhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSUREaXN0cml0b0NhcmdhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iTG9jYWxEZXNjYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFEZXNjYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkhvcmFEZXNjYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk1vcmFkYURlc2NhcmdhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29uY2VsaG9EZXNjYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERGlzdHJpdG9EZXNjYXJnYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk5vbWVEZXN0aW5hdGFyaW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3JhZGFEZXN0aW5hdGFyaW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRENvZGlnb1Bvc3RhbERlc3RpbmF0YXJpbyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iU2VyaWVEb2NNYW51YWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOdW1lcm9Eb2NNYW51YWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOdW1lcm9MaW5oYXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJQb3N0byIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERXN0YWRvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVXRpbGl6YWRvckVzdGFkbyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFIb3JhRXN0YWRvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iQXNzaW5hdHVyYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlZlcnNhb0NoYXZlUHJpdmFkYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk5vbWVGaXNjYWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3JhZGFGaXNjYWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRENvZGlnb1Bvc3RhbEZpc2NhbCIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29uY2VsaG9GaXNjYWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRERpc3RyaXRvRmlzY2FsIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iQ29udHJpYnVpbnRlRmlzY2FsIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iU2lnbGFQYWlzRmlzY2FsIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURMb2phIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSW1wcmVzc28iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJWYWxvckltcG9zdG8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJQZXJjZW50YWdlbURlc2NvbnRvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVmFsb3JEZXNjb250byIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlZhbG9yUG9ydGVzIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURUYXhhSXZhUG9ydGVzIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVGF4YUl2YVBvcnRlcyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk1vdGl2b0lzZW5jYW9JdmEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURFc3BhY29GaXNjYWxQb3J0ZXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJFc3BhY29GaXNjYWxQb3J0ZXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRFJlZ2ltZUl2YVBvcnRlcyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlJlZ2ltZUl2YVBvcnRlcyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkN1c3Rvc0FkaWNpb25haXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJTaXN0ZW1hIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iQXRpdm8iLA0KICAgICAgIChjYXNlIHdoZW4gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFBc3NpbmF0dXJhIiBpcyBudWxsIHRoZW4gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFDcmlhY2FvIiBlbHNlICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEYXRhQXNzaW5hdHVyYSIgZW5kKSBhcyBEYXRhQ3JpYWNhbywNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVXRpbGl6YWRvckNyaWFjYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEYXRhQWx0ZXJhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkYzTU1hcmNhZG9yIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURGb3JtYUV4cGVkaWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOdW1lcm9JbnRlcm5vIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURFbnRpZGFkZSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEVGlwb0VudGlkYWRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb25kaWNhb1BhZ2FtZW50byIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ2xpZW50ZSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkNvZGlnb0FUIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YVZlbmNpbWVudG8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEYXRhTmFzY2ltZW50byIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklkYWRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURFbnRpZGFkZTEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOdW1lcm9CZW5lZmljaWFyaW8xIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iUGFyZW50ZXNjbzEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREVudGlkYWRlMiIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk51bWVyb0JlbmVmaWNpYXJpbzIiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJQYXJlbnRlc2NvMiIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkVtYWlsIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iU3ViVG90YWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEZXNjb250b3NMaW5oYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk91dHJvc0Rlc2NvbnRvcyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRvdGFsUG9udG9zIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVG90YWxWYWxlc09mZXJ0YSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRvdGFsSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVG90YWxFbnRpZGFkZTEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJUb3RhbEVudGlkYWRlMiIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEUGFpc0NhcmdhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURQYWlzRGVzY2FyZ2EiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNYXRyaWN1bGEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJFbnRpZGFkZTFBdXRvbWF0aWNhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURMb2NhbE9wZXJhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIi4iTWVuc2FnZW1Eb2NBVCIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkNvZGlnb1RpcG9Fc3RhZG8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJTZWd1bmRhVmlhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iSUQiIGFzICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNfSUQiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJJRERvY3VtZW50b1ZlbmRhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iSURDYW1wYW5oYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIklEQXJ0aWdvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iRGVzY3JpY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iSURVbmlkYWRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iTnVtQ2FzYXNEZWNVbmlkYWRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iUXVhbnRpZGFkZSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlByZWNvVW5pdGFyaW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJQcmVjb1VuaXRhcmlvRWZldGl2byIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlByZWNvVG90YWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJPYnNlcnZhY29lcyIgYXMgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc19PYnNlcnZhY29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIklETG90ZSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIkNvZGlnb0xvdGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJEZXNjcmljYW9Mb3RlIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iRGF0YUZhYnJpY29Mb3RlIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iRGF0YVZhbGlkYWRlTG90ZSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIklEQXJ0aWdvTnVtU2VyaWUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJBcnRpZ29OdW1TZXJpZSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIklEQXJtYXplbSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIklEQXJtYXplbUxvY2FsaXphY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iSURBcm1hemVtRGVzdGlubyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIklEQXJtYXplbUxvY2FsaXphY2FvRGVzdGlubyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIk51bUxpbmhhc0RpbWVuc29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIkRlc2NvbnRvMSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIkRlc2NvbnRvMiIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIklEVGF4YUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlRheGFJdmEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJNb3Rpdm9Jc2VuY2FvSXZhIiBhcyAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzX01vdGl2b0lzZW5jYW9JdmEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJWYWxvckltcG9zdG8iIGFzICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNfVmFsb3JJbXBvc3RvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iSURFc3BhY29GaXNjYWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJFc3BhY29GaXNjYWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJJRFJlZ2ltZUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlJlZ2ltZUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlNpZ2xhUGFpcyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIk9yZGVtIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iU2lzdGVtYSIgYXMgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc19TaXN0ZW1hIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iQXRpdm8iIGFzICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNfQXRpdm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJEYXRhQ3JpYWNhbyIgYXMgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc19EYXRhQ3JpYWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlV0aWxpemFkb3JDcmlhY2FvIiBhcyAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzX1V0aWxpemFkb3JDcmlhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iRGF0YUFsdGVyYWNhbyIgYXMgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc19EYXRhQWx0ZXJhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIgYXMgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc19VdGlsaXphZG9yQWx0ZXJhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iRjNNTWFyY2Fkb3IiIGFzICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNfRjNNTWFyY2Fkb3IiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJEaWFtZXRybyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlZhbG9yRGVzY29udG9MaW5oYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlRvdGFsQ29tRGVzY29udG9MaW5oYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlZhbG9yRGVzY29udG9DYWJlY2FsaG8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJUb3RhbENvbURlc2NvbnRvQ2FiZWNhbGhvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iVmFsb3JVbml0YXJpb0VudGlkYWRlMSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlZhbG9yVW5pdGFyaW9FbnRpZGFkZTIiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJWYWxvckVudGlkYWRlMSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlZhbG9yRW50aWRhZGUyIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iVG90YWxGaW5hbCIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIklEU2VydmljbyIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIklEVGlwb1NlcnZpY28iLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJJRFRpcG9PbGhvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iVGlwb0Rpc3RhbmNpYSIsDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIlRpcG9PbGhvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iSURUaXBvR3JhZHVhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iVmFsb3JJbmNpZGVuY2lhIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iVmFsb3JJVkEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiLiJEb2N1bWVudG9PcmlnZW0iLA0KICAgICAgICJ0YkNsaWVudGVzIi4iQ29kaWdvIiwgInRiQ2xpZW50ZXMiLiJOb21lIiwNCiAgICAgICAidGJFc3RhZG9zIi4iQ29kaWdvIiBhcyAidGJFc3RhZG9zX0NvZGlnbyIsDQogICAgICAgInRiRXN0YWRvcyIuIkRlc2NyaWNhbyIgYXMgInRiRXN0YWRvc19EZXNjcmljYW8iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iQ29kaWdvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Db2RpZ28iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iQ29kaWdvU2VyaWUiLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iRGVzY3JpY2FvU2VyaWUiLA0KICAgICAgICJ0YkFydGlnb3MiLiJDb2RpZ28iIGFzICJ0YkFydGlnb3NfQ29kaWdvIiwNCiAgICAgICAidGJBcnRpZ29zIi4iRGVzY3JpY2FvQWJyZXZpYWRhIiwNCiAgICAgICAidGJBcnRpZ29zIi4iRGVzY3JpY2FvIiBhcyAidGJBcnRpZ29zX0Rlc2NyaWNhbyIsDQogICAgICAgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiwNCiAgICAgICAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJUaXBvIiwNCiAgICAgICAidGJFbnRpZGFkZXMxIi4iQ29kaWdvIiBhcyAidGJFbnRpZGFkZXMxX0NvZGlnbyIsDQogICAgICAgInRiRW50aWRhZGVzMSIuIkRlc2NyaWNhbyIgYXMgInRiRW50aWRhZGVzMV9EZXNjcmljYW8iLA0KICAgICAgICJ0YkVudGlkYWRlczIiLiJDb2RpZ28iIGFzICJ0YkVudGlkYWRlczJfQ29kaWdvIiwNCiAgICAgICAidGJFbnRpZGFkZXMyIi4iRGVzY3JpY2FvIiBhcyAidGJFbnRpZGFkZXMyX0Rlc2NyaWNhbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMxIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc19Db2RpZ28iLA0KICAgICAgICJ0YkNvZGlnb3NQb3N0YWlzMSIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNfRGVzY3JpY2FvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczIiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfQ29kaWdvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczIiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczMiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfQ29kaWdvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczMiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfRGVzY3JpY2FvIiwNCiAgICAgICAidGJNb2VkYXMiLiJDb2RpZ28iIGFzICJ0Yk1vZWRhc19Db2RpZ28iLA0KICAgICAgICJ0Yk1vZWRhcyIuIkRlc2NyaWNhbyIgYXMgInRiTW9lZGFzX0Rlc2NyaWNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iU2ltYm9sbyIgYXMgInRiTW9lZGFzX1NpbWJvbG8iLA0KICAgICAgICJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNUb3RhaXMiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzIiwNCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iQ29kaWdvTW90aXZvSXNlbmNhb0l2YSIsDQogICAgICAgInRiU2lzdGVtYU1vZWRhcyIuIkNvZGlnbyIgYXMgInRiU2lzdGVtYU1vZWRhc19Db2RpZ28iDQogIGZyb20gImRibyIuInRiRG9jdW1lbnRvc1ZlbmRhcyINCiAgICAgICAidGJEb2N1bWVudG9zVmVuZGFzIg0KICBpbm5lciBqb2luICJkYm8iLiJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMiDQogICAgICAgInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyINCiAgICAgICBvbiAidGJEb2N1bWVudG9zVmVuZGFzTGluaGFzIi4iSUREb2N1bWVudG9WZW5kYSIgPSAidGJEb2N1bWVudG9zVmVuZGFzIi4iSUQiDQogIGlubmVyIGpvaW4gImRibyIuInRiQ2xpZW50ZXMiICJ0YkNsaWVudGVzIg0KICAgICAgIG9uICJ0YkNsaWVudGVzIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERW50aWRhZGUiDQogIGxlZnQgam9pbiAiZGJvIi4idGJFc3RhZG9zIiAidGJFc3RhZG9zIg0KICAgICAgIG9uICJ0YkVzdGFkb3MiLiJJRCIgPSAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURFc3RhZG8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJUaXBvc0RvY3VtZW50byINCiAgICAgICAidGJUaXBvc0RvY3VtZW50byINCiAgICAgICBvbiAidGJUaXBvc0RvY3VtZW50byIuIklEIiA9ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRFRpcG9Eb2N1bWVudG8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJUaXBvc0RvY3VtZW50b1NlcmllcyINCiAgICAgICAidGJUaXBvc0RvY3VtZW50b1NlcmllcyINCiAgICAgICBvbiAidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KICBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIg0KICAgICAgICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCINCiAgICAgICBvbiAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJJRCIgPSAidGJUaXBvc0RvY3VtZW50byIuIklEU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIg0KICBsZWZ0IGpvaW4gImRibyIuInRiQXJ0aWdvcyIgInRiQXJ0aWdvcyINCiAgICAgICBvbiAidGJBcnRpZ29zIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyIuIklEQXJ0aWdvIg0KICBsZWZ0ICBqb2luICJkYm8iLiJ0YkVudGlkYWRlcyIgInRiRW50aWRhZGVzMSINCiAgICAgICBvbiAidGJFbnRpZGFkZXMxIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERW50aWRhZGUxIg0KICBsZWZ0IGpvaW4gImRibyIuInRiRW50aWRhZGVzIiAidGJFbnRpZGFkZXMyIg0KICAgICAgIG9uICJ0YkVudGlkYWRlczIiLiJJRCIgPSAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURFbnRpZGFkZTIiDQogIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMxIg0KICAgICAgIG9uICJ0YkNvZGlnb3NQb3N0YWlzMSIuIklEIiA9ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRENvZGlnb1Bvc3RhbEZpc2NhbCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczIiDQogICAgICAgb24gInRiQ29kaWdvc1Bvc3RhaXMyIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiDQogIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMzIg0KICAgICAgIG9uICJ0YkNvZGlnb3NQb3N0YWlzMyIuIklEIiA9ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIg0KICBsZWZ0IGpvaW4gImRibyIuInRiTW9lZGFzIiAidGJNb2VkYXMiDQogICAgICAgb24gInRiTW9lZGFzIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklETW9lZGEiDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hTW9lZGFzIiAidGJTaXN0ZW1hTW9lZGFzIg0KICAgICAgIG9uICJ0YlNpc3RlbWFNb2VkYXMiLiJJRCIgPSAidGJNb2VkYXMiLiJJRFNpc3RlbWFNb2VkYSINCndoZXJlICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRCI9QElERG9jdW1lbnRvPC9TcWw+PC9RdWVyeT48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiUGFyYW1ldHJvc0xvamFzIj48UGFyYW1ldGVyIE5hbWU9IklETG9qYSIgVHlwZT0iRGV2RXhwcmVzcy5EYXRhQWNjZXNzLkV4cHJlc3Npb24iPihTeXN0ZW0uSW50NjQsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OSkoW1BhcmFtZXRlcnMuSURMb2phXSk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCAidGJMb2phcyIuIkNvZGlnbyIsICJ0YkxvamFzIi4iRGVzY3JpY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuKiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklEIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklETW9lZGFEZWZlaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIk1vcmFkYSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJGb3RvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkZvdG9DYW1pbmhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkRlc2lnbmFjYW9Db21lcmNpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ29kaWdvUG9zdGFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkxvY2FsaWRhZGUiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ29uY2VsaG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRGlzdHJpdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iSURQYWlzIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIlRlbGVmb25lIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkZheCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJFbWFpbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJXZWJTaXRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIk5JRiIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNhcGl0YWxTb2NpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklETG9qYSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRElkaW9tYUJhc2UiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iU2lzdGVtYSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJBdGl2byIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJEYXRhQ3JpYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJVdGlsaXphZG9yQ3JpYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJEYXRhQWx0ZXJhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIlV0aWxpemFkb3JBbHRlcmFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRjNNTWFyY2Fkb3IiLA0KICAgICAgICJ0Yk1vZWRhcyIuIlNpbWJvbG8iDQogIGZyb20gKCgiZGJvIi4idGJMb2phcyIgInRiTG9qYXMiDQogIGlubmVyIGpvaW4gImRibyIuInRiUGFyYW1ldHJvc0xvamEiDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiDQogICAgICAgb24gKCJ0YlBhcmFtZXRyb3NMb2phIi4iSURMb2phIiA9ICJ0YkxvamFzIi4iSUQiKSkNCiAgaW5uZXIgam9pbiAiZGJvIi4idGJNb2VkYXMiICJ0Yk1vZWRhcyINCiAgICAgICBvbiAoInRiTW9lZGFzIi4iSUQiID0gInRiUGFyYW1ldHJvc0xvamEiLiJJRE1vZWRhRGVmZWl0byIpKQ0Kd2hlcmUgInRiUGFyYW1ldHJvc0xvamEiLiJJRExvamEiID0gQElETG9qYTwvU3FsPjxNZXRhIFg9IjE0MCIgWT0iMjAiIFdpZHRoPSIxMDAiIEhlaWdodD0iNTY0IiAvPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IkN1c3RvbVNxbFF1ZXJ5IiBOYW1lPSJDdXN0b21TcWxRdWVyeSI+PFBhcmFtZXRlciBOYW1lPSJJRERvY3VtZW50byIgVHlwZT0iRGV2RXhwcmVzcy5EYXRhQWNjZXNzLkV4cHJlc3Npb24iPihTeXN0ZW0uSW50NjQsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OSkoP0lERG9jdW1lbnRvKTwvUGFyYW1ldGVyPjxTcWw+DQoNCnNlbGVjdCBkaXN0aW5jdCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSUQiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURMb2phU2VkZSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJDb2RpZ29Qb3N0YWxTZWRlIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkxvY2FsaWRhZGVTZWRlIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk1vcmFkYVNlZGUiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iVGVsZWZvbmVTZWRlIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEVGlwb0RvY3VtZW50byIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOdW1lcm9Eb2N1bWVudG8iLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YURvY3VtZW50byIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJPYnNlcnZhY29lcyIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRE1vZWRhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkNvZGlnb1Bvc3RhbExvamEiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iTG9jYWxpZGFkZUxvamEiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iU2lnbGFMb2phIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk5JRkxvamEiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iTW9yYWRhTG9qYSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEZXNpZ25hY2FvQ29tZXJjaWFsTG9qYSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJUYXhhQ29udmVyc2FvIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRvdGFsTW9lZGFEb2N1bWVudG8iLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iVG90YWxNb2VkYVJlZmVyZW5jaWEiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iTG9jYWxDYXJnYSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEYXRhQ2FyZ2EiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSG9yYUNhcmdhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk1vcmFkYUNhcmdhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb25jZWxob0NhcmdhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERGlzdHJpdG9DYXJnYSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJMb2NhbERlc2NhcmdhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFEZXNjYXJnYSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJIb3JhRGVzY2FyZ2EiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iTW9yYWRhRGVzY2FyZ2EiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRENvbmNlbGhvRGVzY2FyZ2EiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSUREaXN0cml0b0Rlc2NhcmdhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk5vbWVEZXN0aW5hdGFyaW8iLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iTW9yYWRhRGVzdGluYXRhcmlvIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJTZXJpZURvY01hbnVhbCIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOdW1lcm9Eb2NNYW51YWwiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iTnVtZXJvTGluaGFzIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlBvc3RvIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERXN0YWRvIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlV0aWxpemFkb3JFc3RhZG8iLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YUhvcmFFc3RhZG8iLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iQXNzaW5hdHVyYSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJWZXJzYW9DaGF2ZVByaXZhZGEiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iTm9tZUZpc2NhbCIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3JhZGFGaXNjYWwiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb25jZWxob0Zpc2NhbCIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRERpc3RyaXRvRmlzY2FsIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkNvbnRyaWJ1aW50ZUZpc2NhbCIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJTaWdsYVBhaXNGaXNjYWwiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURMb2phIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkltcHJlc3NvIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlZhbG9ySW1wb3N0byIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJQZXJjZW50YWdlbURlc2NvbnRvIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlZhbG9yRGVzY29udG8iLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iVmFsb3JQb3J0ZXMiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURUYXhhSXZhUG9ydGVzIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRheGFJdmFQb3J0ZXMiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iTW90aXZvSXNlbmNhb0l2YSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERXNwYWNvRmlzY2FsUG9ydGVzIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkVzcGFjb0Zpc2NhbFBvcnRlcyIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRFJlZ2ltZUl2YVBvcnRlcyIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJSZWdpbWVJdmFQb3J0ZXMiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iQ3VzdG9zQWRpY2lvbmFpcyIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJTaXN0ZW1hIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkF0aXZvIiwgKGNhc2Ugd2hlbiAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YUFzc2luYXR1cmEiIGlzIG51bGwgdGhlbiAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YUNyaWFjYW8iIGVsc2UgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFBc3NpbmF0dXJhIiBlbmQpIGFzIERhdGFDcmlhY2FvLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iVXRpbGl6YWRvckNyaWFjYW8iLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YUFsdGVyYWNhbyIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJVdGlsaXphZG9yQWx0ZXJhY2FvIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkYzTU1hcmNhZG9yIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERm9ybWFFeHBlZGljYW8iLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURUaXBvc0RvY3VtZW50b1NlcmllcyIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOdW1lcm9JbnRlcm5vIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERW50aWRhZGUiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURUaXBvRW50aWRhZGUiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb25kaWNhb1BhZ2FtZW50byIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRENsaWVudGUiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iQ29kaWdvQVQiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YVZlbmNpbWVudG8iLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YU5hc2NpbWVudG8iLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSWRhZGUiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURFbnRpZGFkZTEiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iTnVtZXJvQmVuZWZpY2lhcmlvMSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJQYXJlbnRlc2NvMSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREVudGlkYWRlMiIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOdW1lcm9CZW5lZmljaWFyaW8yIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlBhcmVudGVzY28yIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkVtYWlsIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlN1YlRvdGFsIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRlc2NvbnRvc0xpbmhhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk91dHJvc0Rlc2NvbnRvcyIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJUb3RhbFBvbnRvcyIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJUb3RhbFZhbGVzT2ZlcnRhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRvdGFsSXZhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRvdGFsRW50aWRhZGUxIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRvdGFsRW50aWRhZGUyIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEUGFpc0NhcmdhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEUGFpc0Rlc2NhcmdhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk1hdHJpY3VsYSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJFbnRpZGFkZTFBdXRvbWF0aWNhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklETG9jYWxPcGVyYWNhbyIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNZW5zYWdlbURvY0FUIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkNvZGlnb1RpcG9Fc3RhZG8iLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iU2VndW5kYVZpYSIsICJ0YkNsaWVudGVzIi4iQ29kaWdvIiwgInRiQ2xpZW50ZXMiLiJOb21lIiwgInRiRXN0YWRvcyIuIkNvZGlnbyIgYXMgInRiRXN0YWRvc19Db2RpZ28iLCAidGJFc3RhZG9zIi4iRGVzY3JpY2FvIiBhcyAidGJFc3RhZG9zX0Rlc2NyaWNhbyIsICJ0YlRpcG9zRG9jdW1lbnRvIi4iQ29kaWdvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Db2RpZ28iLCAidGJUaXBvc0RvY3VtZW50byIuIkRlc2NyaWNhbyIgYXMgInRiVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiwgInRiVGlwb3NEb2N1bWVudG8iLiJBY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIsICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iQ29kaWdvU2VyaWUiLCAidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIkRlc2NyaWNhb1NlcmllIiwgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiwgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iVGlwbyIsICJ0YkVudGlkYWRlczEiLiJDb2RpZ28iIGFzICJ0YkVudGlkYWRlczFfQ29kaWdvIiwgInRiRW50aWRhZGVzMSIuIkRlc2NyaWNhbyIgYXMgInRiRW50aWRhZGVzMV9EZXNjcmljYW8iLCAidGJFbnRpZGFkZXMyIi4iQ29kaWdvIiBhcyAidGJFbnRpZGFkZXMyX0NvZGlnbyIsICJ0YkVudGlkYWRlczIiLiJEZXNjcmljYW8iIGFzICJ0YkVudGlkYWRlczJfRGVzY3JpY2FvIiwgInRiQ29kaWdvc1Bvc3RhaXMxIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc19Db2RpZ28iLCAidGJDb2RpZ29zUG9zdGFpczEiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIsICJ0YkNvZGlnb3NQb3N0YWlzMiIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDYXJnYV9Db2RpZ28iLCAidGJDb2RpZ29zUG9zdGFpczIiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiwgInRiQ29kaWdvc1Bvc3RhaXMzIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0NvZGlnbyIsICJ0YkNvZGlnb3NQb3N0YWlzMyIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9EZXNjcmljYW8iLCAidGJNb2VkYXMiLiJDb2RpZ28iIGFzICJ0Yk1vZWRhc19Db2RpZ28iLCAidGJNb2VkYXMiLiJEZXNjcmljYW8iIGFzICJ0Yk1vZWRhc19EZXNjcmljYW8iLCAidGJNb2VkYXMiLiJTaW1ib2xvIiBhcyAidGJNb2VkYXNfU2ltYm9sbyIsICJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNUb3RhaXMiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzIiwgInRiU2lzdGVtYU1vZWRhcyIuIkNvZGlnbyIgYXMgInRiU2lzdGVtYU1vZWRhc19Db2RpZ28iDQpmcm9tICgoKCgoKCgoKCgoKCJkYm8iLiJ0YkRvY3VtZW50b3NWZW5kYXMiICJ0YkRvY3VtZW50b3NWZW5kYXMiDQppbm5lciBqb2luICJkYm8iLiJ0YkNsaWVudGVzIiAidGJDbGllbnRlcyIgb24gKCJ0YkNsaWVudGVzIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERW50aWRhZGUiKSkNCmxlZnQgam9pbiAiZGJvIi4idGJFc3RhZG9zIiAidGJFc3RhZG9zIiBvbiAoInRiRXN0YWRvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREVzdGFkbyIpKQ0KbGVmdCBqb2luICJkYm8iLiJ0YlRpcG9zRG9jdW1lbnRvIiAidGJUaXBvc0RvY3VtZW50byIgb24gKCJ0YlRpcG9zRG9jdW1lbnRvIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEVGlwb0RvY3VtZW50byIpKQ0KbGVmdCBqb2luICJkYm8iLiJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIiAidGJUaXBvc0RvY3VtZW50b1NlcmllcyIgb24gKCJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiKSkNCmxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIgb24gKCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIklEIiA9ICJ0YlRpcG9zRG9jdW1lbnRvIi4iSURTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiKSkNCmxlZnQgam9pbiAiZGJvIi4idGJFbnRpZGFkZXMiICJ0YkVudGlkYWRlczEiIG9uICgidGJFbnRpZGFkZXMxIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERW50aWRhZGUxIikpDQpsZWZ0IGpvaW4gImRibyIuInRiRW50aWRhZGVzIiAidGJFbnRpZGFkZXMyIiBvbiAoInRiRW50aWRhZGVzMiIuIklEIiA9ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREVudGlkYWRlMiIpKQ0KbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczEiIG9uICgidGJDb2RpZ29zUG9zdGFpczEiLiJJRCIgPSAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiKSkNCmxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMyIiBvbiAoInRiQ29kaWdvc1Bvc3RhaXMyIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiKSkNCmxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMzIiBvbiAoInRiQ29kaWdvc1Bvc3RhaXMzIi4iSUQiID0gInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiKSkNCmxlZnQgam9pbiAiZGJvIi4idGJNb2VkYXMiICJ0Yk1vZWRhcyIgb24gKCJ0Yk1vZWRhcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRE1vZWRhIikpDQpsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYU1vZWRhcyIgInRiU2lzdGVtYU1vZWRhcyIgb24gKCJ0YlNpc3RlbWFNb2VkYXMiLiJJRCIgPSAidGJNb2VkYXMiLiJJRFNpc3RlbWFNb2VkYSIpKQ0Kd2hlcmUgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEIj0gQElERG9jdW1lbnRvIA0KZ3JvdXAgYnkgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklETG9qYVNlZGUiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iQ29kaWdvUG9zdGFsU2VkZSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJMb2NhbGlkYWRlU2VkZSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3JhZGFTZWRlIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRlbGVmb25lU2VkZSIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRFRpcG9Eb2N1bWVudG8iLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk51bWVyb0RvY3VtZW50byIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YURvY3VtZW50byIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iT2JzZXJ2YWNvZXMiLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklETW9lZGEiLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkNvZGlnb1Bvc3RhbExvamEiLCAgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJMb2NhbGlkYWRlTG9qYSIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iU2lnbGFMb2phIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOSUZMb2phIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3JhZGFMb2phIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEZXNpZ25hY2FvQ29tZXJjaWFsTG9qYSIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVGF4YUNvbnZlcnNhbyIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVG90YWxNb2VkYURvY3VtZW50byIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVG90YWxNb2VkYVJlZmVyZW5jaWEiLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkxvY2FsQ2FyZ2EiLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFDYXJnYSIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSG9yYUNhcmdhIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3JhZGFDYXJnYSIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb25jZWxob0NhcmdhIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRERpc3RyaXRvQ2FyZ2EiLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkxvY2FsRGVzY2FyZ2EiLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFEZXNjYXJnYSIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSG9yYURlc2NhcmdhIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3JhZGFEZXNjYXJnYSIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb25jZWxob0Rlc2NhcmdhIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRERpc3RyaXRvRGVzY2FyZ2EiLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk5vbWVEZXN0aW5hdGFyaW8iLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk1vcmFkYURlc3RpbmF0YXJpbyIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERGlzdHJpdG9EZXN0aW5hdGFyaW8iLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlNlcmllRG9jTWFudWFsIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOdW1lcm9Eb2NNYW51YWwiLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk51bWVyb0xpbmhhcyIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iUG9zdG8iLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERXN0YWRvIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJVdGlsaXphZG9yRXN0YWRvIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEYXRhSG9yYUVzdGFkbyIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iQXNzaW5hdHVyYSIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVmVyc2FvQ2hhdmVQcml2YWRhIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOb21lRmlzY2FsIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3JhZGFGaXNjYWwiLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklEQ29kaWdvUG9zdGFsRmlzY2FsIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRENvbmNlbGhvRmlzY2FsIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRERpc3RyaXRvRmlzY2FsIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJDb250cmlidWludGVGaXNjYWwiLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlNpZ2xhUGFpc0Zpc2NhbCIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURMb2phIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJbXByZXNzbyIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVmFsb3JJbXBvc3RvIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJQZXJjZW50YWdlbURlc2NvbnRvIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJWYWxvckRlc2NvbnRvIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJWYWxvclBvcnRlcyIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURUYXhhSXZhUG9ydGVzIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJUYXhhSXZhUG9ydGVzIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3Rpdm9Jc2VuY2FvSXZhIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREVzcGFjb0Zpc2NhbFBvcnRlcyIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iRXNwYWNvRmlzY2FsUG9ydGVzIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRFJlZ2ltZUl2YVBvcnRlcyIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iUmVnaW1lSXZhUG9ydGVzIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJDdXN0b3NBZGljaW9uYWlzIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJTaXN0ZW1hIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJBdGl2byIsICAoY2FzZSB3aGVuICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEYXRhQXNzaW5hdHVyYSIgaXMgbnVsbCB0aGVuICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJEYXRhQ3JpYWNhbyIgZWxzZSAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YUFzc2luYXR1cmEiIGVuZCksICAidGJEb2N1bWVudG9zVmVuZGFzIi4iVXRpbGl6YWRvckNyaWFjYW8iLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFBbHRlcmFjYW8iLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlV0aWxpemFkb3JBbHRlcmFjYW8iLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkYzTU1hcmNhZG9yIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREZvcm1hRXhwZWRpY2FvIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJOdW1lcm9JbnRlcm5vIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJREVudGlkYWRlIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJRFRpcG9FbnRpZGFkZSIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDb25kaWNhb1BhZ2FtZW50byIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURDbGllbnRlIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJDb2RpZ29BVCIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGF0YVZlbmNpbWVudG8iLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkRhdGFOYXNjaW1lbnRvIiwgICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJJZGFkZSIsICAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURFbnRpZGFkZTEiLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk51bWVyb0JlbmVmaWNpYXJpbzEiLCAgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlBhcmVudGVzY28xIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIklERW50aWRhZGUyIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk51bWVyb0JlbmVmaWNpYXJpbzIiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iUGFyZW50ZXNjbzIiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iRW1haWwiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iU3ViVG90YWwiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iRGVzY29udG9zTGluaGEiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iT3V0cm9zRGVzY29udG9zIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRvdGFsUG9udG9zIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIlRvdGFsVmFsZXNPZmVydGEiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iVG90YWxJdmEiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iVG90YWxFbnRpZGFkZTEiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iVG90YWxFbnRpZGFkZTIiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURQYWlzQ2FyZ2EiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURQYWlzRGVzY2FyZ2EiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iTWF0cmljdWxhIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIkVudGlkYWRlMUF1dG9tYXRpY2EiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iSURMb2NhbE9wZXJhY2FvIiwgInRiRG9jdW1lbnRvc1ZlbmRhcyIuIk1lbnNhZ2VtRG9jQVQiLCAidGJEb2N1bWVudG9zVmVuZGFzIi4iQ29kaWdvVGlwb0VzdGFkbyIsICJ0YkRvY3VtZW50b3NWZW5kYXMiLiJTZWd1bmRhVmlhIiwgInRiQ2xpZW50ZXMiLiJDb2RpZ28iLCAidGJDbGllbnRlcyIuIk5vbWUiLCAidGJFc3RhZG9zIi4iQ29kaWdvIiwgInRiRXN0YWRvcyIuIkRlc2NyaWNhbyIsICJ0YlRpcG9zRG9jdW1lbnRvIi4iQ29kaWdvIiwgInRiVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iLCAidGJUaXBvc0RvY3VtZW50byIuIkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiwgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iRGVzY3JpY2FvU2VyaWUiLCAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJEZXNjcmljYW8iLCAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJUaXBvIiwgInRiRW50aWRhZGVzMSIuIkNvZGlnbyIsICJ0YkVudGlkYWRlczEiLiJEZXNjcmljYW8iLCAidGJFbnRpZGFkZXMyIi4iQ29kaWdvIiwgInRiRW50aWRhZGVzMiIuIkRlc2NyaWNhbyIsICJ0YkNvZGlnb3NQb3N0YWlzMSIuIkNvZGlnbyIsICJ0YkNvZGlnb3NQb3N0YWlzMSIuIkRlc2NyaWNhbyIsICJ0YkNvZGlnb3NQb3N0YWlzMiIuIkNvZGlnbyIsICJ0YkNvZGlnb3NQb3N0YWlzMiIuIkRlc2NyaWNhbyIsICJ0YkNvZGlnb3NQb3N0YWlzMyIuIkNvZGlnbyIsICJ0YkNvZGlnb3NQb3N0YWlzMyIuIkRlc2NyaWNhbyIsICJ0Yk1vZWRhcyIuIkNvZGlnbyIsICJ0Yk1vZWRhcyIuIkRlc2NyaWNhbyIsICJ0Yk1vZWRhcyIuIlNpbWJvbG8iLCAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiwgInRiU2lzdGVtYU1vZWRhcyIuIkNvZGlnbyI8L1NxbD48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQgTmFtZT0iU3FsRGF0YVNvdXJjZSI+PFZpZXcgTmFtZT0iQ3VzdG9tU3FsUXVlcnkiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETG9qYVNlZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxTZWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkxvY2FsaWRhZGVTZWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYVNlZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGVsZWZvbmVTZWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEVGlwb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRhdGFEb2N1bWVudG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJPYnNlcnZhY29lcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRE1vZWRhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsTG9qYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJMb2NhbGlkYWRlTG9qYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYUxvamEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTklGTG9qYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFMb2phIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2lnbmFjYW9Db21lcmNpYWxMb2phIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxNb2VkYURvY3VtZW50byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhUmVmZXJlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJMb2NhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYUNhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJMb2NhbERlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOb21lRGVzdGluYXRhcmlvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc3RpbmF0YXJpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbERlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2VyaWVEb2NNYW51YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0xpbmhhcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlBvc3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXN0YWRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckVzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhSG9yYUVzdGFkbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkFzc2luYXR1cmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmVyc2FvQ2hhdmVQcml2YWRhIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iTm9tZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvbnRyaWJ1aW50ZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSW1wcmVzc28iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW1wb3N0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQZXJjZW50YWdlbURlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRGVzY29udG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURUYXhhSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUl2YVBvcnRlcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9Qb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ3VzdG9zQWRpY2lvbmFpcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvciIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJJREZvcm1hRXhwZWRpY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvc0RvY3VtZW50b1NlcmllcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0ludGVybm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREVudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvRW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmRpY2FvUGFnYW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDbGllbnRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YVZlbmNpbWVudG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJEYXRhTmFzY2ltZW50byIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IklkYWRlIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iSURFbnRpZGFkZTEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9CZW5lZmljaWFyaW8xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlBhcmVudGVzY28xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERW50aWRhZGUyIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtZXJvQmVuZWZpY2lhcmlvMiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJQYXJlbnRlc2NvMiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTdWJUb3RhbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEZXNjb250b3NMaW5oYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJPdXRyb3NEZXNjb250b3MiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxQb250b3MiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxWYWxlc09mZXJ0YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbEl2YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbEVudGlkYWRlMSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbEVudGlkYWRlMiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNDYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEUGFpc0Rlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTWF0cmljdWxhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkVudGlkYWRlMUF1dG9tYXRpY2EiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IklETG9jYWxPcGVyYWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1lbnNhZ2VtRG9jQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb0VzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTZWd1bmRhVmlhIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTm9tZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVzdGFkb3NfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRXN0YWRvc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUaXBvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRW50aWRhZGVzMV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFbnRpZGFkZXMxX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVudGlkYWRlczJfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRW50aWRhZGVzMl9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX1NpbWJvbG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48VmlldyBOYW1lPSJ0YkRvY3VtZW50b3NWZW5kYXMiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETG9qYVNlZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxTZWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkxvY2FsaWRhZGVTZWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYVNlZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGVsZWZvbmVTZWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEVGlwb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRhdGFEb2N1bWVudG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJPYnNlcnZhY29lcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRE1vZWRhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsTG9qYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJMb2NhbGlkYWRlTG9qYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYUxvamEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTklGTG9qYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFMb2phIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2lnbmFjYW9Db21lcmNpYWxMb2phIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxNb2VkYURvY3VtZW50byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhUmVmZXJlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJMb2NhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYUNhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJMb2NhbERlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOb21lRGVzdGluYXRhcmlvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc3RpbmF0YXJpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbERlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2VyaWVEb2NNYW51YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0xpbmhhcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlBvc3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXN0YWRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckVzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhSG9yYUVzdGFkbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkFzc2luYXR1cmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmVyc2FvQ2hhdmVQcml2YWRhIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iTm9tZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvbnRyaWJ1aW50ZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSW1wcmVzc28iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW1wb3N0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQZXJjZW50YWdlbURlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRGVzY29udG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURUYXhhSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUl2YVBvcnRlcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9Qb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ3VzdG9zQWRpY2lvbmFpcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvciIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJJREZvcm1hRXhwZWRpY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvc0RvY3VtZW50b1NlcmllcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0ludGVybm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREVudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvRW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmRpY2FvUGFnYW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDbGllbnRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YVZlbmNpbWVudG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJEYXRhTmFzY2ltZW50byIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IklkYWRlIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iSURFbnRpZGFkZTEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9CZW5lZmljaWFyaW8xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlBhcmVudGVzY28xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERW50aWRhZGUyIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtZXJvQmVuZWZpY2lhcmlvMiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJQYXJlbnRlc2NvMiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTdWJUb3RhbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEZXNjb250b3NMaW5oYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJPdXRyb3NEZXNjb250b3MiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxQb250b3MiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxWYWxlc09mZXJ0YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbEl2YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbEVudGlkYWRlMSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbEVudGlkYWRlMiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNDYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEUGFpc0Rlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTWF0cmljdWxhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkVudGlkYWRlMUF1dG9tYXRpY2EiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IklETG9jYWxPcGVyYWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1lbnNhZ2VtRG9jQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb0VzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTZWd1bmRhVmlhIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNfSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERvY3VtZW50b1ZlbmRhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDYW1wYW5oYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEVW5pZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bUNhc2FzRGVjVW5pZGFkZSIgVHlwZT0iSW50MTYiIC8+PEZpZWxkIE5hbWU9IlF1YW50aWRhZGUiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvRWZldGl2byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1RvdGFsIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc19PYnNlcnZhY29lcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRExvdGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Mb3RlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0xvdGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUZhYnJpY29Mb3RlIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YVZhbGlkYWRlTG90ZSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvTnVtU2VyaWUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJBcnRpZ29OdW1TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1Mb2NhbGl6YWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJtYXplbURlc3Rpbm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1Mb2NhbGl6YWNhb0Rlc3Rpbm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1MaW5oYXNEaW1lbnNvZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEZXNjb250bzEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRGVzY29udG8yIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEVGF4YUl2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFJdmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zVmVuZGFzTGluaGFzX01vdGl2b0lzZW5jYW9JdmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zVmVuZGFzTGluaGFzX1ZhbG9ySW1wb3N0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJREVzcGFjb0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkVzcGFjb0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFJlZ2ltZUl2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlJlZ2ltZUl2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iT3JkZW0iIFR5cGU9IkludDMyIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNfU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zVmVuZGFzTGluaGFzX0F0aXZvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNfRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNfVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zVmVuZGFzTGluaGFzX0RhdGFBbHRlcmFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNfVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNfRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iRGlhbWV0cm8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmFsb3JEZXNjb250b0xpbmhhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsQ29tRGVzY29udG9MaW5oYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckRlc2NvbnRvQ2FiZWNhbGhvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsQ29tRGVzY29udG9DYWJlY2FsaG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JVbml0YXJpb0VudGlkYWRlMSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvclVuaXRhcmlvRW50aWRhZGUyIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRW50aWRhZGUxIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRW50aWRhZGUyIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsRmluYWwiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURTZXJ2aWNvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvU2VydmljbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb09saG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUaXBvRGlzdGFuY2lhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG9PbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEVGlwb0dyYWR1YWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW5jaWRlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvcklWQSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEb2N1bWVudG9PcmlnZW0iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik5vbWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFc3RhZG9zX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVzdGFkb3NfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFydGlnb3NfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0FicmV2aWFkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFydGlnb3NfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUaXBvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRW50aWRhZGVzMV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFbnRpZGFkZXMxX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVudGlkYWRlczJfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRW50aWRhZGVzMl9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX1NpbWJvbG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iQ29kaWdvTW90aXZvSXNlbmNhb0l2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFNb2VkYXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PC9WaWV3PjxWaWV3IE5hbWU9InRiUGFyYW1ldHJvc0xvamFzIj48RmllbGQgTmFtZT0iQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxobyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUZWxlZm9uZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGYXgiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iV2ViU2l0ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOSUYiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXBpdGFsU29jaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURJZGlvbWFCYXNlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iSURfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFfMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNpZ25hY2FvQ29tZXJjaWFsXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZV8xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRmF4XzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWxfMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJXZWJTaXRlXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTklGXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWxfMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ2FwaXRhbFNvY2lhbF8xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbV8xIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJJRExvamFfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklESWRpb21hQmFzZV8xIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYV8xIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2b18xIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ3JpYWNhb18xIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvXzEiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3JfMSIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJTaW1ib2xvIiBUeXBlPSJTdHJpbmciIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''

Set @ptrvalP.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item8/Controls/Item1/@ReportSourceUrl)[.=10000][1] with sql:variable("@IDSubObservacoes")'')
Set @ptrvalP.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item3/Controls/Item2/@ReportSourceUrl)[.=20000][1] with sql:variable("@IDSubCabecalho")'')
Set @ptrvalP.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item6/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=30000][1] with sql:variable("@IDSubMotivosIsencao")'')
Set @ptrvalP.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item6/SubBands/Item1/Controls/Item2/@ReportSourceUrl)[.=40000][1] with sql:variable("@IDSubFormasPagamento")'')

update tbMapasVistas set MapaXML = @ptrvalP, Caminho='''', NomeMapa = ''DocumentosVendasA5H'', SubReport=0, Entidade = ''DocumentosVendas'' where NomeMapa = ''rptDocumentosVendasA5H''
')
