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

Partial Public Class tbSistemaTiposEntidade
    Public Property ID As Long
    Public Property Codigo As String
    Public Property Entidade As String
    Public Property Tipo As String
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property PorDefeito As Nullable(Of Boolean)
    Public Property TipoAux As String
    Public Property Descricao As String

    Public Overridable Property tbCCStockArtigos As ICollection(Of tbCCStockArtigos) = New HashSet(Of tbCCStockArtigos)
    Public Overridable Property tbClientes As ICollection(Of tbClientes) = New HashSet(Of tbClientes)
    Public Overridable Property tbCondicoesPagamentoDescontos As ICollection(Of tbCondicoesPagamentoDescontos) = New HashSet(Of tbCondicoesPagamentoDescontos)
    Public Overridable Property tbDocumentosCompras As ICollection(Of tbDocumentosCompras) = New HashSet(Of tbDocumentosCompras)
    Public Overridable Property tbDocumentosStock As ICollection(Of tbDocumentosStock) = New HashSet(Of tbDocumentosStock)
    Public Overridable Property tbDocumentosVendas As ICollection(Of tbDocumentosVendas) = New HashSet(Of tbDocumentosVendas)
    Public Overridable Property tbFornecedores As ICollection(Of tbFornecedores) = New HashSet(Of tbFornecedores)
    Public Overridable Property tbMedicosTecnicos As ICollection(Of tbMedicosTecnicos) = New HashSet(Of tbMedicosTecnicos)
    Public Overridable Property tbPagamentosCompras As ICollection(Of tbPagamentosCompras) = New HashSet(Of tbPagamentosCompras)
    Public Overridable Property tbRecibos As ICollection(Of tbRecibos) = New HashSet(Of tbRecibos)
    Public Overridable Property tbControloDocumentos As ICollection(Of tbControloDocumentos) = New HashSet(Of tbControloDocumentos)
    Public Overridable Property tbSistemaTiposEntidadeModulos As ICollection(Of tbSistemaTiposEntidadeModulos) = New HashSet(Of tbSistemaTiposEntidadeModulos)

End Class
