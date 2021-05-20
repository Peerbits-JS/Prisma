/* ACT BD EMPRESA VERSAO 30*/
exec('update tbParametrosCamposContexto set valorcampo=1, ValorMax=2, ValorMin=1 where CodigoCampo=''ArtigoTipoDescricao''')

--novos campos
EXEC('ALTER TABLE tbATEstadoComunicacao Alter Column NomeEntidade nvarchar(200) null')

EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE [name] = N''UpdateTbTiposDocumento'' AND [type] = ''TR'')
BEGIN
      DROP TRIGGER [dbo].[UpdateTbTiposDocumento]
END')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbMapaCaixa'' AND COLUMN_NAME = ''Transporte'')
Begin
    ALTER TABLE [dbo].[tbMapaCaixa] ADD [Transporte] [float] NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbMapaCaixa'' AND COLUMN_NAME = ''Estado'')
Begin
    ALTER TABLE [dbo].[tbMapaCaixa] ADD [Estado] [nvarchar](10) NULL
End')

--nova tabela galeria de fotos
EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbExamesPropsFotos]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbExamesPropsFotos](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [IDExame] [bigint] NOT NULL,
    [Foto] [nvarchar](255) NOT NULL,
    [FotoCaminho] [nvarchar](max) NOT NULL,
    [Ordem] [int] NULL,
    [Ativo] [bit] NOT NULL,
    [Sistema] [bit] NOT NULL,
    [DataCriacao] [datetime] NOT NULL,
    [UtilizadorCriacao] [nvarchar](256) NOT NULL,
    [DataAlteracao] [datetime] NULL,
    [UtilizadorAlteracao] [nvarchar](256) NULL,
    [F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbExamesPropsFotos] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 
ALTER TABLE [dbo].[tbExamesPropsFotos] ADD  CONSTRAINT [DF_tbExamesPropsFotos_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbExamesPropsFotos] ADD  CONSTRAINT [DF_tbExamesPropsFotos_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbExamesPropsFotos] ADD  CONSTRAINT [DF_tbExamesPropsFotos_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbExamesPropsFotos] ADD  CONSTRAINT [DF_tbExamesPropsFotos_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbExamesPropsFotos] ADD  CONSTRAINT [DF_tbExamesPropsFotos_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbExamesPropsFotos] ADD  CONSTRAINT [DF_tbExamesPropsFotos_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]
ALTER TABLE [dbo].[tbExamesPropsFotos]  WITH CHECK ADD  CONSTRAINT [FK_tbExamesPropsFotos_tbExames] FOREIGN KEY([IDExame])
REFERENCES [dbo].[tbExames] ([ID])
ALTER TABLE [dbo].[tbExamesPropsFotos] CHECK CONSTRAINT [FK_tbExamesPropsFotos_tbExames]
END')

--Caminho da abertura/fecho de caixa
exec('UPDATE [F3MOGeral].dbo.tbMenus SET Descricao=''AberturaFechoCaixa'', ToolTip='''', Accao=''/Caixas/AberturaFechoCaixa'' WHERE DescricaoAbreviada=''006.001''')
exec('update [F3MOGeral].dbo.tbmenus set ativo=0 where descricao in (''ParametrosContextoLoja'', ''ParametrosContexto'')')
exec('update [F3MOGeral].dbo.tbmenus set descricaoabreviada=''015.003.001'', idpai=18 where descricao in (''ParametrosEmpresa'')')
exec('update [F3MOGeral].dbo.tbmenus set btncontextoadicionar=0, btncontextoremover=0, btncontextoexportar=0, btncontextoimprimir=0  where descricao in (''ParametrosEmpresa'', ''ParametrosLoja'')')

exec('update [F3MOGeral].dbo.tbmenus set ativo=1 where id in (93,94)')
exec('update [F3MOGeral].dbo.tbperfisacessos set ativo=1 where idmenus in (93,94)')
exec('update [F3MOGeral].dbo.tbmenus set ativo=0 where ID in (19,79)')
exec('update [F3MOGeral].dbo.tbperfisacessos set ativo=0 where idmenus in (19,79)')

--Coluna IDLoja tbArtigosPrecos
EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbArtigosPrecos'' AND COLUMN_NAME = ''IDLoja'') 
Begin
ALTER TABLE [dbo].[tbArtigosPrecos] ADD [IDLoja] [bigint] NULL
ALTER TABLE [dbo].[tbArtigosPrecos]  WITH CHECK ADD  CONSTRAINT [FK_tbArtigosPrecos_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])
ALTER TABLE [dbo].[tbArtigosPrecos] CHECK CONSTRAINT [FK_tbArtigosPrecos_tbLojas]
End')

--Constraint tbArtigosPrecos
EXEC('DROP INDEX [IX_tbArtigosPrecos] ON [dbo].[tbArtigosPrecos]')

EXEC('CREATE UNIQUE NONCLUSTERED INDEX [IX_tbArtigosPrecos] ON [dbo].[tbArtigosPrecos]
(
    [IDCodigoPreco] ASC,
    [IDUnidade] ASC,
    [IDArtigo] ASC,
	[IDLoja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')
 
 --separador de fotos
EXEC('DELETE FROM tbExamesTemplate where ID in (1365,2388)
SET IDENTITY_INSERT [dbo].[tbExamesTemplate] ON 
INSERT [dbo].[tbExamesTemplate] ([ID], [IDPai], [TipoComponente], [Ordem], [Label], [StartRow], [EndRow], [StartCol], [EndCol], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [TabelaBD], [CampoTexto], [FuncaoJSEnviaParametros], [FuncaoJSChange], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorMinimo], [ValorMaximo], [Steps], [IDTemplate], [ViewClassesCSS], [NumCasasDecimais], [IDElemento], [FuncaoJSOnClick], [EEditavelEdicao], [DesenhaBotaoLimpar], [ECabecalho], [EVisivel], [ComponentTag]) VALUES (1365, 729, NULL, 450, N''Fotos'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, CAST(N''2018-05-29 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL, NULL, 2, NULL, NULL, N''CT_TAB_Fotos'', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbExamesTemplate] ([ID], [IDPai], [TipoComponente], [Ordem], [Label], [StartRow], [EndRow], [StartCol], [EndCol], [AtributosHtml], [ModelPropertyName], [ModelPropertyType], [EObrigatorio], [EEditavel], [ValorPorDefeito], [Controlador], [ControladorAcaoExtra], [TabelaBD], [CampoTexto], [FuncaoJSEnviaParametros], [FuncaoJSChange], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorMinimo], [ValorMaximo], [Steps], [IDTemplate], [ViewClassesCSS], [NumCasasDecimais], [IDElemento], [FuncaoJSOnClick], [EEditavelEdicao], [DesenhaBotaoLimpar], [ECabecalho], [EVisivel], [ComponentTag]) VALUES (2388, 1365, N''F3MFotoGrid'', 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, CAST(N''2018-05-29 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL, NULL, 2, NULL, NULL, N''DG_RF_OBS'', NULL, NULL, NULL, NULL, NULL, N''AO_OBS'')
SET IDENTITY_INSERT [dbo].[tbExamesTemplate] OFF')

--Ver documentos de outras lojas
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenusAreasDescricao] where descricao =''Opcoes'')
BEGIN
insert into [F3MOGeral].[dbo].[tbMenusAreasDescricao] (IDMenuPai, Descricao, DescricaoAbreviada, Activo, Sistema, DataCriacao, UtilizadorCriacao)
values ((SELECT [ID] FROM [F3MOGeral].[dbo].[tbMenus] where descricaoabreviada = ''015.005''), ''Opcoes'', ''Opcoes'', 1, 0, GETDATE(), ''F3M'')
END
')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbmenusareas] where descricao =''DocumentosOutrasLojas'')
BEGIN
insert into [F3MOGeral].[dbo].tbMenusAreas (IDMenusAreasDescricao, Descricao, DescricaoAbreviada, Ordem, [btnContextoConsultar], Activo, Sistema, DataCriacao, UtilizadorCriacao)
values ((SELECT [ID] FROM [F3MOGeral].[dbo].[tbMenusAreasDescricao] where descricaoabreviada = ''Opcoes'') , ''DocumentosOutrasLojas'', ''015.005.003'', 1, 1, 1, 0, GETDATE(), ''F3M'')
END
')

EXEC('
DECLARE @IDMenusAreas as bigint
SELECT @IDMenusAreas= ID FROM [F3MOGeral].[dbo].[tbmenusareas] where descricao= ''DocumentosOutrasLojas''
IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreas] WHERE IDMenusAreas=@IDMenusAreas and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreas] ([IDPerfis], [IDMenusAreas], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, @IDMenusAreas, 1, 0, 0, 0, 0, 0, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

EXEC('
DECLARE @IDMenusAreas as bigint
SELECT @IDMenusAreas= ID FROM [F3MOGeral].[dbo].[tbmenusareas] where descricao= ''DocumentosOutrasLojas''
IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreas] WHERE IDMenusAreas=@IDMenusAreas and IDPerfis=2)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreas] ([IDPerfis], [IDMenusAreas], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (2, @IDMenusAreas, 1, 0, 0, 0, 0, 0, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

EXEC('
IF NOT EXISTS(SELECT ID FROM [F3MOGeral].[dbo].[tbMenusAreasEmpresa] where descricao= ''Analises'' )
BEGIN
INSERT INTO [F3MOGeral].[dbo].[tbMenusAreasEmpresa] ([IDMenuPai], [IDEmpresa], [Descricao], [DescricaoAbreviada], [Tabela], [Ordem],
			[btnContextoConsultar], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoRemover], 
			[btnContextoImprimir], [btnContextoExportar], [btnContextoF4], [btnContextoImportar], [btnContextoDuplicar],
			[Activo], [Sistema], [DataCriacao], [UtilizadorCriacao], [IDPaiAreaEmpresa], [CampoDescricao], [CampoRelacaoPai])
VALUES ((SELECT [ID] FROM [F3MOGeral].[dbo].[tbMenus] where Descricao = ''Consultas''), 1, ''Analises'', ''Analises'', ''tbListasPersonalizadas'',
			4, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, GETDATE(), ''F3M'', null, ''Descricao'', null)
END')


--atualizar listas personalizadas de artigos
exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select u.codigo as unidade, l.id as idloja, isnull(st.QuantidadeStock,0) as QuantidadeStock, tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo 
from tbartigos left join tblojas l on l.id>0 left join tbstockartigos st on tbartigos.id=st.IDArtigo and l.id=st.IDLoja left join tbunidades u on tbartigos.idunidade=u.id 
left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo and ap.idcodigopreco=1 and (st.idloja=ap.IDLoja or ap.idloja is null) left join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id 
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=39')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select u.codigo as unidade, l.id as idloja, isnull(st.QuantidadeStock,0) as QuantidadeStock, 
tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo 
from tbartigos left join tblojas l on l.id>0 left join tbstockartigos st on tbartigos.id=st.IDArtigo and l.id=st.IDLoja left join tbunidades u on tbartigos.idunidade=u.id 
left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo and ap.idcodigopreco=1 and (st.idloja=ap.IDLoja or ap.idloja is null) 
inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id 
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=63')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select u.codigo as unidade, l.id as idloja, isnull(st.QuantidadeStock,0) as QuantidadeStock, 
tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, mo.Descricao as DescricaoModelo, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo, 
tb.Tamanho , tb.CodigoCor, tb.CorGenerica, tb.CorLente
from tbartigos left join tblojas l on l.id>0 left join tbstockartigos st on tbartigos.id=st.IDArtigo and l.id=st.IDLoja left join tbunidades u on tbartigos.idunidade=u.id 
left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo and ap.idcodigopreco=1 and (st.idloja=ap.IDLoja or ap.idloja is null) 
inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id 
inner join tbAros tb on tbartigos.id=tb.IDArtigo
left join tbModelos mo on tb.IDModelo=mo.id
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=59')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select u.codigo as unidade, l.id as idloja, isnull(st.QuantidadeStock,0) as QuantidadeStock, 
tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, mo.Descricao as DescricaoModelo, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo, 
tb.Tamanho , tb.CodigoCor, tb.CorGenerica, tb.CorLente
from tbartigos left join tblojas l on l.id>0 left join tbstockartigos st on tbartigos.id=st.IDArtigo and l.id=st.IDLoja left join tbunidades u on tbartigos.idunidade=u.id 
left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo and ap.idcodigopreco=1 and (st.idloja=ap.IDLoja or ap.idloja is null) 
inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id 
inner join tbOculosSol tb on tbartigos.id=tb.IDArtigo
left join tbModelos mo on tb.IDModelo=mo.id
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=62')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select u.codigo as unidade, l.id as idloja, isnull(st.QuantidadeStock,0) as QuantidadeStock, 
tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, mo.Descricao as DescricaoModelo, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo, 
tb.raio, tb.Diametro, isnull(tb.PotenciaCilindrica,0) as PotenciaCilindrica, isnull(tb.PotenciaEsferica,0) as PotenciaEsferica, isnull(tb.Eixo,0) as Eixo, isnull(tb.Adicao,0) as Adicao
from tbartigos left join tblojas l on l.id>0 left join tbstockartigos st on tbartigos.id=st.IDArtigo and l.id=st.IDLoja left join tbunidades u on tbartigos.idunidade=u.id 
left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo and ap.idcodigopreco=1 and (st.idloja=ap.IDLoja or ap.idloja is null) 
inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id 
inner join tbLentesContato tb on tbartigos.id=tb.IDArtigo
left join tbModelos mo on tb.IDModelo=mo.id
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=61')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select u.codigo as unidade, l.id as idloja, isnull(st.QuantidadeStock,0) as QuantidadeStock, 
tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, mo.Descricao as DescricaoModelo, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo, 
tb.Diametro, isnull(tb.PotenciaCilindrica,0) as PotenciaCilindrica, isnull(tb.PotenciaEsferica,0) as PotenciaEsferica, isnull(tb.PotenciaPrismatica,0) as PotenciaPrismatica, isnull(tb.Adicao,0) as Adicao
from tbartigos left join tblojas l on l.id>0 left join tbstockartigos st on tbartigos.id=st.IDArtigo and l.id=st.IDLoja left join tbunidades u on tbartigos.idunidade=u.id 
left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo and ap.idcodigopreco=1 and (st.idloja=ap.IDLoja or ap.idloja is null) 
inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id 
inner join tbLentesoftalmicas tb on tbartigos.id=tb.IDArtigo
left join tbModelos mo on tb.IDModelo=mo.id
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=60')

--ver documentos de outras lojas
EXEC('
DECLARE @IDMenusAreas as bigint
SELECT @IDMenusAreas= ID FROM [F3MOGeral].[dbo].[tbmenusareas] where descricao= ''DocumentosOutrasLojas''
IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreas] WHERE IDMenusAreas=@IDMenusAreas and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreas] ([IDPerfis], [IDMenusAreas], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, @IDMenusAreas, 1, 0, 0, 0, 0, 0, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

EXEC('
DECLARE @IDMenusAreas as bigint
SELECT @IDMenusAreas= ID FROM [F3MOGeral].[dbo].[tbmenusareas] where descricao= ''DocumentosOutrasLojas''
IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessosAreas] WHERE IDMenusAreas=@IDMenusAreas and IDPerfis=2)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreas] ([IDPerfis], [IDMenusAreas], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (2, @IDMenusAreas, 1, 0, 0, 0, 0, 0, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

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

--análises por defeito
EXEC('
DECLARE @IDMenusAreas as bigint
SELECT @IDMenusAreas= ID FROM [F3MOGeral].[dbo].[tbMenusAreasEmpresa] where descricao= ''Analises''
UPDATE [F3MOGeral].[dbo].[tbPerfisAcessosAreasempresa] SET Consultar=1 WHERE IDMenusAreasEmpresa=@IDMenusAreas 
')

--aviso de nova versão
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.12.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.12.0'', ''A'', ''2018-10-03 00:00'', ''2018-10-08 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.12.0'', ''V'', ''2018-10-08 08:00'', ''2018-10-08 08:00'', ''Funcionalidades da versão'', ''
    <li>CAIXA – Controlo de Abertura e Fecho nos Recebimentos</li>
    <li>PVP POR LOJA – Possibilidade de definição de preços de venda por Loja</li>
    <li>PERMISSÕES – Visualização de documentos de outras Lojas</li>
    <li>PERMISSÕES – Acesso a análises por consulta</li>
    <li>GABINETE – Consultas Possibilidade de inclusão de Fotos</li>'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')

--lista personalizada de documentos
EXEC('
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Documentos de Stock''
update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select TD.Codigo as DescricaoTipoDocumento, D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.Documento as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, 
d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, cast(1 as bit) as PermiteImprimir,
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


--lista personalizada de movimentos de stock
exec('update [F3MOGeral].dbo.tbListasPersonalizadas set 
query=''select Distinct D.Descricao as Descricao, D.Descricao as Documento, D.ID, D.Ativo, D.IDTipoDocumentoSeries, d.IDTipoDocumento, D.IDDocumento, D.NumeroDocumento, D.IDFormaPagamento, FP.Descricao as DescricaoFormaPagamento, D.IDLoja as IDLoja, l.Descricao as DescricaoLoja, (case when D.Natureza=''''P'''' then ''''Entrada'''' else ''''Saída'''' end) as Natureza, DataDocumento, D.IDMoeda, D.TotalMoeda, d.TotalMoedareferencia, D.Descricao as DescricaoSplitterLadoDireito 
from tbmapacaixa d 
left join tbLojas l on d.IDloja=l.id 
inner join tbTiposDocumento TD on d.IDTipoDocumento is null and (d.numerodocumento is null or d.numerodocumento='''''''')
inner join tbFormasPagamento FP on d.IDFormaPagamento=FP.ID
''
where Descricao=''Movimentos de Caixa'' ')
