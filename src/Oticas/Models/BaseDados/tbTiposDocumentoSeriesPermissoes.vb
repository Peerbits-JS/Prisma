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

Partial Public Class tbTiposDocumentoSeriesPermissoes
    Public Property ID As Long
    Public Property IDSerie As Long
    Public Property IDPerfil As Long
    Public Property PermissaoConsultar As Boolean
    Public Property PermissaoAlterar As Boolean
    Public Property PermissaoAdicionar As Boolean
    Public Property PermissaoRemover As Boolean
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbTiposDocumentoSeries As tbTiposDocumentoSeries

End Class
