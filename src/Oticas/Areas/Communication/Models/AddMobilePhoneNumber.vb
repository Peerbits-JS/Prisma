Imports System.ComponentModel.DataAnnotations
Imports System.Runtime.Serialization
Imports F3M.Modelos.Base

Namespace Areas.Communication.Models
    Public Class AddMobilePhoneNumber
        Inherits ClsF3MModelo

        <DataMember>
        Public Property IDChamada As String

        <DataMember, Required, StringLength(9)>
        Public Property MobilePhoneNumber As String
    End Class
End Namespace