Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports F3M.Modelos.Autenticacao

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class CondicoesPagamentoController
        Inherits CondicoesPagamentoController(Of Oticas.BD.Dinamica.Aplicacao, tbCondicoesPagamento, CondicoesPagamento)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioCondicoesPagamento())
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        ' GET: Edita/5
        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        Public Overrides Function Edita(Optional ByVal ID As Long = 0) As ActionResult

            Using rp As New RepositorioCondicoesPagamento
                ViewBag.UltimaEntidade = rp.getUltimaEntidade(ID)
            End Using

            Return RetornaAcoes(ID, AcoesFormulario.Alterar)
        End Function
#End Region
    End Class
End Namespace
