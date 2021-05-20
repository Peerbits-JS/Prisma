Imports System.Web.Mvc

Namespace Areas.Communication

    Public Class CommunicationAreaRegistration
        Inherits AreaRegistration

        Public Overrides ReadOnly Property AreaName As String
            Get
                Return "Communication"
            End Get
        End Property

        Public Overrides Sub RegisterArea(context As AreaRegistrationContext)
            context.MapRoute(
                "Communication_default",
                "Communication/{controller}/{action}/{id}",
                New With {.action = "Index", .id = UrlParameter.Optional}
            )
        End Sub
    End Class

End Namespace