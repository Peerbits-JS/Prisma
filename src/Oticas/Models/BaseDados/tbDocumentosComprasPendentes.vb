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

Partial Public Class tbDocumentosComprasPendentes
    Public Property ID As Long
    Public Property IDTipoDocumento As Nullable(Of Long)
    Public Property NumeroDocumento As Nullable(Of Long)
    Public Property DataDocumento As Nullable(Of Date)
    Public Property DataVencimento As Nullable(Of Date)
    Public Property Documento As String
    Public Property IDTipoEntidade As Nullable(Of Long)
    Public Property IDEntidade As Nullable(Of Long)
    Public Property DescricaoEntidade As String
    Public Property TotalMoedaDocumento As Nullable(Of Double)
    Public Property TotalMoedaReferencia As Nullable(Of Double)
    Public Property TotalClienteMoedaDocumento As Nullable(Of Double)
    Public Property TotalClienteMoedaReferencia As Nullable(Of Double)
    Public Property IDMoeda As Nullable(Of Long)
    Public Property TaxaConversao As Nullable(Of Double)
    Public Property ValorPendente As Nullable(Of Double)
    Public Property IDSistemaNaturezas As Nullable(Of Long)
    Public Property Pago As Nullable(Of Boolean)
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property IDDocumentoCompra As Nullable(Of Long)

    Public Overridable Property tbDocumentosCompras As tbDocumentosCompras
    Public Overridable Property tbSistemaNaturezas As tbSistemaNaturezas

End Class