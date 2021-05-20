Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaFormatoUnidadeTempoController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaFormatoUnidadeTempo, SistemaFormatoUnidadeTempo)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaFormatoUnidadeTempo)
        End Sub
#End Region

    End Class
End Namespace