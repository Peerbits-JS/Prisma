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

Partial Public Class tbSistemaSexo
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

    Public Overridable Property tbClientes As ICollection(Of tbClientes) = New HashSet(Of tbClientes)
    Public Overridable Property tbFornecedores As ICollection(Of tbFornecedores) = New HashSet(Of tbFornecedores)
    Public Overridable Property tbMedicosTecnicos As ICollection(Of tbMedicosTecnicos) = New HashSet(Of tbMedicosTecnicos)

End Class