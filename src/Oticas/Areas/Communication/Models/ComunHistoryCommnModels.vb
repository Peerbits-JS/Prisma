Imports System.ComponentModel.DataAnnotations
Imports System.Runtime.Serialization
Imports F3M.Modelos.Base
Imports F3M.Modelos.Controlos

Namespace Areas.Communication.Models

    Public Class ComunHistoryCommnModels
        Inherits ClsF3MModelo

        Sub New()
            Datade = New DateTime(DateTime.Now.Year, DateTime.Now.Month, 1)
            Dataa = New DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddMonths(1).AddDays(-1)
            DestinatariosDropdownListStatic = New ClsF3MDropDownListStatic With {.Data = New List(Of Object) From {
                New With {.ID = "", .Descricao = "Todos"},
                New With {.ID = "2", .Descricao = "Clientes"}}}
            StatusDropdownListStatic = New ClsF3MDropDownListStatic With {.Data = New List(Of Object) From {
                New With {.ID = "", .Descricao = "Todos"},
                New With {.ID = "1", .Descricao = "Enviado"},
                New With {.ID = "0", .Descricao = "Erro de envio"}}}
        End Sub

        <DataMember, Required>
        Public Property Datade As Date

        <DataMember, Required>
        Public Property Dataa As Date

        <DataMember>
        Public Property IDTemplate As Long?

        <DataMember>
        Public Property Destinatarios As String

        <DataMember>
        Public Property ComSistema As String

        <DataMember>
        Public Property Status As String


        Public Property DestinatariosDropdownListStatic As ClsF3MDropDownListStatic

        Public Property StatusDropdownListStatic As ClsF3MDropDownListStatic
    End Class

    Public Class ComunHisGrid
        Public Property TemplateNome As String
        Public Property DataEnvio As Date
        Public Property Destinatarios As String
        Public Property Status As Boolean
        Public Property Mensagem As String
        Public Property Template As String
    End Class
End Namespace
