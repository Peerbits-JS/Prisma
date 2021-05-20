Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao


Namespace Areas.Caixas.Controllers
    Public Class MovimentosCaixaController
        Inherits GrelhaFormController(Of BD.Dinamica.Aplicacao, tbMapaCaixa, MovimentosCaixa)

        Sub New()
            MyBase.New(New RepositorioMovimentosCaixa())
        End Sub


        Public Overrides Function Adiciona(Optional CampoValorPorDefeito As String = "", Optional IDVista As Long = 0) As ActionResult
            Dim result As ActionResult = MyBase.Adiciona(CampoValorPorDefeito, IDVista)

            Dim modeloMovimentoCaixa As MovimentosCaixa = DirectCast(DirectCast(result, PartialViewResult).Model, MovimentosCaixa)

            With modeloMovimentoCaixa
                .DataDocumento = Now()
            End With

            Using repMovCaixa As New RepositorioMovimentosCaixa
                repMovCaixa.PreencheCaixaPorDefeito(modeloMovimentoCaixa)
                modeloMovimentoCaixa.PermiteEditarCaixa = repMovCaixa.UtilizadorPodeAlterarCaixa()
            End Using

            Return result
        End Function

        <F3MAcesso>
        Public Function CaixaEstaAberta(dataDocumento As Date, idContaCaixa As Long) As JsonResult
            Dim blnOk As Boolean = True

            If idContaCaixa > 0 Then
                Using rp As New RepositorioMovimentosCaixa
                    blnOk = rp.CaixaEstaAberta(dataDocumento, idContaCaixa)
                End Using
            End If

            Return RetornaJSONTamMaximo(blnOk)
        End Function
    End Class
End Namespace
