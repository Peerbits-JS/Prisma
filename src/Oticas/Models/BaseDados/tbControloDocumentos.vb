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

Partial Public Class tbControloDocumentos
    Public Property IDTipoDocumento As Nullable(Of Long)
    Public Property IDTiposDocumentoSeries As Nullable(Of Long)
    Public Property IDDocumento As Nullable(Of Long)
    Public Property NumeroDocumento As Nullable(Of Long)
    Public Property DataDocumento As Nullable(Of Date)
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property IDTipoEntidade As Nullable(Of Long)
    Public Property IDEntidade As Nullable(Of Long)
    Public Property IDLoja As Nullable(Of Long)
    Public Property IDEstado As Nullable(Of Long)
    Public Property ATCUD As String

    Public Overridable Property tbSistemaTiposEntidade As tbSistemaTiposEntidade
    Public Overridable Property tbTiposDocumento As tbTiposDocumento
    Public Overridable Property tbTiposDocumentoSeries As tbTiposDocumentoSeries

End Class