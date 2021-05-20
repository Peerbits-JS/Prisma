Imports System.Runtime.Serialization

Public Class HistoricoExamesAccordions
    <DataMember>
    Public Property IDTemplate As Long

    <DataMember>
    Public Property CodigoTemplate As String

    <DataMember>
    Public Property ViewName As String

    <DataMember>
    Public Property ListOfExamesAccordionsInfo As New List(Of HistoricoExamesAccordionsInfo)
End Class