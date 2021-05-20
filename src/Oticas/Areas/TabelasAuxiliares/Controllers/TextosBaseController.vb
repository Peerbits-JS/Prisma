Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class TextosBaseController
        Inherits TextosBaseController(Of Oticas.BD.Dinamica.Aplicacao, tbTextosBase, TextosBase)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioTextosBase())
        End Sub
#End Region

    End Class
End Namespace
