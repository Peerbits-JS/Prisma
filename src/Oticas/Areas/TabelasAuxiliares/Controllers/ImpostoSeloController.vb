Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class ImpostoSeloController
        Inherits ImpostoSeloController(Of Oticas.BD.Dinamica.Aplicacao, tbImpostoSelo, ImpostoSelo)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioImpostoSelo())
        End Sub
#End Region

    End Class
End Namespace
