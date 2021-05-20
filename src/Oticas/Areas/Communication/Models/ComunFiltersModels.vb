Imports System.Runtime.Serialization

Namespace Areas.Communication.Models
    Public Class ComnFiltersModels
        Public Property ComunOFilters As List(Of ComunFilters)
        Public Property ComunOConditions As List(Of ComunConditions)

        Public Property ComunOFilterVData As List(Of ComunConditions)


    End Class

    Public Class ComunFilters
        Public Property ID As Long
        Public Property Descricao As String
        Public Property ControlType As String

    End Class

    Public Class ComunConditions
        Public Property ID As Long
        Public Property IDFilters As Long
        Public Property Descricao As String

    End Class
End Namespace

