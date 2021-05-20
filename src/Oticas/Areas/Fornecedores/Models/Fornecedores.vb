Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class Fornecedores
    Inherits F3M.Fornecedores

    <DataMember>
    Public Property Saldo As Nullable(Of Double)


    <DataMember>
    Public Overridable Property FornecedoresMoradas As List(Of FornecedoresMoradas)

    <DataMember>
    Public Overridable Property FornecedoresContatos As List(Of FornecedoresContatos)

    <DataMember>
    Public Overridable Property FornecedoresTiposFornecimentos As List(Of FornecedoresTiposFornecimentos)
End Class
