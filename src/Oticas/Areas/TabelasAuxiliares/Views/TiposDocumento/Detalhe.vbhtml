@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@ModelType Oticas.TiposDocumento

@Code
    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario
    Dim strTiposDocComum As String = "~/F3M/Areas/TabelasAuxiliaresComum/Views/TiposDocumento/"
    ViewBag.VistaParcial = True
End Code

<div class="@(ClassesCSS.FormPrinc)">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            @Html.Partial(strTiposDocComum & "Cabecalho.vbhtml", Model)
            <div role="tabpanel" class="f3m-tabs clsF3MTabs">
                <ul class="nav nav-pills f3m-tabs__ul" role="tablist">
                    @Html.Partial(strTiposDocComum & "Tabs.vbhtml")
                </ul>
                <div class="tab-content">
                    @Html.Partial(strTiposDocComum & "Definicao.vbhtml", Model)

                    @Html.Partial(strTiposDocComum & "Series.vbhtml", Model)

                    @Html.Partial(strTiposDocComum & "Stocks.vbhtml", Model)

                    @Html.Partial("~/Areas/TabelasAuxiliares/Views/TiposDocumento/IndexGrelhaIdiomas.vbhtml", Model)

                    @Html.Partial(strTiposDocComum & "Observacoes.vbhtml", Model)
                </div>
            </div>
        </div>
    </div>
</div>

<script>

    TiposDocumentosRetornaSeriesEditadas(@Html.Raw(Json.Encode(Model.Series)));

</script>