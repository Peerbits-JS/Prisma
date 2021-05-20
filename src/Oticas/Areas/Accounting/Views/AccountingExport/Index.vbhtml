@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Oticas.DTO
@Imports F3M.Oticas.Translate
@Imports F3M.Modelos.Grelhas
@Imports F3M.Oticas.Translate
@Modeltype AccountingExportDto

@Styles.Render("~/Content/handsontablestyle")
@Scripts.Render("~/bundles/handsontable")
@Scripts.Render("~/bundles/f3m/jsAccountingExport")

@Code
    Layout = ClsConstantes.RetornaSharedLayoutFunc(Me.Context)
End Code

<div class="f3m-top submenu clearfix">
    <div class="float-left f3m-top__left">
        @Html.Partial("~/F3M/Views/Partials/F3MMenuFavoritoHomepageTitulo.vbhtml")
    </div>
</div>

<div class="area-vazia ClsF3MAreaVazia">
    <!--Nav tabs-->
    <div class="f3m-lateral-botoes f3m-aside__closed f3m-aside__closed--esq menu-peq-area-vazia menu-peq-botoes">
        <ul>
            <li role="presentation" class="active">
                <a href="#TabConditions" class="btn main-btn btn-sm active" title="@AccountingExportResources.Conditions" data-toggle="tab" role="tab" aria-expanded="false">
                    <span class="fm f3icon-filtro"></span>
                </a>
            </li>
            <li role="presentation">
                <a href="#TabData" class="btn main-btn btn-sm ClsF3MDados" title="@AccountingExportResources.Data" data-toggle="tab" role="tab" aria-expanded="true">
                    <span class="fm f3icon-table"></span>
                </a>
            </li>
        </ul>
    </div>

    <div id="contabilidadeExportacao" class="area-consultas">
        <div class="container-fluid">
            <div role="tabpanel" class="f3m-tabs clsF3MTabs">
                <div class="tab-content">
                    <div role="tabpanel" class="tab-pane fade show active" id="TabConditions">
                        <div id="containerCabecalho" class="row desContainer">
                            <div Class="@ClassesCSS.XS2">
                                @Code
                                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "InitDate",
                                        .Label = AccountingExportResources.InitDate,
                                        .TipoEditor = Mvc.Componentes.F3MData,
                                        .Modelo = Model.Filter,
                                        .FuncaoJSChange = "accountingexportchangenitdate",
                                        .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo"}})
                                End Code
                            </div>
                            <div class="@ClassesCSS.XS2">
                                @Code
                                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "EndDate",
                                        .Label = AccountingExportResources.EndDate,
                                        .TipoEditor = Mvc.Componentes.F3MData,
                                        .Modelo = Model.Filter,
                                        .FuncaoJSChange = "accountingexportchangeenddate",
                                        .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo"}})
                                End Code
                            </div>
                            <div class="@ClassesCSS.XS2 com-botao">
                                <a id="btnApplyFilter" class="btn main-btn float-left ClsF3MDados" data-toggle="tab" role="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.AplicarFiltros</a>
                            </div>
                        </div>
                        <div>
                            @Html.Partial("~/Areas/Accounting/Views/AccountingExport/Condicoes.vbhtml", Model)
                        </div>
                    </div>
                    <div role="tabpanel" class="tab-pane fade" id="TabData">
                        <div>
                            @Html.Partial("~/Areas/Accounting/Views/AccountingExport/Dados.vbhtml", Model)
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>