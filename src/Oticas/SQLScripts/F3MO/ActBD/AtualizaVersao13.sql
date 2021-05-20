/* ACT BD EMPRESA VERSAO 13*/
--novos campos lojas
EXEC('ALTER TABLE tbLojas ADD EnderecoIP NVARCHAR(255) NULL')

--CG 22/02/2018
EXEC('ALTER TABLE [dbo].[tbDocumentosStockLinhas] ADD IDArtigoPA bigint NULL')
EXEC('ALTER TABLE [dbo].[tbDocumentosComprasLinhas] ADD IDArtigoPA bigint NULL')
EXEC('ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbArtigos2] 
FOREIGN KEY([IDArtigoPA]) REFERENCES [dbo].[tbArtigos] ([ID])')
EXEC('ALTER TABLE [dbo].[tbDocumentosComprasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosComprasLinhas_tbArtigos2]
FOREIGN KEY([IDArtigoPA]) REFERENCES [dbo].[tbArtigos] ([ID])')

ALTER TABLE [dbo].[tbCCStockArtigos] ADD [IDArtigoPara] [bigint] NULL
ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_IDArtigoPara] FOREIGN KEY([IDArtigoPara])
REFERENCES [dbo].[tbArtigos] ([ID])
ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_IDArtigoPara]
ALTER TABLE [dbo].[tbCCStockArtigos] ADD [IDArtigoPA] [bigint] NULL
ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_IDArtigoPA] FOREIGN KEY([IDArtigoPA])
REFERENCES [dbo].[tbArtigos] ([ID])
ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_IDArtigoPA]
