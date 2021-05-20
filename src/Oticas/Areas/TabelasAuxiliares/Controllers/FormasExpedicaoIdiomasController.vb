Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class FormasExpedicaoIdiomasController
        Inherits FormasExpedicaoIdiomasController(Of Oticas.BD.Dinamica.Aplicacao, tbFormasExpedicaoIdiomas, F3M.FormasExpedicaoIdiomas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioFormasExpedicaoIdiomas())
        End Sub
#End Region

    End Class
End Namespace
