@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports Oticas.Areas.Communication.Models
@ModelType CommunicationSmsTemplates

@Scripts.Render("~/bundles/f3m/jsCommunicationTemplate")

@Code
    Dim disabledBtnDestinations As String = If(Model.ID = 0, "disabled f3m-btn-outline", "main-btn")
End Code

<div class="container-fluid" id="template" data-bd-id="@Model.ID">
    <div id="containerCabecalho" class="row desContainer">
        @Html.Partial("Cabecalho", Model)
    </div>

    <div class="row">
        <div class="col-12">
            <div class="f3m-group-btn-sms mb-3 mt-3">
                <button id="btnfilter" class="btn main-btn">Escolher Filtros</button>
                <div class="f3m-group-btn-sms__join"></div>
                <button id="btnDestinations" class="btn @disabledBtnDestinations">Destinatarios + mensagem</button>
            </div>
        </div>
    </div>

    @Html.Partial("Grupo", Model.Grupo)

    @If Model.ID <> 0 Then
        @Html.Partial("Recipts", Model.Recipts)
    End If
</div>