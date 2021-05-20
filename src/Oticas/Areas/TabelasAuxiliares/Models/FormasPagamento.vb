Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class FormasPagamento
    Inherits F3M.FormasPagamento

    <DataMember>
    Public Overridable Property FormasPagamentoIdiomas As List(Of FormasPagamentoIdiomas)
End Class
