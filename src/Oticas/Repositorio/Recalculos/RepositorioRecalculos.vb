Imports System.Data.Entity
Imports System.Data.SqlClient
Imports System.Reflection
Imports F3M
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.BaseDados
Imports F3M.Modelos.Constantes

Namespace Repositorio.Recalculos
    Public Class RepositorioRecalculos
        Inherits F3M.Repositorio.Recalculos.RepositorioRecalculos

#Region "RECALCULO DE STOCKS"
        Public Overrides Function RetornaArtigosMarcados(ctx As DbContext) As List(Of F3M.RecalculoStocksArtigos)
            'new list of RecalculoStocksArtigos
            Dim lstRecalculoStocksArtigos As New List(Of F3M.RecalculoStocksArtigos)
            'get artigos marcados na tbCCStockArtigos
            lstRecalculoStocksArtigos.AddRange(RetornaArtigosMarcadosCCStockArtigos(ctx))
            'get artigos marcados na tbArtigos
            lstRecalculoStocksArtigos.AddRange(RetornaArtigosMarcadosTbArtigos(ctx))
            'order by id
            Dim funcOrder As Func(Of F3M.RecalculoStocksArtigos, Long) = Function(o)
                                                                             Return CObj(o).IDArtigo
                                                                         End Function

            Return (From x In
                        (From t In lstRecalculoStocksArtigos.OrderBy(funcOrder)
                         Group By t.IDArtigo Into Group
                         Select Group.Distinct()).ToList()
                    Select New F3M.RecalculoStocksArtigos With {
                        .Selecionar = True,
                        .IDArtigo = x.FirstOrDefault.IDArtigo,
                        .CodigoArtigo = x.FirstOrDefault.CodigoArtigo,
                        .DescricaoArtigo = x.FirstOrDefault.DescricaoArtigo,
                        .RetificaPreco = True}).ToList()
        End Function

        Private Function RetornaArtigosMarcadosCCStockArtigos(ctx As DbContext) As List(Of RecalculoStocksArtigos)
            Return ctx.Set(Of tbCCStockArtigos).
                Where(Function(w) w.Recalcular).
                Select(Function(s) New RecalculoStocksArtigos With {
                .Selecionar = True,
                .IDArtigo = s.IDArtigo, .CodigoArtigo = s.tbArtigos.Codigo, .DescricaoArtigo = s.Descricao}).ToList()
        End Function

        Private Function RetornaArtigosMarcadosTbArtigos(ctx As DbContext) As List(Of RecalculoStocksArtigos)
            Return ctx.Set(Of tbArtigos).
                Where(Function(w) w.RecalculaUPC).
                Select(Function(s) New RecalculoStocksArtigos With {
                .Selecionar = True,
                .IDArtigo = s.ID, .CodigoArtigo = s.Codigo, .DescricaoArtigo = s.Descricao}).ToList()
        End Function


        Public Overrides Function RetornaDocs(ctx As DbContext) As List(Of F3M.RecalculoStocksExe)
            Dim res = New List(Of F3M.RecalculoStocksExe)

            res.AddRange(RetornaDocsVendas(ctx))
            res.AddRange(RetornaDocsCompras(ctx))
            res.AddRange(RetornaDocsStocks(ctx))

            Return res
        End Function

#End Region

#Region "FUNCOES AUXIALIARES"
        Private Function RetornaDocsVendas(ctx As DbContext) As List(Of RecalculoStocksExe)
            Dim funcSel As Func(Of tbDocumentosVendasLinhas, RecalculoStocksExe) = Function(s)
                                                                                       'instance new model
                                                                                       Dim itemRecalculoStocksExe As New RecalculoStocksExe
                                                                                       'lins props model
                                                                                       With itemRecalculoStocksExe
                                                                                           .IDDocumentoLinha = s.ID
                                                                                           .IDArtigoLinha = s.IDArtigo
                                                                                           .OrdemLinha = s.Ordem
                                                                                           .IDDocumentoOrigem = s.IDDocumentoOrigem
                                                                                           .PCMAnteriorMoedaRef = s.PCMAnteriorMoedaRef
                                                                                           .QtdStockAnterior = s.QtdStockAnterior
                                                                                           .QuantidadeStock = s.QuantidadeStock
                                                                                           '.UPCMoedaRef = s.UPCMoedaRef
                                                                                           .MovStockOrigem = s.MovStockOrigem

                                                                                           .GCE = "DocumentosVendas"
                                                                                           .IDDocumento = s.IDDocumentoVenda
                                                                                           .IDTiposDocumento = s.tbDocumentosVendas.IDTipoDocumento
                                                                                           .IDTiposDocumentoSeries = s.tbDocumentosVendas.IDTiposDocumentoSeries
                                                                                           .DataControloInterno = s.tbDocumentosVendas.DataControloInterno
                                                                                           .CustoMedio = s.tbDocumentosVendas.tbTiposDocumento.CustoMedio
                                                                                           .GereStock = s.tbDocumentosVendas.tbTiposDocumento.GereStock
                                                                                           .CodigoTipoMov = s.tbDocumentosVendas.tbTiposDocumento.tbSistemaTiposDocumentoMovStock?.Codigo
                                                                                       End With

                                                                                       Return itemRecalculoStocksExe
                                                                                   End Function

            'return item
            Return ctx.Set(Of tbDocumentosVendasLinhas).
                Where(Function(w) w.tbDocumentosVendas.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo AndAlso
                w.tbDocumentosVendas.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo <> TiposDocumentosOrigem.OutroSistema AndAlso
                (w.tbDocumentosVendas.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.VendasFinanceiro OrElse
                w.tbDocumentosVendas.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.SubstituicaoArtigos)).
                Select(funcSel).
                ToList()
        End Function

        Private Function RetornaDocsCompras(ctx As DbContext) As List(Of RecalculoStocksExe)
            Dim funcSel As Func(Of tbDocumentosComprasLinhas, RecalculoStocksExe) = Function(s)
                                                                                        'instance new model
                                                                                        Dim itemRecalculoStocksExe As New RecalculoStocksExe
                                                                                        'lins props model
                                                                                        With itemRecalculoStocksExe
                                                                                            .IDDocumentoLinha = s.ID
                                                                                            .IDArtigoLinha = s.IDArtigo
                                                                                            .OrdemLinha = s.Ordem
                                                                                            .IDDocumentoOrigem = s.IDDocumentoOrigem
                                                                                            .PCMAnteriorMoedaRef = s.PCMAnteriorMoedaRef
                                                                                            .QtdStockAnterior = s.QtdStockAnterior
                                                                                            .QuantidadeStock = s.QuantidadeStock
                                                                                            .UPCMoedaRef = s.UPCMoedaRef
                                                                                            .MovStockOrigem = s.MovStockOrigem

                                                                                            .GCE = "DocumentosCompras"
                                                                                            .IDDocumento = s.IDDocumentoCompra
                                                                                            .IDTiposDocumento = s.tbDocumentosCompras.IDTipoDocumento
                                                                                            .IDTiposDocumentoSeries = s.tbDocumentosCompras.IDTiposDocumentoSeries
                                                                                            .DataControloInterno = s.tbDocumentosCompras.DataControloInterno
                                                                                            .CustoMedio = s.tbDocumentosCompras.tbTiposDocumento.CustoMedio
                                                                                            .GereStock = s.tbDocumentosCompras.tbTiposDocumento.GereStock
                                                                                            .CodigoTipoMov = s.tbDocumentosCompras.tbTiposDocumento.tbSistemaTiposDocumentoMovStock?.Codigo
                                                                                        End With

                                                                                        Return itemRecalculoStocksExe
                                                                                    End Function

            'return item
            Return ctx.Set(Of tbDocumentosComprasLinhas).
                Where(Function(w) w.tbDocumentosCompras.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo AndAlso
                w.IDDocumentoOrigem Is Nothing AndAlso
                (w.tbDocumentosCompras.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.ComprasFinanceiro OrElse
                w.tbDocumentosCompras.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.ComprasTransporte)).
                Select(funcSel).
                ToList()
        End Function

        Private Function RetornaDocsStocks(ctx As DbContext) As List(Of RecalculoStocksExe)
            Dim funcSel As Func(Of tbDocumentosStockLinhas, RecalculoStocksExe) = Function(s)
                                                                                      'instance new model
                                                                                      Dim itemRecalculoStocksExe As New RecalculoStocksExe
                                                                                      'lins props model
                                                                                      With itemRecalculoStocksExe
                                                                                          .IDDocumentoLinha = s.ID
                                                                                          .IDArtigoLinha = s.IDArtigo
                                                                                          .OrdemLinha = s.Ordem
                                                                                          .IDDocumentoOrigem = s.IDDocumentoOrigem
                                                                                          .PCMAnteriorMoedaRef = s.PCMAnteriorMoedaRef
                                                                                          .QtdStockAnterior = s.QtdStockAnterior
                                                                                          .QuantidadeStock = s.QuantidadeStock
                                                                                          .UPCMoedaRef = s.UPCMoedaRef
                                                                                          .MovStockOrigem = s.MovStockOrigem

                                                                                          .GCE = "DocumentosStock"
                                                                                          .IDDocumento = s.IDDocumentoStock
                                                                                          .IDTiposDocumento = s.tbDocumentosStock.IDTipoDocumento
                                                                                          .IDTiposDocumentoSeries = s.tbDocumentosStock.IDTiposDocumentoSeries
                                                                                          .DataControloInterno = s.tbDocumentosStock.DataControloInterno
                                                                                          .CustoMedio = s.tbDocumentosStock.tbTiposDocumento.CustoMedio
                                                                                          .GereStock = s.tbDocumentosStock.tbTiposDocumento.GereStock
                                                                                          .CodigoTipoMov = s.tbDocumentosStock.tbTiposDocumento.tbSistemaTiposDocumentoMovStock?.Codigo
                                                                                      End With

                                                                                      Return itemRecalculoStocksExe
                                                                                  End Function

            'return item
            Return ctx.Set(Of tbDocumentosStockLinhas).
                Where(Function(w) w.tbDocumentosStock.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo).
                Select(funcSel).
                ToList()
        End Function

        Public Overrides Function RetornaArtigosTodos(ctx As DbContext) As List(Of RecalculoStocksArtigos)
            Return ctx.Set(Of tbArtigos).Select(Function(s) New RecalculoStocksArtigos With {.Selecionar = True, .IDArtigo = s.ID}).Distinct().ToList()
        End Function

        Public Overrides Sub InsertInto_tbF3MRecalculos(ctx As DbContext, model As List(Of RecalculoStocksArtigos), timestamp As Long, nomeUtilizador As String)
            Dim lst As List(Of tbF3MRecalculo) = model.
                Select(Function(s) New tbF3MRecalculo With {
                        .IDArtigo = s.IDArtigo,
                        .IDRecalculo = timestamp,
                        .Ativo = True,
                        .Sistema = True,
                        .DataCriacao = DateAndTime.Now,
                        .UtilizadorCriacao = nomeUtilizador}).ToList()
            ' .MarcadoRetificaPreco = s.RetificaPreco, ' TODO : QUANDO ALTERARMOS OS SP'S COLOCAR O CAMPO

            Dim strConnection As String = ctx.Database.Connection.ConnectionString
            Using conn As New SqlConnection(strConnection)
                conn.Open()
                Dim trans As SqlTransaction = conn.BeginTransaction

                Dim dtTable As New DataTable
                dtTable = ClsBaseDados.CreateDataTable(lst)

                Using sqlBulkCopy As New SqlBulkCopy(conn, SqlBulkCopyOptions.Default, trans)
                    sqlBulkCopy.DestinationTableName = "tbF3MRecalculo"
                    sqlBulkCopy.WriteToServer(dtTable)
                End Using

                trans.Commit()
                conn.Close()
            End Using
        End Sub
#End Region
    End Class
End Namespace