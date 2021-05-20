Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class IdiomasController
        Inherits IdiomasController(Of Oticas.BD.Dinamica.Aplicacao, tbIdiomas, Idiomas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioIdiomas())
        End Sub
#End Region

    End Class
End Namespace
