Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.Clientes.Controllers

Namespace Areas.Clientes.Controllers
    Public Class ClientesGrelhasController
        Inherits ClientesGrelhasController(Of Oticas.BD.Dinamica.Aplicacao, tbClientes, Oticas.Clientes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioClientes())
        End Sub
#End Region

    End Class
End Namespace
