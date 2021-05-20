Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaEntidadesFormulasController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaEntidadesFormulas, SistemaEntidadesFormulas)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaEntidadesFormulas)
        End Sub
#End Region

    End Class
End Namespace