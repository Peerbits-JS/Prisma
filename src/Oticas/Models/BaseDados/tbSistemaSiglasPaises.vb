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

Partial Public Class tbSistemaSiglasPaises
    Public Property ID As Long
    Public Property Sigla As String
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property Nacional As Nullable(Of Boolean)
    Public Property Descricao As String
    Public Property DescricaoPais As String

    Public Overridable Property tbPaises As ICollection(Of tbPaises) = New HashSet(Of tbPaises)
    Public Overridable Property tbParametrosEmpresa As ICollection(Of tbParametrosEmpresa) = New HashSet(Of tbParametrosEmpresa)
    Public Overridable Property tbParametrosLoja As ICollection(Of tbParametrosLoja) = New HashSet(Of tbParametrosLoja)

End Class
