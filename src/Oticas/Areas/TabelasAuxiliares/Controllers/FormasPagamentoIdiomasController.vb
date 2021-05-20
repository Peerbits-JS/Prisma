Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class FormasPagamentoIdiomasController
        Inherits FormasPagamentoIdiomasController(Of Oticas.BD.Dinamica.Aplicacao, tbFormasPagamentoIdiomas, F3M.FormasPagamentoIdiomas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioFormasPagamentoIdiomas())
        End Sub
#End Region

    End Class
End Namespace
