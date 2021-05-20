Imports System.Runtime.Serialization

Public Class HistoricoExamesAccordionsInfo
    <DataMember>
    Public Property IDElemento As String

    <DataMember>
    Public Property Label As String

    <DataMember>
    Public Property ModelPropertyName As String

    <DataMember>
    Public Property ModelPropertyType As String

    <DataMember>
    Public Property ValorID As String = String.Empty

    <DataMember>
    Public Property ValorDescricao As String = String.Empty

    <DataMember>
    Public Property Ordem As Nullable(Of Integer)

    <DataMember>
    Public Property ViewClassesCSS As String
End Class