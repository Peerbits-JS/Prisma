Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class ContasBancariasMoradasController
        Inherits ContasBancariasMoradasController(Of Oticas.BD.Dinamica.Aplicacao, tbContasBancariasMoradas, ContasBancariasMoradas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioContasBancariasMoradas())
        End Sub
#End Region

    End Class
End Namespace
