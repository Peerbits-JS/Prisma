/* ACT BD EMPRESA VERSAO 55*/

--alterar função de inventário
EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnInventarioData]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnInventarioData]')

EXEC('CREATE FUNCTION [dbo].[fnInventarioData] (@Data as date, @IDValorizado as int)
RETURNS TABLE
AS
RETURN (
	   select @Data as Data, cc.idartigo, CodigoArtigo, DescricaoArtigo, CodigoTipoArtigo, DescricaoTipoArtigo, CodigoMarca, DescricaoMarca,cc.IDArmazem, CodigoArmazem, DescricaoArmazem, 
	   cc.IDArmazemLocalizacao, CodigoArmazemLocalizacao, DescricaoArmazemLocalizacao, CodigoLote, DescricaoLote, UltimaEntrada, UltimaSaida, Quantidade, isnull(Medio,0) as Medio, isnull(UltimoPrecoCompra,0) as UltimoPrecoCompra, isnull(CustoPadrao,0) as CustoPadrao, 
	   (case when @IDValorizado=12 then isnull(CustoPadrao,0) when @IDValorizado=13 then isnull(Medio,0) when @IDValorizado=14 then isnull(UltimoPrecoCompra,0) else Preco end) as Preco, 
	   (case when @IDValorizado=12 then isnull(CustoPadrao,0) when @IDValorizado=13 then isnull(Medio,0) when @IDValorizado=14 then isnull(UltimoPrecoCompra,0) else Preco end)*Quantidade as TotalMoeda,
	   Ativo, Gerestock, Inventariado, 
	   Codigofornecedor, DescricaoFornecedor, 2 as Quantidadenumcasasdecimais, 3 as Preconumcasasdecimais, 3 as TotalMoedanumcasasdecimais  
	   from (select ar.id as idartigo, ar.codigo as CodigoArtigo, ar.Descricao as DescricaoArtigo, ta.codigo as CodigoTipoArtigo, ta.Descricao as DescricaoTipoArtigo, ma.codigo as CodigoMarca, ma.Descricao as DescricaoMarca, 
		isnull(ar.Padrao,0) as CustoPadrao, isnull(ap.valorcomiva,0) as Preco, ar.ativo, ar.gerestock, ar.inventariado, isnull(f.Codigo,'''') as CodigoFornecedor, isnull(f.Nome,'''') as DescricaoFornecedor
		from tbartigos ar 
		LEFT JOIN tbtiposartigos AS ta ON ta.ID = ar.IDtipoartigo
		LEFT JOIN tbMarcas AS ma ON ma.ID = ar.IDmarca
		left join tbartigosprecos ap on ar.id=ap.idartigo and ap.idcodigopreco=@IDValorizado-1 and ap.idloja is null
		left join tbartigosfornecedores af on ar.id=af.idartigo and af.ordem=1
		left join tbfornecedores f on f.id=af.idfornecedor) a

		inner join
		(select idartigo, IDArmazem, IDArmazemLocalizacao,  
		max((Case Natureza when ''E'' then DataDocumento else null end)) as UltimaEntrada, 
		max((Case Natureza when ''S'' then DataDocumento else null end)) as UltimaSaida
		FROM tbCCStockArtigos  
		where DataDocumento<dateadd(d,1,@Data)
		group by idartigo, IDArmazem, IDArmazemLocalizacao) b on a.idartigo=b.idartigo
		
		left join
		(Select idartigo, UltimoPrecoCompra from (select idartigo, isnull(UPCMoedaRef,0) as UltimoPrecoCompra, ROW_NUMBER() OVER (PARTITION BY IDArtigo Order by DataDocumento desc, tbCCStockArtigos.id desc) as lin 
		from tbCCStockArtigos inner join tbTiposDocumento on tbCCStockArtigos.IDTipoDocumento=tbTiposDocumento.id where datadocumento<dateadd(d,1,@Data) and tbTiposDocumento.CustoMedio=1) p where p.lin=1) c on a.idartigo=c.idartigo

		left join
		(Select idartigo, Medio from (select idartigo, isnull(PCMAtualMoedaRef,0) as Medio, ROW_NUMBER() OVER (PARTITION BY IDArtigo Order by DataDocumento desc, tbCCStockArtigos.id desc) as lin 
		from tbCCStockArtigos inner join tbTiposDocumento on tbCCStockArtigos.IDTipoDocumento=tbTiposDocumento.id where datadocumento<dateadd(d,1,@Data) and tbTiposDocumento.CustoMedio=1) p where p.lin=1) d on a.idartigo=d.idartigo

		left join
		(select tbCCStockArtigos.IDArtigo, tbCCStockArtigos.IDArmazem, tbCCStockArtigos.IDArmazemLocalizacao, 
		tbArmazens.Codigo as CodigoArmazem, tbArmazens.Descricao as DescricaoArmazem,
		tbArmazensLocalizacoes.Codigo as CodigoArmazemLocalizacao, tbArmazensLocalizacoes.Descricao as DescricaoArmazemLocalizacao,
		tbArtigosLotes.Codigo as CodigoLote, tbArtigosLotes.Descricao as DescricaoLote,
		isnull(Sum((Case tbCCStockArtigos.Natureza when ''E'' then 1 else -1 end) * tbCCStockArtigos.Quantidade),0) as Quantidade 
		FROM tbCCStockArtigos left join tbArmazens on tbCCStockArtigos.IDArmazem=tbArmazens.id 
		left join tbArmazensLocalizacoes on tbCCStockArtigos.IDArmazemLocalizacao=tbArmazensLocalizacoes.id
		left join tbArtigosLotes on tbCCStockArtigos.IDArtigoLote=tbArtigosLotes.id
		where DataDocumento<dateadd(d,1,@Data)
		group by tbCCStockArtigos.IDArtigo, tbCCStockArtigos.IDArmazem, tbCCStockArtigos.IDArmazemLocalizacao, tbArmazens.Codigo, tbArmazens.Descricao ,
		tbArmazensLocalizacoes.Codigo , tbArmazensLocalizacoes.Descricao,tbArtigosLotes.Codigo, tbArtigosLotes.Descricao) cc
		on b.idartigo=cc.idartigo and b.IDArmazem=cc.idarmazem and b.IDArmazemLocalizacao=cc.IDArmazemLocalizacao
)')

-- Novo Menu de SMS
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral]..tbMenus WHERE Descricao = ''ComunicacaoSms'')
BEGIN
	DECLARE @IDModulo as bigint
	SELECT @IDModulo = ID FROM [F3MOGeral]..tbModulos WHERE Descricao = N''Tabelas''

	INSERT INTO [F3MOGeral]..tbMenus ([IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar], [OpenType])
	VALUES (21, N''ComunicacaoSms'', N''014.001.015'', N''ComunicacaoSms'', 140000, N''f3icon-comment'', N''/TabelasAuxiliares/ComunicacaoSms'', 1, @IDModulo, 1, 1, 1, 1, 1, 0, NULL, 0, 0, getdate(), N''F3M'', NULL, NULL, NULL, NULL, NULL)
END')

-- tbSistemaComunicacao
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbSistemaComunicacao]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbSistemaComunicacao](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](10) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[APIURL] [nvarchar](256) NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaComunicacao_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaComunicacao_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbSistemaComunicacao_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbSistemaComunicacao_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaComunicacao_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbSistemaComunicacao_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaComunicacao] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [IX_tbSistemaComunicacao_Codigo] ON [tbSistemaComunicacao] (
	[Codigo] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
END')

-- tbComunicacao
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbComunicacao]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbComunicacao](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](10) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[IDSistemaComunicacao] [bigint] NULL,
	[Utilizador] [nvarchar](50) NULL,
	[Chave] [nvarchar](50) NULL,
	[Remetente] [nvarchar](50) NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbComunicacao_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbComunicacao_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbComunicacao_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbComunicacao_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbComunicacao_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbComunicacao_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbComunicacao] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [IX_tbComunicacao_Codigo] ON [tbComunicacao] (
	[Codigo] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER TABLE [dbo].[tbComunicacao]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacao_tbSistemaComunicacao] FOREIGN KEY([IDSistemaComunicacao])
REFERENCES [dbo].[tbSistemaComunicacao] ([ID])
ALTER TABLE [dbo].[tbComunicacao] CHECK CONSTRAINT [FK_tbComunicacao_tbSistemaComunicacao]
END')

-- tbMensagemregistro
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbMensagemregistro]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbMensagemregistro](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDComunicacao] [bigint] NOT NULL,
	[Request] [nvarchar](1000) NULL,
	[Response] [nvarchar](1000) NULL,
	[Status] [nvarchar](50) NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbMensagemregistro_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbMensagemregistro_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbMensagemregistro_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbMensagemregistro_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbMensagemregistro_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbMensagemregistro_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbMensagemregistro] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbMensagemregistro]  WITH CHECK ADD  CONSTRAINT [FK_tbMensagemregistro_tbComunicacao] FOREIGN KEY([IDComunicacao])
REFERENCES [dbo].[tbComunicacao] ([ID])
ALTER TABLE [dbo].[tbMensagemregistro] CHECK CONSTRAINT [FK_tbMensagemregistro_tbComunicacao]
END')

-- tbComunicacaoregistro
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbComunicacaoregistro]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbComunicacaoregistro](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDChamada] [bigint] NULL,
	[TipoChamada] [nvarchar](30) NULL,
	[Telemovel] [nvarchar](50) NULL,
	[TextoMensagem] [nvarchar](500) NULL,
	[Documento] [nvarchar](50) NULL,
	[IDMensagemregistro] [bigint] NOT NULL,
	[DocumentID] [bigint] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoregistro_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoregistro_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbComunicacaoregistro_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbComunicacaoregistro_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbComunicacaoregistro_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbComunicacaoregistro_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbComunicacaoregistro] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbComunicacaoregistro]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoregistro_tbMensagemregistro] FOREIGN KEY([IDMensagemregistro])
REFERENCES [dbo].[tbMensagemregistro] ([ID])
ALTER TABLE [dbo].[tbComunicacaoregistro] CHECK CONSTRAINT [FK_tbComunicacaoregistro_tbMensagemregistro]
END')


EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbComunicacaoApis]'') AND type in (N''U''))
BEGIN
create table tbComunicacaoApis (
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDSistemaComunicacao] [bigint] NULL,
	[API] [nvarchar](50) NULL,
	[TipoApi] [nvarchar](20) NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoApis_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoApis_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbComunicacaoApis_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbComunicacaoApis_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbComunicacaoApis_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbComunicacaoApis_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
	CONSTRAINT [PK_tbComunicacaoApis] PRIMARY KEY CLUSTERED (
		ID ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbComunicacaoApis]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoApis_tbSistemaComunicacao] FOREIGN KEY([IDSistemaComunicacao])
REFERENCES [dbo].[tbSistemaComunicacao] ([ID])
ALTER TABLE [dbo].[tbComunicacaoApis] CHECK CONSTRAINT [FK_tbComunicacaoApis_tbSistemaComunicacao]
END')

EXEC('
IF NOT EXISTS(SELECT ID FROM tbSistemaComunicacao WHERE CODIGO=''EZ4U'')
BEGIN
SET IDENTITY_INSERT [dbo].[tbSistemaComunicacao] ON 
INSERT [dbo].[tbSistemaComunicacao] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [APIURL]) 
VALUES (1, N''EZ4U'', N''EZ4U'', 1, 1, CAST(N''2019-12-17T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2019-12-17T11:36:25.840'' AS DateTime), N'''', N''https://api.ez4uteam.com/ez4usms/API/'')
SET IDENTITY_INSERT [dbo].[tbSistemaComunicacao] OFF
END
')

EXEC('
Insert into tbComunicacaoApis(IDSistemaComunicacao,Ativo,Sistema,API,TipoApi) select 1,''1'',''1'',''sendSMS.php?'',''SendSMS''
Insert into tbComunicacaoApis(IDSistemaComunicacao,Ativo,Sistema,API,TipoApi) select 1,''1'',''1'',''getAvailableCredits.php?'',''CreditsCheck''
')

EXEC('update [F3MOGeral]..tbMenus set btncontextosms=0 where Descricao in (''Clientes'', ''DocumentosVendas'', ''DocumentosVendasServicos'')')