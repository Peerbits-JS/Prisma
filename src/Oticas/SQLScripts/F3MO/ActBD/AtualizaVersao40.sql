/* ACT BD EMPRESA VERSAO 40*/
--incluir campos composicao e cor generica nas análises
--views
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaMargemVendas'')) drop view vwMapaMargemVendas')

EXEC('create view [dbo].[vwMapaMargemVendas] as
select 
tbLojas.Codigo as CodigoLoja,
tbLojas.Descricao as DescricaoLoja,
tbMarcas.Codigo as CodigoMarca,
tbMarcas.Descricao as DescricaoMarca,
tbTiposArtigos.Codigo as CodigoTipoArtigo,
tbTiposArtigos.Descricao as DescricaoTipoArtigo,
tbArtigos.Codigo as CodigoArtigo,
tbArtigos.Descricao as DescricaoArtigo,
tbFornecedores.Codigo as CodigoFornecedor,
tbFornecedores.Nome as DescricaoFornecedor,
tbComposicoes.Codigo as CodigoComposicao,
tbComposicoes.Descricao as DescricaoComposicao,
(case when not tbaros.CodigoCor is null then tbaros.CodigoCor else tboculossol.CodigoCor end) as CodigoCor,
(case when not tbaros.CorGenerica is null then tbaros.CorGenerica else tboculossol.CorGenerica end) as CorGenerica,
tbDocumentosVendas.IDMoeda, 
tbDocumentosVendas.TaxaConversao, 
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
tbMoedas.CasasDecimaisTotais as ValorVendanumcasasdecimais,
tbMoedas.CasasDecimaisTotais as PrecoCustonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as ValorCustonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as ValorMargemnumcasasdecimais,
tbUnidades.NumeroDeCasasDecimais as Quantidadenumcasasdecimais,
Sum((case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Quantidade,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as ValorVenda,
Sum(isnull(tbdocumentosVendaslinhas.UPCMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as PrecoCusto,
Sum(isnull(tbdocumentosVendaslinhas.PCMAtualMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as ValorCusto

,(Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) 
-Sum(isnull(tbdocumentosVendaslinhas.PCMAtualMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end))) 
as ValorMargem

,cast((case when (Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)))=0 then 0 
else
(Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) 
-Sum(isnull(tbdocumentosVendaslinhas.PCMAtualMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)))*100
/(Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end))) 
end) as decimal(30,2)) as Margem

FROM tbdocumentosVendas AS tbdocumentosVendas with (nolock) 
LEFT JOIN tbdocumentosVendaslinhas AS tbdocumentosVendaslinhas with (nolock) ON tbdocumentosVendaslinhas.iddocumentoVenda=tbdocumentosVendas.ID
LEFT JOIN tbUnidades as tbUnidades with (nolock) ON tbUnidades.id=tbdocumentosVendaslinhas.IDUnidade
LEFT JOIN tbArtigos AS tbArtigos with (nolock) ON tbArtigos.id=tbdocumentosVendaslinhas.IDArtigo
LEFT JOIN tbArtigosFornecedores AS tbArtigosFornecedores with (nolock) ON tbArtigos.id=tbArtigosFornecedores.IDArtigo and tbArtigosFornecedores.Ordem=1
LEFT JOIN tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.id=tbArtigosFornecedores.IDFornecedor and tbArtigosFornecedores.Ordem=1
LEFT JOIN tbMarcas as tbMarcas with (nolock) ON tbMarcas.ID=tbArtigos.IDMarca
LEFT JOIN tbLojas as tbLojas with (nolock) ON tbLojas.ID=tbdocumentosVendas.IDLoja
LEFT JOIN tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbdocumentosVendas.IDEstado
LEFT JOIN tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
LEFT JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbdocumentosVendas.IDTipoDocumento
LEFT JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbSistemaTiposDocumento.ID=tbTiposDocumento.IDSistemaTiposDocumento
LEFT JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbSistemaNaturezas.ID=tbTiposDocumento.IDSistemaNaturezas
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbdocumentosVendas.IDTiposDocumentoSeries
LEFT JOIN tbArtigosLotes AS tbArtigosLotes with (nolock) ON tbArtigosLotes.ID = tbdocumentosVendaslinhas.IDLote
LEFT JOIN tbClientes AS tbClientes with (nolock) ON tbClientes.ID = tbdocumentosVendas.IDEntidade
LEFT JOIN tbtiposartigos AS tbtiposartigos with (nolock) ON tbtiposartigos.ID = tbArtigos.IDtipoartigo
LEFT JOIN tbParametrosEmpresa as P with (nolock) ON 1 = 1
LEFT JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=P.IDMoedaDefeito
LEFT JOIN tbComposicoes AS tbComposicoes ON tbArtigos.IDComposicao = tbComposicoes.id
LEFT JOIN tbaros AS tbaros ON tbArtigos.ID = tbaros.idartigo
LEFT JOIN tboculossol AS tboculossol ON tbArtigos.ID = tboculossol.idartigo
where tbsistematiposestados.codigo=''EFT'' and tbsistematiposdocumento.tipo=''VndFinanceiro''
group by 
tbLojas.Codigo,tbLojas.Descricao,tbTiposArtigos.Codigo,tbTiposArtigos.Descricao, tbMarcas.Codigo,tbMarcas.Descricao,tbFornecedores.Codigo ,tbFornecedores.Nome,tbArtigos.Codigo,tbArtigos.Descricao, 
tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbUnidades.NumeroDeCasasDecimais, tbComposicoes.Codigo,tbComposicoes.Descricao, 
(case when not tbaros.CodigoCor is null then tbaros.CodigoCor else tboculossol.CodigoCor end),(case when not tbaros.CorGenerica is null then tbaros.CorGenerica else tboculossol.CorGenerica end)
')



EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwCCArtigos'')) drop view vwCCArtigos')

EXEC('
BEGIN
EXECUTE(''create view vwCCArtigos as
select 
(CASE WHEN isnull(tbCCStockArtigos.NumeroDocumento,0) = 0 THEN tbCCStockArtigos.VossoNumeroDocumento
                         ELSE tbTiposDocumento.Codigo + '''' '''' + isnull(tbTiposDocumentoSeries.CodigoSerie,'''''''') + ''''/'''' + CAST(tbCCStockArtigos.NumeroDocumento AS nvarchar(20)) END) as Documento,
(CASE WHEN isnull(tbCCStockArtigos.NumeroDocumentoOrigem,0) = 0 THEN tbCCStockArtigos.VossoNumeroDocumentoOrigem
                         ELSE tbTiposDocumentoOrigem.Codigo + '''' '''' + isnull(tbTiposDocumentoSeriesOrigem.CodigoSerie,'''''''') + ''''/'''' + CAST(tbCCStockArtigos.NumeroDocumentoOrigem AS nvarchar(20)) END) as DocumentoOrigem,
tbCCStockArtigos.NumeroDocumento,
tbCCStockArtigos.DataDocumento,
tbArtigos.Codigo as CodigoArtigo,
tbArtigos.Codigo + ''''-'''' + tbArtigos.Descricao as DescricaoArtigo,
tbArtigos.Ativo as Ativo,
tbLojas.Codigo as CodigoLoja,
tbLojas.Descricao as DescricaoLoja,
tbArmazens.Codigo as CodigoArmazem,
tbArmazens.Descricao as DescricaoArmazem,
tbArmazensLocalizacoes.Codigo as CodigoLocalizacao,
tbArmazensLocalizacoes.Descricao as DescricaoLocalizacao,
tbArtigosLotes.Codigo as CodigoLote,
tbArtigosLotes.Descricao as DescricaoLote,
tbTiposDocumento.Descricao as DescricaoTipoDocumento,
tbTiposArtigos.Descricao as DescricaoTipoArtigo,
tbComposicoes.Codigo as CodigoComposicao,
tbComposicoes.Descricao as DescricaoComposicao,
(case when not tbaros.CodigoCor is null then tbaros.CodigoCor else tboculossol.CodigoCor end) as CodigoCor,
(case when not tbaros.CorGenerica is null then tbaros.CorGenerica else tboculossol.CorGenerica end) as CorGenerica,
(case when tbCCStockArtigos.idtipoentidade<4 then tbClientes.Codigo else tbFornecedores.Codigo end) as CodigoCF,
(case when tbCCStockArtigos.idtipoentidade<4 then tbClientes.Nome else tbFornecedores.Nome end) as DescricaoCF,
tbDimensoesLinhas.Descricao as DescricaoDimensaoLinha1,
tbDimensoesLinhas1.Descricao as DescricaoDimensaoLinha2,
(case when tbCCStockArtigos.Natureza=''''E'''' then ''''Entrada'''' else ''''Saida'''' end) as Natureza,
tbCCStockArtigos.QtdStockAtual,
tbCCStockArtigos.QtdStockAnterior,
isnull(tbCCStockArtigos.PCMAtualMoedaRef,0) as PCMAtualMoedaRef,
isnull(tbCCStockArtigos.PCMAnteriorMoedaRef,0) as PCMAnteriorMoedaRef,
(case when tbCCStockArtigos.Natureza=''''E'''' then tbCCStockArtigos.Quantidade else -(tbCCStockArtigos.Quantidade) end) as QtdLinhaStock,
Round(isnull((
select Sum((Case tbCCStockAgreg.Natureza when ''''E'''' then 1 else -1 end) * tbCCStockAgreg.Quantidade) FROM tbCCStockArtigos as tbCCStockAgreg
WHERE tbCCStockAgreg.IDartigo = tbCCStockArtigos.IDartigo
and   isnull(tbCCStockAgreg.IDArtigoDimensao,0) = isnull(tbCCStockArtigos.IDArtigoDimensao,0)   
and   isnull(tbCCStockAgreg.IDArmazem,0) = isnull(tbCCStockArtigos.IDArmazem,0)   
and   isnull(tbCCStockAgreg.IDArmazemLocalizacao,0) = isnull(tbCCStockArtigos.IDArmazemLocalizacao,0)   
AND (tbCCStockAgreg.Natureza =''''E'''' OR tbCCStockAgreg.Natureza =''''S'''')
AND tbCCStockAgreg.DataControloInterno <= tbCCStockArtigos.DataControloInterno
AND ((tbCCStockAgreg.IDTipoDocumento<>tbCCStockArtigos.IDTipoDocumento OR tbCCStockAgreg.IDDocumento <> tbCCStockArtigos.IDDocumento
       ) OR (tbCCStockAgreg.IDTipoDocumento = tbCCStockArtigos.IDTipoDocumento AND tbCCStockAgreg.IDDocumento = tbCCStockArtigos.IDDocumento
                     AND tbCCStockAgreg.ID<=tbCCStockArtigos.ID
                     )
       )
),0),isnull(tbUnidades.NumeroDeCasasDecimais,0)) as QuantidadeStock,
tbCCStockArtigos.QuantidadeStock2 as QtdLinhaStock2,
Round(isnull((
select Sum((Case tbCCStockAgreg.Natureza when ''''E'''' then 1 else -1 end) * tbCCStockAgreg.QuantidadeStock2) FROM tbCCStockArtigos as tbCCStockAgreg
WHERE tbCCStockAgreg.IDartigo = tbCCStockArtigos.IDartigo
and   isnull(tbCCStockAgreg.IDArtigoDimensao,0) = isnull(tbCCStockArtigos.IDArtigoDimensao,0)   
and   isnull(tbCCStockAgreg.IDArmazem,0) = isnull(tbCCStockArtigos.IDArmazem,0)   
and   isnull(tbCCStockAgreg.IDArmazemLocalizacao,0) = isnull(tbCCStockArtigos.IDArmazemLocalizacao,0)   
AND (tbCCStockAgreg.Natureza =''''E'''' OR tbCCStockAgreg.Natureza =''''S'''')
AND tbCCStockAgreg.DataControloInterno <= tbCCStockArtigos.DataControloInterno 
AND ((tbCCStockAgreg.IDTipoDocumento<>tbCCStockArtigos.IDTipoDocumento OR tbCCStockAgreg.IDDocumento <> tbCCStockArtigos.IDDocumento
       ) OR (tbCCStockAgreg.IDTipoDocumento = tbCCStockArtigos.IDTipoDocumento AND tbCCStockAgreg.IDDocumento = tbCCStockArtigos.IDDocumento
                     AND tbCCStockAgreg.ID<=tbCCStockArtigos.ID
                     )
       )
),0),isnull(tbUnidades2.NumeroDeCasasDecimais,0)) as QuantidadeStock2,
isnull(tbCCStockArtigos.PrecoUnitarioEfetivoMoedaRef,0) as PrecoUnitarioMoedaRef,
isnull(tbCCStockArtigos.Recalcular,0) as RecalcularCustoMedio,
tbCCStockArtigos.DataControloInterno 
FROM tbCCStockArtigos AS tbCCStockArtigos
LEFT JOIN tbArtigos AS tbArtigos ON tbArtigos.id=tbCCStockArtigos.IDArtigo
LEFT JOIN tbUnidades as tbUnidades ON tbUnidades.ID=tbArtigos.IDUnidade
LEFT JOIN tbUnidades as tbUnidades2 ON tbUnidades2.ID=tbArtigos.IDUnidadeStock2
LEFT JOIN tbArtigosDimensoes AS tbArtigosDimensoes ON (tbArtigosDimensoes.ID = tbCCStockArtigos.IDArtigoDimensao and tbArtigosDimensoes.IDArtigo=tbArtigos.ID) 
LEFT JOIN tbDimensoesLinhas AS tbDimensoesLinhas ON tbDimensoesLinhas.ID = tbArtigosDimensoes.IDDimensaoLinha1
LEFT JOIN tbDimensoesLinhas AS tbDimensoesLinhas1 ON tbDimensoesLinhas1.ID = tbArtigosDimensoes.IDDimensaoLinha2
LEFT JOIN tbArmazens AS tbArmazens ON tbArmazens.ID = tbCCStockArtigos.IDArmazem
LEFT JOIN tbArmazensLocalizacoes AS tbArmazensLocalizacoes ON (tbArmazensLocalizacoes.IDArmazem =tbArmazens.ID and tbArmazensLocalizacoes.ID = tbCCStockArtigos.IDArmazemLocalizacao)
LEFT JOIN tbTiposDocumento AS tbTiposDocumento ON tbTiposDocumento.ID=tbCCStockArtigos.IDTipoDocumento
LEFT JOIN tbTiposDocumento AS tbTiposDocumentoOrigem ON tbTiposDocumentoOrigem.ID=tbCCStockArtigos.IDTipoDocumentoOrigem
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries ON tbTiposDocumentoSeries.ID=tbCCStockArtigos.IDTiposDocumentoSeries
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeriesOrigem ON tbTiposDocumentoSeriesOrigem.ID=tbCCStockArtigos.IDTiposDocumentoSeriesOrigem
LEFT JOIN tbArtigosLotes AS tbArtigosLotes ON tbArtigosLotes.ID = tbCCStockArtigos.IDArtigoLote
LEFT JOIN tbFornecedores AS tbFornecedores ON tbFornecedores.ID = tbCCStockArtigos.IDEntidade
LEFT JOIN tbclientes AS tbclientes ON tbclientes.ID = tbCCStockArtigos.IDEntidade
LEFT JOIN tbtiposartigos AS tbtiposartigos ON tbtiposartigos.ID = tbArtigos.IDtipoartigo
LEFT JOIN tbLojas AS tbLojas ON tbLojas.ID = tbCCStockArtigos.IDLoja
LEFT JOIN tbComposicoes AS tbComposicoes ON tbArtigos.IDComposicao = tbComposicoes.id
LEFT JOIN tbaros AS tbaros ON tbArtigos.ID = tbaros.idartigo
LEFT JOIN tboculossol AS tboculossol ON tbArtigos.ID = tboculossol.idartigo
ORDER BY DataControloInterno, tbCCStockArtigos.ID  OFFSET 0 ROWS 
'')
END')


EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnInventarioData]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnInventarioData]')

EXEC('CREATE FUNCTION [dbo].[fnInventarioData] (@Data as date, @IDValorizado as int)
RETURNS TABLE
AS
RETURN (
	   select @Data as Data, cc.idartigo, CodigoArtigo, DescricaoArtigo, CodigoTipoArtigo, DescricaoTipoArtigo, CodigoMarca, DescricaoMarca,cc.IDArmazem, CodigoArmazem, DescricaoArmazem, 
	   cc.IDArmazemLocalizacao, CodigoArmazemLocalizacao, DescricaoArmazemLocalizacao, CodigoLote, DescricaoLote, UltimaEntrada, UltimaSaida, Quantidade, Medio, UltimoPrecoCompra, CustoPadrao, 
	   CodigoComposicao,DescricaoComposicao,CodigoCor,CorGenerica,
	   (case when @IDValorizado=12 then CustoPadrao when @IDValorizado=13 then Medio when @IDValorizado=14 then UltimoPrecoCompra else Preco end) as Preco, 
	   (case when @IDValorizado=12 then CustoPadrao when @IDValorizado=13 then Medio when @IDValorizado=14 then UltimoPrecoCompra else Preco end)*Quantidade as TotalMoeda,
	   Ativo, Gerestock, Inventariado, 
	   Codigofornecedor, DescricaoFornecedor, 2 as Quantidadenumcasasdecimais, 3 as Preconumcasasdecimais, 3 as TotalMoedanumcasasdecimais  
	   from (select ar.id as idartigo, ar.codigo as CodigoArtigo, ar.Descricao as DescricaoArtigo, ta.codigo as CodigoTipoArtigo, ta.Descricao as DescricaoTipoArtigo, ma.codigo as CodigoMarca, ma.Descricao as DescricaoMarca, 
		isnull(ar.Padrao,0) as CustoPadrao, isnull(ap.valorcomiva,0) as Preco, ar.ativo, ar.gerestock, ar.inventariado, isnull(f.Codigo,'''') as CodigoFornecedor, isnull(f.Nome,'''') as DescricaoFornecedor,
		tbComposicoes.Codigo as CodigoComposicao,
		tbComposicoes.Descricao as DescricaoComposicao,
		(case when not tbaros.CodigoCor is null then tbaros.CodigoCor else tboculossol.CodigoCor end) as CodigoCor,
		(case when not tbaros.CorGenerica is null then tbaros.CorGenerica else tboculossol.CorGenerica end) as CorGenerica
		from tbartigos ar 
		LEFT JOIN tbtiposartigos AS ta ON ta.ID = ar.IDtipoartigo
		LEFT JOIN tbMarcas AS ma ON ma.ID = ar.IDmarca
		LEFT JOIN tbComposicoes AS tbComposicoes ON ar.IDComposicao = tbComposicoes.id
		LEFT JOIN tbaros AS tbaros ON ar.ID = tbaros.idartigo
		LEFT JOIN tboculossol AS tboculossol ON ar.ID = tboculossol.idartigo
		left join tbartigosprecos ap on ar.id=ap.idartigo and ap.idcodigopreco=@IDValorizado-1 and ap.idloja is null
		left join tbartigosfornecedores af on ar.id=af.idartigo and af.ordem=1
		left join tbfornecedores f on f.id=af.idfornecedor) a

		inner join
		(select idartigo, IDArmazem, IDArmazemLocalizacao,  
		max((Case Natureza when ''E'' then DataDocumento else null end)) as UltimaEntrada, 
		max((Case Natureza when ''S'' then DataDocumento else null end)) as UltimaSaida
		FROM tbCCStockArtigos  
		where DataDocumento<=dateadd(d,1,@Data)
		group by idartigo, IDArmazem, IDArmazemLocalizacao) b on a.idartigo=b.idartigo
		
		left join
		(Select idartigo, UltimoPrecoCompra from (select idartigo, isnull(UPCMoedaRef,0) as UltimoPrecoCompra, ROW_NUMBER() OVER (PARTITION BY IDArtigo Order by DataDocumento desc) as lin 
		from tbCCStockArtigos where datadocumento<dateadd(d,1,@Data)) p where p.lin=1) c on a.idartigo=c.idartigo

		left join
		(Select idartigo, Medio from (select idartigo, isnull(PCMAtualMoedaRef,0) as Medio, ROW_NUMBER() OVER (PARTITION BY IDArtigo Order by DataDocumento desc) as lin 
		from tbCCStockArtigos where datadocumento<=dateadd(d,1,@Data)) p where p.lin=1) d on a.idartigo=d.idartigo

		left join
		(select tbCCStockArtigos.IDArtigo, tbCCStockArtigos.IDArmazem, tbCCStockArtigos.IDArmazemLocalizacao, 
		tbArmazens.Codigo as CodigoArmazem, tbArmazens.Descricao as DescricaoArmazem,
		tbArmazensLocalizacoes.Codigo as CodigoArmazemLocalizacao, tbArmazensLocalizacoes.Descricao as DescricaoArmazemLocalizacao,
		tbArtigosLotes.Codigo as CodigoLote, tbArtigosLotes.Descricao as DescricaoLote,
		isnull(Sum((Case tbCCStockArtigos.Natureza when ''E'' then 1 else -1 end) * tbCCStockArtigos.Quantidade),0) as Quantidade 
		FROM tbCCStockArtigos left join tbArmazens on tbCCStockArtigos.IDArmazem=tbArmazens.id 
		left join tbArmazensLocalizacoes on tbCCStockArtigos.IDArmazemLocalizacao=tbArmazensLocalizacoes.id
		left join tbArtigosLotes on tbCCStockArtigos.IDArtigoLote=tbArtigosLotes.id
		where DataDocumento<=dateadd(d,1,@Data)
		group by tbCCStockArtigos.IDArtigo, tbCCStockArtigos.IDArmazem, tbCCStockArtigos.IDArmazemLocalizacao, tbArmazens.Codigo, tbArmazens.Descricao ,
		tbArmazensLocalizacoes.Codigo , tbArmazensLocalizacoes.Descricao,tbArtigosLotes.Codigo, tbArtigosLotes.Descricao) cc
		on b.idartigo=cc.idartigo and b.IDArmazem=cc.idarmazem and b.IDArmazemLocalizacao=cc.IDArmazemLocalizacao
)')

--colunas

EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Conta Corrente de Artigos''
IF NOT EXISTS(SELECT ID FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] where [IDListaPersonalizada]=@IDLista and colunavista=''CodigoComposicao'' )
BEGIN
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoComposicao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbComposicoes'', 0, 5, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoComposicao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoCor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CorGenerica'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 70)
END
END')

EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Mapa de Margem de Vendas''
IF NOT EXISTS(SELECT ID FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] where [IDListaPersonalizada]=@IDLista and colunavista=''CodigoComposicao'' )
BEGIN
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoComposicao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbComposicoes'', 0, 5, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoComposicao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoCor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CorGenerica'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 70)
END
END')

EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Inventário à data''
IF NOT EXISTS(SELECT ID FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] where [IDListaPersonalizada]=@IDLista and colunavista=''CodigoComposicao'' )
BEGIN
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoComposicao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbComposicoes'', 0, 5, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoComposicao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoCor'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 70)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CorGenerica'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 1, 70)
END
END')

EXEC('IF NOT EXISTS(SELECT * FROM [dbo].[tbMapasVistas] WHERE ID=48) 
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
DELETE FROM [dbo].[tbMapasVistas] WHERE ID=48
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (48, 48, N''Receita'', N''ReceitaA5H'', N''rptReceitaA5H'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, 2, NULL, NULL, @IDLoja, N''select c.nome as DescricaoCliente, m.Nome as DescricaoMedicoTecnico, m.Observacoes as DadosMedicoTecnico, c.NContribuinte as NContribuinte, c.NumeroBeneficiario1 as NumeroBeneficiario1, c.NumeroBeneficiario2 as NumeroBeneficiario2, c.Codigo as CodigoCliente, e1.codigo as CodigoEntidade1, e2.codigo as CodigoEntidade2,e.Descricao as DescricaoEspecialidade, x.* from vwExamesProps x left join tbClientes c on x.idcliente=c.id left join tbMedicosTecnicos m on x.idmedicotecnico=m.id left join tbEspecialidades e on x.IDespecialidade=e.id left join tbEntidades e1 on c.identidade1=e1.id left join tbEntidades e2 on c.identidade2=e2.id'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')

EXEC('Update [F3MOGeral].dbo.tbParametrosListasPersonalizadas set CampoValor=''UserName'' where ModelPropertyName=''IDUtilizadorF''')

--SP de recálculo de PCM_UPC
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_Recalculo_PCM_UPC]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_Recalculo_PCM_UPC]')

EXEC('CREATE PROCEDURE [dbo].[sp_Recalculo_PCM_UPC] 
	@IDRecalculo as bigint
AS
DECLARE db_cursor CURSOR FOR SELECT C.ID, C.IDArtigo, Natureza, isnull(TD.CustoMedio,0) as CustoMedio, isnull(QuantidadeStock,0), isnull(PrecoUnitarioEfetivoMoedaRef,0) + isnull(UltCustosAdicionaisMoedaRef,0), isnull(PrecoUnitarioMoedaRef,0), isnull(UltCustosAdicionaisMoedaRef,0), isnull(UltDescComerciaisMoedaRef,0)
from tbCCStockArtigos C with (nolock) inner join tbf3mrecalculo on c.idartigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo 
left join tbTiposDocumento TD with (nolock) on C.IDTipoDocumento=TD.id 
left join tbSistemaTiposDocumento STD with (nolock) on TD.IDSistemaTiposDocumento=STD.id
order by c.idartigo, c.DataControloInterno, c.ID; 

DECLARE @ID bigint;
DECLARE @IDArtigo bigint;
DECLARE @IDArtigoAux bigint;
DECLARE @Natureza varchar(10); 
DECLARE @QuantidadeStock float; 
DECLARE @QtdStockAnterior float; 
DECLARE @QtdStockAtual float;
DECLARE @PCMAnteriorMoedaRef decimal(30,4);  
DECLARE @PCMAtualMoedaRef decimal(30,4); 
DECLARE @UPCMoedaRef decimal(30,4); 
DECLARE @CustoMedio decimal(30,4);
DECLARE @PrecoUnitarioEfetivoMoedaRef decimal(30,4);
DECLARE @UltCustosAdicionaisMoedaRef decimal(30,4);
DECLARE @UltDescComerciaisMoedaRef decimal(30,4);
DECLARE @CM bit;

set @QtdStockAnterior=0;
set @QtdStockAtual=0;
set @IDArtigoAux=0;
set @PCMAnteriorMoedaRef=0;
set @CustoMedio=0;
set @IDArtigo=0;
set @PrecoUnitarioEfetivoMoedaRef=0;
set @CM=0;

OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @ID, @IDArtigo, @Natureza, @CM, @QuantidadeStock, @PrecoUnitarioEfetivoMoedaRef, @UPCMoedaRef, @UltCustosAdicionaisMoedaRef, @UltDescComerciaisMoedaRef;
WHILE @@FETCH_STATUS = 0  
BEGIN 

if @IDArtigoAux<>@IDArtigo 
begin
set @IDArtigoAux=@IDArtigo;
set @QtdStockAnterior=0;
set @QtdStockAtual=0;
set @PCMAnteriorMoedaRef=0;
set @CustoMedio=0;
end
else
begin
set @IDArtigoAux=@IDArtigo;
end

IF @Natureza=''E''
begin
SET @QtdStockAnterior=@QtdStockAtual;
SET @PCMAnteriorMoedaRef=@CustoMedio;
SET @QtdStockAtual=@QtdStockAtual+@QuantidadeStock;
end 
else
begin
set @PrecoUnitarioEfetivoMoedaRef=@CustoMedio;
SET @QtdStockAnterior=@QtdStockAtual;
SET @QtdStockAtual=@QtdStockAtual-@QuantidadeStock;
SET @PCMAnteriorMoedaRef=@CustoMedio;
end 

IF (@QtdStockAnterior+@QuantidadeStock)<=0
begin
set @CustoMedio=0;
end
else
begin

if @QtdStockAnterior<0 
begin
set @CustoMedio=@PrecoUnitarioEfetivoMoedaRef;
end
else
begin
set @CustoMedio=CAST((@QtdStockAnterior*@PCMAnteriorMoedaRef+@PrecoUnitarioEfetivoMoedaRef*@QuantidadeStock)/(@QtdStockAnterior+@QuantidadeStock) as decimal(30,4));
end
end

update tbCCStockArtigos set QtdStockAtual=@QtdStockAtual, QtdStockAnterior=@QtdStockAnterior, PCMAnteriorMoedaRef=@PCMAnteriorMoedaRef, PCMAtualMoedaRef=@CustoMedio, UPCompraMoedaRef=@PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef=@UPCMoedaRef, recalcular=0 where id=@ID;

IF @Natureza=''E'' and @CM=1
begin
update tbartigos set medio=@CustoMedio, UltimoPrecoCusto=@PrecoUnitarioEfetivoMoedaRef, UltimoPrecoCompra=@UPCMoedaRef, UltimosCustosAdicionais=@UltCustosAdicionaisMoedaRef, UltimosDescontosComerciais=@UltDescComerciaisMoedaRef where id=@IDArtigo;
end 
else
begin
update tbartigos set medio=@CustoMedio where id=@IDArtigo;
end 

FETCH NEXT FROM db_cursor INTO @ID, @IDArtigo, @Natureza, @CM, @QuantidadeStock, @PrecoUnitarioEfetivoMoedaRef, @UPCMoedaRef, @UltCustosAdicionaisMoedaRef, @UltDescComerciaisMoedaRef;
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;')

--função de inventário
EXEC('IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[fnInventarioData]'') AND xtype IN (N''FN'', N''IF'', N''TF'')) DROP FUNCTION [fnInventarioData]')

EXEC('CREATE FUNCTION [dbo].[fnInventarioData] (@Data as date, @IDValorizado as int)
RETURNS TABLE
AS
RETURN (
	   select @Data as Data, cc.idartigo, CodigoArtigo, DescricaoArtigo, CodigoTipoArtigo, DescricaoTipoArtigo, CodigoMarca, DescricaoMarca,cc.IDArmazem, CodigoArmazem, DescricaoArmazem, 
	   cc.IDArmazemLocalizacao, CodigoArmazemLocalizacao, DescricaoArmazemLocalizacao, CodigoLote, DescricaoLote, UltimaEntrada, UltimaSaida, Quantidade, Medio, UltimoPrecoCompra, CustoPadrao, 
	   (case when @IDValorizado=12 then CustoPadrao when @IDValorizado=13 then Medio when @IDValorizado=14 then UltimoPrecoCompra else Preco end) as Preco, 
	   (case when @IDValorizado=12 then CustoPadrao when @IDValorizado=13 then Medio when @IDValorizado=14 then UltimoPrecoCompra else Preco end)*Quantidade as TotalMoeda,
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
		(Select idartigo, UltimoPrecoCompra from (select idartigo, isnull(UPCMoedaRef,0) as UltimoPrecoCompra, ROW_NUMBER() OVER (PARTITION BY IDArtigo Order by DataDocumento desc) as lin 
		from tbCCStockArtigos where datadocumento<dateadd(d,1,@Data)) p where p.lin=1) c on a.idartigo=c.idartigo

		left join
		(Select idartigo, Medio from (select idartigo, isnull(PCMAtualMoedaRef,0) as Medio, ROW_NUMBER() OVER (PARTITION BY IDArtigo Order by DataDocumento desc) as lin 
		from tbCCStockArtigos where datadocumento<dateadd(d,1,@Data)) p where p.lin=1) d on a.idartigo=d.idartigo

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

--esconder opção de valorização
EXEC('update tbparametroscamposcontexto set ativo=0 where descricaocampo=''ValorizacaoDoStock''')

--atualizar sp_AtualizaCCEntidades
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaCCEntidades]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaCCEntidades]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaCCEntidades]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0,
	@strUtilizador AS nvarchar(256) = '''',
	@lngidEntidade AS bigint = NULL
AS  BEGIN
SET NOCOUNT ON

DECLARE @strSqlQuery AS varchar(max),--variavel para querys dinamicos
	@strSqlQueryAux AS varchar(max),--variavel para querys dinamicos
	@strSqlQueryUpdates AS varchar(max),--variavel para querys dinamicos
	@strSqlQueryInsert AS varchar(max),--varivale para a parte do insert
	@strFiltro as nvarchar(1024),--variavel para a parte do insert
	@strFiltroIns as nvarchar(1024),--variavel para a parte do insert

	@ErrorMessage   varchar(2000),
	@ErrorSeverity  tinyint,
	@ErrorState     tinyint,
	@rowcount INT

BEGIN TRY
	--Verificar se o tipo de documento gere conta corrente
	IF EXISTS(SELECT ID FROM tbTiposDocumento WHERE ISNULL(GereContaCorrente,0)<>0 AND ID=@lngidTipoDocumento)
		BEGIN
		IF (@intAccao = 0) OR (@intAccao = 1)
			BEGIN
				IF @lngidDocumento>0
					BEGIN
						SET @strFiltro='' and IDDocumento='' + cast(@lngidDocumento as nvarchar(50))
						SET @strFiltroIns='' and DV.ID='' + cast(@lngidDocumento as nvarchar(50))
					END
				ELSE
					BEGIN
						SET @strFiltro=''''
						SET @strFiltroIns=''''
					END

				SET @strSqlQuery=''DELETE FROM tbCCEntidades where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)

				SET @strSqlQueryInsert = ''insert into tbCCEntidades ([Natureza], [IDLoja], [IDTipoEntidade],[IDEntidade],[NomeFiscal],[IDTipoDocumento],[IDTipoDocumentoSeries],[IDDocumento],[NumeroDocumento],
										[DataDocumento],[Descricao], [IDMoeda], [TotalMoeda],[TotalMoedaReferencia],[TaxaConversao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao])''
								
				SELECT @strSqlQuery = @strSqlQueryInsert + '' select (case when (TD.Adiantamento=1 and TSN.Codigo=''''R'''') then ''''P'''' when (TD.Adiantamento=1 and TSN.Codigo=''''P'''') then ''''R'''' else TSN.Codigo end) as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbdocumentosvendas DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)


				SELECT @strSqlQuery = @strSqlQueryInsert + '' select (case when (TSN.Codigo=''''R'''') then ''''P'''' when (TSN.Codigo=''''P'''') then ''''R'''' else TSN.Codigo end) as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbdocumentosvendas DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where TD.Adiantamento=0 and TD.GeraPendente=0 and DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns

				EXEC(@strSqlQuery)


				SELECT @strSqlQuery = @strSqlQueryInsert + '' select TSN.Codigo as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbrecibos DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)
			END
		ELSE
			BEGIN
				IF @lngidDocumento>0
					BEGIN
						SET @strFiltro='' and IDDocumento='' + cast(@lngidDocumento as nvarchar(50))
						SET @strFiltroIns='' and DV.ID='' + cast(@lngidDocumento as nvarchar(50))
					END

				SET @strSqlQuery=''DELETE FROM tbCCEntidades where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)
			END

		  UPDATE tbclientes set saldo=tbcc.saldo FROM tbclientes Cli
			   INNER JOIN (
			   select identidade, isnull(sum(case when natureza=''R'' then totalmoedareferencia else -totalmoedareferencia end ),0) as saldo from tbccentidades where identidade=@lngidEntidade group by IDEntidade) tbcc
			   ON Cli.ID= tbcc.identidade
	END
END TRY
	BEGIN CATCH
		SET @ErrorMessage  = ERROR_MESSAGE()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState    = ERROR_STATE()
		RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
	END CATCH
END')

--aviso de nova versão
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.17.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.17.0'', ''A'', ''2019-05-07 00:00'', ''2019-05-07 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.17.0'', ''V'', ''2019-05-13 08:00'', ''2019-05-13 08:00'', ''Funcionalidades da versão'', ''
<li></li>
'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')