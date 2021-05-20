Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class FormasPagamentoController
        Inherits FormasPagamentoController(Of Oticas.BD.Dinamica.Aplicacao, tbformaspagamento, FormasPagamento)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioFormasPagamento())
        End Sub
#End Region

    End Class
End Namespace
