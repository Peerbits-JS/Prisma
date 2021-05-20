Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base

Namespace Areas.Communication.Models
    Public Class CommunicationSmsTemplatesFiltros
        Inherits ClsF3MModelo

        Public Property Codigo As String

        Public Property Descricao As String

        Public Property TipoComponente As String

        Public Property Ordem As Long

        Public Property SqlQuery As String
    End Class
End Namespace
