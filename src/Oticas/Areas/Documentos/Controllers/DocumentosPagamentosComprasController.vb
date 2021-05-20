Imports Kendo.Mvc.UI
Imports F3M.Areas.Documentos.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Repositorio.Comum
Imports Oticas.Repositorio.Documentos
Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Modelos.Utilitarios

Namespace Areas.Documentos.Controllers
    Public Class DocumentosPagamentosComprasController
        Inherits DocumentosController(Of BD.Dinamica.Aplicacao, tbPagamentosCompras, DocumentosPagamentosCompras)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioDocumentosPagamentosCompras)
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function Adiciona(Optional CampoValorPorDefeito As String = "", Optional IDVista As Long = 0) As ActionResult
            Return MyBase.AdicionaPorDefeito(Of tbEstados, tbTiposDocumentoTipEntPermDoc, tbTiposDocumentoSeries, tbParametrosEmpresa, tbSistemaTiposDocumentoColunasAutomaticas)(
                repositorio.BDContexto, Nothing, TiposEntidadeEstados.DocumentosPagamentosCompras, TiposEntidade.Fornecedores,
                SistemaCodigoModulos.ContaCorrente, Menus.Fornecedores, CampoValorPorDefeito, IDVista)
        End Function

        <F3MAcesso>
        Public Function FormasPagamento(Optional ByVal ID As Long = 0, Optional ByVal IDMoeda As Long = 0) As ActionResult
            Dim DPC As New F3M.DocumentosPagamentosCompras
            Dim moeda As New Moedas

            Using repPC As New RepositorioDocPagamentosCompras, repPagamentos As New RepositorioDocumentosPagamentosCompras
                If ID <> 0 Then
                    ViewBag.Opcao = "recebimentos"

                    DPC = repPC.RetornaPagamentoCompra(Of tbPagamentosCompras)(repositorio.BDContexto, ID)
                Else
                    ViewBag.Opcao = String.Empty

                    With DPC
                        .Troco = 0.0
                        .ValorEntregue = 0.0

                        .PermiteEditarCaixa = repPagamentos.UtilizadorPodeAlterarCaixa()
                        repPagamentos.PreencheCaixaPorDefeito(DPC)
                    End With
                End If

                With DPC
                    Using repM As New RepositorioMoedas
                        moeda = repM.RetornaMoeda(IDMoeda)
                    End Using

                    .IDMoeda = moeda.ID
                    .CasasDecimaisTotais = moeda.CasasDecimaisTotais
                    .Simbolo = moeda.Simbolo

                    .ListOfFormasPagamento = repPC.RetornaFormasPagamento(
                        Of tbFormasPagamento, tbPagamentosComprasFormasPagamento)(repositorio.BDContexto, ID)
                End With
            End Using

            Return View(DPC)
        End Function
#End Region

#Region "ACOES DE LEITURA"
        <F3MAcesso>
        Public Function RetornaDocsComprasPendentes(IDFornecedor As Long, IDMoeda As Long) As JsonResult
            Try
                'TODO -> falta por o modelo DocumentosComprasPendentes em cada proj para tipificar
                Dim modelo = RepositorioDocPagamentosCompras.RetornaDocsComprasPendentes(Of tbDocumentosComprasPendentes)(repositorio.BDContexto, IDFornecedor, IDMoeda)

                Return RetornaJSONTamMaximo(LZString.RetornaModeloComp(modelo))
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "FUNÇÕES AUXILIARES"
        <F3MAcesso>
        Public Function VerficaSeHaAlteracoes(inModelo As String) As JsonResult
            Try
                Dim modelo As DocumentosPagamentosCompras = LZString.RetornaModeloDescomp(Of DocumentosPagamentosCompras)(inModelo)

                Return RetornaJSONTamMaximo(RepositorioDocPagamentosCompras.VerficaSeHaAlteracoes(Of tbDocumentosComprasPendentes)(repositorio.BDContexto, modelo))

            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "CÁLCULOS"
        <F3MAcesso>
        Public Function Calcula(inObjetoFiltro As ClsF3MFiltro, inModelo As String) As JsonResult
            Try
                Dim modelo As DocumentosPagamentosCompras = LZString.RetornaModeloDescomp(Of DocumentosPagamentosCompras)(inModelo)

                Return RetornaJSONTamMaximo(LZString.RetornaModeloComp(RepositorioDocPagamentosCompras.Calcula(inObjetoFiltro, modelo)))
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "ANULAR PAGAMENTOS"
        <F3MAcesso>
        Public Function AnulaPagamento(inIDDocPagCompra As Long) As JsonResult
            Try
                Using rpPagamentosCompras As New RepositorioDocumentosPagamentosCompras
                    rpPagamentosCompras.AnulaPagamento(inIDDocPagCompra)
                End Using

                Return RetornaJSONTamMaximo(True)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "VALIDACOES"
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function Adiciona(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As DocumentosPagamentosCompras, filtro As ClsF3MFiltro) As JsonResult

            Dim btCasasDecimaisTotais As Byte

            With modelo
                btCasasDecimaisTotais = If(modelo.CasasDecimaisTotais, 2)
                'atualiza o TotalMoedaDocumento
                .TotalMoedaDocumento = Math.Round(modelo.ListOfPendentes.Select(
                    Function(s) If(s.CodigoSistemaNaturezas = TiposNaturezas.Credito, s.TotalMoeda, -s.TotalMoeda)).DefaultIfEmpty(0).Sum(), btCasasDecimaisTotais)

                'atualiza o ValorAPagar
                .TotalDocumentos = Math.Round(modelo.ListOfPendentes.Select(
                    Function(s) If(s.CodigoSistemaNaturezas = TiposNaturezas.Credito, s.ValorPago, -s.ValorPago)).DefaultIfEmpty(0).Sum(), btCasasDecimaisTotais)

                'atualiza o ValorDesconto
                .TotalDescontos = Math.Round(modelo.ListOfPendentes.Select(
                    Function(s) s.ValorDesconto).DefaultIfEmpty(0).Sum(), 2)
            End With

            Dim TotalFormasPagamento As Double = Math.Round(modelo.ListOfFormasPagamento.Where(Function(w) w.Valor > 0).Sum(Function(s) s.Valor), btCasasDecimaisTotais)

            'VALIDACOES
            If modelo.TotalMoedaDocumento > TotalFormasPagamento Then
                Return New JsonResult() With {.Data = New With {.Errors = Traducao.Cliente.ValorEntregueInferiorPagar, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
            End If
            'END VALIDACOES

            Return MyBase.Adiciona(request, modelo, filtro)
        End Function

        <F3MAcesso>
        Public Function Valida(inModelo As DocumentosPagamentosCompras) As JsonResult
            Try
                If inModelo.IDContaCaixa Is Nothing OrElse Not inModelo.IDContaCaixa > 0 Then
                    Throw New Exception(OticasTraducao.Estrutura.ObrigatorioSelecionarCaixa)
                End If

                ' VALIDA SE A CAIXA ESTA ABERTA
                'Using mc As New RepositorioMapaCaixa
                '    If Not mc.CaixaAberta(Date.Now()) Then
                '        Throw New Exception(OticasTraducao.Estrutura.CaixaNaoEstaAberta)
                '    End If
                'End Using

                Dim btCasasDecimaisTotais As Byte

                With inModelo
                    btCasasDecimaisTotais = If(inModelo.CasasDecimaisTotais, 2)
                    'atualiza o TotalMoedaDocumento
                    .TotalMoedaDocumento = Math.Round(inModelo.ListOfPendentes.Select(
                            Function(s) If(s.CodigoSistemaNaturezas = TiposNaturezas.Credito, s.TotalMoeda, -s.TotalMoeda)).DefaultIfEmpty(0).Sum(), 2)

                    'atualiza o ValorAPagar
                    .TotalDocumentos = Math.Round(inModelo.ListOfPendentes.Select(
                            Function(s) If(s.CodigoSistemaNaturezas = TiposNaturezas.Credito, s.ValorPago, -s.ValorPago)).DefaultIfEmpty(0).Sum(), 2)

                    'atualiza o ValorDesconto
                    .TotalDescontos = Math.Round(inModelo.ListOfPendentes.Select(
                            Function(s) s.ValorDesconto).DefaultIfEmpty(0).Sum(), 2)
                End With

                Dim TotalFormasPagamento As Double = Math.Round(inModelo.ListOfFormasPagamento.Where(Function(w) w.Valor > 0).Sum(Function(s) s.Valor), 2)

                If inModelo.TotalMoedaDocumento > TotalFormasPagamento Then
                    Return New JsonResult() With {.Data = New With {.Errors = Traducao.Cliente.ValorEntregueInferiorPagar, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                End If


                Return RetornaJSONTamMaximo(True)

            Catch ex As Exception
                Return New JsonResult() With {.Data = New With {.Errors = ex.Message, .TipoAlerta = "error"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
            End Try
        End Function

        <F3MAcesso>
        Private Function ValidaValorCredDeb(ByVal inModelo As Oticas.DocumentosPagamentosCompras) As Boolean
            Dim dblSumDeb As Double = (From x In inModelo.ListOfPendentes
                                       Where x.LinhaSelecionada = True And x.CodigoSistemaNaturezas = "R"
                                       Select x.ValorPago).Sum()

            Dim dblSumCred As Double = (From x In inModelo.ListOfPendentes
                                        Where x.LinhaSelecionada = True And x.CodigoSistemaNaturezas = "P"
                                        Select x.ValorPago).Sum()

            Return dblSumDeb >= dblSumCred
        End Function
#End Region
    End Class
End Namespace