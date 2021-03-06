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

Partial Public Class tbEntidades
    Public Property ID As Long
    Public Property IDLoja As Nullable(Of Long)
    Public Property Codigo As String
    Public Property Descricao As String
    Public Property Abreviatura As String
    Public Property Foto As String
    Public Property FotoCaminho As String
    Public Property NContribuinte As String
    Public Property Contabilidade As String
    Public Property IDTipoEntidade As Long
    Public Property IDTipoDescricao As Long
    Public Property Observacoes As String
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property IDClienteEntidade As Nullable(Of Long)

    Public Overridable Property tbClientes As ICollection(Of tbClientes) = New HashSet(Of tbClientes)
    Public Overridable Property tbClientes1 As ICollection(Of tbClientes) = New HashSet(Of tbClientes)
    Public Overridable Property tbClientes2 As tbClientes
    Public Overridable Property tbDocumentosVendas As ICollection(Of tbDocumentosVendas) = New HashSet(Of tbDocumentosVendas)
    Public Overridable Property tbDocumentosVendas1 As ICollection(Of tbDocumentosVendas) = New HashSet(Of tbDocumentosVendas)
    Public Overridable Property tbLojas As tbLojas
    Public Overridable Property tbSistemaEntidadeComparticipacao As tbSistemaEntidadeComparticipacao
    Public Overridable Property tbSistemaEntidadeDescricao As tbSistemaEntidadeDescricao
    Public Overridable Property tbEntidadesAnexos As ICollection(Of tbEntidadesAnexos) = New HashSet(Of tbEntidadesAnexos)
    Public Overridable Property tbEntidadesComparticipacoes As ICollection(Of tbEntidadesComparticipacoes) = New HashSet(Of tbEntidadesComparticipacoes)
    Public Overridable Property tbEntidadesContatos As ICollection(Of tbEntidadesContatos) = New HashSet(Of tbEntidadesContatos)
    Public Overridable Property tbEntidadesLojas As ICollection(Of tbEntidadesLojas) = New HashSet(Of tbEntidadesLojas)
    Public Overridable Property tbEntidadesMoradas As ICollection(Of tbEntidadesMoradas) = New HashSet(Of tbEntidadesMoradas)

End Class
