Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaSuperficiesLentesController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaSuperficiesLentes, SistemaSuperficiesLentes)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaSuperficiesLentes)
        End Sub
#End Region

    End Class
End Namespace