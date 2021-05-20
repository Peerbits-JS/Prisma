/* ACT BD EMPRESA VERSAO 14*/

--novos campos 
EXEC('ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD IDArtigoPara bigint NULL')
EXEC('ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArtigos1] FOREIGN KEY([IDArtigoPara]) REFERENCES [dbo].[tbArtigos] ([ID])')

exec('ALTER TABLE tbDocumentosVendasLinhas ADD IDTipoDocumentoOrigemInicial bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbTiposDocumentoOrigemInicial] FOREIGN KEY([IDTipoDocumentoOrigemInicial])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbTiposDocumentoOrigemInicial]')
exec('ALTER TABLE tbDocumentosVendasLinhas ADD IDDocumentoOrigemInicial bigint null')
exec('ALTER TABLE tbDocumentosVendasLinhas ADD IDLinhaDocumentoOrigemInicial bigint null')
exec('ALTER TABLE tbDocumentosVendasLinhas ADD DocumentoOrigemInicial nvarchar(255) null')

exec('ALTER TABLE tbDocumentosVendasLinhas ADD IDLinhaDocumentoCompraInicial bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbDocumentosVendasLinhasInicial] FOREIGN KEY([IDLinhaDocumentoCompraInicial])
REFERENCES [dbo].[tbDocumentosVendasLinhas] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbDocumentosVendasLinhasInicial]')

exec('ALTER TABLE tbDocumentosVendasLinhas ADD IDLinhaDocumentoStockInicial bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbDocumentosStockLinhasInicial] FOREIGN KEY([IDLinhaDocumentoStockInicial])
REFERENCES [dbo].[tbDocumentosStockLinhas] ([ID])
ALTER TABLE [dbo].[tbDocumentosVendasLinhas] CHECK CONSTRAINT [FK_tbDocumentosVendasLinhas_tbDocumentosStockLinhasInicial]')

EXEC('ALTER TABLE tbDocumentosVendasLinhas ADD IDOFArtigo bigint null')

EXEC('ALTER TABLE tbDocumentosVendasLinhas ADD QtdStockSatisfeita float null')
EXEC('ALTER TABLE tbDocumentosVendasLinhas ADD QtdStockDevolvida float null')
EXEC('ALTER TABLE tbDocumentosVendasLinhas ADD QtdStockAcerto float null')
EXEC('ALTER TABLE tbDocumentosVendasLinhas ADD QtdStock2Satisfeita float null')
EXEC('ALTER TABLE tbDocumentosVendasLinhas ADD QtdStock2Devolvida float null')
EXEC('ALTER TABLE tbDocumentosVendasLinhas ADD QtdStock2Acerto float null')

EXEC('ALTER TABLE [dbo].[tbDocumentosVendasLinhas] ADD IDArtigoPA bigint NULL')
EXEC('ALTER TABLE [dbo].[tbDocumentosVendasLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosVendasLinhas_tbArtigos2] 
FOREIGN KEY([IDArtigoPA]) REFERENCES [dbo].[tbArtigos] ([ID])')

exec('ALTER TABLE tbDocumentosStockLinhas ADD IDLinhaDocumentoStock bigint null')
exec('ALTER TABLE [dbo].[tbDocumentosStockLinhas]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosStockLinhas_tbDocumentosStockLinhas] FOREIGN KEY([IDLinhaDocumentoStock])
REFERENCES [dbo].[tbDocumentosStockLinhas] ([ID])
ALTER TABLE [dbo].[tbDocumentosStockLinhas] CHECK CONSTRAINT [FK_tbDocumentosStockLinhas_tbDocumentosStockLinhas]')

--CG 22/02/2018
ALTER TABLE [dbo].[tbCCStockArtigos] ADD 
   IDTipoDocumentoOrigemInicial bigint null, IDDocumentoOrigemInicial bigint null,
   IDLinhaDocumentoOrigemInicial bigint null,
   DocumentoOrigemInicial nvarchar(255) null
ALTER TABLE [dbo].[tbCCStockArtigos]  WITH CHECK ADD  CONSTRAINT [FK_tbCCStockArtigos_tbTiposDocumentoOrigemInicial] FOREIGN KEY([IDTipoDocumentoOrigemInicial])
REFERENCES [dbo].[tbTiposDocumento] ([ID])
ALTER TABLE [dbo].[tbCCStockArtigos] CHECK CONSTRAINT [FK_tbCCStockArtigos_tbTiposDocumentoOrigemInicial]

EXEC('update tbclientes set IDTipoPessoa=1 where IDTipoPessoa is null')
EXEC('update d set d.CodigoTipoIva=i.Codigo from tbDocumentosVendasLinhas d inner join tbSistemaTiposIVA i on d.IDTipoIva=i.id where d.CodigoTipoIva is null')

EXEC('UPDATE [F3MOGeral].[dbo].[tbListasPersonalizadas] SET Descricao=''Mapa de Compras'' WHERE Descricao=''Mapa de Ranking de Compras''')
EXEC('UPDATE [F3MOGeral].[dbo].[tbListasPersonalizadas] SET Descricao=''Mapa de Vendas'' WHERE Descricao=''Mapa de Ranking de Vendas''')
EXEC('UPDATE [tbmapasvistas] SET Descricao=''Mapa de Compras'' WHERE Entidade=''MapaRankingCompras''')
EXEC('UPDATE [tbmapasvistas] SET Descricao=''Mapa de Vendas'' WHERE Entidade=''MapaRankingVendas''')

EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaRankingVendas'')) drop view vwMapaRankingVendas')

EXEC('create view [dbo].[vwMapaRankingVendas] as
select 
tbClientes.Codigo as CodigoCliente,
tbClientes.Nome as NomeFiscal,
tbLojas.Codigo as CodigoLoja,
tbLojas.Descricao as DescricaoLoja,
tbMarcas.Codigo as CodigoMarca,
tbMarcas.Descricao as DescricaoMarca,
tbTiposArtigos.Codigo as CodigoTipoArtigo,
tbTiposArtigos.Descricao as DescricaoTipoArtigo,
tbArtigos.Codigo as CodigoArtigo,
tbArtigos.Descricao as DescricaoArtigo,
tbArtigosLotes.Codigo as CodigoLote,
tbArtigosLotes.Descricao as DescricaoLote,
tbFornecedores.Codigo as CodigoFornecedor,
tbFornecedores.Nome as DescricaoFornecedor,
tbdocumentosVendas.UtilizadorCriacao as Utilizador,
tbDocumentosVendas.IDMoeda, 
tbDocumentosVendas.TaxaConversao, 
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
Sum((case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Quantidade,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitario,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Valor,
Sum((isnull(tbdocumentosVendaslinhas.PrecoUnitario,0)-isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivo,0))*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end))  as Desconto,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivo,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Liquido,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivo,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as TotalValor,
Sum(isnull(tbdocumentosVendaslinhas.PCMAtualMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as TotalCustoMedio

FROM tbdocumentosVendas AS tbdocumentosVendas with (nolock) 
LEFT JOIN tbdocumentosVendaslinhas AS tbdocumentosVendaslinhas with (nolock) ON tbdocumentosVendaslinhas.iddocumentoVenda=tbdocumentosVendas.ID
LEFT JOIN tbArtigos AS tbArtigos with (nolock) ON tbArtigos.id=tbdocumentosVendaslinhas.IDArtigo
LEFT JOIN tbArtigosFornecedores AS tbArtigosFornecedores with (nolock) ON tbArtigos.id=tbArtigosFornecedores.IDArtigo and tbArtigosFornecedores.Ordem=1
LEFT JOIN tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.id=tbArtigosFornecedores.IDFornecedor and tbArtigosFornecedores.Ordem=1
LEFT JOIN tbMarcas as tbMarcas with (nolock) ON tbMarcas.ID=tbArtigos.IDMarca
LEFT JOIN tbLojas as tbLojas with (nolock) ON tbLojas.ID=tbdocumentosVendas.IDLoja
LEFT JOIN tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbdocumentosVendas.IDEstado
LEFT JOIN tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
LEFT JOIN tbUnidades as tbUnidades with (nolock) ON tbUnidades.ID=tbArtigos.IDUnidade
LEFT JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbdocumentosVendas.IDTipoDocumento
LEFT JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbSistemaTiposDocumento.ID=tbTiposDocumento.IDSistemaTiposDocumento
LEFT JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbSistemaNaturezas.ID=tbTiposDocumento.IDSistemaNaturezas
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbdocumentosVendas.IDTiposDocumentoSeries
LEFT JOIN tbArtigosLotes AS tbArtigosLotes with (nolock) ON tbArtigosLotes.ID = tbdocumentosVendaslinhas.IDLote
LEFT JOIN tbClientes AS tbClientes with (nolock) ON tbClientes.ID = tbdocumentosVendas.IDEntidade
LEFT JOIN tbtiposartigos AS tbtiposartigos with (nolock) ON tbtiposartigos.ID = tbArtigos.IDtipoartigo
LEFT JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosVendas.IDMoeda
where 
tbsistematiposestados.codigo=''EFT'' and tbsistematiposdocumento.tipo=''VndFinanceiro''
group by 
tbArtigos.Codigo,tbArtigos.Descricao,tbArtigosLotes.Codigo ,tbArtigosLotes.Descricao ,tbTiposArtigos.Codigo ,tbTiposArtigos.Descricao ,tbLojas.Codigo ,tbLojas.Descricao ,
tbClientes.Codigo ,tbClientes.Nome ,tbMarcas.Codigo,tbMarcas.Descricao,tbFornecedores.Codigo ,tbFornecedores.Nome ,tbdocumentosVendas.UtilizadorCriacao, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais')



EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaRankingCompras'')) drop view vwMapaRankingCompras')

EXEC('create view [dbo].[vwMapaRankingCompras] as
select 
tbFornecedores.Codigo as CodigoFornecedor,
tbFornecedores.Nome as NomeFiscal,
tbFornecedores.Nome as DescricaoFornecedor,
tbLojas.Codigo as CodigoLoja,
tbLojas.Descricao as DescricaoLoja,
tbMarcas.Codigo as CodigoMarca,
tbMarcas.Descricao as DescricaoMarca,
tbTiposArtigos.Codigo as CodigoTipoArtigo,
tbTiposArtigos.Descricao as DescricaoTipoArtigo,
tbArtigos.Codigo as CodigoArtigo,
tbArtigos.Descricao as DescricaoArtigo,
tbArtigosLotes.Codigo as CodigoLote,
tbArtigosLotes.Descricao as DescricaoLote,
tbdocumentoscompras.IDMoeda, 
tbdocumentoscompras.TaxaConversao, 
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
Sum((case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as Quantidade,
Sum(isnull(tbdocumentoscompraslinhas.PrecoUnitario,0)*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as Valor,
Sum((isnull(tbdocumentoscompraslinhas.PrecoUnitario,0)-isnull(tbdocumentoscompraslinhas.PrecoUnitarioEfetivo,0))*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end))  as Desconto,
Sum(isnull(tbdocumentoscompraslinhas.PrecoUnitarioEfetivo,0)*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as Liquido,
Sum(isnull(tbdocumentoscompraslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as TotalValor,
Sum(isnull(tbdocumentoscompraslinhas.PCMAtualMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as TotalCustoMedio

FROM tbdocumentoscompras AS tbdocumentoscompras with (nolock) 
LEFT JOIN tbdocumentoscompraslinhas AS tbdocumentoscompraslinhas with (nolock) ON tbdocumentoscompraslinhas.iddocumentocompra=tbdocumentoscompras.ID
LEFT JOIN tbArtigos AS tbArtigos with (nolock) ON tbArtigos.id=tbdocumentoscompraslinhas.IDArtigo
LEFT JOIN tbMarcas as tbMarcas with (nolock) ON tbMarcas.ID=tbArtigos.IDMarca
LEFT JOIN tbLojas as tbLojas with (nolock) ON tbLojas.ID=tbdocumentoscompras.IDLoja
LEFT JOIN tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbdocumentoscompras.IDEstado
LEFT JOIN tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
LEFT JOIN tbUnidades as tbUnidades with (nolock) ON tbUnidades.ID=tbArtigos.IDUnidade
LEFT JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbdocumentoscompras.IDTipoDocumento
LEFT JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbSistemaTiposDocumento.ID=tbTiposDocumento.IDSistemaTiposDocumento
LEFT JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbSistemaNaturezas.ID=tbTiposDocumento.IDSistemaNaturezas
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbdocumentoscompras.IDTiposDocumentoSeries
LEFT JOIN tbArtigosLotes AS tbArtigosLotes with (nolock) ON tbArtigosLotes.ID = tbdocumentoscompraslinhas.IDLote
LEFT JOIN tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.ID = tbdocumentoscompras.IDEntidade
LEFT JOIN tbtiposartigos AS tbtiposartigos with (nolock) ON tbtiposartigos.ID = tbArtigos.IDtipoartigo
LEFT JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbdocumentoscompras.IDMoeda
where 
tbsistematiposestados.codigo=''EFT'' and tbsistematiposdocumento.tipo=''CmpFinanceiro''
group by 
tbArtigos.Codigo,tbArtigos.Descricao,tbArtigosLotes.Codigo ,tbArtigosLotes.Descricao ,tbTiposArtigos.Codigo ,tbTiposArtigos.Descricao ,tbLojas.Codigo ,tbLojas.Descricao ,tbFornecedores.Codigo ,tbFornecedores.Nome ,tbMarcas.Codigo,tbMarcas.Descricao,
tbdocumentoscompras.IDMoeda, tbdocumentoscompras.TaxaConversao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais')