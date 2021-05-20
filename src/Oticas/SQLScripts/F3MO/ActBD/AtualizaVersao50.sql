/* ACT BD EMPRESA VERSAO 50*/
exec('update tbartigos set inventariado=1 where inventariado is null')
--atualização do sp_atualizastock
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
END TRY
BEGIN CATCH
	SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
	RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')

--mapa de compras
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
tbdocumentoscompras.DataDocumento, 
tbdocumentoscompras.UtilizadorCriacao as Utilizador, 
tbdocumentoscompras.IDMoeda, 
tbdocumentoscompras.TaxaConversao, 
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
Sum((case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as Quantidade,
Sum(isnull(tbdocumentoscompraslinhas.PrecoUnitarioMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as Valor,
Sum((isnull(tbdocumentoscompraslinhas.PrecoUnitarioMoedaRef,0)-isnull(tbdocumentoscompraslinhas.PrecoUnitarioEfetivo,0))*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end))  as Desconto,
Sum(isnull(tbdocumentoscompraslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as Liquido,
Sum(isnull(tbdocumentoscompraslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as TotalValor,
Sum(isnull(c.PCMAtualMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''P'' then tbdocumentoscompraslinhas.Quantidade else -(tbdocumentoscompraslinhas.Quantidade) end)) as TotalCustoMedio,
tbMoedas.CasasDecimaisTotais as Valornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Descontonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Liquidonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as TotalValornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as TotalCustoMedionumcasasdecimais
FROM tbdocumentoscompras AS tbdocumentoscompras with (nolock) 
LEFT JOIN tbdocumentoscompraslinhas AS tbdocumentoscompraslinhas with (nolock) ON tbdocumentoscompraslinhas.iddocumentocompra=tbdocumentoscompras.ID
LEFT JOIN tbArtigos AS tbArtigos with (nolock) ON tbArtigos.id=tbdocumentoscompraslinhas.IDArtigo
LEFT JOIN (select idartigo, PCMAtualMoedaRef from (select idartigo, PCMAtualMoedaRef, ROW_NUMBER() over(partition by idartigo order by id desc) as rowID from tbdocumentoscompraslinhas) a where rowid=1) c on c.idartigo=tbdocumentoscompraslinhas.IDArtigo
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
LEFT JOIN tbParametrosEmpresa as P with (nolock) ON 1 = 1
LEFT JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=P.IDMoedaDefeito
where 
tbsistematiposestados.codigo=''EFT'' and tbsistematiposdocumento.tipo=''CmpFinanceiro''
group by 
tbArtigos.Codigo,tbArtigos.Descricao,tbArtigosLotes.Codigo ,tbArtigosLotes.Descricao ,tbTiposArtigos.Codigo ,tbTiposArtigos.Descricao ,tbLojas.Codigo ,tbLojas.Descricao ,tbFornecedores.Codigo ,tbFornecedores.Nome ,tbMarcas.Codigo,tbMarcas.Descricao,
tbdocumentoscompras.IDMoeda, tbdocumentoscompras.TaxaConversao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbdocumentoscompras.DataDocumento, tbdocumentoscompras.UtilizadorCriacao')


Exec('delete from [tbMapasVistas] where entidade=''DocumentosCompras'' and (nomemapa=''Cabecalho Empresa Compras'' or nomemapa=''Motivos Isencao Compras'' or nomemapa=''Dimensoes Compras'' or nomemapa=''Dimensoes Compras Nao Valorizado'')')

--Subreport cabeçalho
EXEC('
DECLARE @intOrdem as int;
DECLARE @ptrval xml;  
DECLARE @intModulo as bigint;
DECLARE @intSistemaTipoDoc as bigint;
DECLARE @intSistemaTipoDocFiscal as bigint;
SELECT @intOrdem = Max(isnull(Ordem,0)) + 1 FROM tbMapasVistas
SELECT @intModulo = IDModulo, @intSistemaTipoDoc = IDSistemaTipoDoc, @intSistemaTipoDocFiscal = IDSistemaTipoDocFiscal  FROM tbMapasVistas WHERE Entidade = ''DocumentosCompras'' and NomeMapa=''rptDocumentosCompras''
SET @ptrval = N''<?xml version="1.0" ?>
<XtraReportsLayoutSerializer SerializerVersion="18.2.7.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="Cabecalho Empresa Compras" Margins="3, 65, 5, 7" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="18.2" FilterString="[ID] = ?IDEmpresa" DataMember="tbParametrosEmpresa" DataSource="#Ref-0">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Visible="false" Description="Culture" Name="Culture" />
    <Item2 Ref="5" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item3 Ref="7" Description="IDEmpresa" ValueInfo="1" Name="IDEmpresa" Type="#Ref-6" />
    <Item4 Ref="8" Description="UrlServerPath" AllowNull="true" Name="UrlServerPath" />
  </Parameters>
  <Bands>
    <Item1 Ref="9" ControlType="TopMarginBand" Name="TopMargin" HeightF="5" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="10" ControlType="ReportHeaderBand" Name="ReportHeaderBand1" HeightF="102">
      <Controls>
        <Item1 Ref="11" ControlType="XRLabel" Name="fldCodigoPostal" SizeF="210.13,14" LocationFloat="137.4, 40" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="12" Expression="[CodigoPostal]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="13" UseFont="false" UseBorderWidth="false" />
        </Item1>
        <Item2 Ref="14" ControlType="XRLabel" Name="XrLabel38" Text="Contribuinte Nº:" TextAlignment="TopLeft" SizeF="69.18381,20" LocationFloat="137.4, 54" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
          <StylePriority Ref="15" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="16" ControlType="XRLabel" Name="fldNIF" Text="fldNIF" TextAlignment="TopLeft" SizeF="140.9462,20.00001" LocationFloat="206.5838, 54" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="17" Expression="[NIF]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="18" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="19" ControlType="XRLabel" Name="fldMorada" Text="fldMorada" TextAlignment="TopLeft" SizeF="210.23,20" LocationFloat="137.3, 20" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="20" Expression="[Morada]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="21" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="22" ControlType="XRLabel" Name="fldDesignacaoComercial" TextAlignment="TopLeft" SizeF="210.13,20" LocationFloat="137.4, 0" Font="Arial, 9pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="23" Expression="[DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="24" UseFont="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="25" ControlType="XRPictureBox" Name="picLogotipo" Sizing="Squeeze" ImageAlignment="TopLeft" SizeF="121.4168,94.46" LocationFloat="0, 0">
          <ExpressionBindings>
            <Item1 Ref="26" Expression="?UrlServerPath + [FotoCaminho] + [Foto]" PropertyName="ImageUrl" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item6>
      </Controls>
    </Item2>
    <Item3 Ref="27" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100">
      <SubBands>
        <Item1 Ref="28" ControlType="SubBand" Name="SubBand1" />
      </SubBands>
    </Item3>
    <Item4 Ref="29" ControlType="PageFooterBand" Name="PageFooterBand1" HeightF="0.8749962" />
    <Item5 Ref="30" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="7" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <StyleSheet>
    <Item1 Ref="31" Name="Title" BorderStyle="Inset" Font="Times New Roman, 20pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item2 Ref="32" Name="FieldCaption" BorderStyle="Inset" Font="Arial, 10pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item3 Ref="33" Name="PageInfo" BorderStyle="Inset" Font="Times New Roman, 10pt, style=Bold" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item4 Ref="34" Name="DataField" BorderStyle="Inset" Padding="2,2,0,0,100" Font="Times New Roman, 10pt" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
  </StyleSheet>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="6" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMDE1XEYzTTIwMTc7VXNlciBJRD1GM01TR1A7UGFzc3dvcmQ9O0luaXRpYWwgQ2F0YWxvZyA9OTk5OUYzTVNHUFFBVFNUTUFOOyIgLz48UXVlcnkgVHlwZT0iU2VsZWN0UXVlcnkiIE5hbWU9InRiUGFyYW1ldHJvc0VtcHJlc2EiPjxQYXJhbWV0ZXIgTmFtZT0iSURFbXByZXNhIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5JbnQ2NCwgbXNjb3JsaWIsIFZlcnNpb249NC4wLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5KShbUGFyYW1ldGVycy5JREVtcHJlc2FdKTwvUGFyYW1ldGVyPjxUYWJsZXM+PFRhYmxlIE5hbWU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIFg9IjMwIiBZPSIzMCIgV2lkdGg9IjEyNSIgSGVpZ2h0PSI2MjgiIC8+PFRhYmxlIE5hbWU9InRiU2lzdGVtYVNpZ2xhc1BhaXNlcyIgWD0iMTg1IiBZPSIzMCIgV2lkdGg9IjEyNSIgSGVpZ2h0PSIyODYiIC8+PFRhYmxlIE5hbWU9InRiTW9lZGFzIiBYPSIzNDAiIFk9IjMwIiBXaWR0aD0iMTI1IiBIZWlnaHQ9IjQwMCIgLz48UmVsYXRpb24gVHlwZT0iSW5uZXIiIFBhcmVudD0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmVzdGVkPSJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiPjxLZXlDb2x1bW4gUGFyZW50PSJJRFBhaXMiIE5lc3RlZD0iSUQiIC8+PC9SZWxhdGlvbj48UmVsYXRpb24gVHlwZT0iSW5uZXIiIFBhcmVudD0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmVzdGVkPSJ0Yk1vZWRhcyI+PEtleUNvbHVtbiBQYXJlbnQ9IklETW9lZGFEZWZlaXRvIiBOZXN0ZWQ9IklEIiAvPjwvUmVsYXRpb24+PC9UYWJsZXM+PENvbHVtbnM+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSUQiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURNb2VkYURlZmVpdG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iTW9yYWRhIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkZvdG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRm90b0NhbWluaG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDb2RpZ29Qb3N0YWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iTG9jYWxpZGFkZSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDb25jZWxobyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJEaXN0cml0byIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJJREVtcHJlc2EiIC8+PENvbHVtbiBUYWJsZT0idGJTaXN0ZW1hU2lnbGFzUGFpc2VzIiBOYW1lPSJTaWdsYSIgLz48Q29sdW1uIFRhYmxlPSJ0Yk1vZWRhcyIgTmFtZT0iRGVzY3JpY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiTW9lZGFzIiBOYW1lPSJUYXhhQ29udmVyc2FvIiAvPjxDb2x1bW4gVGFibGU9InRiTW9lZGFzIiBOYW1lPSJTaW1ib2xvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklEUGFpcyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJUZWxlZm9uZSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJGYXgiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRW1haWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iTklGIiAvPjwvQ29sdW1ucz48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQ+PFZpZXcgTmFtZT0idGJQYXJhbWV0cm9zRW1wcmVzYSI+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURNb2VkYURlZmVpdG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvQ2FtaW5obyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNpZ25hY2FvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJMb2NhbGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERW1wcmVzYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlNpZ2xhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUYXhhQ29udmVyc2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlNpbWJvbG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGVsZWZvbmUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRmF4IiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkVtYWlsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik5JRiIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''
--Mapa cabeçalho empresa compras
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito],[SubReport]) VALUES (@intOrdem, N''DocumentosCompras'', N''Cabecalho Empresa Compras'', N''Cabecalho Empresa Compras'', N'''', 1, @ptrval, NULL, N'''', 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''', @intModulo, @intSistemaTipoDoc, @intSistemaTipoDocFiscal, 0,1)
')

--Subreport motivos Isenção compras 
EXEC('
DECLARE @intOrdem as int;
DECLARE @ptrval xml;  
DECLARE @intModulo as bigint;
DECLARE @intSistemaTipoDoc as bigint;
DECLARE @intSistemaTipoDocFiscal as bigint;
SELECT @intOrdem = Max(isnull(Ordem,0)) + 1 FROM tbMapasVistas
SELECT @intModulo = IDModulo, @intSistemaTipoDoc = IDSistemaTipoDoc, @intSistemaTipoDocFiscal = IDSistemaTipoDocFiscal  FROM tbMapasVistas WHERE Entidade = ''DocumentosCompras'' and NomeMapa=''rptDocumentosCompras''
SET @ptrval = N''<?xml version="1.0" ?>
<XtraReportsLayoutSerializer SerializerVersion="18.2.7.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="Motivos Isencao Compras" ScriptsSource="Imports DevExpress.DataAccess.Native.Sql&#xD;&#xA;Imports System.ComponentModel&#xD;&#xA;Imports System.Linq&#xD;&#xA;Imports Reporting&#xD;&#xA;&#xD;&#xA;Private Sub Documentos_Compras_Motivos_Isencao_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim rs As ResultSet = TryCast(TryCast(sender.DataSource, IListSource).GetList(), ResultSet)&#xD;&#xA;    Dim rsDV As ResultTable = rs.Tables.FirstOrDefault(Function(x) x.TableName.Equals(&quot;tbDocumentosComprasMotivosIsencao&quot;))&#xD;&#xA;    Dim coluna As ResultColumn&#xD;&#xA;    Dim SimboloMoeda As String = String.Empty&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    &#xD;&#xA;    lblTaxa.Text = resource.GetResource(&quot;Taxa&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    lblMotivosIsencao.Text = resource.GetResource(&quot;MotivosIsencao&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    &#xD;&#xA;    If Not rsDV Is Nothing andalso rsDV.Count &gt; 0 Then&#xD;&#xA;        coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbMoedas_Simbolo&quot;))&#xD;&#xA;        SimboloMoeda = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(0), ResultRow)))&#xD;&#xA;        lblValorIncidencia.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Incidencia&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblValorIva.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Iva&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    end if&#xD;&#xA;End Sub&#xD;&#xA;" Margins="14, 100, 0, 1" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="18.2" FilterString="[IDDocumentoCompra] = ?IDDocumento" DataMember="tbDocumentosComprasMotivosIsencao" DataSource="#Ref-0">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="41" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="6" Visible="false" Description="Culture" Name="Culture" />
    <Item3 Ref="7" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="8" Name="SomaTotalIncidencia" Expression="[].Sum([TotalIncidencia])" DataMember="tbDocumentosCompras" />
    <Item2 Ref="9" Name="SomaTotalIVA" Expression="[].Sum([TotalIVA])" DataMember="tbDocumentosCompras" />
    <Item3 Ref="10" Name="TotalIncidencia" DisplayName="TotalIncidencia" Expression="[ValorIncidencia] " DataMember="tbDocumentosComprasMotivosIsencao" />
    <Item4 Ref="11" Name="calculatedField1" DisplayName="SomaTotalIncidencia" Expression="[].sum( [ValorIncidencia] )" DataMember="tbDocumentosComprasMotivosIsencao" />
    <Item5 Ref="12" Name="calculatedField2" DisplayName="SomaTotalIVA" Expression="[].sum([TotalIVA])" DataMember="tbDocumentosComprasMotivosIsencao" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="13" ControlType="TopMarginBand" Name="TopMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="14" ControlType="PageHeaderBand" Name="PageHeader" HeightF="17.70833">
      <Controls>
        <Item1 Ref="15" ControlType="XRLabel" Name="lblMotivosIsencao" Text="Motivos de Isenção" TextAlignment="MiddleLeft" SizeF="204.3453,12" LocationFloat="0, 0" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="16" Expression="not IsNullOrEmpty( [Codigo] )" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="17" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="18" ControlType="XRLabel" Name="lblValorIncidencia" Text="Incidência" TextAlignment="MiddleRight" SizeF="78.65823,12" LocationFloat="253.4704, 0" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="19" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="20" ControlType="XRLabel" Name="lblValorIva" Text="Iva" TextAlignment="MiddleRight" SizeF="53.4,12" LocationFloat="332.1286, 0" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="21" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="22" ControlType="XRLabel" Name="lblTaxa" Text="Taxa" TextAlignment="MiddleRight" SizeF="49.12497,12" LocationFloat="204.3454, 0" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="23" UseFont="false" UseTextAlignment="false" />
        </Item4>
      </Controls>
    </Item2>
    <Item3 Ref="24" ControlType="DetailBand" Name="Detail" KeepTogetherWithDetailReports="true" HeightF="0" KeepTogether="true" TextAlignment="TopLeft" Padding="0,0,0,0,100">
      <SubBands>
        <Item1 Ref="25" ControlType="SubBand" Name="SubBand1" HeightF="16.66667">
          <Controls>
            <Item1 Ref="26" ControlType="XRLabel" Name="fldTipoIVA" Text="XrLabel5" TextAlignment="BottomRight" SizeF="41.95493,14.99998" LocationFloat="460.5642, 1.589457E-05" Font="Arial, 6.75pt" Padding="2,2,0,0,100" Visible="false">
              <ExpressionBindings>
                <Item1 Ref="27" Expression="[CodigoTiposIVA]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="28" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="29" ControlType="XRLabel" Name="fldValorIva" Text="fldValorIva" TextAlignment="BottomRight" SizeF="53.38,14.99999" LocationFloat="332.1284, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="30" Expression="FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [TotalIVA])&#xA;" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="31" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="32" ControlType="XRLabel" Name="fldValorIncidencia" Text="fldValorIncidencia" TextAlignment="BottomRight" SizeF="78.6581,14.99999" LocationFloat="253.4704, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="33" Expression="FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [TotalIncidencia])&#xA;" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="34" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="35" ControlType="XRLabel" Name="fldTaxasIva" TextAlignment="BottomRight" SizeF="49.12497,14.99999" LocationFloat="204.3454, 1.589457E-05" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="36" Expression="FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [TaxaIva])&#xA;" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="37" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="38" ControlType="XRLabel" Name="fldDescricao" Text="fldDescricao" TextAlignment="MiddleLeft" SizeF="158.512,14.99999" LocationFloat="45.83333, 1.589457E-05" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="39" Expression="[MotivoIsencaoIva]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="40" UseFont="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="41" ControlType="XRLabel" Name="fldCodigo" Text="fldCodigo" TextAlignment="MiddleLeft" SizeF="45.83333,14.99999" LocationFloat="0, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="42" Expression="[Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="43" UseFont="false" UseTextAlignment="false" />
            </Item6>
          </Controls>
        </Item1>
      </SubBands>
    </Item3>
    <Item4 Ref="44" ControlType="GroupFooterBand" Name="GroupFooter1" HeightF="19.79167">
      <Controls>
        <Item1 Ref="45" ControlType="XRLine" Name="XrLine2" SizeF="181.16,2.083333" LocationFloat="204.3454, 0" />
        <Item2 Ref="46" ControlType="XRLabel" Name="fldTotalIva" Text="fldTotalIva" TextAlignment="BottomRight" SizeF="53.4,12.58332" LocationFloat="332.1283, 2.079995" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="47" Expression="FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [calculatedField2]  )&#xA;" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="48" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="49" ControlType="XRLabel" Name="fldTotalIncidencia" Text="fldTotalIncidencia" TextAlignment="BottomRight" SizeF="66.15811,12.58332" LocationFloat="265.9704, 2.079995" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="50" Expression="FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [calculatedField1] )&#xA;" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="51" UseFont="false" UseTextAlignment="false" />
        </Item3>
      </Controls>
    </Item4>
    <Item5 Ref="52" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="1" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="53" OnBeforePrint="Documentos_Compras_Motivos_Isencao_BeforePrint" />
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int32" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMDE1XEYzTTIwMTc7VXNlciBJRD1GM01TR1A7UGFzc3dvcmQ9O0luaXRpYWwgQ2F0YWxvZyA9OTk5OUYzTVNHUFFBVFNUTUFOOyIgLz48UXVlcnkgVHlwZT0iU2VsZWN0UXVlcnkiIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNNb3Rpdm9zSXNlbmNhbyIgRGlzdGluY3Q9InRydWUiPjxQYXJhbWV0ZXIgTmFtZT0iSWREb2MiIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKD9JRERvY3VtZW50byk8L1BhcmFtZXRlcj48VGFibGVzPjxUYWJsZSBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzIiAvPjxUYWJsZSBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIiAvPjxUYWJsZSBOYW1lPSJ0YklWQSIgLz48VGFibGUgTmFtZT0idGJTaXN0ZW1hVGlwb3NJVkEiIC8+PFRhYmxlIE5hbWU9InRiU2lzdGVtYUNvZGlnb3NJVkEiIC8+PFRhYmxlIE5hbWU9InRiTW9lZGFzIiAvPjxSZWxhdGlvbiBUeXBlPSJMZWZ0T3V0ZXIiIFBhcmVudD0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmVzdGVkPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIj48S2V5Q29sdW1uIFBhcmVudD0iSUQiIE5lc3RlZD0iSUREb2N1bWVudG9Db21wcmEiIC8+PC9SZWxhdGlvbj48UmVsYXRpb24gVHlwZT0iTGVmdE91dGVyIiBQYXJlbnQ9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiIE5lc3RlZD0idGJJVkEiPjxLZXlDb2x1bW4gUGFyZW50PSJJRFRheGFJdmEiIE5lc3RlZD0iSUQiIC8+PC9SZWxhdGlvbj48UmVsYXRpb24gVHlwZT0iTGVmdE91dGVyIiBQYXJlbnQ9InRiSVZBIiBOZXN0ZWQ9InRiU2lzdGVtYVRpcG9zSVZBIj48S2V5Q29sdW1uIFBhcmVudD0iSURUaXBvSXZhIiBOZXN0ZWQ9IklEIiAvPjwvUmVsYXRpb24+PFJlbGF0aW9uIFR5cGU9IkxlZnRPdXRlciIgUGFyZW50PSJ0YklWQSIgTmVzdGVkPSJ0YlNpc3RlbWFDb2RpZ29zSVZBIj48S2V5Q29sdW1uIFBhcmVudD0iSURDb2RpZ29JdmEiIE5lc3RlZD0iSUQiIC8+PC9SZWxhdGlvbj48UmVsYXRpb24gVHlwZT0iTGVmdE91dGVyIiBQYXJlbnQ9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5lc3RlZD0idGJNb2VkYXMiPjxLZXlDb2x1bW4gUGFyZW50PSJJRE1vZWRhIiBOZXN0ZWQ9IklEIiAvPjwvUmVsYXRpb24+PC9UYWJsZXM+PENvbHVtbnM+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIgTmFtZT0iSUREb2N1bWVudG9Db21wcmEiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIgTmFtZT0iVGF4YUl2YSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIiBOYW1lPSJNb3Rpdm9Jc2VuY2FvSXZhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiIE5hbWU9IlZhbG9ySXZhIiBBZ2dyZWdhdGU9IlN1bSIgQWxpYXM9IlRvdGFsSVZBIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiIE5hbWU9IlZhbG9ySW5jaWRlbmNpYSIgQWdncmVnYXRlPSJTdW0iIEFsaWFzPSJWYWxvckluY2lkZW5jaWEiIC8+PENvbHVtbiBUYWJsZT0idGJTaXN0ZW1hVGlwb3NJVkEiIE5hbWU9IkNvZGlnbyIgQWxpYXM9IkNvZGlnb1RpcG9zSVZBIiAvPjxDb2x1bW4gVGFibGU9InRiU2lzdGVtYUNvZGlnb3NJVkEiIE5hbWU9IkNvZGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ0Yk1vZWRhcyIgTmFtZT0iQ2FzYXNEZWNpbWFpc1RvdGFpcyIgQWxpYXM9InRiTW9lZGFzX0Nhc2FzRGVjaW1haXNUb3RhaXMiIC8+PENvbHVtbiBUYWJsZT0idGJNb2VkYXMiIE5hbWU9IkNhc2FzRGVjaW1haXNJdmEiIEFsaWFzPSJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzSXZhIiAvPjxDb2x1bW4gVGFibGU9InRiTW9lZGFzIiBOYW1lPSJTaW1ib2xvIiBBbGlhcz0idGJNb2VkYXNfU2ltYm9sbyIgLz48L0NvbHVtbnM+PEdyb3VwaW5nPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiIE5hbWU9IklERG9jdW1lbnRvQ29tcHJhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiIE5hbWU9IlRheGFJdmEiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIgTmFtZT0iTW90aXZvSXNlbmNhb0l2YSIgLz48Q29sdW1uIFRhYmxlPSJ0YlNpc3RlbWFUaXBvc0lWQSIgTmFtZT0iQ29kaWdvIiAvPjxDb2x1bW4gVGFibGU9InRiU2lzdGVtYUNvZGlnb3NJVkEiIE5hbWU9IkNvZGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ0Yk1vZWRhcyIgTmFtZT0iQ2FzYXNEZWNpbWFpc1RvdGFpcyIgLz48Q29sdW1uIFRhYmxlPSJ0Yk1vZWRhcyIgTmFtZT0iQ2FzYXNEZWNpbWFpc0l2YSIgLz48Q29sdW1uIFRhYmxlPSJ0Yk1vZWRhcyIgTmFtZT0iU2ltYm9sbyIgLz48L0dyb3VwaW5nPjxGaWx0ZXI+W3RiRG9jdW1lbnRvc0NvbXByYXMuSURdID0gP0lkRG9jPC9GaWx0ZXI+PC9RdWVyeT48UmVzdWx0U2NoZW1hPjxEYXRhU2V0PjxWaWV3IE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNNb3Rpdm9zSXNlbmNhbyI+PEZpZWxkIE5hbWU9IklERG9jdW1lbnRvQ29tcHJhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUl2YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRvdGFsSVZBIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW5jaWRlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29UaXBvc0lWQSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc0l2YSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''
--Mapa Motivos Isenção compras
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito],[SubReport]) VALUES (@intOrdem, N''DocumentosCompras'', N''Motivos Isencao Compras'', N''Motivos Isencao Compras'', N'''', 1, @ptrval, NULL, N'''', 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''', @intModulo, @intSistemaTipoDoc, @intSistemaTipoDocFiscal, 0,1)
')

--Subreport Dimensões compras
EXEC('
DECLARE @intOrdem as int;  
DECLARE @intModulo as bigint;
DECLARE @intSistemaTipoDoc as bigint;
DECLARE @intSistemaTipoDocFiscal as bigint;
SELECT @intOrdem = Max(isnull(Ordem,0)) + 1 FROM tbMapasVistas
SELECT @intModulo = IDModulo, @intSistemaTipoDoc = IDSistemaTipoDoc, @intSistemaTipoDocFiscal = IDSistemaTipoDocFiscal  FROM tbMapasVistas WHERE Entidade = ''DocumentosCompras'' and NomeMapa=''rptDocumentosCompras''
DECLARE @ptrval xml;  
SET @ptrval = N''<?xml version="1.0" ?>
<XtraReportsLayoutSerializer SerializerVersion="18.2.7.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="Dimensoes Compras" Margins="70, 0, 0, 0" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="18.2" DataMember="tbDocumentosComprasLinhasDimensoes" DataSource="#Ref-0">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="0" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLinha" ValueInfo="0" Name="IDLinha" Type="#Ref-3" />
    <Item3 Ref="7" Description="SimboloMoedas" Name="SimboloMoedas" />
    <Item4 Ref="9" Description="CasasMoedas" ValueInfo="0" Name="CasasMoedas" Type="#Ref-8" />
    <Item5 Ref="10" Description="CasasDecimais" ValueInfo="0" Name="CasasDecimais" Type="#Ref-8" />
    <Item6 Ref="11" Description="BDEmpresa" Name="BDEmpresa" />
    <Item7 Ref="12" Description="CasasDecimaisIva" ValueInfo="0" Name="CasasDecimaisPrecosUnit" Type="#Ref-8" />
  </Parameters>
  <Bands>
    <Item1 Ref="13" ControlType="TopMarginBand" Name="TopMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" Visible="false" />
    <Item2 Ref="14" ControlType="ReportHeaderBand" Name="ReportHeaderBand1" HeightF="0" Visible="false" />
    <Item3 Ref="15" ControlType="DetailBand" Name="Detail" HeightF="14" TextAlignment="TopLeft" Padding="0,0,0,0,100">
      <Controls>
        <Item1 Ref="16" ControlType="XRLabel" Name="fldDim1" TextAlignment="MiddleRight" SizeF="155.2083,13" LocationFloat="3.86002, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="17" Expression="[dim1]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="18" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="19" ControlType="XRLabel" Name="fldDim2" TextAlignment="MiddleLeft" SizeF="133.3333,13" LocationFloat="175.735, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="20" Expression="[dim2]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="21" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="22" ControlType="XRLabel" Name="fldQuantidade" TextAlignment="MiddleRight" SizeF="58.49997,13" LocationFloat="434, 1" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="23" Expression="FormatString(''''{0:n'''' + ?CasasDecimais  + ''''}'''', [Qtd])" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="24" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="25" ControlType="XRLabel" Name="fldPUnit" TextAlignment="MiddleRight" SizeF="61.77997,13" LocationFloat="506.1202, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="26" Expression="FormatString(''''{0:n'''' + ?CasasDecimaisPrecosUnit  + ''''}'''', [punit])" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="27" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="28" ControlType="XRLabel" Name="fldValTot" Text="fldValTot" TextAlignment="MiddleRight" SizeF="44.82178,13" LocationFloat="654.9001, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="29" Expression="iif(?CasasMoedas &lt; 3, FormatString(''''{0:n'''' + 3  + ''''}'''', [ValTotal]), FormatString(''''{0:n'''' + ?CasasMoedas  + ''''}'''', [ValTotal]))" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="30" UseFont="false" UseTextAlignment="false" />
        </Item5>
      </Controls>
      <ExpressionBindings>
        <Item1 Ref="31" Expression="Iif(IsNullOrEmpty([Qtd]),0,[Qtd]) &gt; 0" PropertyName="Visible" EventName="BeforePrint" />
      </ExpressionBindings>
    </Item3>
    <Item4 Ref="32" ControlType="PageFooterBand" Name="PageFooterBand1" HeightF="0" Visible="false" />
    <Item5 Ref="33" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <StyleSheet>
    <Item1 Ref="34" Name="Title" BorderStyle="Inset" Font="Times New Roman, 20pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item2 Ref="35" Name="FieldCaption" BorderStyle="Inset" Font="Arial, 10pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item3 Ref="36" Name="PageInfo" BorderStyle="Inset" Font="Times New Roman, 10pt, style=Bold" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item4 Ref="37" Name="DataField" BorderStyle="Inset" Padding="2,2,0,0,100" Font="Times New Roman, 10pt" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
  </StyleSheet>
  <ReportPrintOptions Ref="38" PrintOnEmptyDataSource="false" />
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="8" Content="System.Int16" Type="System.Type" />
    <Item3 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMTAxXEYzTTIwMTc7VXNlciBJRD1GM01TR1BFTVBETTtQYXNzd29yZD07SW5pdGlhbCBDYXRhbG9nID05OTk5RjNNU0dQRU1QRE07IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc0RpbWVuc29lcyI+PFBhcmFtZXRlciBOYW1lPSJJRExpbmhhIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5JbnQ2NCwgbXNjb3JsaWIsIFZlcnNpb249NC4wLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5KShbUGFyYW1ldGVycy5JRExpbmhhXSk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCAidGJBcnRpZ29zRGltZW5zb2VzIi4iSURBcnRpZ28iICxETDEuRGVzY3JpY2FvIGFzIGRpbTEsIA0KY2FzZSB3aGVuIERMMi5EZXNjcmljYW8gaXMgbnVsbCB0aGVuICcnIGVsc2UgREwyLkRlc2NyaWNhbyBlbmQgYXMgZGltMiwNCmlzbnVsbCh0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzRGltZW5zb2VzLlF1YW50aWRhZGUsIDApIGFzIFF0ZCwNCmlzbnVsbCh0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzRGltZW5zb2VzLlByZWNvVW5pdGFyaW8sMCkgYXMgcHVuaXQsDQppc251bGwodGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc0RpbWVuc29lcy5RdWFudGlkYWRlLCAwKSAqIGlzbnVsbCh0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzRGltZW5zb2VzLlByZWNvVW5pdGFyaW8sMCkgYXMgVmFsVG90YWwNCiBmcm9tIHRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNEaW1lbnNvZXMNCmxlZnQgam9pbiAiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyINCiAgICAgICBvbiAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc0RpbWVuc29lcyIuIklERG9jdW1lbnRvQ29tcHJhTGluaGEiID0gInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRCINCmxlZnQgam9pbiAiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhcyINCiAgICAgICBvbiAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklERG9jdW1lbnRvQ29tcHJhIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUQiDQpsZWZ0IGpvaW4gImRibyIuInRiQXJ0aWdvc0RpbWVuc29lcyINCiAgICAgICBvbiAidGJBcnRpZ29zRGltZW5zb2VzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNEaW1lbnNvZXMiLiJJREFydGlnb0RpbWVuc2FvIg0KbGVmdCBqb2luICJkYm8iLiJ0YkRpbWVuc29lc0xpbmhhcyIgQXMgREwxDQogICAgICAgb24gREwxLiJJRCIgPSAidGJBcnRpZ29zRGltZW5zb2VzIi4iSUREaW1lbnNhb0xpbmhhMSINCmxlZnQgam9pbiAiZGJvIi4idGJEaW1lbnNvZXNMaW5oYXMiIEFzIERMMg0KICAgICAgIG9uIERMMi4iSUQiID0gInRiQXJ0aWdvc0RpbWVuc29lcyIuIklERGltZW5zYW9MaW5oYTIiDQp3aGVyZSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEIiA9IEBJRExpbmhhDQpPcmRlciBieSBETDEuT3JkZW0gLCBETDIuT3JkZW08L1NxbD48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQ+PFZpZXcgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc0RpbWVuc29lcyI+PEZpZWxkIE5hbWU9IklEQXJ0aWdvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iZGltMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJkaW0yIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlF0ZCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJwdW5pdCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxUb3RhbCIgVHlwZT0iRG91YmxlIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''
--Mapa Dimensões compras
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], 
[IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito],[SubReport]) VALUES (@intOrdem, N''DocumentosCompras'', N''Dimensoes Compras'', N''Dimensoes Compras'', N'''', 1, @ptrval, NULL, N'''', 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''', @intModulo, @intSistemaTipoDoc, @intSistemaTipoDocFiscal, 0,1)
')

--Subreport dimensões compras não valorizado 
EXEC('
DECLARE @intOrdem as int;
DECLARE @intModulo as bigint;
DECLARE @intSistemaTipoDoc as bigint;
DECLARE @intSistemaTipoDocFiscal as bigint;
SELECT @intOrdem = Max(isnull(Ordem,0)) + 1 FROM tbMapasVistas
SELECT @intModulo = IDModulo, @intSistemaTipoDoc = IDSistemaTipoDoc, @intSistemaTipoDocFiscal = IDSistemaTipoDocFiscal  FROM tbMapasVistas WHERE Entidade = ''DocumentosCompras'' and NomeMapa=''rptDocumentosCompras''
DECLARE @ptrval xml;  
SET @ptrval = N''<?xml version="1.0" ?>
<XtraReportsLayoutSerializer SerializerVersion="18.2.7.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="Dimensoes Compras Nao Valorizado" Margins="70, 0, 0, 0" PageWidth="850" PageHeight="1100" ScriptLanguage="VisualBasic" Version="18.2" DataMember="tbDocumentosComprasLinhasDimensoes" DataSource="#Ref-0">
  <Parameters>
    <Item1 Ref="3" Description="IDDocumento" ValueInfo="0" Name="IDDocumento" Type="#Ref-2" />
    <Item2 Ref="4" Description="IDLinha" ValueInfo="0" Name="IDLinha" Type="#Ref-2" />
    <Item3 Ref="6" Description="SimboloMoedas" Name="SimboloMoedas" />
    <Item4 Ref="8" Description="CasasMoedas" ValueInfo="0" Name="CasasMoedas" Type="#Ref-7" />
    <Item5 Ref="9" Description="CasasDecimais" ValueInfo="0" Name="CasasDecimais" Type="#Ref-7" />
    <Item6 Ref="10" Description="BDEmpresa" Name="BDEmpresa" />
  </Parameters>
  <Bands>
    <Item1 Ref="11" ControlType="TopMarginBand" Name="TopMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" Visible="false" />
    <Item2 Ref="12" ControlType="ReportHeaderBand" Name="ReportHeaderBand1" HeightF="0" Visible="false" />
    <Item3 Ref="13" ControlType="DetailBand" Name="Detail" Expanded="false" HeightF="13" TextAlignment="TopLeft" Padding="0,0,0,0,100">
      <Controls>
        <Item1 Ref="14" ControlType="XRLabel" Name="fldDim1" TextAlignment="MiddleRight" SizeF="155.2083,13" LocationFloat="4.860023, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="15" Expression="[dim1]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="16" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="17" ControlType="XRLabel" Name="fldDim2" TextAlignment="MiddleLeft" SizeF="133.3333,13" LocationFloat="174.735, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="18" Expression="[dim2]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="19" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="20" ControlType="XRLabel" Name="fldQuantidade" TextAlignment="MiddleRight" SizeF="61.625,13" LocationFloat="639.9016, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="21" Expression="[Qtd]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="22" UseFont="false" UseTextAlignment="false" />
        </Item3>
      </Controls>
      <ExpressionBindings>
        <Item1 Ref="23" Expression="Iif(IsNullOrEmpty([Qtd]),0,[Qtd]) &gt; 0" PropertyName="Visible" EventName="BeforePrint" />
      </ExpressionBindings>
    </Item3>
    <Item4 Ref="24" ControlType="PageFooterBand" Name="PageFooterBand1" Expanded="false" HeightF="0" Visible="false" />
    <Item5 Ref="25" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <StyleSheet>
    <Item1 Ref="26" Name="Title" BorderStyle="Inset" Font="Times New Roman, 20pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item2 Ref="27" Name="FieldCaption" BorderStyle="Inset" Font="Arial, 10pt, style=Bold" ForeColor="Maroon" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item3 Ref="28" Name="PageInfo" BorderStyle="Inset" Font="Times New Roman, 10pt, style=Bold" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
    <Item4 Ref="29" Name="DataField" BorderStyle="Inset" Padding="2,2,0,0,100" Font="Times New Roman, 10pt" ForeColor="Black" BackColor="Transparent" BorderColor="Black" Sides="None" StringFormat="Near;Near;0;None;Character;Default" BorderWidthSerializable="1" />
  </StyleSheet>
  <ReportPrintOptions Ref="30" PrintOnEmptyDataSource="false" />
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="2" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="7" Content="System.Int16" Type="System.Type" />
    <Item3 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Name="SqlDataSource1" Base64="PFNxbERhdGFTb3VyY2UgTmFtZT0iU3FsRGF0YVNvdXJjZTEiPjxDb25uZWN0aW9uIE5hbWU9IkRlZmF1bHRDb25uRXNwUHJvZHV6IiBDb25uZWN0aW9uU3RyaW5nPSJEYXRhIFNvdXJjZT1GM00tUEMxMDFcRjNNMjAxNztVc2VyIElEPUYzTVNHUEVNUERNO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTk5OTlGM01TR1BFTVBETTsiIC8+PFF1ZXJ5IFR5cGU9IkN1c3RvbVNxbFF1ZXJ5IiBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzRGltZW5zb2VzIj48UGFyYW1ldGVyIE5hbWU9IklETGluaGEiIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKD9JRExpbmhhICk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCAidGJBcnRpZ29zRGltZW5zb2VzIi4iSURBcnRpZ28iICxETDEuRGVzY3JpY2FvIGFzIGRpbTEsIA0KY2FzZSB3aGVuIERMMi5EZXNjcmljYW8gaXMgbnVsbCB0aGVuICcnIGVsc2UgREwyLkRlc2NyaWNhbyBlbmQgYXMgZGltMiwNCmlzbnVsbCh0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzRGltZW5zb2VzLlF1YW50aWRhZGUsIDApIGFzIFF0ZCwNCmlzbnVsbCh0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzRGltZW5zb2VzLlByZWNvVW5pdGFyaW8sMCkgYXMgcHVuaXQsDQppc251bGwodGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc0RpbWVuc29lcy5RdWFudGlkYWRlLCAwKSAqIGlzbnVsbCh0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzRGltZW5zb2VzLlByZWNvVW5pdGFyaW8sMCkgYXMgVmFsVG90YWwNCiBmcm9tIHRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNEaW1lbnNvZXMNCmxlZnQgam9pbiAiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyINCiAgICAgICBvbiAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc0RpbWVuc29lcyIuIklERG9jdW1lbnRvQ29tcHJhTGluaGEiID0gInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRCINCmxlZnQgam9pbiAiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhcyINCiAgICAgICBvbiAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklERG9jdW1lbnRvQ29tcHJhIj0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCINCmxlZnQgam9pbiAiZGJvIi4idGJBcnRpZ29zRGltZW5zb2VzIg0KICAgICAgIG9uICJ0YkFydGlnb3NEaW1lbnNvZXMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc0RpbWVuc29lcyIuIklEQXJ0aWdvRGltZW5zYW8iDQpsZWZ0IGpvaW4gImRibyIuInRiRGltZW5zb2VzTGluaGFzIiBBcyBETDENCiAgICAgICBvbiBETDEuIklEIiA9ICJ0YkFydGlnb3NEaW1lbnNvZXMiLiJJRERpbWVuc2FvTGluaGExIg0KbGVmdCBqb2luICJkYm8iLiJ0YkRpbWVuc29lc0xpbmhhcyIgQXMgREwyDQogICAgICAgb24gREwyLiJJRCIgPSAidGJBcnRpZ29zRGltZW5zb2VzIi4iSUREaW1lbnNhb0xpbmhhMiINCndoZXJlICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSUQiID0gQElETGluaGENCk9yZGVyIGJ5IERMMS5PcmRlbSAsIERMMi5PcmRlbTwvU3FsPjwvUXVlcnk+PFJlc3VsdFNjaGVtYT48RGF0YVNldCBOYW1lPSJTcWxEYXRhU291cmNlMSI+PFZpZXcgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc0RpbWVuc29lcyI+PEZpZWxkIE5hbWU9IklEQXJ0aWdvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iZGltMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJkaW0yIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlF0ZCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJwdW5pdCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxUb3RhbCIgVHlwZT0iRG91YmxlIiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''
--Mapa Dimensões compras não valorizado
INSERT [dbo].[tbMapasVistas] ([Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDLoja], [SQLQuery], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal],[PorDefeito],[SubReport]) 
VALUES (@intOrdem, N''DocumentosCompras'', N''Dimensões Compras Não Valorizado'', N''Dimensoes Compras Nao Valorizado'', N'''', 1, @ptrval, NULL, N'''', 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''', @intModulo, @intSistemaTipoDoc, @intSistemaTipoDocFiscal, 0,1)
')

--Documento de compras - Principal
EXEC('
DECLARE @ptrval xml;  
DECLARE @intIDMapaSubCab as bigint;--10000
DECLARE @intIDMapaMI as bigint;--20000
DECLARE @intIDMapaD as bigint;--30000
DECLARE @intIDMapaDNV as bigint;--40000
SELECT @intIDMapaSubCab = ID FROM tbMapasVistas WHERE Entidade = ''DocumentosCompras'' and NomeMapa = ''Cabecalho Empresa Compras''
SELECT @intIDMapaMI = ID FROM tbMapasVistas WHERE Entidade = ''DocumentosCompras'' and NomeMapa = ''Motivos Isencao Compras''
SELECT @intIDMapaD = ID FROM tbMapasVistas WHERE Entidade = ''DocumentosCompras'' and NomeMapa = ''Dimensoes Compras''
SELECT @intIDMapaDNV = ID FROM tbMapasVistas WHERE Entidade = ''DocumentosCompras'' and NomeMapa = ''Dimensoes Compras Nao Valorizado''
SET @ptrval = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.7.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="Documentos Compras" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Constantes&#xD;&#xA;&#xD;&#xA;Private dblTransportar as Double = 0&#xD;&#xA;Private dblTransporte as Double = 0&#xD;&#xA;&#xD;&#xA;Private Sub Documentos_Compras_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim SimboloMoeda As String = String.Empty&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Parameters.Item(&quot;AcompanhaBens&quot;).Value = False&#xD;&#xA;    Parameters.Item(&quot;IDLinha&quot;).Value = GetCurrentColumnValue(&quot;tbDocumentosComprasLinhas_ID&quot;)        &#xD;&#xA;    Parameters.Item(&quot;CasasMoedas&quot;).Value = GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisIva&quot;)&#xD;&#xA;        &#xD;&#xA;    SimboloMoeda = GetCurrentColumnValue(&quot;tbMoedas_Simbolo&quot;)&#xD;&#xA;    If SimboloMoeda = &quot;&quot; Then&#xD;&#xA;        Parameters.Item(&quot;SimboloMoedas&quot;).Value = &quot;€&quot;&#xD;&#xA;        SimboloMoeda = &quot;€&quot;&#xD;&#xA;    Else&#xD;&#xA;        Me.Parameters.Item(&quot;SimboloMoedas&quot;).Value = SimboloMoeda&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) then&#xD;&#xA;        lblPreco.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Preco&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTotalFinal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Total&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDesconto1.Text = resource.GetResource(&quot;Desconto1&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDesconto2.Text = resource.GetResource(&quot;Desconto2&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescontosLinha.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoLinha&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescontoGlobal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoGlobal&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTotalIva.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalIva&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    End If&#xD;&#xA;    Select Case GetCurrentColumnValue(&quot;tbSistemaTiposDocumento_Tipo&quot;)&#xD;&#xA;        Case &quot;CmpOrcamento&quot;, &quot;CmpTransporte&quot;, &quot;CmpFinanceiro&quot;&#xD;&#xA;            If GetCurrentColumnValue(&quot;tbSistemaNaturezas_Codigo&quot;) = &quot;P&quot; Then&#xD;&#xA;                lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens1_CodigoDestino&quot;)&#xD;&#xA;                fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens1_CodigoDestino&quot;)&#xD;&#xA;                fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes1_Codigo&quot;)&#xD;&#xA;                fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes1_Codigo&quot;)&#xD;&#xA;            ElseIf GetCurrentColumnValue(&quot;tbSistemaNaturezas_Codigo&quot;) = &quot;R&quot; Then&#xD;&#xA;                lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;                fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;                fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;                fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;            End If&#xD;&#xA;        Case &quot;CmpEncomenda&quot;&#xD;&#xA;            lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;            fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;            fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;            fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;    End Select&#xD;&#xA;    ''''Assinatura&#xD;&#xA;    Dim strAssinatura As String = String.Empty&#xD;&#xA;    Dim strAss As String = String.Empty&#xD;&#xA;    Dim strMsg As String = String.Empty&#xD;&#xA;    If GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt) &gt; 0 Then&#xD;&#xA;        strAss = GetCurrentColumnValue(&quot;MensagemDocAT&quot;).Substring(0, GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt))&#xD;&#xA;        strMsg = GetCurrentColumnValue(&quot;MensagemDocAT&quot;).Substring(GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt) + Constantes.SaftAT.CSeparadorMsgAt.Length)&#xD;&#xA;    Else&#xD;&#xA;        strAss = GetCurrentColumnValue(&quot;MensagemDocAT&quot;)&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;CodigoAT&quot;) &lt;&gt; String.Empty Then&#xD;&#xA;        strMsg += &quot; | ATDocCodeId: &quot; &amp; GetCurrentColumnValue(&quot;CodigoAT&quot;)&#xD;&#xA;    End If&#xD;&#xA;    fldMensagemDocAT.Text = strMsg&#xD;&#xA;    fldMensagemDocAT1.Text = strMsg&#xD;&#xA;    fldAssinatura11.Text = strMsg&#xD;&#xA;    fldAssinatura.Text = strAss&#xD;&#xA;    fldAssinatura1.Text = strAss&#xD;&#xA;    fldassinaturanaoval.Text = strAss&#xD;&#xA;    &#xD;&#xA;    If GetCurrentColumnValue(&quot;tbTiposDocumento_AcompanhaBensCirculacao&quot;) Then&#xD;&#xA;        If Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Original&quot; AndAlso Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Duplicado&quot; AndAlso Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Triplicado&quot; Then&#xD;&#xA;            lblCopia1.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;            lblCopia2.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;            lblCopia3.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    &#xD;&#xA;     ''''Separadores totalizadores&#xD;&#xA;    lblSubTotal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;SubTotal&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    lblTotalIva.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalIva&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    lblTotalMoedaDocumento.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalMoedaDocumento&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    ''''Identificação do documento&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) is dbnull.value then&#xD;&#xA;        lblTipoDocumento.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTipoDocumento1.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    end if&#xD;&#xA;    If GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) is dbnull.value Orelse GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) = String.Empty Orelse GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) = &quot;NaoFiscal&quot; Then&#xD;&#xA;        lblTipoDocumento.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTipoDocumento1.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;CodigoTipoEstado&quot;) = &quot;ANL&quot; Then&#xD;&#xA;        lblAnulado.Text = resource.GetResource(&quot;Anulado&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblAnulado.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;SegundaVia&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;SegundaVia&quot;) = &quot;True&quot; Then&#xD;&#xA;        If lblAnulado.Visible Then&#xD;&#xA;            lblSegundaVia.Visible = False&#xD;&#xA;            lblNumVias.Visible = True&#xD;&#xA;        Else&#xD;&#xA;            lblSegundaVia.Text = resource.GetResource(&quot;SegundaVia&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblSegundaVia.Visible = True&#xD;&#xA;            lblNumVias.Visible = False&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbCodigosPostaisCarga_Codigo&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;tbCodigosPostaisCarga_Codigo&quot;) = String.Empty Then&#xD;&#xA;        fldDataCarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbCodigosPostaisDescarga_Codigo&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;tbCodigosPostaisDescarga_Codigo&quot;) = String.Empty Then&#xD;&#xA;        fldDataDescarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;MoradaCarga&quot;) &lt;&gt; String.Empty Or GetCurrentColumnValue(&quot;MoradaDescarga&quot;) &lt;&gt; String.Empty Then&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_AcompanhaBensCirculacao&quot;) Then&#xD;&#xA;            SubBand6.Visible = True&#xD;&#xA;        Else&#xD;&#xA;            SubBand6.Visible = False&#xD;&#xA;        End If&#xD;&#xA;    Else&#xD;&#xA;        SubBand6.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    TraducaoDocumento()   &#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA; Private Sub TraducaoDocumento()&#xD;&#xA;        Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;        ''''Doc.Origem&#xD;&#xA;        lblDocOrigem.Text = resource.GetResource(&quot;Origem&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDocOrigem1.Text = resource.GetResource(&quot;Origem&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Descrição&#xD;&#xA;        lblDescricao.Text = resource.GetResource(&quot;Descricao&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescricao1.Text = resource.GetResource(&quot;Descricao&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Lote&#xD;&#xA;        lblLote.Text = resource.GetResource(&quot;Lote&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblLote1.Text = resource.GetResource(&quot;Lote&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Armazens&#xD;&#xA;        ''''Localizações&#xD;&#xA;        ''''Unidades&#xD;&#xA;        lblUni.Text = resource.GetResource(&quot;Unidade&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblUni1.Text = resource.GetResource(&quot;Unidade&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Quantidade&#xD;&#xA;        lblQuantidade.Text = resource.GetResource(&quot;Qtd&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblQuantidade1.Text = resource.GetResource(&quot;Qtd&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblContribuinte.Text = resource.GetResource(&quot;Contribuinte&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblFornecedorCodigo.Text = resource.GetResource(&quot;FornecedorCodigo&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblCodigoMoeda.Text = resource.GetResource(&quot;CodigoMoeda&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDataDocumento.Text = resource.GetResource(&quot;DataDocumento&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblCarga.Text = resource.GetResource(&quot;Carga&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescarga.Text = resource.GetResource(&quot;Descarga&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblExpedicao.Text = resource.GetResource(&quot;Matricula&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTituloTransporte.Text = resource.GetResource(&quot;TituloTransporte&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTituloTransportar.Text = resource.GetResource(&quot;TituloTransportar&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura11_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        fldAssinatura11.Visible = False&#xD;&#xA;        me.lblCopia3.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        fldAssinatura11.Visible = True&#xD;&#xA;        me.lblCopia3.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura1_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        fldAssinatura1.Visible = False&#xD;&#xA;        me.lblCopia3.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        fldAssinatura1.Visible = True&#xD;&#xA;        me.lblCopia3.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;     If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTransportar.Visible = False&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Me.fldAssinatura1.Visible = False&#xD;&#xA;        Me.fldAssinatura11.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTransportar.Visible = False&#xD;&#xA;            Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTransportar.Visible = True&#xD;&#xA;            Me.lblTituloTransportar.Visible = True&#xD;&#xA;        End If&#xD;&#xA;        Me.fldAssinatura1.Visible = True&#xD;&#xA;        Me.fldAssinatura11.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;    Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex)     &#xD;&#xA;    Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;    While (iterator.MoveNext())&#xD;&#xA;        If (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal&quot;))&#xD;&#xA;            dblTransportar += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;        End If&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;            label.Text = dblTransportar.ToString()&#xD;&#xA;        Else&#xD;&#xA;            label.Text = Convert.ToDouble(dblTransportar.ToString()).ToString(&quot;F&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;        End If&#xD;&#xA;    End While&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransportar.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;     If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Me.lblTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransporte.Visible = False&#xD;&#xA;            Me.lblTransporte.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransporte.Visible = True&#xD;&#xA;            Me.lblTransporte.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    If e.PageIndex &gt; 0 then&#xD;&#xA;        Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;        Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex - 1)     &#xD;&#xA;        Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;        While (iterator.MoveNext())&#xD;&#xA;             if (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal&quot;))&#xD;&#xA;                dblTransporte += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;            End If&#xD;&#xA;            If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;                label.Text = dblTransporte.ToString()&#xD;&#xA;            Else&#xD;&#xA;                label.Text = Convert.ToDouble(dblTransporte.ToString()).ToString(&quot;F&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;            End If&#xD;&#xA;        End While&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransporte.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;" DrawWatermark="true" Margins="54, 18, 25, 1" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosCompras_Cab" DataSource="#Ref-0">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="40026" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="6" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item3 Ref="7" Visible="false" Description="Via" Name="Via" />
    <Item4 Ref="8" Visible="false" Description="BDEmpresa" ValueInfo="Teste" Name="BDEmpresa" />
    <Item5 Ref="9" Visible="false" Description="Observacoes" ValueInfo="select ID, Observacoes from tbDocumentosCompras where ID=" Name="Observacoes" />
    <Item6 Ref="11" Visible="false" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-10" />
    <Item7 Ref="12" Visible="false" Description="FraseFiscal" ValueInfo="FraseFiscal" Name="FraseFiscal" />
    <Item8 Ref="13" Description="IDEmpresa" ValueInfo="1" Name="IDEmpresa" Type="#Ref-3" />
    <Item9 Ref="15" Visible="false" Description="AcompanhaBens" ValueInfo="true" Name="AcompanhaBens" Type="#Ref-14" />
    <Item10 Ref="16" Description="IDLinha" ValueInfo="0" Name="IDLinha" Type="#Ref-3" />
    <Item11 Ref="18" Description="CasasDecimais" ValueInfo="0" Name="CasasDecimais" Type="#Ref-17" />
    <Item12 Ref="19" Description="CasasMoedas" ValueInfo="0" Name="CasasMoedas" Type="#Ref-17" />
    <Item13 Ref="20" Description="SimboloMoedas" Name="SimboloMoedas" />
    <Item14 Ref="21" Description="UrlServerPath" ValueInfo="http:\\localhost" AllowNull="true" Name="UrlServerPath" />
    <Item15 Ref="22" Description="Utilizador" ValueInfo="f3m" Name="Utilizador" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="23" Name="SomaQuantidade" FieldType="Float" DisplayName="SomaQuantidade" Expression="[].Sum([Quantidade])" DataMember="tbDocumentosVendas" />
    <Item2 Ref="24" Name="SomaValorIVA" FieldType="Float" Expression="[].Sum([ValorIVA])" DataMember="tbDocumentosVendas" />
    <Item3 Ref="25" Name="SomaValorIncidencia" FieldType="Float" Expression="[].Sum([ValorIncidencia])" DataMember="tbDocumentosVendas" />
    <Item4 Ref="26" Name="SomaTotalFinal" FieldType="Double" Expression="[].Sum([TotalFinal])" DataMember="tbDocumentosVendas" />
    <Item5 Ref="27" Name="MotivoIsencao" DisplayName="MotivoIsencao" Expression="IIF([TaxaIva]=0, '''''''', [CodigoMotivoIsencaoIva])" DataMember="tbDocumentosVendas" />
    <Item6 Ref="28" Name="SubTotal" FieldType="Double" Expression="[TotalMoedaDocumento] - [ValorImposto] " DataMember="tbDocumentosCompras_Cab" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="29" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="30" ControlType="ReportHeaderBand" Name="ReportHeader" Expanded="false" HeightF="0" />
    <Item3 Ref="31" ControlType="PageHeaderBand" Name="PageHeader" Expanded="false" HeightF="2.09">
      <SubBands>
        <Item1 Ref="32" ControlType="SubBand" Name="SubBand5" HeightF="107.87">
          <Controls>
            <Item1 Ref="33" ControlType="XRSubreport" Name="XrSubreport2" ReportSourceUrl="10000" SizeF="535.2748,105.7917" LocationFloat="0, 0">
              <ParameterBindings>
                <Item1 Ref="34" ParameterName="" DataMember="tbDocumentosCompras.IDLoja" />
                <Item2 Ref="36" ParameterName="Culture" Parameter="#Ref-6" />
                <Item3 Ref="37" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                <Item4 Ref="38" ParameterName="" DataMember="tbParametrosLojas.DesignacaoComercial" />
                <Item5 Ref="39" ParameterName="" DataMember="tbParametrosLojas.Morada" />
                <Item6 Ref="40" ParameterName="" DataMember="tbParametrosLojas.Localidade" />
                <Item7 Ref="41" ParameterName="" DataMember="tbParametrosLojas.CodigoPostal" />
                <Item8 Ref="42" ParameterName="" DataMember="tbParametrosLojas.Sigla" />
                <Item9 Ref="43" ParameterName="" DataMember="tbParametrosLojas.NIF" />
                <Item10 Ref="44" ParameterName="UrlServerPath" Parameter="#Ref-21" />
              </ParameterBindings>
            </Item1>
            <Item2 Ref="45" ControlType="XRLabel" Name="fldDataVencimento" TextFormatString="{0:dd-MM-yyyy}" CanGrow="false" TextAlignment="TopRight" SizeF="83.64227,20" LocationFloat="662.777, 78.02378" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="46" Expression="[DataDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="47" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="48" ControlType="XRLabel" Name="fldTipoDocumento" TextAlignment="TopRight" SizeF="159.7648,20.54824" LocationFloat="586.78, 33.55265" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="49" Expression="[tbTiposDocumento_Codigo] + '''' '''' + [CodigoSerie] + ''''/'''' + [NumeroDocumento] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="50" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="51" ControlType="XRLabel" Name="lblDataDocumento" Text="Data" TextAlignment="TopRight" SizeF="84.06,15" LocationFloat="662.777, 63.10085" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
              <StylePriority Ref="52" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="53" ControlType="XRLabel" Name="lblNumVias" Text="Via" TextAlignment="TopRight" SizeF="160.2199,11.77632" LocationFloat="586.78, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="54" Expression="?Via " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="55" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="56" ControlType="XRLabel" Name="lblTipoDocumento" Text="Fatura" TextAlignment="TopRight" SizeF="159.7648,13.77632" LocationFloat="586.78, 19.77634" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="57" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="58" ControlType="XRLabel" Name="lblAnulado" Angle="20" Text="ANULADO" TextAlignment="MiddleCenter" SizeF="189.8313,105.7917" LocationFloat="427.3537, 0" Font="Arial, 24pt, style=Bold, charSet=0" ForeColor="Red" Padding="2,2,0,0,100" Visible="false">
              <StylePriority Ref="59" UseFont="false" UseForeColor="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="60" ControlType="XRLabel" Name="lblSegundaVia" Text="2º Via" TextAlignment="TopRight" SizeF="80.59814,13.77632" LocationFloat="665.8211, 0" Font="Arial, 9pt, style=Bold, charSet=0" ForeColor="Black" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <StylePriority Ref="61" UseFont="false" UseForeColor="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="62" Expression="not(([tbSistemaTiposDocumento_Tipo] = ''''CmpFinanceiro'''' or &#xA;[tbSistemaTiposDocumento_Tipo] = ''''CmpTransporte'''') And&#xA;([TipoFiscal] = ''''FT'''' Or [TipoFiscal] = ''''FR'''' Or &#xA;[TipoFiscal] = ''''FS'''' Or [TipoFiscal] = ''''NC'''' Or &#xA;[TipoFiscal] = ''''ND'''' Or [TipoFiscal] = ''''NF'''' Or &#xA;[TipoFiscal] = ''''GR'''' Or [TipoFiscal] = ''''GT''''))" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item1>
        <Item2 Ref="63" ControlType="SubBand" Name="SubBand1" HeightF="150.42">
          <Controls>
            <Item1 Ref="64" ControlType="XRPanel" Name="XrPanel1" SizeF="746.837,148.3334" LocationFloat="2.91, 0">
              <Controls>
                <Item1 Ref="65" ControlType="XRLabel" Name="fldCodigoPostal" Text="Código Postal" TextAlignment="TopRight" SizeF="296.2911,22.99999" LocationFloat="381.5468, 86" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="66" Expression="[tbCodigosPostaisCliente_Codigo] + '''' '''' + [tbCodigosPostaisCliente_Descricao] " PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="67" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item1>
                <Item2 Ref="68" ControlType="XRLabel" Name="fldCodigoMoeda" TextAlignment="TopLeft" SizeF="194.7021,13.99999" LocationFloat="103.1326, 49.00001" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="69" Expression="[tbMoedas_Codigo]" PropertyName="Text" EventName="BeforePrint" />
                    <Item2 Ref="70" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="71" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item2>
                <Item3 Ref="72" ControlType="XRLabel" Name="lblCodigoMoeda" Text="Moeda" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010068, 49.00004" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Parentesco">
                  <ExpressionBindings>
                    <Item1 Ref="73" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="74" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item3>
                <Item4 Ref="75" ControlType="XRLabel" Name="fldMorada" TextAlignment="TopRight" SizeF="296.2915,23" LocationFloat="381.5468, 63" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="76" Expression="[MoradaFiscal]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="77" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item4>
                <Item5 Ref="78" ControlType="XRLabel" Name="fldNome" TextAlignment="TopRight" SizeF="296.2916,23" LocationFloat="381.5467, 40" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="79" Expression="[NomeFiscal]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="80" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item5>
                <Item6 Ref="81" ControlType="XRLabel" Name="lblTitulo" Text="Exmo.(a) Sr.(a) " TextAlignment="TopRight" SizeF="296.2916,20" LocationFloat="381.5464, 20" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="82" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="83" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item6>
                <Item7 Ref="84" ControlType="XRLabel" Name="lblContribuinte" Text="Contribuinte nº" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010005, 21.00004" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
                  <StylePriority Ref="85" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item7>
                <Item8 Ref="86" ControlType="XRLabel" Name="lblFornecedorCodigo" Text="Cod. Fornecedor" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010036, 35.00004" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Cliente">
                  <StylePriority Ref="87" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item8>
                <Item9 Ref="88" ControlType="XRLabel" Name="fldFornecedorCodigo" TextAlignment="TopLeft" SizeF="194.7036,14" LocationFloat="103.131, 35.00001" Font="Arial, 8pt" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="89" Expression="[tbFornecedores_Codigo]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="90" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item9>
                <Item10 Ref="91" ControlType="XRLabel" Name="fldContribuinteFiscal" TextAlignment="TopLeft" SizeF="194.715,13.99999" LocationFloat="103.1311, 21" Font="Arial, 8pt" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="92" Expression="[ContribuinteFiscal]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="93" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item10>
              </Controls>
            </Item1>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="94" Expression="not(([tbSistemaTiposDocumento_Tipo] = ''''CmpFinanceiro'''' or &#xA;[tbSistemaTiposDocumento_Tipo] = ''''CmpTransporte'''') And&#xA;([TipoFiscal] = ''''FT'''' Or [TipoFiscal] = ''''FR'''' Or &#xA;[TipoFiscal] = ''''FS'''' Or [TipoFiscal] = ''''NC'''' Or &#xA;[TipoFiscal] = ''''ND'''' Or [TipoFiscal] = ''''NF'''' Or &#xA;[TipoFiscal] = ''''GR'''' Or [TipoFiscal] = ''''GT''''))" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item2>
        <Item3 Ref="95" ControlType="SubBand" Name="SubBand8" HeightF="65">
          <Controls>
            <Item1 Ref="96" ControlType="XRLine" Name="line1" SizeF="745.41,2.252249" LocationFloat="1, 61.07" />
            <Item2 Ref="97" ControlType="XRLabel" Name="label6" Text="Fornecedor" TextAlignment="TopLeft" SizeF="85,15" LocationFloat="260, 25" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
              <StylePriority Ref="98" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="99" ControlType="XRLabel" Name="label10" Multiline="true" Text="label10" SizeF="350,20" LocationFloat="260, 40" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="100" Expression="[CodigoEntidade] + '''' - '''' + [NomeFiscal] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="101" UseFont="false" />
            </Item3>
            <Item4 Ref="102" ControlType="XRLabel" Name="label9" Multiline="true" Text="label9" TextAlignment="MiddleRight" SizeF="100,13" LocationFloat="650, 40" Font="Times New Roman, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="103" Expression="?Utilizador" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="104" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="105" ControlType="XRLabel" Name="label8" Multiline="true" Text="label8" TextAlignment="MiddleRight" SizeF="125,13" LocationFloat="625, 25" Font="Times New Roman, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="106" Expression="LocalDateTimeNow() " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="107" UseFont="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="108" ControlType="XRLabel" Name="label7" Multiline="true" Text="Emitido em" TextAlignment="MiddleRight" SizeF="100,13" LocationFloat="650, 10" Font="Times New Roman, 8pt" Padding="2,2,0,0,100">
              <StylePriority Ref="109" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="110" ControlType="XRLabel" Name="label5" TextFormatString="{0:dd-MM-yyyy}" CanGrow="false" Text="label5" TextAlignment="TopCenter" SizeF="85,20" LocationFloat="170, 40" Font="Arial, 9pt" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="111" Expression="[DataDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="112" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="113" ControlType="XRLabel" Name="label4" Text="Data" TextAlignment="TopCenter" SizeF="85,15" LocationFloat="170, 25" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
              <StylePriority Ref="114" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="115" ControlType="XRLabel" Name="label3" Text="label3" TextAlignment="TopRight" SizeF="160,20" LocationFloat="6, 40" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="116" Expression="[VossoNumeroDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="117" UseFont="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="118" ControlType="XRLabel" Name="lblTipoDocumento1" Text="Fatura" TextAlignment="TopRight" SizeF="160,15" LocationFloat="6, 25" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="119" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="120" ControlType="XRLabel" Name="label1" Multiline="true" Text="label1" SizeF="450,23" LocationFloat="0, 2" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="121" Expression="[tbParametrosEmpresa.DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
            </Item11>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="122" Expression="(([tbSistemaTiposDocumento_Tipo] = ''''CmpFinanceiro'''' or &#xA;[tbSistemaTiposDocumento_Tipo] = ''''CmpTransporte'''') And&#xA;([TipoFiscal] = ''''FT'''' Or [TipoFiscal] = ''''FR'''' Or &#xA;[TipoFiscal] = ''''FS'''' Or [TipoFiscal] = ''''NC'''' Or &#xA;[TipoFiscal] = ''''ND'''' Or [TipoFiscal] = ''''NF'''' Or &#xA;[TipoFiscal] = ''''GR'''' Or [TipoFiscal] = ''''GT''''))" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item3>
        <Item4 Ref="123" ControlType="SubBand" Name="sbValoriza" HeightF="26" Visible="false">
          <Controls>
            <Item1 Ref="124" ControlType="XRLabel" Name="lblArtigo" Text="Artigo" TextAlignment="TopLeft" SizeF="52.09093,13" LocationFloat="0, 9.999974" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="125" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="126" ControlType="XRLabel" Name="lblDesconto1" Text="% D1" TextAlignment="TopRight" SizeF="39.16687,13" LocationFloat="568.7189, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="127" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="128" ControlType="XRLabel" Name="lblDesconto2" Text="% D2" TextAlignment="TopRight" SizeF="39.02051,13" LocationFloat="609.921, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="129" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="130" ControlType="XRLabel" Name="lblLocalizacao" Text="Local " TextAlignment="TopLeft" SizeF="51.64383,13" LocationFloat="395.4805, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Local ">
              <StylePriority Ref="131" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="132" ControlType="XRLine" Name="XrLine1" SizeF="745.41,2.252249" LocationFloat="1, 23.41446" />
            <Item6 Ref="133" ControlType="XRLabel" Name="lblIvaLinha" Text="% Iva" TextAlignment="TopRight" SizeF="42.28259,13" LocationFloat="704.1368, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="134" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="135" ControlType="XRLabel" Name="lblTotalFinal" Text="Total" TextAlignment="TopRight" SizeF="51.19525,13" LocationFloat="649.9416, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="136" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="137" ControlType="XRLabel" Name="lblPreco" Text="Preço" TextAlignment="TopRight" SizeF="49.06677,13" LocationFloat="519.652, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="138" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="139" ControlType="XRLabel" Name="lblQuantidade" Text="Qtd." TextAlignment="TopRight" SizeF="40.20905,13" LocationFloat="452.9174, 9.999978" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="140" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="141" ControlType="XRLabel" Name="lblDescricao" Text="Descrição" TextAlignment="TopLeft" SizeF="178.8246,13" LocationFloat="52.09093, 10" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="142" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="143" ControlType="XRLabel" Name="lblDocOrigem" Text="D.Origem" TextAlignment="TopLeft" SizeF="46.62386,13" LocationFloat="230.9156, 10.41446" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="144" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item11>
            <Item12 Ref="145" ControlType="XRLabel" Name="lblLote" Text="Lote" TextAlignment="TopLeft" SizeF="53.84052,13" LocationFloat="286.9375, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="146" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item12>
            <Item13 Ref="147" ControlType="XRLabel" Name="lblArmazem" Text="Armz." TextAlignment="TopLeft" SizeF="50.43265,13" LocationFloat="341.778, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Armazem">
              <StylePriority Ref="148" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item13>
            <Item14 Ref="149" ControlType="XRLabel" Name="lblUni" Text="Uni." TextAlignment="TopRight" SizeF="26.29852,13" LocationFloat="493.1264, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="150" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item14>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="151" Expression="iif( not [tbTiposDocumento_DocNaoValorizado] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item4>
        <Item5 Ref="152" ControlType="SubBand" Name="sbNaoValoriza" HeightF="31" Visible="false">
          <Controls>
            <Item1 Ref="153" ControlType="XRLabel" Name="lblDocOrigem1" Text="D.Origem" TextAlignment="TopLeft" SizeF="51.04167,13" LocationFloat="344.4388, 10.00454" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="154" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="155" ControlType="XRLabel" Name="lblArtigo1" Text="Artigo" TextAlignment="TopLeft" SizeF="52.09093,13" LocationFloat="0, 10.00455" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="156" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="157" ControlType="XRLabel" Name="lblLocalizacao1" Text="Local " TextAlignment="TopLeft" SizeF="82.2226,13" LocationFloat="566.7189, 9.999935" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Local ">
              <StylePriority Ref="158" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="159" ControlType="XRLine" Name="XrLine3" SizeF="743.06,2.89" LocationFloat="2.001254, 28.04394" />
            <Item5 Ref="160" ControlType="XRLabel" Name="lblUni1" Text="Uni." TextAlignment="TopRight" SizeF="45.84589,13.00453" LocationFloat="703.1369, 9.995429" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="161" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="162" ControlType="XRLabel" Name="lblQuantidade1" Text="Qtd." TextAlignment="TopRight" SizeF="52.19537,13" LocationFloat="650.9415, 9.999943" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="163" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="164" ControlType="XRLabel" Name="lblDescricao1" Text="Descrição" TextAlignment="TopLeft" SizeF="267.3478,13" LocationFloat="77.09093, 10.00455" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="165" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="166" ControlType="XRLabel" Name="lblLote1" Text="Lote" TextAlignment="TopLeft" SizeF="83.68509,13" LocationFloat="395.4805, 9.99543" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="167" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="168" ControlType="XRLabel" Name="lblArmazem1" Text="Armazem" TextAlignment="TopLeft" SizeF="81.96033,13" LocationFloat="482.4602, 9.995436" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Armazem">
              <StylePriority Ref="169" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="170" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item5>
        <Item6 Ref="171" ControlType="SubBand" Name="SubBand9" HeightF="23">
          <Controls>
            <Item1 Ref="172" ControlType="XRLabel" Name="lblTransporte" TextFormatString="{0:0.00}" TextAlignment="MiddleLeft" SizeF="187.58,12" LocationFloat="552.2, 5" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <Scripts Ref="173" OnSummaryGetResult="lblTransporte_SummaryGetResult" OnPrintOnPage="lblTransporte_PrintOnPage" />
              <Summary Ref="174" Running="Page" IgnoreNullValues="true" />
              <StylePriority Ref="175" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="176" ControlType="XRLabel" Name="lblTituloTransporte" Text="Transporte" TextAlignment="MiddleRight" SizeF="78.96,12" LocationFloat="472.2, 5" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <Scripts Ref="177" OnPrintOnPage="lblTituloTransporte_PrintOnPage" />
              <StylePriority Ref="178" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
          </Controls>
        </Item6>
      </SubBands>
    </Item3>
    <Item4 Ref="179" ControlType="DetailBand" Name="Detail" KeepTogetherWithDetailReports="true" SnapLinePadding="0,0,0,0,100" HeightF="0" KeepTogether="true" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="180" ControlType="DetailReportBand" Name="DRValorizado" Level="0" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosCompras" DataSource="#Ref-0" Visible="false">
      <Bands>
        <Item1 Ref="181" ControlType="DetailBand" Name="Detail2" HeightF="13.87496" KeepTogether="true">
          <SubBands>
            <Item1 Ref="182" ControlType="SubBand" Name="SubBandValorizado" HeightF="2.083333">
              <Controls>
                <Item1 Ref="183" ControlType="XRSubreport" Name="sbrValorizado" ReportSourceUrl="30000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="0, 0">
                  <ParameterBindings>
                    <Item1 Ref="184" ParameterName="IDDocumento" Parameter="#Ref-4" />
                    <Item2 Ref="185" ParameterName="IDLinha" DataMember="tbDocumentosCompras.tbDocumentosComprasLinhas_ID" />
                    <Item3 Ref="186" ParameterName="CasasDecimais" DataMember="tbDocumentosCompras.NumCasasDecUnidade" />
                    <Item4 Ref="187" ParameterName="CasasMoedas" DataMember="tbDocumentosCompras.tbMoedas_CasasDecimaisTotais" />
                    <Item5 Ref="188" ParameterName="SimboloMoedas" Parameter="#Ref-20" />
                    <Item6 Ref="189" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                    <Item7 Ref="190" ParameterName="CasasDecimaisPrecosUnit" DataMember="tbDocumentosCompras.tbMoedas_CasasDecimaisPrecosUnitarios" />
                  </ParameterBindings>
                </Item1>
              </Controls>
            </Item1>
          </SubBands>
          <Controls>
            <Item1 Ref="191" ControlType="XRLabel" Name="fldRunningSum" TextFormatString="{0:0.00}" CanGrow="false" CanShrink="true" SizeF="2,2" LocationFloat="0, 0" ForeColor="Black" Padding="0,0,0,0,100">
              <Scripts Ref="192" OnSummaryCalculated="fldRunningSum_SummaryCalculated" />
              <Summary Ref="193" Running="Page" IgnoreNullValues="true" />
              <ExpressionBindings>
                <Item1 Ref="194" Expression="sumRunningSum([PrecoTotal])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="195" UseForeColor="false" UsePadding="false" />
            </Item1>
            <Item2 Ref="196" ControlType="XRLabel" Name="XrLabel8" Text="XrLabel8" SizeF="55.0218,11.99999" LocationFloat="231.9156, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="197" Expression="[DocumentoOrigem]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="198" UseFont="false" />
            </Item2>
            <Item3 Ref="199" ControlType="XRLabel" Name="fldDesconto2" Text="fldDesconto2" TextAlignment="TopRight" SizeF="39.11041,12.1827" LocationFloat="609.8311, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="200" Expression="FormatString(''''{0:n'''' + 2 + ''''}'''', [Desconto2])&#xA;" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="201" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="202" ControlType="XRLabel" Name="fldDesconto1" Text="fldDesconto1" TextAlignment="TopRight" SizeF="40.16681,12.1827" LocationFloat="568.7189, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="203" Expression="FormatString(''''{0:n'''' + 2 + ''''}'''', [Desconto1])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="204" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="205" ControlType="XRLabel" Name="XrLabel1" Text="XrLabel1" SizeF="179.8247,12.99998" LocationFloat="52.09093, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="206" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="207" UseFont="false" />
            </Item5>
            <Item6 Ref="208" ControlType="XRLabel" Name="fldLocalizacaoValoriza" TextAlignment="TopLeft" SizeF="51.64383,12.99998" LocationFloat="395.4805, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="209" Expression="Iif( IsNullOrEmpty([tbArmazensLocalizacoes_Codigo]) , [tbArmazensLocalizacoes1_Codigo] , [tbArmazensLocalizacoes_Codigo]) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="210" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="211" ControlType="XRLabel" Name="fldArmazemValoriza" TextAlignment="TopLeft" SizeF="50.43265,12.99998" LocationFloat="341.778, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="212" Expression="Iif (IsNullOrEmpty([tbArmazens_Codigo]), [tbArmazens1_CodigoDestino] , [tbArmazens_Codigo])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="213" UseFont="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="214" ControlType="XRLabel" Name="XrLabel40" Text="XrLabel40" TextAlignment="TopRight" SizeF="26.29852,12.99998" LocationFloat="493.1264, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="215" Expression="[CodigoUnidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="216" UseFont="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="217" ControlType="XRLabel" Name="fldCodigoLote" Text="fldCodigoLote" SizeF="54.84055,12.99998" LocationFloat="286.9375, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="218" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="219" UseFont="false" />
            </Item9>
            <Item10 Ref="220" ControlType="XRLabel" Name="fldTaxaIVA" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="49.53473,12.99998" LocationFloat="699.09, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="221" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisIva] ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisIva]  + ''''}'''', [TaxaIva])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="222" UseFont="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="223" ControlType="XRLabel" Name="fldPreco" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="48.06677,12.99998" LocationFloat="518.652, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="224" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisPrecosUnitarios]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisPrecosUnitarios] + ''''}'''', [PrecoUnitario])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="225" UseFont="false" UseTextAlignment="false" />
            </Item11>
            <Item12 Ref="226" ControlType="XRLabel" Name="fldTotalFinal" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="50.41821,12.99998" LocationFloat="649.7188, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="227" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais] ), 0 , FormatString(''''{0:n'''' +  [tbMoedas_CasasDecimaisTotais]  + ''''}'''', [PrecoTotal])) &#xA;" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="228" UseFont="false" UseTextAlignment="false" />
            </Item12>
            <Item13 Ref="229" ControlType="XRLabel" Name="fldQuantidade" TextAlignment="TopRight" SizeF="46.00211,12.99998" LocationFloat="447.1243, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="230" Expression="[Quantidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="231" UseFont="false" UseTextAlignment="false" />
            </Item13>
            <Item14 Ref="232" ControlType="XRLabel" Name="fldArtigo" Text="XrLabel1" SizeF="51.06964,12.99998" LocationFloat="1.02129, 0" Font="Arial, 6.75pt" ForeColor="Black" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="233" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="234" UseFont="false" UseForeColor="false" />
            </Item14>
          </Controls>
        </Item1>
      </Bands>
      <ExpressionBindings>
        <Item1 Ref="235" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
      </ExpressionBindings>
    </Item5>
    <Item6 Ref="236" ControlType="DetailReportBand" Name="DRNaoValorizado" Level="1" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosCompras" DataSource="#Ref-0" Visible="false">
      <Bands>
        <Item1 Ref="237" ControlType="DetailBand" Name="Detail3" HeightF="17.12497" KeepTogether="true">
          <SubBands>
            <Item1 Ref="238" ControlType="SubBand" Name="SubBandNaoValorizado" HeightF="2.083333">
              <Controls>
                <Item1 Ref="239" ControlType="XRSubreport" Name="sbrNaoValorizado" ReportSourceUrl="40000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="1.351293, 0">
                  <ParameterBindings>
                    <Item1 Ref="240" ParameterName="IDDocumento" Parameter="#Ref-4" />
                    <Item2 Ref="241" ParameterName="IDLinha" DataMember="tbDocumentosCompras.tbDocumentosComprasLinhas_ID" />
                    <Item3 Ref="242" ParameterName="CasasDecimais" DataMember="tbDocumentosCompras.NumCasasDecUnidade" />
                    <Item4 Ref="243" ParameterName="CasasMoedas" DataMember="tbDocumentosCompras.tbMoedas_CasasDecimaisTotais" />
                    <Item5 Ref="244" ParameterName="SimboloMoedas" Parameter="#Ref-20" />
                    <Item6 Ref="245" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                  </ParameterBindings>
                </Item1>
              </Controls>
            </Item1>
          </SubBands>
          <Controls>
            <Item1 Ref="246" ControlType="XRLabel" Name="XrLabel9" Text="XrLabel8" SizeF="51.04166,12.99994" LocationFloat="355.2106, 2.04168" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="247" Expression="[DocumentoOrigem]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="248" UseFont="false" />
            </Item1>
            <Item2 Ref="249" ControlType="XRLabel" Name="fldCodigoLote1" Text="fldCodigoLote" SizeF="71.91321,12.99998" LocationFloat="406.2523, 2.041681" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="250" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="251" UseFont="false" />
            </Item2>
            <Item3 Ref="252" ControlType="XRLabel" Name="XrLabel2" Text="XrLabel2" SizeF="278.1197,13.04158" LocationFloat="77.09093, 2.000046" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="253" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="254" UseFont="false" />
            </Item3>
            <Item4 Ref="255" ControlType="XRLabel" Name="fldLocalizacao1Valoriza" SizeF="82.2226,14.04165" LocationFloat="566.7189, 1.999977" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="256" Expression="Iif( IsNullOrEmpty([tbArmazensLocalizacoes_Codigo]) , [tbArmazensLocalizacoes1_Codigo] , [tbArmazensLocalizacoes_Codigo]) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="257" UseFont="false" />
            </Item4>
            <Item5 Ref="258" ControlType="XRLabel" Name="fldArtigo1" Text="XrLabel1" SizeF="76.0909,14.04165" LocationFloat="1.000023, 1.999982" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="259" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="260" UseFont="false" />
            </Item5>
            <Item6 Ref="261" ControlType="XRLabel" Name="fldQuantidade2" Text="XrLabel3" TextAlignment="TopRight" SizeF="52.41803,14.04165" LocationFloat="650.7188, 2" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="262" Expression="[Quantidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="263" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="264" ControlType="XRLabel" Name="fldUnidade" Text="XrLabel40" TextAlignment="TopRight" SizeF="45.86334,14.04165" LocationFloat="704.1367, 2" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="265" Expression="[CodigoUnidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="266" UseFont="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="267" ControlType="XRLabel" Name="fldArmazem1Valoriza" SizeF="81.96033,14.04165" LocationFloat="482.4602, 1.999977" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="268" Expression="Iif (IsNullOrEmpty([tbArmazens_Codigo]), [tbArmazens1_CodigoDestino] , [tbArmazens_Codigo])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="269" UseFont="false" />
            </Item8>
          </Controls>
        </Item1>
      </Bands>
      <ExpressionBindings>
        <Item1 Ref="270" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
      </ExpressionBindings>
    </Item6>
    <Item7 Ref="271" ControlType="ReportFooterBand" Name="ReportFooter" PrintAtBottom="true" HeightF="77.63" KeepTogether="true">
      <SubBands>
        <Item1 Ref="272" ControlType="SubBand" Name="SubBand2" HeightF="66.25" KeepTogether="true">
          <Controls>
            <Item1 Ref="273" ControlType="XRLine" Name="XrLine4" SizeF="746.98,2.041214" LocationFloat="0, 0" />
            <Item2 Ref="274" ControlType="XRSubreport" Name="XrSubreport3" ReportSourceUrl="20000" SizeF="445.76,60.00002" LocationFloat="2.32, 4.16">
              <ParameterBindings>
                <Item1 Ref="275" ParameterName="IDDocumento" Parameter="#Ref-4" />
                <Item2 Ref="276" ParameterName="Culture" Parameter="#Ref-6" />
                <Item3 Ref="277" ParameterName="BDEmpresa" Parameter="#Ref-8" />
              </ParameterBindings>
            </Item2>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="278" Expression="iif([tbTiposDocumento_DocNaoValorizado], false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item1>
        <Item2 Ref="279" ControlType="SubBand" Name="SubBand4" HeightF="27.58" KeepTogether="true">
          <Controls>
            <Item1 Ref="280" ControlType="XRLabel" Name="lblCopia2" TextAlignment="MiddleRight" SizeF="433.068,13" LocationFloat="310.99, 0" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="281" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="282" ControlType="XRLabel" Name="fldMensagemDocAT" TextAlignment="MiddleRight" SizeF="433.068,13" LocationFloat="311, 12.5" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="283" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="284" ControlType="XRLabel" Name="fldassinaturanaoval" TextAlignment="MiddleLeft" SizeF="517.0739,13" LocationFloat="0, 12.5" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="285" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="286" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item2>
        <Item3 Ref="287" ControlType="SubBand" Name="SubBand6" HeightF="53.52" KeepTogether="true">
          <Controls>
            <Item1 Ref="288" ControlType="XRLine" Name="XrLine9" SizeF="738.94,2.08" LocationFloat="0, 0" Padding="0,0,0,0,100">
              <StylePriority Ref="289" UsePadding="false" />
            </Item1>
            <Item2 Ref="290" ControlType="XRLabel" Name="lblCarga" Text="Carga" TextAlignment="TopLeft" SizeF="200,12" LocationFloat="1.34, 3.44" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Carga">
              <StylePriority Ref="291" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="292" ControlType="XRLabel" Name="lblDescarga" Text="Descarga" TextAlignment="TopLeft" SizeF="200,12" LocationFloat="201.96, 3.44" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Descarga">
              <StylePriority Ref="293" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="294" ControlType="XRLabel" Name="lblExpedicao" Text="Matrícula" TextAlignment="TopLeft" SizeF="121.83,12" LocationFloat="403.21, 3.44" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Espedicao">
              <StylePriority Ref="295" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="296" ControlType="XRLabel" Name="XrLabel30" Text="XrLabel12" SizeF="121.83,12" LocationFloat="403.21, 15.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="297" Expression="[Matricula]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="298" UseFont="false" />
            </Item5>
            <Item6 Ref="299" ControlType="XRLabel" Name="XrLabel41" Text="XrLabel11" SizeF="200,12" LocationFloat="201.96, 15.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="300" Expression="[MoradaDescarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="301" UseFont="false" />
            </Item6>
            <Item7 Ref="302" ControlType="XRLabel" Name="XrLabel42" Text="XrLabel5" SizeF="200,12" LocationFloat="1.34, 15.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="303" Expression="[MoradaCarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="304" UseFont="false" />
            </Item7>
            <Item8 Ref="305" ControlType="XRLabel" Name="fldCodigoPostalCarga" Text="fldCodigoPostalCarga" SizeF="200,12" LocationFloat="1.34, 27.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="306" Expression="[tbCodigosPostaisCarga_Codigo] + '''' '''' + [tbCodigosPostaisCarga_Descricao] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="307" UseFont="false" />
            </Item8>
            <Item9 Ref="308" ControlType="XRLabel" Name="fldDataCarga" TextFormatString="{0:dd-MM-yyyy HH:mm}" SizeF="200,12" LocationFloat="1.34, 39.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="309" Expression="[DataCarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="310" UseFont="false" />
            </Item9>
            <Item10 Ref="311" ControlType="XRLabel" Name="fldCodigoPostalDescarga" Text="fldCodigoPostalDescarga" SizeF="200,12" LocationFloat="201.97, 27.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="312" Expression="[tbCodigosPostaisDescarga_Codigo] + '''' '''' + [tbCodigosPostaisDescarga_Descricao] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="313" UseFont="false" />
            </Item10>
            <Item11 Ref="314" ControlType="XRLabel" Name="fldDataDescarga" TextFormatString="{0:dd-MM-yyyy HH:mm}" SizeF="200,12" LocationFloat="201.96, 39.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="315" Expression="[DataDescarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="316" UseFont="false" />
            </Item11>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="317" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item3>
        <Item4 Ref="318" ControlType="SubBand" Name="SubBand7" HeightF="36.96" KeepTogether="true">
          <Controls>
            <Item1 Ref="319" ControlType="XRLine" Name="XrLine8" SizeF="738.94,2.08" LocationFloat="0, 3.17" />
            <Item2 Ref="320" ControlType="XRLabel" Name="lblObservacoes" Text="Observações" TextAlignment="MiddleLeft" SizeF="90.12,12" LocationFloat="0, 5.17" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
              <StylePriority Ref="321" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="322" ControlType="XRLabel" Name="fldObservacoes" Multiline="true" TextAlignment="TopLeft" SizeF="742.9999,18.19" LocationFloat="0, 16.69" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
              <ExpressionBindings>
                <Item1 Ref="323" Expression="[Observacoes] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="324" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
          </Controls>
        </Item4>
      </SubBands>
      <Controls>
        <Item1 Ref="325" ControlType="XRLabel" Name="lblCopia1" TextAlignment="MiddleRight" SizeF="433.068,13" LocationFloat="310.99, 1.75" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="326" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="327" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="328" ControlType="XRLabel" Name="lblTotalMoedaDocumento" TextAlignment="TopRight" SizeF="121.383,17" LocationFloat="617.57, 31.95" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="329" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="330" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="331" ControlType="XRLabel" Name="fldDescontosLinha" TextAlignment="TopRight" SizeF="87.00002,20.9583" LocationFloat="288.18, 48.95" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="332" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisTotais] ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais]  + ''''}'''', [ValorDescontoLinha_Sum])) &#xA;" PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="333" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="334" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="335" ControlType="XRLabel" Name="fldDescontoGlobal" TextAlignment="TopRight" SizeF="87.00002,20.96" LocationFloat="376.18, 48.95" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="336" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais] ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais]  + ''''}'''', [ValorDesconto])) &#xA;" PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="337" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="338" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="339" ControlType="XRLabel" Name="fldTotalIva" TextFormatString="{0:€0.00}" TextAlignment="TopRight" SizeF="85.80151,20.9583" LocationFloat="465.38, 48.95" Font="Arial, 6.75pt" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="340" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisIva]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisIva] + ''''}'''', [ValorImposto])) " PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="341" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="342" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="343" ControlType="XRLabel" Name="fldTotalMoedaDocumento" TextAlignment="TopRight" SizeF="176.209,25.59814" LocationFloat="562.75, 48.95" Font="Arial, 14.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="344" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisTotais]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [TotalMoedaDocumento])) " PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="345" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="346" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="347" ControlType="XRLabel" Name="fldSubTotal" TextFormatString="{0:€0.00}" TextAlignment="TopRight" SizeF="87.25985,20.95646" LocationFloat="199.92, 54.16" Font="Arial, 6.75pt" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="348" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisTotais]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [SubTotal])) " PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="349" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="350" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="351" ControlType="XRLabel" Name="XrLabel4" SizeF="190,46" LocationFloat="555.07, 29.55" BackColor="Gainsboro" Padding="2,2,0,0,100" Borders="None" BorderWidth="1">
          <ExpressionBindings>
            <Item1 Ref="352" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="353" UseBackColor="false" UseBorders="false" UseBorderWidth="false" />
        </Item8>
        <Item9 Ref="354" ControlType="XRLabel" Name="lblDescontosLinha" TextAlignment="TopRight" SizeF="87.25985,16" LocationFloat="287.92, 31.95" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="355" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="356" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item9>
        <Item10 Ref="357" ControlType="XRLabel" Name="lblDescontoGlobal" TextAlignment="TopRight" SizeF="87.25984,16" LocationFloat="375.92, 31.95" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="358" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="359" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item10>
        <Item11 Ref="360" ControlType="XRLabel" Name="lblTotalIva" TextAlignment="TopRight" SizeF="86.80161,15.99816" LocationFloat="464.38, 31.95" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="361" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="362" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item11>
        <Item12 Ref="363" ControlType="XRLabel" Name="lblSubTotal" TextAlignment="TopRight" SizeF="87.75003,16" LocationFloat="199.43, 37.16" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="364" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="365" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="366" ControlType="XRLine" Name="XrLine5" SizeF="747.0004,2" LocationFloat="0, 27.56">
          <ExpressionBindings>
            <Item1 Ref="367" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item13>
        <Item14 Ref="368" ControlType="XRLabel" Name="fldMensagemDocAT1" TextAlignment="MiddleRight" SizeF="433.068,13" LocationFloat="311.99, 14.56" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="369" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="370" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item14>
        <Item15 Ref="371" ControlType="XRLabel" Name="fldAssinatura" TextAlignment="MiddleLeft" SizeF="433.1161,13" LocationFloat="0, 14.56" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="372" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="373" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item15>
      </Controls>
    </Item7>
    <Item8 Ref="374" ControlType="PageFooterBand" Name="PageFooter" HeightF="38.33">
      <SubBands>
        <Item1 Ref="375" ControlType="SubBand" Name="SubBand3" HeightF="19.08">
          <Controls>
            <Item1 Ref="376" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="742.98,4" LocationFloat="0, 0" BorderWidth="3">
              <StylePriority Ref="377" UseBorderWidth="false" />
            </Item1>
            <Item2 Ref="378" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="625.4193, 4.000028" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="379" UseFont="false" UseTextAlignment="false" />
            </Item2>
          </Controls>
        </Item1>
      </SubBands>
      <Controls>
        <Item1 Ref="380" ControlType="XRLabel" Name="lblCopia3" TextAlignment="MiddleRight" SizeF="445.7733,13" LocationFloat="300.64, 11.61" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="381" OnPrintOnPage="fldAssinatura11_PrintOnPage" />
          <StylePriority Ref="382" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="383" ControlType="XRLabel" Name="lblTransportar" TextFormatString="{0:0.00}" TextAlignment="MiddleLeft" SizeF="187.58,12" LocationFloat="552.2, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <Scripts Ref="384" OnSummaryGetResult="lblTransportar_SummaryGetResult" OnPrintOnPage="lblTransportar_PrintOnPage" />
          <Summary Ref="385" Running="Page" IgnoreNullValues="true" />
          <StylePriority Ref="386" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="387" ControlType="XRLabel" Name="lblTituloTransportar" Text="Transportar" TextAlignment="MiddleRight" SizeF="78.96,12" LocationFloat="472.2, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="388" OnPrintOnPage="lblTituloTransportar_PrintOnPage" />
          <StylePriority Ref="389" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="390" ControlType="XRLabel" Name="fldAssinatura11" TextAlignment="MiddleRight" SizeF="445.7733,13" LocationFloat="300.646, 24.7" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="391" OnPrintOnPage="fldAssinatura11_PrintOnPage" />
          <StylePriority Ref="392" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="393" ControlType="XRLabel" Name="fldAssinatura1" TextAlignment="MiddleLeft" SizeF="445.7733,13" LocationFloat="1.351039, 24.7" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="394" OnPrintOnPage="fldAssinatura1_PrintOnPage" />
          <StylePriority Ref="395" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
      </Controls>
    </Item8>
    <Item9 Ref="396" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="1" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="397" OnBeforePrint="Documentos_Compras_BeforePrint" />
  <ExportOptions Ref="398">
    <Html Ref="399" ExportMode="SingleFilePageByPage" />
  </ExportOptions>
  <Watermark Ref="400" ShowBehind="false" Text="CONFIDENTIAL" Font="Arial, 96pt" />
  <ExpressionBindings>
    <Item1 Ref="401" Expression="([tbSistemaTiposDocumento_Tipo] != ''''CmpFinanceiro''''  And &#xA;([TipoFiscal] != ''''FT'''' Or [TipoFiscal] != ''''FR'''' Or &#xA;[TipoFiscal] != ''''FS'''' Or [TipoFiscal] != ''''NC'''' Or &#xA;[TipoFiscal] != ''''ND'''')) Or &#xA;([tbSistemaTiposDocumento_Tipo] != ''''CmpTransporte''''  And &#xA;([TipoFiscal] != ''''NF'''' Or [TipoFiscal] != ''''GR'''' Or &#xA;[TipoFiscal] != ''''GT''''))" PropertyName="Visible" EventName="BeforePrint" />
  </ExpressionBindings>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="10" Content="System.Int32" Type="System.Type" />
    <Item3 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="14" Content="System.Boolean" Type="System.Type" />
    <Item4 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="17" Content="System.Int16" Type="System.Type" />
    <Item5 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMDE1XEYzTTIwMTc7VXNlciBJRD1GM01TR1A7UGFzc3dvcmQ9O0luaXRpYWwgQ2F0YWxvZyA9OTk5OUYzTVNHUFFBVFNUTUFOOyIgLz48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXMiPjxQYXJhbWV0ZXIgTmFtZT0iSUREb2N1bWVudG8iIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKD9JRERvY3VtZW50byk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCBkaXN0aW5jdCAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9Eb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhRG9jdW1lbnRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iT2JzZXJ2YWNvZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGF4YUNvbnZlcnNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRvdGFsTW9lZGFEb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhUmVmZXJlbmNpYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkxvY2FsQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJIb3JhQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFDYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJMb2NhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSG9yYURlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW9yYWRhRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZURlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYURlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9EZXN0aW5hdGFyaW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZXJpZURvY01hbnVhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0RvY01hbnVhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0xpbmhhcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBvc3RvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJVdGlsaXphZG9yRXN0YWRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUhvcmFFc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBc3NpbmF0dXJhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmVyc2FvQ2hhdmVQcml2YWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZUZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYUZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRmlzY2FsIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9GaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb250cmlidWludGVGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvamEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJbXByZXNzbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9ySW1wb3N0byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBlcmNlbnRhZ2VtRGVzY29udG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWYWxvckRlc2NvbnRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRheGFJdmFQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUYXhhSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW90aXZvSXNlbmNhb0l2YSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vdGl2b0lzZW5jYW9Qb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbFBvcnRlcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkVzcGFjb0Zpc2NhbFBvcnRlcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iUmVnaW1lSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ3VzdG9zQWRpY2lvbmFpcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpc3RlbWEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBdGl2byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDcmlhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckNyaWFjYW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQWx0ZXJhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkYzTU1hcmNhZG9yIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURGb3JtYUV4cGVkaWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9JbnRlcm5vIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFbnRpZGFkZSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb0VudGlkYWRlIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25kaWNhb1BhZ2FtZW50byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETG9jYWxPcGVyYWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0FUIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURQYWlzQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFBhaXNEZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1hdHJpY3VsYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbEZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGVzY3JpY2FvRGlzdHJpdG9GaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvQVRJbnRlcm5vIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGlwb0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY3VtZW50byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1RpcG9Fc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Eb2NPcmlnZW0iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9DYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbENhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9EZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29FbnRpZGFkZSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb01vZWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTWVuc2FnZW1Eb2NBVCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEU2lzVGlwb3NEb2NQVSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Npc1RpcG9zRG9jUFUiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NNYW51YWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NSZXBvc2ljYW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQXNzaW5hdHVyYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDb250cm9sb0ludGVybm8iLA0KCSJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURvY3VtZW50byIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29UaXBvRXN0YWRvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNlZ3VuZGFWaWEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRCIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfSUQiLA0KCSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9yZGVtIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklERG9jdW1lbnRvQ29tcHJhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJ0aWdvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIkRlc2NyaWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRFVuaWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iTnVtQ2FzYXNEZWNVbmlkYWRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlF1YW50aWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iUHJlY29Vbml0YXJpbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJQcmVjb1VuaXRhcmlvRWZldGl2byIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJQcmVjb1RvdGFsIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9ic2VydmFjb2VzIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19PYnNlcnZhY29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRExvdGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQ29kaWdvTG90ZSIsDQoJICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQ29kaWdvVW5pZGFkZSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEZXNjcmljYW9Mb3RlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIkRhdGFGYWJyaWNvTG90ZSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEYXRhVmFsaWRhZGVMb3RlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJ0aWdvTnVtU2VyaWUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQXJ0aWdvTnVtU2VyaWUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbUxvY2FsaXphY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbURlc3Rpbm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtTG9jYWxpemFjYW9EZXN0aW5vIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk51bUxpbmhhc0RpbWVuc29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEZXNjb250bzEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGVzY29udG8yIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEVGF4YUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJUYXhhSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk1vdGl2b0lzZW5jYW9JdmEiIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX01vdGl2b0lzZW5jYW9JdmEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURFc3BhY29GaXNjYWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRXNwYWNvRmlzY2FsIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEUmVnaW1lSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlJlZ2ltZUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJTaWdsYVBhaXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iT3JkZW0iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iU2lzdGVtYSIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfU2lzdGVtYSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJBdGl2byIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfQXRpdm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGF0YUNyaWFjYW8iIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0RhdGFDcmlhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlV0aWxpemFkb3JDcmlhY2FvIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19VdGlsaXphZG9yQ3JpYWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEYXRhQWx0ZXJhY2FvIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQWx0ZXJhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlV0aWxpemFkb3JBbHRlcmFjYW8iIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX1V0aWxpemFkb3JBbHRlcmFjYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRjNNTWFyY2Fkb3IiIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0YzTU1hcmNhZG9yIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlZhbG9ySW5jaWRlbmNpYSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJWYWxvcklWQSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEb2N1bWVudG9PcmlnZW0iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGF0YUVudHJlZ2EiLA0KCSAidGJGb3JuZWNlZG9yZXMiLiJOb21lIiBhcyAidGJGb3JuZWNlZG9yZXNfTm9tZSIsDQoJICJ0YkZvcm5lY2Vkb3JlcyIuIkNvZGlnbyIgYXMgInRiRm9ybmVjZWRvcmVzX0NvZGlnbyIsDQoJICJ0YkZvcm5lY2Vkb3JlcyIuIk5Db250cmlidWludGUiIGFzICJ0YkZvcm5lY2Vkb3Jlc19OQ29udHJpYnVpbnRlIiwNCgkgInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIk1vcmFkYSIgYXMgInRiRm9ybmVjZWRvcmVzTW9yYWRhc19Nb3JhZGEiLA0KCSAidGJDb2RpZ29zUG9zdGFpcyIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0NvZGlnbyIsDQoJICJ0YkNvZGlnb3NQb3N0YWlzIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiwNCiAgICAgICAidGJFc3RhZG9zIi4iQ29kaWdvIiBhcyAidGJFc3RhZG9zX0NvZGlnbyIsDQogICAgICAgInRiRXN0YWRvcyIuIkRlc2NyaWNhbyIgYXMgInRiRXN0YWRvc19EZXNjcmljYW8iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iQ29kaWdvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Db2RpZ28iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KCSAidGJUaXBvc0RvY3VtZW50byIuIkRvY05hb1ZhbG9yaXphZG8iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0RvY05hb1ZhbG9yaXphZG8iLA0KCSAidGJUaXBvc0RvY3VtZW50byIuIkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJEZXNjcmljYW9TZXJpZSIsDQogICAgICAgInRiQXJ0aWdvcyIuIkNvZGlnbyIgYXMgInRiQXJ0aWdvc19Db2RpZ28iLA0KICAgICAgICJ0YkFydGlnb3MiLiJEZXNjcmljYW9BYnJldmlhZGEiLA0KICAgICAgICJ0YkFydGlnb3MiLiJEZXNjcmljYW8iIGFzICJ0YkFydGlnb3NfRGVzY3JpY2FvIiwNCiAgICAgICAidGJBcnRpZ29zIi4iR2VyZUxvdGVzIiBhcyAidGJBcnRpZ29zX0dlcmVMb3RlcyIsDQogICAgICAgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiwNCgkgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iVGlwbyIgYXMgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iLA0KCSAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KICAgICAgICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIlRpcG8iLA0KICAgICAgICJ0YkNvZGlnb3NQb3N0YWlzMSIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNfQ29kaWdvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczEiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMyIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMyIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0Rlc2NyaWNhbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMzIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0NvZGlnbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMzIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJNb2VkYXNfQ29kaWdvIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW8iIGFzICJ0Yk1vZWRhc19EZXNjcmljYW8iLA0KICAgICAgICJ0Yk1vZWRhcyIuIlNpbWJvbG8iIGFzICJ0Yk1vZWRhc19TaW1ib2xvIiwNCgkgInRiQXJtYXplbnMiLiJEZXNjcmljYW8iIGFzICJ0YkFybWF6ZW5zX0Rlc2NyaWNhbyIsDQoJICJ0YkFybWF6ZW5zIi4iQ29kaWdvIiBhcyAidGJBcm1hemVuc19Db2RpZ28iLA0KCSAidGJBcm1hemVuc0xvY2FsaXphY29lcyIuIkRlc2NyaWNhbyIgYXMgInRiQXJtYXplbnNMb2NhbGl6YWNvZXNfRGVzY3JpY2FvIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzX0NvZGlnbyIsDQoJICJ0YkFybWF6ZW5zMSIuIkRlc2NyaWNhbyIgYXMgInRiQXJtYXplbnMxX0Rlc2NyaWNhb0Rlc3Rpbm8iLA0KCSAidGJBcm1hemVuczEiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zMV9Db2RpZ29EZXN0aW5vIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iRGVzY3JpY2FvIiBhcyAidGJBcm1hemVuc0xvY2FsaXphY29lczFfRGVzY3JpY2FvIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iQ29kaWdvIiBhcyAidGJBcm1hemVuc0xvY2FsaXphY29lczFfQ29kaWdvIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiBhcyAidGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIsDQoJICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgYXMgInRiTW9lZGFzX0Nhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiLA0KCSAgICJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNJdmEiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzSXZhIiwNCgkgInRiU2lzdGVtYUNvZGlnb3NJVkEiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFDb2RpZ29zSVZBLkNvZGlnbyIsIA0KICAgICAgICJ0YlNpc3RlbWFNb2VkYXMiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFNb2VkYXNfQ29kaWdvIiwNCgkgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhRG9jdW1lbnRvIiAtICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JJbXBvc3RvIiBhcyAiU3ViVG90YWwiLA0KCSAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgYXMgInRiUGFyYW1lbnRyb3NFbXByZXNhX0Nhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIsDQoJICJ0YlNpc3RlbWFOYXR1cmV6YXMiLkNvZGlnbyBhcyAidGJTaXN0ZW1hTmF0dXJlemFzX0NvZGlnbyINCiAgZnJvbSAiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhcyINCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIg0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIg0KICAgICAgIG9uICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSUREb2N1bWVudG9Db21wcmEiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YklWQSIgInRiSVZBIiBvbiAidGJJVkEiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEVGF4YUl2YSINCiAgbGVmdCBqb2luIHRiU2lzdGVtYUNvZGlnb3NJVkEgb24gdGJJVkEuSURDb2RpZ29JVkEgPSB0YlNpc3RlbWFDb2RpZ29zSVZBLklEDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hVGlwb3NJVkEiICJ0YlNpc3RlbWFUaXBvc0lWQSIgb24gInRiU2lzdGVtYVRpcG9zSVZBIi4iSUQiID0gInRiSVZBIi4iSURUaXBvSXZhIg0KICBsZWZ0IGpvaW4gImRibyIuInRiRm9ybmVjZWRvcmVzIiAidGJGb3JuZWNlZG9yZXMiDQogICAgICAgb24gInRiRm9ybmVjZWRvcmVzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVudGlkYWRlIg0KICBsZWZ0IGpvaW4gImRibyIuICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiDQoJICAgb24gInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIklERm9ybmVjZWRvciIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERW50aWRhZGUiIGFuZCAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iT3JkZW0iPTENCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpcyINCiAgICAgICBvbiAidGJDb2RpZ29zUG9zdGFpcyIuIklEIiA9ICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiLiJJRENvZGlnb1Bvc3RhbCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkVzdGFkb3MiICJ0YkVzdGFkb3MiDQogICAgICAgb24gInRiRXN0YWRvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJUaXBvc0RvY3VtZW50byINCiAgICAgICAidGJUaXBvc0RvY3VtZW50byINCiAgICAgICBvbiAidGJUaXBvc0RvY3VtZW50byIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvRG9jdW1lbnRvIg0KICBsZWZ0IGpvaW4gImRibyIuInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KICAgICAgIG9uICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KCSAgICBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIiAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iDQogICAgICAgb24gInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFUaXBvc0RvY3VtZW50byINCiAgbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIg0KICAgICAgIG9uICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIklEIiA9ICJ0YlRpcG9zRG9jdW1lbnRvIi4iSURTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hTmF0dXJlemFzIiAidGJTaXN0ZW1hTmF0dXJlemFzIg0KICAgICAgIG9uICJ0YlNpc3RlbWFOYXR1cmV6YXMiLiJJRCIgPSAidGJUaXBvc0RvY3VtZW50byIuIklEU2lzdGVtYU5hdHVyZXphcyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFydGlnb3MiICJ0YkFydGlnb3MiDQogICAgICAgb24gInRiQXJ0aWdvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcnRpZ28iDQogIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMxIg0KICAgICAgIG9uICJ0YkNvZGlnb3NQb3N0YWlzMSIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiDQogIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMyIg0KICAgICAgIG9uICJ0YkNvZGlnb3NQb3N0YWlzMiIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczMiDQogICAgICAgb24gInRiQ29kaWdvc1Bvc3RhaXMzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIg0KICBsZWZ0IGpvaW4gImRibyIuInRiTW9lZGFzIiAidGJNb2VkYXMiDQogICAgICAgb24gInRiTW9lZGFzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIg0KICBsZWZ0IGpvaW4gInRiUGFyYW1ldHJvc0VtcHJlc2EiIA0KICAgICAgIG9uICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURNb2VkYURlZmVpdG8iID0gInRiTW9lZGFzIi4iSUQiIA0KICBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYU1vZWRhcyIgInRiU2lzdGVtYU1vZWRhcyINCiAgICAgICBvbiAidGJTaXN0ZW1hTW9lZGFzIi4iSUQiID0gInRiTW9lZGFzIi4iSURTaXN0ZW1hTW9lZGEiDQogIGxlZnQgam9pbiAiZGJvIi4idGJBcm1hemVucyIgInRiQXJtYXplbnMiDQogICAgICAgb24gInRiQXJtYXplbnMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzIiAidGJBcm1hemVuc0xvY2FsaXphY29lcyINCiAgICAgICBvbiAidGJBcm1hemVuc0xvY2FsaXphY29lcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtTG9jYWxpemFjYW8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJBcm1hemVucyIgInRiQXJtYXplbnMxIg0KICAgICAgIG9uICJ0YkFybWF6ZW5zMSIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtRGVzdGlubyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzIiAidGJBcm1hemVuc0xvY2FsaXphY29lczEiDQogICAgICAgb24gInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJREFybWF6ZW1Mb2NhbGl6YWNhb0Rlc3Rpbm8iDQp3aGVyZSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEIj0gQElERG9jdW1lbnRvDQpPcmRlciBieSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9yZGVtIjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IlNlbGVjdFF1ZXJ5IiBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzX0NhYiIgRGlzdGluY3Q9InRydWUiPjxQYXJhbWV0ZXIgTmFtZT0iSWREb2MiIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKD9JRERvY3VtZW50byk8L1BhcmFtZXRlcj48VGFibGVzPjxUYWJsZSBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzIiAvPjxUYWJsZSBOYW1lPSJ0YkZvcm5lY2Vkb3JlcyIgLz48VGFibGUgTmFtZT0idGJGb3JuZWNlZG9yZXNNb3JhZGFzIiAvPjxUYWJsZSBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzIiAvPjxUYWJsZSBOYW1lPSJ0YkVzdGFkb3MiIC8+PFRhYmxlIE5hbWU9InRiVGlwb3NEb2N1bWVudG8iIC8+PFRhYmxlIE5hbWU9InRiVGlwb3NEb2N1bWVudG9TZXJpZXMiIC8+PFRhYmxlIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIiAvPjxUYWJsZSBOYW1lPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIgLz48VGFibGUgTmFtZT0idGJDb2RpZ29zUG9zdGFpcyIgQWxpYXM9InRiQ29kaWdvc1Bvc3RhaXMxIiAvPjxUYWJsZSBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzIiBBbGlhcz0idGJDb2RpZ29zUG9zdGFpczIiIC8+PFRhYmxlIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXMiIEFsaWFzPSJ0YkNvZGlnb3NQb3N0YWlzMyIgLz48VGFibGUgTmFtZT0idGJNb2VkYXMiIC8+PFRhYmxlIE5hbWU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIC8+PFRhYmxlIE5hbWU9InRiU2lzdGVtYU5hdHVyZXphcyIgLz48VGFibGUgTmFtZT0idGJTaXN0ZW1hTW9lZGFzIiAvPjxUYWJsZSBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIiAvPjxSZWxhdGlvbiBUeXBlPSJMZWZ0T3V0ZXIiIFBhcmVudD0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmVzdGVkPSJ0YkZvcm5lY2Vkb3JlcyI+PEtleUNvbHVtbiBQYXJlbnQ9IklERW50aWRhZGUiIE5lc3RlZD0iSUQiIC8+PC9SZWxhdGlvbj48UmVsYXRpb24gVHlwZT0iTGVmdE91dGVyIiBQYXJlbnQ9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5lc3RlZD0idGJGb3JuZWNlZG9yZXNNb3JhZGFzIj48S2V5Q29sdW1uIFBhcmVudD0iSURFbnRpZGFkZSIgTmVzdGVkPSJJREZvcm5lY2Vkb3IiIC8+PC9SZWxhdGlvbj48UmVsYXRpb24gVHlwZT0iTGVmdE91dGVyIiBQYXJlbnQ9InRiRm9ybmVjZWRvcmVzTW9yYWRhcyIgTmVzdGVkPSJ0YkNvZGlnb3NQb3N0YWlzIj48S2V5Q29sdW1uIFBhcmVudD0iSURDb2RpZ29Qb3N0YWwiIE5lc3RlZD0iSUQiIC8+PC9SZWxhdGlvbj48UmVsYXRpb24gVHlwZT0iTGVmdE91dGVyIiBQYXJlbnQ9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5lc3RlZD0idGJFc3RhZG9zIj48S2V5Q29sdW1uIFBhcmVudD0iSURFc3RhZG8iIE5lc3RlZD0iSUQiIC8+PC9SZWxhdGlvbj48UmVsYXRpb24gVHlwZT0iTGVmdE91dGVyIiBQYXJlbnQ9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5lc3RlZD0idGJUaXBvc0RvY3VtZW50byI+PEtleUNvbHVtbiBQYXJlbnQ9IklEVGlwb0RvY3VtZW50byIgTmVzdGVkPSJJRCIgLz48L1JlbGF0aW9uPjxSZWxhdGlvbiBUeXBlPSJMZWZ0T3V0ZXIiIFBhcmVudD0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmVzdGVkPSJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIj48S2V5Q29sdW1uIFBhcmVudD0iSURUaXBvc0RvY3VtZW50b1NlcmllcyIgTmVzdGVkPSJJRCIgLz48L1JlbGF0aW9uPjxSZWxhdGlvbiBUeXBlPSJMZWZ0T3V0ZXIiIFBhcmVudD0idGJUaXBvc0RvY3VtZW50byIgTmVzdGVkPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byI+PEtleUNvbHVtbiBQYXJlbnQ9IklEU2lzdGVtYVRpcG9zRG9jdW1lbnRvIiBOZXN0ZWQ9IklEIiAvPjwvUmVsYXRpb24+PFJlbGF0aW9uIFR5cGU9IkxlZnRPdXRlciIgUGFyZW50PSJ0YlRpcG9zRG9jdW1lbnRvIiBOZXN0ZWQ9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIj48S2V5Q29sdW1uIFBhcmVudD0iSURTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiIE5lc3RlZD0iSUQiIC8+PC9SZWxhdGlvbj48UmVsYXRpb24gVHlwZT0iTGVmdE91dGVyIiBQYXJlbnQ9InRiVGlwb3NEb2N1bWVudG8iIE5lc3RlZD0idGJTaXN0ZW1hTmF0dXJlemFzIj48S2V5Q29sdW1uIFBhcmVudD0iSURTaXN0ZW1hTmF0dXJlemFzIiBOZXN0ZWQ9IklEIiAvPjwvUmVsYXRpb24+PFJlbGF0aW9uIFR5cGU9IkxlZnRPdXRlciIgUGFyZW50PSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOZXN0ZWQ9InRiQ29kaWdvc1Bvc3RhaXMyIj48S2V5Q29sdW1uIFBhcmVudD0iSURDb2RpZ29Qb3N0YWxDYXJnYSIgTmVzdGVkPSJJRCIgLz48L1JlbGF0aW9uPjxSZWxhdGlvbiBUeXBlPSJMZWZ0T3V0ZXIiIFBhcmVudD0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmVzdGVkPSJ0YkNvZGlnb3NQb3N0YWlzMyI+PEtleUNvbHVtbiBQYXJlbnQ9IklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIE5lc3RlZD0iSUQiIC8+PC9SZWxhdGlvbj48UmVsYXRpb24gVHlwZT0iTGVmdE91dGVyIiBQYXJlbnQ9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5lc3RlZD0idGJDb2RpZ29zUG9zdGFpczEiPjxLZXlDb2x1bW4gUGFyZW50PSJJRENvZGlnb1Bvc3RhbEZpc2NhbCIgTmVzdGVkPSJJRCIgLz48L1JlbGF0aW9uPjxSZWxhdGlvbiBUeXBlPSJMZWZ0T3V0ZXIiIFBhcmVudD0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmVzdGVkPSJ0Yk1vZWRhcyI+PEtleUNvbHVtbiBQYXJlbnQ9IklETW9lZGEiIE5lc3RlZD0iSUQiIC8+PC9SZWxhdGlvbj48UmVsYXRpb24gVHlwZT0iTGVmdE91dGVyIiBQYXJlbnQ9InRiTW9lZGFzIiBOZXN0ZWQ9InRiUGFyYW1ldHJvc0VtcHJlc2EiPjxLZXlDb2x1bW4gUGFyZW50PSJJRCIgTmVzdGVkPSJJRE1vZWRhRGVmZWl0byIgLz48L1JlbGF0aW9uPjxSZWxhdGlvbiBUeXBlPSJMZWZ0T3V0ZXIiIFBhcmVudD0idGJNb2VkYXMiIE5lc3RlZD0idGJTaXN0ZW1hTW9lZGFzIj48S2V5Q29sdW1uIFBhcmVudD0iSURTaXN0ZW1hTW9lZGEiIE5lc3RlZD0iSUQiIC8+PC9SZWxhdGlvbj48UmVsYXRpb24gVHlwZT0iTGVmdE91dGVyIiBQYXJlbnQ9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiIE5lc3RlZD0idGJEb2N1bWVudG9zQ29tcHJhcyI+PEtleUNvbHVtbiBQYXJlbnQ9IklERG9jdW1lbnRvQ29tcHJhIiBOZXN0ZWQ9IklEIiAvPjwvUmVsYXRpb24+PC9UYWJsZXM+PENvbHVtbnM+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSUQiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURUaXBvRG9jdW1lbnRvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9Ik51bWVyb0RvY3VtZW50byIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJEYXRhRG9jdW1lbnRvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9Ik9ic2VydmFjb2VzIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklETW9lZGEiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iVGF4YUNvbnZlcnNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJUb3RhbE1vZWRhRG9jdW1lbnRvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlRvdGFsTW9lZGFSZWZlcmVuY2lhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkxvY2FsQ2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRGF0YUNhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkhvcmFDYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJNb3JhZGFDYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRENvZGlnb1Bvc3RhbENhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEQ29uY2VsaG9DYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRERpc3RyaXRvQ2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iTG9jYWxEZXNjYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJEYXRhRGVzY2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSG9yYURlc2NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9Ik1vcmFkYURlc2NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURDb25jZWxob0Rlc2NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklERGlzdHJpdG9EZXNjYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJOb21lRGVzdGluYXRhcmlvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJTZXJpZURvY01hbnVhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJOdW1lcm9Eb2NNYW51YWwiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iTnVtZXJvTGluaGFzIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlBvc3RvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklERXN0YWRvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlV0aWxpemFkb3JFc3RhZG8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRGF0YUhvcmFFc3RhZG8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iQXNzaW5hdHVyYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJWZXJzYW9DaGF2ZVByaXZhZGEiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iTm9tZUZpc2NhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJNb3JhZGFGaXNjYWwiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURDb2RpZ29Qb3N0YWxGaXNjYWwiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSUREaXN0cml0b0Zpc2NhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRENvbmNlbGhvRmlzY2FsIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkNvbnRyaWJ1aW50ZUZpc2NhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJTaWdsYVBhaXNGaXNjYWwiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURMb2phIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkltcHJlc3NvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlZhbG9ySW1wb3N0byIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJQZXJjZW50YWdlbURlc2NvbnRvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlZhbG9yRGVzY29udG8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iVmFsb3JQb3J0ZXMiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURUYXhhSXZhUG9ydGVzIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlRheGFJdmFQb3J0ZXMiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iTW90aXZvSXNlbmNhb0l2YSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklERXNwYWNvRmlzY2FsUG9ydGVzIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkVzcGFjb0Zpc2NhbFBvcnRlcyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRFJlZ2ltZUl2YVBvcnRlcyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJSZWdpbWVJdmFQb3J0ZXMiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iQ3VzdG9zQWRpY2lvbmFpcyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJTaXN0ZW1hIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkF0aXZvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkRhdGFDcmlhY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlV0aWxpemFkb3JDcmlhY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkRhdGFBbHRlcmFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRjNNTWFyY2Fkb3IiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJREZvcm1hRXhwZWRpY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEVGlwb3NEb2N1bWVudG9TZXJpZXMiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iTnVtZXJvSW50ZXJubyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRFRpcG9FbnRpZGFkZSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJREVudGlkYWRlIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEQ29uZGljYW9QYWdhbWVudG8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURMb2NhbE9wZXJhY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkNvZGlnb0FUIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEUGFpc0NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEUGFpc0Rlc2NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9Ik1hdHJpY3VsYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRFBhaXNGaXNjYWwiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iQ29kaWdvUG9zdGFsRmlzY2FsIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJEZXNjcmljYW9Db25jZWxob0Zpc2NhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJEZXNjcmljYW9EaXN0cml0b0Zpc2NhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJREVzcGFjb0Zpc2NhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRFJlZ2ltZUl2YSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJDb2RpZ29BVEludGVybm8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iVGlwb0Zpc2NhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJEb2N1bWVudG8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iQ29kaWdvVGlwb0VzdGFkbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJDb2RpZ29Eb2NPcmlnZW0iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRGlzdHJpdG9DYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJDb25jZWxob0NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkNvZGlnb1Bvc3RhbENhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlNpZ2xhUGFpc0NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkRpc3RyaXRvRGVzY2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iQ29uY2VsaG9EZXNjYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJTaWdsYVBhaXNEZXNjYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJDb2RpZ29FbnRpZGFkZSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJDb2RpZ29Nb2VkYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJNZW5zYWdlbURvY0FUIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEU2lzVGlwb3NEb2NQVSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJDb2RpZ29TaXNUaXBvc0RvY1BVIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkRvY01hbnVhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJEb2NSZXBvc2ljYW8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRGF0YUFzc2luYXR1cmEiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRGF0YUNvbnRyb2xvSW50ZXJubyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJTZWd1bmRhVmlhIiAvPjxDb2x1bW4gVGFibGU9InRiRm9ybmVjZWRvcmVzIiBOYW1lPSJOb21lIiBBbGlhcz0idGJGb3JuZWNlZG9yZXNfTm9tZSIgLz48Q29sdW1uIFRhYmxlPSJ0YkZvcm5lY2Vkb3JlcyIgTmFtZT0iQ29kaWdvIiBBbGlhcz0idGJGb3JuZWNlZG9yZXNfQ29kaWdvIiAvPjxDb2x1bW4gVGFibGU9InRiRm9ybmVjZWRvcmVzIiBOYW1lPSJOQ29udHJpYnVpbnRlIiBBbGlhcz0idGJGb3JuZWNlZG9yZXNfTkNvbnRyaWJ1aW50ZSIgLz48Q29sdW1uIFRhYmxlPSJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiIE5hbWU9Ik1vcmFkYSIgQWxpYXM9InRiRm9ybmVjZWRvcmVzTW9yYWRhc19Nb3JhZGEiIC8+PENvbHVtbiBUYWJsZT0idGJDb2RpZ29zUG9zdGFpcyIgTmFtZT0iQ29kaWdvIiBBbGlhcz0idGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfQ29kaWdvIiAvPjxDb2x1bW4gVGFibGU9InRiQ29kaWdvc1Bvc3RhaXMiIE5hbWU9IkRlc2NyaWNhbyIgQWxpYXM9InRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0Rlc2NyaWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkVzdGFkb3MiIE5hbWU9IkNvZGlnbyIgQWxpYXM9InRiRXN0YWRvc19Db2RpZ28iIC8+PENvbHVtbiBUYWJsZT0idGJFc3RhZG9zIiBOYW1lPSJEZXNjcmljYW8iIEFsaWFzPSJ0YkVzdGFkb3NfRGVzY3JpY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiVGlwb3NEb2N1bWVudG8iIE5hbWU9IkNvZGlnbyIgQWxpYXM9InRiVGlwb3NEb2N1bWVudG9fQ29kaWdvIiAvPjxDb2x1bW4gVGFibGU9InRiVGlwb3NEb2N1bWVudG8iIE5hbWU9IkRlc2NyaWNhbyIgQWxpYXM9InRiVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiVGlwb3NEb2N1bWVudG8iIE5hbWU9IkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBBbGlhcz0idGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlRpcG9zRG9jdW1lbnRvIiBOYW1lPSJEb2NOYW9WYWxvcml6YWRvIiBBbGlhcz0idGJUaXBvc0RvY3VtZW50b19Eb2NOYW9WYWxvcml6YWRvIiAvPjxDb2x1bW4gVGFibGU9InRiVGlwb3NEb2N1bWVudG9TZXJpZXMiIE5hbWU9IkNvZGlnb1NlcmllIiAvPjxDb2x1bW4gVGFibGU9InRiVGlwb3NEb2N1bWVudG9TZXJpZXMiIE5hbWU9IkRlc2NyaWNhb1NlcmllIiAvPjxDb2x1bW4gVGFibGU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIiBOYW1lPSJEZXNjcmljYW8iIEFsaWFzPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbF9EZXNjcmljYW8iIC8+PENvbHVtbiBUYWJsZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iIE5hbWU9IlRpcG8iIEFsaWFzPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19UaXBvIiAvPjxDb2x1bW4gVGFibGU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIiBOYW1lPSJEZXNjcmljYW8iIEFsaWFzPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iIC8+PENvbHVtbiBUYWJsZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiIE5hbWU9IlRpcG8iIC8+PENvbHVtbiBUYWJsZT0idGJDb2RpZ29zUG9zdGFpczMiIE5hbWU9IkNvZGlnbyIgQWxpYXM9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iIC8+PENvbHVtbiBUYWJsZT0idGJDb2RpZ29zUG9zdGFpczMiIE5hbWU9IkRlc2NyaWNhbyIgQWxpYXM9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9EZXNjcmljYW8iIC8+PENvbHVtbiBUYWJsZT0idGJDb2RpZ29zUG9zdGFpczEiIE5hbWU9IkNvZGlnbyIgQWxpYXM9InRiQ29kaWdvc1Bvc3RhaXNfQ29kaWdvIiAvPjxDb2x1bW4gVGFibGU9InRiQ29kaWdvc1Bvc3RhaXMxIiBOYW1lPSJEZXNjcmljYW8iIEFsaWFzPSJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkNvZGlnb3NQb3N0YWlzMiIgTmFtZT0iQ29kaWdvIiBBbGlhcz0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkNvZGlnb3NQb3N0YWlzMiIgTmFtZT0iRGVzY3JpY2FvIiBBbGlhcz0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0Rlc2NyaWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0Yk1vZWRhcyIgTmFtZT0iQ29kaWdvIiBBbGlhcz0idGJNb2VkYXNfQ29kaWdvIiAvPjxDb2x1bW4gVGFibGU9InRiTW9lZGFzIiBOYW1lPSJEZXNjcmljYW8iIEFsaWFzPSJ0Yk1vZWRhc19EZXNjcmljYW8iIC8+PENvbHVtbiBUYWJsZT0idGJNb2VkYXMiIE5hbWU9IkNhc2FzRGVjaW1haXNUb3RhaXMiIEFsaWFzPSJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzIiAvPjxDb2x1bW4gVGFibGU9InRiTW9lZGFzIiBOYW1lPSJDYXNhc0RlY2ltYWlzSXZhIiBBbGlhcz0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc0l2YSIgLz48Q29sdW1uIFRhYmxlPSJ0Yk1vZWRhcyIgTmFtZT0iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgQWxpYXM9InRiTW9lZGFzX0Nhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiIC8+PENvbHVtbiBUYWJsZT0idGJNb2VkYXMiIE5hbWU9IlNpbWJvbG8iIEFsaWFzPSJ0Yk1vZWRhc19TaW1ib2xvIiAvPjxDb2x1bW4gVGFibGU9InRiU2lzdGVtYU1vZWRhcyIgTmFtZT0iQ29kaWdvIiBBbGlhcz0idGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIEFsaWFzPSJ0YlBhcmFtZW50cm9zRW1wcmVzYV9DYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIC8+PENvbHVtbiBUYWJsZT0idGJTaXN0ZW1hTmF0dXJlemFzIiBOYW1lPSJDb2RpZ28iIEFsaWFzPSJ0YlNpc3RlbWFOYXR1cmV6YXNfQ29kaWdvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9Ik1vcmFkYURlc3RpbmF0YXJpbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJWb3Nzb051bWVyb0RvY3VtZW50byIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIiBOYW1lPSJWYWxvckRlc2NvbnRvTGluaGEiIEFnZ3JlZ2F0ZT0iU3VtIiBBbGlhcz0iVmFsb3JEZXNjb250b0xpbmhhX1N1bSIgLz48L0NvbHVtbnM+PEdyb3VwaW5nPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEVGlwb0RvY3VtZW50byIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJOdW1lcm9Eb2N1bWVudG8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRGF0YURvY3VtZW50byIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJPYnNlcnZhY29lcyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRE1vZWRhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlRheGFDb252ZXJzYW8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iVG90YWxNb2VkYURvY3VtZW50byIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJUb3RhbE1vZWRhUmVmZXJlbmNpYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJMb2NhbENhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkRhdGFDYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJIb3JhQ2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iTW9yYWRhQ2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURDb2RpZ29Qb3N0YWxDYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRENvbmNlbGhvQ2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSUREaXN0cml0b0NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkxvY2FsRGVzY2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRGF0YURlc2NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkhvcmFEZXNjYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJNb3JhZGFEZXNjYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEQ29uY2VsaG9EZXNjYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRERpc3RyaXRvRGVzY2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iTm9tZURlc3RpbmF0YXJpbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJNb3JhZGFEZXN0aW5hdGFyaW8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURDb25jZWxob0Rlc3RpbmF0YXJpbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlNlcmllRG9jTWFudWFsIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9Ik51bWVyb0RvY01hbnVhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJOdW1lcm9MaW5oYXMiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iUG9zdG8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURFc3RhZG8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iVXRpbGl6YWRvckVzdGFkbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJEYXRhSG9yYUVzdGFkbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJBc3NpbmF0dXJhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlZlcnNhb0NoYXZlUHJpdmFkYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJOb21lRmlzY2FsIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9Ik1vcmFkYUZpc2NhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRENvZGlnb1Bvc3RhbEZpc2NhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRENvbmNlbGhvRmlzY2FsIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklERGlzdHJpdG9GaXNjYWwiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iQ29udHJpYnVpbnRlRmlzY2FsIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlNpZ2xhUGFpc0Zpc2NhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRExvamEiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSW1wcmVzc28iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iVmFsb3JJbXBvc3RvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlBlcmNlbnRhZ2VtRGVzY29udG8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iVmFsb3JEZXNjb250byIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJWYWxvclBvcnRlcyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRFRheGFJdmFQb3J0ZXMiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iVGF4YUl2YVBvcnRlcyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJNb3Rpdm9Jc2VuY2FvSXZhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9Ik1vdGl2b0lzZW5jYW9Qb3J0ZXMiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURFc3BhY29GaXNjYWxQb3J0ZXMiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRXNwYWNvRmlzY2FsUG9ydGVzIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEUmVnaW1lSXZhUG9ydGVzIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlJlZ2ltZUl2YVBvcnRlcyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJDdXN0b3NBZGljaW9uYWlzIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlNpc3RlbWEiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iQXRpdm8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRGF0YUNyaWFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRGF0YUFsdGVyYWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkYzTU1hcmNhZG9yIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklERm9ybWFFeHBlZGljYW8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURUaXBvc0RvY3VtZW50b1NlcmllcyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJOdW1lcm9JbnRlcm5vIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklERW50aWRhZGUiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURUaXBvRW50aWRhZGUiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURDb25kaWNhb1BhZ2FtZW50byIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJJRExvY2FsT3BlcmFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iQ29kaWdvQVQiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURQYWlzQ2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURQYWlzRGVzY2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iTWF0cmljdWxhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEUGFpc0Zpc2NhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJDb2RpZ29Qb3N0YWxGaXNjYWwiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRGVzY3JpY2FvQ29kaWdvUG9zdGFsRmlzY2FsIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkRlc2NyaWNhb0Rpc3RyaXRvRmlzY2FsIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklERXNwYWNvRmlzY2FsIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IklEUmVnaW1lSXZhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkNvZGlnb0FUSW50ZXJubyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJUaXBvRmlzY2FsIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkRvY3VtZW50byIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJDb2RpZ29UaXBvRXN0YWRvIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkNvZGlnb0RvY09yaWdlbSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJEaXN0cml0b0NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkNvbmNlbGhvQ2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iQ29kaWdvUG9zdGFsQ2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iU2lnbGFQYWlzQ2FyZ2EiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRGlzdHJpdG9EZXNjYXJnYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJDb25jZWxob0Rlc2NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkNvZGlnb1Bvc3RhbERlc2NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlNpZ2xhUGFpc0Rlc2NhcmdhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkNvZGlnb0VudGlkYWRlIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkNvZGlnb01vZWRhIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9Ik1lbnNhZ2VtRG9jQVQiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iSURTaXNUaXBvc0RvY1BVIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkNvZGlnb1Npc1RpcG9zRG9jUFUiIC8+PENvbHVtbiBUYWJsZT0idGJEb2N1bWVudG9zQ29tcHJhcyIgTmFtZT0iRG9jTWFudWFsIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IkRvY1JlcG9zaWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJEYXRhQXNzaW5hdHVyYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJEYXRhQ29udHJvbG9JbnRlcm5vIiAvPjxDb2x1bW4gVGFibGU9InRiRG9jdW1lbnRvc0NvbXByYXMiIE5hbWU9IlNlZ3VuZGFWaWEiIC8+PENvbHVtbiBUYWJsZT0idGJGb3JuZWNlZG9yZXMiIE5hbWU9IkNvZGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkZvcm5lY2Vkb3JlcyIgTmFtZT0iTm9tZSIgLz48Q29sdW1uIFRhYmxlPSJ0YkZvcm5lY2Vkb3JlcyIgTmFtZT0iTkNvbnRyaWJ1aW50ZSIgLz48Q29sdW1uIFRhYmxlPSJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiIE5hbWU9Ik1vcmFkYSIgLz48Q29sdW1uIFRhYmxlPSJ0YkNvZGlnb3NQb3N0YWlzIiBOYW1lPSJDb2RpZ28iIC8+PENvbHVtbiBUYWJsZT0idGJDb2RpZ29zUG9zdGFpcyIgTmFtZT0iRGVzY3JpY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiRXN0YWRvcyIgTmFtZT0iQ29kaWdvIiAvPjxDb2x1bW4gVGFibGU9InRiRXN0YWRvcyIgTmFtZT0iRGVzY3JpY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiVGlwb3NEb2N1bWVudG8iIE5hbWU9IkNvZGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlRpcG9zRG9jdW1lbnRvIiBOYW1lPSJEZXNjcmljYW8iIC8+PENvbHVtbiBUYWJsZT0idGJUaXBvc0RvY3VtZW50byIgTmFtZT0iQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJUaXBvc0RvY3VtZW50byIgTmFtZT0iRG9jTmFvVmFsb3JpemFkbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIiBOYW1lPSJDb2RpZ29TZXJpZSIgLz48Q29sdW1uIFRhYmxlPSJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIiBOYW1lPSJEZXNjcmljYW9TZXJpZSIgLz48Q29sdW1uIFRhYmxlPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byIgTmFtZT0iVGlwbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byIgTmFtZT0iRGVzY3JpY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIiBOYW1lPSJUaXBvIiAvPjxDb2x1bW4gVGFibGU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIiBOYW1lPSJEZXNjcmljYW8iIC8+PENvbHVtbiBUYWJsZT0idGJDb2RpZ29zUG9zdGFpczEiIE5hbWU9IkNvZGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkNvZGlnb3NQb3N0YWlzMSIgTmFtZT0iRGVzY3JpY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiQ29kaWdvc1Bvc3RhaXMyIiBOYW1lPSJDb2RpZ28iIC8+PENvbHVtbiBUYWJsZT0idGJDb2RpZ29zUG9zdGFpczIiIE5hbWU9IkRlc2NyaWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkNvZGlnb3NQb3N0YWlzMyIgTmFtZT0iQ29kaWdvIiAvPjxDb2x1bW4gVGFibGU9InRiQ29kaWdvc1Bvc3RhaXMzIiBOYW1lPSJEZXNjcmljYW8iIC8+PENvbHVtbiBUYWJsZT0idGJNb2VkYXMiIE5hbWU9IkNvZGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ0Yk1vZWRhcyIgTmFtZT0iRGVzY3JpY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiTW9lZGFzIiBOYW1lPSJDYXNhc0RlY2ltYWlzVG90YWlzIiAvPjxDb2x1bW4gVGFibGU9InRiTW9lZGFzIiBOYW1lPSJDYXNhc0RlY2ltYWlzSXZhIiAvPjxDb2x1bW4gVGFibGU9InRiTW9lZGFzIiBOYW1lPSJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiAvPjxDb2x1bW4gVGFibGU9InRiTW9lZGFzIiBOYW1lPSJTaW1ib2xvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgLz48Q29sdW1uIFRhYmxlPSJ0YlNpc3RlbWFOYXR1cmV6YXMiIE5hbWU9IkNvZGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlNpc3RlbWFNb2VkYXMiIE5hbWU9IkNvZGlnbyIgLz48Q29sdW1uIFRhYmxlPSJ0YkRvY3VtZW50b3NDb21wcmFzIiBOYW1lPSJWb3Nzb051bWVyb0RvY3VtZW50byIgLz48L0dyb3VwaW5nPjxGaWx0ZXI+W3RiRG9jdW1lbnRvc0NvbXByYXMuSURdID0gP0lkRG9jPC9GaWx0ZXI+PC9RdWVyeT48UXVlcnkgVHlwZT0iU2VsZWN0UXVlcnkiIE5hbWU9InRiUGFyYW1ldHJvc0VtcHJlc2EiPjxUYWJsZXM+PFRhYmxlIE5hbWU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIC8+PC9UYWJsZXM+PENvbHVtbnM+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSUQiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURNb2VkYURlZmVpdG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iTW9yYWRhIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkZvdG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRm90b0NhbWluaG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDb2RpZ29Qb3N0YWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iTG9jYWxpZGFkZSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDb25jZWxobyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJEaXN0cml0byIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJJRFBhaXMiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iVGVsZWZvbmUiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRmF4IiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkVtYWlsIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IldlYlNpdGUiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iTklGIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkNvbnNlcnZhdG9yaWFSZWdpc3RvQ29tZXJjaWFsIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9Ik51bWVyb1JlZ2lzdG9Db21lcmNpYWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQ2FwaXRhbFNvY2lhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJJRElkaW9tYUJhc2UiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iU2lzdGVtYSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJBdGl2byIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJEYXRhQ3JpYWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJEYXRhQWx0ZXJhY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRjNNTWFyY2Fkb3IiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURFbXByZXNhIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJJRFBhaXNlc0Rlc2MiIC8+PC9Db2x1bW5zPjwvUXVlcnk+PFJlc3VsdFNjaGVtYT48RGF0YVNldD48VmlldyBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEYXRhRG9jdW1lbnRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iT2JzZXJ2YWNvZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURNb2VkYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxNb2VkYURvY3VtZW50byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhUmVmZXJlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJMb2NhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYUNhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJMb2NhbERlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOb21lRGVzdGluYXRhcmlvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc3RpbmF0YXJpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbERlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2VyaWVEb2NNYW51YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0xpbmhhcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlBvc3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXN0YWRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckVzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhSG9yYUVzdGFkbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkFzc2luYXR1cmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmVyc2FvQ2hhdmVQcml2YWRhIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iTm9tZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvbnRyaWJ1aW50ZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSW1wcmVzc28iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW1wb3N0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQZXJjZW50YWdlbURlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRGVzY29udG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURUYXhhSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUl2YVBvcnRlcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9Qb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ3VzdG9zQWRpY2lvbmFpcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvciIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJJREZvcm1hRXhwZWRpY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvc0RvY3VtZW50b1NlcmllcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0ludGVybm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREVudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvRW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmRpY2FvUGFnYW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURMb2NhbE9wZXJhY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNEZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1hdHJpY3VsYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0Rpc3RyaXRvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BVEludGVybm8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwb0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEb2N1bWVudG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb0VzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Eb2NPcmlnZW0iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG9DYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxob0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG9EZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29FbnRpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Nb2VkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNZW5zYWdlbURvY0FUIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEU2lzVGlwb3NEb2NQVSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Npc1RpcG9zRG9jUFUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRG9jTWFudWFsIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEb2NSZXBvc2ljYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFBc3NpbmF0dXJhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YUNvbnRyb2xvSW50ZXJubyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkRhdGFEb2N1bWVudG9fMSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1RpcG9Fc3RhZG9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTZWd1bmRhVmlhIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0lEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iT3JkZW0iIFR5cGU9IkludDMyIiAvPjxGaWVsZCBOYW1lPSJJRERvY3VtZW50b0NvbXByYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEVW5pZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bUNhc2FzRGVjVW5pZGFkZSIgVHlwZT0iSW50MTYiIC8+PEZpZWxkIE5hbWU9IlF1YW50aWRhZGUiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvRWZldGl2byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1RvdGFsIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfT2JzZXJ2YWNvZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb3RlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvTG90ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29VbmlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0xvdGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUZhYnJpY29Mb3RlIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YVZhbGlkYWRlTG90ZSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvTnVtU2VyaWUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJBcnRpZ29OdW1TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1Mb2NhbGl6YWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJtYXplbURlc3Rpbm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1Mb2NhbGl6YWNhb0Rlc3Rpbm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1MaW5oYXNEaW1lbnNvZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEZXNjb250bzEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRGVzY29udG8yIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEVGF4YUl2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFJdmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19Nb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlJlZ2ltZUl2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iT3JkZW1fMSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19BdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQ3JpYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19VdGlsaXphZG9yQWx0ZXJhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iVmFsb3JJbmNpZGVuY2lhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9ySVZBIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRvY3VtZW50b09yaWdlbSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhRW50cmVnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX05vbWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX05Db250cmlidWludGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNNb3JhZGFzX01vcmFkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRXN0YWRvc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFc3RhZG9zX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0RvY05hb1ZhbG9yaXphZG8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJ0aWdvc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQWJyZXZpYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJ0aWdvc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcnRpZ29zX0dlcmVMb3RlcyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX1NpbWJvbG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc0xvY2FsaXphY29lc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc0xvY2FsaXphY29lc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuczFfRGVzY3JpY2FvRGVzdGlubyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zMV9Db2RpZ29EZXN0aW5vIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJtYXplbnNMb2NhbGl6YWNvZXMxX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzMV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc0l2YSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hQ29kaWdvc0lWQS5Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTdWJUb3RhbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0YlBhcmFtZW50cm9zRW1wcmVzYV9DYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYU5hdHVyZXphc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48L1ZpZXc+PFZpZXcgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc19DYWIiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRhdGFEb2N1bWVudG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJPYnNlcnZhY29lcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRE1vZWRhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUNvbnZlcnNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhRG9jdW1lbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsTW9lZGFSZWZlcmVuY2lhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkxvY2FsQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUNhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSG9yYUNhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iTW9yYWRhQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxDYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9DYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9DYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkxvY2FsRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YURlc2NhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSG9yYURlc2NhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iTW9yYWRhRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9EZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik5vbWVEZXN0aW5hdGFyaW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlNlcmllRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY01hbnVhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9MaW5oYXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJQb3N0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVzdGFkbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JFc3RhZG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUhvcmFFc3RhZG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJBc3NpbmF0dXJhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlZlcnNhb0NoYXZlUHJpdmFkYSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9Ik5vbWVGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTW9yYWRhRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb250cmlidWludGVGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklETG9qYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkltcHJlc3NvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJWYWxvckltcG9zdG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUGVyY2VudGFnZW1EZXNjb250byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckRlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yUG9ydGVzIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEVGF4YUl2YVBvcnRlcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFJdmFQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iTW90aXZvSXNlbmNhb0l2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRXNwYWNvRmlzY2FsUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUmVnaW1lSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUmVnaW1lSXZhUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkN1c3Rvc0FkaWNpb25haXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkYzTU1hcmNhZG9yIiBUeXBlPSJVbmtub3duIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERm9ybWFFeHBlZGljYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtZXJvSW50ZXJubyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0VudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURFbnRpZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uZGljYW9QYWdhbWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRExvY2FsT3BlcmFjYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BVCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNDYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEUGFpc0Rlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTWF0cmljdWxhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpc0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbEZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9Db2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQ29uY2VsaG9GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvRGlzdHJpdG9GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFJlZ2ltZUl2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0FUSW50ZXJubyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUaXBvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRvY3VtZW50byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29UaXBvRXN0YWRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0RvY09yaWdlbSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0b0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG9EZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxob0Rlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbERlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0Rlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0VudGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb01vZWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1lbnNhZ2VtRG9jQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURTaXNUaXBvc0RvY1BVIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvU2lzVGlwb3NEb2NQVSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEb2NNYW51YWwiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRvY1JlcG9zaWNhbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUFzc2luYXR1cmEiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ29udHJvbG9JbnRlcm5vIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iU2VndW5kYVZpYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNfTm9tZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkZvcm5lY2Vkb3Jlc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNfTkNvbnRyaWJ1aW50ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXNfTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFc3RhZG9zX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVzdGFkb3NfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fRG9jTmFvVmFsb3JpemFkbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQ29kaWdvU2VyaWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvU2VyaWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDYXJnYV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0Nhc2FzRGVjaW1haXNUb3RhaXMiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0Nhc2FzRGVjaW1haXNJdmEiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0Nhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX1NpbWJvbG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlBhcmFtZW50cm9zRW1wcmVzYV9DYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYU5hdHVyZXphc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTW9yYWRhRGVzdGluYXRhcmlvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlZvc3NvTnVtZXJvRG9jdW1lbnRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlZhbG9yRGVzY29udG9MaW5oYV9TdW0iIFR5cGU9IkRvdWJsZSIgLz48L1ZpZXc+PFZpZXcgTmFtZT0idGJQYXJhbWV0cm9zRW1wcmVzYSI+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURNb2VkYURlZmVpdG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvQ2FtaW5obyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNpZ25hY2FvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJMb2NhbGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZheCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJXZWJTaXRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik5JRiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhcGl0YWxTb2NpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURJZGlvbWFCYXNlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IlVua25vd24iIC8+PEZpZWxkIE5hbWU9IklERW1wcmVzYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iSURQYWlzZXNEZXNjIiBUeXBlPSJJbnQ2NCIgLz48L1ZpZXc+PC9EYXRhU2V0PjwvUmVzdWx0U2NoZW1hPjxDb25uZWN0aW9uT3B0aW9ucyBDbG9zZUNvbm5lY3Rpb249InRydWUiIC8+PC9TcWxEYXRhU291cmNlPg==" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''
--Mapa de documentos de compras 
---tratar subreports
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item3/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=10000][1] with sql:variable("@intIDMapaSubCab")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item7/SubBands/Item1/Controls/Item2/@ReportSourceUrl)[.=20000][1] with sql:variable("@intIDMapaMI")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item5/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=30000][1] with sql:variable("@intIDMapaD")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item6/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=40000][1] with sql:variable("@intIDMapaDNV")'')
UPDATE tbMapasVistas SET MapaXML = @ptrval Where Entidade = ''DocumentosCompras'' and NomeMapa = ''rptDocumentosCompras''
')