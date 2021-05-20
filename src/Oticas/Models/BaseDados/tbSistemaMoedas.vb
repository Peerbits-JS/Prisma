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

Partial Public Class tbSistemaMoedas
    Public Property ID As Long
    Public Property Codigo As String
    Public Property Descricao As String
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property CasasDecimaisTotais As Nullable(Of Byte)
    Public Property CasasDecimaisIva As Nullable(Of Byte)
    Public Property CasasDecimaisPrecosUnitarios As Nullable(Of Byte)

    Public Overridable Property tbDocumentosStockContagem As ICollection(Of tbDocumentosStockContagem) = New HashSet(Of tbDocumentosStockContagem)
    Public Overridable Property tbMoedas As ICollection(Of tbMoedas) = New HashSet(Of tbMoedas)

End Class
