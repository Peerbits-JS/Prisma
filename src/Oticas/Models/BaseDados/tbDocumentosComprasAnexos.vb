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

Partial Public Class tbDocumentosComprasAnexos
    Public Property ID As Long
    Public Property IDDocumentoCompra As Long
    Public Property IDTipoAnexo As Nullable(Of Long)
    Public Property Descricao As String
    Public Property FicheiroOriginal As String
    Public Property Ficheiro As String
    Public Property FicheiroThumbnail As String
    Public Property Caminho As String
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbDocumentosCompras As tbDocumentosCompras
    Public Overridable Property tbSistemaTiposAnexos As tbSistemaTiposAnexos

End Class
