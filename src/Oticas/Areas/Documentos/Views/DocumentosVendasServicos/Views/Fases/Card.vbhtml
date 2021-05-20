@Modeltype Oticas.DocumentosVendasServicos

@Scripts.Render("~/bundles/f3m/jsFormularioDocumentosServicosFases")

@Code
@<div id="fasesHistorico" class="col-6 col-lg-6 col-lg-7 f3m-card card4item">
    @*TITULO*@
    <div class="card-title f3m-card__title">
        <span class="fm f3icon-list-ol"></span>
        <h6>@Traducao.EstruturaMenus.Estados</h6>
    </div>
    @*CONTAINER*@
    <div class="clearfix card-body f3m-card__body">
        <div class="row">
            <div class="col-12 text-left card-body-holder card-table">
                @*TABS*@
                <div role="tabpanel" class="f3m-tabs clsF3MTabsEstados">
                    @Html.Partial("Views/Fases/Tabs", Model)
                    @*TAB CONTENT*@
                    <div class="tab-content">
                        @Html.Partial("Views/Fases/TabsContent", Model)
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
End Code