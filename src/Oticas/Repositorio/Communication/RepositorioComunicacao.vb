Imports F3M.Modelos.Repositorio
Imports System.Net
Imports System.IO
Imports F3M.Modelos.Autenticacao
Imports Newtonsoft.Json
Imports Oticas.Areas.Communication.Models

Namespace Repositorio.Communication
    Public Class RepositorioComunicacao
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbComunicacao, ComunicacaoSms)

        Sub New()
            MyBase.New()
        End Sub

        Public Function GetMsgSystemDefault() As Long?
            Return BDContexto.
                tbComunicacao.
                AsNoTracking().
                OrderBy(Function(entity) entity.Descricao).
                FirstOrDefault(Function(entity) entity.Ativo)?.ID
        End Function

        Public Function GetCustomerName(id As Long) As String
            Return BDContexto.tbClientes.AsNoTracking().FirstOrDefault(Function(entity) entity.ID = id)?.Nome
        End Function

        Public Function GetComunDetails(ClientId As String)
            Dim msgList As List(Of ComunCommonMsgList) = BDContexto.
                tbComunicacaoregistro.
                AsNoTracking().
                Where(Function(entity) entity.IDChamada = ClientId).
                Select(Function(entity) New ComunCommonMsgList With {
                .TxtMsg = entity.TextoMensagem,
                .Status = entity.tbMensagemregistro.Status,
                .DataCriacao = entity.DataCriacao,
                .Responce = entity.tbMensagemregistro.Response,
                .Documento = entity.Documento,
                .DocumentId = entity.DocumentID,
                .UtilizadorCriacao = entity.UtilizadorCriacao,
                .MsgFrom = entity.TipoChamada}).
                ToList()

            msgList.All(Function(p)
                            p.ErrorDesc = GetErrordesc(p.Responce)
                            Return True
                        End Function)

            Return msgList
        End Function

        Public Function GetErrordesc(response As String) As String
            If Not String.IsNullOrEmpty(response) Then
                Dim ErrorString = JsonConvert.DeserializeObject(Of ComunResponceModels)(response).ErrorDesc
                Return If(String.IsNullOrEmpty(ErrorString), String.Empty, ErrorString)
            End If

            Return String.Empty
        End Function

        Public Function AddComunnicationTrans(ComunModel As ComunMsgCommonModels)
            Dim mobilePhoneNumber As String = BDContexto.tbClientesContatos.AsNoTracking().FirstOrDefault(Function(entity) entity.IDCliente = ComunModel.IDChamada).Telemovel

            Dim ComunicacaoText As ComunicacaoModels = (From tComun In BDContexto.tbComunicacao.AsNoTracking()
                                                        Join tSysComun In BDContexto.tbSistemaComunicacao.AsNoTracking() On tComun.IDSistemaComunicacao Equals tSysComun.ID
                                                        Join tComunApi In BDContexto.tbComunicacaoApis.AsNoTracking() On tComun.IDSistemaComunicacao Equals tComunApi.IDSistemaComunicacao
                                                        Where tComun.ID = ComunModel.IDComunicacao AndAlso tComunApi.TipoApi = "SendSMS"
                                                        Select New ComunicacaoModels With {
                                                            .Descricao = tComun.Descricao,
                                                            .Remetente = tComun.Remetente,
                                                            .Utilizador = tComun.Utilizador,
                                                            .Chave = tComun.Chave,
                                                            .APIURL = tSysComun.APIURL + tComunApi.API
                                                            }).FirstOrDefault()

            Dim SmsReqText = getSmsRequest(mobilePhoneNumber, ComunModel.TextoMensagem, ComunicacaoText)

            Dim Responsejson = CallAPI(SmsReqText)

            Dim SmsResponse As ComunResponceModels = JsonConvert.DeserializeObject(Of ComunResponceModels)(Responsejson)

            Dim newMgm = New tbMensagemregistro With {
                .IDComunicacao = ComunModel.IDComunicacao,
                .DataCriacao = DateTime.Now,
                .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome,
                .Request = SmsReqText,
                .Response = Responsejson}

            Dim ReturnJson As Object

            If (SmsResponse.Result = "OK") Then
                newMgm.Status = 1
                ReturnJson = New With {
                    Key .Status = 1,
                    Key .Msg = "SMS enviado com sucesso",
                    Key .SmsCount = SmsResponse.NrOfInsertedMessages,
                    Key .Date = DateTime.Now.ToString("dd/MM/yyyy HH:mm")
                }

            Else
                newMgm.Status = 0
                ReturnJson = New With {
                    Key .Status = 0,
                    Key .Msg = SmsResponse.ErrorDesc,
                    Key .Date = DateTime.Now.ToString("dd/MM/yyyy HH:mm")
                    }
            End If


            BDContexto.tbMensagemregistro.Add(newMgm)
            BDContexto.SaveChanges()

            Dim newCom = New tbComunicacaoregistro With {
                      .IDChamada = ComunModel.IDChamada,
                      .TextoMensagem = ComunModel.TextoMensagem,
                      .TipoChamada = ComunModel.TipoChamada,
                      .Telemovel = mobilePhoneNumber,
                      .Documento = ComunModel.Documento,
                      .DocumentID = ComunModel.DocumentID,
                      .DataCriacao = DateTime.Now,
                      .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome,
                      .IDMensagemregistro = newMgm.ID
                }

            BDContexto.tbComunicacaoregistro.Add(newCom)
            BDContexto.SaveChanges()

            Return ReturnJson
        End Function

        Public Function AddClientMovel(IDChamada As String, telMovel As String)
            Dim ReturnJson As Object
            Dim tbContact = BDContexto.tbClientesContatos.FirstOrDefault(Function(f) f.IDCliente = IDChamada)

            Try
                If tbContact Is Nothing Then
                    tbContact = New tbClientesContatos With {
                        .IDCliente = IDChamada,
                        .Telemovel = telMovel,
                        .DataCriacao = DateTime.Now,
                        .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome,
                        .Ordem = 1,
                        .Ativo = True,
                        .Mailing = True}
                    BDContexto.tbClientesContatos.Add(tbContact)
                Else
                    tbContact.Telemovel = telMovel
                End If

                BDContexto.SaveChanges()

                ReturnJson = New With {
                  Key .Status = 1,
                  Key .Msg = "Telemóvel adicionado com sucesso"
              }

            Catch ex As Exception

                ReturnJson = New With {
                  Key .Status = 0,
                  Key .Msg = ex.InnerException.ToString()
              }

            End Try

            Return ReturnJson

        End Function

        Public Function getSmsRequest(telMovel As String, txtMsg As String, txtComunName As ComunicacaoModels)
            Dim msgBody As StringBuilder = New StringBuilder()
            msgBody.Append(txtComunName.APIURL)
            msgBody.Append(String.Format("account={0}&licensekey={1}", txtComunName.Utilizador, txtComunName.Chave))
            msgBody.Append(String.Format("&phoneNumber={2}&messageText={0}&startDate={1}", txtMsg, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), telMovel))
            msgBody.Append(String.Format("&CC=35&alfaSender={0}&TTL=24&envio24=1", txtComunName.Remetente))

            Return msgBody.ToString()
        End Function

        Public Function CallAPI(msgRequest As String)

            Dim request As WebRequest = WebRequest.Create(msgRequest)

            Dim response As WebResponse = request.GetResponse()

            Dim dataStream As Stream = response.GetResponseStream()

            Dim reader As New StreamReader(dataStream)

            Dim responseFromServer As String = reader.ReadToEnd()


            reader.Close()
            response.Close()

            Return responseFromServer
        End Function

        Public Function GetSmsBalance(IDComunicacao As Long?)
            If Not IDComunicacao Is Nothing Then
                Dim ComunDetail As ComunicacaoModels = (From tComun In BDContexto.tbComunicacao.AsNoTracking()
                                                        Join tSysComun In BDContexto.tbSistemaComunicacao.AsNoTracking()
                                                            On tComun.IDSistemaComunicacao Equals tSysComun.ID
                                                        Join tComunApi In BDContexto.tbComunicacaoApis.AsNoTracking() On tComun.IDSistemaComunicacao Equals tComunApi.IDSistemaComunicacao
                                                        Where tComun.ID = IDComunicacao And tComunApi.TipoApi = "CreditsCheck"
                                                        Select New ComunicacaoModels With {
                                                            .APIURL = tSysComun.APIURL + tComunApi.API,
                                                            .Utilizador = tComun.Utilizador,
                                                            .Chave = tComun.Chave}).
                                                        FirstOrDefault()

                If Not ComunDetail Is Nothing Then
                    Dim Apiresponse = CallAPI(String.Format("{0}account={1}&licensekey={2}", ComunDetail.APIURL, ComunDetail.Utilizador, ComunDetail.Chave))

                    Dim SmsResponse As ComunCountResponceModels = JsonConvert.DeserializeObject(Of ComunCountResponceModels)(Apiresponse)
                    If SmsResponse.Result = "NOT OK" Then
                        Return 0
                    Else
                        Return SmsResponse.AvailableCreditsInfo.FirstOrDefault().AvailableCredits
                    End If
                End If
            End If
            Return 0
        End Function

        Public Function GetDocNo(id As Long?) As String
            If Not id Is Nothing Then
                Return BDContexto.tbDocumentosVendas.AsNoTracking().Where(Function(entity) entity.ID = id).Select(Function(entity) entity.Documento).FirstOrDefault()
            End If

            Return String.Empty
        End Function

        Public Function GetCommunicationHistory(filter As ComunFilterModels)
            With filter
                .DataDe = New Date(.DataDe.Year, .DataDe.Month, .DataDe.Day, 0, 0, 0)
                .Dataa = New Date(.Dataa.Year, .Dataa.Month, .Dataa.Day, 23, 59, 59)
            End With

            Return (From tComunReg In BDContexto.tbComunicacaoregistro.AsNoTracking()
                    Join tMenReg In BDContexto.tbMensagemregistro.AsNoTracking() On tComunReg.IDMensagemregistro Equals tMenReg.ID
                    Join tClient In BDContexto.tbClientes.AsNoTracking() On tComunReg.IDChamada Equals tClient.ID
                    Where tComunReg.DataCriacao <= filter.Dataa AndAlso tComunReg.DataCriacao >= filter.DataDe AndAlso
                        If(String.IsNullOrEmpty(filter.Status), True, tMenReg.Status = filter.Status) AndAlso
                        If(filter.IDTemplate Is Nothing, True, tComunReg.IDComunicacaoSmsTemplates = filter.IDTemplate)
                    Select New ComunHisGrid With {
                        .DataEnvio = tComunReg.DataCriacao,
                        .Mensagem = tComunReg.TextoMensagem,
                        .Status = tMenReg.Status,
                        .Destinatarios = tClient.Nome,
                        .Template = If(tComunReg.tbComunicacaoSmsTemplates Is Nothing, String.Empty, tComunReg.tbComunicacaoSmsTemplates.Nome)}).
                        OrderBy(Function(entity) entity.DataEnvio).
                        ToList()
        End Function
    End Class
End Namespace