Imports System.ComponentModel.DataAnnotations
Imports System.Runtime.Serialization
Imports F3M.Modelos.Base


Namespace Areas.Communication.Models

    Public Class ComunCommonModels
        Inherits ClsF3MModelo

        <DataMember>
        Public Property IDmsgsystem As Long?

        <DataMember>
        Public Property Descricaomsgsystem As String

        <DataMember>
        Public Property Destination As String

        <DataMember>
        Public Property Documento As String

        Public Property IDDoc As Long?

        <DataMember>
        Public Property IDChamada As String

        <DataMember>
        Public Property TexoMsgArea As String

        <DataMember>
        Public Property MsgFrom As String


        Public Property ComunList As List(Of ComunCommonMsgList)

        <DataMember>
        <Display(Name:="Enter")>
        Public Property BtnEnter As String

        <DataMember>
        Public Property AvailableCredits As String
    End Class
End Namespace