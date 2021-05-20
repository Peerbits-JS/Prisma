Namespace Areas.Admin.Controllers
    Public Class UtilizadoresController
        Inherits F3M.Areas.Administracao.Controllers.UtilizadoresController

        Const ViewsPath As String = "~/F3M/Areas/Administracao/Views/Utilizadores/"

        Public Shared Function GetViewsPath() As String
            Return ViewsPath
        End Function
    End Class
End Namespace