/* ACT BD EMPRESA VERSAO 42*/
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbServicosFases]'') AND type in (N''U'')) DROP TABLE [dbo].[tbServicosFases]')
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbTiposFases]'') AND type in (N''U'')) DROP TABLE [dbo].[tbTiposFases]')
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbSistemaTiposFases]'') AND type in (N''U'')) DROP TABLE [dbo].[tbSistemaTiposFases]')

EXEC('
CREATE TABLE [dbo].[tbTiposFases](
	[ID]  [bigint] identity(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[IDSistemaClassificacoesTiposArtigos] [bigint] NULL,
	[IDSistemaTiposOlhos] [bigint] NULL,
 CONSTRAINT [PK_tbTiposFases] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbTiposFases] ADD  CONSTRAINT [DF_tbTiposFases_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbTiposFases] ADD  CONSTRAINT [DF_tbTiposFases_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbTiposFases] ADD  CONSTRAINT [DF_tbTiposFases_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbTiposFases]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposFases_tbSistemaClassificacoesTiposArtigos] FOREIGN KEY ([IDSistemaClassificacoesTiposArtigos])
REFERENCES [dbo].[tbSistemaClassificacoesTiposArtigos] ([ID])

ALTER TABLE [dbo].[tbTiposFases] CHECK CONSTRAINT [FK_tbTiposFases_tbSistemaClassificacoesTiposArtigos]

ALTER TABLE [dbo].[tbTiposFases]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposFases_tbSistemaTiposOlhos] FOREIGN KEY ([IDSistemaTiposOlhos])
REFERENCES [dbo].[tbSistemaTiposOlhos] ([ID])
ALTER TABLE [dbo].[tbTiposFases] CHECK CONSTRAINT [FK_tbTiposFases_tbSistemaTiposOlhos]
')

EXEC('CREATE TABLE [dbo].[tbServicosFases](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTipoFase] [bigint] NOT NULL,
	[IDServico] [bigint] NOT NULL,
	[IDTipoServico] [bigint] NULL,
	[Data] [datetime] NULL,
	[Observacoes] [nvarchar](max) NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbServicosFases] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbServicosFases] ADD  CONSTRAINT [DF_tbServicosFases_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbServicosFases] ADD  CONSTRAINT [DF_tbServicosFases_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbServicosFases] ADD  CONSTRAINT [DF_tbServicosFases_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbServicosFases]  WITH CHECK ADD  CONSTRAINT [FK_tbServicosFases_tbServicos] FOREIGN KEY([IDServico])
REFERENCES [dbo].[tbServicos] ([ID])
ALTER TABLE [dbo].[tbServicosFases] CHECK CONSTRAINT [FK_tbServicosFases_tbServicos]
ALTER TABLE [dbo].[tbServicosFases]  WITH CHECK ADD  CONSTRAINT [FK_tbServicosFases_tbTiposFases] FOREIGN KEY([IDTipoFase])
REFERENCES [dbo].[tbTiposFases] ([ID])
ALTER TABLE [dbo].[tbServicosFases] CHECK CONSTRAINT [FK_tbServicosFases_tbTiposFases]
ALTER TABLE [dbo].[tbServicosFases]  WITH CHECK ADD  CONSTRAINT [FK_tbServicosFases_tbSistemaTiposServicos] FOREIGN KEY([IDTipoServico])
REFERENCES [dbo].[tbSistemaTiposServicos] ([ID])
ALTER TABLE [dbo].[tbServicosFases] CHECK CONSTRAINT [FK_tbServicosFases_tbSistemaTiposServicos]
')

EXEC('CREATE TABLE [dbo].[tbSistemaTiposFases](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NOT NULL,
 CONSTRAINT [PK_tbSistemaTiposFases] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbSistemaTiposFases] ADD  CONSTRAINT [DF_tbSistemaTiposFases_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbSistemaTiposFases] ADD  CONSTRAINT [DF_tbSistemaTiposFases_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbSistemaTiposFases] ADD  CONSTRAINT [DF_tbSistemaTiposFases_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE tbTiposFases ADD IDSistemaTiposFases BIGINT  NULL 

ALTER TABLE [dbo].[tbTiposFases]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposFases_tbSistemaTiposFases] FOREIGN KEY([IDSistemaTiposFases])
REFERENCES [dbo].[tbSistemaTiposFases] ([ID])
ALTER TABLE [dbo].[tbTiposFases] CHECK CONSTRAINT [FK_tbTiposFases_tbSistemaTiposFases]
')

EXEC('DELETE FROM [dbo].[tbSistemaTiposFases]')
EXEC('INSERT [dbo].[tbSistemaTiposFases] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N''P'', N''Pedido'', 1, 1, CAST(N''2019-05-15T00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)')
EXEC('INSERT [dbo].[tbSistemaTiposFases] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N''R'', N''Receção'', 1, 1, CAST(N''2019-05-15T00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)')
EXEC('INSERT [dbo].[tbSistemaTiposFases] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (5, N''MT'', N''Montagem'', 1, 1, CAST(N''2019-05-15T00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)')
EXEC('INSERT [dbo].[tbSistemaTiposFases] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (6, N''CT'', N''Controlo'', 1, 1, CAST(N''2019-05-15T00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)')
EXEC('INSERT [dbo].[tbSistemaTiposFases] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (7, N''CI'', N''ClienteInformado'', 1, 1, CAST(N''2019-05-15T00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)')
EXEC('INSERT [dbo].[tbSistemaTiposFases] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (8, N''ET'', N''Entrega'', 1, 1, CAST(N''2019-05-15T00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL)')

EXEC('DELETE FROM [dbo].[tbTiposFases]')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LOPA'', N''Pedido AR'', 10, 0, 1, CAST(N''2019-05-15T17:44:03.297'' AS DateTime), N''F3M'', CAST(N''2019-05-15T17:46:09.080'' AS DateTime), N''F3M'', 1, 3, 1)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LORA'', N''Receção AR'', 40, 0, 1, CAST(N''2019-05-15T17:44:42.787'' AS DateTime), N''F3M'', CAST(N''2019-05-15T17:57:14.290'' AS DateTime), N''F3M'', 1, 3, 3)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LOMT'', N''Montagem'', 70, 0, 1, CAST(N''2019-05-15T17:45:50.880'' AS DateTime), N''F3M'', CAST(N''2019-05-15T17:57:00.420'' AS DateTime), N''F3M'', 1, NULL, 5)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LOCT'', N''Controlo'', 80, 0, 1, CAST(N''2019-05-15T17:46:50.293'' AS DateTime), N''F3M'', CAST(N''2019-05-15T17:56:31.233'' AS DateTime), N''F3M'', 1, NULL, 6)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LOCI'', N''Cliente Informado'', 90, 0, 1, CAST(N''2019-05-15T17:47:15.513'' AS DateTime), N''F3M'', CAST(N''2019-05-15T17:56:26.337'' AS DateTime), N''F3M'', 1, NULL, 7)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LOET'', N''Entrega'', 100, 0, 1, CAST(N''2019-05-15T17:47:43.837'' AS DateTime), N''F3M'', CAST(N''2019-05-15T17:56:21.277'' AS DateTime), N''F3M'', 1, NULL, 8)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LOPE'', N''Pedido Lente OE'', 20, 0, 1, CAST(N''2019-05-15T18:00:25.723'' AS DateTime), N''F3M'', NULL, NULL, 1, 2, 1)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LOPD'', N''Pedido Lente OD'', 30, 0, 1, CAST(N''2019-05-15T18:00:46.393'' AS DateTime), N''F3M'', CAST(N''2019-05-15T18:00:58.797'' AS DateTime), N''F3M'', 1, 1, 1)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LORE'', N''Receção Lente OE'', 50, 0, 1, CAST(N''2019-05-15T18:02:12.577'' AS DateTime), N''F3M'', NULL, NULL, 1, 2, 3)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LORD'', N''Receção Lente OD'', 60, 0, 1, CAST(N''2019-05-15T18:02:36.693'' AS DateTime), N''F3M'', NULL, NULL, 1, 1, 3)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LCPE'', N''Pedido Lente OE'', 10, 0, 1, CAST(N''2019-05-15T18:04:02.873'' AS DateTime), N''F3M'', CAST(N''2019-05-15T18:06:38.087'' AS DateTime), N''F3M'', 3, 2, 1)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LCPD'', N''Pedido Lente OD'', 20, 0, 1, CAST(N''2019-05-15T18:04:33.267'' AS DateTime), N''F3M'', NULL, NULL, 3, 1, 1)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LCRE'', N''Receção Lente OE'', 30, 0, 1, CAST(N''2019-05-15T18:05:03.880'' AS DateTime), N''F3M'', NULL, NULL, 3, 2, 3)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LCRD'', N''Receção Lente OD'', 40, 0, 1, CAST(N''2019-05-15T18:05:27.543'' AS DateTime), N''F3M'', NULL, NULL, 3, 1, 3)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LCCI'', N''Cliente Informado'', 50, 0, 1, CAST(N''2019-05-15T18:06:16.250'' AS DateTime), N''F3M'', NULL, NULL, 3, NULL, 7)')
EXEC('INSERT [dbo].[tbTiposFases] ([Codigo], [Descricao], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDSistemaClassificacoesTiposArtigos], [IDSistemaTiposOlhos], [IDSistemaTiposFases]) VALUES (N''LCET'', N''Entrega'', 60, 0, 1, CAST(N''2019-05-15T18:06:31.943'' AS DateTime), N''F3M'', NULL, NULL, 3, NULL, 8)')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=138)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (138, 21, N''TiposFases'', N''014.001.014'', N''TiposFases'', 130000, N''f3icon-list-ol'', N''/TabelasAuxiliares/TiposFases'', 1, 14, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=138 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 138, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, 1)
END')


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
	AND (CAST(FLOOR(CAST(E.DataExame AS float)) AS datetime) <= @DataAte OR @DataAte IS NULL)
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
	AND (CAST(FLOOR(CAST(E.DataExame AS float)) AS datetime) <= @DataAte OR @DataAte IS NULL)
	AND (E.IDLoja = @IDLoja OR @IDLoja IS NULL)
GROUP BY E.IDMedicoTecnico
)
')

--lista personalizada
exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select u.codigo as unidade, l.id as idloja, isnull(st.QuantidadeStock,0) as QuantidadeStock, 
tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, mo.Descricao as DescricaoModelo, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca,
(case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo, 
tb.Diametro, isnull(tb.PotenciaCilindrica,0) as PotenciaCilindrica, isnull(tb.PotenciaEsferica,0) as PotenciaEsferica, isnull(tb.PotenciaPrismatica,0) as PotenciaPrismatica, isnull(tb.Adicao,0) as Adicao
from tbartigos left join tblojas l on l.id>0 left join tbstockartigos st on tbartigos.id=st.IDArtigo and l.id=st.IDLoja left join tbunidades u on tbartigos.idunidade=u.id 
left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo and ap.idcodigopreco=1 and (st.idloja=ap.IDLoja or (ap.idloja is null and not ap.idcodigopreco is null)) 
inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id 
inner join tbLentesoftalmicas tb on tbartigos.id=tb.IDArtigo
left join tbModelos mo on tb.IDModelo=mo.id
left join tbmarcas m on tbartigos.idmarca=m.id''
where id=60')

--aviso de nova versão
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.18.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.18.0'', ''A'', ''2019-06-04 00:00'', ''2019-06-11 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.18.0'', ''V'', ''2019-06-11 08:00'', ''2019-06-11 08:00'', ''Funcionalidades da versão'', ''
<li>Exportação para a contabilidade - novas funcionalidades</li>
<li>Último preço e custo médio - Incluir ou não descontos comerciais</li>
<li>Permissão de utilizador - Ver preços de custo de artigos</li>
<li>Serviços - Histórico de documentos associados</li>
<li>Clientes - Novas colunas na grelha</li>
<li>Lojas - Valores por defeito na criação</li>
<li>Módulo de Oficina - Estados de Serviço</li>
'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')