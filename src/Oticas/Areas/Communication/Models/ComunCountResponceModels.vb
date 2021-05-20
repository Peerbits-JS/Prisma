Namespace Areas.Communication.Models
    Public Class ComunCountResponceModels
        Public Property Result As String
        Public Property AvailableCreditsInfo As List(Of AvailCradits)
    End Class

    Public Class AvailCradits
        Public Property Acquired As String
        Public Property Consumed As String
        Public Property ConsumedLandLine As String
        Public Property AvailableCreditsWithoutScheduled As String
        Public Property Scheduled As String
        Public Property AvailableCredits As String
    End Class
End Namespace