Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaIdiomasController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaIdiomas, SistemaIdiomas)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaIdiomas)
        End Sub
#End Region

    End Class
End Namespace