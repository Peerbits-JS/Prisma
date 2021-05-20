@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@imports Oticas.Areas.Communication.Models
@ModelType ComunCommonModels
@Code
    @Scripts.Render("~/bundles/f3m/jsCommunicationSms")
    Layout = ClsConstantes.RetornaSharedLayoutFunc(Me.Context)
End Code

<div class="win-notifica">
    <div class="row desContainer com-border-shadow">
        <div class="col-3 col-f3m">
            @code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDmsgsystem",
                    .Label = "Sistema de envio",
                    .TipoEditor = Mvc.Componentes.F3MDropDownList,
                    .Controlador = URLs.Areas.TabAux & "ComunicacaoSms",
                    .Modelo = Model,
                    .AtributosHtml = New With {.class = CssClasses.TextBoxTitulo},
                    .EEditavel = True,
                    .EObrigatorio = True,
                    .DesenhaBotaoLimpar = False})
            End code
        </div>
        <div class="col-6 col-f3m">
            @code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Destination",
        .Label = "Destinatário",
        .TipoEditor = Mvc.Componentes.F3MTexto,
        .Modelo = Model,
        .AtributosHtml = New With {.class = CssClasses.TextBoxTitulo},
        .EEditavel = False,
        .EObrigatorio = True})
            End code
        </div>

        <div class="col-3 col-f3m">
            @code
                @if Not String.IsNullOrEmpty(Model.Documento) Then
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Documento",
                        .Label = "Documento",
                        .TipoEditor = Mvc.Componentes.F3MTexto,
                        .Modelo = Model,
                        .EEditavel = False,
                        .AtributosHtml = New With {.class = CssClasses.TextBoxTitulo}})
                End If
            End code
        </div>
    </div>
    <div class="clsF3MBodySMS notifica-body-sms">
        <input type="hidden" id="hdIdChamada" value="@Model.IDChamada.ToString()" />
        <input type="hidden" id="hdToday" value="@DateTime.Now.ToString("dd/MM/yyyy HH:mm")" />
        <input type="hidden" id="hdUsers" value="@ClsF3MSessao.RetornaUtilizadorNome" />
        <input type="hidden" id="hdSmsFrom" value="@Model.MsgFrom" />
        <input type="hidden" id="hdDocId" value="@Model.IDDoc" />

        @Code
            @If Model.ComunList.Any() Then
                @For Each item As ComunCommonMsgList In Model.ComunList
                    @<div class="row">
                        <div class="col-12">
                            <div class="float-left">Status de envio</div>
                            <div class="float-right">
                                @If item.Status Then
                                    @<span>Enviado a</span>
                                Else
                                    @<span>Não enviado a</span>
                                End If

                                @item.DataCriacao.ToString("dd/MM/yyyy HH:mm") por @item.UtilizadorCriacao

                                @If String.IsNullOrEmpty(item.Documento) = False Then
                                    @<span>, referente a <a SmsFrom="@item.MsgFrom" DocId="@item.DocumentId" onclick="$communication.ajax.DocClick($(this))">@item.Documento </a></span>
                                End If

                                @If item.Status = True Then
                                    @<span class="badge badge-success">
                                        <span class="fm f3icon-check"></span>
                                    </span>
                                Else
                                    @<span class="badge badge-danger" data-placement="left" data-toggle="tooltip" data-original-title="@item.ErrorDesc" title="@item.ErrorDesc">
                                        <span class="fm f3icon-close"></span>
                                    </span>
                                End If
                            </div>
                        </div>
                    </div>
                    @<div class="row mt-1 mb-3">
                        <div class="col-12 ">
                            <div class="card bg-light">
                                <div class="card-body">
                                    @item.TxtMsg
                                </div>
                            </div>
                        </div>
                    </div>
                Next

            Else
                @<span id="empty-hitoric" class="texto-sem-linhas">
                    Não existe histórico de mensagens.
                </span>
            End If
        End Code
    </div>
    <div class="fixed-bottom">
        <div class="row">
            <div class="col-12">
                <div class="input-group import-txt-fixed mb-1">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "TexoMsgArea",
                            .TipoEditor = Mvc.Componentes.F3MTextArea,
                            .Modelo = Model,
                            .EEditavel = True,
                            .ControladorAccaoExtra = URLs.Areas.TabAux & F3M.Modelos.Constantes.Menus.TextosBase & "/IndexGrelha",
                            .CampoValor = "Texto",
                            .IgnoraBloqueioAssinatura = True,
                            .EstadoBotoes = New ClsF3MEstadoBotoes With {.PermBtnAdd = 2},
                            .ViewClassesCSS = {"textarea-formsolo col-11 p-0"}})
                    End Code
                    <div class="input-group-append col-1 p-0">
                        <button class="btn main-btn btn-sms" type="button" disabled="disabled" id="btnMsgSend">Enviar</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="row m-0">
            <div class="float-left">
                <span id="spnRemainChar"> 0</span> de 160 caracters disponíveis
                <span class="ml-50">Nº de SMS <span id="spnMsgCount">0</span></span>
            </div>
            <div class="float-right">
                <span id="spRemainSms">@Model.AvailableCredits</span> SMS disponíveis
            </div>
        </div>
    </div>
</div>