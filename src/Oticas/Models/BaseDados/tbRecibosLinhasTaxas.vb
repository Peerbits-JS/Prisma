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

Partial Public Class tbRecibosLinhasTaxas
    Public Property ID As Long
    Public Property IDReciboLinha As Long
    Public Property TipoTaxa As String
    Public Property TaxaIva As Nullable(Of Double)
    Public Property ValorIncidencia As Nullable(Of Double)
    Public Property ValorIva As Nullable(Of Double)
    Public Property CodigoMotivoIsencaoIva As String
    Public Property MotivoIsencaoIva As String
    Public Property ValorImposto As Nullable(Of Double)
    Public Property CodigoTipoIva As String
    Public Property CodigoRegiaoIva As String
    Public Property CodigoTaxaIva As String
    Public Property Ordem As Nullable(Of Integer)
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbRecibosLinhas As tbRecibosLinhas

End Class