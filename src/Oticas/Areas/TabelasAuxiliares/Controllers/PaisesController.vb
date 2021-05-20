Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class PaisesController
        Inherits PaisesController(Of Oticas.BD.Dinamica.Aplicacao, tbPaises, Paises)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioPaises())
        End Sub
#End Region

    End Class
End Namespace
