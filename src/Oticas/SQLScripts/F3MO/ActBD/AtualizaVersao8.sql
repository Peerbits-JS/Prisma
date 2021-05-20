/* ACT BD EMPRESA VERSAO 8 */
exec('update [F3MOGeral].dbo.tbmenus set ativo =1  where descricaoabreviada = ''006''')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=116)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) VALUES (116, 6, N''Caixa'', N''006.001'', N''Caixa'', 1, N''fm f3icon-abertura-caixa'', N''Accao'', 1, 6, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=116 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 116, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')


EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbMenus] WHERE ID=117)
BEGIN
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] ON
INSERT [F3MOGeral].[dbo].[tbMenus] ([ID], [IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar]) VALUES (117, 116, N''AberturaCaixa'', N''006.001.001'', N''AberturaCaixa'', 2, N''fm f3icon-abertura-caixa'', N''/Caixas/AberturaCaixa'', 1, 6, 1, 1, 1, 1, 1, 1, NULL, 1, 0, CAST(N''2017-02-22 00:00:00.000'' AS DateTime), N''F3M'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [F3MOGeral].[dbo].[tbMenus] OFF
END')

EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral].[dbo].[tbPerfisAcessos] WHERE IDMenus=117 and IDPerfis=1)
BEGIN
INSERT [F3MOGeral].[dbo].[tbPerfisAcessos] ([IDPerfis], [IDMenus], [Consultar], [Adicionar], [Alterar], [Remover], [Imprimir], [Exportar], [F4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [Importar], [Duplicar]) VALUES (1, 117, 1, 1, 1, 1, 1, 1, 1, 1, 0, CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.633'' AS DateTime), N''F3M'', NULL, NULL)
END')

EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwArtigos'')) drop view vwArtigos')
EXEC('
BEGIN
EXECUTE(''
create view vwArtigos
as
select ''''003'''' as tipodoc, tbdocumentoscompraslinhas.iddocumentocompra as IDDocumento, tbdocumentoscompraslinhas.quantidade as Quantidade, 
tbArtigosPrecos.ValorComIva, tbArtigos.Codigo, tbArtigos.CodigoBarras,tbArtigos.CodigoBarrasFornecedor, tbArtigos.ReferenciaFornecedor
FROM tbdocumentoscompraslinhas as tbdocumentoscompraslinhas 
LEFT JOIN tbArtigos AS tbArtigos ON tbArtigos.id=tbdocumentoscompraslinhas.IDArtigo
LEFT JOIN tbArtigosPrecos AS tbArtigosPrecos ON tbArtigosPrecos.IDArtigo=tbArtigos.id and tbArtigosPrecos.IDCodigoPreco=1
union
select ''''001'''' as tipodoc, tbDocumentosStockLinhas.IDDocumentoStock as IDDocumento, tbDocumentosStockLinhas.Quantidade as Quantidade, 
tbArtigosPrecos.ValorComIva, tbArtigos.Codigo, tbArtigos.CodigoBarras,tbArtigos.CodigoBarrasFornecedor, tbArtigos.ReferenciaFornecedor
FROM tbDocumentosStockLinhas as tbDocumentosStockLinhas 
LEFT JOIN tbArtigos AS tbArtigos ON tbArtigos.id=tbDocumentosStockLinhas.IDArtigo
LEFT JOIN tbArtigosPrecos AS tbArtigosPrecos ON tbArtigosPrecos.IDArtigo=tbArtigos.id and tbArtigosPrecos.IDCodigoPreco=1
'')
END')

--mapas vistas
EXEC('
BEGIN
DECLARE @IDLoja as bigint
SELECT @IDLoja = ID FROM [tbLojas] 
SET IDENTITY_INSERT [dbo].[tbMapasVistas] ON 
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (25, 25, N''Etiquetas'', N''EtiquetasA4'', N''rptEtiquetas'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, N''select * from vwartigos'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
INSERT [dbo].[tbMapasVistas] ([ID], [Ordem], [Entidade], [Descricao], [NomeMapa], [Caminho], [Certificado], [MapaXML], [IDModulo], [IDSistemaTipoDoc], [IDSistemaTipoDocFiscal], [IDLoja], [SQLQuery], [Tabela], [Geral], [Listagem], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (26, 26, N''Etiquetas'', N''EtiquetasRolo'', N''rptEtiquetasRolo'', N''\Reporting\Reports\Oticas\DocumentosVendas\'', 0, NULL, NULL, NULL, NULL, @IDLoja, N''select * from vwartigos'', NULL, 0, 0, 1, 1, CAST(N''2017-01-31 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2017-01-17 16:58:42.120'' AS DateTime), N'''')
SET IDENTITY_INSERT [dbo].[tbMapasVistas] OFF
END')


--SP Existem Documentos
EXEC('CREATE PROCEDURE [dbo].[sp_ExistemDocumentos]  
    @lngidArtigo AS bigint = 0,
    @lngidTipoArtigo AS bigint = 0
AS  BEGIN
SET NOCOUNT ON
DECLARE @ErrorMessage AS varchar(2000),
        @ErrorSeverity AS tinyint,
        @ErrorState AS tinyint,
        @blnResultado bit
BEGIN TRY
        SET @blnResultado = 0
        
        --TIPO DE ARTIGO
        if @lngidTipoArtigo <> 0 
            BEGIN               
                 --Documentos Vendas Linhas
                if Exists(SELECT TOP 1 docC.IDArtigo FROM tbDocumentosVendasLinhas as docC with(nolock) INNER JOIN tbArtigos as Art  with(nolock) ON Art.ID = docC.IDArtigo WHERE Art.IDTipoArtigo = @lngidTipoArtigo)
                BEGIN 
                    SET @blnResultado = 1
                    SELECT @blnResultado
                    Return 
                END
                 --Documentos Stock Linhas
                if Exists(SELECT TOP 1 docS.IDArtigo FROM tbDocumentosStockLinhas as docS with(nolock) INNER JOIN tbArtigos as Art  with(nolock) ON Art.ID = docS.IDArtigo WHERE Art.IDTipoArtigo = @lngidTipoArtigo)
                BEGIN 
                    SET @blnResultado = 1
                    SELECT @blnResultado
                    Return 
                END
                 --Documentos Compras Linhas
                if Exists(SELECT TOP 1 docC.IDArtigo FROM tbDocumentosComprasLinhas as docC with(nolock) INNER JOIN tbArtigos as Art  with(nolock) ON Art.ID = docC.IDArtigo WHERE Art.IDTipoArtigo = @lngidTipoArtigo)
                BEGIN 
                    SET @blnResultado = 1
                    SELECT @blnResultado
                    Return 
                END
            END
        else
        --ARTIGO
           BEGIN                   
                --Documentos Vendas
                if Exists(SELECT TOP 1 IDArtigo FROM tbDocumentosVendasLinhas with(nolock) WHERE IDArtigo = @lngidArtigo)
                BEGIN 
                    SET @blnResultado = 1
                    SELECT @blnResultado
                    Return 
                END                     
                --Documentos Stock
                if Exists(SELECT TOP 1 IDArtigo FROM tbDocumentosStockLinhas with(nolock) WHERE IDArtigo = @lngidArtigo)
                BEGIN 
                    SET @blnResultado = 1
                    SELECT @blnResultado
                    Return 
                END                     
                --Documentos Compras
                if Exists(SELECT TOP 1 IDArtigo FROM tbDocumentosComprasLinhas with(nolock) WHERE IDArtigo = @lngidArtigo)
                BEGIN 
                    SET @blnResultado = 1
                    SELECT @blnResultado
                    Return 
                END                   
                
           END
    SELECT @blnResultado
    Return 
END TRY
BEGIN CATCH
    SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
    RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')

exec('update [F3MOGeral].dbo.tbmenus set opentype=2 where descricao= ''AberturaCaixa''')
