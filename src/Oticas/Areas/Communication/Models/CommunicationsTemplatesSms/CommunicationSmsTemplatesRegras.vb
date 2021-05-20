Namespace Areas.Communication.Models
    Public Class CommunicationSmsTemplatesRegras
        Public Property ID As Long

        Public Property Ordem As Long

        Public Property IDFiltro As Long?

        Public Property IDCondicao As Long?

        Public Property Valor As String

        Public Property Filtros As List(Of CommunicationSmsTemplatesFiltros)

        Public Property Condicoes As List(Of CommunicationSmsTemplatesCondicoes)

        Public Property SqlQueryValores As List(Of SqlQuery)

        Public Property Valores As List(Of CommunicationSmsTemplatesValores)
    End Class
End Namespace