Imports F3M.Core.Business.Documents.Models.Documents
Imports F3M.Purchase.Documents.Services.Services.Interfaces
Imports Oticas.BD.Dinamica
Imports Oticas.Repositorio.BusinessDocuments

Namespace Areas.BusinessDocuments.Controllers
    Public Class PurchaseDocumentsController
        Inherits F3M.Core.Business.Documents.Controllers.PurchaseDocuments.PurchaseDocumentsController(Of Aplicacao, Object, F3M.Core.Business.Documents.Models.PurchaseDocuments.PurchaseDocuments)
        ReadOnly _purchaseDocumentsService As IPurchaseDocumentsService

        ReadOnly _repositorioDocumentosCompras As PurchaseDocumentsRepository

        Public Sub New(purchaseDocumentsService As IPurchaseDocumentsService)
            MyBase.New(purchaseDocumentsService)

            _repositorioDocumentosCompras = New PurchaseDocumentsRepository()
        End Sub


        Public Overrides Sub At(modelo As ConnectionModel)
            _repositorioDocumentosCompras.Assina(modelo.ID)
        End Sub

    End Class
End Namespace
