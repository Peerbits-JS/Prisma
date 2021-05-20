/* ACT BD EMPRESA VERSAO 56*/
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
LEFT JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbSistemaNaturezas.ID=tbTiposDocumento.IDSistemaNaturezas
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbdocumentosVendas.IDTiposDocumentoSeries
LEFT JOIN tbArtigosLotes AS tbArtigosLotes with (nolock) ON tbArtigosLotes.ID = tbdocumentosVendaslinhas.IDLote
LEFT JOIN tbClientes AS tbClientes with (nolock) ON tbClientes.ID = tbdocumentosVendas.IDEntidade
LEFT JOIN tbtiposartigos AS tbtiposartigos with (nolock) ON tbtiposartigos.ID = tbArtigos.IDtipoartigo
LEFT JOIN tbParametrosEmpresa as P with (nolock) ON 1 = 1
LEFT JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=P.IDMoedaDefeito
where 
tbsistematiposestados.codigo=''EFT'' and tbsistematiposdocumento.tipo=''VndFinanceiro''
group by 
tbArtigos.Codigo,tbArtigos.Descricao,tbArtigosLotes.Codigo ,tbArtigosLotes.Descricao ,tbTiposArtigos.Codigo ,tbTiposArtigos.Descricao ,tbLojas.Codigo ,tbLojas.Descricao ,
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

-- Novo Menu de Histórico SMS
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral]..tbMenus WHERE Descricao = ''Comunicacaosetting'')
BEGIN
	INSERT INTO [F3MOGeral]..tbMenus ([IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar], [OpenType])
	VALUES (NULL, N''Comunicacaosetting'', N''019'', N''Comunicacaosetting'', 0, N''f3icon-comment'', N''/Communication/Comunicacaosetting'', 1, 14, 0, 0, 1, 0, 0, 0, NULL, 0, 0, getdate(), N''F3M'', NULL, NULL, NULL, NULL, NULL)
END')

--ativar menus SMS
EXEC('update [F3MOGeral]..tbMenus set ativo=1 where Descricao in (''ComunicacaoSms'',''Comunicacaosetting'')')
EXEC('update [F3MOGeral]..tbMenus set btncontextosms=1 where Descricao in (''Clientes'', ''DocumentosVendas'', ''DocumentosVendasServicos'')')

--aviso de versão 1.24
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.24.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.24.0'', ''A'', ''2020-04-10 00:00'', ''2020-04-14 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.24.0'', ''V'', ''2020-04-14 08:00'', ''2020-04-14 08:00'', ''Funcionalidades da versão'', ''
<li>Comunicação por SMS</li>
		&emsp;Em Clientes, Serviços e Documentos de venda<br>
		&emsp;Histórico de envios<br>
<li>Catálogo de Lentes</li>
		&emsp;Definição de preços de Lentes Oftálmicas e Lentes de contato<br>
<li>Contagem de Stock</li>
		&emsp;Possibilidade de Ordenação por descrição de artigos<br>
<li>Análises</li>
		&emsp;Mapa de Vendas e de Margens de Vendas valorizados pelo custo médio da ficha de Artigo<br>
'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')
