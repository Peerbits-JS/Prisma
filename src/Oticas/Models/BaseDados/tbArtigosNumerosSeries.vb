'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated from a template.
'
'     Manual changes to this file may cause unexpected behavior in your application.
'     Manual changes to this file will be overwritten if the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Imports System
Imports System.Collections.Generic

Partial Public Class tbArtigosNumerosSeries
    Public Property ID As Long
    Public Property IDArtigo As Long
    Public Property NumeroSerie As String
    Public Property Descricao As String
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbArtigos As tbArtigos
    Public Overridable Property tbCCStockArtigos As ICollection(Of tbCCStockArtigos) = New HashSet(Of tbCCStockArtigos)
    Public Overridable Property tbDocumentosComprasLinhas As ICollection(Of tbDocumentosComprasLinhas) = New HashSet(Of tbDocumentosComprasLinhas)
    Public Overridable Property tbDocumentosStockLinhas As ICollection(Of tbDocumentosStockLinhas) = New HashSet(Of tbDocumentosStockLinhas)
    Public Overridable Property tbDocumentosVendasLinhas As ICollection(Of tbDocumentosVendasLinhas) = New HashSet(Of tbDocumentosVendasLinhas)
    Public Overridable Property tbStockArtigos As ICollection(Of tbStockArtigos) = New HashSet(Of tbStockArtigos)
    Public Overridable Property tbStockArtigosNecessidades As ICollection(Of tbStockArtigosNecessidades) = New HashSet(Of tbStockArtigosNecessidades)

End Class
