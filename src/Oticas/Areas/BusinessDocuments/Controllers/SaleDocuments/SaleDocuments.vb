Imports Oticas.BD.Dinamica
Imports Oticas.Repositorio.BusinessDocuments
Imports F3M.Core.Business.Documents.Models.SaleDocuments
Imports F3M.Sale.Documents.Services.Interfaces
Imports F3M.Core.Business.Documents.Models.Documents
Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Core.Business.Documents.Models

Namespace Areas.BusinessDocuments.Controllers
    Public Class SaleDocumentsController
        Inherits F3M.Core.Business.Documents.Controllers.SaleDocuments.SaleDocumentsController(Of Aplicacao, Object, SaleDocuments)
        ReadOnly _saleDocumentsService As ISaleDocumentsService

        ReadOnly _repositorioDocumentosVendas As SaleDocumentsRepository
        ReadOnly _repositorioPagamentosVendas As RepositorioPagamentosVendas

        Public Sub New(saleDocumentsService As ISaleDocumentsService)
            MyBase.New(saleDocumentsService)

            _repositorioDocumentosVendas = New SaleDocumentsRepository()
            _repositorioPagamentosVendas = New RepositorioPagamentosVendas
        End Sub

        Public Overrides Sub At(modelo As ConnectionModel)
            _repositorioDocumentosVendas.Assina(modelo.ID)
        End Sub

        Public Overrides Sub Pay(modelo As SaleDocumentCrud, pendingDocumentId As Long, currencyId As Long?, document As String)
            Dim model As Oticas.PagamentosVendas = Map(modelo.Payment, document)

            _repositorioPagamentosVendas.Calcula(New F3M.Modelos.Comunicacao.ClsF3MFiltro, model, 2)
            _repositorioPagamentosVendas.AdicionaPagamento_FROMDOCSVENDAS(repositorio.BDContexto, model, currencyId, model.ID, pendingDocumentId)
        End Sub

        Private Function Map(model As Payments.Payments, document As String) As Oticas.PagamentosVendas
            Dim result As New Oticas.PagamentosVendas With {.IDContaCaixa = model.IDContaCaixa}

            result.ListOfFormasPagamento = New List(Of PagamentosVendasFormasPagamento)
            For Each paymentMethod In model.PaymentMethods
                result.ListOfFormasPagamento.Add(New PagamentosVendasFormasPagamento With {.IDFormaPagamento = paymentMethod.Id, .Valor = paymentMethod.Total})
            Next

            result.ListOfPendentes = New List(Of DocumentosVendasPendentes)
            For Each documentToPay In model.DocumentsToPay
                result.ListOfPendentes.Add(New DocumentosVendasPendentes With {
                                           .ID = documentToPay.Id,
                                           .IDTipoDocumento = documentToPay.DocumentTypeId,
                                           .IDTiposDocumentoSeries = documentToPay.DocumentTypeSeriesId,
                                           .IDEntidade = documentToPay.CustomerId,
                                           .LinhaSelecionada = documentToPay.IsSelected,
                                           .IDDocumentoVenda = documentToPay.DocumentId,
                                           .Documento = document,
                                           .IDTipoEntidade = documentToPay.CustomerId,
                                           .DataDocumento = documentToPay.DocumentDate,
                                           .DataVencimento = documentToPay.DueDate,
                                           .CodigoSistemaNaturezas = documentToPay.SystemCodeNatureType,
                                           .ValorPago = documentToPay.ValueToPay,
                                           .TotalMoedaDocumento = documentToPay.TotalValue,
                                           .ValorPendente = documentToPay.PendingValue,
                                           .ValorPendenteAux = documentToPay.PendingValue})
            Next

            Return result
        End Function
    End Class
End Namespace
