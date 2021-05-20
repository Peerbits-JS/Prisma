Imports System.Web.Mvc

Namespace Areas.PagamentosVendas
    Public Class PagamentosVendasAreaRegistration
        Inherits AreaRegistration

        Public Overrides ReadOnly Property AreaName() As String
            Get
                Return "PagamentosVendas"
            End Get
        End Property

        Public Overrides Sub RegisterArea(ByVal context As AreaRegistrationContext)
            context.MapRoute(
                "PagamentosVendas_default",
                "PagamentosVendas/{controller}/{action}/{id}",
                New With {.action = "Index", .id = UrlParameter.Optional}
            )
        End Sub
    End Class
End Namespace