/* ACT BD EMPRESA VERSAO 31*/
--nova tabela de configuração de descontos
EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbIVADescontos]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbIVADescontos](
	[ID] [bigint] identity (1,1) NOT NULL,
	[Codigo] [nvarchar](10) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[IDIva] [bigint] NOT NULL,
	[Desconto] [float] NULL,
	[ValorMinimo] [float] NULL,
	[PCM] [bit] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbIVADescontos_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbIVADescontos_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbIVADescontos_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbIVADescontos_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbIVADescontos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbIVADescontos_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbIVADescontos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbIVADescontos]  WITH CHECK ADD  CONSTRAINT [FK_tbIVADescontos_tbIVA] FOREIGN KEY([IDIva])
REFERENCES [dbo].[tbIVA] ([ID])
ON DELETE CASCADE
ALTER TABLE [dbo].[tbIVADescontos] CHECK CONSTRAINT [FK_tbIVADescontos_tbIVA]
END')


--novo campo razaoestado
EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbDocumentosVendas'' AND COLUMN_NAME = ''RazaoEstado'')
Begin
    ALTER TABLE tbDocumentosVendas ADD RazaoEstado nvarchar(50) NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbDocumentosCompras'' AND COLUMN_NAME = ''RazaoEstado'')
Begin
    ALTER TABLE tbDocumentosCompras ADD RazaoEstado nvarchar(50) NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbDocumentosStock'' AND COLUMN_NAME = ''RazaoEstado'')
Begin
    ALTER TABLE tbDocumentosStock ADD RazaoEstado nvarchar(50) NULL
End')

--novo menu configuração de descontos
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=129)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar], [OpenType]) 
VALUES (129, 21, N''IVADescontos'', N''014.001.007'', N''ConfiguracaoDescontos'', 130000, N''f3icon-percent'', N''/Utilitarios/IVADescontos/Index'', 1, 14, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL,2)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=129 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 129, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

--novo menu ver preço de custo
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenusAreasDescricao] where descricao =''OpcoesArtigos'')
BEGIN
insert into [F3MOGeral].[dbo].[tbMenusAreasDescricao] (IDMenuPai, Descricao, DescricaoAbreviada, Activo, Sistema, DataCriacao, UtilizadorCriacao)
values ((SELECT [ID] FROM [F3MOGeral].[dbo].[tbMenus] where descricaoabreviada = ''014.004.001''), ''OpcoesArtigos'', ''OpcoesArtigos'', 1, 0, GETDATE(), ''F3M'')
END
')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbmenusareas] where descricao =''VerPrecoCusto'')
BEGIN
insert into [F3MOGeral].[dbo].tbMenusAreas (IDMenusAreasDescricao, Descricao, DescricaoAbreviada, Ordem, [btnContextoConsultar], Activo, Sistema, DataCriacao, UtilizadorCriacao)
values ((SELECT [ID] FROM [F3MOGeral].[dbo].[tbMenusAreasDescricao] where descricaoabreviada = ''OpcoesArtigos'') , ''VerPrecoCusto'', ''014.004.031'', 1, 1, 1, 0, GETDATE(), ''F3M'')
END
')

EXEC('
DECLARE @IDMenusAreas as bigint
SELECT @IDMenusAreas= ID FROM [F3MOGeral].[dbo].[tbmenusareas] where descricao= ''VerPrecoCusto''
IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreas] WHERE IDMenusAreas=@IDMenusAreas and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreas] ([IDPerfis], [IDMenusAreas], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, @IDMenusAreas, 1, 0, 0, 0, 0, 0, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

EXEC('
DECLARE @IDMenusAreas as bigint
SELECT @IDMenusAreas= ID FROM [F3MOGeral].[dbo].[tbmenusareas] where descricao= ''VerPrecoCusto''
IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreas] WHERE IDMenusAreas=@IDMenusAreas and IDPerfis=2)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreas] ([IDPerfis], [IDMenusAreas], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (2, @IDMenusAreas, 1, 0, 0, 0, 0, 0, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')


--documentos não valorizados
EXEC('
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Documentos de Stock''
update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select TD.Codigo as DescricaoTipoDocumento, D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.Documento as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, 
d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, cast(1 as bit) as PermiteImprimir, td.DocNaoValorizado as DocNaoValorizado,
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
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Documentos de Compras''
update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select TD.Codigo as DescricaoTipoDocumento, D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.documento as Documento, d.VossoNumeroDocumento as VossoNumeroDocumento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, 
d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, cast(1 as bit) as PermiteImprimir, td.DocNaoValorizado as DocNaoValorizado,
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