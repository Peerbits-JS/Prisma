/* ACT BD EMPRESA VERSAO 25*/

--criação do menu de licenciamento
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=125)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (125, 15, N''Licenciamento'', N''015.006'', N''Licenciamento'', 50000, N''f3icon-licenciamento'', N''/Licenciamento/Licenciamento/Index'', 1, 15, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=125 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) 
VALUES (1, 125, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

--alteração de campos RGPD
EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasFuncionalidades Set QueryRetornaCamposBloqueadosAEsquecer = ''SELECT CASE WHEN (SELECT NContribuinte FROM TbClientes WHERE ID = <Chave>)  IS NULL THEN ''''Nome'''' ELSE ''''NContribuinte'''' END AS Campo,CASE WHEN ( SELECT NContribuinte FROM TbClientes WHERE ID = <Chave>)  IS NULL THEN ''''Nome do cliente associado a documentos fiscais'''' ELSE ''''Contribuinte do cliente associado a documentos fiscais'''' END AS MensagemBloqueio FROM (SELECT TOP 1 IDEntidade AS Campo FROM (SELECT TOP 1 IDEntidade FROM tbDocumentosVendas WHERE IDEntidade = <Chave> UNION ALL SELECT TOP 1 IDEntidade FROM tbDocumentosStock WHERE IDEntidade = <Chave>) AS tabDocs) AS tbClientes'' Where Id = 1')
EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasFuncionalidades Set QueryRetornaCamposBloqueadosAEsquecer = ''SELECT CASE WHEN (SELECT NContribuinte FROM TbClientes WHERE ID = <Chave>)  IS NULL THEN ''''Nome'''' ELSE ''''NContribuinte'''' END AS Campo,CASE WHEN ( SELECT NContribuinte FROM TbClientes WHERE ID = <Chave>)  IS NULL THEN ''''Nome do cliente associado a documentos fiscais'''' ELSE ''''Contribuinte do cliente associado a documentos fiscais'''' END AS MensagemBloqueio FROM (SELECT TOP 1 IDEntidade AS Campo FROM (SELECT TOP 1 IDEntidade FROM tbDocumentosVendas WHERE IDEntidade = <Chave> UNION ALL SELECT TOP 1 IDEntidade FROM tbDocumentosStock WHERE IDEntidade = <Chave>) AS tabDocs) AS tbClientes'' Where Id = 2')
EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasFuncionalidades Set QueryRetornaCamposBloqueadosAEsquecer = ''SELECT CASE WHEN (SELECT NContribuinte FROM TbFornecedores WHERE ID = <Chave>)  IS NULL THEN ''''Nome'''' ELSE ''''NContribuinte'''' END AS Campo,CASE WHEN ( SELECT NContribuinte FROM TbFornecedores WHERE ID = <Chave>)  IS NULL THEN ''''Nome do fornecedor associado a documentos fiscais'''' ELSE ''''Contribuinte do fornecedor associado a documentos fiscais'''' END AS MensagemBloqueio FROM (SELECT TOP 1 IDEntidade AS Campo FROM (SELECT TOP 1 IDEntidade FROM tbDocumentosCompras WHERE IDEntidade = <Chave> ) AS tabDocs) AS tbFornecedores'' Where Id = 3')

EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasColunasAnonEsqPort Set TamanhoMaximo = ''MAX'' Where BaseDados = ''<CL>F3MO<I>'' And Tabela = ''tbClientes'' And NomeCampo = ''FotoCaminho''')
EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasColunasAnonEsqPort Set TamanhoMaximo = ''255'' Where BaseDados = ''<CL>F3MO<I>'' And Tabela = ''tbClientesContatos'' And NomeCampo = ''Email''')
EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasColunasAnonEsqPort Set TamanhoMaximo = ''255'' Where BaseDados = ''<CL>F3MO<I>'' And Tabela = ''tbDocumentosVendas'' And NomeCampo = ''Matricula''')
EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasColunasAnonEsqPort Set TamanhoMaximo = ''MAX'' Where BaseDados = ''<CL>F3MO<I>'' And Tabela = ''tbFornecedores'' And NomeCampo = ''FotoCaminho''')
EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasColunasAnonEsqPort Set TamanhoMaximo = ''255'' Where BaseDados = ''<CL>F3MO<I>'' And Tabela = ''tbFornecedoresContatos'' And NomeCampo = ''Email''')
EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasColunasAnonEsqPort Set TipoCampo = ''datetime'' Where BaseDados = ''<CL>F3MO<I>'' And Tabela = ''tbMedicosTecnicos'' And NomeCampo = ''DataNascimento''')
EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasColunasAnonEsqPort Set TipoCampo = ''datetime'' Where BaseDados = ''<CL>F3MO<I>'' And Tabela = ''tbMedicosTecnicos'' And NomeCampo = ''DataValidade''')
EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasColunasAnonEsqPort Set TamanhoMaximo = ''4000'' Where BaseDados = ''<CL>F3MO<I>'' And Tabela = ''tbMedicosTecnicos'' And NomeCampo = ''FotoCaminho''')
EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasColunasAnonEsqPort Set TamanhoMaximo = ''100'' Where BaseDados = ''<CL>F3MO<I>'' And Tabela = ''tbMedicosTecnicos'' And NomeCampo = ''Nome''')
EXEC('Update [F3MOGeral].[dbo].tbSistemaTabelasColunasAnonEsqPort Set TamanhoMaximo = ''255'' Where BaseDados = ''<CL>F3MO<I>'' And Tabela = ''tbMedicosTecnicosContatos'' And NomeCampo = ''Email''')

EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwArtigos'')) drop view vwArtigos')
EXEC('
BEGIN
EXECUTE(''
create view vwArtigos
as
select ''''003'''' as TipoDoc, tbdocumentoscompraslinhas.iddocumentocompra as IDDocumento, tbdocumentoscompraslinhas.quantidade as Quantidade, 
tbArtigosPrecos.ValorComIva as ValorComIva, tbArtigos.Codigo as CodigoArtigo, tbArtigos.Descricao as DescricaoArtigo, tbArtigos.CodigoBarras,tbArtigos.CodigoBarrasFornecedor, tbArtigos.ReferenciaFornecedor, tbfornecedores.codigo as CodigoFornecedor
FROM tbdocumentoscompraslinhas as tbdocumentoscompraslinhas 
LEFT JOIN tbArtigos AS tbArtigos ON tbArtigos.id=tbdocumentoscompraslinhas.IDArtigo
LEFT JOIN tbArtigosPrecos AS tbArtigosPrecos ON tbArtigosPrecos.IDArtigo=tbArtigos.id and tbArtigosPrecos.IDCodigoPreco=1
LEFT JOIN tbArtigosfornecedores AS tbArtigosfornecedores ON tbArtigosfornecedores.IDArtigo=tbArtigos.id and tbArtigosfornecedores.Ordem=1
LEFT JOIN tbfornecedores AS tbfornecedores ON tbfornecedores.ID=tbArtigosfornecedores.IDFornecedor 
union
select ''''001'''' as TipoDoc, tbDocumentosStockLinhas.IDDocumentoStock as IDDocumento, tbDocumentosStockLinhas.Quantidade as Quantidade, 
tbArtigosPrecos.ValorComIva as ValorComIva, tbArtigos.Codigo as CodigoArtigo, tbArtigos.Descricao as DescricaoArtigo, tbArtigos.CodigoBarras,tbArtigos.CodigoBarrasFornecedor, tbArtigos.ReferenciaFornecedor, tbfornecedores.codigo as CodigoFornecedor
FROM tbDocumentosStockLinhas as tbDocumentosStockLinhas 
LEFT JOIN tbArtigos AS tbArtigos ON tbArtigos.id=tbDocumentosStockLinhas.IDArtigo
LEFT JOIN tbArtigosPrecos AS tbArtigosPrecos ON tbArtigosPrecos.IDArtigo=tbArtigos.id and tbArtigosPrecos.IDCodigoPreco=1
LEFT JOIN tbArtigosfornecedores AS tbArtigosfornecedores ON tbArtigosfornecedores.IDArtigo=tbArtigos.id and tbArtigosfornecedores.Ordem=1
LEFT JOIN tbfornecedores AS tbfornecedores ON tbfornecedores.ID=tbArtigosfornecedores.IDFornecedor 
'')
END')

-- criação de novos campos na tabela de templates
exec('
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME=''tbExamesTemplate'' AND COLUMN_NAME = ''IDElemento'') 
Begin
	alter table tbExamesTemplate ADD IDElemento varchar(max)
End
')

exec('
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME=''tbExamesTemplate'' AND COLUMN_NAME = ''FuncaoJSOnClick'') 
Begin
	alter table tbExamesTemplate ADD FuncaoJSOnClick varchar(max)
End
')

-- Criação da tabela de planificações
EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbPlaneamento]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbPlaneamento](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [Start] [datetime] NOT NULL,
    [End] [datetime] NOT NULL,
    [IsAllDay] [bit] NOT NULL,
    [RecurrenceRule] [nvarchar](max) NULL,
    [RecurrenceException] [nvarchar](max) NULL,
    [StartTimezone] [nvarchar](max) NULL,
    [EndTimezone] [nvarchar](max) NULL,
    [IDLoja] [bigint] NOT NULL,
    [IDMedicoTecnico] [bigint] NOT NULL,
    [Observacoes] [nvarchar](256) NULL,
    [Nome] [nvarchar](256) NULL,
    [Contacto] [nvarchar](50) NULL,
    [Ativo] [bit] NOT NULL,
    [Sistema] [bit] NOT NULL,
    [DataCriacao] [datetime] NOT NULL,
    [UtilizadorCriacao] [nvarchar](256) NOT NULL,
    [DataAlteracao] [datetime] NULL,
    [UtilizadorAlteracao] [nvarchar](256) NULL,
    [F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbPlaneamento] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 
ALTER TABLE [dbo].[tbPlaneamento] ADD  CONSTRAINT [DF_tbPlaneamento_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbPlaneamento] ADD  CONSTRAINT [DF_tbPlaneamento_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbPlaneamento] ADD  CONSTRAINT [DF_tbPlaneamento_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbPlaneamento] ADD  CONSTRAINT [DF_tbPlaneamento_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbPlaneamento] ADD  CONSTRAINT [DF_tbPlaneamento_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbPlaneamento] ADD  CONSTRAINT [DF_tbPlaneamento_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]
 
ALTER TABLE [dbo].[tbPlaneamento]  WITH CHECK ADD  CONSTRAINT [FK_tbPlaneamento_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])
ALTER TABLE [dbo].[tbPlaneamento] CHECK CONSTRAINT [FK_tbPlaneamento_tbLojas]
 
ALTER TABLE [dbo].[tbPlaneamento]  WITH CHECK ADD  CONSTRAINT [FK_tbPlaneamento_tbMedicosTecnicos] FOREIGN KEY([IDMedicoTecnico])
REFERENCES [dbo].[tbMedicosTecnicos] ([ID])
ALTER TABLE [dbo].[tbPlaneamento] CHECK CONSTRAINT [FK_tbPlaneamento_tbMedicosTecnicos]
END
') 
 
-- Reordenação dos menus
EXEC('update [F3MOGeral].[dbo].tbmenus set ativo=1 where id in (123,124)')

EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=22, descricaoabreviada=''014.002.001'', idmodulo=14, ordem=100 where descricao=''ImpostoSelo''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=22, descricaoabreviada=''014.002.002'', idmodulo=14, ordem=200 where descricao=''TiposRetencao''')

EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=23, descricaoabreviada=''001.003.003'', idmodulo=1, ordem=300 where descricao=''Localizacoes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=23, descricaoabreviada=''001.003.004'', idmodulo=1, ordem=400 where descricao=''Unidades''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=23, descricaoabreviada=''001.003.005'', idmodulo=1, ordem=500 where descricao=''UnidadesRelacoes''')

EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.002'', idmodulo=14, ordem=1100  where descricao=''IVA''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.003'', idmodulo=14, ordem=1200  where descricao=''IVARegioes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.004'', idmodulo=14, ordem=1300 where descricao=''TiposArtigos''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.005'', idmodulo=14, ordem=1400 where descricao=''GruposArtigo''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.006'', idmodulo=14, ordem=1500 where descricao=''Familias''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.007'', idmodulo=14, ordem=1600 where descricao=''SubFamilias''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.008'', idmodulo=14, ordem=1700 where descricao=''Marcas''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.009'', idmodulo=14, ordem=1800 where descricao=''ModelosArtigos''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.010'', idmodulo=14, ordem=1900  where descricao=''Composicoes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.011'', idmodulo=14, ordem=2000  where descricao=''Estacoes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.012'', idmodulo=14, ordem=2100  where descricao=''TratamentosLentes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.013'', idmodulo=14, ordem=2200  where descricao=''CoresLentes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.014'', idmodulo=14, ordem=2300  where descricao=''SuplementosLentes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.015'', idmodulo=14, ordem=2400  where descricao=''CatalogosLentes''')

EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.020'', ordem=3000  where descricao=''ArtigosDimensoes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.021'', ordem=3100  where descricao=''ArtigosDimensoesLinhas''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.022'', ordem=3200  where descricao=''ArtigosAnexos''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.023'', ordem=3300  where descricao=''ArtigosArmazensLocalizacoes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.024'', ordem=3400  where descricao=''ArtigosAlternativos''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.025'', ordem=3500  where descricao=''ArtigosAssociados''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.026'', ordem=3600  where descricao=''ArtigosComponentes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.027'', ordem=3700  where descricao=''ArtigosLotes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.028'', ordem=3800  where descricao=''ArtigosPrecos''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.029'', ordem=3900  where descricao=''ArtigosUnidades''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=24, descricaoabreviada=''014.004.030'', ordem=4000  where descricao=''ArtigosIdiomas''')

EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.001'', idmodulo=14, ordem=1000 where ID=102 and descricao=''Clientes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.002'', idmodulo=14, ordem=1100 where ID=101 and descricao=''Fornecedores''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.003'', idmodulo=14, ordem=1200 where ID=37 and descricao=''Entidades''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.004'', idmodulo=14, ordem=1300 where descricao=''Paises''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.005'', idmodulo=14, ordem=1400 where descricao=''Distritos''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.006'', idmodulo=14, ordem=1500 where descricao=''Concelhos''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.007'', idmodulo=14, ordem=1600 where descricao=''CodigosPostais''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.008'', idmodulo=14, ordem=1700 where descricao=''CondicoesPagamento''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.009'', idmodulo=14, ordem=1800 where descricao=''FormasPagamento''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.010'', idmodulo=14, ordem=1900 where descricao=''TiposRelacao''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.011'', idmodulo=14, ordem=2000 where descricao=''Profissoes''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.012'', idmodulo=14, ordem=2100 where descricao=''SegmentosMercado''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.013'', idmodulo=14, ordem=2200 where descricao=''SetoresAtividade''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.014'', idmodulo=14, ordem=2300 where descricao=''TiposContatos''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.015'', idmodulo=14, ordem=2400 where descricao=''TiposFornecimentos''')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=25, descricaoabreviada=''014.005.016'', idmodulo=14, ordem=2500 where descricao=''EntidadesAnexos''')

EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=14, descricao=''CaixaeBancos'', tooltip=''CaixaeBancos'', descricaoabreviada=''014.009'', idmodulo=14, ordem=1000, icon=''fm f3icon-abertura-caixa'' where id=116')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=116, descricaoabreviada=''014.009.001'', idmodulo=14, ordem=1000 where id=44')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=116, descricaoabreviada=''014.009.002'', idmodulo=14, ordem=1100 where id=45')

EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=6, descricaoabreviada=''006.001'', idmodulo=14, ordem=1000 where id=117')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=6, descricaoabreviada=''006.002'', idmodulo=14, ordem=1100 where id=120')

EXEC('update [F3MOGeral].[dbo].tbmenus set descricaoabreviada=''012.001'', ordem=1000 where id=118')
EXEC('update [F3MOGeral].[dbo].tbmenus set descricaoabreviada=''012.002'', ordem=1100 where id=99')
EXEC('update [F3MOGeral].[dbo].tbmenus set descricaoabreviada=''012.004'', ordem=1300 where id=119')

EXEC('update [F3MOGeral].[dbo].tbmenus set descricaoabreviada=''012.002.001'', ordem=1000 where id=100')
EXEC('update [F3MOGeral].[dbo].tbmenus set descricaoabreviada=''012.002.002'', ordem=1100 where id=103')
EXEC('update [F3MOGeral].[dbo].tbmenus set descricaoabreviada=''012.002.003'', ordem=1200 where id=104')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=126)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (126, 12, N''Recalculos'', N''012.003'', N''Recalculos'', 1200, N''fm f3icon-tipoartigos'', N''Accao'', 1, 12, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=126 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) 
VALUES (1, 126, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=126,descricaoabreviada=''012.003.001'', ordem=1000 where id=121')

EXEC('update [F3MOGeral].[dbo].tbmenus set ativo=1 where id=5')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=5 where id=114')
EXEC('update [F3MOGeral].[dbo].tbmenus set idpai=5 where id=115')