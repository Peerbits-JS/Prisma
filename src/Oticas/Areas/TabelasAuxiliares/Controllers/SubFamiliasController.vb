Imports F3M.Areas.Comum.Controllers
Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class SubFamiliasController
        Inherits SubFamiliasController(Of Oticas.BD.Dinamica.Aplicacao, tbSubFamilias, SubFamilias)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioSubFamilias())
        End Sub
#End Region

    End Class
End Namespace
