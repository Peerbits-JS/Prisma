/* ACT BD EMPRESA VERSAO 51*/
EXEC('update [F3MOGeral].[dbo].[tbMenus] set ativo=1 where id in (1,2,3,4,5,6,7,12,14,16) and ativo=0')
EXEC('update tbartigos set CodigoBarras=codigo where CodigoBarras ='''' or CodigoBarras  is null')
EXEC('IF NOT EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id(''tbExamesProps'') AND NAME =''tbExamesProps_IDExame'')
CREATE INDEX tbExamesProps_IDExame ON tbExamesProps (IDExame)')

--alterar função de inventário
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
