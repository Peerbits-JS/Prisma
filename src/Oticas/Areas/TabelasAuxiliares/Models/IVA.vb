
Imports System.Runtime.Serialization

Public Class IVA
    Inherits F3M.IVA

    <DataMember>
    Public Property IDIva As Long?

    <DataMember>
    Public Property IDIVADesconto As Long?

    <DataMember>
    Public Property Desconto As Double?

    <DataMember>
    Public Property ValorMinimo As Double?

    <DataMember>
    Public Property PCM As Boolean?
End Class
