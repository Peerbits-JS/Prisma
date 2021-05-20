Imports System.Web.Mvc

Namespace Areas.TabelasAuxiliares
    Public Class TabelasAuxiliaresAreaRegistration
        Inherits AreaRegistration

        Public Overrides ReadOnly Property AreaName() As String
            Get
                Return "TabelasAuxiliares"
            End Get
        End Property

        Public Overrides Sub RegisterArea(ByVal context As AreaRegistrationContext)
            context.MapRoute(
                "TabelasAuxiliares_default",
                "TabelasAuxiliares/{controller}/{action}/{id}",
                New With {.action = "Index", .id = UrlParameter.Optional}
                )
        End Sub
    End Class
End Namespace