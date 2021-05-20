/* ACT BD EMPRESA VERSAO 15*/
exec('ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD IDLinhaDimensaoDocumentoOrigem BIGINT NULL')
exec('ALTER TABLE tbDocumentosStockLinhasDimensoes ADD IDLinhaDimensaoDocumentoOrigem BIGINT NULL')
exec('ALTER TABLE tbCCStockArtigos ADD QtdStockReserva float null, QtdStockReserva2Uni float null')
exec('ALTER TABLE tbDocumentosStockLinhasDimensoes ADD [QuantidadeSatisfeita] [FLOAT] NULL, [QuantidadeDevolvida] [FLOAT] NULL, [Satisfeito] [BIT] NULL')
exec('ALTER TABLE tbDocumentosComprasLinhasDimensoes ADD [QuantidadeSatisfeita] [FLOAT] NULL, [QuantidadeDevolvida] [FLOAT] NULL, [Satisfeito] [BIT] NULL')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaQtdRequisitada]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0
AS  BEGIN
SET NOCOUNT ON
DECLARE	
	@ErrorMessage AS varchar(2000),
	@ErrorSeverity AS tinyint,
	@ErrorState AS tinyint
BEGIN TRY
		
	if @intAccao = 2
	BEGIN
				--******TRATAR ARTIGOS*****
				--retirar valores da tabela sem dimensões 
				UPDATE tbArtigosStock SET StockReqPendente = isnull(StockReqPendente,0) - isnull(artigosdoc.Req1,0) + isnull(artigosdoc.QtdAcerto,0), StockReqPendente2Uni = isnull(StockReqPendente2Uni,0) - isnull(artigosdoc.Req2,0) + isnull(artigosdoc.QtdAcerto2,0)
				FROM tbArtigosStock AS artStock
				INNER JOIN 
				(
					SELECT Linhas.IDArtigo,sum(isnull(Linhas.QuantidadeStock,0) - isnull(Linhas.QtdStockSatisfeita,0) + isnull(Linhas.QtdStockDevolvida,0)) AS Req1,
					sum(isnull(Linhas.QuantidadeStock2,0) - isnull(Linhas.QtdStock2Satisfeita,0) + isnull(Linhas.QtdStock2Devolvida,0)) AS Req2,
					SUm(isnull(Linhas.QtdStockAcerto,0)*-1) as QtdAcerto,
					SUm(isnull(Linhas.QtdStock2Acerto,0)*-1) as QtdAcerto2
					FROM tbDocumentosComprasLinhas AS Linhas 
					LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = Linhas.IDDocumentoCompra
					LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
					LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
					LEFT JOIN tbArtigos AS art ON art.id = Linhas.IDArtigo 
					LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
					WHERE NOT Linhas.IDArtigo IS NULL AND ISNULL(STD.Codigo,''0'') = ''0'' AND STDoc.Tipo = ''CmpEncomenda'' and isnull(art.GereStock,0) <> 0
					 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento
					GROUP BY Linhas.IDArtigo
				) AS artigosdoc ON artigosdoc.IDArtigo = artStock.IDArtigo

				--retirar valores da tabela com dimensões 
				UPDATE tbArtigosDimensoes SET QtdPendenteCompras = isnull(QtdPendenteCompras,0) - isnull(artigosdoc.Req1,0) + isnull(artigosdoc.QtdAcerto,0), 
														  QtdPendenteCompras2 = isnull(QtdPendenteCompras2,0) - isnull(artigosdoc.Req2,0) + isnull(artigosdoc.QtdAcerto2,0)
							FROM tbArtigosDimensoes AS artStock
							INNER JOIN 
							(
								SELECT Linhas.IDArtigo,
									   LinhasDist.IDArtigoDimensao,
									   sum(isnull(LinhasDist.QuantidadeStock,0) - isnull(LinhasDist.QtdStockSatisfeita,0) + isnull(LinhasDist.QtdStockDevolvida,0)) AS Req1,
									   sum(isnull(LinhasDist.QuantidadeStock2,0) - isnull(LinhasDist.QtdStock2Satisfeita,0) + isnull(LinhasDist.QtdStock2Devolvida,0)) AS Req2,
									   sum(isnull(LinhasDist.QtdStockAcerto,0)*-1) as QtdAcerto,
									   sum(isnull(LinhasDist.QtdStock2Acerto,0)*-1) as QtdAcerto2					
								FROM tbDocumentosComprasLinhasDimensoes AS LinhasDist
								LEFT JOIN tbDocumentosComprasLinhas AS Linhas ON Linhas.id = LinhasDist.IDDocumentoCompraLinha
								LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = Linhas.IDDocumentoCompra
								LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
								LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
								LEFT JOIN tbArtigos AS art ON art.id = Linhas.IDArtigo 
								LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
								WHERE NOT Linhas.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') <> ''0'' AND STDoc.Tipo = ''CmpEncomenda'' and isnull(art.GereStock,0) <> 0
								 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento
								GROUP BY Linhas.IDArtigo, 
										 LinhasDist.IDArtigoDimensao					
							) AS artigosdoc ON (artigosdoc.IDArtigo = artStock.IDArtigo and artigosdoc.IDArtigoDimensao = artStock.ID)
				--******FIM DE TRATAR ARTIGOS*****
		
				--******TRATAR StockArtigosNecessidades*****
				--retirar valores  sem dimensoes
				UPDATE tbStockArtigosNecessidades SET  QtdStockRequisitadoPnd = isnull(QtdStockRequisitadoPnd,0) - isnull(artigosdoc.Req1,0) + isnull(artigosdoc.QtdAcerto,0), QtdStockRequisitadoPnd2 = isnull(QtdStockRequisitadoPnd2,0) - isnull(artigosdoc.Req2,0) + isnull(artigosdoc.QtdAcerto2,0),
		 QtdStockRequisitado = isnull(QtdStockRequisitado,0) - isnull(artigosdoc.QtdReqstk,0),
																   QtdStockRequisitado2 = isnull(QtdStockRequisitado2,0) - isnull(artigosdoc.QtdReqstk2,0)
				FROM tbStockArtigosNecessidades AS artStock
				INNER JOIN 
				(
					SELECT   Linhas.IDTipoDocumentoOrigemInicial AS IDTipoDocumento,
								Linhas.IDDocumentoOrigemInicial AS IDDocumento,
								Linhas.IDLinhaDocumentoOrigemInicial AS IDLinhaDocumento,
								Linhas.IDDocumentoOrigemInicial AS IDOrdemFabrico,
								Linhas.IDArtigoPara AS IDArtigoPA,
								Linhas.IDArtigo,
								Doc.IDLoja,
								Linhas.IDArmazem,
								Linhas.IDArmazemLocalizacao,
								Linhas.IDLote AS IDArtigoLote,
								Linhas.IDArtigoNumSerie AS IDArtigoNumeroSerie,	
							sum(isnull(Linhas.QuantidadeStock,0) - isnull(Linhas.QtdStockSatisfeita,0) + isnull(Linhas.QtdStockDevolvida,0)) AS Req1,
							sum(isnull(Linhas.QuantidadeStock2,0) - isnull(Linhas.QtdStock2Satisfeita,0) + isnull(Linhas.QtdStock2Devolvida,0)) AS Req2,
							SUm(isnull(Linhas.QtdStockAcerto,0)*-1) as QtdAcerto,
							SUm(isnull(Linhas.QtdStock2Acerto,0)*-1) as QtdAcerto2,
		sum(isnull(Linhas.QuantidadeStock,0)) as QtdReqstk,
										sum(isnull(Linhas.QuantidadeStock2,0)) as QtdReqstk2
					FROM tbDocumentosComprasLinhas AS Linhas
					LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = Linhas.IDDocumentoCompra
					LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
					LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
					LEFT JOIN tbArtigos AS art ON art.id = Linhas.IDArtigo 
					LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
					LEFT JOIN tbStockArtigosNecessidades AS ArtStok ON (ArtStok.IDArtigo=Linhas.IDArtigo and
																	ArtStok.IDTipoDocumento = Linhas.IDTipoDocumentoOrigemInicial and 
																	ArtStok.IDDocumento = Linhas.IDDocumentoOrigemInicial and
																	isnull(ArtStok.IDLinhaDocumento,0) = isnull(Linhas.IDLinhaDocumentoOrigemInicial,0) and 
																	ArtStok.IDArtigoPA=Linhas.IDArtigoPara and
																	isnull(ArtStok.IDLoja,0) = isnull(Doc.IDLoja,0) and ArtStok.IDArmazem = Linhas.IDArmazem and
																	ArtStok.IDArmazemLocalizacao = Linhas.IDArmazemLocalizacao and 
																	isnull(ArtStok.IDArtigoLote,0) = isnull(Linhas.IDLote,0) and
																	isnull(ArtStok.IDArtigoNumeroSerie,0) = isnull(Linhas.IDArtigoNumSerie,0))
					LEFT JOIN tbTiposDocumento AS Tpinicial ON Tpinicial.id = Linhas.IDTipoDocumentoOrigemInicial
					WHERE NOT Linhas.IDArtigo IS NULL AND ISNULL(STD.Codigo,''0'') = ''0'' AND STDoc.Tipo = ''CmpEncomenda'' and isnull(art.GereStock,0) <> 0
						and  isnull(Tpinicial.ReservaStock,0) <> 0  and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento
					GROUP BY Linhas.IDTipoDocumentoOrigemInicial,
								Linhas.IDDocumentoOrigemInicial,
								Linhas.IDLinhaDocumentoOrigemInicial,
								Linhas.IDDocumentoOrigemInicial,
								Linhas.IDArtigoPara,
								Linhas.IDArtigo,
								Doc.IDLoja,
								Linhas.IDArmazem,
								Linhas.IDArmazemLocalizacao,
								Linhas.IDLote,
								Linhas.IDArtigoNumSerie
				) AS artigosdoc ON (artStock.IDArtigo=artigosdoc.IDArtigo and
									artStock.IDTipoDocumento = artigosdoc.IDTipoDocumento and 
									artStock.IDDocumento = artigosdoc.IDDocumento and
									isnull(artStock.IDLinhaDocumento,0) = isnull(artigosdoc.IDLinhaDocumento,0) and 
									artStock.IDArtigoPA=artigosdoc.IDArtigoPA and
									isnull(artStock.IDLoja,0) = isnull(artigosdoc.IDLoja,0) and 
									artStock.IDArmazem = artigosdoc.IDArmazem and
									artStock.IDArmazemLocalizacao = artigosdoc.IDArmazemLocalizacao and 
									isnull(artStock.IDArtigoLote,0) = isnull(artigosdoc.IDArtigoLote,0) and
									isnull(artStock.IDArtigoNumeroSerie,0) = isnull(artigosdoc.IDArtigoNumeroSerie,0))


			--retirar valores com dimensoes
			UPDATE tbStockArtigosNecessidades SET  QtdStockRequisitadoPnd = isnull(QtdStockRequisitadoPnd,0) - isnull(artigosdoc.Req1,0) + isnull(artigosdoc.QtdAcerto,0), 
																   QtdStockRequisitadoPnd2 = isnull(QtdStockRequisitadoPnd2,0) - isnull(artigosdoc.Req2,0) + isnull(artigosdoc.QtdAcerto2,0),
																   QtdStockRequisitado = isnull(QtdStockRequisitado,0) - isnull(artigosdoc.QtdReqstk,0),
																   QtdStockRequisitado2 = isnull(QtdStockRequisitado2,0) - isnull(artigosdoc.QtdReqstk2,0)
							FROM tbStockArtigosNecessidades AS artStock
							INNER JOIN 
							(
								SELECT   Linhas.IDTipoDocumentoOrigemInicial AS IDTipoDocumento,
											Linhas.IDDocumentoOrigemInicial AS IDDocumento,
											Linhas.IDLinhaDocumentoOrigemInicial AS IDLinhaDocumento,
											Linhas.IDDocumentoOrigemInicial AS IDOrdemFabrico,
											Linhas.IDArtigoPara AS IDArtigoPA,
											Linhas.IDArtigo,
											Doc.IDLoja,
											Linhas.IDArmazem,
											Linhas.IDArmazemLocalizacao,
											Linhas.IDLote AS IDArtigoLote,
											Linhas.IDArtigoNumSerie AS IDArtigoNumeroSerie,
											LinhasDist.IDArtigoDimensao,
											artdim.IDDimensaoLinha1,  
											artdim.IDDimensaoLinha2,	
										sum(isnull(LinhasDist.QuantidadeStock,0) - isnull(LinhasDist.QtdStockSatisfeita,0) + isnull(LinhasDist.QtdStockDevolvida,0)) AS Req1,
										sum(isnull(LinhasDist.QuantidadeStock2,0) - isnull(LinhasDist.QtdStock2Satisfeita,0) + isnull(LinhasDist.QtdStock2Devolvida,0)) AS Req2,
										SUm(isnull(LinhasDist.QtdStockAcerto,0)*-1) as QtdAcerto,
										SUm(isnull(LinhasDist.QtdStock2Acerto,0)*-1) as QtdAcerto2,
										sum(isnull(LinhasDist.QuantidadeStock,0)) as QtdReqstk,
										sum(isnull(LinhasDist.QuantidadeStock2,0)) as QtdReqstk2
								FROM tbDocumentosComprasLinhasDimensoes AS LinhasDist
								LEFT JOIN tbArtigosDimensoes as artdim ON artdim.id = LinhasDist.IDArtigoDimensao
								LEFT JOIN tbDocumentosComprasLinhas AS Linhas ON Linhas.id = LinhasDist.IDDocumentoCompraLinha
								LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = Linhas.IDDocumentoCompra
								LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
								LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
								LEFT JOIN tbArtigos AS art ON art.id = Linhas.IDArtigo 
								LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
								LEFT JOIN tbStockArtigosNecessidades AS ArtStok ON (ArtStok.IDArtigo=Linhas.IDArtigo and
																				ArtStok.IDTipoDocumento = Linhas.IDTipoDocumentoOrigemInicial and 
																				ArtStok.IDDocumento = Linhas.IDDocumentoOrigemInicial and
																				isnull(ArtStok.IDLinhaDocumento,0) = isnull(Linhas.IDLinhaDocumentoOrigemInicial,0) and 
																				ArtStok.IDArtigoPA=Linhas.IDArtigoPara and
																      			isnull(ArtStok.IDLoja,0) = isnull(Doc.IDLoja,0) and ArtStok.IDArmazem = Linhas.IDArmazem and
																				ArtStok.IDArmazemLocalizacao = Linhas.IDArmazemLocalizacao and 
																				isnull(ArtStok.IDArtigoLote,0) = isnull(Linhas.IDLote,0) and
																				isnull(ArtStok.IDArtigoNumeroSerie,0) = isnull(Linhas.IDArtigoNumSerie,0) and 
																				ArtStok.IDArtigoDimensao = LinhasDist.IDArtigoDimensao and
																				ArtStok.IDDimensaoLinha1 = artdim.IDDimensaoLinha1 and
																				isnull(ArtStok.IDDimensaoLinha2,0) = isnull(artdim.IDDimensaoLinha2,0))
								LEFT JOIN tbTiposDocumento AS Tpinicial ON Tpinicial.id = Linhas.IDTipoDocumentoOrigemInicial
								WHERE NOT Linhas.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') <> ''0'' AND STDoc.Tipo = ''CmpEncomenda'' and isnull(art.GereStock,0) <> 0
									and  isnull(Tpinicial.ReservaStock,0) <> 0 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento
								GROUP BY Linhas.IDTipoDocumentoOrigemInicial,
											Linhas.IDDocumentoOrigemInicial,
											Linhas.IDLinhaDocumentoOrigemInicial,
											Linhas.IDDocumentoOrigemInicial,
											Linhas.IDArtigoPara,
											Linhas.IDArtigo,
											Doc.IDLoja,
											Linhas.IDArmazem,
											Linhas.IDArmazemLocalizacao,
											Linhas.IDLote,
											Linhas.IDArtigoNumSerie,
											LinhasDist.IDArtigoDimensao,
											artdim.IDDimensaoLinha1,  
											artdim.IDDimensaoLinha2	
							) AS artigosdoc ON (artStock.IDArtigo=artigosdoc.IDArtigo and
												artStock.IDTipoDocumento = artigosdoc.IDTipoDocumento and 
												artStock.IDDocumento = artigosdoc.IDDocumento and
												isnull(artStock.IDLinhaDocumento,0) = isnull(artigosdoc.IDLinhaDocumento,0) and 
												artStock.IDArtigoPA=artigosdoc.IDArtigoPA and
												isnull(artStock.IDLoja,0) = isnull(artigosdoc.IDLoja,0) and 
												artStock.IDArmazem = artigosdoc.IDArmazem and
												artStock.IDArmazemLocalizacao = artigosdoc.IDArmazemLocalizacao and 
												isnull(artStock.IDArtigoLote,0) = isnull(artigosdoc.IDArtigoLote,0) and
												isnull(artStock.IDArtigoNumeroSerie,0) = isnull(artigosdoc.IDArtigoNumeroSerie,0) and
												artStock.IDArtigoDimensao = artigosdoc.IDArtigoDimensao and
												artStock.IDDimensaoLinha1 = artigosdoc.IDDimensaoLinha1 and
												isnull(artStock.IDDimensaoLinha2,0) = isnull(artigosdoc.IDDimensaoLinha2,0))


	--******FIM TRATAR StockArtigosNecessidades*****
	END
	
	
	if @intAccao = 0 
	BEGIN				
						--sem dimensões
				    	--******TRATAR ARTIGOS*****
						--inserir os registos que nao existem ainda na tabela tbArtigosStock
						INSERT INTO tbArtigosStock(IDArtigo, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao) 
						SELECT distinct CCART.IDArtigo,1 AS Ativo,1 AS Sistema, getdate() AS DataCriacao , CCART.UtilizadorCriacao as UtilizadorCriacao, getdate() AS DataAlteracao, CCART.UtilizadorCriacao AS UtilizadorAlteracao
						FROM tbDocumentosComprasLinhas AS CCART 
						LEFT JOIN tbArtigosStock AS ArtStok ON ArtStok.IDArtigo=CCART.IDArtigo
						LEFT JOIN tbArtigos AS art ON art.id = CCART.IDArtigo 
						LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = CCART.IDDocumentoCompra
						LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
						LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
						LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
						WHERE ArtStok.IDArtigo is NULL and isnull(art.GereStock,0) <> 0	and NOT CCART.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') = ''0'' AND STDoc.Tipo = ''CmpEncomenda''
							 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento

						--adicionar os valores novos
						UPDATE tbArtigosStock SET  StockReqPendente = isnull(StockReqPendente,0) + isnull(artigosdoc.Req1,0) + isnull(artigosdoc.QtdAcerto,0), StockReqPendente2Uni = isnull(StockReqPendente2Uni,0) + isnull(artigosdoc.Req2,0) + isnull(artigosdoc.QtdAcerto2,0)
						FROM tbArtigosStock AS artStock
						INNER JOIN 
						(
							SELECT Linhas.IDArtigo,sum(isnull(Linhas.QuantidadeStock,0) - isnull(Linhas.QtdStockSatisfeita,0) + isnull(Linhas.QtdStockDevolvida,0)) AS Req1,
							sum(isnull(Linhas.QuantidadeStock2,0) - isnull(Linhas.QtdStock2Satisfeita,0)) AS Req2,
							SUm(Case when isnull(Linhas.Satisfeito,0)<>0 then  (isnull(Linhas.QuantidadeStock,0) - isnull(Linhas.QtdStockSatisfeita,0) + isnull(Linhas.QtdStockDevolvida,0))*-1
							else 0 end) as QtdAcerto,
							SUm(Case when isnull(Linhas.Satisfeito,0)<>0 then (isnull(Linhas.QuantidadeStock2,0) - isnull(Linhas.QtdStock2Satisfeita,0) + isnull(Linhas.QtdStock2Devolvida,0))*-1
							else 0 end) as QtdAcerto2
							FROM tbDocumentosComprasLinhas AS Linhas
							LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = Linhas.IDDocumentoCompra
							LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
							LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
							LEFT JOIN tbArtigos AS art ON art.id = Linhas.IDArtigo 
							LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
							WHERE NOT Linhas.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') = ''0'' AND STDoc.Tipo = ''CmpEncomenda'' and isnull(art.GereStock,0) <> 0
							 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento
							GROUP BY Linhas.IDArtigo
						) AS artigosdoc ON artigosdoc.IDArtigo = artStock.IDArtigo	
						--******FIM DE TRATAR ARTIGOS*****

					    --******TRATAR StockArtigosNecessidades*****
						--inserir os registos que nao existem ainda na tabela tbStockArtigosNecessidades
						INSERT INTO tbStockArtigosNecessidades(IDTipoDocumento, IDDocumento, IDLinhaDocumento,IDOrdemFabrico,IDArtigoPA, IDArtigo,IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote,
						IDArtigoNumeroSerie,Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao) 
						SELECT distinct CCART.IDTipoDocumentoOrigemInicial AS IDTipoDocumento,
										CCART.IDDocumentoOrigemInicial AS IDDocumento,
										CCART.IDLinhaDocumentoOrigemInicial AS IDLinhaDocumento,
										CCART.IDDocumentoOrigemInicial AS IDOrdemFabrico,
										CCART.IDArtigoPara AS IDArtigoPA,
										CCART.IDArtigo,
										Doc.IDLoja,
										CCART.IDArmazem,
										CCART.IDArmazemLocalizacao,
										CCART.IDLote AS IDArtigoLote,
										CCART.IDArtigoNumSerie AS IDArtigoNumeroSerie,
										1 AS Ativo,
										1 AS Sistema, 
										getdate() AS DataCriacao , 
										CCART.UtilizadorCriacao as UtilizadorCriacao, 
										getdate() AS DataAlteracao, 
										CCART.UtilizadorCriacao AS UtilizadorAlteracao
									FROM tbDocumentosComprasLinhas AS CCART 
									LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = CCART.IDDocumentoCompra
									LEFT JOIN tbStockArtigosNecessidades AS ArtStok ON (ArtStok.IDArtigo=CCART.IDArtigo and
																						ArtStok.IDTipoDocumento = CCART.IDTipoDocumentoOrigemInicial and 
																						ArtStok.IDDocumento = CCART.IDDocumentoOrigemInicial and
																						isnull(ArtStok.IDLinhaDocumento,0) = isnull(CCART.IDLinhaDocumentoOrigemInicial,0) and 
																						ArtStok.IDArtigoPA=CCART.IDArtigoPara and
																						isnull(ArtStok.IDLoja,0) = isnull(Doc.IDLoja,0) and ArtStok.IDArmazem = CCART.IDArmazem and
																						ArtStok.IDArmazemLocalizacao = CCART.IDArmazemLocalizacao and 
																						isnull(ArtStok.IDArtigoLote,0) = isnull(CCART.IDLote,0) and
																						isnull(ArtStok.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumSerie,0))
									LEFT JOIN tbArtigos AS art ON art.id = CCART.IDArtigo 
									LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
									LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
									LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
									LEFT JOIN tbTiposDocumento AS Tpinicial ON Tpinicial.id = CCART.IDTipoDocumentoOrigemInicial
									WHERE ArtStok.IDArtigo is NULL and isnull(art.GereStock,0) <> 0	and NOT CCART.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') = ''0''
									AND STDoc.Tipo = ''CmpEncomenda'' and  isnull(Tpinicial.ReservaStock,0) <> 0 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento

						--adicionar os valores novos
						UPDATE tbStockArtigosNecessidades SET  QtdStockRequisitadoPnd = isnull(QtdStockRequisitadoPnd,0) + isnull(artigosdoc.Req1,0) + isnull(artigosdoc.QtdAcerto,0), 
															   QtdStockRequisitadoPnd2 = isnull(QtdStockRequisitadoPnd2,0) + isnull(artigosdoc.Req2,0) + isnull(artigosdoc.QtdAcerto2,0),
															   QtdStockRequisitado = isnull(QtdStockRequisitado,0) + isnull(artigosdoc.QtdReqstk,0),
															   QtdStockRequisitado2 = isnull(QtdStockRequisitado2,0) + isnull(artigosdoc.QtdReqstk2,0)
						FROM tbStockArtigosNecessidades AS artStock
						INNER JOIN 
						(
							SELECT   Linhas.IDTipoDocumentoOrigemInicial AS IDTipoDocumento,
										Linhas.IDDocumentoOrigemInicial AS IDDocumento,
										Linhas.IDLinhaDocumentoOrigemInicial AS IDLinhaDocumento,
										Linhas.IDDocumentoOrigemInicial AS IDOrdemFabrico,
										Linhas.IDArtigoPara AS IDArtigoPA,
										Linhas.IDArtigo,
										Doc.IDLoja,
										Linhas.IDArmazem,
										Linhas.IDArmazemLocalizacao,
										Linhas.IDLote AS IDArtigoLote,
										Linhas.IDArtigoNumSerie AS IDArtigoNumeroSerie,	
									sum(isnull(Linhas.QuantidadeStock,0) - isnull(Linhas.QtdStockSatisfeita,0) + isnull(Linhas.QtdStockDevolvida,0)) AS Req1,
									sum(isnull(Linhas.QuantidadeStock2,0) - isnull(Linhas.QtdStock2Satisfeita,0) + isnull(Linhas.QtdStock2Devolvida,0)) AS Req2,
									SUm(Case when isnull(Linhas.Satisfeito,0)<>0 then  (isnull(Linhas.QuantidadeStock,0) - isnull(Linhas.QtdStockSatisfeita,0) + isnull(Linhas.QtdStockDevolvida,0))*-1
									else 0 end) as QtdAcerto,
									SUm(Case when isnull(Linhas.Satisfeito,0)<>0 then (isnull(Linhas.QuantidadeStock2,0) - isnull(Linhas.QtdStock2Satisfeita,0) + isnull(Linhas.QtdStock2Devolvida,0))*-1
									else 0 end) as QtdAcerto2,
									sum(isnull(Linhas.QuantidadeStock,0)) as QtdReqstk,
									sum(isnull(Linhas.QuantidadeStock2,0)) as QtdReqstk2
							FROM tbDocumentosComprasLinhas AS Linhas
							LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = Linhas.IDDocumentoCompra
							LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
							LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
							LEFT JOIN tbArtigos AS art ON art.id = Linhas.IDArtigo 
							LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
							LEFT JOIN tbStockArtigosNecessidades AS ArtStok ON (ArtStok.IDArtigo=Linhas.IDArtigo and
																			ArtStok.IDTipoDocumento = Linhas.IDTipoDocumentoOrigemInicial and 
																			ArtStok.IDDocumento = Linhas.IDDocumentoOrigemInicial and
																			isnull(ArtStok.IDLinhaDocumento,0) = isnull(Linhas.IDLinhaDocumentoOrigemInicial,0) and 
																			ArtStok.IDArtigoPA=Linhas.IDArtigoPara and
																      		isnull(ArtStok.IDLoja,0) = isnull(Doc.IDLoja,0) and ArtStok.IDArmazem = Linhas.IDArmazem and
																			ArtStok.IDArmazemLocalizacao = Linhas.IDArmazemLocalizacao and 
																			isnull(ArtStok.IDArtigoLote,0) = isnull(Linhas.IDLote,0) and
																			isnull(ArtStok.IDArtigoNumeroSerie,0) = isnull(Linhas.IDArtigoNumSerie,0))
							LEFT JOIN tbTiposDocumento AS Tpinicial ON Tpinicial.id = Linhas.IDTipoDocumentoOrigemInicial
							WHERE NOT Linhas.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') = ''0'' AND STDoc.Tipo = ''CmpEncomenda'' and isnull(art.GereStock,0) <> 0
								and  isnull(Tpinicial.ReservaStock,0) <> 0 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento
							GROUP BY Linhas.IDTipoDocumentoOrigemInicial,
										Linhas.IDDocumentoOrigemInicial,
										Linhas.IDLinhaDocumentoOrigemInicial,
										Linhas.IDDocumentoOrigemInicial,
										Linhas.IDArtigoPara,
										Linhas.IDArtigo,
										Doc.IDLoja,
										Linhas.IDArmazem,
										Linhas.IDArmazemLocalizacao,
										Linhas.IDLote,
										Linhas.IDArtigoNumSerie
						) AS artigosdoc ON (artStock.IDArtigo=artigosdoc.IDArtigo and
											artStock.IDTipoDocumento = artigosdoc.IDTipoDocumento and 
											artStock.IDDocumento = artigosdoc.IDDocumento and
											isnull(artStock.IDLinhaDocumento,0) = isnull(artigosdoc.IDLinhaDocumento,0) and 
											artStock.IDArtigoPA=artigosdoc.IDArtigoPA and
											isnull(artStock.IDLoja,0) = isnull(artigosdoc.IDLoja,0) and 
											artStock.IDArmazem = artigosdoc.IDArmazem and
											artStock.IDArmazemLocalizacao = artigosdoc.IDArmazemLocalizacao and 
											isnull(artStock.IDArtigoLote,0) = isnull(artigosdoc.IDArtigoLote,0) and
											isnull(artStock.IDArtigoNumeroSerie,0) = isnull(artigosdoc.IDArtigoNumeroSerie,0))
						--******FIM TRATAR StockArtigosNecessidades*****

						--atualizar qtdacerto na tabela das tbDocumentosComprasLinhas
						UPDATE tbDocumentosComprasLinhas SET  QtdStockAcerto = Case when isnull(Linhas.Satisfeito,0)<>0 then  (isnull(Linhas.QuantidadeStock,0) - isnull(Linhas.QtdStockSatisfeita,0) + isnull(Linhas.QtdStockDevolvida,0))*-1
						else 0 end, 
						QtdStock2Acerto = Case when isnull(Linhas.Satisfeito,0)<>0 then (isnull(Linhas.QuantidadeStock2,0) - isnull(Linhas.QtdStock2Satisfeita,0) + isnull(Linhas.QtdStock2Devolvida,0))*-1
						else 0 end
						FROM tbDocumentosComprasLinhas as Linhas
						LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = Linhas.IDDocumentoCompra
						LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
						LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
						LEFT JOIN tbArtigos AS art ON art.id = Linhas.IDArtigo 
						LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
						WHERE NOT Linhas.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') = ''0'' AND STDoc.Tipo = ''CmpEncomenda'' and isnull(art.GereStock,0) <> 0 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento
						--fim de sem dimensões

						--com dimensões
							--******TRATAR ARTIGOS*****
					--neste caso das dimensões não é preciso verificar, pois já existe sempre as dimensoes
					--adicionar os valores novos
					UPDATE tbArtigosDimensoes SET QtdPendenteCompras = isnull(QtdPendenteCompras,0) + isnull(artigosdoc.Req1,0) + isnull(artigosdoc.QtdAcerto,0), 
												  QtdPendenteCompras2 = isnull(QtdPendenteCompras2,0) + isnull(artigosdoc.Req2,0) + isnull(artigosdoc.QtdAcerto2,0)
					FROM tbArtigosDimensoes AS artStock
					INNER JOIN 
					(
						SELECT Linhas.IDArtigo,
							   LinhasDist.IDArtigoDimensao,
							   sum(isnull(LinhasDist.QuantidadeStock,0) - isnull(LinhasDist.QtdStockSatisfeita,0) + isnull(LinhasDist.QtdStockDevolvida,0)) AS Req1,
							   sum(isnull(LinhasDist.QuantidadeStock2,0) - isnull(LinhasDist.QtdStock2Satisfeita,0) +  isnull(LinhasDist.QtdStock2Devolvida,0)) AS Req2,
							   SUm(Case when isnull(LinhasDist.Satisfeito,0)<>0 then  (isnull(LinhasDist.QuantidadeStock,0) - isnull(LinhasDist.QtdStockSatisfeita,0) + isnull(LinhasDist.QtdStockDevolvida,0))*-1
							   else 0 end) as QtdAcerto,
							   SUm(Case when isnull(LinhasDist.Satisfeito,0)<>0 then (isnull(LinhasDist.QuantidadeStock2,0) - isnull(LinhasDist.QtdStock2Satisfeita,0) + isnull(LinhasDist.QtdStock2Devolvida,0))*-1
							   else 0 end) as QtdAcerto2				
						FROM tbDocumentosComprasLinhasDimensoes AS LinhasDist
						LEFT JOIN tbDocumentosComprasLinhas AS Linhas ON Linhas.id = LinhasDist.IDDocumentoCompraLinha
						LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = Linhas.IDDocumentoCompra
						LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
						LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
						LEFT JOIN tbArtigos AS art ON art.id = Linhas.IDArtigo 
						LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
						WHERE NOT Linhas.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') <> ''0'' AND STDoc.Tipo = ''CmpEncomenda'' and isnull(art.GereStock,0) <> 0
					 	 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento
						GROUP BY Linhas.IDArtigo, 
								 LinhasDist.IDArtigoDimensao					
					) AS artigosdoc ON (artigosdoc.IDArtigo = artStock.IDArtigo and artigosdoc.IDArtigoDimensao = artStock.ID)
					--******FIM DE TRATAR ARTIGOS*****

					--******TRATAR StockArtigosNecessidades*****
					--inserir os registos que nao existem ainda na tabela tbStockArtigosNecessidades
					INSERT INTO tbStockArtigosNecessidades(IDTipoDocumento, IDDocumento, IDLinhaDocumento,IDOrdemFabrico,IDArtigoPA, IDArtigo,IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote,
					IDArtigoNumeroSerie, IDArtigoDimensao, IDDimensaoLinha1, IDDimensaoLinha2, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao) 
					SELECT distinct Linhas.IDTipoDocumentoOrigemInicial AS IDTipoDocumento,
									Linhas.IDDocumentoOrigemInicial AS IDDocumento,
									Linhas.IDLinhaDocumentoOrigemInicial AS IDLinhaDocumento,
									Linhas.IDDocumentoOrigemInicial AS IDOrdemFabrico,
									Linhas.IDArtigoPara AS IDArtigoPA,
									Linhas.IDArtigo,
									Doc.IDLoja,
									Linhas.IDArmazem,
									Linhas.IDArmazemLocalizacao,
									Linhas.IDLote AS IDArtigoLote,
									Linhas.IDArtigoNumSerie AS IDArtigoNumeroSerie,
									CCART.IDArtigoDimensao,
									artdim.IDDimensaoLinha1,  
									artdim.IDDimensaoLinha2,	
									1 AS Ativo,
									1 AS Sistema, 
									getdate() AS DataCriacao , 
									Linhas.UtilizadorCriacao as UtilizadorCriacao, 
									getdate() AS DataAlteracao, 
									Linhas.UtilizadorCriacao AS UtilizadorAlteracao
								FROM tbDocumentosComprasLinhasDimensoes AS CCART 
								LEFT JOIN tbArtigosDimensoes as artdim ON artdim.id = CCART.IDArtigoDimensao
								LEFT JOIN tbDocumentosComprasLinhas AS Linhas ON Linhas.id = CCART.IDDocumentoCompraLinha
								LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = Linhas.IDDocumentoCompra
								LEFT JOIN tbStockArtigosNecessidades AS ArtStok ON (ArtStok.IDArtigo=Linhas.IDArtigo and
																					ArtStok.IDTipoDocumento = Linhas.IDTipoDocumentoOrigemInicial and 
																					ArtStok.IDDocumento = Linhas.IDDocumentoOrigemInicial and
																					isnull(ArtStok.IDLinhaDocumento,0) = isnull(Linhas.IDLinhaDocumentoOrigemInicial,0) and 
																					ArtStok.IDArtigoPA=Linhas.IDArtigoPara and
																					isnull(ArtStok.IDLoja,0) = isnull(Doc.IDLoja,0) and ArtStok.IDArmazem = Linhas.IDArmazem and
																					ArtStok.IDArmazemLocalizacao = Linhas.IDArmazemLocalizacao and 
																					isnull(ArtStok.IDArtigoLote,0) = isnull(Linhas.IDLote,0) and
																					isnull(ArtStok.IDArtigoNumeroSerie,0) = isnull(Linhas.IDArtigoNumSerie,0) and
																					ArtStok.IDArtigoDimensao = CCART.IDArtigoDimensao and
																					ArtStok.IDDimensaoLinha1 = artdim.IDDimensaoLinha1 and
																					isnull(ArtStok.IDDimensaoLinha2,0) = isnull(artdim.IDDimensaoLinha2,0))
								LEFT JOIN tbArtigos AS art ON art.id = Linhas.IDArtigo 
								LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
								LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
								LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
								LEFT JOIN tbTiposDocumento AS Tpinicial ON Tpinicial.id = Linhas.IDTipoDocumentoOrigemInicial
								WHERE ArtStok.IDArtigo is NULL and isnull(art.GereStock,0) <> 0	and NOT Linhas.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') <> ''0''
								AND STDoc.Tipo = ''CmpEncomenda'' and  isnull(Tpinicial.ReservaStock,0) <> 0 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento
								
					--adicionar os valores novos
					UPDATE tbStockArtigosNecessidades SET  QtdStockRequisitadoPnd = isnull(QtdStockRequisitadoPnd,0) + isnull(artigosdoc.Req1,0) + isnull(artigosdoc.QtdAcerto,0), 
														   QtdStockRequisitadoPnd2 = isnull(QtdStockRequisitadoPnd2,0) + isnull(artigosdoc.Req2,0) + isnull(artigosdoc.QtdAcerto2,0),
														   QtdStockRequisitado = isnull(QtdStockRequisitado,0) + isnull(artigosdoc.QtdReqstk,0),
														   QtdStockRequisitado2 = isnull(QtdStockRequisitado2,0) + isnull(artigosdoc.QtdReqstk2,0)
					FROM tbStockArtigosNecessidades AS artStock
					INNER JOIN 
					(
						SELECT   Linhas.IDTipoDocumentoOrigemInicial AS IDTipoDocumento,
									Linhas.IDDocumentoOrigemInicial AS IDDocumento,
									Linhas.IDLinhaDocumentoOrigemInicial AS IDLinhaDocumento,
									Linhas.IDDocumentoOrigemInicial AS IDOrdemFabrico,
									Linhas.IDArtigoPara AS IDArtigoPA,
									Linhas.IDArtigo,
									Doc.IDLoja,
									Linhas.IDArmazem,
									Linhas.IDArmazemLocalizacao,
									Linhas.IDLote AS IDArtigoLote,
									Linhas.IDArtigoNumSerie AS IDArtigoNumeroSerie,
								    LinhasDist.IDArtigoDimensao,
									artdim.IDDimensaoLinha1,  
									artdim.IDDimensaoLinha2,	
								sum(isnull(LinhasDist.QuantidadeStock,0) - isnull(LinhasDist.QtdStockSatisfeita,0) + isnull(LinhasDist.QtdStockDevolvida,0)) AS Req1,
								sum(isnull(LinhasDist.QuantidadeStock2,0) - isnull(LinhasDist.QtdStock2Satisfeita,0) + isnull(LinhasDist.QtdStock2Devolvida,0)) AS Req2,
								SUm(Case when isnull(LinhasDist.Satisfeito,0)<>0 then  (isnull(LinhasDist.QuantidadeStock,0) - isnull(LinhasDist.QtdStockSatisfeita,0) + isnull(LinhasDist.QtdStockDevolvida,0))*-1
									else 0 end) as QtdAcerto,
								SUm(Case when isnull(LinhasDist.Satisfeito,0)<>0 then (isnull(LinhasDist.QuantidadeStock2,0) - isnull(LinhasDist.QtdStock2Satisfeita,0) + isnull(LinhasDist.QtdStock2Devolvida,0))*-1
									else 0 end) as QtdAcerto2,
								sum(isnull(LinhasDist.QuantidadeStock,0)) as QtdReqstk,
								sum(isnull(LinhasDist.QuantidadeStock2,0)) as QtdReqstk2
						FROM tbDocumentosComprasLinhasDimensoes AS LinhasDist
						LEFT JOIN tbArtigosDimensoes as artdim ON artdim.id = LinhasDist.IDArtigoDimensao
						LEFT JOIN tbDocumentosComprasLinhas AS Linhas ON Linhas.id = LinhasDist.IDDocumentoCompraLinha
						LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = Linhas.IDDocumentoCompra
						LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
						LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
						LEFT JOIN tbArtigos AS art ON art.id = Linhas.IDArtigo 
						LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
						LEFT JOIN tbStockArtigosNecessidades AS ArtStok ON (ArtStok.IDArtigo=Linhas.IDArtigo and
																		ArtStok.IDTipoDocumento = Linhas.IDTipoDocumentoOrigemInicial and 
																		ArtStok.IDDocumento = Linhas.IDDocumentoOrigemInicial and
																		isnull(ArtStok.IDLinhaDocumento,0) = isnull(Linhas.IDLinhaDocumentoOrigemInicial,0) and 
																		ArtStok.IDArtigoPA=Linhas.IDArtigoPara and
																      	isnull(ArtStok.IDLoja,0) = isnull(Doc.IDLoja,0) and ArtStok.IDArmazem = Linhas.IDArmazem and
																		ArtStok.IDArmazemLocalizacao = Linhas.IDArmazemLocalizacao and 
																		isnull(ArtStok.IDArtigoLote,0) = isnull(Linhas.IDLote,0) and
																		isnull(ArtStok.IDArtigoNumeroSerie,0) = isnull(Linhas.IDArtigoNumSerie,0) and 
																		ArtStok.IDArtigoDimensao = LinhasDist.IDArtigoDimensao and
																		ArtStok.IDDimensaoLinha1 = artdim.IDDimensaoLinha1 and
																		isnull(ArtStok.IDDimensaoLinha2,0) = isnull(artdim.IDDimensaoLinha2,0))
						LEFT JOIN tbTiposDocumento AS Tpinicial ON Tpinicial.id = Linhas.IDTipoDocumentoOrigemInicial
						WHERE NOT Linhas.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') <> ''0'' AND STDoc.Tipo = ''CmpEncomenda'' and isnull(art.GereStock,0) <> 0
							and  isnull(Tpinicial.ReservaStock,0) <> 0 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento
						GROUP BY Linhas.IDTipoDocumentoOrigemInicial,
									Linhas.IDDocumentoOrigemInicial,
									Linhas.IDLinhaDocumentoOrigemInicial,
									Linhas.IDDocumentoOrigemInicial,
									Linhas.IDArtigoPara,
									Linhas.IDArtigo,
									Doc.IDLoja,
									Linhas.IDArmazem,
									Linhas.IDArmazemLocalizacao,
									Linhas.IDLote,
									Linhas.IDArtigoNumSerie,
									LinhasDist.IDArtigoDimensao,
									artdim.IDDimensaoLinha1,  
									artdim.IDDimensaoLinha2	
					) AS artigosdoc ON (artStock.IDArtigo=artigosdoc.IDArtigo and
										artStock.IDTipoDocumento = artigosdoc.IDTipoDocumento and 
										artStock.IDDocumento = artigosdoc.IDDocumento and
										isnull(artStock.IDLinhaDocumento,0) = isnull(artigosdoc.IDLinhaDocumento,0) and 
										artStock.IDArtigoPA=artigosdoc.IDArtigoPA and
										isnull(artStock.IDLoja,0) = isnull(artigosdoc.IDLoja,0) and 
										artStock.IDArmazem = artigosdoc.IDArmazem and
										artStock.IDArmazemLocalizacao = artigosdoc.IDArmazemLocalizacao and 
										isnull(artStock.IDArtigoLote,0) = isnull(artigosdoc.IDArtigoLote,0) and
										isnull(artStock.IDArtigoNumeroSerie,0) = isnull(artigosdoc.IDArtigoNumeroSerie,0) and
										artStock.IDArtigoDimensao = artigosdoc.IDArtigoDimensao and
										artStock.IDDimensaoLinha1 = artigosdoc.IDDimensaoLinha1 and
										isnull(artStock.IDDimensaoLinha2,0) = isnull(artigosdoc.IDDimensaoLinha2,0))
					--******FIM TRATAR StockArtigosNecessidades*****


					--atualizar qtdacerto na tabela das tbDocumentosComprasLinhasDimensoes
					UPDATE tbDocumentosComprasLinhasDimensoes SET  QtdStockAcerto = Case when isnull(LinhasDist.Satisfeito,0)<>0 then  (isnull(LinhasDist.QuantidadeStock,0) - isnull(LinhasDist.QtdStockSatisfeita,0) + isnull(LinhasDist.QtdStockDevolvida,0))*-1
					else 0 end, 
					QtdStock2Acerto = Case when isnull(LinhasDist.Satisfeito,0)<>0 then (isnull(LinhasDist.QuantidadeStock2,0) - isnull(LinhasDist.QtdStock2Satisfeita,0) + isnull(LinhasDist.QtdStock2Devolvida,0))*-1
					else 0 end
					FROM tbDocumentosComprasLinhasDimensoes as LinhasDist
					LEFT JOIN tbDocumentosComprasLinhas AS Linhas ON Linhas.id = LinhasDist.IDDocumentoCompraLinha
					LEFT JOIN tbDocumentosCompras AS Doc ON Doc.ID = Linhas.IDDocumentoCompra
					LEFT JOIN tbTiposDocumento AS TpDpc ON TpDpc.id = Doc.IDTipoDocumento
					LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TpDpc.IDSistemaTiposDocumento
					LEFT JOIN tbArtigos AS art ON art.id = Linhas.IDArtigo 
					LEFT JOIN tbSistemaTiposDimensoes AS STD ON STD.ID = art.IDTipoDimensao
					WHERE NOT Linhas.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') <> ''0'' AND STDoc.Tipo = ''CmpEncomenda'' and isnull(art.GereStock,0) <> 0 	
					 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento				
				    --fim com dimensões

	END

END TRY
BEGIN CATCH
	SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
	RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')


EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaStockNecessidades]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0,
	@strUtilizador AS nvarchar(256) = ''''
AS  BEGIN
SET NOCOUNT ON
DECLARE	
	@ErrorMessage AS varchar(2000),
	@ErrorSeverity AS tinyint,
	@ErrorState AS tinyint,
	@strWhereQuantidades AS nvarchar(1500) = NULL,
	@strTipoDoc AS nvarchar(50) = NULL,
	@bitGereStock AS bit = 0,
	@strSqlQuery AS varchar(max),--variavel para query''s dinamicos
	@strQueryWhere AS nvarchar(1024) = '''',
	@strQueryCampos AS nvarchar(1024) = ''''
BEGIN TRY

	--Carrega propriedades do tipo de documento
	SELECT @strTipoDoc = STDoc.Tipo,  @bitGereStock = ISNULL(TD.GereStock,0)  
	FROM tbTiposDocumento AS TD
	LEFT JOIN tbSistemaTiposDocumento AS STDoc ON STDoc.id = TD.IDSistemaTiposDocumento
	WHERE TD.ID=@lngidTipoDocumento AND (STDoc.Tipo = ''StkReserva'' OR STDoc.Tipo = ''StkLibertarReserva'' OR STDoc.Tipo = ''ProdCusto'' OR STDoc.Tipo = ''ProdCustoEstorno'')
	
    IF @bitGereStock<>0 
		BEGIN
			IF (@intAccao = 2) 
				BEGIN
					--retira valores da tabela
					UPDATE tbStockArtigosNecessidades SET QtdStockReservado = Case @strTipoDoc when ''StkReserva'' then isnull(tbNec.QtdStockReservado,0) - isnull(CCART.qtdstockreserva,0) when ''StkLibertarReserva'' then isnull(tbNec.QtdStockReservado,0) + isnull(CCART.qtdstockreserva,0) when ''ProdCusto'' then isnull(tbNec.QtdStockReservado,0) + isnull(CCART.qtdstockreserva,0) when ''ProdCustoEstorno'' then isnull(tbNec.QtdStockReservado,0) - isnull(CCART.qtdstockreserva,0) else tbNec.QtdStockReservado end,
															QtdStockReservado2 = Case @strTipoDoc when ''StkReserva'' then isnull(tbNec.QtdStockReservado2,0) - isnull(CCART.qtdstockreserva2,0) when ''StkLibertarReserva'' then isnull(tbNec.QtdStockReservado2,0) + isnull(CCART.qtdstockreserva2,0) when ''ProdCusto'' then isnull(tbNec.QtdStockReservado2,0) + isnull(CCART.qtdstockreserva2,0) when ''ProdCustoEstorno'' then isnull(tbNec.QtdStockReservado2,0) - isnull(CCART.qtdstockreserva2,0) else tbNec.QtdStockReservado2 end,
															QtdStockConsumido = Case @strTipoDoc when ''ProdCusto'' then isnull(tbNec.QtdStockConsumido,0) - isnull(CCART.qtdstock,0) when ''ProdCustoEstorno'' then isnull(tbNec.QtdStockConsumido,0) + isnull(CCART.qtdstock,0) else tbNec.QtdStockConsumido end,
															QtdStockConsumido2 = Case @strTipoDoc when ''ProdCusto'' then isnull(tbNec.QtdStockConsumido2,0) - isnull(CCART.qtdstock2,0) when ''ProdCustoEstorno'' then isnull(tbNec.QtdStockConsumido2,0) + isnull(CCART.qtdstock2,0) else tbNec.QtdStockConsumido2 end
					FROM tbStockArtigosNecessidades as tbNec
					INNER JOIN (
									SELECT cc.IDTipoDocumentoOrigemInicial,
										cc.IDDocumentoOrigemInicial,
										cc.IDLinhaDocumentoOrigemInicial, 
										cc.IDArtigoPA, 
										cc.IDArtigoPara, 
										cc.IDArtigo, 
										cc.IDLoja, 
										cc.IDArmazem, 
										cc.IDArmazemLocalizacao, 
										cc.IDArtigoLote, 
										cc.IDArtigoNumeroSerie, 
										cc.IDArtigoDimensao,
										SUM(isnull(cc.QuantidadeStock,0)) as qtdstock,
										SUM(isnull(cc.QuantidadeStock2,0)) as qtdstock2,
										SUM(isnull(cc.QtdStockReserva,0)) as qtdstockreserva,
										SUM(isnull(cc.QtdStockReserva2Uni,0)) as qtdstockreserva2
									FROM tbCCStockArtigos as cc
									WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento and isnull(IDTipoDocumentoOrigemInicial,0) <> 0
									GROUP BY
										cc.IDTipoDocumentoOrigemInicial,
										cc.IDDocumentoOrigemInicial,
										cc.IDLinhaDocumentoOrigemInicial, 
										cc.IDArtigoPA, 
										cc.IDArtigoPara, 
										cc.IDArtigo, 
										cc.IDLoja, 
										cc.IDArmazem, 
										cc.IDArmazemLocalizacao, 
										cc.IDArtigoLote, 
										cc.IDArtigoNumeroSerie, 
										cc.IDArtigoDimensao
								) AS CCART
									ON (
										tbNec.IDTipoDocumento = CCART.IDTipoDocumentoOrigemInicial AND 
										tbNec.IDDocumento = CCART.IDDocumentoOrigemInicial AND 
										tbNec.IDLinhaDocumento = CCART.IDLinhaDocumentoOrigemInicial AND 
										tbNec.IDArtigoPA = CCART.IDArtigoPA AND 
										tbNec.IDArtigoPara = CCART.IDArtigoPara AND 
										tbNec.IDArtigo = CCART.IDArtigo AND 
										isnull(tbNec.IDLoja,0) = isnull(CCART.IDLoja,0) AND
										isnull(tbNec.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
										isnull(tbNec.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND 
										isnull(tbNec.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)	AND  
										isnull(tbNec.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND 
										isnull(tbNec.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0)
									)	
				END

			else
				BEGIN
				   --inserir a zero os registos que ainda não existem 
					INSERT INTO tbStockArtigosNecessidades(IDTipoDocumento,IDDocumento,IDLinhaDocumento,IDOrdemFabrico, Documento, IDArtigoPA, IDArtigoPara, IDArtigo, IDLoja,
					IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, IDDimensaolinha1, IDDimensaolinha2, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao) 
					SELECT CCART.IDTipoDocumentoOrigemInicial AS IDTipoDocumento, CCART.IDDocumentoOrigemInicial as IDDocumento, CCART.IDLinhaDocumentoOrigemInicial as IDLinhaDocumento,
					CCART.IDDocumentoOrigemInicial as IDOrdemFabrico,CCART.Documento as Documento, CCART.IDArtigoPA,CCART.IDArtigoPara,
					CCART.IDArtigo, CCART.IDLoja, CCART.IDArmazem, CCART.IDArmazemLocalizacao, CCART.IDArtigoLote, CCART.IDArtigoNumeroSerie, CCART.IDArtigoDimensao,
					CCART.IDDimensaolinha1, CCART.IDDimensaolinha2, CCART.Ativo,CCART.Sistema, CCART.DataCriacao, CCART.UtilizadorCriacao, CCART.DataAlteracao,CCART.UtilizadorAlteracao
					FROM (
							SELECT Distinct cc.IDTipoDocumentoOrigemInicial,cc.IDDocumentoOrigemInicial,cc.IDLinhaDocumentoOrigemInicial, cc.DocumentoOrigemInicial as Documento,
							cc.IDArtigoPA, cc.IDArtigoPara, cc.IDArtigo, cc.IDLoja, cc.IDArmazem, cc.IDArmazemLocalizacao, cc.IDArtigoLote, cc.IDArtigoNumeroSerie, cc.IDArtigoDimensao, Dim.IDDimensaoLinha1 as IDDimensaolinha1, Dim.IDDimensaoLinha2 as IDDimensaolinha2,
							1 as Ativo,1 as Sistema, getdate() AS DataCriacao , @strUtilizador as UtilizadorCriacao, getdate() as DataAlteracao, @strUtilizador as UtilizadorAlteracao
							FROM tbCCStockArtigos as cc
							LEFT JOIN tbArtigosDimensoes AS Dim ON Dim.id = cc.IDArtigoDimensao
							WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento and isnull(IDTipoDocumentoOrigemInicial,0) <> 0
					) AS CCART
					LEFT JOIN tbStockArtigosNecessidades AS stkNecAntigos
					ON (
						stkNecAntigos.IDTipoDocumento = CCART.IDTipoDocumentoOrigemInicial AND 
						stkNecAntigos.IDDocumento = CCART.IDDocumentoOrigemInicial AND 
						stkNecAntigos.IDLinhaDocumento = CCART.IDLinhaDocumentoOrigemInicial AND 
						stkNecAntigos.IDArtigoPA = CCART.IDArtigoPA AND 
						stkNecAntigos.IDArtigoPara = CCART.IDArtigoPara AND 
						stkNecAntigos.IDArtigo = CCART.IDArtigo AND 
						isnull(stkNecAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND
						isnull(stkNecAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
						isnull(stkNecAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND 
						isnull(stkNecAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)	AND  
						isnull(stkNecAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND 
						isnull(stkNecAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0)
						)
						WHERE stkNecAntigos.IDArtigoPara is NULL and stkNecAntigos.IDArtigoPA is NULL and stkNecAntigos.IDLinhaDocumento is NULL and stkNecAntigos.IDDocumento is NULL and stkNecAntigos.IDTipoDocumento is NULL and stkNecAntigos.IDArtigo is NULL and stkNecAntigos.IDArmazem is NULL AND
						stkNecAntigos.IDArmazemLocalizacao is NULL and stkNecAntigos.IDArtigoLote is NULL and
						stkNecAntigos.IDArtigoNumeroSerie is NULL and stkNecAntigos.IDArtigoDimensao is NULL and stkNecAntigos.IDLoja is NULL
						
					--atualizar valores
					UPDATE tbStockArtigosNecessidades SET QtdStockReservado = Case @strTipoDoc when ''StkReserva'' then isnull(tbNec.QtdStockReservado,0) + isnull(CCART.qtdstockreserva,0) when ''StkLibertarReserva'' then isnull(tbNec.QtdStockReservado,0) - isnull(CCART.qtdstockreserva,0) when ''ProdCusto'' then isnull(tbNec.QtdStockReservado,0) - isnull(CCART.qtdstockreserva,0) when ''ProdCustoEstorno'' then isnull(tbNec.QtdStockReservado,0) + isnull(CCART.qtdstockreserva,0) else tbNec.QtdStockReservado end,
															QtdStockReservado2 = Case @strTipoDoc when ''StkReserva'' then isnull(tbNec.QtdStockReservado2,0) + isnull(CCART.qtdstockreserva2,0) when ''StkLibertarReserva'' then isnull(tbNec.QtdStockReservado2,0) - isnull(CCART.qtdstockreserva2,0) when ''ProdCusto'' then isnull(tbNec.QtdStockReservado2,0) - isnull(CCART.qtdstockreserva2,0) when ''ProdCustoEstorno'' then isnull(tbNec.QtdStockReservado2,0) + isnull(CCART.qtdstockreserva2,0) else tbNec.QtdStockReservado2 end,
															QtdStockConsumido = Case @strTipoDoc when ''ProdCusto'' then isnull(tbNec.QtdStockConsumido,0) + isnull(CCART.qtdstock,0) when ''ProdCustoEstorno'' then isnull(tbNec.QtdStockConsumido,0) - isnull(CCART.qtdstock,0) else tbNec.QtdStockConsumido end,
															QtdStockConsumido2 = Case @strTipoDoc when ''ProdCusto'' then isnull(tbNec.QtdStockConsumido2,0) + isnull(CCART.qtdstock2,0) when ''ProdCustoEstorno'' then isnull(tbNec.QtdStockConsumido2,0) - isnull(CCART.qtdstock2,0) else tbNec.QtdStockConsumido2 end
					FROM tbStockArtigosNecessidades as tbNec
					INNER JOIN (
									SELECT cc.IDTipoDocumentoOrigemInicial,
										cc.IDDocumentoOrigemInicial,
										cc.IDLinhaDocumentoOrigemInicial, 
										cc.IDArtigoPA, 
										cc.IDArtigoPara, 
										cc.IDArtigo, 
										cc.IDLoja, 
										cc.IDArmazem, 
										cc.IDArmazemLocalizacao, 
										cc.IDArtigoLote, 
										cc.IDArtigoNumeroSerie, 
										cc.IDArtigoDimensao,
										SUM(isnull(cc.QuantidadeStock,0)) as qtdstock,
										SUM(isnull(cc.QuantidadeStock2,0)) as qtdstock2,
										SUM(isnull(cc.QtdStockReserva,0)) as qtdstockreserva,
										SUM(isnull(cc.QtdStockReserva2Uni,0)) as qtdstockreserva2
									FROM tbCCStockArtigos as cc
									WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento and isnull(IDTipoDocumentoOrigemInicial,0) <> 0
									GROUP BY
										cc.IDTipoDocumentoOrigemInicial,
										cc.IDDocumentoOrigemInicial,
										cc.IDLinhaDocumentoOrigemInicial, 
										cc.IDArtigoPA, 
										cc.IDArtigoPara, 
										cc.IDArtigo, 
										cc.IDLoja, 
										cc.IDArmazem, 
										cc.IDArmazemLocalizacao, 
										cc.IDArtigoLote, 
										cc.IDArtigoNumeroSerie, 
										cc.IDArtigoDimensao
								) AS CCART
									ON (
										tbNec.IDTipoDocumento = CCART.IDTipoDocumentoOrigemInicial AND 
										tbNec.IDDocumento = CCART.IDDocumentoOrigemInicial AND 
										tbNec.IDLinhaDocumento = CCART.IDLinhaDocumentoOrigemInicial AND 
										tbNec.IDArtigoPA = CCART.IDArtigoPA AND 
										tbNec.IDArtigoPara = CCART.IDArtigoPara AND 
										tbNec.IDArtigo = CCART.IDArtigo AND 
										isnull(tbNec.IDLoja,0) = isnull(CCART.IDLoja,0) AND
										isnull(tbNec.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
										isnull(tbNec.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND 
										isnull(tbNec.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)	AND  
										isnull(tbNec.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND 
										isnull(tbNec.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0)
									)
					
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

EXEC('DROP PROCEDURE [dbo].[sp_AtualizaStock]')

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
								--depois aqui nos campos --StockReserva, StockReserva2Uni será o valor da linha, mas como ainda não colocaste fica 0
									SET @strQueryQuantidades = ''ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.Quantidade,0) ELSE ISNULL(LinhasDist.Quantidade,0) END) AS Quantidade, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QuantidadeStock,0) ELSE ISNULL(LinhasDist.QuantidadeStock,0) END) as QuantidadeStock, 
													    ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QuantidadeStock2,0) ELSE ISNULL(LinhasDist.QuantidadeStock2,0) END) as QuantidadeStock2, 0 AS QtdStockReserva, 0 AS QtdStockReserva2Uni, 
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
										SET @strQueryQuantidades = ''ABS(ISNULL(Linhas.Quantidade,0)) AS Quantidade, ABS(ISNULL(Linhas.QuantidadeStock,0)) AS QuantidadeStock, ABS(ISNULL(Linhas.QuantidadeStock2,0)) AS QuantidadeStock2,  0 AS QtdStockReserva, 0 AS QtdStockReserva2Uni, 
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
									SUM(Case Natureza WHEN ''R'' Then isnull(QtdStockReserva,0) ELSE isnull(QtdStockReserva,0)*-1 END) as QtdStockReservado,
									SUM(Case Natureza WHEN ''R'' Then isnull(QtdStockReserva2Uni,0) ELSE isnull(QtdStockReserva2Uni,0)*-1 END) as QtdStock2Reservado
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
								SUM(Case Natureza WHEN ''R'' Then isnull(QtdStockReserva,0) ELSE isnull(QtdStockReserva,0)*-1 END) as QtdStockReservado,
								SUM(Case Natureza WHEN ''R'' Then isnull(QtdStockReserva2Uni,0) ELSE isnull(QtdStockReserva2Uni,0)*-1 END) as QtdStock2Reservado
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
							SUM(Case Natureza WHEN ''R'' Then isnull(QtdStockReserva,0) ELSE isnull(QtdStockReserva,0)*-1 END) as QtdStockReservado,
							SUM(Case Natureza WHEN ''R'' Then isnull(QtdStockReserva2Uni,0) ELSE isnull(QtdStockReserva2Uni,0)*-1 END) as QtdStock2Reservado
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
		END
END TRY
BEGIN CATCH
	SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
	RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')