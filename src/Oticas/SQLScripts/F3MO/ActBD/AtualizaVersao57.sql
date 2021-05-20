/* ACT BD EMPRESA VERSAO 57*/
--novo campo de retificação nas compras
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbDocumentosCompras'' AND COLUMN_NAME = ''DocRectificacao'') 
Begin
	ALTER TABLE [dbo].[tbDocumentosCompras] ADD [DocRectificacao] [bit] NULL
End')

--novo SP de retificação de preços nas compras
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_RegistaCCRetCompras]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_RegistaCCRetCompras]')

EXEC('CREATE PROCEDURE [dbo].[sp_RegistaCCRetCompras]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intVerificaRet AS int = 0,
	@strUtilizador AS nvarchar(256) = ''''
AS  BEGIN
SET NOCOUNT ON
DECLARE 
	@ErrorMessage   varchar(2000),
	@ErrorSeverity  tinyint,
	@ErrorState     tinyint
	
BEGIN TRY
	IF (@intVerificaRet = 1) --verifica se o registo já existe e mudou valor e senão existe marca sempre para recalcular - será para chamar sempre em adicionar e alterar, remover não chama, quem trata e o sp do stock
		BEGIN
			UPDATE tbDocumentosComprasLinhas SET Alterada = LinhasCC.Alterada
			FROM tbDocumentosComprasLinhas as Linhas
			LEFT JOIN tbDocumentosCompras as Cab oN cab.ID = Linhas.IDDocumentoCompra
			INNER JOIN 
			(SELECT Cmp.ID, Cmp.IDTipoDocumento, lin.id as IdLinha,
				   ---aqui será a verificação para calcular o update à linha noi campo Alterada
				   Max(Case When isnull(CCartigos.ID,0) <> 0 then-- existe na CCartigos já linha e mudou qtd ou upcmoedaref
						CASE WHEN round(Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END,6)
						 <> round(isnull(CCartigos.UPCMoedaRef,0),6) OR
							round(isnull(CCartigos.QtdAfetacaoStock,0),6) <>  round(ABS(Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock else lin.QuantidadeStock end),6) 	
					   THEN
							1
					   ELSE
							0
					   END		  
				   ELSE
						1---não existe ainda na CCartigos
				   end)
				   AS Alterada
			FROM tbDocumentosCompras as Cmp
			left join tbTiposDocumento as TipoDoc On TipoDoc.ID = Cmp.IDTipoDocumento
			left join tbSistemaTiposDocumento as sttipo on sttipo.ID = TipoDoc.IDSistemaTiposDocumento
			left join tbSistemaTiposDocumentoFiscal as stFiscal on stFiscal.id = TipoDoc.IDSistemaTiposDocumentoFiscal
			left join tbDocumentosComprasLinhas as lin ON lin.IDDocumentoCompra = Cmp.ID
			left join tbArtigos as Art On art.id = lin.IDArtigo
			left join tbArtigosStock as artstk on artstk.IDArtigo = Art.ID
			left join tbDocumentosComprasLinhasDimensoes as linDim ON isnull(linDim.IDDocumentoCompraLinha,0) = isnull(lin.ID,0)
			left join tbArtigosDimensoes as artdim ON artdim.ID = linDim.IDArtigoDimensao
			---joins da Origem
			left join tbTiposDocumento as TipoDocOrigem On isnull(TipoDocOrigem.ID,0) = isnull(lin.IDTipoDocumentoOrigem,0)
			left join tbSistemaTiposDocumento as sttipoOrigem on isnull(sttipoOrigem.ID,0) = isnull(TipoDocOrigem.IDSistemaTiposDocumento,0)
			left join tbSistemaTiposDocumentoFiscal as stFiscalOrigem on isnull(stFiscalOrigem.id,0) = isnull(TipoDocOrigem.IDSistemaTiposDocumentoFiscal,0)
			left join tbDocumentosComprasLinhas as linOrigem ON isnull(linOrigem.IDDocumentoCompra,0) = isnull(lin.IDDocumentoOrigem,0) and isnull(linOrigem.id,0) = isnull(lin.IDLinhaDocumentoOrigem,0)
			left join tbDocumentosComprasLinhasDimensoes as linDimOrigem ON isnull(linDimOrigem.IDDocumentoCompraLinha,0) = isnull(linOrigem.ID,0) and isnull(linDimOrigem.ID,0) = isnull(linDim.IDLinhaDimensaoDocumentoOrigem,0)
			left join tbDocumentosCompras as CmpOrigem ON CmpOrigem.ID = linOrigem.IDDocumentoCompra
			---joins da Origem da origem
			left join tbTiposDocumento as TipoDocOrigem2 On isnull(TipoDocOrigem2.ID,0) = isnull(linOrigem.IDTipoDocumentoOrigem,0)
			left join tbSistemaTiposDocumento as sttipoOrigem2 on isnull(sttipoOrigem2.ID,0) = isnull(TipoDocOrigem2.IDSistemaTiposDocumento,0)
			left join tbSistemaTiposDocumentoFiscal as stFiscalOrigem2 on isnull(stFiscalOrigem2.id,0) = isnull(TipoDocOrigem2.IDSistemaTiposDocumentoFiscal,0)
			left join tbDocumentosComprasLinhas as linOrigem2 ON isnull(linOrigem2.IDDocumentoCompra,0) = isnull(linOrigem.IDDocumentoOrigem,0) and isnull(linOrigem2.id,0) = isnull(linOrigem.IDLinhaDocumentoOrigem,0)
			left join tbDocumentosComprasLinhasDimensoes as linDimOrigem2 ON isnull(linDimOrigem2.IDDocumentoCompraLinha,0) = isnull(linOrigem2.ID,0) and isnull(linDimOrigem2.ID,0) = isnull(linDimOrigem.IDLinhaDimensaoDocumentoOrigem,0)
			left join tbDocumentosCompras as CmpOrigem2 ON CmpOrigem2.ID = linOrigem2.IDDocumentoCompra
			---ligação com a conta corrente
			LEFT JOIN tbCCStockArtigos AS CCartigos ON (Cmp.IDTipoDocumento=CCartigos.IDTipoDocumento and lin.IDDocumentoCompra = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=lin.id AND lin.IDArtigo = CCartigos.IDArtigo and
			 isnull(linDim.IDArtigoDimensao,0) = isnull(CCartigos.IDArtigoDimensao,0) and isnull(CCartigos.Quantidade,0)=0) 
			---condições base
			WHERE Cmp.id=@lngidDocumento and Cmp.IDTipoDocumento=@lngidTipoDocumento and
				  isnull(sttipo.Tipo,'''') = ''CmpFinanceiro'' and 
				  isnull(lin.IDArtigo,0)<>0 and 
				  isnull(art.GereStock,0) <> 0 and
				  isnull(lin.IDTipoDocumentoOrigem,0) <> 0 and
				  isnull(TipoDoc.DocNaoValorizado,0) = 0 and
				(
				  ---condição Guias VGR;VGT->VFT;VFS;VFR
				  ((isnull(stFiscal.Tipo,'''') = ''FT'' OR isnull(stFiscal.Tipo,'''') = ''FR'' OR isnull(stFiscal.Tipo,'''') = ''FS'') and
					isnull(sttipoOrigem.Tipo,'''') = ''CmpTransporte'' and (isnull(stFiscalOrigem.Tipo,'''') = ''GR'' OR isnull(stFiscalOrigem.Tipo,'''') = ''GT'') and
					isnull(TipoDocOrigem.GereStock,0) <> 0 and 
					CASE when isnull(linDim.ID,0)<>0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END <> CASE when isnull(linDimOrigem.ID,0)<>0 THEN isnull(linDimOrigem.UPCMoedaRef,0) ELSE isnull(linOrigem.UPCMoedaRef,0) END				
				  )
				  OR
				  ---condição FT''s VFT;VFS;VFR -> nota de débito
				  (isnull(stFiscal.Tipo,'''') = ''ND'' and  CASE when isnull(linDim.ID,0)<>0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END <> 0 and  
				   ( (isnull(sttipoOrigem.Tipo,'''') = ''CmpFinanceiro'' and
						 (isnull(stFiscalOrigem.Tipo,'''') = ''FR'' OR isnull(stFiscalOrigem.Tipo,'''') = ''FS'' OR isnull(stFiscalOrigem.Tipo,'''') = ''FT'') and 
						 isnull(TipoDocOrigem.GereStock,0) <> 0
					 ) OR
					 (
						isnull(sttipoOrigem2.Tipo,'''') = ''CmpTransporte'' and (isnull(stFiscalOrigem2.Tipo,'''') = ''GR'' OR isnull(stFiscalOrigem2.Tipo,'''') = ''GT'') and
						isnull(TipoDocOrigem2.GereStock,0) <> 0
					 )
				   )
				  )
				  OR
				  ---condição FT''s VFT;VFS;VFR -> nota de crédito
				   (isnull(TipoDoc.GereStock,0) = 0 and isnull(stFiscal.Tipo,'''') = ''NC'' and  CASE when isnull(linDim.ID,0)<>0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END <> 0 and  
				   ( (isnull(sttipoOrigem.Tipo,'''') = ''CmpFinanceiro'' and
						 (isnull(stFiscalOrigem.Tipo,'''') = ''FR'' OR isnull(stFiscalOrigem.Tipo,'''') = ''FS'' OR isnull(stFiscalOrigem.Tipo,'''') = ''FT'') and 
						 isnull(TipoDocOrigem.GereStock,0) <> 0
					 ) OR
					 (
						isnull(sttipoOrigem2.Tipo,'''') = ''CmpTransporte'' and (isnull(stFiscalOrigem2.Tipo,'''') = ''GR'' OR isnull(stFiscalOrigem2.Tipo,'''') = ''GT'') and
						isnull(TipoDocOrigem2.GereStock,0) <> 0
					 )
				   )
				  )
				)
				GROUP BY Cmp.ID, Cmp.IDTipoDocumento, lin.id
				) as LinhasCC
				ON Linhas.ID = LinhasCC.IdLinha and  Linhas.IDDocumentoCompra = LinhasCC.ID and Cab.IDTipoDocumento  =  LinhasCC.IDTipoDocumento
				WHERE Cab.id=@lngidDocumento and Cab.IDTipoDocumento=@lngidTipoDocumento							
		END
	ELSE
		BEGIN --aqui lança registop na CC, com os valores necessários para depois o recalculo tratar os valores
		--1) lança na CC
			INSERT INTO tbCCStockArtigos (Natureza, IDArtigo, Descricao, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie,
										  IDArtigoDimensao, IDMoeda, IDTipoEntidade, IDEntidade, IDTipoDocumento, IDDocumento, IDLinhaDocumento, NumeroDocumento, DataControloInterno, IDTipoDocumentoOrigem,
										  IDDocumentoOrigem, IDLinhaDocumentoOrigem, IDTipoDocumentoOrigemInicial, IDDocumentoOrigemInicial, IDLinhaDocumentoOrigemInicial, DocumentoOrigemInicial, 
										  Quantidade, QuantidadeStock, QuantidadeStock2, QtdStockReserva, QtdStockReserva2Uni, QtdStockAnterior, QtdStockAtual, QtdAfetacaoStock, QtdAfetacaoStock2, 
										  PrecoUnitario, PrecoUnitarioEfetivo, PrecoUnitarioMoedaRef, PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef, 
										  PCMAnteriorMoedaRef, PCMAtualMoedaRef, PVMoedaRef, UPCompraMoedaRef, UltCustosAdicionaisMoedaRef, UltDescComerciaisMoedaRef, Recalcular, DataDocumento, TaxaConversao, 
										  Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, VossoNumeroDocumento, VossoNumeroDocumentoOrigem, NumeroDocumentoOrigem, 
										  IDTiposDocumentoSeries, IDTiposDocumentoSeriesOrigem) 
			SELECT Case when isnull(stFiscal.Tipo,'''') = ''NC'' then ''S'' else ''E'' end as Natureza, lin.IDArtigo, lin.Descricao,  
			Case when isnull(stFiscal.Tipo,'''') = ''NC'' then lin.IDArmazem else lin.IDArmazemDestino end as IDArmazem,
			Case when isnull(stFiscal.Tipo,'''') = ''NC'' then lin.IDArmazemLocalizacao else lin.IDArmazemLocalizacaoDestino end as IDArmazemLocalizacao,
			lin.IDLote as IDArtigoLote,
			lin.IDArtigoNumSerie as IDArtigoNumeroSerie,
			linDim.IDArtigoDimensao AS IDArtigoDimensao,
			Cmp.IDMoeda,
			Cmp.IDTipoEntidade, 
			Cmp.IDEntidade, 
			Cmp.IDTipoDocumento,
			Cmp.ID as IDDocumento, 
			lin.id as IDLinhaDocumento, 
			Cmp.NumeroDocumento,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
				CmpOrigem2.DataControloInterno 
			ELSE
				CmpOrigem.DataControloInterno 
			END
			AS DataControloInterno,
			lin.IDTipoDocumentoOrigem,
			lin.IDDocumentoOrigem as IDDocumentoOrigem,
			lin.IDLinhaDocumentoOrigem as IDLinhaDocumentoOrigem,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---os Iniciais na CC para retificativos ficam com o doc que movimentou stock
				TipoDocOrigem2.ID
			ELSE
				TipoDocOrigem.ID
			END
			AS IDTipoDocumentoOrigemInicial,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---os Iniciais na CC para retificativos ficam com o doc que movimentou stock
				CmpOrigem2.ID
			ELSE
				CmpOrigem.ID
			END
			AS IDDocumentoOrigemInicial, 
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---os Iniciais na CC para retificativos ficam com o doc que movimentou stock
				linOrigem2.ID
			ELSE
				linOrigem.ID
			END
			AS IDLinhaDocumentoOrigemInicial, 
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---os Iniciais na CC para retificativos ficam com o doc que movimentou stock
				CmpOrigem2.Documento
			ELSE
				CmpOrigem.Documento
			END
			AS DocumentoOrigemInicial,
			0 as Quantidade, 
			0 as QuantidadeStock,
			0 as QuantidadeStock2,
			0 as QtdStockReserva,
			0 as QtdStockReserva2Uni,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
				isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0)
			ELSE
				isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0) 			
			END
			AS QtdStockAnterior,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
				isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0)
			ELSE
				isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0) 			
			END
			as QtdStockAtual,
			ABS(Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock else lin.QuantidadeStock end)  as QtdAfetacaoStock, 
			ABS(Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock2 else lin.QuantidadeStock2 end)  as QtdAfetacaoStock2,
			Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.PrecoUnitario else lin.PrecoUnitario end  as PrecoUnitario,
			Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.PrecoUnitarioEfetivo else lin.PrecoUnitarioEfetivo end  as PrecoUnitarioEfetivo,
			Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.PrecoUnitarioMoedaRef else lin.PrecoUnitarioMoedaRef end  as PrecoUnitarioMoedaRef,
			Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.PrecoUnitarioEfetivoMoedaRef else lin.PrecoUnitarioEfetivoMoedaRef end  as PrecoUnitarioEfetivoMoedaRef,
			Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END AS UPCMoedaRef,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---tem de ser ao contrário, pois a 2 movimentou e 1 tb, mas quem nada e a 2
				isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumentoOrigemInicial = CmpOrigem2.IDTipoDocumento and 
																	IDDocumentoOrigemInicial =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumentoOrigemInicial =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0) and isnull(QuantidadeStock,0) = 0 and isnull(QtdAfetacaoStock,0) <> 0 
																	ORDER BY DataControloInterno DESC, ID DESC),
																	isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0))

			ELSE
				isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumentoOrigemInicial = CmpOrigem.IDTipoDocumento and 
																	IDDocumentoOrigemInicial =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumentoOrigemInicial =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0) and isnull(QuantidadeStock,0) = 0 and isnull(QtdAfetacaoStock,0) <> 0 
																	ORDER BY DataControloInterno DESC, ID DESC),
																	isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0)) 		
			END
			AS PCMAnteriorMoedaRef,
			Round(
				CASE WHEN 
					CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
						isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0)
					ELSE
						isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0) 			
					END > 0 then

			((CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
				isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0)
			ELSE
				isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0) 			
			END
			*
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---tem de ser ao contrário, pois a 2 movimentou e 1 tb, mas quem nada e a 2
				isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumentoOrigemInicial = CmpOrigem2.IDTipoDocumento and 
																	IDDocumentoOrigemInicial =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumentoOrigemInicial =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0) and isnull(QuantidadeStock,0) = 0 and isnull(QtdAfetacaoStock,0) <> 0 
																	ORDER BY DataControloInterno DESC, ID DESC),
																	isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0))

			ELSE
				isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumentoOrigemInicial = CmpOrigem.IDTipoDocumento and 
																	IDDocumentoOrigemInicial =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumentoOrigemInicial =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0) and isnull(QuantidadeStock,0) = 0 and isnull(QtdAfetacaoStock,0) <> 0 
																	ORDER BY DataControloInterno DESC, ID DESC),
																	isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0)) 		
			END
			)
			+
			CASE WHEN isnull(stFiscal.Tipo,'''') = ''NC'' Then
				---só aplicar formulas
				- (Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock else lin.QuantidadeStock end
					*
					Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END	
					)
			ELSE
				CASE WHEN isnull(stFiscal.Tipo,'''') = ''ND'' Then
				-----só aplicar formulas
					(Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock else lin.QuantidadeStock end
					*
					Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END	
					) 
				ELSE--FT''s
				---só aplicar formulas
					(Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock else lin.QuantidadeStock end
					*
					Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END	
					) 
					-
						(Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock else lin.QuantidadeStock end
						*
						CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---tem de ser ao contrário, pois a 2 movimentou e 1 tb, mas quem nada e a 2
							isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumentoOrigemInicial = CmpOrigem2.IDTipoDocumento and 
																				IDDocumentoOrigemInicial =linOrigem2.IDDocumentoCompra and 
																				IDLinhaDocumentoOrigemInicial =linOrigem2.ID and 
																				IDArtigo = linOrigem2.IDArtigo and
																				isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0) and isnull(QuantidadeStock,0) = 0 and isnull(QtdAfetacaoStock,0) <> 0 
																				ORDER BY DataControloInterno DESC, ID DESC),
																				isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																				IDDocumento =linOrigem2.IDDocumentoCompra and 
																				IDLinhaDocumento =linOrigem2.ID and 
																				IDArtigo = linOrigem2.IDArtigo and
																				isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0))

						ELSE
							isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumentoOrigemInicial = CmpOrigem.IDTipoDocumento and 
																				IDDocumentoOrigemInicial =linOrigem.IDDocumentoCompra and 
																				IDLinhaDocumentoOrigemInicial =linOrigem.ID and 
																				IDArtigo = linOrigem.IDArtigo and
																				isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0) and isnull(QuantidadeStock,0) = 0 and isnull(QtdAfetacaoStock,0) <> 0 
																				ORDER BY DataControloInterno DESC, ID DESC),
																				isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																				IDDocumento =linOrigem.IDDocumentoCompra and 
																				IDLinhaDocumento =linOrigem.ID and 
																				IDArtigo = linOrigem.IDArtigo and
																				isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0)) 		
						END
						)
				END
			END) / CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
						isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0)
					ELSE
						isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0) 			
					END
				else
				0
				end,
			isnull(tbMoedasRef.CasasDecimaisPrecosUnitarios,0))
			AS PCMAtualMoedaRef,
			Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.PVMoedaRef,0) ELSE isnull(lin.PVMoedaRef,0) END AS PVMoedaRef,
			Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UPCompraMoedaRef,0) ELSE isnull(lin.UPCompraMoedaRef,0) END AS UPCompraMoedaRef,
			CASE WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UltCustosAdicionaisMoedaRef,0) ELSE isnull(lin.UltCustosAdicionaisMoedaRef,0) END AS UltCustosAdicionaisMoedaRef,
			CASE WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UltDescComerciaisMoedaRef,0) ELSE isnull(lin.UltDescComerciaisMoedaRef,0) END AS UltDescComerciaisMoedaRef,
			isnull(lin.Alterada,0) AS Recalcular,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
				CmpOrigem2.DataDocumento 
			ELSE
				CmpOrigem.DataDocumento 
			END
			AS DataDocumento, 
			Cmp.TaxaConversao, 1 AS Ativo, 1 AS Sistema, Cmp.DataCriacao, 
			@strUtilizador  AS UtilizadorCriacao,
			Cmp.DataAlteracao,  @strUtilizador AS UtilizadorAlteracao, 
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
				Cmp.VossoNumeroDocumento + '' (ret. '' + CmpOrigem2.VossoNumeroDocumento + '')''
			ELSE
				Cmp.VossoNumeroDocumento + '' (ret. '' + CmpOrigem.VossoNumeroDocumento + '')''
			END
			AS VossoNumeroDocumento,
			lin.VossoNumeroDocumentoOrigem, 
			lin.NumeroDocumentoOrigem, 
			Cmp.IDTiposDocumentoSeries, 
			lin.IDTiposDocumentoSeriesOrigem														 
		FROM tbDocumentosCompras as Cmp
		left join tbTiposDocumento as TipoDoc On TipoDoc.ID = Cmp.IDTipoDocumento
		left join tbSistemaTiposDocumento as sttipo on sttipo.ID = TipoDoc.IDSistemaTiposDocumento
		left join tbSistemaTiposDocumentoFiscal as stFiscal on stFiscal.id = TipoDoc.IDSistemaTiposDocumentoFiscal
		left join tbDocumentosComprasLinhas as lin ON lin.IDDocumentoCompra = Cmp.ID
		left join tbArtigos as Art On art.id = lin.IDArtigo
		left join tbArtigosStock as artstk on artstk.IDArtigo = Art.ID
		left join tbDocumentosComprasLinhasDimensoes as linDim ON isnull(linDim.IDDocumentoCompraLinha,0) = isnull(lin.ID,0)
		left join tbArtigosDimensoes as artdim ON artdim.ID = linDim.IDArtigoDimensao
		---joins da Origem
		left join tbTiposDocumento as TipoDocOrigem On isnull(TipoDocOrigem.ID,0) = isnull(lin.IDTipoDocumentoOrigem,0)
		left join tbSistemaTiposDocumento as sttipoOrigem on isnull(sttipoOrigem.ID,0) = isnull(TipoDocOrigem.IDSistemaTiposDocumento,0)
		left join tbSistemaTiposDocumentoFiscal as stFiscalOrigem on isnull(stFiscalOrigem.id,0) = isnull(TipoDocOrigem.IDSistemaTiposDocumentoFiscal,0)
		left join tbDocumentosComprasLinhas as linOrigem ON isnull(linOrigem.IDDocumentoCompra,0) = isnull(lin.IDDocumentoOrigem,0) and isnull(linOrigem.id,0) = isnull(lin.IDLinhaDocumentoOrigem,0)
		left join tbDocumentosComprasLinhasDimensoes as linDimOrigem ON isnull(linDimOrigem.IDDocumentoCompraLinha,0) = isnull(linOrigem.ID,0) and isnull(linDimOrigem.ID,0) = isnull(linDim.IDLinhaDimensaoDocumentoOrigem,0)
		left join tbDocumentosCompras as CmpOrigem ON CmpOrigem.ID = linOrigem.IDDocumentoCompra
		---joins da Origem da origem
		left join tbTiposDocumento as TipoDocOrigem2 On isnull(TipoDocOrigem2.ID,0) = isnull(linOrigem.IDTipoDocumentoOrigem,0)
		left join tbSistemaTiposDocumento as sttipoOrigem2 on isnull(sttipoOrigem2.ID,0) = isnull(TipoDocOrigem2.IDSistemaTiposDocumento,0)
		left join tbSistemaTiposDocumentoFiscal as stFiscalOrigem2 on isnull(stFiscalOrigem2.id,0) = isnull(TipoDocOrigem2.IDSistemaTiposDocumentoFiscal,0)
		left join tbDocumentosComprasLinhas as linOrigem2 ON isnull(linOrigem2.IDDocumentoCompra,0) = isnull(linOrigem.IDDocumentoOrigem,0) and isnull(linOrigem2.id,0) = isnull(linOrigem.IDLinhaDocumentoOrigem,0)
		left join tbDocumentosComprasLinhasDimensoes as linDimOrigem2 ON isnull(linDimOrigem2.IDDocumentoCompraLinha,0) = isnull(linOrigem2.ID,0) and isnull(linDimOrigem2.ID,0) = isnull(linDimOrigem.IDLinhaDimensaoDocumentoOrigem,0)
		left join tbDocumentosCompras as CmpOrigem2 ON CmpOrigem2.ID = linOrigem2.IDDocumentoCompra
		---ligação com a conta corrente
		LEFT JOIN tbCCStockArtigos AS CCartigos ON (Cmp.IDTipoDocumento=CCartigos.IDTipoDocumento and lin.IDDocumentoCompra = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=lin.id AND lin.IDArtigo = CCartigos.IDArtigo and
		isnull(linDim.IDArtigoDimensao,0) = isnull(CCartigos.IDArtigoDimensao,0) and isnull(CCartigos.Quantidade,0)=0)
		LEFT JOIN tbParametrosEmpresa as P ON 1 = 1
		LEFT JOIN tbMoedas as tbMoedasRef ON tbMoedasRef.ID=P.IDMoedaDefeito
		---condições base
		WHERE Cmp.id=@lngidDocumento and Cmp.IDTipoDocumento=@lngidTipoDocumento and
			isnull(sttipo.Tipo,'''') = ''CmpFinanceiro'' and 
			isnull(lin.IDArtigo,0)<>0 and 
			isnull(art.GereStock,0) <> 0 and
			isnull(lin.IDTipoDocumentoOrigem,0) <> 0 and
			isnull(TipoDoc.DocNaoValorizado,0) = 0 and
		(
			---condição Guias VGR;VGT->VFT;VFS;VFR
			((isnull(stFiscal.Tipo,'''') = ''FT'' OR isnull(stFiscal.Tipo,'''') = ''FR'' OR isnull(stFiscal.Tipo,'''') = ''FS'') and
			isnull(sttipoOrigem.Tipo,'''') = ''CmpTransporte'' and (isnull(stFiscalOrigem.Tipo,'''') = ''GR'' OR isnull(stFiscalOrigem.Tipo,'''') = ''GT'') and
			isnull(TipoDocOrigem.GereStock,0) <> 0 and 
			CASE when isnull(linDim.ID,0)<>0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END <> CASE when isnull(linDimOrigem.ID,0)<>0 THEN isnull(linDimOrigem.UPCMoedaRef,0) ELSE isnull(linOrigem.UPCMoedaRef,0) END				
			)
			OR
			---condição FT''s VFT;VFS;VFR -> nota de débito
			(isnull(stFiscal.Tipo,'''') = ''ND'' and  CASE when isnull(linDim.ID,0)<>0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END <> 0 and  
			( (isnull(sttipoOrigem.Tipo,'''') = ''CmpFinanceiro'' and
					(isnull(stFiscalOrigem.Tipo,'''') = ''FR'' OR isnull(stFiscalOrigem.Tipo,'''') = ''FS'' OR isnull(stFiscalOrigem.Tipo,'''') = ''FT'') and 
					isnull(TipoDocOrigem.GereStock,0) <> 0
				) OR
				(
				isnull(sttipoOrigem2.Tipo,'''') = ''CmpTransporte'' and (isnull(stFiscalOrigem2.Tipo,'''') = ''GR'' OR isnull(stFiscalOrigem2.Tipo,'''') = ''GT'') and
				isnull(TipoDocOrigem2.GereStock,0) <> 0
				)
			)
			)
			OR
			---condição FT''s VFT;VFS;VFR -> nota de crédito
			(isnull(TipoDoc.GereStock,0) = 0 and isnull(stFiscal.Tipo,'''') = ''NC'' and  CASE when isnull(linDim.ID,0)<>0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END <> 0 and  
			( (isnull(sttipoOrigem.Tipo,'''') = ''CmpFinanceiro'' and
					(isnull(stFiscalOrigem.Tipo,'''') = ''FR'' OR isnull(stFiscalOrigem.Tipo,'''') = ''FS'' OR isnull(stFiscalOrigem.Tipo,'''') = ''FT'') and 
					isnull(TipoDocOrigem.GereStock,0) <> 0
				) OR
				(
				isnull(sttipoOrigem2.Tipo,'''') = ''CmpTransporte'' and (isnull(stFiscalOrigem2.Tipo,'''') = ''GR'' OR isnull(stFiscalOrigem2.Tipo,'''') = ''GT'') and
				isnull(TipoDocOrigem2.GereStock,0) <> 0
				)
			)
			)
		)

		--2) marca documento como rectificativo, se registou na CC
		IF @@ROWCOUNT > 0 
		BEGIN
			UPDATE tbDocumentosCompras SET DocRectificacao=1 WHERE ID=@lngidDocumento and IDTipoDocumento=@lngidTipoDocumento
		END
	END
END TRY
BEGIN CATCH
	SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
	RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')

--atualização do sp_atualizastock
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaStock]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaStock]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaStock]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0,
	@strTabelaCabecalho AS nvarchar(250) = '''', 
	@strTabelaLinhas AS nvarchar(250) = '''',
	@strTabelaLinhasDist AS nvarchar(250) = '''',
	@strCampoRelTabelaLinhasCab AS nvarchar(100) = '''',
	@strCampoRelTabelaLinhasDistLinhas AS nvarchar(100) = '''',
	@strUtilizador AS nvarchar(256) = '''',
	@inValidaStock AS bit
AS  BEGIN
SET NOCOUNT ON

DECLARE @strSqlQuery AS varchar(max),--variavel para query''s dinamicos
	@strSqlQueryAux AS varchar(max),--variavel para query''s dinamicos
	@strSqlQueryUpdates AS varchar(max),--variavel para query''s dinamicos
	@strSqlQueryInsert AS varchar(max),--varivale para a parte do insert
	@paramList AS nvarchar(max),--variavel para usar quando necessitamos de carregar para as variaveis parametros/colunas comquery''s dinamicas
	@strNatureza AS nvarchar(15) = NULL,
	@strNaturezaStock AS nvarchar(15) = NULL,
	@strNaturezaaux AS nvarchar(15) = NULL,
	@strNaturezaBase AS nvarchar(15) = ''[#F3MNAT#]'',
	@strModulo AS nvarchar(50),
	@strTipoDocInterno AS nvarchar(50),
	@cModuloStocks AS nvarchar(3) =''001'',
	@strCodMovStock AS nvarchar(10) = NULL,
	@strQueryQuantidades AS nvarchar(2500) = NULL,
	@strQueryPrecoUnitarios AS nvarchar(2500) = NULL,
	@strQueryLeftJoinDist AS nvarchar(256) = '' '',
	@strQueryLeftJoinDistUpdates AS nvarchar(256) = '' '',
	@strQueryWhereDistUpdates AS nvarchar(max) = '''',
	@strQueryCamposDistUpdates AS nvarchar(1024) = '''',
	@strQueryWhereDistUpdates1 AS nvarchar(1024) = '''',
	@strQueryCamposDistUpdates1 AS nvarchar(1024) = '''',
	@strQueryGroupbyDistUpdates AS nvarchar(1024) = '''',
	@strQueryONDist AS nvarchar(1024) = '''',
	@strQueryDocsAtras AS nvarchar(4000) = '''',
	@strQueryDocsAFrente AS nvarchar(4000) = '''',
	@strQueryDocsUpdates AS varchar(max),
	@strQueryDocsUpdatesaux AS varchar(max),
	@strQueryWhereFrente AS nvarchar(1024) = '''',
	@strArmazensCodigo AS nvarchar(100) = ''[#F3M-TRANSF-F3M#]'',
	@strArmazem AS nvarchar(200) = ''Linhas.IDArmazem, Linhas.IDArmazemLocalizacao, '',
	@strArmazensDestino AS nvarchar(200) = ''Linhas.IDArmazemDestino, Linhas.IDArmazemLocalizacaoDestino, '',
	@strTransFControlo AS nvarchar(256) = ''[#F3M-QTDSTRANSF-F3M#]'',
	@strTransFSaida AS nvarchar(1024) = '''',
	@strTransFEntrada AS nvarchar(1024) = '''',
    @strArtigoDimensao AS nvarchar(100) = ''NULL AS IDArtigoDimensao, '',
	@inLimitMax as tinyint,--1 ignora, 2 avisa, 3 bloqueia
    @inLimitMin as tinyint,
    @inRutura as tinyint,
	@inLimitMaxDel as tinyint,--1 ignora, 2 avisa, 3 bloqueia
    @inLimitMinDel as tinyint,
    @inRuturaDel as tinyint,
	@ErrorMessage   varchar(2000),
	@ErrorSeverity  tinyint,
	@ErrorState     tinyint,
	@rowcount INT,
	@strQueryOrdenacao AS nvarchar(1024) = '''',
	@strWhereQuantidades AS nvarchar(1500) = NULL

BEGIN TRY
	--Verificar se o tipo de documento gere Stock, caso não gere stock não faz nada
	IF EXISTS(SELECT ID FROM tbTiposDocumento WHERE ISNULL(GereStock,0)<>0 AND ID=@lngidTipoDocumento)
		BEGIN
		  	--Calcular a Natureza do stock a registar, para tal carregar o Modulo e o Tipo Doc para vermos o tipo de movimento , se é S ou E ou NM-não movimenta
			SELECT @strModulo = M.Codigo,  @strTipoDocInterno = STD.Tipo, @strCodMovStock = TDMS.Codigo,  
			       @inRutura = Cast(AcaoRutura.Codigo as tinyint), @inLimitMax = CAST(AcaoLimiteMax.Codigo as tinyint), @inLimitMin = CAST(AcaoLimiteMin.Codigo AS tinyint)
			FROM tbTiposDocumento TD
			LEFT JOIN tbSistemaModulos M ON M.ID = TD.IDModulo
			LEFT JOIN tbSistemaTiposDocumento STD ON STD.ID = TD.IDSistemaTiposDocumento
			LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TD.IDSistemaTiposDocumentoMovStock
			LEFT JOIN tbSistemaAcoes as AcaoRutura ON AcaoRutura.id=TD.IDSistemaAcoesRupturaStock
			LEFT JOIN tbSistemaAcoes as AcaoLimiteMax ON AcaoLimiteMax.id=TD.IDSistemaAcoesStockMaximo
			LEFT JOIN tbSistemaAcoes as AcaoLimiteMin ON AcaoLimiteMin.id=TD.IDSistemaAcoesStockMinimo
			WHERE ISNULL(TD.GereStock,0)<>0 AND TD.ID=@lngidTipoDocumento
			IF NOT @strCodMovStock IS NULL	--qtds positivas	
				BEGIN
					SET @strNatureza =
					CASE @strCodMovStock
						WHEN ''001'' THEN NULL --não movimenta
						WHEN ''002'' THEN ''E''
						WHEN ''003'' THEN ''S''
						WHEN ''004'' THEN ''[#F3MN#F3M]''--transferencia ??? so deve existir nos stocks para os tipos StkTrfArmazCTrans,StkTrfArmazSTrans e StkTransfArtComp
						WHEN ''005'' THEN NULL--?vazio
						WHEN ''006'' THEN ''R''
						WHEN ''007'' THEN ''LR''
					END
				END
			IF NOT @strNatureza IS NULL --se a natureza <> NULL então entra para tratar ccstock
				BEGIN
				    SET @strNaturezaStock = @strNatureza
				    --apaga registos caso existam da de validação de stock
				    DELETE FROM tbControloValidacaoStock WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
					--atualiza variaveis de validação de stock do apagar e trata de acordo com a natureza as var do adiccionar e alterar
					SET @inRuturaDel = @inRutura
					SET @inLimitMinDel = @inLimitMin
					SET @inLimitMaxDel = @inLimitMax
					IF  @strNatureza = ''E'' OR @strNatureza = ''LR''
						BEGIN
							SET @inRutura = 1--ignora
							SET @inLimitMin = 1--ignora
						END
					IF  @strNatureza = ''S'' OR @strNatureza = ''R''
						BEGIN
							SET @inLimitMax = 1--ignora
						END
					--verificar se é apagar a acao e atribuir as var do delete e retirar os do insert/update e delete
					IF (@intAccao = 2) 
						BEGIN
						    SET @inRutura = 1--ignora
							SET @inLimitMin = 1--ignora
							SET @inLimitMax = 1--ignora
							IF  @strNatureza = ''E'' OR @strNatureza = ''LR''
								BEGIN
								    SET @inLimitMaxDel = 1--ignora
								
								END
							IF  @strNatureza = ''S'' OR @strNatureza = ''R''
								BEGIN
							    	SET @inRuturaDel = 1--ignora
									SET @inLimitMinDel = 1--ignora
								END

					    END
					

					SET @strNaturezaaux = @strNatureza
					IF  @strNaturezaaux IS NULL 
						BEGIN
							SET @strNaturezaaux=''''
						END
					--Prepara variaveis a concatenar à query das quantidades / Preços, pois se tem dist, teremos de estar preparados para registos na dist
					IF  len(@strTabelaLinhasDist)>0
						BEGIN
						    
						    SET @strQueryOrdenacao ='' ORDER BY Linhas.Ordem asc, LinhasDist.Ordem asc ''
							
							IF  @strNaturezaaux = ''R''  OR  @strNaturezaaux = ''LR''
								BEGIN
									SET @strQueryQuantidades = ''0 AS Quantidade, 
																 0 as QuantidadeStock, 
																 0 as QuantidadeStock2, 
																 ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QuantidadeStock,0) ELSE ISNULL(LinhasDist.QuantidadeStock,0) END) AS QtdStockReserva, 
																 ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QuantidadeStock2,0) ELSE ISNULL(LinhasDist.QuantidadeStock2,0) END) AS QtdStockReserva2Uni, 
														'' + @strTransFControlo + '' 
														,ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdAfetacaoStock,0) ELSE ISNULL(LinhasDist.QtdAfetacaoStock,0) END) as QtdAfetacaoStock, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdAfetacaoStock2,0) ELSE ISNULL(LinhasDist.QtdAfetacaoStock2,0) END) as QtdAfetacaoStock2, ''
								END
							ELSE
								BEGIN
								--depois aqui nos campos --StockReserva, StockReserva2Uni será o valor da linha, mas como ainda não colocaste fica 0-QtdStockReserva, QtdStockReserva2Uni
									SET @strQueryQuantidades = ''ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.Quantidade,0) ELSE ISNULL(LinhasDist.Quantidade,0) END) AS Quantidade, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QuantidadeStock,0) ELSE ISNULL(LinhasDist.QuantidadeStock,0) END) as QuantidadeStock, 
													    ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QuantidadeStock2,0) ELSE ISNULL(LinhasDist.QuantidadeStock2,0) END) as QuantidadeStock2, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockReserva,0) ELSE ISNULL(LinhasDist.QtdStockReserva,0) END) AS QtdStockReserva, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockReserva2Uni,0) ELSE ISNULL(LinhasDist.QtdStockReserva2Uni,0) END) AS QtdStockReserva2Uni, 
														'' + @strTransFControlo + '' 
														,ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdAfetacaoStock,0) ELSE ISNULL(LinhasDist.QtdAfetacaoStock,0) END) as QtdAfetacaoStock, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdAfetacaoStock2,0) ELSE ISNULL(LinhasDist.QtdAfetacaoStock2,0) END) as QtdAfetacaoStock2, ''
								END
													
													     
							SET @strTransFSaida  = ''Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockAnterior,0) ELSE ISNULL(LinhasDist.QtdStockAnterior,0) END as QtdStockAnterior, Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockAtual,0) ELSE ISNULL(LinhasDist.QtdStockAtual,0) END as QtdStockAtual ''
							SET @strTransFEntrada = ''Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockAnterior,0) - ISNULL(Linhas.QuantidadeStock,0)  ELSE ISNULL(LinhasDist.QtdStockAnterior,0) - ISNULL(LinhasDist.QuantidadeStock,0) END as QtdStockAnterior, Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockAtual,0) + ISNULL(Linhas.QuantidadeStock,0) ELSE ISNULL(LinhasDist.QtdStockAtual,0) + ISNULL(LinhasDist.QuantidadeStock,0) END as QtdStockAtual ''


							SET @strQueryPrecoUnitarios = ''Case WHEN LinhasDist.ID IS NULL THEN Linhas.PrecoUnitario ELSE LinhasDist.PrecoUnitario END AS PrecoUnitario, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PrecoUnitarioEfetivo ELSE LinhasDist.PrecoUnitarioEfetivo END AS PrecoUnitarioEfetivo, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PrecoUnitarioMoedaRef ELSE LinhasDist.PrecoUnitarioMoedaRef END AS PrecoUnitarioMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PrecoUnitarioEfetivoMoedaRef ELSE LinhasDist.PrecoUnitarioEfetivoMoedaRef END AS PrecoUnitarioEfetivoMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.UPCMoedaRef ELSE LinhasDist.UPCMoedaRef END AS UPCMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PCMAnteriorMoedaRef ELSE LinhasDist.PCMAnteriorMoedaRef END AS PCMAnteriorMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PCMAtualMoedaRef ELSE LinhasDist.PCMAtualMoedaRef END AS PCMAtualMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PVMoedaRef ELSE LinhasDist.PVMoedaRef END AS PVMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.UPCompraMoedaRef ELSE LinhasDist.UPCompraMoedaRef END AS UPCompraMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.UltCustosAdicionaisMoedaRef ELSE LinhasDist.UltCustosAdicionaisMoedaRef END AS UltCustosAdicionaisMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.UltDescComerciaisMoedaRef ELSE LinhasDist.UltDescComerciaisMoedaRef END AS UltDescComerciaisMoedaRef, 
															''
							
							SET @strQueryLeftJoinDist = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhasDist ON LinhasDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = Linhas.ID ''
							SET @strArtigoDimensao = ''LinhasDist.IDArtigoDimensao AS IDArtigoDimensao, ''
						END
					ELSE
						BEGIN
						    SET @strQueryOrdenacao ='' ORDER BY Linhas.Ordem asc ''
							
								IF  @strNaturezaaux = ''R''  OR  @strNaturezaaux = ''LR''
									BEGIN
										SET @strQueryQuantidades = ''0 AS Quantidade, 0 AS QuantidadeStock, 0 AS QuantidadeStock2, ABS(ISNULL(Linhas.QuantidadeStock,0)) AS QtdStockReserva, ABS(ISNULL(Linhas.QuantidadeStock2,0)) AS QtdStockReserva2Uni, 
														'' + @strTransFControlo + '' , ABS(ISNULL(Linhas.QtdAfetacaoStock,0)) AS QtdAfetacaoStock, ABS(ISNULL(Linhas.QtdAfetacaoStock2,0)) AS QtdAfetacaoStock2, ''
									
									END
								else
									BEGIN
										SET @strQueryQuantidades = ''ABS(ISNULL(Linhas.Quantidade,0)) AS Quantidade, ABS(ISNULL(Linhas.QuantidadeStock,0)) AS QuantidadeStock, ABS(ISNULL(Linhas.QuantidadeStock2,0)) AS QuantidadeStock2, ABS(ISNULL(Linhas.QtdStockReserva,0)) AS QtdStockReserva, ABS(ISNULL(Linhas.QtdStockReserva2Uni,0)) AS QtdStockReserva2Uni, 
														'' + @strTransFControlo + '' , ABS(ISNULL(Linhas.QtdAfetacaoStock,0)) AS QtdAfetacaoStock, ABS(ISNULL(Linhas.QtdAfetacaoStock2,0)) AS QtdAfetacaoStock2, ''
									END
							
							
							


							SET @strTransFSaida  = ''ISNULL(Linhas.QtdStockAnterior,0) AS QtdStockAnterior, ISNULL(Linhas.QtdStockAtual,0) AS QtdStockAtual ''
							SET @strTransFEntrada = ''ISNULL(Linhas.QtdStockAnterior,0) - ISNULL(Linhas.QuantidadeStock,0) AS QtdStockAnterior, ISNULL(Linhas.QtdStockAtual,0) + ISNULL(Linhas.QuantidadeStock,0) AS QtdStockAtual ''
														
							
							
							SET @strQueryPrecoUnitarios = ''Linhas.PrecoUnitario AS PrecoUnitario, Linhas.PrecoUnitarioEfetivo AS PrecoUnitarioEfetivo, Linhas.PrecoUnitarioMoedaRef AS PrecoUnitarioMoedaRef,
													    Linhas.PrecoUnitarioEfetivoMoedaRef AS PrecoUnitarioEfetivoMoedaRef, Linhas.UPCMoedaRef AS UPCMoedaRef, 
														Linhas.PCMAnteriorMoedaRef AS PCMAnteriorMoedaRef, Linhas.PCMAtualMoedaRef AS PCMAtualMoedaRef, Linhas.PVMoedaRef AS PVMoedaRef, 
														Linhas.UPCompraMoedaRef AS UPCompraMoedaRef, Linhas.UltCustosAdicionaisMoedaRef AS UltCustosAdicionaisMoedaRef, Linhas.UltDescComerciaisMoedaRef AS UltDescComerciaisMoedaRef, 
														 ''
						
						END
					--Preparação das Query''s para adicionar e só interessa se ação for adicionar ou alterar na parte seguinte
					IF (@intAccao = 0 OR @intAccao = 1) 
						BEGIN 
							IF (@strTipoDocInterno = ''StkContagemStock'')
								BEGIN 
									SET @strQueryQuantidades = '' ABS(ISNULL(Linhas.QuantidadeDiferenca,0)) AS Quantidade, ABS(ISNULL(Linhas.QuantidadeDiferenca,0)) AS QuantidadeStock, 0 AS QuantidadeStock2, 0 AS QtdStockReserva, 0 AS QtdStockReserva2Uni, 
													 0 AS QtdStockAnterior, 0 AS QtdStockAtual, 0 AS QtdAfetacaoStock, 0 AS QtdAfetacaoStock2, ''

									SET @strTransFSaida  = ''0 AS QtdStockAnterior, 0 AS QtdStockAtual ''
									SET @strTransFEntrada = ''0 AS QtdStockAnterior, 0 AS QtdStockAtual ''

									SET @strQueryPrecoUnitarios = ''Linhas.PrecoUnitario AS PrecoUnitario, Linhas.PrecoUnitario AS PrecoUnitarioEfetivo, Linhas.PrecoUnitario AS PrecoUnitarioMoedaRef,
													    Linhas.PrecoUnitario AS PrecoUnitarioEfetivoMoedaRef, Linhas.PrecoUnitario AS UPCMoedaRef, 
														Linhas.PrecoUnitario AS PCMAnteriorMoedaRef, Linhas.PrecoUnitario AS PCMAtualMoedaRef, 0 AS PVMoedaRef, 
														Linhas.PrecoUnitario AS UPCompraMoedaRef, 0 AS UltCustosAdicionaisMoedaRef, 0 AS UltDescComerciaisMoedaRef, 
														 ''
									SET @strArmazem = ''CAB.IDArmazem, CAB.IDLocalizacao, ''

									SET @paramList = N''@lngidDocumento1 bigint''
									SET @strWhereQuantidades = '' ABS(ISNULL(Linhas.QuantidadeDiferenca,0))>0 and (TDQPos.Codigo=''''002'''' OR TDQPos.Codigo=''''003'''' OR TDQPos.Codigo=''''004'''' OR TDQPos.Codigo=''''006'''' OR TDQPos.Codigo=''''007'''') ''
									SET @strSqlQueryInsert = ''INSERT INTO tbCCStockArtigos (Natureza, IDArtigo, IDArtigoPA, IDArtigoPara, Descricao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie,
															IDArtigoDimensao, IDMoeda, IDTipoEntidade, IDEntidade, IDTipoDocumento, IDDocumento, IDLinhaDocumento, NumeroDocumento, DataControloInterno, IDTipoDocumentoOrigem,
															IDDocumentoOrigem, IDLinhaDocumentoOrigem, IDTipoDocumentoOrigemInicial, IDDocumentoOrigemInicial, IDLinhaDocumentoOrigemInicial, DocumentoOrigemInicial, 
															Quantidade, QuantidadeStock, QuantidadeStock2, QtdStockReserva, QtdStockReserva2Uni, QtdStockAnterior, QtdStockAtual, QtdAfetacaoStock, QtdAfetacaoStock2, PrecoUnitario, PrecoUnitarioEfetivo, PrecoUnitarioMoedaRef, PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef, 
															PCMAnteriorMoedaRef, PCMAtualMoedaRef, PVMoedaRef, UPCompraMoedaRef, UltCustosAdicionaisMoedaRef, UltDescComerciaisMoedaRef, Recalcular, DataDocumento, TaxaConversao, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, VossoNumeroDocumento, VossoNumeroDocumentoOrigem, NumeroDocumentoOrigem, IDTiposDocumentoSeries, IDTiposDocumentoSeriesOrigem) ''
									SELECT @strSqlQuery = @strSqlQueryInsert + ''
															SELECT (case when Linhas.QuantidadeDiferenca>0 then ''''E'''' when Linhas.QuantidadeDiferenca<0 then ''''S'''' else '''''''' end) AS Natureza, Linhas.IDArtigo, NULL as IDArtigoPA, NULL as IDArtigoPara, Linhas.DescricaoArtigo, Cab.IDLoja, '' + @strArmazem + '' Linhas.IDLote AS IDArtigoLote, 
															NULL AS IDArtigoNumeroSerie, '' + @strArtigoDimensao + '' 
															Cab.IDMoeda, NULL as IDTipoEntidade, NULL as IDEntidade, Cab.IDTipoDocumento, Cab.ID as IDDocumento, Linhas.id as IDLinhaDocumento, Cab.NumeroDocumento, dateadd(d, datediff(d, 0, Cab.DataDocumento), cast(''''23:59:59'''' as datetime)) AS DataControloInterno, 
															NULL as IDTipoDocumentoOrigem, NULL as IDDocumentoOrigem, NULL as IDLinhaDocumentoOrigem,
															NULL as IDTipoDocumentoOrigemInicial, NULL as IDDocumentoOrigemInicial, NULL as IDLinhaDocumentoOrigemInicial, NULL as DocumentoOrigemInicial,  
															'' + @strQueryQuantidades + @strQueryPrecoUnitarios + ''isnull(Linhas.Alterada,0) AS Recalcular, dateadd(d, datediff(d, 0, Cab.DataDocumento), cast(''''23:59:59'''' as datetime)) AS DataDocumento, Cab.TaxaConversao, 1 AS Ativo, 1 AS Sistema, Cab.DataCriacao, '''''' + @strUtilizador + '''''' AS UtilizadorCriacao,
															Cab.DataAlteracao, '''''' + @strUtilizador + '''''' AS UtilizadorAlteracao, NULL as VossoNumeroDocumento, NULL as VossoNumeroDocumentoOrigem, NULL as NumeroDocumentoOrigem, Cab.IDTiposDocumentoSeries, NULL as IDTiposDocumentoSeriesOrigem
															FROM '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab 
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON Linhas.'' + @strCampoRelTabelaLinhasCab + '' = Cab.ID 
															LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo '' + 
															@strQueryLeftJoinDist + 
															''LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab.IDTipoDocumento
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDQPos ON TDQPos.id=TpDoc.IDSistemaTiposDocumentoMovStock
															WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND ISNULL(Art.GereStock,0) <> 0 AND NOT Linhas.IDArtigo IS NULL
															AND '' +
															@strWhereQuantidades  + @strQueryOrdenacao

									print @strSqlQuery
								END

							ELSE IF (@strTipoDocInterno = ''SubstituicaoArtigos'')
								BEGIN

									--entrada de artigos
									SET @strQueryQuantidades = '' ABS(ISNULL(Linhas.Quantidade,0)) AS Quantidade, ABS(ISNULL(LinhasSub.Quantidade,0)) AS QuantidadeStock, 0 AS QuantidadeStock2, 0 AS QtdStockReserva, 0 AS QtdStockReserva2Uni, 
													 0 AS QtdStockAnterior, 0 AS QtdStockAtual, 0 AS QtdAfetacaoStock, 0 AS QtdAfetacaoStock2, ''

									SET @strTransFSaida  = ''0 AS QtdStockAnterior, 0 AS QtdStockAtual ''
									SET @strTransFEntrada = ''0 AS QtdStockAnterior, 0 AS QtdStockAtual ''

									SET @strQueryPrecoUnitarios = ''isnull(Art.Medio,0) AS PrecoUnitario, isnull(Art.Medio,0) AS PrecoUnitarioEfetivo, isnull(Art.Medio,0) AS PrecoUnitarioMoedaRef,
													    isnull(Art.Medio,0) AS PrecoUnitarioEfetivoMoedaRef, isnull(Art.Medio,0) AS UPCMoedaRef, 
														isnull(Art.Medio,0) AS PCMAnteriorMoedaRef, isnull(Art.Medio,0) AS PCMAtualMoedaRef, 0 AS PVMoedaRef, 
														isnull(Art.Medio,0) AS UPCompraMoedaRef, 0 AS UltCustosAdicionaisMoedaRef, 0 AS UltDescComerciaisMoedaRef, 
														 ''
									SET @strArmazem = ''LinhasSub.IDArmazem, LinhasSub.IDArmazemLocalizacao,''

									SET @paramList = N''@lngidDocumento1 bigint''
									
									SET @strWhereQuantidades = '' (TDQPos.Codigo=''''002'''' OR TDQPos.Codigo=''''003'''' OR TDQPos.Codigo=''''004'''' OR TDQPos.Codigo=''''006'''' OR TDQPos.Codigo=''''007'''') ''

									SET @strSqlQueryInsert = ''INSERT INTO tbCCStockArtigos (Natureza, IDArtigo, IDArtigoPA, IDArtigoPara, Descricao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie,
															IDArtigoDimensao, IDMoeda, IDTipoEntidade, IDEntidade, IDTipoDocumento, IDDocumento, IDLinhaDocumento, NumeroDocumento, DataControloInterno, IDTipoDocumentoOrigem,
															IDDocumentoOrigem, IDLinhaDocumentoOrigem, IDTipoDocumentoOrigemInicial, IDDocumentoOrigemInicial, IDLinhaDocumentoOrigemInicial, DocumentoOrigemInicial, 
															Quantidade, QuantidadeStock, QuantidadeStock2, QtdStockReserva, QtdStockReserva2Uni, QtdStockAnterior, QtdStockAtual, QtdAfetacaoStock, QtdAfetacaoStock2, PrecoUnitario, PrecoUnitarioEfetivo, PrecoUnitarioMoedaRef, PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef, 
															PCMAnteriorMoedaRef, PCMAtualMoedaRef, PVMoedaRef, UPCompraMoedaRef, UltCustosAdicionaisMoedaRef, UltDescComerciaisMoedaRef, Recalcular, DataDocumento, TaxaConversao, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, VossoNumeroDocumento, VossoNumeroDocumentoOrigem, NumeroDocumentoOrigem, IDTiposDocumentoSeries, IDTiposDocumentoSeriesOrigem) ''
									SELECT @strSqlQuery = @strSqlQueryInsert + ''
															SELECT ''''E'''' AS Natureza, Linhas.IDArtigo, NULL as IDArtigoPA, NULL as IDArtigoPara, Linhas.Descricao, Cab.IDLoja, '' + @strArmazem + '' Linhas.IDLote AS IDArtigoLote, 
															NULL AS IDArtigoNumeroSerie, '' + @strArtigoDimensao + '' 
															Cab.IDMoeda, cab.IDTipoEntidade, cab.IDEntidade, Cab.IDTipoDocumento, Cab.ID as IDDocumento, Linhas.id as IDLinhaDocumento, Cab.NumeroDocumento, dateadd(d, datediff(d, 0, Cab.DataDocumento), cast(''''23:59:59'''' as datetime)) AS DataControloInterno, 
															NULL as IDTipoDocumentoOrigem, NULL as IDDocumentoOrigem, NULL as IDLinhaDocumentoOrigem,
															NULL as IDTipoDocumentoOrigemInicial, NULL as IDDocumentoOrigemInicial, NULL as IDLinhaDocumentoOrigemInicial, NULL as DocumentoOrigemInicial,  
															'' + @strQueryQuantidades + @strQueryPrecoUnitarios + ''isnull(Linhas.Alterada,0) AS Recalcular, dateadd(d, datediff(d, 0, Cab.DataDocumento), cast(''''23:59:59'''' as datetime)) AS DataDocumento, Cab.TaxaConversao, 1 AS Ativo, 1 AS Sistema, Cab.DataCriacao, '''''' + @strUtilizador + '''''' AS UtilizadorCriacao,
															Cab.DataAlteracao, '''''' + @strUtilizador + '''''' AS UtilizadorAlteracao, NULL as VossoNumeroDocumento, NULL as VossoNumeroDocumentoOrigem, NULL as NumeroDocumentoOrigem, Cab.IDTiposDocumentoSeries, NULL as IDTiposDocumentoSeriesOrigem
															FROM '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab 
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS LinhasSub ON LinhasSub.'' + @strCampoRelTabelaLinhasCab + '' = Cab.ID 
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON LinhasSub.IDLinhaDocumentoOrigemInicial = Linhas.ID 
															LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo '' + 
															@strQueryLeftJoinDist + 
															''LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab.IDTipoDocumento
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDQPos ON TDQPos.id=TpDoc.IDSistemaTiposDocumentoMovStock
															WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND ISNULL(Art.GereStock,0) <> 0 AND NOT Linhas.IDArtigo IS NULL
															AND '' +
															@strWhereQuantidades  + @strQueryOrdenacao


									--saida de artigos
									SET @strQueryQuantidades = '' ABS(ISNULL(Linhas.Quantidade,0)) AS Quantidade, ABS(ISNULL(Linhas.Quantidade,0)) AS QuantidadeStock, 0 AS QuantidadeStock2, 0 AS QtdStockReserva, 0 AS QtdStockReserva2Uni, 
													 0 AS QtdStockAnterior, 0 AS QtdStockAtual, 0 AS QtdAfetacaoStock, 0 AS QtdAfetacaoStock2, ''

									SET @strTransFSaida  = ''0 AS QtdStockAnterior, 0 AS QtdStockAtual ''
									SET @strTransFEntrada = ''0 AS QtdStockAnterior, 0 AS QtdStockAtual ''

									SET @strQueryPrecoUnitarios = ''Linhas.PrecoUnitario AS PrecoUnitario, Linhas.PrecoUnitario AS PrecoUnitarioEfetivo, Linhas.PrecoUnitario AS PrecoUnitarioMoedaRef,
													    Linhas.PrecoUnitario AS PrecoUnitarioEfetivoMoedaRef, Linhas.PrecoUnitario AS UPCMoedaRef, 
														Linhas.PrecoUnitario AS PCMAnteriorMoedaRef, Linhas.PrecoUnitario AS PCMAtualMoedaRef, 0 AS PVMoedaRef, 
														Linhas.PrecoUnitario AS UPCompraMoedaRef, 0 AS UltCustosAdicionaisMoedaRef, 0 AS UltDescComerciaisMoedaRef, 
														 ''
									SET @strArmazem = ''Linhas.IDArmazem, linhas.IDArmazemLocalizacao,''

									SET @paramList = N''@lngidDocumento1 bigint''
									
									SET @strWhereQuantidades = '' (TDQPos.Codigo=''''002'''' OR TDQPos.Codigo=''''003'''' OR TDQPos.Codigo=''''004'''' OR TDQPos.Codigo=''''006'''' OR TDQPos.Codigo=''''007'''') ''

									SET @strSqlQueryInsert = ''INSERT INTO tbCCStockArtigos (Natureza, IDArtigo, IDArtigoPA, IDArtigoPara, Descricao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie,
															IDArtigoDimensao, IDMoeda, IDTipoEntidade, IDEntidade, IDTipoDocumento, IDDocumento, IDLinhaDocumento, NumeroDocumento, DataControloInterno, IDTipoDocumentoOrigem,
															IDDocumentoOrigem, IDLinhaDocumentoOrigem, IDTipoDocumentoOrigemInicial, IDDocumentoOrigemInicial, IDLinhaDocumentoOrigemInicial, DocumentoOrigemInicial, 
															Quantidade, QuantidadeStock, QuantidadeStock2, QtdStockReserva, QtdStockReserva2Uni, QtdStockAnterior, QtdStockAtual, QtdAfetacaoStock, QtdAfetacaoStock2, PrecoUnitario, PrecoUnitarioEfetivo, PrecoUnitarioMoedaRef, PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef, 
															PCMAnteriorMoedaRef, PCMAtualMoedaRef, PVMoedaRef, UPCompraMoedaRef, UltCustosAdicionaisMoedaRef, UltDescComerciaisMoedaRef, Recalcular, DataDocumento, TaxaConversao, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, VossoNumeroDocumento, VossoNumeroDocumentoOrigem, NumeroDocumentoOrigem, IDTiposDocumentoSeries, IDTiposDocumentoSeriesOrigem) ''
									SELECT @strSqlQuery = @strSqlQuery + '';'' + @strSqlQueryInsert + ''
															SELECT ''''S'''' AS Natureza, Linhas.IDArtigo, NULL as IDArtigoPA, NULL as IDArtigoPara, Linhas.Descricao, Cab.IDLoja, '' + @strArmazem + '' Linhas.IDLote AS IDArtigoLote, 
															NULL AS IDArtigoNumeroSerie, '' + @strArtigoDimensao + '' 
															Cab.IDMoeda, cab.IDTipoEntidade, cab.IDEntidade, Cab.IDTipoDocumento, Cab.ID as IDDocumento, Linhas.id as IDLinhaDocumento, Cab.NumeroDocumento, dateadd(d, datediff(d, 0, Cab.DataDocumento), cast(''''23:59:59'''' as datetime)) AS DataControloInterno, 
															NULL as IDTipoDocumentoOrigem, NULL as IDDocumentoOrigem, NULL as IDLinhaDocumentoOrigem,
															NULL as IDTipoDocumentoOrigemInicial, NULL as IDDocumentoOrigemInicial, NULL as IDLinhaDocumentoOrigemInicial, NULL as DocumentoOrigemInicial,  
															'' + @strQueryQuantidades + @strQueryPrecoUnitarios + ''isnull(Linhas.Alterada,0) AS Recalcular, dateadd(d, datediff(d, 0, Cab.DataDocumento), cast(''''23:59:59'''' as datetime)) AS DataDocumento, Cab.TaxaConversao, 1 AS Ativo, 1 AS Sistema, Cab.DataCriacao, '''''' + @strUtilizador + '''''' AS UtilizadorCriacao,
															Cab.DataAlteracao, '''''' + @strUtilizador + '''''' AS UtilizadorAlteracao, NULL as VossoNumeroDocumento, NULL as VossoNumeroDocumentoOrigem, NULL as NumeroDocumentoOrigem, Cab.IDTiposDocumentoSeries, NULL as IDTiposDocumentoSeriesOrigem
															FROM '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab 
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON Linhas.'' + @strCampoRelTabelaLinhasCab + '' = Cab.ID 
															LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo '' + 
															@strQueryLeftJoinDist + 
															''LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab.IDTipoDocumento
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDQPos ON TDQPos.id=TpDoc.IDSistemaTiposDocumentoMovStock
															WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND ISNULL(Art.GereStock,0) <> 0 AND NOT Linhas.IDArtigo IS NULL
															AND '' +
															@strWhereQuantidades  + @strQueryOrdenacao 

									print @strSqlQuery
									EXEC(@strSqlQuery) 
									SET @strSqlQuery = ''''
								END

							ELSE
								BEGIN
									SET @paramList = N''@lngidDocumento1 bigint''
									SET @strWhereQuantidades = '' (TDQPos.Codigo=''''002'''' OR TDQPos.Codigo=''''003'''' OR TDQPos.Codigo=''''004'''' OR TDQPos.Codigo=''''006'''' OR TDQPos.Codigo=''''007'''') ''
									SET @strSqlQueryInsert = ''INSERT INTO tbCCStockArtigos (Natureza, IDArtigo, IDArtigoPA, IDArtigoPara, Descricao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie,
															IDArtigoDimensao, IDMoeda, IDTipoEntidade, IDEntidade, IDTipoDocumento, IDDocumento, IDLinhaDocumento, NumeroDocumento, DataControloInterno, IDTipoDocumentoOrigem,
															IDDocumentoOrigem, IDLinhaDocumentoOrigem, IDTipoDocumentoOrigemInicial, IDDocumentoOrigemInicial, IDLinhaDocumentoOrigemInicial, DocumentoOrigemInicial, 
															Quantidade, QuantidadeStock, QuantidadeStock2, QtdStockReserva, QtdStockReserva2Uni, QtdStockAnterior, QtdStockAtual, QtdAfetacaoStock, QtdAfetacaoStock2, PrecoUnitario, PrecoUnitarioEfetivo, PrecoUnitarioMoedaRef, PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef, 
															PCMAnteriorMoedaRef, PCMAtualMoedaRef, PVMoedaRef, UPCompraMoedaRef, UltCustosAdicionaisMoedaRef, UltDescComerciaisMoedaRef, Recalcular, DataDocumento, TaxaConversao, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, VossoNumeroDocumento, VossoNumeroDocumentoOrigem, NumeroDocumentoOrigem, IDTiposDocumentoSeries, IDTiposDocumentoSeriesOrigem) ''
									SELECT @strSqlQuery = @strSqlQueryInsert + ''
															SELECT '''''' + @strNaturezaaux + '''''' AS Natureza, Linhas.IDArtigo, Linhas.IDArtigoPA,Linhas.IDArtigoPara,Linhas.Descricao, Cab.IDLoja, '' + @strArmazensCodigo + '' Linhas.IDLote AS IDArtigoLote, 
															Linhas.IDArtigoNumSerie AS IDArtigoNumeroSerie, '' + @strArtigoDimensao + '' 
															Cab.IDMoeda,Cab.IDTipoEntidade, Cab.IDEntidade, Cab.IDTipoDocumento,Cab.ID as IDDocumento, Linhas.id as IDLinhaDocumento, Cab.NumeroDocumento, Cab.DataControloInterno, 
															Linhas.IDTipoDocumentoOrigem as IDTipoDocumentoOrigem, Linhas.IDDocumentoOrigem as IDDocumentoOrigem,Linhas.IDLinhaDocumentoOrigem as IDLinhaDocumentoOrigem,
															Linhas.IDTipoDocumentoOrigemInicial, Linhas.IDDocumentoOrigemInicial, Linhas.IDLinhaDocumentoOrigemInicial, Linhas.DocumentoOrigemInicial,  
															'' + @strQueryQuantidades + @strQueryPrecoUnitarios + ''isnull(Linhas.Alterada,0) AS Recalcular, Cab.DataDocumento AS DataDocumento, Cab.TaxaConversao, 1 AS Ativo, 1 AS Sistema, Cab.DataCriacao, '''''' + @strUtilizador + '''''' AS UtilizadorCriacao,
															Cab.DataAlteracao, '''''' + @strUtilizador + '''''' AS UtilizadorAlteracao, Cab.VossoNumeroDocumento, Linhas.VossoNumeroDocumentoOrigem, Linhas.NumeroDocumentoOrigem, Cab.IDTiposDocumentoSeries, Linhas.IDTiposDocumentoSeriesOrigem
															FROM '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab 
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON Linhas.'' + @strCampoRelTabelaLinhasCab + '' = Cab.ID 
															LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo '' + 
															@strQueryLeftJoinDist + 
															''LEFT JOIN tbTiposDocumento AS TpDocOrigem ON TpDocOrigem.ID =  Linhas.IDTipoDocumentoOrigem 
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDocOrigem.IDSistemaTiposDocumentoMovStock
															LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab.IDTipoDocumento
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDQPos ON TDQPos.id=TpDoc.IDSistemaTiposDocumentoMovStock
															WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND ISNULL(Art.GereStock,0) <> 0 AND NOT Linhas.IDArtigo IS NULL
															AND (TpDocOrigem.ID IS NULL OR (NOT TpDocOrigem.ID IS NULL AND (ISNULL(TpDocOrigem.GereStock,0) = 0 OR (ISNULL(TpDocOrigem.GereStock,0) <> 0 AND NOT TDMS.Codigo is NULL AND TDMS.Codigo<>TDQPos.Codigo)))) AND '' +
															@strWhereQuantidades  + @strQueryOrdenacao
								END

							IF (@intAccao = 1) --se é alterar
								BEGIN
									--1) marcar as linhas no documento como alterada, se a mesma já existe na CCartigos e o custo ou a quantidade ou a data mudou,
									--para depois se marcar para recalcular ao inserir registos. Nas saidas marcar se mudou data e stock apenas - transferencias sao ignoradas
									IF  len(@strTabelaLinhasDist)>0
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(LinhaDist.IDArtigoDimensao,0) = isnull(CCartigos.IDArtigoDimensao,0)) ''
											SET @strQueryWhereDistUpdates = '' AND ((ISNULL(TDMS.Codigo,0) = ''''002'''' AND ((isnull(LinhaDist.IDArtigoDimensao,0)<>0 
																			AND (Round(Convert(float,isnull(LinhaDist.UPCMoedaRef,0)),6) <> Round(Convert(float,isnull(CCartigos.UPCMoedaRef,0)),6) OR (isnull(LinhaDist.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0))) 
																			) OR (CCartigos.DataControloInterno<>Cab1.DataControloInterno) OR (isnull(LinhaDist.IDArtigoDimensao,0) = 0 
																			AND  (Round(Convert(float,isnull(Linhas.UPCMoedaRef,0)),6) <> Round(Convert(float,isnull(CCartigos.UPCMoedaRef,0)),6) OR (isnull(Linhas.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0)))
																			))) OR ((ISNULL(TDMS.Codigo,0) = ''''003'''' AND ((isnull(LinhaDist.IDArtigoDimensao,0)<>0 
																			AND isnull(LinhaDist.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0)
																			) OR (CCartigos.DataControloInterno<>Cab1.DataControloInterno) OR (isnull(LinhaDist.IDArtigoDimensao,0) = 0 
																			AND  isnull(Linhas.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0))
																			)))) ''														
																			  
										END
									ELSE
										BEGIN
											SET @strQueryLeftJoinDistUpdates = ''''
											SET @strQueryWhereDistUpdates = '' AND ((ISNULL(TDMS.Codigo,0) = ''''002'''' AND (CCartigos.DataControloInterno<>Cab1.DataControloInterno OR Round(Convert(float,isnull(Linhas.UPCMoedaRef,0)),6) <> Round(Convert(float,isnull(CCartigos.UPCMoedaRef,0)),6) OR (isnull(Linhas.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0))) OR (
											(ISNULL(TDMS.Codigo,0) = ''''003'''' AND (CCartigos.DataControloInterno<>Cab1.DataControloInterno OR (isnull(Linhas.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0))))
											))) ''
																			
										END
									SET @strSqlQueryUpdates = '' UPDATE '' + QUOTENAME(@strTabelaLinhas) + '' SET Alterada=1 FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
																LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')
																LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab1.IDTipoDocumento
																LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
																LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo 
															    INNER JOIN tbCCStockArtigos AS CCartigos ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) '' 
																+ @strQueryLeftJoinDistUpdates +
																''WHERE NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) 
																+ @strQueryWhereDistUpdates
								EXEC(@strSqlQueryUpdates)
								
								END

								IF (@intAccao = 0 OR @intAccao = 1) 
									BEGIN
									--2) Linhas novas que nao estavam no documento e agora passar a existir nele, marcar tb como alterada a propria da CCartigos , caso 
									---- exista à frente ja artigo.
									IF  len(@strTabelaLinhasDist)>0
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = Linhas.id) ''
											SET @strQueryWhereDistUpdates = '' and isnull(LinhaDist.IDArtigoDimensao,0) = isnull(LinhasFrente.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates ='',isnull(LinhaDist.IDArtigoDimensao,0) as IdDimensao ''
											SET @strQueryWhereDistUpdates1 = '' AND isnull(CC.IDArtigoDimensao,0) = isnull(LinhasNovas.IdDimensao,0) '' 
											SET @strQueryCamposDistUpdates1 =''isnull(CC.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryGroupbyDistUpdates = '', isnull(CC.IDArtigoDimensao,0)''
											SET @strQueryONDist = '' AND isnull(CCartigos.IDArtigoDimensao,0)=isnull(LinhaDist.IDArtigoDimensao,0) ''
										END
									ELSE
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' ''
											SET @strQueryWhereDistUpdates = '' ''
											SET @strQueryCamposDistUpdates ='' ''
											SET @strQueryWhereDistUpdates1 = '' '' 
											SET @strQueryCamposDistUpdates1 ='' ''
											SET @strQueryGroupbyDistUpdates = '' ''
											SET @strQueryONDist = '' ''
										END

									SET @strSqlQueryUpdates ='' Update '' + QUOTENAME(@strTabelaLinhas) + '' SET Alterada=1 FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
													LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')''
													+ @strQueryLeftJoinDistUpdates +
													''LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab1.IDTipoDocumento
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
													LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo 
													LEFT JOIN	(
													SELECT CC.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Count(CC.ID) as Num FROM tbCCStockArtigos AS CC
													LEFT JOIN tbTiposDocumento AS TpDoc1 ON TpDoc1.ID =  CC.IDTipoDocumento
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS1 ON TDMS1.id=TpDoc1.IDSistemaTiposDocumentoMovStock
													LEFT JOIN		
													(SELECT distinct Linhas.IDArtigo, Cab.DataControloInterno'' + @strQueryCamposDistUpdates + '' FROM  '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
													LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON (Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')''
													+ @strQueryLeftJoinDistUpdates +
													'' LEFT JOIN tbCCStockArtigos AS CCartigos ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo '' + @strQueryONDist + '')	
													WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND Cab.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' AND CCartigos.IDDocumento IS NULL) AS LinhasNovas
													ON 	(CC.IDArtigo = LinhasNovas.IDArtigo '' + @strQueryWhereDistUpdates1 + '')
													WHERE CC.DataControloInterno > LinhasNovas.DataControloInterno AND (CC.Natureza=''''E'''' OR CC.Natureza=''''S'''') AND (ISNULL(TDMS1.Codigo,0) = ''''002'''' OR ISNULL(TDMS1.Codigo,0) = ''''003'''')									
													GROUP BY 	CC.IDArtigo '' + @strQueryGroupbyDistUpdates + '') AS LinhasFrente	
													ON Linhas.IDArtigo = LinhasFrente.IDArtigo '' + @strQueryWhereDistUpdates +
													''WHERE  NOT Linhas.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''') AND NOT LinhasFrente.IDArtigo IS NULL AND Cab1.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND Cab1.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) 

									EXEC(@strSqlQueryUpdates)
									--2.1) Linhas novas que nao estavam no documento e agora passam a existir, mas com artigo repetido e nestes casos, marcar essas linhas de artigos 
									        
									SET @strSqlQueryUpdates = '' Update '' + QUOTENAME(@strTabelaLinhas) + '' SET Alterada=1 FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
											                  LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '') 
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab1.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											INNER JOIN (
												select Linhas.IDArtigo, Linhas.'' + @strCampoRelTabelaLinhasCab + '' FROM  '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
												LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')
												LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab1.IDTipoDocumento
												LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
												where Linhas.'' + @strCampoRelTabelaLinhasCab + '' = '' + Convert(nvarchar,@lngidDocumento) + '' and Cab1.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' and (TDMS.Codigo=''''002'''' OR TDMS.Codigo=''''003'''')
												group by Linhas.'' + @strCampoRelTabelaLinhasCab + '', Linhas.IDArtigo
												having count(*) > 1
												) as COM2
												ON COM2.IDArtigo=Linhas.IDArtigo and COM2.'' + @strCampoRelTabelaLinhasCab + ''=linhas.'' + @strCampoRelTabelaLinhasCab + ''
											LEFT JOIN tbCCStockArtigos AS CC ON Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CC.IDDocumento and linhas.IDArtigo =cc.IDArtigo and cc.IDLinhaDocumento = linhas.id and CC.IDTipoDocumento = TpDoc.ID
											where Linhas.'' + @strCampoRelTabelaLinhasCab + ''= '' + Convert(nvarchar,@lngidDocumento) + '' and Cab1.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' and (TDMS.Codigo=''''002'''' OR TDMS.Codigo=''''003'''') 
											and CC.IDLinhaDocumento is null	'' 


									EXEC(@strSqlQueryUpdates)
									
									END
								IF (@intAccao = 1) --se é alterar
									BEGIN
									--3) Linhas que existiam e agora deixaram de existir no documento, para essas, marcar a linha à frente desse artigo para recalcular a partir daí
									---  caso não existe nenhum para à frente não marcar nenhuma
									IF  len(@strTabelaLinhasDist)>0
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
											SET @strQueryWhereDistUpdates = '' AND isnull(CCART.IDArtigoDimensao,0) = isnull(Docs.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates =''isnull(CCartigos.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryWhereDistUpdates1 = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Doc.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates1 =''isnull(CCART.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryGroupbyDistUpdates = '', isnull(CCART.IDArtigoDimensao,0)''
											SET @strQueryWhereFrente = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Frente.IDArtigoDimensao,0) ''
											SET @strQueryONDist = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) ''
										END
									ELSE
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' ''
											SET @strQueryWhereDistUpdates = ''''
											SET @strQueryCamposDistUpdates ='' ''
											SET @strQueryWhereDistUpdates1 = '' '' 
											SET @strQueryCamposDistUpdates1 ='' ''
											SET @strQueryGroupbyDistUpdates = '' ''	
											SET @strQueryWhereFrente = '' ''
											SET @strQueryONDist = '' ''
										END
									SET @strQueryDocsUpdates = ''LEFT JOIN 
													(SELECT distinct CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + '' CCartigos.DataControloInterno  FROM  tbCCStockArtigos AS CCartigos
													LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
													LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
													'' + @strQueryLeftJoinDistUpdates + ''
													LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
													WHERE CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' 
												    AND (CCartigos.Natureza=''''E'''' OR CCartigos.Natureza=''''S'''')
													AND (Linhas.ID IS NULL '' + @strQueryONDist + '')
													AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
													) AS Docs
													ON (Docs.IDArtigo = CCART.IDArtigo '' + @strQueryWhereDistUpdates + '')''
									
									SET @strQueryDocsAFrente ='' (SELECT CCART.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Min(CCART.DataControloInterno) as Data FROM tbCCStockArtigos AS CCART
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCART.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCART.IDArtigo ''
											+ @strQueryDocsUpdates +
											'' WHERE CCART.DataControloInterno > Docs.DataControloInterno and (CCART.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCART.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCART.Natureza=''''E'''' OR CCART.Natureza=''''S'''')
											AND NOT CCART.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											GROUP BY  CCART.IDArtigo'' + @strQueryGroupbyDistUpdates + '') AS Frente
											ON (Frente.IDArtigo = CCA.IDArtigo '' + @strQueryWhereFrente + '' AND Frente.Data = CCA.DataControloInterno) ''

										SET @strSqlQueryUpdates ='' UPDATE tbCCStockArtigos SET Recalcular = 1 FROM tbCCStockArtigos AS CCA
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCA.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCA.IDArtigo
											INNER JOIN ''
											+ @strQueryDocsAFrente + 
											'' WHERE (CCA.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCA.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCA.Natureza=''''E'''' OR CCA.Natureza=''''S'''')
											AND NOT CCA.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											AND NOT Frente.IDArtigo IS NULL ''
											
									EXEC(@strSqlQueryUpdates)
																		
								 	--retirar as quantidades dos totais as quantidades para as chaves dos artigos do documento
									UPDATE tbStockArtigos SET Quantidade = Round(Quantidade - ArtigosAntigos.Qtd, 6), 
									QuantidadeStock = Round(QuantidadeStock - ArtigosAntigos.QtdStock, 6), 
									QuantidadeStock2 = Round(QuantidadeStock2 - ArtigosAntigos.QtdStock2,6),
									QuantidadeReservada = Round(isnull(QuantidadeReservada,0) - ArtigosAntigos.QtdStockReservado, 6), 
									QuantidadeReservada2 = Round(isnull(QuantidadeReservada2,0) - ArtigosAntigos.QtdStock2Reservado, 6) FROM tbStockArtigos AS CCART
									INNER JOIN (
									SELECT IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, 
									SUM(Case Natureza WHEN ''S'' Then isnull(Quantidade,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(Quantidade,0) ELSE 0 END END) as Qtd,
									SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock,0) ELSE 0 END END) as QtdStock,
									SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock2,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock2,0) ELSE 0 END END) as QtdStock2,
									SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva,0) ELSE isnull(QtdStockReserva,0)*-1 END) as QtdStockReservado,
									SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva2Uni,0) ELSE isnull(QtdStockReserva2Uni,0)*-1 END) as QtdStock2Reservado
									FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento 
									GROUP BY IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
									) AS ArtigosAntigos
									ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
															
								--chama o de stocknecessidades
								  Execute sp_AtualizaStockNecessidades @lngidDocumento, @lngidTipoDocumento,2,@strUtilizador
								  
								--CHAMAR AQUI O OUTRO STORED PROCEDURE COM O ESTADO APAGAR
								
								  Execute sp_AtualizaArtigos @lngidDocumento, @lngidTipoDocumento,2,@strTabelaCabecalho,@strTabelaLinhas,@strTabelaLinhasDist,@strCampoRelTabelaLinhasCab,@strCampoRelTabelaLinhasDistLinhas,@strUtilizador
									--apagar aqui se estiverem a zero
									DELETE tbStockArtigos FROM tbStockArtigos AS CCART
									INNER JOIN (
									SELECT distinct IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
									 FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
									) AS ArtigosAntigos
									ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
											isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
											AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
											AND isnull(CCART.Quantidade,0) = 0 AND isnull(CCART.QuantidadeStock,0) = 0 AND isnull(CCART.QuantidadeStock2,0) = 0 AND isnull(CCART.QuantidadeReservada,0) = 0 AND isnull(CCART.QuantidadeReservada2,0) = 0
									--apagar registos da ccartigos
									--aqui faz os deletes
									
									IF @inValidaStock<>0
										BEGIN
											SET @strQueryCamposDistUpdates =''CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, '''''' + @strUtilizador + '''''' as UtilizadorCriacao ''
								
											IF  len(@strTabelaLinhasDist)>0
												BEGIN
													SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
													SET @strQueryWhereDistUpdates = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) '' 
											
												END
											ELSE
												BEGIN
													SET @strQueryLeftJoinDistUpdates = '' ''
													SET @strQueryWhereDistUpdates = ''''
													
												END
											SET @strQueryDocsUpdates = '' INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, IDArtigo, IDArtigoDimensao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	Ativo, Sistema, DataCriacao, UtilizadorCriacao)   
															SELECT distinct TpDoc.ID AS IDTipoDocumento, CCartigos.IDDocumento AS IDDocumento, CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + ''  FROM  tbCCStockArtigos AS CCartigos
															LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
															'' + @strQueryLeftJoinDistUpdates + ''
															LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
															WHERE '' + @strNaturezaBase + ''  CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' 
															AND (Linhas.ID IS NULL '' + @strQueryWhereDistUpdates + '' )
															AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 ''
											
											IF @strNaturezaStock <> ''[#F3MN#F3M]''
												BEGIN
													 SET @strQueryDocsUpdatesaux = REPLACE(@strQueryDocsUpdates, @strNaturezaBase, '' '')
													 EXEC(@strQueryDocsUpdatesaux)
													 IF Exists(SELECT IDArtigo FROM tbControloValidacaoStock WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento AND isnull(LimiteMax,0) = 0 AND isnull(LimiteMin,0) = 0 AND isnull(RuturaUnd1,0) = 0 AND isnull(RuturaUnd2,0) = 0 )
														BEGIN
															IF  @strNaturezaStock = ''E'' OR  @strNaturezaStock = ''LR''
																BEGIN
																	SET @inLimitMaxDel = 1--ignora
								
																END
															IF  @strNaturezaStock = ''S'' OR  @strNaturezaStock = ''R''
																BEGIN
							    									SET @inRuturaDel = 1--ignora
																	SET @inLimitMinDel = 1--ignora
																END

															Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, 1, 1, 1, @inLimitMaxDel, @inLimitMinDel, @inRuturaDel , @strNaturezaStock 
														END
												END
											ELSE
												BEGIN
												     --Entrada
													 SET @strQueryDocsUpdatesaux = REPLACE(@strQueryDocsUpdates, @strNaturezaBase, ''CCartigos.Natureza=''''E'''' AND '')
													 EXEC(@strQueryDocsUpdatesaux)

												      IF Exists(SELECT IDArtigo FROM tbControloValidacaoStock WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento AND isnull(LimiteMax,0) = 0 AND isnull(LimiteMin,0) = 0 AND isnull(RuturaUnd1,0) = 0 AND isnull(RuturaUnd2,0) = 0 )
													  BEGIN
														Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, 1, 1, 1, 1, @inLimitMinDel, @inRuturaDel , ''E''
													  END

													  --saída
													 SET @strQueryDocsUpdatesaux = REPLACE(@strQueryDocsUpdates, @strNaturezaBase, ''CCartigos.Natureza=''''S'''' AND '')
	  												 EXEC(@strQueryDocsUpdatesaux)

												      IF Exists(SELECT IDArtigo FROM tbControloValidacaoStock WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento AND isnull(LimiteMax,0) = 0 AND isnull(LimiteMin,0) = 0 AND isnull(RuturaUnd1,0) = 0 AND isnull(RuturaUnd2,0) = 0 )
													  BEGIN
														Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, 1, 1, 1, @inLimitMaxDel, 1, 1 , ''S'' 
													  END
												END
										END

									DELETE FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
								END

								--verifica se tem de marcar a Linha como alterada
								if (@strTipoDocInterno = ''CmpFinanceiro'')
									BEGIN
										Execute sp_RegistaCCRetCompras @lngidDocumento, @lngidTipoDocumento, 1, @strUtilizador
									END

								IF (@intAccao = 1) --se é alterar
									BEGIN
										DELETE FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
									END

								IF  @strNaturezaaux = ''[#F3MN#F3M]''--só existe transferencia para os stocks
									BEGIN
										SET @strSqlQueryAux = REPLACE(@strSqlQuery, @strArmazensCodigo, @strArmazem)
										SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strNaturezaaux, ''S'')
										SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strTransFControlo, @strTransFSaida)
									    EXEC(@strSqlQueryAux)--registo do armazem de saída
										SET @strSqlQueryAux = REPLACE(@strSqlQuery, @strArmazensCodigo, @strArmazensDestino)
										SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strNaturezaaux, ''E'')
										SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strTransFControlo, @strTransFEntrada )
										EXEC(@strSqlQueryAux)--registo do armazem de entrada
									END
								ELSE
									BEGIN
									    SET @strSqlQueryAux = REPLACE(@strSqlQuery, @strTransFControlo, @strTransFSaida)
										IF @strNaturezaaux = ''E'' OR  @strNaturezaaux = ''LR''
											BEGIN
												SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strArmazensCodigo, @strArmazensDestino)
											END
										ELSE
											BEGIN
												SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strArmazensCodigo, @strArmazem)
											END
								    	EXEC(@strSqlQueryAux) --registo das linhas diferentes de armazéns
									END

								--regista ret compras
								if (@strTipoDocInterno = ''CmpFinanceiro'')
									BEGIN
										Execute sp_RegistaCCRetCompras @lngidDocumento, @lngidTipoDocumento, 0, @strUtilizador
									END
								
								--inserir a zero os registos que nao existem das chaves nos totais
								INSERT INTO tbStockArtigos(IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao,IDArtigoLote,IDArtigoNumeroSerie, IDArtigoDimensao, Quantidade, QuantidadeStock, QuantidadeStock2,
								Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao) 
								SELECT CCART.IDArtigo, CCART.IDLoja, CCART.IDArmazem, CCART.IDArmazemLocalizacao, CCART.IDArtigoLote, CCART.IDArtigoNumeroSerie, CCART.IDArtigoDimensao,
								CCART.Quantidade, CCART.QuantidadeStock,CCART.QuantidadeStock2,
									CCART.Ativo,CCART.Sistema, CCART.DataCriacao, CCART.UtilizadorCriacao, CCART.DataAlteracao,CCART.UtilizadorAlteracao
									FROM (
								SELECT IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, 0 as Quantidade,
								0 as QuantidadeStock,
								0 as QuantidadeStock2,1 as Ativo,1 as Sistema, getdate() AS DataCriacao , @strUtilizador as UtilizadorCriacao, getdate() as DataAlteracao, @strUtilizador as UtilizadorAlteracao
								FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento 
								GROUP BY IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
								) AS CCART
								LEFT JOIN tbStockArtigos AS ArtigosAntigos
								ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
									WHERE ArtigosAntigos.IDArtigo is NULL and ArtigosAntigos.IDArmazem is NULL AND
									ArtigosAntigos.IDArmazemLocalizacao is NULL and ArtigosAntigos.IDArtigoLote is NULL and
									ArtigosAntigos.IDArtigoNumeroSerie is NULL and ArtigosAntigos.IDArtigoDimensao is NULL and ArtigosAntigos.IDLoja is NULL
								
								--update a somar para os totais das quantidades
								UPDATE tbStockArtigos SET Quantidade =  Round(Quantidade + ArtigosAntigos.Qtd,6), 
								QuantidadeStock = Round(QuantidadeStock + ArtigosAntigos.QtdStock,6), 
								QuantidadeStock2 = Round(QuantidadeStock2 + ArtigosAntigos.QtdStock2,6),
								QuantidadeReservada = Round(isnull(QuantidadeReservada,0) + ArtigosAntigos.QtdStockReservado, 6), 
								QuantidadeReservada2 = Round(isnull(QuantidadeReservada2,0) + ArtigosAntigos.QtdStock2Reservado, 6) FROM tbStockArtigos AS CCART
								INNER JOIN (
								SELECT IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, 
								SUM(Case Natureza WHEN ''S'' Then isnull(Quantidade,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(Quantidade,0) ELSE 0 END END) as Qtd,
								SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock,0) ELSE 0 END END) as QtdStock,
								SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock2,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock2,0) ELSE 0 END END) as QtdStock2,
								SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva,0) ELSE isnull(QtdStockReserva,0)*-1 END) as QtdStockReservado,
								SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva2Uni,0) ELSE isnull(QtdStockReserva2Uni,0)*-1 END) as QtdStock2Reservado
								FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
								GROUP BY IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
								) AS ArtigosAntigos
								ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
								

								--colocar o campo a false nas linhas dos documentos
								SET @strSqlQueryUpdates = '' UPDATE '' + QUOTENAME(@strTabelaLinhas) + '' SET Alterada=0 FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
															LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')'' +  
															'' WHERE Cab1.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND Cab1.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) 
																
								EXEC(@strSqlQueryUpdates)	
								--CHAMAR AQUI O OUTRO STORED PROCEDURE COM O ESTADO inserir		
								 Execute sp_AtualizaArtigos @lngidDocumento, @lngidTipoDocumento,0,@strTabelaCabecalho,@strTabelaLinhas,@strTabelaLinhasDist,@strCampoRelTabelaLinhasCab,@strCampoRelTabelaLinhasDistLinhas,@strUtilizador

								--chama aqui o stock de necessidades
								Execute sp_AtualizaStockNecessidades @lngidDocumento, @lngidTipoDocumento,0,@strUtilizador

								IF  @strNaturezaaux = ''[#F3MN#F3M]''--só existe transferencia para os stocks
									BEGIN
										IF @inValidaStock<>0
											BEGIN
												--entrada
												Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, 1, 1, 1 , 1, 1 , ''E'' 
										
												--saída
												Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, 1, @inLimitMin, @inRutura, 1 , 1, 1 , ''S'' 
											END
									END
								ELSE
									BEGIN
									   IF @inValidaStock<>0
											BEGIN
											   Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, @inLimitMin, @inRutura, 1, 1, 1, @strNaturezaaux 
											END
									END
						END
					ELSE --apagar
						BEGIN
							--3) Linhas que existiam e agora deixaram de existir no documento, para essas, marcar a linha à frente desse artigo para recalcular a partir daí
							---  caso não existe nenhum para à frente não marcar nenhuma
							IF  len(@strTabelaLinhasDist)>0
								BEGIN
									SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
									SET @strQueryWhereDistUpdates = '' AND isnull(CCART.IDArtigoDimensao,0) = isnull(Docs.IDArtigoDimensao,0) '' 
									SET @strQueryCamposDistUpdates =''isnull(CCartigos.IDArtigoDimensao,0) as IDArtigoDimensao, ''
									SET @strQueryWhereDistUpdates1 = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Doc.IDArtigoDimensao,0) '' 
									SET @strQueryCamposDistUpdates1 =''isnull(CCART.IDArtigoDimensao,0) as IDArtigoDimensao, ''
									SET @strQueryGroupbyDistUpdates = '', isnull(CCART.IDArtigoDimensao,0)''
									SET @strQueryWhereFrente = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Frente.IDArtigoDimensao,0) ''
									SET @strQueryONDist = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) ''
								END
							ELSE
								BEGIN
									SET @strQueryLeftJoinDistUpdates = '' ''
									SET @strQueryWhereDistUpdates = ''''
									SET @strQueryCamposDistUpdates ='' ''
									SET @strQueryWhereDistUpdates1 = '' '' 
									SET @strQueryCamposDistUpdates1 ='' ''
									SET @strQueryGroupbyDistUpdates = '' ''	
									SET @strQueryWhereFrente = '' ''	
									SET @strQueryONDist = '' ''
								END
							SET @strQueryDocsUpdates = ''LEFT JOIN 
											(SELECT distinct CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + '' CCartigos.DataControloInterno  FROM  tbCCStockArtigos AS CCartigos
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
											'' + @strQueryLeftJoinDistUpdates + ''
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
											WHERE CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' 
											AND (CCartigos.Natureza=''''E'''' OR CCartigos.Natureza=''''S'''')
											AND (Linhas.ID IS NULL '' + @strQueryONDist + '')
											AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											) AS Docs
											ON (Docs.IDArtigo = CCART.IDArtigo '' + @strQueryWhereDistUpdates + '')''
									

								SET @strQueryDocsAFrente ='' (SELECT CCART.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Min(CCART.DataControloInterno) as Data FROM tbCCStockArtigos AS CCART
										LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCART.IDTipoDocumento
										LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
										LEFT JOIN tbArtigos AS Art ON Art.ID = CCART.IDArtigo ''
										+ @strQueryDocsUpdates +
										'' WHERE CCART.DataControloInterno > Docs.DataControloInterno and (CCART.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCART.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCART.Natureza=''''E'''' OR CCART.Natureza=''''S'''')
										AND NOT CCART.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
										GROUP BY  CCART.IDArtigo'' + @strQueryGroupbyDistUpdates + '') AS Frente
										ON (Frente.IDArtigo = CCA.IDArtigo '' + @strQueryWhereFrente + '' AND Frente.Data = CCA.DataControloInterno) ''

								SET @strSqlQueryUpdates ='' UPDATE tbCCStockArtigos SET Recalcular = 1 FROM tbCCStockArtigos AS CCA
									LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCA.IDTipoDocumento
									LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
									LEFT JOIN tbArtigos AS Art ON Art.ID = CCA.IDArtigo
									INNER JOIN ''
									+ @strQueryDocsAFrente + 
									'' WHERE (CCA.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCA.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCA.Natureza=''''E'''' OR CCA.Natureza=''''S'''')
									AND NOT CCA.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
									AND NOT Frente.IDArtigo IS NULL ''

							EXEC(@strSqlQueryUpdates)
							
						   --retirar as quantidades dos totais para as chaves dos artigos do documento
							UPDATE tbStockArtigos SET Quantidade = Round(Quantidade - ArtigosAntigos.Qtd,6), 
							QuantidadeStock = Round(QuantidadeStock - ArtigosAntigos.QtdStock,6), 
							QuantidadeStock2 = Round(QuantidadeStock2 - ArtigosAntigos.QtdStock2,6),
							QuantidadeReservada = Round(isnull(QuantidadeReservada,0) - ArtigosAntigos.QtdStockReservado, 6), 
							QuantidadeReservada2 = Round(isnull(QuantidadeReservada2,0) - ArtigosAntigos.QtdStock2Reservado, 6) FROM tbStockArtigos AS CCART
							INNER JOIN (
							SELECT IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, 
							SUM(Case Natureza WHEN ''S'' Then isnull(Quantidade,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(Quantidade,0) ELSE 0 END END) as Qtd,
							SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock,0) ELSE 0 END END) as QtdStock,
							SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock2,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock2,0) ELSE 0 END END) as QtdStock2,
							SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva,0) ELSE isnull(QtdStockReserva,0)*-1 END) as QtdStockReservado,
							SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva2Uni,0) ELSE isnull(QtdStockReserva2Uni,0)*-1 END) as QtdStock2Reservado
							FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento 
							GROUP BY IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
							) AS ArtigosAntigos
							ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
							
							--chama aqui o stock de necessidades
							  Execute sp_AtualizaStockNecessidades @lngidDocumento, @lngidTipoDocumento,2,@strUtilizador

							--CHAMAR AQUI O OUTRO STORED PROCEDURE COM O ESTADO APAGAR
							Execute sp_AtualizaArtigos @lngidDocumento, @lngidTipoDocumento,2,@strTabelaCabecalho,@strTabelaLinhas,@strTabelaLinhasDist,@strCampoRelTabelaLinhasCab,@strCampoRelTabelaLinhasDistLinhas,@strUtilizador
							--apagar aqui se estiverem a zero
							
							IF @inValidaStock<>0
							BEGIN	
							
								IF @strNaturezaStock <> ''[#F3MN#F3M]''
									BEGIN
										INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, IDArtigo, IDArtigoDimensao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	Ativo, Sistema, DataCriacao, UtilizadorCriacao)
										SELECT distinct CCartigos.IDTipoDocumento AS IDTipoDocumento, CCartigos.IDDocumento AS IDDocumento, CCartigos.IDArtigo,
										CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, @strUtilizador as UtilizadorCriacao 
										FROM tbCCStockArtigos  as CCartigos WHERE CCartigos.IDTipoDocumento = @lngidTipoDocumento AND CCartigos.IDDocumento = @lngidDocumento 	
										Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, @inLimitMin, @inRutura, @inLimitMaxDel, @inLimitMinDel, @inRuturaDel , @strNaturezaStock 
									END
								ELSE
									BEGIN
										 SET @inRutura = 1--ignora
										 SET @inLimitMin = 1--ignora
										 SET @inLimitMax = 1--ignora
								 
								        --Entrada
										INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, IDArtigo, IDArtigoDimensao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	Ativo, Sistema, DataCriacao, UtilizadorCriacao)
										SELECT distinct CCartigos.IDTipoDocumento AS IDTipoDocumento, CCartigos.IDDocumento AS IDDocumento, CCartigos.IDArtigo,
										CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, @strUtilizador as UtilizadorCriacao 
										FROM tbCCStockArtigos  as CCartigos WHERE CCartigos.IDTipoDocumento = @lngidTipoDocumento AND CCartigos.IDDocumento = @lngidDocumento AND CCartigos.Natureza = ''E''
										Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, @inLimitMin, @inRutura, 1 , @inLimitMinDel, @inRuturaDel , ''E'' 

										--Saída
										INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, IDArtigo, IDArtigoDimensao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	Ativo, Sistema, DataCriacao, UtilizadorCriacao)
										SELECT distinct CCartigos.IDTipoDocumento AS IDTipoDocumento, CCartigos.IDDocumento AS IDDocumento, CCartigos.IDArtigo,
										CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, @strUtilizador as UtilizadorCriacao 
										FROM tbCCStockArtigos  as CCartigos WHERE CCartigos.IDTipoDocumento = @lngidTipoDocumento AND CCartigos.IDDocumento = @lngidDocumento AND CCartigos.Natureza = ''S''
										Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, @inLimitMin, @inRutura, @inLimitMaxDel, 1, 1 , ''S'' 
									END
							END
							
							DELETE tbStockArtigos FROM tbStockArtigos AS CCART
							INNER JOIN (
							SELECT distinct IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
							 FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
							) AS ArtigosAntigos
							ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
									AND isnull(CCART.Quantidade,0) = 0 AND isnull(CCART.QuantidadeStock,0) = 0 AND isnull(CCART.QuantidadeStock2,0) = 0  AND isnull(CCART.QuantidadeReservada,0) = 0 AND isnull(CCART.QuantidadeReservada2,0) = 0
							
							-- apagar CCartigos
							DELETE FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
						END

						
				END	
			SET @strSqlQueryUpdates ='' update c set c.IDLoja=a.idloja from  tbArmazens a inner join tbCCStockArtigos c on a.id=c.IDArmazem where  a.idloja<>c.IDLoja ''
			EXEC(@strSqlQueryUpdates) 
			SET @strSqlQueryUpdates ='' update c set c.IDLoja=a.idloja from  tbArmazens a inner join tbStockArtigos c on a.id=c.IDArmazem where  a.idloja<>c.IDLoja ''
			EXEC(@strSqlQueryUpdates) 


			SET @strSqlQueryUpdates ='' update a set a.quantidade=b.quantidade,a.quantidadestock=b.quantidadestock, a.quantidadestock2=b.quantidadestock2, a.quantidadereservada=b.quantidadereservada, a.quantidadereservada2=b.quantidadereservada2
									from tbStockArtigos a inner join (select idartigo, idloja, idarmazem, idarmazemlocalizacao, idartigolote, IDArtigoNumeroSerie,IDArtigoDimensao, sum(quantidade) as quantidade, sum(quantidadestock) as quantidadestock, sum(quantidadestock2) as quantidadestock2, sum(quantidadereservada) as quantidadereservada, sum(quantidadereservada2) as quantidadereservada2 from tbStockArtigos group by idartigo, idloja, idarmazem, idarmazemlocalizacao, idartigolote, IDArtigoNumeroSerie,IDArtigoDimensao having count(id)>1) b 
									on a.IDArtigo=b.IDArtigo and a.idloja=b.idloja and a.idarmazem=b.idarmazem and a.idarmazemlocalizacao=b.IDArmazemLocalizacao and isnull(a.idartigolote,0)=isnull(b.idartigolote,0) and isnull(a.IDArtigoNumeroSerie,0)=isnull(b.IDArtigoNumeroSerie,0) and isnull(a.IDArtigoDimensao,0)=isnull(b.IDArtigoDimensao,0) ''
			EXEC(@strSqlQueryUpdates) 

			SET @strSqlQueryUpdates ='' delete a from tbStockArtigos a inner join (select min(id) as id, idartigo, idloja, idarmazem, idarmazemlocalizacao, idartigolote, IDArtigoNumeroSerie,IDArtigoDimensao, sum(quantidade) as quantidade, sum(quantidadestock) as quantidadestock, sum(quantidadestock2) as quantidadestock2, sum(quantidadereservada) as quantidadereservada, sum(quantidadereservada2) as quantidadereservada2
									from tbStockArtigos group by idartigo, idloja, idarmazem, idarmazemlocalizacao, idartigolote, IDArtigoNumeroSerie,IDArtigoDimensao having count(id)>1) b 
									on a.IDArtigo=b.IDArtigo and a.idloja=b.idloja and a.idarmazem=b.idarmazem and a.idarmazemlocalizacao=b.IDArmazemLocalizacao and a.id=b.id and isnull(a.idartigolote,0)=isnull(b.idartigolote,0) ''
			EXEC(@strSqlQueryUpdates) 

		END


	ELSE--copiar a partir daqui
		BEGIN
			SELECT @strModulo = M.Codigo,  @strTipoDocInterno = STD.Tipo, @strCodMovStock = TDMS.Codigo
			FROM tbTiposDocumento TD
			LEFT JOIN tbSistemaModulos M ON M.ID = TD.IDModulo
			LEFT JOIN tbSistemaTiposDocumento STD ON STD.ID = TD.IDSistemaTiposDocumento
			LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TD.IDSistemaTiposDocumentoMovStock
			LEFT JOIN tbSistemaAcoes as AcaoRutura ON AcaoRutura.id=TD.IDSistemaAcoesRupturaStock
			LEFT JOIN tbSistemaAcoes as AcaoLimiteMax ON AcaoLimiteMax.id=TD.IDSistemaAcoesStockMaximo
			LEFT JOIN tbSistemaAcoes as AcaoLimiteMin ON AcaoLimiteMin.id=TD.IDSistemaAcoesStockMinimo
			WHERE ISNULL(TD.GereStock,0) = 0 AND TD.ID=@lngidTipoDocumento

			if (@strTipoDocInterno = ''CmpFinanceiro'')
				 BEGIN
					IF (@intAccao = 0 OR @intAccao = 1) 
						BEGIN
							--3) Linhas que existiam e agora deixaram de existir no documento, para essas, marcar a linha à frente desse artigo para recalcular a partir daí
							---  caso não existe nenhum para à frente não marcar nenhuma
							IF (@intAccao = 1) --se é alterar
								BEGIN
									IF  len(@strTabelaLinhasDist)>0
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
											SET @strQueryWhereDistUpdates = '' AND isnull(CCART.IDArtigoDimensao,0) = isnull(Docs.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates =''isnull(CCartigos.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryWhereDistUpdates1 = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Doc.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates1 =''isnull(CCART.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryGroupbyDistUpdates = '', isnull(CCART.IDArtigoDimensao,0)''
											SET @strQueryWhereFrente = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Frente.IDArtigoDimensao,0) ''
											SET @strQueryONDist = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) ''
										END
									ELSE
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' ''
											SET @strQueryWhereDistUpdates = ''''
											SET @strQueryCamposDistUpdates ='' ''
											SET @strQueryWhereDistUpdates1 = '' '' 
											SET @strQueryCamposDistUpdates1 ='' ''
											SET @strQueryGroupbyDistUpdates = '' ''	
											SET @strQueryWhereFrente = '' ''	
											SET @strQueryONDist = '' ''
										END
										SET @strQueryDocsUpdates = ''LEFT JOIN 
													(SELECT distinct CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + '' CCartigos.DataControloInterno  FROM  tbCCStockArtigos AS CCartigos
													LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
													LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
													'' + @strQueryLeftJoinDistUpdates + ''
													LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
													WHERE CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + ''
													AND (CCartigos.Natureza=''''E'''' OR CCartigos.Natureza=''''S'''')
													AND (Linhas.ID IS NULL '' + @strQueryONDist + '')
													AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
													) AS Docs
													ON (Docs.IDArtigo = CCART.IDArtigo '' + @strQueryWhereDistUpdates + '')''
									

										SET @strQueryDocsAFrente ='' (SELECT CCART.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Min(CCART.DataControloInterno) as Data FROM tbCCStockArtigos AS CCART
												LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCART.IDTipoDocumento
												LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
												LEFT JOIN tbArtigos AS Art ON Art.ID = CCART.IDArtigo ''
												+ @strQueryDocsUpdates +
												'' WHERE CCART.DataControloInterno >= Docs.DataControloInterno and (CCART.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCART.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCART.Natureza=''''E'''' OR CCART.Natureza=''''S'''')
												AND NOT CCART.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
												GROUP BY  CCART.IDArtigo'' + @strQueryGroupbyDistUpdates + '') AS Frente
												ON (Frente.IDArtigo = CCA.IDArtigo '' + @strQueryWhereFrente + '' AND Frente.Data = CCA.DataControloInterno) ''

										SET @strSqlQueryUpdates ='' UPDATE tbCCStockArtigos SET Recalcular = 1 FROM tbCCStockArtigos AS CCA
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCA.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCA.IDArtigo
											INNER JOIN ''
											+ @strQueryDocsAFrente + 
											'' WHERE (CCA.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCA.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCA.Natureza=''''E'''' OR CCA.Natureza=''''S'''')
											AND NOT CCA.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											AND NOT Frente.IDArtigo IS NULL ''

									EXEC(@strSqlQueryUpdates)
								END
							Execute sp_RegistaCCRetCompras @lngidDocumento, @lngidTipoDocumento, 1, @strUtilizador ---verifica
							DELETE FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento ---apaga
							Execute sp_RegistaCCRetCompras @lngidDocumento, @lngidTipoDocumento, 0, @strUtilizador ---adiciona
						END
					else
						BEGIN
							--3) Linhas que existiam e agora deixaram de existir no documento, para essas, marcar a linha à frente desse artigo para recalcular a partir daí
							---  caso não existe nenhum para à frente não marcar nenhuma
							IF  len(@strTabelaLinhasDist)>0
								BEGIN
									SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
									SET @strQueryWhereDistUpdates = '' AND isnull(CCART.IDArtigoDimensao,0) = isnull(Docs.IDArtigoDimensao,0) '' 
									SET @strQueryCamposDistUpdates =''isnull(CCartigos.IDArtigoDimensao,0) as IDArtigoDimensao, ''
									SET @strQueryWhereDistUpdates1 = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Doc.IDArtigoDimensao,0) '' 
									SET @strQueryCamposDistUpdates1 =''isnull(CCART.IDArtigoDimensao,0) as IDArtigoDimensao, ''
									SET @strQueryGroupbyDistUpdates = '', isnull(CCART.IDArtigoDimensao,0)''
									SET @strQueryWhereFrente = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Frente.IDArtigoDimensao,0) ''
									SET @strQueryONDist = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) ''
								END
							ELSE
								BEGIN
									SET @strQueryLeftJoinDistUpdates = '' ''
									SET @strQueryWhereDistUpdates = ''''
									SET @strQueryCamposDistUpdates ='' ''
									SET @strQueryWhereDistUpdates1 = '' '' 
									SET @strQueryCamposDistUpdates1 ='' ''
									SET @strQueryGroupbyDistUpdates = '' ''	
									SET @strQueryWhereFrente = '' ''	
									SET @strQueryONDist = '' ''
								END
								SET @strQueryDocsUpdates = ''LEFT JOIN 
											(SELECT distinct CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + '' CCartigos.DataControloInterno  FROM  tbCCStockArtigos AS CCartigos
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
											'' + @strQueryLeftJoinDistUpdates + ''
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
											WHERE CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' 
											AND (CCartigos.Natureza=''''E'''' OR CCartigos.Natureza=''''S'''')
											AND (Linhas.ID IS NULL '' + @strQueryONDist + '')
											AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											) AS Docs
											ON (Docs.IDArtigo = CCART.IDArtigo '' + @strQueryWhereDistUpdates + '')''
									

								SET @strQueryDocsAFrente ='' (SELECT CCART.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Min(CCART.DataControloInterno) as Data FROM tbCCStockArtigos AS CCART
										LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCART.IDTipoDocumento
										LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
										LEFT JOIN tbArtigos AS Art ON Art.ID = CCART.IDArtigo ''
										+ @strQueryDocsUpdates +
										'' WHERE CCART.DataControloInterno >= Docs.DataControloInterno and (CCART.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCART.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCART.Natureza=''''E'''' OR CCART.Natureza=''''S'''')
										AND NOT CCART.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
										GROUP BY  CCART.IDArtigo'' + @strQueryGroupbyDistUpdates + '') AS Frente
										ON (Frente.IDArtigo = CCA.IDArtigo '' + @strQueryWhereFrente + '' AND Frente.Data = CCA.DataControloInterno) ''

								SET @strSqlQueryUpdates ='' UPDATE tbCCStockArtigos SET Recalcular = 1 FROM tbCCStockArtigos AS CCA
									LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCA.IDTipoDocumento
									LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
									LEFT JOIN tbArtigos AS Art ON Art.ID = CCA.IDArtigo
									INNER JOIN ''
									+ @strQueryDocsAFrente + 
									'' WHERE (CCA.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCA.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCA.Natureza=''''E'''' OR CCA.Natureza=''''S'''')
									AND NOT CCA.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
									AND NOT Frente.IDArtigo IS NULL ''

							EXEC(@strSqlQueryUpdates)

							DELETE FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento ---apaga
						END
				 END
		END


END TRY
BEGIN CATCH
	SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
	RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')

--alterar recálculo de último preco de custo
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_Recalculo_PCM_UPC]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_Recalculo_PCM_UPC]')

EXEC('CREATE PROCEDURE [dbo].[sp_Recalculo_PCM_UPC] 
	@IDRecalculo as bigint
AS
DECLARE db_cursor CURSOR FOR 

SELECT C.ID, C.IDArtigo, DataControloInterno, Natureza, isnull(TD.CustoMedio,0) as CustoMedio, isnull(QuantidadeStock,0), isnull(QtdAfetacaoStock,0), isnull(c.PrecoUnitarioEfetivoMoedaRef,0) + isnull(c.UltCustosAdicionaisMoedaRef,0) , isnull(c.PrecoUnitarioMoedaRef,0) , isnull(c.UltCustosAdicionaisMoedaRef,0) , isnull(c.UltDescComerciaisMoedaRef,0) 
,stdf.tipo, std.tipo, patindex(''%(ret.%'',VossoNumeroDocumento) as rectificacao
from tbCCStockArtigos C with (nolock) inner join tbf3mrecalculo on c.idartigo=tbf3mrecalculo.idartigo and tbf3mrecalculo.IDRecalculo=@IDRecalculo 
left join tbTiposDocumento TD with (nolock) on C.IDTipoDocumento=TD.id 
left join tbSistemaTiposDocumento STD with (nolock) on TD.IDSistemaTiposDocumento=STD.id
left join tbSistemaTiposDocumentoFiscal STDF with (nolock) on TD.IDSistemaTiposDocumentoFiscal=STDF.id
where TD.CustoMedio=1
order by c.idartigo, c.DataControloInterno, c.ID; 

DECLARE @ID bigint;
DECLARE @IDArtigo bigint;
DECLARE @IDArtigoAux bigint;
DECLARE @Natureza varchar(10); 
DECLARE @QuantidadeStock float; 
DECLARE @QuantidadeAfetacao float; 
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
DECLARE @DataCI datetime;
DECLARE @TipoFiscal varchar(50); 
DECLARE @TipoDocumento varchar(50); 
DECLARE @rectificacao float; 
 
set @QtdStockAnterior=0;
set @QtdStockAtual=0;
set @IDArtigoAux=0;
set @PCMAnteriorMoedaRef=0;
set @CustoMedio=0;
set @IDArtigo=0;
set @PrecoUnitarioEfetivoMoedaRef=0;
set @CM=0;

OPEN db_cursor;
  
FETCH NEXT FROM db_cursor INTO @ID, @IDArtigo, @DataCI, @Natureza, @CM, @QuantidadeStock, @QuantidadeAfetacao, @PrecoUnitarioEfetivoMoedaRef, @UPCMoedaRef, @UltCustosAdicionaisMoedaRef, @UltDescComerciaisMoedaRef, @TipoFiscal, @TipoDocumento, @rectificacao;
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
--set @PrecoUnitarioEfetivoMoedaRef=@CustoMedio;
SET @QtdStockAnterior=@QtdStockAtual;
SET @QtdStockAtual=@QtdStockAtual-@QuantidadeStock;
SET @PCMAnteriorMoedaRef=@CustoMedio;
end 
IF (@QtdStockAnterior+@QuantidadeStock)<=0
begin
set @CustoMedio=0;
end
else IF (@QtdStockAtual)<=0
begin
set @CustoMedio=0;
end
else
begin
if @QtdStockAnterior<=0 
begin
set @CustoMedio=@PrecoUnitarioEfetivoMoedaRef;
end
else
begin
if (@TipoFiscal=''FT'' or @TipoFiscal=''FR'' or @TipoFiscal=''FS'') and @TipoDocumento=''CmpFinanceiro'' and @rectificacao>0
begin
print ''f'';
set @CustoMedio=CAST(((@QtdStockAnterior*@PCMAnteriorMoedaRef)+(@QuantidadeAfetacao*@PrecoUnitarioEfetivoMoedaRef)-(@QuantidadeAfetacao*@PCMAnteriorMoedaRef))/(@QtdStockAtual) as decimal(30,4));
print @CustoMedio;
end
else if @TipoFiscal=''ND'' and @TipoDocumento=''CmpFinanceiro'' and @rectificacao>0
begin
print ''d'';
set @CustoMedio=CAST(((@QtdStockAnterior*@PCMAnteriorMoedaRef)+(@QuantidadeAfetacao*@PrecoUnitarioEfetivoMoedaRef))/(@QtdStockAtual) as decimal(30,4));
print @CustoMedio;
end
else if @TipoFiscal=''NC'' and @TipoDocumento=''CmpFinanceiro'' and @rectificacao>0
begin
print ''c'';
--print (@PrecoUnitarioEfetivoMoedaRef);
set @CustoMedio=CAST(((@QtdStockAnterior*@PCMAnteriorMoedaRef)-(@QuantidadeAfetacao*@PrecoUnitarioEfetivoMoedaRef))/(@QtdStockAtual) as decimal(30,4));
print @CustoMedio;
end
else
begin
print ''a'';
set @CustoMedio=CAST((@QtdStockAnterior*@PCMAnteriorMoedaRef+@PrecoUnitarioEfetivoMoedaRef*@QuantidadeStock)/(@QtdStockAnterior+@QuantidadeStock) as decimal(30,4));
print @CustoMedio;
end
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

FETCH NEXT FROM db_cursor INTO @ID, @IDArtigo, @DataCI, @Natureza, @CM, @QuantidadeStock, @QuantidadeAfetacao, @PrecoUnitarioEfetivoMoedaRef, @UPCMoedaRef, @UltCustosAdicionaisMoedaRef, @UltDescComerciaisMoedaRef, @TipoFiscal, @TipoDocumento, @rectificacao;
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;
')

--novo SP para inserir retificações de preços nas compras já registadas
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_InsereRetificacao]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_InsereRetificacao]')

EXEC('CREATE PROCEDURE [dbo].[sp_InsereRetificacao] 
	AS
DECLARE db_cursor CURSOR FOR 

SELECT C.ID, c.IDTipoDocumento 
from tbDocumentosCompras c
where C.CodigoTipoEstado=''EFT''
order by c.DataDocumento, c.ID; 

DECLARE	@lngidDocumento AS bigint = null
DECLARE @lngidTipoDocumento AS bigint = null
DECLARE @strUtilizador AS nvarchar(256) = ''F3M''

OPEN db_cursor;
  
FETCH NEXT FROM db_cursor INTO @lngidDocumento, @lngidTipoDocumento;
WHILE @@FETCH_STATUS = 0  
BEGIN 


			INSERT INTO tbCCStockArtigos (Natureza, IDArtigo, Descricao, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie,
										  IDArtigoDimensao, IDMoeda, IDTipoEntidade, IDEntidade, IDTipoDocumento, IDDocumento, IDLinhaDocumento, NumeroDocumento, DataControloInterno, IDTipoDocumentoOrigem,
										  IDDocumentoOrigem, IDLinhaDocumentoOrigem, IDTipoDocumentoOrigemInicial, IDDocumentoOrigemInicial, IDLinhaDocumentoOrigemInicial, DocumentoOrigemInicial, 
										  Quantidade, QuantidadeStock, QuantidadeStock2, QtdStockReserva, QtdStockReserva2Uni, QtdStockAnterior, QtdStockAtual, QtdAfetacaoStock, QtdAfetacaoStock2, 
										  PrecoUnitario, PrecoUnitarioEfetivo, PrecoUnitarioMoedaRef, PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef, 
										  PCMAnteriorMoedaRef, PCMAtualMoedaRef, PVMoedaRef, UPCompraMoedaRef, UltCustosAdicionaisMoedaRef, UltDescComerciaisMoedaRef, Recalcular, DataDocumento, TaxaConversao, 
										  Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, VossoNumeroDocumento, VossoNumeroDocumentoOrigem, NumeroDocumentoOrigem, 
										  IDTiposDocumentoSeries, IDTiposDocumentoSeriesOrigem) 

			SELECT Case when isnull(stFiscal.Tipo,'''') = ''NC'' then ''S'' else ''E'' end as Natureza, lin.IDArtigo, lin.Descricao,  
			Case when isnull(stFiscal.Tipo,'''') = ''NC'' then lin.IDArmazem else lin.IDArmazemDestino end as IDArmazem,
			Case when isnull(stFiscal.Tipo,'''') = ''NC'' then lin.IDArmazemLocalizacao else lin.IDArmazemLocalizacaoDestino end as IDArmazemLocalizacao,
			lin.IDLote as IDArtigoLote,
			lin.IDArtigoNumSerie as IDArtigoNumeroSerie,
			linDim.IDArtigoDimensao AS IDArtigoDimensao,
			Cmp.IDMoeda,
			Cmp.IDTipoEntidade, 
			Cmp.IDEntidade, 
			Cmp.IDTipoDocumento,
			Cmp.ID as IDDocumento, 
			lin.id as IDLinhaDocumento, 
			Cmp.NumeroDocumento,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
				CmpOrigem2.DataControloInterno 
			ELSE
				CmpOrigem.DataControloInterno 
			END
			AS DataControloInterno,
			lin.IDTipoDocumentoOrigem,
			lin.IDDocumentoOrigem as IDDocumentoOrigem,
			lin.IDLinhaDocumentoOrigem as IDLinhaDocumentoOrigem,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---os Iniciais na CC para retificativos ficam com o doc que movimentou stock
				TipoDocOrigem2.ID
			ELSE
				TipoDocOrigem.ID
			END
			AS IDTipoDocumentoOrigemInicial,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---os Iniciais na CC para retificativos ficam com o doc que movimentou stock
				CmpOrigem2.ID
			ELSE
				CmpOrigem.ID
			END
			AS IDDocumentoOrigemInicial, 
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---os Iniciais na CC para retificativos ficam com o doc que movimentou stock
				linOrigem2.ID
			ELSE
				linOrigem.ID
			END
			AS IDLinhaDocumentoOrigemInicial, 
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---os Iniciais na CC para retificativos ficam com o doc que movimentou stock
				CmpOrigem2.Documento
			ELSE
				CmpOrigem.Documento
			END
			AS DocumentoOrigemInicial,
			0 as Quantidade, 
			0 as QuantidadeStock,
			0 as QuantidadeStock2,
			0 as QtdStockReserva,
			0 as QtdStockReserva2Uni,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
				isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0)
			ELSE
				isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0) 			
			END
			AS QtdStockAnterior,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
				isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0)
			ELSE
				isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0) 			
			END
			as QtdStockAtual,
			ABS(Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock else lin.QuantidadeStock end)  as QtdAfetacaoStock, 
			ABS(Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock2 else lin.QuantidadeStock2 end)  as QtdAfetacaoStock2,
			Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.PrecoUnitario else lin.PrecoUnitario end  as PrecoUnitario,
			Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.PrecoUnitarioEfetivo else lin.PrecoUnitarioEfetivo end  as PrecoUnitarioEfetivo,
			Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.PrecoUnitarioMoedaRef else lin.PrecoUnitarioMoedaRef end  as PrecoUnitarioMoedaRef,
			Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.PrecoUnitarioEfetivoMoedaRef else lin.PrecoUnitarioEfetivoMoedaRef end  as PrecoUnitarioEfetivoMoedaRef,
			Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END AS UPCMoedaRef,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---tem de ser ao contrário, pois a 2 movimentou e 1 tb, mas quem nada e a 2
				isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumentoOrigemInicial = CmpOrigem2.IDTipoDocumento and 
																	IDDocumentoOrigemInicial =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumentoOrigemInicial =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0) and isnull(QuantidadeStock,0) = 0 and isnull(QtdAfetacaoStock,0) <> 0 
																	ORDER BY DataControloInterno DESC, ID DESC),
																	isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0))

			ELSE
				isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumentoOrigemInicial = CmpOrigem.IDTipoDocumento and 
																	IDDocumentoOrigemInicial =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumentoOrigemInicial =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0) and isnull(QuantidadeStock,0) = 0 and isnull(QtdAfetacaoStock,0) <> 0 
																	ORDER BY DataControloInterno DESC, ID DESC),
																	isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0)) 		
			END
			AS PCMAnteriorMoedaRef,
			Round(
				CASE WHEN 
					CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
						isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0)
					ELSE
						isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0) 			
					END > 0 then

			((CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
				isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0)
			ELSE
				isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0) 			
			END
			*
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---tem de ser ao contrário, pois a 2 movimentou e 1 tb, mas quem nada e a 2
				isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumentoOrigemInicial = CmpOrigem2.IDTipoDocumento and 
																	IDDocumentoOrigemInicial =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumentoOrigemInicial =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0) and isnull(QuantidadeStock,0) = 0 and isnull(QtdAfetacaoStock,0) <> 0 
																	ORDER BY DataControloInterno DESC, ID DESC),
																	isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0))

			ELSE
				isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumentoOrigemInicial = CmpOrigem.IDTipoDocumento and 
																	IDDocumentoOrigemInicial =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumentoOrigemInicial =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0) and isnull(QuantidadeStock,0) = 0 and isnull(QtdAfetacaoStock,0) <> 0 
																	ORDER BY DataControloInterno DESC, ID DESC),
																	isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0)) 		
			END
			)
			+
			CASE WHEN isnull(stFiscal.Tipo,'''') = ''NC'' Then
				---só aplicar formulas
				- (Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock else lin.QuantidadeStock end
					*
					Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END	
					)
			ELSE
				CASE WHEN isnull(stFiscal.Tipo,'''') = ''ND'' Then
				-----só aplicar formulas
					(Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock else lin.QuantidadeStock end
					*
					Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END	
					) 
				ELSE--FT''s
				---só aplicar formulas
					(Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock else lin.QuantidadeStock end
					*
					Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END	
					) 
					-
						(Case WHEN isnull(linDim.ID,0) <> 0 Then linDim.QuantidadeStock else lin.QuantidadeStock end
						*
						CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then---tem de ser ao contrário, pois a 2 movimentou e 1 tb, mas quem nada e a 2
							isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumentoOrigemInicial = CmpOrigem2.IDTipoDocumento and 
																				IDDocumentoOrigemInicial =linOrigem2.IDDocumentoCompra and 
																				IDLinhaDocumentoOrigemInicial =linOrigem2.ID and 
																				IDArtigo = linOrigem2.IDArtigo and
																				isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0) and isnull(QuantidadeStock,0) = 0 and isnull(QtdAfetacaoStock,0) <> 0 
																				ORDER BY DataControloInterno DESC, ID DESC),
																				isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																				IDDocumento =linOrigem2.IDDocumentoCompra and 
																				IDLinhaDocumento =linOrigem2.ID and 
																				IDArtigo = linOrigem2.IDArtigo and
																				isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0))

						ELSE
							isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumentoOrigemInicial = CmpOrigem.IDTipoDocumento and 
																				IDDocumentoOrigemInicial =linOrigem.IDDocumentoCompra and 
																				IDLinhaDocumentoOrigemInicial =linOrigem.ID and 
																				IDArtigo = linOrigem.IDArtigo and
																				isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0) and isnull(QuantidadeStock,0) = 0 and isnull(QtdAfetacaoStock,0) <> 0 
																				ORDER BY DataControloInterno DESC, ID DESC),
																				isnull((SELECT TOP 1 PCMAtualMoedaRef FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																				IDDocumento =linOrigem.IDDocumentoCompra and 
																				IDLinhaDocumento =linOrigem.ID and 
																				IDArtigo = linOrigem.IDArtigo and
																				isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0)) 		
						END
						)
				END
			END) / CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
						isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem2.IDTipoDocumento and 
																	IDDocumento =linOrigem2.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem2.ID and 
																	IDArtigo = linOrigem2.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem2.IDArtigoDimensao,0)),0)
					ELSE
						isnull((SELECT TOP 1 QtdStockAtual FROM tbCCStockArtigos WHERE IDTipoDocumento = CmpOrigem.IDTipoDocumento and 
																	IDDocumento =linOrigem.IDDocumentoCompra and 
																	IDLinhaDocumento =linOrigem.ID and 
																	IDArtigo = linOrigem.IDArtigo and
																	isnull(IDArtigoDimensao,0) = isnull(linDimOrigem.IDArtigoDimensao,0)),0) 			
					END
				else
				0
				end,
			isnull(tbMoedasRef.CasasDecimaisPrecosUnitarios,0))
			AS PCMAtualMoedaRef,
			Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.PVMoedaRef,0) ELSE isnull(lin.PVMoedaRef,0) END AS PVMoedaRef,
			Case WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UPCompraMoedaRef,0) ELSE isnull(lin.UPCompraMoedaRef,0) END AS UPCompraMoedaRef,
			CASE WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UltCustosAdicionaisMoedaRef,0) ELSE isnull(lin.UltCustosAdicionaisMoedaRef,0) END AS UltCustosAdicionaisMoedaRef,
			CASE WHEN isnull(linDim.ID,0) <> 0 THEN isnull(linDim.UltDescComerciaisMoedaRef,0) ELSE isnull(lin.UltDescComerciaisMoedaRef,0) END AS UltDescComerciaisMoedaRef,
			isnull(lin.Alterada,0) AS Recalcular,
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
				CmpOrigem2.DataDocumento 
			ELSE
				CmpOrigem.DataDocumento 
			END
			AS DataDocumento, 
			Cmp.TaxaConversao, 1 AS Ativo, 1 AS Sistema, Cmp.DataCriacao, 
			@strUtilizador  AS UtilizadorCriacao,
			Cmp.DataAlteracao,  @strUtilizador AS UtilizadorAlteracao, 
			CASE WHEN isnull(TipoDocOrigem2.GereStock,0) <> 0 Then
				Cmp.VossoNumeroDocumento + '' (ret. '' + CmpOrigem2.VossoNumeroDocumento + '')''
			ELSE
				Cmp.VossoNumeroDocumento + '' (ret. '' + CmpOrigem.VossoNumeroDocumento + '')''
			END
			AS VossoNumeroDocumento,
			lin.VossoNumeroDocumentoOrigem, 
			lin.NumeroDocumentoOrigem, 
			Cmp.IDTiposDocumentoSeries, 
			lin.IDTiposDocumentoSeriesOrigem														 
		FROM tbDocumentosCompras as Cmp
		left join tbTiposDocumento as TipoDoc On TipoDoc.ID = Cmp.IDTipoDocumento
		left join tbSistemaTiposDocumento as sttipo on sttipo.ID = TipoDoc.IDSistemaTiposDocumento
		left join tbSistemaTiposDocumentoFiscal as stFiscal on stFiscal.id = TipoDoc.IDSistemaTiposDocumentoFiscal
		left join tbDocumentosComprasLinhas as lin ON lin.IDDocumentoCompra = Cmp.ID
		left join tbArtigos as Art On art.id = lin.IDArtigo
		left join tbArtigosStock as artstk on artstk.IDArtigo = Art.ID
		left join tbDocumentosComprasLinhasDimensoes as linDim ON isnull(linDim.IDDocumentoCompraLinha,0) = isnull(lin.ID,0)
		left join tbArtigosDimensoes as artdim ON artdim.ID = linDim.IDArtigoDimensao
		---joins da Origem
		left join tbTiposDocumento as TipoDocOrigem On isnull(TipoDocOrigem.ID,0) = isnull(lin.IDTipoDocumentoOrigem,0)
		left join tbSistemaTiposDocumento as sttipoOrigem on isnull(sttipoOrigem.ID,0) = isnull(TipoDocOrigem.IDSistemaTiposDocumento,0)
		left join tbSistemaTiposDocumentoFiscal as stFiscalOrigem on isnull(stFiscalOrigem.id,0) = isnull(TipoDocOrigem.IDSistemaTiposDocumentoFiscal,0)
		left join tbDocumentosComprasLinhas as linOrigem ON isnull(linOrigem.IDDocumentoCompra,0) = isnull(lin.IDDocumentoOrigem,0) and isnull(linOrigem.id,0) = isnull(lin.IDLinhaDocumentoOrigem,0)
		left join tbDocumentosComprasLinhasDimensoes as linDimOrigem ON isnull(linDimOrigem.IDDocumentoCompraLinha,0) = isnull(linOrigem.ID,0) and isnull(linDimOrigem.ID,0) = isnull(linDim.IDLinhaDimensaoDocumentoOrigem,0)
		left join tbDocumentosCompras as CmpOrigem ON CmpOrigem.ID = linOrigem.IDDocumentoCompra
		---joins da Origem da origem
		left join tbTiposDocumento as TipoDocOrigem2 On isnull(TipoDocOrigem2.ID,0) = isnull(linOrigem.IDTipoDocumentoOrigem,0)
		left join tbSistemaTiposDocumento as sttipoOrigem2 on isnull(sttipoOrigem2.ID,0) = isnull(TipoDocOrigem2.IDSistemaTiposDocumento,0)
		left join tbSistemaTiposDocumentoFiscal as stFiscalOrigem2 on isnull(stFiscalOrigem2.id,0) = isnull(TipoDocOrigem2.IDSistemaTiposDocumentoFiscal,0)
		left join tbDocumentosComprasLinhas as linOrigem2 ON isnull(linOrigem2.IDDocumentoCompra,0) = isnull(linOrigem.IDDocumentoOrigem,0) and isnull(linOrigem2.id,0) = isnull(linOrigem.IDLinhaDocumentoOrigem,0)
		left join tbDocumentosComprasLinhasDimensoes as linDimOrigem2 ON isnull(linDimOrigem2.IDDocumentoCompraLinha,0) = isnull(linOrigem2.ID,0) and isnull(linDimOrigem2.ID,0) = isnull(linDimOrigem.IDLinhaDimensaoDocumentoOrigem,0)
		left join tbDocumentosCompras as CmpOrigem2 ON CmpOrigem2.ID = linOrigem2.IDDocumentoCompra
		---ligação com a conta corrente
		LEFT JOIN tbCCStockArtigos AS CCartigos ON (Cmp.IDTipoDocumento=CCartigos.IDTipoDocumento and lin.IDDocumentoCompra = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=lin.id AND lin.IDArtigo = CCartigos.IDArtigo and
		isnull(linDim.IDArtigoDimensao,0) = isnull(CCartigos.IDArtigoDimensao,0) and isnull(CCartigos.Quantidade,0)=0)
		LEFT JOIN tbParametrosEmpresa as P ON 1 = 1
		LEFT JOIN tbMoedas as tbMoedasRef ON tbMoedasRef.ID=P.IDMoedaDefeito
		---condições base
		WHERE Cmp.id=@lngidDocumento and Cmp.IDTipoDocumento=@lngidTipoDocumento and
			isnull(sttipo.Tipo,'''') = ''CmpFinanceiro'' and 
			isnull(lin.IDArtigo,0)<>0 and 
			isnull(art.GereStock,0) <> 0 and
			isnull(lin.IDTipoDocumentoOrigem,0) <> 0 and
			isnull(TipoDoc.DocNaoValorizado,0) = 0 and
		(
			---condição Guias VGR;VGT->VFT;VFS;VFR
			((isnull(stFiscal.Tipo,'''') = ''FT'' OR isnull(stFiscal.Tipo,'''') = ''FR'' OR isnull(stFiscal.Tipo,'''') = ''FS'') and
			isnull(sttipoOrigem.Tipo,'''') = ''CmpTransporte'' and (isnull(stFiscalOrigem.Tipo,'''') = ''GR'' OR isnull(stFiscalOrigem.Tipo,'''') = ''GT'') and
			isnull(TipoDocOrigem.GereStock,0) <> 0 and 
			CASE when isnull(linDim.ID,0)<>0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END <> CASE when isnull(linDimOrigem.ID,0)<>0 THEN isnull(linDimOrigem.UPCMoedaRef,0) ELSE isnull(linOrigem.UPCMoedaRef,0) END				
			)
			OR
			---condição FT''s VFT;VFS;VFR -> nota de débito
			(isnull(stFiscal.Tipo,'''') = ''ND'' and  CASE when isnull(linDim.ID,0)<>0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END <> 0 and  
			( (isnull(sttipoOrigem.Tipo,'''') = ''CmpFinanceiro'' and
					(isnull(stFiscalOrigem.Tipo,'''') = ''FR'' OR isnull(stFiscalOrigem.Tipo,'''') = ''FS'' OR isnull(stFiscalOrigem.Tipo,'''') = ''FT'') and 
					isnull(TipoDocOrigem.GereStock,0) <> 0
				) OR
				(
				isnull(sttipoOrigem2.Tipo,'''') = ''CmpTransporte'' and (isnull(stFiscalOrigem2.Tipo,'''') = ''GR'' OR isnull(stFiscalOrigem2.Tipo,'''') = ''GT'') and
				isnull(TipoDocOrigem2.GereStock,0) <> 0
				)
			)
			)
			OR
			---condição FT''s VFT;VFS;VFR -> nota de crédito
			(isnull(TipoDoc.GereStock,0) = 0 and isnull(stFiscal.Tipo,'''') = ''NC'' and  CASE when isnull(linDim.ID,0)<>0 THEN isnull(linDim.UPCMoedaRef,0) ELSE isnull(lin.UPCMoedaRef,0) END <> 0 and  
			( (isnull(sttipoOrigem.Tipo,'''') = ''CmpFinanceiro'' and
					(isnull(stFiscalOrigem.Tipo,'''') = ''FR'' OR isnull(stFiscalOrigem.Tipo,'''') = ''FS'' OR isnull(stFiscalOrigem.Tipo,'''') = ''FT'') and 
					isnull(TipoDocOrigem.GereStock,0) <> 0
				) OR
				(
				isnull(sttipoOrigem2.Tipo,'''') = ''CmpTransporte'' and (isnull(stFiscalOrigem2.Tipo,'''') = ''GR'' OR isnull(stFiscalOrigem2.Tipo,'''') = ''GT'') and
				isnull(TipoDocOrigem2.GereStock,0) <> 0
				)
			)
			)
		)

FETCH NEXT FROM db_cursor INTO @lngidDocumento, @lngidTipoDocumento;
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;
')

--alterações bootstrap
EXEC('update tbExamesProps set ViewClassesCSS = ''col-1'' where ViewClassesCSS = ''col-xs-1''')
EXEC('update tbExamesProps set ViewClassesCSS = ''col-2'' where ViewClassesCSS = ''col-xs-2''')
EXEC('update tbExamesProps set ViewClassesCSS = ''col-3'' where ViewClassesCSS = ''col-xs-3''')
EXEC('update tbExamesProps set ViewClassesCSS = ''col-4'' where ViewClassesCSS = ''col-xs-4''')
EXEC('update tbExamesProps set ViewClassesCSS = ''col-5'' where ViewClassesCSS = ''col-xs-5''')
EXEC('update tbExamesProps set ViewClassesCSS = ''col-6'' where ViewClassesCSS = ''col-xs-6''')
EXEC('update tbExamesProps set ViewClassesCSS = ''col-7'' where ViewClassesCSS = ''col-xs-7''')
EXEC('update tbExamesProps set ViewClassesCSS = ''col-8'' where ViewClassesCSS = ''col-xs-8''')
EXEC('update tbExamesProps set ViewClassesCSS = ''col-9'' where ViewClassesCSS = ''col-xs-9''')
EXEC('update tbExamesProps set ViewClassesCSS = ''col-10'' where ViewClassesCSS = ''col-xs-10''')
EXEC('update tbExamesProps set ViewClassesCSS = ''col-11'' where ViewClassesCSS = ''col-xs-11''')
EXEC('update tbExamesProps set ViewClassesCSS = ''col-12'' where ViewClassesCSS = ''col-xs-12''')
EXEC('update tbExamesProps set ViewClassesCSS = ''CTabCabecalho tab-bg col-12'' where ViewClassesCSS = ''CTabCabecalho tab-bg col-xs-12''')
EXEC('update tbExamesProps set ViewClassesCSS = ''in active'' where ViewClassesCSS = ''show active''')

EXEC('update [F3MOGeral].dbo.tbparametroslistaspersonalizadas set ViewClassesCSS=replace(ViewClassesCSS,''col-xs-'',''col-'')')

--listas personalizadas das graduações transpostas
EXEC('IF NOT EXISTS (SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao = ''Lentes Oftálmicas - Transposta'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Artigos''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Lentes Oftálmicas - Transposta'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbArtigos'', 
N''select u.codigo as unidade, l.id as idloja, isnull(st.QuantidadeStock,0) as QuantidadeStock,  tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, mo.Descricao as DescricaoModelo, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca, (case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo,  tb.Diametro, 
(case when isnull(tb.PotenciaCilindrica,0)<>0 then convert(varchar(max),convert(decimal(10,2),isnull(tb.PotenciaCilindrica,0))) + char(13) + convert(varchar(max),convert(decimal(10,2),-(isnull(tb.PotenciaCilindrica,0)))) else convert(varchar(max),convert(decimal(10,2),isnull(tb.PotenciaCilindrica,0))) end) as PotenciaCilindricaTransposta, 
(case when isnull(tb.PotenciaCilindrica,0)<>0 then convert(varchar(max),convert(decimal(10,2),isnull(tb.PotenciaEsferica,0))) + char(13) +  convert(varchar(max),convert(decimal(10,2),(isnull(tb.PotenciaEsferica,0)+isnull(tb.PotenciaCilindrica,0)))) else convert(varchar(max),convert(decimal(10,2),isnull(tb.PotenciaEsferica,0))) end) as PotenciaEsfericaTransposta, 
isnull(tb.PotenciaPrismatica,0) as PotenciaPrismatica, isnull(tb.Adicao,0) as Adicao  
from tbartigos left join tblojas l on l.id=''''[%%IDLoja%%]'''' left join tbstockartigos st on tbartigos.id=st.IDArtigo and l.id=st.IDLoja left join tbunidades u on tbartigos.idunidade=u.id  left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo and ap.idcodigopreco=1 and (st.idloja=ap.IDLoja or (ap.idloja is null and not ap.idcodigopreco is null))  inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id  inner join tbLentesoftalmicas tb on tbartigos.id=tb.IDArtigo left join tbModelos mo on tb.IDModelo=mo.id left join tbmarcas m on tbartigos.idmarca=m.id'', null, 1)
END
')

EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Lentes Oftálmicas - Transposta''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Codigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbArtigos'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDMarca'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 200)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDModelo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, ''tbFornecedores'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Diametro'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PotenciaEsfericaTransposta'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PotenciaCilindricaTransposta'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Adicao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PotenciaPrismatica'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''ValorComIva'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QuantidadeStock'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Unidade'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDSistemaClassificacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 110)
END')

EXEC('IF NOT EXISTS (SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao = ''Lentes de Contato - Transposta'')
BEGIN
DECLARE @IDMenu as bigint
DECLARE @IDUtil as bigint
SELECT @IDMenu = ID  FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''Artigos''
SELECT @IDUtil = IDUtilizador FROM [F3MOGeral].[dbo].[AspNetUsers] WHERE UserName=''F3M''
INSERT [F3MOGeral].[dbo].[tbListasPersonalizadas] ([Descricao], [IDUtilizadorProprietario], [PorDefeito], [IDMenu], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Base], [TabelaPrincipal], [Query], [IDSistemaCategListasPers], [IDSistemaTipoLista]) 
VALUES (N''Lentes de Contato - Transposta'', @IDUtil, 1, @IDMenu, 1, 1, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', 1, N''tbArtigos'', 
N''select u.codigo as unidade, l.id as idloja, isnull(st.QuantidadeStock,0) as QuantidadeStock,  tbartigos.ID, tbartigos.Codigo, tbartigos.Descricao, isnull(ap.ValorComIva, 0) as ValorComIva, m.Descricao as DescricaoMarca, mo.Descricao as DescricaoModelo, tbartigos.IDTipoArtigo, tbartigos.IDSistemaClassificacao, tbartigos.IDMarca, (case when sta.id=1 then ''''Lentes Oftálmicas'''' when sta.id=3 then ''''Lentes de Contato'''' when sta.id=4 then ''''Óculos de Sol'''' else sta.descricao end) DescricaoTipoArtigo, tbartigos.Ativo,  tb.raio, tb.Diametro, 
(case when isnull(tb.PotenciaCilindrica,0)<>0 then convert(varchar(max),convert(decimal(10,2),isnull(tb.PotenciaCilindrica,0))) + char(13) + convert(varchar(max),convert(decimal(10,2),-(isnull(tb.PotenciaCilindrica,0)))) else convert(varchar(max),convert(decimal(10,2),isnull(tb.PotenciaCilindrica,0))) end) as PotenciaCilindricaTransposta, 
(case when isnull(tb.PotenciaCilindrica,0)<>0 then convert(varchar(max),convert(decimal(10,2),isnull(tb.PotenciaEsferica,0))) + char(13) +  convert(varchar(max),convert(decimal(10,2),(isnull(tb.PotenciaEsferica,0)+isnull(tb.PotenciaCilindrica,0)))) else convert(varchar(max),convert(decimal(10,2),isnull(tb.PotenciaEsferica,0))) end) as PotenciaEsfericaTransposta, 
isnull(tb.Eixo,0) as Eixo, isnull(tb.Adicao,0) as Adicao from tbartigos left join tblojas l on l.id=''''[%%IDLoja%%]'''' left join tbstockartigos st on tbartigos.id=st.IDArtigo and l.id=st.IDLoja left join tbunidades u on tbartigos.idunidade=u.id  left join tbArtigosPrecos ap on tbartigos.id=ap.IDArtigo and ap.idcodigopreco=1 and (st.idloja=ap.IDLoja or (ap.idloja is null and not ap.idcodigopreco is null))  inner join tbSistemaClassificacoesTiposArtigos sta on tbartigos.IDSistemaClassificacao=sta.id  inner join tbLentesContato tb on tbartigos.id=tb.IDArtigo left join tbModelos mo on tb.IDModelo=mo.id left join tbmarcas m on tbartigos.idmarca=m.id'', null, 1)
END
')

EXEC('
BEGIN 
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Lentes de Contato - Transposta''
DELETE FROM [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE IDListaPersonalizada=@IDLista
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Codigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbArtigos'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDMarca'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 200)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDModelo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, ''tbFornecedores'', 1, 5, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Raio'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Diametro'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PotenciaEsfericaTransposta'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''PotenciaCilindricaTransposta'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Eixo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 0, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Adicao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''ValorComIva'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''QuantidadeStock'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 3, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Unidade'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 1, 1, 110)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDSistemaClassificacao'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, NULL, 0, 0, 110)
END')

-- tbSistemaComunicacaoSmsTemplatesFiltros
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbSistemaComunicacaoSmsTemplatesFiltros]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbSistemaComunicacaoSmsTemplatesFiltros](
	[ID] [bigint] NOT NULL,
	[Codigo] [nvarchar](10) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
    [Ordem] [bigint] NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesFiltros_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesFiltros_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesFiltros_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesFiltros_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesFiltros_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesFiltros_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaComunicacaoSmsTemplatesFiltros] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END')

-- tbSistemaComunicacaoSmsTemplatesCondicoes
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes](
    [ID] [bigint] NOT NULL,
    [Descricao] [nvarchar](100) NOT NULL,
    [IDSistemaComunicacaoSmsTemplatesFiltros] [bigint] NOT NULL,
    [Ordem] [bigint] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesCondicoes_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesCondicoes_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesCondicoes_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesCondicoes_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesCondicoes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesCondicoes_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaComunicacaoSmsTemplatesCondicoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes]  WITH CHECK ADD  CONSTRAINT [FK_tbSistemaComunicacaoSmsTemplatesCondicoes_tbSistemaComunicacaoSmsTemplatesFiltros] FOREIGN KEY([IDSistemaComunicacaoSmsTemplatesFiltros])
REFERENCES [dbo].[tbSistemaComunicacaoSmsTemplatesFiltros] ([ID])
ALTER TABLE [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] CHECK CONSTRAINT [FK_tbSistemaComunicacaoSmsTemplatesCondicoes_tbSistemaComunicacaoSmsTemplatesFiltros]
END')
​  
-- tbSistemaComunicacaoSmsTemplatesValores
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbSistemaComunicacaoSmsTemplatesValores]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbSistemaComunicacaoSmsTemplatesValores](
    [ID] [bigint] NOT NULL,
    [TipoComponente] [nvarchar](100) NOT NULL,
    [Ordem] [bigint] NULL,
    [MinValue] [nvarchar](20) NULL,
    [MaxValue] [nvarchar](20) NULL,
    [DefaultValue] [nvarchar](50) NULL,
    [SqlQuery] [nvarchar](max) NULL,
    [Placeholder] [nvarchar](20) NULL,
    [IDSistemaComunicacaoSmsTemplatesCondicoes] [bigint] NULL,
    [CssClasses] [nvarchar](50) NULL,
    [SqlQueryWhere] [nvarchar](max) NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesValores_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesValores_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesValores_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesValores_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesValores_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbSistemaComunicacaoSmsTemplatesValores_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSistemaComunicacaoSmsTemplatesValores] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbSistemaComunicacaoSmsTemplatesValores]  WITH CHECK ADD  CONSTRAINT [FK_tbSistemaComunicacaoSmsTemplatesValores_tbSistemaComunicacaoSmsTemplatesCondicoes] FOREIGN KEY([IDSistemaComunicacaoSmsTemplatesCondicoes])
REFERENCES [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID])
ALTER TABLE [dbo].[tbSistemaComunicacaoSmsTemplatesValores] CHECK CONSTRAINT [FK_tbSistemaComunicacaoSmsTemplatesValores_tbSistemaComunicacaoSmsTemplatesCondicoes]
END')
    
-- tbComunicacaoSmsTemplates
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbComunicacaoSmsTemplates]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbComunicacaoSmsTemplates](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [Nome] [nvarchar](50) NULL,
    [IDSistemaEnvio] [bigint] NOT NULL,
    [IDParametrizacaoConsentimentosPerguntas] [bigint] NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplates_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplates_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplates_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplates_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbComunicacaoSmsTemplates_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbComunicacaoSmsTemplates_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbComunicacaoSmsTemplates] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [IX_tbComunicacaoSmsTemplates_Nome] ON [tbComunicacaoSmsTemplates] (
	[Nome] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER TABLE [dbo].[tbComunicacaoSmsTemplates]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoSmsTemplates_tbComunicacao] FOREIGN KEY([IDSistemaEnvio])
REFERENCES [dbo].[tbComunicacao] ([ID])
ALTER TABLE [dbo].[tbComunicacaoSmsTemplates] CHECK CONSTRAINT [FK_tbComunicacaoSmsTemplates_tbComunicacao]

ALTER TABLE [dbo].[tbComunicacaoSmsTemplates]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoSmsTemplates_tbParametrizacaoConsentimentosPerguntas] FOREIGN KEY([IDParametrizacaoConsentimentosPerguntas])
REFERENCES [dbo].[tbParametrizacaoConsentimentosPerguntas] ([ID])
ALTER TABLE [dbo].[tbComunicacaoSmsTemplates] CHECK CONSTRAINT [FK_tbComunicacaoSmsTemplates_tbParametrizacaoConsentimentosPerguntas]
END')

-- tbComunicacaoSmsTemplatesGrupos
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbComunicacaoSmsTemplatesGrupos]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbComunicacaoSmsTemplatesGrupos](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [IDComunicacaoSmsTemplates] [bigint] NOT NULL,
    [Ordem] [bigint] NULL,
    [MainCondition] [nvarchar](20) NULL,
    [IDComunicacaoSmsTemplatesGrupos] [bigint] NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesGrupos_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesGrupos_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesGrupos_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesGrupos_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesGrupos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesGrupos_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbComunicacaoSmsTemplatesGrupos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesGrupos]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoSmsTemplatesGrupos_tbComunicacaoSmsTemplates] FOREIGN KEY([IDComunicacaoSmsTemplates])
REFERENCES [dbo].[tbComunicacaoSmsTemplates] ([ID])
ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesGrupos] CHECK CONSTRAINT [FK_tbComunicacaoSmsTemplatesGrupos_tbComunicacaoSmsTemplates]

ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesGrupos]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoSmsTemplatesGrupos_tbComunicacaoSmsTemplatesGrupos] FOREIGN KEY([IDComunicacaoSmsTemplatesGrupos])
REFERENCES [dbo].[tbComunicacaoSmsTemplatesGrupos] ([ID])
ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesGrupos] CHECK CONSTRAINT [FK_tbComunicacaoSmsTemplatesGrupos_tbComunicacaoSmsTemplatesGrupos]
END')

-- tbComunicacaoSmsTemplatesRegras
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbComunicacaoSmsTemplatesRegras]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbComunicacaoSmsTemplatesRegras](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [IDComunicacaoSmsTemplatesGrupos] [bigint] NOT NULL,
    [IDSistemaComunicacaoSmsTemplatesFiltros] [bigint] NOT NULL,
    [IDSistemaComunicacaoSmsTemplatesCondicoes] [bigint] NOT NULL,
    [Ordem] [bigint] NOT NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesRegras_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesRegras_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesRegras_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesRegras_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesRegras_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesRegras_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbComunicacaoSmsTemplatesRegras] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesRegras]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoSmsTemplatesRegras_tbComunicacaoSmsTemplatesGrupos] FOREIGN KEY([IDComunicacaoSmsTemplatesGrupos])
REFERENCES [dbo].[tbComunicacaoSmsTemplatesGrupos] ([ID])
ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesRegras] CHECK CONSTRAINT [FK_tbComunicacaoSmsTemplatesRegras_tbComunicacaoSmsTemplatesGrupos]

ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesRegras]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoSmsTemplatesRegras_tbSistemaComunicacaoSmsTemplatesCondicoes] FOREIGN KEY([IDSistemaComunicacaoSmsTemplatesCondicoes])
REFERENCES [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID])
ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesRegras] CHECK CONSTRAINT [FK_tbComunicacaoSmsTemplatesRegras_tbSistemaComunicacaoSmsTemplatesCondicoes]

ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesRegras]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoSmsTemplatesRegras_tbSistemaComunicacaoSmsTemplatesFiltros] FOREIGN KEY([IDSistemaComunicacaoSmsTemplatesFiltros])
REFERENCES [dbo].[tbSistemaComunicacaoSmsTemplatesFiltros] ([ID])
ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesRegras] CHECK CONSTRAINT [FK_tbComunicacaoSmsTemplatesRegras_tbSistemaComunicacaoSmsTemplatesFiltros]
END')​

-- tbComunicacaoSmsTemplatesValores
EXEC('IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbComunicacaoSmsTemplatesValores]'') AND type in (N''U''))
BEGIN
CREATE TABLE [dbo].[tbComunicacaoSmsTemplatesValores](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [IDComunicacaoSmsTemplatesRegras] [bigint] NOT NULL,
    [IDSistemaComunicacaoSmsTemplatesValores] [bigint] NOT NULL,
    [Ordem] [bigint] NOT NULL,
    [Valor] [nvarchar](max) NULL,
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesValores_Ativo]  DEFAULT ((1)),
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesValores_Sistema]  DEFAULT ((0)),
	[DataCriacao] [datetime] NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesValores_DataCriacao]  DEFAULT (getdate()),
	[UtilizadorCriacao] [nvarchar](256) NOT NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesValores_UtilizadorCriacao]  DEFAULT (''''),
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesValores_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL CONSTRAINT [DF_tbComunicacaoSmsTemplatesValores_UtilizadorAlteracao]  DEFAULT (''''),
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbComunicacaoSmsTemplatesValores] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesValores]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoSmsTemplatesValores_tbComunicacaoSmsTemplatesRegras] FOREIGN KEY([IDComunicacaoSmsTemplatesRegras])
REFERENCES [dbo].[tbComunicacaoSmsTemplatesRegras] ([ID])
ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesValores] CHECK CONSTRAINT [FK_tbComunicacaoSmsTemplatesValores_tbComunicacaoSmsTemplatesRegras]

ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesValores]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoSmsTemplatesValores_tbSistemaComunicacaoSmsTemplatesValores] FOREIGN KEY([IDSistemaComunicacaoSmsTemplatesValores])
REFERENCES [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID])
ALTER TABLE [dbo].[tbComunicacaoSmsTemplatesValores] CHECK CONSTRAINT [FK_tbComunicacaoSmsTemplatesValores_tbSistemaComunicacaoSmsTemplatesValores]
END')

-- novo campo IDComunicacaoSmsTemplates
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbComunicacaoregistro'' AND COLUMN_NAME = ''IDComunicacaoSmsTemplates'') 
Begin
alter table tbComunicacaoregistro add IDComunicacaoSmsTemplates bigint null
​ALTER TABLE [dbo].[tbComunicacaoregistro]  WITH CHECK ADD  CONSTRAINT [FK_tbComunicacaoregistro_tbComunicacaoSmsTemplates] FOREIGN KEY([IDComunicacaoSmsTemplates])
REFERENCES [dbo].[tbComunicacaoSmsTemplates] ([ID])
ALTER TABLE [dbo].[tbComunicacaoregistro] CHECK CONSTRAINT [FK_tbComunicacaoregistro_tbComunicacaoSmsTemplates]
End')

-- SmsTemplates valores por defeito
EXEC('IF NOT EXISTS (SELECT * FROM [tbSistemaComunicacaoSmsTemplatesFiltros] WHERE CODIGO=''GEN'')
BEGIN
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesFiltros] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem]) VALUES (1, N''GEN'', N''Género'', 1, 1, CAST(N''2020-04-17T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-17T14:18:36.397'' AS DateTime), NULL, 10)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesFiltros] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem]) VALUES (2, N''AGE'', N''Idade'', 1, 1, CAST(N''2020-04-17T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-17T14:39:53.160'' AS DateTime), NULL, 20)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesFiltros] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem]) VALUES (3, N''PRO'', N''Profissões'', 1, 1, CAST(N''2020-04-24T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-24T00:54:38.900'' AS DateTime), NULL, 30)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesFiltros] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem]) VALUES (4, N''NAS'', N''Data de Nascimento'', 1, 1, CAST(N''2020-04-24T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-24T00:56:47.507'' AS DateTime), NULL, 40)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesFiltros] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem]) VALUES (5, N''LOJ'', N''Loja'', 1, 1, CAST(N''2020-04-24T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-24T01:01:40.690'' AS DateTime), NULL, 50)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesFiltros] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem]) VALUES (6, N''ACT'', N''Ativo'', 1, 1, CAST(N''2020-05-06T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-05-06T11:36:11.073'' AS DateTime), NULL, 5)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID], [Descricao], [IDSistemaComunicacaoSmsTemplatesFiltros], [Ordem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (1, N''>='', 2, 20, 1, 1, CAST(N''2020-04-17T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-17T15:56:56.607'' AS DateTime), NULL)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID], [Descricao], [IDSistemaComunicacaoSmsTemplatesFiltros], [Ordem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N''='', 2, 10, 1, 1, CAST(N''2020-04-17T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-17T15:56:56.607'' AS DateTime), NULL)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID], [Descricao], [IDSistemaComunicacaoSmsTemplatesFiltros], [Ordem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (3, N''<='', 2, 30, 1, 1, CAST(N''2020-04-17T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-17T15:56:56.607'' AS DateTime), NULL)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID], [Descricao], [IDSistemaComunicacaoSmsTemplatesFiltros], [Ordem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (4, N''='', 1, 10, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-20T00:23:44.457'' AS DateTime), NULL)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID], [Descricao], [IDSistemaComunicacaoSmsTemplatesFiltros], [Ordem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (5, N''Entre'', 2, 40, 1, 1, CAST(N''2020-05-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-20T15:35:48.740'' AS DateTime), NULL)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID], [Descricao], [IDSistemaComunicacaoSmsTemplatesFiltros], [Ordem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (6, N''='', 3, 10, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-20T00:23:44.457'' AS DateTime), NULL)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID], [Descricao], [IDSistemaComunicacaoSmsTemplatesFiltros], [Ordem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (7, N''='', 4, 10, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-20T00:23:44.457'' AS DateTime), NULL)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID], [Descricao], [IDSistemaComunicacaoSmsTemplatesFiltros], [Ordem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (8, N''='', 5, 10, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-20T00:23:44.457'' AS DateTime), NULL)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID], [Descricao], [IDSistemaComunicacaoSmsTemplatesFiltros], [Ordem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (9, N''='', 6, 10, 1, 1, CAST(N''2020-05-06T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-05-06T11:38:30.853'' AS DateTime), NULL)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID], [Descricao], [IDSistemaComunicacaoSmsTemplatesFiltros], [Ordem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (10, N''>='', 4, 20, 1, 1, CAST(N''2020-05-07T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-05-07T10:51:44.543'' AS DateTime), NULL)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesCondicoes] ([ID], [Descricao], [IDSistemaComunicacaoSmsTemplatesFiltros], [Ordem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (11, N''<='', 4, 30, 1, 1, CAST(N''2020-05-07T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-05-07T10:51:44.543'' AS DateTime), NULL)
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (1, N''multiselect'', 1, NULL, NULL, NULL, N''select ID, Descricao from tbSistemaSexo where Ativo = 1 ORDER BY Descricao'', 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-20T16:16:53.910'' AS DateTime), NULL, NULL, 4, N''col-5'', N''tbClientes.IDSexo IN ({0})'')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (2, N''int'', 10, N''1'', N''99'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:15:47.090'' AS DateTime), NULL, NULL, 1, N''col-5'', N''CASE WHEN dateadd(year, datediff (year, tbClientes.DataNascimento, getdate()), tbClientes.DataNascimento) > getdate() THEN datediff(year, tbClientes.DataNascimento, getdate()) - 1 ELSE datediff(year, tbClientes.DataNascimento, getdate()) END >= {0}  '')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (3, N''int'', 10, N''1'', N''99'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:19:34.707'' AS DateTime), NULL, NULL, 2, N''col-5'', N''CASE WHEN dateadd(year, datediff (year, tbClientes.DataNascimento, getdate()), tbClientes.DataNascimento) > getdate() THEN datediff(year, tbClientes.DataNascimento, getdate()) - 1 ELSE datediff(year, tbClientes.DataNascimento, getdate()) END = {0}  '')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (4, N''int'', 10, N''1'', N''99'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:21:08.077'' AS DateTime), NULL, NULL, 3, N''col-5'', N''CASE WHEN dateadd(year, datediff (year, tbClientes.DataNascimento, getdate()), tbClientes.DataNascimento) > getdate() THEN datediff(year, tbClientes.DataNascimento, getdate()) - 1 ELSE datediff(year, tbClientes.DataNascimento, getdate()) END <= {0}  '')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (5, N''int'', 10, N''1'', N''99'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:21:08.077'' AS DateTime), NULL, N''De'', 5, N''col-5'', N''CASE WHEN dateadd(year, datediff (year, tbClientes.DataNascimento, getdate()), tbClientes.DataNascimento) > getdate() THEN datediff(year, tbClientes.DataNascimento, getdate()) - 1 ELSE datediff(year, tbClientes.DataNascimento, getdate()) END >= {0}  '')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (6, N''int'', 10, N''1'', N''99'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:21:08.077'' AS DateTime), NULL, N''Até'', 5, N''col-5'', N''CASE WHEN dateadd(year, datediff (year, tbClientes.DataNascimento, getdate()), tbClientes.DataNascimento) > getdate() THEN datediff(year, tbClientes.DataNascimento, getdate()) - 1 ELSE datediff(year, tbClientes.DataNascimento, getdate()) END <= {0}  '')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (7, N''multiselect'', 1, NULL, NULL, NULL, N''select ID, Descricao  from tbProfissoes WHERE Ativo = 1 ORDER BY Descricao'', 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-20T16:16:53.910'' AS DateTime), NULL, NULL, 6, N''col-5'', N''tbClientes.IDProfissao IN ({0})'')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (8, N''int'', 10, N''1'', N''31'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:21:08.077'' AS DateTime), NULL, N''Dia'', 7, N''col-5'', N''DAY(DATANASCIMENTO) = {0}'')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (9, N''int'', 20, N''1'', N''12'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:21:08.077'' AS DateTime), NULL, N''Mês'', 7, N''col-5'', N''MONTH(tbClientes.DATANASCIMENTO) = {0}'')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (10, N''int'', 30, N''1900'', N''2099'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:21:08.077'' AS DateTime), NULL, N''Ano'', 7, N''col-5'', N''YEAR(tbClientes.DATANASCIMENTO) = {0}'')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (11, N''multiselect'', 1, NULL, NULL, NULL, N''select ID, Descricao from tbLojas WHERE Ativo = 1 ORDER BY Descricao'', 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-20T16:16:53.910'' AS DateTime), NULL, NULL, 8, N''col-5'', N''tbClientes.IDLoja IN ({0})'')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (12, N''checkbox'', 1, NULL, NULL, NULL, NULL, 1, 1, CAST(N''2020-05-06T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-05-06T11:41:09.030'' AS DateTime), NULL, NULL, 9, NULL, N''tbClientes.Ativo = {0}'')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (13, N''int'', 10, N''1'', N''31'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:21:08.077'' AS DateTime), NULL, N''Dia'', 10, N''col-5'', N''DAY(DATANASCIMENTO) >= {0}'')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (14, N''int'', 20, N''1'', N''12'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:21:08.077'' AS DateTime), NULL, N''Mês'', 10, N''col-5'', N''MONTH(tbClientes.DATANASCIMENTO) >= {0}'')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (15, N''int'', 30, N''1900'', N''2099'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:21:08.077'' AS DateTime), NULL, N''Ano'', 10, N''col-5'', N''YEAR(tbClientes.DATANASCIMENTO) >= {0}'')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (16, N''int'', 10, N''1'', N''31'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:21:08.077'' AS DateTime), NULL, N''Dia'', 11, N''col-5'', N''DAY(DATANASCIMENTO) <= {0}'')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (17, N''int'', 20, N''1'', N''12'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:21:08.077'' AS DateTime), NULL, N''Mês'', 11, N''col-5'', N''MONTH(tbClientes.DATANASCIMENTO) <= {0}'')
INSERT [dbo].[tbSistemaComunicacaoSmsTemplatesValores] ([ID], [TipoComponente], [Ordem], [MinValue], [MaxValue], [DefaultValue], [SqlQuery], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Placeholder], [IDSistemaComunicacaoSmsTemplatesCondicoes], [CssClasses], [SqlQueryWhere]) VALUES (18, N''int'', 30, N''1900'', N''2099'', NULL, NULL, 1, 1, CAST(N''2020-04-20T00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2020-04-21T14:21:08.077'' AS DateTime), NULL, N''Ano'', 11, N''col-5'', N''YEAR(tbClientes.DATANASCIMENTO) <= {0}'')
END')

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
LEFT JOIN tbSistemaTiposDocumentoFiscal AS tbSistemaTiposDocumentoFiscal with (nolock) ON tbSistemaTiposDocumentoFiscal.ID=tbTiposDocumento.IDSistemaTiposDocumentoFiscal
INNER JOIN tbIVA AS tbIVA  with (nolock) ON tbDocumentosVendasLinhas.IDtaxaiva=tbIVA.ID
LEFT JOIN tbCampanhas with (nolock) ON tbDocumentosVendasLinhas.IDCampanha=tbCampanhas.ID
WHERE tbsistematiposestados.codigo<>''RSC'' and tbSistemaTiposDocumento.Tipo=''VndFinanceiro'' and tbSistemaTiposDocumentoFiscal.Tipo<>''NF''
GROUP BY tbDocumentosVendas.ID, tbDocumentosVendas.IDLoja, tbDocumentosVendas.NomeFiscal, tbDocumentosVendas.IDEntidade, tbDocumentosVendas.IDTipoDocumento, tbDocumentosVendas.IDTiposDocumentoSeries, tbDocumentosVendas.NumeroDocumento,
tbDocumentosVendas.DataDocumento, tbDocumentosVendas.Documento, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbDocumentosVendas.Ativo, tbDocumentosVendasLinhas.TaxaIva, tbDocumentosVendasLinhas.IDTaxaIva,
tbLojas.Codigo, tbLojas.Descricao, tbClientes.Codigo, tbClientes.Nome, tbClientes.NContribuinte, tbTiposDocumento.Codigo, tbDocumentosVendas.UtilizadorCriacao, 
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end), 
tbSistemaNaturezas.Codigo, tbCampanhas.Codigo, tbsistematiposestados.codigo,tbsistematiposestados.Descricao, tbTiposDocumento.Codigo, tbTiposDocumento.Descricao, tbDocumentosVendasLinhas.CodigoTipoIva, tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao
ORDER BY tbDocumentosVendas.ID  OFFSET 0 ROWS ')

--mapa de vendas
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
tbCampanhas.Codigo as CodigoCampanha, 
tbdocumentosVendas.DataDocumento,
tbdocumentosVendas.UtilizadorCriacao as Utilizador,
tbDocumentosVendas.IDMoeda, 
tbDocumentosVendas.TaxaConversao, 
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
Sum((case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Quantidade,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Valor,
Sum((isnull(tbdocumentosVendaslinhas.PrecoUnitarioMoedaRef,0)-isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivo,0))*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end))  as Desconto,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Liquido,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as TotalValor,
Sum(isnull(tbartigos.medio,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as TotalCustoMedio,
tbMoedas.CasasDecimaisTotais as Valornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Descontonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Liquidonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as TotalValornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as TotalCustoMedionumcasasdecimais
FROM tbdocumentosVendas AS tbdocumentosVendas with (nolock) 
LEFT JOIN tbdocumentosVendaslinhas AS tbdocumentosVendaslinhas with (nolock) ON tbdocumentosVendaslinhas.iddocumentoVenda=tbdocumentosVendas.ID
LEFT JOIN tbArtigos AS tbArtigos with (nolock) ON tbArtigos.id=tbdocumentosVendaslinhas.IDArtigo
LEFT JOIN tbArtigosFornecedores AS tbArtigosFornecedores with (nolock) ON tbArtigos.id=tbArtigosFornecedores.IDArtigo and tbArtigosFornecedores.Ordem=1
LEFT JOIN tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.id=tbArtigosFornecedores.IDFornecedor and tbArtigosFornecedores.Ordem=1
LEFT JOIN tbMarcas as tbMarcas with (nolock) ON tbMarcas.ID=tbArtigos.IDMarca
LEFT JOIN tbLojas as tbLojas with (nolock) ON tbLojas.ID=tbdocumentosVendas.IDLoja
LEFT JOIN tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbdocumentosVendas.IDEstado
LEFT JOIN tbCampanhas with (nolock) ON tbDocumentosVendasLinhas.IDCampanha=tbCampanhas.ID
LEFT JOIN tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
LEFT JOIN tbUnidades as tbUnidades with (nolock) ON tbUnidades.ID=tbArtigos.IDUnidade
LEFT JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbdocumentosVendas.IDTipoDocumento
LEFT JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbSistemaTiposDocumento.ID=tbTiposDocumento.IDSistemaTiposDocumento
LEFT JOIN tbSistemaTiposDocumentoFiscal AS tbSistemaTiposDocumentoFiscal with (nolock) ON tbSistemaTiposDocumentoFiscal.ID=tbTiposDocumento.IDSistemaTiposDocumentoFiscal
LEFT JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbSistemaNaturezas.ID=tbTiposDocumento.IDSistemaNaturezas
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbdocumentosVendas.IDTiposDocumentoSeries
LEFT JOIN tbArtigosLotes AS tbArtigosLotes with (nolock) ON tbArtigosLotes.ID = tbdocumentosVendaslinhas.IDLote
LEFT JOIN tbClientes AS tbClientes with (nolock) ON tbClientes.ID = tbdocumentosVendas.IDEntidade
LEFT JOIN tbtiposartigos AS tbtiposartigos with (nolock) ON tbtiposartigos.ID = tbArtigos.IDtipoartigo
LEFT JOIN tbParametrosEmpresa as P with (nolock) ON 1 = 1
LEFT JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=P.IDMoedaDefeito
where tbsistematiposestados.codigo=''EFT'' and tbsistematiposdocumento.tipo=''VndFinanceiro'' and tbSistemaTiposDocumentoFiscal.Tipo<>''NF''
group by tbArtigos.Codigo,tbArtigos.Descricao,tbArtigosLotes.Codigo ,tbArtigosLotes.Descricao ,tbTiposArtigos.Codigo ,tbTiposArtigos.Descricao ,tbLojas.Codigo ,tbLojas.Descricao ,
tbClientes.Codigo ,tbClientes.Nome ,tbMarcas.Codigo,tbMarcas.Descricao,tbFornecedores.Codigo ,tbFornecedores.Nome ,tbCampanhas.Codigo, tbdocumentosVendas.UtilizadorCriacao, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbdocumentosVendas.DataDocumento')

--mapa de margens vendas
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
Sum(isnull(tbartigos.medio,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as PrecoCusto,
Sum(isnull(tbartigos.medio,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as ValorCusto

,(Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) 
-Sum(isnull(tbartigos.medio,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end))) 
as ValorMargem

,cast((case when (Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)))=0 then 0 
else
(Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) 
-Sum(isnull(tbartigos.medio,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)))*100
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
LEFT JOIN tbSistemaTiposDocumentoFiscal AS tbSistemaTiposDocumentoFiscal with (nolock) ON tbSistemaTiposDocumentoFiscal.ID=tbTiposDocumento.IDSistemaTiposDocumentoFiscal
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
where tbsistematiposestados.codigo=''EFT'' and tbsistematiposdocumento.tipo=''VndFinanceiro'' and tbSistemaTiposDocumentoFiscal.Tipo<>''NF''
group by tbLojas.Codigo,tbLojas.Descricao,tbTiposArtigos.Codigo,tbTiposArtigos.Descricao, tbMarcas.Codigo,tbMarcas.Descricao,tbFornecedores.Codigo ,tbFornecedores.Nome,tbArtigos.Codigo,tbArtigos.Descricao, 
tbDocumentosVendas.DataDocumento, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbUnidades.NumeroDeCasasDecimais, tbComposicoes.Codigo,tbComposicoes.Descricao, 
(case when not tbaros.CodigoCor is null then tbaros.CodigoCor else tboculossol.CodigoCor end),(case when not tbaros.CorGenerica is null then tbaros.CorGenerica else tboculossol.CorGenerica end)
')

--aviso de versão 1.25
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.25.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.25.0'', ''A'', ''2020-05-11 00:00'', ''2020-05-18 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.25.0'', ''V'', ''2020-05-18 08:00'', ''2020-05-18 08:00'', ''Funcionalidades da versão'', ''
<li>Comunicação</li>
		&emsp;- envio de uma SMS para uma lista de clientes<br>
		&emsp;- criação de modelos de envio de SMS<br>
<li>Documentos de Venda Não Fiscais - para saldos iniciais ou acerto de conta corrente</li>
<li>Modelos de impressão - edição em Serviços e Documentos de venda</li>
<li>Cálculo de PVP com base no Custo Padrão e Margem definida</li>
<li>Seleção de artigos - pesquisa de Lentes por graduação transposta</li>
<li>Compras - Acerto de Preços de Custo de entrada de stock por valorização de Compras</li>
&emsp;<br>
'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')