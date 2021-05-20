Namespace Areas.Admin.Controllers
    Public Class LojasController
        Inherits F3M.Areas.Administracao.Controllers.LojasController

        Const ViewsPath As String = "~/F3M/Areas/Administracao/Views/Lojas/"

        Public Shared Function GetViewsPath() As String
            Return ViewsPath
        End Function
    End Class
End Namespace