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

Partial Public Class tbEntidadesContatos
    Public Property ID As Long
    Public Property IDEntidade As Nullable(Of Long)
    Public Property IDTipo As Nullable(Of Long)
    Public Property Descricao As String
    Public Property Contato As String
    Public Property Telefone As String
    Public Property Telemovel As String
    Public Property Fax As String
    Public Property Email As String
    Public Property Mailing As Boolean
    Public Property PagWeb As String
    Public Property PagRedeSocial As String
    Public Property Ordem As Integer
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbEntidades As tbEntidades
    Public Overridable Property tbTiposContatos As tbTiposContatos

End Class