/* ACT BD EMPRESA VERSAO 67*/
--aviso de versão 1.30
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.30.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.30.0'', ''A'', ''2021-02-04 00:00'', ''2021-02-04 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.30.0'', ''V'', ''2021-02-04 08:00'', ''2021-02-04 08:00'', ''Funcionalidades da versão'', ''
<li>Documentos de Compra</li>
&emsp;- Acerto de IVA e Total<br>
&emsp;- Duplicação de documento<br>
&emsp;- Séries de documentos Manuais e de Reposição<br>
&emsp;- Atribuição de Descontos de Linha do Fornecedor<br>
&emsp;- Alteração de Total de linha com cálculo de desconto<br>
&emsp;- Atribuição de P.Custo do Catálogo de Lentes Oftálmicas/Contacto
<li>Catálogo de Lentes</li>
&emsp;- Filtro por Índice e Fotocromático<br>
&emsp;- Definição de Preço de Custo na Matriz<br>
&emsp;- Definição de Preços de Custo em Suplementos e Cores
<li>Ficha de Cliente</li>
&emsp;- Histórico de Consultas e detalhe<br>
&emsp;- Novo campo - Permite Comunicações<br>
&emsp;- Sugestão de Local de Operação definido na Loja
<li>SERVIÇOS</li>
&emsp;- Alteração ao layout da janela - SubServiços e Totais<br>
&emsp;- Importação de Consultas - Impressão de Receita ou Relatório
<li>Tabelas</li>
&emsp;- Segmentos - para classificação de Marcas<br>
&emsp;- Tipos de Tratamento - para classificação de tratamentos
<li>Ficha de Fornecedor</li>
&emsp;- Novo campo - Código de Cliente      
<li>Edição de Vistas de Impressão</li>
&emsp;- Liquidações Fornecedor<br>
&emsp;- Contagens de Stock
'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')

--novo campo de clientes
EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbClientes'' AND COLUMN_NAME = ''PermiteComunicacoes'')
BEGIN
ALTER TABLE tbClientes ADD PermiteComunicacoes bit NULL;
END')

--atualizar campo PermiteComunicacoes
EXEC('UPDATE tbClientes SET PermiteComunicacoes=0')

--novo campo de parametrosloja
EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbParametrosLoja'' AND COLUMN_NAME = ''IDLocalOperacao'')
BEGIN
ALTER TABLE tbParametrosLoja ADD [IDLocalOperacao] [bigint] NULL DEFAULT ((1));

ALTER TABLE [dbo].[tbParametrosLoja]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosLoja_tbSistemaRegioesIVA] FOREIGN KEY([IDLocalOperacao])
REFERENCES [dbo].[tbSistemaRegioesIVA] ([ID])
ALTER TABLE [dbo].[tbParametrosLoja] CHECK CONSTRAINT [FK_tbParametrosLoja_tbSistemaRegioesIVA]
END')

--atualizar campo IDLocalOperacao
EXEC('UPDATE tbParametrosLoja SET IDLocalOperacao=1')

--novo campo de fornecedores
EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbfornecedores'' AND COLUMN_NAME = ''CodigoCliente'')
BEGIN
ALTER TABLE tbfornecedores ADD CodigoCliente nvarchar(50) NULL;
END')

--alterar coluna tbComunicacaoSmsTemplates
EXEC('ALTER TABLE [dbo].[tbComunicacaoSmsTemplates] alter column [IDParametrizacaoConsentimentosPerguntas] bigint NULL')

--novo menu tipos tratamentos lentes
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral]..tbMenus WHERE Descricao = ''TiposTratamentosLentes'')
BEGIN
	DECLARE @IDMenuArtigos as bigint
	DECLARE @IDModulo as bigint

	SELECT @IDMenuArtigos = ID FROM [F3MOGeral]..tbMenus WHERE Descricao = ''Artigos'' AND DescricaoAbreviada = N''014.004''
	SELECT @IDModulo = ID FROM [F3MOGeral]..tbModulos WHERE Descricao = N''Tabelas''

	INSERT INTO [F3MOGeral]..tbMenus ([IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar], [OpenType])
	VALUES (@IDMenuArtigos, N''TiposTratamentosLentes'', N''014.004.016'', N''TiposTratamentosLentes'', 2150, N''f3icon-glasses-set'', N''/TabelasAuxiliares/TiposTratamentosLentes'', 1, @IDModulo, 1, 1, 1, 1, 1, 0, NULL, 1, 0, getdate(), N''F3M'', NULL, NULL, NULL, NULL, NULL)

	DECLARE @IDMenuTiposTratamentos as bigint
	SELECT @IDMenuTiposTratamentos = ID FROM [F3MOGeral]..tbMenus WHERE Descricao = ''TiposTratamentosLentes''
	
	INSERT [F3MOGeral]..tbPerfisAcessos ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar])
	VALUES (1, @IDMenuTiposTratamentos, 1, 1, 1, 1, 0, 1, 1, 1, 0, getdate(), N''F3M'', getdate(), N''F3M'', NULL, NULL)
END')

--nova coluna nas listas personalizadas
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Tratamentos de Lentes''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista  and colunavista=''IDTipo''
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDTipo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbTratamentosLentes'', 1, 1, 150)
END')

-- tbTiposTratamentosLentes
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbTiposTratamentosLentes]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbTiposTratamentosLentes](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [Codigo] [nvarchar] (10) NOT NULL,
    [Descricao] [nvarchar] (50) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbTiposTratamentosLentes_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbTiposTratamentosLentes_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbTiposTratamentosLentes_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbTiposTratamentosLentes_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbTiposTratamentosLentes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbTiposTratamentosLentes_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbTiposTratamentosLentes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END')

--novo campo de tratamentolentes
EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbTratamentosLentes'' AND COLUMN_NAME = ''IDTipo'')
BEGIN
ALTER TABLE tbTratamentosLentes ADD IDTipo bigint NULL;
ALTER TABLE [dbo].[tbTratamentosLentes]  WITH CHECK ADD  CONSTRAINT [FK_tbTratamentosLentes_tbTiposTratamentosLentes] FOREIGN KEY([IDTipo])
REFERENCES [dbo].[tbTiposTratamentosLentes] ([ID])
ALTER TABLE [dbo].[tbTratamentosLentes] CHECK CONSTRAINT [FK_tbTratamentosLentes_tbTiposTratamentosLentes]
END')

--novo menu tipos segmentos de marcas
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral]..tbMenus WHERE Descricao = ''SegmentosMarcas'')
BEGIN
	DECLARE @IDMenuArtigos as bigint
	DECLARE @IDModulo as bigint

	SELECT @IDMenuArtigos = ID FROM [F3MOGeral]..tbMenus WHERE Descricao = ''Artigos'' AND DescricaoAbreviada = N''014.004''
	SELECT @IDModulo = ID FROM [F3MOGeral]..tbModulos WHERE Descricao = N''Tabelas''

	INSERT INTO [F3MOGeral]..tbMenus ([IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar], [OpenType])
	VALUES (@IDMenuArtigos, N''SegmentosMarcas'', N''014.004.017'', N''SegmentosMarcas'', 2175, N''f3icon-glasses-set'', N''/TabelasAuxiliares/SegmentosMarcas'', 1, @IDModulo, 1, 1, 1, 1, 1, 0, NULL, 1, 0, getdate(), N''F3M'', NULL, NULL, NULL, NULL, NULL)

	DECLARE @IDMenuSegmentosMarcas as bigint
	SELECT @IDMenuSegmentosMarcas = ID FROM [F3MOGeral]..tbMenus WHERE Descricao = ''SegmentosMarcas''
	
	INSERT [F3MOGeral]..tbPerfisAcessos ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar])
	VALUES (1, @IDMenuSegmentosMarcas, 1, 1, 1, 1, 0, 1, 1, 1, 0, getdate(), N''F3M'', getdate(), N''F3M'', NULL, NULL)
END')

--nova coluna nas listas personalizadas
EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Marcas''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista  and colunavista=''IDSegmentoMarca''
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDSegmentoMarca'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbMarcas'', 1, 1, 150)
END')

-- tbSegmentosMarcas
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbSegmentosMarcas]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbSegmentosMarcas](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [Codigo] [nvarchar] (10) NOT NULL,
    [Descricao] [nvarchar] (50) NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSegmentosMarcas_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSegmentosMarcas_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbSegmentosMarcas_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbSegmentosMarcas_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSegmentosMarcas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbSegmentosMarcas_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSegmentosMarcas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END')

--novo campo de marcas
EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbMarcas'' AND COLUMN_NAME = ''IDSegmentoMarca'')
BEGIN
ALTER TABLE tbMarcas ADD IDSegmentoMarca bigint NULL;
ALTER TABLE [dbo].[tbMarcas]  WITH CHECK ADD  CONSTRAINT [FK_tbMarcas_tbSegmentosMarcas] FOREIGN KEY([IDSegmentoMarca])
REFERENCES [dbo].[tbSegmentosMarcas] ([ID])
ALTER TABLE [dbo].[tbMarcas] CHECK CONSTRAINT [FK_tbMarcas_tbSegmentosMarcas]
END')

--atualizar vista de doc. stock cabeçalho
EXEC('
DECLARE @ptrvalP xml;
SET @ptrvalP = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="CabecalhoStocks369" SnapGridSize="0.1" Margins="3, 65, 3, 4" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="19.1" FilterString="[IDLoja] = ?IDLoja" DataMember="tbParametrosLoja" DataSource="#Ref-0">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item2 Ref="6" Visible="false" Description="Culture" Name="Culture" />
    <Item3 Ref="7" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item4 Ref="8" Visible="false" Description="DesignacaoComercial" Name="DesignacaoComercial" />
    <Item5 Ref="9" Visible="false" Description="Morada" Name="Morada" />
    <Item6 Ref="10" Visible="false" Description="Localidade" Name="Localidade" />
    <Item7 Ref="11" Visible="false" Description="CodigoPostal" Name="CodigoPostal" />
    <Item8 Ref="12" Visible="false" Description="Sigla" Name="Sigla" />
    <Item9 Ref="13" Visible="false" Description="NIF" Name="NIF" />
    <Item10 Ref="14" Visible="false" Description="MoradaSede" Name="MoradaSede" />
    <Item11 Ref="15" Visible="false" Description="CodigoPostalSede" Name="CodigoPostalSede" />
    <Item12 Ref="16" Visible="false" Description="LocalidadeSede" Name="LocalidadeSede" />
    <Item13 Ref="17" Visible="false" Description="TelefoneSede" Name="TelefoneSede" />
    <Item14 Ref="18" Visible="false" Description="IDLojaSede" ValueInfo="0" Name="IDLojaSede" Type="#Ref-3" />
  </Parameters>
  <Bands>
    <Item1 Ref="19" ControlType="TopMarginBand" Name="TopMargin" HeightF="3" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="20" ControlType="ReportHeaderBand" Name="ReportHeaderBand1" HeightF="108.1251">
      <Controls>
        <Item1 Ref="21" ControlType="XRLabel" Name="fldMoradaSede" TextAlignment="TopLeft" SizeF="187.26,15.00001" LocationFloat="363.86, 62.00003" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="22" Expression="[MoradaSede]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="23" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="24" ControlType="XRLabel" Name="fldCodigoPostalSede" SizeF="187.28,13.99997" LocationFloat="363.86, 77.00005" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="25" Expression="[CodigoPostalSede] + '''' '''' + [LocalidadeSede]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="26" UseFont="false" UseBorderWidth="false" />
        </Item2>
        <Item3 Ref="27" ControlType="XRLabel" Name="fldTelefoneSede" SizeF="165.19,13.99999" LocationFloat="385.96, 91.00001" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="28" Expression="[TelefoneSede]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="29" UseFont="false" />
        </Item3>
        <Item4 Ref="30" ControlType="XRLabel" Name="lblTelefoneSede" Text="Tel." TextAlignment="TopLeft" SizeF="22.10526,13.99995" LocationFloat="363.85, 91.00008" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
          <StylePriority Ref="31" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="32" ControlType="XRLabel" Name="LabelSede" Text="Sede" SizeF="187.28,14" LocationFloat="363.86, 48.00003" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="33" UseFont="false" />
        </Item5>
        <Item6 Ref="34" ControlType="XRLabel" Name="lblEmail" Text="Email:" TextAlignment="TopLeft" SizeF="27.20552,13.99998" LocationFloat="130.62, 91.00002" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
          <StylePriority Ref="35" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="36" ControlType="XRLabel" Name="fldConservatoria" Text="Cap.Soc." TextAlignment="TopLeft" SizeF="227.59,13.99998" LocationFloat="130.52, 77.00005" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
          <ExpressionBindings>
            <Item1 Ref="37" Expression="''''Cap. Soc. '''' + [CapitalSocial] + '''' Matric. '''' + [ConservatoriaRegistoComercial] + '''' Nr. '''' + [NumeroRegistoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="38" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="39" ControlType="XRLabel" Name="lblTelefone" Text="Tel." TextAlignment="TopLeft" SizeF="22.10529,14" LocationFloat="130.62, 48.00003" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
          <StylePriority Ref="40" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="41" ControlType="XRLabel" Name="fldTelefone" Text="fldTelefone" SizeF="205.38,14.00001" LocationFloat="152.72, 48.00003" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="42" Expression="[Telefone]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="43" UseFont="false" />
        </Item9>
        <Item10 Ref="44" ControlType="XRLabel" Name="fldEmail" Text="fldEmail" TextAlignment="TopLeft" SizeF="200.28,13.99998" LocationFloat="157.83, 91.00005" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="45" Expression="[Email]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="46" UseFont="false" UseTextAlignment="false" />
        </Item10>
        <Item11 Ref="47" ControlType="XRLabel" Name="fldCodigoPostal" Text="fldCodigoPostal" SizeF="227.48,14" LocationFloat="130.62, 34" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="48" Expression="[CodigoPostal] + '''' '''' + [Localidade] " PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="49" UseFont="false" UseBorderWidth="false" />
        </Item11>
        <Item12 Ref="50" ControlType="XRLabel" Name="lblNIF" Text="Contribuinte nº" TextAlignment="TopLeft" SizeF="74.39218,15" LocationFloat="130.62, 62.00005" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
          <StylePriority Ref="51" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="52" ControlType="XRLabel" Name="fldNIF" Text="fldNIF" TextAlignment="TopLeft" SizeF="153.09,15" LocationFloat="205.02, 62.00005" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="53" Expression=" [Sigla] + '''' '''' + [NIF]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="54" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item13>
        <Item14 Ref="55" ControlType="XRLabel" Name="fldMorada" Text="fldMorada" TextAlignment="TopLeft" SizeF="227.59,14" LocationFloat="130.52, 20" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="56" Expression="[Morada]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="57" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item14>
        <Item15 Ref="58" ControlType="XRLabel" Name="fldDesignacaoComercial" Text="fldDesignacaoComercial" TextAlignment="TopLeft" SizeF="480.1089,20" LocationFloat="130.62, 0" Font="Arial, 9pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="59" Expression="[DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="60" UseFont="false" UseTextAlignment="false" />
        </Item15>
        <Item16 Ref="61" ControlType="XRPictureBox" Name="picLogotipo" Sizing="ZoomImage" ImageAlignment="TopLeft" SizeF="121.4168,94.46" LocationFloat="0, 0" />
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
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9UFJJU01BLUxBQi1WTVxDNDtVc2VyIElEPUYzTU87UGFzc3dvcmQ9O0luaXRpYWwgQ2F0YWxvZyA9MjgxNEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJQYXJhbWV0cm9zTG9qYSI+PFBhcmFtZXRlciBOYW1lPSJJRExvamEiIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKFtQYXJhbWV0ZXJzLklETG9qYV0pPC9QYXJhbWV0ZXI+PFNxbD5zZWxlY3QgInRiUGFyYW1ldHJvc0xvamFTZWRlIi4iSUQiICJJRExvamFTZWRlIiwNCgkgICAidGJQYXJhbWV0cm9zTG9qYVNlZGUiLiJNb3JhZGEiICJNb3JhZGFTZWRlIiwNCgkgICAidGJQYXJhbWV0cm9zTG9qYVNlZGUiLiJDb2RpZ29Qb3N0YWwiICJDb2RpZ29Qb3N0YWxTZWRlIiwNCgkgICAidGJQYXJhbWV0cm9zTG9qYVNlZGUiLiJMb2NhbGlkYWRlIiAiTG9jYWxpZGFkZVNlZGUiLA0KCSAgICJ0YlBhcmFtZXRyb3NMb2phU2VkZSIuVGVsZWZvbmUgIlRlbGVmb25lU2VkZSIsDQoJICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRE1vZWRhRGVmZWl0byIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJNb3JhZGEiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRm90byIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJGb3RvQ2FtaW5obyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJEZXNpZ25hY2FvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNvZGlnb1Bvc3RhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJMb2NhbGlkYWRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNvbmNlbGhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkRpc3RyaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklEUGFpcyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJUZWxlZm9uZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJGYXgiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRW1haWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iV2ViU2l0ZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJOSUYiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJDYXBpdGFsU29jaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRExvamEiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iSURJZGlvbWFCYXNlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIlNpc3RlbWEiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQXRpdm8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRGF0YUNyaWFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iVXRpbGl6YWRvckNyaWFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRGF0YUFsdGVyYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJVdGlsaXphZG9yQWx0ZXJhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkYzTU1hcmNhZG9yIiwNCiAgICAgICAidGJNb2VkYXMiLiJTaW1ib2xvIiwNCiAgICAgICAidGJNb2VkYXMiLiJUYXhhQ29udmVyc2FvIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW9EZWNpbWFsIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW9JbnRlaXJhIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzSXZhIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiwNCiAgICAgICAidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIi5TaWdsYQ0KZnJvbSAiZGJvIi4idGJMb2phcyIgInRiTG9qYXMiDQppbm5lciBqb2luICJkYm8iLiJ0YkxvamFzIiAidGJMb2phc1NlZGUiIG9uICJ0YkxvamFzIi5pZGxvamFzZWRlPSJ0YkxvamFzU2VkZSIuaWQNCmxlZnQgam9pbiAiZGJvIi4idGJwYXJhbWV0cm9zbG9qYSIgInRicGFyYW1ldHJvc2xvamEiIG9uICJ0YkxvamFzIi5pZD0idGJwYXJhbWV0cm9zbG9qYSIuaWRsb2phDQpsZWZ0IGpvaW4gImRibyIuInRicGFyYW1ldHJvc2xvamEiICJ0YnBhcmFtZXRyb3Nsb2phc2VkZSIgb24gInRiTG9qYXNTZWRlIi5pZD0idGJwYXJhbWV0cm9zbG9qYXNlZGUiLmlkbG9qYQ0KbGVmdCBqb2luICJkYm8iLiJ0Yk1vZWRhcyIgInRiTW9lZGFzIiBvbiAidGJNb2VkYXMiLiJJRCIgPSAidGJQYXJhbWV0cm9zTG9qYSIuIklETW9lZGFEZWZlaXRvIg0KbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiIG9uICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiLiJJRCIgPSAidGJQYXJhbWV0cm9zTG9qYSIuIklEUGFpcyINCndoZXJlICJ0YkxvamFzIi5JRCA9IEBJRExvamE8L1NxbD48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQ+PFZpZXcgTmFtZT0idGJQYXJhbWV0cm9zTG9qYSI+PEZpZWxkIE5hbWU9IklETG9qYVNlZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFTZWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbFNlZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZVNlZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGVsZWZvbmVTZWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURNb2VkYURlZmVpdG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvQ2FtaW5obyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNpZ25hY2FvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJMb2NhbGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZheCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJXZWJTaXRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik5JRiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhcGl0YWxTb2NpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJJRExvamEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRElkaW9tYUJhc2UiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvciIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJTaW1ib2xvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvRGVjaW1hbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9JbnRlaXJhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNUb3RhaXMiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNJdmEiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IlNpZ2xhIiBUeXBlPSJTdHJpbmciIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiBEYkNvbW1hbmRUaW1lb3V0PSIxODAwIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
UPDATE tbMapasVistas SET MapaXML = @ptrvalP where NomeMapa = ''Cabecalho Empresa Stocks'' and sistema=1 and subreport = 1
')

--vistas observacoes pagamentos compras
EXEC('
DECLARE @intOrdem as int;
DECLARE @ptrval xml;  
DECLARE @intModulo as bigint;
DECLARE @intSistemaTipoDoc as bigint;
DECLARE @intSistemaTipoDocFiscal as bigint;
SELECT @intOrdem = Max(isnull(Ordem,0)) + 1 FROM tbMapasVistas
SELECT @intModulo = IDModulo, @intSistemaTipoDoc = IDSistemaTipoDoc, @intSistemaTipoDocFiscal = IDSistemaTipoDocFiscal  FROM tbMapasVistas WHERE Entidade = ''DocumentosPagamentosCompras'' and NomeMapa=''rptPagamentosCompras''
SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="19.1.3.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v19.1, Version=19.1.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="PagamentosComprasObservacoes" SnapGridSize="0.1" Margins="0, 97, 0, 0" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="19.1" DataMember="tbDocumentos" DataSource="#Ref-0">
  <Parameters>
    <Item1 Ref="3" Visible="false" Description="Culture" Name="Culture" />
    <Item2 Ref="4" Visible="false" Description="Observacoes" ValueInfo="select ID, Observacoes from tbDocumentosVendas where ID=" Name="Observacoes" />
    <Item3 Ref="6" Visible="false" Description="IDDocumento" ValueInfo="0" Name="IDDocumento" Type="#Ref-5" />
    <Item4 Ref="7" Visible="false" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-5" />
    <Item5 Ref="8" Visible="false" Description="FraseFiscal" Name="FraseFiscal" />
    <Item6 Ref="9" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item7 Ref="11" Visible="false" Description="AcompanhaBens" ValueInfo="True" Name="AcompanhaBens" Type="#Ref-10" />
    <Item8 Ref="12" Visible="false" Description="Parameter1" Name="TipoFiscal" />
  </Parameters>
  <Bands>
    <Item1 Ref="13" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="14" ControlType="TopMarginBand" Name="TopMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item3 Ref="15" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item4 Ref="16" ControlType="ReportHeaderBand" Name="ReportHeaderBand1" HeightF="34.05968">
      <Controls>
        <Item1 Ref="17" ControlType="XRLabel" Name="fldFraseFiscal" TextAlignment="TopLeft" SizeF="551.4506,9.132431" LocationFloat="0, 14" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String" Tag="Observacoes">
          <StylePriority Ref="18" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="19" ControlType="XRLabel" Name="lblObservacoes" Text="Observações" TextAlignment="MiddleLeft" SizeF="90.12,12" LocationFloat="0, 2" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String" Tag="Observacoes">
          <StylePriority Ref="20" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="21" ControlType="XRLabel" Name="fldObservacoes" Multiline="true" TextAlignment="TopLeft" SizeF="742.9999,9.132427" LocationFloat="0, 23.13243" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String" Tag="Observacoes">
          <StylePriority Ref="22" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
      </Controls>
    </Item4>
  </Bands>
  <StyleSheet>
    <Item1 Ref="23" Name="Title" BorderStyle="Inset" Font="Times New Roman, 20pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item2 Ref="24" Name="FieldCaption" BorderStyle="Inset" Font="Arial, 10pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item3 Ref="25" Name="PageInfo" BorderStyle="Inset" Font="Times New Roman, 10pt, style=Bold" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item4 Ref="26" Name="DataField" BorderStyle="Inset" Padding="2,2,0,0,100" Font="Times New Roman, 10pt" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
  </StyleSheet>
  <ComponentStorage>
    <Item1 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v19.1" Name="SqlDataSource1" Base64="PFNxbERhdGFTb3VyY2UgTmFtZT0iU3FsRGF0YVNvdXJjZTEiPjxDb25uZWN0aW9uIE5hbWU9IkRlZmF1bHRDb25uRXNwUHJpc21hIiBGcm9tQXBwQ29uZmlnPSJ0cnVlIiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJEb2N1bWVudG9zIj48U3FsPnNlbGVjdCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklEIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklETW9lZGFEZWZlaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIk1vcmFkYSIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGb3RvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZvdG9DYW1pbmhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRlc2lnbmFjYW9Db21lcmNpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ29kaWdvUG9zdGFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkxvY2FsaWRhZGUiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ29uY2VsaG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRGlzdHJpdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURQYWlzIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIlRlbGVmb25lIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZheCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJFbWFpbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJXZWJTaXRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIk5JRiIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNhcGl0YWxTb2NpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklESWRpb21hQmFzZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJTaXN0ZW1hIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkF0aXZvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRhdGFDcmlhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIlV0aWxpemFkb3JDcmlhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkRhdGFBbHRlcmFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGM01NYXJjYWRvciIsDQogICAgICAgInRiTW9lZGFzIi4iU2ltYm9sbyIsDQogICAgICAgInRiTW9lZGFzIi4iVGF4YUNvbnZlcnNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iRGVzY3JpY2FvRGVjaW1hbCIsDQogICAgICAgInRiTW9lZGFzIi4iRGVzY3JpY2FvSW50ZWlyYSIsDQogICAgICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1RvdGFpcyIsDQogICAgICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc0l2YSIsDQogICAgICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyINCiAgZnJvbSAoImRibyIuInRiUGFyYW1ldHJvc0VtcHJlc2EiDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiDQogIGxlZnQgam9pbiAiZGJvIi4idGJNb2VkYXMiICJ0Yk1vZWRhcyINCiAgICAgICBvbiAoInRiTW9lZGFzIi4iSUQiID0gInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIpKTwvU3FsPjwvUXVlcnk+PFJlc3VsdFNjaGVtYT48RGF0YVNldCBOYW1lPSJTcWxEYXRhU291cmNlMSI+PFZpZXcgTmFtZT0idGJEb2N1bWVudG9zIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRE1vZWRhRGVmZWl0byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG9DYW1pbmhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2lnbmFjYW9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkxvY2FsaWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGVsZWZvbmUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRmF4IiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkVtYWlsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IldlYlNpdGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTklGIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbnNlcnZhdG9yaWFSZWdpc3RvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb1JlZ2lzdG9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ2FwaXRhbFNvY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IklESWRpb21hQmFzZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlNpc3RlbWEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkF0aXZvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ3JpYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JDcmlhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFBbHRlcmFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkYzTU1hcmNhZG9yIiBUeXBlPSJCeXRlQXJyYXkiIC8+PEZpZWxkIE5hbWU9IlNpbWJvbG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGF4YUNvbnZlcnNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9EZWNpbWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0ludGVpcmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ2FzYXNEZWNpbWFpc1RvdGFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iQ2FzYXNEZWNpbWFpc0l2YSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgVHlwZT0iQnl0ZSIgLz48L1ZpZXc+PC9EYXRhU2V0PjwvUmVzdWx0U2NoZW1hPjxDb25uZWN0aW9uT3B0aW9ucyBDbG9zZUNvbm5lY3Rpb249InRydWUiIC8+PC9TcWxEYXRhU291cmNlPg==" />
  </ComponentStorage>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v19.1" Ref="5" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v19.1" Ref="10" Content="System.Boolean" Type="System.Type" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
--observacoes pagamentos compras
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito],[SubReport]) VALUES (@intOrdem, N''DocumentosPagamentosCompras'', N''PagamentosComprasObservacoes'', N''PagamentosComprasObservacoes'', N'''', 1, @ptrval, NULL, N'''', 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''', @intModulo, @intSistemaTipoDoc, @intSistemaTipoDocFiscal, 0,1)
')

--vistas cabecalho pagamentos compras
EXEC('
DECLARE @intOrdem as int;
DECLARE @ptrval xml;  
DECLARE @intModulo as bigint;
DECLARE @intSistemaTipoDoc as bigint;
DECLARE @intSistemaTipoDocFiscal as bigint;
SELECT @intOrdem = Max(isnull(Ordem,0)) + 1 FROM tbMapasVistas
SELECT @intModulo = IDModulo, @intSistemaTipoDoc = IDSistemaTipoDoc, @intSistemaTipoDocFiscal = IDSistemaTipoDocFiscal  FROM tbMapasVistas WHERE Entidade = ''DocumentosPagamentosCompras'' and NomeMapa=''rptPagamentosCompras''
SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="PagamentosComprasCabecalho" ScriptsSource="Imports Reporting&#xD;&#xA;&#xD;&#xA;Private Sub picLogotipo_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    fldDesignacaoComercial.Text = GetParameterValue(&quot;DesignacaoComercial&quot;)&#xD;&#xA;    fldMorada.Text = GetParameterValue(&quot;Morada&quot;)&#xD;&#xA;    fldCodigoPostal.Text = GetParameterValue(&quot;CodigoPostal&quot;) &amp; &quot; &quot; &amp; GetParameterValue(&quot;Localidade&quot;)&#xD;&#xA;    fldNIF.Text = GetParameterValue(&quot;Sigla&quot;) &amp; &quot; &quot; &amp; GetParameterValue(&quot;NIF&quot;)&#xD;&#xA;    fldConservatoria.Text = &quot;Cap. Soc. &quot; &amp; GetParameterValue(&quot;CapitalSocial&quot;) &amp; &quot; &quot; &amp; &quot; Matric. &quot; &amp; GetParameterValue(&quot;ConservatoriaRegistoComercial&quot;) &amp; &quot; &quot; &amp; &quot; Nr. &quot; &amp; GetParameterValue(&quot;NumeroRegistoComercial&quot;)&#xD;&#xA;&#xD;&#xA;    If Not String.IsNullOrEmpty(Parameters(&quot;IDLojaSede&quot;).Value.ToString) AndAlso GetParameterValue(&quot;IDLoja&quot;) &lt;&gt; GetParameterValue(&quot;IDLojaSede&quot;) Then&#xD;&#xA;        LabelSede.Visible = True&#xD;&#xA;        fldMoradaSede.Visible = True&#xD;&#xA;        fldCodigoPostalSede.Visible = True&#xD;&#xA;        lblTelefoneSede.Visible = True&#xD;&#xA;        fldTelefoneSede.Visible = True&#xD;&#xA;        fldMoradaSede.Text = GetParameterValue(&quot;MoradaSede&quot;)&#xD;&#xA;        fldCodigoPostalSede.Text = GetParameterValue(&quot;CodigoPostalSede&quot;) &amp; &quot; &quot; &amp; GetParameterValue(&quot;LocalidadeSede&quot;)&#xD;&#xA;        fldTelefoneSede.Text = GetParameterValue(&quot;TelefoneSede&quot;)&#xD;&#xA;    Else&#xD;&#xA;        LabelSede.Visible = False&#xD;&#xA;        fldMoradaSede.Visible = False&#xD;&#xA;        fldCodigoPostalSede.Visible = False&#xD;&#xA;        lblTelefoneSede.Visible = False&#xD;&#xA;        fldTelefoneSede.Visible = False&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Function GetParameterValue(inParameter As String) As String&#xD;&#xA;    Dim strResult = String.Empty&#xD;&#xA;&#xD;&#xA;    If Parameters(inParameter) IsNot Nothing AndAlso Parameters(inParameter).Value.ToString &lt;&gt; &quot;&quot; Then&#xD;&#xA;        strResult = Me.Parameters(inParameter).Value.ToString&#xD;&#xA;    Else&#xD;&#xA;        strResult = Convert.ToString(GetCurrentColumnValue(inParameter))&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    Return strResult&#xD;&#xA;End Function" SnapGridSize="0.1" Margins="3, 65, 3, 4" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="19.1" FilterString="[IDLoja] = ?IDLoja" DataMember="tbParametrosLoja" DataSource="#Ref-0">
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
          <ExpressionBindings>
            <Item1 Ref="47" Expression="[CodigoPostal] + '''' ''''  + [Localidade] " PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="48" UseFont="false" UseBorderWidth="false" />
        </Item11>
        <Item12 Ref="49" ControlType="XRLabel" Name="lblNIF" Text="Contribuinte nº" TextAlignment="TopLeft" SizeF="74.39218,15" LocationFloat="137.3999, 62.00005" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
          <StylePriority Ref="50" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="51" ControlType="XRLabel" Name="fldNIF" Text="fldNIF" TextAlignment="TopLeft" SizeF="167.1673,15" LocationFloat="211.7921, 62.00005" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="52" Expression="[NIF]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="53" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item13>
        <Item14 Ref="54" ControlType="XRLabel" Name="fldMorada" Text="fldMorada" TextAlignment="TopLeft" SizeF="241.6594,14" LocationFloat="137.3, 20" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="55" Expression="[Morada]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="56" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item14>
        <Item15 Ref="57" ControlType="XRLabel" Name="fldDesignacaoComercial" Text="fldDesignacaoComercial" TextAlignment="TopLeft" SizeF="480.1089,20" LocationFloat="137.3999, 0" Font="Arial, 9pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="58" Expression="[DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="59" UseFont="false" UseTextAlignment="false" />
        </Item15>
        <Item16 Ref="60" ControlType="XRPictureBox" Name="picLogotipo" Sizing="Squeeze" ImageAlignment="TopLeft" SizeF="121.4168,94.46" LocationFloat="0, 0">
          <ExpressionBindings>
            <Item1 Ref="61" Expression="?UrlServerPath  + [FotoCaminho] + [Foto]" PropertyName="ImageUrl" EventName="BeforePrint" />
          </ExpressionBindings>
          <Scripts Ref="62" OnBeforePrint="picLogotipo_BeforePrint" />
        </Item16>
      </Controls>
    </Item2>
    <Item3 Ref="63" ControlType="DetailBand" Name="Detail" Expanded="false" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item4 Ref="64" ControlType="PageFooterBand" Name="PageFooterBand1" HeightF="0.8749962" />
    <Item5 Ref="65" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="4" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="66" OnBeforePrint="PagamentosComprasCabecalho_BeforePrint" />
  <StyleSheet>
    <Item1 Ref="67" Name="Title" BorderStyle="Inset" Font="Times New Roman, 20pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item2 Ref="68" Name="FieldCaption" BorderStyle="Inset" Font="Arial, 10pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item3 Ref="69" Name="PageInfo" BorderStyle="Inset" Font="Times New Roman, 10pt, style=Bold" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item4 Ref="70" Name="DataField" BorderStyle="Inset" Padding="2,2,0,0,100" Font="Times New Roman, 10pt" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
  </StyleSheet>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="2" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMTQzXGYzbTIwMTc7VXNlciBJRD1GM01PO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTI1MDVGM01POyIgLz48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiUGFyYW1ldHJvc0xvamEiPjxQYXJhbWV0ZXIgTmFtZT0iSURMb2phIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5JbnQ2NCwgbXNjb3JsaWIsIFZlcnNpb249NC4wLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5KShbUGFyYW1ldGVycy5JRExvamFdKTwvUGFyYW1ldGVyPjxTcWw+c2VsZWN0ICJ0YlBhcmFtZXRyb3NMb2phU2VkZSIuIklEIiAiSURMb2phU2VkZSIsDQoJICAgInRiUGFyYW1ldHJvc0xvamFTZWRlIi4iTW9yYWRhIiAiTW9yYWRhU2VkZSIsDQoJICAgInRiUGFyYW1ldHJvc0xvamFTZWRlIi4iQ29kaWdvUG9zdGFsIiAiQ29kaWdvUG9zdGFsU2VkZSIsDQoJICAgInRiUGFyYW1ldHJvc0xvamFTZWRlIi4iTG9jYWxpZGFkZSIgIkxvY2FsaWRhZGVTZWRlIiwNCgkgICAidGJQYXJhbWV0cm9zTG9qYVNlZGUiLlRlbGVmb25lICJUZWxlZm9uZVNlZGUiLA0KCSAgICJ0YlBhcmFtZXRyb3NMb2phIi4iSUQiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iSURNb2VkYURlZmVpdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iTW9yYWRhIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkZvdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRm90b0NhbWluaG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRGVzaWduYWNhb0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJDb2RpZ29Qb3N0YWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iTG9jYWxpZGFkZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJDb25jZWxobyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJEaXN0cml0byIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRFBhaXMiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iVGVsZWZvbmUiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRmF4IiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkVtYWlsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIldlYlNpdGUiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iTklGIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNvbnNlcnZhdG9yaWFSZWdpc3RvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIk51bWVyb1JlZ2lzdG9Db21lcmNpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ2FwaXRhbFNvY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJDYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iSURMb2phIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklESWRpb21hQmFzZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJTaXN0ZW1hIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkF0aXZvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkRhdGFDcmlhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIlV0aWxpemFkb3JDcmlhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkRhdGFBbHRlcmFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJGM01NYXJjYWRvciIsDQogICAgICAgInRiTW9lZGFzIi4iU2ltYm9sbyIsDQogICAgICAgInRiTW9lZGFzIi4iVGF4YUNvbnZlcnNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iRGVzY3JpY2FvRGVjaW1hbCIsDQogICAgICAgInRiTW9lZGFzIi4iRGVzY3JpY2FvSW50ZWlyYSIsDQogICAgICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1RvdGFpcyIsDQogICAgICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc0l2YSIsDQogICAgICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIsDQogICAgICAgInRiU2lzdGVtYVNpZ2xhc1BhaXNlcyIuU2lnbGENCmZyb20gImRibyIuInRiTG9qYXMiICJ0YkxvamFzIg0KaW5uZXIgam9pbiAiZGJvIi4idGJMb2phcyIgInRiTG9qYXNTZWRlIiBvbiAidGJMb2phcyIuaWRsb2phc2VkZT0idGJMb2phc1NlZGUiLmlkDQpsZWZ0IGpvaW4gImRibyIuInRicGFyYW1ldHJvc2xvamEiICJ0YnBhcmFtZXRyb3Nsb2phIiBvbiAidGJMb2phcyIuaWQ9InRicGFyYW1ldHJvc2xvamEiLmlkbG9qYQ0KbGVmdCBqb2luICJkYm8iLiJ0YnBhcmFtZXRyb3Nsb2phIiAidGJwYXJhbWV0cm9zbG9qYXNlZGUiIG9uICJ0YkxvamFzU2VkZSIuaWQ9InRicGFyYW1ldHJvc2xvamFzZWRlIi5pZGxvamENCmxlZnQgam9pbiAiZGJvIi4idGJNb2VkYXMiICJ0Yk1vZWRhcyIgb24gInRiTW9lZGFzIi4iSUQiID0gInRiUGFyYW1ldHJvc0xvamEiLiJJRE1vZWRhRGVmZWl0byINCmxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hU2lnbGFzUGFpc2VzIiAidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIiBvbiAidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIi4iSUQiID0gInRiUGFyYW1ldHJvc0xvamEiLiJJRFBhaXMiDQp3aGVyZSAidGJMb2phcyIuSUQgPSBASURMb2phPC9TcWw+PC9RdWVyeT48UmVzdWx0U2NoZW1hPjxEYXRhU2V0PjxWaWV3IE5hbWU9InRiUGFyYW1ldHJvc0xvamEiPjxGaWVsZCBOYW1lPSJJRExvamFTZWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhU2VkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxTZWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkxvY2FsaWRhZGVTZWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lU2VkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxobyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUZWxlZm9uZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGYXgiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iV2ViU2l0ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOSUYiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXBpdGFsU29jaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURJZGlvbWFCYXNlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUYXhhQ29udmVyc2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0RlY2ltYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvSW50ZWlyYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzVG90YWlzIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzSXZhIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJTaWdsYSIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgRGJDb21tYW5kVGltZW91dD0iMTgwMCIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''
--cabeçalho pagamento compras
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito],[SubReport]) VALUES (@intOrdem, N''DocumentosPagamentosCompras'', N''PagamentosComprasCabecalho'', N''PagamentosComprasCabecalho'', N'''', 1, @ptrval, NULL, N'''', 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''', @intModulo, @intSistemaTipoDoc, @intSistemaTipoDocFiscal, 0,1)
')

--vistas pagamentos compras - principal
EXEC('
DECLARE @ptrval xml;  
DECLARE @IDObservacoes as bigint;--10000
DECLARE @IDCabecalho as bigint;--20000

SELECT @IDObservacoes = ID  FROM tbMapasVistas WHERE Entidade = ''DocumentosPagamentosCompras'' and NomeMapa=''PagamentosComprasObservacoes''
SELECT @IDCabecalho = ID  FROM tbMapasVistas WHERE Entidade = ''DocumentosPagamentosCompras'' and NomeMapa=''PagamentosComprasCabecalho''

SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="PagamentosCompras" ScriptsSource="Imports System.Linq&#xD;&#xA;Imports Reporting&#xD;&#xA;Imports DevExpress.DataAccess.Native.Sql&#xD;&#xA;Imports System.ComponentModel&#xD;&#xA;Imports System.Linq&#xD;&#xA;&#xD;&#xA;Private dblTotal As Double = 0&#xD;&#xA;Private dblTotalPagina As Double = 0&#xD;&#xA;Private dblTransportar As Double = 0&#xD;&#xA;Dim count As Int16 = 0&#xD;&#xA;Dim count2 As Int16 = 0&#xD;&#xA;&#xD;&#xA;Private Sub rptPagamentosCompras_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;        Dim SimboloMoeda As String = String.Empty&#xD;&#xA;        Dim strEntidade As String = String.Empty&#xD;&#xA;        Dim strEntidade1 As String = String.Empty&#xD;&#xA;        Dim strEntidade2 As String = String.Empty&#xD;&#xA;        Dim strBeneficiario1 As String = String.Empty&#xD;&#xA;        Dim strBeneficiario2 As String = String.Empty&#xD;&#xA;        Dim strParentesco1 As String = String.Empty&#xD;&#xA;        Dim strParentesco2 As String = String.Empty&#xD;&#xA;        Dim strValor As String = String.Empty&#xD;&#xA;        Dim strTipo As String = String.Empty&#xD;&#xA;        Dim strSerie As String = String.Empty&#xD;&#xA;        Dim strNumero As String = String.Empty&#xD;&#xA;        Dim strData As String = String.Empty&#xD;&#xA;        Dim strCodigoPostal As String = String.Empty&#xD;&#xA;        Dim strLocalidade As String = String.Empty&#xD;&#xA;        Dim strSigla As String = String.Empty&#xD;&#xA;        Dim numeroCasasDecimaisMoeda As Int16 = 0&#xD;&#xA;        Dim numeroCasasDecimaisPercentagens As Int16 = 0&#xD;&#xA;&#xD;&#xA;        Dim aux As String = String.Empty&#xD;&#xA;&#xD;&#xA;        Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;        Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;        Dim coluna As ResultColumn&#xD;&#xA;&#xD;&#xA;        Dim rs As ResultSet = TryCast(TryCast(Me.DataSource, IListSource).GetList(), ResultSet)&#xD;&#xA;        Dim rsDV As ResultTable = rs.Tables.FirstOrDefault(Function(x) x.TableName.Equals(&quot;tbPagamentosCompras&quot;))&#xD;&#xA;&#xD;&#xA;        Me.lblNumVias.Text = Me.Parameters(&quot;Via&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;        ''''leitura de dados do cabeçalho&#xD;&#xA;        If rsDV IsNot Nothing Then&#xD;&#xA;            If rsDV.Count &gt; 0 Then&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbPagamentosComprasLinhas_ID&quot;))&#xD;&#xA;                Dim IDLinha As Long = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;                Me.Parameters.Item(&quot;IDLinha&quot;).Value = IDLinha&#xD;&#xA;&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbMoedas_Simbolo&quot;))&#xD;&#xA;                SimboloMoeda = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;                If SimboloMoeda = &quot;&quot; Then&#xD;&#xA;                    Me.Parameters.Item(&quot;SimboloMoedas&quot;).Value = &quot;€&quot;&#xD;&#xA;                    SimboloMoeda = &quot;€&quot;&#xD;&#xA;                Else&#xD;&#xA;                    Me.Parameters.Item(&quot;SimboloMoedas&quot;).Value = SimboloMoeda&#xD;&#xA;                End If&#xD;&#xA;&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;                Try&#xD;&#xA;                    numeroCasasDecimaisMoeda = Convert.ToInt16(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;                Catch ex As Exception&#xD;&#xA;                    numeroCasasDecimaisMoeda = 0&#xD;&#xA;                End Try&#xD;&#xA;&#xD;&#xA;                Dim CMoedas As Integer&#xD;&#xA;                Try&#xD;&#xA;                    CMoedas = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;                Catch ex As Exception&#xD;&#xA;                    CMoedas = 0&#xD;&#xA;                End Try&#xD;&#xA;&#xD;&#xA;                Me.Parameters.Item(&quot;CasasMoedas&quot;).Value = CMoedas&#xD;&#xA;&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbParamentrosEmpresa_CasasDecimaisPercentagem&quot;))&#xD;&#xA;                Try&#xD;&#xA;                    numeroCasasDecimaisPercentagens = 4 ''''Definido por JO: valor fixo na janela de pagamentos&#xD;&#xA;                Catch ex As Exception&#xD;&#xA;                    numeroCasasDecimaisPercentagens = 0&#xD;&#xA;                End Try&#xD;&#xA;&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbTiposDocumento_Descricao&quot;))&#xD;&#xA;                Dim tipoEstrutura = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbSistemaNaturezas_Codigo&quot;))&#xD;&#xA;                Dim strNatureza = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;&#xD;&#xA;                Me.Parameters.Item(&quot;AcompanhaBens&quot;).Value = False&#xD;&#xA;&#xD;&#xA;                Me.SubBand4.Visible = True&#xD;&#xA;&#xD;&#xA;                Me.lblDescontoGlobal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalDescontos&quot;, culture)&#xD;&#xA;                Me.fldDescontoGlobal.TextFormatString = &quot;{0:0.00}&quot;&#xD;&#xA;&#xD;&#xA;                ''''Assinatura&#xD;&#xA;                Dim strAssinatura As String = String.Empty&#xD;&#xA;&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;MensagemDocAT&quot;))&#xD;&#xA;                strValor = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;                Me.fldAssinatura.Text = strValor&#xD;&#xA;                Me.fldAssinatura1.Text = strValor&#xD;&#xA;&#xD;&#xA;                ''''Separadores totalizadores&#xD;&#xA;                Me.lblSubTotal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;SubTotal&quot;, culture)&#xD;&#xA;                Me.fldSubTotal.TextFormatString  = &quot;{0:0.00}&quot;&#xD;&#xA;&#xD;&#xA;                Me.lblTotalMoedaDocumento.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalMoedaDocumento&quot;, culture)&#xD;&#xA;                Me.fldTotalMoedaDocumento.TextFormatString = &quot;{0:0.00}&quot;&#xD;&#xA;&#xD;&#xA;                ''''Identificação do documento&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbTiposDocumento_Descricao&quot;))&#xD;&#xA;                strValor = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;                Me.lblTipoDocumento.Text = resource.GetResource(strValor, culture)&#xD;&#xA;&#xD;&#xA;                Me.lblPercentagemDesconto.Text = &quot;%&quot; &amp; resource.GetResource(&quot;Desconto&quot;, culture)&#xD;&#xA;                Me.fldPercentagemDesconto.TextFormatString  = &quot;{0:0.00}&quot;&#xD;&#xA;&#xD;&#xA;                Me.lblValorDesconto.Text = resource.GetResource(&quot;ValorDesconto&quot;, culture)&#xD;&#xA;&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbTiposDocumento_Codigo&quot;))&#xD;&#xA;                strTipo = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;CodigoSerie&quot;))&#xD;&#xA;                strSerie = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;NumeroDocumento&quot;))&#xD;&#xA;                strNumero = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;                Me.fldTipoDocumento.Text = strTipo &amp; &quot; &quot; &amp; strSerie &amp; &quot;/&quot; &amp; strNumero&#xD;&#xA;&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbCodigosPostaisCliente_Codigo&quot;))&#xD;&#xA;                strCodigoPostal = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbCodigosPostaisCliente_Descricao&quot;))&#xD;&#xA;                strLocalidade = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;&#xD;&#xA;                Me.fldCodigoPostal.Text = strCodigoPostal &amp; &quot; &quot; &amp; strLocalidade&#xD;&#xA;&#xD;&#xA;                Me.fldTotalDocumentoLinha.TextFormatString = &quot;{0:0.00}&quot;&#xD;&#xA;                Me.fldValorPendenteLinha.TextFormatString = &quot;{0:0.00}&quot;&#xD;&#xA;                Me.fldValorPagoLinha.TextFormatString = &quot;{0:0.00}&quot;&#xD;&#xA;                Me.fldValorDescontoLinha.TextFormatString = &quot;{0:0.00}&quot;&#xD;&#xA;&#xD;&#xA;                coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;CodigoTipoEstado&quot;))&#xD;&#xA;                strValor = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;                If strValor = &quot;ANL&quot; Then&#xD;&#xA;                    Me.lblAnulado.Text = resource.GetResource(&quot;Anulado&quot;, culture)&#xD;&#xA;                    Me.lblAnulado.Visible = True&#xD;&#xA;                End If&#xD;&#xA;&#xD;&#xA;                TraducaoDocumento()&#xD;&#xA;            Else&#xD;&#xA;                Throw New Exception(Traducao.EstruturaImpressao.ImpressaoVazia)&#xD;&#xA;            End If&#xD;&#xA;        End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub TraducaoDocumento()&#xD;&#xA;&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    Me.lblContribuinte.Text = resource.GetResource(&quot;Contribuinte&quot;, culture)&#xD;&#xA;    Me.lblFornecedorCodigo.Text = resource.GetResource(&quot;FornecedorCodigo&quot;, culture)&#xD;&#xA;    Me.lblCodigoMoeda.Text = resource.GetResource(&quot;CodigoMoeda&quot;, culture)&#xD;&#xA;    Me.lblDataDocumento.Text = resource.GetResource(&quot;DataDocumento&quot;, culture)&#xD;&#xA;    Me.lblTituloTransporte.Text = resource.GetResource(&quot;TituloTransporte&quot;, culture)&#xD;&#xA;    Me.lblTituloTransportar.Text = resource.GetResource(&quot;TituloTransportar&quot;, culture)&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;&#xD;&#xA;Public Function CasasDecimaisQuantidades() As String&#xD;&#xA;&#xD;&#xA;    Dim numeroCasasDecimaisUnidades As Int16 = 0&#xD;&#xA;    Dim coluna As ResultColumn&#xD;&#xA;&#xD;&#xA;    Dim rs As ResultSet = TryCast(TryCast(Me.DataSource, IListSource).GetList(), ResultSet)&#xD;&#xA;    Dim rsDV As ResultTable = rs.Tables.FirstOrDefault(Function(x) x.TableName.Equals(&quot;tbPagamentosCompras&quot;))&#xD;&#xA;&#xD;&#xA;    coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;NumCasasDecUnidade&quot;))&#xD;&#xA;    Try&#xD;&#xA;        numeroCasasDecimaisUnidades = Convert.ToInt16(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(count), ResultRow)))&#xD;&#xA;    Catch ex As Exception&#xD;&#xA;        numeroCasasDecimaisUnidades = 0&#xD;&#xA;    End Try&#xD;&#xA;&#xD;&#xA;    Dim sFormat As String = String.Format(&quot;{{0:0.{0}}}&quot;, New String(&quot;0&quot;, numeroCasasDecimaisUnidades))&#xD;&#xA;&#xD;&#xA;    Return sFormat&#xD;&#xA;End Function&#xD;&#xA;&#xD;&#xA;Private Sub fldTaxaIVA_AfterPrint(sender As Object, e As EventArgs)&#xD;&#xA;    AfterPrintValores()&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldUnidade_AfterPrint(sender As Object, e As EventArgs)&#xD;&#xA;    AfterPrintValores()&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldTaxaIVA1_AfterPrint(sender As Object, e As EventArgs)&#xD;&#xA;    AfterPrintValores()&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Public Sub AfterPrintValores()&#xD;&#xA;    Dim aux As Integer = 0&#xD;&#xA;    Dim coluna As ResultColumn&#xD;&#xA;    Dim rs As ResultSet = TryCast(TryCast(Me.DataSource, IListSource).GetList(), ResultSet)&#xD;&#xA;    Dim rsDV As ResultTable = rs.Tables.FirstOrDefault(Function(x) x.TableName.Equals(&quot;tbPagamentosCompras&quot;))&#xD;&#xA;&#xD;&#xA;    ''''leitura de dados do cabeçalho&#xD;&#xA;    If rsDV IsNot Nothing Then&#xD;&#xA;        If rsDV.Count &gt; 0 Then&#xD;&#xA;            coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbPagamentosComprasLinhas_ID&quot;))&#xD;&#xA;            Dim IDLinha As Long = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(count2), ResultRow)))&#xD;&#xA;&#xD;&#xA;            Me.Parameters.Item(&quot;IDLinha&quot;).Value = IDLinha&#xD;&#xA;&#xD;&#xA;            coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;NumCasasDecUnidade&quot;))&#xD;&#xA;            Dim CDecimais As Integer&#xD;&#xA;            Try&#xD;&#xA;                CDecimais = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(count2), ResultRow)))&#xD;&#xA;            Catch ex As Exception&#xD;&#xA;                CDecimais = 0&#xD;&#xA;            End Try&#xD;&#xA;            Me.Parameters.Item(&quot;CasasDecimais&quot;).Value = CDecimais&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    count2 += 1&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub XrLabel55_AfterPrint(sender As Object, e As EventArgs)&#xD;&#xA;    AfterPrintValores()&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldCodigoMotivoIsencaoIva_AfterPrint(sender As Object, e As EventArgs)&#xD;&#xA;    AfterPrintValores()&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub XrLabel52_AfterPrint(sender As Object, e As EventArgs)&#xD;&#xA;    AfterPrintValores()&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldRunningSum_SummaryCalculated(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs)&#xD;&#xA;    dblTotalPagina += e.Value&#xD;&#xA;    dblTotal += e.Value&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Me.lblTransportar.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.lblTituloTransportar.Visible = True&#xD;&#xA;        Me.lblTransportar.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.lblTituloTransportar.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.lblTituloTransporte.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTransporte.Visible = False&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Me.fldAssinatura1.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.lblTransporte.Visible = True&#xD;&#xA;        Me.lblTituloTransporte.Visible = True&#xD;&#xA;        Me.fldAssinatura1.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura1_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.fldAssinatura1.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.fldAssinatura1.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransportar_SummaryGetResult(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs)&#xD;&#xA;    e.Result = dblTotalPagina&#xD;&#xA;    e.Handled = True&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransporte_SummaryGetResult(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs)&#xD;&#xA;    e.Result = dblTotal&#xD;&#xA;    e.Handled = True&#xD;&#xA;End Sub&#xD;&#xA;" SnapGridSize="0.1" DrawWatermark="true" Margins="54, 23, 25, 1" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="19.1" DataMember="tbPagamentosCompras" DataSource="#Ref-0">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="102" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="6" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item3 Ref="7" Visible="false" Description="Via" Name="Via" />
    <Item4 Ref="8" Visible="false" Description="BDEmpresa" ValueInfo="Teste" Name="BDEmpresa" />
    <Item5 Ref="9" Visible="false" Description="Observacoes" ValueInfo="select ID, Observacoes from tbPagamentosCompras where ID=" Name="Observacoes" />
    <Item6 Ref="11" Visible="false" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-10" />
    <Item7 Ref="12" Visible="false" Description="FraseFiscal" ValueInfo="FraseFiscal" Name="FraseFiscal" />
    <Item8 Ref="13" Description="IDEmpresa" ValueInfo="1" Name="IDEmpresa" Type="#Ref-3" />
    <Item9 Ref="15" Visible="false" Description="AcompanhaBens" ValueInfo="true" Name="AcompanhaBens" Type="#Ref-14" />
    <Item10 Ref="16" Description="IDLinha" ValueInfo="0" Name="IDLinha" Type="#Ref-3" />
    <Item11 Ref="18" Description="CasasDecimais" ValueInfo="0" Name="CasasDecimais" Type="#Ref-17" />
    <Item12 Ref="19" Description="CasasMoedas" ValueInfo="0" Name="CasasMoedas" Type="#Ref-17" />
    <Item13 Ref="20" Description="SimboloMoedas" Name="SimboloMoedas" />
    <Item14 Ref="21" Description="UrlServerPath" AllowNull="true" Name="UrlServerPath" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="22" Name="SomaQuantidade" FieldType="Float" DisplayName="SomaQuantidade" Expression="[].Sum([Quantidade])" DataMember="tbDocumentosVendas" />
    <Item2 Ref="23" Name="SomaValorIVA" FieldType="Float" Expression="[].Sum([ValorIVA])" DataMember="tbDocumentosVendas" />
    <Item3 Ref="24" Name="SomaValorIncidencia" FieldType="Float" Expression="[].Sum([ValorIncidencia])" DataMember="tbDocumentosVendas" />
    <Item4 Ref="25" Name="SomaTotalFinal" FieldType="Double" Expression="[].Sum([TotalFinal])" DataMember="tbDocumentosVendas" />
    <Item5 Ref="26" Name="MotivoIsencao" DisplayName="MotivoIsencao" Expression="IIF([TaxaIva]=0, '''''''', [CodigoMotivoIsencaoIva])" DataMember="tbDocumentosVendas" />
    <Item6 Ref="27" Name="cfDescontoLinha" Expression="iif([tbSistemaNaturezas_Codigo]=''''R'''', -[tbPagamentosComprasLinhas_ValorDesconto],[tbPagamentosComprasLinhas_ValorDesconto])" DataMember="tbPagamentosCompras" />
    <Item7 Ref="28" Name="cfValorPago" DisplayName="cfValorPago" Expression="iif([tbSistemaNaturezas_Codigo]=''''R'''', -[tbPagamentosComprasLinhas_ValorPago]+[tbPagamentosComprasLinhas_ValorDesconto],[tbPagamentosComprasLinhas_ValorPago]-[tbPagamentosComprasLinhas_ValorDesconto])" DataMember="tbPagamentosCompras" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="29" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="30" ControlType="ReportHeaderBand" Name="ReportHeader" Expanded="false" HeightF="0" />
    <Item3 Ref="31" ControlType="PageHeaderBand" Name="PageHeader" HeightF="105.7917">
      <SubBands>
        <Item1 Ref="32" ControlType="SubBand" Name="SubBand1" HeightF="172.2917">
          <Controls>
            <Item1 Ref="33" ControlType="XRPanel" Name="XrPanel1" SizeF="746.837,148.3334" LocationFloat="0, 0">
              <Controls>
                <Item1 Ref="34" ControlType="XRLabel" Name="fldCodigoPostal" Text="Código Postal" TextAlignment="TopRight" SizeF="296.2911,22.99999" LocationFloat="381.5468, 86" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <StylePriority Ref="35" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item1>
                <Item2 Ref="36" ControlType="XRLabel" Name="fldCodigoMoeda" TextAlignment="TopLeft" SizeF="194.7021,13.99999" LocationFloat="103.1326, 49.00001" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="37" Expression="[tbMoedas_Codigo]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="38" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item2>
                <Item3 Ref="39" ControlType="XRLabel" Name="lblCodigoMoeda" Text="Moeda" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010068, 49.00004" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Parentesco">
                  <StylePriority Ref="40" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item3>
                <Item4 Ref="41" ControlType="XRLabel" Name="fldMorada" TextAlignment="TopRight" SizeF="296.2915,23" LocationFloat="381.5468, 63" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="42" Expression="[MoradaFiscal]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="43" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item4>
                <Item5 Ref="44" ControlType="XRLabel" Name="fldNome" TextAlignment="TopRight" SizeF="296.2916,23" LocationFloat="381.5467, 40" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="45" Expression="[NomeFiscal]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="46" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item5>
                <Item6 Ref="47" ControlType="XRLabel" Name="lblTitulo" Text="Exmo.(a) Sr.(a) " TextAlignment="TopRight" SizeF="296.2916,20" LocationFloat="381.5464, 20" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <StylePriority Ref="48" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item6>
                <Item7 Ref="49" ControlType="XRLabel" Name="lblContribuinte" Text="Contribuinte nº" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010005, 21.00004" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
                  <StylePriority Ref="50" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item7>
                <Item8 Ref="51" ControlType="XRLabel" Name="lblFornecedorCodigo" Text="Cod. Fornecedor" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010036, 35.00004" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Cliente">
                  <StylePriority Ref="52" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item8>
                <Item9 Ref="53" ControlType="XRLabel" Name="fldFornecedorCodigo" TextAlignment="TopLeft" SizeF="194.7036,14" LocationFloat="103.131, 35.00001" Font="Arial, 8pt" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="54" Expression="[tbFornecedores_Codigo]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="55" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item9>
                <Item10 Ref="56" ControlType="XRLabel" Name="fldContribuinteFiscal" TextAlignment="TopLeft" SizeF="194.715,13.99999" LocationFloat="103.1311, 21" Font="Arial, 8pt" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="57" Expression="[ContribuinteFiscal]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="58" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item10>
              </Controls>
            </Item1>
          </Controls>
        </Item1>
        <Item2 Ref="59" ControlType="SubBand" Name="SubBand4" HeightF="26.01321" Visible="false">
          <Controls>
            <Item1 Ref="60" ControlType="XRLabel" Name="lblValorDesconto" Text="Valor Desconto" TextAlignment="TopRight" SizeF="80.07898,13" LocationFloat="576.3403, 9.999974" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="61" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="62" ControlType="XRLabel" Name="lblPercentagemDesconto" Text="%Desconto" TextAlignment="TopRight" SizeF="68.75,13" LocationFloat="496.7895, 9.999974" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="63" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="64" ControlType="XRLabel" Name="XrLabel8" Text="Total Documento" TextAlignment="TopRight" SizeF="100,13" LocationFloat="288.0858, 10.41444" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="65" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="66" ControlType="XRLine" Name="XrLine1" SizeF="746.6705,2.252249" LocationFloat="1.329763, 23.41446" />
            <Item5 Ref="67" ControlType="XRLabel" Name="lblIvaLinha" Text="Valor Pago" TextAlignment="TopRight" SizeF="84.22339,13" LocationFloat="662.7771, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="68" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="69" ControlType="XRLabel" Name="lblPreco" Text="Valor Pendente" TextAlignment="TopRight" SizeF="87.1203,13" LocationFloat="402.6692, 10.41444" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="70" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="71" ControlType="XRLabel" Name="lblDescricao" Text="Data Documento" TextAlignment="TopLeft" SizeF="82.81,13" LocationFloat="120.31, 10.00002" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="72" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="73" ControlType="XRLabel" Name="lblArtigo" Text="Documento" TextAlignment="TopLeft" SizeF="118.22,13" LocationFloat="0, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="74" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="75" ControlType="XRLabel" Name="lblLote" Text="Vencimento" TextAlignment="TopLeft" SizeF="71.91321,13" LocationFloat="206.0763, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="76" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
          </Controls>
        </Item2>
        <Item3 Ref="77" ControlType="SubBand" Name="SubBand9" HeightF="12">
          <Controls>
            <Item1 Ref="78" ControlType="XRLabel" Name="lblTituloTransportar" Text="Transportar" TextAlignment="MiddleRight" SizeF="78.96,12" LocationFloat="477.4602, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <Scripts Ref="79" OnPrintOnPage="lblTituloTransportar_PrintOnPage" />
              <StylePriority Ref="80" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="81" ControlType="XRLabel" Name="lblTransportar" TextFormatString="{0:0.00}" TextAlignment="MiddleLeft" SizeF="187.58,12" LocationFloat="559.4205, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <Scripts Ref="82" OnSummaryGetResult="lblTransportar_SummaryGetResult" OnPrintOnPage="lblTransportar_PrintOnPage" />
              <Summary Ref="83" Running="Page" IgnoreNullValues="true" />
              <ExpressionBindings>
                <Item1 Ref="84" Expression="sumSum([TotalMoedaDocumento])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="85" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="86" ControlType="XRLabel" Name="fldRunningSum" TextFormatString="{0:0.00}" CanGrow="false" CanShrink="true" SizeF="2,2" LocationFloat="1.351039, 0" ForeColor="Black" Padding="0,0,0,0,100">
              <Scripts Ref="87" OnSummaryCalculated="fldRunningSum_SummaryCalculated" />
              <Summary Ref="88" Running="Page" IgnoreNullValues="true" />
              <ExpressionBindings>
                <Item1 Ref="89" Expression="sumRunningSum([PrecoTotal])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="90" UseForeColor="false" UsePadding="false" />
            </Item3>
          </Controls>
        </Item3>
      </SubBands>
      <Controls>
        <Item1 Ref="91" ControlType="XRSubreport" Name="XrSubreport1" ReportSourceUrl="10000" SizeF="535.2748,105.7917" LocationFloat="0, 0">
          <ParameterBindings>
            <Item1 Ref="92" ParameterName="IDLoja" DataMember="tbPagamentosCompras.IDLoja" />
            <Item2 Ref="94" ParameterName="Culture" Parameter="#Ref-6" />
            <Item3 Ref="95" ParameterName="BDEmpresa" Parameter="#Ref-8" />
            <Item4 Ref="96" ParameterName="DesignacaoComercial" DataMember="tbParametrosLojas.DesignacaoComercial" />
            <Item5 Ref="97" ParameterName="Morada" DataMember="tbParametrosLojas.Morada" />
            <Item6 Ref="98" ParameterName="Localidade" DataMember="tbParametrosLojas.Localidade" />
            <Item7 Ref="99" ParameterName="CodigoPostal" DataMember="tbParametrosLojas.CodigoPostal" />
            <Item8 Ref="100" ParameterName="Sigla" DataMember="tbParametrosLojas.Sigla" />
            <Item9 Ref="101" ParameterName="NIF" DataMember="tbParametrosLojas.NIF" />
            <Item10 Ref="102" ParameterName="" Parameter="#Ref-13" />
            <Item11 Ref="103" ParameterName="UrlServerPath" Parameter="#Ref-21" />
          </ParameterBindings>
        </Item1>
        <Item2 Ref="104" ControlType="XRLabel" Name="fldDataVencimento" TextFormatString="{0:dd-MM-yyyy}" CanGrow="false" TextAlignment="TopRight" SizeF="83.64227,20" LocationFloat="662.777, 78.02378" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="105" Expression="[DataDocumento]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="106" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="107" ControlType="XRLabel" Name="fldTipoDocumento" TextAlignment="TopRight" SizeF="159.7648,20.54824" LocationFloat="586.78, 33.55265" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="108" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="109" ControlType="XRLabel" Name="lblDataDocumento" Text="Data Doc." TextAlignment="TopRight" SizeF="84.06,15" LocationFloat="662.777, 63.10085" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
          <StylePriority Ref="110" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="111" ControlType="XRLabel" Name="lblNumVias" Text="Via" TextAlignment="TopRight" SizeF="160.2199,11.77632" LocationFloat="586.78, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="112" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="113" ControlType="XRLabel" Name="lblTipoDocumento" Text="Fatura" TextAlignment="TopRight" SizeF="159.7648,13.77632" LocationFloat="586.78, 19.77634" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="114" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="115" ControlType="XRLabel" Name="lblAnulado" Angle="20" Text="ANULADO" TextAlignment="MiddleCenter" SizeF="189.8313,105.7917" LocationFloat="427.3537, 0" Font="Arial, 24pt, style=Bold, charSet=0" ForeColor="Red" Padding="2,2,0,0,100" Visible="false">
          <StylePriority Ref="116" UseFont="false" UseForeColor="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="117" ControlType="XRLabel" Name="lblSegundaVia" Text="2º Via" TextAlignment="TopLeft" SizeF="80.59814,13.77632" LocationFloat="586.78, 0" Font="Arial, 9pt, style=Bold, charSet=0" ForeColor="Black" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
          <StylePriority Ref="118" UseFont="false" UseForeColor="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item8>
      </Controls>
    </Item3>
    <Item4 Ref="119" ControlType="DetailBand" Name="Detail" KeepTogetherWithDetailReports="true" SnapLinePadding="0,0,0,0,100" HeightF="16" KeepTogether="true" TextAlignment="TopLeft" Padding="0,0,0,0,100">
      <Controls>
        <Item1 Ref="120" ControlType="XRLabel" Name="fldValorDescontoLinha" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="90.32422,15" LocationFloat="566.095, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="121" Expression="[cfDescontoLinha]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="122" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="123" ControlType="XRLabel" Name="fldTotalDocumentoLinha" TextAlignment="TopRight" SizeF="83.42624,15" LocationFloat="304.6596, 1.000007" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="124" Expression="[tbDocumentosCompras_TotalMoedaDocumento]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="125" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="126" ControlType="XRLabel" Name="fldValorPagoLinha" TextAlignment="TopRight" SizeF="90.5813,15" LocationFloat="656.4192, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="127" Expression="[cfValorPago]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="128" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="129" ControlType="XRLabel" Name="fldValorPendenteLinha" Text="fldValorPendenteLinha" TextAlignment="TopRight" SizeF="87.12021,15" LocationFloat="402.6693, 1.000007" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="130" Expression="[tbPagamentosComprasLinhas_ValorPendente]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="131" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="132" ControlType="XRLabel" Name="XrLabel3" TextFormatString="{0:dd-MM-yyyy}" SizeF="100,15" LocationFloat="204.6596, 1.000007" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="133" Expression="[tbPagamentosComprasLinhas_DataVencimento]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="134" UseFont="false" />
        </Item5>
        <Item6 Ref="135" ControlType="XRLabel" Name="XrLabel5" Text="XrLabel5" SizeF="118.22,15" LocationFloat="0, 1.000007" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="136" Expression="[tbPagamentosComprasLinhas_Documento]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="137" UseFont="false" />
        </Item6>
        <Item7 Ref="138" ControlType="XRLabel" Name="XrLabel2" TextFormatString="{0:dd-MM-yyyy}" SizeF="82.81,15" LocationFloat="120.31, 1.000007" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="139" Expression="[tbPagamentosComprasLinhas_DataDocumento]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="140" UseFont="false" />
        </Item7>
        <Item8 Ref="141" ControlType="XRLabel" Name="fldPercentagemDesconto" Text="fldPercentagemDesconto" TextAlignment="TopRight" SizeF="68.75003,15" LocationFloat="496.7895, 1.000007" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="142" Expression="[tbPagamentosComprasLinhas_PercentagemDesconto]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="143" UseFont="false" UseTextAlignment="false" />
        </Item8>
      </Controls>
    </Item4>
    <Item5 Ref="144" ControlType="GroupFooterBand" Name="GroupFooter1" PrintAtBottom="true" HeightF="98.25002">
      <Controls>
        <Item1 Ref="145" ControlType="XRLabel" Name="lblDescontoGlobal" TextAlignment="TopRight" SizeF="87.25984,16" LocationFloat="460.2796, 47.64999" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="146" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="147" ControlType="XRLabel" Name="fldDescontoGlobal" TextAlignment="TopRight" SizeF="87.00002,20.96" LocationFloat="460.5394, 64.65189" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="148" Expression="[TotalDescontos]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="149" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="150" ControlType="XRLabel" Name="fldTotalMoedaDocumento" TextAlignment="TopRight" SizeF="176.209,25.59814" LocationFloat="564.0951, 61.6519" Font="Arial, 14.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="151" Expression="[TotalMoedaDocumento]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="152" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="153" ControlType="XRLabel" Name="lblTotalMoedaDocumento" TextAlignment="TopRight" SizeF="121.383,17" LocationFloat="618.9211, 47.65189" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="154" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="155" ControlType="XRLabel" Name="fldSubTotal" TextFormatString="{0:€0.00}" TextAlignment="TopRight" SizeF="87.25985,20.95646" LocationFloat="362.2796, 64.65189" Font="Arial, 6.75pt" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="156" Expression="[TotalDocumentos]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="157" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="158" ControlType="XRLabel" Name="lblSubTotal" TextAlignment="TopRight" SizeF="87.75003,16" LocationFloat="361.7894, 47.64999" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="159" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="160" ControlType="XRLine" Name="XrLine5" SizeF="747.0004,2" LocationFloat="1.351039, 43.25504" />
        <Item8 Ref="161" ControlType="XRLabel" Name="fldAssinatura" TextAlignment="MiddleLeft" SizeF="606.5347,13" LocationFloat="1.351039, 30.255" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="162" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="163" ControlType="XRLabel" Name="XrLabel4" SizeF="192.581,53.99998" LocationFloat="556.4193, 44.25003" BackColor="Gainsboro" Padding="2,2,0,0,100" Borders="None" BorderWidth="1">
          <StylePriority Ref="164" UseBackColor="false" UseBorders="false" UseBorderWidth="false" />
        </Item9>
      </Controls>
    </Item5>
    <Item6 Ref="165" ControlType="ReportFooterBand" Name="ReportFooter" PrintAtBottom="true" HeightF="52.18089">
      <Controls>
        <Item1 Ref="166" ControlType="XRLine" Name="XrLine8" SizeF="747.0001,3.000001" LocationFloat="2, 0" />
        <Item2 Ref="167" ControlType="XRSubreport" Name="XrSubreport5" ReportSourceUrl="20000" SizeF="747.0002,46.18089" LocationFloat="2, 3">
          <ParameterBindings>
            <Item1 Ref="168" ParameterName="Culture" Parameter="#Ref-6" />
            <Item2 Ref="169" ParameterName="Observacoes" Parameter="#Ref-9" />
            <Item3 Ref="170" ParameterName="IDDocumento" Parameter="#Ref-4" />
            <Item4 Ref="171" ParameterName="IDLoja" Parameter="#Ref-11" />
            <Item5 Ref="172" ParameterName="FraseFiscal" Parameter="#Ref-12" />
            <Item6 Ref="173" ParameterName="BDEmpresa" Parameter="#Ref-8" />
            <Item7 Ref="174" ParameterName="AcompanhaBens" Parameter="#Ref-15" />
          </ParameterBindings>
        </Item2>
      </Controls>
    </Item6>
    <Item7 Ref="175" ControlType="PageFooterBand" Name="PageFooter" HeightF="38.33949">
      <SubBands>
        <Item1 Ref="176" ControlType="SubBand" Name="SubBand3" HeightF="19.7304">
          <Controls>
            <Item1 Ref="177" ControlType="XRLabel" Name="XrLabel1" Text="Processado por computador" TextAlignment="TopLeft" SizeF="169.5834,12.99997" LocationFloat="0, 4.000028" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="178" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="179" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="746.6705,4" LocationFloat="0, 0" BorderWidth="3">
              <StylePriority Ref="180" UseBorderWidth="false" />
            </Item2>
            <Item3 Ref="181" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="625.4193, 4.000028" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="182" UseFont="false" UseTextAlignment="false" />
            </Item3>
          </Controls>
        </Item1>
      </SubBands>
      <Controls>
        <Item1 Ref="183" ControlType="XRLabel" Name="lblTituloTransporte" Text="Transporte" TextAlignment="MiddleRight" SizeF="78.96,12" LocationFloat="480.4605, 5.652682" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="184" OnPrintOnPage="lblTituloTransporte_PrintOnPage" />
          <StylePriority Ref="185" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="186" ControlType="XRLabel" Name="lblTransporte" TextFormatString="{0:0.00}" TextAlignment="MiddleLeft" SizeF="187.58,12" LocationFloat="559.4205, 5.652682" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <Scripts Ref="187" OnSummaryGetResult="lblTransporte_SummaryGetResult" OnPrintOnPage="lblTransporte_PrintOnPage" />
          <Summary Ref="188" Running="Page" IgnoreNullValues="true" />
          <ExpressionBindings>
            <Item1 Ref="189" Expression="sumSum([TotalMoedaDocumento])" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="190" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="191" ControlType="XRLabel" Name="fldAssinatura1" TextAlignment="MiddleLeft" SizeF="445.7733,13" LocationFloat="1.351039, 22.63114" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="192" OnPrintOnPage="fldAssinatura1_PrintOnPage" />
          <ExpressionBindings>
            <Item1 Ref="193" Expression="Iif(Round([Quantidade], [NumCasasDecUnidade]) = [Quantidade], False, ?)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="194" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
      </Controls>
    </Item7>
    <Item8 Ref="195" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="1" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="196" OnBeforePrint="rptPagamentosCompras_BeforePrint" />
  <ExportOptions Ref="197">
    <Html Ref="198" ExportMode="SingleFilePageByPage" />
  </ExportOptions>
  <Watermark Ref="199" ShowBehind="false" Text="CONFIDENTIAL" Font="Arial, 96pt" />
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="10" Content="System.Int32" Type="System.Type" />
    <Item3 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="14" Content="System.Boolean" Type="System.Type" />
    <Item4 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="17" Content="System.Int16" Type="System.Type" />
    <Item5 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMTQzXGYzbTIwMTc7VXNlciBJRD1GM01PO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTI1MDVGM01POyIgLz48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiUGFnYW1lbnRvc0NvbXByYXMiPjxQYXJhbWV0ZXIgTmFtZT0iSUREb2N1bWVudG8iIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKFtQYXJhbWV0ZXJzLklERG9jdW1lbnRvXSk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCBkaXN0aW5jdCAgInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJRCIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIklEVGlwb0RvY3VtZW50byIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIk51bWVyb0RvY3VtZW50byIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkRhdGFEb2N1bWVudG8iLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJPYnNlcnZhY29lcyIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIklETW9lZGEiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJUYXhhQ29udmVyc2FvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iVG90YWxNb2VkYURvY3VtZW50byIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIlRvdGFsTW9lZGFSZWZlcmVuY2lhIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iTG9jYWxDYXJnYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkRhdGFDYXJnYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkhvcmFDYXJnYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIk1vcmFkYUNhcmdhIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIklEQ29uY2VsaG9DYXJnYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9DYXJnYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkxvY2FsRGVzY2FyZ2EiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJEYXRhRGVzY2FyZ2EiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJIb3JhRGVzY2FyZ2EiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJNb3JhZGFEZXNjYXJnYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvRGVzY2FyZ2EiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvRGVzY2FyZ2EiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJOb21lRGVzdGluYXRhcmlvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iTW9yYWRhRGVzdGluYXRhcmlvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvRGVzdGluYXRhcmlvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIlNlcmllRG9jTWFudWFsIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iTnVtZXJvRG9jTWFudWFsIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iTnVtZXJvTGluaGFzIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iUG9zdG8iLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJREVzdGFkbyIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIlV0aWxpemFkb3JFc3RhZG8iLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJEYXRhSG9yYUVzdGFkbyIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkFzc2luYXR1cmEiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJWZXJzYW9DaGF2ZVByaXZhZGEiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJOb21lRmlzY2FsIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iTW9yYWRhRmlzY2FsIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvRmlzY2FsIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Zpc2NhbCIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkNvbnRyaWJ1aW50ZUZpc2NhbCIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIlNpZ2xhUGFpc0Zpc2NhbCIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIklETG9qYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkltcHJlc3NvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iVmFsb3JJbXBvc3RvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iUGVyY2VudGFnZW1EZXNjb250byIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIlZhbG9yRGVzY29udG8iLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJWYWxvclBvcnRlcyIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIklEVGF4YUl2YVBvcnRlcyIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIlRheGFJdmFQb3J0ZXMiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJNb3Rpdm9Jc2VuY2FvSXZhIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iTW90aXZvSXNlbmNhb1BvcnRlcyIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIklERXNwYWNvRmlzY2FsUG9ydGVzIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iRXNwYWNvRmlzY2FsUG9ydGVzIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURSZWdpbWVJdmFQb3J0ZXMiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJSZWdpbWVJdmFQb3J0ZXMiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJDdXN0b3NBZGljaW9uYWlzIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iU2lzdGVtYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkF0aXZvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iRGF0YUNyaWFjYW8iLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJVdGlsaXphZG9yQ3JpYWNhbyIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkRhdGFBbHRlcmFjYW8iLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJVdGlsaXphZG9yQWx0ZXJhY2FvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iRjNNTWFyY2Fkb3IiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJREZvcm1hRXhwZWRpY2FvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURUaXBvc0RvY3VtZW50b1NlcmllcyIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIk51bWVyb0ludGVybm8iLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJREVudGlkYWRlIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURUaXBvRW50aWRhZGUiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJRENvbmRpY2FvUGFnYW1lbnRvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURMb2NhbE9wZXJhY2FvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iQ29kaWdvQVQiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJRFBhaXNDYXJnYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIklEUGFpc0Rlc2NhcmdhIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iTWF0cmljdWxhIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURQYWlzRmlzY2FsIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iQ29kaWdvUG9zdGFsRmlzY2FsIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iRGVzY3JpY2FvQ29kaWdvUG9zdGFsRmlzY2FsIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iRGVzY3JpY2FvQ29uY2VsaG9GaXNjYWwiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJEZXNjcmljYW9EaXN0cml0b0Zpc2NhbCIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIklERXNwYWNvRmlzY2FsIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURSZWdpbWVJdmEiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJDb2RpZ29BVEludGVybm8iLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJUaXBvRmlzY2FsIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iRG9jdW1lbnRvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iQ29kaWdvVGlwb0VzdGFkbyIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkNvZGlnb0RvY09yaWdlbSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkRpc3RyaXRvQ2FyZ2EiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJDb25jZWxob0NhcmdhIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iQ29kaWdvUG9zdGFsQ2FyZ2EiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNDYXJnYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkRpc3RyaXRvRGVzY2FyZ2EiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJDb25jZWxob0Rlc2NhcmdhIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iQ29kaWdvUG9zdGFsRGVzY2FyZ2EiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNEZXNjYXJnYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkNvZGlnb0VudGlkYWRlIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iQ29kaWdvTW9lZGEiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJNZW5zYWdlbURvY0FUIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURTaXNUaXBvc0RvY1BVIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iQ29kaWdvU2lzVGlwb3NEb2NQVSIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkRvY01hbnVhbCIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkRvY1JlcG9zaWNhbyIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkRhdGFBc3NpbmF0dXJhIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iRGF0YUNvbnRyb2xvSW50ZXJubyIsDQoidGJQYWdhbWVudG9zQ29tcHJhcyIuIkRhdGFEb2N1bWVudG8iLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJUb3RhbERvY3VtZW50b3MiLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJUb3RhbERlc2NvbnRvcyIsDQoidGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhcyIuIklEIiBhcyAidGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhc19JRCIsDQoidGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhcyIuIkRhdGFEb2N1bWVudG8iIGFzICJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzX0RhdGFEb2N1bWVudG8iLA0KInRiUGFnYW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEYXRhVmVuY2ltZW50byIgYXMgInRiUGFnYW1lbnRvc0NvbXByYXNMaW5oYXNfRGF0YVZlbmNpbWVudG8iLA0KInRiUGFnYW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEb2N1bWVudG8iIGFzICJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzX0RvY3VtZW50byIsDQoidGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhcyIuIklERW50aWRhZGUiIGFzICJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzX0lERW50aWRhZGUiLA0KInRiUGFnYW1lbnRvc0NvbXByYXNMaW5oYXMiLiJWYWxvclBlbmRlbnRlIiBhcyAidGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhc19WYWxvclBlbmRlbnRlIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzIi4iVmFsb3JQYWdvIiBhcyAidGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhc19WYWxvclBhZ28iLA0KInRiUGFnYW1lbnRvc0NvbXByYXNMaW5oYXMiLiJUYXhhQ29udmVyc2FvIiBhcyAidGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhc19UYXhhQ29udmVyc2FvIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzIi4iSURNb2VkYSIgYXMgInRiUGFnYW1lbnRvc0NvbXByYXNMaW5oYXNfSURNb2VkYSIsDQoidGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhcyIuIk9yZGVtIiwNCiJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzIi4iUGVyY2VudGFnZW1EZXNjb250byIgYXMgInRiUGFnYW1lbnRvc0NvbXByYXNMaW5oYXNfUGVyY2VudGFnZW1EZXNjb250byIsDQoidGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhcyIuIlZhbG9yRGVzY29udG8iIGFzICJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzX1ZhbG9yRGVzY29udG8iLA0KInRiRm9ybmVjZWRvcmVzIi4iTm9tZSIgYXMgInRiRm9ybmVjZWRvcmVzX05vbWUiLA0KInRiRm9ybmVjZWRvcmVzIi4iQ29kaWdvIiBhcyAidGJGb3JuZWNlZG9yZXNfQ29kaWdvIiwNCiJ0YkZvcm5lY2Vkb3JlcyIuIk5Db250cmlidWludGUiIGFzICJ0YkZvcm5lY2Vkb3Jlc19OQ29udHJpYnVpbnRlIiwNCiJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiLiJNb3JhZGEiIGFzICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXNfTW9yYWRhIiwNCiJ0YkNvZGlnb3NQb3N0YWlzIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfQ29kaWdvIiwNCiJ0YkNvZGlnb3NQb3N0YWlzIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiwNCiJ0YkVzdGFkb3MiLiJDb2RpZ28iIGFzICJ0YkVzdGFkb3NfQ29kaWdvIiwNCiJ0YkVzdGFkb3MiLiJEZXNjcmljYW8iIGFzICJ0YkVzdGFkb3NfRGVzY3JpY2FvIiwNCiJ0YlRpcG9zRG9jdW1lbnRvIi4iQ29kaWdvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Db2RpZ28iLA0KInRiVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0Rlc2NyaWNhbyIsDQoidGJUaXBvc0RvY3VtZW50byIuIkRvY05hb1ZhbG9yaXphZG8iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0RvY05hb1ZhbG9yaXphZG8iLA0KInRiVGlwb3NEb2N1bWVudG8iLiJBY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIgYXMgInRiVGlwb3NEb2N1bWVudG9fQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iLA0KInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsDQoidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIkRlc2NyaWNhb1NlcmllIiwNCiJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIkRlc2NyaWNhbyIgYXMgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsX0Rlc2NyaWNhbyIsDQoidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJUaXBvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fVGlwbyIsDQoidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iVGlwbyIsDQoidGJDb2RpZ29zUG9zdGFpczEiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0NvZGlnbyIsDQoidGJDb2RpZ29zUG9zdGFpczEiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIsDQoidGJDb2RpZ29zUG9zdGFpczIiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfQ29kaWdvIiwNCiJ0YkNvZGlnb3NQb3N0YWlzMiIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDYXJnYV9EZXNjcmljYW8iLA0KInRiQ29kaWdvc1Bvc3RhaXMzIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0NvZGlnbyIsDQoidGJDb2RpZ29zUG9zdGFpczMiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfRGVzY3JpY2FvIiwNCiJ0Yk1vZWRhcyIuIkNvZGlnbyIgYXMgInRiTW9lZGFzX0NvZGlnbyIsDQoidGJNb2VkYXMiLiJEZXNjcmljYW8iIGFzICJ0Yk1vZWRhc19EZXNjcmljYW8iLA0KInRiTW9lZGFzIi4iU2ltYm9sbyIgYXMgInRiTW9lZGFzX1NpbWJvbG8iLA0KInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1RvdGFpcyIgYXMgInRiTW9lZGFzX0Nhc2FzRGVjaW1haXNUb3RhaXMiLA0KInRiU2lzdGVtYU1vZWRhcyIuIkNvZGlnbyIgYXMgInRiU2lzdGVtYU1vZWRhc19Db2RpZ28iLA0KInRiUGFnYW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhRG9jdW1lbnRvIiAtICJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iVmFsb3JJbXBvc3RvIiBhcyAiU3ViVG90YWwiLA0KInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIGFzICJ0YlBhcmFtZW50cm9zRW1wcmVzYV9DYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iLA0KInRiU2lzdGVtYU5hdHVyZXphcyIuQ29kaWdvIGFzICJ0YlNpc3RlbWFOYXR1cmV6YXNfQ29kaWdvIiwNCiJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVG90YWxNb2VkYURvY3VtZW50byIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNfVG90YWxNb2VkYURvY3VtZW50byINCmZyb20gImRibyIuInRiUGFnYW1lbnRvc0NvbXByYXMiICJ0YlBhZ2FtZW50b3NDb21wcmFzIg0KbGVmdCBqb2luICJkYm8iLiJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzIiAidGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhcyINCm9uICJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzIi4iSURQYWdhbWVudG9Db21wcmEiID0gInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJRCINCmxlZnQgam9pbiAiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhcyIgInRiRG9jdW1lbnRvc0NvbXByYXMiDQpvbiAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEIiA9ICJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzIi4iSUREb2N1bWVudG9Db21wcmEiDQpsZWZ0IGpvaW4gImRibyIuInRiRm9ybmVjZWRvcmVzIiAidGJGb3JuZWNlZG9yZXMiDQpvbiAidGJGb3JuZWNlZG9yZXMiLiJJRCIgPSAidGJQYWdhbWVudG9zQ29tcHJhcyIuIklERW50aWRhZGUiDQpsZWZ0IGpvaW4gImRibyIuICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiDQpvbiAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iSURGb3JuZWNlZG9yIiA9ICJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURFbnRpZGFkZSIgYW5kICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiLk9yZGVtPTENCmxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMiDQpvbiAidGJDb2RpZ29zUG9zdGFpcyIuIklEIiA9ICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiLiJJRENvZGlnb1Bvc3RhbCINCmxlZnQgam9pbiAiZGJvIi4idGJFc3RhZG9zIiAidGJFc3RhZG9zIg0Kb24gInRiRXN0YWRvcyIuIklEIiA9ICJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iDQpsZWZ0IGpvaW4gImRibyIuInRiVGlwb3NEb2N1bWVudG8iICJ0YlRpcG9zRG9jdW1lbnRvIg0Kb24gInRiVGlwb3NEb2N1bWVudG8iLiJJRCIgPSAidGJQYWdhbWVudG9zQ29tcHJhcyIuIklEVGlwb0RvY3VtZW50byINCmxlZnQgam9pbiAiZGJvIi4idGJUaXBvc0RvY3VtZW50b1NlcmllcyIgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiDQpvbiAidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIklEIiA9ICJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURUaXBvc0RvY3VtZW50b1NlcmllcyINCmxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byINCm9uICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byIuIklEIiA9ICJ0YlRpcG9zRG9jdW1lbnRvIi4iSURTaXN0ZW1hVGlwb3NEb2N1bWVudG8iDQpsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIiAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiDQpvbiAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJJRCIgPSAidGJUaXBvc0RvY3VtZW50byIuIklEU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIg0KbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFOYXR1cmV6YXMiICJ0YlNpc3RlbWFOYXR1cmV6YXMiDQpvbiAidGJTaXN0ZW1hTmF0dXJlemFzIi4iSUQiID0gInRiUGFnYW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRFNpc3RlbWFOYXR1cmV6YXMiDQpsZWZ0IGpvaW4gImRibyIuInRiQ29kaWdvc1Bvc3RhaXMiICJ0YkNvZGlnb3NQb3N0YWlzMSINCm9uICJ0YkNvZGlnb3NQb3N0YWlzMSIuIklEIiA9ICJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiDQpsZWZ0IGpvaW4gImRibyIuInRiQ29kaWdvc1Bvc3RhaXMiICJ0YkNvZGlnb3NQb3N0YWlzMiINCm9uICJ0YkNvZGlnb3NQb3N0YWlzMiIuIklEIiA9ICJ0YlBhZ2FtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSINCmxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMzIg0Kb24gInRiQ29kaWdvc1Bvc3RhaXMzIi4iSUQiID0gInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIg0KbGVmdCBqb2luICJkYm8iLiJ0Yk1vZWRhcyIgInRiTW9lZGFzIg0Kb24gInRiTW9lZGFzIi4iSUQiID0gInRiUGFnYW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIg0KbGVmdCBqb2luICJ0YlBhcmFtZXRyb3NFbXByZXNhIiANCm9uICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURNb2VkYURlZmVpdG8iID0gInRiTW9lZGFzIi4iSUQiIA0KbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFNb2VkYXMiICJ0YlNpc3RlbWFNb2VkYXMiDQpvbiAidGJTaXN0ZW1hTW9lZGFzIi4iSUQiID0gInRiTW9lZGFzIi4iSURTaXN0ZW1hTW9lZGEiDQp3aGVyZSAidGJQYWdhbWVudG9zQ29tcHJhcyIuIklEIj0gQElERG9jdW1lbnRvDQpPcmRlciBieSAidGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhcyIuIk9yZGVtIjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IkN1c3RvbVNxbFF1ZXJ5IiBOYW1lPSJ0YlBhcmFtZXRyb3NMb2phcyI+PFBhcmFtZXRlciBOYW1lPSJJRExvamEiIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDMyLCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKFtQYXJhbWV0ZXJzLklETG9qYV0pPC9QYXJhbWV0ZXI+PFNxbD5zZWxlY3QgInRiUGFyYW1ldHJvc0xvamEiLiJJRCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRE1vZWRhRGVmZWl0byIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJNb3JhZGEiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRm90byIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJGb3RvQ2FtaW5obyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJEZXNpZ25hY2FvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNvZGlnb1Bvc3RhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJMb2NhbGlkYWRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNvbmNlbGhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkRpc3RyaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklEUGFpcyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJUZWxlZm9uZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJGYXgiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRW1haWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iV2ViU2l0ZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJOSUYiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJDYXBpdGFsU29jaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRExvamEiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iSURJZGlvbWFCYXNlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIlNpc3RlbWEiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQXRpdm8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRGF0YUNyaWFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iVXRpbGl6YWRvckNyaWFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRGF0YUFsdGVyYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJVdGlsaXphZG9yQWx0ZXJhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkYzTU1hcmNhZG9yIiwNCiAgICAgICAidGJNb2VkYXMiLiJTaW1ib2xvIiwNCiAgICAgICAidGJNb2VkYXMiLiJUYXhhQ29udmVyc2FvIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW9EZWNpbWFsIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW9JbnRlaXJhIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzSXZhIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiwNCiAgICAgICAidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIi5TaWdsYQ0KICBmcm9tICJkYm8iLiJ0YlBhcmFtZXRyb3NMb2phIiAidGJQYXJhbWV0cm9zTG9qYSINCiAgbGVmdCBqb2luICJkYm8iLiJ0Yk1vZWRhcyIgInRiTW9lZGFzIg0KICAgICAgIG9uICJ0Yk1vZWRhcyIuIklEIiA9ICJ0YlBhcmFtZXRyb3NMb2phIi4iSURNb2VkYURlZmVpdG8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hU2lnbGFzUGFpc2VzIiAidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIg0KICAgICAgIG9uICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiLiJJRCIgPSAidGJQYXJhbWV0cm9zTG9qYSIuIklEUGFpcyINCndoZXJlIGlkbG9qYT1ASURMb2phDQo8L1NxbD48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQ+PFZpZXcgTmFtZT0idGJQYWdhbWVudG9zQ29tcHJhcyI+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvRG9jdW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtZXJvRG9jdW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRGF0YURvY3VtZW50byIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik9ic2VydmFjb2VzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklETW9lZGEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUYXhhQ29udmVyc2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsTW9lZGFEb2N1bWVudG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxNb2VkYVJlZmVyZW5jaWEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iTG9jYWxDYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ2FyZ2EiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJIb3JhQ2FyZ2EiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFDYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbENhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25jZWxob0NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTG9jYWxEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhRGVzY2FyZ2EiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJIb3JhRGVzY2FyZ2EiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25jZWxob0Rlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Rlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTm9tZURlc3RpbmF0YXJpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFEZXN0aW5hdGFyaW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlNlcmllRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY01hbnVhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9MaW5oYXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJQb3N0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVzdGFkbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JFc3RhZG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUhvcmFFc3RhZG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJBc3NpbmF0dXJhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlZlcnNhb0NoYXZlUHJpdmFkYSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9Ik5vbWVGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTW9yYWRhRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25jZWxob0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb250cmlidWludGVGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklETG9qYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkltcHJlc3NvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJWYWxvckltcG9zdG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUGVyY2VudGFnZW1EZXNjb250byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckRlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yUG9ydGVzIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEVGF4YUl2YVBvcnRlcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFJdmFQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iTW90aXZvSXNlbmNhb0l2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRXNwYWNvRmlzY2FsUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUmVnaW1lSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUmVnaW1lSXZhUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkN1c3Rvc0FkaWNpb25haXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iSURGb3JtYUV4cGVkaWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb3NEb2N1bWVudG9TZXJpZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9JbnRlcm5vIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURFbnRpZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0VudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25kaWNhb1BhZ2FtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETG9jYWxPcGVyYWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0FUIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpc0NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURQYWlzRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNYXRyaWN1bGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9Db25jZWxob0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9EaXN0cml0b0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVzcGFjb0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEUmVnaW1lSXZhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQVRJbnRlcm5vIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG9GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRG9jdW1lbnRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1RpcG9Fc3RhZG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvRG9jT3JpZ2VtIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG9DYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxDYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNDYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0b0Rlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvRW50aWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvTW9lZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTWVuc2FnZW1Eb2NBVCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFNpc1RpcG9zRG9jUFUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29TaXNUaXBvc0RvY1BVIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRvY01hbnVhbCIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRG9jUmVwb3NpY2FvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQXNzaW5hdHVyYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkRhdGFDb250cm9sb0ludGVybm8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJEYXRhRG9jdW1lbnRvXzEiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJUb3RhbERvY3VtZW50b3MiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxEZXNjb250b3MiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0idGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhc19JRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9InRiUGFnYW1lbnRvc0NvbXByYXNMaW5oYXNfRGF0YURvY3VtZW50byIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9InRiUGFnYW1lbnRvc0NvbXByYXNMaW5oYXNfRGF0YVZlbmNpbWVudG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzX0RvY3VtZW50byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzX0lERW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJ0YlBhZ2FtZW50b3NDb21wcmFzTGluaGFzX1ZhbG9yUGVuZGVudGUiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0idGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhc19WYWxvclBhZ28iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0idGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhc19UYXhhQ29udmVyc2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9InRiUGFnYW1lbnRvc0NvbXByYXNMaW5oYXNfSURNb2VkYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik9yZGVtIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0idGJQYWdhbWVudG9zQ29tcHJhc0xpbmhhc19QZXJjZW50YWdlbURlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9InRiUGFnYW1lbnRvc0NvbXByYXNMaW5oYXNfVmFsb3JEZXNjb250byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0YkZvcm5lY2Vkb3Jlc19Ob21lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkZvcm5lY2Vkb3Jlc19OQ29udHJpYnVpbnRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzTW9yYWRhc19Nb3JhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVzdGFkb3NfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRXN0YWRvc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19Eb2NOYW9WYWxvcml6YWRvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0Fjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbF9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fVGlwbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDYXJnYV9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFNb2VkYXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlN1YlRvdGFsIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9InRiUGFyYW1lbnRyb3NFbXByZXNhX0Nhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hTmF0dXJlemFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzX1RvdGFsTW9lZGFEb2N1bWVudG8iIFR5cGU9IkRvdWJsZSIgLz48L1ZpZXc+PFZpZXcgTmFtZT0idGJQYXJhbWV0cm9zTG9qYXMiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxobyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUZWxlZm9uZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGYXgiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iV2ViU2l0ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOSUYiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXBpdGFsU29jaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURJZGlvbWFCYXNlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUYXhhQ29udmVyc2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0RlY2ltYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvSW50ZWlyYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzVG90YWlzIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzSXZhIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJTaWdsYSIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgRGJDb21tYW5kVGltZW91dD0iMTgwMCIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''

Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item3/Controls/Item1/@ReportSourceUrl)[.=10000][1] with sql:variable("@IDCabecalho")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item6/Controls/Item2/@ReportSourceUrl)[.=20000][1] with sql:variable("@IDObservacoes")'')

UPDATE tbMapasVistas SET MapaXML = @ptrval , NomeMapa = ''DocumentosPagamentosCompras'' Where Entidade = ''DocumentosPagamentosCompras'' and NomeMapa = ''rptPagamentosCompras''
')

--atualizar vista graduações de serviços
EXEC('
DECLARE @ptrvalP xml;
SET @ptrvalP = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosVendasServicosGraduacoes" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Microsoft.VisualBasic&#xD;&#xA;&#xD;&#xA;Private Sub DocumentosVendasServicosGraduacoes_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    resource.LoadResources(sender)&#xD;&#xA;&#xD;&#xA;    Dim Culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;    Dim Simbolo As String = Me.Parameters(&quot;Simbolo&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    Dim strvalor As String = String.Empty&#xD;&#xA;    Dim dtData As Date&#xD;&#xA;    Dim NumeroCasasDecimais As Integer = 2&#xD;&#xA;&#xD;&#xA;    Me.lblOlho.Text = resource.GetResource(&quot;Olho&quot;, Culture)&#xD;&#xA;    Me.lblDiametro.Text = resource.GetResource(&quot;Diametro&quot;, Culture)&#xD;&#xA;    Me.lblPotenciaEsferica.Text = resource.GetResource(&quot;PotEsf&quot;, Culture)&#xD;&#xA;    Me.lblPotenciaCilindrica.Text = resource.GetResource(&quot;PotCil&quot;, Culture)&#xD;&#xA;    Me.lblPotenciaPrismatica.Text = resource.GetResource(&quot;Prisma&quot;, Culture)&#xD;&#xA;    Me.lblEixo.Text = resource.GetResource(&quot;Eixo&quot;, Culture)&#xD;&#xA;    Me.lblAdicao.Text = resource.GetResource(&quot;Adicao&quot;, Culture)&#xD;&#xA;    Me.lblCodigoArtigo.Text = resource.GetResource(&quot;Artigo&quot;, Culture)&#xD;&#xA;    Me.lblDistancia.Text = resource.GetResource(&quot;Distancia&quot;, Culture)&#xD;&#xA;&#xD;&#xA;    Me.lblDNP.Text = resource.GetResource(&quot;DNP&quot;, Culture)&#xD;&#xA;    Me.lblAltura.Text = resource.GetResource(&quot;AL&quot;, Culture)&#xD;&#xA;    Me.lblBasePrismatica.Text = resource.GetResource(&quot;BP&quot;, Culture)&#xD;&#xA;    Me.lblAnguloPantoscopico.Text = resource.GetResource(&quot;PAN&quot;, Culture)&#xD;&#xA;    Me.lblDistanciaVertex.Text = resource.GetResource(&quot;VTX&quot;, Culture)&#xD;&#xA;&#xD;&#xA;    Me.lblQuantidade.Text = resource.GetResource(&quot;Qtd&quot;, Culture)&#xD;&#xA;    Me.lblPrecoUnitario.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;Preco&quot;, Culture)&#xD;&#xA;    Me.lblValorDesconto.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoLinha&quot;, Culture)&#xD;&#xA;    Me.lblValorEntidade1.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;ValorEntidade1&quot;, Culture)&#xD;&#xA;    Me.lblValorEntidade2.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;ValorEntidade2&quot;, Culture)&#xD;&#xA;    Me.lblTotal.Text = Simbolo &amp; &quot; &quot; &amp; resource.GetResource(&quot;Total&quot;, Culture)&#xD;&#xA;&#xD;&#xA;    ''''cabecalho&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;tbsistematiposservicos_descricao&quot;))&#xD;&#xA;    If strvalor = &quot;Contato&quot; Then&#xD;&#xA;        strvalor = &quot;Lentes de Contato&quot;&#xD;&#xA;    End If&#xD;&#xA;    Me.lblNumeroServico.Text = resource.GetResource(&quot;Servico&quot;, Culture) &amp; &quot; &quot; &amp; strvalor&#xD;&#xA;&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;tbMedicosTecnicos_Nome&quot;))&#xD;&#xA;    Me.lblMedico.Text = resource.GetResource(&quot;Medico&quot;, Culture) &amp; &quot; &quot; &amp; strvalor&#xD;&#xA;&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;DataEntregaLonge&quot;))&#xD;&#xA;    If strvalor &lt;&gt; String.Empty Then&#xD;&#xA;        dtData = GetCurrentColumnValue(&quot;DataEntregaLonge&quot;)&#xD;&#xA;        Me.lblDataEntrega.Text = resource.GetResource(&quot;Entrega&quot;, Culture) &amp; &quot; &quot; &amp; dtData.ToShortDateString &amp; &quot; &quot; &amp; dtData.ToShortTimeString&#xD;&#xA;    End If&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;BoxLonge&quot;))&#xD;&#xA;    If strvalor &lt;&gt; String.Empty Then&#xD;&#xA;        Me.lblBox.Text = &quot;Box &quot; &amp; strvalor&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;IDTipoGraduacao&quot;))&#xD;&#xA;    If strvalor = &quot;3&quot; Then '''' Perto&#xD;&#xA;        strvalor = Convert.ToString(GetCurrentColumnValue(&quot;DataEntregaPerto&quot;))&#xD;&#xA;        If strvalor &lt;&gt; String.Empty Then&#xD;&#xA;            dtData = GetCurrentColumnValue(&quot;DataEntregaPerto&quot;)&#xD;&#xA;            Me.lblDataEntrega.Text = resource.GetResource(&quot;Entrega&quot;, Culture) &amp; &quot; &quot; &amp; dtData.ToShortDateString &amp; &quot; &quot; &amp; dtData.ToShortTimeString&#xD;&#xA;        End If&#xD;&#xA;&#xD;&#xA;        strvalor = Convert.ToString(GetCurrentColumnValue(&quot;BoxPerto&quot;))&#xD;&#xA;        If strvalor &lt;&gt; String.Empty Then&#xD;&#xA;            Me.lblBox.Text = &quot;Box &quot; &amp; strvalor&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;ValorEntidade1&quot;))&#xD;&#xA;    Me.fldValorEntidade1.Text = strvalor&#xD;&#xA;    Me.fldValorEntidade1.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;&#xD;&#xA;    strvalor = Convert.ToString(GetCurrentColumnValue(&quot;ValorEntidade2&quot;))&#xD;&#xA;    Me.fldValorEntidade2.Text = strvalor&#xD;&#xA;    Me.fldValorEntidade2.TextFormatString = &quot;{0:0.&quot; &amp; Strings.StrDup(NumeroCasasDecimais, &quot;0&quot;) &amp; &quot;}&quot;&#xD;&#xA;End Sub&#xD;&#xA;" SnapGridSize="0.1" Margins="10, 0, 0, 0" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="19.1" DataMember="tbServicosGraduacoes" DataSource="#Ref-0">
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
            <Item10 Ref="91" ControlType="XRLabel" Name="fldEixo" TextFormatString="{0:0}" TextAlignment="MiddleCenter" SizeF="46.21,12" LocationFloat="211.87, 0" Font="Arial, 6.75pt, charSet=0" BackColor="Gainsboro" Padding="2,2,0,0,100">
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
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMTQzXGYzbTIwMTc7VXNlciBJRD1GM01PO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTI3OTNGM01POyIgLz48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiU2Vydmljb3NHcmFkdWFjb2VzIj48UGFyYW1ldGVyIE5hbWU9IklEU2VydmljbyIgVHlwZT0iRGV2RXhwcmVzcy5EYXRhQWNjZXNzLkV4cHJlc3Npb24iPihTeXN0ZW0uSW50NjQsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OSkoW1BhcmFtZXRlcnMuSURTZXJ2aWNvXSk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCBkaXN0aW5jdCB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNHcmFkdWFjb2VzLiosICB0YnNlcnZpY29zLiosIHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcy4qLCB0YmFydGlnb3MuKiwgdGJTZXJ2aWNvcy5JRFRpcG9TZXJ2aWNvLCB0YlNpc3RlbWFUaXBvc09saG9zLmNvZGlnbyBhcyBPbGhvLCB0YlNpc3RlbWFUaXBvc0dyYWR1YWNvZXMuRGVzY3JpY2FvIGFzIEdyYWR1YWNhbywNCnRibWVkaWNvc3RlY25pY29zLm5vbWUgYXMgdGJNZWRpY29zVGVjbmljb3NfTm9tZSwgdGJzZXJ2aWNvcy5pZCBhcyB0YlNlcnZpY29zX0lELCB0YnNpc3RlbWF0aXBvc3NlcnZpY29zLmRlc2NyaWNhbyBhcyB0YnNpc3RlbWF0aXBvc3NlcnZpY29zX2Rlc2NyaWNhbw0KZnJvbSB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMgDQpsZWZ0IGpvaW4gdGJzZXJ2aWNvcyBvbiB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMuSURTZXJ2aWNvPXRic2Vydmljb3MuSUQgDQpsZWZ0IGpvaW4gdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzR3JhZHVhY29lcyBvbiB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMuSURTZXJ2aWNvPXRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc0dyYWR1YWNvZXMuSURTZXJ2aWNvIA0KYW5kICAodGJEb2N1bWVudG9zVmVuZGFzTGluaGFzLklEVGlwb0dyYWR1YWNhbz10YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNHcmFkdWFjb2VzLklEVGlwb0dyYWR1YWNhbyBvciAodGJEb2N1bWVudG9zVmVuZGFzTGluaGFzR3JhZHVhY29lcy5JRFRpcG9HcmFkdWFjYW89MyBhbmQgdGJzZXJ2aWNvcy5JRFRpcG9TZXJ2aWNvJmx0OyZndDsyIGFuZCB0YnNlcnZpY29zLklEVGlwb1NlcnZpY28mbHQ7Jmd0OzYpKQ0KYW5kICB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMuaWR0aXBvb2xobz10YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNHcmFkdWFjb2VzLmlkdGlwb29saG8NCmxlZnQgam9pbiB0YlNpc3RlbWFUaXBvc09saG9zIG9uIHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhc0dyYWR1YWNvZXMuSURUaXBvT2xobz10YlNpc3RlbWFUaXBvc09saG9zLklEIA0KbGVmdCBqb2luIHRiU2lzdGVtYVRpcG9zR3JhZHVhY29lcyBvbiB0YkRvY3VtZW50b3NWZW5kYXNMaW5oYXNHcmFkdWFjb2VzLklEVGlwb0dyYWR1YWNhbz10YlNpc3RlbWFUaXBvc0dyYWR1YWNvZXMuSUQgDQpsZWZ0IGpvaW4gdGJhcnRpZ29zIG9uIHRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcy5JREFydGlnbz10YmFydGlnb3MuSUQgDQpsZWZ0IGpvaW4gdGJtZWRpY29zdGVjbmljb3Mgb24gdGJTZXJ2aWNvcy5JRG1lZGljb3RlY25pY289dGJtZWRpY29zdGVjbmljb3MuSUQgDQpsZWZ0IGpvaW4gdGJzaXN0ZW1hdGlwb3NzZXJ2aWNvcyBvbiB0YnNlcnZpY29zLklEdGlwb1NlcnZpY289dGJzaXN0ZW1hdGlwb3NzZXJ2aWNvcy5JRCANCndoZXJlIHRiU2Vydmljb3MuSUQ9QElEU2Vydmljbw0Kb3JkZXIgYnkgdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzR3JhZHVhY29lcy5JRFRpcG9HcmFkdWFjYW8sdGJEb2N1bWVudG9zVmVuZGFzTGluaGFzR3JhZHVhY29lcy5JRFRpcG9PbGhvPC9TcWw+PC9RdWVyeT48UmVzdWx0U2NoZW1hPjxEYXRhU2V0PjxWaWV3IE5hbWU9InRiU2Vydmljb3NHcmFkdWFjb2VzIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9PbGhvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvR3JhZHVhY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUG90ZW5jaWFFc2ZlcmljYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQb3RlbmNpYUNpbGluZHJpY2EiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUG90ZW5jaWFQcmlzbWF0aWNhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkJhc2VQcmlzbWF0aWNhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkFkaWNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJFaXhvIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iUmFpb0N1cnZhdHVyYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXRhbGhlUmFpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJETlAiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iQWx0dXJhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkFjdWlkYWRlVmlzdWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkFuZ3Vsb1BhbnRvc2NvcGljbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0YW5jaWFWZXJ0ZXgiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iSURTZXJ2aWNvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik9yZGVtIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iSURUaXBvU2VydmljbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETWVkaWNvVGVjbmljbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRhdGFSZWNlaXRhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YUVudHJlZ2FMb25nZSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkRhdGFFbnRyZWdhUGVydG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJWZXJQcmlzbWFzIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJWaXNhb0ludGVybWVkaWEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IlNpc3RlbWFfMSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm9fMSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW9fMSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JDcmlhY2FvXzEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhb18xIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhb18xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkYzTU1hcmNhZG9yXzEiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iSURUaXBvU2Vydmljb09saG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb21iaW5hY2FvRGVmZWl0byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQm94TG9uZ2UiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQm94UGVydG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSUREb2N1bWVudG9WZW5kYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEXzIiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERvY3VtZW50b1ZlbmRhXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENhbXBhbmhhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURBcnRpZ28iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURVbmlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtQ2FzYXNEZWNVbmlkYWRlIiBUeXBlPSJJbnQxNiIgLz48RmllbGQgTmFtZT0iUXVhbnRpZGFkZSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlByZWNvVW5pdGFyaW9FZmV0aXZvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlByZWNvVG90YWwiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iT2JzZXJ2YWNvZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb3RlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvTG90ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9Mb3RlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFGYWJyaWNvTG90ZSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkRhdGFWYWxpZGFkZUxvdGUiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJJREFydGlnb051bVNlcmllIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQXJ0aWdvTnVtU2VyaWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURBcm1hemVtIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURBcm1hemVtTG9jYWxpemFjYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1EZXN0aW5vIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURBcm1hemVtTG9jYWxpemFjYW9EZXN0aW5vIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtTGluaGFzRGltZW5zb2VzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRGVzY29udG8xIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRlc2NvbnRvMiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFRheGFJdmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUYXhhSXZhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9JdmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmFsb3JJbXBvc3RvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRXNwYWNvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUmVnaW1lSXZhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUmVnaW1lSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJPcmRlbV8xIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iU2lzdGVtYV8yIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2b18yIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ3JpYWNhb18yIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW9fMiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvXzIiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvXzIiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3JfMiIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJEaWFtZXRybyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJWYWxvckRlc2NvbnRvTGluaGEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxDb21EZXNjb250b0xpbmhhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRGVzY29udG9DYWJlY2FsaG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxDb21EZXNjb250b0NhYmVjYWxobyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvclVuaXRhcmlvRW50aWRhZGUxIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yVW5pdGFyaW9FbnRpZGFkZTIiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JFbnRpZGFkZTEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JFbnRpZGFkZTIiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxGaW5hbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFNlcnZpY29fMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb1NlcnZpY29fMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb09saG9fMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRpcG9EaXN0YW5jaWEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwb09saG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURUaXBvR3JhZHVhY2FvXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJWYWxvckluY2lkZW5jaWEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JJVkEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGF4YUl2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9JdmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Eb2N1bWVudG9PcmlnZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERvY3VtZW50b09yaWdlbSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETGluaGFEb2N1bWVudG9PcmlnZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Nb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRvY3VtZW50b09yaWdlbSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUaXBvVGF4YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BcnRpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvQmFycmFzQXJ0aWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1VuaWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb0l2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29SZWdpYW9JdmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iUGVyY0luY2lkZW5jaWEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUGVyY0RlZHVjYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JJdmFEZWR1dGl2ZWwiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRGF0YURvY09yaWdlbSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IklEQWRpYW50YW1lbnRvT3JpZ2VtIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpb0VmZXRpdm9TZW1JdmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JEZXNjb250b0VmZXRpdm9TZW1JdmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURVbmlkYWRlU3RvY2siIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFVuaWRhZGVTdG9jazIiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJRdWFudGlkYWRlU3RvY2siIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXVhbnRpZGFkZVN0b2NrMiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvTW9lZGFSZWYiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpb0VmZXRpdm9Nb2VkYVJlZiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9ja0FudGVyaW9yIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlF0ZFN0b2NrQXR1YWwiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVVBDTW9lZGFSZWYiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUENNQW50ZXJpb3JNb2VkYVJlZiIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQQ01BdHVhbE1vZWRhUmVmIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlBWTW9lZGFSZWYiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iQWx0ZXJhZGEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IlZhbG9yaXpvdU9yaWdlbSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iTW92U3RvY2tPcmlnZW0iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9Ik51bUNhc2FzRGVjVW5pZGFkZVN0ayIgVHlwZT0iSW50MTYiIC8+PEZpZWxkIE5hbWU9Ik51bUNhc2FzRGVjMlVuaWRhZGVTdGsiIFR5cGU9IkludDE2IiAvPjxGaWVsZCBOYW1lPSJGYXRvckNvbnZVbmlkU3RrIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkZhdG9yQ29udjJVbmlkU3RrIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlF0ZFN0b2NrQW50ZXJpb3JPcmlnZW0iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2tBdHVhbE9yaWdlbSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQQ01BbnRlcmlvck1vZWRhUmVmT3JpZ2VtIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlF0ZEFmZXRhY2FvU3RvY2siIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkQWZldGFjYW9TdG9jazIiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iT3BlcmFjYW9Db252VW5pZFN0ayIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJPcGVyYWNhb0NvbnYyVW5pZFN0ayIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9QcmVjbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1RpcG9QcmVjbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb0l2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlVQQ29tcHJhTW9lZGFSZWYiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVWx0Q3VzdG9zQWRpY2lvbmFpc01vZWRhUmVmIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlVsdERlc2NDb21lcmNpYWlzTW9lZGFSZWYiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpb0VmZXRpdm9Nb2VkYVJlZk9yaWdlbSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWb3Nzb051bWVyb0RvY3VtZW50b09yaWdlbSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9Eb2N1bWVudG9PcmlnZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzT3JpZ2VtIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUXVhbnRpZGFkZVNhdGlzZmVpdGEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXVhbnRpZGFkZURldm9sdmlkYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTYXRpc2ZlaXRvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJJREFydGlnb1BhcmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Eb2N1bWVudG9PcmlnZW1JbmljaWFsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREb2N1bWVudG9PcmlnZW1JbmljaWFsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURMaW5oYURvY3VtZW50b09yaWdlbUluaWNpYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEb2N1bWVudG9PcmlnZW1JbmljaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklETGluaGFEb2N1bWVudG9Db21wcmFJbmljaWFsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURMaW5oYURvY3VtZW50b1N0b2NrSW5pY2lhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklET0ZBcnRpZ28iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9ja1NhdGlzZmVpdGEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2tEZXZvbHZpZGEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2tBY2VydG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2syU2F0aXNmZWl0YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9jazJEZXZvbHZpZGEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2syQWNlcnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvUEEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJRdGRTdG9ja1Jlc2VydmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUXRkU3RvY2tSZXNlcnZhMlVuaSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEYXRhRW50cmVnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IklEXzMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQXRpdm9fMyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iSURGYW1pbGlhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURTdWJGYW1pbGlhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvQXJ0aWdvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb21wb3NpY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvQ29tcG9zaWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklER3J1cG9BcnRpZ28iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRE1hcmNhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQmFycmFzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlFSQ29kZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9BYnJldmlhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iT2JzZXJ2YWNvZXNfMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJHZXJlTG90ZXMiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkdlcmVTdG9jayIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iR2VyZU51bWVyb1NlcmllIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9WYXJpYXZlbCIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iSURUaXBvRGltZW5zYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpbWVuc2FvUHJpbWVpcmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpbWVuc2FvU2VndW5kYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklET3JkZW1Mb3RlQXByZXNlbnRhciIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVW5pZGFkZV8xIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURVbmlkYWRlVmVuZGEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFVuaWRhZGVDb21wcmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJWYXJpYXZlbENvbnRhYmlsaWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lzdGVtYV8zIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ3JpYWNhb18zIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW9fMyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvXzMiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvXzMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3JfMyIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJJREVzdGFjYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJORSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEVEVYIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0VzdGF0aXN0aWNvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkxpbWl0ZU1heCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJMaW1pdGVNaW4iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUmVwb3NpY2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklET3JkZW1Mb3RlTW92RW50cmFkYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklET3JkZW1Mb3RlTW92U2FpZGEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRheGEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEZWR1dGl2ZWxQZXJjZW50YWdlbSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJbmNpZGVuY2lhUGVyY2VudGFnZW0iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVWx0aW1vUHJlY29DdXN0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJNZWRpbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQYWRyYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVWx0aW1vc0N1c3Rvc0FkaWNpb25haXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVWx0aW1vc0Rlc2NvbnRvc0NvbWVyY2lhaXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVWx0aW1vUHJlY29Db21wcmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxRdWFudGlkYWRlVlNVUEMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxRdWFudGlkYWRlVlNQQ00iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxRdWFudGlkYWRlVlNQQ1BhZHJhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9zQ29tcG9uZW50ZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29tcG9zdG9UcmFuc2Zvcm1hY2FvTWV0b2RvQ3VzdG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREltcG9zdG9TZWxvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRmF0b3JGVE9GUGVyY2VudGFnZW0iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRm90byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvQ2FtaW5obyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFVuaWRhZGVTdG9jazJfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb1ByZWNvXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BVCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJSZWZlcmVuY2lhRm9ybmVjZWRvciIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29CYXJyYXNGb3JuZWNlZG9yIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEU2lzdGVtYUNsYXNzaWZpY2FjYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Eb2N1bWVudG9VUEMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERvY3VtZW50b1VQQyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRhdGFDb250cm9sb1VQQyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlJlY2FsY3VsYVVQQyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iVG9yY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSW52ZW50YXJpYWRvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9QZXNvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUGVzb0tnIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZvbHVtZSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9TZXJ2aWNvXzIiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJPbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkdyYWR1YWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1lZGljb3NUZWNuaWNvc19Ob21lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2Vydmljb3NfSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJ0YnNpc3RlbWF0aXBvc3NlcnZpY29zX2Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgRGJDb21tYW5kVGltZW91dD0iMTgwMCIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''
UPDATE tbMapasVistas SET MapaXML = @ptrvalP where NomeMapa = ''DocumentosVendasServicosGraduacoes'' and sistema=1 and subreport = 1
')

-- vistas cabecalho contagem stock
EXEC('
DECLARE @intOrdem as int;
DECLARE @ptrval xml;  
DECLARE @intModulo as bigint;
DECLARE @intSistemaTipoDoc as bigint;
DECLARE @intSistemaTipoDocFiscal as bigint;
SELECT @intOrdem = Max(isnull(Ordem,0)) + 1 FROM tbMapasVistas
SELECT @intModulo = IDModulo, @intSistemaTipoDoc = IDSistemaTipoDoc, @intSistemaTipoDocFiscal = IDSistemaTipoDocFiscal  FROM tbMapasVistas WHERE Entidade = ''DocumentosStockContagem'' and NomeMapa=''rptContagemStock''
SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="ContagemStockCabecalho" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Microsoft.VisualBasic&#xD;&#xA;Imports DevExpress.DataAccess.Native.Sql&#xD;&#xA;Imports System.ComponentModel&#xD;&#xA;Imports System.Linq&#xD;&#xA;&#xD;&#xA;Private Sub fldDesignacaoComercial_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Try&#xD;&#xA;        Dim rs As ResultSet = TryCast(TryCast(Me.DataSource, IListSource).GetList(), ResultSet)&#xD;&#xA;        Dim rTable As ResultTable = rs.Tables.FirstOrDefault(Function(x) x.TableName.Equals(&quot;tbParametrosLoja&quot;))&#xD;&#xA;&#xD;&#xA;        Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;        Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;        Dim titulo As String = Me.Parameters(&quot;Titulo&quot;).Value.ToString&#xD;&#xA;        Dim strDesignacaoComercial As String = Me.Parameters(&quot;DesignacaoComercial&quot;).Value.ToString&#xD;&#xA;        Dim strValor As String&#xD;&#xA;        Dim coluna As ResultColumn&#xD;&#xA;&#xD;&#xA;        Me.lblEmitido.Text = resource.GetResource(&quot;EmitidoEm&quot;, culture)&#xD;&#xA;&#xD;&#xA;        Me.fldEmitido.Text = Now.ToShortDateString &amp; &quot; &quot; &amp; Now.ToShortTimeString&#xD;&#xA;        Me.lblTitulo.Text = titulo&#xD;&#xA;&#xD;&#xA;        If rTable IsNot Nothing Then&#xD;&#xA;            If rTable.Count &gt; 0 Then&#xD;&#xA;                If Me.Parameters(&quot;DesignacaoComercial&quot;).Value.ToString = &quot;&quot; Then&#xD;&#xA;                    coluna = rTable.Columns.Find(Function(col) col.Name.Equals(&quot;DesignacaoComercial&quot;))&#xD;&#xA;                    strValor = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rTable, IList)(0), ResultRow)))&#xD;&#xA;                Else&#xD;&#xA;                    strValor = Me.Parameters(&quot;DesignacaoComercial&quot;).Value.ToString&#xD;&#xA;                End If&#xD;&#xA;                fldDesignacaoComercial.Text = strValor&#xD;&#xA;            End If&#xD;&#xA;        End If&#xD;&#xA;    Catch ex As Exception&#xD;&#xA;        Throw ex&#xD;&#xA;    End Try&#xD;&#xA;End Sub&#xD;&#xA;" SnapGridSize="0.1" Margins="0, 101, 0, 0" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="19.1" DataMember="tbParametrosLoja" DataSource="#Ref-0">
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
            <Item1 Ref="13" Expression="[Parameters.Utilizador]" PropertyName="Text" EventName="BeforePrint" />
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
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMTQzXGYzbTIwMTc7VXNlciBJRD1GM01PO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTI3OTNGM01POyIgLz48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiUGFyYW1ldHJvc0xvamEiPjxQYXJhbWV0ZXIgTmFtZT0iSURMb2phIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5JbnQ2NCwgbXNjb3JsaWIsIFZlcnNpb249NC4wLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5KShbUGFyYW1ldGVycy5JRExvamFdKTwvUGFyYW1ldGVyPjxTcWw+DQpzZWxlY3QgInRiUGFyYW1ldHJvc0xvamEiLiJJRCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRE1vZWRhRGVmZWl0byIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJNb3JhZGEiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRm90byIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJGb3RvQ2FtaW5obyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJEZXNpZ25hY2FvQ29tZXJjaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNvZGlnb1Bvc3RhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJMb2NhbGlkYWRlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNvbmNlbGhvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkRpc3RyaXRvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIklEUGFpcyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJUZWxlZm9uZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJGYXgiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRW1haWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iV2ViU2l0ZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJOSUYiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJDYXBpdGFsU29jaWFsIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJJRExvamEiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iSURJZGlvbWFCYXNlIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIlNpc3RlbWEiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iQXRpdm8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRGF0YUNyaWFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iVXRpbGl6YWRvckNyaWFjYW8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NMb2phIi4iRGF0YUFsdGVyYWNhbyIsDQogICAgICAgInRiUGFyYW1ldHJvc0xvamEiLiJVdGlsaXphZG9yQWx0ZXJhY2FvIiwNCiAgICAgICAidGJQYXJhbWV0cm9zTG9qYSIuIkYzTU1hcmNhZG9yIiwNCiAgICAgICAidGJNb2VkYXMiLiJTaW1ib2xvIiwNCiAgICAgICAidGJNb2VkYXMiLiJUYXhhQ29udmVyc2FvIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW9EZWNpbWFsIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW9JbnRlaXJhIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzSXZhIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiwNCiAgICAgICAidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIi5TaWdsYQ0KICBmcm9tICJkYm8iLiJ0YlBhcmFtZXRyb3NMb2phIiAidGJQYXJhbWV0cm9zTG9qYSINCiAgbGVmdCBqb2luICJkYm8iLiJ0Yk1vZWRhcyIgInRiTW9lZGFzIg0KICAgICAgIG9uICJ0Yk1vZWRhcyIuIklEIiA9ICJ0YlBhcmFtZXRyb3NMb2phIi4iSURNb2VkYURlZmVpdG8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hU2lnbGFzUGFpc2VzIiAidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIg0KICAgICAgIG9uICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiLiJJRCIgPSAidGJQYXJhbWV0cm9zTG9qYSIuIklEUGFpcyINCndoZXJlIGlkbG9qYT1ASURMb2phPC9TcWw+PC9RdWVyeT48UmVzdWx0U2NoZW1hPjxEYXRhU2V0PjxWaWV3IE5hbWU9InRiUGFyYW1ldHJvc0xvamEiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxobyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUZWxlZm9uZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGYXgiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iV2ViU2l0ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOSUYiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXBpdGFsU29jaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURJZGlvbWFCYXNlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUYXhhQ29udmVyc2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0RlY2ltYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvSW50ZWlyYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzVG90YWlzIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzSXZhIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJTaWdsYSIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgRGJDb21tYW5kVGltZW91dD0iMTgwMCIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
--cabeçalho contagem
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito],[SubReport]) VALUES (@intOrdem, N''DocumentosStockContagem'', N''ContagemStockCabecalho'', N''ContagemStockCabecalho'', N'''', 0, @ptrval, NULL, N'''', 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''', @intModulo, @intSistemaTipoDoc, @intSistemaTipoDocFiscal, 0,1)
')

--vistas contagem stock - principal
EXEC('
DECLARE @ptrval xml;  
DECLARE @IDCabecalho as bigint;--10000

SELECT @IDCabecalho = ID  FROM tbMapasVistas WHERE Entidade = ''DocumentosStockContagem'' and NomeMapa=''ContagemStockCabecalho''

SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosStockContagem" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Microsoft.VisualBasic&#xD;&#xA;Imports DevExpress.DataAccess.Native.Sql&#xD;&#xA;Imports System.ComponentModel&#xD;&#xA;Imports System.Linq&#xD;&#xA;&#xD;&#xA;Private dblTotal As Double = 0&#xD;&#xA;Private dblTotalPagina As Double = 0&#xD;&#xA;&#xD;&#xA;Private Sub rptContagemStock_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;&#xD;&#xA;    Dim SimboloMoeda As String = String.Empty&#xD;&#xA;    Dim strValor As String = String.Empty&#xD;&#xA;    Dim strTipo As String = String.Empty&#xD;&#xA;    Dim strSerie As String = String.Empty&#xD;&#xA;    Dim strNumero As String = String.Empty&#xD;&#xA;    Dim strData As String = String.Empty&#xD;&#xA;    Dim NumeroCasasDecimais As Int16 = 0&#xD;&#xA;&#xD;&#xA;    Dim resource As New ReportTranslation&#xD;&#xA;    Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;&#xD;&#xA;    Dim rs As ResultSet = TryCast(TryCast(Me.DataSource, IListSource).GetList(), ResultSet)&#xD;&#xA;    Dim rsDV As ResultTable = rs.Tables.FirstOrDefault(Function(x) x.TableName.Equals(&quot;tbDetail&quot;))&#xD;&#xA;&#xD;&#xA;    Me.Margins.Bottom = &quot;25&quot;&#xD;&#xA;    Me.Margins.Left = &quot;55&quot;&#xD;&#xA;    Me.Margins.Right = &quot;25&quot;&#xD;&#xA;    Me.Margins.Top = &quot;25&quot;&#xD;&#xA;&#xD;&#xA;    Me.Parameters(&quot;Titulo&quot;).Value = resource.GetResource(&quot;Contagem de Stock&quot;, culture)&#xD;&#xA;&#xD;&#xA;    ''''leitura de dados do cabeçalho&#xD;&#xA;    If rsDV IsNot Nothing Then&#xD;&#xA;        If rsDV.Count &gt; 0 Then&#xD;&#xA;            ''''enviar os dados da moeda por parametros&#xD;&#xA;            SimboloMoeda = &quot;€&quot;&#xD;&#xA;            NumeroCasasDecimais = 2&#xD;&#xA;&#xD;&#xA;            ''''cabeçalhos das linhas&#xD;&#xA;            Me.lblCodigo.Text = resource.GetResource(&quot;Codigo&quot;, culture)&#xD;&#xA;            Me.lblDescricao.Text = resource.GetResource(&quot;Descricao&quot;, culture)&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;" SnapGridSize="0.1" Margins="55, 25, 25, 25" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="19.1" DataMember="tbDetail" DataSource="#Ref-0">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="1" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item3 Ref="7" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item4 Ref="8" Visible="false" Description="Via" Name="Via" />
    <Item5 Ref="9" Visible="false" Description="Formas" ValueInfo="select distinct tbRecibos.ID, tbRecibosFormasPagamento.IDFormaPagamento, tbFormasPagamento.Descricao, tbRecibosFormasPagamento.Valor,  tbRecibosFormasPagamento.ValorEntregue,  tbRecibosFormasPagamento.Troco from tbRecibos inner join tbRecibosFormasPagamento on tbRecibosFormasPagamento.IDRecibo= tbRecibos.ID inner join tbFormasPagamento on tbRecibosFormasPagamento.IDFormaPagamento=tbFormasPagamento.ID where tbRecibos.ID=" Name="Formas" />
    <Item6 Ref="11" Visible="false" Description="NumeroCasasDecimais" ValueInfo="2" Name="NumeroCasasDecimais" Type="#Ref-10" />
    <Item7 Ref="12" Visible="false" Description="Observacoes" ValueInfo="select ID, Observacoes from tbRecibos where ID=" Name="Observacoes" />
    <Item8 Ref="13" Visible="false" Description="Assinatura" ValueInfo="select ID, '''''''' as Assinatura from tbRecibos where ID=" Name="Assinatura" />
    <Item9 Ref="14" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item10 Ref="15" Visible="false" Description="Parameter1" Name="Titulo" />
    <Item11 Ref="16" Visible="false" Description="Parameter1" Name="Utilizador" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="17" Name="cfTotalDiferenca" Expression="[].Sum([QuantidadeDiferenca])" DataMember="tbDetail" />
    <Item2 Ref="18" Name="cfTotalEmStock" Expression="[].Sum([QuantidadeEmStock])" DataMember="tbDetail" />
    <Item3 Ref="19" Name="cfTotalQtd" Expression="[].Sum([QuantidadeContada])" DataMember="tbDetail" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="20" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="21" ControlType="ReportHeaderBand" Name="ReportHeader" HeightF="0" />
    <Item3 Ref="22" ControlType="PageHeaderBand" Name="PageHeader" HeightF="15">
      <SubBands>
        <Item1 Ref="23" ControlType="SubBand" Name="SubBand3" HeightF="23.87498">
          <Controls>
            <Item1 Ref="24" ControlType="XRLabel" Name="XrLabel11" TextAlignment="TopLeft" SizeF="87.12186,16.875" LocationFloat="659.8784, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="25" Expression="[CodigoArmazemLocalizacao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="26" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="27" ControlType="XRLabel" Name="XrLabel9" Multiline="true" Text="Localização&#xD;&#xA;" TextAlignment="TopRight" SizeF="87.12195,16.875" LocationFloat="570.7648, 0" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="28" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="29" ControlType="XRLabel" Name="XrLabel3" TextAlignment="TopLeft" SizeF="88.40179,16.875" LocationFloat="481.363, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="30" Expression="[CodigoArmazem]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="31" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="32" ControlType="XRLabel" Name="XrLabel1" Text="Armazém" TextAlignment="TopRight" SizeF="72.01486,16.875" LocationFloat="409.3481, 0" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="33" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="34" ControlType="XRLabel" Name="XrLabel6" Text="Número" TextAlignment="TopLeft" SizeF="79.66867,16.875" LocationFloat="0.0003178914, 0" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="35" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="36" ControlType="XRLabel" Name="fldDataDocumento" TextFormatString="{0:dd-MM-yyyy}" TextAlignment="TopLeft" SizeF="100,16.875" LocationFloat="289.7223, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="37" Expression="[Datadocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="38" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="39" ControlType="XRLabel" Name="XrLabel4" Text="XrLabel4" TextAlignment="TopLeft" SizeF="100,16.875" LocationFloat="80.00002, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="40" Expression="[Documento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="41" UseFont="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="42" ControlType="XRLabel" Name="lblData" Text="Data" TextAlignment="TopLeft" SizeF="79.66867,16.875" LocationFloat="210.0536, 0" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="43" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
          </Controls>
        </Item1>
        <Item2 Ref="44" ControlType="SubBand" Name="SubBand4" HeightF="29.16667">
          <Controls>
            <Item1 Ref="45" ControlType="XRLabel" Name="XrLabel7" Text="Lote" TextAlignment="MiddleRight" SizeF="55.99109,22.99998" LocationFloat="496.4702, 0" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="46" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="47" ControlType="XRLabel" Name="lblQuantidadeContada" Text="Contada" TextAlignment="MiddleRight" SizeF="70,22.99998" LocationFloat="615, 0" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="48" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="49" ControlType="XRLabel" Name="lblQuantidadeEmStock" Text="Stock" TextAlignment="MiddleRight" SizeF="60,22.99998" LocationFloat="554, 0" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="50" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="51" ControlType="XRLine" Name="XrLine1" SizeF="746,2.124977" LocationFloat="0.0001271566, 22.99999" />
            <Item5 Ref="52" ControlType="XRLabel" Name="lblCodigo" Text="Codigo" TextAlignment="MiddleLeft" SizeF="95.3,22.99998" LocationFloat="0.0003178914, 0" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Doc">
              <StylePriority Ref="53" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="54" ControlType="XRLabel" Name="lblQuantidadeDiferenca" Text="Diferença" TextAlignment="MiddleRight" SizeF="60,22.99998" LocationFloat="685.0002, 0" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="55" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="56" ControlType="XRLabel" Name="lblDescricao" Text="Artigo" TextAlignment="MiddleLeft" SizeF="396.98,22.99998" LocationFloat="97.91, 0" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Doc">
              <StylePriority Ref="57" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
          </Controls>
        </Item2>
      </SubBands>
      <Controls>
        <Item1 Ref="58" ControlType="XRSubreport" Name="XrSubreport1" ReportSourceUrl="10000" SizeF="746,15" LocationFloat="0.0003163631, 0">
          <ParameterBindings>
            <Item1 Ref="60" ParameterName="IDLoja" Parameter="#Ref-5" />
            <Item2 Ref="61" ParameterName="Culture" Parameter="#Ref-7" />
            <Item3 Ref="62" ParameterName="BDEmpresa" Parameter="#Ref-14" />
            <Item4 Ref="63" ParameterName="DesignacaoComercial" />
            <Item5 Ref="64" ParameterName="Titulo" Parameter="#Ref-15" />
            <Item6 Ref="65" ParameterName="Utilizador" Parameter="#Ref-16" />
          </ParameterBindings>
        </Item1>
      </Controls>
    </Item3>
    <Item4 Ref="66" ControlType="DetailBand" Name="Detail" KeepTogetherWithDetailReports="true" HeightF="18" KeepTogether="true" TextAlignment="TopLeft" Padding="0,0,0,0,100">
      <Controls>
        <Item1 Ref="67" ControlType="XRLabel" Name="XrLabel5" Text="XrLabel5" TextAlignment="TopRight" SizeF="60.00024,15.99995" LocationFloat="684.9999, 0" Font="Arial, 8.25pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="68" Expression="[QuantidadeDiferenca]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="69" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="70" ControlType="XRLabel" Name="fldQuantidadeContada" Text="fldQuantidadeContada" TextAlignment="TopRight" SizeF="70,15.99995" LocationFloat="615, 2.000054" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="71" Expression="[QuantidadeContada]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="72" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="73" ControlType="XRLabel" Name="XrLabel2" Text="XrLabel2" TextAlignment="TopRight" SizeF="60,15.99995" LocationFloat="554, 2.000014" Font="Arial, 8.25pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="74" Expression="[QuantidadeEmStock]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="75" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="76" ControlType="XRLabel" Name="XrLabel10" Text="XrLabel10" TextAlignment="TopRight" SizeF="55.99112,16" LocationFloat="496.4702, 2.000014" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="77" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="78" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="79" ControlType="XRLabel" Name="fldCodigo" Text="fldCodigo" SizeF="95.31,16.00001" LocationFloat="0.0002861023, 1.999998" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="80" Expression="[CodigoArtigo]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="81" UseFont="false" />
        </Item5>
        <Item6 Ref="82" ControlType="XRLabel" Name="fldDescricao" Text="fldDescricao" SizeF="398.03,16" LocationFloat="97.91, 2.000014" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="83" Expression="[DescricaoArtigo]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="84" UseFont="false" />
        </Item6>
      </Controls>
    </Item4>
    <Item5 Ref="85" ControlType="GroupFooterBand" Name="GroupFooter1" HeightF="33.00001">
      <Controls>
        <Item1 Ref="86" ControlType="XRLabel" Name="fldTotalQuantidadeEmStock" Text="fldTotalQuantidadeEmStock" TextAlignment="TopRight" SizeF="60,18" LocationFloat="554, 5.000013" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="87" Expression="[cfTotalEmStock]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="88" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="89" ControlType="XRLabel" Name="fldTotalQuantidadeContada" TextAlignment="TopRight" SizeF="70,18" LocationFloat="615, 5.000019" Font="Arial, 9pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="90" Expression="[cfTotalQtd]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="91" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="92" ControlType="XRLabel" Name="fldTotalQuantidadeDiferenca" TextAlignment="TopRight" SizeF="59.00031,18" LocationFloat="685.9999, 5.000023" Font="Arial, 9pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="93" Expression="[cfTotalDiferenca]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="94" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="95" ControlType="XRLine" Name="XrLine2" SizeF="242.5298,4.000029" LocationFloat="504.4702, 0" BorderWidth="0">
          <StylePriority Ref="96" UseBorderWidth="false" />
        </Item4>
        <Item5 Ref="97" ControlType="XRLabel" Name="lblTotalFinal" Text="Totais" TextAlignment="MiddleRight" SizeF="40.22729,17.72754" LocationFloat="504.4702, 5.000048" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <StylePriority Ref="98" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
      </Controls>
    </Item5>
    <Item6 Ref="99" ControlType="ReportFooterBand" Name="ReportFooter" HeightF="23" />
    <Item7 Ref="100" ControlType="PageFooterBand" Name="PageFooter" HeightF="33.00001">
      <SubBands>
        <Item1 Ref="101" ControlType="SubBand" Name="SubBand1" HeightF="17.00005">
          <Controls>
            <Item1 Ref="102" ControlType="XRLabel" Name="XrLabel8" Text="Processado por computador" TextAlignment="MiddleLeft" SizeF="169.5834,12.99997" LocationFloat="0.0003178914, 4.000028" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="103" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="104" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="746.9999,4.000029" LocationFloat="0.0003178914, 0" BorderWidth="1">
              <StylePriority Ref="105" UseBorderWidth="false" />
            </Item2>
            <Item3 Ref="106" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="626.0002, 4.000049" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="107" UseFont="false" UseTextAlignment="false" />
            </Item3>
          </Controls>
        </Item1>
      </SubBands>
    </Item7>
    <Item8 Ref="108" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="109" OnBeforePrint="rptContagemStock_BeforePrint" />
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="10" Content="System.Int32" Type="System.Type" />
    <Item3 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Name="SqlDataSource" Base64="PFNxbERhdGFTb3VyY2UgTmFtZT0iU3FsRGF0YVNvdXJjZSI+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMTQzXGYzbTIwMTc7VXNlciBJRD1GM01PO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTI3OTNGM01POyIgLz48UXVlcnkgVHlwZT0iU2VsZWN0UXVlcnkiIE5hbWU9InRiRGV0YWlsIj48UGFyYW1ldGVyIE5hbWU9IklERG9jdW1lbnRvIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5TdHJpbmcsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OSkoP0lERG9jdW1lbnRvKTwvUGFyYW1ldGVyPjxUYWJsZXM+PFRhYmxlIE5hbWU9InZ3Q29udGFnZW1TdG9jayIgLz48L1RhYmxlcz48Q29sdW1ucz48Q29sdW1uIFRhYmxlPSJ2d0NvbnRhZ2VtU3RvY2siIE5hbWU9IklEIiAvPjxDb2x1bW4gVGFibGU9InZ3Q29udGFnZW1TdG9jayIgTmFtZT0iTnVtZXJvRG9jdW1lbnRvIiAvPjxDb2x1bW4gVGFibGU9InZ3Q29udGFnZW1TdG9jayIgTmFtZT0iRGF0YURvY3VtZW50byIgLz48Q29sdW1uIFRhYmxlPSJ2d0NvbnRhZ2VtU3RvY2siIE5hbWU9IkRvY3VtZW50byIgLz48Q29sdW1uIFRhYmxlPSJ2d0NvbnRhZ2VtU3RvY2siIE5hbWU9IkNvZGlnb0FydGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ2d0NvbnRhZ2VtU3RvY2siIE5hbWU9IkRlc2NyaWNhb0FydGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ2d0NvbnRhZ2VtU3RvY2siIE5hbWU9Ik1lZGlvIiAvPjxDb2x1bW4gVGFibGU9InZ3Q29udGFnZW1TdG9jayIgTmFtZT0iVWx0aW1vUHJlY29Db21wcmEiIC8+PENvbHVtbiBUYWJsZT0idndDb250YWdlbVN0b2NrIiBOYW1lPSJDb2RpZ29UaXBvQXJ0aWdvIiAvPjxDb2x1bW4gVGFibGU9InZ3Q29udGFnZW1TdG9jayIgTmFtZT0iRGVzY3JpY2FvVGlwb0FydGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ2d0NvbnRhZ2VtU3RvY2siIE5hbWU9IkNvZGlnb0Zvcm5lY2Vkb3IiIC8+PENvbHVtbiBUYWJsZT0idndDb250YWdlbVN0b2NrIiBOYW1lPSJEZXNjcmljYW9Gb3JuZWNlZG9yIiAvPjxDb2x1bW4gVGFibGU9InZ3Q29udGFnZW1TdG9jayIgTmFtZT0iQ29kaWdvQXJtYXplbSIgLz48Q29sdW1uIFRhYmxlPSJ2d0NvbnRhZ2VtU3RvY2siIE5hbWU9IkRlc2NyaWNhb0FybWF6ZW0iIC8+PENvbHVtbiBUYWJsZT0idndDb250YWdlbVN0b2NrIiBOYW1lPSJDb2RpZ29Bcm1hemVtTG9jYWxpemFjYW8iIC8+PENvbHVtbiBUYWJsZT0idndDb250YWdlbVN0b2NrIiBOYW1lPSJEZXNjcmljYW9Bcm1hemVtTG9jYWxpemFjYW8iIC8+PENvbHVtbiBUYWJsZT0idndDb250YWdlbVN0b2NrIiBOYW1lPSJDb2RpZ29Mb3RlIiAvPjxDb2x1bW4gVGFibGU9InZ3Q29udGFnZW1TdG9jayIgTmFtZT0iRGVzY3JpY2FvTG90ZSIgLz48Q29sdW1uIFRhYmxlPSJ2d0NvbnRhZ2VtU3RvY2siIE5hbWU9IkNvZGlnb01hcmNhIiAvPjxDb2x1bW4gVGFibGU9InZ3Q29udGFnZW1TdG9jayIgTmFtZT0iRGVzY3JpY2FvTWFyY2EiIC8+PENvbHVtbiBUYWJsZT0idndDb250YWdlbVN0b2NrIiBOYW1lPSJPcmRlbSIgLz48Q29sdW1uIFRhYmxlPSJ2d0NvbnRhZ2VtU3RvY2siIE5hbWU9IlF1YW50aWRhZGVFbVN0b2NrIiAvPjxDb2x1bW4gVGFibGU9InZ3Q29udGFnZW1TdG9jayIgTmFtZT0iUXVhbnRpZGFkZUNvbnRhZGEiIC8+PENvbHVtbiBUYWJsZT0idndDb250YWdlbVN0b2NrIiBOYW1lPSJRdWFudGlkYWRlRGlmZXJlbmNhIiAvPjwvQ29sdW1ucz48RmlsdGVyPlt2d0NvbnRhZ2VtU3RvY2suSURdID0gP0lERG9jdW1lbnRvPC9GaWx0ZXI+PC9RdWVyeT48UmVzdWx0U2NoZW1hPjxEYXRhU2V0IE5hbWU9IlNxbERhdGFTb3VyY2UiPjxWaWV3IE5hbWU9InRiRGV0YWlsIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEYXRhRG9jdW1lbnRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRG9jdW1lbnRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0FydGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9BcnRpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTWVkaW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVWx0aW1vUHJlY29Db21wcmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb0FydGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9UaXBvQXJ0aWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0Zvcm5lY2Vkb3IiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvRm9ybmVjZWRvciIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Bcm1hemVtIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0FybWF6ZW0iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvQXJtYXplbUxvY2FsaXphY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0FybWF6ZW1Mb2NhbGl6YWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Mb3RlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0xvdGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvTWFyY2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvTWFyY2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iT3JkZW0iIFR5cGU9IkludDMyIiAvPjxGaWVsZCBOYW1lPSJRdWFudGlkYWRlRW1TdG9jayIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdWFudGlkYWRlQ29udGFkYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJRdWFudGlkYWRlRGlmZXJlbmNhIiBUeXBlPSJEb3VibGUiIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiBEYkNvbW1hbmRUaW1lb3V0PSIxODAwIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''

Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item3/Controls/Item1/@ReportSourceUrl)[.=10000][1] with sql:variable("@IDCabecalho")'')

UPDATE tbMapasVistas SET MapaXML = @ptrval , NomeMapa = ''DocumentosStockContagem'' Where Entidade = ''DocumentosStockContagem'' and NomeMapa = ''rptContagemStock''
')

--vistas doc. compras codigo cliente
EXEC('
DECLARE @ptrval xml;  
DECLARE @intIDMapaSubCab as bigint;--10000
DECLARE @intIDMapaMI as bigint;--20000
DECLARE @intIDMapaD as bigint;--30000
DECLARE @intIDMapaDNV as bigint;--40000
SELECT @intIDMapaSubCab = ID FROM tbMapasVistas WHERE Entidade = ''PurchaseDocumentsList'' and NomeMapa = ''Cabecalho Empresa Compras''
SELECT @intIDMapaMI = ID FROM tbMapasVistas WHERE Entidade = ''PurchaseDocumentsList'' and NomeMapa = ''Motivos Isencao Compras''
SELECT @intIDMapaD = ID FROM tbMapasVistas WHERE Entidade = ''PurchaseDocumentsList'' and NomeMapa = ''Dimensoes Compras''
SELECT @intIDMapaDNV = ID FROM tbMapasVistas WHERE Entidade = ''PurchaseDocumentsList'' and NomeMapa = ''Dimensoes Compras Nao Valorizado''
SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosCompras" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Constantes&#xD;&#xA;Imports DevExpress.DataAccess.Native.Sql&#xD;&#xA;Imports System.ComponentModel&#xD;&#xA;Imports System.Linq&#xD;&#xA;&#xD;&#xA;&#xD;&#xA;Private dblTransportar as Double = 0&#xD;&#xA;Private dblTransporte as Double = 0&#xD;&#xA;&#xD;&#xA;Private Sub Documentos_Compras_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim SimboloMoeda As String = String.Empty&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Parameters.Item(&quot;AcompanhaBens&quot;).Value = False&#xD;&#xA;    Parameters.Item(&quot;IDLinha&quot;).Value = GetCurrentColumnValue(&quot;tbDocumentosComprasLinhas_ID&quot;)        &#xD;&#xA;    Parameters.Item(&quot;CasasMoedas&quot;).Value = GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisIva&quot;)&#xD;&#xA;        &#xD;&#xA;    SimboloMoeda = GetCurrentColumnValue(&quot;tbMoedas_Simbolo&quot;)&#xD;&#xA;    If SimboloMoeda = &quot;&quot; Then&#xD;&#xA;        Parameters.Item(&quot;SimboloMoedas&quot;).Value = &quot;€&quot;&#xD;&#xA;        SimboloMoeda = &quot;€&quot;&#xD;&#xA;    Else&#xD;&#xA;        Me.Parameters.Item(&quot;SimboloMoedas&quot;).Value = SimboloMoeda&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) then&#xD;&#xA;        lblPreco.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Preco&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTotalFinal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Total&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDesconto1.Text = resource.GetResource(&quot;Desconto1&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDesconto2.Text = resource.GetResource(&quot;Desconto2&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescontosLinha.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoLinha&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescontoGlobal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoGlobal&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTotalIva.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalIva&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    End If&#xD;&#xA;    Select Case GetCurrentColumnValue(&quot;tbSistemaTiposDocumento_Tipo&quot;)&#xD;&#xA;        Case &quot;CmpOrcamento&quot;, &quot;CmpTransporte&quot;, &quot;CmpFinanceiro&quot;&#xD;&#xA;            If GetCurrentColumnValue(&quot;tbSistemaNaturezas_Codigo&quot;) = &quot;P&quot; Then&#xD;&#xA;                lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens1_CodigoDestino&quot;)&#xD;&#xA;                fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens1_CodigoDestino&quot;)&#xD;&#xA;                fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes1_Codigo&quot;)&#xD;&#xA;                fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes1_Codigo&quot;)&#xD;&#xA;            ElseIf GetCurrentColumnValue(&quot;tbSistemaNaturezas_Codigo&quot;) = &quot;R&quot; Then&#xD;&#xA;                lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;                fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;                fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;                fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;            End If&#xD;&#xA;        Case &quot;CmpEncomenda&quot;&#xD;&#xA;            lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;            fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;            fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;            fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;    End Select&#xD;&#xA;    ''''Assinatura&#xD;&#xA;    Dim strAssinatura As String = String.Empty&#xD;&#xA;    Dim strAss As String = String.Empty&#xD;&#xA;    Dim strMsg As String = String.Empty&#xD;&#xA;    If GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt) &gt; 0 Then&#xD;&#xA;        strAss = GetCurrentColumnValue(&quot;MensagemDocAT&quot;).Substring(0, GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt))&#xD;&#xA;        strMsg = GetCurrentColumnValue(&quot;MensagemDocAT&quot;).Substring(GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt) + Constantes.SaftAT.CSeparadorMsgAt.Length)&#xD;&#xA;    Else&#xD;&#xA;        strAss = GetCurrentColumnValue(&quot;MensagemDocAT&quot;)&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;CodigoAT&quot;) &lt;&gt; String.Empty Then&#xD;&#xA;        strMsg += &quot; | ATDocCodeId: &quot; &amp; GetCurrentColumnValue(&quot;CodigoAT&quot;)&#xD;&#xA;    End If&#xD;&#xA;    fldMensagemDocAT.Text = strMsg&#xD;&#xA;    fldMensagemDocAT1.Text = strMsg&#xD;&#xA;    fldAssinatura11.Text = strMsg&#xD;&#xA;    fldAssinatura.Text = strAss&#xD;&#xA;    fldAssinatura1.Text = strAss&#xD;&#xA;    fldassinaturanaoval.Text = strAss&#xD;&#xA;    &#xD;&#xA;    If GetCurrentColumnValue(&quot;tbTiposDocumento_AcompanhaBensCirculacao&quot;) Then&#xD;&#xA;        If Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Original&quot; AndAlso Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Duplicado&quot; AndAlso Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Triplicado&quot; Then&#xD;&#xA;            lblCopia1.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;            lblCopia2.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;            lblCopia3.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    &#xD;&#xA;     ''''Separadores totalizadores&#xD;&#xA;    lblSubTotal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;SubTotal&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    lblTotalIva.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalIva&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    lblTotalMoedaDocumento.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalMoedaDocumento&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    ''''Identificação do documento&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) is dbnull.value then&#xD;&#xA;        lblTipoDocumento.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTipoDocumento1.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    end if&#xD;&#xA;    If GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) is dbnull.value Orelse GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) = String.Empty Orelse GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) = &quot;NaoFiscal&quot; Then&#xD;&#xA;        lblTipoDocumento.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTipoDocumento1.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;CodigoTipoEstado&quot;) = &quot;ANL&quot; Then&#xD;&#xA;        lblAnulado.Text = resource.GetResource(&quot;Anulado&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblAnulado.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;SegundaVia&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;SegundaVia&quot;) = &quot;True&quot; Then&#xD;&#xA;        If lblAnulado.Visible Then&#xD;&#xA;            lblSegundaVia.Visible = False&#xD;&#xA;            lblNumVias.Visible = True&#xD;&#xA;        Else&#xD;&#xA;            lblSegundaVia.Text = resource.GetResource(&quot;SegundaVia&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblSegundaVia.Visible = True&#xD;&#xA;            lblNumVias.Visible = False&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbCodigosPostaisCarga_Codigo&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;tbCodigosPostaisCarga_Codigo&quot;) = String.Empty Then&#xD;&#xA;        fldDataCarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbCodigosPostaisDescarga_Codigo&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;tbCodigosPostaisDescarga_Codigo&quot;) = String.Empty Then&#xD;&#xA;        fldDataDescarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;MoradaCarga&quot;) &lt;&gt; String.Empty Or GetCurrentColumnValue(&quot;MoradaDescarga&quot;) &lt;&gt; String.Empty Then&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_AcompanhaBensCirculacao&quot;) Then&#xD;&#xA;            SubBand6.Visible = True&#xD;&#xA;        Else&#xD;&#xA;            SubBand6.Visible = False&#xD;&#xA;        End If&#xD;&#xA;    Else&#xD;&#xA;        SubBand6.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    &#xD;&#xA;        Dim rs As ResultSet = TryCast(TryCast(sender.DataSource, IListSource).GetList(), ResultSet)&#xD;&#xA;        Dim rsDVQRCode As ResultTable = rs.Tables.FirstOrDefault(Function(x) x.TableName.Equals(&quot;tbDocumentosCompras_QRCode&quot;))&#xD;&#xA;        Dim colunaQRCode As ResultColumn&#xD;&#xA;        If rsDVQRCode.Count &gt; 0 Then&#xD;&#xA;          colunaQRCode = rsDVQRCode.Columns.Find(Function(col) col.Name.Equals(&quot;ATQRCodeTexto&quot;))&#xD;&#xA;          Dim strATCode as String = Convert.ToString(colunaQRCode.GetValue(DirectCast(DirectCast(rsDVQRCode, IList)(0), ResultRow)))&#xD;&#xA;            If strATCode &lt;&gt; String.Empty Then&#xD;&#xA;                  lblAnulado.LocationF = new PointF(316.11, lblAnulado.LocationF.Y) &#xD;&#xA;                  lblNumVias.LocationF = new PointF(447.17, lblNumVias.LocationF.Y)&#xD;&#xA;                  lblSegundaVia.LocationF = new PointF(526.79 , lblSegundaVia.LocationF.Y)&#xD;&#xA;                  lblTipoDocumento.LocationF = new PointF(447.63 , lblTipoDocumento.LocationF.Y)&#xD;&#xA;                  fldTipoDocumento.LocationF = new PointF(447.63 , fldTipoDocumento.LocationF.Y)&#xD;&#xA;                  lblDataDocumento.LocationF = new PointF(523.33 , lblDataDocumento.LocationF.Y)&#xD;&#xA;''''                  fldDataDocumento.LocationF = new PointF(523.33 , fldDataDocumento.LocationF.Y)&#xD;&#xA; ''''                 lblDataVencimento.LocationF = new PointF(531.22 ,lblDataVencimento.LocationF.Y)&#xD;&#xA;                  fldDataVencimento.LocationF = new PointF(531.22 ,fldDataVencimento.LocationF.Y)&#xD;&#xA;            Else&#xD;&#xA;                  lblAnulado.LocationF = new PointF(467.2161, lblAnulado.LocationF.Y) &#xD;&#xA;                  lblNumVias.LocationF = new PointF(586.78, lblNumVias.LocationF.Y)&#xD;&#xA;                  lblSegundaVia.LocationF = new PointF(666.39 , lblSegundaVia.LocationF.Y)&#xD;&#xA;                  lblTipoDocumento.LocationF = new PointF(587.22 , lblTipoDocumento.LocationF.Y)&#xD;&#xA;                  fldTipoDocumento.LocationF = new PointF(587.22 , fldTipoDocumento.LocationF.Y)&#xD;&#xA;                  lblDataDocumento.LocationF = new PointF(662.93 , lblDataDocumento.LocationF.Y)&#xD;&#xA;                  ''''fldDataDocumento.LocationF = new PointF(662.93 , fldDataDocumento.LocationF.Y)&#xD;&#xA;                  ''''lblDataVencimento.LocationF = new PointF(670.83 ,lblDataVencimento.LocationF.Y)&#xD;&#xA;                  fldDataVencimento.LocationF = new PointF(660.99 ,fldDataVencimento.LocationF.Y)   &#xD;&#xA;            End If&#xD;&#xA;        End If&#xD;&#xA;&#xD;&#xA;&#xD;&#xA;    TraducaoDocumento()   &#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA; Private Sub TraducaoDocumento()&#xD;&#xA;        Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;        ''''Doc.Origem&#xD;&#xA;        lblDocOrigem.Text = resource.GetResource(&quot;Origem&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDocOrigem1.Text = resource.GetResource(&quot;Origem&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Descrição&#xD;&#xA;        lblDescricao.Text = resource.GetResource(&quot;Descricao&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescricao1.Text = resource.GetResource(&quot;Descricao&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Lote&#xD;&#xA;        lblLote.Text = resource.GetResource(&quot;Lote&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblLote1.Text = resource.GetResource(&quot;Lote&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Armazens&#xD;&#xA;        ''''Localizações&#xD;&#xA;        ''''Unidades&#xD;&#xA;        lblUni.Text = resource.GetResource(&quot;Unidade&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblUni1.Text = resource.GetResource(&quot;Unidade&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Quantidade&#xD;&#xA;        lblQuantidade.Text = resource.GetResource(&quot;Qtd&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblQuantidade1.Text = resource.GetResource(&quot;Qtd&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblContribuinte.Text = resource.GetResource(&quot;Contribuinte&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblFornecedorCodigo.Text = resource.GetResource(&quot;FornecedorCodigo&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblCodigoMoeda.Text = resource.GetResource(&quot;CodigoMoeda&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDataDocumento.Text = resource.GetResource(&quot;DataDocumento&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblCarga.Text = resource.GetResource(&quot;Carga&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescarga.Text = resource.GetResource(&quot;Descarga&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblExpedicao.Text = resource.GetResource(&quot;Matricula&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTituloTransporte.Text = resource.GetResource(&quot;TituloTransporte&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTituloTransportar.Text = resource.GetResource(&quot;TituloTransportar&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura11_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        fldAssinatura11.Visible = False&#xD;&#xA;        me.lblCopia3.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        fldAssinatura11.Visible = True&#xD;&#xA;        me.lblCopia3.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura1_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        fldAssinatura1.Visible = False&#xD;&#xA;        me.lblCopia3.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        fldAssinatura1.Visible = True&#xD;&#xA;        me.lblCopia3.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;     If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTransportar.Visible = False&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Me.fldAssinatura1.Visible = False&#xD;&#xA;        Me.fldAssinatura11.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTransportar.Visible = False&#xD;&#xA;            Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTransportar.Visible = True&#xD;&#xA;            Me.lblTituloTransportar.Visible = True&#xD;&#xA;        End If&#xD;&#xA;        Me.fldAssinatura1.Visible = True&#xD;&#xA;        Me.fldAssinatura11.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;    Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex)     &#xD;&#xA;    Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;    While (iterator.MoveNext())&#xD;&#xA;        If (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal&quot;))&#xD;&#xA;            dblTransportar += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;        End If&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;            label.Text = dblTransportar.ToString()&#xD;&#xA;        Else&#xD;&#xA;            label.Text = Convert.ToDouble(dblTransportar.ToString()).ToString(&quot;F&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;        End If&#xD;&#xA;    End While&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransportar.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;     If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Me.lblTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransporte.Visible = False&#xD;&#xA;            Me.lblTransporte.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransporte.Visible = True&#xD;&#xA;            Me.lblTransporte.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    If e.PageIndex &gt; 0 then&#xD;&#xA;        Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;        Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex - 1)     &#xD;&#xA;        Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;        While (iterator.MoveNext())&#xD;&#xA;             if (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal&quot;))&#xD;&#xA;                dblTransporte += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;            End If&#xD;&#xA;            If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;                label.Text = dblTransporte.ToString()&#xD;&#xA;            Else&#xD;&#xA;                label.Text = Convert.ToDouble(dblTransporte.ToString()).ToString(&quot;F&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;            End If&#xD;&#xA;        End While&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransporte.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;" DrawWatermark="true" Margins="54, 18, 25, 1" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosCompras_Cab" DataSource="#Ref-0">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="40026" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="6" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item3 Ref="7" Visible="false" Description="Via" Name="Via" />
    <Item4 Ref="8" Visible="false" Description="BDEmpresa" ValueInfo="Teste" Name="BDEmpresa" />
    <Item5 Ref="9" Visible="false" Description="Observacoes" ValueInfo="select ID, Observacoes from tbDocumentosCompras where ID=" Name="Observacoes" />
    <Item6 Ref="11" Visible="false" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-10" />
    <Item7 Ref="12" Visible="false" Description="FraseFiscal" ValueInfo="FraseFiscal" Name="FraseFiscal" />
    <Item8 Ref="13" Description="IDEmpresa" ValueInfo="1" Name="IDEmpresa" Type="#Ref-3" />
    <Item9 Ref="15" Visible="false" Description="AcompanhaBens" ValueInfo="true" Name="AcompanhaBens" Type="#Ref-14" />
    <Item10 Ref="16" Description="IDLinha" ValueInfo="0" Name="IDLinha" Type="#Ref-3" />
    <Item11 Ref="18" Description="CasasDecimais" ValueInfo="0" Name="CasasDecimais" Type="#Ref-17" />
    <Item12 Ref="19" Description="CasasMoedas" ValueInfo="0" Name="CasasMoedas" Type="#Ref-17" />
    <Item13 Ref="20" Description="SimboloMoedas" Name="SimboloMoedas" />
    <Item14 Ref="21" Description="UrlServerPath" ValueInfo="http:\\localhost" AllowNull="true" Name="UrlServerPath" />
    <Item15 Ref="22" Description="Utilizador" ValueInfo="f3m" Name="Utilizador" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="23" Name="SomaQuantidade" FieldType="Float" DisplayName="SomaQuantidade" Expression="[].Sum([Quantidade])" DataMember="tbDocumentosVendas" />
    <Item2 Ref="24" Name="SomaValorIVA" FieldType="Float" Expression="[].Sum([ValorIVA])" DataMember="tbDocumentosVendas" />
    <Item3 Ref="25" Name="SomaValorIncidencia" FieldType="Float" Expression="[].Sum([ValorIncidencia])" DataMember="tbDocumentosVendas" />
    <Item4 Ref="26" Name="SomaTotalFinal" FieldType="Double" Expression="[].Sum([TotalFinal])" DataMember="tbDocumentosVendas" />
    <Item5 Ref="27" Name="MotivoIsencao" DisplayName="MotivoIsencao" Expression="IIF([TaxaIva]=0, '''''''', [CodigoMotivoIsencaoIva])" DataMember="tbDocumentosVendas" />
    <Item6 Ref="28" Name="SubTotal" FieldType="Double" Expression="[TotalMoedaDocumento] - [ValorImposto] " DataMember="tbDocumentosCompras_Cab" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="29" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="30" ControlType="ReportHeaderBand" Name="ReportHeader" HeightF="0" />
    <Item3 Ref="31" ControlType="PageHeaderBand" Name="PageHeader" HeightF="2.09">
      <SubBands>
        <Item1 Ref="32" ControlType="SubBand" Name="SubBand5" HeightF="148.57">
          <Controls>
            <Item1 Ref="33" ControlType="XRPanel" Name="panel1" SizeF="127.07,148.57" LocationFloat="615.91, 0">
              <Controls>
                <Item1 Ref="34" ControlType="XRPictureBox" Name="fldATQRCode" Sizing="StretchImage" ImageAlignment="TopLeft" SizeF="118.11,118.11" LocationFloat="2.8, 17.95">
                  <ExpressionBindings>
                    <Item1 Ref="35" Expression="[tbDocumentosCompras_CabtbDocumentosCompras_QRCode.ATQRCode]" PropertyName="ImageSource" EventName="BeforePrint" />
                  </ExpressionBindings>
                </Item1>
                <Item2 Ref="36" ControlType="XRLabel" Name="fldATCUD" Text="label2" SizeF="118.75,15.95" LocationFloat="2.8, 0" Font="Arial, 8.25pt" Padding="2,2,0,0,100">
                  <ExpressionBindings>
                    <Item1 Ref="37" Expression="[tbDocumentosCompras_CabtbDocumentosCompras_QRCode.ATCUD]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="38" UseFont="false" />
                </Item2>
              </Controls>
            </Item1>
            <Item2 Ref="39" ControlType="XRSubreport" Name="Cabecalho Empresa Compras" ReportSourceUrl="10000" SizeF="535.2748,105.7917" LocationFloat="0, 0">
              <ParameterBindings>
                <Item1 Ref="40" ParameterName="IDEmpresa" DataMember="tbDocumentosCompras.IDLoja" />
                <Item2 Ref="42" ParameterName="Culture" Parameter="#Ref-6" />
                <Item3 Ref="43" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                <Item4 Ref="44" ParameterName="" DataMember="tbParametrosLojas.DesignacaoComercial" />
                <Item5 Ref="45" ParameterName="" DataMember="tbParametrosLojas.Morada" />
                <Item6 Ref="46" ParameterName="" DataMember="tbParametrosLojas.Localidade" />
                <Item7 Ref="47" ParameterName="" DataMember="tbParametrosLojas.CodigoPostal" />
                <Item8 Ref="48" ParameterName="" DataMember="tbParametrosLojas.Sigla" />
                <Item9 Ref="49" ParameterName="" DataMember="tbParametrosLojas.NIF" />
                <Item10 Ref="50" ParameterName="UrlServerPath" Parameter="#Ref-21" />
              </ParameterBindings>
            </Item2>
            <Item3 Ref="51" ControlType="XRLabel" Name="fldDataVencimento" TextFormatString="{0:dd-MM-yyyy}" CanGrow="false" TextAlignment="TopRight" SizeF="83.64227,20" LocationFloat="662.777, 78.02378" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="52" Expression="[DataDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="53" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="54" ControlType="XRLabel" Name="fldTipoDocumento" TextAlignment="TopRight" SizeF="159.7648,20.54824" LocationFloat="586.78, 33.55265" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="55" Expression="[tbTiposDocumento_Codigo] + '''' '''' + [CodigoSerie] + ''''/'''' + [NumeroDocumento] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="56" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="57" ControlType="XRLabel" Name="lblDataDocumento" Text="Data" TextAlignment="TopRight" SizeF="84.06,15" LocationFloat="662.777, 63.10085" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
              <StylePriority Ref="58" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="59" ControlType="XRLabel" Name="lblNumVias" Text="Via" TextAlignment="TopRight" SizeF="160.2199,11.77632" LocationFloat="586.78, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="60" Expression="?Via " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="61" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="62" ControlType="XRLabel" Name="lblTipoDocumento" Text="Fatura" TextAlignment="TopRight" SizeF="159.7648,13.77632" LocationFloat="586.78, 19.77634" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="63" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="64" ControlType="XRLabel" Name="lblAnulado" Angle="20" Text="ANULADO" TextAlignment="MiddleCenter" SizeF="189.8313,105.7917" LocationFloat="427.3537, 0" Font="Arial, 24pt, style=Bold, charSet=0" ForeColor="Red" Padding="2,2,0,0,100" Visible="false">
              <StylePriority Ref="65" UseFont="false" UseForeColor="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="66" ControlType="XRLabel" Name="lblSegundaVia" Text="2º Via" TextAlignment="TopRight" SizeF="80.59814,13.77632" LocationFloat="665.8211, 0" Font="Arial, 9pt, style=Bold, charSet=0" ForeColor="Black" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <StylePriority Ref="67" UseFont="false" UseForeColor="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="68" Expression="not(([tbSistemaTiposDocumento_Tipo] = ''''CmpFinanceiro'''' or &#xA;[tbSistemaTiposDocumento_Tipo] = ''''CmpTransporte'''') And&#xA;([TipoFiscal] = ''''FT'''' Or [TipoFiscal] = ''''FR'''' Or &#xA;[TipoFiscal] = ''''FS'''' Or [TipoFiscal] = ''''NC'''' Or &#xA;[TipoFiscal] = ''''ND'''' Or [TipoFiscal] = ''''NF'''' Or &#xA;[TipoFiscal] = ''''GR'''' Or [TipoFiscal] = ''''GT''''))" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item1>
        <Item2 Ref="69" ControlType="SubBand" Name="SubBand1" HeightF="150.42">
          <Controls>
            <Item1 Ref="70" ControlType="XRPanel" Name="XrPanel1" SizeF="746.837,148.3334" LocationFloat="2.91, 0">
              <Controls>
                <Item1 Ref="71" ControlType="XRLabel" Name="fldCodigoPostal" Text="Código Postal" TextAlignment="TopRight" SizeF="296.2911,22.99999" LocationFloat="381.5468, 86" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="72" Expression="[tbCodigosPostaisCliente_Codigo] + '''' '''' + [tbCodigosPostaisCliente_Descricao] " PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="73" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item1>
                <Item2 Ref="74" ControlType="XRLabel" Name="fldCodigoMoeda" TextAlignment="TopLeft" SizeF="194.7021,13.99999" LocationFloat="103.1326, 49.00001" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="75" Expression="[tbMoedas_Codigo]" PropertyName="Text" EventName="BeforePrint" />
                    <Item2 Ref="76" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="77" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item2>
                <Item3 Ref="78" ControlType="XRLabel" Name="lblCodigoMoeda" Text="Moeda" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010068, 49.00004" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Parentesco">
                  <ExpressionBindings>
                    <Item1 Ref="79" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="80" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item3>
                <Item4 Ref="81" ControlType="XRLabel" Name="fldMorada" TextAlignment="TopRight" SizeF="296.2915,23" LocationFloat="381.5468, 63" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="82" Expression="[MoradaFiscal]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="83" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item4>
                <Item5 Ref="84" ControlType="XRLabel" Name="fldNome" TextAlignment="TopRight" SizeF="296.2916,23" LocationFloat="381.5467, 40" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="85" Expression="[NomeFiscal]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="86" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item5>
                <Item6 Ref="87" ControlType="XRLabel" Name="lblTitulo" Text="Exmo.(a) Sr.(a) " TextAlignment="TopRight" SizeF="296.2916,20" LocationFloat="381.5464, 20" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="88" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="89" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item6>
                <Item7 Ref="90" ControlType="XRLabel" Name="lblContribuinte" Text="Contribuinte nº" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010005, 21.00004" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
                  <StylePriority Ref="91" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item7>
                <Item8 Ref="92" ControlType="XRLabel" Name="lblFornecedorCodigo" Text="Cod. Fornecedor" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010036, 35.00004" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Cliente">
                  <StylePriority Ref="93" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item8>
                <Item9 Ref="94" ControlType="XRLabel" Name="fldFornecedorCodigo" TextAlignment="TopLeft" SizeF="194.7036,14" LocationFloat="103.131, 35.00001" Font="Arial, 8pt" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="95" Expression="[tbFornecedores_Codigo]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="96" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item9>
                <Item10 Ref="97" ControlType="XRLabel" Name="fldContribuinteFiscal" TextAlignment="TopLeft" SizeF="194.715,13.99999" LocationFloat="103.1311, 21" Font="Arial, 8pt" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="98" Expression="[ContribuinteFiscal]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="99" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item10>
              </Controls>
            </Item1>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="100" Expression="not(([tbSistemaTiposDocumento_Tipo] = ''''CmpFinanceiro'''' or &#xA;[tbSistemaTiposDocumento_Tipo] = ''''CmpTransporte'''') And&#xA;([TipoFiscal] = ''''FT'''' Or [TipoFiscal] = ''''FR'''' Or &#xA;[TipoFiscal] = ''''FS'''' Or [TipoFiscal] = ''''NC'''' Or &#xA;[TipoFiscal] = ''''ND'''' Or [TipoFiscal] = ''''NF'''' Or &#xA;[TipoFiscal] = ''''GR'''' Or [TipoFiscal] = ''''GT''''))" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item2>
        <Item3 Ref="101" ControlType="SubBand" Name="SubBand8" HeightF="65">
          <Controls>
            <Item1 Ref="102" ControlType="XRLine" Name="line1" SizeF="745.41,2.252249" LocationFloat="1, 61.07" />
            <Item2 Ref="103" ControlType="XRLabel" Name="label6" Text="Fornecedor" TextAlignment="TopLeft" SizeF="85,15" LocationFloat="260, 25" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
              <StylePriority Ref="104" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="105" ControlType="XRLabel" Name="label10" Multiline="true" Text="label10" SizeF="350,20" LocationFloat="260, 40" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="106" Expression="[CodigoEntidade] + '''' - '''' + [NomeFiscal] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="107" UseFont="false" />
            </Item3>
            <Item4 Ref="108" ControlType="XRLabel" Name="label9" Multiline="true" Text="label9" TextAlignment="MiddleRight" SizeF="100,13" LocationFloat="650, 40" Font="Times New Roman, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="109" Expression="?Utilizador" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="110" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="111" ControlType="XRLabel" Name="label8" Multiline="true" Text="label8" TextAlignment="MiddleRight" SizeF="125,13" LocationFloat="625, 25" Font="Times New Roman, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="112" Expression="LocalDateTimeNow() " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="113" UseFont="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="114" ControlType="XRLabel" Name="label7" Multiline="true" Text="Emitido em" TextAlignment="MiddleRight" SizeF="100,13" LocationFloat="650, 10" Font="Times New Roman, 8pt" Padding="2,2,0,0,100">
              <StylePriority Ref="115" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="116" ControlType="XRLabel" Name="label5" TextFormatString="{0:dd-MM-yyyy}" CanGrow="false" Text="label5" TextAlignment="TopCenter" SizeF="85,20" LocationFloat="170, 40" Font="Arial, 9pt" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="117" Expression="[DataDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="118" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="119" ControlType="XRLabel" Name="label4" Text="Data" TextAlignment="TopCenter" SizeF="85,15" LocationFloat="170, 25" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
              <StylePriority Ref="120" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="121" ControlType="XRLabel" Name="label3" Text="label3" TextAlignment="TopRight" SizeF="160,20" LocationFloat="6, 40" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="122" Expression="[VossoNumeroDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="123" UseFont="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="124" ControlType="XRLabel" Name="lblTipoDocumento1" Text="Fatura" TextAlignment="TopRight" SizeF="160,15" LocationFloat="6, 25" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="125" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="126" ControlType="XRLabel" Name="label1" Multiline="true" Text="label1" SizeF="450,23" LocationFloat="0, 2" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="127" Expression="[tbLojas_Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
            </Item11>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="128" Expression="(([tbSistemaTiposDocumento_Tipo] = ''''CmpFinanceiro'''' or &#xA;[tbSistemaTiposDocumento_Tipo] = ''''CmpTransporte'''') And&#xA;([TipoFiscal] = ''''FT'''' Or [TipoFiscal] = ''''FR'''' Or &#xA;[TipoFiscal] = ''''FS'''' Or [TipoFiscal] = ''''NC'''' Or &#xA;[TipoFiscal] = ''''ND'''' Or [TipoFiscal] = ''''NF'''' Or &#xA;[TipoFiscal] = ''''GR'''' Or [TipoFiscal] = ''''GT''''))" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item3>
        <Item4 Ref="129" ControlType="SubBand" Name="sbValoriza" HeightF="26" Visible="false">
          <Controls>
            <Item1 Ref="130" ControlType="XRLabel" Name="lblArtigo" Text="Artigo" TextAlignment="TopLeft" SizeF="52.09093,13" LocationFloat="0, 9.999974" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="131" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="132" ControlType="XRLabel" Name="lblDesconto1" Text="% D1" TextAlignment="TopRight" SizeF="39.16687,13" LocationFloat="568.7189, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="133" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="134" ControlType="XRLabel" Name="lblDesconto2" Text="% D2" TextAlignment="TopRight" SizeF="39.02051,13" LocationFloat="609.921, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="135" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="136" ControlType="XRLabel" Name="lblLocalizacao" Text="Local " TextAlignment="TopLeft" SizeF="51.64383,13" LocationFloat="395.4805, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Local ">
              <StylePriority Ref="137" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="138" ControlType="XRLine" Name="XrLine1" SizeF="745.41,2.252249" LocationFloat="1, 23.41446" />
            <Item6 Ref="139" ControlType="XRLabel" Name="lblIvaLinha" Text="% Iva" TextAlignment="TopRight" SizeF="42.28259,13" LocationFloat="704.1368, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="140" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="141" ControlType="XRLabel" Name="lblTotalFinal" Text="Total" TextAlignment="TopRight" SizeF="51.19525,13" LocationFloat="649.9416, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="142" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="143" ControlType="XRLabel" Name="lblPreco" Text="Preço" TextAlignment="TopRight" SizeF="49.06677,13" LocationFloat="519.652, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="144" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="145" ControlType="XRLabel" Name="lblQuantidade" Text="Qtd." TextAlignment="TopRight" SizeF="40.20905,13" LocationFloat="452.9174, 9.999978" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="146" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="147" ControlType="XRLabel" Name="lblDescricao" Text="Descrição" TextAlignment="TopLeft" SizeF="178.8246,13" LocationFloat="52.09093, 10" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="148" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="149" ControlType="XRLabel" Name="lblDocOrigem" Text="D.Origem" TextAlignment="TopLeft" SizeF="46.62386,13" LocationFloat="230.9156, 10.41446" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="150" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item11>
            <Item12 Ref="151" ControlType="XRLabel" Name="lblLote" Text="Lote" TextAlignment="TopLeft" SizeF="53.84052,13" LocationFloat="286.9375, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="152" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item12>
            <Item13 Ref="153" ControlType="XRLabel" Name="lblArmazem" Text="Armz." TextAlignment="TopLeft" SizeF="50.43265,13" LocationFloat="341.778, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Armazem">
              <StylePriority Ref="154" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item13>
            <Item14 Ref="155" ControlType="XRLabel" Name="lblUni" Text="Uni." TextAlignment="TopRight" SizeF="26.29852,13" LocationFloat="493.1264, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="156" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item14>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="157" Expression="iif( not [tbTiposDocumento_DocNaoValorizado] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item4>
        <Item5 Ref="158" ControlType="SubBand" Name="sbNaoValoriza" HeightF="31" Visible="false">
          <Controls>
            <Item1 Ref="159" ControlType="XRLabel" Name="lblDocOrigem1" Text="D.Origem" TextAlignment="TopLeft" SizeF="51.04167,13" LocationFloat="344.4388, 10.00454" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="160" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="161" ControlType="XRLabel" Name="lblArtigo1" Text="Artigo" TextAlignment="TopLeft" SizeF="52.09093,13" LocationFloat="0, 10.00455" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="162" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="163" ControlType="XRLabel" Name="lblLocalizacao1" Text="Local " TextAlignment="TopLeft" SizeF="82.2226,13" LocationFloat="566.7189, 9.999935" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Local ">
              <StylePriority Ref="164" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="165" ControlType="XRLine" Name="XrLine3" SizeF="743.06,2.89" LocationFloat="2.001254, 28.04394" />
            <Item5 Ref="166" ControlType="XRLabel" Name="lblUni1" Text="Uni." TextAlignment="TopRight" SizeF="45.84589,13.00453" LocationFloat="703.1369, 9.995429" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="167" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="168" ControlType="XRLabel" Name="lblQuantidade1" Text="Qtd." TextAlignment="TopRight" SizeF="52.19537,13" LocationFloat="650.9415, 9.999943" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="169" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="170" ControlType="XRLabel" Name="lblDescricao1" Text="Descrição" TextAlignment="TopLeft" SizeF="267.3478,13" LocationFloat="77.09093, 10.00455" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="171" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="172" ControlType="XRLabel" Name="lblLote1" Text="Lote" TextAlignment="TopLeft" SizeF="83.68509,13" LocationFloat="395.4805, 9.99543" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="173" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="174" ControlType="XRLabel" Name="lblArmazem1" Text="Armazem" TextAlignment="TopLeft" SizeF="81.96033,13" LocationFloat="482.4602, 9.995436" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Armazem">
              <StylePriority Ref="175" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="176" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item5>
        <Item6 Ref="177" ControlType="SubBand" Name="SubBand9" HeightF="23">
          <Controls>
            <Item1 Ref="178" ControlType="XRLabel" Name="lblTransporte" TextFormatString="{0:0.00}" TextAlignment="MiddleLeft" SizeF="187.58,12" LocationFloat="552.2, 5" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <Scripts Ref="179" OnSummaryGetResult="lblTransporte_SummaryGetResult" OnPrintOnPage="lblTransporte_PrintOnPage" />
              <Summary Ref="180" Running="Page" IgnoreNullValues="true" />
              <StylePriority Ref="181" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="182" ControlType="XRLabel" Name="lblTituloTransporte" Text="Transporte" TextAlignment="MiddleRight" SizeF="78.96,12" LocationFloat="472.2, 5" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <Scripts Ref="183" OnPrintOnPage="lblTituloTransporte_PrintOnPage" />
              <StylePriority Ref="184" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
          </Controls>
        </Item6>
      </SubBands>
    </Item3>
    <Item4 Ref="185" ControlType="DetailBand" Name="Detail" KeepTogetherWithDetailReports="true" SnapLinePadding="0,0,0,0,100" HeightF="0" KeepTogether="true" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="186" ControlType="DetailReportBand" Name="DRValorizado" Level="0" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosCompras" DataSource="#Ref-0" Visible="false">
      <Bands>
        <Item1 Ref="187" ControlType="DetailBand" Name="Detail2" HeightF="13.87496" KeepTogether="true">
          <SubBands>
            <Item1 Ref="188" ControlType="SubBand" Name="SubBandValorizado" HeightF="2.083333">
              <Controls>
                <Item1 Ref="189" ControlType="XRSubreport" Name="Dimensoes Compras" ReportSourceUrl="30000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="0, 0">
                  <ParameterBindings>
                    <Item1 Ref="190" ParameterName="IDDocumento" Parameter="#Ref-4" />
                    <Item2 Ref="191" ParameterName="IDLinha" DataMember="tbDocumentosCompras.tbDocumentosComprasLinhas_ID" />
                    <Item3 Ref="192" ParameterName="CasasDecimais" DataMember="tbDocumentosCompras.NumCasasDecUnidade" />
                    <Item4 Ref="193" ParameterName="CasasMoedas" DataMember="tbDocumentosCompras.tbMoedas_CasasDecimaisTotais" />
                    <Item5 Ref="194" ParameterName="SimboloMoedas" Parameter="#Ref-20" />
                    <Item6 Ref="195" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                    <Item7 Ref="196" ParameterName="CasasDecimaisPrecosUnit" DataMember="tbDocumentosCompras.tbMoedas_CasasDecimaisPrecosUnitarios" />
                  </ParameterBindings>
                </Item1>
              </Controls>
            </Item1>
          </SubBands>
          <Controls>
            <Item1 Ref="197" ControlType="XRLabel" Name="fldRunningSum" TextFormatString="{0:0.00}" CanGrow="false" CanShrink="true" SizeF="2,2" LocationFloat="0, 0" ForeColor="Black" Padding="0,0,0,0,100">
              <Scripts Ref="198" OnSummaryCalculated="fldRunningSum_SummaryCalculated" />
              <Summary Ref="199" Running="Page" IgnoreNullValues="true" />
              <ExpressionBindings>
                <Item1 Ref="200" Expression="sumRunningSum([PrecoTotal])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="201" UseForeColor="false" UsePadding="false" />
            </Item1>
            <Item2 Ref="202" ControlType="XRLabel" Name="XrLabel8" Text="XrLabel8" SizeF="55.0218,11.99999" LocationFloat="231.9156, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="203" Expression="[DocumentoOrigem]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="204" UseFont="false" />
            </Item2>
            <Item3 Ref="205" ControlType="XRLabel" Name="fldDesconto2" Text="fldDesconto2" TextAlignment="TopRight" SizeF="39.11041,12.1827" LocationFloat="609.8311, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="206" Expression="FormatString(''''{0:n'''' + 2 + ''''}'''', [Desconto2])&#xA;" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="207" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="208" ControlType="XRLabel" Name="fldDesconto1" Text="fldDesconto1" TextAlignment="TopRight" SizeF="40.16681,12.1827" LocationFloat="568.7189, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="209" Expression="FormatString(''''{0:n'''' + 2 + ''''}'''', [Desconto1])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="210" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="211" ControlType="XRLabel" Name="XrLabel1" Text="XrLabel1" SizeF="179.8247,12.99998" LocationFloat="52.09093, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="212" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="213" UseFont="false" />
            </Item5>
            <Item6 Ref="214" ControlType="XRLabel" Name="fldLocalizacaoValoriza" TextAlignment="TopLeft" SizeF="51.64383,12.99998" LocationFloat="395.4805, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="215" Expression="Iif( IsNullOrEmpty([tbArmazensLocalizacoes_Codigo]) , [tbArmazensLocalizacoes1_Codigo] , [tbArmazensLocalizacoes_Codigo]) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="216" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="217" ControlType="XRLabel" Name="fldArmazemValoriza" TextAlignment="TopLeft" SizeF="50.43265,12.99998" LocationFloat="341.778, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="218" Expression="Iif (IsNullOrEmpty([tbArmazens_Codigo]), [tbArmazens1_CodigoDestino] , [tbArmazens_Codigo])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="219" UseFont="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="220" ControlType="XRLabel" Name="XrLabel40" Text="XrLabel40" TextAlignment="TopRight" SizeF="26.29852,12.99998" LocationFloat="493.1264, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="221" Expression="[CodigoUnidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="222" UseFont="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="223" ControlType="XRLabel" Name="fldCodigoLote" Text="fldCodigoLote" SizeF="54.84055,12.99998" LocationFloat="286.9375, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="224" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="225" UseFont="false" />
            </Item9>
            <Item10 Ref="226" ControlType="XRLabel" Name="fldTaxaIVA" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="49.53473,12.99998" LocationFloat="699.09, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="227" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisIva] ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisIva]  + ''''}'''', [TaxaIva])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="228" UseFont="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="229" ControlType="XRLabel" Name="fldPreco" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="48.06677,12.99998" LocationFloat="518.652, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="230" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisPrecosUnitarios]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisPrecosUnitarios] + ''''}'''', [PrecoUnitario])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="231" UseFont="false" UseTextAlignment="false" />
            </Item11>
            <Item12 Ref="232" ControlType="XRLabel" Name="fldTotalFinal" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="50.41821,12.99998" LocationFloat="649.7188, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="233" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais] ), 0 , FormatString(''''{0:n'''' +  [tbMoedas_CasasDecimaisTotais]  + ''''}'''', [PrecoTotal])) &#xA;" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="234" UseFont="false" UseTextAlignment="false" />
            </Item12>
            <Item13 Ref="235" ControlType="XRLabel" Name="fldQuantidade" TextAlignment="TopRight" SizeF="46.00211,12.99998" LocationFloat="447.1243, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="236" Expression="[Quantidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="237" UseFont="false" UseTextAlignment="false" />
            </Item13>
            <Item14 Ref="238" ControlType="XRLabel" Name="fldArtigo" Text="XrLabel1" SizeF="51.06964,12.99998" LocationFloat="1.02129, 0" Font="Arial, 6.75pt" ForeColor="Black" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="239" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="240" UseFont="false" UseForeColor="false" />
            </Item14>
          </Controls>
        </Item1>
      </Bands>
      <ExpressionBindings>
        <Item1 Ref="241" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
      </ExpressionBindings>
    </Item5>
    <Item6 Ref="242" ControlType="DetailReportBand" Name="DRNaoValorizado" Level="1" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosCompras" DataSource="#Ref-0" Visible="false">
      <Bands>
        <Item1 Ref="243" ControlType="DetailBand" Name="Detail3" HeightF="17.12497" KeepTogether="true">
          <SubBands>
            <Item1 Ref="244" ControlType="SubBand" Name="SubBandNaoValorizado" HeightF="2.083333">
              <Controls>
                <Item1 Ref="245" ControlType="XRSubreport" Name="Dimensoes Compras Nao Valorizado" ReportSourceUrl="40000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="1.351293, 0">
                  <ParameterBindings>
                    <Item1 Ref="246" ParameterName="IDDocumento" Parameter="#Ref-4" />
                    <Item2 Ref="247" ParameterName="IDLinha" DataMember="tbDocumentosCompras.tbDocumentosComprasLinhas_ID" />
                    <Item3 Ref="248" ParameterName="CasasDecimais" DataMember="tbDocumentosCompras.NumCasasDecUnidade" />
                    <Item4 Ref="249" ParameterName="CasasMoedas" DataMember="tbDocumentosCompras.tbMoedas_CasasDecimaisTotais" />
                    <Item5 Ref="250" ParameterName="SimboloMoedas" Parameter="#Ref-20" />
                    <Item6 Ref="251" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                  </ParameterBindings>
                </Item1>
              </Controls>
            </Item1>
          </SubBands>
          <Controls>
            <Item1 Ref="252" ControlType="XRLabel" Name="XrLabel9" Text="XrLabel8" SizeF="51.04166,12.99994" LocationFloat="355.2106, 2.04168" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="253" Expression="[DocumentoOrigem]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="254" UseFont="false" />
            </Item1>
            <Item2 Ref="255" ControlType="XRLabel" Name="fldCodigoLote1" Text="fldCodigoLote" SizeF="71.91321,12.99998" LocationFloat="406.2523, 2.041681" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="256" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="257" UseFont="false" />
            </Item2>
            <Item3 Ref="258" ControlType="XRLabel" Name="XrLabel2" Text="XrLabel2" SizeF="278.1197,13.04158" LocationFloat="77.09093, 2.000046" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="259" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="260" UseFont="false" />
            </Item3>
            <Item4 Ref="261" ControlType="XRLabel" Name="fldLocalizacao1Valoriza" SizeF="82.2226,14.04165" LocationFloat="566.7189, 1.999977" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="262" Expression="Iif( IsNullOrEmpty([tbArmazensLocalizacoes_Codigo]) , [tbArmazensLocalizacoes1_Codigo] , [tbArmazensLocalizacoes_Codigo]) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="263" UseFont="false" />
            </Item4>
            <Item5 Ref="264" ControlType="XRLabel" Name="fldArtigo1" Text="XrLabel1" SizeF="76.0909,14.04165" LocationFloat="1.000023, 1.999982" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="265" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="266" UseFont="false" />
            </Item5>
            <Item6 Ref="267" ControlType="XRLabel" Name="fldQuantidade2" Text="XrLabel3" TextAlignment="TopRight" SizeF="52.41803,14.04165" LocationFloat="650.7188, 2" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="268" Expression="[Quantidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="269" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="270" ControlType="XRLabel" Name="fldUnidade" Text="XrLabel40" TextAlignment="TopRight" SizeF="45.86334,14.04165" LocationFloat="704.1367, 2" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="271" Expression="[CodigoUnidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="272" UseFont="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="273" ControlType="XRLabel" Name="fldArmazem1Valoriza" SizeF="81.96033,14.04165" LocationFloat="482.4602, 1.999977" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="274" Expression="Iif (IsNullOrEmpty([tbArmazens_Codigo]), [tbArmazens1_CodigoDestino] , [tbArmazens_Codigo])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="275" UseFont="false" />
            </Item8>
          </Controls>
        </Item1>
      </Bands>
      <ExpressionBindings>
        <Item1 Ref="276" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
      </ExpressionBindings>
    </Item6>
    <Item7 Ref="277" ControlType="ReportFooterBand" Name="ReportFooter" PrintAtBottom="true" HeightF="77.63" KeepTogether="true">
      <SubBands>
        <Item1 Ref="278" ControlType="SubBand" Name="SubBand2" HeightF="66.25" KeepTogether="true">
          <Controls>
            <Item1 Ref="279" ControlType="XRLine" Name="XrLine4" SizeF="746.98,2.041214" LocationFloat="0, 0" />
            <Item2 Ref="280" ControlType="XRSubreport" Name="Motivos Isencao Compras" ReportSourceUrl="20000" SizeF="445.76,60.00002" LocationFloat="2.32, 4.16">
              <ParameterBindings>
                <Item1 Ref="281" ParameterName="IDDocumento" Parameter="#Ref-4" />
                <Item2 Ref="282" ParameterName="Culture" Parameter="#Ref-6" />
                <Item3 Ref="283" ParameterName="BDEmpresa" Parameter="#Ref-8" />
              </ParameterBindings>
            </Item2>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="284" Expression="iif([tbTiposDocumento_DocNaoValorizado], false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item1>
        <Item2 Ref="285" ControlType="SubBand" Name="SubBand4" HeightF="27.58" KeepTogether="true">
          <Controls>
            <Item1 Ref="286" ControlType="XRLabel" Name="lblCopia2" TextAlignment="MiddleRight" SizeF="433.068,13" LocationFloat="310.99, 0" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="287" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="288" ControlType="XRLabel" Name="fldMensagemDocAT" TextAlignment="MiddleRight" SizeF="433.068,13" LocationFloat="311, 12.5" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="289" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="290" ControlType="XRLabel" Name="fldassinaturanaoval" TextAlignment="MiddleLeft" SizeF="517.0739,13" LocationFloat="0, 12.5" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="291" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="292" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item2>
        <Item3 Ref="293" ControlType="SubBand" Name="SubBand6" HeightF="53.52" KeepTogether="true">
          <Controls>
            <Item1 Ref="294" ControlType="XRLine" Name="XrLine9" SizeF="738.94,2.08" LocationFloat="0, 0" Padding="0,0,0,0,100">
              <StylePriority Ref="295" UsePadding="false" />
            </Item1>
            <Item2 Ref="296" ControlType="XRLabel" Name="lblCarga" Text="Carga" TextAlignment="TopLeft" SizeF="200,12" LocationFloat="1.34, 3.44" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Carga">
              <StylePriority Ref="297" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="298" ControlType="XRLabel" Name="lblDescarga" Text="Descarga" TextAlignment="TopLeft" SizeF="200,12" LocationFloat="201.96, 3.44" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Descarga">
              <StylePriority Ref="299" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="300" ControlType="XRLabel" Name="lblExpedicao" Text="Matrícula" TextAlignment="TopLeft" SizeF="121.83,12" LocationFloat="403.21, 3.44" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Espedicao">
              <StylePriority Ref="301" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="302" ControlType="XRLabel" Name="XrLabel30" Text="XrLabel12" SizeF="121.83,12" LocationFloat="403.21, 15.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="303" Expression="[Matricula]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="304" UseFont="false" />
            </Item5>
            <Item6 Ref="305" ControlType="XRLabel" Name="XrLabel41" Text="XrLabel11" SizeF="200,12" LocationFloat="201.96, 15.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="306" Expression="[MoradaDescarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="307" UseFont="false" />
            </Item6>
            <Item7 Ref="308" ControlType="XRLabel" Name="XrLabel42" Text="XrLabel5" SizeF="200,12" LocationFloat="1.34, 15.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="309" Expression="[MoradaCarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="310" UseFont="false" />
            </Item7>
            <Item8 Ref="311" ControlType="XRLabel" Name="fldCodigoPostalCarga" Text="fldCodigoPostalCarga" SizeF="200,12" LocationFloat="1.34, 27.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="312" Expression="[tbCodigosPostaisCarga_Codigo] + '''' '''' + [tbCodigosPostaisCarga_Descricao] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="313" UseFont="false" />
            </Item8>
            <Item9 Ref="314" ControlType="XRLabel" Name="fldDataCarga" TextFormatString="{0:dd-MM-yyyy HH:mm}" SizeF="200,12" LocationFloat="1.34, 39.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="315" Expression="[DataCarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="316" UseFont="false" />
            </Item9>
            <Item10 Ref="317" ControlType="XRLabel" Name="fldCodigoPostalDescarga" Text="fldCodigoPostalDescarga" SizeF="200,12" LocationFloat="201.97, 27.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="318" Expression="[tbCodigosPostaisDescarga_Codigo] + '''' '''' + [tbCodigosPostaisDescarga_Descricao] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="319" UseFont="false" />
            </Item10>
            <Item11 Ref="320" ControlType="XRLabel" Name="fldDataDescarga" TextFormatString="{0:dd-MM-yyyy HH:mm}" SizeF="200,12" LocationFloat="201.96, 39.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="321" Expression="[DataDescarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="322" UseFont="false" />
            </Item11>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="323" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item3>
        <Item4 Ref="324" ControlType="SubBand" Name="SubBand7" HeightF="36.96" KeepTogether="true">
          <Controls>
            <Item1 Ref="325" ControlType="XRLine" Name="XrLine8" SizeF="738.94,2.08" LocationFloat="0, 3.17" />
            <Item2 Ref="326" ControlType="XRLabel" Name="lblObservacoes" Text="Observações" TextAlignment="MiddleLeft" SizeF="90.12,12" LocationFloat="0, 5.17" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
              <StylePriority Ref="327" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="328" ControlType="XRLabel" Name="fldObservacoes" Multiline="true" TextAlignment="TopLeft" SizeF="742.9999,18.19" LocationFloat="0, 16.69" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
              <ExpressionBindings>
                <Item1 Ref="329" Expression="[Observacoes] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="330" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
          </Controls>
        </Item4>
      </SubBands>
      <Controls>
        <Item1 Ref="331" ControlType="XRLabel" Name="lblCopia1" TextAlignment="MiddleRight" SizeF="433.068,13" LocationFloat="310.99, 1.75" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="332" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="333" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="334" ControlType="XRLabel" Name="lblTotalMoedaDocumento" TextAlignment="TopRight" SizeF="121.383,17" LocationFloat="617.57, 31.95" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="335" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="336" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="337" ControlType="XRLabel" Name="fldDescontosLinha" TextAlignment="TopRight" SizeF="87.00002,20.9583" LocationFloat="288.18, 48.95" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="338" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisTotais] ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais]  + ''''}'''', [ValorDescontoLinha_Sum])) &#xA;" PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="339" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="340" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="341" ControlType="XRLabel" Name="fldDescontoGlobal" TextAlignment="TopRight" SizeF="87.00002,20.96" LocationFloat="376.18, 48.95" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="342" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais] ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais]  + ''''}'''', [ValorDesconto])) &#xA;" PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="343" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="344" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="345" ControlType="XRLabel" Name="fldTotalIva" TextFormatString="{0:€0.00}" TextAlignment="TopRight" SizeF="85.80151,20.9583" LocationFloat="465.38, 48.95" Font="Arial, 6.75pt" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="346" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisIva]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisIva] + ''''}'''', [ValorImposto])) " PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="347" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="348" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="349" ControlType="XRLabel" Name="fldTotalMoedaDocumento" TextAlignment="TopRight" SizeF="176.209,25.59814" LocationFloat="562.75, 48.95" Font="Arial, 14.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="350" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisTotais]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [TotalMoedaDocumento])) " PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="351" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="352" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="353" ControlType="XRLabel" Name="fldSubTotal" TextFormatString="{0:€0.00}" TextAlignment="TopRight" SizeF="87.25985,20.95646" LocationFloat="199.92, 54.16" Font="Arial, 6.75pt" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="354" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisTotais]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [SubTotal])) " PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="355" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="356" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="357" ControlType="XRLabel" Name="XrLabel4" SizeF="190,46" LocationFloat="555.07, 29.55" BackColor="Gainsboro" Padding="2,2,0,0,100" Borders="None" BorderWidth="1">
          <ExpressionBindings>
            <Item1 Ref="358" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="359" UseBackColor="false" UseBorders="false" UseBorderWidth="false" />
        </Item8>
        <Item9 Ref="360" ControlType="XRLabel" Name="lblDescontosLinha" TextAlignment="TopRight" SizeF="87.25985,16" LocationFloat="287.92, 31.95" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="361" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="362" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item9>
        <Item10 Ref="363" ControlType="XRLabel" Name="lblDescontoGlobal" TextAlignment="TopRight" SizeF="87.25984,16" LocationFloat="375.92, 31.95" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="364" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="365" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item10>
        <Item11 Ref="366" ControlType="XRLabel" Name="lblTotalIva" TextAlignment="TopRight" SizeF="86.80161,15.99816" LocationFloat="464.38, 31.95" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="367" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="368" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item11>
        <Item12 Ref="369" ControlType="XRLabel" Name="lblSubTotal" TextAlignment="TopRight" SizeF="87.75003,16" LocationFloat="199.43, 37.16" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="370" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="371" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="372" ControlType="XRLine" Name="XrLine5" SizeF="747.0004,2" LocationFloat="0, 27.56">
          <ExpressionBindings>
            <Item1 Ref="373" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item13>
        <Item14 Ref="374" ControlType="XRLabel" Name="fldMensagemDocAT1" TextAlignment="MiddleRight" SizeF="433.068,13" LocationFloat="311.99, 14.56" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="375" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="376" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item14>
        <Item15 Ref="377" ControlType="XRLabel" Name="fldAssinatura" TextAlignment="MiddleLeft" SizeF="433.1161,13" LocationFloat="0, 14.56" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="378" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="379" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item15>
      </Controls>
    </Item7>
    <Item8 Ref="380" ControlType="PageFooterBand" Name="PageFooter" HeightF="38.33">
      <SubBands>
        <Item1 Ref="381" ControlType="SubBand" Name="SubBand3" HeightF="19.08">
          <Controls>
            <Item1 Ref="382" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="742.98,4" LocationFloat="0, 0" BorderWidth="3">
              <StylePriority Ref="383" UseBorderWidth="false" />
            </Item1>
            <Item2 Ref="384" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="625.4193, 4.000028" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="385" UseFont="false" UseTextAlignment="false" />
            </Item2>
          </Controls>
        </Item1>
      </SubBands>
      <Controls>
        <Item1 Ref="386" ControlType="XRLabel" Name="lblCopia3" TextAlignment="MiddleRight" SizeF="445.7733,13" LocationFloat="300.64, 11.61" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="387" OnPrintOnPage="fldAssinatura11_PrintOnPage" />
          <StylePriority Ref="388" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="389" ControlType="XRLabel" Name="lblTransportar" TextFormatString="{0:0.00}" TextAlignment="MiddleLeft" SizeF="187.58,12" LocationFloat="552.2, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <Scripts Ref="390" OnSummaryGetResult="lblTransportar_SummaryGetResult" OnPrintOnPage="lblTransportar_PrintOnPage" />
          <Summary Ref="391" Running="Page" IgnoreNullValues="true" />
          <StylePriority Ref="392" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="393" ControlType="XRLabel" Name="lblTituloTransportar" Text="Transportar" TextAlignment="MiddleRight" SizeF="78.96,12" LocationFloat="472.2, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="394" OnPrintOnPage="lblTituloTransportar_PrintOnPage" />
          <StylePriority Ref="395" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="396" ControlType="XRLabel" Name="fldAssinatura11" TextAlignment="MiddleRight" SizeF="445.7733,13" LocationFloat="300.646, 24.7" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="397" OnPrintOnPage="fldAssinatura11_PrintOnPage" />
          <StylePriority Ref="398" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="399" ControlType="XRLabel" Name="fldAssinatura1" TextAlignment="MiddleLeft" SizeF="445.7733,13" LocationFloat="1.351039, 24.7" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="400" OnPrintOnPage="fldAssinatura1_PrintOnPage" />
          <StylePriority Ref="401" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
      </Controls>
    </Item8>
    <Item9 Ref="402" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="1" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="403" OnBeforePrint="Documentos_Compras_BeforePrint" />
  <ExportOptions Ref="404">
    <Html Ref="405" ExportMode="SingleFilePageByPage" />
  </ExportOptions>
  <Watermark Ref="406" ShowBehind="false" Text="CONFIDENTIAL" Font="Arial, 96pt" />
  <ExpressionBindings>
    <Item1 Ref="407" Expression="([tbSistemaTiposDocumento_Tipo] != ''''CmpFinanceiro''''  And &#xA;([TipoFiscal] != ''''FT'''' Or [TipoFiscal] != ''''FR'''' Or &#xA;[TipoFiscal] != ''''FS'''' Or [TipoFiscal] != ''''NC'''' Or &#xA;[TipoFiscal] != ''''ND'''')) Or &#xA;([tbSistemaTiposDocumento_Tipo] != ''''CmpTransporte''''  And &#xA;([TipoFiscal] != ''''NF'''' Or [TipoFiscal] != ''''GR'''' Or &#xA;[TipoFiscal] != ''''GT''''))" PropertyName="Visible" EventName="BeforePrint" />
  </ExpressionBindings>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="10" Content="System.Int32" Type="System.Type" />
    <Item3 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="14" Content="System.Boolean" Type="System.Type" />
    <Item4 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="17" Content="System.Int16" Type="System.Type" />
    <Item5 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Name="SqlDataSource" Base64="PFNxbERhdGFTb3VyY2UgTmFtZT0iU3FsRGF0YVNvdXJjZSI+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMTQzXGYzbTIwMTc7VXNlciBJRD1GM01PO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTI1MDVGM01POyIgLz48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXMiPjxQYXJhbWV0ZXIgTmFtZT0iSUREb2N1bWVudG8iIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKD9JRERvY3VtZW50byk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCBkaXN0aW5jdCAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9Eb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhRG9jdW1lbnRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iT2JzZXJ2YWNvZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGF4YUNvbnZlcnNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRvdGFsTW9lZGFEb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhUmVmZXJlbmNpYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkxvY2FsQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJIb3JhQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFDYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJMb2NhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSG9yYURlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW9yYWRhRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZURlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYURlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9EZXN0aW5hdGFyaW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZXJpZURvY01hbnVhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0RvY01hbnVhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0xpbmhhcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBvc3RvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJVdGlsaXphZG9yRXN0YWRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUhvcmFFc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBc3NpbmF0dXJhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmVyc2FvQ2hhdmVQcml2YWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZUZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYUZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRmlzY2FsIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9GaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb250cmlidWludGVGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvamEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJbXByZXNzbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9ySW1wb3N0byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBlcmNlbnRhZ2VtRGVzY29udG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWYWxvckRlc2NvbnRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRheGFJdmFQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUYXhhSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW90aXZvSXNlbmNhb0l2YSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vdGl2b0lzZW5jYW9Qb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbFBvcnRlcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkVzcGFjb0Zpc2NhbFBvcnRlcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iUmVnaW1lSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ3VzdG9zQWRpY2lvbmFpcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpc3RlbWEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBdGl2byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDcmlhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckNyaWFjYW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQWx0ZXJhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkYzTU1hcmNhZG9yIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURGb3JtYUV4cGVkaWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9JbnRlcm5vIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFbnRpZGFkZSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb0VudGlkYWRlIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25kaWNhb1BhZ2FtZW50byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETG9jYWxPcGVyYWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0FUIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURQYWlzQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFBhaXNEZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1hdHJpY3VsYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbEZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGVzY3JpY2FvRGlzdHJpdG9GaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvQVRJbnRlcm5vIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGlwb0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY3VtZW50byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1RpcG9Fc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Eb2NPcmlnZW0iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9DYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbENhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9EZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29FbnRpZGFkZSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb01vZWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTWVuc2FnZW1Eb2NBVCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEU2lzVGlwb3NEb2NQVSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Npc1RpcG9zRG9jUFUiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NNYW51YWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NSZXBvc2ljYW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQXNzaW5hdHVyYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDb250cm9sb0ludGVybm8iLA0KCSJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURvY3VtZW50byIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29UaXBvRXN0YWRvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNlZ3VuZGFWaWEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRCIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfSUQiLA0KCSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9yZGVtIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklERG9jdW1lbnRvQ29tcHJhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJ0aWdvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIkRlc2NyaWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRFVuaWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iTnVtQ2FzYXNEZWNVbmlkYWRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlF1YW50aWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iUHJlY29Vbml0YXJpbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJQcmVjb1VuaXRhcmlvRWZldGl2byIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJQcmVjb1RvdGFsIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9ic2VydmFjb2VzIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19PYnNlcnZhY29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRExvdGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQ29kaWdvTG90ZSIsDQoJICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQ29kaWdvVW5pZGFkZSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEZXNjcmljYW9Mb3RlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIkRhdGFGYWJyaWNvTG90ZSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEYXRhVmFsaWRhZGVMb3RlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJ0aWdvTnVtU2VyaWUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQXJ0aWdvTnVtU2VyaWUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbUxvY2FsaXphY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbURlc3Rpbm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtTG9jYWxpemFjYW9EZXN0aW5vIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk51bUxpbmhhc0RpbWVuc29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEZXNjb250bzEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGVzY29udG8yIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEVGF4YUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJUYXhhSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk1vdGl2b0lzZW5jYW9JdmEiIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX01vdGl2b0lzZW5jYW9JdmEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURFc3BhY29GaXNjYWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRXNwYWNvRmlzY2FsIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEUmVnaW1lSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlJlZ2ltZUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJTaWdsYVBhaXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iT3JkZW0iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iU2lzdGVtYSIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfU2lzdGVtYSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJBdGl2byIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfQXRpdm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGF0YUNyaWFjYW8iIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0RhdGFDcmlhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlV0aWxpemFkb3JDcmlhY2FvIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19VdGlsaXphZG9yQ3JpYWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEYXRhQWx0ZXJhY2FvIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQWx0ZXJhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlV0aWxpemFkb3JBbHRlcmFjYW8iIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX1V0aWxpemFkb3JBbHRlcmFjYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRjNNTWFyY2Fkb3IiIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0YzTU1hcmNhZG9yIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlZhbG9ySW5jaWRlbmNpYSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJWYWxvcklWQSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEb2N1bWVudG9PcmlnZW0iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGF0YUVudHJlZ2EiLA0KCSAidGJGb3JuZWNlZG9yZXMiLiJOb21lIiBhcyAidGJGb3JuZWNlZG9yZXNfTm9tZSIsDQoJICJ0YkZvcm5lY2Vkb3JlcyIuIkNvZGlnbyIgYXMgInRiRm9ybmVjZWRvcmVzX0NvZGlnbyIsDQoJICJ0YkZvcm5lY2Vkb3JlcyIuIk5Db250cmlidWludGUiIGFzICJ0YkZvcm5lY2Vkb3Jlc19OQ29udHJpYnVpbnRlIiwNCgkgInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIk1vcmFkYSIgYXMgInRiRm9ybmVjZWRvcmVzTW9yYWRhc19Nb3JhZGEiLA0KCSAidGJDb2RpZ29zUG9zdGFpcyIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0NvZGlnbyIsDQoJICJ0YkNvZGlnb3NQb3N0YWlzIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiwNCiAgICAgICAidGJFc3RhZG9zIi4iQ29kaWdvIiBhcyAidGJFc3RhZG9zX0NvZGlnbyIsDQogICAgICAgInRiRXN0YWRvcyIuIkRlc2NyaWNhbyIgYXMgInRiRXN0YWRvc19EZXNjcmljYW8iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iQ29kaWdvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Db2RpZ28iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KCSAidGJUaXBvc0RvY3VtZW50byIuIkRvY05hb1ZhbG9yaXphZG8iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0RvY05hb1ZhbG9yaXphZG8iLA0KCSAidGJUaXBvc0RvY3VtZW50byIuIkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJEZXNjcmljYW9TZXJpZSIsDQogICAgICAgInRiQXJ0aWdvcyIuIkNvZGlnbyIgYXMgInRiQXJ0aWdvc19Db2RpZ28iLA0KICAgICAgICJ0YkFydGlnb3MiLiJEZXNjcmljYW9BYnJldmlhZGEiLA0KICAgICAgICJ0YkFydGlnb3MiLiJEZXNjcmljYW8iIGFzICJ0YkFydGlnb3NfRGVzY3JpY2FvIiwNCiAgICAgICAidGJBcnRpZ29zIi4iR2VyZUxvdGVzIiBhcyAidGJBcnRpZ29zX0dlcmVMb3RlcyIsDQogICAgICAgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiwNCgkgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iVGlwbyIgYXMgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iLA0KCSAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KICAgICAgICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIlRpcG8iLA0KICAgICAgICJ0YkNvZGlnb3NQb3N0YWlzMSIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNfQ29kaWdvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczEiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMyIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMyIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0Rlc2NyaWNhbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMzIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0NvZGlnbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMzIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJNb2VkYXNfQ29kaWdvIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW8iIGFzICJ0Yk1vZWRhc19EZXNjcmljYW8iLA0KICAgICAgICJ0Yk1vZWRhcyIuIlNpbWJvbG8iIGFzICJ0Yk1vZWRhc19TaW1ib2xvIiwNCgkgInRiQXJtYXplbnMiLiJEZXNjcmljYW8iIGFzICJ0YkFybWF6ZW5zX0Rlc2NyaWNhbyIsDQoJICJ0YkFybWF6ZW5zIi4iQ29kaWdvIiBhcyAidGJBcm1hemVuc19Db2RpZ28iLA0KCSAidGJBcm1hemVuc0xvY2FsaXphY29lcyIuIkRlc2NyaWNhbyIgYXMgInRiQXJtYXplbnNMb2NhbGl6YWNvZXNfRGVzY3JpY2FvIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzX0NvZGlnbyIsDQoJICJ0YkFybWF6ZW5zMSIuIkRlc2NyaWNhbyIgYXMgInRiQXJtYXplbnMxX0Rlc2NyaWNhb0Rlc3Rpbm8iLA0KCSAidGJBcm1hemVuczEiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zMV9Db2RpZ29EZXN0aW5vIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iRGVzY3JpY2FvIiBhcyAidGJBcm1hemVuc0xvY2FsaXphY29lczFfRGVzY3JpY2FvIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iQ29kaWdvIiBhcyAidGJBcm1hemVuc0xvY2FsaXphY29lczFfQ29kaWdvIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiBhcyAidGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIsDQoJICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgYXMgInRiTW9lZGFzX0Nhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiLA0KCSAgICJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNJdmEiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzSXZhIiwNCgkgInRiU2lzdGVtYUNvZGlnb3NJVkEiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFDb2RpZ29zSVZBLkNvZGlnbyIsIA0KICAgICAgICJ0YlNpc3RlbWFNb2VkYXMiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFNb2VkYXNfQ29kaWdvIiwNCgkgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhRG9jdW1lbnRvIiAtICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JJbXBvc3RvIiBhcyAiU3ViVG90YWwiLA0KCSAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgYXMgInRiUGFyYW1lbnRyb3NFbXByZXNhX0Nhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIsDQoJICJ0YlNpc3RlbWFOYXR1cmV6YXMiLkNvZGlnbyBhcyAidGJTaXN0ZW1hTmF0dXJlemFzX0NvZGlnbyINCiAgZnJvbSAiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhcyINCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIg0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIg0KICAgICAgIG9uICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSUREb2N1bWVudG9Db21wcmEiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YklWQSIgInRiSVZBIiBvbiAidGJJVkEiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEVGF4YUl2YSINCiAgbGVmdCBqb2luIHRiU2lzdGVtYUNvZGlnb3NJVkEgb24gdGJJVkEuSURDb2RpZ29JVkEgPSB0YlNpc3RlbWFDb2RpZ29zSVZBLklEDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hVGlwb3NJVkEiICJ0YlNpc3RlbWFUaXBvc0lWQSIgb24gInRiU2lzdGVtYVRpcG9zSVZBIi4iSUQiID0gInRiSVZBIi4iSURUaXBvSXZhIg0KICBsZWZ0IGpvaW4gImRibyIuInRiRm9ybmVjZWRvcmVzIiAidGJGb3JuZWNlZG9yZXMiDQogICAgICAgb24gInRiRm9ybmVjZWRvcmVzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVudGlkYWRlIg0KICBsZWZ0IGpvaW4gImRibyIuICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiDQoJICAgb24gInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIklERm9ybmVjZWRvciIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERW50aWRhZGUiIGFuZCAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iT3JkZW0iPTENCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpcyINCiAgICAgICBvbiAidGJDb2RpZ29zUG9zdGFpcyIuIklEIiA9ICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiLiJJRENvZGlnb1Bvc3RhbCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkVzdGFkb3MiICJ0YkVzdGFkb3MiDQogICAgICAgb24gInRiRXN0YWRvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJUaXBvc0RvY3VtZW50byINCiAgICAgICAidGJUaXBvc0RvY3VtZW50byINCiAgICAgICBvbiAidGJUaXBvc0RvY3VtZW50byIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvRG9jdW1lbnRvIg0KICBsZWZ0IGpvaW4gImRibyIuInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KICAgICAgIG9uICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KCSAgICBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIiAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iDQogICAgICAgb24gInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFUaXBvc0RvY3VtZW50byINCiAgbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIg0KICAgICAgIG9uICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIklEIiA9ICJ0YlRpcG9zRG9jdW1lbnRvIi4iSURTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hTmF0dXJlemFzIiAidGJTaXN0ZW1hTmF0dXJlemFzIg0KICAgICAgIG9uICJ0YlNpc3RlbWFOYXR1cmV6YXMiLiJJRCIgPSAidGJUaXBvc0RvY3VtZW50byIuIklEU2lzdGVtYU5hdHVyZXphcyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFydGlnb3MiICJ0YkFydGlnb3MiDQogICAgICAgb24gInRiQXJ0aWdvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcnRpZ28iDQogIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMxIg0KICAgICAgIG9uICJ0YkNvZGlnb3NQb3N0YWlzMSIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiDQogIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMyIg0KICAgICAgIG9uICJ0YkNvZGlnb3NQb3N0YWlzMiIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczMiDQogICAgICAgb24gInRiQ29kaWdvc1Bvc3RhaXMzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIg0KICBsZWZ0IGpvaW4gImRibyIuInRiTW9lZGFzIiAidGJNb2VkYXMiDQogICAgICAgb24gInRiTW9lZGFzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIg0KICBsZWZ0IGpvaW4gInRiUGFyYW1ldHJvc0VtcHJlc2EiIA0KICAgICAgIG9uICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURNb2VkYURlZmVpdG8iID0gInRiTW9lZGFzIi4iSUQiIA0KICBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYU1vZWRhcyIgInRiU2lzdGVtYU1vZWRhcyINCiAgICAgICBvbiAidGJTaXN0ZW1hTW9lZGFzIi4iSUQiID0gInRiTW9lZGFzIi4iSURTaXN0ZW1hTW9lZGEiDQogIGxlZnQgam9pbiAiZGJvIi4idGJBcm1hemVucyIgInRiQXJtYXplbnMiDQogICAgICAgb24gInRiQXJtYXplbnMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzIiAidGJBcm1hemVuc0xvY2FsaXphY29lcyINCiAgICAgICBvbiAidGJBcm1hemVuc0xvY2FsaXphY29lcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtTG9jYWxpemFjYW8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJBcm1hemVucyIgInRiQXJtYXplbnMxIg0KICAgICAgIG9uICJ0YkFybWF6ZW5zMSIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtRGVzdGlubyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzIiAidGJBcm1hemVuc0xvY2FsaXphY29lczEiDQogICAgICAgb24gInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJREFybWF6ZW1Mb2NhbGl6YWNhb0Rlc3Rpbm8iDQp3aGVyZSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEIj0gQElERG9jdW1lbnRvDQpPcmRlciBieSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9yZGVtIjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IkN1c3RvbVNxbFF1ZXJ5IiBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzX0NhYiI+PFBhcmFtZXRlciBOYW1lPSJJZERvYyIgVHlwZT0iRGV2RXhwcmVzcy5EYXRhQWNjZXNzLkV4cHJlc3Npb24iPihTeXN0ZW0uSW50NjQsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OSkoP0lERG9jdW1lbnRvKTwvUGFyYW1ldGVyPjxTcWw+c2VsZWN0IGRpc3RpbmN0ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUQiLCAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb0RvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJPYnNlcnZhY29lcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRheGFDb252ZXJzYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVG90YWxNb2VkYURvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhUmVmZXJlbmNpYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJMb2NhbENhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJIb3JhQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW9yYWRhQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkxvY2FsRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkhvcmFEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uY2VsaG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZURlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9EZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2VyaWVEb2NNYW51YWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTnVtZXJvRG9jTWFudWFsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0xpbmhhcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJQb3N0byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzdGFkbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJVdGlsaXphZG9yRXN0YWRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFIb3JhRXN0YWRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkFzc2luYXR1cmEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmVyc2FvQ2hhdmVQcml2YWRhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk5vbWVGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW9yYWRhRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9GaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb250cmlidWludGVGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETG9qYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJbXByZXNzbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWYWxvckltcG9zdG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iUGVyY2VudGFnZW1EZXNjb250byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWYWxvckRlc2NvbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9yUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGF4YUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUYXhhSXZhUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vdGl2b0lzZW5jYW9JdmEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW90aXZvSXNlbmNhb1BvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbFBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJFc3BhY29GaXNjYWxQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURSZWdpbWVJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iUmVnaW1lSXZhUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkN1c3Rvc0FkaWNpb25haXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lzdGVtYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBdGl2byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQ3JpYWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJVdGlsaXphZG9yQ3JpYWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQWx0ZXJhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkYzTU1hcmNhZG9yIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlV0aWxpemFkb3JBbHRlcmFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURGb3JtYUV4cGVkaWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0ludGVybm8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvRW50aWRhZGUiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFbnRpZGFkZSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmRpY2FvUGFnYW1lbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETG9jYWxPcGVyYWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29BVCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFBhaXNDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFBhaXNEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNYXRyaWN1bGEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURQYWlzRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbEZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEZXNjcmljYW9Db2RpZ29Qb3N0YWxGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGVzY3JpY2FvQ29uY2VsaG9GaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGVzY3JpY2FvRGlzdHJpdG9GaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3BhY29GaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURSZWdpbWVJdmEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvQVRJbnRlcm5vIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRpcG9GaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1RpcG9Fc3RhZG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvRG9jT3JpZ2VtIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRpc3RyaXRvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9DYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Qb3N0YWxDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvbmNlbGhvRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvUG9zdGFsRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvRW50aWRhZGUiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvTW9lZGEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTWVuc2FnZW1Eb2NBVCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFNpc1RpcG9zRG9jUFUiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvU2lzVGlwb3NEb2NQVSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NNYW51YWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRG9jUmVwb3NpY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFBc3NpbmF0dXJhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDb250cm9sb0ludGVybm8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2VndW5kYVZpYSIsInRiRm9ybmVjZWRvcmVzIi4iTm9tZSIgYXMgInRiRm9ybmVjZWRvcmVzX05vbWUiLCJ0YkZvcm5lY2Vkb3JlcyIuIkNvZGlnbyIgYXMgInRiRm9ybmVjZWRvcmVzX0NvZGlnbyIsInRiRm9ybmVjZWRvcmVzIi4iTkNvbnRyaWJ1aW50ZSIgYXMgInRiRm9ybmVjZWRvcmVzX05Db250cmlidWludGUiLCJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiLiJNb3JhZGEiIGFzICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXNfTW9yYWRhIiwidGJDb2RpZ29zUG9zdGFpcyIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0NvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9EZXNjcmljYW8iLCJ0YkVzdGFkb3MiLiJDb2RpZ28iIGFzICJ0YkVzdGFkb3NfQ29kaWdvIiwidGJFc3RhZG9zIi4iRGVzY3JpY2FvIiBhcyAidGJFc3RhZG9zX0Rlc2NyaWNhbyIsInRiVGlwb3NEb2N1bWVudG8iLiJDb2RpZ28iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0NvZGlnbyIsInRiVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0Rlc2NyaWNhbyIsInRiVGlwb3NEb2N1bWVudG8iLiJBY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIgYXMgInRiVGlwb3NEb2N1bWVudG9fQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iLCJ0YlRpcG9zRG9jdW1lbnRvIi4iRG9jTmFvVmFsb3JpemFkbyIgYXMgInRiVGlwb3NEb2N1bWVudG9fRG9jTmFvVmFsb3JpemFkbyIsInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJEZXNjcmljYW9TZXJpZSIsInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJUaXBvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fVGlwbyIsInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJUaXBvIiwidGJDb2RpZ29zUG9zdGFpczMiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpczMiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfRGVzY3JpY2FvIiwidGJDb2RpZ29zUG9zdGFpczEiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0NvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMxIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc19EZXNjcmljYW8iLCJ0YkNvZGlnb3NQb3N0YWlzMiIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDYXJnYV9Db2RpZ28iLCJ0YkNvZGlnb3NQb3N0YWlzMiIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDYXJnYV9EZXNjcmljYW8iLCJ0Yk1vZWRhcyIuIkNvZGlnbyIgYXMgInRiTW9lZGFzX0NvZGlnbyIsInRiTW9lZGFzIi4iRGVzY3JpY2FvIiBhcyAidGJNb2VkYXNfRGVzY3JpY2FvIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiBhcyAidGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIsInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc0l2YSIgYXMgInRiTW9lZGFzX0Nhc2FzRGVjaW1haXNJdmEiLCJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiwidGJNb2VkYXMiLiJTaW1ib2xvIiBhcyAidGJNb2VkYXNfU2ltYm9sbyIsInRiU2lzdGVtYU1vZWRhcyIuIkNvZGlnbyIgYXMgInRiU2lzdGVtYU1vZWRhc19Db2RpZ28iLCJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiBhcyAidGJQYXJhbWVudHJvc0VtcHJlc2FfQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiwidGJTaXN0ZW1hTmF0dXJlemFzIi4iQ29kaWdvIiBhcyAidGJTaXN0ZW1hTmF0dXJlemFzX0NvZGlnbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFEZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVm9zc29OdW1lcm9Eb2N1bWVudG8iLHN1bSgidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlZhbG9yRGVzY29udG9MaW5oYSIpIGFzICJWYWxvckRlc2NvbnRvTGluaGFfU3VtIiwgInRiTG9qYXMiLiJEZXNjcmljYW8iIGFzICJ0YkxvamFzX0Rlc2NyaWNhbyIsIHRiRm9ybmVjZWRvcmVzLiJDb2RpZ29DbGllbnRlIiBmcm9tICgoKCgoKCgoKCgoKCgoKCgiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiDQogbGVmdCBqb2luICJkYm8iLiJ0YkRvY3VtZW50b3NDb21wcmFzIiAidGJEb2N1bWVudG9zQ29tcHJhcyIgb24gKCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRERvY3VtZW50b0NvbXByYSIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJGb3JuZWNlZG9yZXMiICJ0YkZvcm5lY2Vkb3JlcyIgb24gKCJ0YkZvcm5lY2Vkb3JlcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFbnRpZGFkZSIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJGb3JuZWNlZG9yZXNNb3JhZGFzIiAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIiBvbiAoInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIklERm9ybmVjZWRvciIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERW50aWRhZGUiIGFuZCAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iT3JkZW0iPTEgKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiQ29kaWdvc1Bvc3RhaXMiICJ0YkNvZGlnb3NQb3N0YWlzIiBvbiAoInRiQ29kaWdvc1Bvc3RhaXMiLiJJRCIgPSAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iSURDb2RpZ29Qb3N0YWwiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiRXN0YWRvcyIgInRiRXN0YWRvcyIgb24gKCJ0YkVzdGFkb3MiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXN0YWRvIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YlRpcG9zRG9jdW1lbnRvIiAidGJUaXBvc0RvY3VtZW50byIgb24gKCJ0YlRpcG9zRG9jdW1lbnRvIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9Eb2N1bWVudG8iKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIiBvbiAoInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIiAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iIG9uICgidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJJRCIgPSAidGJUaXBvc0RvY3VtZW50byIuIklEU2lzdGVtYVRpcG9zRG9jdW1lbnRvIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIiBvbiAoInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMxIiBvbiAoInRiQ29kaWdvc1Bvc3RhaXMxIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbEZpc2NhbCIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMyIiBvbiAoInRiQ29kaWdvc1Bvc3RhaXMyIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbENhcmdhIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczMiIG9uICgidGJDb2RpZ29zUG9zdGFpczMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiTW9lZGFzIiAidGJNb2VkYXMiIG9uICgidGJNb2VkYXMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETW9lZGEiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiUGFyYW1ldHJvc0VtcHJlc2EiICJ0YlBhcmFtZXRyb3NFbXByZXNhIiBvbiAoInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIgPSAidGJNb2VkYXMiLiJJRCIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hTmF0dXJlemFzIiAidGJTaXN0ZW1hTmF0dXJlemFzIiBvbiAoInRiU2lzdGVtYU5hdHVyZXphcyIuIklEIiA9ICJ0YlRpcG9zRG9jdW1lbnRvIi4iSURTaXN0ZW1hTmF0dXJlemFzIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFNb2VkYXMiICJ0YlNpc3RlbWFNb2VkYXMiIG9uICgidGJTaXN0ZW1hTW9lZGFzIi4iSUQiID0gInRiTW9lZGFzIi4iSURTaXN0ZW1hTW9lZGEiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiTG9qYXMiICJ0YkxvamFzIiBvbiAoInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvamEiID0gInRiTG9qYXMiLiJJRCIpDQp3aGVyZSAoInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCIgPSBASWREb2MpDQpncm91cCBieSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb0RvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJPYnNlcnZhY29lcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRheGFDb252ZXJzYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVG90YWxNb2VkYURvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhUmVmZXJlbmNpYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJMb2NhbENhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJIb3JhQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW9yYWRhQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkxvY2FsRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkhvcmFEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uY2VsaG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZURlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFEZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNlcmllRG9jTWFudWFsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0RvY01hbnVhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9MaW5oYXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iUG9zdG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckVzdGFkbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhSG9yYUVzdGFkbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBc3NpbmF0dXJhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZlcnNhb0NoYXZlUHJpdmFkYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOb21lRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYUZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbEZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9GaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29udHJpYnVpbnRlRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpZ2xhUGFpc0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvamEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSW1wcmVzc28iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JJbXBvc3RvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBlcmNlbnRhZ2VtRGVzY29udG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JEZXNjb250byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWYWxvclBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRheGFJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGF4YUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3Rpdm9Jc2VuY2FvSXZhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vdGl2b0lzZW5jYW9Qb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3BhY29GaXNjYWxQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRXNwYWNvRmlzY2FsUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlJlZ2ltZUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDdXN0b3NBZGljaW9uYWlzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpc3RlbWEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQXRpdm8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUNyaWFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckNyaWFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUFsdGVyYWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJVdGlsaXphZG9yQWx0ZXJhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkYzTU1hcmNhZG9yIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERm9ybWFFeHBlZGljYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvc0RvY3VtZW50b1NlcmllcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9JbnRlcm5vIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERW50aWRhZGUiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvRW50aWRhZGUiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25kaWNhb1BhZ2FtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvY2FsT3BlcmFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvQVQiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURQYWlzQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURQYWlzRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTWF0cmljdWxhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Qb3N0YWxGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGVzY3JpY2FvQ29kaWdvUG9zdGFsRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0Rpc3RyaXRvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXNwYWNvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0FUSW50ZXJubyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUaXBvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29UaXBvRXN0YWRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0RvY09yaWdlbSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvbmNlbGhvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvUG9zdGFsQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGlzdHJpdG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb25jZWxob0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbERlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpZ2xhUGFpc0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0VudGlkYWRlIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb01vZWRhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1lbnNhZ2VtRG9jQVQiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURTaXNUaXBvc0RvY1BVIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Npc1RpcG9zRG9jUFUiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRG9jTWFudWFsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY1JlcG9zaWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQXNzaW5hdHVyYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQ29udHJvbG9JbnRlcm5vIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNlZ3VuZGFWaWEiLCJ0YkZvcm5lY2Vkb3JlcyIuIkNvZGlnbyIsInRiRm9ybmVjZWRvcmVzIi4iTm9tZSIsInRiRm9ybmVjZWRvcmVzIi4iTkNvbnRyaWJ1aW50ZSIsInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIk1vcmFkYSIsInRiQ29kaWdvc1Bvc3RhaXMiLiJDb2RpZ28iLCJ0YkNvZGlnb3NQb3N0YWlzIi4iRGVzY3JpY2FvIiwidGJFc3RhZG9zIi4iQ29kaWdvIiwidGJFc3RhZG9zIi4iRGVzY3JpY2FvIiwidGJUaXBvc0RvY3VtZW50byIuIkNvZGlnbyIsInRiVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iLCJ0YlRpcG9zRG9jdW1lbnRvIi4iQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iLCJ0YlRpcG9zRG9jdW1lbnRvIi4iRG9jTmFvVmFsb3JpemFkbyIsInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJEZXNjcmljYW9TZXJpZSIsInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iVGlwbyIsInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJUaXBvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJEZXNjcmljYW8iLCJ0YkNvZGlnb3NQb3N0YWlzMSIuIkNvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMxIi4iRGVzY3JpY2FvIiwidGJDb2RpZ29zUG9zdGFpczIiLiJDb2RpZ28iLCJ0YkNvZGlnb3NQb3N0YWlzMiIuIkRlc2NyaWNhbyIsInRiQ29kaWdvc1Bvc3RhaXMzIi4iQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpczMiLiJEZXNjcmljYW8iLCJ0Yk1vZWRhcyIuIkNvZGlnbyIsInRiTW9lZGFzIi4iRGVzY3JpY2FvIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzSXZhIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiwidGJNb2VkYXMiLiJTaW1ib2xvIiwidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIsInRiU2lzdGVtYU5hdHVyZXphcyIuIkNvZGlnbyIsInRiU2lzdGVtYU1vZWRhcyIuIkNvZGlnbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWb3Nzb051bWVyb0RvY3VtZW50byIsICJ0YkxvamFzIi4iRGVzY3JpY2FvIix0YkZvcm5lY2Vkb3Jlcy4iQ29kaWdvQ2xpZW50ZSI8L1NxbD48L1F1ZXJ5PjxRdWVyeSBUeXBlPSJTZWxlY3RRdWVyeSIgTmFtZT0idGJQYXJhbWV0cm9zRW1wcmVzYSI+PFRhYmxlcz48VGFibGUgTmFtZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgLz48L1RhYmxlcz48Q29sdW1ucz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJJRCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJJRE1vZWRhRGVmZWl0byIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJNb3JhZGEiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRm90byIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJGb3RvQ2FtaW5obyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJEZXNpZ25hY2FvQ29tZXJjaWFsIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkNvZGlnb1Bvc3RhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJMb2NhbGlkYWRlIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkNvbmNlbGhvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkRpc3RyaXRvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklEUGFpcyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJUZWxlZm9uZSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJGYXgiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRW1haWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iV2ViU2l0ZSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJOSUYiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDYXBpdGFsU29jaWFsIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklESWRpb21hQmFzZSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJTaXN0ZW1hIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkF0aXZvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkRhdGFDcmlhY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IlV0aWxpemFkb3JDcmlhY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkRhdGFBbHRlcmFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJGM01NYXJjYWRvciIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJJREVtcHJlc2EiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklEUGFpc2VzRGVzYyIgLz48L0NvbHVtbnM+PC9RdWVyeT48UXVlcnkgVHlwZT0iU2VsZWN0UXVlcnkiIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNfUVJDb2RlIj48UGFyYW1ldGVyIE5hbWU9ImlkZG9jIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5JbnQ2NCwgbXNjb3JsaWIsIFZlcnNpb249NC4wLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5KSg/SUREb2N1bWVudG8pPC9QYXJhbWV0ZXI+PFRhYmxlcz48VGFibGUgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgQWxpYXM9InRiRG9jdW1lbnRvc0NvbXByYXNfUVJDb2RlIiAvPjwvVGFibGVzPjxDb2x1bW5zPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXNfUVJDb2RlIiBOYW1lPSJJRCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzX1FSQ29kZSIgTmFtZT0iQVRDVUQiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhc19RUkNvZGUiIE5hbWU9IkFUUVJDb2RlIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXNfUVJDb2RlIiBOYW1lPSJBVFFSQ29kZVRleHRvIiAvPjwvQ29sdW1ucz48RmlsdGVyPlt0YkRvY3VtZW50b3NDb21wcmFzX1FSQ29kZS5JRF0gPSA/aWRkb2M8L0ZpbHRlcj48L1F1ZXJ5PjxSZWxhdGlvbiBNYXN0ZXI9InRiRG9jdW1lbnRvc0NvbXByYXNfQ2FiIiBEZXRhaWw9InRiRG9jdW1lbnRvc0NvbXByYXNfUVJDb2RlIj48S2V5Q29sdW1uIE1hc3Rlcj0iSUQiIERldGFpbD0iSUQiIC8+PC9SZWxhdGlvbj48UmVzdWx0U2NoZW1hPjxEYXRhU2V0IE5hbWU9IlNxbERhdGFTb3VyY2UiPjxWaWV3IE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNfQ2FiIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEYXRhRG9jdW1lbnRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iT2JzZXJ2YWNvZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURNb2VkYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxNb2VkYURvY3VtZW50byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhUmVmZXJlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJMb2NhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYUNhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJMb2NhbERlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOb21lRGVzdGluYXRhcmlvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25jZWxob0Rlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9EZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJTZXJpZURvY01hbnVhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9Eb2NNYW51YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvTGluaGFzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUG9zdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3RhZG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yRXN0YWRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFIb3JhRXN0YWRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iQXNzaW5hdHVyYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJWZXJzYW9DaGF2ZVByaXZhZGEiIFR5cGU9IkludDMyIiAvPjxGaWVsZCBOYW1lPSJOb21lRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbEZpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29udHJpYnVpbnRlRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRExvamEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJbXByZXNzbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iVmFsb3JJbXBvc3RvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlBlcmNlbnRhZ2VtRGVzY29udG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JEZXNjb250byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvclBvcnRlcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFRheGFJdmFQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUYXhhSXZhUG9ydGVzIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9JdmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTW90aXZvSXNlbmNhb1BvcnRlcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVzcGFjb0Zpc2NhbFBvcnRlcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkVzcGFjb0Zpc2NhbFBvcnRlcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFJlZ2ltZUl2YVBvcnRlcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlJlZ2ltZUl2YVBvcnRlcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDdXN0b3NBZGljaW9uYWlzIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlNpc3RlbWEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkF0aXZvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ3JpYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JDcmlhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFBbHRlcmFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvciIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERm9ybWFFeHBlZGljYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtZXJvSW50ZXJubyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0VudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURFbnRpZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uZGljYW9QYWdhbWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRExvY2FsT3BlcmFjYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BVCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNDYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEUGFpc0Rlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTWF0cmljdWxhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpc0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbEZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9Db2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQ29uY2VsaG9GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvRGlzdHJpdG9GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFJlZ2ltZUl2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0FUSW50ZXJubyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUaXBvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRvY3VtZW50byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29UaXBvRXN0YWRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0RvY09yaWdlbSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0b0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG9EZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxob0Rlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbERlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0Rlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0VudGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb01vZWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1lbnNhZ2VtRG9jQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURTaXNUaXBvc0RvY1BVIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvU2lzVGlwb3NEb2NQVSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEb2NNYW51YWwiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRvY1JlcG9zaWNhbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUFzc2luYXR1cmEiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ29udHJvbG9JbnRlcm5vIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iU2VndW5kYVZpYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNfTm9tZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkZvcm5lY2Vkb3Jlc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNfTkNvbnRyaWJ1aW50ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXNfTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFc3RhZG9zX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVzdGFkb3NfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fRG9jTmFvVmFsb3JpemFkbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQ29kaWdvU2VyaWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvU2VyaWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDYXJnYV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0Nhc2FzRGVjaW1haXNUb3RhaXMiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0Nhc2FzRGVjaW1haXNJdmEiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0Nhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX1NpbWJvbG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlBhcmFtZW50cm9zRW1wcmVzYV9DYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYU5hdHVyZXphc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTW9yYWRhRGVzdGluYXRhcmlvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlZvc3NvTnVtZXJvRG9jdW1lbnRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlZhbG9yRGVzY29udG9MaW5oYV9TdW0iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0idGJMb2phc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvQ2xpZW50ZSIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48VmlldyBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEYXRhRG9jdW1lbnRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iT2JzZXJ2YWNvZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURNb2VkYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxNb2VkYURvY3VtZW50byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhUmVmZXJlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJMb2NhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYUNhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJMb2NhbERlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOb21lRGVzdGluYXRhcmlvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc3RpbmF0YXJpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbERlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2VyaWVEb2NNYW51YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0xpbmhhcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlBvc3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXN0YWRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckVzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhSG9yYUVzdGFkbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkFzc2luYXR1cmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmVyc2FvQ2hhdmVQcml2YWRhIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iTm9tZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvbnRyaWJ1aW50ZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSW1wcmVzc28iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW1wb3N0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQZXJjZW50YWdlbURlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRGVzY29udG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURUYXhhSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUl2YVBvcnRlcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9Qb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ3VzdG9zQWRpY2lvbmFpcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvciIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJJREZvcm1hRXhwZWRpY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvc0RvY3VtZW50b1NlcmllcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0ludGVybm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREVudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvRW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmRpY2FvUGFnYW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURMb2NhbE9wZXJhY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNEZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1hdHJpY3VsYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0Rpc3RyaXRvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BVEludGVybm8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwb0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEb2N1bWVudG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb0VzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Eb2NPcmlnZW0iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG9DYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxob0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG9EZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29FbnRpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Nb2VkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNZW5zYWdlbURvY0FUIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEU2lzVGlwb3NEb2NQVSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Npc1RpcG9zRG9jUFUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRG9jTWFudWFsIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEb2NSZXBvc2ljYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFBc3NpbmF0dXJhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YUNvbnRyb2xvSW50ZXJubyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkRhdGFEb2N1bWVudG9fMSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1RpcG9Fc3RhZG9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTZWd1bmRhVmlhIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0lEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iT3JkZW0iIFR5cGU9IkludDMyIiAvPjxGaWVsZCBOYW1lPSJJRERvY3VtZW50b0NvbXByYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEVW5pZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bUNhc2FzRGVjVW5pZGFkZSIgVHlwZT0iSW50MTYiIC8+PEZpZWxkIE5hbWU9IlF1YW50aWRhZGUiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvRWZldGl2byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1RvdGFsIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfT2JzZXJ2YWNvZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb3RlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvTG90ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29VbmlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0xvdGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUZhYnJpY29Mb3RlIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YVZhbGlkYWRlTG90ZSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvTnVtU2VyaWUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJBcnRpZ29OdW1TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1Mb2NhbGl6YWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJtYXplbURlc3Rpbm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1Mb2NhbGl6YWNhb0Rlc3Rpbm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1MaW5oYXNEaW1lbnNvZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEZXNjb250bzEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRGVzY29udG8yIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEVGF4YUl2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFJdmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19Nb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlJlZ2ltZUl2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iT3JkZW1fMSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19BdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQ3JpYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19VdGlsaXphZG9yQWx0ZXJhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iVmFsb3JJbmNpZGVuY2lhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9ySVZBIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRvY3VtZW50b09yaWdlbSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhRW50cmVnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX05vbWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX05Db250cmlidWludGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNNb3JhZGFzX01vcmFkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRXN0YWRvc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFc3RhZG9zX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0RvY05hb1ZhbG9yaXphZG8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJ0aWdvc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQWJyZXZpYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJ0aWdvc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcnRpZ29zX0dlcmVMb3RlcyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX1NpbWJvbG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc0xvY2FsaXphY29lc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc0xvY2FsaXphY29lc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuczFfRGVzY3JpY2FvRGVzdGlubyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zMV9Db2RpZ29EZXN0aW5vIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJtYXplbnNMb2NhbGl6YWNvZXMxX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzMV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc0l2YSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hQ29kaWdvc0lWQS5Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTdWJUb3RhbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0YlBhcmFtZW50cm9zRW1wcmVzYV9DYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYU5hdHVyZXphc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48L1ZpZXc+PFZpZXcgTmFtZT0idGJQYXJhbWV0cm9zRW1wcmVzYSI+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURNb2VkYURlZmVpdG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvQ2FtaW5obyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNpZ25hY2FvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJMb2NhbGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZheCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJXZWJTaXRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik5JRiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhcGl0YWxTb2NpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURJZGlvbWFCYXNlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IlVua25vd24iIC8+PEZpZWxkIE5hbWU9IklERW1wcmVzYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iSURQYWlzZXNEZXNjIiBUeXBlPSJJbnQ2NCIgLz48L1ZpZXc+PFZpZXcgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc19RUkNvZGUiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkFUQ1VEIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkFUUVJDb2RlIiBUeXBlPSJCeXRlQXJyYXkiIC8+PEZpZWxkIE5hbWU9IkFUUVJDb2RlVGV4dG8iIFR5cGU9IlN0cmluZyIgLz48L1ZpZXc+PFJlbGF0aW9uIE1hc3Rlcj0idGJEb2N1bWVudG9zQ29tcHJhc19DYWIiIERldGFpbD0idGJEb2N1bWVudG9zQ29tcHJhc19RUkNvZGUiPjxLZXlDb2x1bW4gTWFzdGVyPSJJRCIgRGV0YWlsPSJJRCIgLz48L1JlbGF0aW9uPjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiBEYkNvbW1hbmRUaW1lb3V0PSIxODAwIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
--Mapa de documentos de compras 
---tratar subreports
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item3/SubBands/Item1/Controls/Item2/@ReportSourceUrl)[.=10000][1] with sql:variable("@intIDMapaSubCab")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item7/SubBands/Item1/Controls/Item2/@ReportSourceUrl)[.=20000][1] with sql:variable("@intIDMapaMI")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item5/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=30000][1] with sql:variable("@intIDMapaD")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item6/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=40000][1] with sql:variable("@intIDMapaDNV")'')
UPDATE tbMapasVistas SET MapaXML = @ptrval , NomeMapa = ''DocumentosCompras'' Where Entidade = ''PurchaseDocumentsList'' and NomeMapa = ''DocumentosCompras''
')

-- Permitir editar documentos de compra
EXEC('UPDATE [F3MOGeral]..tbMenus SET btnContextoDuplicar = 1 WHERE Descricao = ''PurchaseDocuments''')

--atualizar vista de rolo
EXEC('
DECLARE @ptrvalP xml;
SET @ptrvalP = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="Rolo" SnapGridSize="25" ReportUnit="TenthsOfAMillimeter" Margins="0, 300, 0, 0" PaperKind="Custom" PageWidth="1000" PageHeight="80" ScriptLanguage="VisualBasic" Version="19.1" DataMember="QueryBase" DataSource="#Ref-0" Dpi="254">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="10" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item3 Ref="7" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item4 Ref="8" Visible="false" Description="Via" Name="Via" />
    <Item5 Ref="9" Visible="false" Description="Formas" ValueInfo="select distinct tbRecibos.ID, tbRecibosFormasPagamento.IDFormaPagamento, tbFormasPagamento.Descricao, tbRecibosFormasPagamento.Valor,  tbRecibosFormasPagamento.ValorEntregue,  tbRecibosFormasPagamento.Troco from tbRecibos inner join tbRecibosFormasPagamento on tbRecibosFormasPagamento.IDRecibo= tbRecibos.ID inner join tbFormasPagamento on tbRecibosFormasPagamento.IDFormaPagamento=tbFormasPagamento.ID where tbRecibos.ID=" Name="Formas" />
    <Item6 Ref="11" Visible="false" Description="NumeroCasasDecimais" ValueInfo="2" Name="NumeroCasasDecimais" Type="#Ref-10" />
    <Item7 Ref="12" Visible="false" Description="Observacoes" ValueInfo="select ID, Observacoes from tbRecibos where ID=" Name="Observacoes" />
    <Item8 Ref="13" Visible="false" Description="Assinatura" ValueInfo="select ID, '''''''' as Assinatura from tbRecibos where ID=" Name="Assinatura" />
    <Item9 Ref="14" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item10 Ref="15" Visible="false" Description="Entidade" Name="Entidade" />
    <Item11 Ref="16" Visible="false" Description="Parameter1" Name="SQLQuery" />
    <Item12 Ref="17" Visible="false" Description="Parameter1" Name="TabelaTemp" />
  </Parameters>
  <Bands>
    <Item1 Ref="18" ControlType="TopMarginBand" Name="TopMarginBand1" HeightF="0" Dpi="254" />
    <Item2 Ref="19" ControlType="DetailBand" Name="Detail" KeepTogetherWithDetailReports="true" KeepTogether="true" TextAlignment="TopLeft" Dpi="254" Padding="0,0,0,0,254">
      <MultiColumn Ref="20" ColumnWidth="600" Layout="AcrossThenDown" Mode="UseColumnWidth" />
      <Controls>
        <Item1 Ref="21" ControlType="XRLabel" Name="label2" CanGrow="false" Text="XrLabel1" TextAlignment="MiddleLeft" SizeF="165.06,26.9" LocationFloat="334.38, 43.95" Dpi="254" Font="Arial Black, 5.5pt" Padding="5,5,0,0,254">
          <ExpressionBindings>
            <Item1 Ref="22" Expression="[DescricaoMarca]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="23" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="24" ControlType="XRLabel" Name="label1" CanGrow="false" Text="XrLabel1" TextAlignment="MiddleLeft" SizeF="165.06,26.9" LocationFloat="334.38, 11.75" Dpi="254" Font="Arial Black, 5.5pt" Padding="5,5,0,0,254">
          <ExpressionBindings>
            <Item1 Ref="25" Expression="[CodigoArtigo]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="26" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="27" ControlType="XRLabel" Name="XrLabel1" CanGrow="false" Text="XrLabel1" TextAlignment="TopLeft" SizeF="290.42,19.7" LocationFloat="6.85, 59.27" Dpi="254" Font="Arial Black, 4.5pt" Padding="5,5,0,0,254">
          <ExpressionBindings>
            <Item1 Ref="28" Expression="[DescricaoArtigo]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="29" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="30" ControlType="XRLabel" Name="fldPV1" TextFormatString="{0:0.00€}" CanGrow="false" TextAlignment="MiddleRight" SizeF="94.71,26.91" LocationFloat="498.94, 11.75" Dpi="254" Font="Arial Black, 5.5pt" Padding="5,5,0,0,254">
          <ExpressionBindings>
            <Item1 Ref="31" Expression="[ValorComIva]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="32" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="33" ControlType="XRBarCode" Name="fldCodigoBarras" Module="3.5" AutoModule="true" TextAlignment="MiddleCenter" ShowText="false" Text="12345678" SizeF="280,40.68" LocationFloat="6.86, 17.46" Dpi="254" Font="Arial, 5.25pt" ForeColor="Black" Padding="0,0,0,0,254" BorderWidth="0">
          <Symbology Ref="34" Name="Code39Extended" WideNarrowRatio="3" CalcCheckSum="false" />
          <ExpressionBindings>
            <Item1 Ref="35" Expression="[CodigoBarras]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="36" UseFont="false" UseForeColor="false" UsePadding="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
      </Controls>
      <StylePriority Ref="37" UsePadding="false" />
    </Item2>
    <Item3 Ref="38" ControlType="BottomMarginBand" Name="BottomMarginBand1" HeightF="0" Dpi="254" />
  </Bands>
  <ReportPrintOptions Ref="39" DetailCountOnEmptyDataSource="0" />
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="10" Content="System.Int32" Type="System.Type" />
    <Item3 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9MTAuMC4xLjQ7VXNlciBJRD1GM01PO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTgzODNGM01POyIgLz48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9IlF1ZXJ5QmFzZSI+PFNxbD5zZWxlY3QgKiBmcm9tIHZ3QXJ0aWdvczwvU3FsPjwvUXVlcnk+PFJlc3VsdFNjaGVtYT48RGF0YVNldD48VmlldyBOYW1lPSJRdWVyeUJhc2UiPjxGaWVsZCBOYW1lPSJ0aXBvZG9jIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERG9jdW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUXVhbnRpZGFkZSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckNvbUl2YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvQmFycmFzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0JhcnJhc0Zvcm5lY2Vkb3IiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iUmVmZXJlbmNpYUZvcm5lY2Vkb3IiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmFsb3JDb21JdmEyIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb01hcmNhIiBUeXBlPSJTdHJpbmciIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiBEYkNvbW1hbmRUaW1lb3V0PSIxODAwIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
UPDATE tbMapasVistas SET MapaXML = @ptrvalP where NomeMapa = ''Rolo'' and sistema=1 and subreport = 0
')
