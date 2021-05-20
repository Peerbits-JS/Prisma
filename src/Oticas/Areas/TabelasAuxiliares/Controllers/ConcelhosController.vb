Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class ConcelhosController
        Inherits ConcelhosController(Of Oticas.BD.Dinamica.Aplicacao, tbConcelhos, Concelhos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioConcelhos())
        End Sub
#End Region

    End Class
End Namespace
