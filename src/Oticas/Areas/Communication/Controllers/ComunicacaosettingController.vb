Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports Oticas.Areas.Communication.Models
Imports Oticas.Repositorio.Communication

Namespace Areas.Communication.Controllers
    Public Class ComunicacaosettingController
        Inherits SimpleFormController

        ReadOnly _repositorioComunicacao As RepositorioComunicacao

        Sub New()
            _repositorioComunicacao = New RepositorioComunicacao()
        End Sub

        <F3MAcesso>
        Function Index() As ActionResult
            Return View(New ComunHistoryModels)
        End Function

        <F3MAcesso>
        Function Historic() As ActionResult
            Return PartialView("AreaGeral", New ComunHistoryModels)
        End Function

        <F3MAcesso>
        Function GetCommunicationHistory(filter As ComunFilterModels) As JsonResult
            Return RetornaJSONTamMaximo(_repositorioComunicacao.GetCommunicationHistory(filter))
        End Function
    End Class
End Namespace