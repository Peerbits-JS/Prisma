/* ACT BD EMPRESA VERSAO 22*/
EXEC('update [dbo].[tbSistemaTiposDocumentoImportacao] set TipoFiscal= ''NF''  where TipoFiscal=''EC'' and TipoDocSist = ''CmpEncomenda''')
EXEC('update [F3MOGeral].[dbo].[tbmenus] set btnContextoImportar=0 where Descricao=''clientes''')
EXEC('update p set p.importar=0 from [F3MOGeral].[dbo].[tbmenus] m inner join [F3MOGeral].[dbo].[tbPerfisAcessos] p on m.id=p.idmenus where m.Descricao=''clientes''')
EXEC('update [F3MOGeral].[dbo].[tbcolunaslistaspersonalizadas] set visivel=0 where idlistapersonalizada=55 and colunavista=''ValorPendente''')
EXEC('update [F3MOGeral].[dbo].[tbmenus] set ativo=0 where descricao IN(''TiposRelacao'',''TiposContatos'')')
EXEC('update [F3MOGeral].[dbo].[tbmenus] set ativo=1 where id=2')
EXEC('update [F3MOGeral].[dbo].[tbmenus] set descricaoabreviada=''012.007'', ordem=3 where descricao IN (''ImportarFicheiros'')')
EXEC('update [F3MOGeral].[dbo].[tbmenus] set idpai=12, descricaoabreviada=''012.006'', ordem=2, idmodulo=12 where descricao IN (''RecalculoStocks'')')

--novos mapasvistas
EXEC('
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (34, 34, N''FichaConsentimento'', N''FichaConsentimento'', N''rptFichaConsentimento'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, NULL, NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')

--novos campos documentos
EXEC('ALTER TABLE tbDocumentosComprasLinhas ADD ValorDescontoEfetivoSemIva float NULL')
EXEC('ALTER TABLE tbDocumentosComprasLinhas ADD PrecoUnitarioEfetivoSemIva float NULL')
EXEC('ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD ValorDescontoEfetivoSemIva float NULL')
EXEC('ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD PrecoUnitarioEfetivoSemIva float NULL')

EXEC('ALTER TABLE tbDocumentosStockLinhas ADD ValorDescontoEfetivoSemIva float NULL')
EXEC('ALTER TABLE tbDocumentosStockLinhas ADD PrecoUnitarioEfetivoSemIva float NULL')
EXEC('ALTER TABLE tbDocumentosStockLinhasDimensoes ADD ValorDescontoEfetivoSemIva float NULL')
EXEC('ALTER TABLE tbDocumentosStockLinhasDimensoes ADD PrecoUnitarioEfetivoSemIva float NULL')

EXEC('ALTER TABLE tbDocumentosStockLinhas ADD ValorDescontoLinha float NULL')
EXEC('ALTER TABLE tbDocumentosStockLinhasDimensoes ADD ValorDescontoLinha float NULL')
EXEC('ALTER TABLE tbDocumentosVendasLinhasDimensoes ADD ValorDescontoLinha float NULL')
EXEC('ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD ValorDescontoLinha float NULL')


--listas de compras e stocks com a moeda do documento
EXEC('
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Documentos de Compras''
update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select TD.Codigo as DescricaoTipoDocumento, D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.documento as Documento, d.VossoNumeroDocumento as VossoNumeroDocumento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, 
d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, cast(1 as bit) as PermiteImprimir,
convert(tinyint,case when isnull(tbMoedas.ID,0) = 0 then tbMoedasRef.CasasDecimaisTotais else isnull(tbMoedas.CasasDecimaisTotais,0) end) as TotalMoedaDocumentonumcasasdecimais
from tbDocumentosCompras d 
left join tbMoedas as tbMoedas ON tbMoedas.ID=d.IDMoeda
left join tbLojas l on d.IDloja=l.id
left join tbFornecedores c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbSistemaTiposDocumentoFiscal TDF on td.IDSistemaTiposDocumentoFiscal=TDF.ID
left join tbEstados s on d.IDEstado=s.ID
LEFT JOIN tbParametrosEmpresa as P ON 1 = 1
LEFT JOIN tbMoedas as tbMoedasRef ON tbMoedasRef.ID=P.IDMoedaDefeito
''where id in (@IDLista)')

EXEC('
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Documentos de Stock''
update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select TD.Codigo as DescricaoTipoDocumento, D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.Documento as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, 
d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax,
convert(tinyint,case when isnull(tbMoedas.ID,0) = 0 then tbMoedasRef.CasasDecimaisTotais else isnull(tbMoedas.CasasDecimaisTotais,0) end) as TotalMoedaDocumentonumcasasdecimais
from tbDocumentosStock d 
left join tbMoedas as tbMoedas ON tbMoedas.ID=d.IDMoeda
left join tbLojas l on d.IDloja=l.id
left join tbClientes c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbEstados s on d.IDEstado=s.ID
left JOIN tbParametrosEmpresa as P ON 1 = 1
left JOIN tbMoedas as tbMoedasRef ON tbMoedasRef.ID=P.IDMoedaDefeito
''where id in (@IDLista)')

EXEC('
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Liquidação Fornecedores''
update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, D.Assinatura, D.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, d.IDEntidade, 
c.nome as DescricaoEntidade, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as DescricaoSplitterLadoDireito, cast(1 as bit) as PermiteImprimir, 
d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, convert(tinyint,case when isnull(tbMoedas.ID,0) = 0 then tbMoedasRef.CasasDecimaisTotais else isnull(tbMoedas.CasasDecimaisTotais,0) end) as TotalMoedaDocumentonumcasasdecimais 
from tbPagamentosCompras d left join tbLojas l on d.IDloja=l.id left join tbFornecedores c on d.IDEntidade=c.id 
left join tbMoedas as tbMoedas ON tbMoedas.ID=d.IDMoeda
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID 
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID 
left join tbSistemaTiposDocumentoFiscal TDF on td.IDSistemaTiposDocumentoFiscal=TDF.ID 
left join tbEstados s on d.IDEstado=s.ID
left JOIN tbParametrosEmpresa as P ON 1 = 1
left JOIN tbMoedas as tbMoedasRef ON tbMoedasRef.ID=P.IDMoedaDefeito
''where id in (@IDLista)')

-- menu e lista personalizada de marcações e consultório
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=122)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (122, 2, N''Agendamento'', N''002.001'', N''Agendamento'', 1000, N''fm f3icon-calendar'', N''Agendamento/Agendamento'', 1, 2, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=122 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) 
VALUES (1, 122, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=123)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (123, 2, N''Exames'', N''002.002'', N''Exames'', 2000, N''fm f3icon-stethoscope'', N''Exames/Exames'', 1, 2, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=123 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) 
VALUES (1, 123, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Exames'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Exames''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Exames'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbExames'', 
N''select tbexames.ID, tbexames.Ativo, tbexames.Numero as Numero, tbexames.DataExame as DataExame, IDCliente, tbclientes.nome as DescricaoCliente, tbexames.IDMedicoTecnico, tbmedicostecnicos.nome as DescricaoMedicoTecnico, IDEspecialidade, tbespecialidades.descricao as DescricaoEspecialidade, tbexames.IDLoja as IDLoja, tbLojas.descricao as DescricaoLoja, cast(Numero as nvarchar(50)) as DescricaoSplitterLadoDireito  from tbexames left join tbclientes on tbexames.id=tbclientes.id left join tbmedicostecnicos on tbexames.idmedicotecnico=tbmedicostecnicos.id left join tbespecialidades on tbexames.idespecialidade=tbespecialidades.id left join tblojas on tbexames.idloja=tblojas.id'', null, 1)
END')


EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Exames''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE [IDListaPersonalizada]=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tblojas'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DataExame'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tblojas'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Numero'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N'''', 0, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDCliente'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDMedicoTecnico'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbMedicosTecnicos'', 1, 1, 250)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEspecialidade'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbEspecialidades'', 1, 1, 150)
END')


EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=124)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (124, 2, N''Planeamento'', N''002.003'', N''Planeamento'', 3000, N''f3icon-planificacao-horarios'', N''Planeamento/Planeamento'', 1, 2, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=124 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) 
VALUES (1, 124, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

-- tabelas de exames 
CREATE TABLE [dbo].[tbTemplates](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDSistemaTipoTemplate] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[IDLoja] [bigint] NOT NULL,
	[Descricao] [nvarchar](max) NOT NULL DEFAULT ('T1'),
	[Codigo] [nvarchar](6) NOT NULL DEFAULT ('T'),
 CONSTRAINT [PK_tbTemplates] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbTemplates]  WITH CHECK ADD  CONSTRAINT [FK_tbTemplates_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])
ALTER TABLE [dbo].[tbTemplates] CHECK CONSTRAINT [FK_tbTemplates_tbLojas]

CREATE TABLE [dbo].[tbExames](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Numero] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[IDCliente] [bigint] NOT NULL,
	[IDMedicoTecnico] [bigint] NOT NULL,
	[IDEspecialidade] [bigint] NOT NULL,
	[IDLoja] [bigint] NOT NULL,
	[DataExame] [datetime] NOT NULL,
	[IDTemplate] [bigint] NOT NULL DEFAULT ((1)),
 CONSTRAINT [PK_tbExames] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbExames]  WITH CHECK ADD  CONSTRAINT [FK_tbExames_tbClientes] FOREIGN KEY([IDCliente])
REFERENCES [dbo].[tbClientes] ([ID])
ALTER TABLE [dbo].[tbExames] CHECK CONSTRAINT [FK_tbExames_tbClientes]

ALTER TABLE [dbo].[tbExames]  WITH CHECK ADD  CONSTRAINT [FK_tbExames_tbEspecialidades] FOREIGN KEY([IDEspecialidade])
REFERENCES [dbo].[tbEspecialidades] ([ID])
ALTER TABLE [dbo].[tbExames] CHECK CONSTRAINT [FK_tbExames_tbEspecialidades]

ALTER TABLE [dbo].[tbExames]  WITH CHECK ADD  CONSTRAINT [FK_tbExames_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])
ALTER TABLE [dbo].[tbExames] CHECK CONSTRAINT [FK_tbExames_tbLojas]

ALTER TABLE [dbo].[tbExames]  WITH CHECK ADD  CONSTRAINT [FK_tbExames_tbMedicosTecnicos] FOREIGN KEY([IDMedicoTecnico])
REFERENCES [dbo].[tbMedicosTecnicos] ([ID])
ALTER TABLE [dbo].[tbExames] CHECK CONSTRAINT [FK_tbExames_tbMedicosTecnicos]

ALTER TABLE [dbo].[tbExames]  WITH CHECK ADD  CONSTRAINT [FK_tbExames_tbTemplates] FOREIGN KEY([IDTemplate])
REFERENCES [dbo].[tbTemplates] ([ID])
ALTER TABLE [dbo].[tbExames] CHECK CONSTRAINT [FK_tbExames_tbTemplates]

CREATE TABLE [dbo].[tbExamesProps](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDExame] [bigint] NOT NULL,
	[IDPai] [bigint] NULL,
	[TipoComponente] [nvarchar](250) NULL,
	[Ordem] [int] NULL,
	[Label] [nvarchar](250) NULL,
	[StartRow] [int] NULL,
	[EndRow] [int] NULL,
	[StartCol] [int] NULL,
	[EndCol] [int] NULL,
	[AtributosHtml] [nvarchar](100) NULL,
	[ModelPropertyName] [nvarchar](100) NULL,
	[ModelPropertyType] [nvarchar](100) NULL,
	[EObrigatorio] [bit] NULL,
	[EEditavel] [bit] NULL,
	[ValorPorDefeito] [nvarchar](max) NULL,
	[Controlador] [nvarchar](max) NULL,
	[ControladorAcaoExtra] [nvarchar](max) NULL,
	[TabelaBD] [nvarchar](max) NULL,
	[CampoTexto] [nvarchar](255) NULL,
	[FuncaoJSEnviaParametros] [nvarchar](max) NULL,
	[FuncaoJSChange] [nvarchar](max) NULL,
	[ValorID] [nvarchar](max) NULL,
	[ValorDescricao] [nvarchar](max) NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NOT NULL,
	[ViewClassesCSS] [nvarchar](max) NULL,
 CONSTRAINT [PK_tbExamesProps] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbExamesProps]  WITH CHECK ADD  CONSTRAINT [FK_tbExamesProps_tbExames] FOREIGN KEY([IDExame])
REFERENCES [dbo].[tbExames] ([ID])
ALTER TABLE [dbo].[tbExamesProps] CHECK CONSTRAINT [FK_tbExamesProps_tbExames]

ALTER TABLE [dbo].[tbExamesProps]  WITH CHECK ADD  CONSTRAINT [FK_tbExamesProps_tbExamesProps] FOREIGN KEY([IDPai])
REFERENCES [dbo].[tbExamesProps] ([ID])
ALTER TABLE [dbo].[tbExamesProps] CHECK CONSTRAINT [FK_tbExamesProps_tbExamesProps]


CREATE TABLE [dbo].[tbExamesTemplate](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDPai] [bigint] NULL,
	[TipoComponente] [nvarchar](250) NULL,
	[Ordem] [int] NULL,
	[Label] [nvarchar](250) NULL,
	[StartRow] [int] NULL,
	[EndRow] [int] NULL,
	[StartCol] [int] NULL,
	[EndCol] [int] NULL,
	[AtributosHtml] [nvarchar](100) NULL,
	[ModelPropertyName] [nvarchar](100) NULL,
	[ModelPropertyType] [nvarchar](100) NULL,
	[EObrigatorio] [bit] NULL,
	[EEditavel] [bit] NULL,
	[ValorPorDefeito] [nvarchar](max) NULL,
	[Controlador] [nvarchar](max) NULL,
	[ControladorAcaoExtra] [nvarchar](max) NULL,
	[TabelaBD] [nvarchar](max) NULL,
	[CampoTexto] [nvarchar](255) NULL,
	[FuncaoJSEnviaParametros] [nvarchar](max) NULL,
	[FuncaoJSChange] [nvarchar](max) NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NOT NULL,
	[ValorMinimo] [float] NULL,
	[ValorMaximo] [float] NULL,
	[Steps] [float] NULL,
	[IDTemplate] [bigint] NOT NULL DEFAULT ((1)),
	[ViewClassesCSS] [nvarchar](max) NULL,
 CONSTRAINT [PK_tbExamesTemplate] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbExamesTemplate]  WITH CHECK ADD  CONSTRAINT [FK_tbExamesTemplate_tbExamesTemplate] FOREIGN KEY([IDPai])
REFERENCES [dbo].[tbExamesTemplate] ([ID])
ALTER TABLE [dbo].[tbExamesTemplate] CHECK CONSTRAINT [FK_tbExamesTemplate_tbExamesTemplate]

ALTER TABLE [dbo].[tbExamesTemplate]  WITH CHECK ADD  CONSTRAINT [FK_tbExamesTemplate_tbTemplates] FOREIGN KEY([IDTemplate])
REFERENCES [dbo].[tbTemplates] ([ID])
ALTER TABLE [dbo].[tbExamesTemplate] CHECK CONSTRAINT [FK_tbExamesTemplate_tbTemplates]

-- tabelas de agendamento
CREATE TABLE [dbo].[tbAgendamento](
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
	[IDEspecialidade] [bigint] NOT NULL,
	[IDCliente] [bigint] NULL,
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
 CONSTRAINT [PK_tbAgendamento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbAgendamento] ADD  CONSTRAINT [DF_tbAgendamento_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbAgendamento] ADD  CONSTRAINT [DF_tbAgendamento_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbAgendamento] ADD  CONSTRAINT [DF_tbAgendamento_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbAgendamento] ADD  CONSTRAINT [DF_tbAgendamento_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbAgendamento] ADD  CONSTRAINT [DF_tbAgendamento_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbAgendamento] ADD  CONSTRAINT [DF_tbAgendamento_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbAgendamento]  WITH CHECK ADD  CONSTRAINT [FK_tbAgendamento_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])
ALTER TABLE [dbo].[tbAgendamento] CHECK CONSTRAINT [FK_tbAgendamento_tbLojas]

ALTER TABLE [dbo].[tbAgendamento]  WITH CHECK ADD  CONSTRAINT [FK_tbAgendamento_tbMedicosTecnicos] FOREIGN KEY([IDMedicoTecnico])
REFERENCES [dbo].[tbMedicosTecnicos] ([ID])
ALTER TABLE [dbo].[tbAgendamento] CHECK CONSTRAINT [FK_tbAgendamento_tbMedicosTecnicos]

ALTER TABLE [dbo].[tbAgendamento]  WITH CHECK ADD  CONSTRAINT [FK_tbAgendamento_tbEspecialidades] FOREIGN KEY([IDEspecialidade])
REFERENCES [dbo].[tbEspecialidades] ([ID])
ALTER TABLE [dbo].[tbAgendamento] CHECK CONSTRAINT [FK_tbAgendamento_tbEspecialidades]

ALTER TABLE [dbo].[tbAgendamento]  WITH CHECK ADD  CONSTRAINT [FK_tbAgendamento_tbClientes] FOREIGN KEY([IDCliente])
REFERENCES [dbo].[tbClientes] ([ID])
ALTER TABLE [dbo].[tbAgendamento] CHECK CONSTRAINT [FK_tbAgendamento_tbClientes]

EXEC('ALTER TABLE [dbo].[tbExamesTemplate] ADD [NumCasasDecimais] [int] NULL')
EXEC('ALTER TABLE [dbo].[tbExamesProps] ADD [NumCasasDecimais] [int] NULL')
EXEC('ALTER TABLE [dbo].[tbExames] ADD [IDAgendamento] [bigint] NULL')

EXEC('ALTER TABLE [dbo].[tbExames]  WITH CHECK ADD  CONSTRAINT [FK_tbExames_tbAgendamento] FOREIGN KEY([IDAgendamento])
REFERENCES [dbo].[tbAgendamento] ([ID])
ALTER TABLE [dbo].[tbExames] CHECK CONSTRAINT [FK_tbExames_tbAgendamento]')

EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.9.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.9.0'', ''A'', ''2018-06-05 00:00:00.000'', ''2018-06-11 08:00:00.000'', ''Nova versão disponível:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.9.0'', ''V'', ''2018-06-11 08:00:00.000'', ''2018-06-11 08:00:00.000'', ''Funcionalidades da versão'', ''<span><span>Regime Geral Proteção de Dados: </span><ul><li></li><li>Ficha de Consentimento</li><li>Marcação de Consultas</li></ul>'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')

EXEC('update [F3MOGeral].[dbo].[tbMenus] set ativo=0 where id in (123,124)')