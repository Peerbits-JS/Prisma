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

Partial Public Class tbTiposContatos
    Public Property ID As Long
    Public Property Codigo As String
    Public Property Descricao As String
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbBancosContatos As ICollection(Of tbBancosContatos) = New HashSet(Of tbBancosContatos)
    Public Overridable Property tbClientesContatos As ICollection(Of tbClientesContatos) = New HashSet(Of tbClientesContatos)
    Public Overridable Property tbContasBancariasContatos As ICollection(Of tbContasBancariasContatos) = New HashSet(Of tbContasBancariasContatos)
    Public Overridable Property tbEntidadesContatos As ICollection(Of tbEntidadesContatos) = New HashSet(Of tbEntidadesContatos)
    Public Overridable Property tbFornecedoresContatos As ICollection(Of tbFornecedoresContatos) = New HashSet(Of tbFornecedoresContatos)
    Public Overridable Property tbMedicosTecnicosContatos As ICollection(Of tbMedicosTecnicosContatos) = New HashSet(Of tbMedicosTecnicosContatos)

End Class
