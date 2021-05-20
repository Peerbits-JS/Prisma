Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class FormasExpedicao
    Inherits F3M.FormasExpedicao

    <DataMember>
    Public Overridable Property FormasExpedicaoIdiomas As List(Of FormasExpedicaoIdiomas)
End Class
