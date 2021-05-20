Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class ContasBancarias
    Inherits F3M.ContasBancarias

    <DataMember>
    Public Overridable Property ContasBancariasContatos As List(Of ContasBancariasContatos)

    <DataMember>
    Public Overridable Property ContasBancariasMoradas As List(Of ContasBancariasMoradas)
End Class
