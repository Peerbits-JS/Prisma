@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@imports Oticas.Areas.Communication.Models
@ModelType AddMobilePhoneNumber

@Code
    Html.F3M().Hidden("hdClientId", Model.IDChamada)
End Code

@Scripts.Render("~/bundles/f3m/jsCommunicationSmsAddMobilePhoneNumber")

<div id="F3MAddMobilePhoneNumber" class="FormSelectTipoDocDuplicar">
    @*TITULO DO FORMULARIO*@
    <div class="submenu clearfix">
        <div class="float-left direito">
            <div id="tituloModulo" class="titulo-form">
                Este cliente não tem número de telemóvel associado, quer adicionar?
            </div>
        </div>
    </div>
    @*MOBILE PHONE NUMBER*@
    <div class="form-container">
        @code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "MobilePhoneNumber",
                .Label = Traducao.EstruturaAplicacaoTermosBase.Telemovel,
                .TipoEditor = Mvc.Componentes.F3MTexto,
                .Modelo = Model,
                .AtributosHtml = New With {.class = CssClasses.TextBoxTitulo}})
        End code
    </div>

    @*FOOTER*@
    <hr class="separador-janelas-xsmall">
    @*<button type="button" class="btn main-btn float-right" id="btnMovelCancel">Cancelar</button>*@
    <button type="button" class="btn main-btn float-right" id="btnMovelSave">Gravar</button>
</div>