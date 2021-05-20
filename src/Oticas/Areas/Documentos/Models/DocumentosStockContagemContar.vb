Imports System.ComponentModel.DataAnnotations

Public Class DocumentosStockContagemContar
    <Required>
    Public Property Quantidade As Integer = 1

    <Required>
    Public Property IDArtigo As Nullable(Of Long)
    Public Property CodigoArtigo As String

    Public Property IDLote As Nullable(Of Long)
    Public Property CodigoLote As String
End Class
