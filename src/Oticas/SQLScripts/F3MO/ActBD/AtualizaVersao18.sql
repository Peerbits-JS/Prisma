/* ACT BD EMPRESA VERSAO 18*/
EXEC('update tbTiposDocumento set IDSistemaTiposDocumentoPrecoUnitario=14 where IDModulo=3')
EXEC('update tbpagamentoscompras set assinatura=null')
EXEC('update tbtiposdocumento set gerecontacorrente=0 where ID=8')
EXEC('update [F3MOGeral].dbo.tbcolunasListasPersonalizadas set Visivel=0 where IDListaPersonalizada=77 and colunavista=''IDEntidade''')
EXEC('update [F3MOGeral].dbo.tbcolunasListasPersonalizadas set tipocoluna=4 where IDListaPersonalizada=77 and colunavista=''DataDocumento''')

EXEC('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, TotalEntidade1, TotalClienteMoedaDocumento, d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as DescricaoSplitterLadoDireito, d.IDEstado,
(case when d.CodigoTipoEstado=''''ANL'''' then 0 else (isnull(d.TotalClienteMoedaDocumento,0)-isnull(d.valorpago,0)) end) as ValorPendente, s.Descricao as DescricaoEstado, e1.Descricao as DescricaoEntidade1, e2.Descricao as DescricaoEntidade2, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, d.CodigoTipoEstado as CodigoTipoEstado
from tbDocumentosVendas d 
inner join tbLojas l on d.IDloja=l.id
inner join tbClientes c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbSistemaTiposDocumento STD on TD.IDSistemaTiposDocumento=STD.ID and STD.Tipo<>''''VndServico''''
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbEstados s on d.IDEstado=s.ID
left join tbentidades e1 on d.IDEntidade1=e1.ID
left join tbentidades e2 on d.IDEntidade2=e2.ID
''where id in (58)')

EXEC('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select TD.Codigo as DescricaoTipoDocumento, D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.Documento as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, 
d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, d.CodigoTipoEstado as CodigoTipoEstado, cast(1 as bit) as PermiteImprimir
from tbDocumentosStock d 
left join tbLojas l on d.IDloja=l.id
left join tbClientes c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbEstados s on d.IDEstado=s.ID
''where id in (69)')

exec('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select TD.Codigo as DescricaoTipoDocumento, D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.documento as Documento, VossoNumeroDocumento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, 
d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax , d.CodigoTipoEstado as CodigoTipoEstado, cast(1 as bit) as PermiteImprimir 
from tbDocumentosCompras d 
left join tbLojas l on d.IDloja=l.id
left join tbFornecedores c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbSistemaTiposDocumentoFiscal TDF on td.IDSistemaTiposDocumentoFiscal=TDF.ID
left join tbEstados s on d.IDEstado=s.ID
''where id in (70)')

EXEC('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, D.Assinatura, D.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, d.IDEntidade, c.nome as DescricaoEntidade, (case when NumeroDocumento=0 then cast(TD.Codigo as nvarchar(20))+ '''' '''' + TDS.CodigoSerie + ''''/'''' else TD.Codigo + '''' '''' + TDS.CodigoSerie + ''''/'''' + cast(D.NumeroDocumento as nvarchar(20)) end) as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as PermiteImprimir from tbPagamentosCompras d left join tbLojas l on d.IDloja=l.id left join tbFornecedores c on d.IDEntidade=c.id inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID left join tbSistemaTiposDocumentoFiscal TDF on td.IDSistemaTiposDocumentoFiscal=TDF.ID left join tbEstados s on d.IDEstado=s.ID''
where TabelaPrincipal=''tbPagamentosCompras''')


EXEC('DROP PROCEDURE [dbo].[sp_AtualizaCCFornecedores]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaCCFornecedores]  
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

				SET @strSqlQuery=''DELETE FROM tbCCFornecedores where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)

				SET @strSqlQueryInsert = ''insert into tbCCFornecedores ([Natureza], [IDLoja], [IDTipoEntidade],[IDEntidade],[NomeFiscal],[IDTipoDocumento],[IDTipoDocumentoSeries],[IDDocumento],[NumeroDocumento],
										[DataDocumento],[Descricao], [IDMoeda], [TotalMoeda],[TotalMoedaReferencia],[TaxaConversao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao])''
								
				SELECT @strSqlQuery = @strSqlQueryInsert + '' select (case when (TD.Adiantamento=1 and TSN.Codigo=''''R'''') then ''''P'''' when (TD.Adiantamento=1 and TSN.Codigo=''''P'''') then ''''R'''' else TSN.Codigo end) as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbdocumentoscompras DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)

				SELECT @strSqlQuery = @strSqlQueryInsert + '' select TSN.Codigo as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento+DV.TotalDescontos, DV.TotalMoedaReferencia+(DV.TotalDescontos*DV.TaxaConversao), DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbpagamentoscompras DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
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

				SET @strSqlQuery=''DELETE FROM tbCCFornecedores where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)
			END

		  UPDATE tbfornecedores set saldo=tbcc.saldo FROM tbfornecedores Cli
			   INNER JOIN (
			   select identidade, isnull(sum(case when natureza=''P'' then totalmoedareferencia else -totalmoedareferencia end ),0) as saldo from tbCCFornecedores where identidade=@lngidEntidade group by IDEntidade) tbcc
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

--notas de crédito a dinheiro
EXEC('INSERT [dbo].[tbTiposDocumento] ([Codigo], [Descricao], [IDModulo], [IDSistemaTiposDocumento], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Observacoes], [IDSistemaTiposDocumentoFiscal], [GereStock], [GereContaCorrente], [GereCaixasBancos], [RegistarCosumidorFinal], [AnalisesEstatisticas], [CalculaComissoes], [ControlaPlafondEntidade], [AcompanhaBensCirculacao], [DocNaoValorizado], [IDSistemaAcoes], [IDSistemaTiposLiquidacao], [CalculaNecessidades], [CustoMedio], [UltimoPrecoCusto], [DataPrimeiraEntrada], [DataUltimaEntrada], [DataPrimeiraSaida], [DataUltimaSaida], [IDSistemaAcoesRupturaStock], [IDSistemaTiposDocumentoMovStock], [IDSistemaTiposDocumentoPrecoUnitario], [AtualizaFichaTecnica], [IDEstado], [IDCliente], [IDSistemaAcoesStockMinimo], [IDSistemaAcoesStockMaximo], [IDSistemaAcoesReposicaoStock], [IDSistemaNaturezas], [ReservaStock], [GeraPendente], [Adiantamento], [Predefinido]) VALUES (N''NCD'', N''Nota de Crédito Dinheiro'', 4, 14, 0, 1, CAST(N''2017-07-27 17:24:04.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, 18, 1, 0, 1, 1, 1, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, NULL, NULL, NULL, 1, 1, 1, 7, 0, 0, 0, 0)')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [dbo].[tbTiposDocumento] WHERE Descricao=''Nota de Crédito Dinheiro''
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (@IDLista, 5, 0, 0, CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.420'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoTipEntPermDoc] ([IDTiposDocumento], [IDSistemaTiposEntidadeModulos], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [ContadorDoc]) VALUES (@IDLista, 6, 0, 0, CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', CAST(N''2017-05-30 09:17:28.427'' AS DateTime), N''F3M'', 0, 0)
INSERT [dbo].[tbTiposDocumentoSeries] ([CodigoSerie], [DescricaoSerie], [SugeridaPorDefeito], [IDTiposDocumento], [Sistema], [AtivoSerie], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Ordem], [CalculaComissoesSerie], [AnalisesEstatisticasSerie], [IVAIncluido], [IVARegimeCaixa], [DataInicial], [DataFinal], [DataUltimoDoc], [NumUltimoDoc], [IDSistemaTiposDocumentoOrigem], [IDSistemaTiposDocumentoComunicacao], [IDParametrosEmpresaCAE], [NumeroVias], [IDMapasVistas]) VALUES (right(year(getdate()),2) + ''NDC'', right(year(getdate()),2) + ''NDC'', 1, @IDLista, 0, 1, CAST(N''2017-07-27 17:24:03.447'' AS DateTime), N''F3M'', NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 1, 1, NULL, 1, 1)
INSERT [F3MOGeral].[dbo].[tbPerfisAcessosAreasEmpresa] ([IDPerfis], [IDMenusAreasEmpresa], [IDLinhaTabela], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 7, @IDLista, 1, 1, 1, 1, 0, 0, NULL, 0, 0, CAST(N''2017-05-30 12:26:30.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
END')

-- Acesso ao contexto duplicar
--EXEC('UPDATE [F3MOGeral].[dbo].[tbMenus] set btnContextoDuplicar=1 Where Descricao in (''Artigos'', ''DocumentosStock'', ''DocumentosCompras'',''DocumentosVendas'')')
--EXEC('update p set p.duplicar=1 from [F3MOGeral].[dbo].tbPerfisAcessos p inner join [F3MOGeral].[dbo].tbmenus m on p.IDMenus=m.id where m.Descricao in (''Artigos'', ''DocumentosStock'', ''DocumentosCompras'',''DocumentosVendas'')')
