Namespace Areas.Communication.Models
    Public Class CommunicationSmsTemplatesGrupos
        Public Property ID As Long

        Public Property Ordem As Long

        Public Property MainCondition As String 'and || or

        Public Property Regras As New List(Of CommunicationSmsTemplatesRegras)

        Public Property Grupos As New List(Of CommunicationSmsTemplatesGrupos)

        Public Property MaxOrdem As Long = 1
    End Class
End Namespace
