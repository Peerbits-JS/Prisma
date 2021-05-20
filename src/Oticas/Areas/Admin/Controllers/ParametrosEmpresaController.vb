Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Administracao

Namespace Areas.Admin.Controllers
    Public Class ParametrosEmpresaController
        Inherits GrelhaController(Of F3MEntities, tbParametrosEmpresa, ParametrosEmpresa)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioParametrosEmpresa())
        End Sub
#End Region

    End Class
End Namespace
