Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaMateriasLentesController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaMateriasLentes, SistemaMateriasLentes)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaMateriasLentes)
        End Sub
#End Region

    End Class
End Namespace