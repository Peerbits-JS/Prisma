Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class CondicoesPagamentoDescontosController
        Inherits CondicoesPagamentoDescontosController(Of Oticas.BD.Dinamica.Aplicacao, tbCondicoesPagamentoDescontos, CondicoesPagamentoDescontos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioCondicoesPagamentoDescontos())
        End Sub
#End Region

    End Class
End Namespace
