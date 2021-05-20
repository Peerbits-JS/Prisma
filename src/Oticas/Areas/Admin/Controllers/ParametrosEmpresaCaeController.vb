Imports F3M.Areas.Admin.Controllers
Imports Oticas.Repositorio.Administracao

Namespace Areas.Admin.Controllers
    Public Class ParametrosEmpresaCaeController
        Inherits ParametrosEmpresaCaeController(Of F3MEntities, tbParametrosEmpresaCAE, ParametrosEmpresaCae)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioParametrosEmpresaCae)
        End Sub
#End Region

    End Class
End Namespace