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

Partial Public Class tbSistemaNaturezas
    Public Property ID As Long
    Public Property Codigo As String
    Public Property Descricao As String
    Public Property Modulo As String
    Public Property TipoDoc As String
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbDocumentosComprasPendentes As ICollection(Of tbDocumentosComprasPendentes) = New HashSet(Of tbDocumentosComprasPendentes)
    Public Overridable Property tbDocumentosVendasPendentes As ICollection(Of tbDocumentosVendasPendentes) = New HashSet(Of tbDocumentosVendasPendentes)
    Public Overridable Property tbPagamentosComprasLinhas As ICollection(Of tbPagamentosComprasLinhas) = New HashSet(Of tbPagamentosComprasLinhas)
    Public Overridable Property tbTiposDocumento As ICollection(Of tbTiposDocumento) = New HashSet(Of tbTiposDocumento)

End Class
