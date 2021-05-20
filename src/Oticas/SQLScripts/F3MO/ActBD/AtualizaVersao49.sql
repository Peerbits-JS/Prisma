/* ACT BD EMPRESA VERSAO 49*/
--mapa de iva de vendas
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaIvaVendas'')) drop view vwMapaIvaVendas')

EXEC('create view [dbo].[vwMapaIvaVendas] as
select 
tbDocumentosVendas.ID, 
tbDocumentosVendas.IDLoja, 
tbDocumentosVendas.NomeFiscal, 
tbDocumentosVendas.IDEntidade, 
tbDocumentosVendas.IDTipoDocumento, 
tbDocumentosVendas.IDTiposDocumentoSeries, 
tbDocumentosVendas.NumeroDocumento, 
tbDocumentosVendas.DataDocumento,
tbDocumentosVendas.UtilizadorCriacao as Utilizador,
tbDocumentosVendas.Documento, 
tbDocumentosVendas.IDMoeda, 
tbDocumentosVendas.TaxaConversao, 
tbDocumentosVendas.Ativo as Ativo, 
tbDocumentosVendasLinhas.TaxaIva, 
tbDocumentosVendasLinhas.IDTaxaIva, 
tbLojas.Codigo as CodigoLoja, 
tbLojas.Descricao as DescricaoLoja,
tbClientes.Codigo as CodigoCliente, 
tbClientes.NContribuinte as NContribuinte, 
tbTiposDocumento.Codigo as CodigoTipoDocumento, 
tbTiposDocumento.Descricao as DescricaoTipoDocumento,
tbDocumentosVendasLinhas.CodigoTipoIva as CodigoIva, 
tbCampanhas.Codigo as CodigoCampanha, 
tbsistematiposestados.codigo as CodigoEstado,
tbsistematiposestados.descricao as DescricaoEstado,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIncidencia) as ValorIncidencia,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIVA) as ValorIVA,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIncidencia + tbDocumentosVendasLinhas.ValorIVA) as Valor,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais
FROM tbDocumentosVendas AS tbDocumentosVendas
INNER JOIN tbDocumentosVendasLinhas AS tbDocumentosVendasLinhas ON tbDocumentosVendas.id=tbDocumentosVendasLinhas.IDDocumentoVenda
INNER JOIN tbClientes AS tbClientes with (nolock) ON tbClientes.id=tbDocumentosVendas.IDentidade
INNER JOIN tbLojas AS tbLojas with (nolock) ON tbLojas.id=tbDocumentosVendas.IDLoja
INNER JOIN tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbdocumentosVendas.IDEstado
INNER JOIN tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
INNER JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosVendas.IDMoeda
INNER JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbDocumentosVendas.IDTipoDocumento AND not tbTiposDocumento.idsistematiposdocumentofiscal is null 
INNER JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbTiposDocumento.IDSistemaNaturezas=tbSistemaNaturezas.ID
INNER JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbDocumentosVendas.IDTiposDocumentoSeries
INNER JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbTiposDocumento.IDSistemaTiposDocumento=tbSistemaTiposDocumento.ID
INNER JOIN tbIVA AS tbIVA  with (nolock) ON tbDocumentosVendasLinhas.IDtaxaiva=tbIVA.ID
LEFT JOIN tbCampanhas with (nolock) ON tbDocumentosVendasLinhas.IDCampanha=tbCampanhas.ID
WHERE tbsistematiposestados.codigo<>''RSC'' and tbSistemaTiposDocumento.Tipo=''VndFinanceiro''
GROUP BY tbDocumentosVendas.ID, tbDocumentosVendas.IDLoja, tbDocumentosVendas.NomeFiscal, tbDocumentosVendas.IDEntidade, tbDocumentosVendas.IDTipoDocumento, tbDocumentosVendas.IDTiposDocumentoSeries, tbDocumentosVendas.NumeroDocumento,
tbDocumentosVendas.DataDocumento, tbDocumentosVendas.Documento, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbDocumentosVendas.Ativo, tbDocumentosVendasLinhas.TaxaIva, tbDocumentosVendasLinhas.IDTaxaIva,
tbLojas.Codigo, tbLojas.Descricao, tbClientes.Codigo, tbClientes.Nome, tbClientes.NContribuinte, tbTiposDocumento.Codigo, tbDocumentosVendas.UtilizadorCriacao, 
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end), 
tbSistemaNaturezas.Codigo, tbCampanhas.Codigo, tbsistematiposestados.codigo,tbsistematiposestados.Descricao, tbTiposDocumento.Codigo, tbTiposDocumento.Descricao, tbDocumentosVendasLinhas.CodigoTipoIva, tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao
ORDER BY tbDocumentosVendas.ID  OFFSET 0 ROWS ')

--mapa de iva de compras
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaIvaCompras'')) drop view vwMapaIvaCompras')

EXEC('create view [dbo].[vwMapaIvaCompras] as
select 
tbDocumentosCompras.ID, 
tbDocumentosCompras.IDLoja, 
tbDocumentosCompras.NomeFiscal, 
tbDocumentosCompras.IDEntidade, 
tbDocumentosCompras.IDTipoDocumento, 
tbDocumentosCompras.IDTiposDocumentoSeries, 
tbDocumentosCompras.NumeroDocumento, 
tbDocumentosCompras.DataDocumento,
tbDocumentosCompras.UtilizadorCriacao as Utilizador,
tbDocumentosCompras.Documento, 
tbDocumentosCompras.IDMoeda, 
tbDocumentosCompras.TaxaConversao, 
tbDocumentosCompras.Ativo as Ativo, 
tbDocumentosComprasLinhas.TaxaIva, 
tbDocumentosComprasLinhas.IDTaxaIva, 
tbLojas.Codigo as CodigoLoja, 
tbLojas.Descricao as DescricaoLoja,
tbFornecedores.Codigo as CodigoFornecedor, 
tbFornecedores.NContribuinte as NContribuinte, 
tbTiposDocumento.Codigo as CodigoTipoDocumento, 
tbTiposDocumento.Descricao as DescricaoTipoDocumento,
tbDocumentosComprasLinhas.CodigoTipoIva as CodigoIva, 
tbSistemaTiposEstados.Codigo as Estado,
tbsistematiposestados.descricao as DescricaoEstado,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIncidencia) as ValorIncidencia,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIVA) as ValorIVA,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIncidencia + tbDocumentosComprasLinhas.ValorIVA) as Valor,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais
FROM tbDocumentosCompras AS tbDocumentosCompras
INNER JOIN tbDocumentosComprasLinhas AS tbDocumentosComprasLinhas ON tbDocumentosCompras.id=tbDocumentosComprasLinhas.IDDocumentoCompra
INNER JOIN tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.id=tbDocumentosCompras.IDentidade
INNER JOIN tbLojas AS tbLojas with (nolock) ON tbLojas.id=tbDocumentosCompras.IDLoja
INNER JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosCompras.IDMoeda
INNER JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbDocumentosCompras.IDTipoDocumento AND not tbTiposDocumento.idsistematiposdocumentofiscal is null 
INNER JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbTiposDocumento.IDSistemaNaturezas=tbSistemaNaturezas.ID
INNER JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbDocumentosCompras.IDTiposDocumentoSeries
INNER JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbTiposDocumento.IDSistemaTiposDocumento=tbSistemaTiposDocumento.ID
INNER JOIN tbIVA AS tbIVA  with (nolock) ON tbDocumentosComprasLinhas.IDtaxaiva=tbIVA.ID
INNER JOIN tbestados AS tbestados with (nolock) ON tbDocumentosCompras.IDEstado=tbEstados.ID
INNER JOIN tbSistemaTiposEstados AS tbSistemaTiposEstados with (nolock) ON tbEstados.IDTipoEstado=tbSistemaTiposEstados.ID
WHERE tbsistematiposestados.codigo=''EFT'' and tbSistemaTiposDocumento.Tipo=''CmpFinanceiro''
GROUP BY tbDocumentosCompras.ID, tbDocumentosCompras.IDLoja, tbDocumentosCompras.NomeFiscal, tbDocumentosCompras.IDEntidade, tbDocumentosCompras.IDTipoDocumento, tbDocumentosCompras.IDTiposDocumentoSeries, tbDocumentosCompras.NumeroDocumento,
tbDocumentosCompras.DataDocumento, tbDocumentosCompras.Documento, tbDocumentosCompras.IDMoeda, tbDocumentosCompras.TaxaConversao, tbDocumentosCompras.Ativo, tbDocumentosComprasLinhas.TaxaIva, tbDocumentosComprasLinhas.IDTaxaIva,
tbLojas.Codigo, tbLojas.Descricao, tbFornecedores.Codigo, tbFornecedores.Nome, tbFornecedores.NContribuinte, tbTiposDocumento.Codigo,tbDocumentosCompras.UtilizadorCriacao,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end), tbSistemaTiposEstados.Codigo, tbSistemaNaturezas.Codigo, tbsistematiposestados.codigo, tbsistematiposestados.Descricao, tbTiposDocumento.Codigo, tbTiposDocumento.Descricao, 
tbDocumentosComprasLinhas.CodigoTipoIva,tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao
ORDER BY tbDocumentosCompras.ID  OFFSET 0 ROWS ')