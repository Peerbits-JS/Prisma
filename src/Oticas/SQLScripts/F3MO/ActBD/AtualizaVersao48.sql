/* ACT BD EMPRESA VERSAO 48*/
--atualizar vista dos documentos de venda
EXEC('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.Documento as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, TotalEntidade1, TotalClienteMoedaDocumento, d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado,
(isnull(d.TotalClienteMoedaDocumento,0)-isnull(d.valorpago,0)) as ValorPendente, s.Descricao as DescricaoEstado, e1.Descricao as DescricaoEntidade1, e2.Descricao as DescricaoEntidade2, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, d.CodigoTipoEstado as CodigoTipoEstado, TD.Adiantamento as Adiantamento
from tbDocumentosVendas d 
inner join tbLojas l on d.IDloja=l.id and d.idloja=''''[%%IDLojaDoc%%]''''
left join tbClientes c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbSistemaTiposDocumento STD on TD.IDSistemaTiposDocumento=STD.ID and STD.Tipo<>''''VndServico'''' and STD.Tipo<>''''SubstituicaoArtigos''''
left join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbEstados s on d.IDEstado=s.ID
left join tbentidades e1 on d.IDEntidade1=e1.ID
left join tbentidades e2 on d.IDEntidade2=e2.ID
''where id in (58)')

--atualizar vista dos serviços
EXEC('
update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.Documento as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, TotalEntidade1, TotalClienteMoedaDocumento, d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, 
d.documento as DescricaoSplitterLadoDireito, d.IDEstado,
(isnull(d.TotalClienteMoedaDocumento,0)-isnull(d.valorpago,0)) as ValorPendente, 
s.Descricao as DescricaoEstado, e1.Descricao as DescricaoEntidade1, e2.Descricao as DescricaoEntidade2, TD.IDSistemaTiposDocumento, cast(1 as bit) as PermiteImprimir
from tbDocumentosVendas d 
inner join tbLojas l on d.IDloja=l.id and d.idloja=''''[%%IDLojaDoc%%]''''
left join tbClientes c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbSistemaTiposDocumento STD on TD.IDSistemaTiposDocumento=STD.ID and STD.Tipo=''''VndServico''''
left join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbEstados s on d.IDEstado=s.ID
left join tbentidades e1 on d.IDEntidade1=e1.ID
left join tbentidades e2 on d.IDEntidade2=e2.ID''
where id in (55)')

--atualizar vista do stock
EXEC('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select TD.Codigo as DescricaoTipoDocumento, D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.Documento as Documento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, 
d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, d.CodigoTipoEstado as CodigoTipoEstado, cast(1 as bit) as PermiteImprimir
from tbDocumentosStock d 
inner join tbLojas l on d.IDloja=l.id and d.idloja=''''[%%IDLojaDoc%%]''''
left join tbClientes c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID and d.ativo=1
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbEstados s on d.IDEstado=s.ID
''where id in (69)')


--incluir filtro de loja nos movimentos de caixa
exec('update [F3MOGeral].dbo.tbListasPersonalizadas set 
query=''select Distinct D.Descricao as Descricao, D.Descricao as Documento, D.ID, D.Ativo, D.IDContaCaixa, CC.Descricao as DescricaoContaCaixa, D.IDTipoDocumentoSeries, d.IDTipoDocumento, D.IDDocumento, D.NumeroDocumento, D.IDFormaPagamento, FP.Descricao as DescricaoFormaPagamento, D.IDLoja as IDLoja, l.Descricao as DescricaoLoja, (case when D.Natureza=''''P'''' then ''''Entrada'''' else ''''Saída'''' end) as Natureza, DataDocumento, D.IDMoeda, D.TotalMoeda, d.TotalMoedareferencia, D.Descricao as DescricaoSplitterLadoDireito 
from tbmapacaixa d inner join tbLojas l on d.IDloja=l.id and d.idloja=''''[%%IDLojaDoc%%]''''
inner join tbFormasPagamento FP on d.IDFormaPagamento=FP.ID 
inner join tbTiposDocumento TD on d.IDTipoDocumento is null
inner join tbContasCaixa CC on d.IDContaCaixa=CC.ID ''
where Descricao=''Movimentos de Caixa'' ')

--atualizar vista do compras
EXEC('
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao=''Documentos de Compras''
update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select TD.Codigo as DescricaoTipoDocumento, D.Ativo, D.IDTiposDocumentoSeries, d.IDTipoDocumento, d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.documento as Documento, d.VossoNumeroDocumento as VossoNumeroDocumento, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, 
d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado, s.Descricao as DescricaoEstado, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, cast(1 as bit) as PermiteImprimir, td.DocNaoValorizado as DocNaoValorizado,
convert(tinyint,case when isnull(tbMoedas.ID,0) = 0 then tbMoedasRef.CasasDecimaisTotais else isnull(tbMoedas.CasasDecimaisTotais,0) end) as TotalMoedaDocumentonumcasasdecimais
from tbDocumentosCompras d 
left join tbMoedas as tbMoedas ON tbMoedas.ID=d.IDMoeda
inner join tbLojas l on d.IDloja=l.id and d.idloja=''''[%%IDLojaDoc%%]''''
left join tbFornecedores c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbSistemaTiposDocumentoFiscal TDF on td.IDSistemaTiposDocumentoFiscal=TDF.ID
left join tbEstados s on d.IDEstado=s.ID
LEFT JOIN tbParametrosEmpresa as P ON 1 = 1
LEFT JOIN tbMoedas as tbMoedasRef ON tbMoedasRef.ID=P.IDMoedaDefeito
''where id in (@IDLista)')

-- Mapas Vistas
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbMapasVistas'' AND COLUMN_NAME = ''TipoReport'') 
Begin
ALTER TABLE tbMapasVistas ADD TipoReport int NULL
End')

EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaDocumentosVendas]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaDocumentosVendas]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaDocumentosVendas] 

AS
DECLARE db_cursor CURSOR FOR 

SELECT D.ID, D.IDTipoDocumento, D.IDTiposDocumentoSeries, D.UtilizadorCriacao, D.IDEntidade, d.DataCriacao
from tbDocumentosVendas D with (nolock) 
left join tbTiposDocumento TD with (nolock) on D.IDTipoDocumento=TD.id 
left join tbSistemaTiposDocumento STD with (nolock) on TD.IDSistemaTiposDocumento=STD.id
where CodigoDocOrigem=''002'' and d.CodigoTipoEstado=''EFT''

DECLARE @IDDocumento bigint;
DECLARE @IDTipoDocumento bigint;
DECLARE @IDTiposDocumentoSeries bigint;
DECLARE @IDEntidade bigint;
DECLARE @Utilizador varchar(200); 
DECLARE @Data datetime;

OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, @Utilizador, @IDEntidade, @Data
WHILE @@FETCH_STATUS = 0  
BEGIN 

EXEC sp_ControloDocumentos  @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, 0, ''tbDocumentosVendas'', @Utilizador 
EXEC sp_AtualizaCCEntidades @IDDocumento, @IDTipoDocumento, 0, @Utilizador, @IDEntidade 

FETCH NEXT FROM db_cursor INTO @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, @Utilizador, @IDEntidade, @Data;
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;
')

EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaDocumentosVendasRC]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaDocumentosVendasRC]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaDocumentosVendasRC] 

AS
DECLARE db_cursor CURSOR FOR 

SELECT D.ID, D.IDTipoDocumento, D.IDTiposDocumentoSeries, D.UtilizadorCriacao, D.IDEntidade,d.DataCriacao
from tbrecibos D with (nolock) 
left join tbTiposDocumento TD with (nolock) on D.IDTipoDocumento=TD.id 
left join tbSistemaTiposDocumento STD with (nolock) on TD.IDSistemaTiposDocumento=STD.id
where CodigoDocOrigem=''002'' and d.CodigoTipoEstado=''EFT''
order by d.DataCriacao, d.ID; 

DECLARE @IDDocumento bigint;
DECLARE @IDTipoDocumento bigint;
DECLARE @IDTiposDocumentoSeries bigint;
DECLARE @IDEntidade bigint;
DECLARE @Utilizador varchar(200); 
DECLARE @Data datetime;

OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, @Utilizador, @IDEntidade, @Data
WHILE @@FETCH_STATUS = 0  
BEGIN 

EXEC sp_ControloDocumentos  @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, 0, ''tbRecibos'', @Utilizador 
EXEC sp_AtualizaCCEntidades @IDDocumento, @IDTipoDocumento, 0, @Utilizador, @IDEntidade 

FETCH NEXT FROM db_cursor INTO @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, @Utilizador, @IDEntidade, @Data;
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;
')