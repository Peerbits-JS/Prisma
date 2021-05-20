Imports F3M.Modelos.Autenticacao
Imports F3M.Areas.Historicos.Controllers
Imports Oticas.Repositorio.Historicos
Imports F3M.Repositorio.Comum
Imports F3M.Core.Business
Imports F3M.Core.Business.Documents.Models.SaleDocuments

Namespace Areas.Historicos.Controllers
    Public Class HistoricosController
        Inherits HistoricosController(Of BD.Dinamica.Aplicacao, Object, F3M.Historicos)

        Const HistoricosViewsPath As String = "~/F3M/Areas/HistoricosComum/Views/HistoricosPart/"

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioHistoricosOticas)
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        <F3MAcesso>
        Public Overrides Function IndexPorDef(inModelo As Object, Optional inPrefixoID As String = Nothing,
                                              Optional inVistaParcial As Boolean = True,
                                              Optional inInicializaHistorico As Boolean = True) As ActionResult
            Return IndexAR(RepositorioHistoricosOticas.RetornaHist(inModelo), inModelo, inPrefixoID, inVistaParcial, inInicializaHistorico)
        End Function
#End Region

#Region "ESPECIFICOS"
        ''' <summary>
        ''' Funcao que retorna o historico atualizado para os documentos de venda
        ''' ex. quando pagamos o historico tem que ser atualizado
        ''' </summary>
        ''' <param name="IDDocumentoVenda"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function RetornaHistDocsVendas(IDDocumentoVenda As Long, Optional ByVal EServico As Boolean = False) As ActionResult

            Try
                Dim HistMOD As F3M.Historicos = RepositorioHistoricosOticas.RetornaHist(IDDocumentoVenda, IIf(EServico, GetType(Oticas.DocumentosVendasServicos), GetType(Oticas.DocumentosVendas)), Nothing)

                RepositorioHistoricos.PreencheHSE(HistMOD)

                Dim novoObj As New With {
                    .ModeloHist = HistMOD,
                    .ModeloObj = New DocumentosVendas,
                    .PrefixoID = "",
                    .VistaParcial = True,
                    .InicializaHistorico = False}

                Return View(HistoricosViewsPath & "HistoricoContent.vbhtml", novoObj)
            Catch
                Throw
            End Try
        End Function

        <F3MAcesso>
        Public Function GetHistSaleDocument(saleDocumentId As Long) As ActionResult
            Try
                Dim HistMOD As F3M.Historicos = RepositorioHistoricosOticas.RetornaHist(saleDocumentId, GetType(SaleDocuments), Nothing)

                RepositorioHistoricos.PreencheHSE(HistMOD)

                Dim novoObj As New With {
                    .ModeloHist = HistMOD,
                    .ModeloObj = New DocumentosVendas,
                    .PrefixoID = "",
                    .VistaParcial = True,
                    .InicializaHistorico = False}

                Return View(HistoricosViewsPath & "HistoricoContent.vbhtml", novoObj)
            Catch
                Throw
            End Try
        End Function
#End Region
    End Class
End Namespace
