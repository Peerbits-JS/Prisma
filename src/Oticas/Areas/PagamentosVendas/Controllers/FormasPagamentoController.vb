Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.PagamentosVendas.Controllers
    Public Class FormasPagamentoController
        Inherits SimpleFormController

        <F3MAcesso>
        Public Function Index(Optional ByVal IDPagamentoVenda As Long = 0,
                              Optional ByVal IDMoeda As Long = 0,
                              Optional ByVal Opcao As String = "",
                              Optional ByVal IDDocumentoVendaServico As Long = 0) As ActionResult
            ViewBag.Opcao = Opcao
            ViewBag.ValorPagoNumerario = CDbl(0)


            Using rp As New RepositorioPagamentosVendas
                ViewBag.ListOfVendasFormasPagamentos = rp.GetFormasPagamento(IDPagamentoVenda)

                If IDDocumentoVendaServico <> 0 Then
                    ViewBag.ValorPagoNumerario = rp.GetValorPago(IDDocumentoVendaServico)
                End If
            End Using

            Using repM As New RepositorioMoedas
                ViewBag.Moeda = repM.RetornaMoeda(IDMoeda)
            End Using

            Return PartialView()
        End Function
    End Class
End Namespace