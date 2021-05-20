Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class CondicoesPagamento
    Inherits F3M.CondicoesPagamento

    <DataMember>
    Public Overridable Property CondicoesPagamentoDescontos As List(Of CondicoesPagamentoDescontos)

    <DataMember>
    Public Overridable Property CondicoesPagamentoIdiomas As List(Of CondicoesPagamentoIdiomas)
End Class
