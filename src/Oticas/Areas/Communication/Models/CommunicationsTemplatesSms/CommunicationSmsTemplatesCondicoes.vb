Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base

Namespace Areas.Communication.Models
    Public Class CommunicationSmsTemplatesCondicoes
        Inherits ClsF3MModelo

        Public Property Codigo As String

        Public Property Descricao As String

        Public Property TipoComponenteFiltro As String

        Public Property TipoComponenteCondicao As String

        Public Property Ordem As Long

        Public Property IDCondicaoSelected As Long?

        Public Property Valor As New CommunicationSmsTemplatesValores
    End Class
End Namespace