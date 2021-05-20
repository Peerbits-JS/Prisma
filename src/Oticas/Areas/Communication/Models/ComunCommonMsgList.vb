Imports System.ComponentModel.DataAnnotations
Imports System.Runtime.Serialization
Imports F3M.Modelos.Base

Namespace Areas.Communication.Models

    Public Class ComunCommonMsgList
        Public Property TxtMsg As String
        Public Property Status As Boolean

        Public Property DataCriacao As Date

        Public Property Responce As String

        Public Property ErrorDesc As String

        Public Property Documento As String


        Public Property UtilizadorCriacao As String

        Public Property MsgFrom As String

        Public Property DocumentId As String
    End Class
End Namespace