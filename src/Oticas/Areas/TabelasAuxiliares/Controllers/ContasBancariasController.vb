Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class ContasBancariasController
        Inherits ContasBancariasController(Of Oticas.BD.Dinamica.Aplicacao, tbContasBancarias, ContasBancarias)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioContasBancarias())
        End Sub
#End Region

    End Class
End Namespace
