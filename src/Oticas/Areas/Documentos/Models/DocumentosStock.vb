Imports System.Runtime.Serialization

Public Class DocumentosStock
    Inherits F3M.DocumentosStock

    ' GRELHAS LINHAS
    <DataMember>
    Public Property DocumentosStockLinhas As New List(Of DocumentosStockLinhas)

    <DataMember>
    Public Property IDLojaSede As Long?
    <DataMember>
    Public Property LocalidadeSede As String

    <DataMember>
    Public Property CodigoPostalSede As String

    <DataMember>
    Public Property MoradaSede As String

    <DataMember>
    Public Property TelefoneSede As String
End Class
