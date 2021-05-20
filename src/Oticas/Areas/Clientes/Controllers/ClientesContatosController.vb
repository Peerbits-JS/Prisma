Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio
Imports Oticas.Modelos.Constantes
Imports F3M.Areas.Clientes.Controllers

Namespace Areas.Clientes.Controllers
    Public Class ClientesContatosController
        Inherits ClientesGrelhasController(Of Oticas.BD.Dinamica.Aplicacao, tbClientesContatos, F3M.ClientesContatos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioClientesContatos())
        End Sub
#End Region

    End Class
End Namespace