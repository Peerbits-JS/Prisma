Imports Microsoft.ApplicationInsights

Namespace ErrorHandler
    <AttributeUsage(AttributeTargets.[Class] Or AttributeTargets.Method, Inherited:=True, AllowMultiple:=True)>
    Public Class AiHandleErrorAttribute
        Inherits HandleErrorAttribute

        Dim _telemetryClient = New TelemetryClient()

        Public Overrides Sub OnException(filterContext As ExceptionContext)
            If filterContext IsNot Nothing AndAlso filterContext.HttpContext IsNot Nothing AndAlso filterContext.Exception IsNot Nothing Then
                _telemetryClient.TrackException(filterContext.Exception, F3M.ClsDadosSessao.GetSessaoCompleta())
            End If
            MyBase.OnException(filterContext)
        End Sub

    End Class
End Namespace