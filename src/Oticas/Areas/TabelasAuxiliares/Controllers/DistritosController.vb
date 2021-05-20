Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class DistritosController
        Inherits DistritosController(Of Oticas.BD.Dinamica.Aplicacao, tbDistritos, Distritos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioDistritos())
        End Sub
#End Region

    End Class
End Namespace
