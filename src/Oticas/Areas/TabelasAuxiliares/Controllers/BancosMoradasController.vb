Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes
Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class BancosMoradasController
        Inherits BancosMoradasController(Of Oticas.BD.Dinamica.Aplicacao, tbBancosMoradas, BancosMoradas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioBancosMoradas())
        End Sub
#End Region

    End Class
End Namespace
