Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Administracao

Namespace Areas.Admin.Controllers
    Public Class ParametrosLojaController
        Inherits GrelhaController(Of F3MEntities, tbParametrosLoja, ParametrosLoja)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioParametrosLoja())
        End Sub
#End Region

    End Class
End Namespace
