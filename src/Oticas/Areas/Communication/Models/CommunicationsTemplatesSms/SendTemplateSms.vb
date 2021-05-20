Namespace Areas.Communication.Models
    Public Class SendTemplateSms
        Public Property IDConnection As String

        Public Property IDTemplate As Long

        Public Property IDSistemaEnvio As Long

        Public Property Message As String

        Public Property Recipts As List(Of ReciptsGrid)
    End Class
End Namespace
