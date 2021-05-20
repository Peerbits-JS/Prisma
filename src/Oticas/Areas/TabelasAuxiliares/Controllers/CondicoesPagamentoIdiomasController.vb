Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class CondicoesPagamentoIdiomasController
        Inherits CondicoesPagamentoIdiomasController(Of Oticas.BD.Dinamica.Aplicacao, tbCondicoesPagamentoIdiomas, CondicoesPagamentoIdiomas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioCondicoesPagamentoIdiomas())
        End Sub
#End Region

    End Class
End Namespace
