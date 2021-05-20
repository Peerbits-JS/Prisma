/* ACT BD EMPRESA VERSAO 64*/
--Adiciona o campo codigo validacao at nos Tipo Doc séries
EXEC('ALTER TABLE tbTiposDocumentoSeries ADD ATCodValidacaoSerie  nvarchar(50) NULL')
-- IX unico para o campo
EXEC('CREATE UNIQUE INDEX IX_tbTiposDocumentoSeriesCodigoAT ON [tbTiposDocumentoSeries](ATCodValidacaoSerie) WHERE ATCodValidacaoSerie IS NOT NULL')
--para controlar se já está a ser usado o ATCodValidacaoSerie
EXEC('ALTER TABLE tbControloDocumentos ADD ATCUD nvarchar(70) NULL')
 
EXEC('DROP PROCEDURE [dbo].[sp_ControloDocumentos]')
EXEC('CREATE PROCEDURE [dbo].[sp_ControloDocumentos]  
    @lngidDocumento AS bigint = NULL,
    @IDTipoDocumento AS bigint = NULL,
    @IDTiposDocumentoSeries AS bigint = 0,
    @intAccao AS int = 0,
    @strTabelaCabecalho AS nvarchar(250) = '''', 
    @strUtilizador AS nvarchar(256) = ''''
AS  BEGIN
SET NOCOUNT ON
DECLARE    
    @ErrorMessage AS varchar(2000),
    @ErrorSeverity AS tinyint,
    @ErrorState AS tinyint,
    @strSqlQuery AS varchar(max),
    @strQueryEstado AS nvarchar(256) = '', Cab.IDEstado as IDEstado '',
    @strQueryATCUD AS nvarchar(256) = '', Cab.ATCUD as ATCUD ''
BEGIN TRY
            
            IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = @strTabelaCabecalho AND COLUMN_NAME = ''IDEstado'')
            BEGIN
               SET @strQueryEstado = '', NULL as IDEstado ''
            END
            IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = @strTabelaCabecalho AND COLUMN_NAME = ''ATCUD'')
            BEGIN
               SET @strQueryATCUD = '', NULL as ATCUD ''
            END
            IF (@intAccao = 0 OR @intAccao = 1) --adiona ou alterar
                BEGIN
                        IF (@intAccao = 1) --adiona ou alterar
                            BEGIN
                                SET @strSqlQuery  = '' DELETE FROM tbControloDocumentos 
                                                 WHERE IDDocumento = '' + Convert(nvarchar,@lngidDocumento)  + '' AND IDTipoDocumento = '' + Convert(nvarchar,@IDTipoDocumento) 
                                                + '' AND IDTiposDocumentoSeries = '' + Convert(nvarchar, @IDTiposDocumentoSeries) 
                                EXEC(@strSqlQuery)
                            END

 

                        SET @strSqlQuery =''INSERT INTO tbControloDocumentos (IDEntidade, IDTipoEntidade , IDTipoDocumento, IDTiposDocumentoSeries, IDDocumento, NumeroDocumento, DataDocumento, 
                                       Ativo, Sistema, DataCriacao, UtilizadorCriacao, IDLoja, IDEstado, ATCUD)''
                                       + '' SELECT Cab.IDEntidade , Cab.IDTipoEntidade, Cab.IDTipoDocumento, Cab.IDTiposDocumentoSeries, Cab.ID as IDDocumento, Cab.NumeroDocumento,
                                        Cab.DataDocumento, 1 as Ativo , 1 as Sistema, getdate() as DataCriacao, '''''' + @strUtilizador + '''''' AS UtilizadorCriacao, Cab.IDLoja as IDLoja '' + @strQueryEstado + @strQueryATCUD + ''
                                        FROM '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab
                                        WHERE Cab.ID = '' + Convert(nvarchar,@lngidDocumento) 
                        EXEC(@strSqlQuery)        
                END
            ELSE--apagar
                BEGIN
                    SET @strSqlQuery  = '' DELETE FROM tbControloDocumentos WHERE IDDocumento = '' + Convert(nvarchar,@lngidDocumento)  + '' AND IDTipoDocumento = '' + Convert(nvarchar,@IDTipoDocumento) 
                                        + '' AND IDTiposDocumentoSeries = '' + Convert(nvarchar, @IDTiposDocumentoSeries) 
                    EXEC(@strSqlQuery)
                END
END TRY
BEGIN CATCH
    SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
    RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')

---Adiciona os campos às tabelas de documentos que terão o QRCode, tem exemplos aqui abaixo
EXEC('ALTER TABLE tbDocumentosVendas ADD ATCUD nvarchar (70) null, ATQRCode image null, ATQRCodeTexto nvarchar(4000)')
EXEC('ALTER TABLE tbDocumentosCompras ADD ATCUD nvarchar (70) null, ATQRCode image null, ATQRCodeTexto nvarchar(4000)')
EXEC('ALTER TABLE tbDocumentosStock ADD ATCUD nvarchar (70) null, ATQRCode image null, ATQRCodeTexto nvarchar(4000)')
EXEC('ALTER TABLE tbRecibos ADD ATCUD nvarchar (70) null, ATQRCode image null, ATQRCodeTexto nvarchar(4000)')

--alterar campos nas tabelas de compras
ALTER TABLE tbDocumentosCompras ALTER COLUMN IDTipoDocumento bigint NULL;
ALTER TABLE tbDocumentosCompras ALTER COLUMN DataDocumento datetime NULL;
ALTER TABLE tbDocumentosCompras ALTER COLUMN Impresso bit NULL;
ALTER TABLE tbDocumentosCompras ALTER COLUMN IDTiposDocumentoSeries bigint NULL;

ALTER TABLE tbDocumentosComprasLinhas ALTER COLUMN Descricao nvarchar(200) NULL;
ALTER TABLE tbDocumentosComprasLinhas ALTER COLUMN Ordem int NULL;

--novos campos de compras
EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbDocumentosCompras'' AND COLUMN_NAME = ''IDTemp'')
BEGIN
ALTER TABLE tbDocumentosCompras ADD IDTemp bigint NULL;
END')

EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbDocumentosCompras'' AND COLUMN_NAME = ''AcaoTemp'')
BEGIN
ALTER TABLE tbDocumentosCompras ADD AcaoTemp int NULL;
END')

EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbDocumentosComprasLinhas'' AND COLUMN_NAME = ''IDTemp'')
BEGIN
ALTER TABLE tbDocumentosComprasLinhas ADD IDTemp bigint NULL;
END')

EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbDocumentosComprasLinhas'' AND COLUMN_NAME = ''AcaoTemp'')
BEGIN
ALTER TABLE tbDocumentosComprasLinhas ADD AcaoTemp int NULL;
END')

--novos campos de tipos de documentos
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbtiposdocumentoseries'' AND COLUMN_NAME = ''Ativo'') 
Begin
ALTER TABLE tbtiposdocumentoseries ADD Ativo bit NULL;
End')

--novos campos de tipos de entidade
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbSistemaTiposEntidade'' AND COLUMN_NAME = ''Descricao'') 
Begin
ALTER TABLE tbSistemaTiposEntidade ADD Descricao nvarchar(200) NULL;
End')

--novo campo na tabela tbSistemaTiposDocumentoFiscal
EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbSistemaTiposDocumentoFiscal'' AND COLUMN_NAME = ''Codigo'')
BEGIN
ALTER TABLE  tbSistemaTiposDocumentoFiscal ADD Codigo nvarchar(10)
END')

--novo campo na tabela tbSistemaTiposDocumento
EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbSistemaTiposDocumento'' AND COLUMN_NAME = ''Codigo'')
BEGIN
ALTER TABLE  tbSistemaTiposDocumento ADD Codigo nvarchar(10)
END')

-- Novo Menu de Compras
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].tbMenus WHERE Descricao = ''PurchaseDocuments'')
BEGIN
INSERT INTO [F3MOGeral].[dbo].tbMenus(IDPai, Descricao, DescricaoAbreviada, ToolTip, Ordem, Icon, Accao, IDTiposOpcoesMenu,
	IDModulo, btnContextoAdicionar, btnContextoAlterar, btnContextoConsultar, btnContextoRemover, btnContextoExportar,
	btnContextoImprimir, btnContextoF4, Ativo, Sistema, DataCriacao, UtilizadorCriacao, btnContextoImportar, btnContextoDuplicar)
VALUES((SELECT ID FROM [F3MOGeral].[dbo].tbMenus WHERE Descricao = ''Compras''), ''PurchaseDocuments'', ''003.006'', ''PurchaseDocuments'', 50, ''f3icon-doc-compra'',
	''/BusinessDocuments/PurchaseDocuments'', 1, (select ID from tbSistemaModulos where Descricao = ''Compras''), 1, 1, 1, 1, 1, 1,
	NULL, 0, 0, getdate(), ''F3M'', 0, 0)

DECLARE @IDMenu int;
SELECT @IDMenu = ID FROM [F3MOGeral].[dbo].[tbMenus] WHERE Descricao = ''PurchaseDocuments'';
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [Importar], [Duplicar]) 
SELECT DISTINCT [IDPerfis], @IDMenu, [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], p.[Ativo], p.[Sistema], p.[DataCriacao], p.[UtilizadorCriacao], [Importar], [Duplicar]
FROM [F3MOGeral].dbo.tbmenus m 
inner join [F3MOGeral].dbo.tbPerfisAcessos p on 
p.IDMenus=m.id
WHERE m.Descricao = ''DocumentosCompras''

END')

-- Nova Lista Personalizada de Compras
EXEC('IF NOT EXISTS (SELECT * FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE Descricao = ''PurchaseDocuments'')
BEGIN

INSERT INTO [F3MOGeral].[dbo].tbListasPersonalizadas(Descricao, IDUtilizadorProprietario, PorDefeito, IDMenu, Sistema, Ativo,
	DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, Base, TabelaPrincipal, Query, IDSistemaCategListasPers, IDSistemaTipoLista)
VALUES(''PurchaseDocuments'', 1, 1, (SELECT ID FROM [F3MOGeral].[dbo].tbMenus WHERE Descricao = ''PurchaseDocuments''), 1, 1, GETDATE(),
	''F3M'', GETDATE(), ''F3M'', 1, ''tbDocumentosCompras'', NULL, NULL, 1)

INSERT INTO [F3MOGeral].[dbo].tbColunasListasPersonalizadas(ColunaVista, IDListaPersonalizada, Sistema, Ativo, DataCriacao,
	UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, Tabela, Visivel, TipoColuna, ColumnWidth, ECondicao, EColunaGrelha)
VALUES(''Store'', (SELECT ID FROM [F3MOGeral].[dbo].tbListasPersonalizadas WHERE Descricao = ''PurchaseDocuments''), 0, 1, GETDATE(),
	''F3M'', getdate(), ''F3M'', ''tbDocumentosCompras'', 1, 1, 150, 1, 1)

INSERT INTO [F3MOGeral].[dbo].tbColunasListasPersonalizadas(ColunaVista, IDListaPersonalizada, Sistema, Ativo, DataCriacao,
	UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, Tabela, Visivel, TipoColuna, ColumnWidth, ECondicao, EColunaGrelha)
VALUES(''DocumentTypeDescription'', (SELECT ID FROM [F3MOGeral].[dbo].tbListasPersonalizadas WHERE Descricao = ''PurchaseDocuments''), 0, 1, GETDATE(),
	''F3M'', getdate(), ''F3M'', ''tbDocumentosCompras'', 1, 1, 150, 1, 1)

INSERT INTO [F3MOGeral].[dbo].tbColunasListasPersonalizadas(ColunaVista, IDListaPersonalizada, Sistema, Ativo, DataCriacao,
	UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, Tabela, Visivel, TipoColuna, ColumnWidth, ECondicao, EColunaGrelha)
VALUES(''Document'', (SELECT ID FROM [F3MOGeral].[dbo].tbListasPersonalizadas WHERE Descricao = ''PurchaseDocuments''), 0, 1, GETDATE(),
	''F3M'', getdate(), ''F3M'', ''tbDocumentosCompras'', 1, 1, 150, 1, 1)

INSERT INTO [F3MOGeral].[dbo].tbColunasListasPersonalizadas(ColunaVista, IDListaPersonalizada, Sistema, Ativo, DataCriacao,
	UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, Tabela, Visivel, TipoColuna, ColumnWidth, ECondicao, EColunaGrelha)
VALUES(''ProviderDocumentNumber'', (SELECT ID FROM [F3MOGeral].[dbo].tbListasPersonalizadas WHERE Descricao = ''PurchaseDocuments''), 0, 1, GETDATE(),
	''F3M'', getdate(), ''F3M'', ''tbDocumentosCompras'', 1, 1, 150, 1, 1)

INSERT INTO [F3MOGeral].[dbo].tbColunasListasPersonalizadas(ColunaVista, IDListaPersonalizada, Sistema, Ativo, DataCriacao,
	UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, Tabela, Visivel, TipoColuna, ColumnWidth, ECondicao, EColunaGrelha)
VALUES(''DocumentDate'', (SELECT ID FROM [F3MOGeral].[dbo].tbListasPersonalizadas WHERE Descricao = ''PurchaseDocuments''), 0, 1, GETDATE(),
	''F3M'', getdate(), ''F3M'', ''tbDocumentosCompras'', 1, 1, 150, 1, 1)

INSERT INTO [F3MOGeral].[dbo].tbColunasListasPersonalizadas(ColunaVista, IDListaPersonalizada, Sistema, Ativo, DataCriacao,
	UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, Tabela, Visivel, TipoColuna, ColumnWidth, ECondicao, EColunaGrelha)
VALUES(''ProviderName'', (SELECT ID FROM [F3MOGeral].[dbo].tbListasPersonalizadas WHERE Descricao = ''PurchaseDocuments''), 0, 1, GETDATE(),
	''F3M'', getdate(), ''F3M'', ''tbDocumentosCompras'', 1, 1, 150, 1, 1)

INSERT INTO [F3MOGeral].[dbo].tbColunasListasPersonalizadas(ColunaVista, IDListaPersonalizada, Sistema, Ativo, DataCriacao,
	UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, Tabela, Visivel, TipoColuna, ColumnWidth, ECondicao, EColunaGrelha)
VALUES(''DocumentTotal'', (SELECT ID FROM [F3MOGeral].[dbo].tbListasPersonalizadas WHERE Descricao = ''PurchaseDocuments''), 0, 1, GETDATE(),
	''F3M'', getdate(), ''F3M'', ''tbDocumentosCompras'', 1, 3, 150, 1, 1)

INSERT INTO [F3MOGeral].[dbo].tbColunasListasPersonalizadas(ColunaVista, IDListaPersonalizada, Sistema, Ativo, DataCriacao,
	UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, Tabela, Visivel, TipoColuna, ColumnWidth, ECondicao, EColunaGrelha)
VALUES(''StateDescription'', (SELECT ID FROM [F3MOGeral].[dbo].tbListasPersonalizadas WHERE Descricao = ''PurchaseDocuments''), 0, 1, GETDATE(),
	''F3M'', getdate(), ''F3M'', ''tbDocumentosCompras'', 1, 1, 150, 1, 1)

END
')

-- Incluir as vistas para as novas compras
EXEC('IF NOT EXISTS(SELECT * FROM tbmapasvistas where entidade=''PurchaseDocuments'')
BEGIN
insert into tbmapasvistas (ordem, entidade, descricao, NomeMapa,caminho, Certificado,IDModulo,IDSistemaTipoDoc,IDSistemaTipoDocFiscal,IDLoja,SQLQuery,Tabela,Geral,Listagem,Ativo,Sistema,DataCriacao,UtilizadorCriacao, MapaXML,MapaBin, PorDefeito, SubReport,TipoReport)
select (select max(ordem) from tbMapasVistas) +ROW_NUMBER() OVER(ORDER BY id ASC) as ordem, ''PurchaseDocumentsList'' as  entidade, descricao, NomeMapa,caminho, Certificado,IDModulo,IDSistemaTipoDoc,IDSistemaTipoDocFiscal,IDLoja,SQLQuery,Tabela,Geral,Listagem,Ativo,Sistema,DataCriacao,UtilizadorCriacao, MapaXML,MapaBin, PorDefeito, SubReport,TipoReport from tbmapasvistas where entidade=''DocumentosCompras''
END')

--atualização do vwMapaIvaCompras tendo em conta o idtemp
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaIvaCompras'')) drop view vwMapaIvaCompras')

EXEC('create view [dbo].[vwMapaIvaCompras] as
select top 100 percent
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
(case when tbsistematiposiva.Codigo =''OUT'' then ''NOR'' else  tbsistematiposiva.Codigo end) as CodigoIva, 
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
LEFT JOIN tbsistematiposiva as tbsistematiposiva on tbDocumentosComprasLinhas.IDTipoIva=tbsistematiposiva.id
WHERE tbsistematiposestados.codigo=''EFT'' and tbSistemaTiposDocumento.Tipo=''CmpFinanceiro'' and tbDocumentosCompras.idtemp is null and isnull(tbDocumentosCompras.acaotemp,0) <> 1 and tbDocumentosComprasLinhas.idtemp is null and isnull(tbDocumentosComprasLinhas.acaotemp ,0) <> 1
GROUP BY tbDocumentosCompras.ID, tbDocumentosCompras.IDLoja, tbDocumentosCompras.NomeFiscal, tbDocumentosCompras.IDEntidade, tbDocumentosCompras.IDTipoDocumento, tbDocumentosCompras.IDTiposDocumentoSeries, tbDocumentosCompras.NumeroDocumento,
tbDocumentosCompras.DataDocumento, tbDocumentosCompras.Documento, tbDocumentosCompras.IDMoeda, tbDocumentosCompras.TaxaConversao, tbDocumentosCompras.Ativo, tbDocumentosComprasLinhas.TaxaIva, tbDocumentosComprasLinhas.IDTaxaIva,
tbLojas.Codigo, tbLojas.Descricao, tbFornecedores.Codigo, tbFornecedores.Nome, tbFornecedores.NContribuinte, tbTiposDocumento.Codigo,tbDocumentosCompras.UtilizadorCriacao,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end), tbSistemaTiposEstados.Codigo, tbSistemaNaturezas.Codigo, tbsistematiposestados.codigo, tbsistematiposestados.Descricao, tbTiposDocumento.Codigo, tbTiposDocumento.Descricao, 
tbsistematiposiva.Codigo,tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao
ORDER BY tbDocumentosCompras.ID ')

--atualização do vwMapaRankingCompras tendo em conta o idtemp
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
where tbsistematiposestados.codigo=''EFT'' and tbsistematiposdocumento.tipo=''CmpFinanceiro'' and tbDocumentosCompras.idtemp is null and isnull(tbDocumentosCompras.acaotemp,0) <> 1 and tbDocumentosComprasLinhas.idtemp is null and isnull(tbDocumentosComprasLinhas.acaotemp ,0) <> 1
group by 
tbArtigos.Codigo,tbArtigos.Descricao,tbArtigosLotes.Codigo ,tbArtigosLotes.Descricao ,tbTiposArtigos.Codigo ,tbTiposArtigos.Descricao ,tbLojas.Codigo ,tbLojas.Descricao ,tbFornecedores.Codigo ,tbFornecedores.Nome ,tbMarcas.Codigo,tbMarcas.Descricao,
tbdocumentoscompras.IDMoeda, tbdocumentoscompras.TaxaConversao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbdocumentoscompras.DataDocumento, tbdocumentoscompras.UtilizadorCriacao')

--atualização do vwMapaPendentesCompras tendo em conta o idtemp
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaPendentesCompras'')) drop view vwMapaPendentesCompras')

EXEC('create view [dbo].[vwMapaPendentesCompras] as
select 
tbDocumentosCompras.ID, 
tbDocumentosCompras.IDLoja, 
tbDocumentosCompras.NomeFiscal, 
tbDocumentosCompras.IDEntidade, 
tbDocumentosCompras.IDTipoDocumento, 
tbDocumentosCompras.IDTiposDocumentoSeries, 
tbDocumentosCompras.NumeroDocumento, 
tbDocumentosCompras.DataDocumento,
tbdocumentoscompras.UtilizadorCriacao as Utilizador, 
tbDocumentosCompras.Documento, 
tbDocumentosCompras.IDMoeda, 
tbDocumentosCompras.TaxaConversao, 
tbDocumentosCompras.Ativo as Ativo,
tbLojas.Codigo as CodigoLoja, 
tbLojas.Descricao as DescricaoLoja,
tbFornecedores.Codigo as CodigoFornecedor, 
tbFornecedores.NContribuinte as NContribuinte, 
tbTiposDocumento.Codigo as CodigoTipoDocumento, 
tbTiposDocumento.Descricao as DescricaoTipoDocumento,
tbTiposDocumentoSeries.CodigoSerie as DescricaoTipoDocumentoSerie, 
tbSistemaNaturezas.Codigo as CodigoNatureza,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,
isnull(tbDocumentosComprasPendentes.TotalMoedaDocumento, 0)*(case when tbSistemaNaturezas.Codigo=''R'' then -1 else  1 end) as Valor,
isnull(tbDocumentosComprasPendentes.ValorPendente, 0)*(case when tbSistemaNaturezas.Codigo=''R'' then -1 else  1 end) as ValorPendente,
isnull(tbDocumentosComprasPendentes.Pago, 0) as Pago,
Round(isnull((
select Sum((Case tbCCSaldoAgreg.IDSistemaNaturezas when 12 then 1 else -1 end) * tbCCSaldoAgreg.ValorPendente * (Case D.CodigoTipoEstado when ''EFT'' then 1 else 0 end)) FROM tbDocumentosComprasPendentes as tbCCSaldoAgreg inner join tbDocumentosCompras as D on tbCCSaldoAgreg.IDDocumentoCompra=d.ID
WHERE tbCCSaldoAgreg.IDEntidade= tbDocumentosComprasPendentes.IDEntidade
AND tbCCSaldoAgreg.DataCriacao <= tbDocumentosComprasPendentes.DataCriacao
AND (tbCCSaldoAgreg.IDSistemaNaturezas in (12,13))
AND ((tbCCSaldoAgreg.IDTipoDocumento<>tbDocumentosComprasPendentes.IDTipoDocumento OR tbCCSaldoAgreg.IDDocumentoCompra <> tbDocumentosComprasPendentes.IDDocumentoCompra
       ) OR (tbCCSaldoAgreg.IDTipoDocumento = tbDocumentosComprasPendentes.IDTipoDocumento AND tbCCSaldoAgreg.IDDocumentoCompra = tbDocumentosComprasPendentes.IDDocumentoCompra
		AND tbCCSaldoAgreg.ID<=tbDocumentosComprasPendentes.ID))),0),isnull(tbMoedas.CasasDecimaisTotais,0)) as Saldo,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
datediff(day,tbDocumentosCompras.DataDocumento,getdate()) as NumeroDias,
tbMoedas.CasasDecimaisTotais as Valornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as ValorPendentenumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Saldonumcasasdecimais,
0 as NumeroDiasnumcasasdecimais
FROM tbDocumentosComprasPendentes AS tbDocumentosComprasPendentes with (nolock) 
LEFT JOIN  tbDocumentosCompras AS tbDocumentosCompras with (nolock) ON tbDocumentosCompras.id=tbDocumentosComprasPendentes.IDDocumentoCompra
LEFT JOIN  tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.id=tbDocumentosCompras.IDentidade
LEFT JOIN  tbLojas AS tbLojas with (nolock) ON tbLojas.id=tbDocumentosCompras.IDLoja
LEFT JOIN  tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosCompras.IDMoeda
LEFT JOIN  tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbDocumentosCompras.IDTipoDocumento AND not tbTiposDocumento.idsistematiposdocumentofiscal is null 
LEFT JOIN  tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbTiposDocumento.IDSistemaNaturezas=tbSistemaNaturezas.ID
LEFT JOIN  tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbDocumentosCompras.IDTiposDocumentoSeries
LEFT JOIN  tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbTiposDocumento.IDSistemaTiposDocumento=tbSistemaTiposDocumento.ID
LEFT JOIN  tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbDocumentosCompras.IDEstado
LEFT JOIN  tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
WHERE tbsistematiposestados.codigo=''EFT'' and tbSistemaTiposDocumento.Tipo=''CmpFinanceiro'' and isnull(tbDocumentosComprasPendentes.ValorPendente,0)>0 and tbDocumentosCompras.idtemp is null and isnull(tbDocumentosCompras.acaotemp ,0) <> 1 
GROUP BY tbDocumentosCompras.ID, tbDocumentosCompras.IDLoja, tbDocumentosCompras.NomeFiscal, tbDocumentosCompras.IDEntidade, tbDocumentosCompras.IDTipoDocumento, tbDocumentosCompras.IDTiposDocumentoSeries, tbDocumentosCompras.NumeroDocumento,
tbDocumentosCompras.DataDocumento, tbDocumentosCompras.Documento, tbDocumentosCompras.IDMoeda, tbDocumentosCompras.TaxaConversao, tbDocumentosCompras.Ativo, 
tbLojas.Codigo, tbLojas.Descricao, tbFornecedores.Codigo, tbFornecedores.Nome, tbFornecedores.NContribuinte, tbTiposDocumento.Codigo,tbTiposDocumentoSeries.CodigoSerie,tbdocumentoscompras.UtilizadorCriacao,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end),
tbSistemaNaturezas.Codigo, tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao,
isnull(tbDocumentosComprasPendentes.TotalMoedaDocumento, 0), isnull(tbDocumentosComprasPendentes.ValorPendente,0), isnull(tbDocumentosComprasPendentes.Pago, 0) 
,tbDocumentosComprasPendentes.IDEntidade, tbDocumentosComprasPendentes.DataCriacao,tbDocumentosComprasPendentes.IDTipoDocumento,tbTiposDocumento.Codigo, tbTiposDocumento.Descricao,tbDocumentosComprasPendentes.IDDocumentoCompra,tbDocumentosComprasPendentes.ID                    
ORDER BY tbDocumentosCompras.ID  OFFSET 0 ROWS ')

--atualização do vwMapaIvaVendas tendo em conta o idtemp
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
tbsistematiposiva.Codigo as CodigoIva, 
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
LEFT JOIN tbsistematiposiva as tbsistematiposiva on tbDocumentosVendasLinhas.IDTipoIva=tbsistematiposiva.id
WHERE tbsistematiposestados.codigo<>''RSC'' and tbSistemaTiposDocumento.Tipo=''VndFinanceiro'' and tbSistemaTiposDocumentoFiscal.Tipo<>''NF''
GROUP BY tbDocumentosVendas.ID, tbDocumentosVendas.IDLoja, tbDocumentosVendas.NomeFiscal, tbDocumentosVendas.IDEntidade, tbDocumentosVendas.IDTipoDocumento, tbDocumentosVendas.IDTiposDocumentoSeries, tbDocumentosVendas.NumeroDocumento,
tbDocumentosVendas.DataDocumento, tbDocumentosVendas.Documento, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbDocumentosVendas.Ativo, tbDocumentosVendasLinhas.TaxaIva, tbDocumentosVendasLinhas.IDTaxaIva,
tbLojas.Codigo, tbLojas.Descricao, tbClientes.Codigo, tbClientes.Nome, tbClientes.NContribuinte, tbTiposDocumento.Codigo, tbDocumentosVendas.UtilizadorCriacao, 
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end), 
tbSistemaNaturezas.Codigo, tbCampanhas.Codigo, tbsistematiposestados.codigo,tbsistematiposestados.Descricao, tbTiposDocumento.Codigo, tbTiposDocumento.Descricao, tbsistematiposiva.Codigo, tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao
ORDER BY tbDocumentosVendas.ID OFFSET 0 ROWS ')

--atualização do sp_AtualizaCCFornecedores tendo em conta o idtemp
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
									where DV.IDTemp is null and isnull(DV.acaotemp,0)<>1 and DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)
				
			    SELECT @strSqlQuery = @strSqlQueryInsert + '' select (case when TSN.Codigo=''''R'''' then ''''P'''' else  ''''R'''' end) as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbdocumentoscompras DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									left join tbSistemaTiposDocumentoFiscal TDFisc ON TDFisc.ID = TD.IDSistemaTiposDocumentoFiscal
									where DV.IDTemp is null and isnull(DV.acaotemp,0)<>1 and (isnull(TDFisc.Tipo,'''''''') = ''''FS'''' OR isnull(TDFisc.Tipo,'''''''') = ''''FR'''' OR isnull(TDFisc.Tipo,'''''''') = ''''NC'''' ) AND ISNULL(TD.GeraPendente,0)=0 AND ISNULL(TD.GereContaCorrente,0)<>0 AND DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)
				
				SELECT @strSqlQuery = @strSqlQueryInsert + '' select TSN.Codigo as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbpagamentoscompras DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)

				IF (@lngidDocumento>0 and @lngidTipoDocumento>0)
					BEGIN
						IF exists(select ID FROM tbpagamentoscompras WHERE IDTipoDocumento=@lngidTipoDocumento and ID=@lngidDocumento and isnull(TotalDescontos,0)<>0)
						BEGIN
							SELECT @strSqlQuery = @strSqlQueryInsert + '' select  TSN.Codigo as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, ''''DERC '''' + ''''(desc. '''' + DV.Documento + '''')'''', DV.IDMoeda, 0, round(round(((isnull(DV.TotalMoedaDocumento,0) + isnull(DV.TotalDescontos,0)) /DV.TaxaConversao),M.CasasDecimaisTotais) - isnull(DV.TotalMoedaReferencia,0),M.CasasDecimaisTotais), 0, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbpagamentoscompras DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									left join tbMoedas as M on M.id = DV.IDMoeda
									where DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
							EXEC(@strSqlQuery)
						END

						IF exists(select ID FROM tbpagamentoscompras WHERE IDTipoDocumento=@lngidTipoDocumento and ID=@lngidDocumento and isnull(TotalDifCambialMoedaReferencia,0)<>0)
						BEGIN
							SELECT @strSqlQuery = @strSqlQueryInsert + '' select Case When DV.TotalDifCambialMoedaReferencia<0 Then ''''R'''' else ''''P'''' end as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, Case When DV.TotalDifCambialMoedaReferencia<0 Then ''''DPPC '''' else ''''DPPD '''' end + ''''(dif. cambial '''' + DV.Documento + '''')'''', DV.IDMoeda, 0, Abs(DV.TotalDifCambialMoedaReferencia), 0, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbpagamentoscompras DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
							EXEC(@strSqlQuery)
						END
					END
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

		  UPDATE tbfornecedores set saldo=isnull(tbcc.saldo,0) FROM tbfornecedores Cli
			   INNER JOIN (
			   select identidade, isnull(sum(case when natureza=''R'' then totalmoedareferencia else -totalmoedareferencia end ),0) as saldo from tbCCFornecedores where identidade=@lngidEntidade group by IDEntidade) tbcc
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

--atualização do sp_AtualizaStock tendo em conta o idtemp
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
	@inValidaStock AS bit,
	@inRecalculoTotal AS bit=0
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
	@strWhereQuantidades AS nvarchar(1500) = NULL,
	@strWhereIDTemp AS nvarchar(1500) = ''''

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
									IF (@strTabelaCabecalho = ''tbDocumentosCompras'')
									BEGIN
										SET @strWhereIDTemp ='' and cab.idtemp is null and isnull(cab.acaotemp,0)<>1 and Linhas.idtemp is null and isnull(Linhas.acaotemp,0)<>1 ''
									END

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
															@strWhereQuantidades +  @strWhereIDTemp + @strQueryOrdenacao
									print ''compras''
									print @strSqlQuery
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

--atualização do sp_AtualizaUPC tendo em conta o idtemp
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaUPC]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaUPC]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaUPC]  
    @lngidDocumento AS bigint = NULL,
    @lngidTipoDocumento AS bigint = NULL,
    @intAccao AS int = 0,
    @strTabelaCabecalho AS nvarchar(250) = '''', 
    @strTabelaLinhas AS nvarchar(250) = '''',
    @strTabelaLinhasDist AS nvarchar(250) = '''',
    @strCampoRelTabelaLinhasCab AS nvarchar(100) = '''',
    @strCampoRelTabelaLinhasDistLinhas AS nvarchar(100) = '''',
    @strUtilizador AS nvarchar(256) = ''''
AS  BEGIN
SET NOCOUNT ON
DECLARE    
    @ErrorMessage AS varchar(2000),
    @ErrorSeverity AS tinyint,
    @ErrorState AS tinyint,
    @strWhereQuantidades AS nvarchar(1500) = NULL,
    @bitUltimoPrecoCusto AS bit = 0,
    @strSqlQuery AS varchar(max),--variavel para query''s dinamicos
    @strQueryWhere AS nvarchar(1024) = '''',
    @strQueryCampos AS nvarchar(1024) = '''',
	@strWhereIDTemp AS nvarchar(1024) = ''''

BEGIN TRY
    --Carrega propriedades do tipo de documento
    SELECT     @bitUltimoPrecoCusto = isnull(TD.UltimoPrecoCusto,0)
    FROM tbTiposDocumento TD
    LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TD.IDSistemaTiposDocumentoMovStock
    WHERE TD.ID=@lngidTipoDocumento and TDMS.Codigo = ''002''
    --Atualiza ultimo preço de custo com base no artigo e documento
    IF @bitUltimoPrecoCusto<>0
        BEGIN
			IF (@strTabelaCabecalho = ''tbDocumentosCompras'')
			BEGIN
				SET @strWhereIDTemp ='' and cab.idtemp is null and isnull(cab.acaotemp,0)<>1 and Linhas.idtemp is null and isnull(Linhas.acaotemp,0)<>1 ''
			END

            SET @strSqlQuery ='' FROM tbArtigos AS ArtStok
                                INNER JOIN (
                                SELECT distinct Linhas.IDArtigo, isnull(Linhas.UPCMoedaRef ,0) AS UPCMoedaRef, isnull(Linhas.UPCompraMoedaRef ,0) AS UPCompraMoedaRef,
                                isnull(Linhas.UltCustosAdicionaisMoedaRef ,0) AS UltCustosAdicionaisMoedaRef, isnull(Linhas.UltDescComerciaisMoedaRef ,0) AS UltDescComerciaisMoedaRef,
                                Cab.DataControloInterno, Cab.ID, Cab.IDTipoDocumento
                                FROM '' + QUOTENAME(@strTabelaLinhas) + ''  AS Linhas
                                LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + ''
                                INNER JOIN (
                                    SELECT Linhas.IDArtigo, Max(isnull(Linhas.Ordem,0)) AS Ordem FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas
                                    LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + ''
                                    LEFT JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = Cab.IDTipoDocumento
                                    WHERE NOT Linhas.IDArtigo is NULL and Cab.IDTipoDocumento = '' + Convert(nvarchar,@lngidTipoDocumento) + '' AND Linhas.'' + @strCampoRelTabelaLinhasCab + '' = '' + Convert(nvarchar,@lngidDocumento) +
                                    '' AND isnull(TPDoc.DocNaoValorizado,0) = 0  
                                    GROUP BY Linhas.IDArtigo
                                ) AS LinhasArtigos
                                ON (LinhasArtigos.IDArtigo = Linhas.IDArtigo AND isnull(LinhasArtigos.Ordem,0) = isnull(Linhas.Ordem,0))
                                LEFT JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = Cab.IDTipoDocumento
                                WHERE NOT Linhas.IDArtigo is NULL and Cab.IDTipoDocumento ='' + Convert(nvarchar,@lngidTipoDocumento) + '' AND Linhas.'' + @strCampoRelTabelaLinhasCab + '' = '' + Convert(nvarchar,@lngidDocumento) + 
                                '' AND isnull(TPDoc.DocNaoValorizado,0) = 0 '' + @strWhereIDTemp + '' 
                                ) AS ART
                                ON ArtStok.ID = ART.IDArtigo ''
            IF (@intAccao = 0 OR @intAccao = 1) --adiona ou alterar
                BEGIN
                    SET @strQueryCampos  = ''UPDATE tbArtigos SET UltimoPrecoCusto = ART.UPCMoedaRef, UltimoPrecoCompra = ART.UPCompraMoedaRef,
                                           UltimosCustosAdicionais = ART.UltCustosAdicionaisMoedaRef, UltimosDescontosComerciais = ART.UltDescComerciaisMoedaRef,
                                           IDTipoDocumentoUPC = ART.IDTipoDocumento, IDDocumentoUPC = ART.ID, DataControloUPC = ART.DataControloInterno, RecalculaUPC = 0 ''
                    SET @strQueryWhere = '' WHERE (ArtStok.IDDocumentoUPC IS NULL OR (NOT ArtStok.IDDocumentoUPC IS NULL AND ART.DataControloInterno >= ArtStok.DataControloUPC))''
                END
            ELSE--apagar
                BEGIN
                    SET @strQueryWhere  = '' WHERE ArtStok.IDDocumentoUPC = ART.ID AND ArtStok.IDTipoDocumentoUPC = ART.IDTipoDocumento ''
                    SET @strQueryCampos = '' UPDATE tbArtigos SET RecalculaUPC = 1 ''
                END
            EXEC(@strQueryCampos + @strSqlQuery + @strQueryWhere )
            --para quem tem dimensoes, atualiza por dimensao FALTA CAMPOS POR DIMENSAO
            IF len(@strTabelaLinhasDist)>0
                BEGIN
                    SET @strSqlQuery ='' FROM tbArtigosDimensoes AS ArtStok
                                        INNER JOIN (
                                        SELECT distinct Linhas.IDArtigo,LinhasDist.IDArtigoDimensao, isnull(LinhasDist.UPCMoedaRef ,0) AS UPCMoedaRef, isnull(LinhasDist.UPCompraMoedaRef ,0) AS UPCompraMoedaRef,
                                        isnull(LinhasDist.UltCustosAdicionaisMoedaRef ,0) AS UltCustosAdicionaisMoedaRef, isnull(LinhasDist.UltDescComerciaisMoedaRef ,0) AS UltDescComerciaisMoedaRef,
                                        Cab.DataControloInterno, Cab.ID, Cab.IDTipoDocumento
                                        FROM '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhasDist 
                                        LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON Linhas.ID = LinhasDist.'' + @strCampoRelTabelaLinhasDistLinhas + ''
                                        LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + ''
                                        INNER JOIN (
                                            SELECT Linhas.IDArtigo, LinhasDist.IDArtigoDimensao, Max(isnull(LinhasDist.Ordem,0)) AS Ordem FROM '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhasDist
                                            LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON Linhas.ID = LinhasDist.'' + @strCampoRelTabelaLinhasDistLinhas + ''
                                            LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + ''
                                            LEFT JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = Cab.IDTipoDocumento
                                            WHERE NOT Linhas.IDArtigo is NULL and Cab.IDTipoDocumento = '' + Convert(nvarchar,@lngidTipoDocumento) + '' AND Linhas.'' + @strCampoRelTabelaLinhasCab + '' = '' + Convert(nvarchar,@lngidDocumento) +
                                            '' AND isnull(TPDoc.DocNaoValorizado,0) = 0  AND NOT LinhasDist.IDArtigoDimensao IS NULL
                                            GROUP BY Linhas.IDArtigo,LinhasDist.IDArtigoDimensao
                                        ) AS LinhasArtigos
                                        ON (LinhasArtigos.IDArtigoDimensao = LinhasDist.IDArtigoDimensao AND LinhasArtigos.IDArtigo = Linhas.IDArtigo AND isnull(LinhasArtigos.Ordem,0) = isnull(LinhasDist.Ordem,0))
                                        LEFT JOIN tbTiposDocumento AS TPDoc ON TPDoc.ID = Cab.IDTipoDocumento
                                        WHERE NOT Linhas.IDArtigo is NULL and Cab.IDTipoDocumento ='' + Convert(nvarchar,@lngidTipoDocumento) + '' AND Linhas.'' + @strCampoRelTabelaLinhasCab + '' = '' + Convert(nvarchar,@lngidDocumento) + 
                                        '' AND isnull(TPDoc.DocNaoValorizado,0) = 0  AND NOT LinhasDist.IDArtigoDimensao IS NULL
                                        ) AS ART
                                        ON ArtStok.IDArtigo = ART.IDArtigo AND ArtStok.ID = ART.IDArtigoDimensao''
                    IF (@intAccao = 0 OR @intAccao = 1) --adiona ou alterar
                        BEGIN
                            SET @strQueryCampos  = ''UPDATE tbArtigosDimensoes SET UPC = ART.UPCMoedaRef, UltPrecoComp  = ART.UPCompraMoedaRef,
                                                    UltimoCustoAdicional = ART.UltCustosAdicionaisMoedaRef, 
                                                    IDTipoDocumentoUPC = ART.IDTipoDocumento, IDDocumentoUPC = ART.ID, DataControloUPC = ART.DataControloInterno, RecalculaUPC = 0 ''
                            SET @strQueryWhere = '' WHERE (ArtStok.IDDocumentoUPC IS NULL OR (NOT ArtStok.IDDocumentoUPC IS NULL AND ART.DataControloInterno >= ArtStok.DataControloUPC))''
                        END
                    ELSE--apagar
                        BEGIN
                            SET @strQueryWhere  = '' WHERE ArtStok.IDDocumentoUPC = ART.ID AND ArtStok.IDTipoDocumentoUPC = ART.IDTipoDocumento ''
                            SET @strQueryCampos = '' UPDATE tbArtigosDimensoes SET RecalculaUPC = 1 ''
                        END
                    EXEC(@strQueryCampos + @strSqlQuery + @strQueryWhere)
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

--atualização do sp_AtualizaQtdRequisitada tendo em conta o idtemp
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaQtdRequisitada]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaQtdRequisitada]')

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
					WHERE NOT Linhas.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') = ''0'' AND STDoc.Tipo = ''CmpEncomenda'' and isnull(art.GereStock,0) <> 0
					 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento and Doc.IDTemp IS NULL and isnull(Doc.acaotemp,0)<>1 and Linhas.IDTemp IS NULL and isnull(Linhas.acaotemp,0)<>1 
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
								Linhas.IDArtigoPara,
								Linhas.IDArtigoPA,
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
																	ArtStok.IDArtigoPara=Linhas.IDArtigoPara and ArtStok.IDArtigoPA=Linhas.IDArtigoPA and
																	isnull(ArtStok.IDLoja,0) = isnull(Doc.IDLoja,0) and isnull(ArtStok.IDArmazem,0) = isnull(Linhas.IDArmazem,0) and
																	isnull(ArtStok.IDArmazemLocalizacao,0) = isnull(Linhas.IDArmazemLocalizacao,0) and 
																	isnull(ArtStok.IDArtigoLote,0) = isnull(Linhas.IDLote,0) and
																	isnull(ArtStok.IDArtigoNumeroSerie,0) = isnull(Linhas.IDArtigoNumSerie,0))
					LEFT JOIN tbTiposDocumento AS Tpinicial ON Tpinicial.id = Linhas.IDTipoDocumentoOrigemInicial
					WHERE NOT Linhas.IDArtigo IS NULL AND isnull(STD.Codigo,''0'') = ''0'' AND STDoc.Tipo = ''CmpEncomenda'' and isnull(art.GereStock,0) <> 0
						and  isnull(Tpinicial.ReservaStock,0) <> 0  and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento
					GROUP BY Linhas.IDTipoDocumentoOrigemInicial,
								Linhas.IDDocumentoOrigemInicial,
								Linhas.IDLinhaDocumentoOrigemInicial,
								Linhas.IDDocumentoOrigemInicial,
								Linhas.IDArtigoPara,
								Linhas.IDArtigoPA,
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
									artStock.IDArtigoPA=artigosdoc.IDArtigoPA and artStock.IDArtigoPara=artigosdoc.IDArtigoPara and
									isnull(artStock.IDLoja,0) = isnull(artigosdoc.IDLoja,0) and 
									isnull(artStock.IDArmazem,0) = isnull(artigosdoc.IDArmazem,0) and
									isnull(artStock.IDArmazemLocalizacao,0) = isnull(artigosdoc.IDArmazemLocalizacao,0) and 
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
											Linhas.IDArtigoPara,
											Linhas.IDArtigoPA,
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
																				ArtStok.IDArtigoPara=Linhas.IDArtigoPara and ArtStok.IDArtigoPA=Linhas.IDArtigoPA and
																      			isnull(ArtStok.IDLoja,0) = isnull(Doc.IDLoja,0) and isnull(ArtStok.IDArmazem,0) = isnull(Linhas.IDArmazem,0) and
																				isnull(ArtStok.IDArmazemLocalizacao,0) = isnull(Linhas.IDArmazemLocalizacao,0) and 
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
											Linhas.IDArtigoPA,
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
												artStock.IDArtigoPA=artigosdoc.IDArtigoPA and 	artStock.IDArtigoPara=artigosdoc.IDArtigoPara and
												isnull(artStock.IDLoja,0) = isnull(artigosdoc.IDLoja,0) and 
												isnull(artStock.IDArmazem,0) = isnull(artigosdoc.IDArmazem,0) and
												isnull(artStock.IDArmazemLocalizacao,0) = isnull(artigosdoc.IDArmazemLocalizacao,0) and 
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
							 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento and Doc.IDTemp IS NULL and isnull(Doc.acaotemp,0)<>1 and CCART.IDTemp IS NULL and isnull(CCART.acaotemp,0)<>1

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
							 and Doc.ID = @lngidDocumento and Doc.IDTipoDocumento = @lngidTipoDocumento and Doc.IDTemp IS NULL and isnull(Doc.acaotemp,0)<>1 and Linhas.IDTemp IS NULL and isnull(Linhas.acaotemp,0)<>1
							GROUP BY Linhas.IDArtigo
						) AS artigosdoc ON artigosdoc.IDArtigo = artStock.IDArtigo	
						--******FIM DE TRATAR ARTIGOS*****

					    --******TRATAR StockArtigosNecessidades*****
						--inserir os registos que nao existem ainda na tabela tbStockArtigosNecessidades
						INSERT INTO tbStockArtigosNecessidades(IDTipoDocumento, Documento, IDDocumento, IDLinhaDocumento,IDOrdemFabrico,IDArtigoPA, IDArtigoPara, IDArtigo,IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote,
						IDArtigoNumeroSerie,Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao) 
						SELECT distinct CCART.IDTipoDocumentoOrigemInicial AS IDTipoDocumento,
										CCART.DocumentoOrigemInicial AS Documento,
										CCART.IDDocumentoOrigemInicial AS IDDocumento,
										CCART.IDLinhaDocumentoOrigemInicial AS IDLinhaDocumento,
										CCART.IDDocumentoOrigemInicial AS IDOrdemFabrico,
										CCART.IDArtigoPA,
										CCART.IDArtigoPara,
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
																						ArtStok.IDArtigoPA=CCART.IDArtigoPA and ArtStok.IDArtigoPara=CCART.IDArtigoPara and
																						isnull(ArtStok.IDLoja,0) = isnull(Doc.IDLoja,0) and isnull(ArtStok.IDArmazem,0) = isnull(CCART.IDArmazem,0) and
																						isnull(ArtStok.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) and 
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
										Linhas.IDArtigoPara,
										Linhas.IDArtigoPA,
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
																			ArtStok.IDArtigoPara=Linhas.IDArtigoPara and ArtStok.IDArtigoPA=Linhas.IDArtigoPA and
																      		isnull(ArtStok.IDLoja,0) = isnull(Doc.IDLoja,0) and isnull(ArtStok.IDArmazem,0) = isnull(Linhas.IDArmazem,0) and
																			isnull(ArtStok.IDArmazemLocalizacao,0) = isnull(Linhas.IDArmazemLocalizacao,0) and 
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
										Linhas.IDArtigoPA,
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
											artStock.IDArtigoPara=artigosdoc.IDArtigoPara and
											artStock.IDArtigoPA=artigosdoc.IDArtigoPA and
											isnull(artStock.IDLoja,0) = isnull(artigosdoc.IDLoja,0) and 
											isnull(artStock.IDArmazem,0) = isnull(artigosdoc.IDArmazem,0) and
											isnull(artStock.IDArmazemLocalizacao,0) = isnull(artigosdoc.IDArmazemLocalizacao,0) and 
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
					INSERT INTO tbStockArtigosNecessidades(IDTipoDocumento, Documento, IDDocumento, IDLinhaDocumento,IDOrdemFabrico,IDArtigoPara, IDArtigoPA, IDArtigo,IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote,
					IDArtigoNumeroSerie, IDArtigoDimensao, IDDimensaoLinha1, IDDimensaoLinha2, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao) 
					SELECT distinct Linhas.IDTipoDocumentoOrigemInicial AS IDTipoDocumento,
									Linhas.DocumentoOrigemInicial AS Documento,
									Linhas.IDDocumentoOrigemInicial AS IDDocumento,
									Linhas.IDLinhaDocumentoOrigemInicial AS IDLinhaDocumento,
									Linhas.IDDocumentoOrigemInicial AS IDOrdemFabrico,
									Linhas.IDArtigoPara,
									Linhas.IDArtigoPA,
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
																					ArtStok.IDArtigoPara=Linhas.IDArtigoPara and ArtStok.IDArtigoPA=Linhas.IDArtigoPA and
																					isnull(ArtStok.IDLoja,0) = isnull(Doc.IDLoja,0) and isnull(ArtStok.IDArmazem,0) = isnull(Linhas.IDArmazem,0) and
																					isnull(ArtStok.IDArmazemLocalizacao,0) = isnull(Linhas.IDArmazemLocalizacao,0) and 
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
									Linhas.IDArtigoPara,
									Linhas.IDArtigoPA,
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
																		ArtStok.IDArtigoPara=Linhas.IDArtigoPara and ArtStok.IDArtigoPA=Linhas.IDArtigoPA and
																      	isnull(ArtStok.IDLoja,0) = isnull(Doc.IDLoja,0) and isnull(ArtStok.IDArmazem,0) = isnull(Linhas.IDArmazem,0) and
																		isnull(ArtStok.IDArmazemLocalizacao,0) = isnull(Linhas.IDArmazemLocalizacao,0) and 
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
									Linhas.IDArtigoPA,
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
										artStock.IDArtigoPA=artigosdoc.IDArtigoPA and artStock.IDArtigoPara=artigosdoc.IDArtigoPara and
										isnull(artStock.IDLoja,0) = isnull(artigosdoc.IDLoja,0) and 
										isnull(artStock.IDArmazem,0) = isnull(artigosdoc.IDArmazem,0) and
										isnull(artStock.IDArmazemLocalizacao,0) = isnull(artigosdoc.IDArmazemLocalizacao,0) and 
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
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID and d.idTemp is null and isnull(d.acaoTemp,0)<>1
inner join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbSistemaTiposDocumentoFiscal TDF on td.IDSistemaTiposDocumentoFiscal=TDF.ID
left join tbEstados s on d.IDEstado=s.ID
LEFT JOIN tbParametrosEmpresa as P ON 1 = 1
LEFT JOIN tbMoedas as tbMoedasRef ON tbMoedasRef.ID=P.IDMoedaDefeito
''where id in (@IDLista)')

--atualizar vista de compras
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
SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosCompras" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Constantes&#xD;&#xA;&#xD;&#xA;Private dblTransportar as Double = 0&#xD;&#xA;Private dblTransporte as Double = 0&#xD;&#xA;&#xD;&#xA;Private Sub Documentos_Compras_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim SimboloMoeda As String = String.Empty&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Parameters.Item(&quot;AcompanhaBens&quot;).Value = False&#xD;&#xA;    Parameters.Item(&quot;IDLinha&quot;).Value = GetCurrentColumnValue(&quot;tbDocumentosComprasLinhas_ID&quot;)        &#xD;&#xA;    Parameters.Item(&quot;CasasMoedas&quot;).Value = GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisIva&quot;)&#xD;&#xA;        &#xD;&#xA;    SimboloMoeda = GetCurrentColumnValue(&quot;tbMoedas_Simbolo&quot;)&#xD;&#xA;    If SimboloMoeda = &quot;&quot; Then&#xD;&#xA;        Parameters.Item(&quot;SimboloMoedas&quot;).Value = &quot;€&quot;&#xD;&#xA;        SimboloMoeda = &quot;€&quot;&#xD;&#xA;    Else&#xD;&#xA;        Me.Parameters.Item(&quot;SimboloMoedas&quot;).Value = SimboloMoeda&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) then&#xD;&#xA;        lblPreco.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Preco&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTotalFinal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Total&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDesconto1.Text = resource.GetResource(&quot;Desconto1&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDesconto2.Text = resource.GetResource(&quot;Desconto2&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescontosLinha.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoLinha&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescontoGlobal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoGlobal&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTotalIva.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalIva&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    End If&#xD;&#xA;    Select Case GetCurrentColumnValue(&quot;tbSistemaTiposDocumento_Tipo&quot;)&#xD;&#xA;        Case &quot;CmpOrcamento&quot;, &quot;CmpTransporte&quot;, &quot;CmpFinanceiro&quot;&#xD;&#xA;            If GetCurrentColumnValue(&quot;tbSistemaNaturezas_Codigo&quot;) = &quot;P&quot; Then&#xD;&#xA;                lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens1_CodigoDestino&quot;)&#xD;&#xA;                fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens1_CodigoDestino&quot;)&#xD;&#xA;                fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes1_Codigo&quot;)&#xD;&#xA;                fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes1_Codigo&quot;)&#xD;&#xA;            ElseIf GetCurrentColumnValue(&quot;tbSistemaNaturezas_Codigo&quot;) = &quot;R&quot; Then&#xD;&#xA;                lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;                fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;                fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;                fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;            End If&#xD;&#xA;        Case &quot;CmpEncomenda&quot;&#xD;&#xA;            lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;            fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;            fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;            fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;    End Select&#xD;&#xA;    ''''Assinatura&#xD;&#xA;    Dim strAssinatura As String = String.Empty&#xD;&#xA;    Dim strAss As String = String.Empty&#xD;&#xA;    Dim strMsg As String = String.Empty&#xD;&#xA;    If GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt) &gt; 0 Then&#xD;&#xA;        strAss = GetCurrentColumnValue(&quot;MensagemDocAT&quot;).Substring(0, GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt))&#xD;&#xA;        strMsg = GetCurrentColumnValue(&quot;MensagemDocAT&quot;).Substring(GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt) + Constantes.SaftAT.CSeparadorMsgAt.Length)&#xD;&#xA;    Else&#xD;&#xA;        strAss = GetCurrentColumnValue(&quot;MensagemDocAT&quot;)&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;CodigoAT&quot;) &lt;&gt; String.Empty Then&#xD;&#xA;        strMsg += &quot; | ATDocCodeId: &quot; &amp; GetCurrentColumnValue(&quot;CodigoAT&quot;)&#xD;&#xA;    End If&#xD;&#xA;    fldMensagemDocAT.Text = strMsg&#xD;&#xA;    fldMensagemDocAT1.Text = strMsg&#xD;&#xA;    fldAssinatura11.Text = strMsg&#xD;&#xA;    fldAssinatura.Text = strAss&#xD;&#xA;    fldAssinatura1.Text = strAss&#xD;&#xA;    fldassinaturanaoval.Text = strAss&#xD;&#xA;    &#xD;&#xA;    If GetCurrentColumnValue(&quot;tbTiposDocumento_AcompanhaBensCirculacao&quot;) Then&#xD;&#xA;        If Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Original&quot; AndAlso Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Duplicado&quot; AndAlso Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Triplicado&quot; Then&#xD;&#xA;            lblCopia1.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;            lblCopia2.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;            lblCopia3.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    &#xD;&#xA;     ''''Separadores totalizadores&#xD;&#xA;    lblSubTotal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;SubTotal&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    lblTotalIva.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalIva&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    lblTotalMoedaDocumento.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalMoedaDocumento&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    ''''Identificação do documento&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) is dbnull.value then&#xD;&#xA;        lblTipoDocumento.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTipoDocumento1.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    end if&#xD;&#xA;    If GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) is dbnull.value Orelse GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) = String.Empty Orelse GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) = &quot;NaoFiscal&quot; Then&#xD;&#xA;        lblTipoDocumento.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTipoDocumento1.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;CodigoTipoEstado&quot;) = &quot;ANL&quot; Then&#xD;&#xA;        lblAnulado.Text = resource.GetResource(&quot;Anulado&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblAnulado.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;SegundaVia&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;SegundaVia&quot;) = &quot;True&quot; Then&#xD;&#xA;        If lblAnulado.Visible Then&#xD;&#xA;            lblSegundaVia.Visible = False&#xD;&#xA;            lblNumVias.Visible = True&#xD;&#xA;        Else&#xD;&#xA;            lblSegundaVia.Text = resource.GetResource(&quot;SegundaVia&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblSegundaVia.Visible = True&#xD;&#xA;            lblNumVias.Visible = False&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbCodigosPostaisCarga_Codigo&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;tbCodigosPostaisCarga_Codigo&quot;) = String.Empty Then&#xD;&#xA;        fldDataCarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbCodigosPostaisDescarga_Codigo&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;tbCodigosPostaisDescarga_Codigo&quot;) = String.Empty Then&#xD;&#xA;        fldDataDescarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;MoradaCarga&quot;) &lt;&gt; String.Empty Or GetCurrentColumnValue(&quot;MoradaDescarga&quot;) &lt;&gt; String.Empty Then&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_AcompanhaBensCirculacao&quot;) Then&#xD;&#xA;            SubBand6.Visible = True&#xD;&#xA;        Else&#xD;&#xA;            SubBand6.Visible = False&#xD;&#xA;        End If&#xD;&#xA;    Else&#xD;&#xA;        SubBand6.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    TraducaoDocumento()   &#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA; Private Sub TraducaoDocumento()&#xD;&#xA;        Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;        ''''Doc.Origem&#xD;&#xA;        lblDocOrigem.Text = resource.GetResource(&quot;Origem&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDocOrigem1.Text = resource.GetResource(&quot;Origem&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Descrição&#xD;&#xA;        lblDescricao.Text = resource.GetResource(&quot;Descricao&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescricao1.Text = resource.GetResource(&quot;Descricao&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Lote&#xD;&#xA;        lblLote.Text = resource.GetResource(&quot;Lote&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblLote1.Text = resource.GetResource(&quot;Lote&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Armazens&#xD;&#xA;        ''''Localizações&#xD;&#xA;        ''''Unidades&#xD;&#xA;        lblUni.Text = resource.GetResource(&quot;Unidade&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblUni1.Text = resource.GetResource(&quot;Unidade&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Quantidade&#xD;&#xA;        lblQuantidade.Text = resource.GetResource(&quot;Qtd&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblQuantidade1.Text = resource.GetResource(&quot;Qtd&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblContribuinte.Text = resource.GetResource(&quot;Contribuinte&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblFornecedorCodigo.Text = resource.GetResource(&quot;FornecedorCodigo&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblCodigoMoeda.Text = resource.GetResource(&quot;CodigoMoeda&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDataDocumento.Text = resource.GetResource(&quot;DataDocumento&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblCarga.Text = resource.GetResource(&quot;Carga&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescarga.Text = resource.GetResource(&quot;Descarga&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblExpedicao.Text = resource.GetResource(&quot;Matricula&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTituloTransporte.Text = resource.GetResource(&quot;TituloTransporte&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTituloTransportar.Text = resource.GetResource(&quot;TituloTransportar&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura11_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        fldAssinatura11.Visible = False&#xD;&#xA;        me.lblCopia3.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        fldAssinatura11.Visible = True&#xD;&#xA;        me.lblCopia3.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura1_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        fldAssinatura1.Visible = False&#xD;&#xA;        me.lblCopia3.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        fldAssinatura1.Visible = True&#xD;&#xA;        me.lblCopia3.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;     If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTransportar.Visible = False&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Me.fldAssinatura1.Visible = False&#xD;&#xA;        Me.fldAssinatura11.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTransportar.Visible = False&#xD;&#xA;            Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTransportar.Visible = True&#xD;&#xA;            Me.lblTituloTransportar.Visible = True&#xD;&#xA;        End If&#xD;&#xA;        Me.fldAssinatura1.Visible = True&#xD;&#xA;        Me.fldAssinatura11.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;    Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex)     &#xD;&#xA;    Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;    While (iterator.MoveNext())&#xD;&#xA;        If (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal&quot;))&#xD;&#xA;            dblTransportar += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;        End If&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;            label.Text = dblTransportar.ToString()&#xD;&#xA;        Else&#xD;&#xA;            label.Text = Convert.ToDouble(dblTransportar.ToString()).ToString(&quot;F&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;        End If&#xD;&#xA;    End While&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransportar.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;     If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Me.lblTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransporte.Visible = False&#xD;&#xA;            Me.lblTransporte.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransporte.Visible = True&#xD;&#xA;            Me.lblTransporte.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    If e.PageIndex &gt; 0 then&#xD;&#xA;        Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;        Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex - 1)     &#xD;&#xA;        Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;        While (iterator.MoveNext())&#xD;&#xA;             if (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal&quot;))&#xD;&#xA;                dblTransporte += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;            End If&#xD;&#xA;            If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;                label.Text = dblTransporte.ToString()&#xD;&#xA;            Else&#xD;&#xA;                label.Text = Convert.ToDouble(dblTransporte.ToString()).ToString(&quot;F&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;            End If&#xD;&#xA;        End While&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransporte.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;" DrawWatermark="true" Margins="54, 18, 25, 1" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosCompras_Cab" DataSource="#Ref-0">
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
    <Item2 Ref="30" ControlType="ReportHeaderBand" Name="ReportHeader" HeightF="0" />
    <Item3 Ref="31" ControlType="PageHeaderBand" Name="PageHeader" HeightF="2.09">
      <SubBands>
        <Item1 Ref="32" ControlType="SubBand" Name="SubBand5" HeightF="107.87">
          <Controls>
            <Item1 Ref="33" ControlType="XRSubreport" Name="Cabecalho Empresa Compras" ReportSourceUrl="10000" SizeF="535.2748,105.7917" LocationFloat="0, 0">
              <ParameterBindings>
                <Item1 Ref="34" ParameterName="IDEmpresa" DataMember="tbDocumentosCompras.IDLoja" />
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
                <Item1 Ref="121" Expression="[tbLojas_Descricao]" PropertyName="Text" EventName="BeforePrint" />
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
                <Item1 Ref="183" ControlType="XRSubreport" Name="Dimensoes Compras" ReportSourceUrl="30000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="0, 0">
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
                <Item1 Ref="239" ControlType="XRSubreport" Name="Dimensoes Compras Nao Valorizado" ReportSourceUrl="40000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="1.351293, 0">
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
            <Item2 Ref="274" ControlType="XRSubreport" Name="Motivos Isencao Compras" ReportSourceUrl="20000" SizeF="445.76,60.00002" LocationFloat="2.32, 4.16">
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
    <Item5 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Name="SqlDataSource" Base64="PFNxbERhdGFTb3VyY2UgTmFtZT0iU3FsRGF0YVNvdXJjZSI+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMTQzXGYzbTIwMTc7VXNlciBJRD1GM01PO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTI4MTRGM01POyIgLz48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXMiPjxQYXJhbWV0ZXIgTmFtZT0iSUREb2N1bWVudG8iIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKD9JRERvY3VtZW50byk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCBkaXN0aW5jdCAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9Eb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhRG9jdW1lbnRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iT2JzZXJ2YWNvZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGF4YUNvbnZlcnNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRvdGFsTW9lZGFEb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhUmVmZXJlbmNpYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkxvY2FsQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJIb3JhQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFDYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJMb2NhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSG9yYURlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW9yYWRhRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZURlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYURlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9EZXN0aW5hdGFyaW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZXJpZURvY01hbnVhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0RvY01hbnVhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0xpbmhhcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBvc3RvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJVdGlsaXphZG9yRXN0YWRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUhvcmFFc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBc3NpbmF0dXJhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmVyc2FvQ2hhdmVQcml2YWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZUZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYUZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRmlzY2FsIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9GaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb250cmlidWludGVGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvamEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJbXByZXNzbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9ySW1wb3N0byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBlcmNlbnRhZ2VtRGVzY29udG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWYWxvckRlc2NvbnRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRheGFJdmFQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUYXhhSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW90aXZvSXNlbmNhb0l2YSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vdGl2b0lzZW5jYW9Qb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbFBvcnRlcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkVzcGFjb0Zpc2NhbFBvcnRlcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iUmVnaW1lSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ3VzdG9zQWRpY2lvbmFpcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpc3RlbWEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBdGl2byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDcmlhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckNyaWFjYW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQWx0ZXJhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkYzTU1hcmNhZG9yIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURGb3JtYUV4cGVkaWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9JbnRlcm5vIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFbnRpZGFkZSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb0VudGlkYWRlIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25kaWNhb1BhZ2FtZW50byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETG9jYWxPcGVyYWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0FUIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURQYWlzQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFBhaXNEZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1hdHJpY3VsYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbEZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGVzY3JpY2FvRGlzdHJpdG9GaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvQVRJbnRlcm5vIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGlwb0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY3VtZW50byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1RpcG9Fc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Eb2NPcmlnZW0iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9DYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbENhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9EZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29FbnRpZGFkZSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb01vZWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTWVuc2FnZW1Eb2NBVCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEU2lzVGlwb3NEb2NQVSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Npc1RpcG9zRG9jUFUiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NNYW51YWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NSZXBvc2ljYW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQXNzaW5hdHVyYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDb250cm9sb0ludGVybm8iLA0KCSJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURvY3VtZW50byIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29UaXBvRXN0YWRvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNlZ3VuZGFWaWEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRCIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfSUQiLA0KCSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9yZGVtIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklERG9jdW1lbnRvQ29tcHJhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJ0aWdvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIkRlc2NyaWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRFVuaWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iTnVtQ2FzYXNEZWNVbmlkYWRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlF1YW50aWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iUHJlY29Vbml0YXJpbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJQcmVjb1VuaXRhcmlvRWZldGl2byIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJQcmVjb1RvdGFsIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9ic2VydmFjb2VzIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19PYnNlcnZhY29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRExvdGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQ29kaWdvTG90ZSIsDQoJICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQ29kaWdvVW5pZGFkZSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEZXNjcmljYW9Mb3RlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIkRhdGFGYWJyaWNvTG90ZSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEYXRhVmFsaWRhZGVMb3RlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJ0aWdvTnVtU2VyaWUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQXJ0aWdvTnVtU2VyaWUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbUxvY2FsaXphY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbURlc3Rpbm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtTG9jYWxpemFjYW9EZXN0aW5vIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk51bUxpbmhhc0RpbWVuc29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEZXNjb250bzEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGVzY29udG8yIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEVGF4YUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJUYXhhSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk1vdGl2b0lzZW5jYW9JdmEiIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX01vdGl2b0lzZW5jYW9JdmEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURFc3BhY29GaXNjYWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRXNwYWNvRmlzY2FsIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEUmVnaW1lSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlJlZ2ltZUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJTaWdsYVBhaXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iT3JkZW0iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iU2lzdGVtYSIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfU2lzdGVtYSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJBdGl2byIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfQXRpdm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGF0YUNyaWFjYW8iIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0RhdGFDcmlhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlV0aWxpemFkb3JDcmlhY2FvIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19VdGlsaXphZG9yQ3JpYWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEYXRhQWx0ZXJhY2FvIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQWx0ZXJhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlV0aWxpemFkb3JBbHRlcmFjYW8iIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX1V0aWxpemFkb3JBbHRlcmFjYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRjNNTWFyY2Fkb3IiIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0YzTU1hcmNhZG9yIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlZhbG9ySW5jaWRlbmNpYSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJWYWxvcklWQSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEb2N1bWVudG9PcmlnZW0iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGF0YUVudHJlZ2EiLA0KCSAidGJGb3JuZWNlZG9yZXMiLiJOb21lIiBhcyAidGJGb3JuZWNlZG9yZXNfTm9tZSIsDQoJICJ0YkZvcm5lY2Vkb3JlcyIuIkNvZGlnbyIgYXMgInRiRm9ybmVjZWRvcmVzX0NvZGlnbyIsDQoJICJ0YkZvcm5lY2Vkb3JlcyIuIk5Db250cmlidWludGUiIGFzICJ0YkZvcm5lY2Vkb3Jlc19OQ29udHJpYnVpbnRlIiwNCgkgInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIk1vcmFkYSIgYXMgInRiRm9ybmVjZWRvcmVzTW9yYWRhc19Nb3JhZGEiLA0KCSAidGJDb2RpZ29zUG9zdGFpcyIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0NvZGlnbyIsDQoJICJ0YkNvZGlnb3NQb3N0YWlzIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiwNCiAgICAgICAidGJFc3RhZG9zIi4iQ29kaWdvIiBhcyAidGJFc3RhZG9zX0NvZGlnbyIsDQogICAgICAgInRiRXN0YWRvcyIuIkRlc2NyaWNhbyIgYXMgInRiRXN0YWRvc19EZXNjcmljYW8iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iQ29kaWdvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Db2RpZ28iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KCSAidGJUaXBvc0RvY3VtZW50byIuIkRvY05hb1ZhbG9yaXphZG8iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0RvY05hb1ZhbG9yaXphZG8iLA0KCSAidGJUaXBvc0RvY3VtZW50byIuIkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJEZXNjcmljYW9TZXJpZSIsDQogICAgICAgInRiQXJ0aWdvcyIuIkNvZGlnbyIgYXMgInRiQXJ0aWdvc19Db2RpZ28iLA0KICAgICAgICJ0YkFydGlnb3MiLiJEZXNjcmljYW9BYnJldmlhZGEiLA0KICAgICAgICJ0YkFydGlnb3MiLiJEZXNjcmljYW8iIGFzICJ0YkFydGlnb3NfRGVzY3JpY2FvIiwNCiAgICAgICAidGJBcnRpZ29zIi4iR2VyZUxvdGVzIiBhcyAidGJBcnRpZ29zX0dlcmVMb3RlcyIsDQogICAgICAgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiwNCgkgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iVGlwbyIgYXMgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iLA0KCSAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KICAgICAgICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIlRpcG8iLA0KICAgICAgICJ0YkNvZGlnb3NQb3N0YWlzMSIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNfQ29kaWdvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczEiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMyIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMyIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0Rlc2NyaWNhbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMzIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0NvZGlnbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMzIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJNb2VkYXNfQ29kaWdvIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW8iIGFzICJ0Yk1vZWRhc19EZXNjcmljYW8iLA0KICAgICAgICJ0Yk1vZWRhcyIuIlNpbWJvbG8iIGFzICJ0Yk1vZWRhc19TaW1ib2xvIiwNCgkgInRiQXJtYXplbnMiLiJEZXNjcmljYW8iIGFzICJ0YkFybWF6ZW5zX0Rlc2NyaWNhbyIsDQoJICJ0YkFybWF6ZW5zIi4iQ29kaWdvIiBhcyAidGJBcm1hemVuc19Db2RpZ28iLA0KCSAidGJBcm1hemVuc0xvY2FsaXphY29lcyIuIkRlc2NyaWNhbyIgYXMgInRiQXJtYXplbnNMb2NhbGl6YWNvZXNfRGVzY3JpY2FvIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzX0NvZGlnbyIsDQoJICJ0YkFybWF6ZW5zMSIuIkRlc2NyaWNhbyIgYXMgInRiQXJtYXplbnMxX0Rlc2NyaWNhb0Rlc3Rpbm8iLA0KCSAidGJBcm1hemVuczEiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zMV9Db2RpZ29EZXN0aW5vIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iRGVzY3JpY2FvIiBhcyAidGJBcm1hemVuc0xvY2FsaXphY29lczFfRGVzY3JpY2FvIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iQ29kaWdvIiBhcyAidGJBcm1hemVuc0xvY2FsaXphY29lczFfQ29kaWdvIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiBhcyAidGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIsDQoJICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgYXMgInRiTW9lZGFzX0Nhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiLA0KCSAgICJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNJdmEiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzSXZhIiwNCgkgInRiU2lzdGVtYUNvZGlnb3NJVkEiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFDb2RpZ29zSVZBLkNvZGlnbyIsIA0KICAgICAgICJ0YlNpc3RlbWFNb2VkYXMiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFNb2VkYXNfQ29kaWdvIiwNCgkgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhRG9jdW1lbnRvIiAtICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JJbXBvc3RvIiBhcyAiU3ViVG90YWwiLA0KCSAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgYXMgInRiUGFyYW1lbnRyb3NFbXByZXNhX0Nhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIsDQoJICJ0YlNpc3RlbWFOYXR1cmV6YXMiLkNvZGlnbyBhcyAidGJTaXN0ZW1hTmF0dXJlemFzX0NvZGlnbyINCiAgZnJvbSAiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhcyINCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIg0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIg0KICAgICAgIG9uICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSUREb2N1bWVudG9Db21wcmEiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YklWQSIgInRiSVZBIiBvbiAidGJJVkEiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEVGF4YUl2YSINCiAgbGVmdCBqb2luIHRiU2lzdGVtYUNvZGlnb3NJVkEgb24gdGJJVkEuSURDb2RpZ29JVkEgPSB0YlNpc3RlbWFDb2RpZ29zSVZBLklEDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hVGlwb3NJVkEiICJ0YlNpc3RlbWFUaXBvc0lWQSIgb24gInRiU2lzdGVtYVRpcG9zSVZBIi4iSUQiID0gInRiSVZBIi4iSURUaXBvSXZhIg0KICBsZWZ0IGpvaW4gImRibyIuInRiRm9ybmVjZWRvcmVzIiAidGJGb3JuZWNlZG9yZXMiDQogICAgICAgb24gInRiRm9ybmVjZWRvcmVzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVudGlkYWRlIg0KICBsZWZ0IGpvaW4gImRibyIuICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiDQoJICAgb24gInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIklERm9ybmVjZWRvciIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERW50aWRhZGUiIGFuZCAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iT3JkZW0iPTENCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpcyINCiAgICAgICBvbiAidGJDb2RpZ29zUG9zdGFpcyIuIklEIiA9ICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiLiJJRENvZGlnb1Bvc3RhbCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkVzdGFkb3MiICJ0YkVzdGFkb3MiDQogICAgICAgb24gInRiRXN0YWRvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJUaXBvc0RvY3VtZW50byINCiAgICAgICAidGJUaXBvc0RvY3VtZW50byINCiAgICAgICBvbiAidGJUaXBvc0RvY3VtZW50byIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvRG9jdW1lbnRvIg0KICBsZWZ0IGpvaW4gImRibyIuInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KICAgICAgIG9uICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KCSAgICBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIiAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iDQogICAgICAgb24gInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFUaXBvc0RvY3VtZW50byINCiAgbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIg0KICAgICAgIG9uICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIklEIiA9ICJ0YlRpcG9zRG9jdW1lbnRvIi4iSURTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hTmF0dXJlemFzIiAidGJTaXN0ZW1hTmF0dXJlemFzIg0KICAgICAgIG9uICJ0YlNpc3RlbWFOYXR1cmV6YXMiLiJJRCIgPSAidGJUaXBvc0RvY3VtZW50byIuIklEU2lzdGVtYU5hdHVyZXphcyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFydGlnb3MiICJ0YkFydGlnb3MiDQogICAgICAgb24gInRiQXJ0aWdvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcnRpZ28iDQogIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMxIg0KICAgICAgIG9uICJ0YkNvZGlnb3NQb3N0YWlzMSIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiDQogIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMyIg0KICAgICAgIG9uICJ0YkNvZGlnb3NQb3N0YWlzMiIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczMiDQogICAgICAgb24gInRiQ29kaWdvc1Bvc3RhaXMzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIg0KICBsZWZ0IGpvaW4gImRibyIuInRiTW9lZGFzIiAidGJNb2VkYXMiDQogICAgICAgb24gInRiTW9lZGFzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIg0KICBsZWZ0IGpvaW4gInRiUGFyYW1ldHJvc0VtcHJlc2EiIA0KICAgICAgIG9uICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURNb2VkYURlZmVpdG8iID0gInRiTW9lZGFzIi4iSUQiIA0KICBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYU1vZWRhcyIgInRiU2lzdGVtYU1vZWRhcyINCiAgICAgICBvbiAidGJTaXN0ZW1hTW9lZGFzIi4iSUQiID0gInRiTW9lZGFzIi4iSURTaXN0ZW1hTW9lZGEiDQogIGxlZnQgam9pbiAiZGJvIi4idGJBcm1hemVucyIgInRiQXJtYXplbnMiDQogICAgICAgb24gInRiQXJtYXplbnMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzIiAidGJBcm1hemVuc0xvY2FsaXphY29lcyINCiAgICAgICBvbiAidGJBcm1hemVuc0xvY2FsaXphY29lcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtTG9jYWxpemFjYW8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJBcm1hemVucyIgInRiQXJtYXplbnMxIg0KICAgICAgIG9uICJ0YkFybWF6ZW5zMSIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtRGVzdGlubyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzIiAidGJBcm1hemVuc0xvY2FsaXphY29lczEiDQogICAgICAgb24gInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJREFybWF6ZW1Mb2NhbGl6YWNhb0Rlc3Rpbm8iDQp3aGVyZSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEIj0gQElERG9jdW1lbnRvDQpPcmRlciBieSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9yZGVtIjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IkN1c3RvbVNxbFF1ZXJ5IiBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzX0NhYiI+PFBhcmFtZXRlciBOYW1lPSJJZERvYyIgVHlwZT0iRGV2RXhwcmVzcy5EYXRhQWNjZXNzLkV4cHJlc3Npb24iPihTeXN0ZW0uSW50NjQsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OSkoP0lERG9jdW1lbnRvKTwvUGFyYW1ldGVyPjxTcWw+c2VsZWN0IGRpc3RpbmN0ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUQiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0RvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk9ic2VydmFjb2VzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETW9lZGEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGF4YUNvbnZlcnNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRvdGFsTW9lZGFSZWZlcmVuY2lhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkxvY2FsQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUNhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkhvcmFDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbENhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uY2VsaG9DYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTG9jYWxEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSG9yYURlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYURlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOb21lRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZXJpZURvY01hbnVhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2NNYW51YWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTnVtZXJvTGluaGFzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBvc3RvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXN0YWRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlV0aWxpemFkb3JFc3RhZG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUhvcmFFc3RhZG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQXNzaW5hdHVyYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWZXJzYW9DaGF2ZVByaXZhZGEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZUZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvbnRyaWJ1aW50ZUZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURMb2phIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkltcHJlc3NvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9ySW1wb3N0byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJQZXJjZW50YWdlbURlc2NvbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9yRGVzY29udG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUYXhhSXZhUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRheGFJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW90aXZvSXNlbmNhb0l2YSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXNwYWNvRmlzY2FsUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkVzcGFjb0Zpc2NhbFBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFJlZ2ltZUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJSZWdpbWVJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ3VzdG9zQWRpY2lvbmFpcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaXN0ZW1hIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkF0aXZvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDcmlhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlV0aWxpemFkb3JDcmlhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFBbHRlcmFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRjNNTWFyY2Fkb3IiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREZvcm1hRXhwZWRpY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTnVtZXJvSW50ZXJubyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9FbnRpZGFkZSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVudGlkYWRlIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uZGljYW9QYWdhbWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURMb2NhbE9wZXJhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0FUIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1hdHJpY3VsYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFBhaXNGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvUG9zdGFsRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEZXNjcmljYW9Db25jZWxob0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEZXNjcmljYW9EaXN0cml0b0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFJlZ2ltZUl2YSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29BVEludGVybm8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGlwb0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvVGlwb0VzdGFkbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Eb2NPcmlnZW0iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGlzdHJpdG9DYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb25jZWxob0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbENhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpZ2xhUGFpc0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRpc3RyaXRvRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29FbnRpZGFkZSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Nb2VkYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNZW5zYWdlbURvY0FUIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEU2lzVGlwb3NEb2NQVSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29TaXNUaXBvc0RvY1BVIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY01hbnVhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NSZXBvc2ljYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUFzc2luYXR1cmEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUNvbnRyb2xvSW50ZXJubyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZWd1bmRhVmlhIiwidGJGb3JuZWNlZG9yZXMiLiJOb21lIiBhcyAidGJGb3JuZWNlZG9yZXNfTm9tZSIsInRiRm9ybmVjZWRvcmVzIi4iQ29kaWdvIiBhcyAidGJGb3JuZWNlZG9yZXNfQ29kaWdvIiwidGJGb3JuZWNlZG9yZXMiLiJOQ29udHJpYnVpbnRlIiBhcyAidGJGb3JuZWNlZG9yZXNfTkNvbnRyaWJ1aW50ZSIsInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIk1vcmFkYSIgYXMgInRiRm9ybmVjZWRvcmVzTW9yYWRhc19Nb3JhZGEiLCJ0YkNvZGlnb3NQb3N0YWlzIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpcyIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0Rlc2NyaWNhbyIsInRiRXN0YWRvcyIuIkNvZGlnbyIgYXMgInRiRXN0YWRvc19Db2RpZ28iLCJ0YkVzdGFkb3MiLiJEZXNjcmljYW8iIGFzICJ0YkVzdGFkb3NfRGVzY3JpY2FvIiwidGJUaXBvc0RvY3VtZW50byIuIkNvZGlnbyIgYXMgInRiVGlwb3NEb2N1bWVudG9fQ29kaWdvIiwidGJUaXBvc0RvY3VtZW50byIuIkRlc2NyaWNhbyIgYXMgInRiVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiwidGJUaXBvc0RvY3VtZW50byIuIkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIsInRiVGlwb3NEb2N1bWVudG8iLiJEb2NOYW9WYWxvcml6YWRvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Eb2NOYW9WYWxvcml6YWRvIiwidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIkNvZGlnb1NlcmllIiwidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIkRlc2NyaWNhb1NlcmllIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJEZXNjcmljYW8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbF9EZXNjcmljYW8iLCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byIuIlRpcG8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19UaXBvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIlRpcG8iLCJ0YkNvZGlnb3NQb3N0YWlzMyIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iLCJ0YkNvZGlnb3NQb3N0YWlzMyIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9EZXNjcmljYW8iLCJ0YkNvZGlnb3NQb3N0YWlzMSIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNfQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpczEiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIsInRiQ29kaWdvc1Bvc3RhaXMyIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMyIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0Rlc2NyaWNhbyIsInRiTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJNb2VkYXNfQ29kaWdvIiwidGJNb2VkYXMiLiJEZXNjcmljYW8iIGFzICJ0Yk1vZWRhc19EZXNjcmljYW8iLCJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNUb3RhaXMiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzSXZhIiBhcyAidGJNb2VkYXNfQ2FzYXNEZWNpbWFpc0l2YSIsInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgYXMgInRiTW9lZGFzX0Nhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiLCJ0Yk1vZWRhcyIuIlNpbWJvbG8iIGFzICJ0Yk1vZWRhc19TaW1ib2xvIiwidGJTaXN0ZW1hTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIsInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIGFzICJ0YlBhcmFtZW50cm9zRW1wcmVzYV9DYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iLCJ0YlNpc3RlbWFOYXR1cmV6YXMiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFOYXR1cmV6YXNfQ29kaWdvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYURlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWb3Nzb051bWVyb0RvY3VtZW50byIsc3VtKCJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iVmFsb3JEZXNjb250b0xpbmhhIikgYXMgIlZhbG9yRGVzY29udG9MaW5oYV9TdW0iLCAidGJMb2phcyIuIkRlc2NyaWNhbyIgYXMgInRiTG9qYXNfRGVzY3JpY2FvIiBmcm9tICgoKCgoKCgoKCgoKCgoKCgiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiDQogbGVmdCBqb2luICJkYm8iLiJ0YkRvY3VtZW50b3NDb21wcmFzIiAidGJEb2N1bWVudG9zQ29tcHJhcyIgb24gKCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRERvY3VtZW50b0NvbXByYSIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJGb3JuZWNlZG9yZXMiICJ0YkZvcm5lY2Vkb3JlcyIgb24gKCJ0YkZvcm5lY2Vkb3JlcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFbnRpZGFkZSIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJGb3JuZWNlZG9yZXNNb3JhZGFzIiAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIiBvbiAoInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIklERm9ybmVjZWRvciIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERW50aWRhZGUiIGFuZCAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iT3JkZW0iPTEgKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiQ29kaWdvc1Bvc3RhaXMiICJ0YkNvZGlnb3NQb3N0YWlzIiBvbiAoInRiQ29kaWdvc1Bvc3RhaXMiLiJJRCIgPSAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iSURDb2RpZ29Qb3N0YWwiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiRXN0YWRvcyIgInRiRXN0YWRvcyIgb24gKCJ0YkVzdGFkb3MiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXN0YWRvIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YlRpcG9zRG9jdW1lbnRvIiAidGJUaXBvc0RvY3VtZW50byIgb24gKCJ0YlRpcG9zRG9jdW1lbnRvIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9Eb2N1bWVudG8iKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIiBvbiAoInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIiAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iIG9uICgidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJJRCIgPSAidGJUaXBvc0RvY3VtZW50byIuIklEU2lzdGVtYVRpcG9zRG9jdW1lbnRvIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIiBvbiAoInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMxIiBvbiAoInRiQ29kaWdvc1Bvc3RhaXMxIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbEZpc2NhbCIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMyIiBvbiAoInRiQ29kaWdvc1Bvc3RhaXMyIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbENhcmdhIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczMiIG9uICgidGJDb2RpZ29zUG9zdGFpczMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiTW9lZGFzIiAidGJNb2VkYXMiIG9uICgidGJNb2VkYXMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETW9lZGEiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiUGFyYW1ldHJvc0VtcHJlc2EiICJ0YlBhcmFtZXRyb3NFbXByZXNhIiBvbiAoInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIgPSAidGJNb2VkYXMiLiJJRCIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hTmF0dXJlemFzIiAidGJTaXN0ZW1hTmF0dXJlemFzIiBvbiAoInRiU2lzdGVtYU5hdHVyZXphcyIuIklEIiA9ICJ0YlRpcG9zRG9jdW1lbnRvIi4iSURTaXN0ZW1hTmF0dXJlemFzIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFNb2VkYXMiICJ0YlNpc3RlbWFNb2VkYXMiIG9uICgidGJTaXN0ZW1hTW9lZGFzIi4iSUQiID0gInRiTW9lZGFzIi4iSURTaXN0ZW1hTW9lZGEiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiTG9qYXMiICJ0YkxvamFzIiBvbiAoInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvamEiID0gInRiTG9qYXMiLiJJRCIpDQp3aGVyZSAoInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCIgPSBASWREb2MpDQpncm91cCBieSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb0RvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJPYnNlcnZhY29lcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRheGFDb252ZXJzYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVG90YWxNb2VkYURvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhUmVmZXJlbmNpYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJMb2NhbENhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJIb3JhQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW9yYWRhQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkxvY2FsRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkhvcmFEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uY2VsaG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZURlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFEZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNlcmllRG9jTWFudWFsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0RvY01hbnVhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9MaW5oYXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iUG9zdG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckVzdGFkbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhSG9yYUVzdGFkbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBc3NpbmF0dXJhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZlcnNhb0NoYXZlUHJpdmFkYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOb21lRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYUZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbEZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9GaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29udHJpYnVpbnRlRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpZ2xhUGFpc0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvamEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSW1wcmVzc28iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JJbXBvc3RvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBlcmNlbnRhZ2VtRGVzY29udG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JEZXNjb250byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWYWxvclBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRheGFJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGF4YUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3Rpdm9Jc2VuY2FvSXZhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vdGl2b0lzZW5jYW9Qb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3BhY29GaXNjYWxQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRXNwYWNvRmlzY2FsUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlJlZ2ltZUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDdXN0b3NBZGljaW9uYWlzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpc3RlbWEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQXRpdm8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUNyaWFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckNyaWFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUFsdGVyYWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJVdGlsaXphZG9yQWx0ZXJhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkYzTU1hcmNhZG9yIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERm9ybWFFeHBlZGljYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvc0RvY3VtZW50b1NlcmllcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9JbnRlcm5vIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERW50aWRhZGUiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvRW50aWRhZGUiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25kaWNhb1BhZ2FtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvY2FsT3BlcmFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvQVQiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURQYWlzQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURQYWlzRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTWF0cmljdWxhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Qb3N0YWxGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGVzY3JpY2FvQ29kaWdvUG9zdGFsRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0Rpc3RyaXRvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXNwYWNvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0FUSW50ZXJubyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUaXBvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29UaXBvRXN0YWRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0RvY09yaWdlbSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvbmNlbGhvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvUG9zdGFsQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGlzdHJpdG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb25jZWxob0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbERlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpZ2xhUGFpc0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0VudGlkYWRlIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb01vZWRhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1lbnNhZ2VtRG9jQVQiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURTaXNUaXBvc0RvY1BVIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Npc1RpcG9zRG9jUFUiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRG9jTWFudWFsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY1JlcG9zaWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQXNzaW5hdHVyYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQ29udHJvbG9JbnRlcm5vIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNlZ3VuZGFWaWEiLCJ0YkZvcm5lY2Vkb3JlcyIuIkNvZGlnbyIsInRiRm9ybmVjZWRvcmVzIi4iTm9tZSIsInRiRm9ybmVjZWRvcmVzIi4iTkNvbnRyaWJ1aW50ZSIsInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIk1vcmFkYSIsInRiQ29kaWdvc1Bvc3RhaXMiLiJDb2RpZ28iLCJ0YkNvZGlnb3NQb3N0YWlzIi4iRGVzY3JpY2FvIiwidGJFc3RhZG9zIi4iQ29kaWdvIiwidGJFc3RhZG9zIi4iRGVzY3JpY2FvIiwidGJUaXBvc0RvY3VtZW50byIuIkNvZGlnbyIsInRiVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iLCJ0YlRpcG9zRG9jdW1lbnRvIi4iQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iLCJ0YlRpcG9zRG9jdW1lbnRvIi4iRG9jTmFvVmFsb3JpemFkbyIsInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJEZXNjcmljYW9TZXJpZSIsInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iVGlwbyIsInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJUaXBvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJEZXNjcmljYW8iLCJ0YkNvZGlnb3NQb3N0YWlzMSIuIkNvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMxIi4iRGVzY3JpY2FvIiwidGJDb2RpZ29zUG9zdGFpczIiLiJDb2RpZ28iLCJ0YkNvZGlnb3NQb3N0YWlzMiIuIkRlc2NyaWNhbyIsInRiQ29kaWdvc1Bvc3RhaXMzIi4iQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpczMiLiJEZXNjcmljYW8iLCJ0Yk1vZWRhcyIuIkNvZGlnbyIsInRiTW9lZGFzIi4iRGVzY3JpY2FvIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzSXZhIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiwidGJNb2VkYXMiLiJTaW1ib2xvIiwidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIsInRiU2lzdGVtYU5hdHVyZXphcyIuIkNvZGlnbyIsInRiU2lzdGVtYU1vZWRhcyIuIkNvZGlnbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWb3Nzb051bWVyb0RvY3VtZW50byIsICJ0YkxvamFzIi4iRGVzY3JpY2FvIjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IlNlbGVjdFF1ZXJ5IiBOYW1lPSJ0YlBhcmFtZXRyb3NFbXByZXNhIj48VGFibGVzPjxUYWJsZSBOYW1lPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiAvPjwvVGFibGVzPjxDb2x1bW5zPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklEIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklETW9lZGFEZWZlaXRvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9Ik1vcmFkYSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJGb3RvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkZvdG9DYW1pbmhvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkRlc2lnbmFjYW9Db21lcmNpYWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQ29kaWdvUG9zdGFsIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkxvY2FsaWRhZGUiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQ29uY2VsaG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRGlzdHJpdG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURQYWlzIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IlRlbGVmb25lIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkZheCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJFbWFpbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJXZWJTaXRlIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9Ik5JRiIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkNhcGl0YWxTb2NpYWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURJZGlvbWFCYXNlIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IlNpc3RlbWEiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQXRpdm8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRGF0YUNyaWFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRGF0YUFsdGVyYWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkYzTU1hcmNhZG9yIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklERW1wcmVzYSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURQYWlzZXNEZXNjIiAvPjwvQ29sdW1ucz48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQgTmFtZT0iU3FsRGF0YVNvdXJjZSI+PFZpZXcgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc19DYWIiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRhdGFEb2N1bWVudG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJPYnNlcnZhY29lcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRE1vZWRhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUNvbnZlcnNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhRG9jdW1lbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsTW9lZGFSZWZlcmVuY2lhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkxvY2FsQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUNhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSG9yYUNhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iTW9yYWRhQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxDYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9DYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9DYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkxvY2FsRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YURlc2NhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSG9yYURlc2NhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iTW9yYWRhRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9EZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik5vbWVEZXN0aW5hdGFyaW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlNlcmllRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY01hbnVhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9MaW5oYXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJQb3N0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVzdGFkbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JFc3RhZG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUhvcmFFc3RhZG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJBc3NpbmF0dXJhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlZlcnNhb0NoYXZlUHJpdmFkYSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9Ik5vbWVGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTW9yYWRhRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb250cmlidWludGVGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklETG9qYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkltcHJlc3NvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJWYWxvckltcG9zdG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUGVyY2VudGFnZW1EZXNjb250byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckRlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yUG9ydGVzIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEVGF4YUl2YVBvcnRlcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFJdmFQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iTW90aXZvSXNlbmNhb0l2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRXNwYWNvRmlzY2FsUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUmVnaW1lSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUmVnaW1lSXZhUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkN1c3Rvc0FkaWNpb25haXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkYzTU1hcmNhZG9yIiBUeXBlPSJCeXRlQXJyYXkiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURGb3JtYUV4cGVkaWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb3NEb2N1bWVudG9TZXJpZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9JbnRlcm5vIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvRW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREVudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25kaWNhb1BhZ2FtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETG9jYWxPcGVyYWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0FUIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpc0NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURQYWlzRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNYXRyaWN1bGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9Db25jZWxob0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9EaXN0cml0b0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVzcGFjb0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEUmVnaW1lSXZhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQVRJbnRlcm5vIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG9GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRG9jdW1lbnRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1RpcG9Fc3RhZG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvRG9jT3JpZ2VtIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG9DYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxDYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNDYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0b0Rlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvRW50aWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvTW9lZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTWVuc2FnZW1Eb2NBVCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFNpc1RpcG9zRG9jUFUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29TaXNUaXBvc0RvY1BVIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRvY01hbnVhbCIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRG9jUmVwb3NpY2FvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQXNzaW5hdHVyYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkRhdGFDb250cm9sb0ludGVybm8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJTZWd1bmRhVmlhIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YkZvcm5lY2Vkb3Jlc19Ob21lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkZvcm5lY2Vkb3Jlc19OQ29udHJpYnVpbnRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzTW9yYWRhc19Nb3JhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVzdGFkb3NfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRXN0YWRvc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19Eb2NOYW9WYWxvcml6YWRvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbF9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fVGlwbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc0l2YSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFNb2VkYXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiUGFyYW1lbnRyb3NFbXByZXNhX0Nhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hTmF0dXJlemFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFEZXN0aW5hdGFyaW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVm9zc29OdW1lcm9Eb2N1bWVudG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmFsb3JEZXNjb250b0xpbmhhX1N1bSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0YkxvamFzX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48VmlldyBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEYXRhRG9jdW1lbnRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iT2JzZXJ2YWNvZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURNb2VkYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxNb2VkYURvY3VtZW50byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhUmVmZXJlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJMb2NhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYUNhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJMb2NhbERlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOb21lRGVzdGluYXRhcmlvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc3RpbmF0YXJpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbERlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2VyaWVEb2NNYW51YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0xpbmhhcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlBvc3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXN0YWRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckVzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhSG9yYUVzdGFkbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkFzc2luYXR1cmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmVyc2FvQ2hhdmVQcml2YWRhIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iTm9tZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvbnRyaWJ1aW50ZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSW1wcmVzc28iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW1wb3N0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQZXJjZW50YWdlbURlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRGVzY29udG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURUYXhhSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUl2YVBvcnRlcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9Qb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ3VzdG9zQWRpY2lvbmFpcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvciIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJJREZvcm1hRXhwZWRpY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvc0RvY3VtZW50b1NlcmllcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0ludGVybm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREVudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvRW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmRpY2FvUGFnYW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURMb2NhbE9wZXJhY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNEZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1hdHJpY3VsYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0Rpc3RyaXRvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BVEludGVybm8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwb0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEb2N1bWVudG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb0VzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Eb2NPcmlnZW0iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG9DYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxob0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG9EZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29FbnRpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Nb2VkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNZW5zYWdlbURvY0FUIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEU2lzVGlwb3NEb2NQVSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Npc1RpcG9zRG9jUFUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRG9jTWFudWFsIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEb2NSZXBvc2ljYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFBc3NpbmF0dXJhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YUNvbnRyb2xvSW50ZXJubyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkRhdGFEb2N1bWVudG9fMSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1RpcG9Fc3RhZG9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTZWd1bmRhVmlhIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0lEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iT3JkZW0iIFR5cGU9IkludDMyIiAvPjxGaWVsZCBOYW1lPSJJRERvY3VtZW50b0NvbXByYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEVW5pZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bUNhc2FzRGVjVW5pZGFkZSIgVHlwZT0iSW50MTYiIC8+PEZpZWxkIE5hbWU9IlF1YW50aWRhZGUiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvRWZldGl2byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1RvdGFsIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfT2JzZXJ2YWNvZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb3RlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvTG90ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29VbmlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0xvdGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUZhYnJpY29Mb3RlIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YVZhbGlkYWRlTG90ZSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvTnVtU2VyaWUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJBcnRpZ29OdW1TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1Mb2NhbGl6YWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJtYXplbURlc3Rpbm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1Mb2NhbGl6YWNhb0Rlc3Rpbm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1MaW5oYXNEaW1lbnNvZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEZXNjb250bzEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRGVzY29udG8yIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEVGF4YUl2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFJdmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19Nb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlJlZ2ltZUl2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iT3JkZW1fMSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19BdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQ3JpYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19VdGlsaXphZG9yQWx0ZXJhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iVmFsb3JJbmNpZGVuY2lhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9ySVZBIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRvY3VtZW50b09yaWdlbSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhRW50cmVnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX05vbWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX05Db250cmlidWludGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNNb3JhZGFzX01vcmFkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRXN0YWRvc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFc3RhZG9zX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0RvY05hb1ZhbG9yaXphZG8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJ0aWdvc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQWJyZXZpYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJ0aWdvc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcnRpZ29zX0dlcmVMb3RlcyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX1NpbWJvbG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc0xvY2FsaXphY29lc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc0xvY2FsaXphY29lc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuczFfRGVzY3JpY2FvRGVzdGlubyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zMV9Db2RpZ29EZXN0aW5vIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJtYXplbnNMb2NhbGl6YWNvZXMxX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzMV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc0l2YSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hQ29kaWdvc0lWQS5Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTdWJUb3RhbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0YlBhcmFtZW50cm9zRW1wcmVzYV9DYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYU5hdHVyZXphc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48L1ZpZXc+PFZpZXcgTmFtZT0idGJQYXJhbWV0cm9zRW1wcmVzYSI+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURNb2VkYURlZmVpdG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvQ2FtaW5obyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNpZ25hY2FvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJMb2NhbGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZheCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJXZWJTaXRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik5JRiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhcGl0YWxTb2NpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURJZGlvbWFCYXNlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IlVua25vd24iIC8+PEZpZWxkIE5hbWU9IklERW1wcmVzYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iSURQYWlzZXNEZXNjIiBUeXBlPSJJbnQ2NCIgLz48L1ZpZXc+PC9EYXRhU2V0PjwvUmVzdWx0U2NoZW1hPjxDb25uZWN0aW9uT3B0aW9ucyBDbG9zZUNvbm5lY3Rpb249InRydWUiIERiQ29tbWFuZFRpbWVvdXQ9IjE4MDAiIC8+PC9TcWxEYXRhU291cmNlPg==" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''
--Mapa de documentos de compras 
---tratar subreports
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item3/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=10000][1] with sql:variable("@intIDMapaSubCab")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item7/SubBands/Item1/Controls/Item2/@ReportSourceUrl)[.=20000][1] with sql:variable("@intIDMapaMI")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item5/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=30000][1] with sql:variable("@intIDMapaD")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item6/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=40000][1] with sql:variable("@intIDMapaDNV")'')
UPDATE tbMapasVistas SET MapaXML = @ptrval , NomeMapa = ''DocumentosCompras'' Where Entidade = ''DocumentosCompras'' and NomeMapa = ''DocumentosCompras''
')

--atualizar vista de compras
EXEC('
DECLARE @ptrval xml;  
DECLARE @intIDMapaSubCab as bigint;--10000
DECLARE @intIDMapaMI as bigint;--20000
DECLARE @intIDMapaD as bigint;--30000
DECLARE @intIDMapaDNV as bigint;--40000
SELECT @intIDMapaSubCab = ID FROM tbMapasVistas WHERE Entidade = ''PurchaseDocumentsList'' and NomeMapa = ''Cabecalho Empresa Compras''
SELECT @intIDMapaMI = ID FROM tbMapasVistas WHERE Entidade = ''PurchaseDocumentsList'' and NomeMapa = ''Motivos Isencao Compras''
SELECT @intIDMapaD = ID FROM tbMapasVistas WHERE Entidade = ''PurchaseDocumentsList'' and NomeMapa = ''Dimensoes Compras''
SELECT @intIDMapaDNV = ID FROM tbMapasVistas WHERE Entidade = ''PurchaseDocumentsList'' and NomeMapa = ''Dimensoes Compras Nao Valorizado''
SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="PurchaseDocumentsList" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Constantes&#xD;&#xA;&#xD;&#xA;Private dblTransportar as Double = 0&#xD;&#xA;Private dblTransporte as Double = 0&#xD;&#xA;&#xD;&#xA;Private Sub Documentos_Compras_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim SimboloMoeda As String = String.Empty&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Parameters.Item(&quot;AcompanhaBens&quot;).Value = False&#xD;&#xA;    Parameters.Item(&quot;IDLinha&quot;).Value = GetCurrentColumnValue(&quot;tbDocumentosComprasLinhas_ID&quot;)        &#xD;&#xA;    Parameters.Item(&quot;CasasMoedas&quot;).Value = GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisIva&quot;)&#xD;&#xA;        &#xD;&#xA;    SimboloMoeda = GetCurrentColumnValue(&quot;tbMoedas_Simbolo&quot;)&#xD;&#xA;    If SimboloMoeda = &quot;&quot; Then&#xD;&#xA;        Parameters.Item(&quot;SimboloMoedas&quot;).Value = &quot;€&quot;&#xD;&#xA;        SimboloMoeda = &quot;€&quot;&#xD;&#xA;    Else&#xD;&#xA;        Me.Parameters.Item(&quot;SimboloMoedas&quot;).Value = SimboloMoeda&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) then&#xD;&#xA;        lblPreco.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Preco&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTotalFinal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Total&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDesconto1.Text = resource.GetResource(&quot;Desconto1&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDesconto2.Text = resource.GetResource(&quot;Desconto2&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescontosLinha.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoLinha&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescontoGlobal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoGlobal&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTotalIva.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalIva&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    End If&#xD;&#xA;    Select Case GetCurrentColumnValue(&quot;tbSistemaTiposDocumento_Tipo&quot;)&#xD;&#xA;        Case &quot;CmpOrcamento&quot;, &quot;CmpTransporte&quot;, &quot;CmpFinanceiro&quot;&#xD;&#xA;            If GetCurrentColumnValue(&quot;tbSistemaNaturezas_Codigo&quot;) = &quot;P&quot; Then&#xD;&#xA;                lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens1_CodigoDestino&quot;)&#xD;&#xA;                fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens1_CodigoDestino&quot;)&#xD;&#xA;                fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes1_Codigo&quot;)&#xD;&#xA;                fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes1_Codigo&quot;)&#xD;&#xA;            ElseIf GetCurrentColumnValue(&quot;tbSistemaNaturezas_Codigo&quot;) = &quot;R&quot; Then&#xD;&#xA;                lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;                fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;                fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;                fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;            End If&#xD;&#xA;        Case &quot;CmpEncomenda&quot;&#xD;&#xA;            lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;            fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;            fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;            fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;    End Select&#xD;&#xA;    ''''Assinatura&#xD;&#xA;    Dim strAssinatura As String = String.Empty&#xD;&#xA;    Dim strAss As String = String.Empty&#xD;&#xA;    Dim strMsg As String = String.Empty&#xD;&#xA;    If GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt) &gt; 0 Then&#xD;&#xA;        strAss = GetCurrentColumnValue(&quot;MensagemDocAT&quot;).Substring(0, GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt))&#xD;&#xA;        strMsg = GetCurrentColumnValue(&quot;MensagemDocAT&quot;).Substring(GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt) + Constantes.SaftAT.CSeparadorMsgAt.Length)&#xD;&#xA;    Else&#xD;&#xA;        strAss = GetCurrentColumnValue(&quot;MensagemDocAT&quot;)&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;CodigoAT&quot;) &lt;&gt; String.Empty Then&#xD;&#xA;        strMsg += &quot; | ATDocCodeId: &quot; &amp; GetCurrentColumnValue(&quot;CodigoAT&quot;)&#xD;&#xA;    End If&#xD;&#xA;    fldMensagemDocAT.Text = strMsg&#xD;&#xA;    fldMensagemDocAT1.Text = strMsg&#xD;&#xA;    fldAssinatura11.Text = strMsg&#xD;&#xA;    fldAssinatura.Text = strAss&#xD;&#xA;    fldAssinatura1.Text = strAss&#xD;&#xA;    fldassinaturanaoval.Text = strAss&#xD;&#xA;    &#xD;&#xA;    If GetCurrentColumnValue(&quot;tbTiposDocumento_AcompanhaBensCirculacao&quot;) Then&#xD;&#xA;        If Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Original&quot; AndAlso Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Duplicado&quot; AndAlso Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Triplicado&quot; Then&#xD;&#xA;            lblCopia1.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;            lblCopia2.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;            lblCopia3.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    &#xD;&#xA;     ''''Separadores totalizadores&#xD;&#xA;    lblSubTotal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;SubTotal&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    lblTotalIva.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalIva&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    lblTotalMoedaDocumento.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalMoedaDocumento&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    ''''Identificação do documento&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) is dbnull.value then&#xD;&#xA;        lblTipoDocumento.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTipoDocumento1.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    end if&#xD;&#xA;    If GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) is dbnull.value Orelse GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) = String.Empty Orelse GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) = &quot;NaoFiscal&quot; Then&#xD;&#xA;        lblTipoDocumento.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTipoDocumento1.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;CodigoTipoEstado&quot;) = &quot;ANL&quot; Then&#xD;&#xA;        lblAnulado.Text = resource.GetResource(&quot;Anulado&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblAnulado.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;SegundaVia&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;SegundaVia&quot;) = &quot;True&quot; Then&#xD;&#xA;        If lblAnulado.Visible Then&#xD;&#xA;            lblSegundaVia.Visible = False&#xD;&#xA;            lblNumVias.Visible = True&#xD;&#xA;        Else&#xD;&#xA;            lblSegundaVia.Text = resource.GetResource(&quot;SegundaVia&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblSegundaVia.Visible = True&#xD;&#xA;            lblNumVias.Visible = False&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbCodigosPostaisCarga_Codigo&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;tbCodigosPostaisCarga_Codigo&quot;) = String.Empty Then&#xD;&#xA;        fldDataCarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbCodigosPostaisDescarga_Codigo&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;tbCodigosPostaisDescarga_Codigo&quot;) = String.Empty Then&#xD;&#xA;        fldDataDescarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;MoradaCarga&quot;) &lt;&gt; String.Empty Or GetCurrentColumnValue(&quot;MoradaDescarga&quot;) &lt;&gt; String.Empty Then&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_AcompanhaBensCirculacao&quot;) Then&#xD;&#xA;            SubBand6.Visible = True&#xD;&#xA;        Else&#xD;&#xA;            SubBand6.Visible = False&#xD;&#xA;        End If&#xD;&#xA;    Else&#xD;&#xA;        SubBand6.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    TraducaoDocumento()   &#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA; Private Sub TraducaoDocumento()&#xD;&#xA;        Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;        ''''Doc.Origem&#xD;&#xA;        lblDocOrigem.Text = resource.GetResource(&quot;Origem&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDocOrigem1.Text = resource.GetResource(&quot;Origem&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Descrição&#xD;&#xA;        lblDescricao.Text = resource.GetResource(&quot;Descricao&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescricao1.Text = resource.GetResource(&quot;Descricao&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Lote&#xD;&#xA;        lblLote.Text = resource.GetResource(&quot;Lote&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblLote1.Text = resource.GetResource(&quot;Lote&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Armazens&#xD;&#xA;        ''''Localizações&#xD;&#xA;        ''''Unidades&#xD;&#xA;        lblUni.Text = resource.GetResource(&quot;Unidade&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblUni1.Text = resource.GetResource(&quot;Unidade&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Quantidade&#xD;&#xA;        lblQuantidade.Text = resource.GetResource(&quot;Qtd&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblQuantidade1.Text = resource.GetResource(&quot;Qtd&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblContribuinte.Text = resource.GetResource(&quot;Contribuinte&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblFornecedorCodigo.Text = resource.GetResource(&quot;FornecedorCodigo&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblCodigoMoeda.Text = resource.GetResource(&quot;CodigoMoeda&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDataDocumento.Text = resource.GetResource(&quot;DataDocumento&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblCarga.Text = resource.GetResource(&quot;Carga&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescarga.Text = resource.GetResource(&quot;Descarga&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblExpedicao.Text = resource.GetResource(&quot;Matricula&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTituloTransporte.Text = resource.GetResource(&quot;TituloTransporte&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTituloTransportar.Text = resource.GetResource(&quot;TituloTransportar&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura11_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        fldAssinatura11.Visible = False&#xD;&#xA;        me.lblCopia3.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        fldAssinatura11.Visible = True&#xD;&#xA;        me.lblCopia3.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura1_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        fldAssinatura1.Visible = False&#xD;&#xA;        me.lblCopia3.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        fldAssinatura1.Visible = True&#xD;&#xA;        me.lblCopia3.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;     If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTransportar.Visible = False&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Me.fldAssinatura1.Visible = False&#xD;&#xA;        Me.fldAssinatura11.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTransportar.Visible = False&#xD;&#xA;            Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTransportar.Visible = True&#xD;&#xA;            Me.lblTituloTransportar.Visible = True&#xD;&#xA;        End If&#xD;&#xA;        Me.fldAssinatura1.Visible = True&#xD;&#xA;        Me.fldAssinatura11.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;    Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex)     &#xD;&#xA;    Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;    While (iterator.MoveNext())&#xD;&#xA;        If (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal&quot;))&#xD;&#xA;            dblTransportar += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;        End If&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;            label.Text = dblTransportar.ToString()&#xD;&#xA;        Else&#xD;&#xA;            label.Text = Convert.ToDouble(dblTransportar.ToString()).ToString(&quot;F&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;        End If&#xD;&#xA;    End While&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransportar.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;     If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Me.lblTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransporte.Visible = False&#xD;&#xA;            Me.lblTransporte.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransporte.Visible = True&#xD;&#xA;            Me.lblTransporte.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    If e.PageIndex &gt; 0 then&#xD;&#xA;        Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;        Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex - 1)     &#xD;&#xA;        Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;        While (iterator.MoveNext())&#xD;&#xA;             if (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal&quot;))&#xD;&#xA;                dblTransporte += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;            End If&#xD;&#xA;            If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;                label.Text = dblTransporte.ToString()&#xD;&#xA;            Else&#xD;&#xA;                label.Text = Convert.ToDouble(dblTransporte.ToString()).ToString(&quot;F&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;            End If&#xD;&#xA;        End While&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransporte.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;" DrawWatermark="true" Margins="54, 18, 25, 1" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosCompras_Cab" DataSource="#Ref-0">
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
    <Item2 Ref="30" ControlType="ReportHeaderBand" Name="ReportHeader" HeightF="0" />
    <Item3 Ref="31" ControlType="PageHeaderBand" Name="PageHeader" HeightF="2.09">
      <SubBands>
        <Item1 Ref="32" ControlType="SubBand" Name="SubBand5" HeightF="107.87">
          <Controls>
            <Item1 Ref="33" ControlType="XRSubreport" Name="Cabecalho Empresa Compras" ReportSourceUrl="10000" SizeF="535.2748,105.7917" LocationFloat="0, 0">
              <ParameterBindings>
                <Item1 Ref="34" ParameterName="IDEmpresa" DataMember="tbDocumentosCompras.IDLoja" />
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
                <Item1 Ref="121" Expression="[tbLojas_Descricao]" PropertyName="Text" EventName="BeforePrint" />
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
                <Item1 Ref="183" ControlType="XRSubreport" Name="Dimensoes Compras" ReportSourceUrl="30000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="0, 0">
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
                <Item1 Ref="239" ControlType="XRSubreport" Name="Dimensoes Compras Nao Valorizado" ReportSourceUrl="40000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="1.351293, 0">
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
            <Item2 Ref="274" ControlType="XRSubreport" Name="Motivos Isencao Compras" ReportSourceUrl="20000" SizeF="445.76,60.00002" LocationFloat="2.32, 4.16">
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
    <Item5 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Name="SqlDataSource" Base64="PFNxbERhdGFTb3VyY2UgTmFtZT0iU3FsRGF0YVNvdXJjZSI+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMTQzXGYzbTIwMTc7VXNlciBJRD1GM01PO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTI4MTRGM01POyIgLz48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXMiPjxQYXJhbWV0ZXIgTmFtZT0iSUREb2N1bWVudG8iIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKD9JRERvY3VtZW50byk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCBkaXN0aW5jdCAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9Eb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhRG9jdW1lbnRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iT2JzZXJ2YWNvZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGF4YUNvbnZlcnNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRvdGFsTW9lZGFEb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhUmVmZXJlbmNpYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkxvY2FsQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJIb3JhQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFDYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJMb2NhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSG9yYURlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW9yYWRhRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZURlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYURlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9EZXN0aW5hdGFyaW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZXJpZURvY01hbnVhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0RvY01hbnVhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0xpbmhhcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBvc3RvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJVdGlsaXphZG9yRXN0YWRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUhvcmFFc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBc3NpbmF0dXJhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmVyc2FvQ2hhdmVQcml2YWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZUZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYUZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRmlzY2FsIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9GaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb250cmlidWludGVGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvamEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJbXByZXNzbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9ySW1wb3N0byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBlcmNlbnRhZ2VtRGVzY29udG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWYWxvckRlc2NvbnRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRheGFJdmFQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUYXhhSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW90aXZvSXNlbmNhb0l2YSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vdGl2b0lzZW5jYW9Qb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbFBvcnRlcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkVzcGFjb0Zpc2NhbFBvcnRlcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iUmVnaW1lSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ3VzdG9zQWRpY2lvbmFpcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpc3RlbWEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBdGl2byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDcmlhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckNyaWFjYW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQWx0ZXJhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkYzTU1hcmNhZG9yIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURGb3JtYUV4cGVkaWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9JbnRlcm5vIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFbnRpZGFkZSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb0VudGlkYWRlIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25kaWNhb1BhZ2FtZW50byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETG9jYWxPcGVyYWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0FUIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURQYWlzQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFBhaXNEZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1hdHJpY3VsYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbEZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGVzY3JpY2FvRGlzdHJpdG9GaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvQVRJbnRlcm5vIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGlwb0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY3VtZW50byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1RpcG9Fc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Eb2NPcmlnZW0iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9DYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbENhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9EZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29FbnRpZGFkZSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb01vZWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTWVuc2FnZW1Eb2NBVCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEU2lzVGlwb3NEb2NQVSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Npc1RpcG9zRG9jUFUiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NNYW51YWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NSZXBvc2ljYW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQXNzaW5hdHVyYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDb250cm9sb0ludGVybm8iLA0KCSJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURvY3VtZW50byIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29UaXBvRXN0YWRvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNlZ3VuZGFWaWEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRCIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfSUQiLA0KCSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9yZGVtIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklERG9jdW1lbnRvQ29tcHJhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJ0aWdvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIkRlc2NyaWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRFVuaWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iTnVtQ2FzYXNEZWNVbmlkYWRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlF1YW50aWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iUHJlY29Vbml0YXJpbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJQcmVjb1VuaXRhcmlvRWZldGl2byIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJQcmVjb1RvdGFsIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9ic2VydmFjb2VzIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19PYnNlcnZhY29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRExvdGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQ29kaWdvTG90ZSIsDQoJICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQ29kaWdvVW5pZGFkZSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEZXNjcmljYW9Mb3RlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIkRhdGFGYWJyaWNvTG90ZSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEYXRhVmFsaWRhZGVMb3RlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJ0aWdvTnVtU2VyaWUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQXJ0aWdvTnVtU2VyaWUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbUxvY2FsaXphY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbURlc3Rpbm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtTG9jYWxpemFjYW9EZXN0aW5vIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk51bUxpbmhhc0RpbWVuc29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEZXNjb250bzEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGVzY29udG8yIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEVGF4YUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJUYXhhSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk1vdGl2b0lzZW5jYW9JdmEiIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX01vdGl2b0lzZW5jYW9JdmEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURFc3BhY29GaXNjYWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRXNwYWNvRmlzY2FsIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEUmVnaW1lSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlJlZ2ltZUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJTaWdsYVBhaXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iT3JkZW0iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iU2lzdGVtYSIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfU2lzdGVtYSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJBdGl2byIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfQXRpdm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGF0YUNyaWFjYW8iIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0RhdGFDcmlhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlV0aWxpemFkb3JDcmlhY2FvIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19VdGlsaXphZG9yQ3JpYWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEYXRhQWx0ZXJhY2FvIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQWx0ZXJhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlV0aWxpemFkb3JBbHRlcmFjYW8iIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX1V0aWxpemFkb3JBbHRlcmFjYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRjNNTWFyY2Fkb3IiIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0YzTU1hcmNhZG9yIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlZhbG9ySW5jaWRlbmNpYSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJWYWxvcklWQSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEb2N1bWVudG9PcmlnZW0iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGF0YUVudHJlZ2EiLA0KCSAidGJGb3JuZWNlZG9yZXMiLiJOb21lIiBhcyAidGJGb3JuZWNlZG9yZXNfTm9tZSIsDQoJICJ0YkZvcm5lY2Vkb3JlcyIuIkNvZGlnbyIgYXMgInRiRm9ybmVjZWRvcmVzX0NvZGlnbyIsDQoJICJ0YkZvcm5lY2Vkb3JlcyIuIk5Db250cmlidWludGUiIGFzICJ0YkZvcm5lY2Vkb3Jlc19OQ29udHJpYnVpbnRlIiwNCgkgInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIk1vcmFkYSIgYXMgInRiRm9ybmVjZWRvcmVzTW9yYWRhc19Nb3JhZGEiLA0KCSAidGJDb2RpZ29zUG9zdGFpcyIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0NvZGlnbyIsDQoJICJ0YkNvZGlnb3NQb3N0YWlzIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiwNCiAgICAgICAidGJFc3RhZG9zIi4iQ29kaWdvIiBhcyAidGJFc3RhZG9zX0NvZGlnbyIsDQogICAgICAgInRiRXN0YWRvcyIuIkRlc2NyaWNhbyIgYXMgInRiRXN0YWRvc19EZXNjcmljYW8iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iQ29kaWdvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Db2RpZ28iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KCSAidGJUaXBvc0RvY3VtZW50byIuIkRvY05hb1ZhbG9yaXphZG8iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0RvY05hb1ZhbG9yaXphZG8iLA0KCSAidGJUaXBvc0RvY3VtZW50byIuIkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJEZXNjcmljYW9TZXJpZSIsDQogICAgICAgInRiQXJ0aWdvcyIuIkNvZGlnbyIgYXMgInRiQXJ0aWdvc19Db2RpZ28iLA0KICAgICAgICJ0YkFydGlnb3MiLiJEZXNjcmljYW9BYnJldmlhZGEiLA0KICAgICAgICJ0YkFydGlnb3MiLiJEZXNjcmljYW8iIGFzICJ0YkFydGlnb3NfRGVzY3JpY2FvIiwNCiAgICAgICAidGJBcnRpZ29zIi4iR2VyZUxvdGVzIiBhcyAidGJBcnRpZ29zX0dlcmVMb3RlcyIsDQogICAgICAgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiwNCgkgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iVGlwbyIgYXMgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iLA0KCSAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KICAgICAgICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIlRpcG8iLA0KICAgICAgICJ0YkNvZGlnb3NQb3N0YWlzMSIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNfQ29kaWdvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczEiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMyIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMyIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0Rlc2NyaWNhbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMzIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0NvZGlnbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMzIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJNb2VkYXNfQ29kaWdvIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW8iIGFzICJ0Yk1vZWRhc19EZXNjcmljYW8iLA0KICAgICAgICJ0Yk1vZWRhcyIuIlNpbWJvbG8iIGFzICJ0Yk1vZWRhc19TaW1ib2xvIiwNCgkgInRiQXJtYXplbnMiLiJEZXNjcmljYW8iIGFzICJ0YkFybWF6ZW5zX0Rlc2NyaWNhbyIsDQoJICJ0YkFybWF6ZW5zIi4iQ29kaWdvIiBhcyAidGJBcm1hemVuc19Db2RpZ28iLA0KCSAidGJBcm1hemVuc0xvY2FsaXphY29lcyIuIkRlc2NyaWNhbyIgYXMgInRiQXJtYXplbnNMb2NhbGl6YWNvZXNfRGVzY3JpY2FvIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzX0NvZGlnbyIsDQoJICJ0YkFybWF6ZW5zMSIuIkRlc2NyaWNhbyIgYXMgInRiQXJtYXplbnMxX0Rlc2NyaWNhb0Rlc3Rpbm8iLA0KCSAidGJBcm1hemVuczEiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zMV9Db2RpZ29EZXN0aW5vIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iRGVzY3JpY2FvIiBhcyAidGJBcm1hemVuc0xvY2FsaXphY29lczFfRGVzY3JpY2FvIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iQ29kaWdvIiBhcyAidGJBcm1hemVuc0xvY2FsaXphY29lczFfQ29kaWdvIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiBhcyAidGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIsDQoJICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgYXMgInRiTW9lZGFzX0Nhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiLA0KCSAgICJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNJdmEiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzSXZhIiwNCgkgInRiU2lzdGVtYUNvZGlnb3NJVkEiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFDb2RpZ29zSVZBLkNvZGlnbyIsIA0KICAgICAgICJ0YlNpc3RlbWFNb2VkYXMiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFNb2VkYXNfQ29kaWdvIiwNCgkgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhRG9jdW1lbnRvIiAtICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JJbXBvc3RvIiBhcyAiU3ViVG90YWwiLA0KCSAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgYXMgInRiUGFyYW1lbnRyb3NFbXByZXNhX0Nhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIsDQoJICJ0YlNpc3RlbWFOYXR1cmV6YXMiLkNvZGlnbyBhcyAidGJTaXN0ZW1hTmF0dXJlemFzX0NvZGlnbyINCiAgZnJvbSAiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhcyINCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIg0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIg0KICAgICAgIG9uICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSUREb2N1bWVudG9Db21wcmEiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YklWQSIgInRiSVZBIiBvbiAidGJJVkEiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEVGF4YUl2YSINCiAgbGVmdCBqb2luIHRiU2lzdGVtYUNvZGlnb3NJVkEgb24gdGJJVkEuSURDb2RpZ29JVkEgPSB0YlNpc3RlbWFDb2RpZ29zSVZBLklEDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hVGlwb3NJVkEiICJ0YlNpc3RlbWFUaXBvc0lWQSIgb24gInRiU2lzdGVtYVRpcG9zSVZBIi4iSUQiID0gInRiSVZBIi4iSURUaXBvSXZhIg0KICBsZWZ0IGpvaW4gImRibyIuInRiRm9ybmVjZWRvcmVzIiAidGJGb3JuZWNlZG9yZXMiDQogICAgICAgb24gInRiRm9ybmVjZWRvcmVzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVudGlkYWRlIg0KICBsZWZ0IGpvaW4gImRibyIuICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiDQoJICAgb24gInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIklERm9ybmVjZWRvciIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERW50aWRhZGUiIGFuZCAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iT3JkZW0iPTENCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpcyINCiAgICAgICBvbiAidGJDb2RpZ29zUG9zdGFpcyIuIklEIiA9ICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiLiJJRENvZGlnb1Bvc3RhbCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkVzdGFkb3MiICJ0YkVzdGFkb3MiDQogICAgICAgb24gInRiRXN0YWRvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJUaXBvc0RvY3VtZW50byINCiAgICAgICAidGJUaXBvc0RvY3VtZW50byINCiAgICAgICBvbiAidGJUaXBvc0RvY3VtZW50byIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvRG9jdW1lbnRvIg0KICBsZWZ0IGpvaW4gImRibyIuInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KICAgICAgIG9uICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KCSAgICBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIiAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iDQogICAgICAgb24gInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFUaXBvc0RvY3VtZW50byINCiAgbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIg0KICAgICAgIG9uICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIklEIiA9ICJ0YlRpcG9zRG9jdW1lbnRvIi4iSURTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hTmF0dXJlemFzIiAidGJTaXN0ZW1hTmF0dXJlemFzIg0KICAgICAgIG9uICJ0YlNpc3RlbWFOYXR1cmV6YXMiLiJJRCIgPSAidGJUaXBvc0RvY3VtZW50byIuIklEU2lzdGVtYU5hdHVyZXphcyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFydGlnb3MiICJ0YkFydGlnb3MiDQogICAgICAgb24gInRiQXJ0aWdvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcnRpZ28iDQogIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMxIg0KICAgICAgIG9uICJ0YkNvZGlnb3NQb3N0YWlzMSIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiDQogIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMyIg0KICAgICAgIG9uICJ0YkNvZGlnb3NQb3N0YWlzMiIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczMiDQogICAgICAgb24gInRiQ29kaWdvc1Bvc3RhaXMzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIg0KICBsZWZ0IGpvaW4gImRibyIuInRiTW9lZGFzIiAidGJNb2VkYXMiDQogICAgICAgb24gInRiTW9lZGFzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIg0KICBsZWZ0IGpvaW4gInRiUGFyYW1ldHJvc0VtcHJlc2EiIA0KICAgICAgIG9uICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURNb2VkYURlZmVpdG8iID0gInRiTW9lZGFzIi4iSUQiIA0KICBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYU1vZWRhcyIgInRiU2lzdGVtYU1vZWRhcyINCiAgICAgICBvbiAidGJTaXN0ZW1hTW9lZGFzIi4iSUQiID0gInRiTW9lZGFzIi4iSURTaXN0ZW1hTW9lZGEiDQogIGxlZnQgam9pbiAiZGJvIi4idGJBcm1hemVucyIgInRiQXJtYXplbnMiDQogICAgICAgb24gInRiQXJtYXplbnMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzIiAidGJBcm1hemVuc0xvY2FsaXphY29lcyINCiAgICAgICBvbiAidGJBcm1hemVuc0xvY2FsaXphY29lcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtTG9jYWxpemFjYW8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJBcm1hemVucyIgInRiQXJtYXplbnMxIg0KICAgICAgIG9uICJ0YkFybWF6ZW5zMSIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtRGVzdGlubyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzIiAidGJBcm1hemVuc0xvY2FsaXphY29lczEiDQogICAgICAgb24gInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJREFybWF6ZW1Mb2NhbGl6YWNhb0Rlc3Rpbm8iDQp3aGVyZSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEIj0gQElERG9jdW1lbnRvDQpPcmRlciBieSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9yZGVtIjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IkN1c3RvbVNxbFF1ZXJ5IiBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzX0NhYiI+PFBhcmFtZXRlciBOYW1lPSJJZERvYyIgVHlwZT0iRGV2RXhwcmVzcy5EYXRhQWNjZXNzLkV4cHJlc3Npb24iPihTeXN0ZW0uSW50NjQsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OSkoP0lERG9jdW1lbnRvKTwvUGFyYW1ldGVyPjxTcWw+c2VsZWN0IGRpc3RpbmN0ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUQiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0RvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk9ic2VydmFjb2VzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETW9lZGEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGF4YUNvbnZlcnNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRvdGFsTW9lZGFSZWZlcmVuY2lhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkxvY2FsQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUNhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkhvcmFDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbENhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uY2VsaG9DYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTG9jYWxEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSG9yYURlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYURlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOb21lRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZXJpZURvY01hbnVhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2NNYW51YWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTnVtZXJvTGluaGFzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBvc3RvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXN0YWRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlV0aWxpemFkb3JFc3RhZG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUhvcmFFc3RhZG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQXNzaW5hdHVyYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWZXJzYW9DaGF2ZVByaXZhZGEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZUZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvbnRyaWJ1aW50ZUZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURMb2phIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkltcHJlc3NvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9ySW1wb3N0byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJQZXJjZW50YWdlbURlc2NvbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9yRGVzY29udG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUYXhhSXZhUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRheGFJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW90aXZvSXNlbmNhb0l2YSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXNwYWNvRmlzY2FsUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkVzcGFjb0Zpc2NhbFBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFJlZ2ltZUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJSZWdpbWVJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ3VzdG9zQWRpY2lvbmFpcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaXN0ZW1hIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkF0aXZvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDcmlhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlV0aWxpemFkb3JDcmlhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFBbHRlcmFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRjNNTWFyY2Fkb3IiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREZvcm1hRXhwZWRpY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTnVtZXJvSW50ZXJubyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9FbnRpZGFkZSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVudGlkYWRlIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uZGljYW9QYWdhbWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURMb2NhbE9wZXJhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0FUIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1hdHJpY3VsYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFBhaXNGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvUG9zdGFsRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEZXNjcmljYW9Db25jZWxob0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEZXNjcmljYW9EaXN0cml0b0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFJlZ2ltZUl2YSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29BVEludGVybm8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGlwb0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvVGlwb0VzdGFkbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Eb2NPcmlnZW0iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGlzdHJpdG9DYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb25jZWxob0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbENhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpZ2xhUGFpc0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRpc3RyaXRvRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29FbnRpZGFkZSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Nb2VkYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNZW5zYWdlbURvY0FUIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEU2lzVGlwb3NEb2NQVSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29TaXNUaXBvc0RvY1BVIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY01hbnVhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NSZXBvc2ljYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUFzc2luYXR1cmEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUNvbnRyb2xvSW50ZXJubyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZWd1bmRhVmlhIiwidGJGb3JuZWNlZG9yZXMiLiJOb21lIiBhcyAidGJGb3JuZWNlZG9yZXNfTm9tZSIsInRiRm9ybmVjZWRvcmVzIi4iQ29kaWdvIiBhcyAidGJGb3JuZWNlZG9yZXNfQ29kaWdvIiwidGJGb3JuZWNlZG9yZXMiLiJOQ29udHJpYnVpbnRlIiBhcyAidGJGb3JuZWNlZG9yZXNfTkNvbnRyaWJ1aW50ZSIsInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIk1vcmFkYSIgYXMgInRiRm9ybmVjZWRvcmVzTW9yYWRhc19Nb3JhZGEiLCJ0YkNvZGlnb3NQb3N0YWlzIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpcyIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0Rlc2NyaWNhbyIsInRiRXN0YWRvcyIuIkNvZGlnbyIgYXMgInRiRXN0YWRvc19Db2RpZ28iLCJ0YkVzdGFkb3MiLiJEZXNjcmljYW8iIGFzICJ0YkVzdGFkb3NfRGVzY3JpY2FvIiwidGJUaXBvc0RvY3VtZW50byIuIkNvZGlnbyIgYXMgInRiVGlwb3NEb2N1bWVudG9fQ29kaWdvIiwidGJUaXBvc0RvY3VtZW50byIuIkRlc2NyaWNhbyIgYXMgInRiVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiwidGJUaXBvc0RvY3VtZW50byIuIkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIsInRiVGlwb3NEb2N1bWVudG8iLiJEb2NOYW9WYWxvcml6YWRvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Eb2NOYW9WYWxvcml6YWRvIiwidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIkNvZGlnb1NlcmllIiwidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIkRlc2NyaWNhb1NlcmllIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJEZXNjcmljYW8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbF9EZXNjcmljYW8iLCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byIuIlRpcG8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19UaXBvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIlRpcG8iLCJ0YkNvZGlnb3NQb3N0YWlzMyIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iLCJ0YkNvZGlnb3NQb3N0YWlzMyIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9EZXNjcmljYW8iLCJ0YkNvZGlnb3NQb3N0YWlzMSIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNfQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpczEiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIsInRiQ29kaWdvc1Bvc3RhaXMyIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMyIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0Rlc2NyaWNhbyIsInRiTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJNb2VkYXNfQ29kaWdvIiwidGJNb2VkYXMiLiJEZXNjcmljYW8iIGFzICJ0Yk1vZWRhc19EZXNjcmljYW8iLCJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNUb3RhaXMiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzSXZhIiBhcyAidGJNb2VkYXNfQ2FzYXNEZWNpbWFpc0l2YSIsInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgYXMgInRiTW9lZGFzX0Nhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiLCJ0Yk1vZWRhcyIuIlNpbWJvbG8iIGFzICJ0Yk1vZWRhc19TaW1ib2xvIiwidGJTaXN0ZW1hTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIsInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIGFzICJ0YlBhcmFtZW50cm9zRW1wcmVzYV9DYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iLCJ0YlNpc3RlbWFOYXR1cmV6YXMiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFOYXR1cmV6YXNfQ29kaWdvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYURlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWb3Nzb051bWVyb0RvY3VtZW50byIsc3VtKCJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iVmFsb3JEZXNjb250b0xpbmhhIikgYXMgIlZhbG9yRGVzY29udG9MaW5oYV9TdW0iLCAidGJMb2phcyIuIkRlc2NyaWNhbyIgYXMgInRiTG9qYXNfRGVzY3JpY2FvIiBmcm9tICgoKCgoKCgoKCgoKCgoKCgiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiDQogbGVmdCBqb2luICJkYm8iLiJ0YkRvY3VtZW50b3NDb21wcmFzIiAidGJEb2N1bWVudG9zQ29tcHJhcyIgb24gKCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRERvY3VtZW50b0NvbXByYSIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJGb3JuZWNlZG9yZXMiICJ0YkZvcm5lY2Vkb3JlcyIgb24gKCJ0YkZvcm5lY2Vkb3JlcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFbnRpZGFkZSIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJGb3JuZWNlZG9yZXNNb3JhZGFzIiAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIiBvbiAoInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIklERm9ybmVjZWRvciIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERW50aWRhZGUiIGFuZCAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iT3JkZW0iPTEgKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiQ29kaWdvc1Bvc3RhaXMiICJ0YkNvZGlnb3NQb3N0YWlzIiBvbiAoInRiQ29kaWdvc1Bvc3RhaXMiLiJJRCIgPSAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iSURDb2RpZ29Qb3N0YWwiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiRXN0YWRvcyIgInRiRXN0YWRvcyIgb24gKCJ0YkVzdGFkb3MiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXN0YWRvIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YlRpcG9zRG9jdW1lbnRvIiAidGJUaXBvc0RvY3VtZW50byIgb24gKCJ0YlRpcG9zRG9jdW1lbnRvIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9Eb2N1bWVudG8iKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIiBvbiAoInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIiAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iIG9uICgidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJJRCIgPSAidGJUaXBvc0RvY3VtZW50byIuIklEU2lzdGVtYVRpcG9zRG9jdW1lbnRvIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIiBvbiAoInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMxIiBvbiAoInRiQ29kaWdvc1Bvc3RhaXMxIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbEZpc2NhbCIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMyIiBvbiAoInRiQ29kaWdvc1Bvc3RhaXMyIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbENhcmdhIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczMiIG9uICgidGJDb2RpZ29zUG9zdGFpczMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiTW9lZGFzIiAidGJNb2VkYXMiIG9uICgidGJNb2VkYXMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETW9lZGEiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiUGFyYW1ldHJvc0VtcHJlc2EiICJ0YlBhcmFtZXRyb3NFbXByZXNhIiBvbiAoInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIgPSAidGJNb2VkYXMiLiJJRCIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hTmF0dXJlemFzIiAidGJTaXN0ZW1hTmF0dXJlemFzIiBvbiAoInRiU2lzdGVtYU5hdHVyZXphcyIuIklEIiA9ICJ0YlRpcG9zRG9jdW1lbnRvIi4iSURTaXN0ZW1hTmF0dXJlemFzIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFNb2VkYXMiICJ0YlNpc3RlbWFNb2VkYXMiIG9uICgidGJTaXN0ZW1hTW9lZGFzIi4iSUQiID0gInRiTW9lZGFzIi4iSURTaXN0ZW1hTW9lZGEiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiTG9qYXMiICJ0YkxvamFzIiBvbiAoInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvamEiID0gInRiTG9qYXMiLiJJRCIpDQp3aGVyZSAoInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCIgPSBASWREb2MpDQpncm91cCBieSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb0RvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJPYnNlcnZhY29lcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRheGFDb252ZXJzYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVG90YWxNb2VkYURvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhUmVmZXJlbmNpYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJMb2NhbENhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJIb3JhQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW9yYWRhQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkxvY2FsRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkhvcmFEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uY2VsaG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZURlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFEZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNlcmllRG9jTWFudWFsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0RvY01hbnVhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9MaW5oYXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iUG9zdG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckVzdGFkbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhSG9yYUVzdGFkbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBc3NpbmF0dXJhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZlcnNhb0NoYXZlUHJpdmFkYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOb21lRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYUZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbEZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9GaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29udHJpYnVpbnRlRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpZ2xhUGFpc0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvamEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSW1wcmVzc28iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JJbXBvc3RvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBlcmNlbnRhZ2VtRGVzY29udG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JEZXNjb250byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWYWxvclBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRheGFJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGF4YUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3Rpdm9Jc2VuY2FvSXZhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vdGl2b0lzZW5jYW9Qb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3BhY29GaXNjYWxQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRXNwYWNvRmlzY2FsUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlJlZ2ltZUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDdXN0b3NBZGljaW9uYWlzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpc3RlbWEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQXRpdm8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUNyaWFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckNyaWFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUFsdGVyYWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJVdGlsaXphZG9yQWx0ZXJhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkYzTU1hcmNhZG9yIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERm9ybWFFeHBlZGljYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvc0RvY3VtZW50b1NlcmllcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9JbnRlcm5vIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERW50aWRhZGUiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvRW50aWRhZGUiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25kaWNhb1BhZ2FtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvY2FsT3BlcmFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvQVQiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURQYWlzQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURQYWlzRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTWF0cmljdWxhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Qb3N0YWxGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGVzY3JpY2FvQ29kaWdvUG9zdGFsRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0Rpc3RyaXRvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXNwYWNvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0FUSW50ZXJubyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUaXBvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29UaXBvRXN0YWRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0RvY09yaWdlbSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvbmNlbGhvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvUG9zdGFsQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGlzdHJpdG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb25jZWxob0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbERlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpZ2xhUGFpc0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0VudGlkYWRlIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb01vZWRhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1lbnNhZ2VtRG9jQVQiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURTaXNUaXBvc0RvY1BVIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Npc1RpcG9zRG9jUFUiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRG9jTWFudWFsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY1JlcG9zaWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQXNzaW5hdHVyYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQ29udHJvbG9JbnRlcm5vIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNlZ3VuZGFWaWEiLCJ0YkZvcm5lY2Vkb3JlcyIuIkNvZGlnbyIsInRiRm9ybmVjZWRvcmVzIi4iTm9tZSIsInRiRm9ybmVjZWRvcmVzIi4iTkNvbnRyaWJ1aW50ZSIsInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIk1vcmFkYSIsInRiQ29kaWdvc1Bvc3RhaXMiLiJDb2RpZ28iLCJ0YkNvZGlnb3NQb3N0YWlzIi4iRGVzY3JpY2FvIiwidGJFc3RhZG9zIi4iQ29kaWdvIiwidGJFc3RhZG9zIi4iRGVzY3JpY2FvIiwidGJUaXBvc0RvY3VtZW50byIuIkNvZGlnbyIsInRiVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iLCJ0YlRpcG9zRG9jdW1lbnRvIi4iQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iLCJ0YlRpcG9zRG9jdW1lbnRvIi4iRG9jTmFvVmFsb3JpemFkbyIsInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJEZXNjcmljYW9TZXJpZSIsInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iVGlwbyIsInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJUaXBvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJEZXNjcmljYW8iLCJ0YkNvZGlnb3NQb3N0YWlzMSIuIkNvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMxIi4iRGVzY3JpY2FvIiwidGJDb2RpZ29zUG9zdGFpczIiLiJDb2RpZ28iLCJ0YkNvZGlnb3NQb3N0YWlzMiIuIkRlc2NyaWNhbyIsInRiQ29kaWdvc1Bvc3RhaXMzIi4iQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpczMiLiJEZXNjcmljYW8iLCJ0Yk1vZWRhcyIuIkNvZGlnbyIsInRiTW9lZGFzIi4iRGVzY3JpY2FvIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzSXZhIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiwidGJNb2VkYXMiLiJTaW1ib2xvIiwidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIsInRiU2lzdGVtYU5hdHVyZXphcyIuIkNvZGlnbyIsInRiU2lzdGVtYU1vZWRhcyIuIkNvZGlnbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWb3Nzb051bWVyb0RvY3VtZW50byIsICJ0YkxvamFzIi4iRGVzY3JpY2FvIjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IlNlbGVjdFF1ZXJ5IiBOYW1lPSJ0YlBhcmFtZXRyb3NFbXByZXNhIj48VGFibGVzPjxUYWJsZSBOYW1lPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiAvPjwvVGFibGVzPjxDb2x1bW5zPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklEIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklETW9lZGFEZWZlaXRvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9Ik1vcmFkYSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJGb3RvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkZvdG9DYW1pbmhvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkRlc2lnbmFjYW9Db21lcmNpYWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQ29kaWdvUG9zdGFsIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkxvY2FsaWRhZGUiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQ29uY2VsaG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRGlzdHJpdG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURQYWlzIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IlRlbGVmb25lIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkZheCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJFbWFpbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJXZWJTaXRlIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9Ik5JRiIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkNhcGl0YWxTb2NpYWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURJZGlvbWFCYXNlIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IlNpc3RlbWEiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQXRpdm8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRGF0YUNyaWFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRGF0YUFsdGVyYWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkYzTU1hcmNhZG9yIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklERW1wcmVzYSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURQYWlzZXNEZXNjIiAvPjwvQ29sdW1ucz48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQgTmFtZT0iU3FsRGF0YVNvdXJjZSI+PFZpZXcgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc19DYWIiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRhdGFEb2N1bWVudG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJPYnNlcnZhY29lcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRE1vZWRhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUNvbnZlcnNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhRG9jdW1lbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsTW9lZGFSZWZlcmVuY2lhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkxvY2FsQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUNhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSG9yYUNhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iTW9yYWRhQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxDYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9DYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9DYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkxvY2FsRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YURlc2NhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSG9yYURlc2NhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iTW9yYWRhRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9EZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik5vbWVEZXN0aW5hdGFyaW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlNlcmllRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY01hbnVhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9MaW5oYXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJQb3N0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVzdGFkbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JFc3RhZG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUhvcmFFc3RhZG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJBc3NpbmF0dXJhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlZlcnNhb0NoYXZlUHJpdmFkYSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9Ik5vbWVGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTW9yYWRhRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb250cmlidWludGVGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklETG9qYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkltcHJlc3NvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJWYWxvckltcG9zdG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUGVyY2VudGFnZW1EZXNjb250byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckRlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yUG9ydGVzIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEVGF4YUl2YVBvcnRlcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFJdmFQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iTW90aXZvSXNlbmNhb0l2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRXNwYWNvRmlzY2FsUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUmVnaW1lSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUmVnaW1lSXZhUG9ydGVzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkN1c3Rvc0FkaWNpb25haXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkYzTU1hcmNhZG9yIiBUeXBlPSJCeXRlQXJyYXkiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURGb3JtYUV4cGVkaWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb3NEb2N1bWVudG9TZXJpZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9JbnRlcm5vIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvRW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREVudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25kaWNhb1BhZ2FtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETG9jYWxPcGVyYWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0FUIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpc0NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURQYWlzRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNYXRyaWN1bGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9Db25jZWxob0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9EaXN0cml0b0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVzcGFjb0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEUmVnaW1lSXZhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQVRJbnRlcm5vIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG9GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRG9jdW1lbnRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1RpcG9Fc3RhZG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvRG9jT3JpZ2VtIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG9DYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxDYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNDYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0b0Rlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvRW50aWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvTW9lZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTWVuc2FnZW1Eb2NBVCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFNpc1RpcG9zRG9jUFUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29TaXNUaXBvc0RvY1BVIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRvY01hbnVhbCIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRG9jUmVwb3NpY2FvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQXNzaW5hdHVyYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkRhdGFDb250cm9sb0ludGVybm8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJTZWd1bmRhVmlhIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YkZvcm5lY2Vkb3Jlc19Ob21lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkZvcm5lY2Vkb3Jlc19OQ29udHJpYnVpbnRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzTW9yYWRhc19Nb3JhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVzdGFkb3NfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRXN0YWRvc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19Eb2NOYW9WYWxvcml6YWRvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbF9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fVGlwbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc0l2YSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFNb2VkYXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiUGFyYW1lbnRyb3NFbXByZXNhX0Nhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hTmF0dXJlemFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFEZXN0aW5hdGFyaW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVm9zc29OdW1lcm9Eb2N1bWVudG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmFsb3JEZXNjb250b0xpbmhhX1N1bSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0YkxvamFzX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48VmlldyBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEYXRhRG9jdW1lbnRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iT2JzZXJ2YWNvZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURNb2VkYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxNb2VkYURvY3VtZW50byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhUmVmZXJlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJMb2NhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYUNhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJMb2NhbERlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOb21lRGVzdGluYXRhcmlvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc3RpbmF0YXJpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbERlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2VyaWVEb2NNYW51YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0xpbmhhcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlBvc3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXN0YWRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckVzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhSG9yYUVzdGFkbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkFzc2luYXR1cmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmVyc2FvQ2hhdmVQcml2YWRhIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iTm9tZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvbnRyaWJ1aW50ZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSW1wcmVzc28iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW1wb3N0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQZXJjZW50YWdlbURlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRGVzY29udG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURUYXhhSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUl2YVBvcnRlcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9Qb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ3VzdG9zQWRpY2lvbmFpcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvciIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJJREZvcm1hRXhwZWRpY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvc0RvY3VtZW50b1NlcmllcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0ludGVybm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREVudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvRW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmRpY2FvUGFnYW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURMb2NhbE9wZXJhY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNEZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1hdHJpY3VsYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0Rpc3RyaXRvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BVEludGVybm8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwb0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEb2N1bWVudG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb0VzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Eb2NPcmlnZW0iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG9DYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxob0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG9EZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29FbnRpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Nb2VkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNZW5zYWdlbURvY0FUIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEU2lzVGlwb3NEb2NQVSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Npc1RpcG9zRG9jUFUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRG9jTWFudWFsIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEb2NSZXBvc2ljYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFBc3NpbmF0dXJhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YUNvbnRyb2xvSW50ZXJubyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkRhdGFEb2N1bWVudG9fMSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1RpcG9Fc3RhZG9fMSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTZWd1bmRhVmlhIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0lEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iT3JkZW0iIFR5cGU9IkludDMyIiAvPjxGaWVsZCBOYW1lPSJJRERvY3VtZW50b0NvbXByYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEVW5pZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bUNhc2FzRGVjVW5pZGFkZSIgVHlwZT0iSW50MTYiIC8+PEZpZWxkIE5hbWU9IlF1YW50aWRhZGUiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvRWZldGl2byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1RvdGFsIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfT2JzZXJ2YWNvZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb3RlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvTG90ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29VbmlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0xvdGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUZhYnJpY29Mb3RlIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YVZhbGlkYWRlTG90ZSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IklEQXJ0aWdvTnVtU2VyaWUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJBcnRpZ29OdW1TZXJpZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW0iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1Mb2NhbGl6YWNhbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJtYXplbURlc3Rpbm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFybWF6ZW1Mb2NhbGl6YWNhb0Rlc3Rpbm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1MaW5oYXNEaW1lbnNvZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEZXNjb250bzEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRGVzY29udG8yIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IklEVGF4YUl2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFJdmEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19Nb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlJlZ2ltZUl2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iT3JkZW1fMSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19BdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQ3JpYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19VdGlsaXphZG9yQWx0ZXJhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iVmFsb3JJbmNpZGVuY2lhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9ySVZBIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRvY3VtZW50b09yaWdlbSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhRW50cmVnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX05vbWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX05Db250cmlidWludGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNNb3JhZGFzX01vcmFkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRXN0YWRvc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFc3RhZG9zX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0RvY05hb1ZhbG9yaXphZG8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJ0aWdvc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQWJyZXZpYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJ0aWdvc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcnRpZ29zX0dlcmVMb3RlcyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX1NpbWJvbG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc0xvY2FsaXphY29lc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc0xvY2FsaXphY29lc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuczFfRGVzY3JpY2FvRGVzdGlubyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zMV9Db2RpZ29EZXN0aW5vIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJtYXplbnNMb2NhbGl6YWNvZXMxX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzMV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc0l2YSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hQ29kaWdvc0lWQS5Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTdWJUb3RhbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0YlBhcmFtZW50cm9zRW1wcmVzYV9DYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYU5hdHVyZXphc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48L1ZpZXc+PFZpZXcgTmFtZT0idGJQYXJhbWV0cm9zRW1wcmVzYSI+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURNb2VkYURlZmVpdG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJNb3JhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvQ2FtaW5obyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNpZ25hY2FvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJMb2NhbGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZheCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJXZWJTaXRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik5JRiIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNhcGl0YWxTb2NpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURJZGlvbWFCYXNlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2lzdGVtYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQXRpdm8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUFsdGVyYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IlVua25vd24iIC8+PEZpZWxkIE5hbWU9IklERW1wcmVzYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0iSURQYWlzZXNEZXNjIiBUeXBlPSJJbnQ2NCIgLz48L1ZpZXc+PC9EYXRhU2V0PjwvUmVzdWx0U2NoZW1hPjxDb25uZWN0aW9uT3B0aW9ucyBDbG9zZUNvbm5lY3Rpb249InRydWUiIERiQ29tbWFuZFRpbWVvdXQ9IjE4MDAiIC8+PC9TcWxEYXRhU291cmNlPg==" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''
--Mapa de documentos de compras 
---tratar subreports
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item3/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=10000][1] with sql:variable("@intIDMapaSubCab")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item7/SubBands/Item1/Controls/Item2/@ReportSourceUrl)[.=20000][1] with sql:variable("@intIDMapaMI")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item5/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=30000][1] with sql:variable("@intIDMapaD")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item6/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=40000][1] with sql:variable("@intIDMapaDNV")'')
UPDATE tbMapasVistas SET MapaXML = @ptrval , NomeMapa = ''DocumentosCompras'' Where Entidade = ''PurchaseDocumentsList'' and NomeMapa = ''DocumentosCompras''
')

