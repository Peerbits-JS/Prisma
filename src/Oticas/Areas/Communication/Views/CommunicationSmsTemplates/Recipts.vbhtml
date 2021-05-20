@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports Oticas.Areas.Communication.Models
@ModelType Recipts

@Scripts.Render("~/bundles/f3m/jsCommunicationRecipts")

    <div id="template-recipts">
        <div>
            <span id="number-recipts">0</span>&nbsp;<span>destinatário(s) selecionado(s).</span>
            <div id="grid"></div>
        </div>
        <div class="d-flex flex-row mt-3">
            <div class="input-group import-txt-fixed">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "TexoMsgArea",
                                                        .TipoEditor = Mvc.Componentes.F3MTextArea,
                                                        .Modelo = Model,
                                                        .EEditavel = True,
                                                        .ControladorAccaoExtra = URLs.Areas.TabAux & F3M.Modelos.Constantes.Menus.TextosBase & "/IndexGrelha",
                                                        .CampoValor = "Texto",
                                                        .IgnoraBloqueioAssinatura = True,
                                                        .EstadoBotoes = New ClsF3MEstadoBotoes With {.PermBtnAdd = 2},
                                                        .ViewClassesCSS = {"textarea-formsolo textarea-w100 flex-grow-1 mr-2"}})
                End Code
                <div class="input-group-append">
                    <button id="btnMsgSend" class="btn main-btn btn-sms" type="button" disabled="disabled">Enviar</button>
                </div>
            </div>
        </div>
        <div class="d-flex justify-content-between">
            <div class="">
                <span id="spnRemainChar"> 0</span> de 160 caracters disponíveis
                <span class="ml-50">Nº de SMS <span id="spnMsgCount">0</span></span>
            </div>
            <div class="">
                <span id="spRemainSms">@Model.AvailableCredits</span> SMS disponíveis
            </div>
        </div>
    </div>

@*PROGRESS BAR*@
@Html.Partial("~/F3M/Areas/Componentes/Views/F3MBarraProgresso/View.vbhtml", "Estamos a trabalhar para si...")