Namespace Areas.Communication.Models

    Public Class ComunResponceModels
        Public Property Result As String
        Public Property LastSMSID As String
        Public Property NrOfInsertedMessages As String

        Public Property ErrorCode As String

        Public Property ErrorDesc As String

        Public Property SMSIDs As List(Of SmsList)



    End Class

    Public Class SmsList
        Public Property SMSID As String
        Public Property SMSReceiverNumber As String
    End Class

End Namespace