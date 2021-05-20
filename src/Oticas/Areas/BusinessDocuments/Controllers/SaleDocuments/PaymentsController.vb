Imports F3M.Core.Business.Documents.Models.Payments
Imports F3M.Modelos.Comunicacao
Imports F3M.Sale.Documents.Services.DTO
Imports F3M.Sale.Documents.Services.Interfaces
Imports Oticas.Repositorio.Documentos
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.BusinessDocuments.Controllers
    <Authorize>
    Public Class PaymentsController
        Inherits F3M.Core.Business.Documents.Controllers.SaleDocuments.PaymentsController

        ReadOnly _repositorioDocumentosVendasPendentes As RepositorioDocumentosVendasPendentes
        ReadOnly _repositorioPagamentosVendas As RepositorioPagamentosVendas
        ReadOnly _repositorioDocumentosVendas As RepositorioDocumentosVendas

        Public Sub New(paymentsService As IPaymentsService)
            MyBase.New(paymentsService)

            _repositorioDocumentosVendasPendentes = New RepositorioDocumentosVendasPendentes
            _repositorioPagamentosVendas = New RepositorioPagamentosVendas
            _repositorioDocumentosVendas = New RepositorioDocumentosVendas
        End Sub

        Public Overrides Function HasPendingDocuments(documentSaleId As Long, entityId As Long, currencyId As Long) As JsonResult
            If _repositorioDocumentosVendas.EDocumentoAnulado(documentSaleId) Then
                Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaAplicacaoTermosBase.DocAnulado, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}

            ElseIf _repositorioDocumentosVendas.EDocumentoRascunho(documentSaleId) Then
                Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaAplicacaoTermosBase.DocRascunho, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}

            ElseIf Not _repositorioDocumentosVendas.VerificaValorPago(documentSaleId) Then
                Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaAplicacaoTermosBase.DocPago, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
            End If

            Dim blnResult = If(_repositorioDocumentosVendasPendentes.GetDocumentosVendasPendentes(documentSaleId, entityId, currencyId).Count > 0, True, False)
            If Not blnResult Then
                Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaAplicacaoTermosBase.DocNaoFinanceiro, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
            End If

            Return RetornaJSONTamMaximo(True)

        End Function

        Public Overrides Function GetDocumentsToPay(documentSaleId As Long, customerId As Long?, currencyId As Long?) As List(Of PaymentDocumentDto)
            Dim documents As List(Of PaymentDocumentDto) = _repositorioDocumentosVendasPendentes.
                GetDocumentosVendasPendentes(documentSaleId, customerId, currencyId).
                Select(Function(entity) New PaymentDocumentDto With {
                .Id = entity.ID,
                .DocumentId = entity.IDDocumentoVenda,
                .Document = entity.Documento,
                .DocumentTypeId = entity.IDTipoDocumento,
                .DocumentTypeSeriesId = entity.IDTiposDocumentoSeries,
                .CustomerId = entity.IDEntidade,
                .Customer = entity.NomeFiscal,
                .DocumentDate = entity.DataDocumento,
                .DueDate = entity.DataVencimento,
                .TotalValue = entity.TotalMoedaDocumento,
                .PendingValue = entity.ValorPendente,
                .DebitCredit = entity.DescricaoSistemaNaturezas,
                .SystemCodeNatureType = entity.CodigoSistemaNaturezas,
                .GereContaCorrente = entity.GereContaCorrente,
                .GereCaixaEBancos = entity.GereCaixasBancos}).
                ToList()

            With documents(0)
                .IsSelected = True
                .ValueToPay = .PendingValue
            End With

            Return documents
        End Function

        Public Overrides Function GetPaymentMethods(paymentId As Long) As List(Of PaymentMethodsDto)
            Return _repositorioPagamentosVendas.
                GetFormasPagamento(paymentId).
                Select(Function(entity) New PaymentMethodsDto With {
                    .Id = entity.IDFormaPagamento,
                    .Code = entity.CodigoSistemaTipoFormaPagamento,
                    .Description = entity.DescricaoFormaPagamento,
                    .PaymentMethodSystemCode = entity.CodigoSistemaTipoFormaPagamento
                }).
            ToList()
        End Function

        Public Overrides Sub SetDefaultBox(payment As Payments)
            _repositorioPagamentosVendas.SetDefaultBox(payment)
            payment.CanEditBox = _repositorioPagamentosVendas.UtilizadorPodeAlterarCaixa()
        End Sub

        Public Overrides Function Pay(objFilter As ClsF3MFiltro, model As Payments) As JsonResult
            Try
                Dim modelo As Oticas.PagamentosVendas = Map(model)

                If Not modelo.IDContaCaixa > 0 Then
                    Throw New Exception(OticasTraducao.Estrutura.ObrigatorioSelecionarCaixa)
                End If

                ' VALIDA SE A CAIXA ESTA ABERTA
                Using mc As New RepositorioMapaCaixa
                    If Not mc.CaixaAberta(Date.Now(), modelo.IDContaCaixa) Then
                        Throw New Exception(OticasTraducao.Estrutura.CaixaNaoEstaAberta)
                    End If
                End Using

                If Not modelo.ListOfPendentes Is Nothing AndAlso modelo.ListOfPendentes.Where(Function(f) f.LinhaSelecionada).Count <> 0 Then
                    _repositorioPagamentosVendas.Calcula(objFilter, modelo)

                    'VALIDACOES
                    If modelo.TotalPagar > modelo.ValorEntregue Then
                        Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.ValorEntregueNaoInferiorValorAPagar, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                    End If

                    If Not ValidaValorCredDeb(modelo) Then
                        Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.ValorCredsMaiorDebs, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                    End If

                    Using rp As New RepositorioPagamentosVendas
                        If Not rp.isValid(modelo, objFilter) Then
                            Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.ValorPendenteAlteradoInfoAtualizada, .TipoAlerta = "i", .isValid = "false"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                        End If

                        If Not rp.isLinhasValidas(modelo, objFilter) Then
                            Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.SelectionarPeloMenos1Doc, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                        End If
                    End Using
                    'END 'VALIDACOES

                    Using rp As New RepositorioPagamentosVendas
                        rp.AdicionaObj(modelo, objFilter)
                    End Using

                    Dim id As Nullable(Of Long) = modelo.IDRecibo

                    Return New JsonResult() With {.Data = New With {.isValid = True, .ID = id}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}

                Else
                    Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.SelectionarPeloMenos1Doc, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                End If

            Catch ex As Exception
                Return New JsonResult() With {.Data = New With {.Errors = ex.Message, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
            End Try
        End Function

        Private Function Map(model As Payments) As Oticas.PagamentosVendas
            Dim result As New Oticas.PagamentosVendas With {.IDContaCaixa = model.IDContaCaixa, .IDEntidade = model.DocumentsToPay(0).CustomerId}

            result.ListOfFormasPagamento = New List(Of PagamentosVendasFormasPagamento)
            For Each paymentMethod In model.PaymentMethods
                result.ListOfFormasPagamento.Add(New PagamentosVendasFormasPagamento With {
                                                 .IDFormaPagamento = paymentMethod.Id, .Valor = paymentMethod.Total
                                                 })
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
                                           .Documento = documentToPay.Document,
                                           .IDTipoEntidade = documentToPay.CustomerId,
                                           .DataDocumento = documentToPay.DocumentDate,
                                           .DataVencimento = documentToPay.DueDate,
                                           .CodigoSistemaNaturezas = documentToPay.SystemCodeNatureType,
                                           .ValorPago = documentToPay.ValueToPay,
                                           .TotalMoedaDocumento = documentToPay.TotalValue,
                                           .ValorPendente = documentToPay.PendingValue,
                                           .ValorPendenteAux = documentToPay.PendingValue,
                                           .GereContaCorrente = documentToPay.GereContaCorrente,
                                           .GereCaixasBancos = documentToPay.GereCaixaEBancos})
            Next

            Return result
        End Function

        Public Overrides Function ValidateFromSaleDocument(objFilter As ClsF3MFiltro, model As Payments) As JsonResult
            Dim modelo As Oticas.PagamentosVendas = Map(model)


            If Not modelo.IDContaCaixa > 0 Then
                Throw New Exception(OticasTraducao.Estrutura.ObrigatorioSelecionarCaixa)
            End If

            ' VALIDA SE A CAIXA ESTA ABERTA
            Using mc As New RepositorioMapaCaixa
                If Not mc.CaixaAberta(Date.Now(), modelo.IDContaCaixa) Then
                    Throw New Exception(OticasTraducao.Estrutura.CaixaNaoEstaAberta)
                End If
            End Using

            If Not modelo.ListOfPendentes Is Nothing AndAlso modelo.ListOfPendentes.Where(Function(f) f.LinhaSelecionada).Count <> 0 Then

                _repositorioPagamentosVendas.Calcula(objFilter, modelo)

                If modelo.TotalPagar > modelo.ValorEntregue Then
                    Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.ValorEntregueNaoInferiorValorAPagar, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                End If

                Return New JsonResult() With {.Data = New With {.isValid = True}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
            Else
                Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.SelectionarPeloMenos1Doc, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
            End If
        End Function


        Private Function ValidaValorCredDeb(ByVal inModelo As Oticas.PagamentosVendas) As Boolean
            Dim dblSumDeb As Double = (From x In inModelo.ListOfPendentes
                                       Where x.LinhaSelecionada = True And x.CodigoSistemaNaturezas = "R"
                                       Select x.ValorPago).Sum()

            Dim dblSumCred As Double = (From x In inModelo.ListOfPendentes
                                        Where x.LinhaSelecionada = True And x.CodigoSistemaNaturezas = "P"
                                        Select x.ValorPago).Sum()

            Return dblSumDeb >= dblSumCred
        End Function
    End Class
End Namespace