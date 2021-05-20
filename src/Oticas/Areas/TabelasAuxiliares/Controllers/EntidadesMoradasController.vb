Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class EntidadesMoradasController
        Inherits EntidadesMoradasController(Of Oticas.BD.Dinamica.Aplicacao, tbEntidadesMoradas, EntidadesMoradas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioEntidadesMoradas())
        End Sub
#End Region

    End Class
End Namespace
