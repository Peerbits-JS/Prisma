Imports Oticas.Repositorio
Imports F3M.Areas.Clientes.Controllers

Namespace Areas.Clientes.Controllers
    Public Class ClientesMoradasController
        Inherits ClientesGrelhasController(Of Oticas.BD.Dinamica.Aplicacao, tbClientesMoradas, F3M.ClientesMoradas)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioClientesMoradas())
        End Sub
#End Region

    End Class
End Namespace