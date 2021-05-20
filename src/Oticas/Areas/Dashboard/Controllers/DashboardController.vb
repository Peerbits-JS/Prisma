Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao

Namespace Areas.Dashboard.Controllers
    Public Class DashboardController
        Inherits SimpleFormController

        <F3MAcesso>
        Public Function Index() As ActionResult
            Return Nothing
        End Function

    End Class
End Namespace