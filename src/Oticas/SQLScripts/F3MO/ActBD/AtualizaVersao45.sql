/* ACT BD EMPRESA VERSAO 45*/
--atualizar lista personalizada de outros devedores
EXEC('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''select tbclientes.ID, tbclientes.Codigo, tbclientes.Nome, tbclientes.NContribuinte, tbclientes.Ativo, mt.Nome as DescricaoMedicoTecnico, tbclientes.Datanascimento, convert(nvarchar(MAX), tbclientes.Datanascimento, 105) as DiaNascimento, 
cc.Telefone, cc.Telemovel, en.Descricao as DescricaoEntidade1, et.Descricao as DescricaoEntidade2, lj.descricao as DescricaoLoja, isnull(tbclientes.saldo, 0) as Saldo, tbclientes.IdTipoEntidade, cast(tbclientes.nome as nvarchar(100)) as DescricaoSplitterLadoDireito ,tbclientes.UtilizadorCriacao
, cm.morada as DescricaoMorada, cp.codigo as codigopostal, cp.descricao as descricaocodigopostal 
from tbclientes  
left join tbLojas lj on tbclientes.idloja=lj.id and tbclientes.idtipoentidade=3
left join tbMedicosTecnicos mt on tbclientes.idmedicotecnico=mt.id
left join tbentidades en on tbclientes.identidade1=en.id
left join tbentidades et on tbclientes.identidade2=et.id
left join tbclientescontatos cc on tbclientes.id=cc.idcliente and cc.ordem=1
left join tbclientesmoradas cm on tbclientes.id=cm.idcliente and cm.ordem=1
left join tbcodigospostais cp on cp.id=cm.idcodigopostal ''
where id in (65)')


--inserir novo tipo de documento origem
EXEC('IF NOT EXISTS(SELECT * FROM [tbSistemaTiposDocumentoOrigem] WHERE ID=2)
BEGIN
INSERT [dbo].[tbSistemaTiposDocumentoOrigem] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N''002'', N''OutroSistema'', 0, 1, CAST(N''2016-05-25 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2016-05-25 09:31:44.997'' AS DateTime), NULL)
END')

--alterar margens vendas
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
tbDocumentosVendas.DataDocumento,
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
tbDocumentosVendas.DataDocumento, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbUnidades.NumeroDeCasasDecimais, tbComposicoes.Codigo,tbComposicoes.Descricao, 
(case when not tbaros.CodigoCor is null then tbaros.CodigoCor else tboculossol.CodigoCor end),(case when not tbaros.CorGenerica is null then tbaros.CorGenerica else tboculossol.CorGenerica end)
')

--alterar recálculo de último preco de custo
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_Recalculo_PCM_UPC]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_Recalculo_PCM_UPC]')

EXEC('CREATE PROCEDURE [dbo].[sp_Recalculo_PCM_UPC] 
	@IDRecalculo as bigint
AS
DECLARE db_cursor CURSOR FOR SELECT C.ID, C.IDArtigo, Natureza, isnull(TD.CustoMedio,0) as CustoMedio, isnull(QuantidadeStock,0), isnull(PrecoUnitarioEfetivoMoedaRef,0) + isnull(UltCustosAdicionaisMoedaRef,0), isnull(PrecoUnitarioMoedaRef,0), isnull(UltCustosAdicionaisMoedaRef,0), isnull(UltDescComerciaisMoedaRef,0)
from tbCCStockArtigos C with (nolock) inner join tbf3mrecalculo on c.idartigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo 
left join tbTiposDocumento TD with (nolock) on C.IDTipoDocumento=TD.id 
left join tbSistemaTiposDocumento STD with (nolock) on TD.IDSistemaTiposDocumento=STD.id
where TD.CustoMedio=1
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
DEALLOCATE db_cursor;
')

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
		(Select idartigo, UltimoPrecoCompra from (select idartigo, isnull(UPCMoedaRef,0) as UltimoPrecoCompra, ROW_NUMBER() OVER (PARTITION BY IDArtigo Order by DataDocumento desc) as lin 
		from tbCCStockArtigos inner join tbTiposDocumento on tbCCStockArtigos.IDTipoDocumento=tbTiposDocumento.id where datadocumento<dateadd(d,1,@Data) and tbTiposDocumento.CustoMedio=1) p where p.lin=1) c on a.idartigo=c.idartigo

		left join
		(Select idartigo, Medio from (select idartigo, isnull(PCMAtualMoedaRef,0) as Medio, ROW_NUMBER() OVER (PARTITION BY IDArtigo Order by DataDocumento desc) as lin 
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


--procedimento de atualização de dados
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaDocumentosVendas]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaDocumentosVendas]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaDocumentosVendas] 

AS
DECLARE db_cursor CURSOR FOR SELECT D.ID, D.IDTipoDocumento, D.IDTiposDocumentoSeries, D.UtilizadorCriacao, D.IDEntidade
from tbDocumentosVendas D with (nolock) 
left join tbTiposDocumento TD with (nolock) on D.IDTipoDocumento=TD.id 
left join tbSistemaTiposDocumento STD with (nolock) on TD.IDSistemaTiposDocumento=STD.id
where CodigoDocOrigem=''002''
order by d.DataControloInterno, d.ID; 

DECLARE @IDDocumento bigint;
DECLARE @IDTipoDocumento bigint;
DECLARE @IDTiposDocumentoSeries bigint;
DECLARE @IDEntidade bigint;
DECLARE @Utilizador varchar(200); 

OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, @Utilizador, @IDEntidade
WHILE @@FETCH_STATUS = 0  
BEGIN 

EXEC sp_ControloDocumentos  @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, 0, ''tbDocumentosVendas'', @Utilizador 
EXEC sp_AtualizaCCEntidades @IDDocumento, @IDTipoDocumento, 0, @Utilizador, @IDEntidade 

FETCH NEXT FROM db_cursor INTO @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, @Utilizador, @IDEntidade;
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;
')