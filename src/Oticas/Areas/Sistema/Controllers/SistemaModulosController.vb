Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaModulosController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaModulos, SistemaModulos)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaModulos)
        End Sub
#End Region

    End Class
End Namespace