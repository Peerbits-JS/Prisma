Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class SegmentosMercado
    Inherits F3M.SegmentosMercado

    <DataMember>
    Public Overridable Property SegmentosMercadoIdiomas As List(Of SegmentosMercadoIdiomas)
End Class
