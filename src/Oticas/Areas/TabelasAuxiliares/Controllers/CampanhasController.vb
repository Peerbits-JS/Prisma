Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class CampanhasController
        Inherits CampanhasController(Of Oticas.BD.Dinamica.Aplicacao, tbCampanhas, Campanhas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioCampanhas())
        End Sub
#End Region

    End Class
End Namespace
