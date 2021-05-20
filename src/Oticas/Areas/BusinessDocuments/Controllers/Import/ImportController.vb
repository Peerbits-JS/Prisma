Imports Kendo.Mvc.UI
Imports Oticas.Repositorio.BusinessDocuments

Namespace Areas.BusinessDocuments.Controllers
    <Authorize>
    Public Class ImportController
        Inherits F3M.Core.Business.Documents.Controllers.ImportController

        ReadOnly _purchaseDocumentsRepository As PurchaseDocumentsRepository
        ReadOnly _saleDocumentsRepository As SaleDocumentsRepository

        Sub New()
            _purchaseDocumentsRepository = New PurchaseDocumentsRepository()
            _saleDocumentsRepository = New SaleDocumentsRepository()
        End Sub

        <HttpPost>
        Public Function GetDocumentsToImport(req As DataSourceRequest, documentId As Long, feature As String) As JsonResult
            Try
                Dim result = Nothing

                Select Case feature
                    Case "PurchaseDocuments"
                        result = _purchaseDocumentsRepository.GetDocumentsToImport(req, documentId)
                    Case "SaleDocuments"
                        result = _saleDocumentsRepository.GetDocumentsToImport(req, documentId)
                End Select

                Return RetornaJSONTamMaximo(result)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <HttpPost>
        Public Function GetDocumentLinesToImport(req As DataSourceRequest, documentId As Long, selectedDocs As Long(), feature As String) As JsonResult
            Try
                Dim result = Nothing

                Select Case feature
                    Case "PurchaseDocuments"
                        result = _purchaseDocumentsRepository.GetDocumentLinesToImport(req, documentId, selectedDocs)
                    Case "SaleDocuments"
                        result = _saleDocumentsRepository.GetDocumentLinesToImport(req, documentId, selectedDocs)
                End Select

                Return RetornaJSONTamMaximo(result)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function
    End Class
End Namespace