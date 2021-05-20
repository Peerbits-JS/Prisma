Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports Oticas.Areas.Communication.Models
Imports Oticas.Repositorio.Communication

Namespace Areas.Communication
    Public Class CommunicationSmsController
        Inherits SimpleFormController

        Const CommunictionPath As String = "~/F3M/Areas/Communication/Views/"
        ReadOnly _repositorioComun As RepositorioComunicacao

#Region "CONSTRUCTOR"
        Sub New()
            _repositorioComun = New RepositorioComunicacao()
        End Sub
#End Region

#Region "ACTION RESULT"
        <F3MAcesso>
        Public Function Index(entityId As Long?, entityToSendSmsId As Long, entityType As String) As ActionResult
            Return View(New ComunModels With {
                .IDmsgsystem = _repositorioComun.GetMsgSystemDefault(),
                .Destination = _repositorioComun.GetCustomerName(entityToSendSmsId),
                .ComunList = _repositorioComun.GetComunDetails(entityToSendSmsId),
                .IDChamada = entityToSendSmsId,
                .Documento = _repositorioComun.GetDocNo(entityId),
                .IDDoc = entityId,
                .MsgFrom = entityType,
                .AvailableCredits = _repositorioComun.GetSmsBalance(.IDmsgsystem)})
        End Function

        <F3MAcesso>
        Public Function AddMobilePhoneNumber(entityToSendSmsId As Long) As ActionResult
            Return View(New AddMobilePhoneNumber With {.IDChamada = entityToSendSmsId})
        End Function
#End Region

#Region "JSON RESULT"
        <F3MAcesso>
        Public Function UpdateMobilePhoneNumber(IDClientID As String, CDMovel As String)
            Return RetornaJSONTamMaximo(_repositorioComun.AddClientMovel(IDClientID, CDMovel))
        End Function

        <F3MAcesso>
        Public Function SendMsg(jsondata As ComunMsgModels) As JsonResult
            Return RetornaJSONTamMaximo(_repositorioComun.AddComunnicationTrans(jsondata))
        End Function
#End Region
    End Class
End Namespace