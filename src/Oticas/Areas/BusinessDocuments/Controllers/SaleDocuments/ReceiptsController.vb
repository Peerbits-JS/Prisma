Imports F3M.Sale.Documents.Services.DTO
Imports F3M.Sale.Documents.Services.Interfaces
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.BusinessDocuments.Controllers
    <Authorize>
    Public Class ReceiptsController
        Inherits F3M.Core.Business.Documents.Controllers.SaleDocuments.ReceitpsController

        ReadOnly _repositorioPagamentosVendas As RepositorioPagamentosVendas

        Public Sub New(receiptsService As IReceiptsService)
            MyBase.New(receiptsService)

            _repositorioPagamentosVendas = New RepositorioPagamentosVendas()
        End Sub

        Public Overrides Function HasPayments(documentSaleId As Long) As JsonResult
            Return RetornaJSONTamMaximo(_repositorioPagamentosVendas.GetPagamentosVendas(documentSaleId).Any())
        End Function

        Public Overrides Function GetPayments(documentSaleId As Long) As List(Of PaymentsDto)
            Return _repositorioPagamentosVendas.GetPagamentosVendas(documentSaleId).
                Select(Function(payment) New PaymentsDto With {
                .Id = payment.ID,
                .Document = payment.Documento,
                .[Date] = payment.Data,
                .IsAborted = payment.CodigoTipoEstado = "ANL",
                .Delivered = payment.ValorEntregue,
                .Returned = payment.Troco}).
                ToList()
        End Function

        Public Overrides Function GetDocuments(paymentId As Long) As List(Of PaymentDocumentDto)
            Return _repositorioPagamentosVendas.
                GetPagamentosVendasLinhas(paymentId).
                Select(Function(x) New PaymentDocumentDto With {
                .Document = x.Documento,
                .Customer = x.NomeFiscal,
                .DocumentDate = x.DataDocumento,
                .DueDate = x.DataVencimento,
                .TotalValue = x.ValorPago,
                .PendingValue = x.ValorPendente,
                .ValueToPay = x.ValorPago,
                .DebitCredit = x.DescricaoSistemaNaturezas}).
                ToList()
        End Function

        Public Overrides Function GetPaymentMethods(paymentId As Long) As List(Of PaymentMethodsDto)
            Return _repositorioPagamentosVendas.
                GetFormasPagamento(paymentId).
                Select(Function(x) New PaymentMethodsDto With {
                .Id = x.IDFormaPagamento,
                .Code = x.CodigoSistemaTipoFormaPagamento,
                .Description = x.DescricaoFormaPagamento,
                .Total = x.Valor.ToString("0.00")}).ToList()
        End Function

        Public Overrides Function GetDocumentReceiptId(paymentId As Long) As Long?
            Return _repositorioPagamentosVendas.GetPagamentoVenda(paymentId).Recibo?.ID
        End Function

        Public Overrides Function CanCancelPayment(paymentId As Long) As JsonResult
            If _repositorioPagamentosVendas.VerificaPagEstadoEfetivo(paymentId) Then

                If _repositorioPagamentosVendas.IsNCDA(paymentId) Then
                    Dim docParaAnular As String = _repositorioPagamentosVendas.GetPagamentosParaAnularByNCDA(paymentId).Documento
                    Return New JsonResult() With {.Data = New With {.Errors = "Esta nota de crédito está a ser utilizada no documento " + docParaAnular + ".", .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                End If

                If Not _repositorioPagamentosVendas.IsFA(paymentId) AndAlso _repositorioPagamentosVendas.VerificaPagamentosLinhasNCDA(paymentId) AndAlso _repositorioPagamentosVendas.HasNCDA(paymentId) Then
                    Dim msg As String = "<div>Esta operação é irreversível.<p>O documento e a respectiva nota de crédito serão anulados.</p><p> Prentende continuar?</p></div>"
                    Return New JsonResult() With {.Data = New With {.WarningMessage = msg}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                End If

                If Not _repositorioPagamentosVendas.ValidaDiasParaAnular(paymentId) Then
                    Return New JsonResult() With {.Data = New With {.Errors = "O número de dias após os quais se pode anular um documento é superior ao definido nos parâmetros da empresa.", .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                End If

                If _repositorioPagamentosVendas.VerificaFAnaNA(paymentId) Then
                    Dim PagamentoVenda As Oticas.PagamentosVendas = _repositorioPagamentosVendas.VerificaSE_NA(paymentId)

                    If Not PagamentoVenda Is Nothing Then
                        Dim strDocumentos As String = String.Join(", ", (From x In PagamentoVenda.ListOfPendentes Select x.Documento).ToList())

                        Dim strWarningMessage = Traducao.EstruturaErros.OperacaoIrreversivelPretendeContinuar.Replace("{0}", strDocumentos)

                        Return New JsonResult() With {.Data = New With {.WarningMessage = strWarningMessage}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}

                    Else
                        Return New JsonResult() With {.Data = New With {.WarningMessage = Traducao.Cliente.valida_estado}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                    End If

                Else
                    Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.FAUtilizadaNaNA, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                End If

            Else
                Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.NaoPodeSerAnulado, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
            End If

            Return RetornaJSONTamMaximo(True)
        End Function

        Public Overrides Function CancelPayment(paymentId As Long) As JsonResult
            If _repositorioPagamentosVendas.VerificaPagEstadoEfetivo(paymentId) Then
                _repositorioPagamentosVendas.Anula(paymentId)

            Else
                Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.NaoPodeSerAnulado, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
            End If

            Return RetornaJSONTamMaximo(True)
        End Function
    End Class
End Namespace