Imports System.Runtime.Serialization

Public Class HistoricoExames
    <DataMember>
    Public Property IDCliente As Long

    <DataMember>
    Public Property IDExameSelecionado As Nullable(Of Long)

    <DataMember>
    Public Property CodigoTemplate As String = String.Empty

    <DataMember>
    Public Property ListOfExamesDatas As New List(Of HistoricoExamesDatas)

    <DataMember>
    Public Property ExamesAccordions As New HistoricoExamesAccordions
End Class