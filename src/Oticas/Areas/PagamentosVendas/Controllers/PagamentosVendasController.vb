Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Utilitarios
Imports Oticas.Repositorio.Documentos
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.PagamentosVendas.Controllers
    Public Class PagamentosVendasController
        Inherits SimpleFormController

        Private Const Numerario As String = "NU"
        Private Const Opcao_Pagamentos As String = "pagamentos"

        ReadOnly _repositorioDocumentosVendasServicos As RepositorioDocumentosVendasServicos

        Sub New()
            _repositorioDocumentosVendasServicos = New RepositorioDocumentosVendasServicos()
        End Sub

        <F3MAcesso>
        Public Function Index(Optional ByVal IDEntidade As Long = 0, Optional ByVal IDDocumentoVenda As Long = 0, Optional ByVal IDDocumentoVendaServico As Long = 0,
                              Optional ByVal IDMoeda As Long = 0, Optional ByVal Opcao As String = "") As ActionResult
            Dim pagamento As New Oticas.PagamentosVendas

            ViewBag.Opcao = Opcao

            If Opcao = "adiantamentos" Then
                If (_repositorioDocumentosVendasServicos.BlnExistemDocsAssociados(IDDocumentoVenda)) Then
                    ViewBag.Opcao = "pagamentos"
                End If
            End If

            Using repM As New RepositorioMoedas
                ViewBag.Moeda = repM.RetornaMoeda(IDMoeda)
            End Using

            Using repPagamentos As New RepositorioPagamentosVendas
                Dim lstPagamentos As New List(Of Oticas.PagamentosVendas)

                'R E C E B I M E N T O S
                If IDDocumentoVenda <> 0 Then
                    lstPagamentos = repPagamentos.GetPagamentosVendas(IDDocumentoVenda)
                End If

                'R E C E B I M E N T O S   F R O M   S E R V I Ç O S
                If IDDocumentoVendaServico <> 0 Then
                    lstPagamentos = repPagamentos.GetPagamentosVendasServicos(IDDocumentoVendaServico)
                End If

                ViewBag.ListOfPagamentos = lstPagamentos

                'If IDDocumentoVenda <> 0 OrElse IDDocumentoVendaServico <> 0 Then
                '    Dim pagamentoExistente = lstPagamentos.FirstOrDefault()

                '    If pagamentoExistente IsNot Nothing Then
                '        pagamento.IDContaCaixa = pagamentoExistente.IDContaCaixa
                '        pagamento.DescricaoContaCaixa = pagamentoExistente.DescricaoContaCaixa
                '    End If
                'Else
                pagamento.PermiteEditarCaixa = repPagamentos.UtilizadorPodeAlterarCaixa()
                repPagamentos.PreencheCaixaPorDefeito(pagamento)
                'End If
            End Using

            Using rp As New RepositorioDocumentosVendas
                ViewBag.IDTipoDocumentoServico = rp.GetIDTipoDocumentoServico()
            End Using

            Return View(pagamento)
        End Function

        <F3MAcesso>
        Public Function PreencheModelo_Pagamentos(inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim IDDocumentoVenda As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDDocumentoVenda", GetType(Long))
                Dim IDEntidade As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDEntidade", GetType(Long))
                Dim CasasDecimaisTotais As Byte = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "CasasDecimaisTotais", GetType(Byte))
                Dim IDMoeda As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDMoeda", GetType(Long))
                Dim result As New Oticas.PagamentosVendas With {.IDEntidade = IDEntidade}

                Using rp As New RepositorioDocumentosVendasPendentes
                    result.ListOfPendentes = rp.GetDocumentosVendasPendentes(IDDocumentoVenda, IDEntidade, IDMoeda)
                End Using

                Dim dblSaldo As Double = 0
                For Each lin In result.ListOfPendentes
                    If lin.CodigoSistemaNaturezas = "P" Then
                        dblSaldo = Math.Round(dblSaldo - lin.ValorPendente, CasasDecimaisTotais)

                    ElseIf lin.CodigoSistemaNaturezas = "R" Then
                        dblSaldo = Math.Round(dblSaldo + lin.ValorPendente, CasasDecimaisTotais)
                    End If
                Next

                result.Saldo = dblSaldo

                Return RetornaJSONTamMaximo(result)

            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function PreencheModelo_Adiantamentos(inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim ID As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDDocumentoVenda", GetType(Long))
                Dim IDEntidade As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDEntidade", GetType(Long))
                Dim result As New Oticas.PagamentosVendas With {
                    .ListOfPendentes = New List(Of DocumentosVendasPendentes),
                    .IDEntidade = IDEntidade
                }

                Using rp As New RepositorioDocumentosVendasServicos
                    Dim DocumentoVendaPendente As New DocumentosVendasPendentes
                    DocumentoVendaPendente = rp.GetDocumentoVendaPendenteWithTransaction(ID)
                    result.ListOfPendentes.Add(DocumentoVendaPendente)
                End Using

                Return RetornaJSONTamMaximo(result)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function PreencheModelo_FROMDOCSVENDAS(inModel As DocumentosVendas, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim IDEntidade As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDEntidade", GetType(Long))
                Dim result As New Oticas.PagamentosVendas With {
                    .ListOfPendentes = New List(Of DocumentosVendasPendentes),
                    .IDEntidade = IDEntidade
                }

                Using rp As New RepositorioDocumentosVendasServicos
                    Dim DocumentoVendaPendente As New DocumentosVendasPendentes

                    With DocumentoVendaPendente
                        .Documento = inModel.Documento
                        .NomeFiscal = inModel.NomeFiscal
                        .DataDocumento = inModel.DataDocumento
                        .DataVencimento = DateAndTime.Now()
                        .TotalMoedaDocumento = inModel.TotalMoedaDocumento
                        .ValorPendente = .TotalMoedaDocumento
                        .ValorPendenteAux = .ValorPendente
                        .ValorPago = .ValorPendente
                        .CodigoSistemaNaturezas = TiposNaturezas.Debito  'R
                        .DescricaoSistemaNaturezas = If(inModel.TipoFiscal = TiposDocumentosFiscal.NotaCredito, TiposNaturezas.Cred, TiposNaturezas.Deb)
                        .GereContaCorrente = False
                    End With

                    result.ListOfPendentes.Add(DocumentoVendaPendente)
                End Using

                Return RetornaJSONTamMaximo(result)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function


        <F3MAcesso>
        Public Function Calcula(inObjetoFiltro As ClsF3MFiltro, inModelo As Oticas.PagamentosVendas) As JsonResult
            Try
                Using rp As New RepositorioPagamentosVendas
                    rp.Calcula(inObjetoFiltro, inModelo)
                End Using

                Return RetornaJSONTamMaximo(inModelo)
            Catch ex As Exception
                Throw
            End Try
        End Function

        <F3MAcesso>
        Public Function GravaLinhas(inObjetoFiltro As ClsF3MFiltro, modelo As Oticas.PagamentosVendas) As JsonResult
            Try
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

                    Calcula(inObjetoFiltro, modelo)

                    'VALIDACOES
                    If modelo.TotalPagar > modelo.ValorEntregue Then
                        Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.ValorEntregueNaoInferiorValorAPagar, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                    End If

                    If Not ValidaValorCredDeb(modelo) Then
                        Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.ValorCredsMaiorDebs, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                    End If

                    Using rp As New RepositorioPagamentosVendas
                        If Not rp.isValid(modelo, inObjetoFiltro) Then
                            Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.ValorPendenteAlteradoInfoAtualizada, .TipoAlerta = "i", .isValid = "false"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                        End If

                        If Not rp.isLinhasValidas(modelo, inObjetoFiltro) Then
                            Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.SelectionarPeloMenos1Doc, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                        End If
                    End Using
                    'END 'VALIDACOES

                    Using rp As New RepositorioPagamentosVendas
                        rp.AdicionaObj(modelo, inObjetoFiltro)
                    End Using

                    Dim id As Nullable(Of Long) = modelo.IDRecibo
                    Dim Opcao As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjetoFiltro, "Opcao", GetType(String)) 'pagamentos || adiantamentos

                    If Opcao = "adiantamentos" Then id = modelo.ListOfPendentes(0).IDDocumentoVenda

                    Return New JsonResult() With {.Data = New With {.isValid = True, .ID = id}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}

                Else
                    Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.SelectionarPeloMenos1Doc, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                End If

            Catch ex As Exception
                Return New JsonResult() With {.Data = New With {.Errors = ex.Message, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
            End Try
        End Function

        'R E C E B I M E N T O S
        <F3MAcesso>
        Public Function GetPagamentosVendasLinhas(IDPagamentoVenda As Long) As JsonResult
            Try

                Using rp As New RepositorioPagamentosVendas
                    Return RetornaJSONTamMaximo(rp.GetPagamentoVenda(IDPagamentoVenda))
                End Using

            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function VerificaPodeAnular(inIDPagamentoVenda As Long) As JsonResult
            Try
                Using rp As New RepositorioPagamentosVendas

                    If rp.VerificaPagEstadoEfetivo(inIDPagamentoVenda) Then

                        If rp.IsNCDA(inIDPagamentoVenda) Then
                            Dim docParaAnular As String = rp.GetPagamentosParaAnularByNCDA(inIDPagamentoVenda).Documento
                            Return New JsonResult() With {.Data = New With {.Errors = "Esta nota de crédito está a ser utilizada no documento " + docParaAnular + ".", .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                        End If

                        If Not rp.IsFA(inIDPagamentoVenda) AndAlso rp.VerificaPagamentosLinhasNCDA(inIDPagamentoVenda) AndAlso rp.HasNCDA(inIDPagamentoVenda) Then
                            Dim msg As String = "<div>Esta operação é irreversível.<p>O documento e a respectiva nota de crédito serão anulados.</p><p> Prentende continuar?</p></div>"
                            Return New JsonResult() With {.Data = New With {.WarningMessage = msg}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                        End If

                        If Not rp.ValidaDiasParaAnular(inIDPagamentoVenda) Then
                            Return New JsonResult() With {.Data = New With {.Errors = "O número de dias após os quais se pode anular um documento é superior ao definido nos parâmetros da empresa.", .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                        End If

                        If rp.VerificaFAnaNA(inIDPagamentoVenda) Then
                            Dim PagamentoVenda As Oticas.PagamentosVendas = rp.VerificaSE_NA(inIDPagamentoVenda)

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
                End Using

                Return RetornaJSONTamMaximo(True)

            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function Anula(IDPagamentoVenda As Long) As JsonResult
            Try
                Using rp As New RepositorioPagamentosVendas
                    If rp.VerificaPagEstadoEfetivo(IDPagamentoVenda) Then
                        rp.Anula(IDPagamentoVenda)

                    Else
                        Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.NaoPodeSerAnulado, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                    End If
                End Using

                Return RetornaJSONTamMaximo(True)

            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        ''' <summary>
        ''' funcao que valida se o valor dos debitos >= creditos
        ''' </summary>
        ''' <param name="inModelo">PagamentosVendas</param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Private Function ValidaValorCredDeb(ByVal inModelo As Oticas.PagamentosVendas) As Boolean
            Dim dblSumDeb As Double = (From x In inModelo.ListOfPendentes
                                       Where x.LinhaSelecionada = True And x.CodigoSistemaNaturezas = "R"
                                       Select x.ValorPago).Sum()

            Dim dblSumCred As Double = (From x In inModelo.ListOfPendentes
                                        Where x.LinhaSelecionada = True And x.CodigoSistemaNaturezas = "P"
                                        Select x.ValorPago).Sum()

            Return dblSumDeb >= dblSumCred
        End Function

        <F3MAcesso>
        Public Function Valida_FROMDOCSVENDAS(inModelo As Oticas.PagamentosVendas, inObjetoFiltro As ClsF3MFiltro) As JsonResult
            Try
                If Not inModelo.IDContaCaixa > 0 Then
                    Throw New Exception(OticasTraducao.Estrutura.ObrigatorioSelecionarCaixa)
                End If

                ' VALIDA SE A CAIXA ESTA ABERTA
                Using mc As New RepositorioMapaCaixa
                    If Not mc.CaixaAberta(Date.Now(), inModelo.IDContaCaixa) Then
                        Throw New Exception(OticasTraducao.Estrutura.CaixaNaoEstaAberta)
                    End If
                End Using

                If Not inModelo.ListOfPendentes Is Nothing AndAlso inModelo.ListOfPendentes.Where(Function(f) f.LinhaSelecionada).Count <> 0 Then

                    Calcula(inObjetoFiltro, inModelo)

                    If inModelo.TotalPagar > inModelo.ValorEntregue Then
                        Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.ValorEntregueNaoInferiorValorAPagar, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                    End If

                    Return New JsonResult() With {.Data = New With {.isValid = True}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                Else
                    Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.SelectionarPeloMenos1Doc, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                End If

            Catch ex As Exception
                Return New JsonResult() With {.Data = New With {.Errors = ex.Message, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
            End Try
        End Function
    End Class
End Namespace