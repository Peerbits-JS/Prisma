@Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresCatalogoLentesMatrizPrecos")
@Styles.Render("~/Content/handsontablestyle")
@Scripts.Render("~/bundles/handsontable")

@ModelType CatalogosLentesMatrizPrecos

@Code
    Html.F3M().Hidden("IDModelo", Model.IDModelo)
    Html.F3M().Hidden("IDTratamento", Model.IDTratamento)
    Html.F3M().Hidden("VerPrecoCusto", Model.VerPrecoCusto)
End Code

<div class="container-fluid">
    <div class="mb-2">
        <p class="fs14 mb-0">
            <b>Modelo:</b> @Model.DescricaoModelo
        </p>
        <p id="DescricaoTratamento" class="fs14 mb-0 hidden">
            <b>Tratamento:</b> @Model.DescricaoTratamento
        </p>

        <div class="row mb-4 mt-2">
            <div class="col-1">
                <label>Diâmetro de:</label>
                <input id="txtDiametroDe" name="txtDiametroDe" type="number" min="0" max="100" step="0.5" required="required" class="clsF3MInput k-select form-control input-sm required k-input alinhamentocentro obrigatorio" data-role="numerictextbox" />
            </div>
            <div class="col-1">
                <label>Diâmetro até:</label>
                <input id="txtDiametroAte" name="txtDiametroAte" type="number" min="0" max="100" step="0.5" required="required" class="clsF3MInput k-select form-control input-sm required k-input alinhamentocentro obrigatorio" data-role="numerictextbox" />
            </div>
            <div id="AreaRaioCurvatura" class="col-1 hidden">
                <label>Raio:</label>
                <input id="txtRaioCurvatura" name="txtRaioCurvatura" type="number" min="0" max="100" step="0.1" required="required" class="clsF3MInput k-select form-control input-sm required k-input alinhamentocentro obrigatorio" data-role="numerictextbox" />
            </div>
        </div>
    </div>
    <span id="MsgParamsMatrizLentesOftalmicas" class="clsF3MTextoSemLinhas texto-sem-linhas hidden">
        Comece por indicar o valor do diâmetro.
    </span>
    <span id="MsgParamsMatrizLentesContacto" class="clsF3MTextoSemLinhas texto-sem-linhas hidden">
        Comece por indicar o valor do diâmetro e o raio de curvatura.
    </span>
    <div class="handson-container">
        <div id="grelhaMatrizPrecos"></div>
    </div>
</div>