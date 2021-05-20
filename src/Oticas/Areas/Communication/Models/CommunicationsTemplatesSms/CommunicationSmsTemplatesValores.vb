Namespace Areas.Communication.Models
    Public Class CommunicationSmsTemplatesValores
        Public Property ID As Long

        Public Property Ordem As Long

        Public Property IDSistemaComunicacaoSmsTemplatesValores As Long?

        Public Property TipoComponente As String

        Public Property Valor As String

        Public Property SqlQuery As String

        Public Property MinValue As String

        Public Property MaxValue As String

        Public Property DefaultValue As String

        Public Property Placeholder As String

        Public Property CssClasses As String

        Public Property SqlQueryWhere As String

        Public Property SqlQueryValores As New List(Of SqlQuery)
    End Class

    Public Class SqlQuery
        Public Property ID As Long?

        Public Property Codigo As String

        Public Property Descricao As String
    End Class
End Namespace
