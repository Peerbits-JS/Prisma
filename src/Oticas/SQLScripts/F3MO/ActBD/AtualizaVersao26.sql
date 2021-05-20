/* ACT BD EMPRESA VERSAO 26*/
--campos de cores
EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbLojas'' AND COLUMN_NAME = ''Cor'') 
Begin
    ALTER TABLE [dbo].[tbLojas] ADD [Cor] [nvarchar](10) NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbEspecialidades'' AND COLUMN_NAME = ''Cor'') 
Begin
    ALTER TABLE [dbo].[tbEspecialidades] ADD [Cor] [nvarchar](10) NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbMedicosTecnicos'' AND COLUMN_NAME = ''IDUtilizador'') 
Begin
    ALTER TABLE [dbo].[tbMedicosTecnicos] ADD [IDUtilizador] [bigint] NULL
End')

--campos de exames
EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbExamesTemplate'' AND COLUMN_NAME = ''EEditavelEdicao'') 
Begin
    ALTER TABLE [dbo].[tbExamesTemplate] ADD [EEditavelEdicao] [bit] NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbExamesProps'' AND COLUMN_NAME = ''EEditavelEdicao'') 
Begin
    ALTER TABLE [dbo].[tbExamesProps] ADD [EEditavelEdicao] [bit] NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbExamesTemplate'' AND COLUMN_NAME = ''IDElemento'') 
Begin
    ALTER TABLE [dbo].[tbExamesTemplate] ADD [IDElemento] [nvarchar](max) NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbExamesProps'' AND COLUMN_NAME = ''IDElemento'') 
Begin
    ALTER TABLE [dbo].[tbExamesProps] ADD [IDElemento] [nvarchar](max) NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbExamesTemplate'' AND COLUMN_NAME = ''FuncaoJSOnClick'') 
Begin
    ALTER TABLE [dbo].[tbExamesTemplate] ADD [FuncaoJSOnClick] [nvarchar](max) NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbExamesProps'' AND COLUMN_NAME = ''FuncaoJSOnClick'') 
Begin
    ALTER TABLE [dbo].[tbExamesProps] ADD [FuncaoJSOnClick] [nvarchar](max) NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbExamesTemplate'' AND COLUMN_NAME = ''DesenhaBotaoLimpar'') 
Begin
    ALTER TABLE [dbo].[tbExamesTemplate] ADD [DesenhaBotaoLimpar] [bit] NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbExamesProps'' AND COLUMN_NAME = ''DesenhaBotaoLimpar'') 
Begin
    ALTER TABLE [dbo].[tbExamesProps] ADD [DesenhaBotaoLimpar] [bit] NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbExamesTemplate'' AND COLUMN_NAME = ''ECabecalho'') 
Begin
    ALTER TABLE [dbo].[tbExamesTemplate] ADD [ECabecalho] [bit] NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbExamesProps'' AND COLUMN_NAME = ''ECabecalho'') 
Begin
    ALTER TABLE [dbo].[tbExamesProps] ADD [ECabecalho] [bit] NULL
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbMedicosTecnicos'' AND COLUMN_NAME = ''IDSistemaAcoes'') 
Begin
    ALTER TABLE [dbo].[tbMedicosTecnicos] ADD [IDSistemaAcoes] [bigint] NULL
 
    ALTER TABLE [dbo].[tbMedicosTecnicos]  WITH CHECK ADD  CONSTRAINT [FK_tbMedicosTecnicos_tbSistemaAcoes] FOREIGN KEY([IDSistemaAcoes])
    REFERENCES [dbo].[tbSistemaAcoes] ([ID])
    ALTER TABLE [dbo].[tbMedicosTecnicos] CHECK CONSTRAINT [FK_tbMedicosTecnicos_tbSistemaAcoes]
End')

EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbMedicosTecnicos'' AND COLUMN_NAME = ''IDSistemaAcoes'') 
Begin
    ALTER TABLE [dbo].[tbMedicosTecnicos] ADD [IDSistemaAcoes] [bigint] NULL
 
    ALTER TABLE [dbo].[tbMedicosTecnicos]  WITH CHECK ADD  CONSTRAINT [FK_tbMedicosTecnicos_tbSistemaAcoes] FOREIGN KEY([IDSistemaAcoes])
    REFERENCES [dbo].[tbSistemaAcoes] ([ID])
    ALTER TABLE [dbo].[tbMedicosTecnicos] CHECK CONSTRAINT [FK_tbMedicosTecnicos_tbSistemaAcoes]
End')


-- Criação da tabela de exames anexos
EXEC('IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbExamesAnexos]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbExamesAnexos](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [IDExame] [bigint] NOT NULL,
    [IDTipoAnexo] [bigint] NULL,
    [Descricao] [nvarchar](255) NULL,
    [FicheiroOriginal] [nvarchar](255) NULL,
    [Ficheiro] [nvarchar](255) NOT NULL,
    [FicheiroThumbnail] [nvarchar](300) NULL,
    [Caminho] [nvarchar](max) NOT NULL,
    [Sistema] [bit] NOT NULL,
    [Ativo] [bit] NOT NULL,
    [DataCriacao] [datetime] NOT NULL,
    [UtilizadorCriacao] [nvarchar](20) NOT NULL,
    [DataAlteracao] [datetime] NULL,
    [UtilizadorAlteracao] [nvarchar](20) NULL,
    [F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbExmesAnexos] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tbExamesAnexos] UNIQUE NONCLUSTERED 
(
    [IDExame] ASC,
    [Ficheiro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 
ALTER TABLE [dbo].[tbExamesAnexos] ADD  CONSTRAINT [DF_tbExamesAnexos_Sistema]  DEFAULT ((0)) FOR [Sistema]
ALTER TABLE [dbo].[tbExamesAnexos] ADD  CONSTRAINT [DF_tbExamesAnexos_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbExamesAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbExamesAnexos_tbExames] FOREIGN KEY([IDExame])
REFERENCES [dbo].[tbExames] ([ID])
ALTER TABLE [dbo].[tbExamesAnexos] CHECK CONSTRAINT [FK_tbExamesAnexos_tbExames]

ALTER TABLE [dbo].[tbExamesAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbExamesAnexos_tbSistemaTiposAnexos] FOREIGN KEY([IDTipoAnexo])
REFERENCES [dbo].[tbSistemaTiposAnexos] ([ID])

ALTER TABLE [dbo].[tbExamesAnexos] CHECK CONSTRAINT [FK_tbExamesAnexos_tbSistemaTiposAnexos]
END
')

--criação do menu anexos exames
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=127)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) 
VALUES (127, 2, N''ExamesAnexos'', N''002.002.001'', N''Anexos'', 3000, N''f3icon-glasses'', N''/Exames/ExamesAnexos'', 1, 2, 1, 1, 1, 1, 1, 1, NULL, 1, 1, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=127 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 127, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')