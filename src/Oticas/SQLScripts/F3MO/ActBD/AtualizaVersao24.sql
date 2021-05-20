/* ACT BD EMPRESA VERSAO 24*/
EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbMedicosTecnicos'' AND COLUMN_NAME = ''Cor'') 
Begin
    ALTER TABLE [dbo].[tbMedicosTecnicos] ADD [Cor] [nvarchar](10) NULL
End')
 
EXEC('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbTiposDocumentoSeries'' AND COLUMN_NAME = ''IDLoja'') 
Begin
    ALTER TABLE [dbo].[tbTiposDocumentoSeries] ADD [IDLoja] [bigint] NULL
    ALTER TABLE [dbo].[tbTiposDocumentoSeries]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumentoSeries_tbLojas] FOREIGN KEY([IDLoja])
    REFERENCES [dbo].[tbLojas] ([ID])
    ALTER TABLE [dbo].[tbTiposDocumentoSeries] CHECK CONSTRAINT [FK_tbTiposDocumentoSeries_tbLojas]
End')

--novos mapasvistas
EXEC('
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
DELETE FROM [dbo].[tbMapasVistas] WHERE ID=35
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (35, 35, N''EtiquetasA4_35x17_Barras'', N''EtiquetasA4_35x17_Barras'', N''rptEtiquetasA4C'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, N''select * from vwArtigos'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')