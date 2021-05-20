Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class Familias
    Inherits F3M.Familias

    <DataMember>
    Public Overridable Property tbArtigos As ICollection(Of tbArtigos) = New HashSet(Of tbArtigos)
    <DataMember>
    Public Overridable Property tbSubFamilias As ICollection(Of tbSubFamilias) = New HashSet(Of tbSubFamilias)
End Class
