Imports Oticas.BD.Dinamica

Namespace Repositorio.Etiquetas
    Public Class RepositorioEtiquetas
        Protected Friend Function RetornaEtiquetasMOD(ByVal documentId As Long, ByVal docType As String) As Areas.Etiquetas.Models.Etiquetas
            Dim ctx As Aplicacao = Activator.CreateInstance(Of Aplicacao)
            'table name
            Dim tableName As String = "tb" & docType, tableNameLinhas = tableName & "Linhas", joinId = String.Empty
            'join id
            Select Case docType
                Case "DocumentosCompras"
                    joinId = "IDDocumentoCompra"
                Case "DocumentosStock"
                    joinId = "IDDocumentoStock"
                Case "DocumentosVendas"
                    joinId = "IDDocumentoVenda"
            End Select
            'query
            Dim query As String = String.Empty
            'props
            query = query & " SELECT "
            query = query & " CAST(1 AS BIT) as 'Selecionar', Linha.IDArtigo,  "
            query = query & " Linha.CodigoArtigo,  "
            query = query & " Linha.Descricao AS 'DescricaoArtigo',  "
            query = query & " Linha.Quantidade, "
            query = query & " Artigo.CodigoBarras,  "
            query = query & " ArtigoFornecedores.CodigoBarras AS 'CodigoBarrasFornecedor', "
            query = query & " Fornecedor.Codigo, "
            query = query & " ISNULL(ArtigoPrecosPV1.ValorComIva, 0) AS ValorComIva, "
            query = query & " ISNULL(ArtigoPrecosPV2.ValorComIva, 0) AS 'ValorComIva2' "
            'table
            query = query & " FROM " & tableName & " AS Documento "
            'joins
            query = query & " INNER JOIN " & tableNameLinhas & "  AS Linha ON Linha." & joinId & " = Documento.ID "
            query = query & " INNER JOIN tbArtigos AS Artigo on Artigo.ID =  Linha.IDArtigo "
            query = query & " LEFT JOIN tbArtigosFornecedores AS ArtigoFornecedores ON ArtigoFornecedores.IDArtigo = Artigo.ID AND ArtigoFornecedores.Ordem = 1 "
            query = query & " LEFT JOIN tbFornecedores AS Fornecedor ON Fornecedor.ID = ArtigoFornecedores.IDFornecedor "
            query = query & " LEFT JOIN tbArtigosPrecos AS ArtigoPrecosPV1 ON ArtigoPrecosPV1.IDArtigo = Artigo.ID AND ArtigoPrecosPV1.IDCodigoPreco = 1 "
            query = query & " LEFT JOIN tbArtigosPrecos AS ArtigoPrecosPV2 ON ArtigoPrecosPV2.IDArtigo = Artigo.ID AND ArtigoPrecosPV2.IDCodigoPreco = 2 "
            'where
            query = query & " WHERE Documento.ID = " & documentId

            Return New Areas.Etiquetas.Models.Etiquetas With {.EtiquetasArtigos = ctx.Database.SqlQuery(Of Areas.Etiquetas.Models.EtiquetasArtigos)(query).ToList()}
        End Function
    End Class
End Namespace