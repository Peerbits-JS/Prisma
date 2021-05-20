/* ACT BD EMPRESA VERSAO 32*/
EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbSistemaFuncionalidadesConsentimento]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbSistemaFuncionalidadesConsentimento](
	[ID] [int] NOT NULL,
	[Funcionalidade][nvarchar](256) NOT NULL,
	[QueryPesquisa] [nvarchar](MAX) NOT NULL,
	[OutraDenominacao][nvarchar](MAX) NULL,
	[QueryDefineEscondeFuncionalidade][nvarchar](MAX) NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaFuncionalidadesConsentimento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)) ON [PRIMARY]

CREATE TABLE [dbo].[tbParametrizacaoConsentimentos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDFuncionalidadeConsentimento] [int] NOT NULL,
	[Codigo][nvarchar](30) NOT NULL,
	[Descricao][nvarchar](256) NULL,
	[Titulo][nvarchar](MAX) NULL,
	[TituloSemFormatacao][nvarchar](MAX) NULL,
	[Cabecalho] [nvarchar](MAX) NULL,
	[CabecalhoSemFormatacao] [nvarchar](MAX) NULL,
	[Rodape][nvarchar](MAX) NULL,
	[RodapeSemFormatacao][nvarchar](MAX) NULL,
	[ApresentadoPorDefeito] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbParametrizacaoConsentimentos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)) ON [PRIMARY]

ALTER TABLE [dbo].[tbParametrizacaoConsentimentos] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentos_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentos] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentos_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentos] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentos_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentos] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentos_UtilizadorCriacao]  DEFAULT ('''') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentos] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentos_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentos] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentos_UtilizadorAlteracao]  DEFAULT ('''') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbParametrizacaoConsentimentos]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrizacaoConsentimentos_tbSistemaFuncionalidadesConsentimento] FOREIGN KEY([IDFuncionalidadeConsentimento])
REFERENCES [dbo].[tbSistemaFuncionalidadesConsentimento] ([ID])
ALTER TABLE [dbo].[tbParametrizacaoConsentimentos] CHECK CONSTRAINT [FK_tbParametrizacaoConsentimentos_tbSistemaFuncionalidadesConsentimento]

CREATE TABLE [dbo].[tbParametrizacaoConsentimentosCamposEntidade](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDSistemaFuncionalidadesConsentimento] [int] NOT NULL,
	[IDParametrizacaoConsentimento] [bigint] NULL,
	[Tabela] [nvarchar](256) NOT NULL,
	[NomeCampoChave] [nvarchar](256) NOT NULL,
	[NomeCampo] [nvarchar](256) NOT NULL,
	[DescricaoCampo] [nvarchar](256) NOT NULL,
	[TipoCampo] [nvarchar](256) NOT NULL,
	[TamanhoMaximoCampo] [nvarchar](256) NULL,
	[ExpressaoLista] [nvarchar](MAX) NULL,
	[ForeignKey] [bit] NOT NULL,
	[TabelaLeftJoin] [nvarchar](MAX) NULL,
	[CampoLeftJoin] [nvarchar](MAX) NULL,
	[ExpressaoLeftJoin] [nvarchar](MAX) NULL,
	[AliasLeftJoin] [nvarchar](100) NULL,
	[NumeroLinhaPosicionado][bigint] NOT NULL,
	[OrdemPosicionado][bigint] NOT NULL,
	[PercentagemOcupaLinha] [float] NULL,
	[CondicaoVisibilidade][nvarchar](MAX) NULL,--Este campo é por causa da data de nascimento dos clientes no prisma que quando é Coletivo não pode aparecer 
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbParametrizacaoConsentimentosCamposEntidade] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)) ON [PRIMARY]

ALTER TABLE [dbo].[tbParametrizacaoConsentimentosCamposEntidade] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentosCamposEntidade_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosCamposEntidade] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentosCamposEntidade_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosCamposEntidade] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentosCamposEntidade_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosCamposEntidade] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentosCamposEntidade_UtilizadorCriacao]  DEFAULT ('''') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosCamposEntidade] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentosCamposEntidade_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosCamposEntidade] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentosCamposEntidade_UtilizadorAlteracao]  DEFAULT ('''') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbParametrizacaoConsentimentosCamposEntidade]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrizacaoConsentimentosCamposEntidade_tbParametrizacaoConsentimentos] FOREIGN KEY([IDParametrizacaoConsentimento])
REFERENCES [dbo].[tbParametrizacaoConsentimentos] ([ID])
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosCamposEntidade] CHECK CONSTRAINT [FK_tbParametrizacaoConsentimentosCamposEntidade_tbParametrizacaoConsentimentos]

ALTER TABLE [dbo].[tbParametrizacaoConsentimentosCamposEntidade]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrizacaoConsentimentosCamposEntidade_tbSistemaFuncionalidadesConsentimento] FOREIGN KEY([IDSistemaFuncionalidadesConsentimento])
REFERENCES [dbo].[tbSistemaFuncionalidadesConsentimento] ([ID])
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosCamposEntidade] CHECK CONSTRAINT [FK_tbParametrizacaoConsentimentosCamposEntidade_tbSistemaFuncionalidadesConsentimento]

CREATE TABLE [dbo].[tbParametrizacaoConsentimentosPerguntas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDParametrizacaoConsentimento] [bigint] NOT NULL,
	[Codigo][bigint] NOT NULL,
	[Descricao] [nvarchar](MAX) NOT NULL,
	[OrdemApresentaPerguntas] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbParametrizacaoConsentimentosPerguntas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)) ON [PRIMARY]


CREATE UNIQUE NONCLUSTERED INDEX [IX_tbParametrizacaoConsentimentosPerguntas_Codigo_IDPa] ON [dbo].[tbParametrizacaoConsentimentosPerguntas]
(
	[Codigo] ASC,
	[IDParametrizacaoConsentimento] Asc
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE [dbo].[tbParametrizacaoConsentimentosPerguntas] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentosPerguntas_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosPerguntas] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentosPerguntas_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosPerguntas] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentosPerguntas_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosPerguntas] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentosPerguntas_UtilizadorCriacao]  DEFAULT ('''') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosPerguntas] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentosPerguntas_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosPerguntas] ADD  CONSTRAINT [DF_tbParametrizacaoConsentimentosPerguntas_UtilizadorAlteracao]  DEFAULT ('''') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbParametrizacaoConsentimentosPerguntas]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrizacaoConsentimentosPerguntas_tbParametrizacaoConsentimentos] FOREIGN KEY([IDParametrizacaoConsentimento])
REFERENCES [dbo].[tbParametrizacaoConsentimentos] ([ID])
ALTER TABLE [dbo].[tbParametrizacaoConsentimentosPerguntas] CHECK CONSTRAINT [FK_tbParametrizacaoConsentimentosPerguntas_tbParametrizacaoConsentimentos]

CREATE TABLE [dbo].[tbConsentimentos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDCodigoEntidade][nvarchar](MAX) NOT NULL,
	[CodigoEntidade][nvarchar](MAX) NOT NULL,
	[DescricaoEntidade][nvarchar](MAX) NOT NULL,
	[IDParametrizacaoConsentimentos] [bigint] NOT NULL,
	[ComAssinatura] [bit] NOT NULL,
	[DataConsentimento] [datetime] NOT NULL,
	[Titulo][nvarchar](MAX) NULL,
	[TituloSemFormatacao][nvarchar](MAX) NULL,
	[Cabecalho] [nvarchar](MAX) NULL,
	[CabecalhoSemFormatacao] [nvarchar](MAX) NULL,
	[Rodape][nvarchar](MAX) NULL,
	[RodapeSemFormatacao][nvarchar](MAX) NULL,
	[Ficheiro][nvarchar](255) NULL,
	[Caminho][nvarchar](MAX) NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbConsentimentos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)) ON [PRIMARY]

ALTER TABLE [dbo].[tbConsentimentos] ADD  CONSTRAINT [DF_tbConsentimentos_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbConsentimentos] ADD  CONSTRAINT [DF_tbConsentimentos_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbConsentimentos] ADD  CONSTRAINT [DF_tbConsentimentos_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbConsentimentos] ADD  CONSTRAINT [DF_tbConsentimentos_UtilizadorCriacao]  DEFAULT ('''') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbConsentimentos] ADD  CONSTRAINT [DF_tbConsentimentos_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbConsentimentos] ADD  CONSTRAINT [DF_tbConsentimentos_UtilizadorAlteracao]  DEFAULT ('''') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbConsentimentos]  WITH CHECK ADD  CONSTRAINT [FK_tbConsentimentos_tbParametrizacaoConsentimentos] FOREIGN KEY([IDParametrizacaoConsentimentos])
REFERENCES [dbo].[tbParametrizacaoConsentimentos] ([ID])
ALTER TABLE [dbo].[tbConsentimentos] CHECK CONSTRAINT [FK_tbConsentimentos_tbParametrizacaoConsentimentos]

CREATE TABLE [dbo].[tbRespostasConsentimentos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDParametrizacaoConsentimentoPerguntas] [bigint] NOT NULL,
	[IDConsentimento] [bigint] NOT NULL,
	[Resposta][bit] NULL,
	[Codigo][bigint] NOT NULL,
	[Descricao] [nvarchar](MAX) NOT NULL,
	[OrdemApresentaPerguntas] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbRespostasConsentimentos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)) ON [PRIMARY]

ALTER TABLE [dbo].[tbRespostasConsentimentos] ADD  CONSTRAINT [DF_tbRespostasConsentimentos_Ativo]  DEFAULT ((1)) FOR [Ativo]
ALTER TABLE [dbo].[tbRespostasConsentimentos] ADD  CONSTRAINT [DF_tbRespostasConsentimentos_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbRespostasConsentimentos] ADD  CONSTRAINT [DF_tbRespostasConsentimentos_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]
ALTER TABLE [dbo].[tbRespostasConsentimentos] ADD  CONSTRAINT [DF_tbRespostasConsentimentos_UtilizadorCriacao]  DEFAULT ('''') FOR [UtilizadorCriacao]
ALTER TABLE [dbo].[tbRespostasConsentimentos] ADD  CONSTRAINT [DF_tbRespostasConsentimentos_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
ALTER TABLE [dbo].[tbRespostasConsentimentos] ADD  CONSTRAINT [DF_tbRespostasConsentimentos_UtilizadorAlteracao]  DEFAULT ('''') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbRespostasConsentimentos]  WITH CHECK ADD  CONSTRAINT [FK_tbRespostasConsentimentos_tbParametrizacaoConsentimentosPerguntas] FOREIGN KEY([IDParametrizacaoConsentimentoPerguntas])
REFERENCES [dbo].[tbParametrizacaoConsentimentosPerguntas] ([ID])
ALTER TABLE [dbo].[tbRespostasConsentimentos] CHECK CONSTRAINT [FK_tbRespostasConsentimentos_tbParametrizacaoConsentimentosPerguntas]

ALTER TABLE [dbo].[tbRespostasConsentimentos]  WITH CHECK ADD  CONSTRAINT [FK_tbRespostasConsentimentos_tbConsentimentos] FOREIGN KEY([IDConsentimento])
REFERENCES [dbo].[tbConsentimentos] ([ID])
ALTER TABLE [dbo].[tbRespostasConsentimentos] CHECK CONSTRAINT [FK_tbRespostasConsentimentos_tbConsentimentos]


-----------------------------------
-- Dados inserir Instituição Prisma
-----------------------------------
INSERT INTO [dbo].[tbSistemaFuncionalidadesConsentimento]([ID],[Funcionalidade],[QueryPesquisa],[OutraDenominacao],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,''Vendas \ Clientes'',''Select F.ID As Chave,F.Codigo As Codigo,F.Nome As Descricao from TBCLIENTES As F where ISNULL(F.Esquecido,0) = 0 AND ISNULL(F.Ativo,1) = 1 Order By Codigo ASC'',NULL,1,1,GETDATE(),''F3M'',NULL,NULL)

SET IDENTITY_INSERT tbParametrizacaoConsentimentos ON;
INSERT INTO [dbo].[tbParametrizacaoConsentimentos]([ID],[IDFuncionalidadeConsentimento],[Codigo],[Descricao],[Titulo],[TituloSemFormatacao],[Cabecalho],[CabecalhoSemFormatacao],[Rodape],[RodapeSemFormatacao],[ApresentadoPorDefeito],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,1,''1'',''Exemplo'',''<p style="text-align:center;"><strong><span style="font-size:x-small;">&nbsp;</span></strong></p><p style="text-align:center;"><strong><span style="font-size:medium;">CONSENTIMENTO </span></strong></p><p style="text-align:center;"><strong><span style="font-size:medium;">Utiliza&ccedil;&atilde;o de dados pessoais nos termos dos artigos 6.&ordm; e 7.&ordm; do Regulamento (EU) 2016/679 - Regulamento Geral de Prote&ccedil;&atilde;o de Dados.</span></strong></p><p style="text-align:center;"><strong><span style="font-size:medium;"></span><span style="font-size:x-small;"></span></strong><strong><span style="font-size:x-small;"></span></strong><br /></p>'',
'' CONSENTIMENTO - Utilização de dados pessoais nos termos dos artigos 6.º e 7.º do Regulamento (EU) 2016/679 - Regulamento Geral de Proteção de Dados.'',
''<p style="text-align:justify;">Os dados pessoais facultados pelo titular dos dados, destinam-se a ser tratados exclusivamente no &acirc;mbito de:</p>'',
''Os dados pessoais facultados pelo titular dos dados, destinam-se a ser tratados exclusivamente no âmbito de: '',
''<p style="text-align:justify;">Entidade Respons&aacute;vel pelo tratamento de dados:</p><p style="text-align:justify;"><span style="background-color:#ffff66;">"Entidade"</span></p><p style="text-align:justify;"><span style="background-color:#ffff66;">"Morada"</span> </p><p style="text-align:justify;">O titular dos dados,tem conhecimento de que tem o direito de retirar o seu consentimento a qualquer momento, sem qualquer penaliza&ccedil;&atilde;o, n&atilde;o comprometendo a licitude do tratamento efetuado com base no consentimento previamente dado.</p><p style="text-align:justify;">O titular dos dados, foi informado da Pol&iacute;tica de Privacidade e Prote&ccedil;&atilde;o de Dados da <span style="background-color:#ffff66;">"Entidade"</span>.<span style="background-color:#ffff66;"> (Opcional - colocar esta frase caso exista Pol&iacute;tica de Privacidade)</span> </p><p><br /></p>'',
'' Entidade Responsável pelo tratamento de dados:"Entidade""Morada"  O titular dos dados,tem conhecimento de que tem o direito de retirar o seu consentimento a qualquer momento, sem qualquer penalização, não comprometendo a licitude do tratamento efetuado com base no consentimento previamente dado.O titular dos dados, foi informado da Política de Privacidade e Proteção de Dados da "Entidade". (Opcional - colocar esta frase caso exista Política de Privacidade) '',
1,1,1,GETDATE(),''F3M'',NULL,NULL)
SET IDENTITY_INSERT tbParametrizacaoConsentimentos OFF;

-- Campos Entidade
INSERT INTO [dbo].[tbParametrizacaoConsentimentosCamposEntidade]([IDSistemaFuncionalidadesConsentimento],[IDParametrizacaoConsentimento],[Tabela],[NomeCampoChave],[NomeCampo],[DescricaoCampo],[TipoCampo],[TamanhoMaximoCampo],[ExpressaoLista],[ForeignKey],[TabelaLeftJoin],[CampoLeftJoin],[ExpressaoLeftJoin],[AliasLeftJoin],[NumeroLinhaPosicionado],[OrdemPosicionado],[PercentagemOcupaLinha],[CondicaoVisibilidade],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,NULL,''TBCLIENTES'',''ID'',''NOME'',''Nome'',''nvarchar'',''200'',NULL,0,NULL,NULL,NULL,NULL,1,1,100,NULL,1,1,GETDATE(),''F3M'',NULL,NULL)

INSERT INTO [dbo].[tbParametrizacaoConsentimentosCamposEntidade]([IDSistemaFuncionalidadesConsentimento],[IDParametrizacaoConsentimento],[Tabela],[NomeCampoChave],[NomeCampo],[DescricaoCampo],[TipoCampo],[TamanhoMaximoCampo],[ExpressaoLista],[ForeignKey],[TabelaLeftJoin],[CampoLeftJoin],[ExpressaoLeftJoin],[AliasLeftJoin],[NumeroLinhaPosicionado],[OrdemPosicionado],[PercentagemOcupaLinha],[CondicaoVisibilidade],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,NULL,''TBCLIENTES'',''ID'',''DATANASCIMENTO'',''Data de Nascimento'',''date'',NULL,''cast(convert(nvarchar,TBCLIENTES.DATANASCIMENTO,105) as nvarchar(10))'',0,NULL,NULL,NULL,NULL,2,1,50,NULL,1,1,GETDATE(),''F3M'',NULL,NULL)

INSERT INTO [dbo].[tbParametrizacaoConsentimentosCamposEntidade]([IDSistemaFuncionalidadesConsentimento],[IDParametrizacaoConsentimento],[Tabela],[NomeCampoChave],[NomeCampo],[DescricaoCampo],[TipoCampo],[TamanhoMaximoCampo],[ExpressaoLista],[ForeignKey],[TabelaLeftJoin],[CampoLeftJoin],[ExpressaoLeftJoin],[AliasLeftJoin],[NumeroLinhaPosicionado],[OrdemPosicionado],[PercentagemOcupaLinha],[CondicaoVisibilidade],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,NULL,''TBCLIENTES'',''ID'',''NContribuinte'',''NIF'',''nvarchar'',''25'',NULL,0,NULL,NULL,NULL,NULL,2,2,50,NULL,1,1,GETDATE(),''F3M'',NULL,NULL)

INSERT INTO [dbo].[tbParametrizacaoConsentimentosCamposEntidade]([IDSistemaFuncionalidadesConsentimento],[IDParametrizacaoConsentimento],[Tabela],[NomeCampoChave],[NomeCampo],[DescricaoCampo],[TipoCampo],[TamanhoMaximoCampo],[ExpressaoLista],[ForeignKey],[TabelaLeftJoin],[CampoLeftJoin],[ExpressaoLeftJoin],[AliasLeftJoin],[NumeroLinhaPosicionado],[OrdemPosicionado],[PercentagemOcupaLinha],[CondicaoVisibilidade],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,NULL,''tbClientesMoradas'',''cast(tbClientesMoradas.Ordem as int) = 1 And tbClientesMoradas.IDCliente'',''MORADA'',''Morada'',''nvarchar'',''100'',NULL,0,NULL,NULL,NULL,NULL,3,1,100,NULL,1,1,GETDATE(),''F3M'',NULL,NULL)

INSERT INTO [dbo].[tbParametrizacaoConsentimentosCamposEntidade]([IDSistemaFuncionalidadesConsentimento],[IDParametrizacaoConsentimento],[Tabela],[NomeCampoChave],[NomeCampo],[DescricaoCampo],[TipoCampo],[TamanhoMaximoCampo],[ExpressaoLista],[ForeignKey],[TabelaLeftJoin],[CampoLeftJoin],[ExpressaoLeftJoin],[AliasLeftJoin],[NumeroLinhaPosicionado],[OrdemPosicionado],[PercentagemOcupaLinha],[CondicaoVisibilidade],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,NULL,''tbClientesContatos'',''cast(tbClientesContatos.Ordem as int) = 1 And tbClientesContatos.IDCliente'',''TELEFONE'',''Telefone'',''nvarchar'',''25'',NULL,0,NULL,NULL,NULL,NULL,4,1,25,NULL,1,1,GETDATE(),''F3M'',NULL,NULL)

INSERT INTO [dbo].[tbParametrizacaoConsentimentosCamposEntidade]([IDSistemaFuncionalidadesConsentimento],[IDParametrizacaoConsentimento],[Tabela],[NomeCampoChave],[NomeCampo],[DescricaoCampo],[TipoCampo],[TamanhoMaximoCampo],[ExpressaoLista],[ForeignKey],[TabelaLeftJoin],[CampoLeftJoin],[ExpressaoLeftJoin],[AliasLeftJoin],[NumeroLinhaPosicionado],[OrdemPosicionado],[PercentagemOcupaLinha],[CondicaoVisibilidade],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,NULL,''tbClientesContatos'',''cast(tbClientesContatos.Ordem as int) = 1 And tbClientesContatos.IDCliente'',''Telemovel'',''Telemóvel'',''nvarchar'',''25'',NULL,0,NULL,NULL,NULL,NULL,4,2,25,NULL,1,1,GETDATE(),''F3M'',NULL,NULL)

INSERT INTO [dbo].[tbParametrizacaoConsentimentosCamposEntidade]([IDSistemaFuncionalidadesConsentimento],[IDParametrizacaoConsentimento],[Tabela],[NomeCampoChave],[NomeCampo],[DescricaoCampo],[TipoCampo],[TamanhoMaximoCampo],[ExpressaoLista],[ForeignKey],[TabelaLeftJoin],[CampoLeftJoin],[ExpressaoLeftJoin],[AliasLeftJoin],[NumeroLinhaPosicionado],[OrdemPosicionado],[PercentagemOcupaLinha],[CondicaoVisibilidade],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,NULL,''tbClientesContatos'',''cast(tbClientesContatos.Ordem as int) = 1 And tbClientesContatos.IDCliente'',''EMAIL'',''E-Mail'',''nvarchar'',''255'',NULL,0,NULL,NULL,NULL,NULL,4,3,50,NULL,1,1,GETDATE(),''F3M'',NULL,NULL)


-- Perguntas
INSERT INTO [dbo].[tbParametrizacaoConsentimentosPerguntas]([IDParametrizacaoConsentimento],[Codigo],[Descricao],[OrdemApresentaPerguntas],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,1,''Acompanhamento do relacionamento comercial e apoio após venda'',1,1,1,GETDATE(),''F3M'',NULL,NULL)

INSERT INTO [dbo].[tbParametrizacaoConsentimentosPerguntas]([IDParametrizacaoConsentimento],[Codigo],[Descricao],[OrdemApresentaPerguntas],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,2,''Divulgação da oferta de produtos e serviços'',2,1,1,GETDATE(),''F3M'',NULL,NULL)

INSERT INTO [dbo].[tbParametrizacaoConsentimentosPerguntas]([IDParametrizacaoConsentimento],[Codigo],[Descricao],[OrdemApresentaPerguntas],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,3,''Envio de felicitações por aniversário'',3,1,1,GETDATE(),''F3M'',NULL,NULL)

INSERT INTO [dbo].[tbParametrizacaoConsentimentosPerguntas]([IDParametrizacaoConsentimento],[Codigo],[Descricao],[OrdemApresentaPerguntas],[Sistema],[Ativo],[DataCriacao],[UtilizadorCriacao],[DataAlteracao],[UtilizadorAlteracao])
VALUES (1,4,''Envio de avisos para rastreio visual'',4,1,1,GETDATE(),''F3M'',NULL,NULL)
END')

EXEC('UPDATE tbSistemaTiposDocumentoFiscal SET Ativo=0 where Descricao =''RecRegimeIvaCx''')

--novos mapasvistas
EXEC('
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
DELETE FROM [dbo].[tbMapasVistas] WHERE ID=38
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (38, 38, N''EtiquetasRoloB'', N''EtiquetasRoloB'', N''rptEtiquetasRoloB'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, N''select * from vwArtigos'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')

--view etiquetas de artigos
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwArtigos'')) drop view vwArtigos')
EXEC('
BEGIN
EXECUTE(''
create view vwArtigos
as
select ''''003'''' as tipodoc, tbdocumentoscompraslinhas.iddocumentocompra as IDDocumento, tbdocumentoscompraslinhas.quantidade as Quantidade, 
tbArtigosPrecos.ValorComIva, tbArtigos.Codigo, tbArtigos.CodigoBarras,tbArtigos.CodigoBarrasFornecedor, tbArtigos.ReferenciaFornecedor, isnull(tbArtigosPrecos2.ValorComIva,0) as ValorComIva2, isnull(tbMarcas.Descricao,'''''''') as DescricaoMarca
FROM tbdocumentoscompraslinhas as tbdocumentoscompraslinhas 
LEFT JOIN tbArtigos AS tbArtigos ON tbArtigos.id=tbdocumentoscompraslinhas.IDArtigo
LEFT JOIN tbArtigosPrecos AS tbArtigosPrecos ON tbArtigosPrecos.IDArtigo=tbArtigos.id and tbArtigosPrecos.IDCodigoPreco=1
LEFT JOIN tbArtigosPrecos AS tbArtigosPrecos2 ON tbArtigosPrecos2.IDArtigo=tbArtigos.id and tbArtigosPrecos2.IDCodigoPreco=2
LEFT JOIN tbMarcas AS tbMarcas ON tbArtigos.idmarca=tbMarcas.id
union
select ''''001'''' as tipodoc, tbDocumentosStockLinhas.IDDocumentoStock as IDDocumento, tbDocumentosStockLinhas.Quantidade as Quantidade, 
tbArtigosPrecos.ValorComIva, tbArtigos.Codigo, tbArtigos.CodigoBarras,tbArtigos.CodigoBarrasFornecedor, tbArtigos.ReferenciaFornecedor, isnull(tbArtigosPrecos2.ValorComIva,0) as ValorComIva2, isnull(tbMarcas.Descricao,'''''''') as DescricaoMarca
FROM tbDocumentosStockLinhas as tbDocumentosStockLinhas 
LEFT JOIN tbArtigos AS tbArtigos ON tbArtigos.id=tbDocumentosStockLinhas.IDArtigo
LEFT JOIN tbArtigosPrecos AS tbArtigosPrecos ON tbArtigosPrecos.IDArtigo=tbArtigos.id and tbArtigosPrecos.IDCodigoPreco=1
LEFT JOIN tbArtigosPrecos AS tbArtigosPrecos2 ON tbArtigosPrecos2.IDArtigo=tbArtigos.id and tbArtigosPrecos2.IDCodigoPreco=2
LEFT JOIN tbMarcas AS tbMarcas ON tbArtigos.idmarca=tbMarcas.id
'')
END')


exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''select tbclientes.ID, tbclientes.Codigo, tbclientes.Nome, tbclientes.NContribuinte, tbclientes.Ativo, mt.Nome as DescricaoMedicoTecnico, tbclientes.Datanascimento, convert(nvarchar(MAX), tbclientes.Datanascimento, 105) as DiaNascimento, cc.Telefone, cc.Telemovel, en.Descricao as DescricaoEntidade1, et.Descricao as DescricaoEntidade2, lj.descricao as DescricaoLoja, isnull(tbclientes.saldo, 0) as Saldo, tbclientes.IdTipoEntidade, cast(tbclientes.nome as nvarchar(100)) as DescricaoSplitterLadoDireito 
,tbclientes.UtilizadorCriacao
from tbclientes  
left join tbLojas lj on tbclientes.idloja=lj.id
left join tbMedicosTecnicos mt on tbclientes.idmedicotecnico=mt.id
left join tbentidades en on tbclientes.identidade1=en.id
left join tbentidades et on tbclientes.identidade2=et.id
left join tbclientescontatos cc on tbclientes.id=cc.idcliente and cc.ordem=1''
where id in (25,66,68)')


EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE ID=25
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE idlistapersonalizada=25 and colunavista=''UtilizadorCriacao''
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UtilizadorCriacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
END')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE ID=66
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE idlistapersonalizada=66 and colunavista=''UtilizadorCriacao''
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UtilizadorCriacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
END')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE ID=68
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE idlistapersonalizada=68 and colunavista=''UtilizadorCriacao''
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UtilizadorCriacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
END')


--conta corrente fornecedores
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwCCFornecedores'')) drop view vwCCFornecedores')

EXEC('create view [dbo].[vwCCFornecedores] as
select 
tbFornecedores.Codigo as CodigoFornecedor,
tbCCFornecedores.NomeFiscal,
tbCCFornecedores.IDEntidade,
tbCCFornecedores.IDLoja,
tbCCFornecedores.IDTipoDocumento,
tbCCFornecedores.IDTipoDocumentoSeries,
tbCCFornecedores.NumeroDocumento,
tbCCFornecedores.DataDocumento,
tbCCFornecedores.Descricao as Documento,
tbCCFornecedores.IDMoeda,
tbCCFornecedores.Ativo as Ativo,
(case when tbCCFornecedores.Natureza=''R'' then ''Crédito'' else ''Débito'' end) as Natureza,  
(case when tbCCFornecedores.Natureza=''P'' then tbCCFornecedores.TotalMoedaReferencia else -(tbCCFornecedores.TotalMoedaReferencia) end) as TotalMoeda,
(case when tbCCFornecedores.Natureza=''P'' then tbCCFornecedores.TotalMoedaReferencia else -(tbCCFornecedores.TotalMoedaReferencia) end) as Valor,
(case when tbCCFornecedores.Natureza=''P'' then tbCCFornecedores.TotalMoedaReferencia else -(tbCCFornecedores.TotalMoedaReferencia) end) as TotalMoedaReferencia,
Round(isnull((
select Sum((Case tbCCSaldoAgreg.Natureza when ''P'' then 1 else -1 end) * tbCCSaldoAgreg.TotalMoedaReferencia) FROM tbCCFornecedores as tbCCSaldoAgreg
WHERE tbCCSaldoAgreg.IDEntidade= tbCCFornecedores.IDEntidade
AND (tbCCSaldoAgreg.Natureza =''P'' OR tbCCSaldoAgreg.Natureza =''R'')
AND tbCCSaldoAgreg.DataCriacao <= tbCCFornecedores.DataCriacao
AND ((tbCCSaldoAgreg.IDTipoDocumento<>tbCCFornecedores.IDTipoDocumento OR tbCCSaldoAgreg.IDDocumento <> tbCCFornecedores.IDDocumento
       ) OR (tbCCSaldoAgreg.IDTipoDocumento = tbCCFornecedores.IDTipoDocumento AND tbCCSaldoAgreg.IDDocumento = tbCCFornecedores.IDDocumento
                     AND tbCCSaldoAgreg.ID<=tbCCFornecedores.ID
                     )
       )
),0),isnull(tbMoedas.CasasDecimaisTotais,0)) as Saldo,
tbmoedas.descricao as tbMoedas_Descricao, 
tbmoedas.Simbolo as tbMoedas_Simbolo, 
tbmoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
tbmoedas.CasasDecimaisTotais as Saldonumcasasdecimais,
tbmoedas.CasasDecimaisTotais as TotalMoedanumcasasdecimais,
tbmoedas.CasasDecimaisTotais as TotalMoedaReferencianumcasasdecimais,
tblojas.Codigo as CodigoLoja,
tblojas.Descricao as DescricaoLoja
FROM tbCCFornecedores AS tbCCFornecedores
LEFT JOIN tbFornecedores AS tbFornecedores ON tbFornecedores.id=tbCCFornecedores.IDentidade
LEFT JOIN tbLojas AS tbLojas ON tbLojas.id=tbCCFornecedores.IDLoja
LEFT JOIN tbParametrosEmpresa as P ON 1 = 1
LEFT JOIN tbMoedas as tbMoedas ON tbMoedas.ID=P.IDMoedaDefeito
LEFT JOIN tbTiposDocumento AS tbTiposDocumento ON tbTiposDocumento.ID=tbCCFornecedores.IDTipoDocumento
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries ON tbTiposDocumentoSeries.ID=tbCCFornecedores.IDTipoDocumentoSeries
ORDER BY tbCCFornecedores.DataCriacao OFFSET 0 ROWS ')

exec('update c set c.DataCriacao=dc.DataControloInterno from  tbdocumentoscompras dc inner join tbCCFornecedores c on dc.IDTipoDocumento=c.IDTipoDocumento and dc.id=c.IDDocumento')

--aviso de nova versão
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.13.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.13.0'', ''A'', ''2018-11-06 00:00'', ''2018-11-12 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.13.0'', ''V'', ''2018-11-12 08:00'', ''2018-11-12 08:00'', ''Funcionalidades da versão'', ''
    <li>UTILIZADORES – Configuração de limites na venda</li>
    <li>PERMISSÕES – Visualizar preços de custo</li>
	<li>DOCUMENTOS – Configuração de distribuição de descontos</li>
	<li>ARTIGOS – Novo formato de etiquetas de rolo</li>
    '', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')

EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Margem de Vendas''
DELETE FROM [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 9, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 11, N'''', 1, CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''Utilizador'', 0, N''Utilizador'', N'''', N'''', 3, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
END')


EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Iva de Vendas''
DELETE [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] Where IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 9, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 11, N'''', 1, CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''Utilizador'', 0, N''Utilizador'', N'''', N'''', 3, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
END')


EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Vendas''
DELETE FROM [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 9, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''DataDocumento'', 0, N''DataDocumento'', N'''', N'''', 11, N'''', 1, CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:36:41.873'' AS DateTime), N''F3M'')
INSERT [F3MOGeral].[dbo].[tbCondicoesListasPersonalizadas] ([IDListaPersonalizada], [Campo], [Sistema], [CampoLabel], [Valor], [QuerySelecaoDados], [IDSistemaCriterio], [CampoRetorno], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (@IDLista, N''Utilizador'', 0, N''Utilizador'', N'''', N'''', 3, N'''', 1, CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'', CAST(N''2017-06-19 16:47:10.290'' AS DateTime), N''F3M'')
END')