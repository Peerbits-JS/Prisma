Imports System.Runtime.Serialization

Public Class HistoricoExamesGrids
    <DataMember>
    Public Property GridCode As String

    <DataMember>
    Public Property Title As String

    <DataMember>
    Public Property HeadersCode As String

    <DataMember>
    Public Property RowsCode As String

    <DataMember>
    Public Property ModelAccordion As New List(Of HistoricoExamesAccordionsInfo)

    <DataMember>
    Public Property PrimeiraColunaHeaderVazia As Boolean = True

    <DataMember>
    Public Property EmptyLastColsExtra As Integer = 0

    <DataMember>
    Public Property ViewClassesCSS As String
End Class

Public Class TD
    <DataMember>
    Public Property Text As String

    <DataMember>
    Public Property ViewClassesCSS As String
End Class